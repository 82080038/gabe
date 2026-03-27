<?php
/**
 * Settings Page
 */

require_once __DIR__ . '/template_header.php';

$pageTitle = 'Pengaturan';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Pengaturan', 'url' => '#']
];
?>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <h1>Pengaturan</h1>
            <p>Halaman pengaturan aplikasi - dalam pengembangan</p>
            
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Pengaturan Aplikasi</h5>
                    <p>Fitur pengaturan akan segera tersedia.</p>
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
