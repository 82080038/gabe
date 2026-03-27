<?php
/**
 * Loan Approval Page
 * Approve or reject loan applications
 */

// Start session
session_start();

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

// Check role permission
if ($_SESSION['user']['role'] !== 'bos' && $_SESSION['user']['role'] !== 'unit_head' && $_SESSION['user']['role'] !== 'branch_head') {
    header('Location: /gabe/pages/web/dashboard.php');
    exit;
}

require_once __DIR__ . '/../template_header.php';

// Set page specific variables
$pageTitle = 'Persetujuan Pinjaman';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Pinjaman', 'url' => '/gabe/pages/loans.php'],
    ['title' => 'Persetujuan', 'url' => '#']
];

// Mock data for pending loans
$pendingLoans = [
    [
        'id' => 1,
        'loan_number' => 'PJ004',
        'member_name' => 'Ibu Ratna Sari',
        'member_number' => 'KOP005',
        'product_name' => 'Pinjaman Regular',
        'principal_amount' => 3000000,
        'interest_rate' => 24,
        'loan_term' => 12,
        'monthly_installment' => 280000,
        'application_date' => '2024-03-25',
        'application_purpose' => 'Modal usaha kecil',
        'collateral' => 'BPKB Motor',
        'member_savings' => 1500000,
        'member_loans' => 500000,
        'monthly_income' => 2500000,
        'credit_score' => 'B',
        'risk_level' => 'Medium',
        'branch' => 'Cabang Jakarta Selatan',
        'applied_by' => 'Petugas Cabang',
        'status' => 'pending_approval'
    ],
    [
        'id' => 2,
        'loan_number' => 'PJ005',
        'member_name' => 'Bapak Hendra Wijaya',
        'member_number' => 'KOP006',
        'product_name' => 'Pinjaman Express',
        'principal_amount' => 2000000,
        'interest_rate' => 30,
        'loan_term' => 6,
        'monthly_installment' => 380000,
        'application_date' => '2024-03-26',
        'application_purpose' => 'Kebutuhan darurat',
        'collateral' => 'Tidak ada',
        'member_savings' => 800000,
        'member_loans' => 0,
        'monthly_income' => 3500000,
        'credit_score' => 'A',
        'risk_level' => 'Low',
        'branch' => 'Cabang Jakarta Pusat',
        'applied_by' => 'Unit Head',
        'status' => 'pending_approval'
    ],
    [
        'id' => 3,
        'loan_number' => 'PJ006',
        'member_name' => 'Ibu Siti Aminah',
        'member_number' => 'KOP007',
        'product_name' => 'Pinjaman Modal Usaha',
        'principal_amount' => 8000000,
        'interest_rate' => 18,
        'loan_term' => 24,
        'monthly_installment' => 400000,
        'application_date' => '2024-03-27',
        'application_purpose' => 'Ekspansi usaha',
        'collateral' => 'Sertifikat Tanah',
        'member_savings' => 3000000,
        'member_loans' => 2000000,
        'monthly_income' => 4500000,
        'credit_score' => 'B',
        'risk_level' => 'Medium',
        'branch' => 'Cabang Jakarta Selatan',
        'applied_by' => 'Branch Head',
        'status' => 'pending_approval'
    ]
];

