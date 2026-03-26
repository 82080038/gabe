<?php
/**
 * ================================================================
 * API ROUTER - KOPERASI BERJALAN
 * Central API router with maintainable structure
 * ================================================================ */

// Load configuration
require_once __DIR__ . '/config.php';

// Apply global middleware
Middleware::cors();
Middleware::rateLimit();

// Parse request
$method = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri = rtrim($uri, '/');

// Route mapping with maintainable structure
$routes = [
    // Authentication routes
    'POST /api/auth/login' => ['AuthController', 'login'],
    'POST /api/auth/logout' => ['AuthController', 'logout'],
    'POST /api/auth/refresh' => ['AuthController', 'refresh'],
    'POST /api/auth/forgot-password' => ['AuthController', 'forgotPassword'],
    'POST /api/auth/reset-password' => ['AuthController', 'resetPassword'],
    
    // User management routes
    'GET /api/users' => ['UserController', 'index'],
    'POST /api/users' => ['UserController', 'store'],
    'GET /api/users/{id}' => ['UserController', 'show'],
    'PUT /api/users/{id}' => ['UserController', 'update'],
    'DELETE /api/users/{id}' => ['UserController', 'destroy'],
    'GET /api/users/profile' => ['UserController', 'profile'],
    'PUT /api/users/profile' => ['UserController', 'updateProfile'],
    'PUT /api/users/password' => ['UserController', 'updatePassword'],
    
    // Member management routes
    'GET /api/members' => ['MemberController', 'index'],
    'POST /api/members' => ['MemberController', 'store'],
    'GET /api/members/{id}' => ['MemberController', 'show'],
    'PUT /api/members/{id}' => ['MemberController', 'update'],
    'DELETE /api/members/{id}' => ['MemberController', 'destroy'],
    'GET /api/members/search' => ['MemberController', 'search'],
    'GET /api/members/{id}/loans' => ['MemberController', 'loans'],
    'GET /api/members/{id}/savings' => ['MemberController', 'savings'],
    'POST /api/members/{id}/verify' => ['MemberController', 'verify'],
    
    // Loan management routes
    'GET /api/loans' => ['LoanController', 'index'],
    'POST /api/loans' => ['LoanController', 'store'],
    'GET /api/loans/{id}' => ['LoanController', 'show'],
    'PUT /api/loans/{id}' => ['LoanController', 'update'],
    'DELETE /api/loans/{id}' => ['LoanController', 'destroy'],
    'POST /api/loans/{id}/approve' => ['LoanController', 'approve'],
    'POST /api/loans/{id}/disburse' => ['LoanController', 'disburse'],
    'POST /api/loans/{id}/payment' => ['LoanController', 'payment'],
    'GET /api/loans/{id}/schedule' => ['LoanController', 'schedule'],
    'GET /api/loans/{id}/history' => ['LoanController', 'history'],
    
    // Savings management routes
    'GET /api/savings' => ['SavingsController', 'index'],
    'POST /api/savings' => ['SavingsController', 'store'],
    'GET /api/savings/{id}' => ['SavingsController', 'show'],
    'PUT /api/savings/{id}' => ['SavingsController', 'update'],
    'DELETE /api/savings/{id}' => ['SavingsController', 'destroy'],
    'POST /api/savings/{id}/deposit' => ['SavingsController', 'deposit'],
    'POST /api/savings/{id}/withdraw' => ['SavingsController', 'withdraw'],
    'GET /api/savings/{id}/transactions' => ['SavingsController', 'transactions'],
    'POST /api/savings/{id}/calculate-interest' => ['SavingsController', 'calculateInterest'],
    
    // Product management routes
    'GET /api/loan-products' => ['ProductController', 'loanProducts'],
    'POST /api/loan-products' => ['ProductController', 'storeLoanProduct'],
    'GET /api/loan-products/{id}' => ['ProductController', 'showLoanProduct'],
    'PUT /api/loan-products/{id}' => ['ProductController', 'updateLoanProduct'],
    'DELETE /api/loan-products/{id}' => ['ProductController', 'destroyLoanProduct'],
    
    'GET /api/savings-products' => ['ProductController', 'savingsProducts'],
    'POST /api/savings-products' => ['ProductController', 'storeSavingsProduct'],
    'GET /api/savings-products/{id}' => ['ProductController', 'showSavingsProduct'],
    'PUT /api/savings-products/{id}' => ['ProductController', 'updateSavingsProduct'],
    'DELETE /api/savings-products/{id}' => ['ProductController', 'destroySavingsProduct'],
    
    // Dashboard and reporting routes
    'GET /api/dashboard/stats' => ['DashboardController', 'stats'],
    'GET /api/dashboard/recent-activity' => ['DashboardController', 'recentActivity'],
    'GET /api/dashboard/performance' => ['DashboardController', 'performance'],
    'GET /api/reports/financial' => ['ReportController', 'financial'],
    'GET /api/reports/loans' => ['ReportController', 'loans'],
    'GET /api/reports/savings' => ['ReportController', 'savings'],
    'GET /api/reports/collections' => ['ReportController', 'collections'],
    
    // Master data routes
    'GET /api/master/religions' => ['MasterController', 'religions'],
    'GET /api/master/occupations' => ['MasterController', 'occupations'],
    'GET /api/master/education-levels' => ['MasterController', 'educationLevels'],
    'GET /api/master/banks' => ['MasterController', 'banks'],
    'GET /api/master/payment-methods' => ['MasterController', 'paymentMethods'],
    'GET /api/master/user-roles' => ['MasterController', 'userRoles'],
    
    // Utility routes
    'GET /api/utils/health-check' => ['UtilityController', 'healthCheck'],
    'POST /api/utils/upload' => ['UtilityController', 'upload'],
    'GET /api/utils/download/{file}' => ['UtilityController', 'download'],
    'GET /api/utils/export/{type}' => ['UtilityController', 'export'],
    'POST /api/utils/import' => ['UtilityController', 'import'],
    
    // Notification routes
    'GET /api/notifications' => ['NotificationController', 'index'],
    'POST /api/notifications' => ['NotificationController', 'store'],
    'PUT /api/notifications/{id}/read' => ['NotificationController', 'markAsRead'],
    'DELETE /api/notifications/{id}' => ['NotificationController', 'destroy'],
    'POST /api/notifications/send' => ['NotificationController', 'send'],
    
    // Settings and configuration routes
    'GET /api/settings/system' => ['SettingsController', 'system'],
    'PUT /api/settings/system' => ['SettingsController', 'updateSystem'],
    'GET /api/settings/user/{id}' => ['SettingsController', 'user'],
    'PUT /api/settings/user/{id}' => ['SettingsController', 'updateUser'],
];

