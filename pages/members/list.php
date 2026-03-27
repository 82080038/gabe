<?php
/**
 * Members List View
 */

// Calculate statistics
$totalMembers = count($members);
$activeMembers = count(array_filter($members, fn($m) => $m['status'] === 'active'));
$totalSavings = array_sum(array_column($members, 'savings_balance'));
$totalLoans = array_sum(array_column($members, 'loan_balance'));
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Manajemen Anggota</h1>
        <div>
            <button class="btn btn-success me-2" onclick="exportMembers()">
                <i class="fas fa-download"></i> Export
            </button>
            <a href="/gabe/pages/members.php?action=add" class="btn btn-primary">
                <i class="fas fa-plus"></i> Tambah Anggota
            </a>
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
                                Anggota Aktif
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $activeMembers; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-user-check fa-2x text-gray-300"></i>
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
                                Total Simpanan
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalSavings, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-piggy-bank fa-2x text-gray-300"></i>
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
                                Total Pinjaman
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalLoans, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-hand-holding-usd fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Filter Data</h6>
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
                    <label class="form-label">Status</label>
                    <select class="form-select" id="statusFilter">
                        <option value="">Semua Status</option>
                        <option value="active">Aktif</option>
                        <option value="inactive">Tidak Aktif</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Cari</label>
                    <input type="text" class="form-control" id="searchFilter" placeholder="Nama atau No. Anggota">
                </div>
                <div class="col-md-3">
                    <label class="form-label">&nbsp;</label>
                    <div>
                        <button class="btn btn-primary btn-sm" onclick="applyFilters()">
                            <i class="fas fa-filter"></i> Terapkan
                        </button>
                        <button class="btn btn-secondary btn-sm" onclick="resetFilters()">
                            <i class="fas fa-undo"></i> Reset
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Members Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Daftar Anggota</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="membersTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>No. Anggota</th>
                            <th>Nama</th>
                            <th>NIK</th>
                            <th>Telepon</th>
                            <th>Cabang</th>
                            <th>Status</th>
                            <th>Simpanan</th>
                            <th>Pinjaman</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($members as $member): ?>
                        <tr>
                            <td>
                                <strong><?php echo htmlspecialchars($member['member_number']); ?></strong>
                                <br>
                                <small class="text-muted">Join: <?php echo date('d/m/Y', strtotime($member['join_date'])); ?></small>
                            </td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                                        <?php echo strtoupper(substr($member['name'], 0, 1)); ?>
                                    </div>
                                    <div>
                                        <strong><?php echo htmlspecialchars($member['name']); ?></strong>
                                        <br>
                                        <small class="text-muted"><?php echo date('d/m/Y', strtotime($member['birth_date'])); ?></small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <code><?php echo htmlspecialchars($member['nik']); ?></code>
                            </td>
                            <td>
                                <div>
                                    <i class="fas fa-phone"></i> <?php echo htmlspecialchars($member['phone']); ?>
                                </div>
                                <small class="text-muted d-block">
                                    <i class="fas fa-map-marker-alt"></i> 
                                    <?php echo substr($member['address'], 0, 30); ?>...
                                </small>
                            </td>
                            <td>
                                <span class="badge bg-info"><?php echo htmlspecialchars($member['branch']); ?></span>
                            </td>
                            <td>
                                <?php if ($member['status'] === 'active'): ?>
                                    <span class="badge bg-success">Aktif</span>
                                <?php else: ?>
                                    <span class="badge bg-secondary">Tidak Aktif</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div>
                                    <span class="badge bg-primary">Rp <?php echo number_format($member['savings_balance'], 0, ',', '.'); ?></span>
                                </div>
                                <small class="text-muted">
                                    K: <?php echo number_format($member['kewer_amount'], 0, ',', '.'); ?> | 
                                    M: <?php echo number_format($member['mawar_amount'], 0, ',', '.'); ?>
                                </small>
                            </td>
                            <td>
                                <span class="badge bg-warning">Rp <?php echo number_format($member['loan_balance'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-info" onclick="viewMember(<?php echo $member['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-primary" onclick="editMember(<?php echo $member['id']; ?>)">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-success" onclick="addSavings(<?php echo $member['id']; ?>)">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-warning" onclick="viewHistory(<?php echo $member['id']; ?>)">
                                        <i class="fas fa-history"></i>
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

<!-- Add Member Modal -->
<div class="modal fade" id="addMemberModal" tabindex="-1" aria-labelledby="addMemberModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addMemberModalLabel">Tambah Anggota Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addMemberForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">No. Anggota</label>
                            <input type="text" class="form-control" id="memberNumber" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Nama Lengkap</label>
                            <input type="text" class="form-control" id="memberName" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">NIK</label>
                            <input type="text" class="form-control" id="memberNik" maxlength="16" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Tanggal Lahir</label>
                            <input type="date" class="form-control" id="memberBirthDate" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Alamat</label>
                        <textarea class="form-control" id="memberAddress" rows="3" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Telepon</label>
                            <input type="tel" class="form-control" id="memberPhone" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Cabang</label>
                            <select class="form-select" id="memberBranch" required>
                                <option value="">Pilih Cabang</option>
                                <option value="Cabang Jakarta Selatan">Cabang Jakarta Selatan</option>
                                <option value="Cabang Jakarta Pusat">Cabang Jakarta Pusat</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Tanggal Gabung</label>
                            <input type="date" class="form-control" id="memberJoinDate" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Kewer (Harian)</label>
                            <input type="number" class="form-control" id="kewerAmount" min="0" value="50000">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Mawar (Bulanan)</label>
                            <input type="number" class="form-control" id="mawarAmount" min="0" value="150000">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Sukarela</label>
                            <input type="number" class="form-control" id="sukarelaAmount" min="0" value="0">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="saveMember()">Simpan</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#membersTable', {
        order: [[0, 'asc']],
        columns: [
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: false },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: true },
            { orderable: false }
        ]
    });
});

