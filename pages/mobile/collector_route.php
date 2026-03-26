<?php
/**
 * Collector Route Page - Mobile Interface
 * PWA-enabled route management with geolocation
 */

require_once __DIR__ . '/../template_header.php';

// Set page specific variables
$pageTitle = 'Rute Kolektor';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/mobile/dashboard'],
    ['title' => 'Rute', 'url' => '/collector/route']
];

// Add mobile-specific meta tags
echo '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">';
echo '<meta name="apple-mobile-web-app-capable" content="yes">';
echo '<meta name="theme-color" content="#667eea">';
?>

<div class="container-fluid p-0 mobile-dashboard">
    <!-- Header -->
    <div class="route-header bg-primary text-white p-3">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h5 class="mb-1">Rute Hari Ini</h5>
                <small class="opacity-75"><?php echo date('d M Y'); ?></small>
            </div>
            <div class="text-right">
                <div class="route-stats">
                    <small class="d-block">Total: <span id="total-members">0</span></small>
                    <small class="d-block">Selesai: <span id="completed-members">0</span></small>
                </div>
            </div>
        </div>
    </div>

    <!-- Route Progress -->
    <div class="route-progress bg-white p-3 border-bottom">
        <div class="d-flex justify-content-between mb-2">
            <small>Progress Rute</small>
            <small id="route-percentage">0%</small>
        </div>
        <div class="progress">
            <div class="progress-bar bg-success" id="route-progress-bar" style="width: 0%"></div>
        </div>
    </div>

    <!-- Map Container -->
    <div class="map-container">
        <div id="route-map" class="route-map">
            <div class="map-placeholder">
                <i class="fas fa-map-marked-alt fa-3x text-muted mb-3"></i>
                <p>Peta rute akan muncul di sini</p>
                <button class="btn btn-primary btn-sm" onclick="mobileRoute.startNavigation()">
                    <i class="fas fa-location-arrow"></i> Mulai Navigasi
                </button>
            </div>
        </div>
    </div>

    <!-- Member List -->
    <div class="member-list-container">
        <div class="list-header bg-white p-3 border-bottom">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="mb-0">Daftar Anggota</h6>
                <div class="btn-group btn-group-sm">
                    <button class="btn btn-outline-primary active" onclick="mobileRoute.sortBy('distance')">
                        <i class="fas fa-route"></i> Jarak
                    </button>
                    <button class="btn btn-outline-primary" onclick="mobileRoute.sortBy('status')">
                        <i class="fas fa-check-circle"></i> Status
                    </button>
                    <button class="btn btn-outline-primary" onclick="mobileRoute.sortBy('amount')">
                        <i class="fas fa-money-bill"></i> Jumlah
                    </button>
                </div>
            </div>
        </div>
        
        <div id="member-list" class="member-list">
            <!-- Members will be populated by JavaScript -->
        </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions bg-white border-top p-3">
        <div class="row">
            <div class="col-4">
                <button class="btn btn-success btn-block btn-sm touch-feedback" onclick="mobileRoute.markAllCompleted()">
                    <i class="fas fa-check-double"></i>
                    <small>Selesai</small>
                </button>
            </div>
            <div class="col-4">
                <button class="btn btn-warning btn-block btn-sm touch-feedback" onclick="mobileRoute.skipCurrent()">
                    <i class="fas fa-forward"></i>
                    <small>Lewati</small>
                </button>
            </div>
            <div class="col-4">
                <button class="btn btn-info btn-block btn-sm touch-feedback" onclick="mobileRoute.showNotes()">
                    <i class="fas fa-sticky-note"></i>
                    <small>Catatan</small>
                </button>
            </div>
        </div>
    </div>

    <!-- Navigation Controls -->
    <div id="navigation-controls" class="navigation-controls bg-white border-top p-3" style="display: none;">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 class="mb-0">Navigasi</h6>
            <button class="btn btn-sm btn-outline-secondary" onclick="mobileRoute.stopNavigation()">
                <i class="fas fa-stop"></i> Stop
            </button>
        </div>
        <div class="navigation-info">
            <div class="d-flex justify-content-between mb-2">
                <small>Lokasi Saat Ini</small>
                <small id="current-location">Mendapatkan lokasi...</small>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <small>Tujuan Berikutnya</small>
                <small id="next-destination">-</small>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <small>Jarak ke Tujuan</small>
                <small id="distance-to-destination">-</small>
            </div>
            <div class="d-flex justify-content-between">
                <small>Estimasi Waktu</small>
                <small id="estimated-time">-</small>
            </div>
        </div>
    </div>
</div>

<!-- Member Details Modal -->
<div id="member-modal" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Detail Anggota</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="member-details">
                    <!-- Member details will be populated by JavaScript -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                <button type="button" class="btn btn-primary" onclick="mobileRoute.collectPayment()">
                    <i class="fas fa-money-bill"></i> Bayar
                </button>
                <button type="button" class="btn btn-success" onclick="mobileRoute.markCompleted()">
                    <i class="fas fa-check"></i> Selesai
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Payment Modal -->
<div id="payment-modal" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Pembayaran</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="payment-form">
                    <input type="hidden" id="payment-member-id">
                    
                    <div class="mb-3">
                        <label class="form-label">Anggota</label>
                        <input type="text" class="form-control" id="payment-member-name" readonly>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Jumlah Pembayaran</label>
                        <div class="input-group">
                            <span class="input-group-text">Rp</span>
                            <input type="number" class="form-control" id="payment-amount" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Metode Pembayaran</label>
                        <select class="form-select" id="payment-method" required>
                            <option value="">Pilih metode</option>
                            <option value="cash">Tunai</option>
                            <option value="transfer">Transfer</option>
                            <option value="digital">Dompet Digital</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Catatan</label>
                        <textarea class="form-control" id="payment-notes" rows="2"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="mobileRoute.submitPayment()">
                    <i class="fas fa-save"></i> Simpan
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Notes Modal -->
<div id="notes-modal" class="modal fade" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Catatan Rute</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <textarea class="form-control" id="route-notes" rows="4" placeholder="Tambahkan catatan untuk rute hari ini..."></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                <button type="button" class="btn btn-primary" onclick="mobileRoute.saveNotes()">
                    <i class="fas fa-save"></i> Simpan
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Mobile Route CSS -->
<link rel="stylesheet" href="/assets/css/mobile-dashboard.css">

<!-- Mobile Route JavaScript -->
<script src="/assets/js/mobile-route.js"></script>

<!-- PWA Development Config -->
<script src="/pwa-dev-config.js"></script>

<?php require_once __DIR__ . '/../template_footer.php'; ?>