// ================================================================
// ROUTE MATCHING WITH MAINTAINABLE PATTERN
// ================================================================

class Router {
    private $routes;
    private $method;
    private $uri;
    
    public function __construct($routes, $method, $uri) {
        $this->routes = $routes;
        $this->method = $method;
        $this->uri = $uri;
    }
    
    public function dispatch() {
        try {
            $route = $this->findRoute();
            
            if (!$route) {
                ApiResponse::error('Route not found', 404);
            }
            
            $this->executeRoute($route);
            
        } catch (Exception $e) {
            Logger::error('Router error', [
                'error' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            
            if (ENVIRONMENT === 'development') {
                ApiResponse::error($e->getMessage(), 500, [
                    'file' => $e->getFile(),
                    'line' => $e->getLine(),
                    'trace' => $e->getTraceAsString()
                ]);
            } else {
                ApiResponse::error('Internal server error', 500);
            }
        }
    }
    
    private function findRoute() {
        $routeKey = "{$this->method} {$this->uri}";
        
        // Exact match
        if (isset($this->routes[$routeKey])) {
            return $this->routes[$routeKey];
        }
        
        // Pattern matching for routes with parameters
        foreach ($this->routes as $pattern => $handler) {
            if ($this->matchesPattern($pattern, $routeKey)) {
                return [
                    'handler' => $handler,
                    'params' => $this->extractParams($pattern, $this->uri)
                ];
            }
        }
        
        return null;
    }
    
    private function matchesPattern($pattern, $routeKey) {
        $patternParts = explode(' ', $pattern);
        $routeParts = explode(' ', $routeKey);
        
        if ($patternParts[0] !== $routeParts[0]) {
            return false;
        }
        
        $patternPath = $patternParts[1];
        $routePath = $routeParts[1];
        
        $patternSegments = explode('/', $patternPath);
        $routeSegments = explode('/', $routePath);
        
        if (count($patternSegments) !== count($routeSegments)) {
            return false;
        }
        
        foreach ($patternSegments as $i => $segment) {
            if ($segment !== $routeSegments[$i] && !preg_match('/^{.+}$/', $segment)) {
                return false;
            }
        }
        
        return true;
    }
    
    private function extractParams($pattern, $uri) {
        $patternParts = explode(' ', $pattern);
        $patternPath = $patternParts[1];
        
        $patternSegments = explode('/', $patternPath);
        $routeSegments = explode('/', $uri);
        
        $params = [];
        
        foreach ($patternSegments as $i => $segment) {
            if (preg_match('/^{(.+)}$/', $segment, $matches)) {
                $paramName = $matches[1];
                $params[$paramName] = $routeSegments[$i] ?? null;
            }
        }
        
        return $params;
    }
    
    private function executeRoute($route) {
        $handler = $route['handler'] ?? $route;
        $params = $route['params'] ?? [];
        
        $controllerName = $handler[0];
        $methodName = $handler[1];
        
        // Load controller
        $controllerFile = __DIR__ . "/controllers/{$controllerName}.php";
        
        if (!file_exists($controllerFile)) {
            throw new Exception("Controller {$controllerName} not found");
        }
        
        require_once $controllerFile;
        
        if (!class_exists($controllerName)) {
            throw new Exception("Class {$controllerName} not found");
        }
        
        $controller = new $controllerName();
        
        if (!method_exists($controller, $methodName)) {
            throw new Exception("Method {$methodName} not found in {$controllerName}");
        }
        
        // Execute with parameters
        $reflection = new ReflectionMethod($controller, $methodName);
        $args = [];
        
        foreach ($reflection->getParameters() as $param) {
            $paramName = $param->getName();
            $args[] = $params[$paramName] ?? null;
        }
        
        $result = $reflection->invokeArgs($controller, $args);
        
        // If controller returns data, send as response
        if ($result !== null) {
            ApiResponse::send($result);
        }
    }
}

// ================================================================
// CONTROLLER BASE CLASS FOR MAINTAINABILITY
// ================================================================

abstract class BaseController {
    protected $db;
    
    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }
    
    /**
     * Validate request data
     */
    protected function validate($rules) {
        return Middleware::validateInput($rules);
    }
    
    /**
     * Get pagination parameters
     */
    protected function getPagination() {
        $page = max(1, intval($_GET['page'] ?? 1));
        $limit = min(MAX_PAGE_SIZE, max(1, intval($_GET['limit'] ?? DEFAULT_PAGE_SIZE)));
        $offset = ($page - 1) * $limit;
        
        return [
            'page' => $page,
            'limit' => $limit,
            'offset' => $offset
        ];
    }
    
    /**
     * Build pagination meta
     */
    protected function buildPaginationMeta($total, $page, $limit) {
        $totalPages = ceil($total / $limit);
        
        return [
            'total' => $total,
            'page' => $page,
            'limit' => $limit,
            'total_pages' => $totalPages,
            'has_next' => $page < $totalPages,
            'has_prev' => $page > 1
        ];
    }
    
    /**
     * Get authenticated user
     */
    protected function getCurrentUser() {
        static $user = null;
        
        if ($user === null) {
            $user = Middleware::auth();
        }
        
        return $user;
    }
    
    /**
     * Check user permission
     */
    protected function checkPermission($requiredRole) {
        $user = $this->getCurrentUser();
        
        $roleHierarchy = [
            ROLE_SUPER_ADMIN => 1,
            ROLE_ADMIN => 2,
            ROLE_UNIT_HEAD => 3,
            ROLE_BRANCH_HEAD => 4,
            ROLE_SUPERVISOR => 5,
            ROLE_COLLECTOR => 6,
            ROLE_CASHIER => 6,
            ROLE_MEMBER => 7,
            ROLE_GUEST => 8
        ];
        
        $userLevel = $roleHierarchy[$user['role']] ?? 8;
        $requiredLevel = $roleHierarchy[$requiredRole] ?? 8;
        
        if ($userLevel > $requiredLevel) {
            ApiResponse::error('Insufficient permissions', 403);
        }
    }
    
    /**
     * Log API activity
     */
    protected function logActivity($action, $details = []) {
        $user = $this->getCurrentUser();
        
        Logger::info("API Activity: {$action}", [
            'user_id' => $user['user_id'] ?? null,
            'user_role' => $user['role'] ?? null,
            'action' => $action,
            'details' => $details,
            'ip' => $_SERVER['REMOTE_ADDR'] ?? 'unknown'
        ]);
    }
    
    /**
     * Handle file upload
     */
    protected function handleFileUpload($fieldName, $allowedTypes = ALLOWED_FILE_TYPES, $maxSize = MAX_FILE_SIZE) {
        if (!isset($_FILES[$fieldName])) {
            return null;
        }
        
        $file = $_FILES[$fieldName];
        
        if ($file['error'] !== UPLOAD_ERR_OK) {
            ApiResponse::error('File upload failed', 400, ['upload_error' => $file['error']]);
        }
        
        if ($file['size'] > $maxSize) {
            ApiResponse::error('File too large', 400);
        }
        
        $fileExtension = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        
        if (!in_array($fileExtension, $allowedTypes)) {
            ApiResponse::error('File type not allowed', 400);
        }
        
        $fileName = generateRandomString() . '.' . $fileExtension;
        $uploadPath = UPLOAD_PATH . $fileName;
        
        if (!move_uploaded_file($file['tmp_name'], $uploadPath)) {
            ApiResponse::error('Failed to save file', 500);
        }
        
        return [
            'name' => $file['name'],
            'path' => $uploadPath,
            'size' => $file['size'],
            'type' => $fileExtension
        ];
    }
    
    /**
     * Send success response with data
     */
    protected function success($data = null, $message = 'Success', $meta = null) {
        ApiResponse::send($data, $message, 200, $meta);
    }
    
    /**
     * Send error response
     */
    protected function error($message, $status = 400, $errors = null) {
        ApiResponse::error($message, $status, $errors);
    }
    
    /**
     * Send not found response
     */
    protected function notFound($message = 'Resource not found') {
        ApiResponse::error($message, 404);
    }
    
    /**
     * Send unauthorized response
     */
    protected function unauthorized($message = 'Unauthorized') {
        ApiResponse::error($message, 401);
    }
    
    /**
     * Send forbidden response
     */
    protected function forbidden($message = 'Forbidden') {
        ApiResponse::error($message, 403);
    }
}

// ================================================================
// DISPATCH REQUEST
// ================================================================

$router = new Router($routes, $method, $uri);
$router->dispatch();

?>
