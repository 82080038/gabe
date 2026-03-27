<?php
/**
 * Index file untuk Aplikasi Koperasi Berjalan
 * Redirect ke dashboard atau login page
 */

// Start session (check if already started)
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Load device detection
require_once __DIR__ . '/config/device_detection.php';
require_once __DIR__ . '/config/indonesia_config.php';

// Redirect ke dashboard jika sudah login
if (isset($_SESSION['user']['id'])) {
    // Redirect sesuai device dan role
    if ($deviceDetection->getDeviceType() === 'mobile' && $deviceDetection->getUserRole() === 'collector') {
        header('Location: /gabe/pages/mobile/dashboard.php');
    } else {
        header('Location: /gabe/pages/web/dashboard.php');
    }
    exit;
}

// Redirect ke login page
header('Location: /gabe/pages/login.php');
exit;
?>
