-- ================================================================
-- UNIVERSAL SCHEMA_PERSON - REUSABLE FOR MULTIPLE APPLICATIONS
-- Complete personal data management system for any Indonesian application
-- Compatible with: Koperasi, Banking, E-commerce, Education, Healthcare, etc.
-- ================================================================

USE schema_person;

-- ================================================================
-- 1. CORE PERSONS TABLE - UNIVERSAL INDONESIAN CITIZEN DATA
-- ================================================================

DROP TABLE IF EXISTS persons;

CREATE TABLE persons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- Basic Identity (KTP Data - Universal)
    nik VARCHAR(16) UNIQUE NOT NULL COMMENT 'Nomor Induk Kependudukan (16 digit)',
    kk_number VARCHAR(16) COMMENT 'Nomor Kartu Keluarga',
    name VARCHAR(100) NOT NULL COMMENT 'Nama lengkap sesuai KTP',
    name_alias VARCHAR(100) COMMENT 'Nama panggilan/alias',
    birth_place VARCHAR(50) COMMENT 'Tempat lahir',
    birth_date DATE COMMENT 'Tanggal lahir (YYYY-MM-DD)',
    gender ENUM('L', 'P') COMMENT 'Jenis kelamin: L=Laki-laki, P=Perempuan',
    religion ENUM('Islam', 'Kristen', 'Katolik', 'Hindu', 'Budha', 'Konghucu', 'Lainnya', 'Tidak Ada') DEFAULT 'Islam',
    blood_type ENUM('A', 'B', 'AB', 'O', 'Tidak Tahu') COMMENT 'Golongan darah',
    nationality VARCHAR(50) DEFAULT 'WNI' COMMENT 'Kewarganegaraan',
    
    -- Physical Characteristics (Universal)
    height DECIMAL(5,2) COMMENT 'Tinggi badan (cm)',
    weight DECIMAL(5,2) COMMENT 'Berat badan (kg)',
    hair_color VARCHAR(20) COMMENT 'Warna rambut',
    eye_color VARCHAR(20) COMMENT 'Warna mata',
    skin_color VARCHAR(20) COMMENT 'Warna kulit',
    distinguishing_marks TEXT COMMENT 'Ciri-ciri khusus/tato/luka',
    
    -- Contact Information (Universal)
    phone VARCHAR(15) COMMENT 'Nomor telepon/HP utama',
    phone2 VARCHAR(15) COMMENT 'Nomor telepon/HP cadangan',
    whatsapp VARCHAR(15) COMMENT 'Nomor WhatsApp',
    telegram VARCHAR(30) COMMENT 'Username Telegram',
    instagram VARCHAR(50) COMMENT 'Username Instagram',
    facebook VARCHAR(50) COMMENT 'Username Facebook',
    email VARCHAR(100) COMMENT 'Email utama',
    email2 VARCHAR(100) COMMENT 'Email cadangan',
    website VARCHAR(100) COMMENT 'Website personal (jika ada)',
    
    -- Address Information (Universal)
    address_detail TEXT COMMENT 'Alamat lengkap (jalan, RT/RW)',
    rt VARCHAR(3) COMMENT 'RT (Rukun Tetangga)',
    rw VARCHAR(3) COMMENT 'RW (Rukun Warga)',
    postal_code VARCHAR(5) COMMENT 'Kode pos',
    address_type ENUM('Rumah', 'Kantor', 'Usaha', 'Kos', 'Lainnya') DEFAULT 'Rumah',
    
    -- Employment Information (Universal)
    occupation VARCHAR(100) COMMENT 'Pekerjaan utama',
    occupation_code VARCHAR(20) COMMENT 'Kode pekerjaan (BPS)',
    workplace VARCHAR(100) COMMENT 'Nama tempat kerja',
    work_address TEXT COMMENT 'Alamat tempat kerja',
    work_phone VARCHAR(15) COMMENT 'Telepon kantor',
    work_email VARCHAR(100) COMMENT 'Email kantor',
    monthly_income DECIMAL(12,2) COMMENT 'Pendapatan bulanan',
    annual_income DECIMAL(15,2) COMMENT 'Pendapatan tahunan',
    business_type ENUM('PNS', 'Swasta', 'Wiraswasta', 'Pedagang', 'Petani', 'Nelayan', 'Buruh', 'Pelajar', 'Mahasiswa', 'Pensiun', 'Tidak Bekerja', 'Lainnya') COMMENT 'Jenis pekerjaan',
    industry_sector VARCHAR(50) COMMENT 'Sektor industri',
    company_name VARCHAR(100) COMMENT 'Nama perusahaan',
    position VARCHAR(100) COMMENT 'Jabatan',
    employment_status ENUM('Tetap', 'Kontrak', 'Freelance', 'Part-time', 'Magang', 'Tidak Bekerja') COMMENT 'Status pekerjaan',
    
    -- Education Information (Universal)
    education_level ENUM('Tidak Sekolah', 'SD', 'SMP', 'SMA', 'D1', 'D2', 'D3', 'D4', 'S1', 'S2', 'S3', 'Profesi', 'Lainnya') COMMENT 'Tingkat pendidikan tertinggi',
    education_major VARCHAR(100) COMMENT 'Jurusan pendidikan',
    education_institution VARCHAR(100) COMMENT 'Nama institusi pendidikan',
    graduation_year INT COMMENT 'Tahun lulus',
    gpa DECIMAL(3,2) COMMENT 'IPK (jika applicable)',
    
    -- Family Information (Universal)
    marital_status ENUM('Belum Menikah', 'Menikah', 'Cerai Hidup', 'Cerai Mati', 'Janda', 'Duda') DEFAULT 'Belum Menikah',
    spouse_name VARCHAR(100) COMMENT 'Nama suami/istri',
    spouse_nik VARCHAR(16) COMMENT 'NIK suami/istri',
    spouse_phone VARCHAR(15) COMMENT 'Telepon suami/istri',
    spouse_occupation VARCHAR(100) COMMENT 'Pekerjaan suami/istri',
    number_of_children INT DEFAULT 0 COMMENT 'Jumlah anak',
    father_name VARCHAR(100) COMMENT 'Nama ayah',
    father_nik VARCHAR(16) COMMENT 'NIK ayah',
    father_occupation VARCHAR(100) COMMENT 'Pekerjaan ayah',
    mother_name VARCHAR(100) COMMENT 'Nama ibu',
    mother_nik VARCHAR(16) COMMENT 'NIK ibu',
    mother_occupation VARCHAR(100) COMMENT 'Pekerjaan ibu',
    
    -- Government & Legal Information (Universal)
    npwp VARCHAR(20) COMMENT 'Nomor Pokok Wajib Pajak',
    bpjs_kesehatan VARCHAR(13) COMMENT 'Nomor BPJS Kesehatan',
    bpjs_ketenagakerjaan VARCHAR(15) COMMENT 'Nomor BPJS Ketenagakerjaan',
    jamsostek VARCHAR(11) COMMENT 'Nomor Jamsostek (legacy)',
    passport_number VARCHAR(20) COMMENT 'Nomor paspor',
    passport_expiry DATE COMMENT 'Masa berlaku paspor',
    sim_type ENUM('A', 'B1', 'B2', 'C', 'D', 'Tidak Ada') COMMENT 'Jenis SIM',
    sim_number VARCHAR(20) COMMENT 'Nomor SIM',
    sim_expiry DATE COMMENT 'Masa berlaku SIM',
    
    -- Health Information (Universal)
    health_condition TEXT COMMENT 'Kondisi kesehatan umum',
    chronic_diseases TEXT COMMENT 'Penyakit kronis (jika ada)',
    allergies TEXT COMMENT 'Alergi',
    medications TEXT COMMENT 'Obat-obatan rutin',
    blood_pressure VARCHAR(20) COMMENT 'Tekanan darah',
    blood_sugar VARCHAR(20) COMMENT 'Gula darah',
    disability ENUM('Tidak Ada', 'Fisik', 'Sensorik', 'Mental', 'Intelektual', 'Multiple') DEFAULT 'Tidak Ada' COMMENT 'Disabilitas',
    disability_description TEXT COMMENT 'Deskripsi disabilitas',
    
    -- Digital Information (Universal)
    photo_path VARCHAR(255) COMMENT 'Path foto profil',
    ktp_photo_path VARCHAR(255) COMMENT 'Path foto KTP',
    kk_photo_path VARCHAR(255) COMMENT 'Path foto KK',
    signature_path VARCHAR(255) COMMENT 'Path tanda tangan digital',
    fingerprint_data TEXT COMMENT 'Data sidik jari (encrypted)',
    face_recognition_data TEXT COMMENT 'Data pengenalan wajah (encrypted)',
    
    -- Financial Information (Universal)
    bank_account_count INT DEFAULT 0 COMMENT 'Jumlah rekening bank',
    credit_card_count INT DEFAULT 0 COMMENT 'Jumlah kartu kredit',
    credit_score INT DEFAULT 0 COMMENT 'Skor kredit (0-100)',
    credit_rating ENUM('Excellent', 'Good', 'Fair', 'Poor', 'Very Poor') COMMENT 'Rating kredit',
    bankruptcy_status BOOLEAN DEFAULT FALSE COMMENT 'Status pailit/kebangkrutan',
    
    -- Risk & Security (Universal)
    risk_level ENUM('Rendah', 'Sedang', 'Tinggi', 'Sangat Tinggi') DEFAULT 'Sedang' COMMENT 'Tingkat risiko',
    is_blacklisted BOOLEAN DEFAULT FALSE COMMENT 'Daftar hitam',
    blacklist_reason TEXT COMMENT 'Alasan blacklist',
    is_watchlist BOOLEAN DEFAULT FALSE COMMENT 'Daftar pantauan',
    watchlist_reason TEXT COMMENT 'Alasan watchlist',
    
    -- Preferences & Interests (Universal)
    hobbies TEXT COMMENT 'Hobi',
    interests TEXT COMMENT 'Minat/ketertarikan',
    skills TEXT COMMENT 'Keahlian/keterampilan',
    languages TEXT COMMENT 'Bahasa yang dikuasai',
    preferred_contact ENUM('Phone', 'WhatsApp', 'Email', 'SMS', 'Surat') DEFAULT 'Phone' COMMENT 'Preferensi kontak',
    
    -- Status & Timestamps (Universal)
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    is_deceased BOOLEAN DEFAULT FALSE COMMENT 'Status meninggal',
    death_date DATE COMMENT 'Tanggal meninggal',
    verification_status ENUM('Pending', 'Verified', 'Rejected', 'Expired') DEFAULT 'Pending' COMMENT 'Status verifikasi',
    verification_date TIMESTAMP NULL COMMENT 'Tanggal verifikasi',
    verified_by INT COMMENT 'Diverifikasi oleh (user_id)',
    last_login TIMESTAMP NULL COMMENT 'Login terakhir',
    last_activity TIMESTAMP NULL COMMENT 'Aktivitas terakhir',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT COMMENT 'Dibuat oleh (user_id)',
    updated_by INT COMMENT 'Diupdate oleh (user_id)',
    
    -- Indexes for performance
    INDEX idx_nik (nik),
    INDEX idx_name (name),
    INDEX idx_name_alias (name_alias),
    INDEX idx_phone (phone),
    INDEX idx_phone2 (phone2),
    INDEX idx_whatsapp (whatsapp),
    INDEX idx_email (email),
    INDEX idx_email2 (email2),
    INDEX idx_kk_number (kk_number),
    INDEX idx_spouse_nik (spouse_nik),
    INDEX idx_father_nik (father_nik),
    INDEX idx_mother_nik (mother_nik),
    INDEX idx_npwp (npwp),
    INDEX idx_bpjs_kesehatan (bpjs_kesehatan),
    INDEX idx_bpjs_ketenagakerjaan (bpjs_ketenagakerjaan),
    INDEX idx_passport_number (passport_number),
    INDEX idx_sim_number (sim_number),
    INDEX idx_marital_status (marital_status),
    INDEX idx_occupation (occupation),
    INDEX idx_business_type (business_type),
    INDEX idx_education_level (education_level),
    INDEX idx_credit_score (credit_score),
    INDEX idx_risk_level (risk_level),
    INDEX idx_verification_status (verification_status),
    INDEX idx_is_active (is_active),
    INDEX idx_is_blacklisted (is_blacklisted),
    INDEX idx_is_watchlist (is_watchlist),
    INDEX idx_created_at (created_at),
    INDEX idx_updated_at (updated_at),
    INDEX idx_birth_date (birth_date),
    INDEX idx_death_date (death_date),
    INDEX idx_last_login (last_login),
    
    -- Unique constraints
    UNIQUE KEY uk_phone (phone),
    UNIQUE KEY uk_phone2 (phone2),
    UNIQUE KEY uk_whatsapp (whatsapp),
    UNIQUE KEY uk_email (email),
    UNIQUE KEY uk_email2 (email2),
    UNIQUE KEY uk_npwp (npwp),
    UNIQUE KEY uk_bpjs_kesehatan (bpjs_kesehatan),
    UNIQUE KEY uk_bpjs_ketenagakerjaan (bpjs_ketenagakerjaan),
    UNIQUE KEY uk_passport_number (passport_number),
    UNIQUE KEY uk_sim_number (sim_number)
);

