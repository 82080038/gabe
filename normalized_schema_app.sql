# ================================================================
# NORMALIZED SCHEMA_APP FOR KOPERASI BERJALAN
# API/Middleware Ready
# Complete Business Logic
# Full Integration with schema_person & schema_address
# ================================================================

USE schema_app;

# ================================================================
# 1. ORGANIZATION STRUCTURE
# ================================================================
-- ================================================================

-- Units Table (Organizational Units)
CREATE TABLE IF NOT EXISTS units (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT 'Nama unit organisasi',
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode unit',
    description TEXT COMMENT 'Deskripsi unit',
    unit_type ENUM('pusat', 'cabang', 'unit', 'divisi', 'departemen') DEFAULT 'unit',
    parent_unit_id INT COMMENT 'Unit induk (hierarki)',
    head_user_id INT COMMENT 'Kepala unit',
    contact_person VARCHAR(100) COMMENT 'Person kontak',
    contact_phone VARCHAR(15) COMMENT 'Telepon kontak',
    contact_email VARCHAR(100) COMMENT 'Email kontak',
    address_id INT COMMENT 'ID alamat (schema_address)',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (parent_unit_id) REFERENCES units(id),
    FOREIGN KEY (head_user_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_code (code),
    INDEX idx_unit_type (unit_type),
    INDEX idx_parent_unit (parent_unit_id),
    INDEX idx_head_user (head_user_id),
    INDEX idx_is_active (is_active)
);

-- Branches Table (Cabang Koperasi)
CREATE TABLE IF NOT EXISTS branches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    unit_id INT NOT NULL COMMENT 'Unit induk',
    name VARCHAR(100) NOT NULL COMMENT 'Nama cabang',
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode cabang',
    branch_type ENUM('pusat', 'cabang_utama', 'cabang', 'unit_pelayanan') DEFAULT 'cabang',
    head_user_id INT COMMENT 'Kepala cabang',
    manager_user_id INT COMMENT 'Manager cabang',
    address_id INT COMMENT 'ID alamat (schema_address)',
    phone VARCHAR(15) COMMENT 'Telepon cabang',
    phone2 VARCHAR(15) COMMENT 'Telepon cadangan',
    email VARCHAR(100) COMMENT 'Email cabang',
    website VARCHAR(100) COMMENT 'Website cabang',
    operational_area TEXT COMMENT 'Area operasional',
    service_hours VARCHAR(100) COMMENT 'Jam operasional',
    latitude DECIMAL(10,8) COMMENT 'Koordinat latitude',
    longitude DECIMAL(11,8) COMMENT 'Koordinat longitude',
    coverage_radius_km INT DEFAULT 5 COMMENT 'Radius cakupan (km)',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    opening_date DATE COMMENT 'Tanggal buka',
    closing_date DATE COMMENT 'Tanggal tutup (jika ada)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (unit_id) REFERENCES units(id),
    FOREIGN KEY (head_user_id) REFERENCES users(id),
    FOREIGN KEY (manager_user_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_unit (unit_id),
    INDEX idx_code (code),
    INDEX idx_branch_type (branch_type),
    INDEX idx_head_user (head_user_id),
    INDEX idx_manager_user (manager_user_id),
    INDEX idx_is_active (is_active),
    INDEX idx_opening_date (opening_date)
);

-- ================================================================
-- 2. USER MANAGEMENT
-- ================================================================

-- Users Table (System Users)
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL COMMENT 'Username login',
    password VARCHAR(255) NOT NULL COMMENT 'Password (hashed)',
    person_id INT NOT NULL COMMENT 'ID person (schema_person)',
    branch_id INT COMMENT 'ID cabang default',
    unit_id INT COMMENT 'ID unit default',
    role ENUM('super_admin', 'admin', 'unit_head', 'branch_head', 'supervisor', 'collector', 'cashier', 'member', 'guest') NOT NULL DEFAULT 'member',
    status ENUM('active', 'inactive', 'suspended', 'pending') DEFAULT 'active',
    login_attempts INT DEFAULT 0 COMMENT 'Jumlah percobaan login gagal',
    last_login TIMESTAMP NULL COMMENT 'Login terakhir',
    last_activity TIMESTAMP NULL COMMENT 'Aktivitas terakhir',
    session_id VARCHAR(100) COMMENT 'ID session aktif',
    api_token VARCHAR(255) COMMENT 'Token API',
    api_token_expiry TIMESTAMP NULL COMMENT 'Masa berlaku token API',
    two_factor_enabled BOOLEAN DEFAULT FALSE COMMENT '2FA aktif',
    two_factor_secret VARCHAR(32) COMMENT 'Secret 2FA',
    email_verified BOOLEAN DEFAULT FALSE COMMENT 'Email terverifikasi',
    phone_verified BOOLEAN DEFAULT FALSE COMMENT 'Telepon terverifikasi',
    must_change_password BOOLEAN DEFAULT FALSE COMMENT 'Harus ganti password',
    password_changed_at TIMESTAMP NULL COMMENT 'Password terakhir diubah',
    last_password_change TIMESTAMP NULL COMMENT 'Password terakhir diubah (legacy)',
    ip_restrictions TEXT COMMENT 'Batasan IP (JSON)',
    device_restrictions TEXT COMMENT 'Batasan device (JSON)',
    permissions JSON COMMENT 'Hak akses tambahan (JSON)',
    preferences JSON COMMENT 'Preferensi user (JSON)',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (person_id) REFERENCES schema_person.persons(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (unit_id) REFERENCES units(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_username (username),
    INDEX idx_person_id (person_id),
    INDEX idx_branch_id (branch_id),
    INDEX idx_unit_id (unit_id),
    INDEX idx_role (role),
    INDEX idx_status (status),
    INDEX idx_last_login (last_login),
    INDEX idx_api_token (api_token),
    INDEX idx_is_active (is_active)
);

-- User Sessions Table (Session Management)
CREATE TABLE IF NOT EXISTS user_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT 'ID user',
    session_id VARCHAR(100) UNIQUE NOT NULL COMMENT 'ID session',
    ip_address VARCHAR(45) COMMENT 'IP address',
    user_agent TEXT COMMENT 'User agent',
    device_info JSON COMMENT 'Info device (JSON)',
    location_info JSON COMMENT 'Info lokasi (JSON)',
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Waktu login',
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Aktivitas terakhir',
    expiry_time TIMESTAMP NOT NULL COMMENT 'Waktu expiry',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    logout_time TIMESTAMP NULL COMMENT 'Waktu logout',
    logout_reason VARCHAR(50) COMMENT 'Alasan logout',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX idx_user_id (user_id),
    INDEX idx_session_id (session_id),
    INDEX idx_ip_address (ip_address),
    INDEX idx_login_time (login_time),
    INDEX idx_expiry_time (expiry_time),
    INDEX idx_is_active (is_active)
);

-- ================================================================
-- 3. MEMBER MANAGEMENT
-- ================================================================

-- Members Table (Anggota Koperasi)
CREATE TABLE IF NOT EXISTS members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL UNIQUE COMMENT 'ID person (schema_person)',
    member_number VARCHAR(20) UNIQUE NOT NULL COMMENT 'Nomor anggota unik',
    branch_id INT NOT NULL COMMENT 'ID cabang',
    member_type ENUM('regular', 'premium', 'vip', 'corporate', 'student', 'senior') DEFAULT 'regular',
    membership_category ENUM('anggota_biasa', 'anggota_luar_biasa', 'anggota_kehormatan') DEFAULT 'anggota_biasa',
    join_date DATE NOT NULL COMMENT 'Tanggal bergabung',
    activation_date DATE COMMENT 'Tanggal aktivasi',
    status ENUM('pending', 'active', 'inactive', 'suspended', 'blacklisted', 'deceased') DEFAULT 'pending',
    status_reason TEXT COMMENT 'Alasan status',
    
    -- Loan Limits & Risk
    max_active_loans INT DEFAULT 2 COMMENT 'Maks pinjaman aktif',
    max_loan_amount DECIMAL(12,2) DEFAULT 10000000 COMMENT 'Maks jumlah pinjaman',
    max_loan_tenor_days INT DEFAULT 180 COMMENT 'Maks tenor (hari)',
    current_active_loans INT DEFAULT 0 COMMENT 'Pinjaman aktif saat ini',
    current_total_loans DECIMAL(12,2) DEFAULT 0 COMMENT 'Total pinjaman saat ini',
    current_late_count INT DEFAULT 0 COMMENT 'Jumlah tunggakan',
    current_late_days INT DEFAULT 0 COMMENT 'Hari tunggakan',
    current_npl_amount DECIMAL(12,2) DEFAULT 0 COMMENT 'Jumlah NPL',
    
    -- Savings Information
    mandatory_savings_amount DECIMAL(10,2) DEFAULT 0 COMMENT 'Simpanan wajib minimal',
    voluntary_savings_amount DECIMAL(10,2) DEFAULT 0 COMMENT 'Simpanan sukarela minimal',
    current_mandatory_savings DECIMAL(12,2) DEFAULT 0 COMMENT 'Simpanan wajib saat ini',
    current_voluntary_savings DECIMAL(12,2) DEFAULT 0 COMMENT 'Simpanan sukarela saat ini',
    total_savings DECIMAL(12,2) DEFAULT 0 COMMENT 'Total simpanan',
    
    -- Credit Information
    credit_score INT DEFAULT 0 COMMENT 'Skor kredit (0-100)',
    risk_level ENUM('low', 'medium', 'high', 'very_high') DEFAULT 'medium',
    credit_limit DECIMAL(12,2) DEFAULT 0 COMMENT 'Limit kredit',
    available_credit DECIMAL(12,2) DEFAULT 0 COMMENT 'Kredit tersedia',
    last_credit_assessment DATE COMMENT 'Terakhir penilaian kredit',
    
    -- Compliance & Verification
    kyc_status ENUM('pending', 'verified', 'rejected', 'expired') DEFAULT 'pending',
    kyc_verified_at TIMESTAMP NULL COMMENT 'KYC terverifikasi',
    kyc_verified_by INT COMMENT 'Diverifikasi oleh',
    aml_status ENUM('pending', 'cleared', 'suspicious', 'blocked') DEFAULT 'pending',
    aml_verified_at TIMESTAMP NULL COMMENT 'AML terverifikasi',
    aml_verified_by INT COMMENT 'Diverifikasi oleh',
    
    -- Preferences & Settings
    preferred_language VARCHAR(10) DEFAULT 'id' COMMENT 'Bahasa preferensi',
    preferred_contact ENUM('phone', 'whatsapp', 'email', 'sms') DEFAULT 'phone',
    notification_settings JSON COMMENT 'Pengaturan notifikasi',
    privacy_settings JSON COMMENT 'Pengaturan privasi',
    
    -- Metadata
    referral_source VARCHAR(100) COMMENT 'Sumber referensi',
    referral_member_id INT COMMENT 'ID member referensi',
    notes TEXT COMMENT 'Catatan tambahan',
    
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (person_id) REFERENCES schema_person.persons(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (referral_member_id) REFERENCES members(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    FOREIGN KEY (kyc_verified_by) REFERENCES users(id),
    FOREIGN KEY (aml_verified_by) REFERENCES users(id),
    
    INDEX idx_person_id (person_id),
    INDEX idx_member_number (member_number),
    INDEX idx_branch_id (branch_id),
    INDEX idx_member_type (member_type),
    INDEX idx_status (status),
    INDEX idx_credit_score (credit_score),
    INDEX idx_risk_level (risk_level),
    INDEX idx_kyc_status (kyc_status),
    INDEX idx_aml_status (aml_status),
    INDEX idx_join_date (join_date),
    INDEX idx_is_active (is_active)
);

-- Member Groups Table (Segmentasi Anggota)
CREATE TABLE IF NOT EXISTS member_groups (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT 'Nama grup',
    description TEXT COMMENT 'Deskripsi grup',
    group_type ENUM('demographic', 'geographic', 'behavioral', 'transactional', 'custom') DEFAULT 'custom',
    criteria JSON COMMENT 'Kriteria member (JSON)',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh',
    
    FOREIGN KEY (created_by) REFERENCES users(id),
    
    INDEX idx_group_type (group_type),
    INDEX idx_is_active (is_active)
);

-- Member Group Members Table (Hubungan Member-Group)
CREATE TABLE IF NOT EXISTS member_group_members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    group_id INT NOT NULL COMMENT 'ID grup',
    member_id INT NOT NULL COMMENT 'ID member',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Tanggal bergabung',
    added_by INT COMMENT 'Ditambahkan oleh',
    
    FOREIGN KEY (group_id) REFERENCES member_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    FOREIGN KEY (added_by) REFERENCES users(id),
    
    UNIQUE KEY uk_group_member (group_id, member_id),
    INDEX idx_group_id (group_id),
    INDEX idx_member_id (member_id)
);

-- ================================================================
-- 4. PRODUCT MANAGEMENT
-- ================================================================

-- Loan Products Table (Produk Pinjaman)
CREATE TABLE IF NOT EXISTS loan_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT 'Nama produk',
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode produk',
    description TEXT COMMENT 'Deskripsi produk',
    product_category ENUM('mikro', 'kecil', 'menengah', 'konsumtif', 'produktif', 'pendidikan', 'kesehatan', 'khusus') DEFAULT 'mikro',
    
    -- Amount & Tenor
    min_amount DECIMAL(12,2) NOT NULL COMMENT 'Minimal pinjaman',
    max_amount DECIMAL(12,2) NOT NULL COMMENT 'Maksimal pinjaman',
    default_amount DECIMAL(12,2) COMMENT 'Default pinjaman',
    amount_increment DECIMAL(8,2) DEFAULT 100000 COMMENT 'Kelipatan jumlah',
    
    min_tenor_days INT NOT NULL COMMENT 'Minimal tenor (hari)',
    max_tenor_days INT NOT NULL COMMENT 'Maksimal tenor (hari)',
    default_tenor_days INT COMMENT 'Default tenor (hari)',
    tenor_increment_days INT DEFAULT 1 COMMENT 'Kelipatan tenor',
    
    -- Interest & Fees
    interest_rate_monthly DECIMAL(5,4) NOT NULL COMMENT 'Suku bunga per bulan',
    interest_type ENUM('flat', 'effective', 'annuity', 'declining_balance') DEFAULT 'flat',
    admin_fee_rate DECIMAL(5,4) DEFAULT 0.0200 COMMENT 'Biaya admin (%)',
    admin_fee_fixed DECIMAL(10,2) DEFAULT 0 COMMENT 'Biaya admin tetap',
    processing_fee_rate DECIMAL(5,4) DEFAULT 0 COMMENT 'Biaya proses (%)',
    processing_fee_fixed DECIMAL(10,2) DEFAULT 0 COMMENT 'Biaya proses tetap',
    late_fee_rate DECIMAL(5,4) DEFAULT 0.0100 COMMENT 'Denda keterlambatan (%)',
    late_fee_fixed DECIMAL(10,2) DEFAULT 0 COMMENT 'Denda keterlambatan tetap',
    early_payment_fee_rate DECIMAL(5,4) DEFAULT 0 COMMENT 'Biaya pelunasan dini (%)',
    
    -- Requirements & Restrictions
    min_credit_score INT DEFAULT 0 COMMENT 'Skor kredit minimal',
    max_credit_score INT DEFAULT 100 COMMENT 'Skor kredit maksimal',
    min_membership_days INT DEFAULT 0 COMMENT 'Lama keanggotaan minimal (hari)',
    max_age_years INT DEFAULT 0 COMMENT 'Usia maksimal (0=tidak ada)',
    min_monthly_income DECIMAL(12,2) COMMENT 'Pendapatan bulanan minimal',
    required_documents JSON COMMENT 'Dokumen yang diperlukan (JSON)',
    collateral_required BOOLEAN DEFAULT FALSE COMMENT 'Jaminan diperlukan',
    collateral_type ENUM('none', 'personal_guarantee', 'corporate_guarantee', 'asset', 'deposit') DEFAULT 'none',
    
    -- Target Market
    target_member_types JSON COMMENT 'Tipe member target (JSON)',
    target_business_types JSON COMMENT 'Tipe usaha target (JSON)',
    target_income_range JSON COMMENT 'Range pendapatan target (JSON)',
    target_geographic_areas JSON COMMENT 'Area geografis target (JSON)',
    
    -- Configuration
    installment_frequency ENUM('daily', 'weekly', 'biweekly', 'monthly', 'quarterly') DEFAULT 'daily',
    grace_period_days INT DEFAULT 0 COMMENT 'Masa tenggang (hari)',
    disbursement_method ENUM('cash', 'transfer', 'digital_wallet') DEFAULT 'transfer',
    repayment_method ENUM('cash', 'auto_debit', 'digital_wallet', 'bank_transfer') DEFAULT 'cash',
    
    -- Status & Metadata
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    is_promotional BOOLEAN DEFAULT FALSE COMMENT 'Produk promosi',
    priority_level INT DEFAULT 0 COMMENT 'Prioritas (0=terendah)',
    effective_date DATE COMMENT 'Tanggal efektif',
    expiry_date DATE COMMENT 'Tanggal kadaluarsa',
    terms_conditions TEXT COMMENT 'Syarat dan ketentuan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_code (code),
    INDEX idx_product_category (product_category),
    INDEX idx_min_amount (min_amount),
    INDEX idx_max_amount (max_amount),
    INDEX idx_interest_rate (interest_rate_monthly),
    INDEX idx_is_active (is_active),
    INDEX idx_is_promotional (is_promotional),
    INDEX idx_effective_date (effective_date)
);

