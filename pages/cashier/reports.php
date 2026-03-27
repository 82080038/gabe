<?php
/**
 * Cashier Reports Page
 * View cashier-specific reports
 */

// Start session (check if already started)
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

// Check cashier role
if ($_SESSION['user']['role'] !== 'cashier') {
    header('Location: /gabe/pages/web/dashboard.php');
    exit;
}

require_once __DIR__ . '/../template_header.php';

// Set page specific variables
$pageTitle = 'Laporan Kasir';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Laporan', 'url' => '#']
];

// Mock data for reports
$dailyTransactions = [
    [
        'date' => '2024-03-27',
        'total_transactions' => 25,
        'total_amount' => 5250000,
        'payments' => 15,
        'payments_amount' => 3750000,
        'deposits' => 8,
        'deposits_amount' => 1200000,
        'withdrawals' => 2,
        'withdrawals_amount' => 300000
    ],
    [
        'date' => '2024-03-26',
        'total_transactions' => 18,
        'total_amount' => 4200000,
        'payments' => 12,
        'payments_amount' => 3000000,
        'deposits' => 5,
        'deposits_amount' => 900000,
        'withdrawals' => 1,
        'withdrawals_amount' => 300000
    ],
    [
        'date' => '2024-03-25',
        'total_transactions' => 22,
        'total_amount' => 4800000,
        'payments' => 14,
        'payments_amount' => 3500000,
        'deposits' => 6,
        'deposits_amount' => 1100000,
        'withdrawals' => 2,
        'withdrawals_amount' => 200000
    ]
];

// Calculate statistics
$todayTransactions = $dailyTransactions[0];
$weekTotal = array_sum(array_column($dailyTransactions, 'total_amount'));
$weekTransactions = array_sum(array_column($dailyTransactions, 'total_transactions'));
$avgDaily = $weekTotal / count($dailyTransactions);
?>

