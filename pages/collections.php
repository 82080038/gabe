<?php
/**
 * Collection Management Page
 * Admin oversight for collection operations
 */

// Start session
session_start();

// Check authentication
if (!isset($_SESSION['user'])) {
    header('Location: /gabe/pages/login.php');
    exit;
}

// Check role permission (admin and manager can access)
if ($_SESSION['user']['role'] !== 'bos' && $_SESSION['user']['role'] !== 'unit_head' && $_SESSION['user']['role'] !== 'branch_head') {
    header('Location: /gabe/pages/web/dashboard.php');
    exit;
}

require_once __DIR__ . '/template_header.php';

// Set page specific variables
$pageTitle = 'Manajemen Koleksi';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Koleksi', 'url' => '#']
];

// Mock data for collections
$collections = [
    [
        'id' => 1,
        'date' => '2024-03-27',
        'collector_name' => 'Bapak Ahmad',
        'collector_id' => 5,
        'branch' => 'Cabang Jakarta Selatan',
        'route_name' => 'Rute A - Tebet',
        'target_members' => 25,
        'visited_members' => 22,
        'collected_amount' => 2500000,
        'target_amount' => 3000000,
        'completion_rate' => 88,
        'status' => 'completed',
        'start_time' => '08:00',
        'end_time' => '15:30'
    ],
    [
        'id' => 2,
        'date' => '2024-03-27',
        'collector_name' => 'Ibu Siti',
        'collector_id' => 8,
        'branch' => 'Cabang Jakarta Utara',
        'route_name' => 'Rute B - Kelapa Gading',
        'target_members' => 30,
        'visited_members' => 18,
        'collected_amount' => 1800000,
        'target_amount' => 2800000,
        'completion_rate' => 64,
        'status' => 'in_progress',
        'start_time' => '09:00',
        'end_time' => null
    ],
    [
        'id' => 3,
        'date' => '2024-03-27',
        'collector_name' => 'Bapak Budi',
        'collector_id' => 12,
        'branch' => 'Cabang Jakarta Barat',
        'route_name' => 'Rute C - Cengkareng',
        'target_members' => 20,
        'visited_members' => 15,
        'collected_amount' => 1200000,
        'target_amount' => 2000000,
        'completion_rate' => 75,
        'status' => 'completed',
        'start_time' => '08:30',
        'end_time' => '14:00'
    ],
    [
        'id' => 4,
        'date' => '2024-03-26',
        'collector_name' => 'Bapak Dedi',
        'collector_id' => 7,
        'branch' => 'Cabang Pusat',
        'route_name' => 'Rute D - Menteng',
        'target_members' => 35,
        'visited_members' => 30,
        'collected_amount' => 3500000,
        'target_amount' => 4000000,
        'completion_rate' => 87.5,
        'status' => 'completed',
        'start_time' => '07:30',
        'end_time' => '16:00'
    ]
];

// Calculate summary statistics
$totalCollections = count($collections);
$totalCollected = array_sum(array_column($collections, 'collected_amount'));
$totalTarget = array_sum(array_column($collections, 'target_amount'));
$averageCompletion = array_sum(array_column($collections, 'completion_rate')) / count($collections);
$completedCollections = count(array_filter($collections, fn($c) => $c['status'] === 'completed'));
$inProgressCollections = count(array_filter($collections, fn($c) => $c['status'] === 'in_progress'));
?>

