<?php
// Simulate direct dashboard access with session
session_start();

echo "=== DASHBOARD ACCESS SIMULATION ===\n\n";

// Manually set session like login would do
$_SESSION['user'] = [
    'id' => 1,
    'username' => 'admin',
    'name' => 'Administrator',
    'role' => 'bos',
    'branch_id' => 1,
    'branch_name' => 'Pusat'
];

echo "✓ Session manually set\n";
echo "✓ User ID: " . $_SESSION['user']['id'] . "\n";
echo "✓ Role: " . $_SESSION['user']['role'] . "\n\n";

// Now test dashboard access logic
echo "=== DASHBOARD ACCESS LOGIC TEST ===\n";

// This simulates the check in dashboard.php
if (!isset($_SESSION['user']['id'])) {
    echo "✗ Would redirect to login (no session)\n";
    exit;
}

echo "✓ Authentication check passed\n";

// Load dashboard content
require_once 'pages/web/dashboard.php';

echo "\n✓ Dashboard content loaded successfully\n";
?>
