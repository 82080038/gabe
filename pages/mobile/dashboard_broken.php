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

<div class="container-fluid p-0">
    <!-- Header dengan summary -->
    <div class="summary-card text-white p-3 mb-3">
        <div class="row text-center">
            <div class="col-4">
                <h4 class="mb-1"><?php echo $summary['total_visited']; ?></h4>
                <small class="opacity-75">Dikunjungi</small>
            </div>
            <div class="col-4">
                <h4 class="mb-1"><?php echo formatRupiah($summary['total_collected']); ?></h4>
                <small class="opacity-75">Terkumpul</small>
            </div>
            <div class="col-4">
                <h4 class="mb-1"><?php echo $summary['pending_count']; ?></h4>
                <small class="opacity-75">Belum Bayar</small>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="row mb-3">
        <div class="col-6">
            <a href="/collector/route" class="btn btn-primary btn-block btn-lg">
                <i class="fas fa-route"></i><br>
                <small>Mulai Rute</small>
            </a>
        </div>
        <div class="col-6">
            <a href="/collector/payments" class="btn btn-success btn-block btn-lg">
                <i class="fas fa-money-bill"></i><br>
                <small>Pembayaran</small>
            </a>
        </div>
    </div>

    <!-- Today's Route Preview -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h6 class="mb-0">Rute Hari Ini</h6>
            <button class="btn btn-sm btn-outline-primary" onclick="refreshRoute()">
                <i class="fas fa-sync"></i>
            </button>
        </div>
        <div class="card-body p-0">
            <?php if (empty($todayRoute)): ?>
                <div class="text-center p-4">
                    <i class="fas fa-route fa-2x text-muted mb-2"></i>
                    <p class="text-muted">Tidak ada rute hari ini</p>
                </div>
            <?php else: ?>
                <div class="route-list">
                    <?php 
                    $displayCount = min(5, count($todayRoute));
                    for ($i = 0; $i < $displayCount; $i++): 
                        $member = $todayRoute[$i];
                        $statusClass = $member['payment_status'] === 'paid' ? 'text-success' : 
                                      ($member['payment_status'] === 'late' ? 'text-danger' : 'text-warning');
                        $statusIcon = $member['payment_status'] === 'paid' ? '✅' : 
                                      ($member['payment_status'] === 'late' ? '⚠️' : '⏰');
                    ?>
                    <div class="member-item" onclick="goToPayment('<?php echo $member['member_number']; ?>')">
                        <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                            <div class="flex-grow-1">
                                <h6 class="mb-1"><?php echo htmlspecialchars($member['name']); ?></h6>
                                <small class="text-muted"><?php echo htmlspecialchars($member['address']); ?></small>
                            </div>
                            <div class="text-right">
                                <div class="<?php echo $statusClass; ?>">
                                    <?php echo $statusIcon; ?>
                                </div>
                                <small class="text-muted">
                                    Rp <?php echo number_format($member['due_amount'] + $member['kewer_amount'], 0, ',', '.'); ?>
                                </small>
                            </div>
                        </div>
                    </div>
                    <?php endfor; ?>
                    
                    <?php if (count($todayRoute) > 5): ?>
                    <div class="text-center p-3">
                        <a href="/collector/route" class="btn btn-sm btn-outline-primary">
                            Lihat <?php echo count($todayRoute) - 5; ?> lagi
                        </a>
                    </div>
                    <?php endif; ?>
                </div>
            <?php endif; ?>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="card">
        <div class="card-header">
            <h6 class="mb-0">Statistik Hari Ini</h6>
        </div>
        <div class="card-body">
            <div class="row text-center">
                <div class="col-4">
                    <div class="stat-item">
                        <div class="stat-number text-primary"><?php echo $summary['loans_paid']; ?></div>
                        <small class="text-muted">Pinjaman</small>
                    </div>
                </div>
                <div class="col-4">
                    <div class="stat-item">
                        <div class="stat-number text-success"><?php echo $summary['savings_deposits']; ?></div>
                        <small class="text-muted">Simpanan</small>
                    </div>
                </div>
                <div class="col-4">
                    <div class="stat-item">
                        <div class="stat-number text-warning"><?php echo $summary['late_count']; ?></div>
                        <small class="text-muted">Terlambat</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activities -->
    <div class="card">
        <div class="card-header">
            <h6 class="mb-0">Aktivitas Terakhir</h6>
        </div>
        <div class="card-body">
            <div class="activity-list">
                <?php
                $recentActivities = $collectorService->getRecentActivities(5);
                if (empty($recentActivities)):
                ?>
                <div class="text-center text-muted p-3">
                    <small>Belum ada aktivitas hari ini</small>
                </div>
                <?php else: ?>
                    <?php foreach ($recentActivities as $activity): ?>
                    <div class="activity-item d-flex align-items-center mb-2">
                        <div class="activity-icon me-2">
                            <?php
                            $icon = $activity['type'] === 'payment' ? 'fa-money-bill' : 
                                   ($activity['type'] === 'visit' ? 'fa-map-marker-alt' : 'fa-clock');
                            $color = $activity['type'] === 'payment' ? 'text-success' : 
                                     ($activity['type'] === 'visit' ? 'text-info' : 'text-muted');
                            ?>
                            <i class="fas <?php echo $icon; ?> <?php echo $color; ?>"></i>
                        </div>
                        <div class="activity-details flex-grow-1">
                            <div class="activity-title"><?php echo htmlspecialchars($activity['title']); ?></div>
                            <small class="text-muted"><?php echo formatWaktu($activity['time']); ?></small>
                        </div>
                    </div>
                    <?php endforeach; ?>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <!-- Quick Links -->
    <div class="card">
        <div class="card-header">
            <h6 class="mb-0">Menu Cepat</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-6 mb-2">
                    <a href="/members/search" class="btn btn-outline-secondary btn-block">
                        <i class="fas fa-search"></i><br>
                        <small>Cari Anggota</small>
                    </a>
                </div>
                <div class="col-6 mb-2">
                    <a href="/reports/daily" class="btn btn-outline-secondary btn-block">
                        <i class="fas fa-chart-line"></i><br>
                        <small>Laporan</small>
                    </a>
                </div>
                <div class="col-6 mb-2">
                    <a href="/messages" class="btn btn-outline-secondary btn-block">
                        <i class="fas fa-envelope"></i><br>
                        <small>Pesan</small>
                    </a>
                </div>
                <div class="col-6 mb-2">
                    <a href="/settings" class="btn btn-outline-secondary btn-block">
                        <i class="fas fa-cog"></i><br>
                        <small>Pengaturan</small>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Mobile specific JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Auto refresh setiap 5 menit
    setInterval(refreshData, 300000);
    
    // Check GPS permission
    if ('geolocation' in navigator) {
        navigator.geolocation.getCurrentPosition(
            (position) => {
                console.log('GPS enabled');
            },
            (error) => {
                console.warn('GPS disabled:', error);
                showGPSWarning();
            }
        );
    }
    
    // Setup pull to refresh
    setupPullToRefresh();
});

