-- ================================================================
-- COMPLETE SCHEMA_PERSON FOR KOPERASI BERJALAN
-- Based on real-world practice and internet research
-- ================================================================

USE schema_person;

-- Drop existing table if exists
DROP TABLE IF EXISTS persons;

-- Enhanced Persons Table for Koperasi Berjalan
CREATE TABLE persons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- Basic Identity (KTP Data)
    nik VARCHAR(16) UNIQUE NOT NULL COMMENT 'Nomor Induk Kependudukan (16 digit)',
    kk_number VARCHAR(16) COMMENT 'Nomor Kartu Keluarga',
    name VARCHAR(100) NOT NULL COMMENT 'Nama lengkap sesuai KTP',
    birth_place VARCHAR(50) COMMENT 'Tempat lahir',
    birth_date DATE COMMENT 'Tanggal lahir (YYYY-MM-DD)',
    gender ENUM('L', 'P') COMMENT 'Jenis kelamin: L=Laki-laki, P=Perempuan',
    religion ENUM('Islam', 'Kristen', 'Katolik', 'Hindu', 'Budha', 'Konghucu', 'Lainnya') DEFAULT 'Islam',
    blood_type ENUM('A', 'B', 'AB', 'O') COMMENT 'Golongan darah',
    
    -- Contact Information
    phone VARCHAR(15) COMMENT 'Nomor telepon/HP aktif',
    whatsapp VARCHAR(15) COMMENT 'Nomor WhatsApp (untuk notifikasi)',
    email VARCHAR(100) COMMENT 'Email (opsional)',
    
    -- Address Information
    address_detail TEXT COMMENT 'Alamat lengkap (jalan, RT/RW)',
    rt VARCHAR(3) COMMENT 'RT (Rukun Tetangga)',
    rw VARCHAR(3) COMMENT 'RW (Rukun Warga)',
    postal_code VARCHAR(5) COMMENT 'Kode pos',
    
    -- Employment Information
    occupation VARCHAR(100) COMMENT 'Pekerjaan utama',
    workplace VARCHAR(100) COMMENT 'Nama tempat kerja',
    work_address TEXT COMMENT 'Alamat tempat kerja',
    monthly_income DECIMAL(12,2) COMMENT 'Pendapatan bulanan (opsional)',
    business_type ENUM('pedagang_pasar', 'warung', 'toko', 'jasa', 'lainnya') COMMENT 'Jenis usaha',
    
    -- Family Information
    marital_status ENUM('Belum Menikah', 'Menikah', 'Cerai', 'Duda/Janda') DEFAULT 'Belum Menikah',
    spouse_name VARCHAR(100) COMMENT 'Nama suami/istri',
    spouse_nik VARCHAR(16) COMMENT 'NIK suami/istri',
    number_of_children INT DEFAULT 0 COMMENT 'Jumlah anak',
    
    -- Tax Information
    npwp VARCHAR(20) COMMENT 'Nomor Pokok Wajib Pajak (opsional)',
    
    -- Government ID
    bpjs_kesehatan VARCHAR(13) COMMENT 'Nomor BPJS Kesehatan',
    bpjs_ketenagakerjaan VARCHAR(11) COMMENT 'Nomor BPJS Ketenagakerjaan',
    
    -- Digital Information
    photo_path VARCHAR(255) COMMENT 'Path foto KTP/anggota',
    ktp_photo_path VARCHAR(255) COMMENT 'Path foto KTP',
    signature_path VARCHAR(255) COMMENT 'Path tanda tangan digital',
    
    -- Risk Assessment
    credit_score INT DEFAULT 0 COMMENT 'Skor kredit (0-100)',
    risk_level ENUM('Rendah', 'Sedang', 'Tinggi') DEFAULT 'Sedang',
    
    -- Status & Timestamps
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    is_blacklisted BOOLEAN DEFAULT FALSE COMMENT 'Daftar hitam',
    verification_status ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',
    verification_date TIMESTAMP NULL COMMENT 'Tanggal verifikasi',
    verified_by INT COMMENT 'Diverifikasi oleh (user_id)',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes for performance
    INDEX idx_nik (nik),
    INDEX idx_name (name),
    INDEX idx_phone (phone),
    INDEX idx_whatsapp (whatsapp),
    INDEX idx_kk_number (kk_number),
    INDEX idx_marital_status (marital_status),
    INDEX idx_business_type (business_type),
    INDEX idx_credit_score (credit_score),
    INDEX idx_verification_status (verification_status),
    INDEX idx_created_at (created_at),
    
    -- Unique constraints
    UNIQUE KEY uk_phone (phone),
    UNIQUE KEY uk_whatsapp (whatsapp),
    UNIQUE KEY uk_npwp (npwp)
);

