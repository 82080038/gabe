<?php
/**
 * Collector History Page
 * View collection and payment history
 */

// Start session
session_start();

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

// Check collector role
if ($_SESSION['user']['role'] !== 'collector') {
    header('Location: /gabe/pages/web/dashboard.php');
    exit;
}

require_once __DIR__ . '/../template_header.php';

// Set page specific variables
$pageTitle = 'Riwayat Aktivitas';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/mobile/dashboard.php'],
    ['title' => 'Riwayat', 'url' => '#']
];

// Mock data for history
$historyData = [
    [
        'id' => 1,
        'date' => '2024-03-27',
        'time' => '10:30:00',
        'type' => 'collection',
        'member_name' => 'Bapak Ahmad Wijaya',
        'member_number' => 'KOP001',
        'amount' => 50000,
        'savings_type' => 'Kewer',
        'location' => 'Jl. Merdeka No. 123',
        'status' => 'completed',
        'notes' => 'Pembayaran lancar'
    ],
    [
        'id' => 2,
        'date' => '2024-03-27',
        'time' => '09:45:00',
        'type' => 'collection',
        'member_name' => 'Ibu Siti Nurhaliza',
        'member_number' => 'KOP002',
        'amount' => 75000,
        'savings_type' => 'Kewer',
        'location' => 'Jl. Sudirman No. 456',
        'status' => 'completed',
        'notes' => 'Pembayaran tepat waktu'
    ],
    [
        'id' => 3,
        'date' => '2024-03-26',
        'time' => '15:20:00',
        'type' => 'payment',
        'member_name' => 'Bapak Budi Santoso',
        'member_number' => 'KOP003',
        'amount' => 450000,
        'loan_number' => 'PJ003',
        'location' => 'Jl. Gatotkaca No. 789',
        'status' => 'completed',
        'notes' => 'Angsuran bulanan'
    ],
    [
        'id' => 4,
        'date' => '2024-03-26',
        'time' => '11:15:00',
        'type' => 'collection',
        'member_name' => 'Ibu Dewi Lestari',
        'member_number' => 'KOP004',
        'amount' => 60000,
        'savings_type' => 'Kewer',
        'location' => 'Jl. Thamrin No. 321',
        'status' => 'completed',
        'notes' => 'Pembayaran rutin'
    ]
];

// Calculate statistics
$totalCollections = count(array_filter($historyData, fn($h) => $h['type'] === 'collection'));
$totalPayments = count(array_filter($historyData, fn($h) => $h['type'] === 'payment'));
$todayCollections = count(array_filter($historyData, fn($h) => $h['type'] === 'collection' && $h['date'] === date('Y-m-d')));
$todayAmount = array_sum(array_filter($historyData, fn($h) => $h['date'] === date('Y-m-d'))->map(fn($h) => $h['amount']));
?>

<div class="container-fluid">
    <!-- Page Header -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Riwayat Aktivitas</h1>
        <div>
            <button class="btn btn-success me-2" onclick="exportHistory()">
                <i class="fas fa-download"></i> Export
            </button>
            <button class="btn btn-primary" onclick="refreshHistory()">
                <i class="fas fa-sync-alt"></i> Refresh
            </button>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Total Koleksi Hari Ini
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $todayCollections; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-calendar-day fa-2x text-gray-300"></i>
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
                                Total Hari Ini
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($todayAmount, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-money-bill fa-2x text-gray-300"></i>
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
                                Total Koleksi
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $totalCollections; ?>
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
                                Total Pembayaran
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $totalPayments; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-credit-card fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Filter Riwayat</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <label class="form-label">Dari Tanggal</label>
                    <input type="date" class="form-control" id="startDate" value="<?php echo date('Y-m-d', strtotime('-7 days')); ?>">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Sampai Tanggal</label>
                    <input type="date" class="form-control" id="endDate" value="<?php echo date('Y-m-d'); ?>">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Jenis Aktivitas</label>
                    <select class="form-select" id="activityType">
                        <option value="">Semua Jenis</option>
                        <option value="collection">Koleksi</option>
                        <option value="payment">Pembayaran</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">&nbsp;</label>
                    <div>
                        <button class="btn btn-primary btn-sm" onclick="applyFilter()">
                            <i class="fas fa-filter"></i> Terapkan
                        </button>
                        <button class="btn btn-secondary btn-sm" onclick="resetFilter()">
                            <i class="fas fa-undo"></i> Reset
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- History Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Riwayat Aktivitas</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="historyTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Tanggal & Waktu</th>
                            <th>Jenis</th>
                            <th>Anggota</th>
                            <th>Jumlah</th>
                            <th>Lokasi</th>
                            <th>Status</th>
                            <th>Catatan</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($historyData as $history): ?>
                        <tr>
                            <td>
                                <div>
                                    <strong><?php echo date('d/m/Y', strtotime($history['date'])); ?></strong>
                                </div>
                                <small class="text-muted"><?php echo $history['time']; ?></small>
                            </td>
                            <td>
                                <?php if ($history['type'] === 'collection'): ?>
                                    <span class="badge bg-success">
                                        <i class="fas fa-hand-holding-usd"></i> Koleksi
                                    </span>
                                <?php else: ?>
                                    <span class="badge bg-info">
                                        <i class="fas fa-credit-card"></i> Pembayaran
                                    </span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                                        <?php echo strtoupper(substr($history['member_name'], 0, 1)); ?>
                                    </div>
                                    <div>
                                        <strong><?php echo htmlspecialchars($history['member_name']); ?></strong>
                                        <br>
                                        <small class="text-muted"><?php echo htmlspecialchars($history['member_number']); ?></small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge bg-primary">Rp <?php echo number_format($history['amount'], 0, ',', '.'); ?></span>
                                <?php if (isset($history['savings_type'])): ?>
                                <br>
                                <small class="text-muted"><?php echo htmlspecialchars($history['savings_type']); ?></small>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div>
                                    <i class="fas fa-map-marker-alt"></i> <?php echo htmlspecialchars($history['location']); ?>
                                </div>
                            </td>
                            <td>
                                <?php if ($history['status'] === 'completed'): ?>
                                    <span class="badge bg-success">Selesai</span>
                                <?php else: ?>
                                    <span class="badge bg-warning">Pending</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <small><?php echo htmlspecialchars($history['notes']); ?></small>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-info" onclick="viewDetails(<?php echo $history['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-primary" onclick="printReceipt(<?php echo $history['id']; ?>)">
                                        <i class="fas fa-print"></i>
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

<!-- Details Modal -->
<div class="modal fade" id="detailsModal" tabindex="-1" aria-labelledby="detailsModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailsModalLabel">Detail Aktivitas</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="detailsContent">
                    <!-- Details will be loaded here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                <button type="button" class="btn btn-primary" onclick="printReceipt()">
                    <i class="fas fa-print"></i> Cetak Struk
                </button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#historyTable', {
        order: [[0, 'desc']],
        columns: [
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: false },
            { orderable: true },
            { orderable: false },
            { orderable: false }
        ]
    });
});