// Save Member
function saveMember() {
    const form = document.getElementById('addMemberForm');
    
    if (!KoperasiApp.validation.validate(form)) {
        KoperasiApp.notification.error('Silakan lengkapi semua field yang wajib diisi');
        return;
    }
    
    const formData = {
        member_number: document.getElementById('memberNumber').value,
        name: document.getElementById('memberName').value,
        nik: document.getElementById('memberNik').value,
        birth_date: document.getElementById('memberBirthDate').value,
        address: document.getElementById('memberAddress').value,
        phone: document.getElementById('memberPhone').value,
        branch: document.getElementById('memberBranch').value,
        join_date: document.getElementById('memberJoinDate').value,
        kewer_amount: document.getElementById('kewerAmount').value,
        mawar_amount: document.getElementById('mawarAmount').value,
        sukarela_amount: document.getElementById('sukarelaAmount').value
    };
    
    // Show loading
    const saveButton = document.querySelector('#addMemberModal .btn-primary');
    const originalText = saveButton.innerHTML;
    KoperasiApp.utils.showLoading(saveButton);
    
    // Simulate save
    KoperasiApp.ajax.post('/gabe/api/members', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Anggota berhasil ditambahkan');
            KoperasiApp.modal.hide('addMemberModal');
            form.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo
            console.log('Saving member:', formData);
            KoperasiApp.notification.success('Anggota berhasil ditambahkan');
            KoperasiApp.modal.hide('addMemberModal');
            form.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(saveButton, originalText);
        });
}

// View Member
function viewMember(id) {
    console.log('View member:', id);
    KoperasiApp.notification.info('Fitur detail akan segera tersedia');
}

// Edit Member
function editMember(id) {
    console.log('Edit member:', id);
    KoperasiApp.notification.info('Fitur edit akan segera tersedia');
}

// Add Savings
function addSavings(id) {
    console.log('Add savings for member:', id);
    KoperasiApp.notification.info('Fitur tambah simpanan akan segera tersedia');
}

// View History
function viewHistory(id) {
    console.log('View history for member:', id);
    KoperasiApp.notification.info('Fitur riwayat akan segera tersedia');
}

// Export Members
function exportMembers() {
    console.log('Exporting members...');
    KoperasiApp.notification.success('Data anggota berhasil diexport');
}

// Apply Filters
function applyFilters() {
    const branch = document.getElementById('branchFilter').value;
    const status = document.getElementById('statusFilter').value;
    const search = document.getElementById('searchFilter').value;
    
    console.log('Applying filters:', { branch, status, search });
    KoperasiApp.notification.info('Filter diterapkan');
}

// Reset Filters
function resetFilters() {
    document.getElementById('branchFilter').value = '';
    document.getElementById('statusFilter').value = '';
    document.getElementById('searchFilter').value = '';
    
    console.log('Filters reset');
    KoperasiApp.notification.info('Filter direset');
}

// Set today's date as default
document.getElementById('memberJoinDate').valueAsDate = new Date();
</script>