-- Family Links Table (Hubungan Keluarga)
CREATE TABLE IF NOT EXISTS family_links (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person1_id INT NOT NULL COMMENT 'Person ID 1',
    person2_id INT NOT NULL COMMENT 'Person ID 2',
    relationship ENUM('suami_istri', 'orang_tua_anak', 'kakek_nenek_cucu', 'saudara_kandung', 'saudara_ipar', 'paman_keponakan', 'sepupu', 'lainnya') NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE COMMENT 'Hubungan utama (untuk suami/istri)',
    verification_status ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',
    verified_by INT COMMENT 'Diverifikasi oleh',
    verified_at TIMESTAMP NULL COMMENT 'Tanggal verifikasi',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person1_id) REFERENCES persons(id) ON DELETE CASCADE,
    FOREIGN KEY (person2_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person1 (person1_id),
    INDEX idx_person2 (person2_id),
    INDEX idx_relationship (relationship),
    INDEX idx_verification_status (verification_status),
    
    -- Prevent duplicate relationships
    UNIQUE KEY uk_relationship (person1_id, person2_id, relationship)
);

-- Emergency Contacts Table
CREATE TABLE IF NOT EXISTS emergency_contacts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    contact_name VARCHAR(100) NOT NULL COMMENT 'Nama kontak darurat',
    relationship VARCHAR(50) COMMENT 'Hubungan dengan anggota',
    phone VARCHAR(15) NOT NULL COMMENT 'Nomor telepon kontak darurat',
    address TEXT COMMENT 'Alamat kontak darurat',
    is_primary BOOLEAN DEFAULT FALSE COMMENT 'Kontak utama',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_phone (phone),
    INDEX idx_primary (is_primary)
);

-- Education Background Table
CREATE TABLE IF NOT EXISTS education_background (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    education_level ENUM('Tidak Sekolah', 'SD', 'SMP', 'SMA', 'D3', 'D4', 'S1', 'S2', 'S3') NOT NULL,
    institution_name VARCHAR(100) COMMENT 'Nama institusi pendidikan',
    major VARCHAR(100) COMMENT 'Jurusan/Program studi',
    year_graduated INT COMMENT 'Tahun lulus',
    certificate_path VARCHAR(255) COMMENT 'Path ijazah/sertifikat',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_education_level (education_level)
);

-- Business Information Table (Detail Usaha)
CREATE TABLE IF NOT EXISTS business_information (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    business_name VARCHAR(100) COMMENT 'Nama usaha',
    business_type ENUM('pedagang_pasar', 'warung_kelontong', 'toko_kelontong', 'toko_semako', 'jasa', 'workshop', 'lainnya') NOT NULL,
    business_category VARCHAR(50) COMMENT 'Kategori usaha detail',
    business_address TEXT COMMENT 'Alamat usaha',
    business_phone VARCHAR(15) COMMENT 'Telepon usaha',
    business_email VARCHAR(100) COMMENT 'Email usaha',
    start_date DATE COMMENT 'Tanggal mulai usaha',
    monthly_revenue DECIMAL(12,2) COMMENT 'Omzet bulanan',
    monthly_expense DECIMAL(12,2) COMMENT 'Biaya bulanan',
    business_permit_number VARCHAR(50) COMMENT 'Nomor izin usaha',
    business_permit_expiry DATE COMMENT 'Masa berlaku izin usaha',
    has_employees BOOLEAN DEFAULT FALSE COMMENT 'Memiliki karyawan',
    number_of_employees INT DEFAULT 0 COMMENT 'Jumlah karyawan',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_business_type (business_type),
    INDEX idx_business_category (business_category),
    INDEX idx_monthly_revenue (monthly_revenue)
);

