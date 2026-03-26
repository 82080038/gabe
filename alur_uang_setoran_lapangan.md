# Alur Uang Setoran dari Nasabah di Lapangan
## Implementasi Sistem Pemisahan Tugas (Segregation of Duties)

---

## Ringkasan Alur Kerja

**Prinsip Utama**: Kolektor **tidak pernah memegang uang tunai** dalam jumlah besar. Semua transaksi menggunakan sistem **verifikasi digital** dan **setoran langsung ke kasir cabang** atau **transfer bank**.

---

## 1. Metode Setoran yang Direkomendasikan

### Metode A: Transfer Langsung (Paling Direkomendasikan)
```
Nasabah (Lapangan) → Transfer Bank → Kasir Cabang → Verifikasi Digital
```

**Langkah-langkah:**
1. **Kolektor menginformasikan** nomor rekening cabang kepada nasabah
2. **Nasabah melakukan transfer** dari:
   - Mobile banking (BCA, Mandiri, BRI, dll)
   - E-wallet (GoPay, OVO, Dana) dengan transfer ke rekening
   - ATM terdekat
3. **Kolektor menerima bukti transfer** (screenshot foto)
4. **Kolektor upload bukti** ke aplikasi mobile
5. **Sistem mencatat transaksi** dengan status "pending verification"
6. **Kasir cabang memverifikasi** transfer masuk ke rekening
7. **Status berubah "verified"** dan transaksi final

**Keuntungan:**
- ✅ Kolektor tidak pegang uang tunai
- ✅ Ada jejak digital yang jelas
- ✅ Nasabah bisa transfer kapan saja
- ✅ Mengurangi risiko kehilangan uang

### Metode B: Setoran ke Kasir Cabang
```
Nasabah (Lapangan) → Datang ke Cabang → Bayar ke Kasir → Verifikasi
```

**Langkah-langkah:**
1. **Kolektor memberikan struk/tagihan** kepada nasabah
2. **Nasabah datang ke cabang** pada jam operasional
3. **Nasabah bayar langsung ke kasir** dengan:
   - Tunai
   - Transfer bank di lokasi
   - QR code payment
4. **Kasir mencatat pembayaran** di sistem
5. **Kolektor update status** di aplikasi mobile

**Keuntungan:**
- ✅ Nasabah terbiasa dengan cara ini
- ✅ Kasir yang bertanggung jawab atas uang
- ✅ Transaksi langsung tercatat

### Metode C: Mobile Banking Agent (Untuk Area Terpencil)
```
Nasabah → Mobile Banking Agent → Transfer ke Kasir Cabang → Verifikasi
```

**Langkah-langkah:**
1. **Identifikasi agen terdekat** (warung, minimarket, BRI Link)
2. **Kolektor arahkan nasabah** ke agen tersebut
3. **Nasabah setor tunai ke agen**
4. **Agen transfer ke rekening cabang**
5. **Upload bukti transfer** ke aplikasi

---

## 2. Implementasi Teknis di Aplikasi

### 2.1 Mobile Collector App
```php
// Endpoint untuk kolektor mencatat setoran
POST /api/collector/record-payment
{
    "member_id": "12345",
    "payment_type": "transfer", // transfer, cash_at_branch, agent
    "amount": 1000000,
    "payment_method": "bca_mobile", // bca_mobile, mandiri_syariah, gopay
    "evidence": "base64_image", // bukti transfer/screenshot
    "location": {
        "lat": -7.2575,
        "lng": 112.7521
    },
    "notes": "Anggota setor via BCA Mobile"
}
```

### 2.2 Workflow Sistem
```php
class PaymentProcessor {
    public function recordPayment($data) {
        // 1. Simpan transaksi dengan status pending
        $transaction = $this->createTransaction([
            'member_id' => $data['member_id'],
            'amount' => $data['amount'],
            'payment_type' => $data['payment_type'],
            'status' => 'pending_verification',
            'collector_id' => Auth::user()->id,
            'evidence' => $data['evidence'],
            'location' => $data['location']
        ]);
        
        // 2. Kirim notifikasi ke kasir cabang
        $this->notifyCashier([
            'type' => 'new_payment_pending',
            'transaction_id' => $transaction->id,
            'amount' => $data['amount'],
            'member_name' => $transaction->member->name
        ]);
        
        // 3. Jika transfer, cek otomatis (API banking)
        if ($data['payment_type'] === 'transfer') {
            $this->autoVerifyTransfer($transaction);
        }
        
        return $transaction;
    }
}
```

### 2.3 Verifikasi oleh Kasir
```php
// Dashboard Kasir untuk verifikasi
GET /api/cashier/pending-payments
{
    "data": [
        {
            "id": 1001,
            "member_name": "Ahmad Wijaya",
            "amount": 1000000,
            "payment_type": "transfer",
            "payment_method": "bca_mobile",
            "evidence": "https://storage.example.com/evidence/1001.jpg",
            "time": "2025-03-27 09:30:00",
            "collector": "Budi Santoso"
        }
    ]
}

// Kasir approve/reject
POST /api/cashier/verify-payment/1001
{
    "action": "approve", // approve atau reject
    "notes": "Transfer sudah masuk ke rekening cabang"
}
```

---

## 3. Alur Darurat (Jika Nasabah Hanya Punya Tunai)

### 3.1 Prosedur Khusus
**Hanya untuk keadaan darurat** (nasabah tidak punya akses banking):

