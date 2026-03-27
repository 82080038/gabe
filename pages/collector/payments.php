<?php
/**
 * Collector Payments Page
 * Mobile payment processing for collectors
 */

// Start session
session_start();

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

// Check role permission
if ($_SESSION['user']['role'] !== 'collector') {
    header('Location: /gabe/pages/web/dashboard.php');
    exit;
}

require_once __DIR__ . '/../template_header.php';

// Set page specific variables
$pageTitle = 'Pembayaran';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/mobile/dashboard.php'],
    ['title' => 'Pembayaran', 'url' => '#']
];

// Mock data for recent payments
$recentPayments = [
    [
        'id' => 1,
        'member_name' => 'Bapak Ahmad Wijaya',
        'member_address' => 'Jl. Merdeka No. 123, Tebet',
        'payment_type' => 'kewer',
        'amount' => 50000,
        'payment_method' => 'cash',
        'payment_time' => '2024-03-27 10:30:00',
        'collector_name' => $_SESSION['user']['name'],
        'status' => 'completed'
    ],
    [
        'id' => 2,
        'member_name' => 'Ibu Siti Nurhaliza',
        'member_address' => 'Jl. Sudirman No. 456, Kebayoran',
        'payment_type' => 'mawar',
        'amount' => 150000,
        'payment_method' => 'cash',
        'payment_time' => '2024-03-27 09:45:00',
        'collector_name' => $_SESSION['user']['name'],
        'status' => 'completed'
    ],
    [
        'id' => 3,
        'member_name' => 'Bapak Budi Santoso',
        'member_address' => 'Jl. Gatotkaca No. 789, Pancoran',
        'payment_type' => 'kewer',
        'amount' => 60000,
        'payment_method' => 'transfer',
        'payment_time' => '2024-03-27 08:15:00',
        'collector_name' => $_SESSION['user']['name'],
        'status' => 'completed'
    ]
];

// Mock data for payment summary
$paymentSummary = [
    'today_collected' => 260000,
    'today_target' => 500000,
    'week_collected' => 1200000,
    'week_target' => 2500000,
    'month_collected' => 5200000,
    'month_target' => 10000000
];
?>