-- ================================================================
-- 2. FAMILY RELATIONSHIPS TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS family_relationships (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person1_id INT NOT NULL COMMENT 'Person ID 1',
    person2_id INT NOT NULL COMMENT 'Person ID 2',
    relationship_type ENUM('Ayah', 'Ibu', 'Anak', 'Suami', 'Istri', 'Kakak', 'Adik', 'Kakek', 'Nenek', 'Cucu', 'Paman', 'Bibi', 'Keponakan', 'Sepupu', 'Mertua', 'Menantu', 'Ipar', 'Lainnya') NOT NULL,
    relationship_level ENUM('1', '2', '3', '4', '5+') COMMENT 'Tingkat hubungan (1=orang tua, 2=saudara, 3=sepupu, dst)',
    is_primary BOOLEAN DEFAULT FALSE COMMENT 'Hubungan utama (untuk suami/istri)',
    is_legal_guardian BOOLEAN DEFAULT FALSE COMMENT 'Wali hukum',
    is_emergency_contact BOOLEAN DEFAULT FALSE COMMENT 'Kontak darurat',
    custody_level ENUM('Full', 'Partial', 'None') DEFAULT 'None' COMMENT 'Tingkat perwalian',
    financial_responsibility ENUM('Full', 'Partial', 'None') DEFAULT 'None' COMMENT 'Tanggung jawab finansial',
    verification_status ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',
    verified_by INT COMMENT 'Diverifikasi oleh',
    verified_at TIMESTAMP NULL COMMENT 'Tanggal verifikasi',
    notes TEXT COMMENT 'Catatan hubungan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person1_id) REFERENCES persons(id) ON DELETE CASCADE,
    FOREIGN KEY (person2_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person1 (person1_id),
    INDEX idx_person2 (person2_id),
    INDEX idx_relationship_type (relationship_type),
    INDEX idx_relationship_level (relationship_level),
    INDEX idx_is_primary (is_primary),
    INDEX idx_is_legal_guardian (is_legal_guardian),
    INDEX idx_is_emergency_contact (is_emergency_contact),
    INDEX idx_verification_status (verification_status),
    
    -- Prevent duplicate relationships
    UNIQUE KEY uk_relationship (person1_id, person2_id, relationship_type)
);

-- ================================================================
-- 3. CONTACTS TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS contacts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    contact_type ENUM('Personal', 'Business', 'Emergency', 'Reference', 'Social', 'Professional') NOT NULL,
    contact_name VARCHAR(100) NOT NULL COMMENT 'Nama kontak',
    relationship VARCHAR(50) COMMENT 'Hubungan dengan person',
    organization VARCHAR(100) COMMENT 'Organisasi/perusahaan',
    position VARCHAR(100) COMMENT 'Jabatan',
    phone VARCHAR(15) COMMENT 'Nomor telepon',
    phone2 VARCHAR(15) COMMENT 'Nomor telepon cadangan',
    whatsapp VARCHAR(15) COMMENT 'Nomor WhatsApp',
    email VARCHAR(100) COMMENT 'Email',
    address TEXT COMMENT 'Alamat',
    city VARCHAR(50) COMMENT 'Kota',
    province VARCHAR(50) COMMENT 'Provinsi',
    postal_code VARCHAR(5) COMMENT 'Kode pos',
    country VARCHAR(50) DEFAULT 'Indonesia' COMMENT 'Negara',
    is_primary BOOLEAN DEFAULT FALSE COMMENT 'Kontak utama',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    notes TEXT COMMENT 'Catatan tambahan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_contact_type (contact_type),
    INDEX idx_phone (phone),
    INDEX idx_whatsapp (whatsapp),
    INDEX idx_email (email),
    INDEX idx_is_primary (is_primary),
    INDEX idx_is_active (is_active)
);

