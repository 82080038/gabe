<?php
/**
 * ================================================================
 * USER CONTROLLER - KOPERASI BERJALAN
 * Maintainable user management with proper validation and security
 * ================================================================ */

require_once __DIR__ . '/../index.php';

class UserController extends BaseController {
    
    /**
     * Get all users with pagination and filtering
     * GET /api/users
     */
    public function index() {
        $this->checkPermission(ROLE_ADMIN);
        
        $pagination = $this->getPagination();
        $search = sanitizeInput($_GET['search'] ?? '');
        $role = sanitizeInput($_GET['role'] ?? '');
        $branchId = intval($_GET['branch_id'] ?? 0);
        $status = sanitizeInput($_GET['status'] ?? '');
        
        try {
            // Build query
            $whereConditions = [];
            $params = [];
            
            if (!empty($search)) {
                $whereConditions[] = "(u.username LIKE ? OR p.name LIKE ? OR p.email LIKE ?)";
                $searchParam = "%{$search}%";
                $params[] = $searchParam;
                $params[] = $searchParam;
                $params[] = $searchParam;
            }
            
            if (!empty($role)) {
                $whereConditions[] = "u.role = ?";
                $params[] = $role;
            }
            
            if ($branchId > 0) {
                $whereConditions[] = "u.branch_id = ?";
                $params[] = $branchId;
            }
            
            if (!empty($status)) {
                $whereConditions[] = "u.status = ?";
                $params[] = $status;
            }
            
            $whereClause = !empty($whereConditions) ? 'WHERE ' . implode(' AND ', $whereConditions) : '';
            
            // Get total count
            $countQuery = "
                SELECT COUNT(*) as total
                FROM users u
                LEFT JOIN schema_person.persons p ON u.person_id = p.id
                LEFT JOIN branches b ON u.branch_id = b.id
                {$whereClause}
            ";
            
            $stmt = $this->db->prepare($countQuery);
            $stmt->execute($params);
            $total = $stmt->fetch()['total'];
            
            // Get users with pagination
            $query = "
                SELECT u.id, u.username, u.email, u.role, u.status, u.is_active,
                       u.last_login, u.last_activity, u.created_at, u.updated_at,
                       p.name as person_name, p.phone, p.email as person_email,
                       b.name as branch_name, ur.name as role_name
                FROM users u
                LEFT JOIN schema_person.persons p ON u.person_id = p.id
                LEFT JOIN branches b ON u.branch_id = b.id
                LEFT JOIN master_user_roles ur ON u.role = ur.code
                {$whereClause}
                ORDER BY u.created_at DESC
                LIMIT ? OFFSET ?
            ";
            
            $params[] = $pagination['limit'];
            $params[] = $pagination['offset'];
            
            $stmt = $this->db->prepare($query);
            $stmt->execute($params);
            $users = $stmt->fetchAll();
            
            // Format user data
            $formattedUsers = array_map(function($user) {
                return [
                    'id' => (int)$user['id'],
                    'username' => $user['username'],
                    'email' => $user['email'],
                    'role' => $user['role'],
                    'role_name' => $user['role_name'],
                    'status' => $user['status'],
                    'is_active' => (bool)$user['is_active'],
                    'person_name' => $user['person_name'],
                    'phone' => $user['phone'],
                    'person_email' => $user['person_email'],
                    'branch_id' => (int)$user['branch_id'],
                    'branch_name' => $user['branch_name'],
                    'last_login' => $user['last_login'],
                    'last_activity' => $user['last_activity'],
                    'created_at' => $user['created_at'],
                    'updated_at' => $user['updated_at']
                ];
            }, $users);
            
            $meta = $this->buildPaginationMeta($total, $pagination['page'], $pagination['limit']);
            
            $this->success($formattedUsers, 'Users retrieved successfully', $meta);
            
        } catch (PDOException $e) {
            Logger::error('Database error in users index', [
                'error' => $e->getMessage(),
                'query' => $query ?? 'unknown'
            ]);
            $this->error('Failed to retrieve users', 500);
        }
    }
    