-- Savings Products Table (Produk Simpanan)
CREATE TABLE IF NOT EXISTS savings_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT 'Nama produk',
    code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode produk',
    description TEXT COMMENT 'Deskripsi produk',
    product_type ENUM('kewer', 'mawar', 'sukarela', 'deposito', 'berjangka', 'pendidikan', 'haji', 'khusus') DEFAULT 'sukarela',
    product_category ENUM('wajib', 'sukarela', 'investasi', 'tujuan') DEFAULT 'sukarela',
    
    -- Amount & Frequency
    min_deposit DECIMAL(10,2) NOT NULL COMMENT 'Setoran minimal',
    max_deposit DECIMAL(12,2) COMMENT 'Setoran maksimal (0=tidak ada)',
    default_deposit DECIMAL(10,2) COMMENT 'Setoran default',
    deposit_increment DECIMAL(8,2) DEFAULT 10000 COMMENT 'Kelipatan setoran',
    deposit_frequency ENUM('daily', 'weekly', 'monthly', 'quarterly', 'flexible') DEFAULT 'flexible',
    min_monthly_deposit DECIMAL(10,2) COMMENT 'Setoran bulanan minimal',
    
    -- Interest & Returns
    interest_rate_monthly DECIMAL(5,4) NOT NULL COMMENT 'Suku bunga per bulan',
    interest_calculation ENUM('daily', 'monthly', 'quarterly', 'annually') DEFAULT 'monthly',
    interest_payment_frequency ENUM('monthly', 'quarterly', 'annually', 'maturity') DEFAULT 'monthly',
    bonus_rate DECIMAL(5,4) DEFAULT 0 COMMENT 'Bonus rate (%)',
    tax_rate DECIMAL(5,4) DEFAULT 0 COMMENT 'Pajak bunga (%)',
    compounding_method ENUM('simple', 'compound') DEFAULT 'simple',
    
    -- Tenor & Withdrawal
    min_tenor_months INT COMMENT 'Tenor minimal (bulan)',
    max_tenor_months INT COMMENT 'Tenor maksimal (bulan)',
    default_tenor_months INT COMMENT 'Tenor default (bulan)',
    withdrawal_penalty_days INT DEFAULT 0 COMMENT 'Masa penalti penarikan (hari)',
    withdrawal_penalty_rate DECIMAL(5,4) DEFAULT 0 COMMENT 'Penalti penarikan (%)',
    min_withdrawal_amount DECIMAL(10,2) COMMENT 'Penarikan minimal',
    max_withdrawal_frequency INT COMMENT 'Maks frekuensi penarikan per bulan',
    auto_renewal BOOLEAN DEFAULT FALSE COMMENT 'Perpanjangan otomatis',
    
    -- Requirements & Restrictions
    min_credit_score INT DEFAULT 0 COMMENT 'Skor kredit minimal',
    min_membership_days INT DEFAULT 0 COMMENT 'Lama keanggotaan minimal (hari)',
    min_age_years INT DEFAULT 17 COMMENT 'Usia minimal',
    max_age_years INT DEFAULT 0 COMMENT 'Usia maksimal (0=tidak ada)',
    required_documents JSON COMMENT 'Dokumen yang diperlukan (JSON)',
    
    -- Target Market
    target_member_types JSON COMMENT 'Tipe member target (JSON)',
    target_income_range JSON COMMENT 'Range pendapatan target (JSON)',
    target_purpose JSON COMMENT 'Tujuan target (JSON)',
    
    -- Configuration
    account_type ENUM('individual', 'joint', 'corporate', 'custodial') DEFAULT 'individual',
    currency VARCHAR(3) DEFAULT 'IDR' COMMENT 'Mata uang',
    auto_debit_enabled BOOLEAN DEFAULT FALSE COMMENT 'Auto-debit aktif',
    online_access BOOLEAN DEFAULT TRUE COMMENT 'Akses online',
    mobile_banking BOOLEAN DEFAULT TRUE COMMENT 'Mobile banking',
    
    -- Status & Metadata
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    is_promotional BOOLEAN DEFAULT FALSE COMMENT 'Produk promosi',
    priority_level INT DEFAULT 0 COMMENT 'Prioritas (0=terendah)',
    effective_date DATE COMMENT 'Tanggal efektif',
    expiry_date DATE COMMENT 'Tanggal kadaluarsa',
    terms_conditions TEXT COMMENT 'Syarat dan ketentuan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_code (code),
    INDEX idx_product_type (product_type),
    INDEX idx_product_category (product_category),
    INDEX idx_interest_rate (interest_rate_monthly),
    INDEX idx_is_active (is_active),
    INDEX idx_is_promotional (is_promotional),
    INDEX idx_effective_date (effective_date)
);

