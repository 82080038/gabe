<?php
/**
 * ================================================================
 * LOAN CONTROLLER - KOPERASI BERJALAN
 * Complete loan management system with scheduling and collection
 * ================================================================ */

require_once __DIR__ . '/../index.php';

class LoanController extends BaseController {
    
    /**
     * Get all loans with pagination and filtering
     * GET /api/loans
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
        $status = sanitizeInput($_GET['status'] ?? '');
        $productId = intval($_GET['product_id'] ?? 0);
        $memberId = intval($_GET['member_id'] ?? 0);
        $dateFrom = sanitizeInput($_GET['date_from'] ?? '');
        $dateTo = sanitizeInput($_GET['date_to'] ?? '');
        
        try {
            $whereConditions = [];
            $params = [];
            
            // Branch filtering for non-admin users
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $whereConditions[] = "l.branch_id = ?";
                $params[] = $branchId;
            }
            
            // Search filter
            if (!empty($search)) {
                $whereConditions[] = "(m.member_number LIKE ? OR p.name LIKE ? OR l.loan_number LIKE ?)";
                $searchParam = "%{$search}%";
                $params[] = $searchParam;
                $params[] = $searchParam;
                $params[] = $searchParam;
            }
            
            // Status filter
            if (!empty($status)) {
                $whereConditions[] = "l.status = ?";
                $params[] = $status;
            }
            
            // Product filter
            if ($productId > 0) {
                $whereConditions[] = "l.product_id = ?";
                $params[] = $productId;
            }
            
            // Member filter
            if ($memberId > 0) {
                $whereConditions[] = "l.member_id = ?";
                $params[] = $memberId;
            }
            
            // Date range filter
            if (!empty($dateFrom)) {
                $whereConditions[] = "DATE(l.created_at) >= ?";
                $params[] = $dateFrom;
            }
            
            if (!empty($dateTo)) {
                $whereConditions[] = "DATE(l.created_at) <= ?";
                $params[] = $dateTo;
            }
            
            $whereClause = !empty($whereConditions) ? "WHERE " . implode(" AND ", $whereConditions) : "";
            
            // Get total count
            $countQuery = "
                SELECT COUNT(*) as total
                FROM loans l
                LEFT JOIN members m ON l.member_id = m.id
                LEFT JOIN schema_person.persons p ON m.person_id = p.id
                {$whereClause}
            ";
            
            $stmt = $this->db->prepare($countQuery);
            $stmt->execute($params);
            $total = $stmt->fetch()['total'];
            
            // Get loans data
            $query = "
                SELECT 
                    l.*,
                    m.member_number,
                    p.name as member_name,
                    p.phone,
                    p.email,
                    lp.name as product_name,
                    lp.interest_rate,
                    lp.tenure_months,
                    b.name as branch_name,
                    u.username as created_by_username,
                    c.total_paid,
                    c.remaining_balance,
                    c.next_payment_date,
                    c.days_overdue
                FROM loans l
                LEFT JOIN members m ON l.member_id = m.id
                LEFT JOIN schema_person.persons p ON m.person_id = p.id
                LEFT JOIN loan_products lp ON l.product_id = lp.id
                LEFT JOIN branches b ON l.branch_id = b.id
                LEFT JOIN users u ON l.created_by = u.id
                LEFT JOIN (
                    SELECT 
                        loan_id,
                        SUM(amount) as total_paid,
                        SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END) as remaining_balance,
                        MIN(CASE WHEN status = 'pending' THEN due_date ELSE NULL END) as next_payment_date,
                        DATEDIFF(CURDATE(), MIN(CASE WHEN status = 'pending' THEN due_date ELSE NULL END)) as days_overdue
                    FROM loan_schedules
                    GROUP BY loan_id
                ) c ON l.id = c.loan_id
                {$whereClause}
                ORDER BY l.created_at DESC
                LIMIT ? OFFSET ?
            ";
            
            $params[] = $limit;
            $params[] = $offset;
            
            $stmt = $this->db->prepare($query);
            $stmt->execute($params);
            $loans = $stmt->fetchAll();
            
            // Format response
            $formattedLoans = [];
            foreach ($loans as $loan) {
                $formattedLoans[] = [
                    'id' => $loan['id'],
                    'loan_number' => $loan['loan_number'],
                    'member' => [
                        'id' => $loan['member_id'],
                        'member_number' => $loan['member_number'],
                        'name' => $loan['member_name'],
                        'phone' => $loan['phone'],
                        'email' => $loan['email']
                    ],
                    'product' => [
                        'id' => $loan['product_id'],
                        'name' => $loan['product_name'],
                        'interest_rate' => $loan['interest_rate'],
                        'tenure_months' => $loan['tenure_months']
                    ],
                    'amount' => floatval($loan['amount']),
                    'interest_rate' => floatval($loan['interest_rate']),
                    'tenure_months' => $loan['tenure_months'],
                    'monthly_payment' => floatval($loan['monthly_payment']),
                    'disbursement_date' => $loan['disbursement_date'],
                    'status' => $loan['status'],
                    'created_at' => $loan['created_at'],
                    'branch' => [
                        'id' => $loan['branch_id'],
                        'name' => $loan['branch_name']
                    ],
                    'created_by' => $loan['created_by_username'],
                    'payment_summary' => [
                        'total_paid' => floatval($loan['total_paid'] ?? 0),
                        'remaining_balance' => floatval($loan['remaining_balance'] ?? $loan['amount']),
                        'next_payment_date' => $loan['next_payment_date'],
                        'days_overdue' => intval($loan['days_overdue'] ?? 0)
                    ]
                ];
            }
            
            $this->success($formattedLoans, 'Loans retrieved successfully', [
                'total' => $total,
                'page' => $page,
                'limit' => $limit,
                'total_pages' => ceil($total / $limit),
                'has_next' => $page < ceil($total / $limit),
                'has_prev' => $page > 1
            ]);
            
        } catch (PDOException $e) {
            Logger::error('Database error in loan index', [
                'error' => $e->getMessage(),
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to retrieve loans', 500);
        }
    }
    
    /**
     * Create new loan application
     * POST /api/loans
     */
    public function create() {
        $currentUser = $this->getCurrentUser();
        
        // Validate input
        $requiredFields = ['member_id', 'product_id', 'amount', 'purpose', 'tenure_months'];
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
            $productQuery = "SELECT * FROM loan_products WHERE id = ? AND is_active = 1";
            $stmt = $this->db->prepare($productQuery);
            $stmt->execute([$input['product_id']]);
            $product = $stmt->fetch();
            
            if (!$product) {
                $this->error('Loan product not found or inactive', 400);
                return;
            }
            
            // Validate loan amount
            if ($input['amount'] < $product['min_amount'] || $input['amount'] > $product['max_amount']) {
                $this->error('Loan amount must be between ' . $product['min_amount'] . ' and ' . $product['max_amount'], 400);
                return;
            }
            
            // Validate tenure
            if ($input['tenure_months'] < $product['min_tenure'] || $input['tenure_months'] > $product['max_tenure']) {
                $this->error('Tenure must be between ' . $product['min_tenure'] . ' and ' . $product['max_tenure'] . ' months', 400);
                return;
            }
            
            // Check member's existing loans
            $existingLoansQuery = "SELECT COUNT(*) as count FROM loans WHERE member_id = ? AND status IN ('active', 'late', 'default')";
            $stmt = $this->db->prepare($existingLoansQuery);
            $stmt->execute([$input['member_id']]);
            $existingLoans = $stmt->fetch()['count'];
            
            if ($existingLoans >= $product['max_concurrent_loans']) {
                $this->error('Member has reached maximum concurrent loans', 400);
                return;
            }
            
            // Calculate loan details
            $interestRate = $product['interest_rate'];
            $monthlyInterestRate = $interestRate / 100 / 12;
            $monthlyPayment = $input['amount'] * ($monthlyInterestRate * pow(1 + $monthlyInterestRate, $input['tenure_months'])) / (pow(1 + $monthlyInterestRate, $input['tenure_months']) - 1);
            
            // Generate loan number
            $loanNumber = $this->generateLoanNumber();
            
            // Start transaction
            $this->db->beginTransaction();
            
            try {
                // Create loan record
                $loanQuery = "
                    INSERT INTO loans (
                        loan_number, member_id, product_id, amount, interest_rate, 
                        tenure_months, monthly_payment, purpose, status, 
                        branch_id, created_by, created_at
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'draft', ?, ?, NOW())
                ";
                
                $stmt = $this->db->prepare($loanQuery);
                $stmt->execute([
                    $loanNumber,
                    $input['member_id'],
                    $input['product_id'],
                    $input['amount'],
                    $interestRate,
                    $input['tenure_months'],
                    $monthlyPayment,
                    $input['purpose'],
                    $currentUser['branch_id'],
                    $currentUser['user_id']
                ]);
                
                $loanId = $this->db->lastInsertId();
                
                // Create loan schedule
                $this->createLoanSchedule($loanId, $input['amount'], $monthlyPayment, $input['tenure_months'], $interestRate);
                
                // Update member's credit score
                $this->updateMemberCreditScore($input['member_id']);
                
                // Log activity
                Logger::info('Loan created', [
                    'loan_id' => $loanId,
                    'loan_number' => $loanNumber,
                    'member_id' => $input['member_id'],
                    'amount' => $input['amount'],
                    'user_id' => $currentUser['user_id']
                ]);
                
                // Commit transaction
                $this->db->commit();
                
                // Get created loan details
                $this->getLoanDetails($loanId);
                
            } catch (Exception $e) {
                $this->db->rollback();
                throw $e;
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in loan creation', [
                'error' => $e->getMessage(),
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to create loan', 500);
        }
    }
    
