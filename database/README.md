# 🗄️ Database Export - Koperasi Berjalan

This directory contains database exports and backup files for the Koperasi Berjalan cooperative management system.

## 📋 Database Structure

### Multi-Database Architecture
The application uses a multi-database architecture with the following databases:

1. **schema_person** - Personal data and family relationships
2. **schema_address** - Indonesian address data (provinces, regencies, districts, villages)
3. **schema_app** - Application data and transactions

### Database Credentials
- **Host**: localhost
- **Port**: 3306
- **Username**: root
- **Password**: root
- **Sudo User**: 8208
- **Sudo Password**: 8208

## 📁 Files in This Directory

### Database Exports
- `full_database_export.sql` - Complete export of all databases
- `schema_person.sql` - Personal database export
- `schema_address.sql` - Address database export
- `schema_app.sql` - Application database export

### Backup Files
- `backup_YYYY-MM-DD_HH-mm-ss.sql` - Timestamped backup files
- `latest_backup.sql` - Most recent backup

### Configuration Files
- `database_structure.md` - Database structure documentation
- `migration_scripts/` - Database migration scripts
- `seed_data/` - Sample data and seed files

## 🚀 Quick Start

### Import Database
```bash
# Import complete database
mysql -u root -p < full_database_export.sql

# Import individual databases
mysql -u root -p < schema_person.sql
mysql -u root -p < schema_address.sql
mysql -u root -p < schema_app.sql
```

### Export Database
```bash
# Export complete database
mysqldump -u root -p --all-databases --routines --triggers --events > full_database_export.sql

# Export individual databases
mysqldump -u root -p schema_person > schema_person.sql
mysqldump -u root -p schema_address > schema_address.sql
mysqldump -u root -p schema_app > schema_app.sql
```

### Backup Database
```bash
# Create timestamped backup
mysqldump -u root -p --all-databases --routines --triggers --events > backup_$(date +%Y-%m-%d_%H-%M-%S).sql

# Create latest backup
mysqldump -u root -p --all-databases --routines --triggers --events > latest_backup.sql
```

## 📊 Database Schema

### Schema Person
```sql
-- Personal data tables
persons
family_members
family_relationships
person_identifications
person_contacts
person_educations
person_employments
```

### Schema Address
```sql
-- Indonesian address hierarchy
provinces
regencies
districts
villages
postal_codes
```

### Schema App
```sql
-- Application tables
users
branches
members
loans
savings
collections
reports
audit_logs
```

## 🔧 Database Operations

### Connect to Database
```bash
# Connect to MySQL
mysql -u root -p

# Connect to specific database
mysql -u root -p schema_person
mysql -u root -p schema_address
mysql -u root -p schema_app
```

### Database Maintenance
```bash
# Check database status
mysql -u root -p -e "SHOW DATABASES;"
mysql -u root -p -e "SHOW PROCESSLIST;"

# Optimize tables
mysql -u root -p -e "OPTIMIZE TABLE schema_app.members;"

# Repair tables
mysql -u root -p -e "REPAIR TABLE schema_app.loans;"
```

### User Management
```bash
# Create new user
mysql -u root -p -e "CREATE USER 'koperasi'@'localhost' IDENTIFIED BY 'password';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO 'koperasi'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
```

## 📈 Performance Optimization

### Index Optimization
```sql
-- Add indexes for performance
CREATE INDEX idx_members_active ON members(status);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_collections_date ON collections(collection_date);
```

### Query Optimization
```sql
-- Analyze query performance
EXPLAIN SELECT * FROM members WHERE status = 'active';
EXPLAIN SELECT * FROM loans WHERE status = 'pending';
```

## 🔒 Security

### Database Security
- Use strong passwords
- Limit database access
- Regular backups
- Monitor access logs
- Use SSL connections in production

### Backup Security
- Encrypt backup files
- Store backups securely
- Regular backup testing
- Offsite backup storage

## 📝 Migration Scripts

### Database Migrations
```php
// Example migration script
<?php
// Create migration table
$sql = "CREATE TABLE IF NOT EXISTS migrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    migration VARCHAR(255) NOT NULL,
    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";
```

### Seed Data
```sql
-- Insert sample data
INSERT INTO branches (name, code, address) VALUES 
('Kantor Pusat', 'HQ', 'Jakarta'),
('Cabang Surabaya', 'SBY', 'Surabaya'),
('Cabang Bandung', 'BDG', 'Bandung');
```

## 🔄 Backup Strategy

### Automated Backups
```bash
#!/bin/bash
# Backup script
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="backup_$DATE.sql"
mysqldump -u root -p --all-databases --routines --triggers --events > $BACKUP_FILE

# Keep only last 30 days of backups
find /path/to/backups -name "backup_*.sql" -mtime +30 -delete
```

### Recovery Process
```bash
# Restore from backup
mysql -u root -p < backup_2026-03-27_10-00-00.sql

# Verify restore
mysql -u root -p -e "SELECT COUNT(*) FROM schema_app.members;"
```

## 📋 Checklist

### Before Deployment
- [ ] Backup current database
- [ ] Test export/import process
- [ ] Verify data integrity
- [ ] Update credentials
- [ ] Test application connectivity

### After Deployment
- [ ] Verify database connection
- [ ] Test all CRUD operations
- [ ] Check performance
- [ ] Monitor error logs
- [ ] Create new backup

## 🚨 Troubleshooting

### Common Issues

#### Connection Failed
```bash
# Check MySQL status
sudo systemctl status mysql
sudo systemctl start mysql

# Check configuration
mysql -u root -p -e "SHOW VARIABLES LIKE 'port';"
```

#### Permission Denied
```bash
# Reset password
sudo mysql -u root -p -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';"
sudo mysql -u root -p -e "FLUSH PRIVILEGES;"
```

#### Database Not Found
```bash
# Create database
mysql -u root -p -e "CREATE DATABASE schema_app;"
mysql -u root -p -e "CREATE DATABASE schema_person;"
mysql -u root -p -e "CREATE DATABASE schema_address;"
```

### Error Messages

#### "Access denied for user 'root'@'localhost'"
- Check MySQL service status
- Verify credentials
- Reset root password

#### "Can't connect to local MySQL server"
- Check if MySQL is running
- Verify socket path
- Check port configuration

#### "Table doesn't exist"
- Import database schema
- Check database name
- Verify table prefix

## 📞 Support

### Getting Help
- Check MySQL logs: `/var/log/mysql/error.log`
- Review application logs
- Test database connection
- Verify configuration files

### Emergency Recovery
1. Stop application
2. Restore from latest backup
3. Verify data integrity
4. Restart application
5. Monitor performance

---

**Note**: This database export contains all data for the Koperasi Berjalan cooperative management system. Always test imports in a development environment before production deployment.
