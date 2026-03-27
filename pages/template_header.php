<?php
/**
 * Template Header untuk Aplikasi Koperasi Berjalan
 * Mendukung penuh bahasa Indonesia dan lokasi Indonesia
 */

// Load konfigurasi Indonesia
require_once __DIR__ . '/../config/indonesia_config.php';

// Set headers untuk bahasa Indonesia
header('Content-Language: id');
header('Content-Type: text/html; charset=UTF-8');

// Meta tags untuk lokasi Indonesia
$metaTags = IndonesiaConfig::generateMetaTags();
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Language" content="id">
    <meta name="language" content="Indonesian">
    <meta name="geo.country" content="ID">
    <meta name="geo.region" content="ID">
    <meta name="geo.placename" content="Indonesia">
    <meta property="og:locale" content="id_ID">
    <meta name="author" content="Aplikasi Koperasi Berjalan">
    <meta name="description" content="Aplikasi digital untuk koperasi berjalan dengan sistem Kewer-Mawar">
    
    <title><?php echo $pageTitle ?? 'Aplikasi Koperasi Berjalan'; ?></title>
    
    <!-- CSS Indonesia Theme -->
    <link href="/gabe/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="/gabe/assets/css/indonesia-theme.css" rel="stylesheet">
    <link href="/gabe/assets/css/fontawesome.min.css" rel="stylesheet">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="/gabe/assets/images/favicon.ico">
    
    <!-- Indonesia Formatter JS -->
    <script src="/gabe/assets/js/indonesia-formatter.js"></script>
    
    <?php if (isset($customCSS)): ?>
    <style><?php echo $customCSS; ?></style>
    <?php endif; ?>
    
    <style>
    .navbar-toggler-icon {
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%280, 0, 0, 0.55%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
    }
    
    @media (max-width: 768px) {
        .navbar-nav {
            text-align: center;
        }
        .navbar-nav .nav-item {
            margin: 0.5rem 0;
        }
        .dropdown-menu {
            text-align: center;
        }
    }
    </style>
</head>
<body class="bg-light">
    <!-- Navigation Header -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="/gabe/pages/web/dashboard.php">
                <i class="fas fa-store"></i> Koperasi Berjalan
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/gabe/pages/web/dashboard.php">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    
                    <?php if ($_SESSION['user']['role'] === 'bos' || $_SESSION['user']['role'] === 'unit_head'): ?>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="unitDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-building"></i> Unit
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/units">Daftar Unit</a></li>
                            <li><a class="dropdown-item" href="/units/add">Tambah Unit</a></li>
                        </ul>
                    </li>
                    <?php endif; ?>
                    
                    <?php if ($_SESSION['user']['role'] === 'bos' || $_SESSION['user']['role'] === 'unit_head' || $_SESSION['user']['role'] === 'branch_head'): ?>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="branchDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-home"></i> Cabang
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/branches">Daftar Cabang</a></li>
                            <?php if ($_SESSION['user']['role'] !== 'branch_head'): ?>
                            <li><a class="dropdown-item" href="/branches/add">Tambah Cabang</a></li>
                            <?php endif; ?>
                        </ul>
                    </li>
                    <?php endif; ?>
                    
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="memberDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-users"></i> Anggota
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/members">Daftar Anggota</a></li>
                            <li><a class="dropdown-item" href="/members/add">Tambah Anggota</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/members/family">Hubungan Keluarga</a></li>
                        </ul>
                    </li>
                    
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="loanDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-hand-holding-usd"></i> Pinjaman
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/loans">Daftar Pinjaman</a></li>
                            <li><a class="dropdown-item" href="/loans/apply">Ajukan Pinjaman</a></li>
                            <li><a class="dropdown-item" href="/loans/schedules">Jadwal Angsuran</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/loans/products">Produk Pinjaman</a></li>
                        </ul>
                    </li>
                    
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="savingsDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-piggy-bank"></i> Simpanan
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/savings/kewer">Kewer (Harian)</a></li>
                            <li><a class="dropdown-item" href="/savings/mawar">Mawar (Bulanan)</a></li>
                            <li><a class="dropdown-item" href="/savings/sukarela">Sukarela</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/savings/products">Produk Simpanan</a></li>
                        </ul>
                    </li>
                    
                    <?php if ($_SESSION['user']['role'] === 'collector'): ?>
                    <li class="nav-item">
                        <a class="nav-link" href="/collector/route">
                            <i class="fas fa-route"></i> Rute Hari Ini
                        </a>
                    </li>
                    <?php endif; ?>
                    
                    <?php if ($_SESSION['user']['role'] === 'cashir'): ?>
                    <li class="nav-item">
                        <a class="nav-link" href="/cashier">
                            <i class="fas fa-cash-register"></i> Kasir
                        </a>
                    </li>
                    <?php endif; ?>
                    
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="reportDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-chart-bar"></i> Laporan
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="/reports/summary">Ringkasan</a></li>
                            <li><a class="dropdown-item" href="/reports/loans">Pinjaman</a></li>
                            <li><a class="dropdown-item" href="/reports/savings">Simpanan</a></li>
                            <li><a class="dropdown-item" href="/reports/cash">Arus Kas</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/reports/financial">Keuangan</a></li>
                            <li><a class="dropdown-item" href="/reports/ojk">Laporan OJK</a></li>
                        </ul>
                    </li>
                </ul>
                
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user"></i> <?php echo htmlspecialchars($_SESSION['user']['name']); ?>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="/gabe/pages/profile.php">
                                <i class="fas fa-user-cog"></i> Profil
                            </a></li>
                            <li><a class="dropdown-item" href="/gabe/pages/settings.php">
                                <i class="fas fa-cog"></i> Pengaturan
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="/gabe/logout.php">
                                <i class="fas fa-sign-out-alt"></i> Keluar
                            </a></li>
                        </ul>
                    </li>
                    
                    <li class="nav-item">
                        <span class="navbar-text">
                            <i class="fas fa-map-marker-alt"></i> 
                            <?php echo htmlspecialchars($_SESSION['user']['branch_name'] ?? 'Pusat'); ?>
                        </span>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Flash Messages -->
    <?php if (isset($_SESSION['flash_message'])): ?>
    <div class="alert alert-<?php echo $_SESSION['flash_type'] ?? 'info'; ?> alert-dismissible fade show m-3" role="alert">
        <?php 
        echo $_SESSION['flash_message'];
        unset($_SESSION['flash_message']);
        unset($_SESSION['flash_type']);
        ?>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <?php endif; ?>
    
    <!-- Breadcrumb -->
    <?php if (isset($breadcrumbs) && !empty($breadcrumbs)): ?>
    <nav aria-label="breadcrumb" class="m-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="/gabe/pages/web/dashboard.php"><i class="fas fa-home"></i> Beranda</a>
            </li>
            <?php foreach ($breadcrumbs as $index => $breadcrumb): ?>
                <?php if ($index === count($breadcrumbs) - 1): ?>
                    <li class="breadcrumb-item active" aria-current="page">
                        <?php echo htmlspecialchars($breadcrumb['title']); ?>
                    </li>
                <?php else: ?>
                    <li class="breadcrumb-item">
                        <a href="<?php echo htmlspecialchars($breadcrumb['url']); ?>">
                            <?php echo htmlspecialchars($breadcrumb['title']); ?>
                        </a>
                    </li>
                <?php endif; ?>
            <?php endforeach; ?>
        </ol>
    </nav>
    <?php endif; ?>

<!-- Main Content -->
<main class="container-fluid p-3">
