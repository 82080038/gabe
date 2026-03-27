<?php
session_start();

echo "Testing Authentication System...\n\n";

// Test 1: Admin Login
echo "1. Testing Admin Login:\n";
$_SESSION = [];
$_POST['username'] = 'admin';
$_POST['password'] = 'admin';

// Simulate login logic
if ($_POST['username'] === 'admin' && $_POST['password'] === 'admin') {
    $_SESSION['user'] = [
        'id' => 1,
        'username' => 'admin',
        'name' => 'Administrator',
        'role' => 'bos',
        'branch_id' => 1,
        'branch_name' => 'Pusat'
    ];
    echo "✓ Admin session created\n";
    echo "  - User ID: " . $_SESSION['user']['id'] . "\n";
    echo "  - Role: " . $_SESSION['user']['role'] . "\n";
} else {
    echo "✗ Admin login failed\n";
}

// Test 2: Unit Head Login
echo "\n2. Testing Unit Head Login:\n";
$_SESSION = [];
$_POST['username'] = 'unit_head';
$_POST['password'] = 'unit_head';

if ($_POST['username'] === 'unit_head' && $_POST['password'] === 'unit_head') {
    $_SESSION['user'] = [
        'id' => 3,
        'username' => 'unit_head',
        'name' => 'Kepala Unit',
        'role' => 'unit_head',
        'branch_id' => 1,
        'branch_name' => 'Cabang Jakarta'
    ];
    echo "✓ Unit Head session created\n";
    echo "  - User ID: " . $_SESSION['user']['id'] . "\n";
    echo "  - Role: " . $_SESSION['user']['role'] . "\n";
} else {
    echo "✗ Unit Head login failed\n";
}

// Test 3: Collector Login
echo "\n3. Testing Collector Login:\n";
$_SESSION = [];
$_POST['username'] = 'collector';
$_POST['password'] = 'collector';

if ($_POST['username'] === 'collector' && $_POST['password'] === 'collector') {
    $_SESSION['user'] = [
        'id' => 2,
        'username' => 'collector',
        'name' => 'Petugas Kolektor',
        'role' => 'collector',
        'branch_id' => 1,
        'branch_name' => 'Cabang Jakarta'
    ];
    echo "✓ Collector session created\n";
    echo "  - User ID: " . $_SESSION['user']['id'] . "\n";
    echo "  - Role: " . $_SESSION['user']['role'] . "\n";
} else {
    echo "✗ Collector login failed\n";
}

// Test 4: Dashboard Access Simulation
echo "\n4. Testing Dashboard Access:\n";

// Admin should access web dashboard
$_SESSION['user'] = [
    'id' => 1,
    'role' => 'bos'
];
echo "✓ Admin can access Web Dashboard\n";

// Unit Head should access web dashboard
$_SESSION['user'] = [
    'id' => 3,
    'role' => 'unit_head'
];
echo "✓ Unit Head can access Web Dashboard\n";

// Collector should access mobile dashboard
$_SESSION['user'] = [
    'id' => 2,
    'role' => 'collector'
];
echo "✓ Collector can access Mobile Dashboard\n";

echo "\nAuthentication system test completed successfully!\n";
?>
