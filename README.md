# Aplikasi Koperasi Berjalan (Kewer-Mawar)

Aplikasi digital untuk **koperasi berjalan** dengan sistem **Kewer/Mawar** yang mendukung multi-unit dan multi-cabang.

## 🎯 Visi dan Tujuan

Membangun aplikasi koperasi berjalan yang mampu mengelola:
- **Operasi Door-to-Door**: Kolektor (AO) kunjungi anggota setiap hari
- **Simpanan Kewer**: Setoran harian Rp5.000-50.000 dengan imbal hasil
- **Simpanan Mawar**: Setoran bulanan Rp100.000-1.000.000 berjangka
- **Pinjaman Mikro**: Rp500.000-10.000.000 dengan angsuran harian/mingguan
- **Target Pasar**: Pedagang pasar, warung kelontong, UMKM kecil
- **Volume Tinggi**: 300-1.000 transaksi per hari per cabang
- **Deteksi Risiko**: Analisis keluarga dan kolektibilitas anggota
- **Pencegahan Fraud**: Sistem segregation of duties dan audit trail
- **Laporan Real-time** dan dashboard analitik

## 🚀 Status Implementasi (27 Maret 2026)

### ✅ **Fitur yang Sudah Berjalan:**
- **Database-Driven Authentication** dengan password hashing
- **Multi-Role Login System** (6 role user dengan database integration)
- **Dashboard Role-Based** yang fully functional tanpa PHP errors
- **Quick Login Demo** untuk testing semua role
- **Responsive Design** dengan Bootstrap 5 dan device detection
- **PWA Features** dengan Service Worker dan manifest
- **Navigation System** dengan mobile toggle
- **Helper Functions** untuk format Indonesia (formatWaktu, formatRupiah, dll)
- **Error Handling** dan debugging yang comprehensive
- **XAMPP Integration** dengan proper Apache configuration

### 🔧 **Perbaikan Terbaru:**
- Fixed PHP warnings pada dashboard dengan null coalescing operator
- Added `formatWaktu()` helper function
- Updated authentication system ke database-based
- Fixed all undefined array keys issues
- Clean dashboard tanpa fatal errors

### 📱 **User Role System:**
| Role | Username | Password | Hak Akses | Status |
|------|----------|----------|-----------|--------|
| Administrator | `admin` | `admin` | Full system access | ✅ Tested |
| Manager Unit | `manager` | `manager` | Unit management | ✅ Tested |
| Branch Head | `branch_head` | `branch_head` | Branch operations | ✅ Tested |
| Collector | `collector` | `collector` | Mobile collection | ✅ Tested |
| Cashier | `cashier` | `cashier` | Cash transactions | ✅ Tested |
| Staff | `staff` | `staff` | Administrative | ✅ Tested |

## 🏗️ Arsitektur Teknologi

### Stack Teknologi
- **Frontend**: HTML5, Bootstrap 5, jQuery 3.7, FontAwesome 6
- **Backend**: PHP 8.2+ Native dengan session management
- **Database**: MySQL 8.0+ dengan multi-schema
- **Mobile**: Progressive Web App (PWA) untuk kolektor
- **Testing**: Puppeteer untuk E2E testing
- **Pattern**: Hybrid dengan door-to-door collection

### Struktur Folder
```
/gabe/
├── api/                 - API endpoints (dalam pengembangan)
├── pages/               - Halaman aplikasi
│   ├── login.php       - Login dengan quick access
│   ├── quick_login.php - Demo semua role
│   ├── web/            - Dashboard desktop
│   ├── mobile/         - Dashboard mobile
│   └── template_*.php  - Template components
├── assets/              - Static files
│   ├── css/           - Bootstrap + custom styles
│   ├── js/            - JavaScript libraries
│   ├── images/        - Images dan icons
│   └── webfonts/       - Font Awesome fonts
├── config/             - Configuration files
├── database/           - SQL schemas
└── tests/              - Puppeteer E2E tests
```

## 🌐 Cara Akses Aplikasi

### **Persyaratan:**
- XAMPP dengan Apache + MySQL
- PHP 8.2+ 
- Browser modern (Chrome, Firefox)

### **Instalasi:**
1. Start XAMPP: `sudo /opt/lampp/lampp start`
2. Akses: `http://localhost/gabe/`
3. Login dengan role yang diinginkan

### **Quick Access:**
- **Login Page**: `http://localhost/gabe/pages/login.php`
- **Quick Login Demo**: `http://localhost/gabe/pages/quick_login.php`
- **Dashboard**: `http://localhost/gabe/pages/web/dashboard.php`

## 🧪 Testing & Quality Assurance

### **Automated Testing:**
- **Puppeteer E2E**: Comprehensive system testing
- **Mobile Responsiveness**: Multi-device testing
- **PWA Features**: Service worker testing
- **Performance**: Load time dan metrics

### **Manual Testing:**
- **6 Role Testing**: Setiap role dengan hak akses berbeda
- **Responsive Design**: Desktop, tablet, mobile
- **Cross-browser**: Chrome, Firefox compatibility
- **User Experience**: Navigation dan usability

## 📊 Dokumentasi

- **[Panduan Lengkap](PANDUAN_LENGKAP_KOPERASI_BERJALAN.md)** - Dokumentasi detail
- **[Project Status](PROJECT_STATUS.md)** - Status implementasi
- **[Setup Instructions](setup_instructions.md)** - Panduan instalasi
- **[API Documentation](api/docs/api_documentation.md)** - API reference
- **[Testing Guide](tests/README.md)** - Testing procedures

## 🔧 Development Tools

### **Testing Commands:**
```bash
# Puppeteer comprehensive test
cd /opt/lampp/htdocs/gabe/tests && npm test

# Headless testing
HEADLESS=true node puppeteer-comprehensive-test.js

# Specific test suites
npm run test:auth
npm run test:mobile
npm run test:pwa
```

### **Debug Tools:**
- **PWA Debug**: `window.PWA_DEBUG` di browser console
- **Device Detection**: `window.deviceType`, `window.userRole`
- **Responsive Manager**: `window.responsiveManager`

## 🎯 Roadmap Development

### **Phase 1 (Selesai):**
- ✅ Login system dengan multi-role
- ✅ Responsive design
- ✅ PWA basic features
- ✅ Navigation system
- ✅ Testing framework

### **Phase 2 (Dalam Pengembangan):**
- 🔄 API endpoints development
- 🔄 Database integration
- 🔄 Real dashboard functionality
- 🔄 Mobile collection features

### **Phase 3 (Rencana):**
- 📋 Advanced reporting
- 📋 Analytics dashboard
- 📋 Offline mobile app
- 📋 Integration APIs

## 📞 Kontak & Support

- **Development**: Cascade AI Assistant
- **Documentation**: Lihat folder `/docs/`
- **Issues**: Check error logs di `/opt/lampp/logs/`

---

**© 2024 Koperasi Berjalan - Aplikasi Digital Koperasi Simpan Pinjam**
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
