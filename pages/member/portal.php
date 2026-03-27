<?php
/**
 * Member Portal - Self-Service Interface
 * PWA-enabled member dashboard with comprehensive features
 */

require_once __DIR__ . '/../template_header.php';

// Set page specific variables
$pageTitle = 'Portal Anggota';
$breadcrumbs = [
    ['title' => 'Portal', 'url' => '../pages/member/portal.php']
];

// Add mobile-specific meta tags
echo '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">';
echo '<meta name="apple-mobile-web-app-capable" content="yes">';
echo '<meta name="apple-mobile-web-app-status-bar-style" content="default">';
echo '<meta name="theme-color" content="#28a745">';

// Get member data (mock data for now)
$memberData = [
    'id' => 123,
    'member_number' => 'KOP-2023-001234',
    'name' => 'Ahmad Wijaya',
    'email' => 'ahmad.wijaya@email.com',
    'phone' => '+628123456789',
    'join_date' => '2023-01-15',
    'status' => 'active',
    'branch_name' => 'Cabang Jakarta Pusat',
    'loan_balance' => 15000000,
    'savings_balance' => 25000000,
    'credit_score' => 750,
    'risk_level' => 'Rendah'
];

// Get recent transactions
$recentTransactions = [
    ['type' => 'loan_payment', 'amount' => 1500000, 'date' => '2026-03-26', 'status' => 'completed'],
    ['type' => 'savings_deposit', 'amount' => 1000000, 'date' => '2026-03-25', 'status' => 'completed'],
    ['type' => 'loan_disbursement', 'amount' => 20000000, 'date' => '2026-03-20', 'status' => 'completed']
];

// Get loans data
$loans = [
    ['id' => 1, 'product_name' => 'Pinjaman Mikro', 'amount' => 20000000, 'balance' => 15000000, 'status' => 'active', 'next_payment' => '2026-04-01'],
    ['id' => 2, 'product_name' => 'Pinjaman Modal', 'amount' => 10000000, 'balance' => 5000000, 'status' => 'active', 'next_payment' => '2026-04-05']
];

// Get savings accounts
$savings = [
    ['id' => 1, 'product_name' => 'Simpanan Wajib', 'balance' => 15000000, 'type' => 'mandatory'],
    ['id' => 2, 'product_name' => 'Simpanan Sukarela', 'balance' => 10000000, 'type' => 'voluntary']
];
?>

