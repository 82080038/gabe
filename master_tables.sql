-- ================================================================
-- MASTER TABLES FOR KOPERASI BERJALAN NORMALIZATION
-- Reference tables that can be dynamically populated and related to other tables
-- ================================================================

USE schema_app;

-- ================================================================
-- 1. MASTER DATA FOR PERSONAL INFORMATION
-- ================================================================

-- Master Religions
CREATE TABLE IF NOT EXISTS master_religions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(10) UNIQUE NOT NULL COMMENT 'Kode agama',
    name VARCHAR(50) NOT NULL COMMENT 'Nama agama',
    description TEXT COMMENT 'Deskripsi',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_is_active (is_active)
);

-- Master Blood Types
CREATE TABLE IF NOT EXISTS master_blood_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(5) UNIQUE NOT NULL COMMENT 'Golongan darah (A, B, AB, O)',
    name VARCHAR(20) NOT NULL COMMENT 'Nama lengkap',
    rhesus_factor ENUM('+', '-') DEFAULT '+' COMMENT 'Faktor Rhesus',
    description TEXT COMMENT 'Deskripsi',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_is_active (is_active)
);

-- Master Education Levels
CREATE TABLE IF NOT EXISTS master_education_levels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(10) UNIQUE NOT NULL COMMENT 'Kode tingkat pendidikan',
    name VARCHAR(50) NOT NULL COMMENT 'Nama tingkat pendidikan',
    level_order INT NOT NULL COMMENT 'Urutan level',
    description TEXT COMMENT 'Deskripsi',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_level_order (level_order),
    INDEX idx_is_active (is_active)
);

-- Master Occupations
CREATE TABLE IF NOT EXISTS master_occupations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode pekerjaan',
    name VARCHAR(100) NOT NULL COMMENT 'Nama pekerjaan',
    category VARCHAR(50) COMMENT 'Kategori pekerjaan',
    bps_code VARCHAR(20) COMMENT 'Kode BPS',
    description TEXT COMMENT 'Deskripsi',
    income_level ENUM('low', 'medium', 'high', 'none') COMMENT 'Tingkat pendapatan',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_bps_code (bps_code),
    INDEX idx_is_active (is_active)
);

-- Master Business Types
CREATE TABLE IF NOT EXISTS master_business_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode jenis usaha',
    name VARCHAR(100) NOT NULL COMMENT 'Nama jenis usaha',
    category VARCHAR(50) COMMENT 'Kategori usaha',
    description TEXT COMMENT 'Deskripsi',
    risk_level ENUM('low', 'medium', 'high') DEFAULT 'medium' COMMENT 'Tingkat risiko',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_risk_level (risk_level),
    INDEX idx_is_active (is_active)
);

-- Master Document Types
CREATE TABLE IF NOT EXISTS master_document_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode dokumen',
    name VARCHAR(100) NOT NULL COMMENT 'Nama dokumen',
    category ENUM('identity', 'legal', 'financial', 'business', 'education', 'health', 'other') NOT NULL,
    description TEXT COMMENT 'Deskripsi',
    is_required BOOLEAN DEFAULT FALSE COMMENT 'Wajib diisi',
    expiry_required BOOLEAN DEFAULT FALSE COMMENT 'Memiliki masa berlaku',
    file_types_allowed TEXT COMMENT 'Tipe file yang diizinkan',
    max_file_size_mb INT DEFAULT 5 COMMENT 'Ukuran file maksimal (MB)',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_is_required (is_required),
    INDEX idx_is_active (is_active)
);

-- ================================================================
-- 2. MASTER DATA FOR FINANCIAL OPERATIONS
-- ================================================================

-- Master Banks
CREATE TABLE IF NOT EXISTS master_banks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(10) UNIQUE NOT NULL COMMENT 'Kode bank',
    name VARCHAR(100) NOT NULL COMMENT 'Nama bank',
    short_name VARCHAR(50) COMMENT 'Nama singkat',
    bank_type ENUM('government', 'private', 'foreign', 'syariah', 'rural', 'development') NOT NULL,
    bic_code VARCHAR(20) COMMENT 'BIC/SWIFT Code',
    headquarters VARCHAR(100) COMMENT 'Kantor pusat',
    website VARCHAR(100) COMMENT 'Website',
    phone VARCHAR(20) COMMENT 'Telepon',
    email VARCHAR(100) COMMENT 'Email',
    description TEXT COMMENT 'Deskripsi',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_bank_type (bank_type),
    INDEX idx_bic_code (bic_code),
    INDEX idx_is_active (is_active)
);

-- Master Currencies
CREATE TABLE IF NOT EXISTS master_currencies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(3) UNIQUE NOT NULL COMMENT 'Kode mata uang (ISO 4217)',
    name VARCHAR(50) NOT NULL COMMENT 'Nama mata uang',
    symbol VARCHAR(10) NOT NULL COMMENT 'Simbol mata uang',
    decimal_places INT DEFAULT 2 COMMENT 'Jumlah desimal',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_is_active (is_active)
);

-- Master Payment Methods
CREATE TABLE IF NOT EXISTS master_payment_methods (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode metode pembayaran',
    name VARCHAR(50) NOT NULL COMMENT 'Nama metode pembayaran',
    category ENUM('cash', 'bank_transfer', 'digital_wallet', 'card', 'auto_debit', 'check', 'other') NOT NULL,
    description TEXT COMMENT 'Deskripsi',
    processing_fee_rate DECIMAL(5,4) DEFAULT 0 COMMENT 'Biaya proses (%)',
    min_amount DECIMAL(12,2) COMMENT 'Jumlah minimal',
    max_amount DECIMAL(12,2) COMMENT 'Jumlah maksimal',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_is_active (is_active)
);

-- Master Fee Types
CREATE TABLE IF NOT EXISTS master_fee_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode jenis biaya',
    name VARCHAR(100) NOT NULL COMMENT 'Nama jenis biaya',
    category ENUM('admin', 'processing', 'late', 'early_payment', 'penalty', 'service', 'other') NOT NULL,
    calculation_method ENUM('fixed', 'percentage', 'tiered') DEFAULT 'percentage',
    default_rate DECIMAL(5,4) DEFAULT 0 COMMENT 'Tarif default (%)',
    default_amount DECIMAL(12,2) DEFAULT 0 COMMENT 'Jumlah default',
    description TEXT COMMENT 'Deskripsi',
    is_taxable BOOLEAN DEFAULT FALSE COMMENT 'Kena pajak',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_is_active (is_active)
);