<div class="container-fluid p-0 mobile-dashboard">
    
    <!-- Payment Header -->
    <div class="alert alert-info mb-3">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <strong>Pembayaran Simpanan</strong>
                <br>
                <small class="text-muted">
                    <i class="fas fa-money-bill"></i> Proses pembayaran anggota
                </small>
            </div>
            <div class="text-end">
                <small class="d-block"><?php echo date('d M Y'); ?></small>
                <small class="text-muted"><?php echo date('H:i'); ?></small>
            </div>
        </div>
    </div>
    
    <!-- Payment Summary -->
    <div class="summary-card text-white p-3 mb-3">
        <div class="row text-center">
            <div class="col-4">
                <h4 class="mb-1"><?php echo 'Rp ' . number_format($paymentSummary['today_collected'], 0, ',', '.'); ?></h4>
                <small class="opacity-75">Hari Ini</small>
            </div>
            <div class="col-4">
                <h4 class="mb-1"><?php echo 'Rp ' . number_format($paymentSummary['week_collected'], 0, ',', '.'); ?></h4>
                <small class="opacity-75">Minggu Ini</small>
            </div>
            <div class="col-4">
                <h4 class="mb-1"><?php echo 'Rp ' . number_format($paymentSummary['month_collected'], 0, ',', '.'); ?></h4>
                <small class="opacity-75">Bulan Ini</small>
            </div>
        </div>
    </div>
    
    <!-- Progress Overview -->
    <div class="card mb-3">
        <div class="card-header">
            <h6 class="mb-0">Progress Target</h6>
        </div>
        <div class="card-body">
            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <small>Hari Ini</small>
                    <small><?php echo 'Rp ' . number_format($paymentSummary['today_collected'], 0, ',', '.'); ?> / Rp <?php echo number_format($paymentSummary['today_target'], 0, ',', '.'); ?></small>
                </div>
                <div class="progress">
                    <div class="progress-bar bg-primary" style="width: <?php echo ($paymentSummary['today_collected'] / $paymentSummary['today_target']) * 100; ?>%"></div>
                </div>
            </div>
            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <small>Minggu Ini</small>
                    <small><?php echo 'Rp ' . number_format($paymentSummary['week_collected'], 0, ',', '.'); ?> / Rp <?php echo number_format($paymentSummary['week_target'], 0, ',', '.'); ?></small>
                </div>
                <div class="progress">
                    <div class="progress-bar bg-success" style="width: <?php echo ($paymentSummary['week_collected'] / $paymentSummary['week_target']) * 100; ?>%"></div>
                </div>
            </div>
            <div>
                <div class="d-flex justify-content-between mb-1">
                    <small>Bulan Ini</small>
                    <small><?php echo 'Rp ' . number_format($paymentSummary['month_collected'], 0, ',', '.'); ?> / Rp <?php echo number_format($paymentSummary['month_target'], 0, ',', '.'); ?></small>
                </div>
                <div class="progress">
                    <div class="progress-bar bg-warning" style="width: <?php echo ($paymentSummary['month_collected'] / $paymentSummary['month_target']) * 100; ?>%"></div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Quick Actions -->
    <div class="row mb-3">
        <div class="col-6">
            <button class="btn btn-primary btn-block btn-lg btn-mobile-action" onclick="quickPayment()">
                <i class="fas fa-plus-circle icon-large"></i>
                <small>Bayar Cepat</small>
            </button>
        </div>
        <div class="col-6">
            <button class="btn btn-success btn-block btn-lg btn-mobile-action" onclick="batchPayment()">
                <i class="fas fa-users icon-large"></i>
                <small>Bayar Batch</small>
            </button>
        </div>
    </div>
    
    <!-- Payment Statistics -->
    <div class="row mb-3">
        <div class="col-6">
            <div class="card text-center">
                <div class="card-body p-2">
                    <i class="fas fa-check-circle text-success fa-2x mb-2"></i>
                    <h6 class="mb-1"><?php echo count($recentPayments); ?></h6>
                    <small class="text-muted">Transaksi Hari Ini</small>
                </div>
            </div>
        </div>
        <div class="col-6">
            <div class="card text-center">
                <div class="card-body p-2">
                    <i class="fas fa-clock text-warning fa-2x mb-2"></i>
                    <h6 class="mb-1">3</h6>
                    <small class="text-muted">Menunggu Verifikasi</small>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Recent Payments -->
    <div class="card mb-3">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h6 class="mb-0">Pembayaran Terkini</h6>
            <button class="btn btn-sm btn-outline-primary" onclick="refreshPayments()">
                <i class="fas fa-sync-alt"></i>
            </button>
        </div>
        <div class="card-body p-0">
            <div class="list-group list-group-flush">
                <?php foreach ($recentPayments as $payment): ?>
                <div class="list-group-item">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center mb-1">
                                <h6 class="mb-0 me-2"><?php echo htmlspecialchars($payment['member_name']); ?></h6>
                                <span class="badge bg-<?php echo $payment['payment_type'] === 'kewer' ? 'info' : 'warning'; ?>">
                                    <?php echo strtoupper($payment['payment_type']); ?>
                                </span>
                            </div>
                            <p class="mb-1 small text-muted">
                                <i class="fas fa-map-marker-alt"></i> 
                                <?php echo htmlspecialchars($payment['member_address']); ?>
                            </p>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="badge bg-success">Rp <?php echo number_format($payment['amount'], 0, ',', '.'); ?></span>
                                <small class="text-muted">
                                    <i class="fas fa-clock"></i> <?php echo date('H:i', strtotime($payment['payment_time'])); ?>
                                </small>
                            </div>
                        </div>
                        <div class="btn-group-vertical">
                            <button class="btn btn-sm btn-outline-info mb-1" onclick="viewPaymentDetails(<?php echo $payment['id']; ?>)">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-sm btn-outline-warning mb-1" onclick="printReceipt(<?php echo $payment['id']; ?>)">
                                <i class="fas fa-print"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
    </div>
    
    <!-- Payment Methods -->
    <div class="card mb-3">
        <div class="card-header">
            <h6 class="mb-0">Metode Pembayaran</h6>
        </div>
        <div class="card-body">
            <div class="row text-center">
                <div class="col-4">
                    <div class="payment-method-card p-2 border rounded mb-2" onclick="selectPaymentMethod('cash')">
                        <i class="fas fa-money-bill-wave fa-2x text-success mb-2"></i>
                        <p class="mb-0 small">Cash</p>
                    </div>
                </div>
                <div class="col-4">
                    <div class="payment-method-card p-2 border rounded mb-2" onclick="selectPaymentMethod('transfer')">
                        <i class="fas fa-exchange-alt fa-2x text-primary mb-2"></i>
                        <p class="mb-0 small">Transfer</p>
                    </div>
                </div>
                <div class="col-4">
                    <div class="payment-method-card p-2 border rounded mb-2" onclick="selectPaymentMethod('digital')">
                        <i class="fas fa-mobile-alt fa-2x text-info mb-2"></i>
                        <p class="mb-0 small">Digital</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Quick Payment Modal -->
