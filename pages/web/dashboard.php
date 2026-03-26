<?php
/**
 * Web Dashboard untuk Admin/Manager
 * Full featured dengan charts dan comprehensive data
 */

require_once __DIR__ . '/../template_header.php';

// Set page specific variables
$pageTitle = 'Dashboard Manajemen';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/dashboard']
];

// Get comprehensive dashboard data
$dashboardData = $dashboardService->getComprehensiveData();
$recentActivities = $dashboardService->getRecentActivities(10);
$alerts = $dashboardService->getSystemAlerts();
?>

<div class="container-fluid">
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Dashboard Manajemen</h1>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-primary" onclick="exportData()">
                <i class="fas fa-download"></i> Export
            </button>
            <button class="btn btn-outline-secondary" onclick="refreshDashboard()">
                <i class="fas fa-sync"></i> Refresh
            </button>
            <div class="btn-group">
                <button class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown">
                    <i class="fas fa-calendar"></i> Periode
                </button>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#" onclick="changePeriod('today')">Hari Ini</a></li>
                    <li><a class="dropdown-item" href="#" onclick="changePeriod('week')">Minggu Ini</a></li>
                    <li><a class="dropdown-item" href="#" onclick="changePeriod('month')">Bulan Ini</a></li>
                    <li><a class="dropdown-item" href="#" onclick="changePeriod('year')">Tahun Ini</a></li>
                </ul>
            </div>
        </div>
    </div>

    <!-- System Alerts -->
    <?php if (!empty($alerts)): ?>
    <div class="row mb-4">
        <div class="col-12">
            <?php foreach ($alerts as $alert): ?>
            <div class="alert alert-<?php echo $alert['type']; ?> alert-dismissible fade show" role="alert">
                <i class="fas fa-<?php echo $alert['icon']; ?>"></i>
                <strong><?php echo htmlspecialchars($alert['title']); ?></strong>
                <?php echo htmlspecialchars($alert['message']); ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <?php endforeach; ?>
        </div>
    </div>
    <?php endif; ?>

    <!-- Key Metrics Cards -->
    <div class="row mb-4">
        <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Total Anggota
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo number_format($dashboardData['total_members'], 0, ',', '.'); ?>
                            </div>
                            <div class="text-xs text-muted">
                                <i class="fas fa-arrow-up text-success"></i> 
                                +<?php echo number_format($dashboardData['new_members_this_month'], 0, ',', '.'); ?> bulan ini
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-users fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Portfolio Pinjaman
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo formatRupiah($dashboardData['total_portfolio']); ?>
                            </div>
                            <div class="text-xs text-muted">
                                <i class="fas fa-arrow-up text-success"></i> 
                                +<?php echo number_format($dashboardData['portfolio_growth'], 2, ',', '.'); ?>% bulan ini
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-hand-holding-usd fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Total Simpanan
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo formatRupiah($dashboardData['total_savings']); ?>
                            </div>
                            <div class="text-xs text-muted">
                                <i class="fas fa-arrow-up text-success"></i> 
                                +<?php echo number_format($dashboardData['savings_growth'], 2, ',', '.'); ?>% bulan ini
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-piggy-bank fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-lg-6 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                NPL Ratio
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo number_format($dashboardData['npl_ratio'], 2, ',', '.'); ?>%
                            </div>
                            <div class="text-xs text-muted">
                                <i class="fas fa-arrow-<?php echo $dashboardData['npl_trend'] === 'up' ? 'down text-danger' : 'up text-success'; ?>"></i> 
                                <?php echo number_format($dashboardData['npl_change'], 2, ',', '.'); ?>% dari bulan lalu
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Charts Row -->
    <div class="row mb-4">
        <!-- Portfolio Growth Chart -->
        <div class="col-xl-8 col-lg-7 mb-4">
            <div class="card shadow">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Pertumbuhan Portfolio</h6>
                    <div class="dropdown no-arrow">
                        <a class="dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                        </a>
                        <div class="dropdown-menu dropdown-menu-right shadow">
                            <a class="dropdown-item" href="#" onclick="changeChartType('line')">Line Chart</a>
                            <a class="dropdown-item" href="#" onclick="changeChartType('bar')">Bar Chart</a>
                            <a class="dropdown-item" href="#" onclick="changeChartType('area')">Area Chart</a>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="chart-area">
                        <canvas id="portfolioChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Loan Distribution Chart -->
        <div class="col-xl-4 col-lg-5 mb-4">
            <div class="card shadow">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Distribusi Pinjaman</h6>
                </div>
                <div class="card-body">
                    <div class="chart-pie pt-4">
                        <canvas id="loanDistributionChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Performance Metrics -->
    <div class="row mb-4">
        <!-- Collection Performance -->
        <div class="col-lg-4 mb-4">
            <div class="card shadow">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Performa Penagihan</h6>
                </div>
                <div class="card-body">
                    <div class="chart-bar">
                        <canvas id="collectionChart"></canvas>
                    </div>
                    <div class="mt-3 text-center">
                        <small class="text-muted">Tingkat penagihan harian</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Branch Performance -->
        <div class="col-lg-8 mb-4">
            <div class="card shadow">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Performa Cabang</h6>
                    <button class="btn btn-sm btn-outline-primary" onclick="toggleBranchView()">
                        <i class="fas fa-th"></i> Grid View
                    </button>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="branchTable">
                            <thead>
                                <tr>
                                    <th>Cabang</th>
                                    <th>Anggota</th>
                                    <th>Portfolio</th>
                                    <th>Penagihan</th>
                                    <th>NPL</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($dashboardData['branch_performance'] as $branch): ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($branch['name']); ?></td>
                                    <td><?php echo number_format($branch['members'], 0, ',', '.'); ?></td>
                                    <td><?php echo formatRupiah($branch['portfolio']); ?></td>
                                    <td><?php echo number_format($branch['collection_rate'], 1, ',', '.'); ?>%</td>
                                    <td>
                                        <span class="badge badge-<?php echo $branch['npl'] > 5 ? 'danger' : ($branch['npl'] > 3 ? 'warning' : 'success'); ?>">
                                            <?php echo number_format($branch['npl'], 2, ',', '.'); ?>%
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge badge-<?php echo $branch['status'] === 'active' ? 'success' : 'secondary'; ?>">
                                            <?php echo ucfirst($branch['status']); ?>
                                        </span>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activities & Quick Actions -->
    <div class="row">
        <!-- Recent Activities -->
        <div class="col-lg-8 mb-4">
            <div class="card shadow">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Aktivitas Terkini</h6>
                    <a href="/activities" class="btn btn-sm btn-outline-primary">Lihat Semua</a>
                </div>
                <div class="card-body">
                    <div class="activity-list">
                        <?php foreach ($recentActivities as $activity): ?>
                        <div class="activity-item border-bottom pb-3 mb-3">
                            <div class="d-flex align-items-start">
                                <div class="activity-icon me-3">
                                    <?php
                                    $iconClass = $activity['type'] === 'loan' ? 'fa-hand-holding-usd text-primary' :
                                                ($activity['type'] === 'payment' ? 'fa-money-bill text-success' :
                                                ($activity['type'] === 'member' ? 'fa-user-plus text-info' :
                                                ($activity['type'] === 'system' ? 'fa-cog text-warning' : 'fa-info-circle text-secondary')));
                                    ?>
                                    <i class="fas <?php echo $iconClass; ?>"></i>
                                </div>
                                <div class="activity-details flex-grow-1">
                                    <div class="activity-title">
                                        <?php echo htmlspecialchars($activity['title']); ?>
                                    </div>
                                    <div class="activity-description text-muted small">
                                        <?php echo htmlspecialchars($activity['description']); ?>
                                    </div>
                                    <div class="activity-meta text-muted small">
                                        <i class="fas fa-user"></i> <?php echo htmlspecialchars($activity['user']); ?> •
                                        <i class="fas fa-clock"></i> <?php echo formatDateTime($activity['created_at']); ?>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions & System Status -->
        <div class="col-lg-4 mb-4">
            <!-- Quick Actions -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Aksi Cepat</h6>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="/loans/approve" class="btn btn-outline-primary">
                            <i class="fas fa-check-circle"></i> Approve Pinjaman
                        </a>
                        <a href="/members/add" class="btn btn-outline-success">
                            <i class="fas fa-user-plus"></i> Tambah Anggota
                        </a>
                        <a href="/reports/generate" class="btn btn-outline-info">
                            <i class="fas fa-file-alt"></i> Generate Laporan
                        </a>
                        <a href="/settings/system" class="btn btn-outline-warning">
                            <i class="fas fa-cogs"></i> Pengaturan Sistem
                        </a>
                    </div>
                </div>
            </div>

            <!-- System Status -->
            <div class="card shadow">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Status Sistem</h6>
                </div>
                <div class="card-body">
                    <div class="system-status">
                        <div class="status-item d-flex justify-content-between align-items-center mb-2">
                            <span><i class="fas fa-database text-info"></i> Database</span>
                            <span class="badge badge-success">Normal</span>
                        </div>
                        <div class="status-item d-flex justify-content-between align-items-center mb-2">
                            <span><i class="fas fa-server text-warning"></i> Server</span>
                            <span class="badge badge-success">Online</span>
                        </div>
                        <div class="status-item d-flex justify-content-between align-items-center mb-2">
                            <span><i class="fas fa-wifi text-success"></i> API</span>
                            <span class="badge badge-success">Active</span>
                        </div>
                        <div class="status-item d-flex justify-content-between align-items-center mb-2">
                            <span><i class="fas fa-hdd text-secondary"></i> Storage</span>
                            <span class="badge badge-warning">75%</span>
                        </div>
                        <div class="status-item d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-clock text-primary"></i> Last Sync</span>
                            <span class="text-muted small"><?php echo formatWaktu($dashboardData['last_sync']); ?></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Dashboard JavaScript -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    initCharts();
    setupAutoRefresh();
    setupRealTimeUpdates();
});