-- ================================================================
-- 3. MASTER DATA FOR COMPLIANCE & LEGAL
-- ================================================================

-- Master ID Types
CREATE TABLE IF NOT EXISTS master_id_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode jenis identitas',
    name VARCHAR(100) NOT NULL COMMENT 'Nama jenis identitas',
    category ENUM('government', 'professional', 'business', 'educational', 'health', 'other') NOT NULL,
    issuing_authority VARCHAR(100) COMMENT 'Penerbit',
    format_pattern VARCHAR(50) COMMENT 'Pola format (regex)',
    length_min INT COMMENT 'Panjang minimal',
    length_max INT COMMENT 'Panjang maksimal',
    has_expiry BOOLEAN DEFAULT FALSE COMMENT 'Memiliki masa berlaku',
    description TEXT COMMENT 'Deskripsi',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_issuing_authority (issuing_authority),
    INDEX idx_is_active (is_active)
);

-- Master Relationship Types
CREATE TABLE IF NOT EXISTS master_relationship_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode hubungan',
    name VARCHAR(50) NOT NULL COMMENT 'Nama hubungan',
    category ENUM('family', 'business', 'legal', 'other') NOT NULL,
    relationship_level ENUM('1', '2', '3', '4', '5+') NOT NULL COMMENT 'Tingkat hubungan',
    inverse_relationship_id INT COMMENT 'Hubungan invers',
    description TEXT COMMENT 'Deskripsi',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (inverse_relationship_id) REFERENCES master_relationship_types(id),
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_relationship_level (relationship_level),
    INDEX idx_is_active (is_active)
);

-- Master Risk Levels
CREATE TABLE IF NOT EXISTS master_risk_levels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode tingkat risiko',
    name VARCHAR(50) NOT NULL COMMENT 'Nama tingkat risiko',
    score_min INT NOT NULL COMMENT 'Skor minimal',
    score_max INT NOT NULL COMMENT 'Skor maksimal',
    color_code VARCHAR(10) COMMENT 'Kode warna',
    description TEXT COMMENT 'Deskripsi',
    action_required TEXT COMMENT 'Tindakan yang diperlukan',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_score_range (score_min, score_max),
    INDEX idx_is_active (is_active)
);

-- Master Compliance Statuses
CREATE TABLE IF NOT EXISTS master_compliance_statuses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode status compliance',
    name VARCHAR(50) NOT NULL COMMENT 'Nama status',
    category ENUM('kyc', 'aml', 'audit', 'legal', 'other') NOT NULL,
    description TEXT COMMENT 'Deskripsi',
    next_step TEXT COMMENT 'Langkah berikutnya',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_is_active (is_active)
);

-- ================================================================
-- 4. MASTER DATA FOR OPERATIONS
-- ================================================================

-- Master Transaction Types
CREATE TABLE IF NOT EXISTS master_transaction_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode jenis transaksi',
    name VARCHAR(100) NOT NULL COMMENT 'Nama jenis transaksi',
    category ENUM('loan', 'savings', 'fee', 'transfer', 'adjustment', 'other') NOT NULL,
    direction ENUM('in', 'out', 'neutral') NOT NULL COMMENT 'Arah transaksi',
    description TEXT COMMENT 'Deskripsi',
    affects_balance BOOLEAN DEFAULT TRUE COMMENT 'Mempengaruhi saldo',
    requires_approval BOOLEAN DEFAULT FALSE COMMENT 'Memerlukan persetujuan',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_direction (direction),
    INDEX idx_is_active (is_active)
);

-- Master Notification Types
CREATE TABLE IF NOT EXISTS master_notification_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode jenis notifikasi',
    name VARCHAR(100) NOT NULL COMMENT 'Nama jenis notifikasi',
    category ENUM('info', 'warning', 'error', 'success', 'reminder', 'alert', 'promotion', 'system') NOT NULL,
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    description TEXT COMMENT 'Deskripsi',
    template_path VARCHAR(255) COMMENT 'Path template',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_priority (priority),
    INDEX idx_is_active (is_active)
);

-- Master Communication Channels
CREATE TABLE IF NOT EXISTS master_communication_channels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode channel',
    name VARCHAR(50) NOT NULL COMMENT 'Nama channel',
    type ENUM('email', 'sms', 'whatsapp', 'push', 'in_app', 'phone_call', 'mail', 'other') NOT NULL,
    description TEXT COMMENT 'Deskripsi',
    provider VARCHAR(100) COMMENT 'Provider',
    cost_per_unit DECIMAL(10,4) DEFAULT 0 COMMENT 'Biaya per unit',
    max_length INT COMMENT 'Maksimal karakter',
    supports_attachments BOOLEAN DEFAULT FALSE COMMENT 'Mendukung lampiran',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_type (type),
    INDEX idx_is_active (is_active)
);

-- Master Status Types
CREATE TABLE IF NOT EXISTS master_status_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode status',
    name VARCHAR(50) NOT NULL COMMENT 'Nama status',
    category ENUM('user', 'member', 'loan', 'savings', 'document', 'transaction', 'other') NOT NULL,
    color_code VARCHAR(10) COMMENT 'Kode warna',
    description TEXT COMMENT 'Deskripsi',
    next_statuses JSON COMMENT 'Status berikutnya yang mungkin',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_is_active (is_active)
);

-- ================================================================
-- 5. MASTER DATA FOR GEOGRAPHIC (NON-ADDRESS)
-- ================================================================

-- Master Countries
CREATE TABLE IF NOT EXISTS master_countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(3) UNIQUE NOT NULL COMMENT 'Kode negara (ISO 3166-1 alpha-3)',
    name VARCHAR(100) NOT NULL COMMENT 'Nama negara',
    name_local VARCHAR(100) COMMENT 'Nama lokal',
    continent VARCHAR(50) COMMENT 'Benua',
    capital VARCHAR(100) COMMENT 'Ibukota',
    currency_code VARCHAR(3) COMMENT 'Kode mata uang',
    phone_code VARCHAR(10) COMMENT 'Kode telepon',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_continent (continent),
    INDEX idx_is_active (is_active)
);

