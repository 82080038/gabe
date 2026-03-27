<?php
/**
 * Settings Page
 */

// Start session
session_start();

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

// Check admin permission
if ($_SESSION['user']['role'] !== 'bos') {
    header('Location: /gabe/pages/web/dashboard.php');
    exit;
}

require_once __DIR__ . '/template_header.php';

// Set page specific variables
$pageTitle = 'Pengaturan Sistem';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Sistem', 'url' => '#']
];

// Handle different actions
$action = $_GET['action'] ?? 'general';

switch ($action) {
    case 'users':
        include 'settings/users.php';
        break;
    case 'roles':
        include 'settings/roles.php';
        break;
    case 'backup':
        include 'settings/backup.php';
        break;
    case 'logs':
        include 'settings/logs.php';
        break;
    case 'maintenance':
        include 'settings/maintenance.php';
        break;
    default:
        include 'settings/general.php';
        break;
}
?>

</main>
<!-- Footer -->
<footer class="bg-light text-center text-lg-start mt-5">
    <div class="text-center p-3" style="background-color: rgba(0, 0, 0, 0.2);">
        © 2024 Koperasi Berjalan - Aplikasi Digital Koperasi
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="/gabe/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