    /**
     * Get specific loan details
     * GET /api/loans/{id}
     */
    public function show($id) {
        $currentUser = $this->getCurrentUser();
        $loanId = intval($id);
        
        try {
            $query = "
                SELECT 
                    l.*,
                    m.member_number,
                    p.name as member_name,
                    p.phone,
                    p.email,
                    p.address,
                    lp.name as product_name,
                    lp.interest_rate as product_interest_rate,
                    lp.tenure_months as product_tenure,
                    lp.description as product_description,
                    b.name as branch_name,
                    u.username as created_by_username,
                    u2.username as approved_by_username,
                    u3.username as disbursed_by_username
                FROM loans l
                LEFT JOIN members m ON l.member_id = m.id
                LEFT JOIN schema_person.persons p ON m.person_id = p.id
                LEFT JOIN loan_products lp ON l.product_id = lp.id
                LEFT JOIN branches b ON l.branch_id = b.id
                LEFT JOIN users u ON l.created_by = u.id
                LEFT JOIN users u2 ON l.approved_by = u2.id
                LEFT JOIN users u3 ON l.disbursed_by = u3.id
                WHERE l.id = ?
            ";
            
            $stmt = $this->db->prepare($query);
            $stmt->execute([$loanId]);
            $loan = $stmt->fetch();
            
            if (!$loan) {
                $this->error('Loan not found', 404);
                return;
            }
            
            // Check permissions
            if (!$this->hasLoanAccess($loan, $currentUser)) {
                $this->error('Access denied', 403);
                return;
            }
            
            // Get loan schedule
            $scheduleQuery = "
                SELECT 
                    ls.*,
                    CASE 
                        WHEN ls.status = 'paid' THEN 'success'
                        WHEN ls.status = 'pending' AND ls.due_date < CURDATE() THEN 'danger'
                        WHEN ls.status = 'pending' AND ls.due_date <= DATE_ADD(CURDATE(), INTERVAL 7 DAY) THEN 'warning'
                        ELSE 'primary'
                    END as status_color
                FROM loan_schedules ls
                WHERE ls.loan_id = ?
                ORDER BY ls.installment_number
            ";
            
            $stmt = $this->db->prepare($scheduleQuery);
            $stmt->execute([$loanId]);
            $schedule = $stmt->fetchAll();
            
            // Get payment history
            $paymentQuery = "
                SELECT 
                    lp.*,
                    u.username as created_by_username
                FROM loan_payments lp
                LEFT JOIN users u ON lp.created_by = u.id
                WHERE lp.loan_id = ?
                ORDER BY lp.created_at DESC
            ";
            
            $stmt = $this->db->prepare($paymentQuery);
            $stmt->execute([$loanId]);
            $payments = $stmt->fetchAll();
            
            // Calculate summary
            $totalPaid = array_sum(array_column($payments, 'amount'));
            $remainingBalance = $loan['amount'] - $totalPaid;
            $paidInstallments = count(array_filter($schedule, fn($s) => $s['status'] === 'paid'));
            $pendingInstallments = count(array_filter($schedule, fn($s) => $s['status'] === 'pending'));
            $overdueInstallments = count(array_filter($schedule, fn($s) => $s['status'] === 'pending' && $s['due_date'] < date('Y-m-d')));
            
            $response = [
                'id' => $loan['id'],
                'loan_number' => $loan['loan_number'],
                'member' => [
                    'id' => $loan['member_id'],
                    'member_number' => $loan['member_number'],
                    'name' => $loan['member_name'],
                    'phone' => $loan['phone'],
                    'email' => $loan['email'],
                    'address' => $loan['address']
                ],
                'product' => [
                    'id' => $loan['product_id'],
                    'name' => $loan['product_name'],
                    'interest_rate' => $loan['product_interest_rate'],
                    'tenure_months' => $loan['product_tenure'],
                    'description' => $loan['product_description']
                ],
                'amount' => floatval($loan['amount']),
                'interest_rate' => floatval($loan['interest_rate']),
                'tenure_months' => $loan['tenure_months'],
                'monthly_payment' => floatval($loan['monthly_payment']),
                'purpose' => $loan['purpose'],
                'status' => $loan['status'],
                'disbursement_date' => $loan['disbursement_date'],
                'created_at' => $loan['created_at'],
                'approved_at' => $loan['approved_at'],
                'disbursed_at' => $loan['disbursed_at'],
                'branch' => [
                    'id' => $loan['branch_id'],
                    'name' => $loan['branch_name']
                ],
                'staff' => [
                    'created_by' => $loan['created_by_username'],
                    'approved_by' => $loan['approved_by_username'],
                    'disbursed_by' => $loan['disbursed_by_username']
                ],
                'summary' => [
                    'total_paid' => $totalPaid,
                    'remaining_balance' => $remainingBalance,
                    'paid_installments' => $paidInstallments,
                    'pending_installments' => $pendingInstallments,
                    'overdue_installments' => $overdueInstallments,
                    'completion_percentage' => round(($totalPaid / $loan['amount']) * 100, 2)
                ],
                'schedule' => $schedule,
                'payments' => $payments
            ];
            
            $this->success($response, 'Loan details retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in loan details', [
                'error' => $e->getMessage(),
                'loan_id' => $loanId,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to retrieve loan details', 500);
        }
    }
    
    /**
     * Update loan status (approve, reject, disburse)
     * PUT /api/loans/{id}/status
     */
    public function updateStatus($id) {
        $currentUser = $this->getCurrentUser();
        $loanId = intval($id);
        
        // Validate input
        $input = $this->validate(['status', 'notes']);
        
        if (!$input) {
            return;
        }
        
        $allowedStatuses = ['submitted', 'approved', 'rejected', 'disbursed', 'active', 'completed', 'default'];
        
        if (!in_array($input['status'], $allowedStatuses)) {
            $this->error('Invalid status', 400);
            return;
        }
        
        try {
            // Get current loan
            $query = "SELECT * FROM loans WHERE id = ?";
            $stmt = $this->db->prepare($query);
            $stmt->execute([$loanId]);
            $loan = $stmt->fetch();
            
            if (!$loan) {
                $this->error('Loan not found', 404);
                return;
            }
            
            // Check permissions
            if (!$this->hasLoanAccess($loan, $currentUser)) {
                $this->error('Access denied', 403);
                return;
            }
            
            // Validate status transition
            if (!$this->isValidStatusTransition($loan['status'], $input['status'])) {
                $this->error('Invalid status transition', 400);
                return;
            }
            
            // Update loan status
            $updateQuery = "
                UPDATE loans 
                SET status = ?, notes = ?, 
                    approved_by = ?, approved_at = ?,
                    disbursed_by = ?, disbursed_at = ?,
                    updated_at = NOW()
                WHERE id = ?
            ";
            
            $approvedBy = $input['status'] === 'approved' ? $currentUser['user_id'] : $loan['approved_by'];
            $approvedAt = $input['status'] === 'approved' ? date('Y-m-d H:i:s') : $loan['approved_at'];
            $disbursedBy = $input['status'] === 'disbursed' ? $currentUser['user_id'] : $loan['disbursed_by'];
            $disbursedAt = $input['status'] === 'disbursed' ? date('Y-m-d H:i:s') : $loan['disbursed_at'];
            
            $stmt = $this->db->prepare($updateQuery);
            $stmt->execute([
                $input['status'],
                $input['notes'] ?? null,
                $approvedBy,
                $approvedAt,
                $disbursedBy,
                $disbursedAt,
                $loanId
            ]);
            
            // Handle specific status actions
            if ($input['status'] === 'approved') {
                $this->handleLoanApproval($loanId);
            } elseif ($input['status'] === 'disbursed') {
                $this->handleLoanDisbursement($loanId);
            } elseif ($input['status'] === 'default') {
                $this->handleLoanDefault($loanId);
            }
            
            // Log activity
            Logger::info('Loan status updated', [
                'loan_id' => $loanId,
                'old_status' => $loan['status'],
                'new_status' => $input['status'],
                'user_id' => $currentUser['user_id'],
                'notes' => $input['notes'] ?? null
            ]);
            
            // Get updated loan details
            $this->show($loanId);
            
        } catch (PDOException $e) {
            Logger::error('Database error in loan status update', [
                'error' => $e->getMessage(),
                'loan_id' => $loanId,
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to update loan status', 500);
        }
    }
    
    /**
     * Make loan payment
     * POST /api/loans/{id}/payment
     */
    public function makePayment($id) {
        $currentUser = $this->getCurrentUser();
        $loanId = intval($id);
        
        // Validate input
        $input = $this->validate(['amount', 'payment_method', 'notes']);
        
        if (!$input) {
            return;
        }
        
        try {
            // Get loan details
            $query = "SELECT * FROM loans WHERE id = ?";
            $stmt = $this->db->prepare($query);
            $stmt->execute([$loanId]);
            $loan = $stmt->fetch();
            
            if (!$loan) {
                $this->error('Loan not found', 404);
                return;
            }
            
            // Check permissions
            if (!$this->hasLoanAccess($loan, $currentUser)) {
                $this->error('Access denied', 403);
                return;
            }
            
            // Validate loan status
            if (!in_array($loan['status'], ['active', 'late'])) {
                $this->error('Loan is not active for payment', 400);
                return;
            }
            
            // Get pending installments
            $scheduleQuery = "
                SELECT * FROM loan_schedules 
                WHERE loan_id = ? AND status = 'pending' 
                ORDER BY installment_number
                LIMIT 1
            ";
            
            $stmt = $this->db->prepare($scheduleQuery);
            $stmt->execute([$loanId]);
            $nextInstallment = $stmt->fetch();
            
            if (!$nextInstallment) {
                $this->error('No pending installments found', 400);
                return;
            }
            
            // Validate payment amount
            if ($input['amount'] <= 0) {
                $this->error('Payment amount must be greater than 0', 400);
                return;
            }
            
            if ($input['amount'] > $nextInstallment['amount']) {
                $this->error('Payment amount exceeds installment amount', 400);
                return;
            }
            
            // Start transaction
            $this->db->beginTransaction();
            
            try {
                // Create payment record
                $paymentQuery = "
                    INSERT INTO loan_payments (
                        loan_id, schedule_id, amount, payment_method, notes, 
                        status, created_by, created_at
                    ) VALUES (?, ?, ?, ?, ?, 'completed', ?, NOW())
                ";
                
                $stmt = $this->db->prepare($paymentQuery);
                $stmt->execute([
                    $loanId,
                    $nextInstallment['id'],
                    $input['amount'],
                    $input['payment_method'],
                    $input['notes'] ?? null,
                    $currentUser['user_id']
                ]);
                
                $paymentId = $this->db->lastInsertId();
                
                // Update installment status
                if ($input['amount'] >= $nextInstallment['amount']) {
                    // Full payment
                    $updateScheduleQuery = "
                        UPDATE loan_schedules 
                        SET status = 'paid', paid_amount = ?, paid_date = NOW(), payment_id = ?
                        WHERE id = ?
                    ";
                    
                    $stmt = $this->db->prepare($updateScheduleQuery);
                    $stmt->execute([$input['amount'], $paymentId, $nextInstallment['id']]);
                } else {
                    // Partial payment
                    $updateScheduleQuery = "
                        UPDATE loan_schedules 
                        SET paid_amount = COALESCE(paid_amount, 0) + ?, 
                            status = CASE 
                                WHEN COALESCE(paid_amount, 0) + ? >= amount THEN 'paid' 
                                ELSE 'partial' 
                            END,
                            paid_date = CASE 
                                WHEN COALESCE(paid_amount, 0) + ? >= amount THEN NOW() 
                                ELSE paid_date 
                            END
                        WHERE id = ?
                    ";
                    
                    $stmt = $this->db->prepare($updateScheduleQuery);
                    $stmt->execute([$input['amount'], $input['amount'], $input['amount'], $nextInstallment['id']]);
                }
                
                // Check if all installments are paid
                $checkQuery = "
                    SELECT COUNT(*) as pending_count 
                    FROM loan_schedules 
                    WHERE loan_id = ? AND status != 'paid'
                ";
                
                $stmt = $this->db->prepare($checkQuery);
                $stmt->execute([$loanId]);
                $pendingCount = $stmt->fetch()['pending_count'];
                
                if ($pendingCount == 0) {
                    // Mark loan as completed
                    $updateLoanQuery = "UPDATE loans SET status = 'completed', completed_at = NOW() WHERE id = ?";
                    $stmt = $this->db->prepare($updateLoanQuery);
                    $stmt->execute([$loanId]);
                }
                
                // Update member's credit score
                $this->updateMemberCreditScore($loan['member_id']);
                
                // Log activity
                Logger::info('Loan payment made', [
                    'loan_id' => $loanId,
                    'payment_id' => $paymentId,
                    'amount' => $input['amount'],
                    'payment_method' => $input['payment_method'],
                    'user_id' => $currentUser['user_id']
                ]);
                
                // Commit transaction
                $this->db->commit();
                
                $this->success([
                    'payment_id' => $paymentId,
                    'amount' => $input['amount'],
                    'payment_method' => $input['payment_method'],
                    'remaining_balance' => $nextInstallment['amount'] - $input['amount']
                ], 'Payment processed successfully');
                
            } catch (Exception $e) {
                $this->db->rollback();
                throw $e;
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in loan payment', [
                'error' => $e->getMessage(),
                'loan_id' => $loanId,
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to process payment', 500);
        }
    }
    
    /**
     * Get loan statistics
     * GET /api/loans/statistics
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
            
            // Get loan statistics
            $statsQuery = "
                SELECT 
                    COUNT(*) as total_loans,
                    COUNT(CASE WHEN status = 'draft' THEN 1 END) as draft_loans,
                    COUNT(CASE WHEN status = 'submitted' THEN 1 END) as submitted_loans,
                    COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_loans,
                    COUNT(CASE WHEN status = 'rejected' THEN 1 END) as rejected_loans,
                    COUNT(CASE WHEN status = 'disbursed' THEN 1 END) as disbursed_loans,
                    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_loans,
                    COUNT(CASE WHEN status = 'late' THEN 1 END) as late_loans,
                    COUNT(CASE WHEN status = 'default' THEN 1 END) as defaulted_loans,
                    COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_loans,
                    COALESCE(SUM(amount), 0) as total_disbursed,
                    COALESCE(SUM(CASE WHEN status IN ('active', 'late', 'default') THEN amount ELSE 0 END), 0) as outstanding_loans,
                    COALESCE(AVG(amount), 0) as average_loan_amount,
                    COUNT(CASE WHEN DATE(created_at) BETWEEN ? AND ? THEN 1 END) as new_loans_period
                FROM loans
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
                    COUNT(*) as loan_count,
                    COALESCE(SUM(amount), 0) as total_amount,
                    COALESCE(AVG(amount), 0) as average_amount
                FROM loans
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
            
            // Get portfolio distribution
            $portfolioQuery = "
                SELECT 
                    lp.name as product_name,
                    COUNT(l.id) as loan_count,
                    COALESCE(SUM(l.amount), 0) as total_amount,
                    COALESCE(SUM(CASE WHEN l.status IN ('active', 'late', 'default') THEN l.amount ELSE 0 END), 0) as outstanding_amount
                FROM loans l
                LEFT JOIN loan_products lp ON l.product_id = lp.id
                " . ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN ? "WHERE l.branch_id = ?" : "") . "
                GROUP BY lp.id, lp.name
                ORDER BY total_amount DESC
            ";
            
            $portfolioParams = [];
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $portfolioParams[] = $branchId;
            }
            
            $stmt = $this->db->prepare($portfolioQuery);
            $stmt->execute($portfolioParams);
            $portfolio = $stmt->fetchAll();
            
            // Calculate performance metrics
            $approvalRate = $stats['submitted_loans'] > 0 ? 
                round(($stats['approved_loans'] / $stats['submitted_loans']) * 100, 2) : 0;
            
            $completionRate = $stats['disbursed_loans'] > 0 ? 
                round(($stats['completed_loans'] / $stats['disbursed_loans']) * 100, 2) : 0;
            
            $defaultRate = $stats['disbursed_loans'] > 0 ? 
                round(($stats['defaulted_loans'] / $stats['disbursed_loans']) * 100, 2) : 0;
            
            $response = [
                'summary' => [
                    'total_loans' => intval($stats['total_loans']),
                    'active_loans' => intval($stats['active_loans']),
                    'completed_loans' => intval($stats['completed_loans']),
                    'late_loans' => intval($stats['late_loans']),
                    'defaulted_loans' => intval($stats['defaulted_loans']),
                    'total_disbursed' => floatval($stats['total_disbursed']),
                    'outstanding_loans' => floatval($stats['outstanding_loans']),
                    'average_loan_amount' => floatval($stats['average_loan_amount']),
                    'new_loans_period' => intval($stats['new_loans_period'])
                ],
                'performance' => [
                    'approval_rate' => $approvalRate,
                    'completion_rate' => $completionRate,
                    'default_rate' => $defaultRate
                ],
                'status_distribution' => [
                    'draft' => intval($stats['draft_loans']),
                    'submitted' => intval($stats['submitted_loans']),
                    'approved' => intval($stats['approved_loans']),
                    'rejected' => intval($stats['rejected_loans']),
                    'disbursed' => intval($stats['disbursed_loans']),
                    'active' => intval($stats['active_loans']),
                    'late' => intval($stats['late_loans']),
                    'default' => intval($stats['defaulted_loans']),
                    'completed' => intval($stats['completed_loans'])
                ],
                'monthly_trends' => $trends,
                'portfolio_distribution' => $portfolio
            ];
            
            $this->success($response, 'Loan statistics retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in loan statistics', [
                'error' => $e->getMessage(),
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to retrieve loan statistics', 500);
        }
    }
    
    /**
     * Helper methods
     */
    private function generateLoanNumber() {
        $prefix = 'LOAN';
        $date = date('Ymd');
        
        // Get last loan number for today
        $query = "SELECT loan_number FROM loans WHERE loan_number LIKE ? ORDER BY id DESC LIMIT 1";
        $stmt = $this->db->prepare($query);
        $stmt->execute(["{$prefix}{$date}%"]);
        $lastLoan = $stmt->fetch();
        
        if ($lastLoan) {
            $lastNumber = intval(substr($lastLoan['loan_number'], -4));
            $newNumber = $lastNumber + 1;
        } else {
            $newNumber = 1;
        }
        
        return $prefix . $date . str_pad($newNumber, 4, '0', STR_PAD_LEFT);
    }
    
    private function createLoanSchedule($loanId, $principal, $monthlyPayment, $tenureMonths, $annualRate) {
        $monthlyRate = $annualRate / 100 / 12;
        $balance = $principal;
        
        for ($i = 1; $i <= $tenureMonths; $i++) {
            $interestPayment = $balance * $monthlyRate;
            $principalPayment = $monthlyPayment - $interestPayment;
            $balance -= $principalPayment;
            
            // Ensure balance doesn't go negative due to rounding
            if ($balance < 0.01) {
                $balance = 0;
                $principalPayment += $balance;
            }
            
            $dueDate = date('Y-m-d', strtotime("+$i months"));
            
            $query = "
                INSERT INTO loan_schedules (
                    loan_id, installment_number, due_date, amount, 
                    principal_amount, interest_amount, balance, status
                ) VALUES (?, ?, ?, ?, ?, ?, ?, 'pending')
            ";
            
            $stmt = $this->db->prepare($query);
            $stmt->execute([
                $loanId,
                $i,
                $dueDate,
                $monthlyPayment,
                $principalPayment,
                $interestPayment,
                max(0, $balance)
            ]);
        }
    }
    
    private function updateMemberCreditScore($memberId) {
        // Get member's loan history
        $query = "
            SELECT 
                COUNT(*) as total_loans,
                COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_loans,
                COUNT(CASE WHEN status = 'default' THEN 1 END) as defaulted_loans,
                COUNT(CASE WHEN status = 'late' THEN 1 END) as late_loans,
                AVG(CASE WHEN status = 'completed' THEN 
                    DATEDIFF(completed_at, disbursement_date) 
                END) as avg_completion_days
            FROM loans 
            WHERE member_id = ?
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$memberId]);
        $history = $stmt->fetch();
        
        // Calculate credit score (simplified algorithm)
        $baseScore = 700;
        
        // Adjust based on completion rate
        if ($history['total_loans'] > 0) {
            $completionRate = $history['completed_loans'] / $history['total_loans'];
            $baseScore += ($completionRate - 0.5) * 200;
        }
        
        // Penalize defaults
        if ($history['defaulted_loans'] > 0) {
            $baseScore -= $history['defaulted_loans'] * 100;
        }
        
        // Penalize late payments
        if ($history['late_loans'] > 0) {
            $baseScore -= $history['late_loans'] * 20;
        }
        
        // Bonus for quick completion
        if ($history['avg_completion_days'] && $history['avg_completion_days'] < 365) {
            $baseScore += 50;
        }
        
        // Ensure score is within bounds
        $creditScore = max(300, min(850, round($baseScore)));
        
        // Update member's credit score
        $updateQuery = "UPDATE members SET credit_score = ?, updated_at = NOW() WHERE id = ?";
        $stmt = $this->db->prepare($updateQuery);
        $stmt->execute([$creditScore, $memberId]);
    }
    
    private function hasLoanAccess($loan, $currentUser) {
        // Admin and super admin can access all loans
        if (in_array($currentUser['role'], [ROLE_SUPER_ADMIN, ROLE_ADMIN])) {
            return true;
        }
        
        // Branch managers can access loans from their branch
        if (in_array($currentUser['role'], [ROLE_BRANCH_HEAD, ROLE_UNIT_HEAD, ROLE_SUPERVISOR])) {
            return $loan['branch_id'] == $currentUser['branch_id'];
        }
        
        // Collectors and cashiers can only access loans they created or are assigned to
        if (in_array($currentUser['role'], [ROLE_COLLECTOR, ROLE_CASHIER])) {
            return $loan['created_by'] == $currentUser['user_id'];
        }
        
        return false;
    }
    
    private function isValidStatusTransition($currentStatus, $newStatus) {
        $validTransitions = [
            'draft' => ['submitted', 'rejected'],
            'submitted' => ['approved', 'rejected'],
            'approved' => ['disbursed', 'rejected'],
            'disbursed' => ['active'],
            'active' => ['late', 'completed', 'default'],
            'late' => ['active', 'default', 'completed'],
            'default' => ['completed'],
            'completed' => [],
            'rejected' => []
        ];
        
        return in_array($newStatus, $validTransitions[$currentStatus] ?? []);
    }
    
    private function handleLoanApproval($loanId) {
        // Additional actions when loan is approved
        // Could include: sending notifications, updating member limits, etc.
    }
    
    private function handleLoanDisbursement($loanId) {
        // Additional actions when loan is disbursed
        // Could include: transferring funds, updating member account, etc.
    }
    
    private function handleLoanDefault($loanId) {
        // Additional actions when loan is defaulted
        // Could include: penalty calculation, credit score impact, etc.
    }
    
    private function getLoanDetails($loanId) {
        // Get and return loan details after creation
        $this->show($loanId);
    }
}

?>
