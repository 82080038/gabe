<?php
/**
 * ================================================================
 * API CONFIGURATION - KOPERASI BERJALAN
 * Centralized configuration for maintainability and security
 * ================================================================
 */

// Prevent direct access
if (!defined('KOPERASI_API')) {
    define('KOPERASI_API', true);
}

// ================================================================
// ENVIRONMENT CONFIGURATION
// ================================================================

// Environment detection
define('ENVIRONMENT', 
    $_SERVER['HTTP_HOST'] === 'localhost' || 
    $_SERVER['HTTP_HOST'] === '127.0.0.1' ? 'development' : 'production'
);

// Error reporting based on environment
if (ENVIRONMENT === 'development') {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    ini_set('log_errors', 1);
    ini_set('error_log', __DIR__ . '/../logs/api-errors.log');
} else {
    error_reporting(E_ALL & ~E_DEPRECATED & ~E_STRICT);
    ini_set('display_errors', 0);
    ini_set('log_errors', 1);
    ini_set('error_log', __DIR__ . '/../logs/api-errors.log');
}

// ================================================================
// DATABASE CONFIGURATION
// ================================================================

// Database connection parameters
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', 'root');
define('DB_NAME', 'schema_app');

// Database connection with error handling
class Database {
    private static $instance = null;
    private $connection;
    
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    private function __construct() {
        try {
            $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4";
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::ATTR_PERSISTENT => true
            ];
            
            $this->connection = new PDO($dsn, DB_USER, DB_PASS, $options);
        } catch (PDOException $e) {
            $this->handleDatabaseError($e);
        }
    }
    
    public function getConnection() {
        return $this->connection;
    }
    
    private function handleDatabaseError($e) {
        $error = [
            'error' => 'Database connection failed',
            'message' => ENVIRONMENT === 'development' ? $e->getMessage() : 'Service unavailable',
            'timestamp' => date('Y-m-d H:i:s'),
            'environment' => ENVIRONMENT
        ];
        
        // Log error
        error_log("Database Error: " . $e->getMessage(), 3, __DIR__ . '/../logs/database-errors.log');
        
        // Return appropriate response
        header('Content-Type: application/json');
        http_response_code(503);
        echo json_encode($error);
        exit;
    }
    
    public function __clone() {}
    public function __wakeup() {}
}

// ================================================================
// SECURITY CONFIGURATION
// ================================================================

// CORS Configuration
define('ALLOWED_ORIGINS', ENVIRONMENT === 'development' 
    ? ['http://localhost:3000', 'http://127.0.0.1:3000', 'http://localhost'] 
    : ['https://yourdomain.com']
);

// JWT Configuration
define('JWT_SECRET_KEY', 'your-super-secret-jwt-key-change-in-production');
define('JWT_ALGORITHM', 'HS256');
define('JWT_EXPIRE_TIME', 86400); // 24 hours

// Rate Limiting
define('RATE_LIMIT_REQUESTS', 100);
define('RATE_LIMIT_WINDOW', 3600); // 1 hour

