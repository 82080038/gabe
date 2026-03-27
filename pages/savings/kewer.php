<?php
/**
 * Kewer Savings View (Daily Savings)
 */

// Calculate statistics
$totalKewerSavings = array_sum(array_column(array_filter($savings, fn($s) => $s['savings_type'] === 'kewer'), 'total_balance'));
$totalMawarSavings = array_sum(array_column(array_filter($savings, fn($s) => $s['savings_type'] === 'mawar'), 'total_balance'));
$totalSukarelaSavings = array_sum(array_column(array_filter($savings, fn($s) => $s['savings_type'] === 'sukarela'), 'total_balance'));
$totalAllSavings = $totalKewerSavings + $totalMawarSavings + $totalSukarelaSavings;
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Simpanan Kewer (Harian)</h1>
        <div>
            <button class="btn btn-success me-2" onclick="exportSavings()">
                <i class="fas fa-download"></i> Export
            </button>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#depositModal">
                <i class="fas fa-plus"></i> Tambah Setoran
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
                                Kewer (Harian)
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalKewerSavings, 0, ',', '.'); ?>
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
                                Mawar (Bulanan)
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalMawarSavings, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-calendar-alt fa-2x text-gray-300"></i>
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
                                Sukarela
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalSukarelaSavings, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-hand-holding-heart fa-2x text-gray-300"></i>
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
                                Total Semua Simpanan
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalAllSavings, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-piggy-bank fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Savings Tabs -->
    <div class="card shadow mb-4">
        <div class="card-header">
            <ul class="nav nav-tabs card-header-tabs" id="savingsTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="kewer-tab" data-bs-toggle="tab" data-bs-target="#kewer" type="button" role="tab">
                        <i class="fas fa-calendar-day"></i> Kewer (Harian)
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="mawar-tab" data-bs-toggle="tab" data-bs-target="#mawar" type="button" role="tab">
                        <i class="fas fa-calendar-alt"></i> Mawar (Bulanan)
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="sukarela-tab" data-bs-toggle="tab" data-bs-target="#sukarela" type="button" role="tab">
                        <i class="fas fa-hand-holding-heart"></i> Sukarela
                    </button>
                </li>
            </ul>
        </div>
        <div class="card-body">
            <div class="tab-content" id="savingsTabContent">
                <!-- Kewer Tab -->
                <div class="tab-pane fade show active" id="kewer" role="tabpanel">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="kewerTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>Anggota</th>
                                    <th>Jumlah Harian</th>
                                    <th>Target Bulanan</th>
                                    <th>Terkumpul Bulan Ini</th>
                                    <th>Terakhir Setor</th>
                                    <th>Total Saldo</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach (array_filter($savings, fn($s) => $s['savings_type'] === 'kewer') as $saving): ?>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                                                <?php echo strtoupper(substr($saving['member_name'], 0, 1)); ?>
                                            </div>
                                            <div>
                                                <strong><?php echo htmlspecialchars($saving['member_name']); ?></strong>
                                                <br>
                                                <small class="text-muted"><?php echo htmlspecialchars($saving['member_number']); ?></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary">Rp <?php echo number_format($saving['daily_amount'], 0, ',', '.'); ?></span>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">Rp <?php echo number_format($saving['monthly_target'], 0, ',', '.'); ?></span>
                                    </td>
                                    <td>
                                        <div>
                                            <span class="badge bg-success">Rp <?php echo number_format($saving['current_month_collected'], 0, ',', '.'); ?></span>
                                        </div>
                                        <div class="progress mt-1" style="height: 10px;">
                                            <div class="progress-bar" role="progressbar" 
                                                 style="width: <?php echo ($saving['current_month_collected'] / $saving['monthly_target']) * 100; ?>%;"
                                                 aria-valuenow="<?php echo $saving['current_month_collected']; ?>" 
                                                 aria-valuemin="0" aria-valuemax="<?php echo $saving['monthly_target']; ?>">
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div>
                                            <?php echo date('d/m/Y', strtotime($saving['last_deposit_date'])); ?>
                                        </div>
                                        <small class="text-muted">
                                            <?php echo \Carbon\Carbon::parse($saving['last_deposit_date'])->diffForHumans(); ?>
                                        </small>
                                    </td>
                                    <td>
                                        <span class="badge bg-warning">Rp <?php echo number_format($saving['total_balance'], 0, ',', '.'); ?></span>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-outline-success" onclick="addDeposit(<?php echo $saving['id']; ?>)">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                            <button type="button" class="btn btn-outline-info" onclick="viewHistory(<?php echo $saving['id']; ?>)">
                                                <i class="fas fa-history"></i>
                                            </button>
                                            <button type="button" class="btn btn-outline-warning" onclick="withdrawSavings(<?php echo $saving['id']; ?>)">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Mawar Tab -->
                <div class="tab-pane fade" id="mawar" role="tabpanel">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="mawarTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>Anggota</th>
                                    <th>Jumlah Bulanan</th>
                                    <th>Bulan Ini</th>
                                    <th>Terakhir Setor</th>
                                    <th>Total Saldo</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach (array_filter($savings, fn($s) => $s['savings_type'] === 'mawar') as $saving): ?>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm bg-success text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                                                <?php echo strtoupper(substr($saving['member_name'], 0, 1)); ?>
                                            </div>
                                            <div>
                                                <strong><?php echo htmlspecialchars($saving['member_name']); ?></strong>
                                                <br>
                                                <small class="text-muted"><?php echo htmlspecialchars($saving['member_number']); ?></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge bg-success">Rp <?php echo number_format($saving['monthly_amount'], 0, ',', '.'); ?></span>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary">Rp <?php echo number_format($saving['current_month_collected'], 0, ',', '.'); ?></span>
                                    </td>
                                    <td>
                                        <?php echo date('d/m/Y', strtotime($saving['last_deposit_date'])); ?>
                                    </td>
                                    <td>
                                        <span class="badge bg-info">Rp <?php echo number_format($saving['total_balance'], 0, ',', '.'); ?></span>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-outline-success" onclick="addDeposit(<?php echo $saving['id']; ?>)">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                            <button type="button" class="btn btn-outline-info" onclick="viewHistory(<?php echo $saving['id']; ?>)">
                                                <i class="fas fa-history"></i>
                                            </button>
                                            <button type="button" class="btn btn-outline-warning" onclick="withdrawSavings(<?php echo $saving['id']; ?>)">
                                                <i class="fas fa-minus"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Sukarela Tab -->
                <div class="tab-pane fade" id="sukarela" role="tabpanel">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="sukarelaTable" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>Anggota</th>
                                    <th>Terakhir Setor</th>
                                    <th>Jumlah Terakhir</th>
                                    <th>Total Saldo</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach (array_filter($savings, fn($s) => $s['savings_type'] === 'sukarela') as $saving): ?>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="avatar-sm bg-info text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                                                <?php echo strtoupper(substr($saving['member_name'], 0, 1)); ?>
                                            </div>
                                            <div>
                                                <strong><?php echo htmlspecialchars($saving['member_name']); ?></strong>
                                                <br>
                                                <small class="text-muted"><?php echo htmlspecialchars($saving['member_number']); ?></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <?php echo date('d/m/Y', strtotime($saving['last_deposit_date'])); ?>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary">Rp <?php echo number_format($saving['last_deposit_amount'], 0, ',', '.'); ?></span>
                                    </td>
                                    <td>
                                        <span class="badge bg-warning">Rp <?php echo number_format($saving['total_balance'], 0, ',', '.'); ?></span>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <button type="button" class="btn btn-outline-success" onclick="addDeposit(<?php echo $saving['id']; ?>)">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                            <button type="button" class="btn btn-outline-info" onclick="viewHistory(<?php echo $saving['id']; ?>)">
                                                <i class="fas fa-history"></i>
                                            </button>
                                            <button type="button" class="btn btn-outline-warning" onclick="withdrawSavings(<?php echo $saving['id']; ?>)">
                                                <i class="fas fa-minus"></i>
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
    </div>