-- Master Provinces (Indonesia Only - Complement to schema_address)
CREATE TABLE IF NOT EXISTS master_provinces (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(10) UNIQUE NOT NULL COMMENT 'Kode provinsi',
    name VARCHAR(100) NOT NULL COMMENT 'Nama provinsi',
    country_code VARCHAR(3) DEFAULT 'IDN' COMMENT 'Kode negara',
    capital VARCHAR(100) COMMENT 'Ibukota provinsi',
    area_km2 DECIMAL(10,2) COMMENT 'Luas (km²)',
    population INT COMMENT 'Jumlah penduduk',
    density_per_km2 DECIMAL(8,2) COMMENT 'Kepaduan per km²',
    gdp_trillion DECIMAL(10,2) COMMENT 'GDP (triliun)',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_country_code (country_code),
    INDEX idx_is_active (is_active)
);

-- ================================================================
-- 6. MASTER DATA FOR SYSTEM CONFIGURATION
-- ================================================================

-- Master System Settings Categories
CREATE TABLE IF NOT EXISTS master_setting_categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode kategori',
    name VARCHAR(100) NOT NULL COMMENT 'Nama kategori',
    description TEXT COMMENT 'Deskripsi',
    parent_category_id INT COMMENT 'Kategori induk',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (parent_category_id) REFERENCES master_setting_categories(id),
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_parent_category (parent_category_id),
    INDEX idx_is_active (is_active)
);

-- Master User Roles
CREATE TABLE IF NOT EXISTS master_user_roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode role',
    name VARCHAR(50) NOT NULL COMMENT 'Nama role',
    display_name VARCHAR(100) COMMENT 'Nama tampilan',
    level INT NOT NULL COMMENT 'Level role (1=highest)',
    description TEXT COMMENT 'Deskripsi',
    permissions JSON COMMENT 'Hak akses',
    is_system_role BOOLEAN DEFAULT FALSE COMMENT 'Role sistem',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_level (level),
    INDEX idx_is_system_role (is_system_role),
    INDEX idx_is_active (is_active)
);

-- Master Device Types
CREATE TABLE IF NOT EXISTS master_device_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode device',
    name VARCHAR(50) NOT NULL COMMENT 'Nama device',
    category ENUM('mobile', 'tablet', 'desktop', 'laptop', 'other') NOT NULL,
    os_name VARCHAR(50) COMMENT 'Nama OS',
    browser_name VARCHAR(50) COMMENT 'Nama browser',
    description TEXT COMMENT 'Deskripsi',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_category (category),
    INDEX idx_os_name (os_name),
    INDEX idx_browser_name (browser_name),
    INDEX idx_is_active (is_active)
);

-- ================================================================
-- 7. SAMPLE DATA FOR MASTER TABLES
-- ================================================================

-- Sample Religions
INSERT INTO master_religions (code, name, description, is_active) VALUES
('ISL', 'Islam', 'Agama Islam', TRUE),
('KRT', 'Kristen', 'Agama Kristen Protestan', TRUE),
('KTH', 'Katolik', 'Agama Katolik', TRUE),
('HDN', 'Hindu', 'Agama Hindu', TRUE),
('BDH', 'Budha', 'Agama Budha', TRUE),
('KHC', 'Konghucu', 'Agama Konghucu', TRUE),
('LNN', 'Lainnya', 'Agama lainnya', TRUE),
('TDA', 'Tidak Ada', 'Tidak beragama', TRUE);

-- Sample Blood Types
INSERT INTO master_blood_types (code, name, rhesus_factor, description, is_active) VALUES
('A+', 'A Positif', '+', 'Golongan darah A positif', TRUE),
('A-', 'A Negatif', '-', 'Golongan darah A negatif', TRUE),
('B+', 'B Positif', '+', 'Golongan darah B positif', TRUE),
('B-', 'B Negatif', '-', 'Golongan darah B negatif', TRUE),
('AB+', 'AB Positif', '+', 'Golongan darah AB positif', TRUE),
('AB-', 'AB Negatif', '-', 'Golongan darah AB negatif', TRUE),
('O+', 'O Positif', '+', 'Golongan darah O positif', TRUE),
('O-', 'O Negatif', '-', 'Golongan darah O negatif', TRUE);

-- Sample Education Levels
INSERT INTO master_education_levels (code, name, level_order, description, is_active) VALUES
('TDS', 'Tidak Sekolah', 0, 'Tidak pernah sekolah', TRUE),
('TK', 'TK', 1, 'Taman Kanak-Kanak', TRUE),
('SD', 'SD', 2, 'Sekolah Dasar', TRUE),
('SMP', 'SMP', 3, 'Sekolah Menengah Pertama', TRUE),
('SMA', 'SMA', 4, 'Sekolah Menengah Atas', TRUE),
('SMK', 'SMK', 4, 'Sekolah Menengah Kejuruan', TRUE),
('MA', 'MA', 4, 'Madrasah Aliyah', TRUE),
('D1', 'D1', 5, 'Diploma 1', TRUE),
('D2', 'D2', 5, 'Diploma 2', TRUE),
('D3', 'D3', 5, 'Diploma 3', TRUE),
('D4', 'D4', 6, 'Diploma 4', TRUE),
('S1', 'S1', 6, 'Strata 1 (Sarjana)', TRUE),
('S2', 'S2', 7, 'Strata 2 (Magister)', TRUE),
('S3', 'S3', 8, 'Strata 3 (Doktor)', TRUE),
('PRS', 'Profesi', 6, 'Pendidikan Profesi', TRUE),
('LNN', 'Lainnya', 9, 'Pendidikan lainnya', TRUE);

