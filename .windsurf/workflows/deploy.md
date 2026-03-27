---
description: Deploy the Koperasi Berjalan application
---
1. Check XAMPP services status
// turbo
2. Start XAMPP services if needed
// turbo
3. Verify database connection
4. Run application tests
5. Check application accessibility
6. Verify all user roles functionality

## Commands
```bash
# Check XAMPP status
sudo /opt/lampp/lampp status

# Start XAMPP
sudo /opt/lampp/lampp start

# Run tests
cd /opt/lampp/htdocs/gabe/tests && npm test

# Access application
http://localhost/gabe/
```
