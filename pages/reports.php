<?php
/**
 * Reports Management Page
 * Generate and view various reports
 */

// Start session
session_start();

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

require_once __DIR__ . '/template_header.php';

// Set page specific variables
$pageTitle = 'Laporan';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Laporan', 'url' => '#']
];

// Handle different actions
$action = $_GET['action'] ?? 'summary';

switch ($action) {
    case 'loans':
        include 'reports/loans.php';
        break;
    case 'savings':
        include 'reports/savings.php';
        break;
    case 'cash':
        include 'reports/cash.php';
        break;
    case 'collections':
        include 'reports/collections.php';
        break;
    case 'financial':
        include 'reports/financial.php';
        break;
    case 'ojk':
        include 'reports/ojk.php';
        break;
    case 'audit':
        include 'reports/audit.php';
        break;
    default:
        include 'reports/summary.php';
        break;
}
?>