-- Sample Occupations
INSERT INTO master_occupations (code, name, category, bps_code, description, income_level, is_active) VALUES
('PNS', 'Pegawai Negeri Sipil', 'Pemerintah', '1111', 'Pegawai pemerintah', 'medium', TRUE),
('TNI', 'Tentara Nasional Indonesia', 'Pemerintah', '1112', 'Angkatan bersenjata', 'medium', TRUE),
('POL', 'Polisi', 'Pemerintah', '1113', 'Kepolisian', 'medium', TRUE),
('GUR', 'Guru', 'Pendidikan', '2311', 'Tenaga pendidik', 'medium', TRUE),
('DSW', 'Dosen', 'Pendidikan', '2320', 'Tenaga pengajar perguruan tinggi', 'high', TRUE),
('DOK', 'Dokter', 'Kesehatan', '2211', 'Tenaga medis', 'high', TRUE),
('PRS', 'Perawat', 'Kesehatan', '2221', 'Tenaga kesehatan', 'medium', TRUE),
('ENG', 'Insinyur', 'Teknik', '3111', 'Tenaga teknik', 'high', TRUE),
('AKU', 'Akuntan', 'Keuangan', '4111', 'Tenaga akuntansi', 'high', TRUE),
('LAW', 'Pengacara', 'Hukum', '2411', 'Tenaga hukum', 'high', TRUE),
('WIR', 'Wiraswasta', 'Bisnis', '5111', 'Pengusaha', 'variable', TRUE),
('TRD', 'Pedagang', 'Bisnis', '5121', 'Pengguna jasa', 'variable', TRUE),
('PTR', 'Petani', 'Pertanian', '6111', 'Tenaga pertanian', 'low', TRUE),
('NLN', 'Nelayan', 'Perikanan', '6121', 'Tenaga perikanan', 'low', TRUE),
('BRH', 'Buruh', 'Industri', '7111', 'Tenaga industri', 'low', TRUE),
('PLJ', 'Pelajar', 'Pendidikan', '8111', 'Sedang belajar', 'none', TRUE),
('MHS', 'Mahasiswa', 'Pendidikan', '8121', 'Sedang kuliah', 'none', TRUE),
('PNS', 'Pensiunan', 'Lainnya', '9111', 'Sudah pensiun', 'medium', TRUE),
('TGL', 'Tidak Bekerja', 'Lainnya', '9999', 'Tidak memiliki pekerjaan', 'none', TRUE),
('LNN', 'Lainnya', 'Lainnya', '9998', 'Pekerjaan lainnya', 'variable', TRUE);

-- Sample Business Types
INSERT INTO master_business_types (code, name, category, description, risk_level, is_active) VALUES
('TRS', 'Toko', 'Retail', 'Toko kelontong/semako', 'low', TRUE),
('RSL', 'Restoran', 'Food & Beverage', 'Rumah makan/kafe', 'medium', TRUE),
('JAS', 'Jasa', 'Services', 'Berbagai jenis jasa', 'medium', TRUE),
('MNF', 'Manufaktur', 'Industri', 'Produksi barang', 'high', TRUE),
('TEK', 'Teknologi', 'Technology', 'IT dan teknologi', 'medium', TRUE),
('PTR', 'Pertanian', 'Agrikultur', 'Usaha pertanian', 'medium', TRUE),
('TRD', 'Perdagangan', 'Trade', 'Distributor/grosir', 'medium', TRUE),
('TRP', 'Transportasi', 'Transportation', 'Jasa transportasi', 'high', TRUE),
('KSH', 'Kesehatan', 'Healthcare', 'Fasilitas kesehatan', 'medium', TRUE),
('PND', 'Pendidikan', 'Education', 'Lembaga pendidikan', 'low', TRUE),
('LNN', 'Lainnya', 'Other', 'Jenis usaha lainnya', 'variable', TRUE);

-- Sample Document Types
INSERT INTO master_document_types (code, name, category, description, is_required, expiry_required, file_types_allowed, is_active) VALUES
('KTP', 'KTP', 'identity', 'Kartu Tanda Penduduk', TRUE, TRUE, 'JPG,JPEG,PNG,PDF', TRUE),
('KK', 'Kartu Keluarga', 'identity', 'Kartu Keluarga', TRUE, TRUE, 'JPG,JPEG,PNG,PDF', TRUE),
('AKL', 'Akta Kelahiran', 'legal', 'Akta Kelahiran', FALSE, FALSE, 'JPG,JPEG,PNG,PDF', TRUE),
('AKP', 'Akta Perkawinan', 'legal', 'Akta Perkawinan', FALSE, FALSE, 'JPG,JPEG,PNG,PDF', TRUE),
('AKC', 'Akta Cerai', 'legal', 'Akta Perceraian', FALSE, FALSE, 'JPG,JPEG,PNG,PDF', TRUE),
('NPWP', 'NPWP', 'financial', 'Nomor Pokok Wajib Pajak', FALSE, FALSE, 'JPG,JPEG,PNG,PDF', TRUE),
('BPK', 'BPJS Kesehatan', 'financial', 'Kartu BPJS Kesehatan', FALSE, TRUE, 'JPG,JPEG,PNG,PDF', TRUE),
('BPT', 'BPJS Ketenagakerjaan', 'financial', 'Kartu BPJS Ketenagakerjaan', FALSE, TRUE, 'JPG,JPEG,PNG,PDF', TRUE),
('SIM', 'SIM', 'identity', 'Surat Izin Mengemudi', FALSE, TRUE, 'JPG,JPEG,PNG,PDF', TRUE),
('PSP', 'Paspor', 'identity', 'Paspor', FALSE, TRUE, 'JPG,JPEG,PNG,PDF', TRUE),
('IJZ', 'Ijazah', 'education', 'Ijazah pendidikan', FALSE, FALSE, 'JPG,JPEG,PNG,PDF', TRUE),
('SRT', 'Surat Referensi', 'business', 'Surat referensi kerja/usaha', FALSE, FALSE, 'PDF,DOC,DOCX', TRUE),
('LNN', 'Lainnya', 'other', 'Dokumen lainnya', FALSE, FALSE, 'PDF,DOC,DOCX,JPG,JPEG,PNG', TRUE);

-- Sample Banks
INSERT INTO master_banks (code, name, short_name, bank_type, bic_code, headquarters, website, phone, email, description, is_active) VALUES
('014', 'Bank Central Asia', 'BCA', 'private', 'CENAIDJA', 'Jakarta', 'https://www.bca.co.id', '1500888', 'halo@bca.co.id', 'Bank swasta terbesar di Indonesia', TRUE),
('008', 'Bank Mandiri', 'Mandiri', 'government', 'BDRIIDJA', 'Jakarta', 'https://www.bankmandiri.co.id', '14000', 'mandiri@bankmandiri.co.id', 'Bank milik pemerintah', TRUE),
('002', 'Bank Rakyat Indonesia', 'BRI', 'government', 'BRINIDJA', 'Jakarta', 'https://www.bri.co.id', '1500176', 'halo@bri.co.id', 'Bank untuk UMKM', TRUE),
('009', 'Bank Negara Indonesia', 'BNI', 'government', 'BNINIDJA', 'Jakarta', 'https://www.bni.co.id', '1500646', 'bni@bni.co.id', 'Bank BUMN pertama', TRUE),
('011', 'Danamon', 'Danamon', 'private', 'DANAINID', 'Jakarta', 'https://www.danamon.co.id', '1500688', 'cs@danamon.co.id', 'Bank swasta', TRUE),
('019', 'Bank Panin', 'Panin', 'private', 'PANINIDJA', 'Jakarta', 'https://www.panin.co.id', '1500788', 'info@panin.co.id', 'Bank swasta', TRUE),
('022', 'CIMB Niaga', 'CIMB', 'private', 'BIBAIDJA', 'Jakarta', 'https://www.cimbniaga.co.id', '1500800', 'cimbniaga@cimbniaga.co.id', 'Bank CIMB Group', TRUE),
('031', 'Bank Permata', 'Permata', 'private', 'BBBAIDJA', 'Jakarta', 'https://www.permatabank.co.id', '1500111', 'info@permatabank.co.id', 'Bank Permata', TRUE),
('213', 'Bank Syariah Mandiri', 'BSM', 'syariah', 'BSMDIDJA', 'Jakarta', 'https://www.syariahmandiri.co.id', '1500155', 'bsm@syariahmandiri.co.id', 'Bank syariah', TRUE),
('425', 'Bank BJB', 'BJB', 'government', 'BJBAIDJA', 'Bandung', 'https://www.bankbjb.co.id', '1500667', 'bjb@bankbjb.co.id', 'Bank BPD Jawa Barat', TRUE);