-- ================================================================
-- 5. LOAN MANAGEMENT
-- ================================================================

-- Loans Table (Pinjaman)
CREATE TABLE IF NOT EXISTS loans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    application_number VARCHAR(20) UNIQUE NOT NULL COMMENT 'Nomor aplikasi',
    member_id INT NOT NULL COMMENT 'ID member',
    product_id INT NOT NULL COMMENT 'ID produk pinjaman',
    branch_id INT NOT NULL COMMENT 'ID cabang',
    collector_id INT COMMENT 'ID kolektor',
    
    -- Loan Details
    amount DECIMAL(12,2) NOT NULL COMMENT 'Jumlah pinjaman',
    admin_fee DECIMAL(10,2) NOT NULL COMMENT 'Biaya admin',
    processing_fee DECIMAL(10,2) NOT NULL COMMENT 'Biaya proses',
    insurance_fee DECIMAL(10,2) DEFAULT 0 COMMENT 'Biaya asuransi',
    other_fees DECIMAL(10,2) DEFAULT 0 COMMENT 'Biaya lain-lain',
    total_fees DECIMAL(10,2) GENERATED ALWAYS AS (admin_fee + processing_fee + insurance_fee + other_fees) STORED,
    net_disbursed DECIMAL(12,2) NOT NULL COMMENT 'Jumlah cair',
    
    -- Interest & Terms
    interest_rate_monthly DECIMAL(5,4) NOT NULL COMMENT 'Suku bunga per bulan',
    interest_type ENUM('flat', 'effective', 'annuity', 'declining_balance') DEFAULT 'flat',
    installment_amount DECIMAL(10,2) NOT NULL COMMENT 'Jumlah angsuran',
    frequency ENUM('daily', 'weekly', 'biweekly', 'monthly') DEFAULT 'daily',
    total_installments INT NOT NULL COMMENT 'Total angsuran',
    paid_installments INT DEFAULT 0 COMMENT 'Angsuran terbayang',
    remaining_installments INT GENERATED ALWAYS AS (total_installments - paid_installments) STORED,
    
    -- Dates
    application_date DATE NOT NULL COMMENT 'Tanggal aplikasi',
    approval_date DATE COMMENT 'Tanggal persetujuan',
    disbursement_date DATE COMMENT 'Tanggal pencairan',
    first_payment_date DATE COMMENT 'Tanggal pembayaran pertama',
    maturity_date DATE COMMENT 'Tanggal jatuh tempo',
    completion_date DATE COMMENT 'Tanggal pelunasan',
    
    -- Status
    status ENUM('draft', 'submitted', 'under_review', 'approved', 'rejected', 'disbursed', 'active', 'late', 'defaulted', 'completed', 'cancelled') DEFAULT 'draft',
    rejection_reason TEXT COMMENT 'Alasan penolakan',
    cancellation_reason TEXT COMMENT 'Alasan pembatalan',
    
    -- Collateral & Guarantee
    collateral_type ENUM('none', 'personal_guarantee', 'corporate_guarantee', 'asset', 'deposit', 'savings') DEFAULT 'none',
    collateral_value DECIMAL(12,2) DEFAULT 0 COMMENT 'Nilai jaminan',
    collateral_description TEXT COMMENT 'Deskripsi jaminan',
    guarantor_id INT COMMENT 'ID penjamin',
    guarantor_relationship VARCHAR(50) COMMENT 'Hubungan penjamin',
    
    -- Risk Assessment
    credit_score_at_application INT COMMENT 'Skor kredit saat aplikasi',
    risk_level_at_application ENUM('low', 'medium', 'high', 'very_high') COMMENT 'Tingkat risiko saat aplikasi',
    risk_score DECIMAL(5,2) COMMENT 'Skor risiko (0-100)',
    risk_factors JSON COMMENT 'Faktor risiko (JSON)',
    
    -- Financial Summary
    total_principal DECIMAL(12,2) GENERATED ALWAYS AS (amount) STORED,
    total_interest DECIMAL(12,2) DEFAULT 0 COMMENT 'Total bunga',
    total_late_fees DECIMAL(12,2) DEFAULT 0 COMMENT 'Total denda',
    total_paid DECIMAL(12,2) DEFAULT 0 COMMENT 'Total terbayang',
    total_outstanding DECIMAL(12,2) GENERATED ALWAYS AS (total_principal + total_interest + total_late_fees - total_paid) STORED,
    days_past_due INT DEFAULT 0 COMMENT 'Hari tunggakan',
    
    -- Metadata
    purpose TEXT COMMENT 'Tujuan pinjaman',
    notes TEXT COMMENT 'Catatan tambahan',
    document_attachments JSON COMMENT 'Dokumen lampiran (JSON)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (product_id) REFERENCES loan_products(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (collector_id) REFERENCES users(id),
    FOREIGN KEY (guarantor_id) REFERENCES members(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_application_number (application_number),
    INDEX idx_member_id (member_id),
    INDEX idx_product_id (product_id),
    INDEX idx_branch_id (branch_id),
    INDEX idx_collector_id (collector_id),
    INDEX idx_status (status),
    INDEX idx_application_date (application_date),
    INDEX idx_disbursement_date (disbursement_date),
    INDEX idx_maturity_date (maturity_date),
    INDEX idx_amount (amount),
    INDEX idx_total_outstanding (total_outstanding),
    INDEX idx_days_past_due (days_past_due)
);

-- Loan Schedules Table (Jadwal Angsuran)
CREATE TABLE IF NOT EXISTS loan_schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT NOT NULL COMMENT 'ID pinjaman',
    installment_number INT NOT NULL COMMENT 'Nomor angsuran',
    due_date DATE NOT NULL COMMENT 'Tanggal jatuh tempo',
    
    -- Amount Details
    principal_amount DECIMAL(10,2) NOT NULL COMMENT 'Jumlah pokok',
    interest_amount DECIMAL(10,2) NOT NULL COMMENT 'Jumlah bunga',
    late_fee_amount DECIMAL(10,2) DEFAULT 0 COMMENT 'Jumlah denda',
    total_amount DECIMAL(10,2) NOT NULL COMMENT 'Total jumlah',
    
    -- Payment Details
    paid_date DATE COMMENT 'Tanggal pembayaran',
    paid_amount DECIMAL(10,2) DEFAULT 0 COMMENT 'Jumlah terbayar',
    paid_principal DECIMAL(10,2) DEFAULT 0 COMMENT 'Pokok terbayar',
    paid_interest DECIMAL(10,2) DEFAULT 0 COMMENT 'Bunga terbayar',
    paid_late_fee DECIMAL(10,2) DEFAULT 0 COMMENT 'Denda terbayar',
    balance_amount DECIMAL(10,2) GENERATED ALWAYS AS (total_amount - paid_amount) STORED,
    
    -- Collection Details
    collector_id INT COMMENT 'ID kolektor',
    collection_method ENUM('cash', 'transfer', 'digital_wallet', 'auto_debit', 'bank_transfer', 'waived') DEFAULT 'cash',
    payment_reference VARCHAR(50) COMMENT 'Referensi pembayaran',
    receipt_number VARCHAR(50) COMMENT 'Nomor kwitansi',
    bank_reference VARCHAR(50) COMMENT 'Referensi bank',
    
    -- Status
    status ENUM('pending', 'paid', 'late', 'overdue', 'waived', 'restructured', 'written_off') DEFAULT 'pending',
    days_late INT DEFAULT 0 COMMENT 'Hari terlambat',
    waiver_reason TEXT COMMENT 'Alasan penghapusan',
    
    -- Location & Metadata
    collection_location JSON COMMENT 'Lokasi penagihan (JSON)',
    collection_notes TEXT COMMENT 'Catatan penagihan',
    attachments JSON COMMENT 'Lampiran (JSON)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE,
    FOREIGN KEY (collector_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_loan_id (loan_id),
    INDEX idx_installment_number (installment_number),
    INDEX idx_due_date (due_date),
    INDEX idx_paid_date (paid_date),
    INDEX idx_collector_id (collector_id),
    INDEX idx_status (status),
    INDEX idx_days_late (days_late),
    UNIQUE KEY uk_loan_installment (loan_id, installment_number)
);

-- ================================================================
-- 6. SAVINGS MANAGEMENT
-- ================================================================

