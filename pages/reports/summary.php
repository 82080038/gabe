<?php
/**
 * Summary Report View
 */

// Mock data for summary statistics
$summaryStats = [
    'total_members' => 156,
    'active_members' => 142,
    'total_savings' => 450000000,
    'total_loans' => 320000000,
    'monthly_savings' => 25000000,
    'monthly_loans' => 18000000,
    'monthly_collections' => 22000000,
    'npl_ratio' => 2.5,
    'portfolio_at_risk' => 8000000
];

// Mock data for recent activities
$recentActivities = [
    [
        'type' => 'deposit',
        'description' => 'Setoran Kewer - Bapak Ahmad',
        'amount' => 50000,
        'date' => '2024-03-27 10:30:00',
        'user' => 'Petugas Kolektor'
    ],
    [
        'type' => 'loan_disbursement',
        'description' => 'Pencairan Pinjaman - Ibu Siti',
        'amount' => 5000000,
        'date' => '2024-03-27 09:15:00',
        'user' => 'Administrator'
    ],
    [
        'type' => 'payment',
        'description' => 'Pembayaran Angsuran - Bapak Budi',
        'amount' => 450000,
        'date' => '2024-03-27 08:45:00',
        'user' => 'Kasir'
    ]
];

// Mock data for branch performance
$branchPerformance = [
    [
        'branch_name' => 'Cabang Jakarta Selatan',
        'total_members' => 85,
        'savings_balance' => 280000000,
        'loan_portfolio' => 180000000,
        'monthly_collections' => 15000000,
        'npl_ratio' => 2.2
    ],
    [
        'branch_name' => 'Cabang Jakarta Pusat',
        'total_members' => 71,
        'savings_balance' => 170000000,
        'loan_portfolio' => 140000000,
        'monthly_collections' => 7000000,
        'npl_ratio' => 2.8
    ]
];
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Ringkasan Laporan</h1>
        <div>
            <button class="btn btn-success me-2" onclick="exportReport()">
                <i class="fas fa-download"></i> Export PDF
            </button>
            <button class="btn btn-primary" onclick="generateReport()">
                <i class="fas fa-sync-alt"></i> Refresh Data
            </button>
        </div>
    </div>

    <!-- Date Range Filter -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Filter Periode</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <label class="form-label">Dari Tanggal</label>
                    <input type="date" class="form-control" id="startDate" value="<?php echo date('Y-m-01'); ?>">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Sampai Tanggal</label>
                    <input type="date" class="form-control" id="endDate" value="<?php echo date('Y-m-d'); ?>">
                </div>
                <div class="col-md-4">
                    <label class="form-label">&nbsp;</label>
                    <div>
                        <button class="btn btn-primary" onclick="applyDateFilter()">
                            <i class="fas fa-filter"></i> Terapkan
                        </button>
                        <button class="btn btn-secondary" onclick="resetDateFilter()">
                            <i class="fas fa-undo"></i> Reset
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Key Metrics -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Total Anggota
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $summaryStats['total_members']; ?>
                            </div>
                            <div class="text-xs text-muted">
                                Aktif: <?php echo $summaryStats['active_members']; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-users fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Total Simpanan
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($summaryStats['total_savings'], 0, ',', '.'); ?>
                            </div>
                            <div class="text-xs text-muted">
                                Bulan ini: +<?php echo 'Rp ' . number_format($summaryStats['monthly_savings'], 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-piggy-bank fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Total Pinjaman
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($summaryStats['total_loans'], 0, ',', '.'); ?>
                            </div>
                            <div class="text-xs text-muted">
                                Bulan ini: +<?php echo 'Rp ' . number_format($summaryStats['monthly_loans'], 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-hand-holding-usd fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                NPL Ratio
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $summaryStats['npl_ratio']; ?>%
                            </div>
                            <div class="text-xs text-muted">
                                At Risk: <?php echo 'Rp ' . number_format($summaryStats['portfolio_at_risk'], 0, ',', '.'); ?>
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
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Trend Simpanan & Pinjaman</h6>
                </div>
                <div class="card-body">
                    <canvas id="trendChart"></canvas>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Distribusi Produk</h6>
                </div>
                <div class="card-body">
                    <canvas id="productChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Branch Performance -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Performa Cabang</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="branchTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Cabang</th>
                            <th>Total Anggota</th>
                            <th>Saldo Simpanan</th>
                            <th>Portofolio Pinjaman</th>
                            <th>Koleksi Bulanan</th>
                            <th>NPL Ratio</th>
                            <th>Performa</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($branchPerformance as $branch): ?>
                        <tr>
                            <td><strong><?php echo htmlspecialchars($branch['branch_name']); ?></strong></td>
                            <td>
                                <span class="badge bg-primary"><?php echo $branch['total_members']; ?></span>
                            </td>
                            <td>
                                <span class="badge bg-success">Rp <?php echo number_format($branch['savings_balance'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <span class="badge bg-info">Rp <?php echo number_format($branch['loan_portfolio'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <span class="badge bg-warning">Rp <?php echo number_format($branch['monthly_collections'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <div class="progress" style="height: 20px;">
                                    <div class="progress-bar <?php echo $branch['npl_ratio'] > 2.5 ? 'bg-danger' : 'bg-success'; ?>" 
                                         style="width: <?php echo min($branch['npl_ratio'] * 20, 100); ?>%;"
                                         title="NPL: <?php echo $branch['npl_ratio']; ?>%">
                                        <?php echo $branch['npl_ratio']; ?>%
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="text-center">
                                    <?php if ($branch['npl_ratio'] < 2): ?>
                                    <i class="fas fa-star text-success"></i>
                                    <?php elseif ($branch['npl_ratio'] < 3): ?>
                                    <i class="fas fa-star text-warning"></i>
                                    <?php else: ?>
                                    <i class="fas fa-star text-danger"></i>
                                    <?php endif; ?>
                                </div>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Recent Activities -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Aktivitas Terkini</h6>
        </div>
        <div class="card-body">
            <div class="timeline">
                <?php foreach ($recentActivities as $activity): ?>
                <div class="timeline-item">
                    <div class="timeline-marker <?php echo $activity['type'] === 'deposit' ? 'bg-success' : ($activity['type'] === 'loan_disbursement' ? 'bg-info' : 'bg-warning'); ?>">
                        <i class="fas <?php echo $activity['type'] === 'deposit' ? 'fa-plus' : ($activity['type'] === 'loan_disbursement' ? 'fa-hand-holding-usd' : 'fa-money-bill'); ?>"></i>
                    </div>
                    <div class="timeline-content">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <strong><?php echo htmlspecialchars($activity['description']); ?></strong>
                                <span class="badge bg-<?php echo $activity['type'] === 'deposit' ? 'success' : ($activity['type'] === 'loan_disbursement' ? 'info' : 'warning'); ?> ms-2">
                                    Rp <?php echo number_format($activity['amount'], 0, ',', '.'); ?>
                                </span>
                            </div>
                            <small class="text-muted"><?php echo date('d/m/Y H:i', strtotime($activity['date'])); ?></small>
                        </div>
                        <small class="text-muted">Oleh: <?php echo htmlspecialchars($activity['user']); ?></small>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#branchTable', {
        order: [[5, 'asc']],
        columns: [
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: false }
        ]
    });
    
    // Initialize Trend Chart
    const trendCtx = document.getElementById('trendChart').getContext('2d');
    const trendChart = KoperasiApp.chart.createLineChart(trendCtx, {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        datasets: [{
            label: 'Simpanan',
            data: [380000000, 390000000, 400000000, 420000000, 440000000, 450000000],
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            tension: 0.1
        }, {
            label: 'Pinjaman',
            data: [280000000, 290000000, 300000000, 310000000, 315000000, 320000000],
            borderColor: 'rgb(255, 99, 132)',
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            tension: 0.1
        }]
    });
    
    // Initialize Product Chart
    const productCtx = document.getElementById('productChart').getContext('2d');
    const productChart = KoperasiApp.chart.createPieChart(productCtx, {
        labels: ['Kewer', 'Mawar', 'Sukarela'],
        datasets: [{
            data: [180000000, 200000000, 70000000],
            backgroundColor: [
                'rgba(54, 162, 235, 0.8)',
                'rgba(255, 206, 86, 0.8)',
                'rgba(75, 192, 192, 0.8)'
            ]
        }]
    });
});

// Apply Date Filter
function applyDateFilter() {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    
    console.log('Applying date filter:', { startDate, endDate });
    KoperasiApp.notification.info('Filter periode diterapkan');
    
    // In real implementation, this would reload data with date filter
    setTimeout(() => location.reload(), 1000);
}

// Reset Date Filter
function resetDateFilter() {
    document.getElementById('startDate').value = '<?php echo date('Y-m-01'); ?>';
    document.getElementById('endDate').value = '<?php echo date('Y-m-d'); ?>';
    
    console.log('Date filter reset');
    KoperasiApp.notification.info('Filter periode direset');
    
    setTimeout(() => location.reload(), 1000);
}

// Generate Report
function generateReport() {
    console.log('Generating report...');
    KoperasiApp.notification.success('Laporan berhasil diperbarui');
    setTimeout(() => location.reload(), 1000);
}

// Export Report
function exportReport() {
    console.log('Exporting report...');
    KoperasiApp.notification.success('Laporan berhasil diexport ke PDF');
}
</script>

<style>
.timeline {
    position: relative;
    padding-left: 30px;
}

.timeline::before {
    content: '';
    position: absolute;
    left: 15px;
    top: 0;
    bottom: 0;
    width: 2px;
    background: #e9ecef;
}

.timeline-item {
    position: relative;
    margin-bottom: 20px;
}

.timeline-marker {
    position: absolute;
    left: -30px;
    top: 0;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 12px;
}

.timeline-content {
    background: white;
    padding: 15px;
    border-radius: 8px;
    border-left: 3px solid #e9ecef;
    margin-left: 15px;
}
</style>