-- Sample Currencies
INSERT INTO master_currencies (code, name, symbol, decimal_places, is_active) VALUES
('IDR', 'Indonesian Rupiah', 'Rp', 0, TRUE),
('USD', 'United States Dollar', '$', 2, TRUE),
('EUR', 'Euro', '€', 2, TRUE),
('JPY', 'Japanese Yen', '¥', 0, TRUE),
('GBP', 'British Pound', '£', 2, TRUE),
('AUD', 'Australian Dollar', 'A$', 2, TRUE),
('SGD', 'Singapore Dollar', 'S$', 2, TRUE),
('MYR', 'Malaysian Ringgit', 'RM', 2, TRUE),
('CNY', 'Chinese Yuan', '¥', 2, TRUE),
('THB', 'Thai Baht', '฿', 2, TRUE);

-- Sample Payment Methods
INSERT INTO master_payment_methods (code, name, category, description, processing_fee_rate, min_amount, max_amount, is_active) VALUES
('CASH', 'Tunai', 'cash', 'Pembayaran tunai', 0, 0, 999999999, TRUE),
('TRF', 'Transfer Bank', 'bank_transfer', 'Transfer antar bank', 0.0050, 10000, 999999999, TRUE),
('OVO', 'OVO', 'digital_wallet', 'Dompet digital OVO', 0.0100, 1000, 5000000, TRUE),
('GPA', 'GoPay', 'digital_wallet', 'Dompet digital GoPay', 0.0100, 1000, 5000000, TRUE),
('DNA', 'DANA', 'digital_wallet', 'Dompet digital DANA', 0.0100, 1000, 5000000, TRUE),
('SHO', 'ShopeePay', 'digital_wallet', 'Dompet digital ShopeePay', 0.0100, 1000, 5000000, TRUE),
('ATM', 'ATM Transfer', 'bank_transfer', 'Transfer via ATM', 0.0075, 10000, 999999999, TRUE),
('MBK', 'Mobile Banking', 'bank_transfer', 'Transfer via mobile banking', 0.0050, 10000, 999999999, TRUE),
('IBK', 'Internet Banking', 'bank_transfer', 'Transfer via internet banking', 0.0050, 10000, 999999999, TRUE),
('CHQ', 'Cek', 'check', 'Pembayaran dengan cek', 0.0150, 100000, 999999999, TRUE),
('GIR', 'Bilyet Giro', 'check', 'Pembayaran dengan bilyet giro', 0.0100, 100000, 999999999, TRUE),
('ADB', 'Auto Debit', 'auto_debit', 'Potongan otomatis', 0.0050, 10000, 999999999, TRUE);

-- Sample Fee Types
INSERT INTO master_fee_types (code, name, category, calculation_method, default_rate, default_amount, description, is_taxable, is_active) VALUES
('ADM', 'Biaya Administrasi', 'admin', 'percentage', 0.0200, 0, 'Biaya administrasi umum', FALSE, TRUE),
('PRO', 'Biaya Proses', 'processing', 'percentage', 0.0100, 0, 'Biaya pemrosesan aplikasi', FALSE, TRUE),
('LTF', 'Denda Keterlambatan', 'late', 'percentage', 0.0100, 0, 'Denda untuk keterlambatan pembayaran', FALSE, TRUE),
('EPF', 'Biaya Pelunasan Dini', 'early_payment', 'percentage', 0.0200, 0, 'Biaya untuk pelunasan sebelum jatuh tempo', FALSE, TRUE),
('SRV', 'Biaya Layanan', 'service', 'fixed', 0, 10000, 'Biaya layanan tambahan', FALSE, TRUE),
('PEN', 'Biaya Penalti', 'penalty', 'fixed', 0, 50000, 'Biaya penalti', FALSE, TRUE),
('INS', 'Biaya Asuransi', 'admin', 'percentage', 0.0050, 0, 'Biaya asuransi pinjaman', FALSE, TRUE),
('LGL', 'Biaya Legal', 'processing', 'fixed', 0, 250000, 'Biaya legalitas', FALSE, TRUE),
('NOT', 'Biaya Notaris', 'processing', 'fixed', 0, 150000, 'Biaya notaris', FALSE, TRUE),
('SUR', 'Biaya Survei', 'processing', 'fixed', 0, 100000, 'Biaya survei lokasi', FALSE, TRUE),
('OTH', 'Lainnya', 'other', 'fixed', 0, 0, 'Biaya lainnya', FALSE, TRUE);

