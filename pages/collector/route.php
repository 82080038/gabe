<?php
/**
 * Collector Route Page
 * Mobile route management for collectors
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
$pageTitle = 'Rute Koleksi';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/mobile/dashboard.php'],
    ['title' => 'Rute', 'url' => '#']
];

// Mock data for today's route
$todayRoute = [
    [
        'id' => 1,
        'name' => 'Bapak Ahmad Wijaya',
        'address' => 'Jl. Merdeka No. 123, RT 02/RW 03, Tebet, Jakarta Selatan',
        'phone' => '0812-3456-7890',
        'kewer_amount' => 50000,
        'mawar_amount' => 100000,
        'total_amount' => 150000,
        'status' => 'pending',
        'visit_time' => null,
        'payment_method' => 'cash',
        'notes' => 'Pembayaran rutin bulanan'
    ],
    [
        'id' => 2,
        'name' => 'Ibu Siti Nurhaliza',
        'address' => 'Jl. Sudirman No. 456, RT 01/RW 05, Kebayoran, Jakarta Selatan',
        'phone' => '0813-2345-6789',
        'kewer_amount' => 75000,
        'mawar_amount' => 150000,
        'total_amount' => 225000,
        'status' => 'visited',
        'visit_time' => '09:30',
        'payment_method' => 'cash',
        'notes' => 'Sudah bayar tepat waktu'
    ],
    [
        'id' => 3,
        'name' => 'Bapak Budi Santoso',
        'address' => 'Jl. Gatotkaca No. 789, RT 03/RW 02, Pancoran, Jakarta Selatan',
        'phone' => '0814-3456-7890',
        'kewer_amount' => 60000,
        'mawar_amount' => 120000,
        'total_amount' => 180000,
        'status' => 'pending',
        'visit_time' => null,
        'payment_method' => 'cash',
        'notes' => 'Biasa bayar di akhir bulan'
    ],
    [
        'id' => 4,
        'name' => 'Ibu Diana Putri',
        'address' => 'Jl. Hayam Wuruk No. 567, RT 04/RW 01, Mampang, Jakarta Selatan',
        'phone' => '0815-2345-6789',
        'kewer_amount' => 40000,
        'mawar_amount' => 80000,
        'total_amount' => 120000,
        'status' => 'pending',
        'visit_time' => null,
        'payment_method' => 'transfer',
        'notes' => 'Prefer transfer bank'
    ],
    [
        'id' => 5,
        'name' => 'Bapak Eko Prasetyo',
        'address' => 'Jl. Thamrin No. 890, RT 02/RW 04, Setiabudi, Jakarta Selatan',
        'phone' => '0816-3456-7890',
        'kewer_amount' => 55000,
        'mawar_amount' => 110000,
        'total_amount' => 165000,
        'status' => 'completed',
        'visit_time' => '10:45',
        'payment_method' => 'cash',
        'notes' => 'Bayar cash, sudah lunas'
    ]
];

// Calculate route statistics
$totalMembers = count($todayRoute);
$visitedMembers = count(array_filter($todayRoute, function($m) { return $m['status'] === 'visited' || $m['status'] === 'completed'; }));
$completedMembers = count(array_filter($todayRoute, function($m) { return $m['status'] === 'completed'; }));
$pendingMembers = count(array_filter($todayRoute, function($m) { return $m['status'] === 'pending'; }));
$totalCollected = array_sum(array_column(array_filter($todayRoute, function($m) { return $m['status'] === 'completed'; }), 'total_amount'));
$totalTarget = array_sum(array_column($todayRoute, 'total_amount'));
$completionRate = ($totalCollected / $totalTarget) * 100;
?>

<div class="container-fluid p-0 mobile-dashboard">
    
    <!-- Route Header -->
    <div class="alert alert-info mb-3">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <strong>Rute Koleksi Hari Ini</strong>
                <br>
                <small class="text-muted">
                    <i class="fas fa-route"></i> Rute A - Tebet Area
                </small>
            </div>
            <div class="text-end">
                <small class="d-block"><?php echo date('d M Y'); ?></small>
                <small class="text-muted"><?php echo date('H:i'); ?></small>
            </div>
        </div>
    </div>
    
    <!-- Route Statistics -->
    <div class="summary-card text-white p-3 mb-3">
        <div class="row text-center">
            <div class="col-3">
                <h4 class="mb-1"><?php echo $visitedMembers; ?></h4>
                <small class="opacity-75">Dikunjungi</small>
            </div>
            <div class="col-3">
                <h4 class="mb-1"><?php echo $completedMembers; ?></h4>
                <small class="opacity-75">Selesai</small>
            </div>
            <div class="col-3">
                <h4 class="mb-1"><?php echo 'Rp ' . number_format($totalCollected, 0, ',', '.'); ?></h4>
                <small class="opacity-75">Terkumpul</small>
            </div>
            <div class="col-3">
                <h4 class="mb-1"><?php echo number_format($completionRate, 1); ?>%</h4>
                <small class="opacity-75">Progress</small>
            </div>
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
                    <small>Kunjungan</small>
                    <small><?php echo $visitedMembers; ?>/<?php echo $totalMembers; ?> anggota</small>
                </div>
                <div class="progress">
                    <div class="progress-bar bg-primary" style="width: <?php echo ($visitedMembers / $totalMembers) * 100; ?>%"></div>
                </div>
            </div>
            <div class="mb-3">
                <div class="d-flex justify-content-between mb-1">
                    <small>Pengumpulan</small>
                    <small><?php echo 'Rp ' . number_format($totalCollected, 0, ',', '.'); ?> / Rp <?php echo number_format($totalTarget, 0, ',', '.'); ?></small>
                </div>
                <div class="progress">
                    <div class="progress-bar bg-success" style="width: <?php echo $completionRate; ?>%"></div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Route Actions -->
    <div class="row mb-3">
        <div class="col-4">
            <button class="btn btn-outline-primary btn-block btn-sm" onclick="startNavigation()">
                <i class="fas fa-map-marked-alt"></i><br>
                <small>Navigasi</small>
            </button>
        </div>
        <div class="col-4">
            <button class="btn btn-outline-success btn-block btn-sm" onclick="quickPayment()">
                <i class="fas fa-money-bill"></i><br>
                <small>Bayar Cepat</small>
            </button>
        </div>
        <div class="col-4">
            <button class="btn btn-outline-info btn-block btn-sm" onclick="routeSummary()">
                <i class="fas fa-chart-line"></i><br>
                <small>Ringkasan</small>
            </button>
        </div>
    </div>
    
    <!-- Members List -->
    <div class="card mb-3">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h6 class="mb-0">Daftar Anggota</h6>
            <span class="badge bg-primary"><?php echo $totalMembers; ?> Anggota</span>
        </div>
        <div class="card-body p-0">
            <div class="list-group list-group-flush">
                <?php foreach ($todayRoute as $index => $member): ?>
                <div class="list-group-item">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center mb-1">
                                <h6 class="mb-0 me-2"><?php echo htmlspecialchars($member['name']); ?></h6>
                                <?php if ($member['status'] === 'completed'): ?>
                                    <span class="badge bg-success">Selesai</span>
                                <?php elseif ($member['status'] === 'visited'): ?>
                                    <span class="badge bg-warning">Dikunjungi</span>
                                <?php else: ?>
                                    <span class="badge bg-secondary">Pending</span>
                                <?php endif; ?>
                            </div>
                            <p class="mb-1 small text-muted">
                                <i class="fas fa-map-marker-alt"></i> 
                                <?php echo htmlspecialchars($member['address']); ?>
                            </p>
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <small class="text-muted">Kewer: </small>
                                    <span class="badge bg-info">Rp <?php echo number_format($member['kewer_amount'], 0, ',', '.'); ?></span>
                                </div>
                                <div>
                                    <small class="text-muted">Mawar: </small>
                                    <span class="badge bg-warning">Rp <?php echo number_format($member['mawar_amount'], 0, ',', '.'); ?></span>
                                </div>
                            </div>
                            <?php if ($member['visit_time']): ?>
                                <small class="text-muted">
                                    <i class="fas fa-clock"></i> Kunjungan: <?php echo $member['visit_time']; ?>
                                </small>
                            <?php endif; ?>
                        </div>
                        <div class="btn-group-vertical">
                            <button class="btn btn-sm btn-outline-primary mb-1" onclick="navigateToMember(<?php echo $index; ?>)">
                                <i class="fas fa-directions"></i>
                            </button>
                            <button class="btn btn-sm btn-outline-success mb-1" onclick="collectPayment(<?php echo $index; ?>)">
                                <i class="fas fa-money-bill"></i>
                            </button>
                            <button class="btn btn-sm btn-outline-info" onclick="viewMemberDetails(<?php echo $index; ?>)">
                                <i class="fas fa-user"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
    </div>
    
    <!-- Quick Actions Bottom -->
    <div class="fixed-bottom bg-white border-top p-3">
        <div class="row">
            <div class="col-6">
                <button class="btn btn-primary btn-block" onclick="completeRoute()">
                    <i class="fas fa-check-circle"></i> Selesai Rute
                </button>
            </div>
            <div class="col-6">
                <button class="btn btn-success btn-block" onclick="emergencyCall()">
                    <i class="fas fa-phone"></i> Darurat
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Payment Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="paymentModalLabel">Pembayaran Simpanan</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="paymentForm">
                    <div class="mb-3">
                        <label class="form-label">Nama Anggota</label>
                        <input type="text" class="form-control" id="paymentMemberName" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Jenis Simpanan</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="kewerPayment" checked>
                            <label class="form-check-label" for="kewerPayment">
                                Kewer (Harian) - <span id="kewerAmount">Rp 0</span>
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="mawarPayment" checked>
                            <label class="form-check-label" for="mawarPayment">
                                Mawar (Bulanan) - <span id="mawarAmount">Rp 0</span>
                            </label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Metode Pembayaran</label>
                        <select class="form-select" id="paymentMethod">
                            <option value="cash">Cash</option>
                            <option value="transfer">Transfer</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Total Pembayaran</label>
                        <input type="text" class="form-control" id="totalPayment" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Catatan</label>
                        <textarea class="form-control" id="paymentNotes" rows="2"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-success" onclick="processPayment()">Proses Pembayaran</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Route data
const routeData = <?php echo json_encode($todayRoute); ?>;
let currentMemberIndex = null;

// Navigate to Member
function navigateToMember(index) {
    const member = routeData[index];
    console.log('Navigating to:', member.name);
    
    // Open Google Maps or similar navigation
    const address = encodeURIComponent(member.address);
    const url = `https://maps.google.com/maps?q=${address}`;
    window.open(url, '_blank');
}

// Collect Payment
function collectPayment(index) {
    currentMemberIndex = index;
    const member = routeData[index];
    
    // Populate payment form
    document.getElementById('paymentMemberName').value = member.name;
    document.getElementById('kewerAmount').textContent = 'Rp ' + member.kewer_amount.toLocaleString('id-ID');
    document.getElementById('mawarAmount').textContent = 'Rp ' + member.mawar_amount.toLocaleString('id-ID');
    document.getElementById('paymentMethod').value = member.payment_method;
    updateTotalPayment();
    
    // Show modal
    $('#paymentModal').modal('show');
}

// Update Total Payment
function updateTotalPayment() {
    const kewerChecked = document.getElementById('kewerPayment').checked;
    const mawarChecked = document.getElementById('mawarPayment').checked;
    const member = routeData[currentMemberIndex];
    
    let total = 0;
    if (kewerChecked) total += member.kewer_amount;
    if (mawarChecked) total += member.mawar_amount;
    
    document.getElementById('totalPayment').value = 'Rp ' + total.toLocaleString('id-ID');
}

// Process Payment
function processPayment() {
    const member = routeData[currentMemberIndex];
    const kewerChecked = document.getElementById('kewerPayment').checked;
    const mawarChecked = document.getElementById('mawarPayment').checked;
    const paymentMethod = document.getElementById('paymentMethod').value;
    const notes = document.getElementById('paymentNotes').value;
    
    // Calculate total
    let total = 0;
    if (kewerChecked) total += member.kewer_amount;
    if (mawarChecked) total += member.mawar_amount;
    
    // Simulate payment processing
    console.log('Processing payment:', {
        member: member.name,
        kewer: kewerChecked,
        mawar: mawarChecked,
        total: total,
        method: paymentMethod,
        notes: notes
    });
    
    // Show success message
    Swal.fire({
        icon: 'success',
        title: 'Pembayaran Berhasil',
        text: `Pembayaran sebesar Rp ${total.toLocaleString('id-ID')} telah dicatat`,
        timer: 2000,
        showConfirmButton: false
    });
    
    // Close modal and reload page
    $('#paymentModal').modal('hide');
    setTimeout(() => location.reload(), 1500);
}

// View Member Details
function viewMemberDetails(index) {
    const member = routeData[index];
    
    Swal.fire({
        title: member.name,
        html: `
            <div class="text-start">
                <p><strong>Alamat:</strong> ${member.address}</p>
                <p><strong>Telepon:</strong> ${member.phone}</p>
                <p><strong>Kewer:</strong> Rp ${member.kewer_amount.toLocaleString('id-ID')}</p>
                <p><strong>Mawar:</strong> Rp ${member.mawar_amount.toLocaleString('id-ID')}</p>
                <p><strong>Total:</strong> Rp ${member.total_amount.toLocaleString('id-ID')}</p>
                <p><strong>Status:</strong> ${member.status}</p>
                <p><strong>Catatan:</strong> ${member.notes}</p>
            </div>
        `,
        icon: 'info',
        confirmButtonText: 'Tutup'
    });
}

// Start Navigation
function startNavigation() {
    Swal.fire({
        title: 'Mulai Navigasi',
        text: 'Arahkan ke anggota pertama dalam rute?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Ya, Mulai',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed) {
            navigateToMember(0);
        }
    });
}

// Quick Payment
function quickPayment() {
    Swal.fire({
        title: 'Pembayaran Cepat',
        input: 'select',
        inputOptions: routeData.map((member, index) => ({
            [index]: `${member.name} - Rp ${member.total_amount.toLocaleString('id-ID')}`
        })),
        inputPlaceholder: 'Pilih anggota',
        showCancelButton: true,
        confirmButtonText: 'Bayar',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed && result.value) {
            collectPayment(parseInt(result.value));
        }
    });
}

// Route Summary
function routeSummary() {
    const completed = routeData.filter(m => m.status === 'completed').length;
    const visited = routeData.filter(m => m.status === 'visited' || m.status === 'completed').length;
    const totalCollected = routeData.filter(m => m.status === 'completed').reduce((sum, m) => sum + m.total_amount, 0);
    
    Swal.fire({
        title: 'Ringkasan Rute',
        html: `
            <div class="text-start">
                <p><strong>Total Anggota:</strong> ${routeData.length}</p>
                <p><strong>Dikunjungi:</strong> ${visited}</p>
                <p><strong>Selesai:</strong> ${completed}</p>
                <p><strong>Total Terkumpul:</strong> Rp ${totalCollected.toLocaleString('id-ID')}</p>
                <p><strong>Progress:</strong> ${((completed / routeData.length) * 100).toFixed(1)}%</p>
            </div>
        `,
        icon: 'info',
        confirmButtonText: 'Tutup'
    });
}

// Complete Route
function completeRoute() {
    Swal.fire({
        title: 'Selesaikan Rute?',
        text: 'Apakah Anda yakin ingin menyelesaikan rute hari ini?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Ya, Selesaikan',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                icon: 'success',
                title: 'Rute Selesai',
                text: 'Terima kasih! Rute hari ini telah selesai.',
                timer: 2000,
                showConfirmButton: false
            }).then(() => {
                window.location.href = '/gabe/pages/mobile/dashboard.php';
            });
        }
    });
}

// Emergency Call
function emergencyCall() {
    Swal.fire({
        title: 'Panggilan Darurat',
        html: `
            <div class="text-start">
                <p><strong>Kantor:</strong> 021-12345678</p>
                <p><strong>Supervisor:</strong> 0812-3456-7890</p>
                <p><strong>Security:</strong> 0813-2345-6789</p>
            </div>
        `,
        icon: 'warning',
        confirmButtonText: 'Tutup'
    });
}

// Update payment total when checkboxes change
document.getElementById('kewerPayment').addEventListener('change', updateTotalPayment);
document.getElementById('mawarPayment').addEventListener('change', updateTotalPayment);

// Add mobile-specific styles
const mobileStyles = `
    .fixed-bottom {
        position: fixed;
        bottom: 0;
        left: 0;
        right: 0;
        z-index: 1030;
    }
    .btn-group-vertical .btn {
        margin-bottom: 2px;
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
styleSheet.textContent = mobileStyles;
document.head.appendChild(styleSheet);
</script>