-- Bank Accounts Table
CREATE TABLE IF NOT EXISTS bank_accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    bank_name VARCHAR(50) NOT NULL COMMENT 'Nama bank',
    account_number VARCHAR(25) NOT NULL COMMENT 'Nomor rekening',
    account_name VARCHAR(100) NOT NULL COMMENT 'Nama pemegang rekening',
    account_type ENUM('Tabungan', 'Giro', 'Deposito') DEFAULT 'Tabungan',
    branch_office VARCHAR(100) COMMENT 'Nama cabang bank',
    is_primary BOOLEAN DEFAULT FALSE COMMENT 'Rekening utama',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Status aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_bank_name (bank_name),
    INDEX idx_account_number (account_number),
    INDEX idx_primary (is_primary),
    
    UNIQUE KEY uk_account_number (bank_name, account_number)
);

-- Document Uploads Table
CREATE TABLE IF NOT EXISTS document_uploads (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    document_type ENUM('KTP', 'KK', 'NPWP', 'BPJS_Kesehatan', 'BPJS_Ketenagakerjaan', 'Izin_Usaha', 'Surat_Nikah', 'Akta_Kelahiran', 'Ijazah', 'Foto_Profil', 'Tanda_Tangan', 'Lainnya') NOT NULL,
    document_number VARCHAR(50) COMMENT 'Nomor dokumen',
    file_path VARCHAR(255) NOT NULL COMMENT 'Path file dokumen',
    file_name VARCHAR(255) NOT NULL COMMENT 'Nama file asli',
    file_size INT COMMENT 'Ukuran file (bytes)',
    file_type VARCHAR(50) COMMENT 'Tipe file (PDF, JPG, dll)',
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date DATE COMMENT 'Masa berlaku dokumen',
    is_verified BOOLEAN DEFAULT FALSE COMMENT 'Status verifikasi',
    verified_by INT COMMENT 'Diverifikasi oleh',
    verified_at TIMESTAMP NULL COMMENT 'Tanggal verifikasi',
    notes TEXT COMMENT 'Catatan verifikasi',
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_document_type (document_type),
    INDEX idx_expiry_date (expiry_date),
    INDEX idx_is_verified (is_verified),
    INDEX idx_upload_date (upload_date)
);

-- Risk Assessment History Table
CREATE TABLE IF NOT EXISTS risk_assessment_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    assessment_date DATE NOT NULL COMMENT 'Tanggal penilaian',
    credit_score INT NOT NULL COMMENT 'Skor kredit (0-100)',
    risk_level ENUM('Rendah', 'Sedang', 'Tinggi') NOT NULL COMMENT 'Tingkat risiko',
    assessment_factors JSON COMMENT 'Faktor penilaian (JSON)',
    notes TEXT COMMENT 'Catatan penilaian',
    assessed_by INT NOT NULL COMMENT 'Dinilai oleh (user_id)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_assessment_date (assessment_date),
    INDEX idx_credit_score (credit_score),
    INDEX idx_risk_level (risk_level),
    INDEX idx_assessed_by (assessed_by)
);

-- Verification History Table
CREATE TABLE IF NOT EXISTS verification_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL COMMENT 'Person ID',
    verification_type ENUM('Data_Diri', 'Dokumen', 'Alamat', 'Usaha', 'Keluarga', 'Lainnya') NOT NULL,
    verification_status ENUM('Pending', 'Verified', 'Rejected') NOT NULL,
    verification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_by INT NOT NULL COMMENT 'Diverifikasi oleh (user_id)',
    notes TEXT COMMENT 'Catatan verifikasi',
    previous_status VARCHAR(50) COMMENT 'Status sebelumnya',
    
    FOREIGN KEY (person_id) REFERENCES persons(id) ON DELETE CASCADE,
    
    INDEX idx_person (person_id),
    INDEX idx_verification_type (verification_type),
    INDEX idx_verification_status (verification_status),
    INDEX idx_verification_date (verification_date),
    INDEX idx_verified_by (verified_by)
);

-- ================================================================
-- VIEWS FOR REPORTING AND ANALYSIS
-- ================================================================

