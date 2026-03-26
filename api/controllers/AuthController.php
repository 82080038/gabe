<?php
/**
 * ================================================================
 * AUTHENTICATION CONTROLLER - KOPERASI BERJALAN
 * Maintainable authentication with proper security practices
 * ================================================================ */

require_once __DIR__ . '/../index.php';

class AuthController extends BaseController {
    
    /**
     * User login
     * POST /api/auth/login
     */
    public function login() {
        // Validate input
        $input = $this->validate([
            'username' => ['required' => true, 'min' => 3],
            'password' => ['required' => true, 'min' => 6]
        ]);
        
        $username = sanitizeInput($input['username']);
        $password = $input['password'];
        
        try {
            // Find user by username
            $stmt = $this->db->prepare("
                SELECT u.*, p.name as person_name, p.email, p.phone,
                       b.name as branch_name, ur.name as role_name
                FROM users u
                LEFT JOIN schema_person.persons p ON u.person_id = p.id
                LEFT JOIN branches b ON u.branch_id = b.id
                LEFT JOIN master_user_roles ur ON u.role = ur.code
                WHERE u.username = ? AND u.is_active = 1
            ");
            
            $stmt->execute([$username]);
            $user = $stmt->fetch();
            
            if (!$user) {
                $this->logActivity('LOGIN_FAILED', ['username' => $username, 'reason' => 'user_not_found']);
                $this->error('Invalid credentials', 401);
            }
            
            // Verify password
            if (!password_verify($password, $user['password'])) {
                $this->logActivity('LOGIN_FAILED', ['username' => $username, 'reason' => 'invalid_password']);
                $this->error('Invalid credentials', 401);
            }
            
            // Check if user is suspended
            if ($user['status'] === STATUS_SUSPENDED) {
                $this->logActivity('LOGIN_BLOCKED', ['username' => $username, 'reason' => 'account_suspended']);
                $this->error('Account suspended', 403);
            }
            
            // Generate JWT token
            $token = $this->generateJWT($user);
            
            // Update last login
            $this->updateLastLogin($user['id']);
            
            // Log successful login
            $this->logActivity('LOGIN_SUCCESS', [
                'user_id' => $user['id'],
                'username' => $username,
                'role' => $user['role']
            ]);
            
            // Prepare user data for response
            $userData = [
                'id' => $user['id'],
                'username' => $user['username'],
                'name' => $user['person_name'],
                'email' => $user['email'],
                'phone' => $user['phone'],
                'role' => $user['role'],
                'role_name' => $user['role_name'],
                'branch_id' => $user['branch_id'],
                'branch_name' => $user['branch_name'],
                'last_login' => $user['last_login'],
                'permissions' => $this->getUserPermissions($user['role'])
            ];
            
            $this->success([
                'user' => $userData,
                'token' => $token,
                'expires_in' => JWT_EXPIRE_TIME
            ], 'Login successful');
            
        } catch (PDOException $e) {
            Logger::error('Database error during login', [
                'error' => $e->getMessage(),
                'username' => $username
            ]);
            $this->error('Login failed due to system error', 500);
        }
    }
    
    /**
     * User logout
     * POST /api/auth/logout
     */
    public function logout() {
        $user = $this->getCurrentUser();
        
        // In a real implementation, you might want to:
        // 1. Add token to blacklist
        // 2. Clear session data
        // 3. Log logout activity
        
        $this->logActivity('LOGOUT', [
            'user_id' => $user['user_id'],
            'username' => $user['username']
        ]);
        
        $this->success(null, 'Logout successful');
    }
    
    /**
     * Refresh JWT token
     * POST /api/auth/refresh
     */
    public function refresh() {
        $user = $this->getCurrentUser();
        
        // Generate new token
        $newToken = $this->generateJWT($user);
        
        $this->success([
            'token' => $newToken,
            'expires_in' => JWT_EXPIRE_TIME
        ], 'Token refreshed');
    }
    
    /**
     * Forgot password
     * POST /api/auth/forgot-password
     */
    public function forgotPassword() {
        $input = $this->validate([
            'email' => ['required' => true, 'email' => true]
        ]);
        
        $email = sanitizeInput($input['email']);
        
        try {
            // Find user by email
            $stmt = $this->db->prepare("
                SELECT u.id, u.username, p.name, p.email
                FROM users u
                LEFT JOIN schema_person.persons p ON u.person_id = p.id
                WHERE p.email = ? AND u.is_active = 1
            ");
            
            $stmt->execute([$email]);
            $user = $stmt->fetch();
            
            if (!$user) {
                // Don't reveal if email exists or not
                $this->success(null, 'If the email exists, a reset link has been sent');
            }
            
            // Generate reset token
            $resetToken = generateRandomString(32);
            $resetExpiry = date('Y-m-d H:i:s', strtotime('+1 hour'));
            
            // Save reset token
            $stmt = $this->db->prepare("
                UPDATE users 
                SET reset_token = ?, reset_token_expiry = ?
                WHERE id = ?
            ");
            
            $stmt->execute([$resetToken, $resetExpiry, $user['id']]);
            
            // Send reset email (implementation depends on your email service)
            $this->sendPasswordResetEmail($user['email'], $resetToken);
            
            $this->logActivity('PASSWORD_RESET_REQUESTED', [
                'user_id' => $user['id'],
                'email' => $email
            ]);
            
            $this->success(null, 'If the email exists, a reset link has been sent');
            
        } catch (PDOException $e) {
            Logger::error('Database error during forgot password', [
                'error' => $e->getMessage(),
                'email' => $email
            ]);
            $this->error('System error occurred', 500);
        }
    }
    
    /**
     * Reset password
     * POST /api/auth/reset-password
     */
    public function resetPassword() {
        $input = $this->validate([
            'token' => ['required' => true],
            'password' => ['required' => true, 'min' => 8],
            'confirm_password' => ['required' => true]
        ]);
        
        $token = sanitizeInput($input['token']);
        $password = $input['password'];
        $confirmPassword = $input['confirm_password'];
        
        if ($password !== $confirmPassword) {
            $this->error('Passwords do not match', 400);
        }
        
        try {
            // Find user by reset token
            $stmt = $this->db->prepare("
                SELECT id, username, reset_token_expiry
                FROM users
                WHERE reset_token = ? AND is_active = 1
            ");
            
            $stmt->execute([$token]);
            $user = $stmt->fetch();
            
            if (!$user) {
                $this->error('Invalid or expired reset token', 400);
            }
            
            if (strtotime($user['reset_token_expiry']) < time()) {
                $this->error('Reset token has expired', 400);
            }
            
            // Hash new password
            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
            
            // Update password and clear reset token
            $stmt = $this->db->prepare("
                UPDATE users 
                SET password = ?, reset_token = NULL, reset_token_expiry = NULL,
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = ?
            ");
            
            $stmt->execute([$hashedPassword, $user['id']]);
            
            $this->logActivity('PASSWORD_RESET', [
                'user_id' => $user['id'],
                'username' => $user['username']
            ]);
            
            $this->success(null, 'Password reset successful');
            
        } catch (PDOException $e) {
            Logger::error('Database error during password reset', [
                'error' => $e->getMessage(),
                'token' => $token
            ]);
            $this->error('System error occurred', 500);
        }
    }
    
    /**
     * Generate JWT token
     */
    private function generateJWT($user) {
        $header = base64_encode(json_encode([
            'alg' => JWT_ALGORITHM,
            'typ' => 'JWT'
        ]));
        
        $payload = [
            'user_id' => $user['id'],
            'username' => $user['username'],
            'role' => $user['role'],
            'branch_id' => $user['branch_id'],
            'iat' => time(),
            'exp' => time() + JWT_EXPIRE_TIME
        ];
        
        $payloadEncoded = base64_encode(json_encode($payload));
        
        $signature = hash_hmac('sha256', "$header.$payloadEncoded", JWT_SECRET_KEY, true);
        $signatureEncoded = base64_encode($signature);
        
        return "$header.$payloadEncoded.$signatureEncoded";
    }
    
    /**
     * Update last login timestamp
     */
    private function updateLastLogin($userId) {
        $stmt = $this->db->prepare("
            UPDATE users 
            SET last_login = CURRENT_TIMESTAMP, last_activity = CURRENT_TIMESTAMP
            WHERE id = ?
        ");
        
        $stmt->execute([$userId]);
    }
    
    /**
     * Get user permissions based on role
     */
    private function getUserPermissions($role) {
        $permissions = [
            ROLE_SUPER_ADMIN => ['all'],
            ROLE_ADMIN => ['users', 'members', 'products', 'reports', 'settings'],
            ROLE_UNIT_HEAD => ['unit_management', 'staff_management', 'reports'],
            ROLE_BRANCH_HEAD => ['branch_management', 'member_management', 'loan_approval', 'reports'],
            ROLE_SUPERVISOR => ['staff_supervision', 'collection_supervision', 'reports'],
            ROLE_COLLECTOR => ['collection', 'member_visit', 'mobile_access'],
            ROLE_CASHIER => ['cash_management', 'savings_transactions', 'loan_payments'],
            ROLE_MEMBER => ['self_service', 'view_own_data', 'apply_loan'],
            ROLE_GUEST => ['view_public_info']
        ];
        
        return $permissions[$role] ?? [];
    }
    
    /**
     * Send password reset email
     */
    private function sendPasswordResetEmail($email, $token) {
        // Implementation depends on your email service
        // This is a placeholder for email sending
        
        $resetLink = "https://yourdomain.com/reset-password?token=" . $token;
        
        $subject = "Password Reset - Koperasi Berjalan";
        $message = "
            <h2>Password Reset Request</h2>
            <p>Click the link below to reset your password:</p>
            <p><a href='{$resetLink}'>Reset Password</a></p>
            <p>This link will expire in 1 hour.</p>
            <p>If you didn't request this, please ignore this email.</p>
        ";
        
        // Log email sending (in production, use actual email service)
        Logger::info('Password reset email sent', [
            'email' => $email,
            'token' => $token,
            'reset_link' => $resetLink
        ]);
        
        // In development, just log the link
        if (ENVIRONMENT === 'development') {
            Logger::debug('Password reset link', ['link' => $resetLink]);
        }
    }
    
    /**
     * Validate password strength
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
    
    /**
     * Rate limiting for login attempts
     */
    private function checkLoginRateLimit($username) {
        // Implement login rate limiting
        // Check failed login attempts in last 15 minutes
        $stmt = $this->db->prepare("
            SELECT COUNT(*) as attempts
            FROM audit_logs
            WHERE action = 'LOGIN_FAILED'
            AND JSON_EXTRACT(details, '$.username') = ?
            AND created_at > DATE_SUB(NOW(), INTERVAL 15 MINUTE)
        ");
        
        $stmt->execute([$username]);
        $result = $stmt->fetch();
        
        if ($result['attempts'] >= 5) {
            $this->error('Too many login attempts. Please try again later.', 429);
        }
    }
}

?>
