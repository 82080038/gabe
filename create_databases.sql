-- ================================================================
-- SETUP DATABASE APLIKASI KOPERASI BERJALAN
-- Total: 3 Database (schema_person, alamat_db, schema_app)
-- ================================================================

-- ================================================================
-- 1. CREATE DATABASES
-- ================================================================

-- Database untuk data personal dan hubungan keluarga
CREATE DATABASE IF NOT EXISTS schema_person 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Database untuk data alamat (rename dari alamat_db ke schema_address)
-- NOTE: alamat_db sudah ada, kita akan rename ke schema_address
-- Database untuk aplikasi dan transaksi
CREATE DATABASE IF NOT EXISTS schema_app 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- ================================================================
-- 2. SETUP SCHEMA_PERSON
-- ================================================================

USE schema_person;

-- Tabel persons (data personal anggota)
CREATE TABLE IF NOT EXISTS persons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nik VARCHAR(16) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15),
    email VARCHAR(100),
    photo_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_nik (nik),
    INDEX idx_name (name),
    INDEX idx_phone (phone)
);

-- Tabel family_links (hubungan keluarga untuk deteksi risiko)
CREATE TABLE IF NOT EXISTS family_links (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person1_id INT NOT NULL,
    person2_id INT NOT NULL,
    relationship ENUM('suami_istri', 'orang_tua_anak', 'saudara_kandung', 'lainnya') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person1_id) REFERENCES persons(id) ON DELETE CASCADE,
    FOREIGN KEY (person2_id) REFERENCES persons(id) ON DELETE CASCADE,
    INDEX idx_person1 (person1_id),
    INDEX idx_person2 (person2_id),
    INDEX idx_relationship (relationship)
);

-- ================================================================
-- 3. SETUP ALAMAT_DB (Import dari file alamat_db.sql)
-- ================================================================

-- Import data alamat Indonesia yang sudah ada
-- NOTE: Jalankan perintah ini di command line:
-- mysql -u root -p alamat_db < /opt/lampp/htdocs/gabe/alamat_db.sql

-- ================================================================
-- 4. SETUP SCHEMA_APP
-- ================================================================

USE schema_app;

-- Tabel units (unit organisasi)
CREATE TABLE IF NOT EXISTS units (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    head_user_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_code (code),
    INDEX idx_active (is_active)
);

-- Tabel branches (cabang koperasi)
CREATE TABLE IF NOT EXISTS branches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    unit_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    head_user_id INT,
    address_id INT,
    phone VARCHAR(15),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (unit_id) REFERENCES units(id),
    -- FOREIGN KEY (address_id) REFERENCES schema_address.addresses(id),
    INDEX idx_unit (unit_id),
    INDEX idx_code (code),
    INDEX idx_active (is_active)
);

-- Tabel users (user management dengan role-based access)
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    person_id INT NOT NULL,
    branch_id INT,
    role ENUM('bos', 'unit_head', 'branch_head', 'collector', 'cashir', 'member') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES schema_person.persons(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    INDEX idx_username (username),
    INDEX idx_role (role),
    INDEX idx_branch (branch_id),
    INDEX idx_active (is_active)
);

-- Tabel members (data anggota koperasi)
CREATE TABLE IF NOT EXISTS members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL UNIQUE,
    member_number VARCHAR(20) UNIQUE NOT NULL,
    branch_id INT NOT NULL,
    join_date DATE NOT NULL,
    status ENUM('active', 'inactive', 'blacklisted') DEFAULT 'active',
    max_active_loans INT DEFAULT 2,
    max_loan_amount DECIMAL(12,2) DEFAULT 10000000,
    current_active_loans INT DEFAULT 0,
    current_total_loans DECIMAL(12,2) DEFAULT 0,
    current_late_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (person_id) REFERENCES schema_person.persons(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    INDEX idx_member_number (member_number),
    INDEX idx_branch_status (branch_id, status),
    INDEX idx_join_date (join_date)
);

