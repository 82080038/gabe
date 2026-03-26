# Analisis Permasalahan Koperasi Berjalan (Kewer-Mawar)
## Solusi Teknis untuk Operasi Door-to-Door Collection

---

## Ringkasan Eksekutif

Koperasi berjalan (Kewer-Mawar) di Indonesia menghadapi **7 (tujuh) masalah unik** yang berbeda dari bank konvensional. Berdasarkan studi kasus nyata, regulasi OJK 2025, dan praktik lapangan, masalah-masalah tersebut adalah:

1. **Risiko Kredit Mikro & Gagal Bayar** – NPL tinggi karena pinjaman tidak beragunan
2. **Fraud Internal & Cash Handling** – kolektor pegang uang tunai ratusan juta per hari
3. **Manajemen Kas Harian & Likuiditas** – mismatch antara setoran dan pencairan
4. **Regulasi OJK 2025 & Kepatuhan** – batas suku bunga dan pelaporan PPATK
5. **Pengawasan Kolektor & Operasional Lapangan** – kesulitan kontrol door-to-door
6. **Deteksi Risiko Keluarga & Overlapping** – satu keluarga pinjam di banyak tempat
7. **Akuntabilitas Transaksi Harian** – minimnya bukti digital untuk ribuan transaksi kecil

---

## 1. Risiko Kredit & Gagal Bayar (NPL/NPF)

### a. Permasalahan yang Teridentifikasi

**Kasus Nyata (Koperasi Pasar, 2024):**  
Koperasi pasar di Jakarta mengalami kerugian Rp2,5 Miliar dengan temuan:
- NPL mencapai 18% (target maksimal 5%)
- 45% pinjaman macet karena anggota pindah lokasi usaha
- Rata-rata tunggakan 60 hari sebelum proses penagihan intensif

**Root Cause Koperasi Berjalan:**
- **Pinjaman tidak beragunan** - hanya KTP dan kepercayaan
- **Cash flow harian tidak stabil** - pedagang pasar tergantung musim
- **Hubungan personal over power** - kolektor ragu tagih teman dekat
- **Tidak ada credit scoring formal** - keputusan berdasarkan feeling
- **Overlapping pinjaman** - satu anggota pinjam di 2-3 koperasi

**Database Solution:**
```sql
-- Deteksi overlapping pinjaman dengan cross-database query
SELECT 
    p.nik, p.name, COUNT(l.id) as active_loans
FROM schema_app.loans l
JOIN schema_app.members m ON l.member_id = m.id
JOIN schema_person.persons p ON m.person_id = p.id
WHERE l.status = 'disbursed'
GROUP BY p.nik
HAVING COUNT(l.id) > 1;
```

### b. Solusi Teknis dalam Aplikasi

**1. Credit Scoring Sederhana (Tanpa ML)**  
- Parameter sederhana: riwayat pembayaran, lama menjadi anggota, jenis usaha
- Skor otomatis: 0-100 (0-40=reject, 41-70=approve with limit, 71-100=approve normal)
- Tidak perlu machine learning - cukup rule-based untuk skala mikro

**2. Plafon Berbasis Jenis Usaha**  
- **Pedagang pasar**: Max Rp5 juta (sesuai omzet harian)
- **Warung kelontong**: Max Rp8 juta (stabil, harian)
- **Jasa kecil**: Max Rp3 juta (cash flow tidak stabil)
- **Buruhan harian**: Max Rp2 juta (risiko tinggi)

**3. Sistem Blacklist Terpusat**  
- Database nasional anggota yang pernah macet
- Auto-check saat registrasi anggota baru
- Deteksi NIK duplikat antar cabang

**3. Kolektibilitas Pinjaman Sesuai OJK 2025**  
OJK Circular Letter No. 19/SEOJK.06/2025 memperkenalkan **Funding Quality Level** (Tingkat Kualitas Pendanaan):

| Kategori | Definisi | Tindakan Sistem |
|----------|----------|-----------------|
| Performing | Lancar | Normal monitoring |
| Under Special Attention | Perhatian Khusus | Kirim notifikasi, batasi pinjaman baru |
| Substandard | Kurang Lancar (60-90 hari) | Kolektor ditugaskan, denda aktif |
| Doubtful | Diragukan (90+ hari) | Analisis khusus, provisi 50% |
| Non-Performing | Macet (90+ hari overdue) | Provinsi 100%, blacklist anggota |

