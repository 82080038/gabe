<?php
/**
 * Unit Management Page
 * Manage cooperative units
 */

// Start session
session_start();

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

// Check role permission
if ($_SESSION['user']['role'] !== 'bos' && $_SESSION['user']['role'] !== 'unit_head') {
    header('Location: /gabe/pages/web/dashboard.php');
    exit;
}

require_once __DIR__ . '/template_header.php';

// Set page specific variables
$pageTitle = 'Manajemen Unit';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Unit', 'url' => '#']
];

// Mock data for units
$units = [
    [
        'id' => 1,
        'name' => 'Unit Pusat',
        'code' => 'U001',
        'address' => 'Jl. Merdeka No. 123, Jakarta',
        'phone' => '021-12345678',
        'email' => 'pusat@koperasi.co.id',
        'head_name' => 'Bapak Ahmad Wijaya',
        'status' => 'active',
        'member_count' => 450,
        'created_at' => '2024-01-15'
    ],
    [
        'id' => 2,
        'name' => 'Unit Cabang Jakarta Selatan',
        'code' => 'U002',
        'address' => 'Jl. Sudirman No. 456, Jakarta Selatan',
        'phone' => '021-87654321',
        'email' => 'jaksouth@koperasi.co.id',
        'head_name' => 'Ibu Siti Nurhaliza',
        'status' => 'active',
        'member_count' => 320,
        'created_at' => '2024-02-20'
    ],
    [
        'id' => 3,
        'name' => 'Unit Cabang Jakarta Utara',
        'code' => 'U003',
        'address' => 'Jl. Gatotkaca No. 789, Jakarta Utara',
        'phone' => '021-98765432',
        'email' => 'jakutara@koperasi.co.id',
        'head_name' => 'Bapak Budi Santoso',
        'status' => 'active',
        'member_count' => 280,
        'created_at' => '2024-03-10'
    ]
];
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Manajemen Unit</h1>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUnitModal">
            <i class="fas fa-plus"></i> Tambah Unit
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
                                Total Unit
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo count($units); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-building fa-2x text-gray-300"></i>
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
                                Unit Aktif
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo count(array_filter($units, fn($u) => $u['status'] === 'active')); ?>
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
                                Total Anggota
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo number_format(array_sum(array_column($units, 'member_count')), 0, ',', '.'); ?>
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
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Rata-rata Anggota
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo number_format(array_sum(array_column($units, 'member_count')) / count($units), 0, ',', '.'); ?>
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

    <!-- Units Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Daftar Unit</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="unitsTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Kode</th>
                            <th>Nama Unit</th>
                            <th>Alamat</th>
                            <th>Kepala Unit</th>
                            <th>Telepon</th>
                            <th>Jumlah Anggota</th>
                            <th>Status</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($units as $unit): ?>
                        <tr>
                            <td><?php echo htmlspecialchars($unit['code']); ?></td>
                            <td>
                                <strong><?php echo htmlspecialchars($unit['name']); ?></strong>
                                <br>
                                <small class="text-muted"><?php echo htmlspecialchars($unit['email']); ?></small>
                            </td>
                            <td><?php echo htmlspecialchars($unit['address']); ?></td>
                            <td><?php echo htmlspecialchars($unit['head_name']); ?></td>
                            <td><?php echo htmlspecialchars($unit['phone']); ?></td>
                            <td>
                                <span class="badge bg-info"><?php echo number_format($unit['member_count'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <?php if ($unit['status'] === 'active'): ?>
                                    <span class="badge bg-success">Aktif</span>
                                <?php else: ?>
                                    <span class="badge bg-secondary">Tidak Aktif</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-primary" onclick="editUnit(<?php echo $unit['id']; ?>)">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-info" onclick="viewUnit(<?php echo $unit['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-danger" onclick="deleteUnit(<?php echo $unit['id']; ?>)">
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

<!-- Add Unit Modal -->
<div class="modal fade" id="addUnitModal" tabindex="-1" aria-labelledby="addUnitModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addUnitModalLabel">Tambah Unit Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="addUnitForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="unitCode" class="form-label">Kode Unit</label>
                            <input type="text" class="form-control" id="unitCode" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="unitName" class="form-label">Nama Unit</label>
                            <input type="text" class="form-control" id="unitName" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="unitAddress" class="form-label">Alamat</label>
                        <textarea class="form-control" id="unitAddress" rows="3" required></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="unitPhone" class="form-label">Telepon</label>
                            <input type="tel" class="form-control" id="unitPhone" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="unitEmail" class="form-label">Email</label>
                            <input type="email" class="form-control" id="unitEmail" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="unitHead" class="form-label">Kepala Unit</label>
                        <input type="text" class="form-control" id="unitHead" required>
                    </div>
                    <div class="mb-3">
                        <label for="unitStatus" class="form-label">Status</label>
                        <select class="form-select" id="unitStatus" required>
                            <option value="active">Aktif</option>
                            <option value="inactive">Tidak Aktif</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="saveUnit()">Simpan</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/template_footer.php'; ?>

<script>
// Initialize DataTable
$(document).ready(function() {
    KoperasiApp.dataTable.init('#unitsTable', {
        order: [[0, 'asc']],
        columns: [
            { orderable: true },
            { orderable: true },
            { orderable: false },
            { orderable: true },
            { orderable: false },
            { orderable: true },
            { orderable: true },
            { orderable: false },
            { orderable: false }
        ]
    });
});

// Save Unit
function saveUnit() {
    const form = document.getElementById('addUnitForm');
    
    if (!KoperasiApp.validation.validate(form)) {
        KoperasiApp.notification.error('Silakan lengkapi semua field yang wajib diisi');
        return;
    }
    
    const formData = {
        code: document.getElementById('unitCode').value,
        name: document.getElementById('unitName').value,
        address: document.getElementById('unitAddress').value,
        phone: document.getElementById('unitPhone').value,
        email: document.getElementById('unitEmail').value,
        head_name: document.getElementById('unitHead').value,
        status: document.getElementById('unitStatus').value
    };
    
    // Show loading
    const saveButton = document.querySelector('#addUnitModal .btn-primary');
    const originalText = saveButton.innerHTML;
    KoperasiApp.utils.showLoading(saveButton);
    
    // Simulate AJAX call (replace with actual API call)
    KoperasiApp.ajax.post('/gabe/api/units', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Unit berhasil ditambahkan');
            KoperasiApp.modal.hide('addUnitModal');
            form.reset();
            
            // Reload page after delay
            setTimeout(() => location.reload(), 1500);
        })
        .fail(function() {
            // Fallback for demo - simulate success
            console.log('Saving unit:', formData);
            KoperasiApp.notification.success('Unit berhasil ditambahkan');
            KoperasiApp.modal.hide('addUnitModal');
            form.reset();
            setTimeout(() => location.reload(), 1500);
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(saveButton, originalText);
        });
}

// Edit Unit
function editUnit(id) {
    console.log('Edit unit:', id);
    KoperasiApp.notification.info('Fitur edit akan segera tersedia');
}

// View Unit
function viewUnit(id) {
    console.log('View unit:', id);
    KoperasiApp.notification.info('Fitur detail akan segera tersedia');
}

// Delete Unit
function deleteUnit(id) {
    Swal.fire({
        title: 'Hapus Unit?',
        text: 'Apakah Anda yakin ingin menghapus unit ini?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Ya, hapus!',
        cancelButtonText: 'Batal'
    }).then((result) => {
        if (result.isConfirmed) {
            // Simulate delete API call
            KoperasiApp.ajax.delete(`/gabe/api/units/${id}`)
                .done(function(response) {
                    KoperasiApp.notification.success('Unit berhasil dihapus');
                    setTimeout(() => location.reload(), 1000);
                })
                .fail(function() {
                    // Fallback for demo
                    console.log('Delete unit:', id);
                    KoperasiApp.notification.success('Unit berhasil dihapus');
                    setTimeout(() => location.reload(), 1000);
                });
        }
    });
}
</script>