    /**
     * Create new user
     * POST /api/users
     */
    public function store() {
        $this->checkPermission(ROLE_ADMIN);
        
        $input = $this->validate([
            'username' => ['required' => true, 'min' => 3, 'max' => 50],
            'password' => ['required' => true, 'min' => 8],
            'person_id' => ['required' => true, 'numeric' => true],
            'role' => ['required' => true],
            'branch_id' => ['required' => true, 'numeric' => true],
            'email' => ['required' => true, 'email' => true]
        ]);
        
        $username = sanitizeInput($input['username']);
        $password = $input['password'];
        $personId = intval($input['person_id']);
        $role = sanitizeInput($input['role']);
        $branchId = intval($input['branch_id']);
        $email = sanitizeInput($input['email']);
        
        // Validate password strength
        $passwordErrors = $this->validatePasswordStrength($password);
        if (!empty($passwordErrors)) {
            $this->error('Password validation failed', 400, $passwordErrors);
        }
        
        // Validate role
        $validRoles = [ROLE_SUPER_ADMIN, ROLE_ADMIN, ROLE_UNIT_HEAD, ROLE_BRANCH_HEAD, ROLE_SUPERVISOR, ROLE_COLLECTOR, ROLE_CASHIER];
        if (!in_array($role, $validRoles)) {
            $this->error('Invalid role specified', 400);
        }
        
        try {
            $this->db->beginTransaction();
            
            // Check if username exists
            $stmt = $this->db->prepare("SELECT id FROM users WHERE username = ?");
            $stmt->execute([$username]);
            if ($stmt->fetch()) {
                $this->db->rollBack();
                $this->error('Username already exists', 400);
            }
            
            // Check if person exists and is not already linked to a user
            $stmt = $this->db->prepare("
                SELECT p.id, p.name 
                FROM schema_person.persons p
                LEFT JOIN users u ON p.id = u.person_id
                WHERE p.id = ? AND u.id IS NULL
            ");
            $stmt->execute([$personId]);
            $person = $stmt->fetch();
            
            if (!$person) {
                $this->db->rollBack();
                $this->error('Person not found or already linked to a user', 400);
            }
            
            // Check if branch exists
            $stmt = $this->db->prepare("SELECT id FROM branches WHERE id = ?");
            $stmt->execute([$branchId]);
            if (!$stmt->fetch()) {
                $this->db->rollBack();
                $this->error('Branch not found', 400);
            }
            
            // Hash password
            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
            
            // Create user
            $stmt = $this->db->prepare("
                INSERT INTO users (username, password, person_id, role, branch_id, email, status, is_active, created_by, updated_by)
                VALUES (?, ?, ?, ?, ?, ?, 'active', 1, ?, ?)
            ");
            
            $currentUser = $this->getCurrentUser();
            $stmt->execute([
                $username, $hashedPassword, $personId, $role, $branchId, $email,
                $currentUser['user_id'], $currentUser['user_id']
            ]);
            
            $userId = $this->db->lastInsertId();
            
            // Log activity
            $this->logActivity('USER_CREATED', [
                'user_id' => $userId,
                'username' => $username,
                'role' => $role,
                'person_id' => $personId,
                'branch_id' => $branchId
            ]);
            
            $this->db->commit();
            
            // Get created user details
            $stmt = $this->db->prepare("
                SELECT u.id, u.username, u.role, u.status, u.created_at,
                       p.name as person_name, p.phone, p.email as person_email,
                       b.name as branch_name, ur.name as role_name
                FROM users u
                LEFT JOIN schema_person.persons p ON u.person_id = p.id
                LEFT JOIN branches b ON u.branch_id = b.id
                LEFT JOIN master_user_roles ur ON u.role = ur.code
                WHERE u.id = ?
            ");
            
            $stmt->execute([$userId]);
            $user = $stmt->fetch();
            
            $userData = [
                'id' => (int)$user['id'],
                'username' => $user['username'],
                'role' => $user['role'],
                'role_name' => $user['role_name'],
                'status' => $user['status'],
                'person_name' => $user['person_name'],
                'phone' => $user['phone'],
                'person_email' => $user['person_email'],
                'branch_id' => (int)$branchId,
                'branch_name' => $user['branch_name'],
                'created_at' => $user['created_at']
            ];
            
            $this->success($userData, 'User created successfully', 201);
            
        } catch (PDOException $e) {
            $this->db->rollBack();
            Logger::error('Database error in user creation', [
                'error' => $e->getMessage(),
                'username' => $username,
                'person_id' => $personId
            ]);
            $this->error('Failed to create user', 500);
        }
    }
    
    /**
     * Get specific user
     * GET /api/users/{id}
     */
    public function show($id) {
        $userId = intval($id);
        $currentUser = $this->getCurrentUser();
        
        // Users can only view their own profile unless they have admin permissions
        if ($currentUser['role'] !== ROLE_SUPER_ADMIN && $currentUser['role'] !== ROLE_ADMIN && $currentUser['user_id'] != $userId) {
            $this->checkPermission(ROLE_ADMIN);
        }
        
        try {
            $stmt = $this->db->prepare("
                SELECT u.id, u.username, u.email, u.role, u.status, u.is_active,
                       u.last_login, u.last_activity, u.created_at, u.updated_at,
                       p.name as person_name, p.phone, p.email as person_email, p.nik,
                       p.address, p.birth_date, p.gender, p.religion,
                       b.name as branch_name, ur.name as role_name
                FROM users u
                LEFT JOIN schema_person.persons p ON u.person_id = p.id
                LEFT JOIN branches b ON u.branch_id = b.id
                LEFT JOIN master_user_roles ur ON u.role = ur.code
                WHERE u.id = ?
            ");
            
            $stmt->execute([$userId]);
            $user = $stmt->fetch();
            
            if (!$user) {
                $this->notFound('User not found');
            }
            
            // Get user permissions
            $permissions = $this->getUserPermissions($user['role']);
            
            $userData = [
                'id' => (int)$user['id'],
                'username' => $user['username'],
                'email' => $user['email'],
                'role' => $user['role'],
                'role_name' => $user['role_name'],
                'status' => $user['status'],
                'is_active' => (bool)$user['is_active'],
                'permissions' => $permissions,
                'person_info' => [
                    'name' => $user['person_name'],
                    'phone' => $user['phone'],
                    'email' => $user['person_email'],
                    'nik' => $user['nik'],
                    'address' => $user['address'],
                    'birth_date' => $user['birth_date'],
                    'gender' => $user['gender'],
                    'religion' => $user['religion']
                ],
                'branch' => [
                    'id' => (int)$user['branch_id'],
                    'name' => $user['branch_name']
                ],
                'activity' => [
                    'last_login' => $user['last_login'],
                    'last_activity' => $user['last_activity']
                ],
                'timestamps' => [
                    'created_at' => $user['created_at'],
                    'updated_at' => $user['updated_at']
                ]
            ];
            
            $this->success($userData, 'User retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in user retrieval', [
                'error' => $e->getMessage(),
                'user_id' => $userId
            ]);
            $this->error('Failed to retrieve user', 500);
        }
    }
    
    /**
     * Update user
     * PUT /api/users/{id}
     */
    public function update($id) {
        $userId = intval($id);
        $currentUser = $this->getCurrentUser();
        
        // Users can only update their own profile unless they have admin permissions
        if ($currentUser['role'] !== ROLE_SUPER_ADMIN && $currentUser['role'] !== ROLE_ADMIN && $currentUser['user_id'] != $userId) {
            $this->checkPermission(ROLE_ADMIN);
        }
        
        $input = $this->validate([
            'email' => ['email' => true],
            'role' => [],
            'branch_id' => ['numeric' => true],
            'status' => []
        ]);
        
        try {
            $this->db->beginTransaction();
            
            // Check if user exists
            $stmt = $this->db->prepare("SELECT id, role FROM users WHERE id = ?");
            $stmt->execute([$userId]);
            $existingUser = $stmt->fetch();
            
            if (!$existingUser) {
                $this->db->rollBack();
                $this->notFound('User not found');
            }
            
            // Only admins can change role and status
            $updateFields = [];
            $params = [];
            
            if (isset($input['email'])) {
                $updateFields[] = "email = ?";
                $params[] = sanitizeInput($input['email']);
            }
            
            if ($currentUser['role'] === ROLE_SUPER_ADMIN || $currentUser['role'] === ROLE_ADMIN) {
                if (isset($input['role'])) {
                    $validRoles = [ROLE_SUPER_ADMIN, ROLE_ADMIN, ROLE_UNIT_HEAD, ROLE_BRANCH_HEAD, ROLE_SUPERVISOR, ROLE_COLLECTOR, ROLE_CASHIER];
                    if (!in_array($input['role'], $validRoles)) {
                        $this->db->rollBack();
                        $this->error('Invalid role specified', 400);
                    }
                    $updateFields[] = "role = ?";
                    $params[] = sanitizeInput($input['role']);
                }
                
                if (isset($input['branch_id'])) {
                    $updateFields[] = "branch_id = ?";
                    $params[] = intval($input['branch_id']);
                }
                
                if (isset($input['status'])) {
                    $validStatuses = [STATUS_ACTIVE, STATUS_INACTIVE, STATUS_SUSPENDED];
                    if (!in_array($input['status'], $validStatuses)) {
                        $this->db->rollBack();
                        $this->error('Invalid status specified', 400);
                    }
                    $updateFields[] = "status = ?";
                    $params[] = sanitizeInput($input['status']);
                }
            }
            
            if (!empty($updateFields)) {
                $updateFields[] = "updated_at = CURRENT_TIMESTAMP";
                $updateFields[] = "updated_by = ?";
                $params[] = $currentUser['user_id'];
                $params[] = $userId;
                
                $sql = "UPDATE users SET " . implode(', ', $updateFields) . " WHERE id = ?";
                $stmt = $this->db->prepare($sql);
                $stmt->execute($params);
                
                $this->logActivity('USER_UPDATED', [
                    'user_id' => $userId,
                    'updated_fields' => array_keys($input),
                    'updated_by' => $currentUser['user_id']
                ]);
            }
            
            $this->db->commit();
            
            // Get updated user
            $this->show($userId);
            
        } catch (PDOException $e) {
            $this->db->rollBack();
            Logger::error('Database error in user update', [
                'error' => $e->getMessage(),
                'user_id' => $userId
            ]);
            $this->error('Failed to update user', 500);
        }
    }
    
    /**
     * Delete user
     * DELETE /api/users/{id}
     */
    public function destroy($id) {
        $this->checkPermission(ROLE_SUPER_ADMIN);
        
        $userId = intval($id);
        $currentUser = $this->getCurrentUser();
        
        // Cannot delete self
        if ($userId === $currentUser['user_id']) {
            $this->error('Cannot delete your own account', 400);
        }
        
        try {
            $this->db->beginTransaction();
            
            // Check if user exists
            $stmt = $this->db->prepare("SELECT username FROM users WHERE id = ?");
            $stmt->execute([$userId]);
            $user = $stmt->fetch();
            
            if (!$user) {
                $this->db->rollBack();
                $this->notFound('User not found');
            }
            
            // Check for dependencies (loans, savings, etc.)
            $stmt = $this->db->prepare("
                SELECT COUNT(*) as count FROM loans WHERE created_by = ?
                UNION ALL
                SELECT COUNT(*) as count FROM savings_accounts WHERE created_by = ?
                UNION ALL
                SELECT COUNT(*) as count FROM journals WHERE created_by = ?
            ");
            
            $stmt->execute([$userId, $userId, $userId]);
            $dependencies = $stmt->fetchAll(PDO::FETCH_COLUMN);
            
            if (array_sum($dependencies) > 0) {
                $this->db->rollBack();
                $this->error('Cannot delete user with existing transactions', 400);
            }
            
            // Soft delete (set is_active = false)
            $stmt = $this->db->prepare("
                UPDATE users 
                SET is_active = 0, status = 'inactive', updated_by = ?, updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
            ");
            
            $stmt->execute([$currentUser['user_id'], $userId]);
            
            $this->logActivity('USER_DELETED', [
                'user_id' => $userId,
                'username' => $user['username'],
                'deleted_by' => $currentUser['user_id']
            ]);
            
            $this->db->commit();
            
            $this->success(null, 'User deleted successfully');
            
        } catch (PDOException $e) {
            $this->db->rollBack();
            Logger::error('Database error in user deletion', [
                'error' => $e->getMessage(),
                'user_id' => $userId
            ]);
            $this->error('Failed to delete user', 500);
        }
    }
    
    /**
     * Get current user profile
     * GET /api/users/profile
     */
    public function profile() {
        $user = $this->getCurrentUser();
        $this->show($user['user_id']);
    }
    
    /**
     * Update current user profile
     * PUT /api/users/profile
     */
    public function updateProfile() {
        $user = $this->getCurrentUser();
        $this->update($user['user_id']);
    }
    
    /**
     * Update current user password
     * PUT /api/users/password
     */
    public function updatePassword() {
        $input = $this->validate([
            'current_password' => ['required' => true],
            'new_password' => ['required' => true, 'min' => 8],
            'confirm_password' => ['required' => true]
        ]);
        
        $currentPassword = $input['current_password'];
        $newPassword = $input['new_password'];
        $confirmPassword = $input['confirm_password'];
        
        if ($newPassword !== $confirmPassword) {
            $this->error('Passwords do not match', 400);
        }
        
        $user = $this->getCurrentUser();
        $userId = $user['user_id'];
        
        try {
            // Get current password
            $stmt = $this->db->prepare("SELECT password FROM users WHERE id = ?");
            $stmt->execute([$userId]);
            $currentUser = $stmt->fetch();
            
            if (!$currentUser || !password_verify($currentPassword, $currentUser['password'])) {
                $this->error('Current password is incorrect', 400);
            }
            
            // Validate new password strength
            $passwordErrors = $this->validatePasswordStrength($newPassword);
            if (!empty($passwordErrors)) {
                $this->error('Password validation failed', 400, $passwordErrors);
            }
            
            // Hash new password
            $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
            
            // Update password
            $stmt = $this->db->prepare("
                UPDATE users 
                SET password = ?, updated_by = ?, updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
            ");
            
            $stmt->execute([$hashedPassword, $userId, $userId]);
            
            $this->logActivity('PASSWORD_CHANGED', [
                'user_id' => $userId,
                'username' => $user['username']
            ]);
            
            $this->success(null, 'Password updated successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in password update', [
                'error' => $e->getMessage(),
                'user_id' => $userId
            ]);
            $this->error('Failed to update password', 500);
        }
    }
    
    /**
     * Validate password strength (same as in AuthController)
     */
    private function validatePasswordStrength($password) {
        $errors = [];
        
        if (strlen($password) < 8) {
            $errors[] = 'Password must be at least 8 characters long';
        }
        
        if (!preg_match('/[A-Z]/', $password)) {
            $errors[] = 'Password must contain at least one uppercase letter';
        }
        
        if (!preg_match('/[a-z]/', $password)) {
            $errors[] = 'Password must contain at least one lowercase letter';
        }
        
        if (!preg_match('/[0-9]/', $password)) {
            $errors[] = 'Password must contain at least one number';
        }
        
        if (!preg_match('/[!@#$%^&*(),.?":{}|<>]/', $password)) {
            $errors[] = 'Password must contain at least one special character';
        }
        
        return $errors;
    }
}

?>
