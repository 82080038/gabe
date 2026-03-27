<?php
session_start();

// Simulate admin login
$_SESSION['user'] = [
    'id' => 1,
    'username' => 'admin',
    'name' => 'Administrator',
    'role' => 'bos',
    'branch_id' => 1,
    'branch_name' => 'Pusat'
];

echo "Session set: ";
print_r($_SESSION);

// Now test units page
echo "\n\n=== Testing Units Page ===\n";
include 'pages/units.php';

echo "\n\n=== Testing Branches Page ===\n";
include 'pages/branches.php';

echo "\n\n=== Testing Members Page ===\n";
include 'pages/members.php';
?>
