# Spesifikasi Aplikasi Kewer/Mawar
## Sistem Simpan Pinjam Mikro untuk Pedagang Pasar & UMKM

---

## Ringkasan Eksekutif

Aplikasi Kewer/Mawar adalah sistem simpan pinjam **mikro** dengan karakteristik:
- **Pinjaman kecil**: Rp500.000 - Rp10.000.000
- **Angsuran harian/mingguan**: Rp10.000 - Rp500.000 per hari
- **Target pasar**: Pedagang pasar, buruh harian, UMKM kecil
- **Sistem kolektor**: Door-to-door collection setiap hari
- **Volume tinggi**: Ratusan transaksi kecil per hari

---

## 1. Profil Pinjaman Kewer/Mawar

### 1.1 Karakteristik Pinjaman
| Aspek | Keterangan | Contoh Nilai |
|-------|------------|--------------|
| **Jumlah Pinjaman** | Rp500.000 - Rp10.000.000 | Modal tambahan warung |
| **Tenor** | 30 - 180 hari | 3-6 bulan |
| **Frekuensi Angsuran** | Harian atau Mingguan | Rp20.000/hari |
| **Suku Bunga** | 1-3% per bulan flat | Rp60.000/bulan untuk Rp2 juta |
| **Biaya Administrasi** | 2-5% dari pokok | Rp100.000 untuk Rp2 juta |
| **Jaminan** | KTP + Surat Keterangan Usaha | Tidak perlu agunan fisik |

### 1.2 Target Market
- **Pedagang Pasar**: Sayur, ikan, bumbu, pakaian
- **Warung/Kios**: Kelontong, makanan, pulsa
- **Buruh Harian**: Bangunan, cleaning, pengemudi
- **UMKM Kecil**: Jasa kecil, home industry
- **Penghasilan**: Rp2.000.000 - Rp5.000.000/bulan

### 1.3 Volume Bisnis (Per Cabang)
- **Anggota Aktif**: 500 - 2.000 orang
- **Pinjaman Aktif**: 200 - 800 pinjaman
- **Transaksi/Hari**: 300 - 1.000 transaksi
- **Total Pinjaman**: Rp200 juta - Rp2 miliar
- **Total Simpanan**: Rp100 juta - Rp1 miliar

---

## 2. Regulasi Khusus Kewer/Mawar

### 2.1 Kategori Pinjaman (OJK 2025)
Pinjaman Kewer/Mawar masuk kategori **Pinjaman Produktif Mikro**:

| Jenis Pinjaman | Kategori OJK | Batas Harian |
|----------------|-------------|--------------|
| Kewer/Mawar ≤ Rp50 Juta | Produktif Mikro | **0,275% per hari** (≤6 bulan) |
| Kewer/Mawar ≤ Rp50 Juta | Produktif Mikro | **0,1% per hari** (>6 bulan) |

**Implementasi:**
- Kebanyakan pinjaman Kewer/Mawar ≤ Rp50 juta
- Tenor biasanya ≤6 bulan
- **Maksimal suku bunga: 0,275% per hari = 8,25% per bulan**

### 2.2 Batasan Lain
- **Tidak ada batasan minimum pendapatan** (berbeda dengan fintech P2P)
- **Verifikasi KTP cukup** (tidak perlu e-KYC kompleks)
- **Tidak perlu analisis kredit rumit** (focus pada cash flow harian)

---

## 3. Sistem Kewer (Simpanan Harian)

### 3.1 Konsep Kewer
**Kewer** = Simpanan harian wajib yang:
- **Setoran rutin**: Rp5.000 - Rp50.000 per hari
- **Imbal hasil**: 0,5% - 1% per bulan
- **Jangka waktu**: 6 - 24 bulan
- **Tujuan**: Disiplin menabung, dana darurat

### 3.2 Alur Kewer
```
Hari 1: Nasabah setor Rp10.000 → Kolektor catat → Sistem simpan
Hari 2: Nasabah setor Rp10.000 → Kolektor catat → Sistem simpan
...
Akhir Bulan: Hitung imbal hasil → Tambah ke saldo
```