-- ================================================================
-- 4. EDUCATION RECORDS TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS education_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    education_level ENUM('TK', 'SD', 'SMP', 'SMA', 'SMK', 'MA', 'D1', 'D2', 'D3', 'D4', 'S1', 'S2', 'S3', 'Profesi', 'Sertifikat', 'Kursus', 'Lainnya') NOT NULL,
    institution_name VARCHAR(100) NOT NULL COMMENT 'Nama institusi',
    institution_type ENUM('Negeri', 'Swasta', 'Internasional', 'Online') DEFAULT 'Negeri',
    major_field VARCHAR(100) COMMENT 'Jurusan/Program studi',
    specialization VARCHAR(100) COMMENT 'Spesialisasi',
    start_date DATE COMMENT 'Tanggal mulai',
    end_date DATE COMMENT 'Tanggal selesai',
    graduation_date DATE COMMENT 'Tanggal wisuda',
    gpa DECIMAL(3,2) COMMENT 'IPK/Nilai rata-rata',
    max_gpa DECIMAL(3,2) DEFAULT 4.00 COMMENT 'Skala maksimum GPA',
    thesis_title VARCHAR(200) COMMENT 'Judul tesis/skripsi',
    achievement VARCHAR(200) COMMENT 'Prestasi/capaian',
    certificate_number VARCHAR(50) COMMENT 'Nomor ijazah/sertifikat',
    certificate_path VARCHAR(255) COMMENT 'Path file ijazah/sertifikat',
    is_completed BOOLEAN DEFAULT FALSE COMMENT 'Status selesai',
    is_current BOOLEAN DEFAULT FALSE COMMENT 'Sedang berjalan',
    notes TEXT COMMENT 'Catatan tambahan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_education_level (education_level),
    INDEX idx_institution_name (institution_name),
    INDEX idx_major_field (major_field),
    INDEX idx_start_date (start_date),
    INDEX idx_end_date (end_date),
    INDEX idx_is_completed (is_completed),
    INDEX idx_is_current (is_current)
);

-- ================================================================
-- 5. EMPLOYMENT RECORDS TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS employment_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    company_name VARCHAR(100) NOT NULL COMMENT 'Nama perusahaan/instansi',
    company_type ENUM('Pemerintah', 'BUMN', 'Swasta', 'Multinasional', 'Startup', 'NGO', 'Pendidikan', 'Kesehatan', 'Sendiri', 'Lainnya') NOT NULL,
    industry_sector VARCHAR(50) COMMENT 'Sektor industri',
    position VARCHAR(100) NOT NULL COMMENT 'Jabatan/posisi',
    department VARCHAR(100) COMMENT 'Departemen',
    level ENUM('Staff', 'Supervisor', 'Manager', 'Senior Manager', 'Director', 'VP', 'C-Level', 'Owner', 'Lainnya') COMMENT 'Level jabatan',
    employment_type ENUM('Tetap', 'Kontrak', 'Freelance', 'Part-time', 'Magang', 'Volunteer', 'Sendiri', 'Lainnya') NOT NULL,
    start_date DATE NOT NULL COMMENT 'Tanggal mulai kerja',
    end_date DATE COMMENT 'Tanggal selesai kerja',
    is_current BOOLEAN DEFAULT FALSE COMMENT 'Sedang bekerja',
    salary DECIMAL(12,2) COMMENT 'Gaji bulanan',
    salary_currency VARCHAR(3) DEFAULT 'IDR' COMMENT 'Mata uang gaji',
    benefits TEXT COMMENT 'Benefit/fasilitas',
    work_address TEXT COMMENT 'Alamat kerja',
    work_city VARCHAR(50) COMMENT 'Kota kerja',
    work_province VARCHAR(50) COMMENT 'Provinsi kerja',
    work_phone VARCHAR(15) COMMENT 'Telepon kantor',
    work_email VARCHAR(100) COMMENT 'Email kantor',
    supervisor_name VARCHAR(100) COMMENT 'Nama atasan',
    supervisor_phone VARCHAR(15) COMMENT 'Telepon atasan',
    supervisor_email VARCHAR(100) COMMENT 'Email atasan',
    duties TEXT COMMENT 'Tugas dan tanggung jawab',
    achievements TEXT COMMENT 'Pencapaian/prestasi',
    reason_for_leaving TEXT COMMENT 'Alasan keluar',
    reference_available BOOLEAN DEFAULT FALSE COMMENT 'Referensi tersedia',
    reference_contact VARCHAR(100) COMMENT 'Kontak referensi',
    certificate_path VARCHAR(255) COMMENT 'Path file sertifikat kerja',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_company_name (company_name),
    INDEX idx_position (position),
    INDEX idx_employment_type (employment_type),
    INDEX idx_start_date (start_date),
    INDEX idx_end_date (end_date),
    INDEX idx_is_current (is_current),
    INDEX idx_salary (salary)
);

-- ================================================================
-- 6. BUSINESS RECORDS TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS business_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID (owner)',
    business_name VARCHAR(100) NOT NULL COMMENT 'Nama usaha',
    business_type ENUM('Toko', 'Restoran', 'Jasa', 'Manufaktur', 'Teknologi', 'Pertanian', 'Perdagangan', 'Transportasi', 'Kesehatan', 'Pendidikan', 'Lainnya') NOT NULL,
    business_category VARCHAR(50) COMMENT 'Kategori usaha detail',
    legal_entity ENUM('Perorangan', 'CV', 'PT', 'Firma', 'Yayasan', 'Koperasi', 'Lainnya') DEFAULT 'Perorangan',
    registration_number VARCHAR(50) COMMENT 'Nomor registrasi usaha',
    tax_id VARCHAR(30) COMMENT 'NPWP perusahaan',
    business_license VARCHAR(50) COMMENT 'Nomor izin usaha',
    license_expiry DATE COMMENT 'Masa berlaku izin',
    start_date DATE COMMENT 'Tanggal mulai usaha',
    description TEXT COMMENT 'Deskripsi usaha',
    products_services TEXT COMMENT 'Produk/jasa',
    business_address TEXT COMMENT 'Alamat usaha',
    business_city VARCHAR(50) COMMENT 'Kota usaha',
    business_province VARCHAR(50) COMMENT 'Provinsi usaha',
    business_phone VARCHAR(15) COMMENT 'Telepon usaha',
    business_email VARCHAR(100) COMMENT 'Email usaha',
    business_website VARCHAR(100) COMMENT 'Website usaha',
    business_social_media TEXT COMMENT 'Media sosial usaha',
    annual_revenue DECIMAL(15,2) COMMENT 'Omzet tahunan',
    monthly_revenue DECIMAL(12,2) COMMENT 'Omzet bulanan',
    monthly_expense DECIMAL(12,2) COMMENT 'Biaya bulanan',
    profit_margin DECIMAL(5,2) COMMENT 'Margin profit (%)',
    number_of_employees INT DEFAULT 0 COMMENT 'Jumlah karyawan',
    business_status ENUM('Aktif', 'Tidak Aktif', 'Dijual', 'Ditutup', 'Lainnya') DEFAULT 'Aktif',
    ownership_percentage DECIMAL(5,2) DEFAULT 100.00 COMMENT 'Persentase kepemilikan',
    is_primary_business BOOLEAN DEFAULT TRUE COMMENT 'Usaha utama',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_business_name (business_name),
    INDEX idx_business_type (business_type),
    INDEX idx_legal_entity (legal_entity),
    INDEX idx_start_date (start_date),
    INDEX idx_business_status (business_status),
    INDEX idx_annual_revenue (annual_revenue),
    INDEX idx_number_of_employees (number_of_employees)
);

