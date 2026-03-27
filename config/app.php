<?php
/**
 * Application Configuration
 * Koperasi Berjalan - Digital Cooperative Management System
 */

// Application Constants
define('APP_NAME', 'Koperasi Berjalan');
define('APP_VERSION', '1.0.0');
define('APP_DESCRIPTION', 'Aplikasi Digital Koperasi Simpan Pinjam');
define('APP_AUTHOR', 'Cascade AI Assistant');

// Environment Configuration
define('ENVIRONMENT', 'development'); // development, staging, production
define('DEBUG_MODE', true);
define('ERROR_REPORTING', E_ALL);

// URL Configuration
define('BASE_URL', 'http://localhost/gabe/');
define('ASSETS_URL', BASE_URL . 'assets/');
define('PAGES_URL', BASE_URL . 'pages/');

// Session Configuration
define('SESSION_NAME', 'KOPERASI_SESSION');
define('SESSION_LIFETIME', 7200); // 2 hours in seconds
define('SESSION_PATH', '/gabe/');
define('SESSION_DOMAIN', 'localhost');

// Security Configuration
define('HASH_ALGORITHM', PASSWORD_DEFAULT);
define('MIN_PASSWORD_LENGTH', 6);
define('MAX_LOGIN_ATTEMPTS', 5);
define('LOGIN_TIMEOUT', 900); // 15 minutes

// Database Configuration (for future use)
define('DB_HOST', 'localhost');
define('DB_NAME', 'koperasi_berjalan');
define('DB_USER', 'root');
define('DB_PASSWORD', '');
define('DB_CHARSET', 'utf8mb4');

// File Upload Configuration
define('UPLOAD_MAX_SIZE', 5242880); // 5MB in bytes
define('UPLOAD_ALLOWED_TYPES', ['jpg', 'jpeg', 'png', 'gif', 'pdf']);
define('UPLOAD_PATH', __DIR__ . '/../uploads/');

// PWA Configuration
define('PWA_ENABLED', true);
define('PWA_CACHE_VERSION', 'v1.0.0');
define('PWA_OFFLINE_ENABLED', true);

// Performance Configuration
define('CACHE_ENABLED', true);
define('CACHE_LIFETIME', 3600); // 1 hour
define('COMPRESSION_ENABLED', true);

// Logging Configuration
define('LOG_ENABLED', true);
define('LOG_LEVEL', 'INFO'); // DEBUG, INFO, WARNING, ERROR
define('LOG_PATH', __DIR__ . '/../logs/');

// Feature Flags
define('FEATURE_API', false); // API endpoints
define('FEATURE_DATABASE', false); // Database integration
define('FEATURE_REPORTS', false); // Advanced reporting
define('FEATURE_ANALYTICS', false); // Analytics dashboard

// User Roles Configuration
define('ROLES', [
    'bos' => 'Administrator',
    'unit_head' => 'Manager Unit', 
    'branch_head' => 'Kepala Cabang',
    'collector' => 'Kolektor',
    'cashir' => 'Kasir',
    'staff' => 'Staff Administrasi'
]);

// Quick Login Demo Users (for development)
define('DEMO_USERS', [
    'admin' => [
        'username' => 'admin',
        'password' => 'admin',
        'name' => 'Administrator',
        'role' => 'bos',
        'branch_id' => 1,
        'branch_name' => 'Pusat'
    ],
    'manager' => [
        'username' => 'manager',
        'password' => 'manager', 
        'name' => 'Manager Unit',
        'role' => 'unit_head',
        'branch_id' => 1,
        'branch_name' => 'Pusat'
    ],
    'branch_head' => [
        'username' => 'branch_head',
        'password' => 'branch_head',
        'name' => 'Kepala Cabang',
        'role' => 'branch_head',
        'branch_id' => 2,
        'branch_name' => 'Cabang Jakarta'
    ],
    'collector' => [
        'username' => 'collector',
        'password' => 'collector',
        'name' => 'Petugas Kolektor',
        'role' => 'collector',
        'branch_id' => 2,
        'branch_name' => 'Cabang Jakarta'
    ],
    'cashier' => [
        'username' => 'cashier',
        'password' => 'cashier',
        'name' => 'Kasir',
        'role' => 'cashir',
        'branch_id' => 1,
        'branch_name' => 'Pusat'
    ],
    'staff' => [
        'username' => 'staff',
        'password' => 'staff',
        'name' => 'Staff Administrasi',
        'role' => 'staff',
        'branch_id' => 1,
        'branch_name' => 'Pusat'
    ]
]);

// Error Handling
if (DEBUG_MODE) {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
} else {
    error_reporting(0);
    ini_set('display_errors', 0);
}

// Timezone
date_default_timezone_set('Asia/Jakarta');

// Character Encoding
mb_internal_encoding('UTF-8');

// Security Headers (if needed)
if (!headers_sent()) {
    header('X-Content-Type-Options: nosniff');
    header('X-Frame-Options: SAMEORIGIN');
    header('X-XSS-Protection: 1; mode=block');
    header('Referrer-Policy: strict-origin-when-cross-origin');
}

?>