### 3.3 Implementasi Teknis
```php
// Tabel untuk Kewer
CREATE TABLE kewer_accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    daily_amount DECIMAL(10,2) NOT NULL, -- target harian
    interest_rate DECIMAL(5,4) DEFAULT 0.0080, -- 0.8% per bulan
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('active', 'completed', 'paused') DEFAULT 'active'
);

CREATE TABLE kewer_deposits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    deposit_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    collector_id INT NOT NULL,
    payment_type ENUM('cash', 'transfer') DEFAULT 'cash',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 4. Sistem Mawar (Simpanan Berjangka)

### 4.1 Konsep Mawar
**Mawar** = Simpanan berjangka dengan:
- **Setoran bulanan**: Rp100.000 - Rp1.000.000
- **Jangka waktu**: 6 - 36 bulan
- **Imbal hasil**: 1% - 1,5% per bulan
- **Penarikan**: Hanya di akhir periode

### 4.2 Perbedaan Kewer vs Mawar
| Aspek | Kewer | Mawar |
|-------|-------|-------|
| **Frekuensi** | Harian | Bulanan |
| **Jumlah** | Kecil (Rp5-50rb) | Sedang (Rp100rb-1jt) |
| **Liquidity** | Cair harian | Terikat periode |
| **Imbal Hasil** | 0,5-1%/bulan | 1-1,5%/bulan |
| **Tujuan** | Disiplin menabung | Investasi jangka panjang |

---

## 5. Alur Bisnis Kewer/Mawar

### 5.1 Registrasi Anggota
```
1. Kolektor datang ke calon anggota
2. Foto KTP + selfie
3. Isi formulir sederhana (nama, alamat, usaha)
4. Verifikasi oleh kepala cabang (1 hari)
5. Anggota aktif, dapat nomor anggota
```

### 5.2 Pengajuan Pinjaman
```
1. Anggota ajukan pinjaman ke kolektor
2. Kolektor input ke aplikasi mobile
3. Sistem cek:
   - Riwayat pinjaman (boleh max 2 pinjaman aktif)
   - Keterlambatan (boleh max 3x telat)
   - Total pinjaman (max Rp10 juta)
4. Auto-approve jika memenuhi kriteria
5. Pencairan tunai di cabang (oleh kasir)
```

### 5.3 Penagihan Harian
```
Pagi (07:00-10:00):
- Kolektor dapat rute dari sistem
- Kunjungi 30-50 nasabah per hari
- Catat pembayaran di aplikasi mobile

Siang (12:00-13:00):
- Setoran ke kasir cabang
- Verifikasi pembayaran

Sore (16:00):
- Rekap harian
- Update status nasabah
```

---

## 6. Implementasi Teknis

### 6.1 Database Schema (Khusus Kewer/Mawar)
```sql
-- Pinjaman Mikro
CREATE TABLE micro_loans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL, -- Rp500rb - Rp10jt
    admin_fee DECIMAL(10,2) NOT NULL,
    interest_rate DECIMAL(5,4) NOT NULL, -- max 0.275% per hari
    installment_amount DECIMAL(10,2) NOT NULL, -- Rp10rb - Rp500rb/hari
    frequency ENUM('daily', 'weekly') DEFAULT 'daily',
    total_installments INT NOT NULL, -- 30-180 hari
    disbursement_date DATE NOT NULL,
    status ENUM('proposed', 'approved', 'disbursed', 'completed', 'defaulted') DEFAULT 'proposed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Jadwal Angsuran Harian
CREATE TABLE micro_loan_schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT NOT NULL,
    installment_number INT NOT NULL,
    due_date DATE NOT NULL,
    principal_amount DECIMAL(10,2) NOT NULL,
    interest_amount DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'paid', 'late', 'waived') DEFAULT 'pending',
    paid_date DATE,
    paid_amount DECIMAL(10,2),
    collector_id INT,
    payment_type ENUM('cash', 'transfer', 'waived') DEFAULT 'cash'
);