function refreshData() {
    fetch('/api/collector/dashboard-data')
        .then(response => response.json())
        .then(data => {
            updateDashboard(data);
        })
        .catch(error => {
            console.error('Error refreshing data:', error);
        });
}

function refreshRoute() {
    const btn = document.querySelector('[onclick="refreshRoute()"]');
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
    
    fetch('/api/collector/refresh-route')
        .then(response => response.json())
        .then(data => {
            updateRouteList(data);
            btn.innerHTML = '<i class="fas fa-sync"></i>';
        })
        .catch(error => {
            console.error('Error refreshing route:', error);
            btn.innerHTML = '<i class="fas fa-sync"></i>';
        });
}

function goToPayment(memberNumber) {
    window.location.href = `/collector/payment/${memberNumber}`;
}

function updateDashboard(data) {
    // Update summary card
    document.querySelector('.summary-card h4:nth-child(1)').textContent = data.total_visited;
    document.querySelector('.summary-card h4:nth-child(2)').textContent = formatRupiah(data.total_collected);
    document.querySelector('.summary-card h4:nth-child(3)').textContent = data.pending_count;
    
    // Update stats
    document.querySelector('.stat-number:nth-child(1)').textContent = data.loans_paid;
    document.querySelector('.stat-number:nth-child(2)').textContent = data.savings_deposits;
    document.querySelector('.stat-number:nth-child(3)').textContent = data.late_count;
}