-- Tabel loan_products (produk pinjaman)
CREATE TABLE IF NOT EXISTS loan_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    min_amount DECIMAL(12,2) NOT NULL,
    max_amount DECIMAL(12,2) NOT NULL,
    min_tenor_days INT NOT NULL,
    max_tenor_days INT NOT NULL,
    interest_rate_monthly DECIMAL(5,4) NOT NULL,
    admin_fee_rate DECIMAL(5,4) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_active (is_active)
);

-- Tabel loans (data pinjaman)
CREATE TABLE IF NOT EXISTS loans (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    product_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    admin_fee DECIMAL(12,2) NOT NULL,
    net_disbursed DECIMAL(12,2) NOT NULL,
    interest_rate_monthly DECIMAL(5,4) NOT NULL,
    installment_amount DECIMAL(10,2) NOT NULL,
    frequency ENUM('daily', 'weekly') DEFAULT 'daily',
    total_installments INT NOT NULL,
    paid_installments INT DEFAULT 0,
    disbursement_date DATE,
    first_payment_date DATE,
    status ENUM('proposed', 'approved', 'disbursed', 'completed', 'defaulted') DEFAULT 'proposed',
    approved_by INT,
    approved_at TIMESTAMP NULL,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (product_id) REFERENCES loan_products(id),
    FOREIGN KEY (approved_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_member_status (member_id, status),
    INDEX idx_disbursement_date (disbursement_date),
    INDEX idx_status (status),
    INDEX idx_created_by (created_by)
);

-- Tabel loan_schedules (jadwal angsuran)
CREATE TABLE IF NOT EXISTS loan_schedules (
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
    payment_type ENUM('cash', 'transfer', 'waived'),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE,
    FOREIGN KEY (collector_id) REFERENCES users(id),
    INDEX idx_due_date_status (due_date, status),
    INDEX idx_collector (collector_id),
    INDEX idx_paid_date (paid_date)
);

-- Tabel savings_products (produk simpanan)
CREATE TABLE IF NOT EXISTS savings_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    product_type ENUM('kewer', 'mawar', 'sukarela') NOT NULL,
    min_deposit DECIMAL(10,2) NOT NULL,
    interest_rate_monthly DECIMAL(5,4) NOT NULL,
    min_tenor_months INT,
    max_tenor_months INT,
    withdrawal_penalty_days INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_product_type (product_type),
    INDEX idx_active (is_active)
);

-- Tabel savings_accounts (rekening simpanan)
CREATE TABLE IF NOT EXISTS savings_accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    product_id INT NOT NULL,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    target_daily_amount DECIMAL(10,2),
    start_date DATE NOT NULL,
    end_date DATE,
    interest_rate_monthly DECIMAL(5,4) NOT NULL,
    status ENUM('active', 'completed', 'paused', 'closed') DEFAULT 'active',
    current_balance DECIMAL(12,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (product_id) REFERENCES savings_products(id),
    INDEX idx_member_product (member_id, product_id),
    INDEX idx_account_number (account_number),
    INDEX idx_status (status)
);

-- Tabel savings_deposits (setoran simpanan)
CREATE TABLE IF NOT EXISTS savings_deposits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    deposit_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    collector_id INT,
    payment_type ENUM('cash', 'transfer') DEFAULT 'cash',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (account_id) REFERENCES savings_accounts(id),
    FOREIGN KEY (collector_id) REFERENCES users(id),
    INDEX idx_account_date (account_id, deposit_date),
    INDEX idx_collector (collector_id),
    INDEX idx_deposit_date (deposit_date)
);

-- Tabel cash_balances (saldo kas harian)
CREATE TABLE IF NOT EXISTS cash_balances (
    id INT PRIMARY KEY AUTO_INCREMENT,
    branch_id INT NOT NULL,
    balance_date DATE NOT NULL,
    opening_balance DECIMAL(15,2) NOT NULL,
    cash_in DECIMAL(15,2) DEFAULT 0,
    cash_out DECIMAL(15,2) DEFAULT 0,
    closing_balance DECIMAL(15,2) NOT NULL,
    collector_cash_handled DECIMAL(15,2) DEFAULT 0,
    status ENUM('draft', 'verified', 'locked') DEFAULT 'draft',
    verified_by INT,
    verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (verified_by) REFERENCES users(id),
    UNIQUE KEY uk_branch_date (branch_id, balance_date),
    INDEX idx_status (status),
    INDEX idx_balance_date (balance_date)
);