-- Savings Accounts Table (Rekening Simpanan)
CREATE TABLE IF NOT EXISTS savings_accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(20) UNIQUE NOT NULL COMMENT 'Nomor rekening',
    member_id INT NOT NULL COMMENT 'ID member',
    product_id INT NOT NULL COMMENT 'ID produk simpanan',
    branch_id INT NOT NULL COMMENT 'ID cabang',
    
    -- Account Details
    account_name VARCHAR(100) NOT NULL COMMENT 'Nama rekening',
    account_type ENUM('individual', 'joint', 'corporate', 'custodial') DEFAULT 'individual',
    joint_account_holders JSON COMMENT 'Pemegang rekening bersama (JSON)',
    custodian_id INT COMMENT 'ID wali (untuk minor)',
    
    -- Terms & Conditions
    start_date DATE NOT NULL COMMENT 'Tanggal mulai',
    end_date DATE COMMENT 'Tanggal berakhir',
    target_amount DECIMAL(12,2) COMMENT 'Target jumlah',
    monthly_target DECIMAL(10,2) COMMENT 'Target bulanan',
    auto_debit_enabled BOOLEAN DEFAULT FALSE COMMENT 'Auto-debit aktif',
    auto_debit_amount DECIMAL(10,2) COMMENT 'Jumlah auto-debit',
    
    -- Interest Configuration
    interest_rate_monthly DECIMAL(5,4) NOT NULL COMMENT 'Suku bunga per bulan',
    interest_calculation ENUM('daily', 'monthly', 'quarterly', 'annually') DEFAULT 'monthly',
    interest_payment_frequency ENUM('monthly', 'quarterly', 'annually', 'maturity') DEFAULT 'monthly',
    tax_withholding_rate DECIMAL(5,4) DEFAULT 0 COMMENT 'Pajak yang ditahan',
    
    -- Financial Summary
    current_balance DECIMAL(12,2) DEFAULT 0 COMMENT 'Saldo saat ini',
    total_deposits DECIMAL(12,2) DEFAULT 0 COMMENT 'Total setoran',
    total_withdrawals DECIMAL(12,2) DEFAULT 0 COMMENT 'Total penarikan',
    total_interest_earned DECIMAL(12,2) DEFAULT 0 COMMENT 'Total bunga earned',
    total_tax_withheld DECIMAL(12,2) DEFAULT 0 COMMENT 'Total pajak ditahan',
    
    -- Status
    status ENUM('active', 'inactive', 'frozen', 'closed', 'dormant') DEFAULT 'active',
    freeze_reason TEXT COMMENT 'Alasan pembekuan',
    closure_reason TEXT COMMENT 'Alasan penutupan',
    closure_date DATE COMMENT 'Tanggal penutupan',
    
    -- Access & Security
    online_access_enabled BOOLEAN DEFAULT TRUE COMMENT 'Akses online aktif',
    mobile_banking_enabled BOOLEAN DEFAULT TRUE COMMENT 'Mobile banking aktif',
    atm_card_enabled BOOLEAN DEFAULT TRUE COMMENT 'Kartu ATM aktif',
    daily_limit DECIMAL(10,2) DEFAULT 0 COMMENT 'Batas harian',
    transaction_limit DECIMAL(10,2) DEFAULT 0 COMMENT 'Batas transaksi',
    
    -- Metadata
    notes TEXT COMMENT 'Catatan tambahan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (product_id) REFERENCES savings_products(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (custodian_id) REFERENCES members(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_account_number (account_number),
    INDEX idx_member_id (member_id),
    INDEX idx_product_id (product_id),
    INDEX idx_branch_id (branch_id),
    INDEX idx_status (status),
    INDEX idx_start_date (start_date),
    INDEX idx_end_date (end_date),
    INDEX idx_current_balance (current_balance)
);