-- ================================================================
-- 7. BANK ACCOUNTS TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS bank_accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    bank_name VARCHAR(50) NOT NULL COMMENT 'Nama bank',
    bank_code VARCHAR(10) COMMENT 'Kode bank',
    account_number VARCHAR(25) NOT NULL COMMENT 'Nomor rekening',
    account_name VARCHAR(100) NOT NULL COMMENT 'Nama pemegang rekening',
    account_type ENUM('Tabungan', 'Giro', 'Deposito', 'Kredit', 'Syariah', 'Digital', 'Lainnya') DEFAULT 'Tabungan',
    currency VARCHAR(3) DEFAULT 'IDR' COMMENT 'Mata uang',
    branch_office VARCHAR(100) COMMENT 'Nama cabang bank',
    branch_address TEXT COMMENT 'Alamat cabang',
    opening_date DATE COMMENT 'Tanggal buka rekening',
    balance DECIMAL(15,2) DEFAULT 0 COMMENT 'Saldo rekening',
    overdraft_limit DECIMAL(15,2) DEFAULT 0 COMMENT 'Batas overdraft',
    interest_rate DECIMAL(5,4) COMMENT 'Suku bunga',
    is_joint_account BOOLEAN DEFAULT FALSE COMMENT 'Rekening bersama',
    joint_account_holders TEXT COMMENT 'Pemegang rekening bersama',
    is_primary BOOLEAN DEFAULT FALSE COMMENT 'Rekening utama',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    is_dormant BOOLEAN DEFAULT FALSE COMMENT 'Status dormant',
    last_transaction_date DATE COMMENT 'Tanggal transaksi terakhir',
    atm_card BOOLEAN DEFAULT TRUE COMMENT 'Memiliki kartu ATM',
    mobile_banking BOOLEAN DEFAULT TRUE COMMENT 'Aktif mobile banking',
    internet_banking BOOLEAN DEFAULT TRUE COMMENT 'Aktif internet banking',
    notes TEXT COMMENT 'Catatan tambahan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_bank_name (bank_name),
    INDEX idx_account_number (account_number),
    INDEX idx_account_type (account_type),
    INDEX idx_currency (currency),
    INDEX idx_is_primary (is_primary),
    INDEX idx_is_active (is_active),
    INDEX idx_balance (balance),
    
    UNIQUE KEY uk_account_number (bank_name, account_number)
);

-- ================================================================
-- 8. DIGITAL IDENTITIES TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS digital_identities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    platform VARCHAR(50) NOT NULL COMMENT 'Platform (Google, Apple, Facebook, dll)',
    platform_user_id VARCHAR(100) COMMENT 'User ID di platform',
    username VARCHAR(100) COMMENT 'Username',
    email VARCHAR(100) COMMENT 'Email terkait',
    phone VARCHAR(15) COMMENT 'Phone terkait',
    auth_method ENUM('Email', 'Phone', 'OAuth2', 'SAML', 'LDAP', 'Biometric', 'Lainnya') COMMENT 'Metode autentikasi',
    last_login TIMESTAMP NULL COMMENT 'Login terakhir',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    is_verified BOOLEAN DEFAULT FALSE COMMENT 'Status terverifikasi',
    verification_date TIMESTAMP NULL COMMENT 'Tanggal verifikasi',
    permissions TEXT COMMENT 'Permissions/hak akses',
    metadata JSON COMMENT 'Data tambahan (JSON)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_platform (platform),
    INDEX idx_platform_user_id (platform_user_id),
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_is_active (is_active),
    INDEX idx_is_verified (is_verified),
    INDEX idx_last_login (last_login)
);

-- ================================================================
-- 9. DOCUMENTS TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS documents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    document_type ENUM('KTP', 'KK', 'AKTA_KELAHIRAN', 'AKTA_PERKAWINAN', 'AKTA_CERAI', 'NPWP', 'BPJS_Kesehatan', 'BPJS_Ketenagakerjaan', 'SIM', 'PASPOR', 'IJAZAH', 'SERTIFIKAT', 'SURAT_REFERENSI', 'SURAT_KETERANGAN', 'FOTO', 'TANDA_TANGAN', 'KARTU_IDENTITAS', 'LAINNYA') NOT NULL,
    document_number VARCHAR(50) COMMENT 'Nomor dokumen',
    document_name VARCHAR(200) COMMENT 'Nama dokumen',
    issuing_authority VARCHAR(100) COMMENT 'Penerbit dokumen',
    issue_date DATE COMMENT 'Tanggal terbit',
    expiry_date DATE COMMENT 'Masa berlaku',
    file_path VARCHAR(255) NOT NULL COMMENT 'Path file dokumen',
    file_name VARCHAR(255) NOT NULL COMMENT 'Nama file asli',
    file_size INT COMMENT 'Ukuran file (bytes)',
    file_type VARCHAR(50) COMMENT 'Tipe file (PDF, JPG, PNG, dll)',
    mime_type VARCHAR(100) COMMENT 'MIME type',
    checksum VARCHAR(64) COMMENT 'Checksum file (SHA-256)',
    is_verified BOOLEAN DEFAULT FALSE COMMENT 'Status verifikasi',
    verification_method ENUM('Manual', 'OCR', 'API', 'Blockchain', 'Lainnya') COMMENT 'Metode verifikasi',
    verified_by INT COMMENT 'Diverifikasi oleh',
    verified_at TIMESTAMP NULL COMMENT 'Tanggal verifikasi',
    verification_notes TEXT COMMENT 'Catatan verifikasi',
    is_public BOOLEAN DEFAULT FALSE COMMENT 'Dapat diakses publik',
    access_level ENUM('Private', 'Internal', 'Public', 'Restricted') DEFAULT 'Private' COMMENT 'Level akses',
    tags TEXT COMMENT 'Tag/kategori',
    description TEXT COMMENT 'Deskripsi dokumen',
    language VARCHAR(10) DEFAULT 'id' COMMENT 'Bahasa dokumen',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_document_type (document_type),
    INDEX idx_document_number (document_number),
    INDEX idx_issuing_authority (issuing_authority),
    INDEX idx_issue_date (issue_date),
    INDEX idx_expiry_date (expiry_date),
    INDEX idx_is_verified (is_verified),
    INDEX idx_verification_method (verification_method),
    INDEX idx_access_level (access_level),
    INDEX idx_created_at (created_at),
    INDEX idx_expiry_warning (expiry_date, is_verified)
);

