<?php
/**
 * Branch Management Page
 * Manage cooperative branches
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

require_once __DIR__ . '/template_header.php';

// Set page specific variables
$pageTitle = 'Manajemen Cabang';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Cabang', 'url' => '#']
];

// Mock data for branches
$branches = [
    [
        'id' => 1,
        'name' => 'Cabang Pusat',
        'code' => 'CB001',
        'address' => 'Jl. Merdeka No. 123, Jakarta Pusat',
        'phone' => '021-12345678',
        'email' => 'pusat@koperasi.co.id',
        'manager_name' => 'Bapak Ahmad Wijaya',
        'status' => 'active',
        'member_count' => 450,
        'loan_portfolio' => 2500000000,
        'savings_balance' => 1800000000,
        'created_at' => '2024-01-15'
    ],
    [
        'id' => 2,
        'name' => 'Cabang Jakarta Selatan',
        'code' => 'CB002',
        'address' => 'Jl. Sudirman No. 456, Jakarta Selatan',
        'phone' => '021-87654321',
        'email' => 'jaksouth@koperasi.co.id',
        'manager_name' => 'Ibu Siti Nurhaliza',
        'status' => 'active',
        'member_count' => 320,
        'loan_portfolio' => 1800000000,
        'savings_balance' => 1200000000,
        'created_at' => '2024-02-20'
    ],
    [
        'id' => 3,
        'name' => 'Cabang Jakarta Utara',
        'code' => 'CB003',
        'address' => 'Jl. Gatotkaca No. 789, Jakarta Utara',
        'phone' => '021-98765432',
        'email' => 'jakutara@koperasi.co.id',
        'manager_name' => 'Bapak Budi Santoso',
        'status' => 'active',
        'member_count' => 280,
        'loan_portfolio' => 1500000000,
        'savings_balance' => 950000000,
        'created_at' => '2024-03-10'
    ],
    [
        'id' => 4,
        'name' => 'Cabang Jakarta Barat',
        'code' => 'CB004',
        'address' => 'Jl. Hayam Wuruk No. 567, Jakarta Barat',
        'phone' => '021-55554444',
        'email' => 'jakbarat@koperasi.co.id',
        'manager_name' => 'Ibu Diana Putri',
        'status' => 'inactive',
        'member_count' => 150,
        'loan_portfolio' => 800000000,
        'savings_balance' => 450000000,
        'created_at' => '2024-04-05'
    ]
];
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Manajemen Cabang</h1>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBranchModal">
            <i class="fas fa-plus"></i> Tambah Cabang
        </button>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Total Cabang
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo count($branches); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-home fa-2x text-gray-300"></i>
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
                                Cabang Aktif
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo count(array_filter($branches, fn($b) => $b['status'] === 'active')); ?>
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
                                Total Portofolio Pinjaman
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format(array_sum(array_column($branches, 'loan_portfolio')), 0, ',', '.'); ?>
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
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Total Simpanan
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format(array_sum(array_column($branches, 'savings_balance')), 0, ',', '.'); ?>
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

    <!-- Branches Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Daftar Cabang</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="branchesTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Kode</th>
                            <th>Nama Cabang</th>
                            <th>Alamat</th>
                            <th>Manajer Cabang</th>
                            <th>Telepon</th>
                            <th>Jumlah Anggota</th>
                            <th>Portofolio Pinjaman</th>
                            <th>Saldo Simpanan</th>
                            <th>Status</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($branches as $branch): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($branch['code']); ?></td>
                            <td>
                                <strong><?php echo htmlspecialchars($branch['name']); ?></strong>
                                <br>
                                <small class="text-muted"><?php echo htmlspecialchars($branch['email']); ?></small>
                            </td>
                            <td><?php echo htmlspecialchars($branch['address']); ?></td>
                            <td><?php echo htmlspecialchars($branch['manager_name']); ?></td>
                            <td><?php echo htmlspecialchars($branch['phone']); ?></td>
                            <td>
                                <span class="badge bg-info"><?php echo number_format($branch['member_count'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <span class="badge bg-warning"><?php echo 'Rp ' . number_format($branch['loan_portfolio'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <span class="badge bg-success"><?php echo 'Rp ' . number_format($branch['savings_balance'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <?php if ($branch['status'] === 'active'): ?>
                                    <span class="badge bg-success">Aktif</span>
                                <?php else: ?>
                                    <span class="badge bg-secondary">Tidak Aktif</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-primary" onclick="editBranch(<?php echo $branch['id']; ?>)">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-info" onclick="viewBranch(<?php echo $branch['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-danger" onclick="deleteBranch(<?php echo $branch['id']; ?>)">
                                        <i class="fas fa-trash"></i>
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

<!-- Add Branch Modal -->
<div class="modal fade" id="addBranchModal" tabindex="-1" aria-labelledby="addBranchModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addBranchModalLabel">Tambah Cabang Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addBranchForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="branchCode" class="form-label">Kode Cabang</label>
                            <input type="text" class="form-control" id="branchCode" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="branchName" class="form-label">Nama Cabang</label>
                            <input type="text" class="form-control" id="branchName" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="branchAddress" class="form-label">Alamat</label>
                        <textarea class="form-control" id="branchAddress" rows="3" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="branchPhone" class="form-label">Telepon</label>
                            <input type="tel" class="form-control" id="branchPhone" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="branchEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="branchEmail" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="branchManager" class="form-label">Manajer Cabang</label>
                        <input type="text" class="form-control" id="branchManager" required>
                    </div>
                    <div class="mb-3">
                        <label for="branchStatus" class="form-label">Status</label>
                        <select class="form-select" id="branchStatus" required>
                            <option value="active">Aktif</option>
                            <option value="inactive">Tidak Aktif</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="saveBranch()">Simpan</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/template_footer.php'; ?>

<script>
// Initialize DataTable
$(document).ready(function() {
    $('#branchesTable').DataTable({
        responsive: true,
        language: {
            url: "//cdn.datatables.net/plug-ins/1.10.24/i18n/Indonesian.json"
        }
    });
});

// Save Branch
function saveBranch() {
    const formData = {
        code: document.getElementById('branchCode').value,
        name: document.getElementById('branchName').value,
        address: document.getElementById('branchAddress').value,
        phone: document.getElementById('branchPhone').value,
        email: document.getElementById('branchEmail').value,
        manager_name: document.getElementById('branchManager').value,
        status: document.getElementById('branchStatus').value
    };
    
    // Simulate save (replace with actual AJAX call)
    console.log('Saving branch:', formData);
    
    // Show success message
    Swal.fire({
        icon: 'success',
        title: 'Berhasil',
        text: 'Cabang berhasil ditambahkan',
        timer: 2000,
        showConfirmButton: false
    });
    
    // Close modal and reset form
    $('#addBranchModal').modal('hide');
    document.getElementById('addBranchForm').reset();
    
    // Reload page to show new data
    setTimeout(() => location.reload(), 1500);
}

// Edit Branch
function editBranch(id) {
    console.log('Edit branch:', id);
    // Implement edit functionality
    Swal.fire({
        icon: 'info',
        title: 'Edit Cabang',
        text: 'Fitur edit akan segera tersedia',
        timer: 2000,
        showConfirmButton: false
    });
}

// View Branch
function viewBranch(id) {
    console.log('View branch:', id);
    // Implement view functionality
    Swal.fire({
        icon: 'info',
        title: 'Detail Cabang',
        text: 'Fitur detail akan segera tersedia',
        timer: 2000,
        showConfirmButton: false
    });
}

// Delete Branch
function deleteBranch(id) {
    Swal.fire({
        title: 'Hapus Cabang?',
        text: 'Apakah Anda yakin ingin menghapus cabang ini?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Ya, hapus!',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed) {
            console.log('Delete branch:', id);
            // Implement delete functionality
            Swal.fire({
                icon: 'success',
                title: 'Terhapus!',
                text: 'Cabang berhasil dihapus',
                timer: 2000,
                showConfirmButton: false
            });
        }
    });
}
</script>