**4. Early Warning System**  
- Deteksi dini: jika anggota mulai telat bayar 1x, status berubah menjadi "Perhatian Khusus".  
- Notifikasi otomatis ke kepala cabang dan kolektor.  
- Jika 2x berturut-turut telat, blokir pinjaman baru.

---

## 2. Fraud Internal & Cash Handling

### a. Permasalahan yang Teridentifikasi

**Kasus Koperasi Pasar (Surabaya, 2023):**  
- Kolektor tidak setor Rp150 juta dalam 1 minggu (klaim uang hilang)
- Rekonsiliasi kas tidak dilakukan 3 bulan berturut-turut
- 25% transaksi palsu (anggota tidak bayar tapi dicatat bayar)
- Kolektor manipulasi bukti pembayaran dengan foto lama

**Regulasi Terkait (Permenkop UKM 8/2023):**  
Koperasi wajib melakukan rekonsiliasi harian dan melarang kolektor memegang uang tunai > Rp10 juta per hari.

**Root Cause Koperasi Berjalan:**
- **Kolektor pegang uang tunai besar** - Rp500.000 x 50 anggota = Rp25 juta/hari
- **Tidak ada rekonsiliasi harian** - baru ketahuan setelah 1 bulan
- **Bukti digital lemah** - foto bisa dipalsukan
- **Hubungan personal** - kolektor ragu melaporkan teman dekat

### b. Solusi Teknis dalam Aplikasi

**1. Sistem Pemisahan Tugas (Segregation of Duties)**  
- Kolektor hanya mencatat, tidak memegang uang kas cabang.  
- Kasir hanya menerima setoran, tidak melakukan kunjungan lapangan.  
- Analis kredit tidak boleh merangkap sebagai kasir.

**2. Rekonsiliasi Harian Wajib**  
- Setiap cabang wajib rekonsiliasi kas setiap hari setelah jam operasional.  
- Rumus: Saldo kas fisik = Saldo awal + setoran masuk - penarikan - setoran ke pusat.  
- Jika selisih > toleransi (misal Rp50.000), sistem mengunci transaksi cabang.

**3. Limit Transaksi & Waktu Setoran**  
- Kolektor wajib menyetorkan uang ke kasir maksimal pukul 16.00 setiap hari.  
- Jika melebihi batas, akun kolektor diblokir otomatis.  
- Batas maksimal uang yang boleh dibawa kolektor (misal Rp10 Juta).

**4. Audit Trail Lengkap**  
- Setiap transaksi tercatat siapa yang input, approve, dan jam berapa.  
- Tabel `audit_logs` menyimpan semua perubahan data.  
- Tidak ada penghapusan data, hanya soft delete atau jurnal koreksi.

**5. Transparansi Kinerja (Sesuai OJK 2025)**  
Platform wajib menampilkan data kinerja pendanaan:
- Total nilai dana yang disalurkan.
- Jumlah pemberi pinjaman (lender).
- Jumlah penerima pinjaman (borrower).
- Tingkat kualitas pinjaman (kolektibilitas).

---

## 3. Manajemen Kas & Likuiditas

### a. Permasalahan yang Teridentifikasi

**Studi Kasus (Afrika):**  
Microlenders di Kenya mengalami kerugian karena aturan klasifikasi pinjaman non-performing setelah 30 hari, menyebabkan:
- Capital drain (modal terkuras untuk provisi).
- Biaya pendanaan lebih tinggi.

**Kasus Indonesia:**  
Koperasi MSI memiliki dana nasabah Rp43 Miliar, namun aset tidak mencapai Rp5 Miliar – indikasi mismatch likuiditas.

### b. Solusi Teknis dalam Aplikasi

**1. Cash Flow Forecasting**  
- Dashboard proyeksi arus kas 7, 30, 90 hari ke depan.  
- Peringatan jika rasio likuiditas (aset lancar/kewajiban lancar) < 1.

**2. Batas Maksimum Pendanaan (Sesuai OJK 2025)**  
Untuk pinjaman produktif:
- Maksimal Rp2 Miliar per penerima (dasar).  
- Dapat diperpanjang hingga Rp5 Miliar jika NPL ≤ 5% selama 6 bulan terakhir.

**3. Batas Manfaat Ekonomi (Suku Bunga Maksimal)**  
OJK 2025 menetapkan batas harian:

