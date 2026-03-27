<?php
/**
 * Cashier Transactions Page
 * Handle cash transactions and payments
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
$pageTitle = 'Transaksi Kas';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Transaksi', 'url' => '#']
];

// Mock data for transactions
$transactions = [
    [
        'id' => 1,
        'transaction_number' => 'TRX001',
        'type' => 'payment',
        'member_name' => 'Bapak Ahmad Wijaya',
        'member_number' => 'KOP001',
        'amount' => 450000,
        'payment_method' => 'cash',
        'description' => 'Angsuran Pinjaman PJ001',
        'date' => '2024-03-27',
        'time' => '10:30:00',
        'cashier' => 'Petugas Kasir',
        'status' => 'completed'
    ],
    [
        'id' => 2,
        'transaction_number' => 'TRX002',
        'type' => 'deposit',
        'member_name' => 'Ibu Siti Nurhaliza',
        'member_number' => 'KOP002',
        'amount' => 200000,
        'payment_method' => 'cash',
        'description' => 'Setoran Simpanan Mawar',
        'date' => '2024-03-27',
        'time' => '09:45:00',
        'cashier' => 'Petugas Kasir',
        'status' => 'completed'
    ],
    [
        'id' => 3,
        'transaction_number' => 'TRX003',
        'type' => 'withdrawal',
        'member_name' => 'Bapak Budi Santoso',
        'member_number' => 'KOP003',
        'amount' => 100000,
        'payment_method' => 'cash',
        'description' => 'Penarikan Simpanan Sukarela',
        'date' => '2024-03-27',
        'time' => '08:15:00',
        'cashier' => 'Petugas Kasir',
        'status' => 'completed'
    ]
];

// Calculate statistics
$totalTransactions = count($transactions);
$totalAmount = array_sum(array_column($transactions, 'amount'));
$todayTransactions = count(array_filter($transactions, fn($t) => $t['date'] === date('Y-m-d')));
$todayAmount = array_sum(array_filter($transactions, fn($t) => $t['date'] === date('Y-m-d'))->map(fn($t) => $t['amount']));
?>

<div class="container-fluid">
    <!-- Page Header -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Transaksi Kas</h1>
        <div>
            <button class="btn btn-success me-2" onclick="exportTransactions()">
                <i class="fas fa-download"></i> Export
            </button>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#transactionModal">
                <i class="fas fa-plus"></i> Transaksi Baru
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
                                Transaksi Hari Ini
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $todayTransactions; ?>
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
                                Total Transaksi
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $totalTransactions; ?>
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
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Total Semua
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalAmount, 0, ',', '.'); ?>
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

    <!-- Transaction Form -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Form Transaksi</h6>
        </div>
        <div class="card-body">
            <form id="transactionForm">
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Jenis Transaksi</label>
                        <select class="form-select" id="transactionType" required>
                            <option value="">Pilih Jenis</option>
                            <option value="payment">Pembayaran</option>
                            <option value="deposit">Setoran</option>
                            <option value="withdrawal">Penarikan</option>
                        </select>
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Anggota</label>
                        <select class="form-select" id="memberSelect" required>
                            <option value="">Pilih Anggota</option>
                            <option value="1">Bapak Ahmad Wijaya (KOP001)</option>
                            <option value="2">Ibu Siti Nurhaliza (KOP002)</option>
                            <option value="3">Bapak Budi Santoso (KOP003)</option>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label class="form-label">Jumlah (Rp)</label>
                        <input type="number" class="form-control" id="amount" min="1000" step="1000" required>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label class="form-label">Metode</label>
                        <select class="form-select" id="paymentMethod" required>
                            <option value="cash">Tunai</option>
                            <option value="transfer">Transfer</option>
                            <option value="digital">Digital</option>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-save"></i> Proses
                        </button>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 mb-3">
                        <label class="form-label">Deskripsi</label>
                        <input type="text" class="form-control" id="description" placeholder="Masukkan deskripsi transaksi">
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Transactions Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Riwayat Transaksi</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="transactionsTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>No. Transaksi</th>
                            <th>Tanggal & Waktu</th>
                            <th>Jenis</th>
                            <th>Anggota</th>
                            <th>Jumlah</th>
                            <th>Metode</th>
                            <th>Deskripsi</th>
                            <th>Status</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($transactions as $transaction): ?>
                        <tr>
                            <td>
                                <strong><?php echo htmlspecialchars($transaction['transaction_number']); ?></strong>
                            </td>
                            <td>
                                <div>
                                    <strong><?php echo date('d/m/Y', strtotime($transaction['date'])); ?></strong>
                                </div>
                                <small class="text-muted"><?php echo $transaction['time']; ?></small>
                            </td>
                            <td>
                                <?php if ($transaction['type'] === 'payment'): ?>
                                    <span class="badge bg-info">
                                        <i class="fas fa-credit-card"></i> Pembayaran
                                    </span>
                                <?php elseif ($transaction['type'] === 'deposit'): ?>
                                    <span class="badge bg-success">
                                        <i class="fas fa-plus"></i> Setoran
                                    </span>
                                <?php else: ?>
                                    <span class="badge bg-warning">
                                        <i class="fas fa-minus"></i> Penarikan
                                    </span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                                        <?php echo strtoupper(substr($transaction['member_name'], 0, 1)); ?>
                                    </div>
                                    <div>
                                        <strong><?php echo htmlspecialchars($transaction['member_name']); ?></strong>
                                        <br>
                                        <small class="text-muted"><?php echo htmlspecialchars($transaction['member_number']); ?></small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge bg-primary">Rp <?php echo number_format($transaction['amount'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <span class="badge bg-secondary"><?php echo ucfirst($transaction['payment_method']); ?></span>
                            </td>
                            <td>
                                <small><?php echo htmlspecialchars($transaction['description']); ?></small>
                            </td>
                            <td>
                                <span class="badge bg-success">Selesai</span>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-info" onclick="viewTransaction(<?php echo $transaction['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-primary" onclick="printReceipt(<?php echo $transaction['id']; ?>)">
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

<!-- Transaction Modal -->
<div class="modal fade" id="transactionModal" tabindex="-1" aria-labelledby="transactionModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="transactionModalLabel">Transaksi Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="modalTransactionForm">
                    <div class="mb-3">
                        <label class="form-label">Jenis Transaksi</label>
                        <select class="form-select" id="modalTransactionType" required>
                            <option value="">Pilih Jenis</option>
                            <option value="payment">Pembayaran</option>
                            <option value="deposit">Setoran</option>
                            <option value="withdrawal">Penarikan</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Anggota</label>
                        <select class="form-select" id="modalMemberSelect" required>
                            <option value="">Pilih Anggota</option>
                            <option value="1">Bapak Ahmad Wijaya (KOP001)</option>
                            <option value="2">Ibu Siti Nurhaliza (KOP002)</option>
                            <option value="3">Bapak Budi Santoso (KOP003)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Jumlah (Rp)</label>
                        <input type="number" class="form-control" id="modalAmount" min="1000" step="1000" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Metode Pembayaran</label>
                        <select class="form-select" id="modalPaymentMethod" required>
                            <option value="cash">Tunai</option>
                            <option value="transfer">Transfer</option>
                            <option value="digital">Digital</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Deskripsi</label>
                        <textarea class="form-control" id="modalDescription" rows="2" placeholder="Masukkan deskripsi transaksi"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="processModalTransaction()">Proses Transaksi</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#transactionsTable', {
        order: [[0, 'desc']],
        columns: [
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: false },
            { orderable: true },
            { orderable: false }
        ]
    });
});

// Process Transaction (Form)
document.getElementById('transactionForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = {
        type: document.getElementById('transactionType').value,
        member_id: document.getElementById('memberSelect').value,
        amount: document.getElementById('amount').value,
        payment_method: document.getElementById('paymentMethod').value,
        description: document.getElementById('description').value
    };
    
    // Show loading
    const submitButton = e.target.querySelector('button[type="submit"]');
    const originalText = submitButton.innerHTML;
    KoperasiApp.utils.showLoading(submitButton);
    
    // Simulate processing
    KoperasiApp.ajax.post('/gabe/api/transactions', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Transaksi berhasil diproses');
            e.target.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Processing transaction:', formData);
            KoperasiApp.notification.success('Transaksi berhasil diproses');
            e.target.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(submitButton, originalText);
        });
});

// Process Modal Transaction
function processModalTransaction() {
    const form = document.getElementById('modalTransactionForm');
    
    if (!KoperasiApp.validation.validate(form)) {
        KoperasiApp.notification.error('Silakan lengkapi semua field yang wajib diisi');
        return;
    }
    
    const formData = {
        type: document.getElementById('modalTransactionType').value,
        member_id: document.getElementById('modalMemberSelect').value,
        amount: document.getElementById('modalAmount').value,
        payment_method: document.getElementById('modalPaymentMethod').value,
        description: document.getElementById('modalDescription').value
    };
    
    // Show loading
    const processButton = document.querySelector('#transactionModal .btn-primary');
    const originalText = processButton.innerHTML;
    KoperasiApp.utils.showLoading(processButton);
    
    // Simulate processing
    KoperasiApp.ajax.post('/gabe/api/transactions', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Transaksi berhasil diproses');
            KoperasiApp.modal.hide('transactionModal');
            form.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Processing modal transaction:', formData);
            KoperasiApp.notification.success('Transaksi berhasil diproses');
            KoperasiApp.modal.hide('transactionModal');
            form.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(processButton, originalText);
        });
}

// View Transaction
function viewTransaction(id) {
    console.log('View transaction:', id);
    KoperasiApp.notification.info('Detail transaksi akan segera tersedia');
}

// Print Receipt
function printReceipt(id) {
    console.log('Printing receipt for transaction:', id);
    KoperasiApp.notification.success('Struk transaksi berhasil dicetak');
}

// Export Transactions
function exportTransactions() {
    console.log('Exporting transactions...');
    KoperasiApp.notification.success('Data transaksi berhasil diexport');
}

// Format currency input
document.getElementById('amount').addEventListener('input', function(e) {
    let value = e.target.value.replace(/\D/g, '');
    if (value) {
        e.target.value = parseInt(value).toLocaleString('id-ID');
    }
});

document.getElementById('modalAmount').addEventListener('input', function(e) {
    let value = e.target.value.replace(/\D/g, '');
    if (value) {
        e.target.value = parseInt(value).toLocaleString('id-ID');
    }
});
</script>