-- Savings Deposits Table (Setoran Simpanan)
CREATE TABLE IF NOT EXISTS savings_deposits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL COMMENT 'ID rekening',
    transaction_number VARCHAR(20) UNIQUE COMMENT 'Nomor transaksi',
    deposit_date DATE NOT NULL COMMENT 'Tanggal setoran',
    amount DECIMAL(10,2) NOT NULL COMMENT 'Jumlah setoran',
    
    -- Transaction Details
    deposit_type ENUM('regular', 'additional', 'bonus', 'interest', 'correction') DEFAULT 'regular',
    payment_method ENUM('cash', 'transfer', 'digital_wallet', 'auto_debit', 'bank_transfer') DEFAULT 'cash',
    payment_reference VARCHAR(50) COMMENT 'Referensi pembayaran',
    receipt_number VARCHAR(50) COMMENT 'Nomor kwitansi',
    
    -- Collection Details
    collector_id INT COMMENT 'ID kolektor',
    teller_id INT COMMENT 'ID teller',
    branch_id INT NOT NULL COMMENT 'ID cabang',
    counter_number VARCHAR(10) COMMENT 'Nomor loket',
    
    -- Status & Verification
    status ENUM('pending', 'verified', 'rejected', 'cancelled') DEFAULT 'verified',
    verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Tanggal verifikasi',
    verified_by INT COMMENT 'Diverifikasi oleh',
    rejection_reason TEXT COMMENT 'Alasan penolakan',
    
    -- Metadata
    notes TEXT COMMENT 'Catatan tambahan',
    attachments JSON COMMENT 'Lampiran (JSON)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    
    FOREIGN KEY (account_id) REFERENCES savings_accounts(id),
    FOREIGN KEY (collector_id) REFERENCES users(id),
    FOREIGN KEY (teller_id) REFERENCES users(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (verified_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    
    INDEX idx_account_id (account_id),
    INDEX idx_transaction_number (transaction_number),
    INDEX idx_deposit_date (deposit_date),
    INDEX idx_collector_id (collector_id),
    INDEX idx_status (status),
    INDEX idx_amount (amount)
);

-- Savings Withdrawals Table (Penarikan Simpanan)
CREATE TABLE IF NOT EXISTS savings_withdrawals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL COMMENT 'ID rekening',
    transaction_number VARCHAR(20) UNIQUE COMMENT 'Nomor transaksi',
    withdrawal_date DATE NOT NULL COMMENT 'Tanggal penarikan',
    amount DECIMAL(10,2) NOT NULL COMMENT 'Jumlah penarikan',
    
    -- Transaction Details
    withdrawal_type ENUM('regular', 'early', 'emergency', 'penalty', 'correction') DEFAULT 'regular',
    payment_method ENUM('cash', 'transfer', 'digital_wallet', 'bank_transfer') DEFAULT 'cash',
    payment_reference VARCHAR(50) COMMENT 'Referensi pembayaran',
    receipt_number VARCHAR(50) COMMENT 'Nomor kwitansi',
    
    -- Collection Details
    teller_id INT COMMENT 'ID teller',
    branch_id INT NOT NULL COMMENT 'ID cabang',
    counter_number VARCHAR(10) COMMENT 'Nomor loket',
    
    -- Approval & Verification
    requires_approval BOOLEAN DEFAULT FALSE COMMENT 'Memerlukan persetujuan',
    approved_by INT COMMENT 'Disetujui oleh',
    approved_at TIMESTAMP NULL COMMENT 'Tanggal persetujuan',
    approval_notes TEXT COMMENT 'Catatan persetujuan',
    
    -- Status
    status ENUM('pending', 'approved', 'rejected', 'cancelled') DEFAULT 'approved',
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Tanggal diproses',
    processed_by INT COMMENT 'Diproses oleh',
    rejection_reason TEXT COMMENT 'Alasan penolakan',
    
    -- Penalties
    penalty_amount DECIMAL(10,2) DEFAULT 0 COMMENT 'Jumlah penalti',
    penalty_reason TEXT COMMENT 'Alasan penalti',
    
    -- Metadata
    notes TEXT COMMENT 'Catatan tambahan',
    attachments JSON COMMENT 'Lampiran (JSON)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    
    FOREIGN KEY (account_id) REFERENCES savings_accounts(id),
    FOREIGN KEY (teller_id) REFERENCES users(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (approved_by) REFERENCES users(id),
    FOREIGN KEY (processed_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    
    INDEX idx_account_id (account_id),
    INDEX idx_transaction_number (transaction_number),
    INDEX idx_withdrawal_date (withdrawal_date),
    INDEX idx_teller_id (teller_id),
    INDEX idx_status (status),
    INDEX idx_amount (amount)
);

-- ================================================================
-- 7. CASH MANAGEMENT
-- ================================================================

-- Cash Balances Table (Saldo Kas Harian)
CREATE TABLE IF NOT EXISTS cash_balances (
    id INT PRIMARY KEY AUTO_INCREMENT,
    branch_id INT NOT NULL COMMENT 'ID cabang',
    balance_date DATE NOT NULL COMMENT 'Tanggal saldo',
    
    -- Cash Types
    opening_balance DECIMAL(15,2) NOT NULL COMMENT 'Saldo awal',
    cash_in DECIMAL(15,2) DEFAULT 0 COMMENT 'Pemasukan kas',
    cash_out DECIMAL(15,2) DEFAULT 0 COMMENT 'Pengeluaran kas',
    closing_balance DECIMAL(15,2) NOT NULL COMMENT 'Saldo akhir',
    
    -- Breakdown by Source
    loan_disbursements DECIMAL(15,2) DEFAULT 0 COMMENT 'Pencairan pinjaman',
    loan_repayments DECIMAL(15,2) DEFAULT 0 COMMENT 'Pembayaran pinjaman',
    savings_deposits DECIMAL(15,2) DEFAULT 0 COMMENT 'Setoran simpanan',
    savings_withdrawals DECIMAL(15,2) DEFAULT 0 COMMENT 'Penarikan simpanan',
    fees_income DECIMAL(15,2) DEFAULT 0 COMMENT 'Pendapatan biaya',
    operating_expenses DECIMAL(15,2) DEFAULT 0 COMMENT 'Biaya operasional',
    
    -- Collection Statistics
    collector_cash_handled DECIMAL(15,2) DEFAULT 0 COMMENT 'Kas yang ditangani kolektor',
    online_transfers DECIMAL(15,2) DEFAULT 0 COMMENT 'Transfer online',
    bank_deposits DECIMAL(15,2) DEFAULT 0 COMMENT 'Setoran bank',
    
    -- Verification & Status
    status ENUM('draft', 'submitted', 'verified', 'locked') DEFAULT 'draft',
    verified_by INT COMMENT 'Diverifikasi oleh',
    verified_at TIMESTAMP NULL COMMENT 'Tanggal verifikasi',
    locked_by INT COMMENT 'Dikunci oleh',
    locked_at TIMESTAMP NULL COMMENT 'Tanggal penguncian',
    
    -- Reconciliation
    bank_balance DECIMAL(15,2) DEFAULT 0 COMMENT 'Saldo bank',
    difference_amount DECIMAL(15,2) DEFAULT 0 COMMENT 'Selisih',
    reconciliation_status ENUM('pending', 'matched', 'mismatch', 'resolved') DEFAULT 'pending',
    reconciliation_notes TEXT COMMENT 'Catatan rekonsiliasi',
    
    -- Metadata
    notes TEXT COMMENT 'Catatan tambahan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (verified_by) REFERENCES users(id),
    FOREIGN KEY (locked_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    UNIQUE KEY uk_branch_date (branch_id, balance_date),
    INDEX idx_branch_id (branch_id),
    INDEX idx_balance_date (balance_date),
    INDEX idx_status (status),
    INDEX idx_reconciliation_status (reconciliation_status)
);

-- Cash Transactions Table (Transaksi Kas)
CREATE TABLE IF NOT EXISTS cash_transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_number VARCHAR(20) UNIQUE NOT NULL COMMENT 'Nomor transaksi',
    cash_balance_id INT NOT NULL COMMENT 'ID saldo kas',
    branch_id INT NOT NULL COMMENT 'ID cabang',
    transaction_date DATE NOT NULL COMMENT 'Tanggal transaksi',
    transaction_time TIME NOT NULL COMMENT 'Waktu transaksi',
    
    -- Transaction Details
    transaction_type ENUM('cash_in', 'cash_out', 'transfer_in', 'transfer_out', 'adjustment') NOT NULL,
    category ENUM('loan_disbursement', 'loan_payment', 'savings_deposit', 'savings_withdrawal', 'fee_income', 'operating_expense', 'bank_deposit', 'bank_withdrawal', 'adjustment', 'other') NOT NULL,
    amount DECIMAL(15,2) NOT NULL COMMENT 'Jumlah transaksi',
    description TEXT COMMENT 'Deskripsi transaksi',
    
    -- Reference Information
    reference_type ENUM('loan', 'savings_account', 'fee', 'expense', 'bank_transaction', 'adjustment', 'other') COMMENT 'Tipe referensi',
    reference_id INT COMMENT 'ID referensi',
    reference_number VARCHAR(50) COMMENT 'Nomor referensi',
    
    -- Collection Details
    collector_id INT COMMENT 'ID kolektor',
    teller_id INT COMMENT 'ID teller',
    counter_number VARCHAR(10) COMMENT 'Nomor loket',
    payment_method ENUM('cash', 'transfer', 'digital_wallet', 'bank_transfer', 'check', 'other') DEFAULT 'cash',
    receipt_number VARCHAR(50) COMMENT 'Nomor kwitansi',
    
    -- Location & Metadata
    location JSON COMMENT 'Lokasi transaksi (JSON)',
    attachments JSON COMMENT 'Lampiran (JSON)',
    notes TEXT COMMENT 'Catatan tambahan',
    
    -- Status
    status ENUM('pending', 'verified', 'rejected', 'cancelled') DEFAULT 'verified',
    verified_by INT COMMENT 'Diverifikasi oleh',
    verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Tanggal verifikasi',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    
    FOREIGN KEY (cash_balance_id) REFERENCES cash_balances(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (collector_id) REFERENCES users(id),
    FOREIGN KEY (teller_id) REFERENCES users(id),
    FOREIGN KEY (verified_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    
    INDEX idx_transaction_number (transaction_number),
    INDEX idx_cash_balance_id (cash_balance_id),
    INDEX idx_branch_id (branch_id),
    INDEX idx_transaction_date (transaction_date),
    INDEX idx_category (category),
    INDEX idx_reference (reference_type, reference_id),
    INDEX idx_collector_id (collector_id),
    INDEX idx_status (status)
);

-- ================================================================
-- 8. ACCOUNTING SYSTEM (SAK ETAP COMPLIANT)
-- ================================================================

-- Chart of Accounts Table
CREATE TABLE IF NOT EXISTS accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Kode akun',
    account_name VARCHAR(100) NOT NULL COMMENT 'Nama akun',
    account_type ENUM('aset', 'kewajiban', 'ekuitas', 'pendapatan', 'beban') NOT NULL COMMENT 'Tipe akun',
    account_category ENUM('current', 'non_current', 'operating', 'investing', 'financing') COMMENT 'Kategori akun',
    parent_id INT COMMENT 'ID akun induk',
    level INT DEFAULT 1 COMMENT 'Tingkat akun',
    normal_balance ENUM('debit', 'credit') NOT NULL COMMENT 'Saldo normal',
    description TEXT COMMENT 'Deskripsi akun',
    
    -- Configuration
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    is_consolidated BOOLEAN DEFAULT FALSE COMMENT 'Dikonsolidasi',
    is_budget_account BOOLEAN DEFAULT FALSE COMMENT 'Akun anggaran',
    is_tax_account BOOLEAN DEFAULT FALSE COMMENT 'Akun pajak',
    is_restricted BOOLEAN DEFAULT FALSE COMMENT 'Akun terbatas',
    
    -- Opening Balance
    opening_balance DECIMAL(15,2) DEFAULT 0 COMMENT 'Saldo awal',
    opening_balance_date DATE COMMENT 'Tanggal saldo awal',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (parent_id) REFERENCES accounts(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_account_code (account_code),
    INDEX idx_account_type (account_type),
    INDEX idx_parent_id (parent_id),
    INDEX idx_level (level),
    INDEX idx_is_active (is_active)
);

-- Journals Table (Jurnal Umum)
CREATE TABLE IF NOT EXISTS journals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    journal_number VARCHAR(20) UNIQUE NOT NULL COMMENT 'Nomor jurnal',
    journal_date DATE NOT NULL COMMENT 'Tanggal jurnal',
    period_id INT COMMENT 'ID periode akuntansi',
    description TEXT COMMENT 'Deskripsi jurnal',
    
    -- Reference Information
    reference_type VARCHAR(50) COMMENT 'Tipe referensi',
    reference_id INT COMMENT 'ID referensi',
    reference_number VARCHAR(50) COMMENT 'Nomor referensi',
    
    -- Status & Approval
    status ENUM('draft', 'submitted', 'approved', 'rejected', 'posted', 'reversed') DEFAULT 'draft',
    approved_by INT COMMENT 'Disetujui oleh',
    approved_at TIMESTAMP NULL COMMENT 'Tanggal persetujuan',
    posted_by INT COMMENT 'Diposting oleh',
    posted_at TIMESTAMP NULL COMMENT 'Tanggal posting',
    reversed_by INT COMMENT 'Dibalik oleh',
    reversed_at TIMESTAMP NULL COMMENT 'Tanggal pembalikan',
    
    -- Amount Summary
    total_debit DECIMAL(15,2) GENERATED ALWAYS AS (
        SELECT COALESCE(SUM(debit), 0) FROM journal_details WHERE journal_id = journals.id
    ) STORED,
    total_credit DECIMAL(15,2) GENERATED ALWAYS AS (
        SELECT COALESCE(SUM(credit), 0) FROM journal_details WHERE journal_id = journals.id
    ) STORED,
    
    -- Metadata
    notes TEXT COMMENT 'Catatan jurnal',
    attachments JSON COMMENT 'Lampiran (JSON)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (period_id) REFERENCES accounting_periods(id),
    FOREIGN KEY (approved_by) REFERENCES users(id),
    FOREIGN KEY (posted_by) REFERENCES users(id),
    FOREIGN KEY (reversed_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_journal_number (journal_number),
    INDEX idx_journal_date (journal_date),
    INDEX idx_reference (reference_type, reference_id),
    INDEX idx_status (status),
    INDEX idx_approved_by (approved_by),
    INDEX idx_created_by (created_by)
);

-- Journal Details Table (Detail Jurnal)
CREATE TABLE IF NOT EXISTS journal_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    journal_id INT NOT NULL COMMENT 'ID jurnal',
    account_id INT NOT NULL COMMENT 'ID akun',
    line_number INT NOT NULL COMMENT 'Nomor baris',
    
    -- Amount
    debit DECIMAL(15,2) DEFAULT 0 COMMENT 'Debit',
    credit DECIMAL(15,2) DEFAULT 0 COMMENT 'Kredit',
    amount DECIMAL(15,2) GENERATED ALWAYS AS (GREATEST(debit, credit)) STORED,
    
    -- Details
    description TEXT COMMENT 'Deskripsi baris jurnal',
    cost_center_id INT COMMENT 'ID pusat biaya',
    department_id INT COMMENT 'ID departemen',
    project_id INT COMMENT 'ID proyek',
    
    -- Reference
    reference_type VARCHAR(50) COMMENT 'Tipe referensi',
    reference_id INT COMMENT 'ID referensi',
    reference_number VARCHAR(50) COMMENT 'Nomor referensi',
    
    -- Tax Information
    tax_code VARCHAR(20) COMMENT 'Kode pajak',
    tax_rate DECIMAL(5,4) DEFAULT 0 COMMENT 'Tarif pajak',
    tax_amount DECIMAL(15,2) DEFAULT 0 COMMENT 'Jumlah pajak',
    
    -- Metadata
    notes TEXT COMMENT 'Catatan baris jurnal',
    attachments JSON COMMENT 'Lampiran (JSON)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (journal_id) REFERENCES journals(id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    FOREIGN KEY (cost_center_id) REFERENCES cost_centers(id),
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (project_id) REFERENCES projects(id),
    
    INDEX idx_journal_id (journal_id),
    INDEX idx_account_id (account_id),
    INDEX idx_debit (debit),
    INDEX idx_credit (credit),
    INDEX idx_amount (amount),
    INDEX idx_reference (reference_type, reference_id)
);

-- Accounting Periods Table
CREATE TABLE IF NOT EXISTS accounting_periods (
    id INT PRIMARY KEY AUTO_INCREMENT,
    period_name VARCHAR(50) NOT NULL COMMENT 'Nama periode',
    period_type ENUM('monthly', 'quarterly', 'annually') NOT NULL COMMENT 'Tipe periode',
    start_date DATE NOT NULL COMMENT 'Tanggal mulai',
    end_date DATE NOT NULL COMMENT 'Tanggal selesai',
    fiscal_year INT NOT NULL COMMENT 'Tahun fiskal',
    
    -- Status
    status ENUM('open', 'closed', 'locked') DEFAULT 'open',
    closed_by INT COMMENT 'Ditutup oleh',
    closed_at TIMESTAMP NULL COMMENT 'Tanggal penutupan',
    locked_by INT COMMENT 'Dikunci oleh',
    locked_at TIMESTAMP NULL COMMENT 'Tanggal penguncian',
    
    -- Summary
    total_journals INT DEFAULT 0 COMMENT 'Total jurnal',
    total_debit DECIMAL(15,2) DEFAULT 0 COMMENT 'Total debit',
    total_credit DECIMAL(15,2) DEFAULT 0 COMMENT 'Total kredit',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    
    FOREIGN KEY (closed_by) REFERENCES users(id),
    FOREIGN KEY (locked_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    
    UNIQUE KEY uk_period_dates (period_type, start_date, end_date),
    INDEX idx_period_type (period_type),
    INDEX idx_fiscal_year (fiscal_year),
    INDEX idx_status (status)
);

-- ================================================================
-- 9. COMPLIANCE & AUDIT
-- ================================================================

-- Audit Logs Table (Log Aktivitas)
CREATE TABLE IF NOT EXISTS audit_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50) COMMENT 'Nama tabel',
    record_id INT COMMENT 'ID record',
    action ENUM('CREATE', 'UPDATE', 'DELETE', 'VIEW', 'LOGIN', 'LOGOUT', 'APPROVE', 'REJECT', 'POST', 'REVERSE', 'EXPORT', 'IMPORT', 'OTHER') NOT NULL COMMENT 'Aksi',
    
    -- User Information
    user_id INT COMMENT 'ID user',
    username VARCHAR(50) COMMENT 'Username',
    role VARCHAR(50) COMMENT 'Role user',
    
    -- Data Changes
    old_values JSON COMMENT 'Nilai lama (JSON)',
    new_values JSON COMMENT 'Nilai baru (JSON)',
    changed_fields JSON COMMENT 'Field yang berubah (JSON)',
    
    -- System Information
    ip_address VARCHAR(45) COMMENT 'IP address',
    user_agent TEXT COMMENT 'User agent',
    session_id VARCHAR(100) COMMENT 'Session ID',
    device_info JSON COMMENT 'Info device (JSON)',
    
    -- Reference
    reference_type VARCHAR(50) COMMENT 'Tipe referensi',
    reference_id INT COMMENT 'ID referensi',
    reference_number VARCHAR(50) COMMENT 'Nomor referensi',
    
    -- Context
    context JSON COMMENT 'Konteks tambahan (JSON)',
    reason TEXT COMMENT 'Alasan aksi',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    
    INDEX idx_table_record (table_name, record_id),
    INDEX idx_action (action),
    INDEX idx_user_id (user_id),
    INDEX idx_ip_address (ip_address),
    INDEX idx_created_at (created_at),
    INDEX idx_reference (reference_type, reference_id)
);

-- Compliance Reports Table (Laporan Kepatuhan)
CREATE TABLE IF NOT EXISTS compliance_reports (
    id INT PRIMARY KEY AUTO_INCREMENT,
    report_type ENUM('aml', 'kyc', 'ppatk', 'bi', 'audit', 'risk', 'other') NOT NULL COMMENT 'Tipe laporan',
    report_name VARCHAR(200) NOT NULL COMMENT 'Nama laporan',
    report_period_start DATE NOT NULL COMMENT 'Periode mulai',
    report_period_end DATE NOT NULL COMMENT 'Periode selesai',
    
    -- Report Content
    report_data JSON NOT NULL COMMENT 'Data laporan (JSON)',
    summary_data JSON COMMENT 'Ringkasan data (JSON)',
    flagged_transactions JSON COMMENT 'Transaksi yang ditandai (JSON)',
    
    -- Status & Review
    status ENUM('draft', 'submitted', 'under_review', 'approved', 'rejected', 'submitted') DEFAULT 'draft',
    reviewed_by INT COMMENT 'Direview oleh',
    reviewed_at TIMESTAMP NULL COMMENT 'Tanggal review',
    review_notes TEXT COMMENT 'Catatan review',
    submitted_to VARCHAR(100) COMMENT 'Dikirim ke',
    submitted_at TIMESTAMP NULL COMMENT 'Tanggal pengiriman',
    submission_reference VARCHAR(50) COMMENT 'Referensi pengiriman',
    
    -- Metadata
    file_path VARCHAR(255) COMMENT 'Path file laporan',
    file_size INT COMMENT 'Ukuran file',
    file_type VARCHAR(50) COMMENT 'Tipe file',
    checksum VARCHAR(64) COMMENT 'Checksum file',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    
    FOREIGN KEY (reviewed_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    
    INDEX idx_report_type (report_type),
    INDEX idx_report_period (report_period_start, report_period_end),
    INDEX idx_status (status),
    INDEX idx_reviewed_by (reviewed_by),
    INDEX idx_created_by (created_by)
);

-- ================================================================
-- 10. NOTIFICATIONS & COMMUNICATIONS
-- ================================================================

-- Notifications Table (Notifikasi User)
CREATE TABLE IF NOT EXISTS notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT 'ID user',
    title VARCHAR(200) NOT NULL COMMENT 'Judul notifikasi',
    message TEXT NOT NULL COMMENT 'Pesan notifikasi',
    
    -- Notification Details
    type ENUM('info', 'warning', 'error', 'success', 'reminder', 'alert', 'promotion', 'system') DEFAULT 'info',
    category ENUM('loan', 'savings', 'payment', 'account', 'security', 'marketing', 'system') DEFAULT 'system',
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    
    -- Action Links
    action_url VARCHAR(255) COMMENT 'URL aksi',
    action_text VARCHAR(100) COMMENT 'Teks aksi',
    action_method ENUM('GET', 'POST', 'PUT', 'DELETE') DEFAULT 'GET',
    
    -- Delivery Channels
    channels JSON COMMENT 'Channel pengiriman (JSON)',
    email_sent BOOLEAN DEFAULT FALSE COMMENT 'Email terkirim',
    sms_sent BOOLEAN DEFAULT FALSE COMMENT 'SMS terkirim',
    push_sent BOOLEAN DEFAULT FALSE COMMENT 'Push notification terkirim',
    whatsapp_sent BOOLEAN DEFAULT FALSE COMMENT 'WhatsApp terkirim',
    
    -- Status
    is_read BOOLEAN DEFAULT FALSE COMMENT 'Status dibaca',
    read_at TIMESTAMP NULL COMMENT 'Tanggal dibaca',
    is_archived BOOLEAN DEFAULT FALSE COMMENT 'Status diarsipkan',
    archived_at TIMESTAMP NULL COMMENT 'Tanggal diarsipkan',
    
    -- Metadata
    metadata JSON COMMENT 'Metadata tambahan (JSON)',
    expires_at TIMESTAMP NULL COMMENT 'Kadaluarsa',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    INDEX idx_user_id (user_id),
    INDEX idx_type (type),
    INDEX idx_category (category),
    INDEX idx_priority (priority),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at),
    INDEX idx_expires_at (expires_at)
);

-- Communication Logs Table (Log Komunikasi)
CREATE TABLE IF NOT EXISTS communication_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT COMMENT 'ID user',
    contact_type ENUM('email', 'sms', 'whatsapp', 'push', 'in_app', 'phone_call') NOT NULL COMMENT 'Tipe kontak',
    recipient VARCHAR(255) NOT NULL COMMENT 'Penerima',
    
    -- Message Details
    subject VARCHAR(200) COMMENT 'Subjek (email)',
    content TEXT NOT NULL COMMENT 'Isi pesan',
    template_name VARCHAR(100) COMMENT 'Nama template',
    
    -- Status
    status ENUM('pending', 'sent', 'delivered', 'failed', 'bounced', 'opened', 'clicked') DEFAULT 'pending',
    sent_at TIMESTAMP NULL COMMENT 'Terkirim pada',
    delivered_at TIMESTAMP NULL COMMENT 'Terkirim pada',
    opened_at TIMESTAMP NULL COMMENT 'Dibuka pada',
    clicked_at TIMESTAMP NULL COMMENT 'Diklik pada',
    failed_reason TEXT COMMENT 'Alasan gagal',
    
    -- Provider Information
    provider VARCHAR(50) COMMENT 'Provider (SMTP, SMS gateway, dll)',
    provider_message_id VARCHAR(100) COMMENT 'ID message provider',
    provider_response TEXT COMMENT 'Response provider',
    
    -- Metadata
    metadata JSON COMMENT 'Metadata tambahan (JSON)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    
    INDEX idx_user_id (user_id),
    INDEX idx_contact_type (contact_type),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- ================================================================
-- 11. SYSTEM CONFIGURATION
-- ================================================================

-- System Settings Table (Pengaturan Sistem)
CREATE TABLE IF NOT EXISTS system_settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL COMMENT 'Key pengaturan',
    setting_value TEXT COMMENT 'Nilai pengaturan',
    setting_type ENUM('string', 'number', 'boolean', 'json', 'array') DEFAULT 'string',
    description TEXT COMMENT 'Deskripsi pengaturan',
    
    -- Category & Module
    category VARCHAR(50) COMMENT 'Kategori',
    module VARCHAR(50) COMMENT 'Modul',
    is_public BOOLEAN DEFAULT FALSE COMMENT 'Dapat diakses publik',
    is_editable BOOLEAN DEFAULT TRUE COMMENT 'Dapat diedit',
    
    -- Validation
    validation_rules JSON COMMENT 'Aturan validasi (JSON)',
    default_value TEXT COMMENT 'Nilai default',
    
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_setting_key (setting_key),
    INDEX idx_category (category),
    INDEX idx_module (module),
    INDEX idx_is_public (is_public)
);