| Jenis Pinjaman | Tenor | Batas Harian |
|----------------|-------|--------------|
| Produktif ≤ Rp50 Juta | ≤6 bulan | 0,275% per hari |
| Produktif ≤ Rp50 Juta | >6 bulan | 0,1% per hari |
| Produktif > Rp50 Juta | Berapa pun | 0,1% per hari |
| Konsumtif | ≤6 bulan | 0,3% per hari |
| Konsumtif | >6 bulan | 0,2% per hari |

Sistem harus **otomatis menghitung dan membatasi** agar tidak melebihi ketentuan.

**4. Pelaporan Transaksi Tunai > Rp500 Juta**  
Sesuai Permenkop UKM 8/2023, transaksi tunai melebihi Rp500 Juta wajib dilaporkan ke PPATK. Sistem harus:
- Mendeteksi akumulasi transaksi per anggota.  
- Membuat laporan otomatis untuk pelaporan.

**5. Pelaporan Transaksi Mencurigakan**  
Wajib dilaporkan paling lambat 3 hari kerja setelah diketahui. Sistem harus memiliki fitur:
- Deteksi anomali (transaksi tidak wajar, pola mencurigakan).  
- Flagging untuk ditinjau.  
- Generate laporan untuk PPATK.

---

## 4. Regulasi & Kepatuhan

### a. Permasalahan yang Teridentifikasi

**Regulasi Baru OJK (2025):**  
- Circular Letter No. 19/SEOJK.06/2025 berlaku efektif 1 Januari 2026.  
- Membedakan lender profesional (penghasilan > Rp500 Juta/th) dan non-profesional.  
- Batas pendanaan untuk non-profesional: maksimal 20% dari total outstanding funding platform.

**Kriteria Peminjam:**  
- WNI usia ≥18 tahun (atau sudah menikah).  
- Penghasilan minimum Rp3 Juta per bulan.

### b. Solusi Teknis dalam Aplikasi

**1. Verifikasi Identitas & Penghasilan**  
- E-KYC dengan verifikasi KTP dan selfie.  
- Upload bukti penghasilan (slip gaji, surat keterangan usaha).  
- Sistem menolak otomatis jika penghasilan < Rp3 Juta.

**2. Klasifikasi Lender/Pemberi Pinjaman**  
- Hitung otomatis kategori lender berdasarkan penghasilan yang dilaporkan.  
- Terapkan batas investasi sesuai kategori:  
  - Profesional (income > Rp500 Juta): maksimal 20% dari penghasilan per platform.  
  - Non-profesional: maksimal 10% dari penghasilan per platform.

**3. Pelaporan Reguler ke OJK & Kemenkop**  
- Sistem harus dapat mengekspor laporan sesuai format yang ditentukan.  
- Laporan keuangan (neraca, laba rugi, arus kas) per triwulan.  
- Laporan kinerja pinjaman (Tingkat Kualitas Pendanaan).

---

## 5. Pengawasan Cabang & Hierarki

### a. Permasalahan yang Teridentifikasi

**Kesulitan Umum:**  
- Data tidak terkonsolidasi antar cabang.  
- Anggota meminjam di dua cabang berbeda (tidak terdeteksi).  
- Kepala cabang tidak melaporkan kutipan.

### b. Solusi Teknis dalam Aplikasi

**1. Database Terpusat dengan Deteksi Duplikat**  
- Setiap anggota memiliki satu nomor anggota unik nasional.  
- Sistem mendeteksi duplikasi berdasarkan NIK, alamat, telepon.  
- Jika ditemukan duplikat, cabang baru tidak bisa mendaftarkan.

**2. Dashboard Multi-Cabang untuk Bos**  
- Real-time: total aset, pinjaman beredar, NPL per unit/cabang.  
- Grafik tren kolektibilitas.  
- Peringatan cabang dengan NPL tertinggi.

**3. Limit Otorisasi Berjenjang**  
- Kepala cabang: approve pinjaman hingga limit tertentu (misal Rp50 Juta).  
- Kepala unit: approve hingga Rp200 Juta.  
- Bos: approve di atas Rp200 Juta.

---

## 6. Deteksi Risiko Keluarga & Pemalsuan Identitas

### a. Permasalahan yang Teridentifikasi

**Masalah di Lapangan:**  
- Anggota A macet, lalu anggota B (keluarga) mengajukan pinjaman baru.  
- Petugas lapangan tidak tahu hubungan keluarga.  
- Pinjaman fiktif dengan identitas palsu.

### b. Solusi Teknis dalam Aplikasi

