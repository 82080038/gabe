<?php
/**
 * Authentication System for Koperasi Berjalan
 * Database-based authentication
 */

session_start();

// Database configuration
$db_host = 'localhost';
$db_user = 'root';
$db_pass = 'root';
$db_name = 'schema_app';
$socket = '/opt/lampp/var/mysql/mysql.sock';

// Create database connection
try {
    $pdo = new PDO("mysql:host=$db_host;unix_socket=$socket;dbname=$db_name", $db_user, $db_pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}

/**
 * Authenticate user
 */
function authenticateUser($username, $password) {
    global $pdo;
    
    try {
        $stmt = $pdo->prepare("SELECT u.*, p.name as person_name 
                              FROM users u 
                              LEFT JOIN schema_person.persons p ON u.person_id = p.id 
                              WHERE u.username = :username AND u.status = 'active' AND u.is_active = 1");
        
        $stmt->bindParam(':username', $username);
        $stmt->execute();
        
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user && password_verify($password, $user['password'])) {
            // Update last login
            $updateStmt = $pdo->prepare("UPDATE users SET last_login = NOW(), last_activity = NOW() WHERE id = :id");
            $updateStmt->bindParam(':id', $user['id']);
            $updateStmt->execute();
            
            return $user;
        }
        
        return false;
    } catch (PDOException $e) {
        error_log("Authentication error: " . $e->getMessage());
        return false;
    }
}

/**
 * Login user and create session
 */
function loginUser($username, $password) {
    $user = authenticateUser($username, $password);
    
    if ($user) {
        $_SESSION['user'] = [
            'id' => $user['id'],
            'username' => $user['username'],
            'name' => $user['person_name'] ?: $user['username'],
            'role' => $user['role'],
            'branch_id' => $user['branch_id'],
            'unit_id' => $user['unit_id']
        ];
        
        return true;
    }
    
    return false;
}

/**
 * Check if user is logged in
 */
function isLoggedIn() {
    return isset($_SESSION['user']);
}

/**
 * Get current user
 */
function getCurrentUser() {
    return $_SESSION['user'] ?? null;
}

/**
 * Logout user
 */
function logoutUser() {
    unset($_SESSION['user']);
    session_destroy();
}

/**
 * Check user role
 */
function hasRole($role) {
    $user = getCurrentUser();
    return $user && $user['role'] === $role;
}

/**
 * Redirect based on role and device
 */
function redirectBasedOnRole($deviceType) {
    $user = getCurrentUser();
    
    if (!$user) {
        header('Location: /gabe/pages/login.php');
        exit;
    }
    
    // Mobile collector goes to mobile dashboard
    if ($deviceType === 'mobile' && $user['role'] === 'collector') {
        header('Location: /gabe/pages/mobile/dashboard.php');
    } else {
        header('Location: /gabe/pages/web/dashboard.php');
    }
    exit;
}
?>