-- Templates Table (Template Notifikasi/Email)
CREATE TABLE IF NOT EXISTS templates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT 'Nama template',
    type ENUM('email', 'sms', 'whatsapp', 'push', 'notification') NOT NULL COMMENT 'Tipe template',
    category VARCHAR(50) NOT NULL COMMENT 'Kategori template',
    
    -- Content
    subject VARCHAR(200) COMMENT 'Subjek (email)',
    content TEXT NOT NULL COMMENT 'Isi template',
    html_content TEXT COMMENT 'Isi HTML (email)',
    
    -- Variables
    variables JSON COMMENT 'Variable yang tersedia (JSON)',
    default_variables JSON COMMENT 'Variable default (JSON)',
    
    -- Configuration
    language VARCHAR(10) DEFAULT 'id' COMMENT 'Bahasa',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    is_default BOOLEAN DEFAULT FALSE COMMENT 'Template default',
    
    -- Metadata
    description TEXT COMMENT 'Deskripsi template',
    tags JSON COMMENT 'Tag (JSON)',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NOT NULL COMMENT 'Dibuat oleh',
    updated_by INT COMMENT 'Diupdate oleh',
    
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id),
    
    INDEX idx_type (type),
    INDEX idx_category (category),
    INDEX idx_language (language),
    INDEX idx_is_active (is_active),
    INDEX idx_is_default (is_default)
);

-- ================================================================
-- 12. VIEWS FOR REPORTING & ANALYSIS
-- ================================================================

