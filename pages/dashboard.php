<?php
/**
 * Main Dashboard Router
 * Arahkan ke dashboard yang sesuai berdasarkan role dan device
 */

session_start();

// Check authentication
if (!isset($_SESSION['user']['id'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

// Load device detection
require_once __DIR__ . '/../config/device_detection.php';

// Get user role and device type
$userRole = $_SESSION['user']['role'];
$deviceType = $deviceDetection->getDeviceType();

// Route to appropriate dashboard
if ($deviceType === 'mobile' && $userRole === 'collector') {
    // Mobile collector dashboard
    header('Location: /gabe/pages/mobile/dashboard.php');
} elseif ($deviceType === 'mobile') {
    // Mobile dashboard for other roles
    header('Location: /gabe/pages/mobile/dashboard.php');
} else {
    // Web dashboard
    header('Location: /gabe/pages/web/dashboard.php');
}

exit;
?>