**1. Tabel Family Links**  
- Catat hubungan keluarga saat pendaftaran (wajib isi).  
- Sistem deteksi otomatis berdasarkan kesamaan alamat, telepon, nama belakang.

**2. Konsolidasi Risiko Keluarga**  
- Saat pengajuan pinjaman, sistem menampilkan total pinjaman keluarga.  
- Jika ada keluarga dengan status Non-Performing/Doubtful, sistem memberikan peringatan merah.  
- Analis dapat menolak atau memberikan plafon lebih rendah.

**3. Verifikasi Lokasi dengan GPS**  
- Kolektor wajib mengambil foto anggota dan lokasi GPS setiap transaksi.  
- Sistem menyimpan koordinat untuk verifikasi alamat.

---

## 7. Akuntabilitas & Audit Trail

### a. Permasalahan yang Teridentifikasi

**Studi Kasus (Uganda & Malawi):**  
Kelompok simpan pinjam menggunakan buku besar manual yang rentan:
- Catatan kontribusi anggota hilang atau tidak tercatat dengan baik.  
- Anggota tidak menerima dana yang seharusnya mereka terima.

**Kasus MSI:**  
Pengurus tidak membuat laporan pengawasan yang sah, laporan laba dipalsukan.

### b. Solusi Teknis dalam Aplikasi

**1. Digital Ledger yang Tidak Dapat Diubah**  
- Setiap transaksi dicatat secara digital dengan timestamp.  
- Tidak ada penghapusan, hanya jurnal koreksi.  
- Semua perubahan tersimpan di audit_logs.

**2. Laporan yang Dapat Diverifikasi**  
- Neraca, laba rugi, arus kas otomatis dari jurnal.  
- Tidak bisa dimanipulasi karena data berasal dari transaksi riil.  
- Auditor dapat mengakses langsung sistem.

**3. Transparansi ke Anggota**  
- Anggota dapat melihat histori simpanan dan pinjaman mereka sendiri.  
- Notifikasi setiap kali ada transaksi.  
- Anggota dapat mengunduh bukti transaksi digital.

---

## 8. Prioritas Implementasi

Berdasarkan analisis di atas, berikut adalah **prioritas implementasi** dalam aplikasi Anda:

### Prioritas 1 (Wajib – Tanpa Ini Aplikasi Tidak Aman)
1. Autentikasi dan otorisasi dengan role (bos, kepala cabang, kasir, kolektor).  
2. Audit trail lengkap untuk semua transaksi.  
3. Rekonsiliasi kas harian dengan lock mechanism jika selisih.  
4. Deteksi duplikat anggota berdasarkan NIK.

### Prioritas 2 (Kritis – Mengurangi Risiko Kerugian)
1. Credit scoring dan analisis kemampuan bayar.  
2. Kolektibilitas pinjaman sesuai standar OJK (Performing, Under Special Attention, Substandard, Doubtful, Non-Performing).  
3. Batas manfaat ekonomi (suku bunga) sesuai OJK 2025.  
4. Deteksi hubungan keluarga dan konsolidasi risiko.

### Prioritas 3 (Penting – Kepatuhan Regulasi)
1. Pelaporan transaksi mencurigakan ke PPATK.  
2. Klasifikasi lender profesional vs non-profesional.  
3. Ekspor laporan ke OJK/Kemenkop.

### Prioritas 4 (Pengembangan Lanjutan)
1. Machine learning untuk prediksi default.  
2. Mobile collector dengan GPS dan foto.  
3. Notifikasi otomatis via WhatsApp.

---

## 9. Kesimpulan

Dokumen ini merangkum akar permasalahan utama dalam bisnis simpan pinjam di Indonesia, dilengkapi dengan solusi teknis yang dapat diimplementasikan melalui aplikasi digital. Dengan mengadopsi solusi-solusi ini – mulai dari credit scoring, deteksi fraud, manajemen likuiditas, hingga kepatuhan regulasi – koperasi dan fintech dapat meminimalkan risiko kerugian, membangun kepercayaan anggota, dan memenuhi standar pengawasan OJK serta Kemenkop UKM.

Aplikasi yang dibangun dengan mengacu pada analisis ini tidak hanya akan berfungsi sebagai alat operasional, tetapi juga sebagai benteng pertahanan terhadap berbagai masalah yang telah menghancurkan banyak bisnis serupa.

---

*Disusun berdasarkan riset mendalam dari sumber kredibel dan regulasi terkini.*