-- ================================================================
-- 10. HEALTH RECORDS TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS health_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    record_type ENUM('Medical', 'Dental', 'Vision', 'Mental', 'Vaccination', 'Checkup', 'Emergency', 'Surgery', 'Lainnya') NOT NULL,
    provider_name VARCHAR(100) COMMENT 'Nama provider/fasilitas kesehatan',
    provider_type ENUM('Rumah Sakit', 'Klinik', 'Puskesmas', 'Dokter Praktik', 'Apotek', 'Lainnya') COMMENT 'Tipe provider',
    doctor_name VARCHAR(100) COMMENT 'Nama dokter',
    doctor_specialization VARCHAR(50) COMMENT 'Spesialisasi dokumen',
    visit_date DATE NOT NULL COMMENT 'Tanggal kunjungan',
    diagnosis TEXT COMMENT 'Diagnosis',
    symptoms TEXT COMMENT 'Gejala',
    treatment TEXT COMMENT 'Pengobatan/tindakan',
    medications TEXT COMMENT 'Obat-obatan',
    prescription VARCHAR(100) COMMENT 'Nomor resep',
    allergies TEXT COMMENT 'Alergi yang ditemukan',
    blood_pressure VARCHAR(20) COMMENT 'Tekanan darah',
    heart_rate INT COMMENT 'Denyut jantung',
    weight DECIMAL(5,2) COMMENT 'Berat badan',
    height DECIMAL(5,2) COMMENT 'Tinggi badan',
    temperature DECIMAL(4,1) COMMENT 'Suhu tubuh',
    blood_sugar VARCHAR(20) COMMENT 'Gula darah',
    cholesterol VARCHAR(20) COMMENT 'Kolesterol',
    notes TEXT COMMENT 'Catatan tambahan',
    follow_up_required BOOLEAN DEFAULT FALSE COMMENT 'Perlu follow-up',
    follow_up_date DATE COMMENT 'Tanggal follow-up',
    is_confidential BOOLEAN DEFAULT TRUE COMMENT 'Informasi rahasia',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_record_type (record_type),
    INDEX idx_provider_name (provider_name),
    INDEX idx_doctor_name (doctor_name),
    INDEX idx_visit_date (visit_date),
    INDEX idx_diagnosis (diagnosis(100)),
    INDEX idx_follow_up_date (follow_up_date),
    INDEX idx_is_confidential (is_confidential)
);

-- ================================================================
-- 11. PREFERENCES TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS preferences (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    preference_category VARCHAR(50) NOT NULL COMMENT 'Kategori preferensi',
    preference_key VARCHAR(100) NOT NULL COMMENT 'Key preferensi',
    preference_value TEXT COMMENT 'Value preferensi',
    data_type ENUM('String', 'Number', 'Boolean', 'JSON', 'Date', 'Time') DEFAULT 'String' COMMENT 'Tipe data',
    is_system BOOLEAN DEFAULT FALSE COMMENT 'Preferensi sistem',
    is_public BOOLEAN DEFAULT FALSE COMMENT 'Dapat diakses publik',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_category (preference_category),
    INDEX idx_key (preference_key),
    INDEX idx_is_system (is_system),
    INDEX idx_is_public (is_public),
    
    UNIQUE KEY uk_preference (person_id, preference_category, preference_key)
);

-- ================================================================
-- 12. AUDIT LOGS TABLE - UNIVERSAL
-- ================================================================

CREATE TABLE IF NOT EXISTS audit_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT COMMENT 'Person ID (jika applicable)',
    table_name VARCHAR(50) COMMENT 'Nama tabel',
    record_id INT COMMENT 'ID record',
    action ENUM('CREATE', 'UPDATE', 'DELETE', 'VIEW', 'LOGIN', 'LOGOUT', 'EXPORT', 'IMPORT', 'VERIFY', 'REJECT', 'APPROVE', 'LAINNYA') NOT NULL,
    old_values JSON COMMENT 'Nilai lama (JSON)',
    new_values JSON COMMENT 'Nilai baru (JSON)',
    changed_fields JSON COMMENT 'Field yang berubah (JSON)',
    ip_address VARCHAR(45) COMMENT 'IP address',
    user_agent TEXT COMMENT 'User agent',
    session_id VARCHAR(100) COMMENT 'Session ID',
    user_id INT COMMENT 'User ID yang melakukan aksi',
    username VARCHAR(50) COMMENT 'Username yang melakukan aksi',
    reason TEXT COMMENT 'Alasan perubahan',
    reference_type VARCHAR(50) COMMENT 'Tipe referensi',
    reference_id INT COMMENT 'ID referensi',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_person (person_id),
    INDEX idx_table_name (table_name),
    INDEX idx_record_id (record_id),
    INDEX idx_action (action),
    INDEX idx_user_id (user_id),
    INDEX idx_username (username),
    INDEX idx_ip_address (ip_address),
    INDEX idx_created_at (created_at),
    INDEX idx_reference (reference_type, reference_id)
);

-- ================================================================
-- VIEWS FOR UNIVERSAL REPORTING
-- ================================================================

-- Complete Person Profile View
CREATE OR REPLACE VIEW person_complete_profile AS
SELECT 
    p.id,
    p.nik,
    p.kk_number,
    p.name,
    p.name_alias,
    p.birth_place,
    p.birth_date,
    TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) as age,
    p.gender,
    p.religion,
    p.blood_type,
    p.nationality,
    p.height,
    p.weight,
    p.phone,
    p.whatsapp,
    p.email,
    p.address_detail,
    p.rt,
    p.rw,
    p.postal_code,
    p.occupation,
    p.workplace,
    p.monthly_income,
    p.annual_income,
    p.business_type,
    p.education_level,
    p.marital_status,
    p.spouse_name,
    p.number_of_children,
    p.npwp,
    p.bpjs_kesehatan,
    p.bpjs_ketenagakerjaan,
    p.credit_score,
    p.risk_level,
    p.verification_status,
    p.is_active,
    p.is_blacklisted,
    p.is_deceased,
    p.death_date,
    p.created_at,
    p.updated_at,
    
    -- Family Count
    (SELECT COUNT(*) FROM family_relationships fr 
     WHERE (fr.person1_id = p.id OR fr.person2_id = p.id) 
     AND fr.verification_status = 'Verified') as verified_family_count,
    
    -- Contact Count
    (SELECT COUNT(*) FROM contacts c WHERE c.person_id = p.id AND c.is_active = 1) as active_contacts_count,
    
    -- Education Count
    (SELECT COUNT(*) FROM education_records er WHERE er.person_id = p.id AND er.is_completed = 1) as completed_education_count,
    
    -- Employment Count
    (SELECT COUNT(*) FROM employment_records emr WHERE emr.person_id = p.id AND emr.is_current = 1) as current_employment_count,
    
    -- Business Count
    (SELECT COUNT(*) FROM business_records br WHERE br.person_id = p.id AND br.business_status = 'Aktif') as active_business_count,
    
    -- Bank Account Count
    (SELECT COUNT(*) FROM bank_accounts ba WHERE ba.person_id = p.id AND ba.is_active = 1) as active_bank_accounts_count,
    
    -- Document Count
    (SELECT COUNT(*) FROM documents d WHERE d.person_id = p.id AND d.is_verified = 1) as verified_documents_count,
    
    -- Health Record Count
    (SELECT COUNT(*) FROM health_records hr WHERE hr.person_id = p.id) as health_records_count
    
FROM persons p
WHERE p.is_active = 1;