<div class="modal fade" id="quickPaymentModal" tabindex="-1" aria-labelledby="quickPaymentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="quickPaymentModalLabel">Pembayaran Cepat</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="quickPaymentForm">
                    <div class="mb-3">
                        <label class="form-label">Cari Anggota</label>
                        <input type="text" class="form-control" id="memberSearch" placeholder="Masukkan nama atau nomor anggota">
                        <div id="memberSearchResults" class="mt-2"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Jenis Simpanan</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="kewerPayment" checked>
                            <label class="form-check-label" for="kewerPayment">
                                Kewer (Harian)
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="mawarPayment">
                            <label class="form-check-label" for="mawarPayment">
                                Mawar (Bulanan)
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="sukarelaPayment">
                            <label class="form-check-label" for="sukarelaPayment">
                                Sukarela
                            </label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Jumlah</label>
                        <input type="number" class="form-control" id="paymentAmount" placeholder="0" min="0">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Metode Pembayaran</label>
                        <select class="form-select" id="paymentMethod">
                            <option value="cash">Cash</option>
                            <option value="transfer">Transfer</option>
                            <option value="digital">Digital (OVO/Gopay)</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-success" onclick="processQuickPayment()">Proses Pembayaran</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Payment data
const paymentData = <?php echo json_encode($recentPayments); ?>;

// Quick Payment
function quickPayment() {
    $('#quickPaymentModal').modal('show');
}

// Batch Payment
function batchPayment() {
    Swal.fire({
        title: 'Pembayaran Batch',
        text: 'Fitur pembayaran batch akan segera tersedia',
        icon: 'info',
        timer: 2000,
        showConfirmButton: false
    });
}

// View Payment Details
function viewPaymentDetails(id) {
    const payment = paymentData.find(p => p.id === id);
    
    Swal.fire({
        title: 'Detail Pembayaran',
        html: `
            <div class="text-start">
                <p><strong>Anggota:</strong> ${payment.member_name}</p>
                <p><strong>Alamat:</strong> ${payment.member_address}</p>
                <p><strong>Jenis:</strong> ${payment.payment_type.toUpperCase()}</p>
                <p><strong>Jumlah:</strong> Rp ${payment.amount.toLocaleString('id-ID')}</p>
                <p><strong>Metode:</strong> ${payment.payment_method}</p>
                <p><strong>Waktu:</strong> ${new Date(payment.payment_time).toLocaleString('id-ID')}</p>
                <p><strong>Kolektor:</strong> ${payment.collector_name}</p>
                <p><strong>Status:</strong> ${payment.status}</p>
            </div>
        `,
        icon: 'info',
        confirmButtonText: 'Tutup'
    });
}

// Print Receipt
function printReceipt(id) {
    const payment = paymentData.find(p => p.id === id);
    
    Swal.fire({
        title: 'Cetak Struk',
        html: `
            <div class="text-center">
                <h5>KOPERASI BERJALAN</h5>
                <p>Struk Pembayaran</p>
                <hr>
                <div class="text-start">
                    <p><strong>No:</strong> ${String(id).padStart(6, '0')}</p>
                    <p><strong>Tanggal:</strong> ${new Date().toLocaleDateString('id-ID')}</p>
                    <p><strong>Anggota:</strong> ${payment.member_name}</p>
                    <p><strong>Jenis:</strong> ${payment.payment_type.toUpperCase()}</p>
                    <p><strong>Jumlah:</strong> Rp ${payment.amount.toLocaleString('id-ID')}</p>
                    <p><strong>Metode:</strong> ${payment.payment_method}</p>
                </div>
                <hr>
                <p>Terima Kasih</p>
            </div>
        `,
        icon: 'success',
        confirmButtonText: 'Cetak',
        cancelButtonText: 'Batal',
        showCancelButton: true
    }).then((result) => {
        if (result.isConfirmed) {
            window.print();
        }
    });
}