-- Sample ID Types
INSERT INTO master_id_types (code, name, category, issuing_authority, format_pattern, length_min, length_max, has_expiry, description, is_active) VALUES
('NIK', 'Nomor Induk Kependudukan', 'government', 'Dinas Kependudukan', '^[0-9]{16}$', 16, 16, TRUE, 'NIK 16 digit', TRUE),
('KK', 'Kartu Keluarga', 'government', 'Dinas Kependudukan', '^[0-9]{16}$', 16, 16, TRUE, 'Nomor KK 16 digit', TRUE),
('NPWP', 'Nomor Pokok Wajib Pajak', 'government', 'Direktorat Jenderal Pajak', '^[0-9]{15}$', 15, 15, FALSE, 'NPWP 15 digit', TRUE),
('SIM', 'Surat Izin Mengemudi', 'government', 'Polisi', '^[0-9]{8,12}$', 8, 12, TRUE, 'SIM 8-12 digit', TRUE),
('PSP', 'Paspor', 'government', 'Imigrasi', '^[A-Z]{2}[0-9]{7}$', 9, 9, TRUE, 'Paspor Indonesia', TRUE),
('BPK', 'BPJS Kesehatan', 'government', 'BPJS', '^[0-9]{13}$', 13, 13, FALSE, 'BPJS Kesehatan 13 digit', TRUE),
('BPT', 'BPJS Ketenagakerjaan', 'government', 'BPJS', '^[0-9]{11}$', 11, 11, FALSE, 'BPJS Ketenagakerjaan 11 digit', TRUE),
('STR', 'Surat Tanda Registrasi', 'professional', 'Profesi', '^[0-9]{8,12}$', 8, 12, TRUE, 'STR tenaga kesehatan', TRUE),
('SIU', 'Surat Izin Usaha', 'business', 'Dinas Perizinan', '^[0-9]{8,16}$', 8, 16, TRUE, 'SIU untuk usaha', TRUE),
('NPWP', 'NPWP Perusahaan', 'business', 'DJP', '^[0-9]{15}$', 15, 15, FALSE, 'NPWP perusahaan', TRUE),
('LNN', 'Lainnya', 'other', 'Various', '^[A-Z0-9]{5,20}$', 5, 20, FALSE, 'Identitas lainnya', TRUE);

-- Sample Relationship Types
INSERT INTO master_relationship_types (code, name, category, relationship_level, description, is_active) VALUES
('AYH', 'Ayah', 'family', '1', 'Ayah kandung', TRUE),
('IBU', 'Ibu', 'family', '1', 'Ibu kandung', TRUE),
('ANK', 'Anak', 'family', '1', 'Anak kandung', TRUE),
('SUH', 'Suami', 'family', '1', 'Suami', TRUE),
('IST', 'Istri', 'family', '1', 'Istri', TRUE),
('KAK', 'Kakak', 'family', '2', 'Kakak kandung', TRUE),
('ADE', 'Adik', 'family', '2', 'Adik kandung', TRUE),
('KKE', 'Kakek', 'family', '2', 'Kakek', TRUE),
('NEN', 'Nenek', 'family', '2', 'Nenek', TRUE),
('CUC', 'Cucu', 'family', '3', 'Cucu', TRUE),
('PAM', 'Paman', 'family', '2', 'Paman (bapak dari ayah/ibu)', TRUE),
('BIB', 'Bibi', 'family', '2', 'Bibi (bapak dari ayah/ibu)', TRUE),
('KEP', 'Keponakan', 'family', '3', 'Keponakan', TRUE),
('SEP', 'Sepupu', 'family', '3', 'Sepupu', TRUE),
('MRT', 'Mertua', 'family', '1', 'Mertua (orang tua pasangan)', TRUE),
('MNT', 'Menantu', 'family', '1', 'Menantu (pasangan anak)', TRUE),
('IPR', 'Ipar', 'family', '2', 'Ipar (suami/istri saudara)', TRUE),
('SAH', 'Sahabat', 'other', '4', 'Teman dekat', TRUE),
('RFR', 'Referensi', 'business', '4', 'Referensi bisnis', TRUE),
('LNN', 'Lainnya', 'other', '5', 'Hubungan lainnya', TRUE);

-- Sample Risk Levels
INSERT INTO master_risk_levels (code, name, score_min, score_max, color_code, description, action_required, is_active) VALUES
('VHI', 'Sangat Tinggi', 0, 20, '#FF0000', 'Risiko sangat tinggi, perhatian khusus', 'Tindakan mitigasi segera, monitoring intensif', TRUE),
('HGH', 'Tinggi', 21, 40, '#FF8C00', 'Risiko tinggi, perlu monitoring', 'Monitoring rutin, batasan kredit', TRUE),
('MED', 'Sedang', 41, 60, '#FFD700', 'Risiko sedang, monitoring normal', 'Monitoring standar', TRUE),
('LOW', 'Rendah', 61, 80, '#90EE90', 'Risiko rendah, proses normal', 'Proses normal', TRUE),
('VLO', 'Sangat Rendah', 81, 100, '#008000', 'Risiko sangat rendah, proses cepat', 'Proses prioritas', TRUE);

-- Sample Compliance Statuses
INSERT INTO master_compliance_statuses (code, name, category, description, next_step, is_active) VALUES
('PND', 'Pending', 'kyc', 'Menunggu verifikasi', 'Lengkapi dokumen', TRUE),
('VER', 'Verified', 'kyc', 'Terverifikasi', 'Tidak ada', TRUE),
('REJ', 'Rejected', 'kyc', 'Ditolak', 'Ajukan ulang dengan dokumen lengkap', TRUE),
('EXP', 'Expired', 'kyc', 'Kadaluarsa', 'Perbarui dokumen', TRUE),
('CLR', 'Cleared', 'aml', 'Bersih', 'Tidak ada', TRUE),
('SPC', 'Suspicious', 'aml', 'Mencurigakan', 'Investigasi lanjutan', TRUE),
('BLK', 'Blocked', 'aml', 'Diblokir', 'Hubungi compliance', TRUE),
('APP', 'Approved', 'audit', 'Disetujui', 'Tidak ada', TRUE),
('REV', 'Review', 'audit', 'Direview', 'Tunggu hasil review', TRUE),
('CMP', 'Complete', 'legal', 'Lengkap', 'Tidak ada', TRUE),
('INC', 'Incomplete', 'legal', 'Tidak lengkap', 'Lengkapi dokumen', TRUE);

-- Sample Transaction Types
INSERT INTO master_transaction_types (code, name, category, direction, description, affects_balance, requires_approval, is_active) VALUES
('LDI', 'Pencairan Pinjaman', 'loan', 'out', 'Pencairan dana pinjaman', TRUE, TRUE, TRUE),
('LPY', 'Pembayaran Pinjaman', 'loan', 'in', 'Pembayaran angsuran pinjaman', TRUE, FALSE, TRUE),
('SDP', 'Setoran Simpanan', 'savings', 'in', 'Setoran ke rekening simpanan', TRUE, FALSE, TRUE),
('SWD', 'Penarikan Simpanan', 'savings', 'out', 'Penarikan dari rekening simpanan', TRUE, TRUE, TRUE),
('FAD', 'Biaya Admin', 'fee', 'out', 'Pembayaran biaya administrasi', TRUE, FALSE, TRUE),
('FPR', 'Biaya Proses', 'fee', 'out', 'Pembayaran biaya proses', TRUE, FALSE, TRUE),
('FLT', 'Denda Keterlambatan', 'fee', 'in', 'Penerimaan denda keterlambatan', TRUE, FALSE, TRUE),
('TRF', 'Transfer', 'transfer', 'neutral', 'Transfer antar rekening', FALSE, FALSE, TRUE),
('ADJ', 'Penyesuaian', 'adjustment', 'neutral', 'Penyesuaian saldo', TRUE, TRUE, TRUE),
('REV', 'Pembatalan', 'adjustment', 'neutral', 'Pembatalan transaksi', TRUE, TRUE, TRUE),
('OTH', 'Lainnya', 'other', 'neutral', 'Transaksi lainnya', FALSE, FALSE, TRUE);

