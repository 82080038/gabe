<?php
/**
 * Quick Login Page - Demo All User Roles
 * Aplikasi Koperasi Berjalan
 */

require_once __DIR__ . '/template_header.php';

$pageTitle = 'Quick Login - Demo All Roles';
$breadcrumbs = [
    ['title' => 'Quick Login', 'url' => '#']
];

// Define all user roles for demo
$userRoles = [
    'admin' => [
        'username' => 'admin',
        'password' => 'admin',
        'name' => 'Administrator',
        'role' => 'bos',
        'branch_id' => 1,
        'branch_name' => 'Pusat',
        'description' => 'Full access - Super Admin',
        'color' => 'danger',
        'icon' => 'fas fa-crown'
    ],
    'manager' => [
        'username' => 'manager',
        'password' => 'manager',
        'name' => 'Manager Unit',
        'role' => 'unit_head',
        'branch_id' => 1,
        'branch_name' => 'Pusat',
        'description' => 'Manage units & operations',
        'color' => 'primary',
        'icon' => 'fas fa-user-tie'
    ],
    'branch_head' => [
        'username' => 'branch_head',
        'password' => 'branch_head',
        'name' => 'Kepala Cabang',
        'role' => 'branch_head',
        'branch_id' => 2,
        'branch_name' => 'Cabang Jakarta',
        'description' => 'Manage branch operations',
        'color' => 'info',
        'icon' => 'fas fa-building'
    ],
    'collector' => [
        'username' => 'collector',
        'password' => 'collector',
        'name' => 'Petugas Kolektor',
        'role' => 'collector',
        'branch_id' => 2,
        'branch_name' => 'Cabang Jakarta',
        'description' => 'Field collection agent',
        'color' => 'success',
        'icon' => 'fas fa-route'
    ],
    'cashier' => [
        'username' => 'cashier',
        'password' => 'cashier',
        'name' => 'Kasir',
        'role' => 'cashir',
        'branch_id' => 1,
        'branch_name' => 'Pusat',
        'description' => 'Handle cash transactions',
        'color' => 'warning',
        'icon' => 'fas fa-cash-register'
    ],
    'staff' => [
        'username' => 'staff',
        'password' => 'staff',
        'name' => 'Staff Administrasi',
        'role' => 'staff',
        'branch_id' => 1,
        'branch_name' => 'Pusat',
        'description' => 'Administrative support',
        'color' => 'secondary',
        'icon' => 'fas fa-user'
    ]
];

// Handle quick login
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['quick_login'])) {
    $role = $_POST['role'] ?? 'admin';
    
    if (isset($userRoles[$role])) {
        $user = $userRoles[$role];
        
        // Set session
        $_SESSION['user'] = [
            'id' => array_search($role, array_keys($userRoles)) + 1,
            'username' => $user['username'],
            'name' => $user['name'],
            'role' => $user['role'],
            'branch_id' => $user['branch_id'],
            'branch_name' => $user['branch_name']
        ];
        
        // Redirect based on device and role
        $deviceType = 'desktop'; // Simplified for demo
        
        // Always redirect to web dashboard for quick login demo
        header('Location: /gabe/pages/web/dashboard.php');
        exit;
    }
}
?>