// Refresh Payments
function refreshPayments() {
    Swal.fire({
        icon: 'success',
        title: 'Diperbarui',
        text: 'Data pembayaran telah diperbarui',
        timer: 1000,
        showConfirmButton: false
    });
}

// Select Payment Method
function selectPaymentMethod(method) {
    document.getElementById('paymentMethod').value = method;
    
    // Update UI
    document.querySelectorAll('.payment-method-card').forEach(card => {
        card.classList.remove('border-primary', 'bg-light');
    });
    event.target.closest('.payment-method-card').classList.add('border-primary', 'bg-light');
}

// Process Quick Payment
function processQuickPayment() {
    const memberName = document.getElementById('memberSearch').value;
    const kewer = document.getElementById('kewerPayment').checked;
    const mawar = document.getElementById('mawarPayment').checked;
    const sukarela = document.getElementById('sukarelaPayment').checked;
    const amount = document.getElementById('paymentAmount').value;
    const method = document.getElementById('paymentMethod').value;
    
    if (!memberName || !amount) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Silakan lengkapi semua field'
        });
        return;
    }
    
    // Simulate payment processing
    Swal.fire({
        icon: 'success',
        title: 'Pembayaran Berhasil',
        text: `Pembayaran sebesar Rp ${parseInt(amount).toLocaleString('id-ID')} telah dicatat untuk ${memberName}`,
        timer: 2000,
        showConfirmButton: false
    });
    
    // Close modal and reset form
    $('#quickPaymentModal').modal('hide');
    document.getElementById('quickPaymentForm').reset();
    
    // Reload page after delay
    setTimeout(() => location.reload(), 1500);
}

// Member Search (mock implementation)
document.getElementById('memberSearch').addEventListener('input', function(e) {
    const searchTerm = e.target.value.toLowerCase();
    const resultsDiv = document.getElementById('memberSearchResults');
    
    if (searchTerm.length > 2) {
        // Mock search results
        const mockResults = [
            { name: 'Bapak Ahmad Wijaya', id: 1 },
            { name: 'Ibu Siti Nurhaliza', id: 2 },
            { name: 'Bapak Budi Santoso', id: 3 }
        ];
        
        const filtered = mockResults.filter(member => 
            member.name.toLowerCase().includes(searchTerm)
        );
        
        if (filtered.length > 0) {
            resultsDiv.innerHTML = filtered.map(member => `
                <div class="list-group-item list-group-item-action" onclick="selectMember('${member.name}', ${member.id})">
                    ${member.name}
                </div>
            `).join('');
        } else {
            resultsDiv.innerHTML = '<div class="text-muted">Tidak ada hasil</div>';
        }
    } else {
        resultsDiv.innerHTML = '';
    }
});

// Select Member
function selectMember(name, id) {
    document.getElementById('memberSearch').value = name;
    document.getElementById('memberSearchResults').innerHTML = '';
    
    // Auto-fill amount based on member (mock implementation)
    const memberAmounts = {
        1: 50000,  // Bapak Ahmad
        2: 150000, // Ibu Siti
        3: 60000   // Bapak Budi
    };
    
    document.getElementById('paymentAmount').value = memberAmounts[id] || 0;
}

// Add mobile-specific styles
const mobilePaymentStyles = `
    .payment-method-card {
        cursor: pointer;
        transition: all 0.3s ease;
    }
    .payment-method-card:hover {
        background-color: #f8f9fa;
        transform: translateY(-2px);
    }
    .payment-method-card.selected {
        background-color: #e3f2fd;
        border-color: #2196f3 !important;
    }
    .list-group-item {
        border-left: none;
        border-right: none;
    }
    .list-group-item:first-child {
        border-top: none;
    }
    .list-group-item:last-child {
        border-bottom: none;
    }
`;

const styleSheet = document.createElement('style');
styleSheet.textContent = mobilePaymentStyles;
document.head.appendChild(styleSheet);
</script>