<div class="container-fluid p-0 member-portal">
    <!-- Member Header -->
    <div class="member-header bg-success text-white p-4">
        <div class="row align-items-center">
            <div class="col-auto">
                <div class="member-avatar">
                    <img src="../assets/images/default-avatar.png" alt="Avatar" class="rounded-circle" width="60" height="60">
                </div>
            </div>
            <div class="col">
                <h4 class="mb-1"><?php echo htmlspecialchars($memberData['name']); ?></h4>
                <small class="opacity-75"><?php echo htmlspecialchars($memberData['member_number']); ?></small>
                <div class="mt-1">
                    <span class="badge bg-white text-success">Aktif</span>
                    <small class="ms-2 opacity-75">
                        <i class="fas fa-star"></i> Skor: <?php echo $memberData['credit_score']; ?>
                    </small>
                </div>
            </div>
            <div class="col-auto">
                <button class="btn btn-light btn-sm" onclick="memberPortal.showProfile()">
                    <i class="fas fa-user"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="quick-stats bg-white p-3 border-bottom">
        <div class="row text-center">
            <div class="col-4">
                <div class="stat-item">
                    <div class="stat-number text-primary"><?php echo number_format($memberData['savings_balance'], 0, ',', '.'); ?></div>
                    <small class="text-muted">Simpanan</small>
                </div>
            </div>
            <div class="col-4">
                <div class="stat-item">
                    <div class="stat-number text-warning"><?php echo number_format($memberData['loan_balance'], 0, ',', '.'); ?></div>
                    <small class="text-muted">Pinjaman</small>
                </div>
            </div>
            <div class="col-4">
                <div class="stat-item">
                    <div class="stat-number text-success">750</div>
                    <small class="text-muted">Skor Kredit</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions bg-white p-3 mb-3">
        <div class="row">
            <div class="col-3">
                <button class="btn btn-outline-primary btn-block p-2 touch-feedback" onclick="memberPortal.applyLoan()">
                    <i class="fas fa-hand-holding-usd fa-lg"></i>
                    <small class="d-block mt-1">Ajukan Pinjaman</small>
                </button>
            </div>
            <div class="col-3">
                <button class="btn btn-outline-success btn-block p-2 touch-feedback" onclick="memberPortal.depositSavings()">
                    <i class="fas fa-piggy-bank fa-lg"></i>
                    <small class="d-block mt-1">Setor Simpanan</small>
                </button>
            </div>
            <div class="col-3">
                <button class="btn btn-outline-info btn-block p-2 touch-feedback" onclick="memberPortal.viewTransactions()">
                    <i class="fas fa-history fa-lg"></i>
                    <small class="d-block mt-1">Riwayat</small>
                </button>
            </div>
            <div class="col-3">
                <button class="btn btn-outline-warning btn-block p-2 touch-feedback" onclick="memberPortal.makePayment()">
                    <i class="fas fa-credit-card fa-lg"></i>
                    <small class="d-block mt-1">Bayar</small>
                </button>
            </div>
        </div>
    </div>

    <!-- Loans Section -->
    <div class="card mb-3">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="mb-0">Pinjaman Saya</h6>
                <button class="btn btn-sm btn-outline-primary" onclick="memberPortal.applyLoan()">
                    <i class="fas fa-plus"></i> Ajukan
                </button>
            </div>
        </div>
        <div class="card-body p-0">
            <?php if (empty($loans)): ?>
            <div class="empty-state p-4">
                <i class="fas fa-hand-holding-usd fa-2x text-muted mb-2"></i>
                <p class="text-muted">Belum ada pinjaman</p>
            </div>
            <?php else: ?>
                <?php foreach ($loans as $loan): ?>
                <div class="loan-item p-3 border-bottom">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <h6 class="mb-1"><?php echo htmlspecialchars($loan['product_name']); ?></h6>
                            <small class="text-muted">Total: <?php echo formatCurrency($loan['amount']); ?></small>
                            <div class="mt-2">
                                <div class="d-flex justify-content-between mb-1">
                                    <small>Sisa Pinjaman</small>
                                    <small class="text-warning"><?php echo formatCurrency($loan['balance']); ?></small>
                                </div>
                                <div class="progress" style="height: 4px;">
                                    <div class="progress-bar bg-warning" style="width: <?php echo ($loan['balance'] / $loan['amount']) * 100; ?>%"></div>
                                </div>
                            </div>
                        </div>
                        <div class="text-end">
                            <span class="badge bg-<?php echo $loan['status'] === 'active' ? 'success' : 'secondary'; ?>">
                                <?php echo ucfirst($loan['status']); ?>
                            </span>
                            <small class="d-block text-muted mt-1">
                                <i class="fas fa-calendar"></i> <?php echo formatDate($loan['next_payment']); ?>
                            </small>
                        </div>
                    </div>
                    <div class="mt-2">
                        <button class="btn btn-sm btn-outline-primary" onclick="memberPortal.viewLoanDetails(<?php echo $loan['id']; ?>)">
                            <i class="fas fa-info-circle"></i> Detail
                        </button>
                        <button class="btn btn-sm btn-outline-success" onclick="memberPortal.makeLoanPayment(<?php echo $loan['id']; ?>)">
                            <i class="fas fa-money-bill"></i> Bayar
                        </button>
                    </div>
                </div>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </div>

    <!-- Savings Section -->
    <div class="card mb-3">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="mb-0">Simpanan Saya</h6>
                <button class="btn btn-sm btn-outline-success" onclick="memberPortal.depositSavings()">
                    <i class="fas fa-plus"></i> Setor
                </button>
            </div>
        </div>
        <div class="card-body p-0">
            <?php if (empty($savings)): ?>
            <div class="empty-state p-4">
                <i class="fas fa-piggy-bank fa-2x text-muted mb-2"></i>
                <p class="text-muted">Belum ada simpanan</p>
            </div>
            <?php else: ?>
                <?php foreach ($savings as $saving): ?>
                <div class="savings-item p-3 border-bottom">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="mb-1"><?php echo htmlspecialchars($saving['product_name']); ?></h6>
                            <small class="text-muted"><?php echo ucfirst($saving['type']); ?></small>
                        </div>
                        <div class="text-end">
                            <div class="savings-balance text-success fw-bold"><?php echo formatCurrency($saving['balance']); ?></div>
                            <small class="text-muted">Saldo</small>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </div>

    <!-- Recent Transactions -->
    <div class="card mb-3">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="mb-0">Transaksi Terbaru</h6>
                <button class="btn btn-sm btn-outline-info" onclick="memberPortal.viewTransactions()">
                    <i class="fas fa-list"></i> Lihat Semua
                </button>
            </div>
        </div>
        <div class="card-body p-0">
            <?php if (empty($recentTransactions)): ?>
            <div class="empty-state p-4">
                <i class="fas fa-history fa-2x text-muted mb-2"></i>
                <p class="text-muted">Belum ada transaksi</p>
            </div>
            <?php else: ?>
                <?php foreach ($recentTransactions as $transaction): ?>
                <div class="transaction-item p-3 border-bottom">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="d-flex align-items-center">
                            <div class="transaction-icon bg-<?php echo $transaction['type'] === 'loan_payment' ? 'success' : ($transaction['type'] === 'savings_deposit' ? 'primary' : 'warning'); ?> text-white rounded-circle p-2 me-3">
                                <i class="fas fa-<?php echo $transaction['type'] === 'loan_payment' ? 'money-bill' : ($transaction['type'] === 'savings_deposit' ? 'piggy-bank' : 'hand-holding-usd'); ?>"></i>
                            </div>
                            <div>
                                <div class="transaction-title">
                                    <?php 
                                    echo $transaction['type'] === 'loan_payment' ? 'Pembayaran Pinjaman' : 
                                         ($transaction['type'] === 'savings_deposit' ? 'Setoran Simpanan' : 'Pencairan Pinjaman'); 
                                    ?>
                                </div>
                                <small class="text-muted"><?php echo formatDate($transaction['date']); ?></small>
                            </div>
                        </div>
                        <div class="text-end">
                            <div class="transaction-amount <?php echo $transaction['type'] === 'loan_payment' ? 'text-success' : 'text-primary'; ?>">
                                <?php echo $transaction['type'] === 'loan_payment' ? '-' : '+'; ?><?php echo formatCurrency($transaction['amount']); ?>
                            </div>
                            <small class="text-muted">
                                <i class="fas fa-check-circle text-success"></i> Selesai
                            </small>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>
    </div>

    <!-- Notifications -->
    <div class="card mb-3">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="mb-0">Notifikasi</h6>
                <span class="badge bg-primary">3</span>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="notification-item p-3 border-bottom">
                <div class="d-flex align-items-start">
                    <div class="notification-icon bg-warning text-white rounded-circle p-2 me-3">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="notification-title">Pembayaran Pinjaman Jatuh Tempo</div>
                        <small class="text-muted">Pinjaman Mikro - jatuh tempo 1 April 2026</small>
                        <div class="mt-1">
                            <small class="text-muted">2 hari yang lalu</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="notification-item p-3 border-bottom">
                <div class="d-flex align-items-start">
                    <div class="notification-icon bg-success text-white rounded-circle p-2 me-3">
                        <i class="fas fa-check"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="notification-title">Pembayaran Berhasil</div>
                        <small class="text-muted">Pembayaran pinjaman Rp 1.500.000 telah diterima</small>
                        <div class="mt-1">
                            <small class="text-muted">1 hari yang lalu</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="notification-item p-3">
                <div class="d-flex align-items-start">
                    <div class="notification-icon bg-info text-white rounded-circle p-2 me-3">
                        <i class="fas fa-info"></i>
                    </div>
                    <div class="flex-grow-1">
                        <div class="notification-title">Promo Simpanan Berhadiah</div>
                        <small class="text-muted">Dapatkan bonus 5% untuk setoran simpanan sukarela</small>
                        <div class="mt-1">
                            <small class="text-muted">3 hari yang lalu</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Links -->
    <div class="card mb-3">
        <div class="card-header">
            <h6 class="mb-0">Layanan Lainnya</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-6 mb-3">
                    <button class="btn btn-outline-primary btn-block p-3 touch-feedback" onclick="memberPortal.viewDocuments()">
                        <i class="fas fa-file-alt fa-lg"></i>
                        <small class="d-block mt-1">Dokumen</small>
                    </button>
                </div>
                <div class="col-6 mb-3">
                    <button class="btn btn-outline-info btn-block p-3 touch-feedback" onclick="memberPortal.viewReports()">
                        <i class="fas fa-chart-bar fa-lg"></i>
                        <small class="d-block mt-1">Laporan</small>
                    </button>
                </div>
                <div class="col-6 mb-3">
                    <button class="btn btn-outline-success btn-block p-3 touch-feedback" onclick="memberPortal.contactSupport()">
                        <i class="fas fa-headset fa-lg"></i>
                        <small class="d-block mt-1">Bantuan</small>
                    </button>
                </div>
                <div class="col-6 mb-3">
                    <button class="btn btn-outline-warning btn-block p-3 touch-feedback" onclick="memberPortal.showSettings()">
                        <i class="fas fa-cog fa-lg"></i>
                        <small class="d-block mt-1">Pengaturan</small>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Profile Modal -->