function updateRouteList(route) {
    const routeList = document.querySelector('.route-list');
    if (!routeList) return;
    
    routeList.innerHTML = '';
    
    route.slice(0, 5).forEach(member => {
        const statusClass = member.payment_status === 'paid' ? 'text-success' : 
                          (member.payment_status === 'late' ? 'text-danger' : 'text-warning');
        const statusIcon = member.payment_status === 'paid' ? '✅' : 
                          (member.payment_status === 'late' ? '⚠️' : '⏰');
        
        const memberHTML = `
            <div class="member-item" onclick="goToPayment('${member.member_number}')">
                <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                    <div class="flex-grow-1">
                        <h6 class="mb-1">${member.name}</h6>
                        <small class="text-muted">${member.address}</small>
                    </div>
                    <div class="text-right">
                        <div class="${statusClass}">
                            ${statusIcon}
                        </div>
                        <small class="text-muted">
                            Rp ${formatAngka(member.due_amount + member.kewer_amount)}
                        </small>
                    </div>
                </div>
            </div>
        `;
        
        routeList.innerHTML += memberHTML;
    });
}

function showGPSWarning() {
    const alert = document.createElement('div');
    alert.className = 'alert alert-warning alert-dismissible fade show position-fixed top-0 start-0 end-0 m-3';
    alert.innerHTML = `
        <i class="fas fa-exclamation-triangle"></i> 
        GPS tidak aktif. Aktifkan GPS untuk pelacakan lokasi.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    document.body.appendChild(alert);
    
    setTimeout(() => {
        alert.remove();
    }, 5000);
}

function setupPullToRefresh() {
    let startY = 0;
    let isPulling = false;
    
    document.addEventListener('touchstart', (e) => {
        if (window.scrollY === 0) {
            startY = e.touches[0].pageY;
            isPulling = true;
        }
    });
    
    document.addEventListener('touchmove', (e) => {
        if (!isPulling) return;
        
        const currentY = e.touches[0].pageY;
        const pullDistance = currentY - startY;
        
        if (pullDistance > 100) {
            document.body.style.transform = `translateY(${Math.min(pullDistance - 100, 50)}px)`;
        }
    });
    
    document.addEventListener('touchend', () => {
        if (isPulling) {
            document.body.style.transform = '';
            
            if (document.body.style.transform !== '') {
                refreshData();
            }
            
            isPulling = false;
        }
    });
}
</script>

<style>
.summary-card {
    background: linear-gradient(135deg, #e74c3c, #c0392b);
    border-radius: 0.5rem;
}

.member-item {
    cursor: pointer;
    transition: background-color 0.2s ease;
}

.member-item:hover {
    background-color: #f8f9fa;
}

.stat-item {
    padding: 0.5rem;
}

.stat-number {
    font-size: 1.25rem;
    font-weight: 600;
}

.activity-item {
    border-left: 3px solid #e9ecef;
    padding-left: 1rem;
}

.activity-icon {
    width: 30px;
    text-align: center;
}

.activity-title {
    font-size: 0.875rem;
    font-weight: 500;
}

.btn-lg {
    padding: 1rem;
    font-size: 0.875rem;
}

.btn-lg i {
    font-size: 1.5rem;
    display: block;
    margin-bottom: 0.5rem;
}

.route-list {
    max-height: 400px;
    overflow-y: auto;
}

.card {
    border-radius: 0.5rem;
    box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
}

.card-header {
    background-color: #f8f9fa;
    border-bottom: 1px solid #dee2e6;
    font-weight: 600;
}

/* Pull to refresh indicator */
.pull-to-refresh {
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f8f9fa;
    border-radius: 0.5rem 0.5rem 0 0;
}

.pull-to-refresh i {
    font-size: 1.5rem;
    color: #6c757d;
}
</style>

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
?>
