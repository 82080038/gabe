<?php
/**
 * ================================================================
 * DASHBOARD CONTROLLER - KOPERASI BERJALAN
 * Maintainable dashboard with comprehensive statistics and metrics
 * ================================================================ */

require_once __DIR__ . '/../index.php';

class DashboardController extends BaseController {
    
    /**
     * Get dashboard statistics
     * GET /api/dashboard/stats
     */
    public function stats() {
        $currentUser = $this->getCurrentUser();
        $branchId = $currentUser['branch_id'];
        $role = $currentUser['role'];
        
        try {
            $stats = [];
            
            // Get basic counts
            $stats['members'] = $this->getMemberStats($branchId, $role);
            $stats['loans'] = $this->getLoanStats($branchId, $role);
            $stats['savings'] = $this->getSavingsStats($branchId, $role);
            $stats['financial'] = $this->getFinancialStats($branchId, $role);
            $stats['performance'] = $this->getPerformanceStats($branchId, $role);
            
            // Add role-specific data
            if ($role === ROLE_COLLECTOR) {
                $stats['collection'] = $this->getCollectionStats($currentUser['user_id']);
            } elseif ($role === ROLE_CASHIER) {
                $stats['transactions'] = $this->getTransactionStats($branchId);
            }
            
            $this->success($stats, 'Dashboard statistics retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in dashboard stats', [
                'error' => $e->getMessage(),
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to retrieve dashboard statistics', 500);
        }
    }
    
    /**
     * Get recent activity
     * GET /api/dashboard/recent-activity
     */
    public function recentActivity() {
        $currentUser = $this->getCurrentUser();
        $branchId = $currentUser['branch_id'];
        $role = $currentUser['role'];
        $limit = min(50, max(5, intval($_GET['limit'] ?? 10)));
        
        try {
            $activities = [];
            
            // Get recent loans
            if ($this->hasPermission(['loans'])) {
                $loanActivities = $this->getRecentLoanActivities($branchId, $role, $limit);
                $activities = array_merge($activities, $loanActivities);
            }
            
            // Get recent savings transactions
            if ($this->hasPermission(['savings'])) {
                $savingsActivities = $this->getRecentSavingsActivities($branchId, $role, $limit);
                $activities = array_merge($activities, $savingsActivities);
            }
            
            // Get recent user activities (for admins)
            if (in_array($role, [ROLE_SUPER_ADMIN, ROLE_ADMIN, ROLE_UNIT_HEAD, ROLE_BRANCH_HEAD])) {
                $userActivities = $this->getRecentUserActivities($branchId, $limit);
                $activities = array_merge($activities, $userActivities);
            }
            
            // Sort by date and limit
            usort($activities, function($a, $b) {
                return strtotime($b['timestamp']) - strtotime($a['timestamp']);
            });
            
            $activities = array_slice($activities, 0, $limit);
            
            $this->success($activities, 'Recent activity retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in recent activity', [
                'error' => $e->getMessage(),
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to retrieve recent activity', 500);
        }
    }
    
    /**
     * Get performance metrics
     * GET /api/dashboard/performance
     */
    public function performance() {
        $currentUser = $this->getCurrentUser();
        $branchId = $currentUser['branch_id'];
        $role = $currentUser['role'];
        $period = sanitizeInput($_GET['period'] ?? 'month'); // day, week, month, quarter, year
        
        try {
            $performance = [];
            
            // Collection performance
            if ($this->hasPermission(['collections'])) {
                $performance['collections'] = $this->getCollectionPerformance($branchId, $period);
            }
            
            // Loan performance
            if ($this->hasPermission(['loans'])) {
                $performance['loans'] = $this->getLoanPerformance($branchId, $period);
            }
            
            // Savings performance
            if ($this->hasPermission(['savings'])) {
                $performance['savings'] = $this->getSavingsPerformance($branchId, $period);
            }
            
            // Staff performance (for managers)
            if (in_array($role, [ROLE_SUPER_ADMIN, ROLE_ADMIN, ROLE_UNIT_HEAD, ROLE_BRANCH_HEAD, ROLE_SUPERVISOR])) {
                $performance['staff'] = $this->getStaffPerformance($branchId, $period);
            }
            
            $this->success($performance, 'Performance metrics retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in performance metrics', [
                'error' => $e->getMessage(),
                'user_role' => $role,
                'branch_id' => $branchId,
                'period' => $period
            ]);
            $this->error('Failed to retrieve performance metrics', 500);
        }
    }
    
    /**
     * Get member statistics
     */
    private function getMemberStats($branchId, $role) {
        $whereClause = "";
        $params = [];
        
        if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
            $whereClause = "WHERE branch_id = ?";
            $params[] = $branchId;
        }
        
        $query = "
            SELECT 
                COUNT(*) as total_members,
                COUNT(CASE WHEN status = 'active' THEN 1 END) as active_members,
                COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_members,
                COUNT(CASE WHEN status = 'suspended' THEN 1 END) as suspended_members,
                COUNT(CASE WHEN DATE(created_at) = CURDATE() THEN 1 END) as new_members_today,
                COUNT(CASE WHEN DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as new_members_week,
                COUNT(CASE WHEN DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 1 END) as new_members_month
            FROM members
            {$whereClause}
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        return $stmt->fetch();
    }
    
    /**
     * Get loan statistics
     */
    private function getLoanStats($branchId, $role) {
        $whereClause = "";
        $params = [];
        
        if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
            $whereClause = "WHERE l.branch_id = ?";
            $params[] = $branchId;
        }
        
        $query = "
            SELECT 
                COUNT(*) as total_loans,
                COUNT(CASE WHEN l.status = 'active' THEN 1 END) as active_loans,
                COUNT(CASE WHEN l.status = 'completed' THEN 1 END) as completed_loans,
                COUNT(CASE WHEN l.status = 'late' THEN 1 END) as late_loans,
                COUNT(CASE WHEN l.status = 'default' THEN 1 END) as defaulted_loans,
                COUNT(CASE WHEN DATE(l.disbursement_date) = CURDATE() THEN 1 END) as loans_today,
                COUNT(CASE WHEN DATE(l.disbursement_date) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as loans_week,
                COUNT(CASE WHEN DATE(l.disbursement_date) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 1 END) as loans_month,
                COALESCE(SUM(CASE WHEN l.status = 'active' THEN l.amount ELSE 0 END), 0) as total_outstanding,
                COALESCE(SUM(l.amount), 0) as total_disbursed,
                COALESCE(AVG(l.amount), 0) as average_loan_amount
            FROM loans l
            {$whereClause}
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        return $stmt->fetch();
    }
    
    /**
     * Get savings statistics
     */
    private function getSavingsStats($branchId, $role) {
        $whereClause = "";
        $params = [];
        
        if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
            $whereClause = "WHERE sa.branch_id = ?";
            $params[] = $branchId;
        }
        
        $query = "
            SELECT 
                COUNT(DISTINCT sa.id) as total_savings_accounts,
                COUNT(DISTINCT sa.member_id) as members_with_savings,
                COUNT(DISTINCT sa.member_id) as active_savers,
                COALESCE(SUM(sa.balance), 0) as total_savings_balance,
                COALESCE(SUM(sd.amount), 0) as total_deposits_today,
                COUNT(CASE WHEN DATE(sd.deposit_date) = CURDATE() THEN 1 END) as deposits_today,
                COUNT(CASE WHEN DATE(sd.deposit_date) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as deposits_week,
                COUNT(CASE WHEN DATE(sd.deposit_date) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 1 END) as deposits_month,
                COALESCE(AVG(sa.balance), 0) as average_savings_balance
            FROM savings_accounts sa
            LEFT JOIN savings_deposits sd ON sa.id = sd.account_id
            {$whereClause}
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        return $stmt->fetch();
    }
    
    /**
     * Get financial statistics
     */
    private function getFinancialStats($branchId, $role) {
        $whereClause = "";
        $params = [];
        
        if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
            $whereClause = "WHERE branch_id = ?";
            $params[] = $branchId;
        }
        
        // Get current month financial data
        $query = "
            SELECT 
                COALESCE(SUM(CASE WHEN jd.debit > 0 THEN jd.debit ELSE 0 END), 0) as total_debits,
                COALESCE(SUM(CASE WHEN jd.credit > 0 THEN jd.credit ELSE 0 END), 0) as total_credits,
                COALESCE(SUM(CASE WHEN jd.debit > 0 THEN jd.debit ELSE 0 END) - 
                         SUM(CASE WHEN jd.credit > 0 THEN jd.credit ELSE 0 END), 0) as net_flow,
                COUNT(DISTINCT j.id) as total_transactions
            FROM journals j
            JOIN journal_details jd ON j.id = jd.journal_id
            WHERE DATE(j.created_at) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
            " . ($whereClause ? "AND {$whereClause}" : "")
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        return $stmt->fetch();
    }
    
    /**
     * Get performance statistics
     */
    private function getPerformanceStats($branchId, $role) {
        $stats = [];
        
        // Collection rate
        if ($this->hasPermission(['collections'])) {
            $stats['collection_rate'] = $this->getCollectionRate($branchId);
        }
        
        // Loan approval rate
        if ($this->hasPermission(['loans'])) {
            $stats['loan_approval_rate'] = $this->getLoanApprovalRate($branchId);
        }
        
        // Savings growth rate
        if ($this->hasPermission(['savings'])) {
            $stats['savings_growth_rate'] = $this->getSavingsGrowthRate($branchId);
        }
        
        return $stats;
    }
    
    /**
     * Get collection statistics (for collectors)
     */
    private function getCollectionStats($collectorId) {
        $query = "
            SELECT 
                COUNT(*) as total_collections,
                COUNT(CASE WHEN status = 'collected' THEN 1 END) as successful_collections,
                COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_collections,
                COUNT(CASE WHEN status = 'failed' THEN 1 END) as failed_collections,
                COALESCE(SUM(CASE WHEN status = 'collected' THEN amount ELSE 0 END), 0) as total_collected,
                COUNT(CASE WHEN DATE(collection_date) = CURDATE() THEN 1 END) as collections_today
            FROM collections
            WHERE collector_id = ?
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$collectorId]);
        return $stmt->fetch();
    }
    
    /**
     * Get transaction statistics (for cashiers)
     */
    private function getTransactionStats($branchId) {
        $query = "
            SELECT 
                COUNT(*) as total_transactions,
                COUNT(CASE WHEN DATE(created_at) = CURDATE() THEN 1 END) as transactions_today,
                COUNT(CASE WHEN DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) THEN 1 END) as transactions_week,
                COUNT(CASE WHEN DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN 1 END) as transactions_month,
                COALESCE(SUM(CASE WHEN jd.debit > 0 THEN jd.debit ELSE 0 END), 0) as total_debits_today,
                COALESCE(SUM(CASE WHEN jd.credit > 0 THEN jd.credit ELSE 0 END), 0) as total_credits_today
            FROM journals j
            JOIN journal_details jd ON j.id = jd.journal_id
            WHERE j.branch_id = ? AND DATE(j.created_at) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$branchId]);
        return $stmt->fetch();
    }
    
    /**
     * Get recent loan activities
     */
    private function getRecentLoanActivities($branchId, $role, $limit) {
        $whereClause = "";
        $params = [];
        
        if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
            $whereClause = "WHERE l.branch_id = ?";
            $params[] = $branchId;
        }
        
        $query = "
            SELECT 
                l.id,
                l.member_id,
                l.amount,
                l.status,
                l.disbursement_date,
                l.created_at,
                m.member_number,
                p.name as member_name,
                lp.name as product_name,
                u.username as created_by_username
            FROM loans l
            LEFT JOIN members m ON l.member_id = m.id
            LEFT JOIN schema_person.persons p ON m.person_id = p.id
            LEFT JOIN loan_products lp ON l.product_id = lp.id
            LEFT JOIN users u ON l.created_by = u.id
            {$whereClause}
            ORDER BY l.created_at DESC
            LIMIT ?
        ";
        
        $params[] = $limit;
        
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        
        $activities = [];
        while ($row = $stmt->fetch()) {
            $activities[] = [
                'type' => 'loan',
                'action' => $this->getLoanAction($row['status']),
                'description' => "Loan {$row['amount']} for {$row['member_name']} ({$row['product_name']})",
                'timestamp' => $row['created_at'],
                'user' => $row['created_by_username'],
                'data' => $row
            ];
        }
        
        return $activities;
    }
    
    /**
     * Get recent savings activities
     */
    private function getRecentSavingsActivities($branchId, $role, $limit) {
        $whereClause = "";
        $params = [];
        
        if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
            $whereClause = "WHERE sa.branch_id = ?";
            $params[] = $branchId;
        }
        
        $query = "
            SELECT 
                sd.id,
                sd.amount,
                sd.payment_method,
                sd.deposit_date,
                sd.created_at,
                sa.account_number,
                m.member_number,
                p.name as member_name,
                sp.name as product_name,
                u.username as created_by_username
            FROM savings_deposits sd
            LEFT JOIN savings_accounts sa ON sd.account_id = sa.id
            LEFT JOIN members m ON sa.member_id = m.id
            LEFT JOIN schema_person.persons p ON m.person_id = p.id
            LEFT JOIN savings_products sp ON sa.product_id = sp.id
            LEFT JOIN users u ON sd.created_by = u.id
            {$whereClause}
            ORDER BY sd.created_at DESC
            LIMIT ?
        ";
        
        $params[] = $limit;
        
        $stmt = $this->db->prepare($query);
        $stmt->execute($params);
        
        $activities = [];
        while ($row = $stmt->fetch()) {
            $activities[] = [
                'type' => 'savings',
                'action' => 'deposit',
                'description' => "Deposit {$row['amount']} for {$row['member_name']} ({$row['product_name']})",
                'timestamp' => $row['created_at'],
                'user' => $row['created_by_username'],
                'data' => $row
            ];
        }
        
        return $activities;
    }
    
    /**
     * Get recent user activities
     */
    private function getRecentUserActivities($branchId, $limit) {
        $query = "
            SELECT 
                al.id,
                al.action,
                al.details,
                al.created_at,
                al.ip,
                al.user_agent,
                u.username
            FROM audit_logs al
            LEFT JOIN users u ON JSON_EXTRACT(al.details, '$.user_id') = u.id
            WHERE al.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
            AND JSON_EXTRACT(al.details, '$.branch_id') = ?
            ORDER BY al.created_at DESC
            LIMIT ?
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$branchId, $limit]);
        
        $activities = [];
        while ($row = $stmt->fetch()) {
            $activities[] = [
                'type' => 'user',
                'action' => $row['action'],
                'description' => $this->formatActivityDescription($row['action'], $row['details']),
                'timestamp' => $row['created_at'],
                'user' => $row['username'],
                'data' => [
                    'ip' => $row['ip'],
                    'user_agent' => $row['user_agent']
                ]
            ];
        }
        
        return $activities;
    }
    
    /**
     * Get collection performance
     */
    private function getCollectionPerformance($branchId, $period) {
        $dateCondition = $this->getDateCondition($period);
        
        $query = "
            SELECT 
                COUNT(*) as total_collections,
                COUNT(CASE WHEN status = 'collected' THEN 1 END) as successful_collections,
                COUNT(CASE WHEN status = 'failed' THEN 1 END) as failed_collections,
                COALESCE(SUM(CASE WHEN status = 'collected' THEN amount ELSE 0 END), 0) as total_collected,
                COALESCE(SUM(CASE WHEN status = 'collected' THEN amount ELSE 0 END) / 
                         COUNT(CASE WHEN status = 'collected' THEN 1 END), 0) as average_collection,
                COUNT(CASE WHEN status = 'collected' THEN 1 END) * 100.0 / COUNT(*) as success_rate
            FROM collections
            WHERE branch_id = ? AND {$dateCondition}
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$branchId]);
        return $stmt->fetch();
    }
    
    /**
     * Get loan performance
     */
    private function getLoanPerformance($branchId, $period) {
        $dateCondition = $this->getDateCondition($period);
        
        $query = "
            SELECT 
                COUNT(*) as total_loans,
                COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_loans,
                COUNT(CASE WHEN status = 'rejected' THEN 1 END) as rejected_loans,
                COUNT(CASE WHEN status = 'disbursed' THEN 1 END) as disbursed_loans,
                COUNT(CASE WHEN status = 'late' THEN 1 END) as late_loans,
                COUNT(CASE WHEN status = 'default' THEN 1 END) as defaulted_loans,
                COALESCE(SUM(CASE WHEN status = 'disbursed' THEN amount ELSE 0 END), 0) as total_disbursed,
                COUNT(CASE WHEN status = 'approved' THEN 1 END) * 100.0 / COUNT(*) as approval_rate
            FROM loans
            WHERE branch_id = ? AND {$dateCondition}
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$branchId]);
        return $stmt->fetch();
    }
    
    /**
     * Get savings performance
     */
    private function getSavingsPerformance($branchId, $period) {
        $dateCondition = $this->getDateCondition($period);
        
        $query = "
            SELECT 
                COUNT(DISTINCT sd.id) as total_deposits,
                COUNT(DISTINCT sa.member_id) as active_savers,
                COALESCE(SUM(sd.amount), 0) as total_deposits,
                COALESCE(SUM(sd.amount) / COUNT(DISTINCT sd.id), 0) as average_deposit,
                COALESCE(SUM(sa.balance), 0) as total_balance,
                COALESCE(SUM(sa.balance) / COUNT(DISTINCT sa.member_id), 0) as average_balance
            FROM savings_deposits sd
            LEFT JOIN savings_accounts sa ON sd.account_id = sa.id
            WHERE sa.branch_id = ? AND {$dateCondition}
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$branchId]);
        return $stmt->fetch();
    }
    
    /**
     * Get staff performance
     */
    private function getStaffPerformance($branchId, $period) {
        $dateCondition = $this->getDateCondition($period);
        
        $query = "
            SELECT 
                u.id,
                u.username,
                u.role,
                p.name as person_name,
                COUNT(DISTINCT CASE WHEN al.action LIKE '%CREATED%' THEN al.id END) as created_records,
                COUNT(DISTINCT CASE WHEN al.action LIKE '%UPDATED%' THEN al.id END) as updated_records,
                COUNT(DISTINCT al.id) as total_activities
            FROM users u
            LEFT JOIN schema_person.persons p ON u.person_id = p.id
            LEFT JOIN audit_logs al ON JSON_EXTRACT(al.details, '$.user_id') = u.id
            WHERE u.branch_id = ? AND u.is_active = 1 AND {$dateCondition}
            GROUP BY u.id, u.username, u.role, p.name
            ORDER BY total_activities DESC
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$branchId]);
        
        $staff = [];
        while ($row = $stmt->fetch()) {
            $staff[] = [
                'id' => $row['id'],
                'username' => $row['username'],
                'role' => $row['role'],
                'name' => $row['person_name'],
                'performance' => [
                    'created_records' => (int)$row['created_records'],
                    'updated_records' => (int)$row['updated_records'],
                    'total_activities' => (int)$row['total_activities']
                ]
            ];
        }
        
        return $staff;
    }
    
    /**
     * Helper methods
     */
    private function hasPermission($permissions) {
        $user = $this->getCurrentUser();
        $userPermissions = $this->getUserPermissions($user['role']);
        
        foreach ($permissions as $permission) {
            if (in_array($permission, $userPermissions) || in_array('all', $userPermissions)) {
                return true;
            }
        }
        
        return false;
    }
    
    private function getLoanAction($status) {
        $actions = [
            'draft' => 'created',
            'submitted' => 'submitted',
            'approved' => 'approved',
            'rejected' => 'rejected',
            'disbursed' => 'disbursed',
            'active' => 'active',
            'late' => 'late',
            'default' => 'defaulted',
            'completed' => 'completed'
        ];
        
        return $actions[$status] ?? 'unknown';
    }
    
    private function formatActivityDescription($action, $details) {
        $detailsArray = json_decode($details, true);
        
        switch ($action) {
            case 'LOGIN_SUCCESS':
                return "User logged in";
            case 'LOGIN_FAILED':
                return "Login failed for user: " . ($detailsArray['username'] ?? 'unknown');
            case 'USER_CREATED':
                return "User created: " . ($detailsArray['username'] ?? 'unknown');
            case 'LOAN_CREATED':
                return "Loan created for member: " . ($detailsArray['member_id'] ?? 'unknown');
            case 'SAVINGS_DEPOSIT':
                return "Savings deposit: " . ($detailsArray['amount'] ?? 'unknown');
            default:
                return $action;
        }
    }
    
    private function getDateCondition($period) {
        switch ($period) {
            case 'day':
                return "DATE(created_at) = CURDATE()";
            case 'week':
                return "DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
            case 'month':
                return "DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
            case 'quarter':
                return "DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)";
            case 'year':
                return "DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 365 DAY)";
            default:
                return "DATE(created_at) >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
        }
    }
    
    private function getCollectionRate($branchId) {
        $query = "
            SELECT 
                COUNT(CASE WHEN status = 'collected' THEN 1 END) * 100.0 / COUNT(*) as rate
            FROM collections
            WHERE branch_id = ? AND collection_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$branchId]);
        $result = $stmt->fetch();
        return $result['rate'] ?? 0;
    }
    
    private function getLoanApprovalRate($branchId) {
        $query = "
            SELECT 
                COUNT(CASE WHEN status = 'approved' THEN 1 END) * 100.0 / COUNT(*) as rate
            FROM loans
            WHERE branch_id = ? AND created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$branchId]);
        $result = $stmt->fetch();
        return $result['rate'] ?? 0;
    }
    
    private function getSavingsGrowthRate($branchId) {
        $query = "
            SELECT 
                (SUM(CASE WHEN created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN balance ELSE 0 END) -
                 SUM(CASE WHEN created_at < DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN balance ELSE 0 END)) * 100.0 /
                NULLIF(SUM(CASE WHEN created_at < DATE_SUB(CURDATE(), INTERVAL 30 DAY) THEN balance ELSE 0 END), 0) as rate
            FROM savings_accounts
            WHERE branch_id = ?
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$branchId]);
        $result = $stmt->fetch();
        return $result['rate'] ?? 0;
    }
}

?>