-- Complete Person Profile View
CREATE OR REPLACE VIEW person_complete_profile AS
SELECT 
    p.id,
    p.nik,
    p.kk_number,
    p.name,
    p.birth_place,
    p.birth_date,
    TIMESTAMPDIFF(YEAR, p.birth_date, CURDATE()) as age,
    p.gender,
    p.religion,
    p.blood_type,
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
    p.business_type,
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
    p.created_at,
    
    -- Business Information
    bi.business_name,
    bi.business_type as business_category,
    bi.monthly_revenue,
    bi.monthly_expense,
    bi.number_of_employees,
    
    -- Bank Accounts Count
    (SELECT COUNT(*) FROM bank_accounts ba WHERE ba.person_id = p.id AND ba.is_active = 1) as bank_accounts_count,
    
    -- Documents Count
    (SELECT COUNT(*) FROM document_uploads du WHERE du.person_id = p.id AND du.is_verified = 1) as verified_documents_count,
    
    -- Family Members Count
    (SELECT COUNT(*) FROM family_links fl WHERE (fl.person1_id = p.id OR fl.person2_id = p.id) AND fl.verification_status = 'Verified') as verified_family_count
    
FROM persons p
LEFT JOIN business_information bi ON p.id = bi.person_id
WHERE p.is_active = 1;

-- Risk Assessment View
CREATE OR REPLACE VIEW person_risk_assessment AS
SELECT 
    p.id,
    p.name,
    p.nik,
    p.phone,
    p.credit_score,
    p.risk_level,
    p.monthly_income,
    p.business_type,
    p.marital_status,
    p.number_of_children,
    
    -- Risk Factors
    CASE 
        WHEN p.credit_score >= 80 THEN 'Rendah'
        WHEN p.credit_score >= 60 THEN 'Sedang'
        ELSE 'Tinggi'
    END as calculated_risk,
    
    -- Income to Family Ratio
    CASE 
        WHEN p.monthly_income > 0 AND p.number_of_children > 0 THEN
            CASE 
                WHEN p.monthly_income / (p.number_of_children + 1) > 2000000 THEN 'Baik'
                WHEN p.monthly_income / (p.number_of_children + 1) > 1000000 THEN 'Cukup'
                ELSE 'Kurang'
            END
        ELSE 'Baik'
    END as income_family_ratio,
    
    -- Business Stability
    CASE 
        WHEN bi.monthly_revenue > 0 AND bi.monthly_expense > 0 THEN
            CASE 
                WHEN (bi.monthly_revenue - bi.monthly_expense) / bi.monthly_revenue > 0.3 THEN 'Stabil'
                WHEN (bi.monthly_revenue - bi.monthly_expense) / bi.monthly_revenue > 0.1 THEN 'Cukup Stabil'
                ELSE 'Tidak Stabil'
            END
        ELSE 'Unknown'
    END as business_stability,
    
    -- Family Risk
    (SELECT COUNT(*) FROM family_links fl 
     JOIN persons p2 ON (fl.person1_id = p2.id OR fl.person2_id = p2.id)
     WHERE (fl.person1_id = p.id OR fl.person2_id = p.id) 
     AND p2.is_blacklisted = 1) as blacklisted_family_count,
    
    p.created_at as member_since
    
FROM persons p
LEFT JOIN business_information bi ON p.id = bi.person_id
WHERE p.is_active = 1;

-- ================================================================
-- STORED PROCEDURES
-- ================================================================

DELIMITER $$

