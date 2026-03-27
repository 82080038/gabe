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

// Redirect to dashboard
header('Location: /gabe/pages/web/dashboard.php');
exit;
?>