let portfolioChart, loanDistributionChart, collectionChart;

function initCharts() {
    // Portfolio Growth Chart
    const portfolioCtx = document.getElementById('portfolioChart').getContext('2d');
    portfolioChart = new Chart(portfolioCtx, {
        type: 'line',
        data: {
            labels: <?php echo json_encode($dashboardData['portfolio_labels']); ?>,
            datasets: [{
                label: 'Portfolio Pinjaman',
                data: <?php echo json_encode($dashboardData['portfolio_data']); ?>,
                borderColor: '#e74c3c',
                backgroundColor: 'rgba(231, 76, 60, 0.1)',
                tension: 0.4,
                fill: true
            }, {
                label: 'Total Simpanan',
                data: <?php echo json_encode($dashboardData['savings_data']); ?>,
                borderColor: '#27ae60',
                backgroundColor: 'rgba(39, 174, 96, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return formatRupiah(value);
                        }
                    }
                }
            }
        }
    });

    // Loan Distribution Chart
    const loanCtx = document.getElementById('loanDistributionChart').getContext('2d');
    loanDistributionChart = new Chart(loanCtx, {
        type: 'doughnut',
        data: {
            labels: <?php echo json_encode($dashboardData['loan_types']); ?>,
            datasets: [{
                data: <?php echo json_encode($dashboardData['loan_amounts']); ?>,
                backgroundColor: [
                    '#e74c3c', '#3498db', '#27ae60', '#f39c12', '#9b59b6', '#1abc9c'
                ]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                }
            }
        }
    });

    // Collection Performance Chart
    const collectionCtx = document.getElementById('collectionChart').getContext('2d');
    collectionChart = new Chart(collectionCtx, {
        type: 'bar',
        data: {
            labels: <?php echo json_encode($dashboardData['collection_days']); ?>,
            datasets: [{
                label: 'Tingkat Penagihan (%)',
                data: <?php echo json_encode($dashboardData['collection_rates']); ?>,
                backgroundColor: '#3498db'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100,
                    ticks: {
                        callback: function(value) {
                            return value + '%';
                        }
                    }
                }
            }
        }
    });
}