-- Calculate Credit Score
CREATE PROCEDURE IF NOT EXISTS CalculateCreditScore(IN p_person_id INT)
BEGIN
    DECLARE v_score INT DEFAULT 0;
    DECLARE v_income_score INT DEFAULT 0;
    DECLARE v_age_score INT DEFAULT 0;
    DECLARE v_business_score INT DEFAULT 0;
    DECLARE v_family_score INT DEFAULT 0;
    DECLARE v_document_score INT DEFAULT 0;
    
    -- Get person data
    DECLARE v_monthly_income DECIMAL(12,2);
    DECLARE v_birth_date DATE;
    DECLARE v_business_type VARCHAR(50);
    DECLARE v_marital_status VARCHAR(50);
    DECLARE v_number_of_children INT;
    
    SELECT monthly_income, birth_date, business_type, marital_status, number_of_children
    INTO v_monthly_income, v_birth_date, v_business_type, v_marital_status, v_number_of_children
    FROM persons WHERE id = p_person_id;
    
    -- Income Score (0-30 points)
    IF v_monthly_income >= 5000000 THEN SET v_income_score = 30;
    ELSEIF v_monthly_income >= 3000000 THEN SET v_income_score = 25;
    ELSEIF v_monthly_income >= 2000000 THEN SET v_income_score = 20;
    ELSEIF v_monthly_income >= 1000000 THEN SET v_income_score = 15;
    ELSE SET v_income_score = 5;
    END IF;
    
    -- Age Score (0-20 points)
    IF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 25 AND 50 THEN SET v_age_score = 20;
    ELSEIF TIMESTAMPDIFF(YEAR, v_birth_date, CURDATE()) BETWEEN 20 AND 60 THEN SET v_age_score = 15;
    ELSE SET v_age_score = 10;
    END IF;
    
    -- Business Type Score (0-20 points)
    IF v_business_type = 'pedagang_pasar' THEN SET v_business_score = 15;
    ELSEIF v_business_type = 'warung' THEN SET v_business_score = 18;
    ELSEIF v_business_type = 'toko' THEN SET v_business_score = 20;
    ELSE SET v_business_score = 10;
    END IF;
    
    -- Family Score (0-20 points)
    IF v_marital_status = 'Menikah' AND v_number_of_children <= 2 THEN SET v_family_score = 20;
    ELSEIF v_marital_status = 'Menikah' AND v_number_of_children <= 4 THEN SET v_family_score = 15;
    ELSEIF v_marital_status = 'Belum Menikah' THEN SET v_family_score = 18;
    ELSE SET v_family_score = 10;
    END IF;
    
    -- Document Score (0-10 points)
    SELECT COUNT(*) * 2 INTO v_document_score
    FROM document_uploads 
    WHERE person_id = p_person_id AND is_verified = 1;
    
    IF v_document_score > 10 THEN SET v_document_score = 10; END IF;
    
    -- Calculate Total Score
    SET v_score = v_income_score + v_age_score + v_business_score + v_family_score + v_document_score;
    
    -- Update person record
    UPDATE persons 
    SET credit_score = v_score,
        risk_level = CASE 
            WHEN v_score >= 80 THEN 'Rendah'
            WHEN v_score >= 60 THEN 'Sedang'
            ELSE 'Tinggi'
        END
    WHERE id = p_person_id;
    
    -- Insert into assessment history
    INSERT INTO risk_assessment_history 
    (person_id, assessment_date, credit_score, risk_level, assessed_by)
    VALUES (p_person_id, CURDATE(), v_score, 
            CASE WHEN v_score >= 80 THEN 'Rendah' WHEN v_score >= 60 THEN 'Sedang' ELSE 'Tinggi' END, 
            1);
    
    SELECT v_score as credit_score, 
           CASE WHEN v_score >= 80 THEN 'Rendah' WHEN v_score >= 60 THEN 'Sedang' ELSE 'Tinggi' END as risk_level;
    
END$$

-- Verify Person Data
CREATE PROCEDURE IF NOT EXISTS VerifyPerson(IN p_person_id INT, IN p_user_id INT, IN p_notes TEXT)
BEGIN
    DECLARE v_verification_count INT DEFAULT 0;
    
    -- Count verified documents
    SELECT COUNT(*) INTO v_verification_count
    FROM document_uploads 
    WHERE person_id = p_person_id AND is_verified = 1;
    
    -- Update verification status
    UPDATE persons 
    SET verification_status = CASE 
            WHEN v_verification_count >= 3 THEN 'Verified'
            ELSE 'Pending'
        END,
        verification_date = CASE 
            WHEN v_verification_count >= 3 THEN CURRENT_TIMESTAMP 
            ELSE NULL 
        END,
        verified_by = CASE 
            WHEN v_verification_count >= 3 THEN p_user_id 
            ELSE NULL 
        END
    WHERE id = p_person_id;
    
    -- Insert verification history
    INSERT INTO verification_history 
    (person_id, verification_type, verification_status, verified_by, notes)
    VALUES (p_person_id, 'Data_Diri', 
            CASE WHEN v_verification_count >= 3 THEN 'Verified' ELSE 'Pending' END, 
            p_user_id, p_notes);
    
    SELECT verification_status, v_verification_count as verified_documents;
END$$

DELIMITER ;

-- ================================================================
-- TRIGGERS
-- ================================================================

DELIMITER $$

-- Trigger to update risk assessment when person data changes
CREATE TRIGGER IF NOT EXISTS tr_person_update_risk
AFTER UPDATE ON persons
FOR EACH ROW
BEGIN
    IF NEW.monthly_income <> OLD.monthly_income OR 
       NEW.business_type <> OLD.business_type OR 
       NEW.marital_status <> OLD.marital_status OR
       NEW.number_of_children <> OLD.number_of_children THEN
        CALL CalculateCreditScore(NEW.id);
    END IF;
