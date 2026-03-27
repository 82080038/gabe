<?php
/**
 * Profile Page
 */

require_once __DIR__ . '/template_header.php';

$pageTitle = 'Profil Pengguna';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Profil', 'url' => '#']
];
?>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <h1>Profil Pengguna</h1>
            <p>Halaman profil pengguna - dalam pengembangan</p>
            
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Informasi Akun</h5>
                    <table class="table">
                        <tr>
                            <td>Nama:</td>
                            <td><?php echo htmlspecialchars($_SESSION['user']['name'] ?? 'N/A'); ?></td>
                        </tr>
                        <tr>
                            <td>Username:</td>
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
