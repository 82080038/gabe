<?php
/**
 * Savings Management Page
 * Manage cooperative savings
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
$pageTitle = 'Manajemen Simpanan';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Simpanan', 'url' => '#']
];

// Mock data for savings
$savings = [
    [
        'id' => 1,
        'member_name' => 'Bapak Ahmad Wijaya',
        'member_number' => 'KOP001',
        'savings_type' => 'kewer',
        'daily_amount' => 50000,
        'monthly_target' => 1500000,
        'current_month_collected' => 1200000,
        'last_deposit_date' => '2024-03-27',
        'total_balance' => 18000000,
        'branch' => 'Cabang Jakarta Selatan'
    ],
    [
        'id' => 2,
        'member_name' => 'Ibu Siti Nurhaliza',
        'member_number' => 'KOP002',
        'savings_type' => 'mawar',
        'monthly_amount' => 200000,
        'current_month_collected' => 200000,
        'last_deposit_date' => '2024-03-25',
        'total_balance' => 4800000,
        'branch' => 'Cabang Jakarta Selatan'
    ],
    [
        'id' => 3,
        'member_name' => 'Bapak Budi Santoso',
        'member_number' => 'KOP003',
        'savings_type' => 'sukarela',
        'last_deposit_amount' => 100000,
        'last_deposit_date' => '2024-03-20',
        'total_balance' => 2500000,
        'branch' => 'Cabang Jakarta Pusat'
    ]
];

// Handle different actions
$action = $_GET['action'] ?? 'kewer';

switch ($action) {
    case 'mawar':
        include 'savings/mawar.php';
        break;
    case 'sukarela':
        include 'savings/sukarela.php';
        break;
    case 'products':
        include 'savings/products.php';
        break;
    case 'withdrawal':
        include 'savings/withdrawal.php';
        break;
    case 'deposit':
        include 'savings/deposit.php';
        break;
    default:
        include 'savings/kewer.php';
        break;
}
?>
