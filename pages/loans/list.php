<?php
/**
 * Loans List View
 */

// Calculate statistics
$totalLoans = count($loans);
$activeLoans = count(array_filter($loans, fn($l) => $l['status'] === 'active'));
$pendingLoans = count(array_filter($loans, fn($l) => $l['status'] === 'pending'));
$totalOutstanding = array_sum(array_column($loans, 'outstanding_balance'));
$totalDisbursed = array_sum(array_column($loans, 'principal_amount'));
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Manajemen Pinjaman</h1>
        <div>
            <button class="btn btn-success me-2" onclick="exportLoans()">
                <i class="fas fa-download"></i> Export
            </button>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#applyLoanModal">
                <i class="fas fa-plus"></i> Ajukan Pinjaman
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
                                Total Pinjaman
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $totalLoans; ?>
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
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Pinjaman Aktif
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $activeLoans; ?>
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
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Total Outstanding
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalOutstanding, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-chart-line fa-2x text-gray-300"></i>
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
                                Menunggu Persetujuan
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $pendingLoans; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-clock fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Loans Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Daftar Pinjaman</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="loansTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>No. Pinjaman</th>
                            <th>Anggota</th>
                            <th>Produk</th>
                            <th>Plafon</th>
                            <th>Tenor</th>
                            <th>Angsuran</th>
                            <th>Status</th>
                            <th>Outstanding</th>
                            <th>Progress</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($loans as $loan): ?>
                        <tr>
                            <td>
                                <strong><?php echo htmlspecialchars($loan['loan_number']); ?></strong>
                                <br>
                                <small class="text-muted">
                                    Disbursement: <?php echo date('d/m/Y', strtotime($loan['disbursement_date'])); ?>
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
                                <div>
                                    <strong><?php echo htmlspecialchars($loan['product_name']); ?></strong>
                                </div>
                                <small class="text-muted">
                                    Suku Bunga: <?php echo $loan['interest_rate']; ?>% p.a.
                                </small>
                            </td>
                            <td>
                                <span class="badge bg-primary">Rp <?php echo number_format($loan['principal_amount'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <div>
                                    <?php echo $loan['loan_term']; ?> bulan
                                </div>
                                <small class="text-muted">
                                    Mulai: <?php echo date('d/m/Y', strtotime($loan['first_payment_date'])); ?>
                                </small>
                            </td>
                            <td>
                                <span class="badge bg-success">Rp <?php echo number_format($loan['monthly_installment'], 0, ',', '.'); ?></span>
                                <br>
                                <small class="text-muted">/bulan</small>
                            </td>
                            <td>
                                <?php if ($loan['status'] === 'active'): ?>
                                    <span class="badge bg-success">Aktif</span>
                                <?php elseif ($loan['status'] === 'pending'): ?>
                                    <span class="badge bg-warning">Menunggu Persetujuan</span>
                                <?php else: ?>
                                    <span class="badge bg-secondary">Selesai</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <span class="badge bg-info">Rp <?php echo number_format($loan['outstanding_balance'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <div class="progress" style="height: 20px;">
                                    <div class="progress-bar" role="progressbar" 
                                         style="width: <?php echo ($loan['paid_installments'] / $loan['total_installments']) * 100; ?>%;"
                                         aria-valuenow="<?php echo $loan['paid_installments']; ?>" 
                                         aria-valuemin="0" aria-valuemax="<?php echo $loan['total_installments']; ?>">
                                        <?php echo $loan['paid_installments']; ?>/<?php echo $loan['total_installments']; ?>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-info" onclick="viewLoan(<?php echo $loan['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <?php if ($loan['status'] === 'pending'): ?>
                                    <button type="button" class="btn btn-outline-success" onclick="approveLoan(<?php echo $loan['id']; ?>)">
                                        <i class="fas fa-check"></i>
                                    </button>
                                    <?php endif; ?>
                                    <button type="button" class="btn btn-outline-primary" onclick="viewSchedule(<?php echo $loan['id']; ?>)">
                                        <i class="fas fa-calendar"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-warning" onclick="recordPayment(<?php echo $loan['id']; ?>)">
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

<!-- Apply Loan Modal -->
<div class="modal fade" id="applyLoanModal" tabindex="-1" aria-labelledby="applyLoanModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="applyLoanModalLabel">Ajukan Pinjaman Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="applyLoanForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Pilih Anggota</label>
                            <select class="form-select" id="memberSelect" required>
                                <option value="">Pilih Anggota</option>
                                <option value="1">Bapak Ahmad Wijaya (KOP001)</option>
                                <option value="2">Ibu Siti Nurhaliza (KOP002)</option>
                                <option value="3">Bapak Budi Santoso (KOP003)</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Produk Pinjaman</label>
                            <select class="form-select" id="productSelect" required>
                                <option value="">Pilih Produk</option>
                                <option value="regular">Pinjaman Regular</option>
                                <option value="express">Pinjaman Express</option>
                                <option value="modal">Pinjaman Modal Usaha</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Jumlah Pinjaman (Rp)</label>
                            <input type="number" class="form-control" id="loanAmount" min="1000000" max="50000000" step="100000" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Tenor (bulan)</label>
                            <select class="form-select" id="loanTerm" required>
                                <option value="6">6 bulan</option>
                                <option value="12">12 bulan</option>
                                <option value="18">18 bulan</option>
                                <option value="24">24 bulan</option>
                                <option value="36">36 bulan</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Suku Bunga (%)</label>
                            <input type="number" class="form-control" id="interestRate" min="12" max="36" step="0.5" value="24" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Tujuan Pinjaman</label>
                            <textarea class="form-control" id="loanPurpose" rows="3" required></textarea>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Jaminan</label>
                            <textarea class="form-control" id="collateral" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Tanggal Pengajuan</label>
                            <input type="date" class="form-control" id="applicationDate" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Tanggal Disburse (Estimasi)</label>
                            <input type="date" class="form-control" id="disbursementDate" required>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="applyLoan()">Ajukan Pinjaman</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#loansTable', {
        order: [[0, 'asc']],
        columns: [
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: false },
            { orderable: false }
        ]
    });
});

// Apply Loan
function applyLoan() {
    const form = document.getElementById('applyLoanForm');
    
    if (!KoperasiApp.validation.validate(form)) {
        KoperasiApp.notification.error('Silakan lengkapi semua field yang wajib diisi');
        return;
    }
    
    const formData = {
        member_id: document.getElementById('memberSelect').value,
        product: document.getElementById('productSelect').value,
        amount: document.getElementById('loanAmount').value,
        term: document.getElementById('loanTerm').value,
        interest_rate: document.getElementById('interestRate').value,
        purpose: document.getElementById('loanPurpose').value,
        collateral: document.getElementById('collateral').value,
        application_date: document.getElementById('applicationDate').value,
        disbursement_date: document.getElementById('disbursementDate').value
    };
    
    // Show loading
    const applyButton = document.querySelector('#applyLoanModal .btn-primary');
    const originalText = applyButton.innerHTML;
    KoperasiApp.utils.showLoading(applyButton);
    
    // Simulate application
    KoperasiApp.ajax.post('/gabe/api/loans/apply', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Pengajuan pinjaman berhasil diajukan');
            KoperasiApp.modal.hide('applyLoanModal');
            form.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Applying loan:', formData);
            KoperasiApp.notification.success('Pengajuan pinjaman berhasil diajukan');
            KoperasiApp.modal.hide('applyLoanModal');
            form.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(applyButton, originalText);
        });
}

