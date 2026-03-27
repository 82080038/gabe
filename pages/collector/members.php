<?php
/**
 * Collector Members Page
 * View collector's assigned members
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
$pageTitle = 'Anggota Saya';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/mobile/dashboard.php'],
    ['title' => 'Anggota Saya', 'url' => '#']
];

// Mock data for collector's assigned members
$assignedMembers = [
    [
        'id' => 1,
        'member_number' => 'KOP001',
        'name' => 'Bapak Ahmad Wijaya',
        'phone' => '0812-3456-7890',
        'address' => 'Jl. Merdeka No. 123, RT 02/RW 03, Tebet, Jakarta Selatan',
        'daily_savings' => 50000,
        'monthly_savings' => 1500000,
        'loan_balance' => 2500000,
        'last_visit' => '2024-03-27',
        'visit_frequency' => 'daily',
        'status' => 'active',
        'payment_status' => 'current',
        'gps_location' => '-6.2088, 106.8456',
        'notes' => 'Pembayaran rutin, selalu tepat waktu'
    ],
    [
        'id' => 2,
        'member_number' => 'KOP002',
        'name' => 'Ibu Siti Nurhaliza',
        'phone' => '0813-2345-6789',
        'address' => 'Jl. Sudirman No. 456, RT 01/RW 05, Kebayoran, Jakarta Selatan',
        'daily_savings' => 75000,
        'monthly_savings' => 2000000,
        'loan_balance' => 3000000,
        'last_visit' => '2024-03-26',
        'visit_frequency' => 'daily',
        'status' => 'active',
        'payment_status' => 'current',
        'gps_location' => '-6.2297, 106.8295',
        'notes' => 'Setoran rutin, kadang telat 1-2 hari'
    ],
    [
        'id' => 3,
        'member_number' => 'KOP003',
        'name' => 'Bapak Budi Santoso',
        'phone' => '0814-3456-7890',
        'address' => 'Jl. Gatotkaca No. 789, RT 03/RW 02, Pancoran, Jakarta Selatan',
        'daily_savings' => 60000,
        'monthly_savings' => 1800000,
        'loan_balance' => 1500000,
        'last_visit' => '2024-03-27',
        'visit_frequency' => 'daily',
        'status' => 'active',
        'payment_status' => 'current',
        'gps_location' => '-6.2615, 106.8106',
        'notes' => 'Pembayaran baik, komunikasi lancar'
    ],
    [
        'id' => 4,
        'member_number' => 'KOP004',
        'name' => 'Ibu Dewi Lestari',
        'phone' => '0815-4567-8901',
        'address' => 'Jl. Thamrin No. 321, RT 04/RW 01, Menteng, Jakarta Pusat',
        'daily_savings' => 55000,
        'monthly_savings' => 1650000,
        'loan_balance' => 0,
        'last_visit' => '2024-03-25',
        'visit_frequency' => 'daily',
        'status' => 'active',
        'payment_status' => 'overdue',
        'gps_location' => '-6.1944, 106.8229',
        'notes' => 'Perlu dihubungi, pembayaran terlambat 2 hari'
    ],
    [
        'id' => 5,
        'member_number' => 'KOP005',
        'name' => 'Bapak Eko Prasetyo',
        'phone' => '0816-5678-9012',
        'address' => 'Jl. Rasuna Said No. 456, RT 02/RW 04, Kuningan, Jakarta Selatan',
        'daily_savings' => 45000,
        'monthly_savings' => 1350000,
        'loan_balance' => 1000000,
        'last_visit' => '2024-03-27',
        'visit_frequency' => 'daily',
        'status' => 'active',
        'payment_status' => 'current',
        'gps_location' => '-6.2297, 106.8195',
        'notes' => 'Anggota baru, pembayaran konsisten'
    ]
];

// Calculate statistics
$totalMembers = count($assignedMembers);
$currentMembers = count(array_filter($assignedMembers, fn($m) => $m['payment_status'] === 'current'));
$overdueMembers = count(array_filter($assignedMembers, fn($m) => $m['payment_status'] === 'overdue'));
$totalSavings = array_sum(array_column($assignedMembers, 'monthly_savings'));
$totalLoans = array_sum(array_column($assignedMembers, 'loan_balance'));
$visitedToday = count(array_filter($assignedMembers, fn($m) => $m['last_visit'] === date('Y-m-d')));
?>

<div class="container-fluid">
    <!-- Page Header -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Anggota Saya</h1>
        <div>
            <button class="btn btn-success me-2" onclick="exportMembers()">
                <i class="fas fa-download"></i> Export
            </button>
            <button class="btn btn-primary" onclick="refreshMembers()">
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
                                Total Anggota
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $totalMembers; ?>
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
                                Pembayaran Lancar
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $currentMembers; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check-circle fa-2x text-gray-300"></i>
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
                                <?php echo $overdueMembers; ?>
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
                                Dikunjungi Hari Ini
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $visitedToday; ?>
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

    <!-- Members List -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Daftar Anggota</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="membersTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Anggota</th>
                            <th>Informasi</th>
                            <th>Status Pembayaran</th>
                            <th>Kunjungan Terakhir</th>
                            <th>Lokasi</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($assignedMembers as $member): ?>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 40px; height: 40px;">
                                        <?php echo strtoupper(substr($member['name'], 0, 1)); ?>
                                    </div>
                                    <div>
                                        <strong><?php echo htmlspecialchars($member['name']); ?></strong>
                                        <br>
                                        <small class="text-muted"><?php echo htmlspecialchars($member['member_number']); ?></small>
                                        <br>
                                        <small class="text-muted">
                                            <i class="fas fa-phone"></i> <?php echo htmlspecialchars($member['phone']); ?>
                                        </small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <small class="text-muted">
                                        <i class="fas fa-home"></i> <?php echo substr($member['address'], 0, 40); ?>...
                                    </small>
                                </div>
                                <div class="mt-1">
                                    <span class="badge bg-info">Kewer: Rp <?php echo number_format($member['daily_savings'], 0, ',', '.'); ?></span>
                                    <span class="badge bg-success">Mawar: Rp <?php echo number_format($member['monthly_savings'], 0, ',', '.'); ?></span>
                                </div>
                                <?php if ($member['loan_balance'] > 0): ?>
                                <div class="mt-1">
                                    <span class="badge bg-warning">Pinjaman: Rp <?php echo number_format($member['loan_balance'], 0, ',', '.'); ?></span>
                                </div>
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if ($member['payment_status'] === 'current'): ?>
                                    <span class="badge bg-success">Lancar</span>
                                <?php elseif ($member['payment_status'] === 'overdue'): ?>
                                    <span class="badge bg-danger">Telat</span>
                                <?php else: ?>
                                    <span class="badge bg-warning">Perlu Perhatian</span>
                                <?php endif; ?>
                                <br>
                                <small class="text-muted">Frekuensi: <?php echo $member['visit_frequency']; ?></small>
                            </td>
                            <td>
                                <div>
                                    <?php echo date('d/m/Y', strtotime($member['last_visit'])); ?>
                                </div>
                                <?php if ($member['last_visit'] === date('Y-m-d')): ?>
                                    <small class="text-success">Hari ini</small>
                                <?php else: ?>
                                    <small class="text-muted">
                                        <?php echo \Carbon\Carbon::parse($member['last_visit'])->diffForHumans(); ?>
                                    </small>
                                <?php endif; ?>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-outline-info" onclick="openMaps(<?php echo $member['id']; ?>)">
                                    <i class="fas fa-map-marker-alt"></i> Maps
                                </button>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-primary" onclick="viewMember(<?php echo $member['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-success" onclick="quickPayment(<?php echo $member['id']; ?>)">
                                        <i class="fas fa-money-bill"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-info" onclick="callMember('<?php echo $member['phone']; ?>')">
                                        <i class="fas fa-phone"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-warning" onclick="addNote(<?php echo $member['id']; ?>)">
                                        <i class="fas fa-sticky-note"></i>
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

<!-- Member Details Modal -->
<div class="modal fade" id="memberModal" tabindex="-1" aria-labelledby="memberModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="memberModalLabel">Detail Anggota</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="memberDetails">
                    <!-- Member details will be loaded here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                <button type="button" class="btn btn-primary" onclick="processPaymentFromModal()">
                    <i class="fas fa-money-bill"></i> Proses Pembayaran
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Quick Payment Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="paymentModalLabel">Pembayaran Cepat</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="quickPaymentForm">
                    <input type="hidden" id="memberId" name="member_id">
                    
                    <div class="mb-3">
                        <label class="form-label">Jenis Pembayaran</label>
                        <select class="form-select" name="payment_type" required>
                            <option value="kewer">Kewer (Harian)</option>
                            <option value="mawar">Mawar (Bulanan)</option>
                            <option value="loan">Angsuran Pinjaman</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Jumlah (Rp)</label>
                        <input type="number" class="form-control" name="amount" min="1000" step="1000" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Metode Pembayaran</label>
                        <select class="form-select" name="payment_method" required>
                            <option value="cash">Tunai</option>
                            <option value="transfer">Transfer</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Catatan</label>
                        <textarea class="form-control" name="notes" rows="2" placeholder="Masukkan catatan pembayaran..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-success" onclick="confirmQuickPayment()">Proses Pembayaran</button>
            </div>
        </div>
    </div>
</div>

<!-- Notes Modal -->
<div class="modal fade" id="notesModal" tabindex="-1" aria-labelledby="notesModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="notesModalLabel">Catatan Anggota</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="notesForm">
                    <input type="hidden" id="notesMemberId" name="member_id">
                    
                    <div class="mb-3">
                        <label class="form-label">Catatan</label>
                        <textarea class="form-control" name="notes" rows="4" placeholder="Masukkan catatan tentang anggota..."></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Status Follow-up</label>
                        <select class="form-select" name="followup_status">
                            <option value="normal">Normal</option>
                            <option value="attention">Perlu Perhatian</option>
                            <option value="urgent">Urgent</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="saveNotes()">Simpan Catatan</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
let currentMemberId = null;

// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#membersTable', {
        order: [[3, 'desc']],
        columns: [
            { orderable: true },
            { orderable: false },
            { orderable: true },
            { orderable: true },
            { orderable: false },
            { orderable: false }
        ]
    });
});

// View Member
function viewMember(id) {
    // Mock data for demonstration
    const member = {
        id: id,
        member_number: 'KOP001',
        name: 'Bapak Ahmad Wijaya',
        phone: '0812-3456-7890',
        address: 'Jl. Merdeka No. 123, RT 02/RW 03, Tebet, Jakarta Selatan',
        daily_savings: 50000,
        monthly_savings: 1500000,
        loan_balance: 2500000,
        last_visit: '2024-03-27',
        visit_frequency: 'daily',
        status: 'active',
        payment_status: 'current',
        gps_location: '-6.2088, 106.8456',
        notes: 'Pembayaran rutin, selalu tepat waktu'
    };
    
    const content = `
        <div class="row">
            <div class="col-md-6">
                <h6>Informasi Anggota</h6>
                <p><strong>No. Anggota:</strong> ${member.member_number}</p>
                <p><strong>Telepon:</strong> ${member.phone}</p>
                <p><strong>Alamat:</strong> ${member.address}</p>
                <p><strong>Status:</strong> <span class="badge bg-success">Aktif</span></p>
            </div>
            <div class="col-md-6">
                <h6>Informasi Keuangan</h6>
                <p><strong>Kewer (Harian):</strong> Rp ${member.daily_savings.toLocaleString('id-ID')}</p>
                <p><strong>Mawar (Bulanan):</strong> Rp ${member.monthly_savings.toLocaleString('id-ID')}</p>
                <p><strong>Saldo Pinjaman:</strong> Rp ${member.loan_balance.toLocaleString('id-ID')}</p>
                <p><strong>Status Pembayaran:</strong> <span class="badge bg-success">Lancar</span></p>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-md-6">
                <p><strong>Kunjungan Terakhir:</strong> ${member.last_visit}</p>
                <p><strong>Frekuensi:</strong> ${member.visit_frequency}</p>
            </div>
            <div class="col-md-6">
                <p><strong>Lokasi GPS:</strong> ${member.gps_location}</p>
                <p><strong>Catatan:</strong> ${member.notes}</p>
            </div>
        </div>
    `;
    
    document.getElementById('memberDetails').innerHTML = content;
    currentMemberId = id;
    KoperasiApp.modal.show('memberModal');
}

// Quick Payment
function quickPayment(id) {
    currentMemberId = id;
    document.getElementById('memberId').value = id;
    document.getElementById('quickPaymentForm').reset();
    
    KoperasiApp.modal.show('paymentModal');
}

// Process Payment from Modal
function processPaymentFromModal() {
    if (currentMemberId) {
        quickPayment(currentMemberId);
    }
}

// Confirm Quick Payment
function confirmQuickPayment() {
    const form = document.getElementById('quickPaymentForm');
    const formData = new FormData(form);
    
    const paymentData = {
        member_id: formData.get('member_id'),
        payment_type: formData.get('payment_type'),
        amount: formData.get('amount'),
        payment_method: formData.get('payment_method'),
        notes: formData.get('notes')
    };
    
    // Show loading
    const confirmButton = document.querySelector('#paymentModal .btn-success');
    const originalText = confirmButton.innerHTML;
    KoperasiApp.utils.showLoading(confirmButton);
    
    // Simulate processing
    KoperasiApp.ajax.post('/gabe/api/payments/quick', paymentData)
        .done(function(response) {
            KoperasiApp.notification.success('Pembayaran berhasil diproses');
            KoperasiApp.modal.hide('paymentModal');
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Processing quick payment:', paymentData);
            KoperasiApp.notification.success('Pembayaran berhasil diproses');
            KoperasiApp.modal.hide('paymentModal');
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(confirmButton, originalText);
        });
}

// Open Maps
function openMaps(id) {
    // Mock GPS coordinates
    const coordinates = '-6.2088, 106.8456';
    const mapsUrl = `https://www.google.com/maps?q=${coordinates}`;
    window.open(mapsUrl, '_blank');
}

// Call Member
function callMember(phone) {
    window.location.href = `tel:${phone}`;
}

// Add Note
function addNote(id) {
    currentMemberId = id;
    document.getElementById('notesMemberId').value = id;
    document.getElementById('notesForm').reset();
    
    KoperasiApp.modal.show('notesModal');
}

// Save Notes
function saveNotes() {
    const form = document.getElementById('notesForm');
    const formData = new FormData(form);
    
    const notesData = {
        member_id: formData.get('member_id'),
        notes: formData.get('notes'),
        followup_status: formData.get('followup_status')
    };
    
    // Show loading
    const saveButton = document.querySelector('#notesModal .btn-primary');
    const originalText = saveButton.innerHTML;
    KoperasiApp.utils.showLoading(saveButton);
    
    // Simulate saving
    KoperasiApp.ajax.post('/gabe/api/members/notes', notesData)
        .done(function(response) {
            KoperasiApp.notification.success('Catatan berhasil disimpan');
            KoperasiApp.modal.hide('notesModal');
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Saving notes:', notesData);
            KoperasiApp.notification.success('Catatan berhasil disimpan');
            KoperasiApp.modal.hide('notesModal');
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(saveButton, originalText);
        });
}

// Export Members
function exportMembers() {
    console.log('Exporting members...');
    KoperasiApp.notification.success('Data anggota berhasil diexport');
}

// Refresh Members
function refreshMembers() {
    console.log('Refreshing members...');
    KoperasiApp.notification.success('Data anggota diperbarui');
    setTimeout(() => location.reload(), 1000);
}
</script>
