<?php
/**
 * Index file untuk Aplikasi Koperasi Berjalan
 * Redirect ke dashboard atau login page
 */

session_start();

// Load device detection
require_once __DIR__ . '/config/device_detection.php';
require_once __DIR__ . '/config/indonesia_config.php';

// Redirect ke dashboard jika sudah login
if (isset($_SESSION['user']['id'])) {
    // Redirect sesuai device dan role
    if ($deviceDetection->getDeviceType() === 'mobile' && $deviceDetection->getUserRole() === 'collector') {
        header('Location: /pages/mobile/dashboard.php');
    } else {
        header('Location: /pages/web/dashboard.php');
    }
    exit;
}

// Redirect ke login page
header('Location: /pages/login.php');
exit;
?>
