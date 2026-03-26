<?php
/**
 * Mobile Dashboard untuk Kolektor
 * PWA-enabled dengan touch-friendly interface
 */

require_once __DIR__ . '/../template_header.php';

// Set page specific variables
$pageTitle = 'Dashboard Kolektor';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/dashboard']
];

// Add mobile-specific meta tags
echo '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">';
echo '<meta name="apple-mobile-web-app-capable" content="yes">';
echo '<meta name="apple-mobile-web-app-status-bar-style" content="default">';
echo '<meta name="theme-color" content="#667eea">';

// Get today's route data (mock data for now)
$todayRoute = [];
$summary = [
    'total_visited' => 12,
    'total_collected' => 2500000,
    'pending_count' => 3
];
?>

<div class="container-fluid p-0 mobile-dashboard">
    <!-- Header dengan summary -->
    <div class="summary-card text-white p-3 mb-3">
        <div class="row text-center">
            <div class="col-4">
                <h4 class="mb-1" id="visited-count"><?php echo $summary['total_visited']; ?></h4>
                <small class="opacity-75">Dikunjungi</small>
            </div>
            <div class="col-4">
                <h4 class="mb-1" id="collected-amount"><?php echo number_format($summary['total_collected'], 0, ',', '.'); ?></h4>
                <small class="opacity-75">Terkumpul</small>
            </div>
            <div class="col-4">
                <h4 class="mb-1" id="pending-count"><?php echo $summary['pending_count']; ?></h4>
                <small class="opacity-75">Belum Bayar</small>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="row mb-3">
        <div class="col-6">
            <a href="/collector/route" class="btn btn-primary btn-block btn-lg btn-mobile-action touch-feedback">
                <i class="fas fa-route icon-large"></i>
                <small>Mulai Rute</small>
            </a>
        </div>
        <div class="col-6">
            <a href="/collector/payments" class="btn btn-success btn-block btn-lg btn-mobile-action touch-feedback">
                <i class="fas fa-money-bill icon-large"></i>
                <small>Pembayaran</small>
            </a>
        </div>
    </div>

    <!-- Progress Overview -->
    <div class="card mb-3">
        <div class="card-header">
            <h6 class="mb-0">Progress Hari Ini</h6>
        </div>
        <div class="card-body">
            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <small>Pengumpulan</small>
                    <small id="collection-progress-text">80%</small>
                </div>
                <div class="progress" id="collection-progress">
                    <div class="progress-bar bg-success" style="width: 80%"></div>
                </div>
            </div>
            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <small>Kunjungan</small>
                    <small id="visit-progress-text">75%</small>
                </div>
                <div class="progress" id="visit-progress">
                    <div class="progress-bar bg-primary" style="width: 75%"></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Today's Route -->
    <div class="card mb-3">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h6 class="mb-0">Rute Hari Ini</h6>
            <span class="badge bg-primary"><?php echo count($todayRoute); ?> Anggota</span>
        </div>
        <div class="card-body p-0">
            <div id="route-list" class="route-list">
                <?php if (empty($todayRoute)): ?>
                <div class="empty-state">
                    <i class="fas fa-route"></i>
                    <p>Belum ada rute hari ini</p>
                    <button class="btn btn-primary btn-sm mt-2" onclick="mobileDashboard.generateRoute()">
                        <i class="fas fa-plus"></i> Buat Rute
                    </button>
                </div>
                <?php else: ?>
                    <!-- Route items will be populated by JavaScript -->
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="card mb-3">
        <div class="card-header">
            <h6 class="mb-0">Statistik Hari Ini</h6>
        </div>
        <div class="card-body">
            <div class="row text-center">
                <div class="col-4">
                    <div class="stat-item">
                        <div class="stat-number text-primary">8</div>
                        <small class="text-muted">Pinjaman</small>
                    </div>
                </div>
                <div class="col-4">
                    <div class="stat-item">
                        <div class="stat-number text-success">15</div>
                        <small class="text-muted">Simpanan</small>
                    </div>
                </div>
                <div class="col-4">
                    <div class="stat-item">
                        <div class="stat-number text-warning">2</div>
                        <small class="text-muted">Terlambat</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activities -->
    <div class="card mb-3">
        <div class="card-header">
            <h6 class="mb-0">Aktivitas Terbaru</h6>
        </div>
        <div class="card-body">
            <div class="activity-list">
                <div class="activity-item d-flex align-items-center mb-2">
                    <div class="activity-icon bg-success text-white rounded-circle p-2 me-3">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="d-block">Pembayaran berhasil</small>
                        <small class="text-muted">Budi Santoso - 2 menit lalu</small>
                    </div>
                </div>
                <div class="activity-item d-flex align-items-center mb-2">
                    <div class="activity-icon bg-primary text-white rounded-circle p-2 me-3">
                        <i class="fas fa-route"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="d-block">Rute selesai</small>
                        <small class="text-muted">Area Jakarta - 15 menit lalu</small>
                    </div>
                </div>
                <div class="activity-item d-flex align-items-center">
                    <div class="activity-icon bg-warning text-white rounded-circle p-2 me-3">
                        <i class="fas fa-exclamation"></i>
                    </div>
                    <div class="flex-grow-1">
                        <small class="d-block">Pembayaran terlambat</small>
                        <small class="text-muted">Ahmad Yani - 1 jam lalu</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Links -->
    <div class="card mb-3">
        <div class="card-header">
            <h6 class="mb-0">Menu Cepat</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-4 text-center">
                    <a href="/collector/members" class="quick-link">
                        <div class="quick-link-icon bg-info text-white rounded-circle p-3 mb-2">
                            <i class="fas fa-users"></i>
                        </div>
                        <small>Anggota</small>
                    </a>
                </div>
                <div class="col-4 text-center">
                    <a href="/collector/reports" class="quick-link">
                        <div class="quick-link-icon bg-warning text-white rounded-circle p-3 mb-2">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <small>Laporan</small>
                    </a>
                </div>
                <div class="col-4 text-center">
                    <a href="/collector/settings" class="quick-link">
                        <div class="quick-link-icon bg-secondary text-white rounded-circle p-3 mb-2">
                            <i class="fas fa-cog"></i>
                        </div>
                        <small>Pengaturan</small>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Mobile Dashboard CSS -->
<link rel="stylesheet" href="/assets/css/mobile-dashboard.css">

<!-- Mobile Dashboard JavaScript -->
<script src="/assets/js/mobile-dashboard.js"></script>

<!-- PWA Development Config -->
<script src="/pwa-dev-config.js"></script>

<!-- Online Status Indicator -->
<div id="online-status" class="online-status online">
    <i class="fas fa-wifi"></i> Online
</div>

<!-- Pull to Refresh Indicator -->
<div id="pull-indicator" style="display: none;">
    <i class="fas fa-sync-alt"></i>
</div>

<!-- Error Container -->
<div id="error-container"></div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>