// View Loan
function viewLoan(id) {
    console.log('View loan:', id);
    KoperasiApp.notification.info('Fitur detail pinjaman akan segera tersedia');
}

// Approve Loan
function approveLoan(id) {
    Swal.fire({
        title: 'Setujui Pinjaman?',
        text: 'Apakah Anda yakin ingin menyetujui pinjaman ini?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#28a745',
        cancelButtonColor: '#6c757d',
        confirmButtonText: 'Ya, Setujui',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed) {
            console.log('Approving loan:', id);
            KoperasiApp.notification.success('Pinjaman berhasil disetujui');
            setTimeout(() => location.reload(), 1000);
        }
    });
}

// View Schedule
function viewSchedule(id) {
    console.log('View schedule for loan:', id);
    KoperasiApp.notification.info('Fitur jadwal angsuran akan segera tersedia');
}

// Record Payment
function recordPayment(id) {
    console.log('Record payment for loan:', id);
    KoperasiApp.notification.info('Fitur pembayaran akan segera tersedia');
}

// Export Loans
function exportLoans() {
    console.log('Exporting loans...');
    KoperasiApp.notification.success('Data pinjaman berhasil diexport');
}

// Set today's date as default
document.getElementById('applicationDate').valueAsDate = new Date();
</script>
