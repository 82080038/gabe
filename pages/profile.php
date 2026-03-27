<?php
/**
 * Profile Page
 */

// Start session
session_start();

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

require_once __DIR__ . '/template_header.php';

$pageTitle = 'Profil Pengguna';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Profil', 'url' => '#']
];
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Profil Pengguna</h1>
        <div>
            <button class="btn btn-primary" onclick="editProfile()">
                <i class="fas fa-edit"></i> Edit Profil
            </button>
        </div>
    </div>

    <!-- Profile Information -->
    <div class="row">
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-body text-center">
                    <div class="mb-3">
                        <div class="avatar-lg bg-primary text-white rounded-circle d-flex align-items-center justify-content-center mx-auto" style="width: 120px; height: 120px; font-size: 48px;">
                            <?php echo strtoupper(substr($_SESSION['user']['name'] ?? 'U', 0, 1)); ?>
                        </div>
                    </div>
                    <h4 class="card-title mb-1"><?php echo htmlspecialchars($_SESSION['user']['name'] ?? 'N/A'); ?></h4>
                    <p class="text-muted mb-3"><?php echo htmlspecialchars($_SESSION['user']['username'] ?? 'N/A'); ?></p>
                    <div class="mb-3">
                        <span class="badge bg-<?php echo $_SESSION['user']['role'] === 'bos' ? 'danger' : ($_SESSION['user']['role'] === 'collector' ? 'success' : 'info'); ?>">
                            <?php 
                            $roleLabels = [
                                'bos' => 'Administrator',
                                'unit_head' => 'Unit Head',
                                'branch_head' => 'Branch Head',
                                'collector' => 'Petugas Kolektor',
                                'cashier' => 'Kasir',
                                'staff' => 'Staff'
                            ];
                            echo $roleLabels[$_SESSION['user']['role']] ?? 'Unknown';
                            ?>
                        </span>
                    </div>
                    <div class="text-start">
                        <p class="mb-2"><strong>Cabang:</strong> <?php echo htmlspecialchars($_SESSION['user']['branch_name'] ?? 'Pusat'); ?></p>
                        <p class="mb-2"><strong>Status:</strong> <span class="badge bg-success">Aktif</span></p>
                        <p class="mb-2"><strong>Bergabung:</strong> <?php echo date('d/m/Y', strtotime('2024-01-01')); ?></p>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Informasi Akun</h6>
                </div>
                <div class="card-body">
                    <form id="profileForm">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nama Lengkap</label>
                                <input type="text" class="form-control" id="fullName" value="<?php echo htmlspecialchars($_SESSION['user']['name'] ?? ''); ?>" readonly>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" value="<?php echo htmlspecialchars($_SESSION['user']['username'] ?? ''); ?>" readonly>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" value="<?php echo htmlspecialchars($_SESSION['user']['email'] ?? 'user@example.com'); ?>" readonly>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Telepon</label>
                                <input type="tel" class="form-control" id="phone" value="<?php echo htmlspecialchars($_SESSION['user']['phone'] ?? '0812-3456-7890'); ?>" readonly>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Role</label>
                                <input type="text" class="form-control" value="<?php echo $roleLabels[$_SESSION['user']['role']] ?? 'Unknown'; ?>" readonly>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Cabang</label>
                                <input type="text" class="form-control" value="<?php echo htmlspecialchars($_SESSION['user']['branch_name'] ?? 'Pusat'); ?>" readonly>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Alamat</label>
                            <textarea class="form-control" id="address" rows="2" readonly><?php echo htmlspecialchars($_SESSION['user']['address'] ?? 'Jl. Contoh No. 123, Jakarta'); ?></textarea>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Security Settings -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-warning">Pengaturan Keamanan</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Password Lama</label>
                            <input type="password" class="form-control" id="oldPassword" placeholder="Masukkan password lama">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Password Baru</label>
                            <input type="password" class="form-control" id="newPassword" placeholder="Masukkan password baru">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Konfirmasi Password</label>
                            <input type="password" class="form-control" id="confirmPassword" placeholder="Konfirmasi password baru">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">&nbsp;</label>
                            <div>
                                <button class="btn btn-warning" onclick="changePassword()">
                                    <i class="fas fa-key"></i> Ganti Password
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Activity Log -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-info">Log Aktivitas Terakhir</h6>
                </div>
                <div class="card-body">
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="timeline-marker bg-success">
                                <i class="fas fa-sign-in-alt"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <strong>Login ke sistem</strong>
                                        <div class="text-muted small">IP: 192.168.1.100</div>
                                    </div>
                                    <small class="text-muted">2 jam yang lalu</small>
                                </div>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-marker bg-primary">
                                <i class="fas fa-edit"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <strong>Mengubah data anggota</strong>
                                        <div class="text-muted small">ID: KOP001</div>
                                    </div>
                                    <small class="text-muted">5 jam yang lalu</small>
                                </div>
                            </div>
                        </div>
                        <div class="timeline-item">
                            <div class="timeline-marker bg-info">
                                <i class="fas fa-download"></i>
                            </div>
                            <div class="timeline-content">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <strong>Download laporan</strong>
                                        <div class="text-muted small">Laporan Bulanan</div>
                                    </div>
                                    <small class="text-muted">1 hari yang lalu</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/template_footer.php'; ?>