-- Sample Notification Types
INSERT INTO master_notification_types (code, name, category, priority, description, is_active) VALUES
('INF', 'Informasi Umum', 'info', 'low', 'Informasi umum kepada user', TRUE),
('WRN', 'Peringatan', 'warning', 'medium', 'Peringatan penting', TRUE),
('ERR', 'Error', 'error', 'high', 'Notifikasi error sistem', TRUE),
('SUC', 'Sukses', 'success', 'medium', 'Notifikasi sukses operasi', TRUE),
('REM', 'Pengingat', 'reminder', 'medium', 'Pengingat jadwal', TRUE),
('ALT', 'Alert', 'alert', 'high', 'Alert penting', TRUE),
('PRM', 'Promosi', 'promotion', 'low', 'Promosi produk', TRUE),
('SYS', 'Sistem', 'system', 'medium', 'Notifikasi sistem', TRUE);

-- Sample Communication Channels
INSERT INTO master_communication_channels (code, name, type, description, provider, cost_per_unit, max_length, supports_attachments, is_active) VALUES
('EML', 'Email', 'email', 'Kirim email notifikasi', 'SMTP', 0, 0, TRUE, TRUE),
('SMS', 'SMS', 'sms', 'Kirim SMS notifikasi', 'WhatsApp Gateway', 0.0500, 160, FALSE, TRUE),
('WAP', 'WhatsApp', 'whatsapp', 'Kirim WhatsApp notifikasi', 'WhatsApp Business API', 0.0300, 4096, TRUE, TRUE),
('PUSH', 'Push Notification', 'push', 'Push notification ke mobile', 'Firebase', 0, 1000, FALSE, TRUE),
('APP', 'In-App', 'in_app', 'Notifikasi dalam aplikasi', 'Internal', 0, 500, TRUE, TRUE),
('TEL', 'Telepon', 'phone_call', 'Panggilan telepon', 'Telecom Provider', 0.1000, 0, FALSE, TRUE),
('ML', 'Surat Pos', 'mail', 'Kirim surat pos', 'Pos Indonesia', 0.5000, 0, TRUE, TRUE),
('OTH', 'Lainnya', 'other', 'Channel komunikasi lainnya', 'Various', 0, 0, FALSE, TRUE);

-- Sample Status Types
INSERT INTO master_status_types (code, name, category, color_code, description, next_statuses, is_active) VALUES
('ACT', 'Aktif', 'user', '#28a745', 'User aktif', '["INA", "SUS"]', TRUE),
('INA', 'Tidak Aktif', 'user', '#dc3545', 'User tidak aktif', '["ACT"]', TRUE),
('SUS', 'Ditangguhkan', 'user', '#ffc107', 'User ditangguhkan', '["ACT", "INA"]', TRUE),
('PND', 'Pending', 'member', '#ffc107', 'Member menunggu verifikasi', '["ACT", "REJ"]', TRUE),
('VER', 'Verified', 'member', '#28a745', 'Member terverifikasi', '["ACT", "SUS", "BLK"]', TRUE),
('REJ', 'Ditolak', 'member', '#dc3545', 'Member ditolak', '["PND"]', TRUE),
('BLK', 'Blacklist', 'member', '#000000', 'Member di-blacklist', '["VER"]', TRUE),
('DFT', 'Draft', 'loan', '#6c757d', 'Pinjaman draft', '["SUB", "CAN"]', TRUE),
('SUB', 'Submitted', 'loan', '#17a2b8', 'Pinjaman diajukan', '["APP", "REJ", "CAN"]', TRUE),
('APP', 'Approved', 'loan', '#28a745', 'Pinjaman disetujui', '["DIS", "CAN"]', TRUE),
('DIS', 'Disbursed', 'loan', '#007bff', 'Pinjaman dicairkan', '["ACT", "LAT"]', TRUE),
('ACT', 'Active', 'loan', '#28a745', 'Pinjaman aktif', '["COM", "LAT", "DEF"]', TRUE),
('LAT', 'Late', 'loan', '#ffc107', 'Pinjaman terlambat', '["ACT", "DEF"]', TRUE),
('DEF', 'Default', 'loan', '#dc3545', 'Pinjaman gagal bayar', '["COM"]', TRUE),
('COM', 'Completed', 'loan', '#28a745', 'Pinjaman lunas', '[""]', TRUE),
('CAN', 'Cancelled', 'loan', '#dc3545', 'Pinjaman dibatalkan', '[""]', TRUE);

-- Sample Countries
INSERT INTO master_countries (code, name, name_local, continent, capital, currency_code, phone_code, is_active) VALUES
('IDN', 'Indonesia', 'Indonesia', 'Asia', 'Jakarta', 'IDR', '+62', TRUE),
('MYS', 'Malaysia', 'Malaysia', 'Asia', 'Kuala Lumpur', 'MYR', '+60', TRUE),
('SGP', 'Singapore', 'Singapura', 'Asia', 'Singapore', 'SGD', '+65', TRUE),
('THA', 'Thailand', 'Thailand', 'Asia', 'Bangkok', 'THB', '+66', TRUE),
('PHL', 'Philippines', 'Pilipinas', 'Asia', 'Manila', 'PHP', '+63', TRUE),
('VNM', 'Vietnam', 'Việt Nam', 'Asia', 'Hanoi', 'VND', '+84', TRUE),
('MMR', 'Myanmar', 'Myanmar', 'Asia', 'Naypyidaw', 'MMK', '+95', TRUE),
('KHM', 'Cambodia', 'Kâmpŭchea', 'Asia', 'Phnom Penh', 'KHR', '+855', TRUE),
('LAO', 'Laos', 'Sathalanalat Paxathipathai Paxaxon Lao', 'Asia', 'Vientiane', 'LAK', '+856', TRUE),
('BRN', 'Brunei', 'Brunei Darussalam', 'Asia', 'Bandar Seri Begawan', 'BND', '+673', TRUE),
('USA', 'United States', 'United States', 'North America', 'Washington D.C.', 'USD', '+1', TRUE),
('GBR', 'United Kingdom', 'United Kingdom', 'Europe', 'London', 'GBP', '+44', TRUE),
('AUS', 'Australia', 'Australia', 'Oceania', 'Canberra', 'AUD', '+61', TRUE),
('JPN', 'Japan', '日本', 'Asia', 'Tokyo', 'JPY', '+81', TRUE),
('CHN', 'China', '中国', 'Asia', 'Beijing', 'CNY', '+86', TRUE),
('IND', 'India', 'भारत', 'Asia', 'New Delhi', 'INR', '+91', TRUE);