-- Limit per Anggota
CREATE TABLE member_limits (
    member_id INT PRIMARY KEY,
    max_active_loans INT DEFAULT 2,
    max_loan_amount DECIMAL(10,2) DEFAULT 10000000, -- Rp10 juta
    max_late_days INT DEFAULT 3,
    current_active_loans INT DEFAULT 0,
    current_total_loans DECIMAL(10,2) DEFAULT 0,
    current_late_count INT DEFAULT 0
);
```

### 6.2 Business Logic
```php
class MicroLoanService {
    public function calculateLoan($amount, $tenorDays, $dailyRate = 0.00275) {
        $adminFee = $amount * 0.03; // 3% admin fee
        $netAmount = $amount - $adminFee;
        
        // Hitung bunga flat harian
        $dailyInterest = $amount * $dailyRate;
        $totalInterest = $dailyInterest * $tenorDays;
        
        // Angsuran harian (pokok + bunga)
        $dailyInstallment = ($amount + $totalInterest) / $tenorDays;
        
        return [
            'loan_amount' => $amount,
            'admin_fee' => $adminFee,
            'net_disbursed' => $netAmount,
            'daily_installment' => round($dailyInstallment, 0),
            'total_interest' => $totalInterest,
            'total_payment' => $amount + $totalInterest
        ];
    }
    
    public function checkEligibility($memberId, $requestedAmount) {
        $limits = $this->getMemberLimits($memberId);
        
        // Cek jumlah pinjaman aktif
        if ($limits['current_active_loans'] >= $limits['max_active_loans']) {
            return ['eligible' => false, 'reason' => 'Max active loans reached'];
        }
        
        // Cek total pinjaman
        if (($limits['current_total_loans'] + $requestedAmount) > $limits['max_loan_amount']) {
            return ['eligible' => false, 'reason' => 'Max loan amount exceeded'];
        }
        
        // Cek keterlambatan
        if ($limits['current_late_count'] >= $limits['max_late_days']) {
            return ['eligible' => false, 'reason' => 'Too many late payments'];
        }
        
        return ['eligible' => true];
    }
}
```

### 6.3 Mobile Collector App
```javascript
// Dashboard Kolektor
const CollectorDashboard = {
    async getDailyRoute() {
        const response = await fetch('/api/collector/daily-route');
        return response.json(); // 30-50 nasabah dengan GPS
    },
    
    async recordPayment(memberId, amount, paymentType) {
        const payment = {
            member_id: memberId,
            amount: amount,
            payment_type: paymentType, // cash, transfer
            location: {
                lat: this.currentLocation.lat,
                lng: this.currentLocation.lng
            },
            photo: this.capturePhoto(), // bukti pembayaran
            time: new Date().toISOString()
        };
        
        return await fetch('/api/collector/record-payment', {
            method: 'POST',
            body: JSON.stringify(payment)
        });
    }
};
```

---

## 7. Risiko Khusus Kewer/Mawar

### 7.1 Risiko Operasional
| Risiko | Dampak | Mitigasi |
|--------|--------|----------|
| Kolektor tidak setor | Kehilangan uang harian | Lock mechanism, daily reconciliation |
| Nasabah kabur | Pinjaman macet | KTP, alamat, referensi keluarga |
| Kolektor manipulasi | Fraud internal | GPS tracking, photo evidence |
| Cuaca hujan | Target tidak tercapai | Mobile banking backup |

### 7.2 Risiko Kredit
| Risiko | Indikator | Action |
|--------|-----------|--------|
| Nasabah telat 1x | Warning | SMS reminder |
| Nasabah telat 3x | High risk | Kolektor khusus |
| Nasabah telat 7x | Default | Blacklist, collection agency |
| Nasabah pindah | Lost contact | Hubungi keluarga/referensi |

### 7.3 Kriteria Blacklist
- Telat > 7 hari tanpa kabar
- Pinjaman macet > 30 hari
- Manipulasi bukti pembayaran
- Pindah alamat tanpa informasi

---

## 8. Laporan Khusus Kewer/Mawar

### 8.1 Dashboard Harian Kolektor
```
Target: Rp2.000.000
Realisasi: Rp1.850.000 (92,5%)
Nasabah dikunjungi: 45/48
Nasabah bayar: 42/45
Nasabah telat: 3
```

### 8.2 Laporan Cabang (Harian)
```
Total Pencairan: Rp15.000.000
Total Penagihan: Rp12.500.000
Total Setoran: Rp11.800.000
Selisih: Rp700.000
NPL Hari Ini: 2,4%
```

### 8.3 Laporan Bulanan
```
Total Pinjaman Aktif: 450 pinjaman
Total Outstanding: Rp450.000.000
NPL Bulanan: 3,2%
Rata-rata Pinjaman: Rp1.000.000
Rata-rata Tenor: 90 hari
```

---

## 9. Integrasi dengan Modul Lain

### 9.1 Akuntansi Kewer/Mawar
```sql
-- Jurnal untuk pencairan pinjaman mikro
INSERT INTO journal_details VALUES
(null, journal_id, 1010, 970000, 0, 'Kas - Pencairan pinjaman #123'),
(null, journal_id, 1100, 0, 1000000, 'Piutang Pinjaman Mikro'),
(null, journal_id, 4020, 0, 30000, 'Pendapatan Admin Fee');