-- Member Complete Profile View
CREATE OR REPLACE VIEW member_complete_profile AS
SELECT 
    m.id,
    m.member_number,
    m.member_type,
    m.join_date,
    m.status,
    m.credit_score,
    m.risk_level,
    m.max_loan_amount,
    m.current_active_loans,
    m.current_total_loans,
    m.total_savings,
    m.kyc_status,
    m.aml_status,
    
    -- Personal Data from schema_person
    p.nik,
    p.name,
    p.phone,
    p.email,
    p.birth_date,
    TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) as age,
    p.gender,
    p.occupation,
    p.monthly_income,
    p.business_type,
    p.marital_status,
    p.number_of_children,
    p.address_detail,
    p.postal_code,
    
    -- Branch Information
    b.name as branch_name,
    b.code as branch_code,
    b.phone as branch_phone,
    
    -- Loan Summary
    (SELECT COUNT(*) FROM loans l 
     WHERE l.member_id = m.id AND l.status IN ('active', 'late', 'defaulted')) as active_loans_count,
    (SELECT COALESCE(SUM(l.amount), 0) FROM loans l 
     WHERE l.member_id = m.id AND l.status IN ('active', 'late', 'defaulted')) as total_loan_amount,
    (SELECT COALESCE(SUM(ls.total_amount - ls.paid_amount), 0) FROM loan_schedules ls
     JOIN loans l ON ls.loan_id = l.id
     WHERE l.member_id = m.id AND ls.status = 'pending') as outstanding_amount,
    
    -- Savings Summary
    (SELECT COUNT(*) FROM savings_accounts sa 
     WHERE sa.member_id = m.id AND sa.status = 'active') as active_savings_count,
    (SELECT COALESCE(SUM(sa.current_balance), 0) FROM savings_accounts sa 
     WHERE sa.member_id = m.id AND sa.status = 'active') as total_savings_balance,
    
    -- Recent Activity
    (SELECT MAX(CASE WHEN l.status = 'disbursed' THEN l.disbursement_date END) FROM loans l 
     WHERE l.member_id = m.id) as last_loan_disbursement,
    (SELECT MAX(sd.deposit_date) FROM savings_deposits sd
     JOIN savings_accounts sa ON sd.account_id = sa.id
     WHERE sa.member_id = m.id) as last_savings_deposit,
    
    m.created_at as member_since,
    m.updated_at
    
FROM members m
JOIN schema_person.persons p ON m.person_id = p.id
JOIN branches b ON m.branch_id = b.id
WHERE m.is_active = 1;

-- Branch Performance View
CREATE OR REPLACE VIEW branch_performance AS
SELECT 
    b.id,
    b.name as branch_name,
    b.code as branch_code,
    b.branch_type,
    
    -- Member Statistics
    (SELECT COUNT(*) FROM members m WHERE m.branch_id = b.id AND m.status = 'active') as active_members_count,
    (SELECT COUNT(*) FROM members m WHERE m.branch_id = b.id AND m.status = 'active' AND m.join_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) as new_members_30d,
    
    -- Loan Portfolio
    (SELECT COUNT(*) FROM loans l 
     JOIN members m ON l.member_id = m.id
     WHERE m.branch_id = b.id AND l.status IN ('active', 'late', 'defaulted')) as active_loans_count,
    (SELECT COALESCE(SUM(l.amount), 0) FROM loans l
     JOIN members m ON l.member_id = m.id
     WHERE m.branch_id = b.id AND l.status IN ('active', 'late', 'defaulted')) as total_loan_portfolio,
    (SELECT COALESCE(SUM(l.total_outstanding), 0) FROM loans l
     JOIN members m ON l.member_id = m.id
     WHERE m.branch_id = b.id AND l.status IN ('active', 'late', 'defaulted')) as total_outstanding,
    
    -- NPL Analysis
    (SELECT COUNT(*) FROM loans l
     JOIN members m ON l.member_id = m.id
     JOIN loan_schedules ls ON l.id = ls.loan_id
     WHERE m.branch_id = b.id 
     AND l.status IN ('active', 'late', 'defaulted')
     AND ls.status = 'late'
     AND DATEDIFF(CURDATE(), ls.due_date) > 90) as npl_loans_count,
    (SELECT ROUND(
        (SELECT COUNT(*) FROM loans l
         JOIN members m ON l.member_id = m.id
         JOIN loan_schedules ls ON l.id = ls.loan_id
         WHERE m.branch_id = b.id 
         AND l.status IN ('active', 'late', 'defaulted')
         AND ls.status = 'late'
         AND DATEDIFF(CURDATE(), ls.due_date) > 90) * 100.0 /
        (SELECT COUNT(*) FROM loans l
         JOIN members m ON l.member_id = m.id
         WHERE m.branch_id = b.id AND l.status IN ('active', 'late', 'defaulted')), 2) as npl_ratio,
    
    -- Savings Portfolio
    (SELECT COUNT(*) FROM savings_accounts sa
     JOIN members m ON sa.member_id = m.id
     WHERE m.branch_id = b.id AND sa.status = 'active') as active_savings_count,
    (SELECT COALESCE(SUM(sa.current_balance), 0) FROM savings_accounts sa
     JOIN members m ON sa.member_id = m.id
     WHERE m.branch_id = b.id AND sa.status = 'active') as total_savings_balance,
    
    -- Collection Performance
    (SELECT COUNT(DISTINCT l.collector_id) FROM loans l
     JOIN members m ON l.member_id = m.id
     WHERE m.branch_id = b.id AND l.status = 'disbursed') as active_collectors_count,
    (SELECT COALESCE(SUM(ls.paid_amount), 0) FROM loan_schedules ls
     JOIN loans l ON ls.loan_id = l.id
     JOIN members m ON l.member_id = m.id
     WHERE m.branch_id = b.id 
     AND ls.paid_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) as collections_30d,
    
    -- Cash Performance
    (SELECT COALESCE(SUM(c.cash_in), 0) FROM cash_balances c
     WHERE c.branch_id = b.id 
     AND c.balance_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) as cash_in_30d,
    (SELECT COALESCE(SUM(c.cash_out), 0) FROM cash_balances c
     WHERE c.branch_id = b.id 
     AND c.balance_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)) as cash_out_30d,
    
    b.created_at as branch_since
    
FROM branches b
WHERE b.is_active = 1;

-- ================================================================
-- STORED PROCEDURES FOR API/MIDDLEWARE
-- ================================================================

DELIMITER $$

-- Create New Member with Auto Number
CREATE PROCEDURE IF NOT EXISTS CreateMember(
    IN p_person_id INT,
    IN p_branch_id INT,
    IN p_member_type VARCHAR(50),
    IN p_created_by INT
)
BEGIN
    DECLARE v_member_number VARCHAR(20);
    DECLARE v_join_date DATE;
    
    -- Generate member number
    SELECT CONCAT('MBR', DATE_FORMAT(CURDATE(), '%Y%m%d'), 
                   LPAD((SELECT COUNT(*) + 1 FROM members WHERE branch_id = p_branch_id), 4, '0'))
    INTO v_member_number;
    
    SET v_join_date = CURDATE();
    
    -- Insert member
    INSERT INTO members (
        person_id, member_number, branch_id, member_type, join_date, 
        status, created_by
    ) VALUES (
        p_person_id, v_member_number, p_branch_id, p_member_type, v_join_date,
        'pending', p_created_by
    );
    
    -- Return member data
    SELECT id, member_number, status, join_date 
    FROM members 
    WHERE id = LAST_INSERT_ID();
    
END$$

-- Process Loan Application
CREATE PROCEDURE IF NOT EXISTS ProcessLoanApplication(
    IN p_member_id INT,
    IN p_product_id INT,
    IN p_amount DECIMAL(12,2),
    IN p_purpose TEXT,
    IN p_created_by INT
)
BEGIN
    DECLARE v_application_number VARCHAR(20);
    DECLARE v_product_info JSON;
    DECLARE v_member_info JSON;
    DECLARE v_loan_id INT;
    
    -- Get product info
    SELECT JSON_OBJECT(
        'name', name,
        'min_amount', min_amount,
        'max_amount', max_amount,
        'interest_rate_monthly', interest_rate_monthly,
        'admin_fee_rate', admin_fee_rate
    ) INTO v_product_info
    FROM loan_products 
    WHERE id = p_product_id AND is_active = 1;
    
    -- Get member info
    SELECT JSON_OBJECT(
        'credit_score', credit_score,
        'risk_level', risk_level,
        'max_loan_amount', max_loan_amount,
        'current_active_loans', current_active_loans,
        'current_total_loans', current_total_loans
    ) INTO v_member_info
    FROM members 
    WHERE id = p_member_id AND status = 'active';
    
    -- Generate application number
    SELECT CONCAT('APP', DATE_FORMAT(CURDATE(), '%Y%m%d'), 
                   LPAD((SELECT COUNT(*) + 1 FROM loans WHERE DATE(application_date) = CURDATE()), 4, '0'))
    INTO v_application_number;
    
    -- Calculate fees
    DECLARE v_admin_fee DECIMAL(10,2);
    DECLARE v_processing_fee DECIMAL(10,2);
    DECLARE v_net_disbursed DECIMAL(12,2);
    
    SET v_admin_fee = p_amount * JSON_EXTRACT(v_product_info, '$.admin_fee_rate');
    SET v_processing_fee = p_amount * JSON_EXTRACT(v_product_info, '$.processing_fee_rate');
    SET v_net_disbursed = p_amount - v_admin_fee - v_processing_fee;
    
    -- Insert loan
    INSERT INTO loans (
        application_number, member_id, product_id, branch_id,
        amount, admin_fee, processing_fee, net_disbursed,
        application_date, purpose, status, created_by
    ) VALUES (
        v_application_number, p_member_id, p_product_id, 
        (SELECT branch_id FROM members WHERE id = p_member_id),
        p_amount, v_admin_fee, v_processing_fee, v_net_disbursed,
        CURDATE(), p_purpose, 'submitted', p_created_by
    );
    
    SET v_loan_id = LAST_INSERT_ID();
    
    -- Return loan data
    SELECT 
        id, application_number, amount, net_disbursed, status,
        JSON_OBJECT('product_info', v_product_info, 'member_info', v_member_info) as details
    FROM loans 
    WHERE id = v_loan_id;
    
END$$

