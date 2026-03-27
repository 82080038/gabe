<?php
/**
 * Loans Management Page
 * Manage cooperative loans
 */

// Start session
session_start();

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

// Check role permission
if ($_SESSION['user']['role'] !== 'bos' && $_SESSION['user']['role'] !== 'unit_head' && $_SESSION['user']['role'] !== 'branch_head') {
    header('Location: /gabe/pages/web/dashboard.php');
    exit;
}

require_once __DIR__ . '/template_header.php';

// Set page specific variables
$pageTitle = 'Manajemen Pinjaman';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Pinjaman', 'url' => '#']
];

// Mock data for loans
$loans = [
    [
        'id' => 1,
        'loan_number' => 'PJ001',
        'member_name' => 'Bapak Ahmad Wijaya',
        'member_number' => 'KOP001',
        'product_name' => 'Pinjaman Regular',
        'principal_amount' => 5000000,
        'interest_rate' => 24,
        'loan_term' => 12,
        'disbursement_date' => '2024-01-15',
        'first_payment_date' => '2024-02-15',
        'status' => 'active',
        'outstanding_balance' => 4200000,
        'monthly_installment' => 450000,
        'paid_installments' => 2,
        'total_installments' => 12,
        'branch' => 'Cabang Jakarta Selatan'
    ],
    [
        'id' => 2,
        'loan_number' => 'PJ002',
        'member_name' => 'Ibu Siti Nurhaliza',
        'member_number' => 'KOP002',
        'product_name' => 'Pinjaman Express',
        'principal_amount' => 3000000,
        'interest_rate' => 30,
        'loan_term' => 6,
        'disbursement_date' => '2024-02-20',
        'first_payment_date' => '2024-03-20',
        'status' => 'active',
        'outstanding_balance' => 2500000,
        'monthly_installment' => 550000,
        'paid_installments' => 1,
        'total_installments' => 6,
        'branch' => 'Cabang Jakarta Selatan'
    ],
    [
        'id' => 3,
        'loan_number' => 'PJ003',
        'member_name' => 'Bapak Budi Santoso',
        'member_number' => 'KOP003',
        'product_name' => 'Pinjaman Modal Usaha',
        'principal_amount' => 10000000,
        'interest_rate' => 18,
        'loan_term' => 24,
        'disbursement_date' => '2024-03-10',
        'first_payment_date' => '2024-04-10',
        'status' => 'pending',
        'outstanding_balance' => 10000000,
        'monthly_installment' => 500000,
        'paid_installments' => 0,
        'total_installments' => 24,
        'branch' => 'Cabang Jakarta Pusat'
    ]
];

// Handle different actions
$action = $_GET['action'] ?? 'list';

switch ($action) {
    case 'apply':
        include 'loans/add.php';
        break;
    case 'add':
        include 'loans/add.php';
        break;
    case 'edit':
        include 'loans/edit.php';
        break;
    case 'view':
        include 'loans/view.php';
        break;
    case 'schedules':
        include 'loans/schedules.php';
        break;
    case 'products':
        include 'loans/products.php';
        break;
    case 'approval':
        include 'loans/approval.php';
        break;
    default:
        include 'loans/list.php';
        break;
}
?>
