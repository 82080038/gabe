<?php
/**
 * Template Footer untuk Aplikasi Koperasi Berjalan
 * Mendukung penuh bahasa Indonesia dan lokasi Indonesia
 */
?>
</main>

<!-- Footer -->
<footer class="bg-light text-center text-lg-start mt-5">
    <div class="container-fluid p-4">
        <div class="row">
            <div class="col-lg-4 col-md-6 mb-4 mb-md-0">
                <h5 class="text-uppercase">Aplikasi Koperasi Berjalan</h5>
                <p>
                    Sistem digital untuk koperasi simpan pinjam dengan operasi door-to-door.
                    Mendukung Kewer (simpanan harian) dan Mawar (simpanan berjangka).
                </p>
            </div>
            
            <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                <h5 class="text-uppercase">Menu</h5>
                <ul class="list-unstyled mb-0">
                    <li><a href="../pages/web/dashboard.php" class="text-dark">Dashboard</a></li>
                    <li><a href="/members" class="text-dark">Anggota</a></li>
                    <li><a href="/loans" class="text-dark">Pinjaman</a></li>
                    <li><a href="/savings" class="text-dark">Simpanan</a></li>
                </ul>
            </div>
            
            <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                <h5 class="text-uppercase">Laporan</h5>
                <ul class="list-unstyled mb-0">
                    <li><a href="/reports/summary" class="text-dark">Ringkasan</a></li>
                    <li><a href="/reports/financial" class="text-dark">Keuangan</a></li>
                    <li><a href="/reports/ojk" class="text-dark">Laporan OJK</a></li>
                    <li><a href="/reports/audit" class="text-dark">Audit Trail</a></li>
                </ul>
            </div>
            
            <div class="col-lg-4 col-md-6 mb-4 mb-md-0">
                <h5 class="text-uppercase">Informasi</h5>
                <ul class="list-unstyled mb-0">
                    <li><i class="fas fa-map-marker-alt"></i> Indonesia</li>
                    <li><i class="fas fa-phone"></i> +62 xxx xxxx xxxx</li>
                    <li><i class="fas fa-envelope"></i> info@koperasi.co.id</li>
                    <li><i class="fas fa-clock"></i> Senin - Sabtu: 08:00 - 17:00 WIB</li>
                </ul>
            </div>
        </div>
    </div>
    
    <div class="text-center p-3 bg-dark text-white">
        <small>
            &copy; <?php echo date('Y'); ?> Aplikasi Koperasi Berjalan. 
            Dibuat dengan <i class="fas fa-heart text-danger"></i> di Indonesia.
        </small>
    </div>
</footer>

<!-- Indonesia Formatter Script -->
<script>
// Konfigurasi global untuk Indonesia
window.indonesiaConfig = <?php echo json_encode(IndonesiaConfig::getJSConfig()); ?>;
</script>

<!-- Bootstrap JS -->
<script src="../assets/js/bootstrap.bundle.min.js"></script>

<!-- jQuery -->
<script src="../assets/js/jquery.min.js"></script>

<!-- Chart.js untuk dashboard -->
<script src="../assets/js/chart.min.js"></script>

<!-- DataTables -->
<script src="../assets/js/datatables.min.js"></script>

<!-- Custom JavaScript -->
<script src="../assets/js/app.js"></script>

<!-- Page specific JavaScript -->
<?php if (isset($pageJS)): ?>
<script><?php echo $pageJS; ?></script>
<?php endif; ?>

<!-- Indonesia Theme Initialization -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Set timezone untuk semua date inputs
    const dateInputs = document.querySelectorAll('input[type="date"], input[type="datetime-local"]');
    dateInputs.forEach(input => {
        const now = new Date();
        const offset = now.getTimezoneOffset();
        const localISOTime = new Date(now.getTime() - (offset * 60 * 1000)).toISOString().slice(0, 16);
        input.min = localISOTime;
    });
    
    // Format currency inputs otomatis
    const currencyInputs = document.querySelectorAll('input.currency, input[data-type="currency"]');
    currencyInputs.forEach(input => {
        input.addEventListener('blur', function() {
            if (this.value) {
                const value = parseFloat(this.value.replace(/[^\d,-]/g, '').replace(/\./g, '').replace(/,/g, '.'));
                if (!isNaN(value)) {
                    this.value = formatRupiah(value);
                }
            }
        });
    });
    
    // Format phone inputs otomatis
    const phoneInputs = document.querySelectorAll('input.phone, input[data-type="phone"]');
    phoneInputs.forEach(input => {
        input.addEventListener('blur', function() {
            if (this.value) {
                this.value = formatNomorTelepon(this.value);
            }
        });
    });
    
    // Auto-format dates
    const dateInputFields = document.querySelectorAll('input.date, input[data-type="date"]');
    dateInputFields.forEach(input => {
        input.addEventListener('blur', function() {
            if (this.value) {
                // Format DD/MM/YYYY
                const parts = this.value.split('/');
                if (parts.length === 3 && parts[0].length === 2 && parts[1].length === 2 && parts[2].length === 4) {
                    // Valid format
                    this.classList.remove('is-invalid');
                } else {
                    this.classList.add('is-invalid');
                }
            }
        });
    });
    
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    
    // Initialize popovers
    const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
    
    // Auto-refresh untuk dashboard
    if (window.location.pathname === '/dashboard' || window.location.pathname === '/dashboard/') {
        setInterval(function() {
            // Refresh data every 5 minutes
            location.reload();
        }, 300000); // 5 minutes
    }
    
    // Confirmation dialogs
    const confirmButtons = document.querySelectorAll('[data-confirm]');
    confirmButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            const message = this.getAttribute('data-confirm') || 'Apakah Anda yakin?';
            if (!confirm(message)) {
                e.preventDefault();
                return false;
            }
        });
    });
    
    // Loading states
    const loadingButtons = document.querySelectorAll('[data-loading]');
    loadingButtons.forEach(button => {
        button.addEventListener('click', function() {
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Memproses...';
            this.disabled = true;
            
            // Reset after 5 seconds (fallback)
            setTimeout(() => {
                this.innerHTML = originalText;
                this.disabled = false;
            }, 5000);
        });
    });
});
</script>

<!-- Print styles -->
<style>
@media print {
    .no-print { display: none !important; }
    .navbar { display: none !important; }
    footer { display: none !important; }
    .btn { display: none !important; }
    
    .currency { font-weight: 600; }
    .table { page-break-inside: avoid; }
    
    body { font-size: 12pt; }
    h1 { font-size: 18pt; }
    h2 { font-size: 16pt; }
    h3 { font-size: 14pt; }
}
</style>

<!-- Bootstrap JavaScript -->
<script src="/gabe/assets/js/bootstrap.bundle.min.js"></script>

<!-- Analytics (optional) -->
<?php if (isset($analyticsCode)): ?>
<?php echo $analyticsCode; ?>
<?php endif; ?>

</body>
</html>
