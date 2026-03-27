# 🚀 Setup Instructions - Koperasi Berjalan

**Last Updated:** 2026-03-27  
**Version:** 1.0.0  
**Status:** Production Ready

---

## 📋 **Overview**

Aplikasi Koperasi Berjalan adalah sistem simpan pinjam digital yang siap digunakan dengan:
- **Multi-role user system** (6 role types)
- **Responsive web & mobile interface**
- **PWA features** dengan Service Worker
- **Quick login demo** untuk testing
- **Comprehensive testing** dengan Puppeteer

---

## 🛠️ **System Requirements**

### **Software Requirements**
- **XAMPP** (Apache + MySQL + PHP)
- **PHP 8.2+** 
- **MySQL 8.0+**
- **Modern Browser** (Chrome, Firefox, Edge)

### **Hardware Requirements**
- **RAM:** Minimum 4GB (8GB recommended)
- **Storage:** Minimum 2GB free space
- **Processor:** Modern dual-core or better

---

## 🚀 **Quick Setup (5 Minutes)**

### **Step 1: Start XAMPP**
```bash
# Start XAMPP services
sudo /opt/lampp/lampp start

# Check status
sudo /opt/lampp/lampp status
```

### **Step 2: Verify Setup**
```bash
# Test Apache
curl -I http://localhost/

# Test MySQL
mysql -u root -p -e "SHOW DATABASES;"
```

### **Step 3: Access Application**
```bash
# Open browser
http://localhost/gabe/

# Quick access URLs
http://localhost/gabe/pages/login.php          # Login page
http://localhost/gabe/pages/quick_login.php    # Quick demo
http://localhost/gabe/pages/web/dashboard.php  # Dashboard
```

---

## 📱 **Quick Login Demo**

### **Available User Roles**
| Role | Username | Password | Access Level |
|------|----------|----------|--------------|
| Administrator | `admin` | `admin` | Full system access |
| Manager Unit | `manager` | `manager` | Unit management |
| Branch Head | `branch_head` | `branch_head` | Branch operations |
| Collector | `collector` | `collector` | Mobile collection |
| Cashier | `cashier` | `cashier` | Cash transactions |
| Staff | `staff` | `staff` | Administrative |

### **Demo Instructions**
1. **Buka:** `http://localhost/gabe/pages/quick_login.php`
2. **Pilih role** yang ingin diuji
3. **Klik "Quick Login"**
4. **Dashboard** akan menampilkan konten sesuai role

---

## 🗄️ **Database Setup (Optional)**

### **For Full Functionality**
Jika ingin mengaktifkan database integration:

#### **Step 1: Create Database**
```sql
mysql -u root -p
CREATE DATABASE koperasi_berjalan;
USE koperasi_berjalan;
```

#### **Step 2: Import Schema**
```bash
# Import database schema
mysql -u root -p koperasi_berjalan < /opt/lampp/htdocs/gabe/database/schema.sql

# Import sample data (optional)
mysql -u root -p koperasi_berjalan < /opt/lampp/htdocs/gabe/database/sample_data.sql
```

#### **Step 3: Configure Connection**
```php
// Edit config/database.php
$host = 'localhost';
$dbname = 'koperasi_berjalan';
$username = 'root';
$password = ''; // Your MySQL password
```

---

## 🧪 **Testing Setup**

### **Automated Testing**
```bash
# Navigate to tests directory
cd /opt/lampp/htdocs/gabe/tests

# Install dependencies (if needed)
npm install

# Run comprehensive tests
npm test

# Run specific test suites
npm run test:auth      # Authentication tests
npm run test:mobile    # Mobile responsiveness
npm run test:pwa       # PWA features
```

### **Manual Testing Checklist**
- [ ] **Login System:** Test all 6 roles
- [ ] **Dashboard:** Verify role-based content
- [ ] **Responsive:** Test mobile, tablet, desktop
- [ ] **Navigation:** Test menu and breadcrumbs
- [ ] **PWA:** Test service worker and caching
- [ ] **Quick Login:** Test role switching

---

## 🔧 **Configuration**

### **Apache Configuration**
```apache
# /opt/lampp/etc/extra/httpd-vhosts.conf (optional)
<VirtualHost *:80>
    DocumentRoot "/opt/lampp/htdocs/gabe"
    ServerName localhost
    <Directory "/opt/lampp/htdocs/gabe">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

### **PHP Configuration**
```ini
# /opt/lampp/etc/php.ini
memory_limit = 256M
max_execution_time = 300
upload_max_filesize = 64M
post_max_size = 64M
```

### **Application Configuration**
```php
// config/app.php (create if needed)
define('APP_NAME', 'Koperasi Berjalan');
define('APP_VERSION', '1.0.0');
define('DEBUG_MODE', true);
define('BASE_URL', 'http://localhost/gabe/');
```

---

## 🚨 **Troubleshooting**

### **Common Issues**

#### **1. 404 Errors**
```bash
# Check Apache status
sudo /opt/lampp/lampp status