<div class="container-fluid">
    <!-- Page Heading -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Manajemen Koleksi</h1>
        <div>
            <button class="btn btn-success me-2" onclick="exportCollectionReport()">
                <i class="fas fa-download"></i> Export Laporan
            </button>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#assignRouteModal">
                <i class="fas fa-route"></i> Assign Rute
            </button>
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
                                Total Koleksi Hari Ini
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalCollected, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-money-bill-wave fa-2x text-gray-300"></i>
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
                                Target Harian
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo 'Rp ' . number_format($totalTarget, 0, ',', '.'); ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-bullseye fa-2x text-gray-300"></i>
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
                                Rata-rata Completion
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo number_format($averageCompletion, 1); ?>%
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-percentage fa-2x text-gray-300"></i>
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
                                Rute Aktif
                            </div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <?php echo $inProgressCollections; ?> / <?php echo $totalCollections; ?>
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-route fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Collection Progress Overview -->
    <div class="row mb-4">
        <div class="col-lg-8">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Progress Koleksi Hari Ini</h6>
                </div>
                <div class="card-body">
                    <canvas id="collectionProgressChart"></canvas>
                </div>
            </div>
        </div>
        
        <div class="col-lg-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Status Rute</h6>
                </div>
                <div class="card-body">
                    <div class="row no-gutters align-items-center mb-3">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Selesai</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo $completedCollections; ?></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                        </div>
                    </div>
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Sedang Berjalan</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800"><?php echo $inProgressCollections; ?></div>
                        </div>
                        <div class="col-auto">
                            <i class="fas fa-clock fa-2x text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Collections Table -->
    <div class="card shadow mb-4">
        <div class="card-header py-3 d-flex justify-content-between align-items-center">
            <h6 class="m-0 font-weight-bold text-primary">Data Koleksi</h6>
            <div>
                <input type="date" class="form-control form-control-sm d-inline-block me-2" id="filterDate" style="width: auto;">
                <button class="btn btn-sm btn-outline-primary" onclick="filterCollections()">Filter</button>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="collectionsTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Tanggal</th>
                            <th>Kolektor</th>
                            <th>Cabang</th>
                            <th>Rute</th>
                            <th>Target (Anggota)</th>
                            <th>Dikunjungi</th>
                            <th>Target (Rp)</th>
                            <th>Terkumpul (Rp)</th>
                            <th>Completion</th>
                            <th>Status</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($collections as $collection): ?>
                        <tr>
                            <td><?php echo date('d/m/Y', strtotime($collection['date'])); ?></td>
                            <td>
                                <strong><?php echo htmlspecialchars($collection['collector_name']); ?></strong>
                                <br>
                                <small class="text-muted">ID: <?php echo $collection['collector_id']; ?></small>
                            </td>
                            <td><?php echo htmlspecialchars($collection['branch']); ?></td>
                            <td><?php echo htmlspecialchars($collection['route_name']); ?></td>
                            <td>
                                <span class="badge bg-info"><?php echo $collection['target_members']; ?></span>
                            </td>
                            <td>
                                <span class="badge bg-warning"><?php echo $collection['visited_members']; ?></span>
                            </td>
                            <td>
                                <span class="badge bg-secondary"><?php echo 'Rp ' . number_format($collection['target_amount'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <span class="badge bg-success"><?php echo 'Rp ' . number_format($collection['collected_amount'], 0, ',', '.'); ?></span>
                            </td>
                            <td>
                                <div class="progress" style="height: 20px;">
                                    <div class="progress-bar" role="progressbar" 
                                         style="width: <?php echo $collection['completion_rate']; ?>%;"
                                         aria-valuenow="<?php echo $collection['completion_rate']; ?>" 
                                         aria-valuemin="0" aria-valuemax="100">
                                        <?php echo number_format($collection['completion_rate'], 1); ?>%
                                    </div>
                                </div>
                            </td>
                            <td>
                                <?php if ($collection['status'] === 'completed'): ?>
                                    <span class="badge bg-success">Selesai</span>
                                <?php else: ?>
                                    <span class="badge bg-warning">Berjalan</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <button type="button" class="btn btn-outline-info" onclick="viewCollectionDetails(<?php echo $collection['id']; ?>)">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-primary" onclick="trackCollection(<?php echo $collection['id']; ?>)">
                                        <i class="fas fa-map-marked-alt"></i>
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

<!-- Assign Route Modal -->
<div class="modal fade" id="assignRouteModal" tabindex="-1" aria-labelledby="assignRouteModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="assignRouteModalLabel">Assign Rute Kolektor</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="assignRouteForm">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="collectorSelect" class="form-label">Pilih Kolektor</label>
                            <select class="form-select" id="collectorSelect" required>
                                <option value="">-- Pilih Kolektor --</option>
                                <option value="5">Bapak Ahmad</option>
                                <option value="8">Ibu Siti</option>
                                <option value="12">Bapak Budi</option>
                                <option value="7">Bapak Dedi</option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="routeSelect" class="form-label">Pilih Rute</label>
                            <select class="form-select" id="routeSelect" required>
                                <option value="">-- Pilih Rute --</option>
                                <option value="route-a">Rute A - Tebet</option>
                                <option value="route-b">Rute B - Kelapa Gading</option>
                                <option value="route-c">Rute C - Cengkareng</option>
                                <option value="route-d">Rute D - Menteng</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="targetAmount" class="form-label">Target (Rp)</label>
                            <input type="number" class="form-control" id="targetAmount" min="0" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="targetMembers" class="form-label">Target Anggota</label>
                            <input type="number" class="form-control" id="targetMembers" min="1" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="collectionDate" class="form-label">Tanggal Koleksi</label>
                        <input type="date" class="form-control" id="collectionDate" required>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="assignRoute()">Assign</button>
            </div>
        </div>
    </div>
</div>

<?php require_once __DIR__ . '/template_footer.php'; ?>

<script>
// Initialize DataTable
$(document).ready(function() {
    $('#collectionsTable').DataTable({
        responsive: true,
        language: {
            url: "//cdn.datatables.net/plug-ins/1.10.24/i18n/Indonesian.json"
        }
    });
    
    // Initialize Progress Chart
    const ctx = document.getElementById('collectionProgressChart').getContext('2d');
    const collectionProgressChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Bapak Ahmad', 'Ibu Siti', 'Bapak Budi'],
            datasets: [{
                label: 'Target',
                data: [3000000, 2800000, 2000000],
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }, {
                label: 'Terkumpul',
                data: [2500000, 1800000, 1200000],
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return 'Rp ' + value.toLocaleString('id-ID');
                        }
                    }
                }
            }
        }
    });
});

