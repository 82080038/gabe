---
description: Setup and configure database for Koperasi Berjalan
---
1. Check MySQL service status
// turbo
2. Create database if not exists
3. Import database schema
4. Verify table creation
5. Create test users
6. Validate database connectivity

## Database Commands
```bash
# Check MySQL status
sudo /opt/lampp/lampp status

# Create database
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS koperasi_berjalan;"

# Import schemas
mysql -u root -p koperasi_berjalan < /opt/lampp/htdocs/gabe/master_tables.sql
mysql -u root -p koperasi_berjalan < /opt/lampp/htdocs/gabe/normalized_schema_app.sql

# Verify tables
mysql -u root -p -e "USE koperasi_berjalan; SHOW TABLES;"
```

## Database Schemas
- schema_person: Personal data and family relationships
- schema_address: Address data with multiple types
- schema_app: Application operational data
