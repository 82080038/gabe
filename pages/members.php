<?php
/**
 * Members Management Page
 * Manage cooperative members
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
$pageTitle = 'Manajemen Anggota';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Anggota', 'url' => '#']
];

// Mock data for members
$members = [
    [
        'id' => 1,
        'member_number' => 'KOP001',
        'name' => 'Bapak Ahmad Wijaya',
        'nik' => '1234567890123456',
        'birth_date' => '1980-05-15',
        'phone' => '0812-3456-7890',
        'address' => 'Jl. Merdeka No. 123, RT 02/RW 03, Tebet, Jakarta Selatan',
        'branch' => 'Cabang Jakarta Selatan',
        'join_date' => '2024-01-15',
        'status' => 'active',
        'kewer_amount' => 50000,
        'mawar_amount' => 150000,
        'sukarela_amount' => 0,
        'loan_balance' => 2500000,
        'savings_balance' => 1200000
    ],
    [
        'id' => 2,
        'member_number' => 'KOP002',
        'name' => 'Ibu Siti Nurhaliza',
        'nik' => '2345678901234567',
        'birth_date' => '1985-08-22',
        'phone' => '0813-2345-6789',
        'address' => 'Jl. Sudirman No. 456, RT 01/RW 05, Kebayoran, Jakarta Selatan',
        'branch' => 'Cabang Jakarta Selatan',
        'join_date' => '2024-02-20',
        'status' => 'active',
        'kewer_amount' => 75000,
        'mawar_amount' => 200000,
        'sukarela_amount' => 100000,
        'loan_balance' => 3000000,
        'savings_balance' => 1800000
    ],
    [
        'id' => 3,
        'member_number' => 'KOP003',
        'name' => 'Bapak Budi Santoso',
        'nik' => '3456789012345678',
        'birth_date' => '1978-12-10',
        'phone' => '0814-3456-7890',
        'address' => 'Jl. Gatotkaca No. 789, RT 03/RW 02, Pancoran, Jakarta Selatan',
        'branch' => 'Cabang Jakarta Pusat',
        'join_date' => '2024-03-10',
        'status' => 'active',
        'kewer_amount' => 60000,
        'mawar_amount' => 180000,
        'sukarela_amount' => 50000,
        'loan_balance' => 1500000,
        'savings_balance' => 950000
    ]
];

// Handle different actions
$action = $_GET['action'] ?? 'list';

switch ($action) {
    case 'add':
        include 'members/add.php';
        break;
    case 'edit':
        include 'members/edit.php';
        break;
    case 'view':
        include 'members/view.php';
        break;
    case 'family':
        include 'members/family.php';
        break;
    case 'import':
        include 'members/import.php';
        break;
    default:
        include 'members/list.php';
        break;
}
?>