function setupAutoRefresh() {
    // Auto refresh every 5 minutes
    setInterval(refreshDashboard, 300000);
}

function setupRealTimeUpdates() {
    // WebSocket connection for real-time updates (if available)
    if (window.WebSocket) {
        const ws = new WebSocket('ws://localhost:8080/dashboard-updates');
        
        ws.onmessage = function(event) {
            const data = JSON.parse(event.data);
            handleRealTimeUpdate(data);
        };
        
        ws.onopen = function() {
            console.log('WebSocket connected');
        };
        
        ws.onerror = function(error) {
            console.log('WebSocket error:', error);
        };
    }
}

function handleRealTimeUpdate(data) {
    switch(data.type) {
        case 'new_loan':
            updateMetrics();
            showNotification('Pinjaman baru diajukan', 'info');
            break;
        case 'payment_received':
            updateMetrics();
            showNotification('Pembayaran diterima', 'success');
            break;
        case 'system_alert':
            showAlert(data.alert);
            break;
    }
}

function refreshDashboard() {
    fetch('/api/dashboard/refresh')
        .then(response => response.json())
        .then(data => {
            updateMetrics();
            updateCharts(data);
        })
        .catch(error => {
            console.error('Error refreshing dashboard:', error);
        });
}

function updateMetrics() {
    fetch('/api/dashboard/metrics')
        .then(response => response.json())
        .then(data => {
            // Update metric cards
            document.querySelector('.border-left-primary .h5').textContent = data.total_members.toLocaleString('id-ID');
            document.querySelector('.border-left-success .h5').textContent = formatRupiah(data.total_portfolio);
            document.querySelector('.border-left-info .h5').textContent = formatRupiah(data.total_savings);
            document.querySelector('.border-left-warning .h5').textContent = data.npl_ratio.toFixed(2) + '%';
        });
}