<div class="container-fluid">
    <!-- Page Header -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Laporan Kasir</h1>
        <div>
            <button class="btn btn-success me-2" onclick="exportReport()">
                <i class="fas fa-download"></i> Export
            </button>
            <button class="btn btn-primary" onclick="generateReport()">
                <i class="fas fa-sync-alt"></i> Refresh
            </button>
        </div>
    </div>

    <!-- Date Range Filter -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Filter Laporan</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-4">
                    <label class="form-label">Dari Tanggal</label>
                    <input type="date" class="form-control" id="startDate" value="<?php echo date('Y-m-d', strtotime('-7 days')); ?>">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Sampai Tanggal</label>
                    <input type="date" class="form-control" id="endDate" value="<?php echo date('Y-m-d'); ?>">
                </div>
                <div class="col-md-4">
                    <label class="form-label">&nbsp;</label>
                    <div>
                        <button class="btn btn-primary" onclick="applyFilter()">
                            <i class="fas fa-filter"></i> Terapkan
                        </button>
                        <button class="btn btn-secondary" onclick="resetFilter()">
                            <i class="fas fa-undo"></i> Reset
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Summary Cards -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Transaksi Hari Ini
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $todayTransactions['total_transactions']; ?>
                            </div>
                            <div class="text-xs text-muted">
                                Total: <?php echo 'Rp ' . number_format($todayTransactions['total_amount'], 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exchange-alt fa-2x text-gray-300"></i>
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
                                Pembayaran
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $todayTransactions['payments']; ?>
                            </div>
                            <div class="text-xs text-muted">
                                Total: <?php echo 'Rp ' . number_format($todayTransactions['payments_amount'], 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-credit-card fa-2x text-gray-300"></i>
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
                                Setoran
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $todayTransactions['deposits']; ?>
                            </div>
                            <div class="text-xs text-muted">
                                Total: <?php echo 'Rp ' . number_format($todayTransactions['deposits_amount'], 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-plus fa-2x text-gray-300"></i>
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
                                Penarikan
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $todayTransactions['withdrawals']; ?>
                            </div>
                            <div class="text-xs text-muted">
                                Total: <?php echo 'Rp ' . number_format($todayTransactions['withdrawals_amount'], 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-minus fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Weekly Summary -->
    <div class="row mb-4">
        <div class="col-xl-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Grafik Transaksi Mingguan</h6>
                </div>
                <div class="card-body">
                    <canvas id="weeklyChart"></canvas>
                </div>
            </div>
        </div>
        
        <div class="col-xl-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Ringkasan Mingguan</h6>
                </div>
                <div class="card-body">
                    <div class="row no-gutters align-items-center mb-3">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Total Transaksi
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $weekTransactions; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-chart-bar fa-2x text-gray-300"></i>
                        </div>
                    </div>
                    
                    <div class="row no-gutters align-items-center mb-3">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Total Amount
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($weekTotal, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-money-bill fa-2x text-gray-300"></i>
                        </div>
                    </div>
                    
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Rata-rata/Hari
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($avgDaily, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-chart-line fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Detailed Transactions Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Detail Transaksi Harian</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="reportsTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Tanggal</th>
                            <th>Total Transaksi</th>
                            <th>Total Amount</th>
                            <th>Pembayaran</th>
                            <th>Setoran</th>
                            <th>Penarikan</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($dailyTransactions as $transaction): ?>
                        <tr>
                            <td>
                                <strong><?php echo date('d/m/Y', strtotime($transaction['date'])); ?></strong>
                            </td>
                            <td>
                                <span class="badge bg-primary"><?php echo $transaction['total_transactions']; ?></span>
                            </td>
                            <td>
                                <span class="badge bg-info">Rp <?php echo number_format($transaction['total_amount'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <div>
                                    <span class="badge bg-success"><?php echo $transaction['payments']; ?></span>
                                </div>
                                <small class="text-muted">Rp <?php echo number_format($transaction['payments_amount'], 0, ',', '.'); ?></small>
                            </td>
                            <td>
                                <div>
                                    <span class="badge bg-info"><?php echo $transaction['deposits']; ?></span>
                                </div>
                                <small class="text-muted">Rp <?php echo number_format($transaction['deposits_amount'], 0, ',', '.'); ?></small>
                            </td>
                            <td>
                                <div>
                                    <span class="badge bg-warning"><?php echo $transaction['withdrawals']; ?></span>
                                </div>
                                <small class="text-muted">Rp <?php echo number_format($transaction['withdrawals_amount'], 0, ',', '.'); ?></small>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-info" onclick="viewDetail('<?php echo $transaction['date']; ?>')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-primary" onclick="exportDetail('<?php echo $transaction['date']; ?>')">
                                        <i class="fas fa-download"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Detail Modal -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailModalLabel">Detail Transaksi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="detailContent">
                    <!-- Details will be loaded here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                <button type="button" class="btn btn-primary" onclick="exportDetailFromModal()">
                    <i class="fas fa-download"></i> Export
                </button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#reportsTable', {
        order: [[0, 'desc']],
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
    
    // Initialize Weekly Chart
    const weeklyCtx = document.getElementById('weeklyChart').getContext('2d');
    const weeklyChart = KoperasiApp.chart.createLineChart(weeklyCtx, {
        labels: ['25 Mar', '26 Mar', '27 Mar'],
        datasets: [{
            label: 'Total Transaksi',
            data: [22, 18, 25],
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            tension: 0.1
        }, {
            label: 'Total Amount (x1000)',
            data: [4.8, 4.2, 5.25],
            borderColor: 'rgb(255, 99, 132)',
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            tension: 0.1
        }]
    });
});

// View Detail
function viewDetail(date) {
    // Mock data for demonstration
    const detailData = {
        date: date,
        transactions: [
            { time: '10:30', type: 'payment', amount: 450000, member: 'Bapak Ahmad' },
            { time: '09:45', type: 'deposit', amount: 200000, member: 'Ibu Siti' },
            { time: '08:15', type: 'withdrawal', amount: 100000, member: 'Bapak Budi' }
        ]
    };
    
    const content = `
        <h6>Detail Transaksi - ${date}</h6>
        <div class="table-responsive">
            <table class="table table-sm">
                <thead>
                    <tr>
                        <th>Waktu</th>
                        <th>Jenis</th>
                        <th>Anggota</th>
                        <th>Jumlah</th>
                    </tr>
                </thead>
                <tbody>
                    ${detailData.transactions.map(t => `
                        <tr>
                            <td>${t.time}</td>
                            <td><span class="badge bg-${t.type === 'payment' ? 'info' : (t.type === 'deposit' ? 'success' : 'warning')}">${t.type}</span></td>
                            <td>${t.member}</td>
                            <td>Rp ${t.amount.toLocaleString('id-ID')}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
    `;
    
    document.getElementById('detailContent').innerHTML = content;
    KoperasiApp.modal.show('detailModal');
}

// Export Detail
function exportDetail(date) {
    console.log('Exporting detail for:', date);
    KoperasiApp.notification.success(`Detail transaksi ${date} berhasil diexport`);
}

// Export Detail from Modal
function exportDetailFromModal() {
    console.log('Exporting detail from modal');
    KoperasiApp.notification.success('Detail berhasil diexport');
}

// Apply Filter
function applyFilter() {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    
    console.log('Applying filter:', { startDate, endDate });
    KoperasiApp.notification.info('Filter diterapkan');
    
    setTimeout(() => location.reload(), 1000);
}

// Reset Filter
function resetFilter() {
    document.getElementById('startDate').value = '<?php echo date('Y-m-d', strtotime('-7 days')); ?>';
    document.getElementById('endDate').value = '<?php echo date('Y-m-d'); ?>';
    
    console.log('Filter reset');
    KoperasiApp.notification.info('Filter direset');
    
    setTimeout(() => location.reload(), 1000);
}

// Export Report
function exportReport() {
    console.log('Exporting report...');
    KoperasiApp.notification.success('Laporan berhasil diexport ke Excel');
}

// Generate Report
function generateReport() {
    console.log('Generating report...');
    KoperasiApp.notification.success('Laporan berhasil diperbarui');
    setTimeout(() => location.reload(), 1000);
}
</script>