// File Upload Configuration
define('MAX_FILE_SIZE', 5 * 1024 * 1024); // 5MB
define('ALLOWED_FILE_TYPES', ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx']);
define('UPLOAD_PATH', __DIR__ . '/../uploads/');

// ================================================================
// API RESPONSE STANDARDS
// ================================================================

class ApiResponse {
    /**
     * Send standardized API response
     */
    public static function send($data = null, $message = '', $status = 200, $meta = null) {
        $response = [
            'success' => $status >= 200 && $status < 300,
            'message' => $message,
            'data' => $data,
            'timestamp' => date('Y-m-d H:i:s'),
            'status' => $status
        ];
        
        if ($meta !== null) {
            $response['meta'] = $meta;
        }
        
        // Add debug info in development
        if (ENVIRONMENT === 'development') {
            $response['debug'] = [
                'memory_usage' => round(memory_get_usage() / 1024 / 1024, 2) . ' MB',
                'execution_time' => round(microtime(true) - $_SERVER['REQUEST_TIME_FLOAT'], 4) . 's',
                'queries' => self::getQueryCount()
            ];
        }
        
        header('Content-Type: application/json');
        http_response_code($status);
        echo json_encode($response, JSON_PRETTY_PRINT);
        exit;
    }
    
    /**
     * Send error response
     */
    public static function error($message, $status = 400, $errors = null) {
        $response = [
            'success' => false,
            'error' => $message,
            'status' => $status,
            'timestamp' => date('Y-m-d H:i:s')
        ];
        
        if ($errors !== null) {
            $response['errors'] = $errors;
        }
        
        if (ENVIRONMENT === 'development') {
            $response['debug'] = [
                'file' => debug_backtrace()[1]['file'] ?? 'unknown',
                'line' => debug_backtrace()[1]['line'] ?? 'unknown',
                'function' => debug_backtrace()[1]['function'] ?? 'unknown'
            ];
        }
        
        header('Content-Type: application/json');
        http_response_code($status);
        echo json_encode($response, JSON_PRETTY_PRINT);
        exit;
    }
    
    private static function getQueryCount() {
        // Implementation depends on your logging system
        return 0; // Placeholder
    }
}

// ================================================================
// MIDDLEWARE CONFIGURATION
// ================================================================

class Middleware {
    /**
     * CORS middleware
     */
    public static function cors() {
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
        
        if (in_array($origin, ALLOWED_ORIGINS)) {
            header("Access-Control-Allow-Origin: $origin");
        }
        
        header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
        header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
        header("Access-Control-Allow-Credentials: true");
        header("Access-Control-Max-Age: 3600");
        
        if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
            http_response_code(200);
            exit;
        }
    }
    
    /**
     * Rate limiting middleware
     */
    public static function rateLimit($requests = RATE_LIMIT_REQUESTS, $window = RATE_LIMIT_WINDOW) {
        $clientIp = self::getClientIp();
        $key = "rate_limit_{$clientIp}";
        
        // Simple file-based rate limiting (use Redis in production)
        $rateLimitFile = __DIR__ . '/../cache/rate_limits.json';
        $rateLimits = file_exists($rateLimitFile) ? json_decode(file_get_contents($rateLimitFile), true) : [];
        
        $now = time();
        $windowStart = $now - $window;
        
        // Clean old entries
        $rateLimits = array_filter($rateLimits, function($entry) use ($windowStart) {
            return $entry['timestamp'] > $windowStart;
        });
        
        // Check current requests
        $currentRequests = count(array_filter($rateLimits, function($entry) use ($clientIp) {
            return $entry['ip'] === $clientIp;
        }));
        
        if ($currentRequests >= $requests) {
            ApiResponse::error('Rate limit exceeded', 429);
        }
        
        // Add current request
        $rateLimits[] = [
            'ip' => $clientIp,
            'timestamp' => $now
        ];
        
        file_put_contents($rateLimitFile, json_encode($rateLimits));
    }
    
    /**
     * Authentication middleware
     */
    public static function auth() {
        $headers = getallheaders();
        $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
        
        if (!$authHeader) {
            ApiResponse::error('Authorization header required', 401);
        }
        
        if (!preg_match('/Bearer\s+(.*)$/i', $authHeader, $matches)) {
            ApiResponse::error('Invalid authorization format', 401);
        }
        
        $token = $matches[1];
        
        try {
            $payload = self::verifyJWT($token);
            return $payload;
        } catch (Exception $e) {
            ApiResponse::error('Invalid or expired token', 401);
        }
    }
    
    /**
     * Input validation middleware
     */
    public static function validateInput($rules) {
        $input = json_decode(file_get_contents('php://input'), true);
        $errors = [];
        
        foreach ($rules as $field => $fieldRules) {
            $value = $input[$field] ?? null;
            
            foreach ($fieldRules as $rule => $ruleValue) {
                switch ($rule) {
                    case 'required':
                        if ($value === null || $value === '') {
                            $errors[$field][] = "$field is required";
                        }
                        break;
                    case 'email':
                        if ($value !== null && !filter_var($value, FILTER_VALIDATE_EMAIL)) {
                            $errors[$field][] = "$field must be a valid email";
                        }
                        break;
                    case 'min':
                        if ($value !== null && strlen($value) < $ruleValue) {
                            $errors[$field][] = "$field must be at least $ruleValue characters";
                        }
                        break;
                    case 'max':
                        if ($value !== null && strlen($value) > $ruleValue) {
                            $errors[$field][] = "$field must not exceed $ruleValue characters";
                        }
                        break;
                    case 'numeric':
                        if ($value !== null && !is_numeric($value)) {
                            $errors[$field][] = "$field must be numeric";
                        }
                        break;
                }
            }
        }
        
        if (!empty($errors)) {
            ApiResponse::error('Validation failed', 400, $errors);
        }
        
        return $input;
    }
    
    /**
     * Get client IP address
     */
    private static function getClientIp() {
        $ipKeys = ['HTTP_CLIENT_IP', 'HTTP_X_FORWARDED_FOR', 'HTTP_X_FORWARDED', 'HTTP_FORWARDED_FOR', 'HTTP_FORWARDED', 'REMOTE_ADDR'];
        
        foreach ($ipKeys as $key) {
            if (array_key_exists($key, $_SERVER) === true) {
                foreach (explode(',', $_SERVER[$key]) as $ip) {
                    $ip = trim($ip);
                    if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) !== false) {
                        return $ip;
                    }
                }
            }
        }
        
        return $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
    }
    
    /**
     * JWT verification
     */
    private static function verifyJWT($token) {
        $parts = explode('.', $token);
        
        if (count($parts) !== 3) {
            throw new Exception('Invalid token structure');
        }
        
        list($header, $payload, $signature) = $parts;
        
        // Verify signature (simplified - use proper JWT library in production)
        $expectedSignature = hash_hmac('sha256', "$header.$payload", JWT_SECRET_KEY, true);
        $signatureValid = hash_equals(base64_decode($signature), $expectedSignature);
        
        if (!$signatureValid) {
            throw new Exception('Invalid signature');
        }
        
        $payloadData = json_decode(base64_decode($payload), true);
        
        if (!$payloadData || !isset($payloadData['exp']) || $payloadData['exp'] < time()) {
            throw new Exception('Token expired');
        }
        
        return $payloadData;
    }
}