function updateCharts(data) {
    // Update portfolio chart
    portfolioChart.data.datasets[0].data = data.portfolio_data;
    portfolioChart.data.datasets[1].data = data.savings_data;
    portfolioChart.update();
    
    // Update distribution chart
    loanDistributionChart.data.datasets[0].data = data.loan_amounts;
    loanDistributionChart.update();
    
    // Update collection chart
    collectionChart.data.datasets[0].data = data.collection_rates;
    collectionChart.update();
}

function changePeriod(period) {
    fetch(`/api/dashboard/change-period?period=${period}`)
        .then(response => response.json())
        .then(data => {
            updateCharts(data);
            showNotification(`Periode diubah ke ${period}`, 'success');
        });
}

function changeChartType(type) {
    portfolioChart.config.type = type;
    portfolioChart.update();
}

function toggleBranchView() {
    const table = document.getElementById('branchTable');
    if (table.classList.contains('table')) {
        // Convert to grid view
        // Implementation for grid view
    }
}

function exportData() {
    window.open('/api/dashboard/export', '_blank');
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed top-0 end-0 m-3`;
    notification.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.remove();
    }, 5000);
}

function showAlert(alert) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${alert.type} alert-dismissible fade show position-fixed top-0 start-0 end-0 m-3`;
    alertDiv.innerHTML = `
        <i class="fas fa-${alert.icon}"></i>
        <strong>${alert.title}</strong> ${alert.message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    document.body.appendChild(alertDiv);
}
</script>

<style>
.border-left-primary {
    border-left: 0.25rem solid #4e73df !important;
}

.border-left-success {
    border-left: 0.25rem solid #1cc88a !important;
}

.border-left-info {
    border-left: 0.25rem solid #36b9cc !important;
}

.border-left-warning {
    border-left: 0.25rem solid #f6c23e !important;
}

.chart-area {
    position: relative;
    height: 300px;
}

.chart-pie {
    position: relative;
    height: 250px;
}

.chart-bar {
    position: relative;
    height: 200px;
}

.activity-item {
    position: relative;
}

.activity-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f8f9fa;
}

.activity-title {
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 0.25rem;
}

.activity-description {
    margin-bottom: 0.5rem;
}

.activity-meta {
    font-size: 0.75rem;
}

.system-status .status-item {
    padding: 0.5rem 0;
}

.system-status .badge {
    font-size: 0.75rem;
}

.status-item i {
    width: 20px;
    text-align: center;
}

.card {
    transition: all 0.3s ease;
}

.card:hover {
    transform: translateY(-2px);
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
}

.table th {
    font-weight: 600;
    font-size: 0.875rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

@media (max-width: 768px) {
    .container-fluid {
        padding: 0 1rem;
    }
    
    .d-flex.justify-content-between {
        flex-direction: column;
        gap: 1rem;
    }
    
    .row .col-xl-3 {
        margin-bottom: 1rem;
    }
}
</style>

<?php require_once __DIR__ . '/../template_footer.php'; ?>
