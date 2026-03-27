<?php
session_start();

// Test different user roles
$roles = [
    'admin' => ['username' => 'admin', 'password' => 'admin', 'expected_role' => 'bos'],
    'unit_head' => ['username' => 'unit_head', 'password' => 'unit_head', 'expected_role' => 'unit_head'],
    'collector' => ['username' => 'collector', 'password' => 'collector', 'expected_role' => 'collector']
];

foreach ($roles as $role_name => $credentials) {
    echo "Testing $role_name...\n";
    
    // Simulate login
    $_POST['username'] = $credentials['username'];
    $_POST['password'] = $credentials['password'];
    
    // Load login logic
    include 'pages/login.php';
    
    // Check session
    if (isset($_SESSION['user'])) {
        echo "✓ $role_name login successful\n";
        echo "  - Role: " . $_SESSION['user']['role'] . "\n";
        echo "  - Name: " . $_SESSION['user']['name'] . "\n";
        
        // Test dashboard access
        if ($credentials['expected_role'] === 'collector') {
            echo "  - Expected: Mobile Dashboard\n";
        } else {
            echo "  - Expected: Web Dashboard\n";
        }
        
        // Clear session for next test
        session_destroy();
        session_start();
    } else {
        echo "✗ $role_name login failed\n";
    }
    
    echo "\n";
    // Clear POST
    $_POST = [];
}

echo "Authentication test completed.\n";
?>