-- Jurnal untuk pembayaran harian
INSERT INTO journal_details VALUES
(null, journal_id, 1010, 35000, 0, 'Kas - Angsuran #123'),
(null, journal_id, 1100, 0, 33000, 'Piutang Pinjaman Mikro'),
(null, journal_id, 4010, 0, 2000, 'Pendapatan Bunga Harian');
```

### 9.2 Notifikasi WhatsApp
```php
// Template notifikasi
$messages = [
    'payment_reminder' => 'Yth {name}, jangan lupa setor Kewer Rp{amount} hari ini. Terima kasih!',
    'loan_due' => 'Yth {name}, angsuran pinjaman Rp{amount} jatuh tempo hari ini.',
    'late_payment' => 'Yth {name}, pembayaran Anda terlambat {days} hari. Segera bayar.',
    'loan_approved' => 'Selamat {name}, pinjaman Rp{amount} telah disetujui. Ambil di cabang.'
];
```

---

## 10. Skala Bisnis Realistis

### 10.1 Cabang Kecil (Perdesaan)
- **Anggota**: 300-500 orang
- **Pinjaman aktif**: 100-200 pinjaman
- **Rata-rata pinjaman**: Rp1.000.000
- **Total portfolio**: Rp100-200 juta
- **Kolektor**: 2-3 orang
- **Target harian/kolektor**: Rp500.000-1.000.000

### 10.2 Cabang Sedang (Kota Kecil)
- **Anggota**: 800-1.500 orang
- **Pinjaman aktif**: 300-600 pinjaman
- **Rata-rata pinjaman**: Rp1.500.000
- **Total portfolio**: Rp450-900 juta
- **Kolektor**: 5-8 orang
- **Target harian/kolektor**: Rp800.000-1.500.000

### 10.3 Cabang Besar (Kota)
- **Anggota**: 2.000-5.000 orang
- **Pinjaman aktif**: 800-2.000 pinjaman
- **Rata-rata pinjaman**: Rp2.000.000
- **Total portfolio**: Rp1,6-4 miliar
- **Kolektor**: 10-15 orang
- **Target harian/kolektor**: Rp1.000.000-2.000.000

---

## 11. Kesimpulan

Aplikasi Kewer/Mawar memiliki karakteristik unik yang membedakannya dari pinjaman konvensional:

✅ **Volume tinggi, nilai kecil** - Ratusan transaksi Rp10.000-50.000  
✅ **Frekuensi harian** - Kolektor kunjungi setiap hari  
✅ **Sistem kepercayaan** - Berbasis hubungan personal  
✅ **Regulasi sederhana** - Tidak perlu e-KYC kompleks  
✅ **Suku bunga terbatas** - Maksimal 0,275% per hari (8,25%/bulan)  

Dengan implementasi yang tepat, aplikasi Kewer/Mawar dapat:
- Melayani masyarakat mikro yang tidak bisa akses bank
- Memberikan profitabilitas yang stabil (NPL < 5%)
- Berkembang secara bertahap ke cabang-cabang baru
- Membangun inklusi keuangan di masyarakat

---

*Dokumen ini khusus untuk aplikasi Kewer/Mawar dengan skala pinjaman mikro yang realistis.*