-- Sample User Roles
INSERT INTO master_user_roles (code, name, display_name, level, description, permissions, is_system_role, is_active) VALUES
('SADM', 'super_admin', 'Super Administrator', 1, 'Administrator sistem dengan akses penuh', '["all"]', TRUE, TRUE),
('ADM', 'admin', 'Administrator', 2, 'Administrator dengan akses luas', '["users", "members", "products", "reports"]', TRUE, TRUE),
('UHD', 'unit_head', 'Kepala Unit', 3, 'Kepala unit organisasi', '["unit_management", "staff_management", "reports"]', FALSE, TRUE),
('BHD', 'branch_head', 'Kepala Cabang', 4, 'Kepala cabang koperasi', '["branch_management", "member_management", "loan_approval", "reports"]', FALSE, TRUE),
('SUP', 'supervisor', 'Supervisor', 5, 'Supervisor operasional', '["staff_supervision", "collection_supervision", "reports"]', FALSE, TRUE),
('COL', 'collector', 'Kolektor', 6, 'Kolektor lapangan', '["collection", "member_visit", "mobile_access"]', FALSE, TRUE),
('CSH', 'cashier', 'Kasir', 6, 'Kasir koperasi', '["cash_management", "savings_transactions", "loan_payments"]', FALSE, TRUE),
('MBR', 'member', 'Anggota', 7, 'Anggota koperasi', '["self_service", "view_own_data", "apply_loan"]', FALSE, TRUE),
('GST', 'guest', 'Tamu', 8, 'Pengguna tamu dengan akses terbatas', '["view_public_info"]', TRUE, TRUE);

-- Sample Device Types
INSERT INTO master_device_types (code, name, category, os_name, browser_name, description, is_active) VALUES
('MAD', 'Mobile Android', 'mobile', 'Android', 'Chrome', 'Perangkat mobile dengan OS Android', TRUE),
('MIO', 'Mobile iOS', 'mobile', 'iOS', 'Safari', 'Perangkat mobile dengan OS iOS', TRUE),
('TAD', 'Tablet Android', 'tablet', 'Android', 'Chrome', 'Tablet dengan OS Android', TRUE),
('TIO', 'Tablet iOS', 'tablet', 'iOS', 'Safari', 'Tablet dengan OS iOS', TRUE),
('DWD', 'Desktop Windows', 'desktop', 'Windows', 'Chrome', 'Desktop dengan OS Windows', TRUE),
('DMC', 'Desktop Mac', 'desktop', 'macOS', 'Safari', 'Desktop dengan OS macOS', TRUE),
('DLN', 'Desktop Linux', 'desktop', 'Linux', 'Firefox', 'Desktop dengan OS Linux', TRUE),
('LWD', 'Laptop Windows', 'laptop', 'Windows', 'Chrome', 'Laptop dengan OS Windows', TRUE),
('LMC', 'Laptop Mac', 'laptop', 'macOS', 'Safari', 'Laptop dengan OS macOS', TRUE),
('LLN', 'Laptop Linux', 'laptop', 'Linux', 'Firefox', 'Laptop dengan OS Linux', TRUE),
('OTH', 'Lainnya', 'other', 'Other', 'Other', 'Perangkat lainnya', TRUE);

-- ================================================================
-- SETUP COMPLETE
-- ================================================================

SELECT 'Master tables setup completed successfully!' as status;

-- Show summary
SELECT 'Personal Information Masters' as category, COUNT(*) as count FROM information_schema.tables 
WHERE table_schema = 'schema_app' AND table_name LIKE 'master_%' AND table_name IN ('master_religions', 'master_blood_types', 'master_education_levels', 'master_occupations', 'master_business_types', 'master_document_types')
UNION ALL
SELECT 'Financial Operations Masters', COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'schema_app' AND table_name LIKE 'master_%' AND table_name IN ('master_banks', 'master_currencies', 'master_payment_methods', 'master_fee_types')
UNION ALL
SELECT 'Compliance & Legal Masters', COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'schema_app' AND table_name LIKE 'master_%' AND table_name IN ('master_id_types', 'master_relationship_types', 'master_risk_levels', 'master_compliance_statuses')
UNION ALL
SELECT 'Operations Masters', COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'schema_app' AND table_name LIKE 'master_%' AND table_name IN ('master_transaction_types', 'master_notification_types', 'master_communication_channels', 'master_status_types')
UNION ALL
SELECT 'Geographic Masters', COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'schema_app' AND table_name LIKE 'master_%' AND table_name IN ('master_countries', 'master_provinces')
UNION ALL
SELECT 'System Configuration Masters', COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'schema_app' AND table_name LIKE 'master_%' AND table_name IN ('master_setting_categories', 'master_user_roles', 'master_device_types');

-- Show sample data counts
SELECT 'Sample Data Summary' as info;
SELECT 'Religions', COUNT(*) as count FROM master_religions
UNION ALL
SELECT 'Blood Types', COUNT(*) FROM master_blood_types
UNION ALL
SELECT 'Education Levels', COUNT(*) FROM master_education_levels
UNION ALL
SELECT 'Occupations', COUNT(*) FROM master_occupations
UNION ALL
SELECT 'Business Types', COUNT(*) FROM master_business_types
UNION ALL
SELECT 'Document Types', COUNT(*) FROM master_document_types
UNION ALL
SELECT 'Banks', COUNT(*) FROM master_banks
UNION ALL
SELECT 'Payment Methods', COUNT(*) FROM master_payment_methods
UNION ALL
SELECT 'User Roles', COUNT(*) FROM master_user_roles;