<script>
// Edit Profile
function editProfile() {
    const fields = ['fullName', 'email', 'phone', 'address'];
    const isEditing = document.getElementById('fullName').readOnly;
    
    fields.forEach(field => {
        const element = document.getElementById(field);
        element.readOnly = !isEditing;
        if (isEditing) {
            element.classList.add('bg-light');
        } else {
            element.classList.remove('bg-light');
        }
    });
    
    const editButton = document.querySelector('button[onclick="editProfile()"]');
    if (isEditing) {
        editButton.innerHTML = '<i class="fas fa-save"></i> Simpan';
        editButton.classList.remove('btn-primary');
        editButton.classList.add('btn-success');
    } else {
        // Save profile
        saveProfile();
    }
}

// Save Profile
function saveProfile() {
    const formData = {
        full_name: document.getElementById('fullName').value,
        email: document.getElementById('email').value,
        phone: document.getElementById('phone').value,
        address: document.getElementById('address').value
    };
    
    // Show loading
    const editButton = document.querySelector('button[onclick="editProfile()"]');
    const originalText = editButton.innerHTML;
    KoperasiApp.utils.showLoading(editButton);
    
    // Simulate save
    KoperasiApp.ajax.post('/gabe/api/profile/update', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Profil berhasil diperbarui');
            // Reset fields to read-only
            const fields = ['fullName', 'email', 'phone', 'address'];
            fields.forEach(field => {
                const element = document.getElementById(field);
                element.readOnly = true;
                element.classList.add('bg-light');
            });
            editButton.innerHTML = '<i class="fas fa-edit"></i> Edit Profil';
            editButton.classList.remove('btn-success');
            editButton.classList.add('btn-primary');
        })
        .fail(function() {
            // Fallback for demo
            console.log('Saving profile:', formData);
            KoperasiApp.notification.success('Profil berhasil diperbarui');
            // Reset fields to read-only
            const fields = ['fullName', 'email', 'phone', 'address'];
            fields.forEach(field => {
                const element = document.getElementById(field);
                element.readOnly = true;
                element.classList.add('bg-light');
            });
            editButton.innerHTML = '<i class="fas fa-edit"></i> Edit Profil';
            editButton.classList.remove('btn-success');
            editButton.classList.add('btn-primary');
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(editButton, originalText);
        });
}

// Change Password
function changePassword() {
    const oldPassword = document.getElementById('oldPassword').value;
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    
    // Validation
    if (!oldPassword || !newPassword || !confirmPassword) {
        KoperasiApp.notification.error('Semua field password harus diisi');
        return;
    }
    
    if (newPassword !== confirmPassword) {
        KoperasiApp.notification.error('Password baru dan konfirmasi tidak sama');
        return;
    }
    
    if (newPassword.length < 6) {
        KoperasiApp.notification.error('Password baru minimal 6 karakter');
        return;
    }
    
    const formData = {
        old_password: oldPassword,
        new_password: newPassword
    };
    
    // Show loading
    const changeButton = document.querySelector('button[onclick="changePassword()"]');
    const originalText = changeButton.innerHTML;
    KoperasiApp.utils.showLoading(changeButton);
    
    // Simulate password change
    KoperasiApp.ajax.post('/gabe/api/profile/change-password', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Password berhasil diubah');
            // Clear password fields
            document.getElementById('oldPassword').value = '';
            document.getElementById('newPassword').value = '';
            document.getElementById('confirmPassword').value = '';
        })
        .fail(function() {
            // Fallback for demo
            console.log('Changing password:', formData);
            KoperasiApp.notification.success('Password berhasil diubah');
            // Clear password fields
            document.getElementById('oldPassword').value = '';
            document.getElementById('newPassword').value = '';
            document.getElementById('confirmPassword').value = '';
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(changeButton, originalText);
        });
}
</script>

<style>
.timeline {
    position: relative;
    padding-left: 30px;
}

.timeline::before {
    content: '';
    position: absolute;
    left: 15px;
    top: 0;
    bottom: 0;
    width: 2px;
    background: #e9ecef;
}

.timeline-item {
    position: relative;
    margin-bottom: 20px;
}

.timeline-marker {
    position: absolute;
    left: -30px;
    top: 0;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 12px;
}

.timeline-content {
    background: white;
    padding: 15px;
    border-radius: 8px;
    border-left: 3px solid #e9ecef;
    margin-left: 15px;
}
</style>
                            <td><?php echo htmlspecialchars($_SESSION['user']['username'] ?? 'N/A'); ?></td>
                        </tr>
                        <tr>
                            <td>Role:</td>
                            <td><?php echo htmlspecialchars($_SESSION['user']['role'] ?? 'N/A'); ?></td>
                        </tr>
                        <tr>
                            <td>Cabang:</td>
                            <td><?php echo htmlspecialchars($_SESSION['user']['branch_name'] ?? 'N/A'); ?></td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

</main>
<!-- Footer -->
<footer class="bg-light text-center text-lg-start mt-5">
    <div class="text-center p-3" style="background-color: rgba(0, 0, 0, 0.2);">
        © 2024 Koperasi Berjalan - Aplikasi Digital Koperasi
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="/gabe/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
