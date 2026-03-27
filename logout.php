<?php
/**
 * Logout handler untuk Aplikasi Koperasi Berjalan
 */

session_start();

// Hapus semua session data
session_unset();
session_destroy();

// Redirect ke login page
header('Location: /gabe/pages/login.php');
exit;
?>