# Check .htaccess
ls -la /opt/lampp/htdocs/gabe/.htaccess

# Restart Apache
sudo /opt/lampp/lampp restartapache
```

#### **2. Database Connection**
```bash
# Test MySQL connection
mysql -u root -p

# Check database exists
SHOW DATABASES LIKE 'koperasi_berjalan';
```

#### **3. Asset Loading Issues**
```bash
# Check file permissions
sudo chown -R www-data:www-data /opt/lampp/htdocs/gabe
sudo chmod -R 755 /opt/lampp/htdocs/gabe

# Verify assets exist
ls -la /opt/lampp/htdocs/gabe/assets/
```

#### **4. JavaScript Errors**
```bash
# Check browser console
# Open Developer Tools → Console

# Verify assets load
curl -I http://localhost/gabe/assets/js/bootstrap.bundle.min.js
curl -I http://localhost/gabe/assets/css/bootstrap.min.css
```

### **Error Logs**
```bash
# Apache error log
tail -f /opt/lampp/logs/error_log

# PHP error log
tail -f /opt/lampp/logs/php_error_log

# MySQL error log
tail -f /opt/lampp/mysql/data/mysql.err
```

---

## 📱 **Mobile Testing**

### **Device Testing**
1. **Chrome DevTools:** F12 → Toggle device toolbar
2. **Real Device:** Access `http://[IP-ADDRESS]/gabe/`
3. **PWA Testing:** Install as mobile app

### **Responsive Breakpoints**
- **Mobile:** < 768px
- **Tablet:** 768px - 1024px  
- **Desktop:** > 1024px

---

## 🌐 **Production Deployment**

### **Security Checklist**
- [ ] Change default passwords
- [ ] Enable HTTPS/SSL
- [ ] Configure firewall
- [ ] Set up backups
- [ ] Monitor logs

### **Performance Optimization**
- [ ] Enable gzip compression
- [ ] Configure caching
- [ ] Optimize images
- [ ] Use CDN for assets

---

## 📞 **Support**

### **Documentation**
- **[README.md](README.md)** - Project overview
- **[PROJECT_STATUS.md](PROJECT_STATUS.md)** - Implementation status
- **[PANDUAN_LENGKAP_KOPERASI_BERJALAN.md](PANDUAN_LENGKAP_KOPERASI_BERJALAN.md)** - Complete guide

### **Debug Tools**
```javascript
// Browser console
window.PWA_DEBUG           // PWA debugging
window.deviceType          // Device detection
window.userRole            // Current user role
window.responsiveManager   // Responsive system
```

---

**🎉 Setup Complete!**

Aplikasi Koperasi Berjalan siap digunakan. Kunjungi `http://localhost/gabe/` untuk memulai.

**Quick Start:** `http://localhost/gabe/pages/quick_login.php` untuk demo semua role.

### **Step 4: Update Foreign Keys (Opsional)**
```sql
mysql> source /opt/lampp/htdocs/gabe/rename_database.sql;
```

### **Step 5: Verifikasi Setup**
```sql
mysql -u root -p

-- Cek database yang sudah dibuat
SHOW DATABASES;
-- Hasil: schema_address, schema_app, schema_person, (dan database default)

-- Cek tabel di setiap database
USE schema_person;
SHOW TABLES;

USE schema_address;
SHOW TABLES;

USE schema_app;
SHOW TABLES;
```

## 📊 **Struktur Database Final**

```
┌─────────────────┐
│   MySQL Server   │
├─────────────────┤
│ schema_address  │ ← Rename dari alamat_db (14.8MB data sudah ada)
│ ├─ provinces    │ (34 provinsi)
│ ├─ regencies    │ (514 kabupaten/kota)
│ ├─ districts    │ (7.000+ kecamatan)
│ ├─ villages     │ (80.000+ desa/kelurahan)
│ └─ streets      │ (jutaan alamat)
├─────────────────┤
│ schema_person   │
│ ├─ persons      │
│ └─ family_links │
├─────────────────┤
│ schema_app      │
│ ├─ units        │
│ ├─ branches     │
│ ├─ users        │
│ ├─ members      │
│ ├─ loans        │
│ ├─ savings      │
│ ├─ accounting   │
│ └─ ...          │
└─────────────────┘
```

## 🔗 **Cross-Database Relationships**

```sql
-- schema_app.members -> schema_person.persons
ALTER TABLE schema_app.members 
ADD FOREIGN KEY (person_id) REFERENCES schema_person.persons(id);

-- schema_app.branches -> schema_address.addresses  
ALTER TABLE schema_app.branches 
ADD FOREIGN KEY (address_id) REFERENCES schema_address.addresses(id);

-- schema_app.users -> schema_person.persons
ALTER TABLE schema_app.users 
ADD FOREIGN KEY (person_id) REFERENCES schema_person.persons(id);
```

## 📈 **Fitur Database yang Tersedia**

### ✅ **Core Features**
- Multi-organization (Units → Branches)
- Role-based access control
- Member & family relationship tracking
- Complete loan & savings management
- Double-entry accounting (SAK ETAP)