// ================================================================
// LOGGING CONFIGURATION
// ================================================================

class Logger {
    private static $logFile;
    
    public static function init() {
        self::$logFile = __DIR__ . '/../logs/api-' . date('Y-m-d') . '.log';
        
        // Create logs directory if not exists
        $logDir = dirname(self::$logFile);
        if (!is_dir($logDir)) {
            mkdir($logDir, 0755, true);
        }
    }
    
    public static function log($level, $message, $context = []) {
        if (!self::$logFile) {
            self::init();
        }
        
        $logEntry = [
            'timestamp' => date('Y-m-d H:i:s'),
            'level' => $level,
            'message' => $message,
            'context' => $context,
            'ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
            'endpoint' => $_SERVER['REQUEST_URI'] ?? 'unknown',
            'method' => $_SERVER['REQUEST_METHOD'] ?? 'unknown'
        ];
        
        $logLine = json_encode($logEntry) . PHP_EOL;
        file_put_contents(self::$logFile, $logLine, FILE_APPEND | LOCK_EX);
        
        // In development, also log to console
        if (ENVIRONMENT === 'development') {
            error_log("[$level] $message");
        }
    }
    
    public static function info($message, $context = []) {
        self::log('INFO', $message, $context);
    }
    
    public static function error($message, $context = []) {
        self::log('ERROR', $message, $context);
    }
    
    public static function warning($message, $context = []) {
        self::log('WARNING', $message, $context);
    }
    
    public static function debug($message, $context = []) {
        if (ENVIRONMENT === 'development') {
            self::log('DEBUG', $message, $context);
        }
    }
}

// ================================================================
// INITIALIZATION
// ================================================================

// Initialize logger
Logger::init();

// Start request logging
$requestStart = microtime(true);
Logger::info('API Request started', [
    'method' => $_SERVER['REQUEST_METHOD'],
    'uri' => $_SERVER['REQUEST_URI'],
    'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown'
]);

// Register shutdown function for request completion logging
register_shutdown_function(function() use ($requestStart) {
    $executionTime = round(microtime(true) - $requestStart, 4);
    Logger::info('API Request completed', [
        'execution_time' => $executionTime,
        'memory_usage' => round(memory_get_usage() / 1024 / 1024, 2) . ' MB',
        'status' => http_response_code()
    ]);
});

// ================================================================
// GLOBAL FUNCTIONS FOR MAINTAINABILITY
// ================================================================

/**
 * Sanitize input data
 */
function sanitizeInput($data) {
    if (is_array($data)) {
        return array_map('sanitizeInput', $data);
    }
    return htmlspecialchars(strip_tags(trim($data)), ENT_QUOTES, 'UTF-8');
}

/**
 * Validate date format
 */
function validateDate($date, $format = 'Y-m-d') {
    $d = DateTime::createFromFormat($format, $date);
    return $d && $d->format($format) === $date;
}

/**
 * Generate random string
 */
function generateRandomString($length = 32) {
    return bin2hex(random_bytes($length / 2));
}

/**
 * Format currency
 */
function formatCurrency($amount, $currency = 'IDR') {
    return $currency . ' ' . number_format($amount, 0, ',', '.');
}

/**
 * Send JSON response with proper headers
 */
function sendJsonResponse($data, $status = 200) {
    ApiResponse::send($data, '', $status);
}

/**
 * Send error response
 */
function sendErrorResponse($message, $status = 400, $errors = null) {
    ApiResponse::error($message, $status, $errors);
}

// ================================================================
// CONSTANTS FOR MAINTAINABILITY
// ================================================================

// User roles
define('ROLE_SUPER_ADMIN', 'super_admin');
define('ROLE_ADMIN', 'admin');
define('ROLE_UNIT_HEAD', 'unit_head');
define('ROLE_BRANCH_HEAD', 'branch_head');
define('ROLE_SUPERVISOR', 'supervisor');
define('ROLE_COLLECTOR', 'collector');
define('ROLE_CASHIER', 'cashier');
define('ROLE_MEMBER', 'member');
define('ROLE_GUEST', 'guest');

// Status constants
define('STATUS_ACTIVE', 'active');
define('STATUS_INACTIVE', 'inactive');
define('STATUS_SUSPENDED', 'suspended');
define('STATUS_PENDING', 'pending');
define('STATUS_VERIFIED', 'verified');
define('STATUS_REJECTED', 'rejected');

// Transaction types
define('TRANSACTION_LOAN_DISBURSEMENT', 'loan_disbursement');
define('TRANSACTION_LOAN_PAYMENT', 'loan_payment');
define('TRANSACTION_SAVINGS_DEPOSIT', 'savings_deposit');
define('TRANSACTION_SAVINGS_WITHDRAWAL', 'savings_withdrawal');
define('TRANSACTION_FEE_PAYMENT', 'fee_payment');

// Pagination
define('DEFAULT_PAGE_SIZE', 20);
define('MAX_PAGE_SIZE', 100);

?>
