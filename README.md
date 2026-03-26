# Aplikasi Simpan Pinjam (Koperasi)

Aplikasi manajemen koperasi simpan pinjam dengan sistem **Kewer/Mawar** yang mendukung multi-unit dan multi-cabang.

## 🎯 Visi dan Tujuan

Membangun aplikasi simpan pinjam yang mampu mengelola:
- **Hierarki Organisasi**: BOS → UNIT → CABANG
- **Produk Simpanan Berkala** (harian/mingguan) dengan imbal hasil (kewer/mawar)
- **Pinjaman** dengan angsuran harian/mingguan untuk pedagang pasar, pengusaha kecil, dan UMKM
- **Transaksi Kas** dengan frekuensi tinggi dan dukungan petugas lapangan (kolektor mobile)
- **Deteksi Risiko Kredit** melalui hubungan keluarga
- **Pencegahan Fraud Internal** (kutipan tidak disetor, pelarian dana)
- **Laporan Real-time** dan dashboard analitik

## 🏗️ Arsitektur Teknologi

### Stack Teknologi
- **Frontend**: HTML, Bootstrap, jQuery, AJAX
- **Backend**: PHP Native dengan REST API
- **Database**: MySQL (satu instance dengan beberapa schema logis)
- **Pattern**: Hybrid (bukan SPA murni)

### Struktur Folder
```
/api/          - Endpoint REST (auth, members, savings, loans, dll)
/pages/        - File HTML untuk setiap menu (dashboard, dll)
/assets/       - CSS, JS, vendor libraries
/config/       - Koneksi database, fungsi helper
```

## 🗄️ Arsitektur Database

Menggunakan **satu database instance** dengan **tiga schema logis**:

### 1. schema_person
Data personal, hubungan keluarga, dan biometrik

### 2. schema_address
Data alamat (provinsi, kabupaten, kecamatan, desa) dengan tipe: rumah, kantor, penagihan

### 3. schema_app
Data operasional: unit, cabang, anggota, simpanan, pinjaman, transaksi, kas, audit log

### Keuntungan Arsitektur Ini:
- ✅ JOIN lintas schema tetap dapat dilakukan
- ✅ Foreign key dapat dibuat antar schema (InnoDB support)
- ✅ Backup dan maintenance lebih sederhana
- ✅ Skalabilitas ke depan dengan sharding jika diperlukan

## 🚀 Fitur Inti

### 1. Manajemen Unit & Cabang
Khusus untuk level BOS, mengelola hierarki organisasi

### 2. Manajemen Anggota & Data Personal
- Registrasi anggota baru
- Data personal lengkap dengan foto dan biometrik
- Manajemen hubungan keluarga untuk deteksi risiko

### 3. Produk Simpanan Berkala (Kewer/Mawar)
- Simpanan harian/mingguan
- Perhitungan imbal hasil otomatis
- Tracking setoran dan penarikan

### 4. Pinjaman dengan Angsuran
- Pengajuan pinjaman dengan approval workflow
- Angsuran harian/mingguan/bulanan
- Perhitungan bunga (Flat, Efektif, Anuitas)
- Denda keterlambatan otomatis

### 5. Transaksi Kasir
Interface cepat untuk transaksi harian dengan frekuensi tinggi

### 6. Mobile Collector
Aplikasi untuk petugas lapangan dengan:
- Mode offline (PWA)
- Sinkronisasi otomatis saat online
- GPS tracking untuk setiap transaksi

### 7. Deteksi Hubungan Keluarga & Risiko Kredit
Analisis otomatis untuk mencegah risiko kredit berlebihan dalam satu keluarga

### 8. Pencegahan Fraud Internal
- Audit log lengkap
- Deteksi anomali transaksi
- Rekonsiliasi kas harian

### 9. Notifikasi Otomatis
- WhatsApp notification untuk angsuran jatuh tempo
- Alert untuk tunggakan
- Reminder untuk petugas

### 10. Laporan & Dashboard
- Dashboard real-time per cabang/unit
- Laporan keuangan
- Analisis performa kolektor
- Export ke Excel/PDF

## 🔐 Keamanan

- **Autentikasi**: Session-based dengan role-based access control (RBAC)
- **Otorisasi**: Multi-level (BOS, Unit Head, Branch Head, Kasir, Kolektor, Analis Kredit)
- **Enkripsi**: SSL/TLS untuk komunikasi, enkripsi data sensitif
- **Session Management**: Auto timeout, blocking IP setelah 5x gagal login
- **Audit Trail**: Logging semua aktivitas penting