### ✅ **Advanced Features**
- Fraud detection system
- PPATK reporting compliance
- Real-time notifications
- Audit logging
- Risk assessment algorithms

### ✅ **Reporting Views**
- Member portfolio view
- Daily collection view  
- NPL analysis view
- Performance metrics

### ✅ **Automation**
- Stored procedures for risk calculation
- Triggers for automatic updates
- Daily report generation
- Balance reconciliation

## 🎯 **Quick Test Setup**

### **1. Test Connection (PHP)**
```php
<?php
// config/database.php
$connections = [
    'person' => new mysqli('localhost', 'root', '', 'schema_person'),
    'address' => new mysqli('localhost', 'root', '', 'alamat_db'),
    'app' => new mysqli('localhost', 'root', '', 'schema_app')
];

foreach ($connections as $name => $conn) {
    if ($conn->connect_error) {
        die("Connection $name failed: " . $conn->connect_error);
    }
    echo "Connected to $name database successfully!\n";
}
?>
```

### **2. Test Data Insertion**
```sql
-- Test insert data person
USE schema_person;
INSERT INTO persons (nik, name, phone) 
VALUES ('3201011234560001', 'Test User', '08123456789');

-- Test insert data application
USE schema_app;
INSERT INTO units (name, code) VALUES ('Unit Test', 'TEST01');
INSERT INTO branches (unit_id, name, code) VALUES (1, 'Cabang Test', 'TEST001');
```

### **3. Verify Data**
```sql
-- Cek cross-database join
SELECT 
    m.member_number, 
    p.name, 
    b.name as branch_name,
    v.name as village_name
FROM schema_app.members m
JOIN schema_person.persons p ON m.person_id = p.id  
JOIN schema_app.branches b ON m.branch_id = b.id
LEFT JOIN schema_address.villages v ON 1=1;  -- Test connection
```

## 🔧 **Configuration Files**

### **Update config/database.php**
```php
<?php
return [
    'person' => [
        'host' => 'localhost',
        'dbname' => 'schema_person',
        'username' => 'root',
        'password' => '',
        'charset' => 'utf8mb4'
    ],
    'address' => [
        'host' => 'localhost', 
        'dbname' => 'schema_address',
        'username' => 'root',
        'password' => '',
        'charset' => 'utf8mb4'
    ],
    'app' => [
        'host' => 'localhost',
        'dbname' => 'schema_app', 
        'username' => 'root',
        'password' => '',
        'charset' => 'utf8mb4'
    ]
];
?>
```

## ⚡ **Performance Optimization**

### **Indexes Already Created**
- Primary keys & foreign keys
- Performance indexes for queries
- Unique constraints for data integrity

### **Additional Optimization**
```sql
-- Add composite indexes for reporting
CREATE INDEX idx_member_branch_date ON schema_app.members(branch_id, join_date);
CREATE INDEX idx_loan_status_date ON schema_app.loans(status, disbursement_date);
CREATE INDEX idx_savings_account_date ON schema_app.savings_deposits(account_id, deposit_date);
```

## 🛡️ **Security Considerations**

- ✅ Password hashing for users
- ✅ SQL injection prevention with prepared statements
- ✅ Audit logging for all changes
- ✅ Role-based access control
- ✅ Foreign key constraints for data integrity

## 📝 **Troubleshooting**

### **Common Issues & Solutions:**

1. **"Access denied for user 'root'@'localhost'"**
   ```bash
   # Reset MySQL root password
   sudo /opt/lampp/lampp stop
   sudo /opt/lampp/bin/mysqld_safe --skip-grant-tables &
   mysql -u root
   UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
   FLUSH PRIVILEGES;
   sudo /opt/lampp/lampp restart
   ```

2. **"Can't create database"**
   ```sql
   -- Check permissions
   SHOW GRANTS FOR 'root'@'localhost';
   
   -- Grant all privileges
   GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
   FLUSH PRIVILEGES;
   ```

3. **"File too large" saat import alamat_db.sql**
   ```bash
   # Increase max_allowed_packet
   mysql -u root -p -e "SET GLOBAL max_allowed_packet=1073741824;"
   mysql -u root -p alamat_db < /opt/lampp/htdocs/gabe/alamat_db.sql
   ```

## ✅ **Setup Verification Checklist**

- [ ] 3 databases created: schema_person, schema_address, schema_app
- [ ] alamat_db_backup.sql imported to schema_address successfully (data Indonesia lengkap)
- [ ] All tables created with proper relationships
- [ ] Initial data inserted (accounts, products)
- [ ] Views and stored procedures created
- [ ] Triggers activated
- [ ] PHP connection test successful
- [ ] Cross-database queries working

## 🚀 **Next Steps**

1. **Test Application Connection**
2. **Create Admin User**
3. **Import Initial Data**
4. **Test CRUD Operations**
5. **Verify Accounting Journals**
6. **Test Reporting Views**

---

**Database setup selesai!** 🎉 Aplikasi siap digunakan dengan 3 database yang terintegrasi sempurna.
