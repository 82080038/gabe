<?php
// Database connection
$db_host = 'localhost';
$db_user = 'root';
$db_pass = 'root';
$db_name = 'schema_app';
$socket = '/opt/lampp/var/mysql/mysql.sock';

try {
    $pdo = new PDO("mysql:host=$db_host;unix_socket=$socket;dbname=$db_name", $db_user, $db_pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Users and their passwords
    $users = [
        'admin' => 'admin',
        'manager' => 'manager', 
        'branch_head' => 'branch_head',
        'collector' => 'collector',
        'cashier' => 'cashier',
        'staff' => 'staff'
    ];
    
    foreach ($users as $username => $password) {
        $hash = password_hash($password, PASSWORD_DEFAULT);
        
        $stmt = $pdo->prepare("UPDATE users SET password = :password WHERE username = :username");
        $stmt->bindParam(':password', $hash);
        $stmt->bindParam(':username', $username);
        $stmt->execute();
        
        echo "Updated password for: $username\n";
    }
    
    echo "All passwords updated successfully!\n";
    
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