-- Risk Assessment View
CREATE OR REPLACE VIEW person_risk_assessment AS
SELECT 
    p.id,
    p.name,
    p.nik,
    p.phone,
    p.email,
    p.credit_score,
    p.risk_level,
    p.monthly_income,
    p.annual_income,
    p.business_type,
    p.marital_status,
    p.number_of_children,
    p.education_level,
    p.occupation,
    p.is_blacklisted,
    p.is_watchlist,
    
    -- Risk Factors Calculation
    CASE 
        WHEN p.credit_score >= 80 THEN 'Rendah'
        WHEN p.credit_score >= 60 THEN 'Sedang'
        WHEN p.credit_score >= 40 THEN 'Tinggi'
        ELSE 'Sangat Tinggi'
    END as calculated_risk,
    
    -- Income Analysis
    CASE 
        WHEN p.annual_income > 0 AND p.number_of_children > 0 THEN
            CASE 
                WHEN p.annual_income / (p.number_of_children + 1) > 24000000 THEN 'Baik'
                WHEN p.annual_income / (p.number_of_children + 1) > 12000000 THEN 'Cukup'
                ELSE 'Kurang'
            END
        ELSE 'Baik'
    END as income_family_ratio,
    
    -- Employment Stability
    CASE 
        WHEN emr.employment_type IN ('Tetap', 'PNS', 'BUMN') THEN 'Stabil'
        WHEN emr.employment_type IN ('Kontrak', 'Freelance') THEN 'Sedang Stabil'
        ELSE 'Tidak Stabil'
    END as employment_stability,
    
    -- Business Analysis
    CASE 
        WHEN br.annual_revenue > 0 AND br.monthly_expense > 0 THEN
            CASE 
                WHEN (br.annual_revenue - (br.monthly_expense * 12)) / br.annual_revenue > 0.3 THEN 'Profitable'
                WHEN (br.annual_revenue - (br.monthly_expense * 12)) / br.annual_revenue > 0.1 THEN 'Breakeven'
                ELSE 'Loss Making'
            END
        ELSE 'Unknown'
    END as business_profitability,
    
    -- Family Risk
    (SELECT COUNT(*) FROM family_relationships fr 
     JOIN persons p2 ON (fr.person1_id = p2.id OR fr.person2_id = p2.id)
     WHERE (fr.person1_id = p.id OR fr.person2_id = p.id) 
     AND p2.is_blacklisted = 1) as blacklisted_family_count,
    
    -- Document Completeness
    (SELECT COUNT(*) FROM documents d 
     WHERE d.person_id = p.id AND d.is_verified = 1) as verified_documents_count,
    
    -- Age Factor
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) BETWEEN 25 AND 55 THEN 'Optimal'
        WHEN TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) BETWEEN 18 AND 65 THEN 'Good'
        ELSE 'Risk'
    END as age_factor,
    
    p.created_at as member_since
    
FROM persons p
LEFT JOIN employment_records emr ON p.id = emr.person_id AND emr.is_current = 1
LEFT JOIN business_records br ON p.id = br.person_id AND br.is_primary_business = 1
WHERE p.is_active = 1;

-- ================================================================
-- STORED PROCEDURES FOR UNIVERSAL OPERATIONS
-- ================================================================

DELIMITER $$

-- Calculate Comprehensive Credit Score
CREATE PROCEDURE IF NOT EXISTS CalculateUniversalCreditScore(IN p_person_id INT)
BEGIN
    DECLARE v_score INT DEFAULT 0;
    DECLARE v_income_score INT DEFAULT 0;
    DECLARE v_age_score INT DEFAULT 0;
    DECLARE v_education_score INT DEFAULT 0;
    DECLARE v_employment_score INT DEFAULT 0;
    DECLARE v_business_score INT DEFAULT 0;
    DECLARE v_family_score INT DEFAULT 0;
    DECLARE v_document_score INT DEFAULT 0;
    DECLARE v_health_score INT DEFAULT 0;
    
    -- Get person data
    DECLARE v_annual_income DECIMAL(15,2);
    DECLARE v_birth_date DATE;
    DECLARE v_education_level VARCHAR(50);
    DECLARE v_marital_status VARCHAR(50);
    DECLARE v_number_of_children INT;
    DECLARE v_occupation VARCHAR(100);
    DECLARE v_business_type VARCHAR(50);
    DECLARE v_is_blacklisted BOOLEAN;
    
    SELECT annual_income, birth_date, education_level, marital_status, 
           number_of_children, occupation, business_type, is_blacklisted
    INTO v_annual_income, v_birth_date, v_education_level, v_marital_status, 
         v_number_of_children, v_occupation, v_business_type, v_is_blacklisted
    FROM persons WHERE id = p_person_id;
    
    -- Blacklist check (automatic fail)
    IF v_is_blacklisted = TRUE THEN
        SET v_score = 0;
    ELSE
        -- Income Score (0-25 points)
        IF v_annual_income >= 120000000 THEN SET v_income_score = 25;
        ELSEIF v_annual_income >= 60000000 THEN SET v_income_score = 20;
        ELSEIF v_annual_income >= 36000000 THEN SET v_income_score = 15;
        ELSEIF v_annual_income >= 24000000 THEN SET v_income_score = 10;
        ELSE SET v_income_score = 5;
        END IF;
        
        -- Age Score (0-15 points)
        IF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 25 AND 50 THEN SET v_age_score = 15;
        ELSEIF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 21 AND 60 THEN SET v_age_score = 12;
        ELSEIF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 18 AND 65 THEN SET v_age_score = 8;
        ELSE SET v_age_score = 3;
        END IF;
        
        -- Education Score (0-15 points)
        IF v_education_level IN ('S3', 'S2', 'Profesi') THEN SET v_education_score = 15;
        ELSEIF v_education_level IN ('S1', 'D4') THEN SET v_education_score = 12;
        ELSEIF v_education_level IN ('D3', 'D2', 'D1') THEN SET v_education_score = 10;
        ELSEIF v_education_level IN ('SMA', 'SMK', 'MA') THEN SET v_education_score = 8;
        ELSEIF v_education_level IN ('SMP') THEN SET v_education_score = 5;
        ELSE SET v_education_score = 2;
        END IF;
        
        -- Employment Score (0-15 points)
        IF v_occupation IN ('PNS', 'BUMN', 'Swasta') THEN SET v_employment_score = 15;
        ELSEIF v_occupation IN ('Wiraswasta', 'Pedagang') THEN SET v_employment_score = 12;
        ELSEIF v_occupation IN ('Petani', 'Nelayan') THEN SET v_employment_score = 8;
        ELSEIF v_occupation IN ('Buruh', 'Freelance') THEN SET v_employment_score = 5;
        ELSE SET v_employment_score = 2;
        END IF;
        
        -- Business Score (0-10 points)
        IF v_business_type IN ('PNS', 'BUMN', 'Swasta') THEN SET v_business_score = 10;
        ELSEIF v_business_type IN ('Wiraswasta', 'Pedagang') THEN SET v_business_score = 8;
        ELSEIF v_business_type IN ('Petani', 'Nelayan') THEN SET v_business_score = 5;
        ELSE SET v_business_score = 3;
        END IF;
        
        -- Family Score (0-10 points)
        IF v_marital_status = 'Menikah' AND v_number_of_children <= 2 THEN SET v_family_score = 10;
        ELSEIF v_marital_status = 'Menikah' AND v_number_of_children <= 4 THEN SET v_family_score = 8;
        ELSEIF v_marital_status = 'Belum Menikah' THEN SET v_family_score = 9;
        ELSE SET v_family_score = 5;
        END IF;
        
        -- Document Score (0-10 points)
        SELECT COUNT(*) * 2 INTO v_document_score
        FROM documents 
        WHERE person_id = p_person_id AND is_verified = 1;
        
        IF v_document_score > 10 THEN SET v_document_score = 10; END IF;
        
        -- Calculate Total Score
        SET v_score = v_income_score + v_age_score + v_education_score + 
                     v_employment_score + v_business_score + v_family_score + v_document_score;
        
        -- Cap at 100
        IF v_score > 100 THEN SET v_score = 100; END IF;
    END IF;
    
    -- Update person record
    UPDATE persons 
    SET credit_score = v_score,
        risk_level = CASE 
            WHEN v_score >= 80 THEN 'Rendah'
            WHEN v_score >= 60 THEN 'Sedang'
            WHEN v_score >= 40 THEN 'Tinggi'
            ELSE 'Sangat Tinggi'
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_person_id;
    
    -- Insert into audit log
    INSERT INTO audit_logs (person_id, action, new_values, user_id)
    VALUES (p_person_id, 'UPDATE', 
            JSON_OBJECT('credit_score', v_score, 'risk_level', 
                       CASE WHEN v_score >= 80 THEN 'Rendah'
                            WHEN v_score >= 60 THEN 'Sedang'
                            WHEN v_score >= 40 THEN 'Tinggi'
                            ELSE 'Sangat Tinggi' END), 
            1);
    
    SELECT v_score as credit_score, 
           CASE WHEN v_score >= 80 THEN 'Rendah'
                WHEN v_score >= 60 THEN 'Sedang'
                WHEN v_score >= 40 THEN 'Tinggi'
                ELSE 'Sangat Tinggi' END as risk_level;
    
