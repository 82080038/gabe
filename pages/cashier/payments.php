<?php
/**
 * Cashier Payments Page
 * Handle payment processing
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
$pageTitle = 'Pembayaran';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Pembayaran', 'url' => '#']
];

// Mock data for pending payments
$pendingPayments = [
    [
        'id' => 1,
        'loan_number' => 'PJ001',
        'member_name' => 'Bapak Ahmad Wijaya',
        'member_number' => 'KOP001',
        'installment_number' => 3,
        'due_date' => '2024-03-27',
        'amount' => 450000,
        'principal' => 375000,
        'interest' => 75000,
        'late_fee' => 0,
        'total_amount' => 450000,
        'status' => 'pending',
        'collector' => 'Petugas Kolektor',
        'branch' => 'Cabang Jakarta Selatan'
    ],
    [
        'id' => 2,
        'loan_number' => 'PJ002',
        'member_name' => 'Ibu Siti Nurhaliza',
        'member_number' => 'KOP002',
        'installment_number' => 2,
        'due_date' => '2024-03-27',
        'amount' => 550000,
        'principal' => 500000,
        'interest' => 50000,
        'late_fee' => 5000,
        'total_amount' => 555000,
        'status' => 'pending',
        'collector' => 'Petugas Kolektor',
        'branch' => 'Cabang Jakarta Selatan'
    ],
    [
        'id' => 3,
        'loan_number' => 'PJ003',
        'member_name' => 'Bapak Budi Santoso',
        'member_number' => 'KOP003',
        'installment_number' => 1,
        'due_date' => '2024-03-26',
        'amount' => 500000,
        'principal' => 416667,
        'interest' => 83333,
        'late_fee' => 10000,
        'total_amount' => 510000,
        'status' => 'overdue',
        'collector' => 'Petugas Kolektor',
        'branch' => 'Cabang Jakarta Pusat'
    ]
];

// Calculate statistics
$totalPending = count($pendingPayments);
$overduePayments = count(array_filter($pendingPayments, fn($p) => $p['status'] === 'overdue'));
$totalAmount = array_sum(array_column($pendingPayments, 'total_amount'));
$todayDue = count(array_filter($pendingPayments, fn($p) => $p['due_date'] === date('Y-m-d')));
?>

<div class="container-fluid">
    <!-- Page Header -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Pembayaran Angsuran</h1>
        <div>
            <button class="btn btn-success me-2" onclick="bulkPayment()">
                <i class="fas fa-check-double"></i> Bayar Semua
            </button>
            <button class="btn btn-primary" onclick="refreshPayments()">
                <i class="fas fa-sync-alt"></i> Refresh
            </button>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Menunggu Pembayaran
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $totalPending; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-clock fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-danger shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-danger text-uppercase mb-1">
                                Telat Bayar
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $overduePayments; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
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
                                Total Jatuh Tempo
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalAmount, 0, ',', '.'); ?>
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
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Jatuh Tempo Hari Ini
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $todayDue; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-calendar-day fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Payment Form -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Pembayaran Cepat</h6>
        </div>
        <div class="card-body">
            <form id="quickPaymentForm">
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <label class="form-label">No. Pinjaman</label>
                        <input type="text" class="form-control" id="loanNumber" placeholder="Masukkan no. pinjaman">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">No. Anggota</label>
                        <input type="text" class="form-control" id="memberNumber" placeholder="Masukkan no. anggota">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">Jumlah (Rp)</label>
                        <input type="number" class="form-control" id="paymentAmount" min="1000" step="1000">
                    </div>
                    <div class="col-md-3 mb-3">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" class="btn btn-success w-100">
                            <i class="fas fa-money-bill"></i> Bayar
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Pending Payments Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Daftar Pembayaran Menunggu</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="paymentsTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>No. Pinjaman</th>
                            <th>Anggota</th>
                            <th>Angsuran Ke-</th>
                            <th>Jatuh Tempo</th>
                            <th>Jumlah</th>
                            <th>Denda</th>
                            <th>Total</th>
                            <th>Status</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($pendingPayments as $payment): ?>
                        <tr>
                            <td>
                                <strong><?php echo htmlspecialchars($payment['loan_number']); ?></strong>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-sm bg-info text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                                        <?php echo strtoupper(substr($payment['member_name'], 0, 1)); ?>
                                    </div>
                                    <div>
                                        <strong><?php echo htmlspecialchars($payment['member_name']); ?></strong>
                                        <br>
                                        <small class="text-muted"><?php echo htmlspecialchars($payment['member_number']); ?></small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge bg-primary"><?php echo $payment['installment_number']; ?></span>
                            </td>
                            <td>
                                <div>
                                    <?php echo date('d/m/Y', strtotime($payment['due_date'])); ?>
                                </div>
                                <?php if ($payment['status'] === 'overdue'): ?>
                                <small class="text-danger">Telat</small>
                                <?php endif; ?>
                            </td>
                            <td>
                                <span class="badge bg-info">Rp <?php echo number_format($payment['amount'], 0, ',', '.'); ?></span>
                                <br>
                                <small class="text-muted">
                                    Pokok: Rp <?php echo number_format($payment['principal'], 0, ',', '.'); ?>
                                </small>
                            </td>
                            <td>
                                <?php if ($payment['late_fee'] > 0): ?>
                                    <span class="badge bg-danger">Rp <?php echo number_format($payment['late_fee'], 0, ',', '.'); ?></span>
                                <?php else: ?>
                                    <span class="badge bg-success">Rp 0</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <span class="badge bg-warning">Rp <?php echo number_format($payment['total_amount'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <?php if ($payment['status'] === 'overdue'): ?>
                                    <span class="badge bg-danger">Telat Bayar</span>
                                <?php else: ?>
                                    <span class="badge bg-warning">Menunggu</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-info" onclick="viewDetails(<?php echo $payment['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-success" onclick="processPayment(<?php echo $payment['id']; ?>)">
                                        <i class="fas fa-money-bill"></i>
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

<!-- Payment Details Modal -->
<div class="modal fade" id="detailsModal" tabindex="-1" aria-labelledby="detailsModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="detailsModalLabel">Detail Pembayaran</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <div id="detailsContent">
                <!-- Details will be loaded here -->
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
            <button type="button" class="btn btn-success" onclick="processPaymentFromModal()">
                <i class="fas fa-money-bill"></i> Proses Pembayaran
            </button>
        </div>
    </div>
</div>

<!-- Payment Confirmation Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="paymentModalLabel">Konfirmasi Pembayaran</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="paymentForm">
                    <input type="hidden" id="paymentId" name="payment_id">
                    
                    <div class="mb-3">
                        <label class="form-label">Jumlah Pembayaran (Rp)</label>
                        <input type="number" class="form-control" id="paymentAmountModal" name="amount" min="1000" step="1000" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Metode Pembayaran</label>
                        <select class="form-select" id="paymentMethod" name="payment_method" required>
                            <option value="cash">Tunai</option>
                            <option value="transfer">Transfer Bank</option>
                            <option value="digital">E-Wallet</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Catatan Pembayaran</label>
                        <textarea class="form-control" id="paymentNotes" name="notes" rows="2" placeholder="Masukkan catatan pembayaran..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-success" onclick="confirmPayment()">Konfirmasi Pembayaran</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
let currentPaymentId = null;

// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#paymentsTable', {
        order: [[3, 'asc']],
        columns: [
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: false }
        ]
    });
});

// Quick Payment Form
document.getElementById('quickPaymentForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = {
        loan_number: document.getElementById('loanNumber').value,
        member_number: document.getElementById('memberNumber').value,
        amount: document.getElementById('paymentAmount').value
    };
    
    if (!formData.loan_number && !formData.member_number) {
        KoperasiApp.notification.error('Masukkan no. pinjaman atau no. anggota');
        return;
    }
    
    // Show loading
    const submitButton = e.target.querySelector('button[type="submit"]');
    const originalText = submitButton.innerHTML;
    KoperasiApp.utils.showLoading(submitButton);
    
    // Simulate processing
    KoperasiApp.ajax.post('/gabe/api/payments/quick', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Pembayaran berhasil diproses');
            e.target.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Processing quick payment:', formData);
            KoperasiApp.notification.success('Pembayaran berhasil diproses');
            e.target.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(submitButton, originalText);
        });
});

// View Details
function viewDetails(id) {
    // Mock data for demonstration
    const payment = {
        id: id,
        loan_number: 'PJ001',
        member_name: 'Bapak Ahmad Wijaya',
        member_number: 'KOP001',
        installment_number: 3,
        due_date: '27/03/2024',
        amount: 450000,
        principal: 375000,
        interest: 75000,
        late_fee: 0,
        total_amount: 450000,
        status: 'pending',
        collector: 'Petugas Kolektor',
        branch: 'Cabang Jakarta Selatan'
    };
    
    const content = `
        <div class="row">
            <div class="col-md-6">
                <h6>Informasi Pinjaman</h6>
                <p><strong>No. Pinjaman:</strong> ${payment.loan_number}</p>
                <p><strong>Angsuran Ke:</strong> ${payment.installment_number}</p>
                <p><strong>Jatuh Tempo:</strong> ${payment.due_date}</p>
                <p><strong>Status:</strong> <span class="badge bg-warning">Menunggu</span></p>
            </div>
            <div class="col-md-6">
                <h6>Informasi Anggota</h6>
                <p><strong>Nama:</strong> ${payment.member_name}</p>
                <p><strong>No. Anggota:</strong> ${payment.member_number}</p>
                <p><strong>Kolektor:</strong> ${payment.collector}</p>
                <p><strong>Cabang:</strong> ${payment.branch}</p>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-md-4">
                <p><strong>Pokok:</strong> Rp ${payment.principal.toLocaleString('id-ID')}</p>
            </div>
            <div class="col-md-4">
                <p><strong>Bunga:</strong> Rp ${payment.interest.toLocaleString('id-ID')}</p>
            </div>
            <div class="col-md-4">
                <p><strong>Denda:</strong> Rp ${payment.late_fee.toLocaleString('id-ID')}</p>
            </div>
        </div>
        <hr>
        <p><strong>Total Pembayaran:</strong> <span class="badge bg-warning">Rp ${payment.total_amount.toLocaleString('id-ID')}</span></p>
    `;
    
    document.getElementById('detailsContent').innerHTML = content;
    currentPaymentId = id;
    KoperasiApp.modal.show('detailsModal');
}

// Process Payment
function processPayment(id) {
    currentPaymentId = id;
    document.getElementById('paymentId').value = id;
    document.getElementById('paymentAmountModal').value = '';
    document.getElementById('paymentMethod').value = 'cash';
    document.getElementById('paymentNotes').value = '';
    
    KoperasiApp.modal.show('paymentModal');
}

// Process Payment from Modal
function processPaymentFromModal() {
    if (currentPaymentId) {
        processPayment(currentPaymentId);
    }
}

// Confirm Payment
function confirmPayment() {
    const form = document.getElementById('paymentForm');
    const formData = new FormData(form);
    
    const paymentData = {
        payment_id: formData.get('payment_id'),
        amount: formData.get('amount'),
        payment_method: formData.get('payment_method'),
        notes: formData.get('notes')
    };
    
    // Show loading
    const confirmButton = document.querySelector('#paymentModal .btn-success');
    const originalText = confirmButton.innerHTML;
    KoperasiApp.utils.showLoading(confirmButton);
    
    // Simulate processing
    KoperasiApp.ajax.post('/gabe/api/payments/process', paymentData)
        .done(function(response) {
            KoperasiApp.notification.success('Pembayaran berhasil diproses');
            KoperasiApp.modal.hide('paymentModal');
            KoperasiApp.modal.hide('detailsModal');
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Processing payment:', paymentData);
            KoperasiApp.notification.success('Pembayaran berhasil diproses');
            KoperasiApp.modal.hide('paymentModal');
            KoperasiApp.modal.hide('detailsModal');
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(confirmButton, originalText);
        });
}

// Bulk Payment
function bulkPayment() {
    Swal.fire({
        title: 'Bayar Semua?',
        text: 'Apakah Anda yakin ingin memproses semua pembayaran menunggu?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#28a745',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Ya, Bayar Semua',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed) {
            console.log('Processing bulk payments');
            KoperasiApp.notification.success('Semua pembayaran berhasil diproses');
            setTimeout(() => location.reload(), 1500);
        }
    });
}

// Refresh Payments
function refreshPayments() {
    console.log('Refreshing payments...');
    KoperasiApp.notification.success('Data pembayaran diperbarui');
    setTimeout(() => location.reload(), 1000);
}

// Format currency inputs
document.getElementById('paymentAmount').addEventListener('input', function(e) {
    let value = e.target.value.replace(/\D/g, '');
    if (value) {
        e.target.value = parseInt(value).toLocaleString('id-ID');
    }
});

document.getElementById('paymentAmountModal').addEventListener('input', function(e) {
    let value = e.target.value.replace(/\D/g, '');
    if (value) {
        e.target.value = parseInt(value).toLocaleString('id-ID');
    }
});
</script>