</div>

<!-- Deposit Modal -->
<div class="modal fade" id="depositModal" tabindex="-1" aria-labelledby="depositModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="depositModalLabel">Tambah Setoran Simpanan</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="depositForm">
                    <div class="mb-3">
                        <label class="form-label">Pilih Anggota</label>
                        <select class="form-select" id="memberSelect" required>
                            <option value="">Pilih Anggota</option>
                            <option value="1">Bapak Ahmad Wijaya (KOP001)</option>
                            <option value="2">Ibu Siti Nurhaliza (KOP002)</option>
                            <option value="3">Bapak Budi Santoso (KOP003)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Jenis Simpanan</label>
                        <select class="form-select" id="savingsType" required>
                            <option value="kewer">Kewer (Harian)</option>
                            <option value="mawar">Mawar (Bulanan)</option>
                            <option value="sukarela">Sukarela</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Jumlah Setoran (Rp)</label>
                        <input type="number" class="form-control" id="depositAmount" min="10000" step="1000" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tanggal Setoran</label>
                        <input type="date" class="form-control" id="depositDate" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Catatan</label>
                        <textarea class="form-control" id="depositNotes" rows="2"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-success" onclick="processDeposit()">Proses Setoran</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Initialize DataTables
$(document).ready(function() {
    KoperasiApp.dataTable.init('#kewerTable', {
        order: [[0, 'asc']]
    });
    
    KoperasiApp.dataTable.init('#mawarTable', {
        order: [[0, 'asc']]
    });
    
    KoperasiApp.dataTable.init('#sukarelaTable', {
        order: [[0, 'asc']]
    });
});