## 💰 Manajemen Limit & Plafon

Setiap user dengan otoritas persetujuan memiliki limit plafon yang dikonfigurasi oleh BOS:
- Approval otomatis jika dalam limit
- Escalation ke atasan jika melebihi limit
- Audit trail untuk semua persetujuan

## 📊 Perhitungan Bunga & Denda

### Metode Bunga:
- **Flat**: Bunga tetap dari pokok pinjaman
- **Efektif**: Bunga dari sisa pokok (menurun)
- **Anuitas**: Angsuran tetap, komposisi berubah

### Denda Keterlambatan:
- Perhitungan otomatis per hari setelah jatuh tempo
- Konfigurasi per produk pinjaman
- Cron job untuk update status dan penalti

## 📱 Fitur Offline (Mobile Collector)

- **PWA** dengan service worker
- **Local Storage**: IndexedDB untuk transaksi offline
- **Sinkronisasi**: Batch upload saat online
- **Conflict Resolution**: Deteksi duplikasi dengan UUID
- **GPS Tracking**: Lokasi setiap transaksi untuk audit

## 💾 Backup & Disaster Recovery

### Strategi Backup:
- **Full Backup**: Harian pukul 02.00
- **Incremental**: Setiap 6 jam
- **Storage**: Cloud (AWS S3/Google Cloud) + server sekunder
- **Retention**: Harian 30 hari, bulanan 1 tahun

### Recovery:
- Failover ke replica < 1 jam
- Prosedur restore terdokumentasi
- Testing restore bulanan

### Redundansi:
- Database replication (master-slave)
- VPS dengan snapshot otomatis
- Load balancer untuk high availability

## 📋 Spesifikasi Non-Fungsional

- **Keamanan**: SSL/TLS, enkripsi data sensitif, session timeout
- **Performa**: Response time API < 2 detik, support 500 transaksi/jam per cabang
- **Ketersediaan**: Uptime target 99.5%, SLA server minimal 99.9%
- **Skalabilitas**: Arsitektur mendukung penambahan cabang tanpa perubahan signifikan

## 🔄 Rencana Migrasi Data

Untuk sistem yang sudah berjalan:
1. Identifikasi data lama (Excel, buku besar)
2. Buat skrip migrasi
3. Validasi dan pembersihan data
4. Testing di staging
5. Migrasi pada hari libur operasional

## 💻 Infrastruktur Rekomendasi

### Server:
- **VPS**: 4 vCPU, 8 GB RAM, 100 GB SSD
- **Provider**: DigitalOcean, AWS Lightsail, atau sejenisnya
- **Domain & SSL**: ~Rp 300.000/tahun

### Layanan Tambahan:
- **WhatsApp API**: Fonnte, WATI (sesuai volume)
- **Monitoring**: Uptime monitoring, error tracking

### Estimasi Biaya Pengembangan:
- **Tim Internal**: Sesuai gaji developer
- **Outsourcing**: Rp 250-600 juta (aplikasi lengkap)

## 📚 Dokumentasi & Pelatihan

- User manual (PDF) untuk setiap modul
- Video tutorial
- Pelatihan tatap muka untuk:
  - Kasir
  - Kolektor
  - Kepala Cabang
  - Analis Kredit
- Helpdesk internal untuk support harian

## 🛠️ Langkah Implementasi Bertahap

1. **Fase 1**: Setup infrastruktur dan database
2. **Fase 2**: Modul autentikasi dan manajemen user
3. **Fase 3**: Manajemen anggota dan data personal
4. **Fase 4**: Modul simpanan berkala
5. **Fase 5**: Modul pinjaman dan angsuran
6. **Fase 6**: Transaksi kasir dan mobile collector
7. **Fase 7**: Laporan dan dashboard
8. **Fase 8**: Notifikasi dan automation
9. **Fase 9**: Testing dan UAT
10. **Fase 10**: Deployment dan training

## 🎯 Fitur Tambahan yang Direkomendasikan

- Barcode/QR Code pada kartu anggota
- Multi-mata uang (opsional)
- Integrasi payment gateway (Virtual Account)
- API untuk sistem akuntansi eksternal
- Dashboard kolektor dengan target setoran harian

## 📄 Lisensi

Proprietary - Hak Cipta Dilindungi

## 👥 Kontributor

Dikembangkan dengan bantuan AI untuk mendukung ekspansi bisnis koperasi secara aman dan terkendali.

---

**Catatan**: Dokumen ini merupakan ringkasan final dari kerangka aplikasi. Simpan sebagai acuan pengembangan aplikasi.
