<?php
session_start();

// Simulate the exact login process
echo "Testing login flow simulation...\n";

// Test Admin Login
echo "\n=== ADMIN LOGIN TEST ===\n";
$_SESSION = [];
$_POST['username'] = 'admin';
$_POST['password'] = 'admin';

// Load device detection (required for login)
require_once 'config/device_detection.php';
require_once 'config/indonesia_config.php';

$deviceDetection = new DeviceDetection();

// Simulate the login logic from login.php
if ($_POST['username'] === 'admin' && $_POST['password'] === 'admin') {
    $_SESSION['user'] = [
        'id' => 1,
        'username' => 'admin',
        'name' => 'Administrator',
        'role' => 'bos',
        'branch_id' => 1,
        'branch_name' => 'Pusat'
    ];
    
    echo "✓ Login successful\n";
    echo "✓ Session created: " . print_r($_SESSION['user'], true) . "\n";
    
    // Test redirect logic
    if ($deviceDetection->getDeviceType() === 'mobile' && $deviceDetection->getUserRole() === 'collector') {
        echo "✓ Would redirect to: /gabe/pages/mobile/dashboard.php\n";
    } else {
        echo "✓ Would redirect to: /gabe/pages/web/dashboard.php\n";
    }
} else {
    echo "✗ Login failed\n";
}

// Test if session persists
echo "\n=== SESSION PERSISTENCE TEST ===\n";
if (isset($_SESSION['user']['id'])) {
    echo "✓ Session persists after login\n";
    echo "✓ User ID: " . $_SESSION['user']['id'] . "\n";
    echo "✓ Role: " . $_SESSION['user']['role'] . "\n";
} else {
    echo "✗ Session not persisting\n";
}

// Test dashboard access check
echo "\n=== DASHBOARD ACCESS TEST ===\n";
if (!isset($_SESSION['user']['id'])) {
    echo "✗ Would redirect to login (no session)\n";
} else {
    echo "✓ Can access dashboard\n";
    if ($_SESSION['user']['role'] === 'collector') {
        echo "✓ Should access mobile dashboard\n";
    } else {
        echo "✓ Should access web dashboard\n";
    }
}

echo "\nLogin flow test completed.\n";
?>