END$$

-- Universal Person Search
CREATE PROCEDURE IF NOT EXISTS UniversalPersonSearch(
    IN p_search_term VARCHAR(255),
    IN p_search_type VARCHAR(50),
    IN p_limit INT
)
BEGIN
    CASE p_search_type
        WHEN 'NIK' THEN
            SELECT * FROM persons WHERE nik LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'NAME' THEN
            SELECT * FROM persons WHERE name LIKE CONCAT('%', p_search_term, '%') OR name_alias LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'PHONE' THEN
            SELECT * FROM persons WHERE phone LIKE CONCAT('%', p_search_term, '%') OR whatsapp LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'EMAIL' THEN
            SELECT * FROM persons WHERE email LIKE CONCAT('%', p_search_term, '%') OR email2 LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'NPWP' THEN
            SELECT * FROM persons WHERE npwp LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
        WHEN 'ALL' THEN
            SELECT * FROM persons 
            WHERE nik LIKE CONCAT('%', p_search_term, '%') 
               OR name LIKE CONCAT('%', p_search_term, '%') 
               OR phone LIKE CONCAT('%', p_search_term, '%') 
               OR email LIKE CONCAT('%', p_search_term, '%')
            LIMIT p_limit;
        ELSE
            SELECT * FROM persons WHERE name LIKE CONCAT('%', p_search_term, '%') LIMIT p_limit;
    END CASE;
END$$

-- Verify Person Documents
CREATE PROCEDURE IF NOT EXISTS VerifyPersonDocuments(IN p_person_id INT, IN p_user_id INT, IN p_notes TEXT)
BEGIN
    DECLARE v_total_documents INT DEFAULT 0;
    DECLARE v_verified_documents INT DEFAULT 0;
    DECLARE v_required_documents INT DEFAULT 3;
    
    -- Count total and verified documents
    SELECT COUNT(*), SUM(CASE WHEN is_verified = 1 THEN 1 ELSE 0 END)
    INTO v_total_documents, v_verified_documents
    FROM documents 
    WHERE person_id = p_person_id;
    
    -- Update verification status
    UPDATE persons 
    SET verification_status = CASE 
            WHEN v_verified_documents >= v_required_documents THEN 'Verified'
            WHEN v_verified_documents > 0 THEN 'Pending'
            ELSE 'Pending'
        END,
        verification_date = CASE 
            WHEN v_verified_documents >= v_required_documents THEN CURRENT_TIMESTAMP 
            ELSE NULL 
        END,
        verified_by = CASE 
            WHEN v_verified_documents >= v_required_documents THEN p_user_id 
            ELSE NULL 
        END,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_person_id;
    
    -- Insert verification history
    INSERT INTO audit_logs (person_id, action, new_values, user_id, reason)
    VALUES (p_person_id, 'VERIFY', 
            JSON_OBJECT('verification_status', 
                       CASE WHEN v_verified_documents >= v_required_documents THEN 'Verified' ELSE 'Pending' END,
                       'verified_documents', v_verified_documents,
                       'total_documents', v_total_documents), 
            p_user_id, p_notes);
    
    SELECT verification_status, v_verified_documents as verified_documents, 
           v_total_documents as total_documents;
END$$

DELIMITER ;

-- ================================================================
-- TRIGGERS FOR AUTOMATIC OPERATIONS
-- ================================================================

DELIMITER $$

-- Trigger to update risk assessment when person data changes
CREATE TRIGGER IF NOT EXISTS tr_person_update_risk_assessment
AFTER UPDATE ON persons
FOR EACH ROW
BEGIN
    IF NEW.annual_income <> OLD.annual_income OR 
       NEW.business_type <> OLD.business_type OR 
       NEW.marital_status <> OLD.marital_status OR
       NEW.number_of_children <> OLD.number_of_children OR
       NEW.education_level <> OLD.education_level OR
       NEW.occupation <> OLD.occupation OR
       NEW.is_blacklisted <> OLD.is_blacklisted THEN
        CALL CalculateUniversalCreditScore(NEW.id);
    END IF;
END$$

-- Trigger to log all person changes
CREATE TRIGGER IF NOT EXISTS tr_person_audit_log
AFTER INSERT ON persons
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (person_id, action, new_values, user_id)
    VALUES (NEW.id, 'CREATE', 
            JSON_OBJECT('nik', NEW.nik, 'name', NEW.name, 'created_at', NEW.created_at), 
            NEW.created_by);
END$$

CREATE TRIGGER IF NOT EXISTS tr_person_audit_log_update
AFTER UPDATE ON persons
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (person_id, action, old_values, new_values, user_id)
    VALUES (NEW.id, 'UPDATE', 
            JSON_OBJECT('nik', OLD.nik, 'name', OLD.name, 'updated_at', OLD.updated_at),
            JSON_OBJECT('nik', NEW.nik, 'name', NEW.name, 'updated_at', NEW.updated_at), 
            NEW.updated_by);
END$$

DELIMITER ;

-- ================================================================
-- SAMPLE DATA FOR TESTING
-- ================================================================

-- Sample Persons (Universal Data)
INSERT INTO persons (
    nik, kk_number, name, name_alias, birth_place, birth_date, gender, religion, blood_type,
    phone, whatsapp, email, address_detail, rt, rw, postal_code,
    occupation, workplace, work_address, monthly_income, annual_income, business_type,
    education_level, education_institution, graduation_year,
    marital_status, spouse_name, spouse_phone, number_of_children,
    father_name, mother_name, npwp, bpjs_kesehatan, bpjs_ketenagakerjaan,
    credit_score, risk_level, verification_status, created_by
) VALUES 
('3201011234560001', '3201011234560001', 'Ahmad Sudirman', 'Pak Ahmad', 'Jakarta', '1985-05-15', 'L', 'Islam', 'A',
 '08123456789', '08123456789', 'ahmad.sudirman@email.com', 'Jl. Merdeka No. 123, Kelurahan Menteng', '001', '002', '12345',
 'Pedagang', 'Pasar Senen', 'Pasar Senen Blok A No. 10, Jakarta Pusat', 3000000, 36000000, 'Pedagang',
 'SMA', 'SMA Negeri 1 Jakarta', 2003,
 'Menikah', 'Siti Nurhaliza', '08234567890', 2,
 'Budi Santoso', 'Siti Rohani', '123456789012345', '0001234567890', '0001234567890',
 75, 'Sedang', 'Verified', 1),

('3201011234560002', '3201011234560002', 'Siti Nurhaliza', 'Bu Siti', 'Bandung', '1988-08-20', 'P', 'Islam', 'B',
 '08234567890', '08234567890', 'siti.nurhaliza@email.com', 'Jl. Sudirman No. 456, Kelurahan Sukajadi', '003', '004', '54321',
 'Pengusaha', 'Warung Siti', 'Jl. Sudirman No. 456, Bandung', 2500000, 30000000, 'Wiraswasta',
 'S1', 'Universitas Padjadjaran', 2010,
 'Menikah', 'Ahmad Sudirman', '08123456789', 2,
 'Ahmad Wijaya', 'Dewi Sartika', '234567890123456', '0002345678901', '0002345678901',
 70, 'Sedang', 'Verified', 1),

('3201011234560003', '3201011234560003', 'Budi Santoso', 'Pak Budi', 'Surabaya', '1980-03-10', 'L', 'Islam', 'O',
 '08345678901', '08345678901', 'budi.santoso@email.com', 'Jl. Gubernur Suryo No. 789, Kelurahan Genteng', '005', '006', '65432',
 'PNS', 'Dinas Pendidikan', 'Dinas Pendidikan Kota Surabaya', 8000000, 96000000, 'PNS',
 'S2', 'Universitas Airlangga', 2005,
 'Menikah', 'Ratna Sari', '08456789012', 3,
 'Suprapto', 'Sumarni', '345678901234567', '0003456789012', '0003456789012',
 85, 'Rendah', 'Verified', 1);