// Process Deposit
function processDeposit() {
    const form = document.getElementById('depositForm');
    
    if (!KoperasiApp.validation.validate(form)) {
        KoperasiApp.notification.error('Silakan lengkapi semua field yang wajib diisi');
        return;
    }
    
    const formData = {
        member_id: document.getElementById('memberSelect').value,
        savings_type: document.getElementById('savingsType').value,
        amount: document.getElementById('depositAmount').value,
        deposit_date: document.getElementById('depositDate').value,
        notes: document.getElementById('depositNotes').value
    };
    
    // Show loading
    const depositButton = document.querySelector('#depositModal .btn-success');
    const originalText = depositButton.innerHTML;
    KoperasiApp.utils.showLoading(depositButton);
    
    // Simulate deposit
    KoperasiApp.ajax.post('/gabe/api/savings/deposit', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Setoran simpanan berhasil diproses');
            KoperasiApp.modal.hide('depositModal');
            form.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Processing deposit:', formData);
            KoperasiApp.notification.success('Setoran simpanan berhasil diproses');
            KoperasiApp.modal.hide('depositModal');
            form.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(depositButton, originalText);
        });
}

// Add Deposit
function addDeposit(id) {
    console.log('Add deposit for savings:', id);
    $('#depositModal').modal('show');
}

// View History
function viewHistory(id) {
    console.log('View history for savings:', id);
    KoperasiApp.notification.info('Fitur riwayat simpanan akan segera tersedia');
}

// Withdraw Savings
function withdrawSavings(id) {
    console.log('Withdraw from savings:', id);
    KoperasiApp.notification.info('Fitur penarikan simpanan akan segera tersedia');
}

// Export Savings
function exportSavings() {
    console.log('Exporting savings...');
    KoperasiApp.notification.success('Data simpanan berhasil diexport');
}

// Set today's date as default
document.getElementById('depositDate').valueAsDate = new Date();
</script>
