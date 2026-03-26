<?php
/**
 * ================================================================
 * SAVINGS CONTROLLER - KOPERASI BERJALAN
 * Complete savings management system with deposits and withdrawals
 * ================================================================ */

require_once __DIR__ . '/../index.php';

class SavingsController extends BaseController {
    
    /**
     * Get all savings accounts with pagination and filtering
     * GET /api/savings
     */
    public function index() {
        $currentUser = $this->getCurrentUser();
        $branchId = $currentUser['branch_id'];
        $role = $currentUser['role'];
        
        // Pagination parameters
        $page = max(1, intval($_GET['page'] ?? 1));
        $limit = min(100, max(10, intval($_GET['limit'] ?? 20)));
        $offset = ($page - 1) * $limit;
        
        // Filter parameters
        $search = sanitizeInput($_GET['search'] ?? '');
        $type = sanitizeInput($_GET['type'] ?? '');
        $productId = intval($_GET['product_id'] ?? 0);
        $memberId = intval($_GET['member_id'] ?? 0);
        $status = sanitizeInput($_GET['status'] ?? '');
        
        try {
            $whereConditions = [];
            $params = [];
            
            // Branch filtering for non-admin users
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $whereConditions[] = "sa.branch_id = ?";
                $params[] = $branchId;
            }
            
            // Search filter
            if (!empty($search)) {
                $whereConditions[] = "(m.member_number LIKE ? OR p.name LIKE ? OR sa.account_number LIKE ?)";
                $searchParam = "%{$search}%";
                $params[] = $searchParam;
                $params[] = $searchParam;
                $params[] = $searchParam;
            }
            
            // Type filter
            if (!empty($type)) {
                $whereConditions[] = "sp.type = ?";
                $params[] = $type;
            }
            
            // Product filter
            if ($productId > 0) {
                $whereConditions[] = "sa.product_id = ?";
                $params[] = $productId;
            }
            
            // Member filter
            if ($memberId > 0) {
                $whereConditions[] = "sa.member_id = ?";
                $params[] = $memberId;
            }
            
            // Status filter
            if (!empty($status)) {
                $whereConditions[] = "sa.status = ?";
                $params[] = $status;
            }
            
            $whereClause = !empty($whereConditions) ? "WHERE " . implode(" AND ", $whereConditions) : "";
            
            // Get total count
            $countQuery = "
                SELECT COUNT(*) as total
                FROM savings_accounts sa
                LEFT JOIN members m ON sa.member_id = m.id
                LEFT JOIN schema_person.persons p ON m.person_id = p.id
                LEFT JOIN savings_products sp ON sa.product_id = sp.id
                {$whereClause}
            ";
            
            $stmt = $this->db->prepare($countQuery);
            $stmt->execute($params);
            $total = $stmt->fetch()['total'];
            
            // Get savings accounts data
            $query = "
                SELECT 
                    sa.*,
                    m.member_number,
                    p.name as member_name,
                    p.phone,
                    p.email,
                    sp.name as product_name,
                    sp.type as product_type,
                    sp.interest_rate,
                    sp.min_balance,
                    sp.description as product_description,
                    b.name as branch_name,
                    u.username as created_by_username,
                    d.last_deposit_date,
                    d.last_deposit_amount,
                    d.total_deposits,
                    d.total_withdrawals,
                    d.interest_earned
                FROM savings_accounts sa
                LEFT JOIN members m ON sa.member_id = m.id
                LEFT JOIN schema_person.persons p ON m.person_id = p.id
                LEFT JOIN savings_products sp ON sa.product_id = sp.id
                LEFT JOIN branches b ON sa.branch_id = b.id
                LEFT JOIN users u ON sa.created_by = u.id
                LEFT JOIN (
                    SELECT 
                        account_id,
                        MAX(CASE WHEN transaction_type = 'deposit' THEN created_at ELSE NULL END) as last_deposit_date,
                        MAX(CASE WHEN transaction_type = 'deposit' THEN amount ELSE 0 END) as last_deposit_amount,
                        SUM(CASE WHEN transaction_type = 'deposit' THEN amount ELSE 0 END) as total_deposits,
                        SUM(CASE WHEN transaction_type = 'withdrawal' THEN amount ELSE 0 END) as total_withdrawals,
                        COALESCE(SUM(interest_amount), 0) as interest_earned
                    FROM savings_transactions
                    GROUP BY account_id
                ) d ON sa.id = d.account_id
                {$whereClause}
                ORDER BY sa.created_at DESC
                LIMIT ? OFFSET ?
            ";
            
            $params[] = $limit;
            $params[] = $offset;
            
            $stmt = $this->db->prepare($query);
            $stmt->execute($params);
            $accounts = $stmt->fetchAll();
            
            // Format response
            $formattedAccounts = [];
            foreach ($accounts as $account) {
                $formattedAccounts[] = [
                    'id' => $account['id'],
                    'account_number' => $account['account_number'],
                    'member' => [
                        'id' => $account['member_id'],
                        'member_number' => $account['member_number'],
                        'name' => $account['member_name'],
                        'phone' => $account['phone'],
                        'email' => $account['email']
                    ],
                    'product' => [
                        'id' => $account['product_id'],
                        'name' => $account['product_name'],
                        'type' => $account['product_type'],
                        'interest_rate' => floatval($account['interest_rate']),
                        'min_balance' => floatval($account['min_balance']),
                        'description' => $account['product_description']
                    ],
                    'balance' => floatval($account['balance']),
                    'status' => $account['status'],
                    'opened_date' => $account['opened_date'],
                    'created_at' => $account['created_at'],
                    'branch' => [
                        'id' => $account['branch_id'],
                        'name' => $account['branch_name']
                    ],
                    'created_by' => $account['created_by_username'],
                    'activity_summary' => [
                        'last_deposit_date' => $account['last_deposit_date'],
                        'last_deposit_amount' => floatval($account['last_deposit_amount'] ?? 0),
                        'total_deposits' => floatval($account['total_deposits'] ?? 0),
                        'total_withdrawals' => floatval($account['total_withdrawals'] ?? 0),
                        'interest_earned' => floatval($account['interest_earned'] ?? 0)
                    ]
                ];
            }
            
            $this->success($formattedAccounts, 'Savings accounts retrieved successfully', [
                'total' => $total,
                'page' => $page,
                'limit' => $limit,
                'total_pages' => ceil($total / $limit),
                'has_next' => $page < ceil($total / $limit),
                'has_prev' => $page > 1
            ]);
            
        } catch (PDOException $e) {
            Logger::error('Database error in savings index', [
                'error' => $e->getMessage(),
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to retrieve savings accounts', 500);
        }
    }
    
    /**
     * Create new savings account
     * POST /api/savings
     */
    public function create() {
        $currentUser = $this->getCurrentUser();
        
        // Validate input
        $requiredFields = ['member_id', 'product_id', 'initial_deposit'];
        $input = $this->validate($requiredFields);
        
        if (!$input) {
            return;
        }
        
        try {
            // Validate member exists and is active
            $memberQuery = "SELECT m.*, p.name as member_name FROM members m LEFT JOIN schema_person.persons p ON m.person_id = p.id WHERE m.id = ? AND m.status = 'active'";
            $stmt = $this->db->prepare($memberQuery);
            $stmt->execute([$input['member_id']]);
            $member = $stmt->fetch();
            
            if (!$member) {
                $this->error('Member not found or inactive', 400);
                return;
            }
            
            // Validate product exists
            $productQuery = "SELECT * FROM savings_products WHERE id = ? AND is_active = 1";
            $stmt = $this->db->prepare($productQuery);
            $stmt->execute([$input['product_id']]);
            $product = $stmt->fetch();
            
            if (!$product) {
                $this->error('Savings product not found or inactive', 400);
                return;
            }
            
            // Validate initial deposit
            if ($input['initial_deposit'] < $product['min_deposit']) {
                $this->error('Initial deposit must be at least ' . $product['min_deposit'], 400);
                return;
            }
            
            // Check if member already has this type of savings account
            if ($product['type'] === 'mandatory') {
                $existingQuery = "SELECT COUNT(*) as count FROM savings_accounts WHERE member_id = ? AND product_id = ? AND status = 'active'";
                $stmt = $this->db->prepare($existingQuery);
                $stmt->execute([$input['member_id'], $input['product_id']]);
                $existingCount = $stmt->fetch()['count'];
                
                if ($existingCount > 0) {
                    $this->error('Member already has this type of savings account', 400);
                    return;
                }
            }
            
            // Generate account number
            $accountNumber = $this->generateAccountNumber();
            
            // Start transaction
            $this->db->beginTransaction();
            
            try {
                // Create savings account
                $accountQuery = "
                    INSERT INTO savings_accounts (
                        account_number, member_id, product_id, balance, 
                        status, branch_id, created_by, opened_date, created_at
                    ) VALUES (?, ?, ?, ?, 'active', ?, ?, NOW(), NOW())
                ";
                
                $stmt = $this->db->prepare($accountQuery);
                $stmt->execute([
                    $accountNumber,
                    $input['member_id'],
                    $input['product_id'],
                    $input['initial_deposit'],
                    $currentUser['branch_id'],
                    $currentUser['user_id']
                ]);
                
                $accountId = $this->db->lastInsertId();
                
                // Create initial deposit transaction
                $transactionQuery = "
                    INSERT INTO savings_transactions (
                        account_id, transaction_type, amount, payment_method, 
                        notes, status, created_by, created_at
                    ) VALUES (?, 'deposit', ?, ?, ?, 'completed', ?, NOW())
                ";
                
                $stmt = $this->db->prepare($transactionQuery);
                $stmt->execute([
                    $accountId,
                    $input['initial_deposit'],
                    $input['payment_method'] ?? 'cash',
                    $input['notes'] ?? 'Initial deposit',
                    $currentUser['user_id']
                ]);
                
                // Update member's credit score
                $this->updateMemberCreditScore($input['member_id']);
                
                // Log activity
                Logger::info('Savings account created', [
                    'account_id' => $accountId,
                    'account_number' => $accountNumber,
                    'member_id' => $input['member_id'],
                    'product_id' => $input['product_id'],
                    'initial_deposit' => $input['initial_deposit'],
                    'user_id' => $currentUser['user_id']
                ]);
                
                // Commit transaction
                $this->db->commit();
                
                // Get created account details
                $this->getAccountDetails($accountId);
                
            } catch (Exception $e) {
                $this->db->rollback();
                throw $e;
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in savings account creation', [
                'error' => $e->getMessage(),
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to create savings account', 500);
        }
    }
    
    /**
     * Get specific savings account details
     * GET /api/savings/{id}
     */
    public function show($id) {
        $currentUser = $this->getCurrentUser();
        $accountId = intval($id);
        
        try {
            $query = "
                SELECT 
                    sa.*,
                    m.member_number,
                    p.name as member_name,
                    p.phone,
                    p.email,
                    p.address,
                    sp.name as product_name,
                    sp.type as product_type,
                    sp.interest_rate,
                    sp.min_balance,
                    sp.description as product_description,
                    b.name as branch_name,
                    u.username as created_by_username
                FROM savings_accounts sa
                LEFT JOIN members m ON sa.member_id = m.id
                LEFT JOIN schema_person.persons p ON m.person_id = p.id
                LEFT JOIN savings_products sp ON sa.product_id = sp.id
                LEFT JOIN branches b ON sa.branch_id = b.id
                LEFT JOIN users u ON sa.created_by = u.id
                WHERE sa.id = ?
            ";
            
            $stmt = $this->db->prepare($query);
            $stmt->execute([$accountId]);
            $account = $stmt->fetch();
            
            if (!$account) {
                $this->error('Savings account not found', 404);
                return;
            }
            
            // Check permissions
            if (!$this->hasSavingsAccess($account, $currentUser)) {
                $this->error('Access denied', 403);
                return;
            }
            
            // Get transaction history
            $transactionQuery = "
                SELECT 
                    st.*,
                    u.username as created_by_username
                FROM savings_transactions st
                LEFT JOIN users u ON st.created_by = u.id
                WHERE st.account_id = ?
                ORDER BY st.created_at DESC
            ";
            
            $stmt = $this->db->prepare($transactionQuery);
            $stmt->execute([$accountId]);
            $transactions = $stmt->fetchAll();
            
            // Calculate summary
            $totalDeposits = array_sum(array_column(array_filter($transactions, fn($t) => $t['transaction_type'] === 'deposit'), 'amount'));
            $totalWithdrawals = array_sum(array_column(array_filter($transactions, fn($t) => $t['transaction_type'] === 'withdrawal'), 'amount'));
            $totalInterest = array_sum(array_column($transactions, 'interest_amount'));
            
            // Get interest calculation history
            $interestQuery = "
                SELECT 
                    calculation_date,
                    interest_rate,
                    daily_balance,
                    interest_amount,
                    accumulated_interest
                FROM savings_interest_calculations
                WHERE account_id = ?
                ORDER BY calculation_date DESC
                LIMIT 12
            ";
            
            $stmt = $this->db->prepare($interestQuery);
            $stmt->execute([$accountId]);
            $interestHistory = $stmt->fetchAll();
            
            $response = [
                'id' => $account['id'],
                'account_number' => $account['account_number'],
                'member' => [
                    'id' => $account['member_id'],
                    'member_number' => $account['member_number'],
                    'name' => $account['member_name'],
                    'phone' => $account['phone'],
                    'email' => $account['email'],
                    'address' => $account['address']
                ],
                'product' => [
                    'id' => $account['product_id'],
                    'name' => $account['product_name'],
                    'type' => $account['product_type'],
                    'interest_rate' => floatval($account['interest_rate']),
                    'min_balance' => floatval($account['min_balance']),
                    'description' => $account['product_description']
                ],
                'balance' => floatval($account['balance']),
                'status' => $account['status'],
                'opened_date' => $account['opened_date'],
                'created_at' => $account['created_at'],
                'branch' => [
                    'id' => $account['branch_id'],
                    'name' => $account['branch_name']
                ],
                'created_by' => $account['created_by_username'],
                'summary' => [
                    'total_deposits' => $totalDeposits,
                    'total_withdrawals' => $totalWithdrawals,
                    'total_interest' => $totalInterest,
                    'net_deposits' => $totalDeposits - $totalWithdrawals
                ],
                'transactions' => $transactions,
                'interest_history' => $interestHistory
            ];
            
            $this->success($response, 'Savings account details retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in savings account details', [
                'error' => $e->getMessage(),
                'account_id' => $accountId,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to retrieve savings account details', 500);
        }
    }
    
    /**
     * Make deposit to savings account
     * POST /api/savings/{id}/deposit
     */
    public function makeDeposit($id) {
        $currentUser = $this->getCurrentUser();
        $accountId = intval($id);
        
        // Validate input
        $input = $this->validate(['amount', 'payment_method', 'notes']);
        
        if (!$input) {
            return;
        }
        
        try {
            // Get account details
            $query = "SELECT * FROM savings_accounts WHERE id = ?";
            $stmt = $this->db->prepare($query);
            $stmt->execute([$accountId]);
            $account = $stmt->fetch();
            
            if (!$account) {
                $this->error('Savings account not found', 404);
                return;
            }
            
            // Check permissions
            if (!$this->hasSavingsAccess($account, $currentUser)) {
                $this->error('Access denied', 403);
                return;
            }
            
            // Validate account status
            if ($account['status'] !== 'active') {
                $this->error('Account is not active for deposits', 400);
                return;
            }
            
            // Validate deposit amount
            if ($input['amount'] <= 0) {
                $this->error('Deposit amount must be greater than 0', 400);
                return;
            }
            
            // Get product minimum deposit
            $productQuery = "SELECT min_deposit FROM savings_products WHERE id = ?";
            $stmt = $this->db->prepare($productQuery);
            $stmt->execute([$account['product_id']]);
            $product = $stmt->fetch();
            
            if ($input['amount'] < $product['min_deposit']) {
                $this->error('Deposit amount must be at least ' . $product['min_deposit'], 400);
                return;
            }
            
            // Start transaction
            $this->db->beginTransaction();
            
            try {
                // Create transaction record
                $transactionQuery = "
                    INSERT INTO savings_transactions (
                        account_id, transaction_type, amount, payment_method, 
                        notes, status, created_by, created_at
                    ) VALUES (?, 'deposit', ?, ?, ?, 'completed', ?, NOW())
                ";
                
                $stmt = $this->db->prepare($transactionQuery);
                $stmt->execute([
                    $accountId,
                    $input['amount'],
                    $input['payment_method'],
                    $input['notes'] ?? null,
                    $currentUser['user_id']
                ]);
                
                $transactionId = $this->db->lastInsertId();
                
                // Update account balance
                $newBalance = $account['balance'] + $input['amount'];
                $updateQuery = "UPDATE savings_accounts SET balance = ?, updated_at = NOW() WHERE id = ?";
                $stmt = $this->db->prepare($updateQuery);
                $stmt->execute([$newBalance, $accountId]);
                
                // Update member's credit score
                $this->updateMemberCreditScore($account['member_id']);
                
                // Log activity
                Logger::info('Savings deposit made', [
                    'account_id' => $accountId,
                    'transaction_id' => $transactionId,
                    'amount' => $input['amount'],
                    'payment_method' => $input['payment_method'],
                    'new_balance' => $newBalance,
                    'user_id' => $currentUser['user_id']
                ]);
                
                // Commit transaction
                $this->db->commit();
                
                $this->success([
                    'transaction_id' => $transactionId,
                    'amount' => $input['amount'],
                    'payment_method' => $input['payment_method'],
                    'new_balance' => $newBalance
                ], 'Deposit processed successfully');
                
            } catch (Exception $e) {
                $this->db->rollback();
                throw $e;
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in savings deposit', [
                'error' => $e->getMessage(),
                'account_id' => $accountId,
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to process deposit', 500);
        }
    }
    
    /**
     * Make withdrawal from savings account
     * POST /api/savings/{id}/withdrawal
     */
    public function makeWithdrawal($id) {
        $currentUser = $this->getCurrentUser();
        $accountId = intval($id);
        
        // Validate input
        $input = $this->validate(['amount', 'payment_method', 'notes']);
        
        if (!$input) {
            return;
        }
        
        try {
            // Get account details
            $query = "SELECT * FROM savings_accounts WHERE id = ?";
            $stmt = $this->db->prepare($query);
            $stmt->execute([$accountId]);
            $account = $stmt->fetch();
            
            if (!$account) {
                $this->error('Savings account not found', 404);
                return;
            }
            
            // Check permissions
            if (!$this->hasSavingsAccess($account, $currentUser)) {
                $this->error('Access denied', 403);
                return;
            }
            
            // Validate account status
            if ($account['status'] !== 'active') {
                $this->error('Account is not active for withdrawals', 400);
                return;
            }
            
            // Validate withdrawal amount
            if ($input['amount'] <= 0) {
                $this->error('Withdrawal amount must be greater than 0', 400);
                return;
            }
            
            // Check sufficient balance
            if ($input['amount'] > $account['balance']) {
                $this->error('Insufficient balance', 400);
                return;
            }
            
            // Get product minimum balance
            $productQuery = "SELECT min_balance FROM savings_products WHERE id = ?";
            $stmt = $this->db->prepare($productQuery);
            $stmt->execute([$account['product_id']]);
            $product = $stmt->fetch();
            
            $newBalance = $account['balance'] - $input['amount'];
            
            if ($newBalance < $product['min_balance']) {
                $this->error('Withdrawal would violate minimum balance requirement of ' . $product['min_balance'], 400);
                return;
            }
            
            // Start transaction
            $this->db->beginTransaction();
            
            try {
                // Create transaction record
                $transactionQuery = "
                    INSERT INTO savings_transactions (
                        account_id, transaction_type, amount, payment_method, 
                        notes, status, created_by, created_at
                    ) VALUES (?, 'withdrawal', ?, ?, ?, 'completed', ?, NOW())
                ";
                
                $stmt = $this->db->prepare($transactionQuery);
                $stmt->execute([
                    $accountId,
                    $input['amount'],
                    $input['payment_method'],
                    $input['notes'] ?? null,
                    $currentUser['user_id']
                ]);
                
                $transactionId = $this->db->lastInsertId();
                
                // Update account balance
                $updateQuery = "UPDATE savings_accounts SET balance = ?, updated_at = NOW() WHERE id = ?";
                $stmt = $this->db->prepare($updateQuery);
                $stmt->execute([$newBalance, $accountId]);
                
                // Update member's credit score
                $this->updateMemberCreditScore($account['member_id']);
                
                // Log activity
                Logger::info('Savings withdrawal made', [
                    'account_id' => $accountId,
                    'transaction_id' => $transactionId,
                    'amount' => $input['amount'],
                    'payment_method' => $input['payment_method'],
                    'new_balance' => $newBalance,
                    'user_id' => $currentUser['user_id']
                ]);
                
                // Commit transaction
                $this->db->commit();
                
                $this->success([
                    'transaction_id' => $transactionId,
                    'amount' => $input['amount'],
                    'payment_method' => $input['payment_method'],
                    'new_balance' => $newBalance
                ], 'Withdrawal processed successfully');
                
            } catch (Exception $e) {
                $this->db->rollback();
                throw $e;
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in savings withdrawal', [
                'error' => $e->getMessage(),
                'account_id' => $accountId,
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to process withdrawal', 500);
        }
    }
    
    /**
     * Calculate and apply interest for savings accounts
     * POST /api/savings/calculate-interest
     */
    public function calculateInterest() {
        $currentUser = $this->getCurrentUser();
        
        // Validate permissions
        if (!in_array($currentUser['role'], [ROLE_SUPER_ADMIN, ROLE_ADMIN, ROLE_BRANCH_HEAD])) {
            $this->error('Access denied', 403);
            return;
        }
        
        try {
            // Get all active savings accounts
            $accountsQuery = "
                SELECT 
                    sa.*,
                    sp.interest_rate,
                    sp.type as product_type
                FROM savings_accounts sa
                LEFT JOIN savings_products sp ON sa.product_id = sp.id
                WHERE sa.status = 'active' AND sp.interest_rate > 0
            ";
            
            $stmt = $this->db->prepare($accountsQuery);
            $stmt->execute();
            $accounts = $stmt->fetchAll();
            
            $totalInterestCalculated = 0;
            $accountsUpdated = 0;
            
            foreach ($accounts as $account) {
                $interestAmount = $this->calculateAccountInterest($account);
                
                if ($interestAmount > 0) {
                    // Apply interest to account
                    $newBalance = $account['balance'] + $interestAmount;
                    
                    $updateQuery = "
                        UPDATE savings_accounts 
                        SET balance = ?, updated_at = NOW() 
                        WHERE id = ?
                    ";
                    
                    $stmt = $this->db->prepare($updateQuery);
                    $stmt->execute([$newBalance, $account['id']]);
                    
                    // Create interest transaction
                    $transactionQuery = "
                        INSERT INTO savings_transactions (
                            account_id, transaction_type, amount, interest_amount, 
                            notes, status, created_by, created_at
                        ) VALUES (?, 'interest', 0, ?, 'Monthly interest calculation', 'completed', ?, NOW())
                    ";
                    
                    $stmt = $this->db->prepare($transactionQuery);
                    $stmt->execute([
                        $account['id'],
                        $interestAmount,
                        $currentUser['user_id']
                    ]);
                    
                    // Record interest calculation
                    $calculationQuery = "
                        INSERT INTO savings_interest_calculations (
                            account_id, calculation_date, interest_rate, 
                            daily_balance, interest_amount, accumulated_interest
                        ) VALUES (?, CURDATE(), ?, ?, ?, ?)
                    ";
                    
                    $stmt = $this->db->prepare($calculationQuery);
                    $stmt->execute([
                        $account['id'],
                        $account['interest_rate'],
                        $account['balance'],
                        $interestAmount,
                        $this->getAccumulatedInterest($account['id'])
                    ]);
                    
                    $totalInterestCalculated += $interestAmount;
                    $accountsUpdated++;
                }
            }
            
            // Log activity
            Logger::info('Interest calculation completed', [
                'accounts_updated' => $accountsUpdated,
                'total_interest' => $totalInterestCalculated,
                'user_id' => $currentUser['user_id']
            ]);
            
            $this->success([
                'accounts_updated' => $accountsUpdated,
                'total_interest_calculated' => $totalInterestCalculated,
                'calculation_date' => date('Y-m-d')
            ], 'Interest calculation completed successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in interest calculation', [
                'error' => $e->getMessage(),
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to calculate interest', 500);
        }
    }
    
    /**
     * Get savings statistics
     * GET /api/savings/statistics
     */
    public function statistics() {
        $currentUser = $this->getCurrentUser();
        $branchId = $currentUser['branch_id'];
        $role = $currentUser['role'];
        
        // Date range parameters
        $dateFrom = sanitizeInput($_GET['date_from'] ?? date('Y-m-01'));
        $dateTo = sanitizeInput($_GET['date_to'] ?? date('Y-m-t'));
        
        try {
            $whereClause = "";
            $params = [];
            
            // Branch filtering for non-admin users
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $whereClause = "WHERE branch_id = ?";
                $params[] = $branchId;
            }
            
            // Get savings statistics
            $statsQuery = "
                SELECT 
                    COUNT(*) as total_accounts,
                    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_accounts,
                    COUNT(CASE WHEN status = 'inactive' THEN 1 END) as inactive_accounts,
                    COUNT(CASE WHEN status = 'frozen' THEN 1 END) as frozen_accounts,
                    COALESCE(SUM(balance), 0) as total_balance,
                    COALESCE(AVG(balance), 0) as average_balance,
                    COUNT(CASE WHEN DATE(created_at) BETWEEN ? AND ? THEN 1 END) as new_accounts_period,
                    COUNT(DISTINCT member_id) as unique_members
                FROM savings_accounts
                {$whereClause}
            ";
            
            if (empty($params)) {
                $params = [$dateFrom, $dateTo];
            } else {
                $params[] = $dateFrom;
                $params[] = $dateTo;
            }
            
            $stmt = $this->db->prepare($statsQuery);
            $stmt->execute($params);
            $stats = $stmt->fetch();
            
            // Get monthly trends
            $trendsQuery = "
                SELECT 
                    DATE_FORMAT(created_at, '%Y-%m') as month,
                    COUNT(*) as account_count,
                    COALESCE(SUM(balance), 0) as total_balance,
                    COALESCE(AVG(balance), 0) as average_balance
                FROM savings_accounts
                WHERE created_at >= DATE_SUB(?, INTERVAL 12 MONTH)
                " . ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN ? "AND branch_id = ?" : "") . "
                GROUP BY DATE_FORMAT(created_at, '%Y-%m')
                ORDER BY month DESC
            ";
            
            $trendsParams = [date('Y-m-d')];
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $trendsParams[] = $branchId;
            }
            
            $stmt = $this->db->prepare($trendsQuery);
            $stmt->execute($trendsParams);
            $trends = $stmt->fetchAll();
            
            // Get product distribution
            $productQuery = "
                SELECT 
                    sp.name as product_name,
                    sp.type as product_type,
                    COUNT(sa.id) as account_count,
                    COALESCE(SUM(sa.balance), 0) as total_balance,
                    COALESCE(AVG(sa.balance), 0) as average_balance
                FROM savings_accounts sa
                LEFT JOIN savings_products sp ON sa.product_id = sp.id
                " . ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN ? "WHERE sa.branch_id = ?" : "") . "
                GROUP BY sp.id, sp.name, sp.type
                ORDER BY total_balance DESC
            ";
            
            $productParams = [];
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $productParams[] = $branchId;
            }
            
            $stmt = $this->db->prepare($productQuery);
            $stmt->execute($productParams);
            $products = $stmt->fetchAll();
            
            // Get transaction statistics for the period
            $transactionQuery = "
                SELECT 
                    transaction_type,
                    COUNT(*) as transaction_count,
                    COALESCE(SUM(amount), 0) as total_amount,
                    COALESCE(AVG(amount), 0) as average_amount
                FROM savings_transactions st
                LEFT JOIN savings_accounts sa ON st.account_id = sa.id
                WHERE st.created_at BETWEEN ? AND ?
                " . ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN ? "AND sa.branch_id = ?" : "") . "
                GROUP BY transaction_type
            ";
            
            $transactionParams = [$dateFrom, $dateTo];
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $transactionParams[] = $branchId;
            }
            
            $stmt = $this->db->prepare($transactionQuery);
            $stmt->execute($transactionParams);
            $transactions = $stmt->fetchAll();
            
            $response = [
                'summary' => [
                    'total_accounts' => intval($stats['total_accounts']),
                    'active_accounts' => intval($stats['active_accounts']),
                    'inactive_accounts' => intval($stats['inactive_accounts']),
                    'frozen_accounts' => intval($stats['frozen_accounts']),
                    'total_balance' => floatval($stats['total_balance']),
                    'average_balance' => floatval($stats['average_balance']),
                    'new_accounts_period' => intval($stats['new_accounts_period']),
                    'unique_members' => intval($stats['unique_members'])
                ],
                'monthly_trends' => $trends,
                'product_distribution' => $products,
                'transaction_summary' => $transactions
            ];
            
            $this->success($response, 'Savings statistics retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in savings statistics', [
                'error' => $e->getMessage(),
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to retrieve savings statistics', 500);
        }
    }
    
    /**
     * Helper methods
     */
    private function generateAccountNumber() {
        $prefix = 'SAV';
        $date = date('Ymd');
        
        // Get last account number for today
        $query = "SELECT account_number FROM savings_accounts WHERE account_number LIKE ? ORDER BY id DESC LIMIT 1";
        $stmt = $this->db->prepare($query);
        $stmt->execute(["{$prefix}{$date}%"]);
        $lastAccount = $stmt->fetch();
        
        if ($lastAccount) {
            $lastNumber = intval(substr($lastAccount['account_number'], -4));
            $newNumber = $lastNumber + 1;
        } else {
            $newNumber = 1;
        }
        
        return $prefix . $date . str_pad($newNumber, 4, '0', STR_PAD_LEFT);
    }
    
    private function calculateAccountInterest($account) {
        // Simple monthly interest calculation
        // In a real implementation, this would be more sophisticated
        $monthlyRate = $account['interest_rate'] / 100 / 12;
        return $account['balance'] * $monthlyRate;
    }
    
    private function getAccumulatedInterest($accountId) {
        $query = "SELECT COALESCE(SUM(interest_amount), 0) as total FROM savings_interest_calculations WHERE account_id = ?";
        $stmt = $this->db->prepare($query);
        $stmt->execute([$accountId]);
        return $stmt->fetch()['total'];
    }
    
    private function updateMemberCreditScore($memberId) {
        // Get member's savings history
        $query = "
            SELECT 
                COUNT(*) as total_accounts,
                COALESCE(SUM(balance), 0) as total_balance,
                COUNT(CASE WHEN status = 'active' THEN 1 END) as active_accounts,
                AVG(CASE WHEN status = 'active' THEN balance END) as avg_balance
            FROM savings_accounts 
            WHERE member_id = ?
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$memberId]);
        $savingsHistory = $stmt->fetch();
        
        // Calculate credit score impact from savings
        $baseScore = 0;
        
        // Base score for having savings accounts
        if ($savingsHistory['total_accounts'] > 0) {
            $baseScore += 50;
        }
        
        // Bonus for active accounts
        if ($savingsHistory['active_accounts'] > 0) {
            $baseScore += 30;
        }
        
        // Bonus for higher balance
        if ($savingsHistory['total_balance'] > 1000000) { // > 10 juta
            $baseScore += 20;
        } elseif ($savingsHistory['total_balance'] > 500000) { // > 5 juta
            $baseScore += 10;
        }
        
        // Bonus for consistent savings
        if ($savingsHistory['avg_balance'] > 100000) { // > 1 juta
            $baseScore += 10;
        }
        
        // Update member's credit score (this would be combined with other factors)
        $updateQuery = "UPDATE members SET credit_score = LEAST(850, credit_score + ?), updated_at = NOW() WHERE id = ?";
        $stmt = $this->db->prepare($updateQuery);
        $stmt->execute([$baseScore, $memberId]);
    }
    
    private function hasSavingsAccess($account, $currentUser) {
        // Admin and super admin can access all accounts
        if (in_array($currentUser['role'], [ROLE_SUPER_ADMIN, ROLE_ADMIN])) {
            return true;
        }
        
        // Branch managers can access accounts from their branch
        if (in_array($currentUser['role'], [ROLE_BRANCH_HEAD, ROLE_UNIT_HEAD, ROLE_SUPERVISOR])) {
            return $account['branch_id'] == $currentUser['branch_id'];
        }
        
        // Collectors and cashiers can access accounts they created or are assigned to
        if (in_array($currentUser['role'], [ROLE_COLLECTOR, ROLE_CASHIER])) {
            return $account['created_by'] == $currentUser['user_id'];
        }
        
        return false;
    }
    
    private function getAccountDetails($accountId) {
        // Get and return account details after creation
        $this->show($accountId);
    }
}

?>