<div id="profile-modal" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Profil Saya</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="text-center mb-4">
                    <img src="../assets/images/default-avatar.png" alt="Avatar" class="rounded-circle" width="100" height="100">
                    <h5 class="mt-3"><?php echo htmlspecialchars($memberData['name']); ?></h5>
                    <p class="text-muted"><?php echo htmlspecialchars($memberData['member_number']); ?></p>
                </div>
                
                <div class="profile-details">
                    <div class="row mb-3">
                        <div class="col-4">
                            <small class="text-muted">Email</small>
                        </div>
                        <div class="col-8">
                            <p><?php echo htmlspecialchars($memberData['email']); ?></p>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-4">
                            <small class="text-muted">Telepon</small>
                        </div>
                        <div class="col-8">
                            <p><?php echo htmlspecialchars($memberData['phone']); ?></p>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-4">
                            <small class="text-muted">Cabang</small>
                        </div>
                        <div class="col-8">
                            <p><?php echo htmlspecialchars($memberData['branch_name']); ?></p>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-4">
                            <small class="text-muted">Bergabung</small>
                        </div>
                        <div class="col-8">
                            <p><?php echo formatDate($memberData['join_date']); ?></p>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-4">
                            <small class="text-muted">Status</small>
                        </div>
                        <div class="col-8">
                            <span class="badge bg-success">Aktif</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                <button type="button" class="btn btn-primary" onclick="memberPortal.editProfile()">
                    <i class="fas fa-edit"></i> Edit Profil
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Member Portal CSS -->
<link rel="stylesheet" href="../assets/css/member-portal.css">

<!-- Member Portal JavaScript -->
<script src="../assets/js/member-portal.js"></script>

<!-- PWA Development Config -->
<script src="/pwa-dev-config.js"></script>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<?php
// Helper functions
function formatCurrency($amount) {
    return 'Rp ' . number_format($amount, 0, ',', '.');
}

function formatDate($date) {
    return date('d M Y', strtotime($date));
}
?>
