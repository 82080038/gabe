-- ================================================================
-- RENAME DATABASE: alamat_db → schema_address
-- ================================================================

-- Step 1: Rename database alamat_db menjadi schema_address
RENAME DATABASE alamat_db TO schema_address;

-- Step 2: Update cross-database foreign keys
USE schema_app;

-- Drop existing foreign key constraints if they exist
-- ALTER TABLE branches DROP FOREIGN KEY branches_ibfk_2;

-- Add new foreign key constraints to schema_address
-- ALTER TABLE branches 
-- ADD CONSTRAINT fk_branch_address 
-- FOREIGN KEY (address_id) REFERENCES schema_address.addresses(id);

-- Step 3: Update views to use schema_address
DROP VIEW IF EXISTS member_portfolio_view;

CREATE VIEW member_portfolio_view AS
SELECT 
    m.id, m.member_number, p.name, p.phone,
    b.name as branch_name,
    COUNT(l.id) as active_loans,
    COALESCE(SUM(l.amount), 0) as total_loans,
    COUNT(sa.id) as savings_accounts,
    COALESCE(SUM(sa.current_balance), 0) as total_savings,
    m.status as member_status,
    m.join_date
FROM schema_app.members m
JOIN schema_person.persons p ON m.person_id = p.id
JOIN schema_app.branches b ON m.branch_id = b.id
LEFT JOIN schema_app.loans l ON m.id = l.member_id AND l.status = 'disbursed'
LEFT JOIN schema_app.savings_accounts sa ON m.id = sa.member_id AND sa.status = 'active'
GROUP BY m.id;

-- Step 4: Verification
SELECT 'Database renamed successfully!' as status;

-- Show new database structure
SHOW DATABASES LIKE 'schema_%';
