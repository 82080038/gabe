<?php
/**
 * Add Member Form
 */

// Set page specific variables
$pageTitle = 'Tambah Anggota Baru';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Anggota', 'url' => '/gabe/pages/members.php'],
    ['title' => 'Tambah Anggota', 'url' => '#']
];
?>

<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-user-plus"></i> Tambah Anggota Baru
                </h5>
            </div>
            <div class="card-body">
                <form method="POST" action="/members/save" id="addMemberForm" data-validate>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="member_number" class="form-label">Nomor Anggota</label>
                                <input type="text" class="form-control" id="member_number" name="member_number" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="name" class="form-label">Nama Lengkap</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="nik" class="form-label">NIK</label>
                                <input type="text" class="form-control" id="nik" name="nik" maxlength="16" required placeholder="16 digit angka">
                                <small class="form-text text-muted">Masukkan 16 digit Nomor Induk Kependudukan</small>
                            </div>
                            
                            <div class="mb-3">
                                <label for="birth_date" class="form-label">Tanggal Lahir</label>
                                <input type="date" class="form-control" id="birth_date" name="birth_date" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="phone" class="form-label">Nomor Telepon</label>
                                <input type="tel" class="form-control phone" id="phone" name="phone" required placeholder="08xxxxxxxxxx">
                                <small class="form-text text-muted">Format: 08xxxxxxxxxx atau 62xxxxxxxxxx</small>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="address" class="form-label">Alamat Lengkap</label>
                                <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="branch" class="form-label">Cabang</label>
                                <select class="form-control" id="branch" name="branch" required>
                                    <option value="">Pilih Cabang</option>
                                    <option value="Jakarta Pusat">Jakarta Pusat</option>
                                    <option value="Jakarta Utara">Jakarta Utara</option>
                                    <option value="Jakarta Selatan">Jakarta Selatan</option>
                                    <option value="Jakarta Barat">Jakarta Barat</option>
                                    <option value="Jakarta Timur">Jakarta Timur</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="join_date" class="form-label">Tanggal Bergabung</label>
                                <input type="date" class="form-control" id="join_date" name="join_date" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-control" id="status" name="status" required>
                                    <option value="active">Aktif</option>
                                    <option value="inactive">Tidak Aktif</option>
                                    <option value="pending">Menunggu Verifikasi</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <hr>
                    
                    <h6>Simpanan</h6>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="kewer_amount" class="form-label">Kewer (Harian)</label>
                                <input type="number" class="form-control currency" id="kewer_amount" name="kewer_amount" min="0" step="1000">
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="mawar_amount" class="form-label">Mawar (Bulanan)</label>
                                <input type="number" class="form-control currency" id="mawar_amount" name="mawar_amount" min="0" step="1000">
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label for="sukarela_amount" class="form-label">Sukarela</label>
                                <input type="number" class="form-control currency" id="sukarela_amount" name="sukarela_amount" min="0" step="1000">
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="/gabe/pages/members.php" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Kembali
                        </a>
                        <div>
                            <button type="reset" class="btn btn-warning">
                                <i class="fas fa-redo"></i> Reset
                            </button>
                            <button type="submit" class="btn btn-primary" data-loading>
                                <i class="fas fa-save"></i> Simpan Anggota
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Auto-generate member number
    const memberNumberInput = document.getElementById('member_number');
    const today = new Date();
    const yearMonth = today.getFullYear() + String(today.getMonth() + 1).padStart(2, '0');
    const random = Math.floor(Math.random() * 10000).toString().padStart(4, '0');
    memberNumberInput.value = 'KOP' + yearMonth + random;
    
    // Set default join date to today
    document.getElementById('join_date').value = today.toISOString().split('T')[0];
    
    // Form validation
    const form = document.getElementById('addMemberForm');
    form.addEventListener('submit', function(e) {
        // Validate NIK (16 digits)
        const nik = document.getElementById('nik').value;
        if (nik.length !== 16 || !/^\d+$/.test(nik)) {
            alert('NIK harus 16 digit angka');
            e.preventDefault();
            return;
        }
        
        // Validate phone number
        const phone = document.getElementById('phone').value;
        if (!/^08\d{8,12}$/.test(phone.replace(/[-\s]/g, ''))) {
            alert('Nomor telepon tidak valid');
            e.preventDefault();
            return;
        }
    });
});
</script>

<?php require_once __DIR__ . '/../template_footer.php'; ?>
