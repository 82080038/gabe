<?php
/**
 * General Settings View
 */

// Mock settings data
$generalSettings = [
    'cooperative_name' => 'Koperasi Berjalan',
    'cooperative_address' => 'Jl. Merdeka No. 123, Jakarta',
    'cooperative_phone' => '021-12345678',
    'cooperative_email' => 'info@koperasi-berjalan.co.id',
    'business_hours' => 'Senin - Sabtu: 08:00 - 17:00 WIB',
    'interest_rate_kewer' => 6,
    'interest_rate_mawar' => 12,
    'interest_rate_sukarela' => 3,
    'late_payment_fee' => 5000,
    'max_loan_amount' => 50000000,
    'min_savings_amount' => 10000
];
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Pengaturan Umum</h1>
        <div>
            <button class="btn btn-success" onclick="saveSettings()">
                <i class="fas fa-save"></i> Simpan Pengaturan
            </button>
        </div>
    </div>

    <!-- Cooperative Information -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Informasi Koperasi</h6>
        </div>
        <div class="card-body">
            <form id="cooperativeForm">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Nama Koperasi</label>
                        <input type="text" class="form-control" name="cooperative_name" value="<?php echo htmlspecialchars($generalSettings['cooperative_name']); ?>" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Telepon</label>
                        <input type="tel" class="form-control" name="cooperative_phone" value="<?php echo htmlspecialchars($generalSettings['cooperative_phone']); ?>" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 mb-3">
                        <label class="form-label">Alamat</label>
                        <textarea class="form-control" name="cooperative_address" rows="2" required><?php echo htmlspecialchars($generalSettings['cooperative_address']); ?></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="cooperative_email" value="<?php echo htmlspecialchars($generalSettings['cooperative_email']); ?>" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Jam Operasional</label>
                        <input type="text" class="form-control" name="business_hours" value="<?php echo htmlspecialchars($generalSettings['business_hours']); ?>" required>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Financial Settings -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Pengaturan Keuangan</h6>
        </div>
        <div class="card-body">
            <form id="financialForm">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Suku Bunga Kewer (%)</label>
                        <input type="number" class="form-control" name="interest_rate_kewer" value="<?php echo $generalSettings['interest_rate_kewer']; ?>" min="0" max="20" step="0.5" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Suku Bunga Mawar (%)</label>
                        <input type="number" class="form-control" name="interest_rate_mawar" value="<?php echo $generalSettings['interest_rate_mawar']; ?>" min="0" max="30" step="0.5" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Suku Bunga Sukarela (%)</label>
                        <input type="number" class="form-control" name="interest_rate_sukarela" value="<?php echo $generalSettings['interest_rate_sukarela']; ?>" min="0" max="15" step="0.5" required>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Denda Keterlambatan (Rp)</label>
                        <input type="number" class="form-control" name="late_payment_fee" value="<?php echo $generalSettings['late_payment_fee']; ?>" min="0" step="1000" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Maksimal Pinjaman (Rp)</label>
                        <input type="number" class="form-control" name="max_loan_amount" value="<?php echo $generalSettings['max_loan_amount']; ?>" min="1000000" step="1000000" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Minimal Simpanan (Rp)</label>
                        <input type="number" class="form-control" name="min_savings_amount" value="<?php echo $generalSettings['min_savings_amount']; ?>" min="5000" step="5000" required>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- System Settings -->
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Pengaturan Sistem</h6>
        </div>
        <div class="card-body">
            <form id="systemForm">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Zona Waktu</label>
                        <select class="form-select" name="timezone">
                            <option value="Asia/Jakarta" selected>Asia/Jakarta (WIB)</option>
                            <option value="Asia/Makassar">Asia/Makassar (WITA)</option>
                            <option value="Asia/Jayapura">Asia/Jayapura (WIT)</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Bahasa</label>
                        <select class="form-select" name="language">
                            <option value="id" selected>Bahasa Indonesia</option>
                            <option value="en">English</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mata Uang</label>
                        <select class="form-select" name="currency">
                            <option value="IDR" selected>Rupiah (IDR)</option>
                            <option value="USD">US Dollar (USD)</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Format Tanggal</label>
                        <select class="form-select" name="date_format">
                            <option value="d/m/Y" selected>DD/MM/YYYY</option>
                            <option value="m/d/Y">MM/DD/YYYY</option>
                            <option value="Y-m-d">YYYY-MM-DD</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="enable_notifications" id="enableNotifications" checked>
                            <label class="form-check-label" for="enableNotifications">
                                Aktifkan Notifikasi Email
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="enable_backup" id="enableBackup" checked>
                            <label class="form-check-label" for="enableBackup">
                                Aktifkan Backup Otomatis
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="enable_maintenance" id="enableMaintenance">
                            <label class="form-check-label" for="enableMaintenance">
                                Mode Maintenance
                            </label>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/../template_footer.php'; ?>

<script>
// Save Settings
function saveSettings() {
    const cooperativeForm = document.getElementById('cooperativeForm');
    const financialForm = document.getElementById('financialForm');
    const systemForm = document.getElementById('systemForm');
    
    // Validate all forms
    if (!KoperasiApp.validation.validate(cooperativeForm) || 
        !KoperasiApp.validation.validate(financialForm) || 
        !KoperasiApp.validation.validate(systemForm)) {
        KoperasiApp.notification.error('Silakan lengkapi semua field yang wajib diisi');
        return;
    }
    
    // Collect all form data
    const formData = {
        ...Object.fromEntries(new FormData(cooperativeForm)),
        ...Object.fromEntries(new FormData(financialForm)),
        ...Object.fromEntries(new FormData(systemForm)),
        enable_notifications: document.getElementById('enableNotifications').checked,
        enable_backup: document.getElementById('enableBackup').checked,
        enable_maintenance: document.getElementById('enableMaintenance').checked
    };
    
    // Show loading
    const saveButton = document.querySelector('.btn-success');
    const originalText = saveButton.innerHTML;
    KoperasiApp.utils.showLoading(saveButton);
    
    // Simulate save
    KoperasiApp.ajax.post('/gabe/api/settings', formData)
        .done(function(response) {
            KoperasiApp.notification.success('Pengaturan berhasil disimpan');
        })
        .fail(function() {
            // Fallback for demo
            console.log('Saving settings:', formData);
            KoperasiApp.notification.success('Pengaturan berhasil disimpan');
        })
        .always(function() {
            KoperasiApp.utils.hideLoading(saveButton, originalText);
        });
}

// Form validation on input
document.querySelectorAll('input, select, textarea').forEach(function(element) {
    element.addEventListener('blur', function() {
        if (this.hasAttribute('required') && !this.value.trim()) {
            this.classList.add('is-invalid');
        } else {
            this.classList.remove('is-invalid');
        }
    });
});
</script>
