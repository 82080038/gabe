<?php
/**
 * Logout handler untuk Aplikasi Koperasi Berjalan
 */

// Start session (check if already started)
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Hapus semua session data
session_unset();
session_destroy();

// Redirect ke login page
header('Location: /gabe/pages/login.php');
exit;
?>