-- Tabel audit_logs (log aktivitas)
CREATE TABLE IF NOT EXISTS audit_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(50),
    record_id INT,
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_user_date (user_id, created_at),
    INDEX idx_action (action),
    INDEX idx_table_record (table_name, record_id)
);

-- ================================================================
-- 5. ACCOUNTING TABLES (SAK ETAP Compliant)
-- ================================================================

-- Tabel accounts (chart of accounts)
CREATE TABLE IF NOT EXISTS accounts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_code VARCHAR(20) NOT NULL UNIQUE,
    account_name VARCHAR(100) NOT NULL,
    account_type ENUM('aset', 'kewajiban', 'ekuitas', 'pendapatan', 'beban') NOT NULL,
    parent_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (parent_id) REFERENCES accounts(id),
    INDEX idx_code (account_code),
    INDEX idx_type (account_type),
    INDEX idx_active (is_active)
);

-- Tabel journals (jurnal umum)
CREATE TABLE IF NOT EXISTS journals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    journal_date DATE NOT NULL,
    description TEXT,
    reference_type VARCHAR(50),
    reference_id INT,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_date (journal_date),
    INDEX idx_reference (reference_type, reference_id),
    INDEX idx_created_by (created_by)
);

-- Tabel journal_details (detail jurnal)
CREATE TABLE IF NOT EXISTS journal_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    journal_id INT NOT NULL,
    account_id INT NOT NULL,
    debit DECIMAL(15,2) DEFAULT 0,
    credit DECIMAL(15,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (journal_id) REFERENCES journals(id) ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts(id),
    INDEX idx_journal (journal_id),
    INDEX idx_account (account_id),
    INDEX idx_account_debit (account_id, debit),
    INDEX idx_account_credit (account_id, credit)
);

-- ================================================================
-- 6. ADDITIONAL TABLES FOR KOPERASI BERJALAN
-- ================================================================

-- Tabel fraud_alerts (deteksi fraud)
CREATE TABLE IF NOT EXISTS fraud_alerts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    collector_id INT NOT NULL,
    alert_date DATE NOT NULL,
    anomaly_types JSON,
    details JSON,
    severity ENUM('low', 'medium', 'high'),
    status ENUM('pending', 'investigating', 'resolved') DEFAULT 'pending',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (collector_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    INDEX idx_collector_date (collector_id, alert_date),
    INDEX idx_severity (severity),
    INDEX idx_status (status)
);

-- Tabel ppatk_reportable_transactions (PPATK reporting)
CREATE TABLE IF NOT EXISTS ppatk_reportable_transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_type ENUM('cash_in', 'cash_out') NOT NULL,
    cumulative_amount DECIMAL(15,2) NOT NULL,
    reported BOOLEAN DEFAULT FALSE,
    reported_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (member_id) REFERENCES members(id),
    INDEX idx_member_date (member_id, transaction_date),
    INDEX idx_cumulative (cumulative_amount),
    INDEX idx_reported (reported)
);

-- Tabel notifications (notifikasi user)
CREATE TABLE IF NOT EXISTS notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('info', 'warning', 'error', 'success') DEFAULT 'info',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_user_read (user_id, is_read),
    INDEX idx_type (type),
    INDEX idx_created_at (created_at)
);

-- ================================================================
-- 7. VIEWS FOR REPORTING
-- ================================================================

-- View portfolio anggota
CREATE OR REPLACE VIEW member_portfolio_view AS
SELECT 
    m.id, m.member_number, p.name, p.phone,
    b.name as branch_name,
    COUNT(l.id) as active_loans,
    COALESCE(SUM(l.amount), 0) as total_loans,
    COUNT(sa.id) as savings_accounts,
    COALESCE(SUM(sa.current_balance), 0) as total_savings,
    m.status as member_status,
    m.join_date
