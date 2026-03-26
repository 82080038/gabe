# PANDUAN LENGKAP
## Aplikasi Koperasi Berjalan (Kewer-Mawar) Sempurna

---

## DAFTAR ISI

1. [Pengertian Konsep Koperasi Berjalan](#1-pengertian-konsep-koperasi-berjalan)
2. [Karakteristik Bisnis Kewer-Mawar](#2-karakteristik-bisnis-kewer-mawar)
3. [Arsitektur Sistem Lengkap](#3-arsitektur-sistem-lengkap)
4. [Database Design Komprehensif](#4-database-design-komprehensif)
5. [Implementasi Fitur Utama](#5-implementasi-fitur-utama)
6. [Mobile Collector App](#6-mobile-collector-app)
7. [Sistem Keuangan & Akuntansi](#7-sistem-keuangan--akuntansi)
8. [Risk Management & Fraud Prevention](#8-risk-management--fraud-prevention)
9. [Regulasi & Kepatuhan](#9-regulasi--kepatuhan)
10. [Deployment & Maintenance](#10-deployment--maintenance)
11. [Panduan Implementasi Bertahap](#11-panduan-implementasi-bertahap)

---

## 1. Pengertian Konsep Koperasi Berjalan

### 1.1 Definisi
**Koperasi Berjalan** adalah koperasi simpan pinjam yang:
- Beroperasi dengan sistem **door-to-door collection**
- Kolektor (AO) mengunjungi anggota setiap hari
- Fokus pada **simpanan harian (kewer)** dan **pinjaman mikro**
- Target pasar: pedagang pasar, warung, UMKM kecil
- Volume transaksi tinggi dengan nilai kecil

### 1.2 Istilah Umum
- **Kewer**: Simpanan harian rutin (Rp5.000-50.000/hari)
- **Mawar**: Simpanan berjangka bulanan (Rp100.000-1.000.000/bulan)
- **AO (Account Officer)**: Petugas kolektor lapangan
- **Koperasi Pasar (Koppas)**: Koperasi untuk pedagang pasar

### 1.3 Target Market
| Jenis Usaha | Contoh | Penghasilan/Bulan | Kebutuhan Pinjaman |
|-------------|--------|-------------------|-------------------|
| Pedagang Pasar | Sayur, ikan, bumbu | Rp2-5 juta | Rp1-5 juta |
| Warung Kelontong | Sembako, rokok | Rp3-6 juta | Rp2-8 juta |
| Usaha Jasa Kecil | Tambal ban, fotokopi | Rp2,5-4 juta | Rp1-3 juta |
| Kuliner | Warteg, kopi | Rp3-7 juta | Rp2-6 juta |

---

## 2. Karakteristik Bisnis Kewer-Mawar

### 2.1 Skala Operasional
```
Per Cabang Kecil (Perdesaan):
- Anggota aktif: 300-500 orang
- Transaksi/hari: 200-400 transaksi
- Pinjaman aktif: 100-200 pinjaman
- Total portfolio: Rp100-300 juta
- Kolektor: 2-3 orang

Per Cabang Sedang (Kota):
- Anggota aktif: 800-1.500 orang
- Transaksi/hari: 500-800 transaksi
- Pinjaman aktif: 300-600 pinjaman
- Total portfolio: Rp500 juta - 1,5 miliar
- Kolektor: 5-8 orang
```

### 2.2 Produk Pinjaman
| Jenis | Jumlah | Tenor | Angsuran | Suku Bunga |
|-------|--------|-------|----------|------------|
| Pinjaman Mikro | Rp500rb-5jt | 30-90 hari | Rp20rb-100rb/hari | 1-3%/bulan flat |
| Pinjaman Kecil | Rp5jt-10jt | 90-180 hari | Rp100rb-300rb/hari | 2-4%/bulan flat |
| Modal Usaha | Rp10jt-25jt | 180-360 hari | Rp200rb-500rb/hari | 2,5-4,5%/bulan flat |

### 2.3 Produk Simpanan
| Jenis | Setoran | Imbal Hasil | Jangka Waktu |
|-------|---------|-------------|--------------|
| Kewer Harian | Rp5rb-50rb/hari | 0,5-1%/bulan | 6-24 bulan |
| Mawar Bulanan | Rp100rb-1jt/bulan | 1-1,5%/bulan | 12-36 bulan |
| Simpanan Sukarela | Bebas | 0,8-1,2%/bulan | Cair kapan saja |

---

## 3. Arsitektur Sistem Lengkap

### 3.1 Stack Teknologi
```
Frontend:
- Web: HTML5, Bootstrap 5, jQuery 3.7
- Mobile: Progressive Web App (PWA)
- Dashboard: Chart.js, DataTables

Backend:
- Language: PHP 8.2+ (Native, tidak Framework)
- API: RESTful dengan JSON response
- Session: PHP Sessions + JWT untuk mobile

Database:
- MySQL 8.0+ dengan InnoDB
- Multi-schema: person, address, app
- Backup: Daily full + incremental

Infrastructure:
- Web Server: Apache/Nginx
- PHP-FPM untuk performa
- Redis untuk cache
- File Storage: Local + Cloud backup
```

### 3.2 Struktur Folder
```
/opt/lampp/htdocs/gabe/
├── api/                    # REST API endpoints
│   ├── auth/              # Authentication
│   ├── members/           # Member management
│   ├── loans/             # Loan operations
│   ├── savings/           # Savings operations
│   ├── collector/         # Collector operations
│   ├── reports/           # Report generation
│   └── accounting/        # Accounting operations
├── pages/                  # Frontend pages
│   ├── dashboard/          # Admin dashboard
│   ├── members/           # Member pages
│   ├── loans/             # Loan pages
│   ├── savings/           # Savings pages
│   ├── reports/           # Report pages
│   └── settings/          # System settings
├── assets/                 # Static assets
│   ├── css/               # Stylesheets
│   ├── js/                # JavaScript
│   ├── images/            # Images
│   └── vendor/           # Third-party libraries
├── config/                 # Configuration files
│   ├── database.php       # Database connection
│   ├── config.php         # System configuration
│   └── functions.php      # Helper functions
├── mobile/                 # PWA for collectors
│   ├── manifest.json       # PWA manifest
│   ├── sw.js              # Service worker
│   ├── index.html         # Mobile app shell
│   └── assets/            # Mobile assets
├── uploads/                # File uploads
│   ├── members/           # Member photos
│   ├── loans/             # Loan documents
│   └── receipts/          # Payment receipts
└── logs/                   # Application logs
```

### 3.3 Multi-User Roles
```
BOS (Super Admin):
- Manage all units and branches
- View consolidated reports
- Set global parameters
- Manage system users

Unit Head:
- Manage multiple branches
- Approve large loans
- View unit-level reports
- Manage branch heads

Branch Head:
- Manage single branch
- Approve medium loans
- Manage collectors
- View branch reports

Collector (AO):
- Daily route management
- Record payments
- Member visitation
- Mobile app access

Cashier:
- Process cash transactions
- Daily reconciliation
- Verify payments
- Manage cash balance

Member:
- View own transactions
- Request loans
- Check balances
- Mobile access (optional)
```

---

## 4. Database Design Komprehensif

### 4.1 Schema Design
```sql
-- Schema Person
CREATE DATABASE schema_person;
USE schema_person;

CREATE TABLE persons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nik VARCHAR(16) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15),
    email VARCHAR(100),
    photo_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE family_links (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person1_id INT NOT NULL,
    person2_id INT NOT NULL,
    relationship ENUM('suami_istri', 'orang_tua_anak', 'saudara_kandung', 'lainnya'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person1_id) REFERENCES persons(id),
    FOREIGN KEY (person2_id) REFERENCES persons(id)
);

-- Schema Address
CREATE DATABASE schema_address;
USE schema_address;

CREATE TABLE provinces (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE regencies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    province_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    FOREIGN KEY (province_id) REFERENCES provinces(id)
);

CREATE TABLE districts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    regency_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    FOREIGN KEY (regency_id) REFERENCES regencies(id)
);

CREATE TABLE villages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    district_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    FOREIGN KEY (district_id) REFERENCES districts(id)
);

CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    village_id INT NOT NULL,
    address_detail TEXT,
    address_type ENUM('rumah', 'usaha', 'penagihan'),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    FOREIGN KEY (person_id) REFERENCES schema_person.persons(id),
    FOREIGN KEY (village_id) REFERENCES villages(id)
);

-- Schema App
CREATE DATABASE schema_app;
USE schema_app;

CREATE TABLE units (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    head_user_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE branches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    unit_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    head_user_id INT,
    address_id INT,
    phone VARCHAR(15),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (unit_id) REFERENCES units(id),
    FOREIGN KEY (address_id) REFERENCES schema_address.addresses(id)
);

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    person_id INT NOT NULL,
    branch_id INT,
    role ENUM('bos', 'unit_head', 'branch_head', 'collector', 'cashir', 'member') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES schema_person.persons(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id)
);

CREATE TABLE members (
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
    FOREIGN KEY (person_id) REFERENCES schema_person.persons(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id)
);

CREATE TABLE loan_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    min_amount DECIMAL(12,2) NOT NULL,
    max_amount DECIMAL(12,2) NOT NULL,
    min_tenor_days INT NOT NULL,
    max_tenor_days INT NOT NULL,
    interest_rate_monthly DECIMAL(5,4) NOT NULL,
    admin_fee_rate DECIMAL(5,4) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE loans (
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
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (product_id) REFERENCES loan_products(id),
    FOREIGN KEY (approved_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE loan_schedules (
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
    FOREIGN KEY (loan_id) REFERENCES loans(id),
    FOREIGN KEY (collector_id) REFERENCES users(id)
);

CREATE TABLE savings_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    product_type ENUM('kewer', 'mawar', 'sukarela') NOT NULL,
    min_deposit DECIMAL(10,2) NOT NULL,
    interest_rate_monthly DECIMAL(5,4) NOT NULL,
    min_tenor_months INT,
    max_tenor_months INT,
    withdrawal_penalty_days INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE savings_accounts (
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
    FOREIGN KEY (member_id) REFERENCES members(id),
    FOREIGN KEY (product_id) REFERENCES savings_products(id)
);

CREATE TABLE savings_deposits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    deposit_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    collector_id INT,
    payment_type ENUM('cash', 'transfer') DEFAULT 'cash',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES savings_accounts(id),
    FOREIGN KEY (collector_id) REFERENCES users(id)
);

CREATE TABLE cash_balances (
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
    FOREIGN KEY (verified_by) REFERENCES users(id)
);

CREATE TABLE audit_logs (
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
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

### 4.2 Indexing Strategy
```sql
-- Performance indexes
CREATE INDEX idx_loans_member_status ON loans(member_id, status);
CREATE INDEX idx_loan_schedules_due_date ON loan_schedules(due_date, status);
CREATE INDEX idx_savings_deposits_date ON savings_deposits(deposit_date, account_id);
CREATE INDEX idx_members_branch_status ON members(branch_id, status);
CREATE INDEX idx_audit_logs_user_date ON audit_logs(user_id, created_at);

-- Unique constraints
ALTER TABLE members ADD CONSTRAINT uk_member_number UNIQUE (member_number);
ALTER TABLE savings_accounts ADD CONSTRAINT uk_account_number UNIQUE (account_number);
```

---

## 5. Implementasi Fitur Utama

### 5.1 Authentication System
```php
<?php
// config/auth.php
// Konfigurasi Lokasi Indonesia
date_default_timezone_set('Asia/Jakarta');
setlocale(LC_ALL, 'id_ID.UTF8', 'id_ID.UTF-8', 'id_ID');

class Auth {
    private $pdo;
    
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
    public function login($username, $password, $remember = false) {
        $stmt = $this->pdo->prepare("
            SELECT u.*, p.name, p.photo_path, b.name as branch_name, r.role
            FROM users u
            JOIN persons p ON u.person_id = p.id
            LEFT JOIN branches b ON u.branch_id = b.id
            WHERE u.username = ? AND u.is_active = 1
        ");
        $stmt->execute([$username]);
        $user = $stmt->fetch();
        
        if ($user && password_verify($password, $user['password'])) {
            // Update last login
            $this->updateLastLogin($user['id']);
            
            // Set session
            $_SESSION['user'] = [
                'id' => $user['id'],
                'username' => $user['username'],
                'name' => $user['name'],
                'role' => $user['role'],
                'branch_id' => $user['branch_id'],
                'branch_name' => $user['branch_name'],
                'photo' => $user['photo_path']
            ];
            
            // Generate JWT for mobile
            if ($remember) {
                $_SESSION['jwt'] = $this->generateJWT($user);
            }
            
            return true;
        }
        
        return false;
    }
    
    public function checkRole($required_role) {
        $user_role = $_SESSION['user']['role'] ?? null;
        $role_hierarchy = [
            'member' => 1,
            'collector' => 2,
            'cashier' => 3,
            'branch_head' => 4,
            'unit_head' => 5,
            'bos' => 6
        ];
        
        return $role_hierarchy[$user_role] >= $role_hierarchy[$required_role];
    }
    
    private function generateJWT($user) {
        $payload = [
            'user_id' => $user['id'],
            'role' => $user['role'],
            'exp' => time() + (30 * 24 * 60 * 60) // 30 days
        ];
        
        return base64_encode(json_encode($payload));
    }
}
```

### 5.2 Loan Management System
```php
<?php
// api/loans/LoanService.php
class LoanService {
    private $pdo;
    
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
    public function applyLoan($data) {
        $this->pdo->beginTransaction();
        
        try {
            // Check member eligibility
            $eligibility = $this->checkEligibility($data['member_id'], $data['amount']);
            if (!$eligibility['eligible']) {
                throw new Exception($eligibility['reason']);
            }
            
            // Get product details
            $product = $this->getLoanProduct($data['product_id']);
            
            // Calculate loan details
            $loanDetails = $this->calculateLoan($data, $product);
            
            // Create loan
            $stmt = $this->pdo->prepare("
                INSERT INTO loans (
                    member_id, product_id, amount, admin_fee, net_disbursed,
                    interest_rate_monthly, installment_amount, frequency,
                    total_installments, first_payment_date, created_by
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ");
            
            $stmt->execute([
                $data['member_id'],
                $data['product_id'],
                $loanDetails['amount'],
                $loanDetails['admin_fee'],
                $loanDetails['net_disbursed'],
                $loanDetails['interest_rate_monthly'],
                $loanDetails['installment_amount'],
                $loanDetails['frequency'],
                $loanDetails['total_installments'],
                $loanDetails['first_payment_date'],
                $_SESSION['user']['id']
            ]);
            
            $loanId = $this->pdo->lastInsertId();
            
            // Generate payment schedule
            $this->generatePaymentSchedule($loanId, $loanDetails);
            
            // Update member limits
            $this->updateMemberLimits($data['member_id'], $data['amount'], 'increase');
            
            // Create accounting journal
            $this->createLoanJournal($loanId, $loanDetails);
            
            $this->pdo->commit();
            
            return ['success' => true, 'loan_id' => $loanId];
            
        } catch (Exception $e) {
            $this->pdo->rollBack();
            throw $e;
        }
    }
    
    public function checkEligibility($memberId, $requestedAmount) {
        $stmt = $this->pdo->prepare("
            SELECT m.*, COUNT(l.id) as active_loans, COALESCE(SUM(l.amount), 0) as total_loans,
                   COUNT(CASE WHEN ls.status = 'late' THEN 1 END) as late_count
            FROM members m
            LEFT JOIN loans l ON m.id = l.member_id AND l.status = 'disbursed'
            LEFT JOIN loan_schedules ls ON l.id = ls.loan_id AND ls.status = 'late'
            WHERE m.id = ? AND m.status = 'active'
            GROUP BY m.id
        ");
        $stmt->execute([$memberId]);
        $member = $stmt->fetch();
        
        if (!$member) {
            return ['eligible' => false, 'reason' => 'Member not found or inactive'];
        }
        
        if ($member['active_loans'] >= $member['max_active_loans']) {
            return ['eligible' => false, 'reason' => 'Maximum active loans reached'];
        }
        
        if (($member['total_loans'] + $requestedAmount) > $member['max_loan_amount']) {
            return ['eligible' => false, 'reason' => 'Maximum loan amount exceeded'];
        }
        
        if ($member['late_count'] >= 3) {
            return ['eligible' => false, 'reason' => 'Too many late payments'];
        }
        
        return ['eligible' => true];
    }
    
    private function calculateLoan($data, $product) {
        $amount = $data['amount'];
        $tenorDays = $data['tenor_days'];
        
        // Validate against product limits
        if ($amount < $product['min_amount'] || $amount > $product['max_amount']) {
            throw new Exception('Amount outside product limits');
        }
        
        if ($tenorDays < $product['min_tenor_days'] || $tenorDays > $product['max_tenor_days']) {
            throw new Exception('Tenor outside product limits');
        }
        
        $adminFee = $amount * ($product['admin_fee_rate'] / 100);
        $netDisbursed = $amount - $adminFee;
        
        // Calculate interest (flat rate)
        $monthlyInterest = $amount * ($product['interest_rate_monthly'] / 100);
        $dailyInterest = $monthlyInterest / 30;
        $totalInterest = $dailyInterest * $tenorDays;
        
        $totalPayment = $amount + $totalInterest;
        $installmentAmount = $totalPayment / $tenorDays;
        
        return [
            'amount' => $amount,
            'admin_fee' => $adminFee,
            'net_disbursed' => $netDisbursed,
            'interest_rate_monthly' => $product['interest_rate_monthly'],
            'installment_amount' => round($installmentAmount, 0),
            'frequency' => $data['frequency'] ?? 'daily',
            'total_installments' => $tenorDays,
            'first_payment_date' => date('Y-m-d', strtotime('+1 day'))
        ];
    }
    
    private function generatePaymentSchedule($loanId, $loanDetails) {
        $principalPerInstallment = $loanDetails['amount'] / $loanDetails['total_installments'];
        $interestPerInstallment = $loanDetails['installment_amount'] - $principalPerInstallment;
        
        for ($i = 1; $i <= $loanDetails['total_installments']; $i++) {
            $dueDate = date('Y-m-d', strtotime("+{$i} days", strtotime($loanDetails['first_payment_date'])));
            
            $stmt = $this->pdo->prepare("
                INSERT INTO loan_schedules (
                    loan_id, installment_number, due_date, principal_amount,
                    interest_amount, total_amount
                ) VALUES (?, ?, ?, ?, ?, ?)
            ");
            
            $stmt->execute([
                $loanId,
                $i,
                $dueDate,
                round($principalPerInstallment, 2),
                round($interestPerInstallment, 2),
                $loanDetails['installment_amount']
            ]);
        }
    }
}
```

### 5.3 Collector Daily Route System
```php
<?php
// api/collector/CollectorService.php
class CollectorService {
    private $pdo;
    
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
    public function getDailyRoute($collectorId, $date = null) {
        $date = $date ?? date('Y-m-d');
        
        $stmt = $this->pdo->prepare("
            SELECT 
                m.member_number,
                p.name,
                p.phone,
                a.address_detail,
                v.name as village,
                d.name as district,
                COALESCE(ls.total_amount, 0) as due_amount,
                COALESCE(sa.target_daily_amount, 0) as kewer_amount,
                l.id as loan_id,
                ls.id as schedule_id,
                ls.status as payment_status,
                a.latitude,
                a.longitude
            FROM users u
            JOIN members m ON u.id = ? AND u.branch_id = m.branch_id
            JOIN persons p ON m.person_id = p.id
            LEFT JOIN addresses a ON p.id = a.person_id AND a.address_type = 'usaha'
            LEFT JOIN villages v ON a.village_id = v.id
            LEFT JOIN districts d ON v.district_id = d.id
            LEFT JOIN loans l ON m.id = l.member_id AND l.status = 'disbursed'
            LEFT JOIN loan_schedules ls ON l.id = ls.loan_id AND ls.due_date = ?
            LEFT JOIN savings_accounts sa ON m.id = sa.member_id AND sa.status = 'active'
            WHERE m.status = 'active'
            ORDER BY 
                CASE WHEN ls.status = 'pending' THEN 1 ELSE 2 END,
                v.name, p.name
        ");
        
        $stmt->execute([$collectorId, $date]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    public function recordPayment($data) {
        $this->pdo->beginTransaction();
        
        try {
            // Record loan payment
            if (!empty($data['loan_schedule_id'])) {
                $stmt = $this->pdo->prepare("
                    UPDATE loan_schedules 
                    SET status = 'paid', paid_date = ?, paid_amount = ?, 
                        collector_id = ?, payment_type = ?, notes = ?
                    WHERE id = ? AND status = 'pending'
                ");
                $stmt->execute([
                    $data['payment_date'],
                    $data['amount'],
                    $_SESSION['user']['id'],
                    $data['payment_type'],
                    $data['notes'] ?? null,
                    $data['loan_schedule_id']
                ]);
                
                // Update loan progress
                $this->updateLoanProgress($data['loan_schedule_id']);
                
                // Create accounting entry
                $this->createPaymentJournal($data['loan_schedule_id'], $data['amount']);
            }
            
            // Record savings deposit
            if (!empty($data['savings_account_id'])) {
                $stmt = $this->pdo->prepare("
                    INSERT INTO savings_deposits (
                        account_id, deposit_date, amount, collector_id, 
                        payment_type, notes
                    ) VALUES (?, ?, ?, ?, ?, ?)
                ");
                $stmt->execute([
                    $data['savings_account_id'],
                    $data['payment_date'],
                    $data['amount'],
                    $_SESSION['user']['id'],
                    $data['payment_type'],
                    $data['notes'] ?? null
                ]);
                
                // Update savings balance
                $this->updateSavingsBalance($data['savings_account_id'], $data['amount']);
            }
            
            // Record location and photo evidence
            if (!empty($data['location'])) {
                $this->recordVisitLocation($data['member_id'], $data['location']);
            }
            
            if (!empty($data['photo_path'])) {
                $this->savePaymentPhoto($data['payment_id'], $data['photo_path']);
            }
            
            $this->pdo->commit();
            
            return ['success' => true, 'message' => 'Payment recorded successfully'];
            
        } catch (Exception $e) {
            $this->pdo->rollBack();
            throw $e;
        }
    }
    
    public function getDailySummary($collectorId, $date = null) {
        $date = $date ?? date('Y-m-d');
        
        $stmt = $this->pdo->prepare("
            SELECT 
                COUNT(CASE WHEN ls.status = 'paid' THEN 1 END) as loans_paid,
                COUNT(CASE WHEN ls.status = 'pending' THEN 1 END) as loans_pending,
                COALESCE(SUM(CASE WHEN ls.status = 'paid' THEN ls.paid_amount ELSE 0 END), 0) as total_loans_collected,
                COUNT(CASE WHEN sd.id IS NOT NULL THEN 1 END) as savings_deposits,
                COALESCE(SUM(CASE WHEN sd.id IS NOT NULL THEN sd.amount ELSE 0 END), 0) as total_savings_collected,
                (COALESCE(SUM(CASE WHEN ls.status = 'paid' THEN ls.paid_amount ELSE 0 END), 0) + 
                 COALESCE(SUM(CASE WHEN sd.id IS NOT NULL THEN sd.amount ELSE 0 END), 0)) as total_collected
            FROM users u
            LEFT JOIN loan_schedules ls ON u.id = ? AND ls.collector_id = u.id AND ls.paid_date = ?
            LEFT JOIN savings_deposits sd ON u.id = ? AND sd.collector_id = u.id AND sd.deposit_date = ?
            WHERE u.id = ?
        ");
        
        $stmt->execute([$collectorId, $date, $collectorId, $date, $collectorId]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}
```

---

## 6. Mobile Collector App

### 6.1 PWA Manifest
```json
{
  "name": "Koperasi Collector",
  "short_name": "KopCollector",
  "description": "Aplikasi mobile untuk kolektor koperasi",
  "start_url": "/mobile/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2c3e50",
  "icons": [
    {
      "src": "/mobile/assets/icons/icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/mobile/assets/icons/icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

### 6.2 Service Worker (Offline Support)
```javascript
// mobile/sw.js
const CACHE_NAME = 'kopcollector-v1';
const urlsToCache = [
    '/mobile/',
    '/mobile/index.html',
    '/mobile/assets/css/style.css',
    '/mobile/assets/js/app.js',
    '/mobile/assets/icons/icon-192x192.png'
];

self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(urlsToCache))
    );
});

self.addEventListener('fetch', event => {
    event.respondWith(
        caches.match(event.request)
            .then(response => {
                // Cache hit - return response
                if (response) {
                    return response;
                }

                return fetch(event.request).then(response => {
                    // Check if valid response
                    if(!response || response.status !== 200 || response.type !== 'basic') {
                        return response;
                    }

                    // Clone response
                    const responseToCache = response.clone();

                    caches.open(CACHE_NAME)
                        .then(cache => {
                            cache.put(event.request, responseToCache);
                        });

                    return response;
                });
            })
    );
});
```

### 6.3 Mobile App Interface
```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Koperasi Collector</title>
    <meta http-equiv="Content-Language" content="id">
    <meta name="language" content="Indonesian">
    <meta name="geo.country" content="ID">
    <meta name="geo.region" content="ID">
    <link rel="manifest" href="/mobile/manifest.json">
    <link href="/mobile/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="/mobile/assets/css/style.css" rel="stylesheet">
</head>
<body>
    <div id="app">
        <!-- Login Screen -->
        <div id="loginScreen" class="screen">
            <div class="login-container">
                <h2>Koperasi Collector</h2>
                <form id="loginForm">
                    <div class="form-group">
                        <input type="text" id="username" class="form-control" placeholder="Username" required>
                    </div>
                    <div class="form-group">
                        <input type="password" id="password" class="form-control" placeholder="Password" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Login</button>
                </form>
            </div>
        </div>

        <!-- Main Dashboard -->
        <div id="dashboardScreen" class="screen" style="display:none;">
            <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                <span class="navbar-brand">Koperasi Collector</span>
                <div class="navbar-nav ml-auto">
                    <span class="navbar-text" id="userName"></span>
                    <button class="btn btn-outline-light btn-sm ml-2" onclick="logout()">Logout</button>
                </div>
            </nav>

            <div class="container-fluid mt-3">
                <!-- Daily Summary -->
                <div class="card mb-3">
                    <div class="card-header">
                        <h5>Ringkasan Harian - <span id="todayDate"></span></h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-6">
                                <small>Total Dikunjungi</small>
                                <h4 id="totalVisited">0</h4>
                            </div>
                            <div class="col-6">
                                <small>Total Terkumpul</small>
                                <h4 id="totalCollected">Rp 0</h4>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Route List -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5>Rute Hari Ini</h5>
                        <button class="btn btn-sm btn-success" onclick="refreshRoute()">
                            <i class="fas fa-sync"></i> Refresh
                        </button>
                    </div>
                    <div class="card-body p-0">
                        <div id="routeList"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Screen -->
        <div id="paymentScreen" class="screen" style="display:none;">
            <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                <button class="btn btn-outline-light" onclick="backToDashboard()">
                    <i class="fas fa-arrow-left"></i> Kembali
                </button>
                <span class="navbar-brand">Pembayaran</span>
            </nav>

            <div class="container mt-3">
                <div class="card">
                    <div class="card-body">
                        <h5 id="memberName"></h5>
                        <p class="text-muted" id="memberAddress"></p>
                        
                        <!-- Loan Payment -->
                        <div id="loanPayment" class="payment-section">
                            <h6>Angsuran Pinjaman</h6>
                            <div class="form-group">
                                <label>Jumlah Tagihan</label>
                                <input type="text" id="loanDueAmount" class="form-control" readonly>
                            </div>
                            <div class="form-group">
                                <label>Dibayar</label>
                                <input type="number" id="loanPaidAmount" class="form-control" step="1000">
                            </div>
                        </div>

                        <!-- Savings Payment -->
                        <div id="savingsPayment" class="payment-section">
                            <h6>Setoran Kewer</h6>
                            <div class="form-group">
                                <label>Target Harian</label>
                                <input type="text" id="savingsTargetAmount" class="form-control" readonly>
                            </div>
                            <div class="form-group">
                                <label>Disetor</label>
                                <input type="number" id="savingsPaidAmount" class="form-control" step="1000">
                            </div>
                        </div>

                        <!-- Payment Method -->
                        <div class="form-group">
                            <label>Metode Pembayaran</label>
                            <select id="paymentMethod" class="form-control">
                                <option value="cash">Tunai</option>
                                <option value="transfer">Transfer</option>
                            </select>
                        </div>

                        <!-- Photo Evidence -->
                        <div class="form-group">
                            <label>Bukti Foto (Opsional)</label>
                            <input type="file" id="photoEvidence" class="form-control" accept="image/*">
                            <button type="button" class="btn btn-sm btn-info mt-2" onclick="takePhoto()">
                                <i class="fas fa-camera"></i> Ambil Foto
                            </button>
                        </div>

                        <!-- Notes -->
                        <div class="form-group">
                            <label>Catatan</label>
                            <textarea id="paymentNotes" class="form-control" rows="2"></textarea>
                        </div>

                        <!-- Submit Button -->
                        <button type="button" class="btn btn-primary btn-block" onclick="submitPayment()">
                            Simpan Pembayaran
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="/mobile/assets/js/jquery.min.js"></script>
    <script src="/mobile/assets/js/bootstrap.min.js"></script>
    <script src="/mobile/assets/js/app.js"></script>
</body>
</html>
```

### 6.4 Mobile App JavaScript
```javascript
// mobile/assets/js/app.js
class CollectorApp {
    constructor() {
        this.apiBase = '/api';
        this.currentUser = null;
        this.currentRoute = [];
        this.currentMember = null;
        this.init();
    }

    init() {
        // Check if already logged in
        const token = localStorage.getItem('kopcollector_token');
        if (token) {
            this.validateToken(token);
        } else {
            this.showScreen('loginScreen');
        }

        // Setup event listeners
        this.setupEventListeners();
        
        // Register service worker
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('/mobile/sw.js');
        }
    }

    setupEventListeners() {
        // Login form
        $('#loginForm').on('submit', (e) => {
            e.preventDefault();
            this.login();
        });

        // Payment form
        $('#paymentMethod').on('change', () => {
            this.updatePaymentMethod();
        });
    }

    async login() {
        const username = $('#username').val();
        const password = $('#password').val();

        try {
            const response = await this.apiCall('/auth/login', 'POST', {
                username, password, remember: true
            });

            if (response.success) {
                localStorage.setItem('kopcollector_token', response.token);
                this.currentUser = response.user;
                this.showDashboard();
            } else {
                alert('Login gagal: ' + response.message);
            }
        } catch (error) {
            alert('Error: ' + error.message);
        }
    }

    async showDashboard() {
        $('#userName').text(this.currentUser.name);
        $('#todayDate').text(new Date().toLocaleDateString('id-ID'));
        
        await this.loadDailySummary();
        await this.loadRoute();
        
        this.showScreen('dashboardScreen');
    }

    async loadDailySummary() {
        try {
            const summary = await this.apiCall('/collector/daily-summary');
            
            $('#totalVisited').text(summary.total_visited || 0);
            $('#totalCollected').text(this.formatCurrency(summary.total_collected || 0));
        } catch (error) {
            console.error('Error loading summary:', error);
        }
    }

    async loadRoute() {
        try {
            const route = await this.apiCall('/collector/daily-route');
            this.currentRoute = route;
            
            const routeList = $('#routeList');
            routeList.empty();

            route.forEach(member => {
                const statusClass = this.getStatusClass(member.payment_status);
                const statusIcon = this.getStatusIcon(member.payment_status);
                
                const memberCard = `
                    <div class="member-card" onclick="app.showPayment(${member.member_number})">
                        <div class="d-flex justify-content-between align-items-center p-3 border-bottom">
                            <div>
                                <h6 class="mb-1">${member.name}</h6>
                                <small class="text-muted">${member.address}</small>
                            </div>
                            <div class="text-right">
                                <div class="${statusClass}">
                                    ${statusIcon} ${this.getStatusText(member.payment_status)}
                                </div>
                                <small class="text-muted">Rp ${this.formatCurrency(member.due_amount + member.kewer_amount)}</small>
                            </div>
                        </div>
                    </div>
                `;
                
                routeList.append(memberCard);
            });
        } catch (error) {
            console.error('Error loading route:', error);
        }
    }

    showPayment(memberNumber) {
        const member = this.currentRoute.find(m => m.member_number == memberNumber);
        if (!member) return;

        this.currentMember = member;
        
        $('#memberName').text(member.name);
        $('#memberAddress').text(member.address);
        
        // Setup loan payment
        if (member.due_amount > 0) {
            $('#loanPayment').show();
            $('#loanDueAmount').val(this.formatCurrency(member.due_amount));
            $('#loanPaidAmount').val(member.due_amount);
        } else {
            $('#loanPayment').hide();
        }
        
        // Setup savings payment
        if (member.kewer_amount > 0) {
            $('#savingsPayment').show();
            $('#savingsTargetAmount').val(this.formatCurrency(member.kewer_amount));
            $('#savingsPaidAmount').val(member.kewer_amount);
        } else {
            $('#savingsPayment').hide();
        }
        
        this.showScreen('paymentScreen');
    }

    async submitPayment() {
        const paymentData = {
            member_id: this.currentMember.member_number,
            payment_date: new Date().toISOString().split('T')[0],
            payment_method: $('#paymentMethod').val(),
            notes: $('#paymentNotes').val()
        };

        // Add loan payment
        if (this.currentMember.due_amount > 0) {
            paymentData.loan_schedule_id = this.currentMember.schedule_id;
            paymentData.amount = parseFloat($('#loanPaidAmount').val());
        }

        // Add savings payment
        if (this.currentMember.kewer_amount > 0) {
            paymentData.savings_account_id = this.currentMember.savings_account_id;
            paymentData.amount = parseFloat($('#savingsPaidAmount').val());
        }

        // Add location
        if (navigator.geolocation) {
            const position = await this.getCurrentPosition();
            paymentData.location = {
                lat: position.coords.latitude,
                lng: position.coords.longitude
            };
        }

        try {
            const response = await this.apiCall('/collector/record-payment', 'POST', paymentData);
            
            if (response.success) {
                alert('Pembayaran berhasil disimpan!');
                this.backToDashboard();
            } else {
                alert('Error: ' + response.message);
            }
        } catch (error) {
            alert('Error: ' + error.message);
        }
    }

    async apiCall(endpoint, method = 'GET', data = null) {
        const token = localStorage.getItem('kopcollector_token');
        const options = {
            method,
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            }
        };

        if (data && method !== 'GET') {
            options.body = JSON.stringify(data);
        }

        const response = await fetch(this.apiBase + endpoint, options);
        return await response.json();
    }

    formatCurrency(amount) {
        return new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR',
            minimumFractionDigits: 0
        }).format(amount);
    }
    
    formatDate(date) {
        return new Intl.DateTimeFormat('id-ID', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        }).format(new Date(date));
    }

    getStatusClass(status) {
        const classes = {
            'pending': 'text-warning',
            'paid': 'text-success',
            'late': 'text-danger'
        };
        return classes[status] || 'text-secondary';
    }

    getStatusIcon(status) {
        const icons = {
            'pending': '⏰',
            'paid': '✅',
            'late': '⚠️'
        };
        return icons[status] || '📋';
    }

    getStatusText(status) {
        const texts = {
            'pending': 'Belum Bayar',
            'paid': 'Sudah Bayar',
            'late': 'Terlambat'
        };
        return texts[status] || 'Status';
    }

    showScreen(screenId) {
        $('.screen').hide();
        $('#' + screenId).show();
    }

    backToDashboard() {
        this.showDashboard();
    }

    logout() {
        localStorage.removeItem('kopcollector_token');
        this.currentUser = null;
        this.showScreen('loginScreen');
    }

    async getCurrentPosition() {
        return new Promise((resolve, reject) => {
            navigator.geolocation.getCurrentPosition(resolve, reject);
        });
    }
}

// Initialize app
const app = new CollectorApp();
```

---

## 7. Sistem Keuangan & Akuntansi

### 7.1 Accounting Journal System
```php
<?php
// config/AccountingService.php
class AccountingService {
    private $pdo;
    
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
    public function createLoanJournal($loanId, $loanDetails) {
        $this->pdo->beginTransaction();
        
        try {
            // Create journal header
            $stmt = $this->pdo->prepare("
                INSERT INTO journals (
                    journal_date, description, reference_type, reference_id, created_by
                ) VALUES (?, ?, ?, ?, ?)
            ");
            
            $stmt->execute([
                date('Y-m-d'),
                "Pencairan pinjaman #{$loanId}",
                'loan_disbursement',
                $loanId,
                $_SESSION['user']['id']
            ]);
            
            $journalId = $this->pdo->lastInsertId();
            
            // Create journal details (double entry)
            $entries = [
                ['account_id' => 1010, 'debit' => $loanDetails['net_disbursed'], 'credit' => 0, 'notes' => 'Kas - Pencairan pinjaman'],
                ['account_id' => 1100, 'debit' => 0, 'credit' => $loanDetails['amount'], 'notes' => 'Piutang Pinjaman Mikro'],
                ['account_id' => 4020, 'debit' => 0, 'credit' => $loanDetails['admin_fee'], 'notes' => 'Pendapatan Admin Fee']
            ];
            
            foreach ($entries as $entry) {
                $stmt = $this->pdo->prepare("
                    INSERT INTO journal_details (
                        journal_id, account_id, debit, credit, notes
                    ) VALUES (?, ?, ?, ?, ?)
                ");
                $stmt->execute([
                    $journalId,
                    $entry['account_id'],
                    $entry['debit'],
                    $entry['credit'],
                    $entry['notes']
                ]);
            }
            
            // Validate balance
            $this->validateJournalBalance($journalId);
            
            $this->pdo->commit();
            return $journalId;
            
        } catch (Exception $e) {
            $this->pdo->rollBack();
            throw $e;
        }
    }
    
    public function createPaymentJournal($scheduleId, $amount) {
        $this->pdo->beginTransaction();
        
        try {
            // Get loan and schedule details
            $stmt = $this->pdo->prepare("
                SELECT l.id as loan_id, l.member_id, ls.principal_amount, ls.interest_amount
                FROM loan_schedules ls
                JOIN loans l ON ls.loan_id = l.id
                WHERE ls.id = ?
            ");
            $stmt->execute([$scheduleId]);
            $details = $stmt->fetch();
            
            // Create journal
            $stmt = $this->pdo->prepare("
                INSERT INTO journals (
                    journal_date, description, reference_type, reference_id, created_by
                ) VALUES (?, ?, ?, ?, ?)
            ");
            
            $stmt->execute([
                date('Y-m-d'),
                "Pembayaran angsuran pinjaman #{$details['loan_id']}",
                'loan_payment',
                $scheduleId,
                $_SESSION['user']['id']
            ]);
            
            $journalId = $this->pdo->lastInsertId();
            
            // Create entries
            $entries = [
                ['account_id' => 1010, 'debit' => $amount, 'credit' => 0, 'notes' => 'Kas - Pembayaran angsuran'],
                ['account_id' => 1100, 'debit' => 0, 'credit' => $details['principal_amount'], 'notes' => 'Piutang Pinjaman Mikro'],
                ['account_id' => 4010, 'debit' => 0, 'credit' => $details['interest_amount'], 'notes' => 'Pendapatan Bunga Pinjaman']
            ];
            
            foreach ($entries as $entry) {
                $stmt = $this->pdo->prepare("
                    INSERT INTO journal_details (
                        journal_id, account_id, debit, credit, notes
                    ) VALUES (?, ?, ?, ?, ?)
                ");
                $stmt->execute([
                    $journalId,
                    $entry['account_id'],
                    $entry['debit'],
                    $entry['credit'],
                    $entry['notes']
                ]);
            }
            
            $this->validateJournalBalance($journalId);
            $this->pdo->commit();
            return $journalId;
            
        } catch (Exception $e) {
            $this->pdo->rollBack();
            throw $e;
        }
    }
    
    private function validateJournalBalance($journalId) {
        $stmt = $this->pdo->prepare("
            SELECT SUM(debit) as total_debit, SUM(credit) as total_credit
            FROM journal_details WHERE journal_id = ?
        ");
        $stmt->execute([$journalId]);
        $balance = $stmt->fetch();
        
        if ($balance['total_debit'] != $balance['total_credit']) {
            throw new Exception("Journal balance mismatch: Debit {$balance['total_debit']} != Credit {$balance['total_credit']}");
        }
    }
    
    public function generateBalanceSheet($date, $branchId = null) {
        $whereClause = $branchId ? "AND j.reference_id IN (SELECT id FROM branches WHERE id = ?)" : "";
        
        $stmt = $this->pdo->prepare("
            SELECT 
                a.account_code,
                a.account_name,
                a.account_type,
                COALESCE(SUM(jd.debit - jd.credit), 0) as balance
            FROM accounts a
            LEFT JOIN journal_details jd ON a.id = jd.account_id
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE j.journal_date <= ? $whereClause
            GROUP BY a.id, a.account_code, a.account_name, a.account_type
            ORDER BY a.account_code
        ");
        
        $params = [$date];
        if ($branchId) {
            $params[] = $branchId;
        }
        
        $stmt->execute($params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    public function generateIncomeStatement($startDate, $endDate, $branchId = null) {
        $whereClause = $branchId ? "AND j.reference_id IN (SELECT id FROM branches WHERE id = ?)" : "";
        
        $stmt = $this->pdo->prepare("
            SELECT 
                a.account_code,
                a.account_name,
                a.account_type,
                COALESCE(SUM(jd.debit - jd.credit), 0) as total
            FROM accounts a
            LEFT JOIN journal_details jd ON a.id = jd.account_id
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE j.journal_date BETWEEN ? AND ? 
            AND a.account_type IN ('pendapatan', 'beban')
            $whereClause
            GROUP BY a.id, a.account_code, a.account_name, a.account_type
            ORDER BY a.account_code
        ");
        
        $params = [$startDate, $endDate];
        if ($branchId) {
            $params[] = $branchId;
        }
        
        $stmt->execute($params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
```

### 7.2 Cash Reconciliation System
```php
<?php
// config/CashService.php
class CashService {
    private $pdo;
    
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
    public function createDailyBalance($branchId, $date = null) {
        $date = $date ?? date('Y-m-d');
        
        // Get previous day's closing balance
        $previousDate = date('Y-m-d', strtotime('-1 day', strtotime($date)));
        $stmt = $this->pdo->prepare("
            SELECT closing_balance 
            FROM cash_balances 
            WHERE branch_id = ? AND balance_date = ? AND status = 'verified'
        ");
        $stmt->execute([$branchId, $previousDate]);
        $previous = $stmt->fetch();
        
        $openingBalance = $previous ? $previous['closing_balance'] : 0;
        
        // Calculate today's cash in and out
        $stmt = $this->pdo->prepare("
            SELECT 
                COALESCE(SUM(CASE WHEN jd.debit > jd.credit THEN jd.debit - jd.credit ELSE 0 END), 0) as cash_in,
                COALESCE(SUM(CASE WHEN jd.credit > jd.debit THEN jd.credit - jd.debit ELSE 0 END), 0) as cash_out
            FROM journals j
            JOIN journal_details jd ON j.id = jd.journal_id
            JOIN accounts a ON jd.account_id = a.id
            WHERE j.journal_date = ? 
            AND j.reference_id = ?
            AND a.account_code = '1010'
        ");
        $stmt->execute([$date, $branchId]);
        $cashFlow = $stmt->fetch();
        
        $closingBalance = $openingBalance + $cashFlow['cash_in'] - $cashFlow['cash_out'];
        
        // Create or update daily balance
        $stmt = $this->pdo->prepare("
            INSERT INTO cash_balances (
                branch_id, balance_date, opening_balance, cash_in, cash_out, closing_balance
            ) VALUES (?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE
                opening_balance = VALUES(opening_balance),
                cash_in = VALUES(cash_in),
                cash_out = VALUES(cash_out),
                closing_balance = VALUES(closing_balance),
                status = 'draft'
        ");
        
        $stmt->execute([
            $branchId,
            $date,
            $openingBalance,
            $cashFlow['cash_in'],
            $cashFlow['cash_out'],
            $closingBalance
        ]);
        
        return [
            'opening_balance' => $openingBalance,
            'cash_in' => $cashFlow['cash_in'],
            'cash_out' => $cashFlow['cash_out'],
            'closing_balance' => $closingBalance
        ];
    }
    
    public function verifyDailyBalance($branchId, $date, $verifiedBy, $physicalCash) {
        $this->pdo->beginTransaction();
        
        try {
            // Get system balance
            $stmt = $this->pdo->prepare("
                SELECT closing_balance FROM cash_balances 
                WHERE branch_id = ? AND balance_date = ?
            ");
            $stmt->execute([$branchId, $date]);
            $balance = $stmt->fetch();
            
            if (!$balance) {
                throw new Exception('Daily balance not found');
            }
            
            $systemBalance = $balance['closing_balance'];
            $difference = abs($systemBalance - $physicalCash);
            
            // Update verification
            $stmt = $this->pdo->prepare("
                UPDATE cash_balances 
                SET verified_by = ?, verified_at = NOW(), 
                    collector_cash_handled = ?,
                    status = CASE 
                        WHEN ABS(? - ?) <= 50000 THEN 'verified'
                        ELSE 'discrepancy'
                    END
                WHERE branch_id = ? AND balance_date = ?
            ");
            
            $stmt->execute([
                $verifiedBy,
                $physicalCash,
                $systemBalance,
                $physicalCash,
                $branchId,
                $date
            ]);
            
            // Create discrepancy record if needed
            if ($difference > 50000) {
                $stmt = $this->pdo->prepare("
                    INSERT INTO cash_discrepancies (
                        branch_id, balance_date, system_balance, physical_balance, 
                        difference, reported_by, status
                    ) VALUES (?, ?, ?, ?, ?, ?, 'pending')
                ");
                $stmt->execute([
                    $branchId,
                    $date,
                    $systemBalance,
                    $physicalCash,
                    $difference,
                    $verifiedBy
                ]);
                
                // Lock branch operations
                $this->lockBranchOperations($branchId);
            }
            
            $this->pdo->commit();
            
            return [
                'verified' => $difference <= 50000,
                'system_balance' => $systemBalance,
                'physical_balance' => $physicalCash,
                'difference' => $difference
            ];
            
        } catch (Exception $e) {
            $this->pdo->rollBack();
            throw $e;
        }
    }
    
    private function lockBranchOperations($branchId) {
        $stmt = $this->pdo->prepare("
            UPDATE branches SET status = 'locked' WHERE id = ?
        ");
        $stmt->execute([$branchId]);
        
        // Notify management
        $this->notifyManagement($branchId, 'Branch locked due to cash discrepancy');
    }
}
```

---

## 8. Risk Management & Fraud Prevention

### 8.1 Fraud Detection System
```php
<?php
// config/FraudDetectionService.php
class FraudDetectionService {
    private $pdo;
    
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
    public function detectAnomalies($collectorId, $date = null) {
        $date = $date ?? date('Y-m-d');
        $anomalies = [];
        
        // Check 1: Unusual payment patterns
        $paymentAnomalies = $this->detectPaymentAnomalies($collectorId, $date);
        if (!empty($paymentAnomalies)) {
            $anomalies['payment_patterns'] = $paymentAnomalies;
        }
        
        // Check 2: Location anomalies
        $locationAnomalies = $this->detectLocationAnomalies($collectorId, $date);
        if (!empty($locationAnomalies)) {
            $anomalies['locations'] = $locationAnomalies;
        }
        
        // Check 3: Time patterns
        $timeAnomalies = $this->detectTimeAnomalies($collectorId, $date);
        if (!empty($timeAnomalies)) {
            $anomalies['time_patterns'] = $timeAnomalies;
        }
        
        // Check 4: Cash handling issues
        $cashAnomalies = $this->detectCashAnomalies($collectorId, $date);
        if (!empty($cashAnomalies)) {
            $anomalies['cash_handling'] = $cashAnomalies;
        }
        
        return $anomalies;
    }
    
    private function detectPaymentAnomalies($collectorId, $date) {
        $anomalies = [];
        
        // Check for round numbers (potential manipulation)
        $stmt = $this->pdo->prepare("
            SELECT ls.id, ls.total_amount, ls.paid_amount, p.name
            FROM loan_schedules ls
            JOIN loans l ON ls.loan_id = l.id
            JOIN members m ON l.member_id = m.id
            JOIN persons p ON m.person_id = p.id
            WHERE ls.collector_id = ? AND ls.paid_date = ?
            AND ls.paid_amount IN (10000, 20000, 50000, 100000, 200000, 500000)
            AND MOD(ls.paid_amount, ls.total_amount) != 0
        ");
        $stmt->execute([$collectorId, $date]);
        $roundNumbers = $stmt->fetchAll();
        
        if (!empty($roundNumbers)) {
            $anomalies[] = [
                'type' => 'round_number_payments',
                'description' => 'Payments with unusual round numbers',
                'details' => $roundNumbers
            ];
        }
        
        // Check for multiple payments to same member on same day
        $stmt = $this->pdo->prepare("
            SELECT ls.collector_id, COUNT(*) as payment_count, p.name
            FROM loan_schedules ls
            JOIN loans l ON ls.loan_id = l.id
            JOIN members m ON l.member_id = m.id
            JOIN persons p ON m.person_id = p.id
            WHERE ls.collector_id = ? AND ls.paid_date = ?
            GROUP BY l.member_id, p.name
            HAVING payment_count > 1
        ");
        $stmt->execute([$collectorId, $date]);
        $multiplePayments = $stmt->fetchAll();
        
        if (!empty($multiplePayments)) {
            $anomalies[] = [
                'type' => 'multiple_payments_same_member',
                'description' => 'Multiple payments to same member on same day',
                'details' => $multiplePayments
            ];
        }
        
        return $anomalies;
    }
    
    private function detectLocationAnomalies($collectorId, $date) {
        $anomalies = [];
        
        // Check for impossible travel distances
        $stmt = $this->pdo->prepare("
            SELECT 
                p1.name as member1, p2.name as member2,
                a1.latitude as lat1, a1.longitude as lng1,
                a2.latitude as lat2, a2.longitude as lng2,
                ls1.paid_time as time1, ls2.paid_time as time2,
                (6371 * acos(cos(radians(a1.latitude)) * cos(radians(a2.latitude)) * 
                 cos(radians(a2.longitude) - radians(a1.longitude)) + 
                 sin(radians(a1.latitude)) * sin(radians(a2.latitude)))) as distance
            FROM loan_schedules ls1
            JOIN loan_schedules ls2 ON ls1.collector_id = ls2.collector_id
            JOIN loans l1 ON ls1.loan_id = l1.id
            JOIN loans l2 ON ls2.loan_id = l2.id
            JOIN members m1 ON l1.member_id = m1.id
            JOIN members m2 ON l2.member_id = m2.id
            JOIN persons p1 ON m1.person_id = p1.id
            JOIN persons p2 ON m2.person_id = p2.id
            JOIN addresses a1 ON p1.id = a1.person_id AND a1.address_type = 'usaha'
            JOIN addresses a2 ON p2.id = a2.person_id AND a2.address_type = 'usaha'
            WHERE ls1.collector_id = ? AND ls1.paid_date = ?
            AND ls2.collector_id = ? AND ls2.paid_date = ?
            AND ls1.id != ls2.id
            AND ls1.paid_time IS NOT NULL AND ls2.paid_time IS NOT NULL
            HAVING distance > 10 AND ABS(TIMESTAMPDIFF(MINUTE, ls1.paid_time, ls2.paid_time)) < 30
        ");
        $stmt->execute([$collectorId, $date, $collectorId, $date]);
        $impossibleTravel = $stmt->fetchAll();
        
        if (!empty($impossibleTravel)) {
            $anomalies[] = [
                'type' => 'impossible_travel',
                'description' => 'Impossible travel distances between payments',
                'details' => $impossibleTravel
            ];
        }
        
        return $anomalies;
    }
    
    public function createFraudAlert($collectorId, $anomalies, $date) {
        $stmt = $this->pdo->prepare("
            INSERT INTO fraud_alerts (
                collector_id, alert_date, anomaly_types, details, 
                severity, status, created_by
            ) VALUES (?, ?, ?, ?, ?, 'pending', ?)
        ");
        
        $anomalyTypes = json_encode(array_keys($anomalies));
        $details = json_encode($anomalies);
        $severity = $this->calculateSeverity($anomalies);
        
        $stmt->execute([
            $collectorId,
            $date,
            $anomalyTypes,
            $details,
            $severity,
            $_SESSION['user']['id']
        ]);
        
        // Notify management
        $this->notifyFraudAlert($collectorId, $anomalies, $severity);
        
        return $this->pdo->lastInsertId();
    }
    
    private function calculateSeverity($anomalies) {
        $score = 0;
        
        // Different anomaly types have different weights
        $weights = [
            'payment_patterns' => 3,
            'locations' => 5,
            'time_patterns' => 2,
            'cash_handling' => 4
        ];
        
        foreach ($anomalies as $type => $details) {
            $score += $weights[$type] * count($details);
        }
        
        if ($score >= 10) return 'high';
        if ($score >= 5) return 'medium';
        return 'low';
    }
}
```

### 8.2 Risk Assessment System
```php
<?php
// config/RiskAssessmentService.php
class RiskAssessmentService {
    private $pdo;
    
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
    public function assessMemberRisk($memberId) {
        $riskScore = 0;
        $riskFactors = [];
        
        // Factor 1: Payment history
        $paymentRisk = $this->assessPaymentHistory($memberId);
        $riskScore += $paymentRisk['score'];
        $riskFactors['payment_history'] = $paymentRisk;
        
        // Factor 2: Loan concentration
        $concentrationRisk = $this->assessLoanConcentration($memberId);
        $riskScore += $concentrationRisk['score'];
        $riskFactors['loan_concentration'] = $concentrationRisk;
        
        // Factor 3: Family risk
        $familyRisk = $this->assessFamilyRisk($memberId);
        $riskScore += $familyRisk['score'];
        $riskFactors['family_risk'] = $familyRisk;
        
        // Factor 4: Business stability
        $businessRisk = $this->assessBusinessStability($memberId);
        $riskScore += $businessRisk['score'];
        $riskFactors['business_stability'] = $businessRisk;
        
        // Determine risk category
        $riskCategory = $this->getRiskCategory($riskScore);
        
        return [
            'risk_score' => $riskScore,
            'risk_category' => $riskCategory,
            'risk_factors' => $riskFactors,
            'recommendation' => $this->getRecommendation($riskCategory)
        ];
    }
    
    private function assessPaymentHistory($memberId) {
        $stmt = $this->pdo->prepare("
            SELECT 
                COUNT(*) as total_payments,
                COUNT(CASE WHEN ls.status = 'late' THEN 1 END) as late_payments,
                COUNT(CASE WHEN ls.status = 'paid' AND ls.paid_date > ls.due_date THEN 1 END) as delayed_payments,
                AVG(DATEDIFF(ls.paid_date, ls.due_date)) as avg_delay_days
            FROM loan_schedules ls
            JOIN loans l ON ls.loan_id = l.id
            WHERE l.member_id = ? AND ls.status IN ('paid', 'late')
        ");
        $stmt->execute([$memberId]);
        $history = $stmt->fetch();
        
        $score = 0;
        $details = [];
        
        if ($history['total_payments'] > 0) {
            $lateRatio = $history['late_payments'] / $history['total_payments'];
            $delayedRatio = $history['delayed_payments'] / $history['total_payments'];
            
            if ($lateRatio > 0.2) {
                $score += 4;
                $details[] = 'High late payment ratio: ' . round($lateRatio * 100, 1) . '%';
            } elseif ($lateRatio > 0.1) {
                $score += 2;
                $details[] = 'Moderate late payment ratio: ' . round($lateRatio * 100, 1) . '%';
            }
            
            if ($delayedRatio > 0.3) {
                $score += 3;
                $details[] = 'High delayed payment ratio: ' . round($delayedRatio * 100, 1) . '%';
            }
            
            if ($history['avg_delay_days'] > 5) {
                $score += 2;
                $details[] = 'High average delay: ' . round($history['avg_delay_days'], 1) . ' days';
            }
        }
        
        return [
            'score' => $score,
            'details' => $details,
            'data' => $history
        ];
    }
    
    private function assessFamilyRisk($memberId) {
        $stmt = $this->pdo->prepare("
            SELECT 
                COUNT(DISTINCT CASE WHEN l.status = 'defaulted' THEN l.member_id END) as defaulted_members,
                COUNT(DISTINCT CASE WHEN l.status = 'disbursed' THEN l.member_id END) as active_members,
                COALESCE(SUM(CASE WHEN l.status = 'disbursed' THEN l.amount ELSE 0 END), 0) as total_family_loans
            FROM family_links fl
            JOIN members m ON (fl.person1_id = m.person_id OR fl.person2_id = m.person_id)
            JOIN loans l ON m.id = l.member_id
            WHERE (fl.person1_id = ? OR fl.person2_id = ?)
            AND m.id != ?
        ");
        $stmt->execute([$memberId, $memberId, $memberId]);
        $familyData = $stmt->fetch();
        
        $score = 0;
        $details = [];
        
        if ($familyData['defaulted_members'] > 0) {
            $score += 5;
            $details[] = 'Family has defaulted members: ' . $familyData['defaulted_members'];
        }
        
        if ($familyData['active_members'] > 0) {
            $defaultRatio = $familyData['defaulted_members'] / $familyData['active_members'];
            if ($defaultRatio > 0.3) {
                $score += 3;
                $details[] = 'High family default ratio: ' . round($defaultRatio * 100, 1) . '%';
            }
        }
        
        if ($familyData['total_family_loans'] > 20000000) { // Rp20 juta
            $score += 2;
            $details[] = 'High family loan exposure: Rp ' . number_format($familyData['total_family_loans']);
        }
        
        return [
            'score' => $score,
            'details' => $details,
            'data' => $familyData
        ];
    }
    
    private function getRiskCategory($score) {
        if ($score >= 10) return 'high';
        if ($score >= 6) return 'medium';
        if ($score >= 3) return 'low_medium';
        return 'low';
    }
    
    private function getRecommendation($riskCategory) {
        $recommendations = [
            'high' => 'Reject loan application. Member requires financial counseling.',
            'medium' => 'Approve with reduced amount and increased monitoring.',
            'low_medium' => 'Approve with standard monitoring.',
            'low' => 'Approve with normal terms.'
        ];
        
        return $recommendations[$riskCategory];
    }
}
```

---

## 9. Regulasi & Kepatuhan

### 9.1 OJK Compliance Module
```php
<?php
// config/OJKComplianceService.php
class OJKComplianceService {
    private $pdo;
    
    public function __construct($pdo) {
        $this->pdo = $pdo;
    }
    
    public function validateInterestRate($amount, $tenorDays, $interestRate) {
        // OJK 2025: Max 0.275% per day for loans ≤ Rp50 juta, tenor ≤ 6 months
        $maxDailyRate = 0.00275; // 0.275%
        
        if ($amount <= 50000000 && $tenorDays <= 180) {
            $maxMonthlyRate = $maxDailyRate * 30; // Convert to monthly
            if ($interestRate > $maxMonthlyRate) {
                return [
                    'compliant' => false,
                    'error' => 'Interest rate exceeds OJK limit of 0.275% per day',
                    'max_rate' => $maxMonthlyRate
                ];
            }
        }
        
        return ['compliant' => true];
    }
    
    public function generateOJKReport($startDate, $endDate, $branchId = null) {
        $whereClause = $branchId ? "AND l.branch_id = ?" : "";
        
        // Portfolio Quality Report
        $stmt = $this->pdo->prepare("
            SELECT 
                COUNT(*) as total_borrowers,
                COUNT(CASE WHEN l.status = 'disbursed' THEN 1 END) as active_borrowers,
                COALESCE(SUM(CASE WHEN l.status = 'disbursed' THEN l.amount ELSE 0 END), 0) as total_outstanding,
                COUNT(CASE WHEN ls.status = 'late' AND DATEDIFF(CURDATE(), ls.due_date) <= 30 THEN 1 END) as special_attention,
                COUNT(CASE WHEN ls.status = 'late' AND DATEDIFF(CURDATE(), ls.due_date) BETWEEN 31 AND 90 THEN 1 END) as substandard,
                COUNT(CASE WHEN ls.status = 'late' AND DATEDIFF(CURDATE(), ls.due_date) > 90 THEN 1 END) as doubtful,
                COUNT(CASE WHEN ls.status = 'late' AND DATEDIFF(CURDATE(), ls.due_date) > 90 THEN 1 END) as non_performing
            FROM loans l
            LEFT JOIN loan_schedules ls ON l.id = ls.loan_id
            WHERE l.disbursement_date BETWEEN ? AND ? $whereClause
        ");
        
        $params = [$startDate, $endDate];
        if ($branchId) {
            $params[] = $branchId;
        }
        
        $stmt->execute($params);
        $portfolioData = $stmt->fetch();
        
        // Calculate NPL ratio
        $totalBorrowers = $portfolioData['total_borrowers'];
        $nonPerforming = $portfolioData['non_performing'];
        $nplRatio = $totalBorrowers > 0 ? ($nonPerforming / $totalBorrowers) * 100 : 0;
        
        return [
            'report_period' => [
                'start_date' => $startDate,
                'end_date' => $endDate
            ],
            'portfolio_quality' => [
                'total_borrowers' => $portfolioData['total_borrowers'],
                'active_borrowers' => $portfolioData['active_borrowers'],
                'total_outstanding' => $portfolioData['total_outstanding'],
                'funding_quality_level' => [
                    'performing' => $portfolioData['active_borrowers'] - $portfolioData['special_attention'] - $portfolioData['substandard'] - $portfolioData['doubtful'] - $portfolioData['non_performing'],
                    'under_special_attention' => $portfolioData['special_attention'],
                    'substandard' => $portfolioData['substandard'],
                    'doubtful' => $portfolioData['doubtful'],
                    'non_performing' => $portfolioData['non_performing']
                ],
                'npl_ratio' => round($nplRatio, 2)
            ],
            'compliance_status' => [
                'interest_rate_compliant' => $this->checkInterestRateCompliance(),
                'max_loan_amount_compliant' => $this->checkMaxLoanAmountCompliance(),
                'reporting_frequency' => 'monthly',
                'last_report_date' => $this->getLastReportDate()
            ]
        ];
    }
    
    public function checkPPATKReporting($memberId, $amount, $transactionType) {
        // Check if cumulative transactions > Rp500 juta
        $stmt = $this->pdo->prepare("
            SELECT COALESCE(SUM(amount), 0) as total_amount
            FROM ppatk_reportable_transactions
            WHERE member_id = ? AND transaction_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
        ");
        $stmt->execute([$memberId]);
        $cumulative = $stmt->fetch();
        
        $totalAfterTransaction = $cumulative['total_amount'] + $amount;
        
        if ($totalAfterTransaction > 500000000) { // Rp500 juta
            return [
                'reportable' => true,
                'cumulative_amount' => $totalAfterTransaction,
                'threshold' => 500000000,
                'action_required' => 'Create PPATK report'
            ];
        }
        
        return ['reportable' => false];
    }
}
```

---

## 10. Deployment & Maintenance

### 10.1 Server Setup Script
```bash
#!/bin/bash
# setup_server.sh

echo "Setting up Koperasi Berjalan Application Server - Lokasi Indonesia..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y apache2 php8.2 php8.2-mysql php8.2-json php8.2-mbstring php8.2-curl php8.2-gd php8.2-xml php8.2-intl mysql-server redis-server

# Configure PHP untuk Indonesia
sudo sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/8.2/apache2/php.ini
sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/8.2/apache2/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/' /etc/php/8.2/apache2/php.ini
sudo sed -i 's/post_max_size = 8M/post_max_size = 50M/' /etc/php/8.2/apache2/php.ini

# Set timezone Indonesia
echo "date.timezone = Asia/Jakarta" | sudo tee -a /etc/php/8.2/apache2/php.ini

# Set locale Indonesia
sudo locale-gen id_ID.UTF-8
echo "intl.default_locale = id_ID" | sudo tee -a /etc/php/8.2/apache2/php.ini

# Configure Apache
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod expires

# Create virtual host
sudo tee /etc/apache2/sites-available/koperasi.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName koperasi.local
    DocumentRoot /opt/lampp/htdocs/gabe
    
    <Directory /opt/lampp/htdocs/gabe>
        AllowOverride All
        Require all granted
    </Directory>
    
    # Enable CORS for mobile app
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization"
    
    # Cache static assets
    <LocationMatch "\.(css|js|png|jpg|jpeg|gif|ico)$">
        ExpiresActive On
        ExpiresDefault "access plus 1 month"
    </LocationMatch>
    
    # Security headers
    Header always set X-Content-Type-Options nosniff
    Header always set X-Frame-Options DENY
    Header always set X-XSS-Protection "1; mode=block"
</VirtualHost>
EOF

# Enable site
sudo a2ensite koperasi.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2

# Setup MySQL
sudo mysql_secure_installation

# Create database and schemas
mysql -u root -p <<EOF
CREATE DATABASE schema_person;
CREATE DATABASE schema_address;
CREATE DATABASE schema_app;

CREATE USER 'koperasi'@'localhost' IDENTIFIED BY 'StrongPassword123!';
GRANT ALL PRIVILEGES ON schema_.* TO 'koperasi'@'localhost';
FLUSH PRIVILEGES;
EOF

# Setup Redis
sudo systemctl enable redis-server
sudo systemctl start redis-server

# Create directories
sudo mkdir -p /opt/lampp/htdocs/gabe/uploads/{members,loans,receipts}
sudo mkdir -p /opt/lampp/htdocs/gabe/logs
sudo chown -R www-data:www-data /opt/lampp/htdocs/gabe/uploads
sudo chown -R www-data:www-data /opt/lampp/htdocs/gabe/logs

# Setup SSL (Let's Encrypt)
sudo apt install -y certbot python3-certbot-apache
sudo certbot --apache -d koperasi.local

echo "Server setup completed!"
echo "Next steps:"
echo "1. Import database schema"
echo "2. Configure config/database.php"
echo "3. Create admin user"
echo "4. Test application"
```

### 10.2 Backup Script
```bash
#!/bin/bash
# backup_script.sh

BACKUP_DIR="/backup/koperasi"
DATE=$(date +%Y%m%d_%H%M%S)
DB_USER="koperasi"
DB_PASS="StrongPassword123!"
DB_NAME="schema_app"

# Create backup directory
mkdir -p $BACKUP_DIR

# Database backup
mysqldump -u$DB_USER -p$DB_PASS --single-transaction --routines --triggers schema_app > $BACKUP_DIR/schema_app_$DATE.sql
mysqldump -u$DB_USER -p$DB_PASS --single-transaction --routines --triggers schema_person > $BACKUP_DIR/schema_person_$DATE.sql
mysqldump -u$DB_USER -p$DB_PASS --single-transaction --routines --triggers schema_address > $BACKUP_DIR/schema_address_$DATE.sql

# Files backup
tar -czf $BACKUP_DIR/uploads_$DATE.tar.gz /opt/lampp/htdocs/gabe/uploads

# Config backup
tar -czf $BACKUP_DIR/config_$DATE.tar.gz /opt/lampp/htdocs/gabe/config

# Upload to cloud storage (example with AWS S3)
# aws s3 cp $BACKUP_DIR/schema_app_$DATE.sql s3://koperasi-backup/database/
# aws s3 cp $BACKUP_DIR/uploads_$DATE.tar.gz s3://koperasi-backup/files/

# Clean old backups (keep 30 days)
find $BACKUP_DIR -name "*.sql" -mtime +30 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete

echo "Backup completed: $DATE"
```

### 10.3 Monitoring Script
```bash
#!/bin/bash
# monitor_script.sh

LOG_FILE="/var/log/koperasi_monitor.log"
ALERT_EMAIL="admin@koperasi.com"

# Check Apache status
if ! systemctl is-active --quiet apache2; then
    echo "$(date): Apache is down" >> $LOG_FILE
    systemctl start apache2
    echo "Apache restarted" | mail -s "Apache Restarted" $ALERT_EMAIL
fi

# Check MySQL status
if ! systemctl is-active --quiet mysql; then
    echo "$(date): MySQL is down" >> $LOG_FILE
    systemctl start mysql
    echo "MySQL restarted" | mail -s "MySQL Restarted" $ALERT_EMAIL
fi

# Check disk space
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "$(date): Disk usage is ${DISK_USAGE}%" >> $LOG_FILE
    echo "Disk usage critical: ${DISK_USAGE}%" | mail -s "Disk Space Alert" $ALERT_EMAIL
fi

# Check memory usage
MEMORY_USAGE=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
if [ $MEMORY_USAGE -gt 90 ]; then
    echo "$(date): Memory usage is ${MEMORY_USAGE}%" >> $LOG_FILE
    echo "Memory usage critical: ${MEMORY_USAGE}%" | mail -s "Memory Alert" $ALERT_EMAIL
fi

# Check application health
curl -f http://localhost/api/health > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "$(date): Application health check failed" >> $LOG_FILE
    systemctl reload apache2
fi

echo "$(date): Health check completed" >> $LOG_FILE
```

---

## 11. Panduan Implementasi Bertahap

### Fase 1: Foundation (Minggu 1-2)
```
✓ Setup server dan environment
✓ Database schema creation
✓ Basic authentication system
✓ User management (BOS, Unit Head, Branch Head)
✓ Basic CRUD for members
```

### Fase 2: Core Features (Minggu 3-4)
```
✓ Loan management system
✓ Savings accounts (Kewer/Mawar)
✓ Payment schedules generation
✓ Basic accounting journals
✓ Cash balance tracking
```

### Fase 3: Mobile Collector (Minggu 5-6)
```
✓ PWA development
✓ Daily route system
✓ Payment recording
✓ Location tracking
✓ Offline support
```

### Fase 4: Advanced Features (Minggu 7-8)
```
✓ Risk assessment system
✓ Fraud detection
✓ OJK compliance reporting
✓ Advanced reporting dashboard
✓ Notification system
```

### Fase 5: Testing & Deployment (Minggu 9-10)
```
✓ Load testing (500+ transactions/day)
✓ Security testing
✓ User acceptance testing
✓ Production deployment
✓ Training and documentation
```

---

## KESIMPULAN

Panduan ini menyediakan kerangka lengkap untuk membangun aplikasi koperasi berjalan (Kewer-Mawar) yang:

✅ **Scalable** - Mendukung ratusan transaksi per hari  
✅ **Secure** - Proteksi fraud dan risk management  
✅ **Compliant** - Sesuai regulasi OJK 2025  
✅ **Mobile-First** - PWA untuk kolektor lapangan  
✅ **Professional** - Akuntansi double-entry lengkap  

Dengan mengikuti panduan ini, aplikasi yang dihasilkan akan:
- Melayani 500-5.000 anggota per cabang
- Memproses 300-1.000 transaksi per hari
- Mengelola portfolio Rp100 juta - 4 miliar
- Menjaga NPL di bawah 5%
- Siap untuk audit dan pelaporan regulasi

---

*Dokumen ini adalah panduan lengkap untuk implementasi aplikasi koperasi berjalan yang profesional dan compliant.*