-- Get Member Dashboard Data
CREATE PROCEDURE IF NOT EXISTS GetMemberDashboard(
    IN p_member_id INT,
    IN p_period_days INT DEFAULT 30
)
BEGIN
    -- Member Info
    SELECT 
        m.member_number, m.member_type, m.status, m.credit_score, m.risk_level,
        p.name, p.phone, p.email,
        b.name as branch_name,
        JSON_OBJECT('total_savings', m.total_savings, 'available_credit', m.available_credit) as financial_summary
    FROM members m
    JOIN schema_person.persons p ON m.person_id = p.id
    JOIN branches b ON m.branch_id = b.id
    WHERE m.id = p_member_id;
    
    -- Recent Loans
    SELECT 
        id, application_number, amount, status, disbursement_date,
        total_outstanding, days_past_due
    FROM loans 
    WHERE member_id = p_member_id 
    AND status IN ('active', 'late', 'defaulted')
    ORDER BY disbursement_date DESC
    LIMIT 5;
    
    -- Recent Savings Activities
    SELECT 
        sd.id, sd.transaction_number, sd.deposit_date, sd.amount,
        sd.payment_method, sd.notes
    FROM savings_deposits sd
    JOIN savings_accounts sa ON sd.account_id = sa.id
    WHERE sa.member_id = p_member_id
    AND sd.deposit_date >= DATE_SUB(CURDATE(), INTERVAL p_period_days DAY)
    ORDER BY sd.deposit_date DESC
    LIMIT 5;
    
    -- Upcoming Payments
    SELECT 
        ls.id, ls.installment_number, ls.due_date, ls.total_amount,
        ls.balance_amount, ls.days_late
    FROM loan_schedules ls
    JOIN loans l ON ls.loan_id = l.id
    WHERE l.member_id = p_member_id
    AND ls.status = 'pending'
    AND ls.due_date <= DATE_ADD(CURDATE(), INTERVAL 7 DAY)
    ORDER BY ls.due_date ASC
    LIMIT 10;
    
END$$

DELIMITER ;

-- ================================================================
-- TRIGGERS FOR AUTOMATION
-- ================================================================

DELIMITER $$

-- Update Member Statistics
CREATE TRIGGER IF NOT EXISTS tr_member_update_stats
AFTER INSERT ON loan_schedules
FOR EACH ROW
BEGIN
    IF NEW.status = 'paid' THEN
        UPDATE loans 
        SET paid_installments = paid_installments + 1,
            total_paid = total_paid + NEW.paid_amount
        WHERE id = NEW.loan_id;
        
        -- Update member loan stats
        UPDATE members m
        SET current_active_loans = (
            SELECT COUNT(*) 
            FROM loans l 
            WHERE l.member_id = NEW.loan_id AND l.status = 'disbursed'
        ),
        current_total_loans = (
            SELECT COALESCE(SUM(l.amount), 0)
            FROM loans l 
            WHERE l.member_id = NEW.loan_id AND l.status = 'disbursed'
        )
        WHERE m.id = (SELECT member_id FROM loans WHERE id = NEW.loan_id);
    END IF;
END$$

-- Update Savings Balance
CREATE TRIGGER IF NOT EXISTS tr_savings_update_balance
AFTER INSERT ON savings_deposits
FOR EACH ROW
BEGIN
    UPDATE savings_accounts 
    SET current_balance = current_balance + NEW.amount,
        total_deposits = total_deposits + NEW.amount
    WHERE id = NEW.account_id;
    
    -- Update member savings
    UPDATE members m
    SET total_savings = (
        SELECT COALESCE(SUM(sa.current_balance), 0)
        FROM savings_accounts sa
        WHERE sa.member_id = m.id AND sa.status = 'active'
    )
    WHERE m.id = (SELECT member_id FROM savings_accounts WHERE id = NEW.account_id);
END$$

-- Create Journal Entry for Loan Disbursement
CREATE TRIGGER IF NOT EXISTS tr_loan_disbursement_journal
AFTER UPDATE ON loans
FOR EACH ROW
BEGIN
    IF NEW.status = 'disbursed' AND OLD.status != 'disbursed' THEN
        -- Create journal entry
        INSERT INTO journals (
            journal_number, journal_date, description, reference_type, reference_id, status, created_by
        ) VALUES (
            CONCAT('JRN', DATE_FORMAT(CURDATE(), '%Y%m%d'), LPAD((SELECT COUNT(*) + 1 FROM journals WHERE journal_date = CURDATE()), 4, '0')),
            CURDATE(),
            CONCAT('Pencairan pinjaman ', NEW.application_number),
            'loan', NEW.id, 'posted', NEW.updated_by
        );
        
        SET @journal_id = LAST_INSERT_ID();
        
        -- Debit: Pinjaman yang diberikan
        INSERT INTO journal_details (
            journal_id, account_id, line_number, debit, credit, description
        ) SELECT 
            @journal_id, id, 1, NEW.amount, 0, 
            CONCAT('Pinjaman ', NEW.application_number, ' - ', (SELECT name FROM members WHERE id = NEW.member_id))
        FROM accounts 
        WHERE account_code = '1100'; -- Piutang Pinjaman Mikro
        
        -- Credit: Kas
        INSERT INTO journal_details (
            journal_id, account_id, line_number, debit, credit, description
        ) SELECT 
            @journal_id, id, 2, 0, NEW.net_disbursed,
            CONCAT('Kas - Pencairan ', NEW.application_number)
        FROM accounts 
        WHERE account_code = '1010'; -- Kas
        
        -- Credit: Biaya Admin
        IF NEW.admin_fee > 0 THEN
            INSERT INTO journal_details (
                journal_id, account_id, line_number, debit, credit, description
            ) SELECT 
                @journal_id, id, 3, 0, NEW.admin_fee,
                CONCAT('Biaya Admin - ', NEW.application_number)
            FROM accounts 
            WHERE account_code = '4100'; -- Biaya Admin
        END IF;
        
        -- Credit: Biaya Proses
        IF NEW.processing_fee > 0 THEN
            INSERT INTO journal_details (
                journal_id, account_id, line_number, debit, credit, description
            ) SELECT 
                @journal_id, id, 4, 0, NEW.processing_fee,
                CONCAT('Biaya Proses - ', NEW.application_number)
            FROM accounts 
            WHERE account_code = '4101'; -- Biaya Proses
        END IF;
    END IF;
END$$

DELIMITER ;

-- ================================================================
-- SAMPLE DATA FOR TESTING
-- ================================================================

-- Insert sample units
INSERT INTO units (name, code, description, unit_type, head_user_id, is_active, created_by) VALUES
('Unit Pusat', 'UP001', 'Unit Pusat Koperasi Berjalan', 'pusat', 1, TRUE, 1),
('Unit Jakarta', 'UP002', 'Unit Operasional Jakarta', 'unit', 2, TRUE, 1);

-- Insert sample branches
INSERT INTO branches (unit_id, name, code, branch_type, head_user_id, phone, email, is_active, created_by) VALUES
(1, 'Kantor Pusat', 'KP001', 'pusat', 1, '021-55551234', 'info@koperasi.co.id', TRUE, 1),
(1, 'Cabang Jakarta Pusat', 'CJ001', 'cabang', 2, '021-55551235', 'jakarta@koperasi.co.id', TRUE, 1),
(2, 'Cabang Jakarta Selatan', 'CJ002', 'cabang', 2, '021-55551236', 'jakselatan@koperasi.co.id', TRUE, 1);

-- Insert sample users
INSERT INTO users (username, password, person_id, branch_id, role, status, created_by) VALUES
('admin', '$2y$10$abcdefghijklmnopqrstuvwx', 1, 1, 'super_admin', 'active', 1),
('manager', '$2y$10$abcdefghijklmnopqrstuvwx', 2, 1, 'admin', 'active', 1),
('collector1', '$2y$10$abcdefghijklmnopqrstuvwx', 3, 2, 'collector', 'active', 1),
('cashier1', '$2y$10$abcdefghijklmnopqrstuvwx', 3, 2, 'cashier', 'active', 1);

-- Insert sample members
CALL CreateMember(1, 2, 'regular', 1);
CALL CreateMember(2, 2, 'regular', 1);
CALL CreateMember(3, 3, 'regular', 1);

-- Update member status to active
UPDATE members SET status = 'active', activation_date = CURDATE() WHERE id IN (1, 2, 3);

-- Insert sample loan products
INSERT INTO loan_products (name, code, description, product_category, min_amount, max_amount, min_tenor_days, max_tenor_days, interest_rate_monthly, admin_fee_rate, is_active, created_by) VALUES
('Pinjaman Mikro Kewer', 'PMK001', 'Pinjaman mikro untuk kebutuhan harian', 'mikro', 500000, 5000000, 30, 90, 0.0300, 0.0200, TRUE, 1),
('Pinjaman Kecil Mawar', 'PMK002', 'Pinjaman kecil untuk modal usaha', 'kecil', 5000000, 10000000, 60, 180, 0.0250, 0.0150, TRUE, 1),
('Pinjaman Produktif', 'PMK003', 'Pinjaman untuk modal produktif', 'menengah', 10000000, 50000000, 90, 360, 0.0200, 0.0100, TRUE, 1);

-- Insert sample savings products
INSERT INTO savings_products (name, code, description, product_type, min_deposit, interest_rate_monthly, is_active, created_by) VALUES
('Kewer Harian', 'SKH001', 'Simpanan harian rutin', 'kewer', 5000, 0.0080, TRUE, 1),
('Mawar Bulanan', 'SKM002', 'Simpanan bulanan berjangka', 'mawar', 100000, 0.0100, TRUE, 1),
('Sukarela', 'SKS003', 'Simpanan sukarela fleksibel', 'sukarela', 10000, 0.0090, TRUE, 1);

-- Insert sample savings accounts
INSERT INTO savings_accounts (account_number, member_id, product_id, branch_id, account_name, start_date, interest_rate_monthly, created_by) VALUES
('SA001', 1, 1, 1, 'Tabungan Ahmad', CURDATE(), 0.0080, 1),
('SA002', 2, 2, 1, 'Tabungan Siti', CURDATE(), 0.0100, 1),
('SA003', 3, 3, 2, 'Tabungan Budi', CURDATE(), 0.0090, 1);

-- Insert sample deposits
INSERT INTO savings_deposits (account_id, deposit_date, amount, payment_method, collector_id, branch_id, created_by) VALUES
(1, CURDATE(), 100000, 'cash', 3, 2, 1),
(2, CURDATE(), 150000, 'transfer', NULL, 1, 1),
(3, CURDATE(), 200000, 'cash', 3, 3, 1);

-- ================================================================
-- SETUP COMPLETE
-- ================================================================

SELECT 'Normalized Schema App setup completed successfully!' as status;
SELECT COUNT(*) as total_units FROM units;
SELECT COUNT(*) as total_branches FROM branches;
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_members FROM members;
SELECT COUNT(*) as total_loan_products FROM loan_products;
SELECT COUNT(*) as total_savings_products FROM savings_products;
SELECT COUNT(*) as total_savings_accounts FROM savings_accounts;
SELECT COUNT(*) as total_savings_deposits FROM savings_deposits;

-- Show sample data verification
SELECT 'Sample Data Verification:' as info;
SELECT u.username, u.role, p.name as person_name, b.name as branch_name 
FROM users u
JOIN schema_person.persons p ON u.person_id = p.id
LEFT JOIN branches b ON u.branch_id = b.id
LIMIT 3;