<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="text-center mb-4">
                <h1 class="h2">🚀 Quick Login Demo</h1>
                <p class="lead">Pilih role user untuk testing aplikasi Koperasi Berjalan</p>
            </div>

            <!-- User Role Cards -->
            <div class="row g-4">
                <?php foreach ($userRoles as $roleKey => $user): ?>
                <div class="col-md-6 col-lg-4">
                    <div class="card h-100 border-0 shadow-sm">
                        <div class="card-body text-center">
                            <div class="mb-3">
                                <div class="icon-box bg-<?= $user['color'] ?> bg-opacity-10 rounded-circle p-3 d-inline-block">
                                    <i class="<?= $user['icon'] ?> text-<?= $user['color'] ?> fa-2x"></i>
                                </div>
                            </div>
                            
                            <h5 class="card-title"><?= htmlspecialchars($user['name']) ?></h5>
                            <p class="text-muted small mb-2"><?= htmlspecialchars($user['description']) ?></p>
                            
                            <div class="mb-3">
                                <span class="badge bg-<?= $user['color'] ?> me-1"><?= ucfirst($user['role']) ?></span>
                                <span class="badge bg-light text-dark"><?= htmlspecialchars($user['branch_name']) ?></span>
                            </div>
                            
                            <div class="mb-3">
                                <small class="text-muted">
                                    <strong>Username:</strong> <?= htmlspecialchars($user['username']) ?><br>
                                    <strong>Password:</strong> <?= htmlspecialchars($user['password']) ?>
                                </small>
                            </div>
                            
                            <form method="POST" class="d-inline">
                                <input type="hidden" name="role" value="<?= $roleKey ?>">
                                <input type="hidden" name="quick_login" value="1">
                                <button type="submit" class="btn btn-<?= $user['color'] ?> btn-sm w-100">
                                    <i class="fas fa-sign-in-alt"></i> Quick Login
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>

            <!-- Role Comparison Table -->
            <div class="mt-5">
                <h3 class="h4 mb-3">📊 Role Comparison</h3>
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Role</th>
                                <th>Access Level</th>
                                <th>Main Features</th>
                                <th>Dashboard Type</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="badge bg-danger">Administrator</span></td>
                                <td>Super Admin</td>
                                <td>Full system access, user management, system settings</td>
                                <td>Web Dashboard - Full Features</td>
                            </tr>
                            <tr>
                                <td><span class="badge bg-primary">Manager</span></td>
                                <td>Unit Head</td>
                                <td>Unit management, operations oversight, reports</td>
                                <td>Web Dashboard - Management</td>
                            </tr>
                            <tr>
                                <td><span class="badge bg-info">Branch Head</span></td>
                                <td>Branch Manager</td>
                                <td>Branch operations, staff management, local reports</td>
                                <td>Web Dashboard - Branch View</td>
                            </tr>
                            <tr>
                                <td><span class="badge bg-success">Collector</span></td>
                                <td>Field Agent</td>
                                <td>Collection routes, payment processing, mobile access</td>
                                <td>Mobile Dashboard - Field Operations</td>
                            </tr>
                            <tr>
                                <td><span class="badge bg-warning">Cashier</span></td>
                                <td>Financial Staff</td>
                                <td>Cash transactions, daily reconciliation, teller</td>
                                <td>Web Dashboard - Cashier View</td>
                            </tr>
                            <tr>
                                <td><span class="badge bg-secondary">Staff</span></td>
                                <td>Administrative</td>
                                <td>Data entry, basic operations, limited access</td>
                                <td>Web Dashboard - Basic Features</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="mt-4 text-center">
                <div class="btn-group" role="group">
                    <a href="/gabe/pages/login.php" class="btn btn-outline-primary">
                        <i class="fas fa-key"></i> Traditional Login
                    </a>
                    <a href="/gabe/pages/web/dashboard.php" class="btn btn-outline-secondary">
                        <i class="fas fa-tachometer-alt"></i> Dashboard Demo
                    </a>
                    <a href="/gabe/logout.php" class="btn btn-outline-danger">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.icon-box {
    width: 80px;
    height: 80px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
}

.card {
    transition: transform 0.2s, box-shadow 0.2s;
}

.card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 20px rgba(0,0,0,0.1) !important;
}

.table th {
    border-top: none;
    font-weight: 600;
    color: #495057;
}
</style>

</main>
<!-- Footer -->
<footer class="bg-light text-center text-lg-start mt-5">
    <div class="text-center p-3" style="background-color: rgba(0, 0, 0, 0.2);">
        © 2024 Koperasi Berjalan - Quick Login Demo
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="/gabe/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