1. **Kolektor terima uang tunai** (maksimal Rp500.000 per transaksi)
2. **Buat kwitansi digital** dengan foto uang dan nasabah
3. **Sistem lock akun kolektor** hingga setoran ke kasir
4. **Kolektor wajib setor ke kasir** dalam 2 jam
5. **Kasir verifikasi dan unlock akun kolektor**

### 3.2 Implementasi Lock Mechanism
```php
// Lock kolektor jika terima tunai
public function lockCollectorForCash($collectorId, $amount) {
    // 1. Lock akun
    $this->lockAccount($collectorId);
    
    // 2. Set deadline 2 jam
    $deadline = now()->addHours(2);
    
    // 3. Kirim alert ke supervisor
    $this->alertSupervisor([
        'message' => "Kolektor {$collectorId} terima tunai Rp{$amount}",
        'deadline' => $deadline,
        'action_required' => 'pastikan setor ke kasir sebelum deadline'
    ]);
    
    // 4. Auto unlock jika lewat deadline (dengan penalty)
    $this->scheduleAutoUnlock($collectorId, $deadline);
}
```

---

## 4. Kontrol & Audit

### 4.1 Daily Reconciliation
Setiap hari jam 16:00, sistem otomatis:
```sql
-- Rekap transaksi per kolektor
SELECT 
    c.name as collector_name,
    COUNT(t.id) as total_transactions,
    SUM(t.amount) as total_amount,
    COUNT(CASE WHEN t.status = 'pending' THEN 1 END) as pending_count,
    COUNT(CASE WHEN t.payment_type = 'cash' THEN 1 END) as cash_count
FROM transactions t
JOIN users c ON t.collector_id = c.id
WHERE DATE(t.created_at) = CURDATE()
GROUP BY c.id;
```

### 4.2 Alert System
- **Jika kolektor punya pending > 5 transaksi**: Alert ke supervisor
- **Jika kolektor terima tunai > Rp1 juta/hari**: Auto lock
- **Jika kolektor tidak setor dalam 2 jam**: Escalation ke kepala cabang

### 4.3 Audit Trail
Setiap transaksi tercatat:
```json
{
    "transaction_id": 1001,
    "timestamp": "2025-03-27 09:30:00",
    "collector_id": 45,
    "member_id": 12345,
    "payment_type": "transfer",
    "amount": 1000000,
    "evidence": "screenshot_bca_mobile.jpg",
    "location": {"lat": -7.2575, "lng": 112.7521},
    "verification_time": "2025-03-27 09:45:00",
    "verified_by": 22,
    "status_changes": [
        {"time": "09:30", "status": "pending", "user": "collector"},
        {"time": "09:45", "status": "verified", "user": "cashier"}
    ]
}
```

---

## 5. Keuntungan Sistem Ini

### 5.1 Mengurangi Risiko Fraud
- ✅ **Kolektor tidak pegang uang tunai besar**
- ✅ **Semua transaksi tercatat digital**
- ✅ **Ada bukti transfer/foto**
- ✅ **Verifikasi oleh pihak ketiga (kasir)**

### 5.2 Meningkatkan Efisiensi
- ✅ **Nasabah bisa transfer kapan saja**
- ✅ **Tidak perlu tunggu kolektor**
- ✅ **Real-time tracking**
- ✅ **Otomatisasi notifikasi**

### 5.3 Kepatuhan Regulasi
- ✅ **Memenuhi segregation of duties**
- ✅ **Audit trail lengkap**
- ✅ **Siap untuk audit OJK**
- ✅ **Transparansi penuh**

---

## 6. Implementasi Bertahap

### Fase 1: Transfer Langsung (Minggu 1-2)
1. Setup rekening cabang
2. Integrasi mobile banking verification
3. Training kolektor dan nasabah

### Fase 2: Setoran di Cabang (Minggu 3-4)
1. Modifikasi prosedur kasir
2. QR code payment system
3. Dashboard verifikasi

### Fase 3: Mobile Agent & Darurat (Minggu 5-6)
1. Integrasi dengan agen
2. Lock mechanism untuk tunai
3. Emergency procedures

---

## 7. Contoh Kasus Real

### Kasus: Nasabah Pedagang Pasar
**Nama:** Ibu Siti, penjual sayur di pasar traditional
**Lokasi:** 15km dari cabang terdekat
**Masalah:** Tidak punya mobile banking, hanya punya tunai

**Solusi:**
1. **Kolektor arahkan ke BRI Link terdekat (500m)**
2. **Ibu Siti setor Rp500.000 ke BRI Link**
3. **BRI Link transfer ke rekening cabang**
4. **Kolektor upload bukti transfer**
5. **Kasir verifikasi dalam 10 menit**
6. **Transaksi selesai, Ibu Siti dapat struk digital**

**Hasil:**
- ✅ Ibu Siti tidak perlu jalan 15km
- ✅ Kolektor tidak pegang uang tunai
- ✅ Transaksi tercatat digital
- ✅ Ada bukti yang bisa di-verify

---

## 8. Kesimpulan

Dengan sistem ini, **uang setoran dari nasabah di lapangan tidak pernah melalui tangan kolektor**. Semua transaksi menggunakan jalur digital yang dapat dilacak dan diverifikasi, menghilangkan risiko fraud internal yang terjadi di kasus MSI Magetan.

**Kunci kesuksesan:**
1. **Edukasi nasabah** tentang transfer banking
2. **Fasilitasi pembayaran** di berbagai channel
3. **Kontrol ketat** untuk kasus darurat tunai
4. **Audit continuous** untuk semua transaksi

---

*Implementasi ini menjawab pertanyaan "bagaimana dengan uang setoran dari nasabah di lapangan?" dengan solusi yang aman, efisien, dan sesuai regulasi.*