END$$

DELIMITER ;

-- ================================================================
-- SAMPLE DATA INSERTION
-- ================================================================

-- Sample Person Data
INSERT INTO persons (
    nik, kk_number, name, birth_place, birth_date, gender, religion,
    phone, whatsapp, email, address_detail, rt, rw, postal_code,
    occupation, workplace, monthly_income, business_type,
    marital_status, spouse_name, number_of_children, npwp,
    bpjs_kesehatan, credit_score, risk_level, verification_status
) VALUES 
('3201011234560001', '3201011234560001', 'Ahmad Sudirman', 'Jakarta', '1985-05-15', 'L', 'Islam',
 '08123456789', '08123456789', 'ahmad@email.com', 'Jl. Merdeka No. 123', '001', '002', '12345',
 'Pedagang Pasar', 'Pasar Senen', 3000000, 'pedagang_pasar',
 'Menikah', 'Siti Nurhaliza', 2, '123456789012345',
 '0001234567890', 75, 'Sedang', 'Verified'),

('3201011234560002', '3201011234560002', 'Siti Nurhaliza', 'Bandung', '1988-08-20', 'P', 'Islam',
 '08234567890', '08234567890', 'siti@email.com', 'Jl. Sudirman No. 456', '003', '004', '54321',
 'Warung Kelontong', 'Warung Siti', 2500000, 'warung',
 'Menikah', 'Ahmad Sudirman', 2, '234567890123456',
    '0002345678901', 70, 'Sedang', 'Verified');

-- Sample Family Links
INSERT INTO family_links (person1_id, person2_id, relationship, is_primary, verification_status) VALUES
(1, 2, 'suami_istri', TRUE, 'Verified');

-- Sample Business Information
INSERT INTO business_information (person_id, business_name, business_type, business_category, business_address, start_date, monthly_revenue, monthly_expense, has_employees, number_of_employees) VALUES
(1, 'Toko Ahmad', 'pedagang_pasar', 'Semako', 'Pasar Senen Blok A No. 10', '2020-01-01', 5000000, 2000000, TRUE, 2),
(2, 'Warung Siti', 'warung_kelontong', 'Kelontong', 'Jl. Sudirman No. 456', '2019-06-15', 4000000, 1500000, FALSE, 0);

-- Sample Bank Accounts
INSERT INTO bank_accounts (person_id, bank_name, account_number, account_name, account_type, is_primary) VALUES
(1, 'BCA', '1234567890', 'Ahmad Sudirman', 'Tabungan', TRUE),
(2, 'Mandiri', '0987654321', 'Siti Nurhaliza', 'Tabungan', TRUE);

-- Sample Document Uploads
INSERT INTO document_uploads (person_id, document_type, document_number, file_path, file_name, file_type, is_verified) VALUES
(1, 'KTP', '3201011234560001', '/uploads/ktp/3201011234560001.jpg', 'KTP_Ahmad.jpg', 'JPG', TRUE),
(1, 'KK', '3201011234560001', '/uploads/kk/3201011234560001.jpg', 'KK_Ahmad.jpg', 'JPG', TRUE),
(1, 'NPWP', '123456789012345', '/uploads/npwp/123456789012345678.jpg', 'NPWP_Ahmad.jpg', 'JPG', TRUE),
(2, 'KTP', '3201011234560002', '/uploads/ktp/3201011234560002.jpg', 'KTP_Siti.jpg', 'JPG', TRUE),
(2, 'KK', '3201011234560002', '/uploads/kk/3201011234560002.jpg', 'KK_Siti.jpg', 'JPG', TRUE),
(2, 'NPWP', '234567890123456', '/uploads/npwp/234567890123456.jpg', 'NPWP_Siti.jpg', 'JPG', TRUE);

-- ================================================================
-- SETUP COMPLETE
-- ================================================================

SELECT 'Schema Person setup completed successfully!' as status;
SELECT COUNT(*) as total_persons FROM persons;
SELECT COUNT(*) as total_family_links FROM family_links;
SELECT COUNT(*) as total_business_info FROM business_information;
SELECT COUNT(*) as total_bank_accounts FROM bank_accounts;
SELECT COUNT(*) as total_documents FROM document_uploads;