// View Details
function viewDetails(id) {
    // Mock data for demonstration
    const details = {
        id: id,
        date: '27/03/2024',
        time: '10:30:00',
        type: 'collection',
        member_name: 'Bapak Ahmad Wijaya',
        member_number: 'KOP001',
        amount: 50000,
        savings_type: 'Kewer',
        location: 'Jl. Merdeka No. 123',
        status: 'completed',
        notes: 'Pembayaran lancar',
        collector_name: '<?php echo $_SESSION['user']['name']; ?>'
    };
    
    const content = `
        <div class="row">
            <div class="col-md-6">
                <p><strong>Tanggal:</strong> ${details.date}</p>
                <p><strong>Waktu:</strong> ${details.time}</p>
                <p><strong>Jenis:</strong> ${details.type === 'collection' ? 'Koleksi' : 'Pembayaran'}</p>
                <p><strong>Status:</strong> <span class="badge bg-success">Selesai</span></p>
            </div>
            <div class="col-md-6">
                <p><strong>Anggota:</strong> ${details.member_name}</p>
                <p><strong>No. Anggota:</strong> ${details.member_number}</p>
                <p><strong>Jumlah:</strong> Rp ${details.amount.toLocaleString('id-ID')}</p>
                <p><strong>Lokasi:</strong> ${details.location}</p>
            </div>
        </div>
        <hr>
        <p><strong>Catatan:</strong> ${details.notes}</p>
        <p><strong>Petugas:</strong> ${details.collector_name}</p>
    `;
    
    document.getElementById('detailsContent').innerHTML = content;
    KoperasiApp.modal.show('detailsModal');
}

// Print Receipt
function printReceipt(id) {
    console.log('Printing receipt for:', id);
    KoperasiApp.notification.success('Struk berhasil dicetak');
}

// Apply Filter
function applyFilter() {
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    const activityType = document.getElementById('activityType').value;
    
    console.log('Applying filter:', { startDate, endDate, activityType });
    KoperasiApp.notification.info('Filter diterapkan');
    
    // In real implementation, this would reload data with filters
    setTimeout(() => location.reload(), 1000);
}

// Reset Filter
function resetFilter() {
    document.getElementById('startDate').value = '<?php echo date('Y-m-d', strtotime('-7 days')); ?>';
    document.getElementById('endDate').value = '<?php echo date('Y-m-d'); ?>';
    document.getElementById('activityType').value = '';
    
    console.log('Filter reset');
    KoperasiApp.notification.info('Filter direset');
    
    setTimeout(() => location.reload(), 1000);
}

// Export History
function exportHistory() {
    console.log('Exporting history...');
    KoperasiApp.notification.success('Riwayat berhasil diexport');
}

// Refresh History
function refreshHistory() {
    console.log('Refreshing history...');
    KoperasiApp.notification.success('Data riwayat diperbarui');
    setTimeout(() => location.reload(), 1000);
}
</script>