// Calculate statistics
$totalPending = count($pendingLoans);
$highRisk = count(array_filter($pendingLoans, fn($l) => $l['risk_level'] === 'High'));
$totalAmount = array_sum(array_column($pendingLoans, 'principal_amount'));
$avgAmount = $totalAmount / $totalPending;
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Persetujuan Pinjaman</h1>
        <div>
            <button class="btn btn-success me-2" onclick="bulkApprove()">
                <i class="fas fa-check-double"></i> Setujui Semua
            </button>
            <button class="btn btn-primary" onclick="refreshApplications()">
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
                                Menunggu Persetujuan
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
                                Risiko Tinggi
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $highRisk; ?>
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
                                Total Plafon
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
                                Rata-rata Plafon
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($avgAmount, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-chart-bar fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter Section -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Filter Aplikasi</h6>
        </div>
        <div class="card-body">
            <div class="row">
                <div class="col-md-3">
                    <label class="form-label">Cabang</label>
                    <select class="form-select" id="branchFilter">
                        <option value="">Semua Cabang</option>
                        <option value="Cabang Jakarta Selatan">Cabang Jakarta Selatan</option>
                        <option value="Cabang Jakarta Pusat">Cabang Jakarta Pusat</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Tingkat Risiko</label>
                    <select class="form-select" id="riskFilter">
                        <option value="">Semua Risiko</option>
                        <option value="Low">Rendah</option>
                        <option value="Medium">Sedang</option>
                        <option value="High">Tinggi</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Skor Kredit</label>
                    <select class="form-select" id="creditFilter">
                        <option value="">Semua Skor</option>
                        <option value="A">A (Baik)</option>
                        <option value="B">B (Cukup)</option>
                        <option value="C">C (Kurang)</option>
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

    <!-- Pending Loans Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Aplikasi Pinjaman Menunggu Persetujuan</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="approvalTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>No. Aplikasi</th>
                            <th>Anggota</th>
                            <th>Plafon</th>
                            <th>Tenor</th>
                            <th>Risiko</th>
                            <th>Skor Kredit</th>
                            <th>Jaminan</th>
                            <th>Status</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($pendingLoans as $loan): ?>
                        <tr>
                            <td>
                                <div>
                                    <strong><?php echo htmlspecialchars($loan['loan_number']); ?></strong>
                                </div>
                                <small class="text-muted">
                                    <?php echo date('d/m/Y', strtotime($loan['application_date'])); ?>
                                </small>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-sm bg-info text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                                        <?php echo strtoupper(substr($loan['member_name'], 0, 1)); ?>
                                    </div>
                                    <div>
                                        <strong><?php echo htmlspecialchars($loan['member_name']); ?></strong>
                                        <br>
                                        <small class="text-muted"><?php echo htmlspecialchars($loan['member_number']); ?></small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge bg-primary">Rp <?php echo number_format($loan['principal_amount'], 0, ',', '.'); ?></span>
                                <br>
                                <small class="text-muted">
                                    Angsuran: Rp <?php echo number_format($loan['monthly_installment'], 0, ',', '.'); ?>
                                </small>
                            </td>
                            <td>
                                <div>
                                    <?php echo $loan['loan_term']; ?> bulan
                                </div>
                                <small class="text-muted">
                                    <?php echo $loan['interest_rate']; ?>% p.a.
                                </small>
                            </td>
                            <td>
                                <span class="badge bg-<?php echo $loan['risk_level'] === 'Low' ? 'success' : ($loan['risk_level'] === 'Medium' ? 'warning' : 'danger'); ?>">
                                    <?php echo $loan['risk_level']; ?>
                                </span>
                            </td>
                            <td>
                                <span class="badge bg-<?php echo $loan['credit_score'] === 'A' ? 'success' : ($loan['credit_score'] === 'B' ? 'warning' : 'danger'); ?>">
                                    <?php echo $loan['credit_score']; ?>
                                </span>
                            </td>
                            <td>
                                <div>
                                    <?php if ($loan['collateral'] === 'Tidak ada'): ?>
                                        <span class="badge bg-danger">Tidak Ada</span>
                                    <?php else: ?>
                                        <span class="badge bg-info"><?php echo htmlspecialchars($loan['collateral']); ?></span>
                                    <?php endif; ?>
                                </div>
                            </td>
                            <td>
                                <span class="badge bg-warning">Menunggu Persetujuan</span>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-info" onclick="viewDetails(<?php echo $loan['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-success" onclick="approveLoan(<?php echo $loan['id']; ?>)">
                                        <i class="fas fa-check"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-danger" onclick="rejectLoan(<?php echo $loan['id']; ?>)">
                                        <i class="fas fa-times"></i>
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
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailsModalLabel">Detail Aplikasi Pinjaman</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="detailsContent">
                    <!-- Details will be loaded here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                <button type="button" class="btn btn-success" onclick="approveFromModal()">
                    <i class="fas fa-check"></i> Setujui
                </button>
                <button type="button" class="btn btn-danger" onclick="rejectFromModal()">
                    <i class="fas fa-times"></i> Tolak
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Approval Modal -->
<div class="modal fade" id="approvalModal" tabindex="-1" aria-labelledby="approvalModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="approvalModalLabel">Konfirmasi Persetujuan</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="approvalForm">
                    <input type="hidden" id="loanId" name="loan_id">
                    <input type="hidden" id="approvalType" name="approval_type">
                    
                    <div class="mb-3">
                        <label class="form-label">Catatan Persetujuan</label>
                        <textarea class="form-control" id="approvalNotes" name="notes" rows="3" placeholder="Masukkan catatan persetujuan..."></textarea>
                    </div>
                    
                    <div class="mb-3" id="disbursementDateDiv" style="display: none;">
                        <label class="form-label">Tanggal Pencairan</label>
                        <input type="date" class="form-control" id="disbursementDate" name="disbursement_date">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="processApproval()">Proses</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
let currentLoanId = null;

// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#approvalTable', {
        order: [[0, 'asc']],
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

// View Details
function viewDetails(id) {
    // Mock data for demonstration
    const loan = {
        id: id,
        loan_number: 'PJ004',
        member_name: 'Ibu Ratna Sari',
        member_number: 'KOP005',
        principal_amount: 3000000,
        interest_rate: 24,
        loan_term: 12,
        monthly_installment: 280000,
        application_date: '25/03/2024',
        application_purpose: 'Modal usaha kecil',
        collateral: 'BPKB Motor',
        member_savings: 1500000,
        member_loans: 500000,
        monthly_income: 2500000,
        credit_score: 'B',
        risk_level: 'Medium',
        branch: 'Cabang Jakarta Selatan',
        applied_by: 'Petugas Cabang'
    };
    
    const content = `
        <div class="row">
            <div class="col-md-6">
                <h6>Informasi Pinjaman</h6>
                <p><strong>No. Pinjaman:</strong> ${loan.loan_number}</p>
                <p><strong>Plafon:</strong> Rp ${loan.principal_amount.toLocaleString('id-ID')}</p>
                <p><strong>Tenor:</strong> ${loan.loan_term} bulan</p>
                <p><strong>Suku Bunga:</strong> ${loan.interest_rate}% p.a.</p>
                <p><strong>Angsuran:</strong> Rp ${loan.monthly_installment.toLocaleString('id-ID')}</p>
                <p><strong>Tujuan:</strong> ${loan.application_purpose}</p>
                <p><strong>Jaminan:</strong> ${loan.collateral}</p>
            </div>
            <div class="col-md-6">
                <h6>Informasi Anggota</h6>
                <p><strong>Nama:</strong> ${loan.member_name}</p>
                <p><strong>No. Anggota:</strong> ${loan.member_number}</p>
                <p><strong>Simpanan:</strong> Rp ${loan.member_savings.toLocaleString('id-ID')}</p>
                <p><strong>Pinjaman Aktif:</strong> Rp ${loan.member_loans.toLocaleString('id-ID')}</p>
                <p><strong>Penghasilan Bulanan:</strong> Rp ${loan.monthly_income.toLocaleString('id-ID')}</p>
                <p><strong>Skor Kredit:</strong> <span class="badge bg-warning">${loan.credit_score}</span></p>
                <p><strong>Tingkat Risiko:</strong> <span class="badge bg-warning">${loan.risk_level}</span></p>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-md-6">
                <p><strong>Tanggal Aplikasi:</strong> ${loan.application_date}</p>
                <p><strong>Cabang:</strong> ${loan.branch}</p>
            </div>
            <div class="col-md-6">
                <p><strong>Diajukan Oleh:</strong> ${loan.applied_by}</p>
                <p><strong>Status:</strong> <span class="badge bg-warning">Menunggu Persetujuan</span></p>
            </div>
        </div>
    `;
    
    document.getElementById('detailsContent').innerHTML = content;
    currentLoanId = id;
    KoperasiApp.modal.show('detailsModal');
}

// Approve Loan
function approveLoan(id) {
    currentLoanId = id;
    document.getElementById('loanId').value = id;
    document.getElementById('approvalType').value = 'approve';
    document.getElementById('disbursementDateDiv').style.display = 'block';
    document.getElementById('disbursementDate').valueAsDate = new Date();
    
    document.getElementById('approvalModalLabel').textContent = 'Setujui Pinjaman';
    KoperasiApp.modal.show('approvalModal');
}

// Reject Loan
function rejectLoan(id) {
    currentLoanId = id;
    document.getElementById('loanId').value = id;
    document.getElementById('approvalType').value = 'reject';
    document.getElementById('disbursementDateDiv').style.display = 'none';
    
    document.getElementById('approvalModalLabel').textContent = 'Tolak Pinjaman';
    KoperasiApp.modal.show('approvalModal');
}

// Approve from Modal
function approveFromModal() {
    if (currentLoanId) {
        approveLoan(currentLoanId);
    }
}

// Reject from Modal
function rejectFromModal() {
    if (currentLoanId) {
        rejectLoan(currentLoanId);
    }
}

// Process Approval
function processApproval() {
    const form = document.getElementById('approvalForm');
    const formData = new FormData(form);
    
    const approvalData = {
        loan_id: formData.get('loan_id'),
        approval_type: formData.get('approval_type'),
        notes: formData.get('notes'),
        disbursement_date: formData.get('disbursement_date')
    };
    
    // Show loading
    const processButton = document.querySelector('#approvalModal .btn-primary');
    const originalText = processButton.innerHTML;
    KoperasiApp.utils.showLoading(processButton);
    
    // Simulate approval process
    KoperasiApp.ajax.post('/gabe/api/loans/approve', approvalData)
        .done(function(response) {
            const action = approvalData.approval_type === 'approve' ? 'disetujui' : 'ditolak';
            KoperasiApp.notification.success(`Pinjaman berhasil ${action}`);
            KoperasiApp.modal.hide('approvalModal');
            KoperasiApp.modal.hide('detailsModal');
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Processing approval:', approvalData);
            const action = approvalData.approval_type === 'approve' ? 'disetujui' : 'ditolak';
            KoperasiApp.notification.success(`Pinjaman berhasil ${action}`);
            KoperasiApp.modal.hide('approvalModal');
            KoperasiApp.modal.hide('detailsModal');
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(processButton, originalText);
        });
}

// Bulk Approve
function bulkApprove() {
    Swal.fire({
        title: 'Setujui Semua Pinjaman?',
        text: 'Apakah Anda yakin ingin menyetujui semua pinjaman yang menunggu?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#28a745',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Ya, Setujui Semua',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed) {
            console.log('Bulk approving all loans');
            KoperasiApp.notification.success('Semua pinjaman berhasil disetujui');
            setTimeout(() => location.reload(), 1500);
        }
    });
}

// Apply Filter
function applyFilter() {
    const branch = document.getElementById('branchFilter').value;
    const risk = document.getElementById('riskFilter').value;
    const credit = document.getElementById('creditFilter').value;
    
    console.log('Applying filter:', { branch, risk, credit });
    KoperasiApp.notification.info('Filter diterapkan');
    
    setTimeout(() => location.reload(), 1000);
}

// Reset Filter
function resetFilter() {
    document.getElementById('branchFilter').value = '';
    document.getElementById('riskFilter').value = '';
    document.getElementById('creditFilter').value = '';
    
    console.log('Filter reset');
    KoperasiApp.notification.info('Filter direset');
    
    setTimeout(() => location.reload(), 1000);
}

// Refresh Applications
function refreshApplications() {
    console.log('Refreshing applications...');
    KoperasiApp.notification.success('Data aplikasi diperbarui');
    setTimeout(() => location.reload(), 1000);
}
</script>