// Assign Route
function assignRoute() {
    const formData = {
        collector_id: document.getElementById('collectorSelect').value,
        route_id: document.getElementById('routeSelect').value,
        target_amount: document.getElementById('targetAmount').value,
        target_members: document.getElementById('targetMembers').value,
        collection_date: document.getElementById('collectionDate').value
    };
    
    console.log('Assigning route:', formData);
    
    Swal.fire({
        icon: 'success',
        title: 'Berhasil',
        text: 'Rute berhasil diassign ke kolektor',
        timer: 2000,
        showConfirmButton: false
    });
    
    $('#assignRouteModal').modal('hide');
    document.getElementById('assignRouteForm').reset();
}

// View Collection Details
function viewCollectionDetails(id) {
    console.log('View collection details:', id);
    Swal.fire({
        icon: 'info',
        title: 'Detail Koleksi',
        text: 'Fitur detail akan segera tersedia',
        timer: 2000,
        showConfirmButton: false
    });
}

// Track Collection
function trackCollection(id) {
    console.log('Track collection:', id);
    Swal.fire({
        icon: 'info',
        title: 'Tracking Koleksi',
        text: 'Fitur tracking akan segera tersedia',
        timer: 2000,
        showConfirmButton: false
    });
}

// Filter Collections
function filterCollections() {
    const date = document.getElementById('filterDate').value;
    console.log('Filter by date:', date);
    // Implement filter functionality
}

// Export Collection Report
function exportCollectionReport() {
    console.log('Exporting collection report...');
    Swal.fire({
        icon: 'success',
        title: 'Export Berhasil',
        text: 'Laporan koleksi berhasil diexport',
        timer: 2000,
        showConfirmButton: false
    });
}

// Set today's date as default
document.getElementById('collectionDate').valueAsDate = new Date();
</script>