FROM members m
JOIN schema_person.persons p ON m.person_id = p.id
JOIN branches b ON m.branch_id = b.id
LEFT JOIN loans l ON m.id = l.member_id AND l.status = 'disbursed'
LEFT JOIN savings_accounts sa ON m.id = sa.member_id AND sa.status = 'active'
GROUP BY m.id;

-- View collection harian
CREATE OR REPLACE VIEW daily_collection_view AS
SELECT 
    DATE(ls.paid_date) as collection_date,
    b.name as branch_name,
    u.name as collector_name,
    COUNT(ls.id) as payments_count,
    COALESCE(SUM(ls.paid_amount), 0) as total_collected,
    COUNT(DISTINCT l.member_id) as unique_members
FROM loan_schedules ls
JOIN loans l ON ls.loan_id = l.id
JOIN members m ON l.member_id = m.id
JOIN branches b ON m.branch_id = b.id
LEFT JOIN users u ON ls.collector_id = u.id
WHERE ls.paid_date IS NOT NULL
GROUP BY DATE(ls.paid_date), b.id, ls.collector_id;

-- View NPL analysis
CREATE OR REPLACE VIEW npl_analysis_view AS
SELECT 
    b.name as branch_name,
    COUNT(l.id) as total_loans,
    COUNT(CASE WHEN l.status = 'defaulted' THEN 1 END) as defaulted_loans,
    COUNT(CASE WHEN ls.status = 'late' AND DATEDIFF(CURDATE(), ls.due_date) > 90 THEN 1 END) as npl_loans,
    ROUND(
        (COUNT(CASE WHEN ls.status = 'late' AND DATEDIFF(CURDATE(), ls.due_date) > 90 THEN 1 END) * 100.0) / 
        COUNT(l.id), 2
    ) as npl_ratio
FROM branches b
LEFT JOIN members m ON b.id = m.branch_id
LEFT JOIN loans l ON m.id = l.member_id
LEFT JOIN loan_schedules ls ON l.id = ls.loan_id
GROUP BY b.id;

-- ================================================================
-- 8. STORED PROCEDURES
-- ================================================================

DELIMITER $$

-- Procedure hitung risiko anggota
CREATE PROCEDURE IF NOT EXISTS CalculateMemberRisk(IN p_member_id INT)
BEGIN
    DECLARE v_risk_score INT DEFAULT 0;
    DECLARE v_late_count INT DEFAULT 0;
    DECLARE v_family_defaulted INT DEFAULT 0;
    
    -- Hitung tunggakan
    SELECT COUNT(*) INTO v_late_count
    FROM loan_schedules ls
    JOIN loans l ON ls.loan_id = l.id
    WHERE l.member_id = p_member_id 
    AND ls.status = 'late';
    
    -- Hitung keluarga yang macet
    SELECT COUNT(*) INTO v_family_defaulted
    FROM family_links fl
    JOIN loans l ON (fl.person2_id = (SELECT person_id FROM members WHERE id = p_member_id))
    WHERE l.status = 'defaulted';
    
    -- Calculate risk score
    SET v_risk_score = (v_late_count * 3) + (v_family_defaulted * 5);
    
    -- Update member risk level
    UPDATE members 
    SET current_late_count = v_late_count,
        max_loan_amount = CASE 
            WHEN v_risk_score >= 10 THEN 2000000
            WHEN v_risk_score >= 5 THEN 5000000
            ELSE 10000000
        END
    WHERE id = p_member_id;
    
    SELECT v_risk_score as risk_score;
END$$