-- Sample Family Relationships
INSERT INTO family_relationships (person1_id, person2_id, relationship_type, relationship_level, is_primary, is_legal_guardian, verification_status) VALUES
(1, 2, 'Suami', '1', TRUE, TRUE, 'Verified'),
(1, 3, 'Kakak', '2', FALSE, FALSE, 'Verified');

-- Sample Contacts
INSERT INTO contacts (person_id, contact_type, contact_name, relationship, phone, whatsapp, email, address, is_primary) VALUES
(1, 'Emergency', 'Dr. Andi Wijaya', 'Dokter Pribadi', '08567890123', '08567890123', 'andi.wijaya@hospital.com', 'Rumah Sakit Medika, Jl. Healthcare No. 100', TRUE),
(2, 'Business', 'Haji Ahmad', 'Supplier', '08678901234', '08678901234', 'haji.ahmad@supplier.com', 'Pasar Grosir, Blok B No. 50', FALSE),
(3, 'Reference', 'Prof. Dr. Siti Aminah', 'Mentor', '08789012345', '08789012345', 'siti.aminah@university.ac.id', 'Universitas Negeri, Kampus A', TRUE);

-- Sample Education Records
INSERT INTO education_records (person_id, education_level, institution_name, major_field, start_date, end_date, graduation_date, gpa, is_completed) VALUES
(1, 'SMA', 'SMA Negeri 1 Jakarta', 'IPA', '1998-07-01', '2003-06-30', '2003-06-30', 3.25, TRUE),
(2, 'S1', 'Universitas Padjadjaran', 'Manajemen', '2006-07-01', '2010-06-30', '2010-06-30', 3.45, TRUE),
(3, 'S2', 'Universitas Airlangga', 'Pendidikan', '2003-07-01', '2005-06-30', '2005-06-30', 3.75, TRUE);

-- Sample Employment Records
INSERT INTO employment_records (person_id, company_name, company_type, position, level, employment_type, start_date, is_current, salary) VALUES
(1, 'Pasar Senen', 'Sendiri', 'Pedagang', 'Owner', 'Sendiri', '2005-01-01', TRUE, 3000000),
(2, 'Warung Siti', 'Sendiri', 'Pemilik Warung', 'Owner', 'Sendiri', '2010-06-01', TRUE, 2500000),
(3, 'Dinas Pendidikan Kota Surabaya', 'Pemerintah', 'Guru Honorer', 'Staff', 'Kontrak', '2008-01-01', TRUE, 8000000);

-- Sample Business Records
INSERT INTO business_records (person_id, business_name, business_type, business_category, start_date, description, business_address, business_phone, annual_revenue, monthly_revenue, monthly_expense, number_of_employees) VALUES
(1, 'Toko Ahmad', 'Perdagangan', 'Semako', '2005-01-01', 'Toko sembako dan kebutuhan harian', 'Pasar Senen Blok A No. 10, Jakarta Pusat', '08123456789', 36000000, 3000000, 2000000, 2),
(2, 'Warung Siti', 'Perdagangan', 'Kelontong', '2010-06-01', 'Warung kelontong dan kebutuhan rumah tangga', 'Jl. Sudirman No. 456, Bandung', '08234567890', 30000000, 2500000, 1500000, 0);

-- Sample Bank Accounts
INSERT INTO bank_accounts (person_id, bank_name, bank_code, account_number, account_name, account_type, currency, branch_office, opening_date, is_primary) VALUES
(1, 'BCA', '014', '1234567890', 'Ahmad Sudirman', 'Tabungan', 'IDR', 'KC Jakarta Pusat', '2005-01-15', TRUE),
(1, 'Mandiri', '008', '0987654321', 'Ahmad Sudirman', 'Tabungan', 'IDR', 'KC Jakarta Pusat', '2010-03-20', FALSE),
(2, 'BRI', '002', '1111222233', 'Siti Nurhaliza', 'Tabungan', 'IDR', 'KC Bandung', '2010-07-01', TRUE),
(3, 'BNI', '009', '4444555566', 'Budi Santoso', 'Tabungan', 'IDR', 'KC Surabaya', '2008-02-10', TRUE);

-- Sample Documents
INSERT INTO documents (person_id, document_type, document_number, issuing_authority, issue_date, expiry_date, file_path, file_name, file_type, is_verified) VALUES
(1, 'KTP', '3201011234560001', 'Dinas Kependudukan', '2020-01-15', '2030-01-15', '/uploads/ktp/3201011234560001.jpg', 'KTP_Ahmad.jpg', 'JPG', TRUE),
(1, 'KK', '3201011234560001', 'Dinas Kependudukan', '2020-01-15', '2030-01-15', '/uploads/kk/3201011234560001.jpg', 'KK_Ahmad.jpg', 'JPG', TRUE),
(1, 'NPWP', '123456789012345', 'Direktorat Jenderal Pajak', '2018-03-10', NULL, '/uploads/npwp/123456789012345.jpg', 'NPWP_Ahmad.jpg', 'JPG', TRUE),
(2, 'KTP', '3201011234560002', 'Dinas Kependudukan', '2021-02-20', '2031-02-20', '/uploads/ktp/3201011234560002.jpg', 'KTP_Siti.jpg', 'JPG', TRUE),
(2, 'KK', '3201011234560002', 'Dinas Kependudukan', '2021-02-20', '2031-02-20', '/uploads/kk/3201011234560002.jpg', 'KK_Siti.jpg', 'JPG', TRUE),
(2, 'NPWP', '234567890123456', 'Direktorat Jenderal Pajak', '2019-05-15', NULL, '/uploads/npwp/234567890123456.jpg', 'NPWP_Siti.jpg', 'JPG', TRUE),
(3, 'KTP', '3201011234560003', 'Dinas Kependudukan', '2019-07-10', '2029-07-10', '/uploads/ktp/3201011234560003.jpg', 'KTP_Budi.jpg', 'JPG', TRUE),
(3, 'KK', '3201011234560003', 'Dinas Kependudukan', '2019-07-10', '2029-07-10', '/uploads/kk/3201011234560003.jpg', 'KK_Budi.jpg', 'JPG', TRUE),
(3, 'NPWP', '345678901234567', 'Direktorat Jenderal Pajak', '2017-09-20', NULL, '/uploads/npwp/345678901234567.jpg', 'NPWP_Budi.jpg', 'JPG', TRUE);

-- Sample Preferences
INSERT INTO preferences (person_id, preference_category, preference_key, preference_value, data_type) VALUES
(1, 'notification', 'email_notifications', 'true', 'Boolean'),
(1, 'notification', 'sms_notifications', 'false', 'Boolean'),
(1, 'language', 'preferred_language', 'id', 'String'),
(1, 'privacy', 'share_contact_info', 'family_only', 'String'),
(2, 'notification', 'whatsapp_notifications', 'true', 'Boolean'),
(2, 'language', 'preferred_language', 'id', 'String'),
(3, 'notification', 'email_notifications', 'true', 'Boolean'),
(3, 'privacy', 'share_contact_info', 'public', 'String');

-- ================================================================
-- SETUP COMPLETE
-- ================================================================

SELECT 'Universal Schema Person setup completed successfully!' as status;
SELECT COUNT(*) as total_persons FROM persons;
SELECT COUNT(*) as total_family_relationships FROM family_relationships;
SELECT COUNT(*) as total_contacts FROM contacts;
SELECT COUNT(*) as total_education_records FROM education_records;
SELECT COUNT(*) as total_employment_records FROM employment_records;
SELECT COUNT(*) as total_business_records FROM business_records;
SELECT COUNT(*) as total_bank_accounts FROM bank_accounts;
SELECT COUNT(*) as total_documents FROM documents;
SELECT COUNT(*) as total_preferences FROM preferences;

-- Show sample data verification
SELECT 'Sample Data Verification:' as info;
SELECT nik, name, phone, email, credit_score, risk_level, verification_status FROM persons LIMIT 3;
