<?php
/**
 * Add Loan Application Form
 */

// Set page specific variables
$pageTitle = 'Ajukan Pinjaman Baru';
$breadcrumbs = [
    ['title' => 'Dashboard', 'url' => '/gabe/pages/web/dashboard.php'],
    ['title' => 'Pinjaman', 'url' => '/gabe/pages/loans.php'],
    ['title' => 'Ajukan Pinjaman', 'url' => '#']
];
?>

<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-hand-holding-usd"></i> Ajukan Pinjaman Baru
                </h5>
            </div>
            <div class="card-body">
                <form method="POST" action="/loans/save" id="addLoanForm">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="member_id" class="form-label">Anggota</label>
                                <select class="form-control" id="member_id" name="member_id" required>
                                    <option value="">Pilih Anggota</option>
                                    <option value="1">KOP001 - Bapak Ahmad Wijaya</option>
                                    <option value="2">KOP002 - Ibu Siti Nurhaliza</option>
                                    <option value="3">KOP003 - Bapak Budi Santoso</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="loan_type" class="form-label">Jenis Pinjaman</label>
                                <select class="form-control" id="loan_type" name="loan_type" required>
                                    <option value="">Pilih Jenis Pinjaman</option>
                                    <option value="kewer">Pinjaman Kewer</option>
                                    <option value="mawar">Pinjaman Mawar</option>
                                    <option value="sukarela">Pinjaman Sukarela</option>
                                    <option value="darurat">Pinjaman Darurat</option>
                                    <option value="investasi">Pinjaman Investasi</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="amount" class="form-label">Jumlah Pinjaman</label>
                                <input type="number" class="form-control currency" id="amount" name="amount" min="100000" step="10000" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="interest_rate" class="form-label">Suku Bunga (%)</label>
                                <input type="number" class="form-control" id="interest_rate" name="interest_rate" min="0" max="30" step="0.1" value="12" required>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="term" class="form-label">Jangka Waktu (Bulan)</label>
                                <input type="number" class="form-control" id="term" name="term" min="1" max="60" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="purpose" class="form-label">Tujuan Pinjaman</label>
                                <textarea class="form-control" id="purpose" name="purpose" rows="3" required></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="collateral" class="form-label">Jaminan</label>
                                <textarea class="form-control" id="collateral" name="collateral" rows="2" placeholder="Jika ada"></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="disbursement_date" class="form-label">Tanggal Pencairan</label>
                                <input type="date" class="form-control" id="disbursement_date" name="disbursement_date" required>
                            </div>
                        </div>
                    </div>
                    
                    <hr>
                    
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mb-3">
                                <label for="notes" class="form-label">Catatan Tambahan</label>
                                <textarea class="form-control" id="notes" name="notes" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between">
                        <a href="/gabe/pages/loans.php" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Kembali
                        </a>
                        <div>
                            <button type="button" class="btn btn-info" onclick="calculateInstallment()">
                                <i class="fas fa-calculator"></i> Hitung Angsuran
                            </button>
                            <button type="reset" class="btn btn-warning">
                                <i class="fas fa-redo"></i> Reset
                            </button>
                            <button type="submit" class="btn btn-primary" data-loading>
                                <i class="fas fa-paper-plane"></i> Ajukan Pinjaman
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Installment Calculation Modal -->
<div class="modal fade" id="installmentModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Perhitungan Angsuran</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="calculationResult">
                    <!-- Calculation results will be displayed here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Set default disbursement date to today
    document.getElementById('disbursement_date').value = new Date().toISOString().split('T')[0];
    
    // Auto-calculate installment when values change
    ['amount', 'interest_rate', 'term'].forEach(id => {
        document.getElementById(id).addEventListener('change', calculateInstallment);
    });
    
    // Form validation
    const form = document.getElementById('addLoanForm');
    form.addEventListener('submit', function(e) {
        const amount = parseFloat(document.getElementById('amount').value.replace(/[^\d]/g, ''));
        const memberSavings = 5000000; // Mock member savings
        
        if (amount > memberSavings * 5) {
            alert('Jumlah pinjaman melebihi batas maksimal (5x total simpanan)');
            e.preventDefault();
            return;
        }
    });
});

function calculateInstallment() {
    const amount = parseFloat(document.getElementById('amount').value.replace(/[^\d]/g, '')) || 0;
    const rate = parseFloat(document.getElementById('interest_rate').value) || 0;
    const term = parseInt(document.getElementById('term').value) || 1;
    
    if (amount <= 0 || term <= 0) {
        alert('Masukkan jumlah pinjaman dan jangka waktu yang valid');
        return;
    }
    
    // Calculate monthly interest rate
    const monthlyRate = rate / 100 / 12;
    
    // Calculate monthly installment (using flat rate for simplicity)
    const totalInterest = amount * monthlyRate * term;
    const totalPayment = amount + totalInterest;
    const monthlyInstallment = totalPayment / term;
    
    // Display results
    const resultHtml = `
        <div class="row">
            <div class="col-6">
                <strong>Pinjaman Pokok:</strong><br>
                <span class="text-primary">${formatRupiah(amount)}</span>
            </div>
            <div class="col-6">
                <strong>Total Bunga:</strong><br>
                <span class="text-warning">${formatRupiah(totalInterest)}</span>
            </div>
            <div class="col-6 mt-3">
                <strong>Total Pembayaran:</strong><br>
                <span class="text-success">${formatRupiah(totalPayment)}</span>
            </div>
            <div class="col-6 mt-3">
                <strong>Angsuran/Bulan:</strong><br>
                <span class="text-info">${formatRupiah(monthlyInstallment)}</span>
            </div>
        </div>
        <hr>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> 
            Perhitungan menggunakan suku bunga flat ${rate}% per tahun
        </div>
    `;
    
    document.getElementById('calculationResult').innerHTML = resultHtml;
    
    // Show modal
    const modal = new bootstrap.Modal(document.getElementById('installmentModal'));
    modal.show();
}
</script>

<?php require_once __DIR__ . '/../template_footer.php'; ?>