-- Procedure generate laporan harian
CREATE PROCEDURE IF NOT EXISTS GenerateDailyCollectionReport(IN p_date DATE, IN p_branch_id INT)
BEGIN
    SELECT 
        b.name as branch_name,
        COUNT(DISTINCT ls.collector_id) as active_collectors,
        COUNT(ls.id) as total_payments,
        COALESCE(SUM(ls.paid_amount), 0) as total_collected,
        COUNT(DISTINCT l.member_id) as unique_members,
        COUNT(CASE WHEN ls.status = 'late' THEN 1 END) as late_payments
    FROM branches b
    LEFT JOIN members m ON b.id = m.branch_id
    LEFT JOIN loans l ON m.id = l.member_id
    LEFT JOIN loan_schedules ls ON l.id = ls.loan_id AND DATE(ls.paid_date) = p_date
    WHERE b.id = p_branch_id
    GROUP BY b.id;
END$$

DELIMITER ;

-- ================================================================
-- 9. TRIGGERS FOR AUTOMATION
-- ================================================================

DELIMITER $$

-- Trigger update member loan stats
CREATE TRIGGER IF NOT EXISTS update_member_loan_stats
AFTER INSERT ON loan_schedules
FOR EACH ROW
BEGIN
    IF NEW.status = 'paid' THEN
        UPDATE loans 
        SET paid_installments = paid_installments + 1
        WHERE id = NEW.loan_id;
        
        -- Update member stats
        UPDATE members m
        SET current_active_loans = (
            SELECT COUNT(*) 
            FROM loans l 
            WHERE l.member_id = m.id AND l.status = 'disbursed'
        ),
        current_total_loans = (
            SELECT COALESCE(SUM(l.amount), 0)
            FROM loans l 
            WHERE l.member_id = m.id AND l.status = 'disbursed'
        )
        WHERE m.id = (SELECT member_id FROM loans WHERE id = NEW.loan_id);
    END IF;
END$$

DELIMITER ;

-- ================================================================
-- 10. INSERT INITIAL DATA
-- ================================================================

-- Default Chart of Accounts (SAK ETAP)
INSERT IGNORE INTO accounts (account_code, account_name, account_type) VALUES
('1000', 'AKTIVA LANCAR', 'aset'),
('1010', 'Kas', 'aset'),
('1020', 'Bank', 'aset'),
('1100', 'Piutang Pinjaman Mikro', 'aset'),
('1200', 'Penyisihan Piutang Ragu-ragu', 'aset'),
('2000', 'KEWAJIBAN LANCAR', 'kewajiban'),
('2100', 'Simpanan Anggota', 'kewajiban'),
('2200', 'Hutang Bank', 'kewajiban'),
('3000', 'EKUITAS', 'ekuitas'),
('3100', 'Simpanan Pokok', 'ekuitas'),
('3200', 'Simpanan Wajib', 'ekuitas'),
('3300', 'Sisa Hasil Usaha', 'ekuitas'),
('4000', 'PENDAPATAN', 'pendapatan'),
('4010', 'Pendapatan Bunga Pinjaman', 'pendapatan'),
('4020', 'Pendapatan Admin Fee', 'pendapatan'),
('5000', 'BEBAN', 'beban'),
('5010', 'Beban Bunga Simpanan', 'beban'),
('5020', 'Beban Operasional', 'beban');

-- Default Loan Products
INSERT IGNORE INTO loan_products (name, min_amount, max_amount, min_tenor_days, max_tenor_days, interest_rate_monthly, admin_fee_rate) VALUES
('Pinjaman Mikro', 500000, 5000000, 30, 90, 0.0300, 0.0200),
('Pinjaman Kecil', 5000000, 10000000, 60, 180, 0.0250, 0.0150);

-- Default Savings Products
INSERT IGNORE INTO savings_products (name, product_type, min_deposit, interest_rate_monthly, min_tenor_months, max_tenor_months) VALUES
('Kewer Harian', 'kewer', 5000, 0.0080, 6, 24),
('Mawar Bulanan', 'mawar', 100000, 0.0100, 12, 36),
('Sukarela', 'sukarela', 10000, 0.0090, NULL, NULL);

-- ================================================================
-- SETUP COMPLETE
-- ================================================================

SELECT 'Database setup completed successfully!' as status;
