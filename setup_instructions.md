# Setup Database Aplikasi Koperasi Berjalan

## 📋 **Overview**
Implementasi database menggunakan **3 database**:
1. `schema_person` - Data personal & hubungan keluarga
2. `schema_address` - Data alamat lengkap Indonesia (rename dari alamat_db)
3. `schema_app` - Data aplikasi & transaksi

## 🚀 **Langkah Setup Database**

### **Step 1: Login ke MySQL**
```bash
mysql -u root -p
# Masukkan password: root
```

### **Step 2: Import Data alamat_db_backup.sql ke schema_address**
```bash
# Konversi encoding jika perlu
iconv -f utf-16 -t utf-8 /opt/lampp/htdocs/gabe/alamat_db_backup.sql > /opt/lampp/htdocs/gabe/alamat_db_clean.sql

# Import ke schema_address
mysql -u root -p schema_address < /opt/lampp/htdocs/gabe/alamat_db_clean.sql
```

### **Step 3: Jalankan Script Setup**
```sql
mysql> source /opt/lampp/htdocs/gabe/create_databases.sql;
```

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
