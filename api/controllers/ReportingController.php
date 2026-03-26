<?php
/**
 * ================================================================
 * REPORTING CONTROLLER - KOPERASI BERJALAN
 * Complete reporting system with financial and operational reports
 * ================================================================ */

require_once __DIR__ . '/../index.php';

class ReportingController extends BaseController {
    
    /**
     * Generate financial reports
     * GET /api/reports/financial
     */
    public function financial() {
        $currentUser = $this->getCurrentUser();
        $branchId = $currentUser['branch_id'];
        $role = $currentUser['role'];
        
        // Report parameters
        $reportType = sanitizeInput($_GET['report_type'] ?? 'summary');
        $dateFrom = sanitizeInput($_GET['date_from'] ?? date('Y-m-01'));
        $dateTo = sanitizeInput($_GET['date_to'] ?? date('Y-m-t'));
        $format = sanitizeInput($_GET['format'] ?? 'json');
        
        try {
            $whereClause = "";
            $params = [];
            
            // Branch filtering for non-admin users
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $whereClause = "WHERE branch_id = ?";
                $params[] = $branchId;
            }
            
            switch ($reportType) {
                case 'summary':
                    $data = $this->generateFinancialSummary($dateFrom, $dateTo, $whereClause, $params);
                    break;
                case 'income-statement':
                    $data = $this->generateIncomeStatement($dateFrom, $dateTo, $whereClause, $params);
                    break;
                case 'balance-sheet':
                    $data = $this->generateBalanceSheet($dateFrom, $dateTo, $whereClause, $params);
                    break;
                case 'cash-flow':
                    $data = $this->generateCashFlowStatement($dateFrom, $dateTo, $whereClause, $params);
                    break;
                case 'loan-portfolio':
                    $data = $this->generateLoanPortfolioReport($dateFrom, $dateTo, $whereClause, $params);
                    break;
                case 'savings-summary':
                    $data = $this->generateSavingsSummaryReport($dateFrom, $dateTo, $whereClause, $params);
                    break;
                default:
                    $this->error('Invalid report type', 400);
                    return;
            }
            
            if ($format === 'excel') {
                $this->exportToExcel($data, $reportType);
            } elseif ($format === 'pdf') {
                $this->exportToPDF($data, $reportType);
            } else {
                $this->success($data, 'Financial report generated successfully');
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in financial report', [
                'error' => $e->getMessage(),
                'report_type' => $reportType,
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to generate financial report', 500);
        }
    }
    
    /**
     * Generate operational reports
     * GET /api/reports/operational
     */
    public function operational() {
        $currentUser = $this->getCurrentUser();
        $branchId = $currentUser['branch_id'];
        $role = $currentUser['role'];
        
        // Report parameters
        $reportType = sanitizeInput($_GET['report_type'] ?? 'performance');
        $dateFrom = sanitizeInput($_GET['date_from'] ?? date('Y-m-01'));
        $dateTo = sanitizeInput($_GET['date_to'] ?? date('Y-m-t'));
        $format = sanitizeInput($_GET['format'] ?? 'json');
        
        try {
            $whereClause = "";
            $params = [];
            
            // Branch filtering for non-admin users
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $whereClause = "WHERE branch_id = ?";
                $params[] = $branchId;
            }
            
            switch ($reportType) {
                case 'performance':
                    $data = $this->generatePerformanceReport($dateFrom, $dateTo, $whereClause, $params);
                    break;
                case 'collection':
                    $data = $this->generateCollectionReport($dateFrom, $dateTo, $whereClause, $params);
                    break;
                case 'member':
                    $data = $this->generateMemberReport($dateFrom, $dateTo, $whereClause, $params);
                    break;
                case 'staff':
                    $data = $this->generateStaffReport($dateFrom, $dateTo, $whereClause, $params);
                    break;
                case 'audit':
                    $data = $this->generateAuditReport($dateFrom, $dateTo, $whereClause, $params);
                    break;
                default:
                    $this->error('Invalid report type', 400);
                    return;
            }
            
            if ($format === 'excel') {
                $this->exportToExcel($data, $reportType);
            } elseif ($format === 'pdf') {
                $this->exportToPDF($data, $reportType);
            } else {
                $this->success($data, 'Operational report generated successfully');
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in operational report', [
                'error' => $e->getMessage(),
                'report_type' => $reportType,
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to generate operational report', 500);
        }
    }
    
    /**
     * Generate dashboard reports
     * GET /api/reports/dashboard
     */
    public function dashboard() {
        $currentUser = $this->getCurrentUser();
        $branchId = $currentUser['branch_id'];
        $role = $currentUser['role'];
        
        // Report parameters
        $period = sanitizeInput($_GET['period'] ?? 'month');
        $dateFrom = $this->getPeriodStartDate($period);
        $dateTo = date('Y-m-t');
        
        try {
            $whereClause = "";
            $params = [];
            
            // Branch filtering for non-admin users
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $whereClause = "WHERE branch_id = ?";
                $params[] = $branchId;
            }
            
            // Generate comprehensive dashboard data
            $dashboardData = [
                'overview' => $this->getDashboardOverview($dateFrom, $dateTo, $whereClause, $params),
                'trends' => $this->getDashboardTrends($period, $whereClause, $params),
                'performance' => $this->getDashboardPerformance($dateFrom, $dateTo, $whereClause, $params),
                'alerts' => $this->getDashboardAlerts($whereClause, $params),
                'kpi' => $this->getDashboardKPIs($dateFrom, $dateTo, $whereClause, $params)
            ];
            
            $this->success($dashboardData, 'Dashboard report generated successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in dashboard report', [
                'error' => $e->getMessage(),
                'period' => $period,
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to generate dashboard report', 500);
        }
    }
    
    /**
     * Generate custom reports
     * POST /api/reports/custom
     */
    public function custom() {
        $currentUser = $this->getCurrentUser();
        
        // Validate input
        $input = $this->validate(['report_name', 'data_sources', 'filters', 'columns']);
        
        if (!$input) {
            return;
        }
        
        try {
            // Validate permissions for custom reports
            if (!in_array($currentUser['role'], [ROLE_SUPER_ADMIN, ROLE_ADMIN, ROLE_BRANCH_HEAD])) {
                $this->error('Access denied for custom reports', 403);
                return;
            }
            
            $reportData = $this->generateCustomReport($input);
            
            $this->success($reportData, 'Custom report generated successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in custom report', [
                'error' => $e->getMessage(),
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to generate custom report', 500);
        }
    }
    
    /**
     * Helper methods for financial reports
     */
    private function generateFinancialSummary($dateFrom, $dateTo, $whereClause, $params) {
        $dateParams = array_merge($params, [$dateFrom, $dateTo]);
        
        // Get income statement summary
        $incomeQuery = "
            SELECT 
                'income' as category,
                COALESCE(SUM(CASE WHEN jd.credit > 0 THEN jd.credit ELSE 0 END), 0) as total
            FROM journal_details jd
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE DATE(j.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY 'income'
            
            UNION ALL
            
            SELECT 
                'expenses' as category,
                COALESCE(SUM(CASE WHEN jd.debit > 0 THEN jd.debit ELSE 0 END), 0) as total
            FROM journal_details jd
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE DATE(j.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY 'expenses'
        ";
        
        $stmt = $this->db->prepare($incomeQuery);
        $stmt->execute($dateParams);
        $incomeData = $stmt->fetchAll();
        
        // Get loan disbursements and repayments
        $loanQuery = "
            SELECT 
                'loan_disbursements' as category,
                COALESCE(SUM(l.amount), 0) as total
            FROM loans l
            WHERE DATE(l.disbursement_date) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY 'loan_disbursements'
            
            UNION ALL
            
            SELECT 
                'loan_repayments' as category,
                COALESCE(SUM(lp.amount), 0) as total
            FROM loan_payments lp
            LEFT JOIN loans l ON lp.loan_id = l.id
            WHERE DATE(lp.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY 'loan_repayments'
        ";
        
        $stmt = $this->db->prepare($loanQuery);
        $stmt->execute($dateParams);
        $loanData = $stmt->fetchAll();
        
        // Get savings deposits and withdrawals
        $savingsQuery = "
            SELECT 
                'savings_deposits' as category,
                COALESCE(SUM(st.amount), 0) as total
            FROM savings_transactions st
            LEFT JOIN savings_accounts sa ON st.account_id = sa.id
            WHERE st.transaction_type = 'deposit' 
            AND DATE(st.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY 'savings_deposits'
            
            UNION ALL
            
            SELECT 
                'savings_withdrawals' as category,
                COALESCE(SUM(st.amount), 0) as total
            FROM savings_transactions st
            LEFT JOIN savings_accounts sa ON st.account_id = sa.id
            WHERE st.transaction_type = 'withdrawal' 
            AND DATE(st.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY 'savings_withdrawals'
        ";
        
        $stmt = $this->db->prepare($savingsQuery);
        $stmt->execute($dateParams);
        $savingsData = $stmt->fetchAll();
        
        // Combine all data
        $allData = array_merge($incomeData, $loanData, $savingsData);
        
        // Calculate net income
        $netIncome = 0;
        foreach ($allData as $item) {
            if (in_array($item['category'], ['income', 'loan_repayments', 'savings_deposits'])) {
                $netIncome += $item['total'];
            } else {
                $netIncome -= $item['total'];
            }
        }
        
        return [
            'period' => [
                'from' => $dateFrom,
                'to' => $dateTo
            ],
            'summary' => [
                'total_income' => array_sum(array_column($incomeData, 'total')),
                'total_expenses' => array_sum(array_column(array_filter($incomeData, fn($i) => $i['category'] === 'expenses'), 'total')),
                'net_income' => $netIncome,
                'loan_disbursements' => array_sum(array_column(array_filter($loanData, fn($i) => $i['category'] === 'loan_disbursements'), 'total')),
                'loan_repayments' => array_sum(array_column(array_filter($loanData, fn($i) => $i['category'] === 'loan_repayments'), 'total')),
                'savings_deposits' => array_sum(array_column(array_filter($savingsData, fn($i) => $i['category'] === 'savings_deposits'), 'total')),
                'savings_withdrawals' => array_sum(array_column(array_filter($savingsData, fn($i) => $i['category'] === 'savings_withdrawals'), 'total'))
            ],
            'details' => $allData
        ];
    }
    
    private function generateIncomeStatement($dateFrom, $dateTo, $whereClause, $params) {
        $dateParams = array_merge($params, [$dateFrom, $dateTo]);
        
        // Get revenue
        $revenueQuery = "
            SELECT 
                jd.account_code,
                jd.account_name,
                jd.description,
                SUM(jd.credit) as amount,
                'Revenue' as category
            FROM journal_details jd
            LEFT JOIN accounts a ON jd.account_code = a.code
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE jd.credit > 0 
            AND a.type = 'revenue'
            AND DATE(j.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY jd.account_code, jd.account_name, jd.description
            ORDER BY jd.account_code
        ";
        
        $stmt = $this->db->prepare($revenueQuery);
        $stmt->execute($dateParams);
        $revenueData = $stmt->fetchAll();
        
        // Get expenses
        $expenseQuery = "
            SELECT 
                jd.account_code,
                jd.account_name,
                jd.description,
                SUM(jd.debit) as amount,
                'Expense' as category
            FROM journal_details jd
            LEFT JOIN accounts a ON jd.account_code = a.code
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE jd.debit > 0 
            AND a.type = 'expense'
            AND DATE(j.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY jd.account_code, jd.account_name, jd.description
            ORDER BY jd.account_code
        ";
        
        $stmt = $this->db->prepare($expenseQuery);
        $stmt->execute($dateParams);
        $expenseData = $stmt->fetchAll();
        
        $totalRevenue = array_sum(array_column($revenueData, 'amount'));
        $totalExpenses = array_sum(array_column($expenseData, 'amount'));
        
        return [
            'period' => [
                'from' => $dateFrom,
                'to' => $dateTo
            ],
            'summary' => [
                'total_revenue' => $totalRevenue,
                'total_expenses' => $totalExpenses,
                'net_income' => $totalRevenue - $totalExpenses,
                'gross_profit_margin' => $totalRevenue > 0 ? round(($totalRevenue - $totalExpenses) / $totalRevenue * 100, 2) : 0
            ],
            'revenue' => $revenueData,
            'expenses' => $expenseData
        ];
    }
    
    private function generateBalanceSheet($dateFrom, $dateTo, $whereClause, $params) {
        // Get assets
        $assetsQuery = "
            SELECT 
                a.code,
                a.name,
                COALESCE(SUM(CASE 
                    WHEN jd.debit > 0 THEN jd.debit 
                    WHEN jd.credit > 0 THEN -jd.credit 
                    ELSE 0 
                END), 0) as balance,
                'Asset' as category
            FROM journal_details jd
            LEFT JOIN accounts a ON jd.account_code = a.code
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE a.type = 'asset'
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY a.code, a.name
            HAVING balance != 0
            ORDER BY a.code
        ";
        
        $stmt = $this->db->prepare($assetsQuery);
        $stmt->execute($params);
        $assetsData = $stmt->fetchAll();
        
        // Get liabilities
        $liabilitiesQuery = "
            SELECT 
                a.code,
                a.name,
                COALESCE(SUM(CASE 
                    WHEN jd.credit > 0 THEN jd.credit 
                    WHEN jd.debit > 0 THEN -jd.debit 
                    ELSE 0 
                END), 0) as balance,
                'Liability' as category
            FROM journal_details jd
            LEFT JOIN accounts a ON jd.account_code = a.code
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE a.type = 'liability'
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY a.code, a.name
            HAVING balance != 0
            ORDER BY a.code
        ";
        
        $stmt = $this->db->prepare($liabilitiesQuery);
        $stmt->execute($params);
        $liabilitiesData = $stmt->fetchAll();
        
        // Get equity
        $equityQuery = "
            SELECT 
                a.code,
                a.name,
                COALESCE(SUM(CASE 
                    WHEN jd.credit > 0 THEN jd.credit 
                    WHEN jd.debit > 0 THEN -jd.debit 
                    ELSE 0 
                END), 0) as balance,
                'Equity' as category
            FROM journal_details jd
            LEFT JOIN accounts a ON jd.account_code = a.code
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE a.type = 'equity'
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY a.code, a.name
            HAVING balance != 0
            ORDER BY a.code
        ";
        
        $stmt = $this->db->prepare($equityQuery);
        $stmt->execute($params);
        $equityData = $stmt->fetchAll();
        
        $totalAssets = array_sum(array_column($assetsData, 'balance'));
        $totalLiabilities = array_sum(array_column($liabilitiesData, 'balance'));
        $totalEquity = array_sum(array_column($equityData, 'balance'));
        
        return [
            'as_of_date' => $dateTo,
            'summary' => [
                'total_assets' => $totalAssets,
                'total_liabilities' => $totalLiabilities,
                'total_equity' => $totalEquity,
                'balance_check' => abs(($totalAssets - $totalLiabilities) - $totalEquity) < 0.01
            ],
            'assets' => $assetsData,
            'liabilities' => $liabilitiesData,
            'equity' => $equityData
        ];
    }
    
    private function generateCashFlowStatement($dateFrom, $dateTo, $whereClause, $params) {
        $dateParams = array_merge($params, [$dateFrom, $dateTo]);
        
        // Get operating activities
        $operatingQuery = "
            SELECT 
                'Operating Activities' as category,
                jd.account_name,
                jd.description,
                SUM(CASE 
                    WHEN jd.debit > 0 THEN -jd.debit 
                    WHEN jd.credit > 0 THEN jd.credit 
                    ELSE 0 
                END) as amount
            FROM journal_details jd
            LEFT JOIN accounts a ON jd.account_code = a.code
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE a.cash_flow_category = 'operating'
            AND DATE(j.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY jd.account_name, jd.description
            ORDER BY jd.account_name
        ";
        
        $stmt = $this->db->prepare($operatingQuery);
        $stmt->execute($dateParams);
        $operatingData = $stmt->fetchAll();
        
        // Get investing activities
        $investingQuery = "
            SELECT 
                'Investing Activities' as category,
                jd.account_name,
                jd.description,
                SUM(CASE 
                    WHEN jd.debit > 0 THEN -jd.debit 
                    WHEN jd.credit > 0 THEN jd.credit 
                    ELSE 0 
                END) as amount
            FROM journal_details jd
            LEFT JOIN accounts a ON jd.account_code = a.code
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE a.cash_flow_category = 'investing'
            AND DATE(j.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY jd.account_name, jd.description
            ORDER BY jd.account_name
        ";
        
        $stmt = $this->db->prepare($investingQuery);
        $stmt->execute($dateParams);
        $investingData = $stmt->fetchAll();
        
        // Get financing activities
        $financingQuery = "
            SELECT 
                'Financing Activities' as category,
                jd.account_name,
                jd.description,
                SUM(CASE 
                    WHEN jd.debit > 0 THEN -jd.debit 
                    WHEN jd.credit > 0 THEN jd.credit 
                    ELSE 0 
                END) as amount
            FROM journal_details jd
            LEFT JOIN accounts a ON jd.account_code = a.code
            LEFT JOIN journals j ON jd.journal_id = j.id
            WHERE a.cash_flow_category = 'financing'
            AND DATE(j.created_at) BETWEEN ? AND ?
            " . ($whereClause ? "AND {$whereClause}" : "") . "
            GROUP BY jd.account_name, jd.description
            ORDER BY jd.account_name
        ";
        
        $stmt = $this->db->prepare($financingQuery);
        $stmt->execute($dateParams);
        $financingData = $stmt->fetchAll();
        
        $operatingCashFlow = array_sum(array_column($operatingData, 'amount'));
        $investingCashFlow = array_sum(array_column($investingData, 'amount'));
        $financingCashFlow = array_sum(array_column($financingData, 'amount'));
        
        return [
            'period' => [
                'from' => $dateFrom,
                'to' => $dateTo
            ],
            'summary' => [
                'operating_cash_flow' => $operatingCashFlow,
                'investing_cash_flow' => $investingCashFlow,
                'financing_cash_flow' => $financingCashFlow,
                'net_cash_flow' => $operatingCashFlow + $investingCashFlow + $financingCashFlow
            ],
            'operating_activities' => $operatingData,
            'investing_activities' => $investingData,
            'financing_activities' => $financingData
        ];
    }
    
    /**
     * Helper methods for operational reports
     */
    private function generatePerformanceReport($dateFrom, $dateTo, $whereClause, $params) {
        $dateParams = array_merge($params, [$dateFrom, $dateTo]);
        
        // Get collection performance
        $collectionQuery = "
            SELECT 
                u.username,
                u.full_name,
                COUNT(c.id) as total_collections,
                COUNT(CASE WHEN c.status = 'completed' THEN 1 END) as completed_collections,
                COALESCE(SUM(c.total_collected), 0) as total_collected,
                COALESCE(SUM(c.total_amount), 0) as total_target,
                COUNT(CASE WHEN DATE(c.collection_date) BETWEEN ? AND ? THEN 1 END) as period_collections,
                COALESCE(SUM(CASE WHEN DATE(c.collection_date) BETWEEN ? AND ? THEN c.total_collected ELSE 0 END), 0) as period_collected
            FROM collections c
            LEFT JOIN users u ON c.collector_id = u.id
            " . ($whereClause ? "WHERE {$whereClause}" : "") . "
            GROUP BY u.id, u.username, u.full_name
            ORDER BY total_collected DESC
        ";
        
        $stmt = $this->db->prepare($collectionQuery);
        $stmt->execute($dateParams);
        $collectionData = $stmt->fetchAll();
        
        // Get loan performance
        $loanQuery = "
            SELECT 
                COUNT(*) as total_loans,
                COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_loans,
                COUNT(CASE WHEN status = 'disbursed' THEN 1 END) as disbursed_loans,
                COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_loans,
                COUNT(CASE WHEN status = 'default' THEN 1 END) as defaulted_loans,
                COALESCE(SUM(amount), 0) as total_disbursed,
                COUNT(CASE WHEN DATE(created_at) BETWEEN ? AND ? THEN 1 END) as period_loans
            FROM loans
            " . ($whereClause ? "WHERE {$whereClause}" : "") . "
        ";
        
        $stmt = $this->db->prepare($loanQuery);
        $stmt->execute($dateParams);
        $loanData = $stmt->fetch();
        
        // Get savings performance
        $savingsQuery = "
            SELECT 
                COUNT(*) as total_accounts,
                COUNT(CASE WHEN status = 'active' THEN 1 END) as active_accounts,
                COALESCE(SUM(balance), 0) as total_balance,
                COUNT(CASE WHEN DATE(created_at) BETWEEN ? AND ? THEN 1 END) as period_accounts
            FROM savings_accounts
            " . ($whereClause ? "WHERE {$whereClause}" : "") . "
        ";
        
        $stmt = $this->db->prepare($savingsQuery);
        $stmt->execute($dateParams);
        $savingsData = $stmt->fetch();
        
        return [
            'period' => [
                'from' => $dateFrom,
                'to' => $dateTo
            ],
            'collection_performance' => [
                'summary' => [
                    'total_collectors' => count($collectionData),
                    'overall_completion_rate' => $loanData['disbursed_loans'] > 0 ? 
                        round($collectionData[0]['completed_collections'] / $collectionData[0]['total_collections'] * 100, 2) : 0,
                    'overall_collection_rate' => $collectionData[0]['total_target'] > 0 ? 
                        round($collectionData[0]['total_collected'] / $collectionData[0]['total_target'] * 100, 2) : 0
                ],
                'collectors' => $collectionData
            ],
            'loan_performance' => [
                'approval_rate' => $loanData['total_loans'] > 0 ? 
                    round($loanData['approved_loans'] / $loanData['total_loans'] * 100, 2) : 0,
                'completion_rate' => $loanData['disbursed_loans'] > 0 ? 
                    round($loanData['completed_loans'] / $loanData['disbursed_loans'] * 100, 2) : 0,
                'default_rate' => $loanData['disbursed_loans'] > 0 ? 
                    round($loanData['defaulted_loans'] / $loanData['disbursed_loans'] * 100, 2) : 0,
                'details' => $loanData
            ],
            'savings_performance' => $savingsData
        ];
    }
    
    private function generateCollectionReport($dateFrom, $dateTo, $whereClause, $params) {
        $dateParams = array_merge($params, [$dateFrom, $dateTo]);
        
        // Get daily collection performance
        $dailyQuery = "
            SELECT 
                DATE(c.collection_date) as date,
                COUNT(*) as total_collections,
                COUNT(CASE WHEN c.status = 'completed' THEN 1 END) as completed_collections,
                COALESCE(SUM(c.total_collected), 0) as total_collected,
                COALESCE(SUM(c.total_amount), 0) as total_target
            FROM collections c
            " . ($whereClause ? "WHERE {$whereClause}" : "") . "
            AND DATE(c.collection_date) BETWEEN ? AND ?
            GROUP BY DATE(c.collection_date)
            ORDER BY date
        ";
        
        $stmt = $this->db->prepare($dailyQuery);
        $stmt->execute($dateParams);
        $dailyData = $stmt->fetchAll();
        
        // Get collector performance
        $collectorQuery = "
            SELECT 
                u.username,
                u.full_name,
                COUNT(c.id) as total_collections,
                COUNT(CASE WHEN c.status = 'completed' THEN 1 END) as completed_collections,
                COALESCE(SUM(c.total_collected), 0) as total_collected,
                COALESCE(SUM(c.total_amount), 0) as total_target,
                COUNT(CASE WHEN DATE(c.collection_date) BETWEEN ? AND ? THEN 1 END) as period_collections
            FROM collections c
            LEFT JOIN users u ON c.collector_id = u.id
            " . ($whereClause ? "WHERE {$whereClause} " : "") . "
            GROUP BY u.id, u.username, u.full_name
            ORDER BY total_collected DESC
        ";
        
        $stmt = $this->db->prepare($collectorQuery);
        $stmt->execute($dateParams);
        $collectorData = $stmt->fetchAll();
        
        // Get member collection status
        $memberQuery = "
            SELECT 
                COUNT(*) as total_members,
                COUNT(CASE WHEN cm.status = 'completed' THEN 1 END) as collected_members,
                COUNT(CASE WHEN cm.status = 'pending' THEN 1 END) as pending_members,
                COUNT(CASE WHEN cm.status = 'skipped' THEN 1 END) as skipped_members
            FROM collection_members cm
            LEFT JOIN collections c ON cm.collection_id = c.id
            " . ($whereClause ? "WHERE {$whereClause}" : ") . "
            AND DATE(c.collection_date) BETWEEN ? AND ?
        ";
        
        $stmt = $this->db->prepare($memberQuery);
        $stmt->execute($dateParams);
        $memberData = $stmt->fetch();
        
        return [
            'period' => [
                'from' => $dateFrom,
                'to' => $dateTo
            ],
            'daily_performance' => $dailyData,
            'collector_performance' => $collectorData,
            'member_status' => $memberData
        ];
    }
    
    /**
     * Helper methods for dashboard reports
     */
    private function getDashboardOverview($dateFrom, $dateTo, $whereClause, $params) {
        $dateParams = array_merge($params, [$dateFrom, $dateTo]);
        
        // Get key metrics
        $metricsQuery = "
            SELECT 
                (SELECT COUNT(*) FROM members m WHERE m.status = 'active' " . ($whereClause ? "AND {$whereClause}" : "") . ") as active_members,
                (SELECT COUNT(*) FROM loans l WHERE l.status IN ('active', 'late') " . ($whereClause ? "AND {$whereClause}" : "") . ") as active_loans,
                (SELECT COUNT(*) FROM savings_accounts sa WHERE sa.status = 'active' " . ($whereClause ? "AND {$whereClause}" : "") . ") as active_savings,
                (SELECT COALESCE(SUM(balance), 0) FROM savings_accounts sa WHERE sa.status = 'active' " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_savings,
                (SELECT COALESCE(SUM(amount), 0) FROM loans l WHERE l.status IN ('active', 'late') " . ($whereClause ? "AND {$whereClause}" : "") . ") as outstanding_loans,
                (SELECT COUNT(*) FROM collections c WHERE DATE(c.collection_date) = CURDATE() " . ($whereClause ? "AND {$whereClause}" : "") . ") as today_collections
        ";
        
        $stmt = $this->db->prepare($metricsQuery);
        $stmt->execute($params);
        return $stmt->fetch();
    }
    
    private function getDashboardTrends($period, $whereClause, $params) {
        // Get monthly trends for the specified period
        $months = $this->getPeriodMonths($period);
        
        $trends = [];
        foreach ($months as $month) {
            $monthParams = array_merge($params, [$month]);
            
            $query = "
                SELECT 
                    ? as month,
                    (SELECT COUNT(*) FROM members WHERE DATE(created_at) <= ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_members,
                    (SELECT COUNT(*) FROM loans WHERE DATE(created_at) <= ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_loans,
                    (SELECT COUNT(*) FROM savings_accounts WHERE DATE(created_at) <= ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_savings,
                    (SELECT COALESCE(SUM(balance), 0) FROM savings_accounts WHERE DATE(created_at) <= ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_balance
            ";
            
            $stmt = $this->db->prepare($query);
            $stmt->execute($monthParams);
            $trend = $stmt->fetch();
            
            $trends[] = [
                'month' => $month,
                'total_members' => intval($trend['total_members']),
                'total_loans' => intval($trend['total_loans']),
                'total_savings' => intval($trend['total_savings']),
                'total_balance' => floatval($trend['total_balance'])
            ];
        }
        
        return $trends;
    }
    
    private function getDashboardPerformance($dateFrom, $dateTo, $whereClause, $params) {
        $dateParams = array_merge($params, [$dateFrom, $dateTo]);
        
        // Get performance metrics
        $query = "
            SELECT 
                (SELECT COUNT(*) FROM collections c WHERE DATE(c.collection_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_collections,
                (SELECT COUNT(CASE WHEN c.status = 'completed' THEN 1 END) FROM collections c WHERE DATE(c.collection_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as completed_collections,
                (SELECT COALESCE(SUM(c.total_collected), 0) FROM collections c WHERE DATE(c.collection_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_collected,
                (SELECT COALESCE(SUM(c.total_amount), 0) FROM collections c WHERE DATE(c.collection_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_target,
                (SELECT COUNT(*) FROM loans l WHERE DATE(created_at) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as new_loans,
                (SELECT COUNT(*) FROM savings_accounts sa WHERE DATE(created_at) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as new_savings
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute($dateParams);
        return $stmt->fetch();
    }
    
    private function getDashboardAlerts($whereClause, $params) {
        // Get alerts and notifications
        $alerts = [];
        
        // Overdue loans alert
        $overdueQuery = "
            SELECT COUNT(*) as count
            FROM loan_schedules ls
            LEFT JOIN loans l ON ls.loan_id = l.id
            WHERE ls.status = 'pending' 
            AND ls.due_date < CURDATE()
            " . ($whereClause ? "AND {$whereClause}" : "") . "
        ";
        
        $stmt = $this->db->prepare($overdueQuery);
        $stmt->execute($params);
        $overdueCount = $stmt->fetch()['count'];
        
        if ($overdueCount > 0) {
            $alerts[] = [
                'type' => 'warning',
                'message' => "{$overdueCount} overdue loan payments",
                'count' => $overdueCount
            ];
        }
        
        // Low balance alerts
        $lowBalanceQuery = "
            SELECT COUNT(*) as count
            FROM savings_accounts sa
            LEFT JOIN savings_products sp ON sa.product_id = sp.id
            WHERE sa.status = 'active' 
            AND sa.balance < sp.min_balance
            " . ($whereClause ? "AND {$whereClause}" : "") . "
        ";
        
        $stmt = $this->db->prepare($lowBalanceQuery);
        $stmt->execute($params);
        $lowBalanceCount = $stmt->fetch()['count'];
        
        if ($lowBalanceCount > 0) {
            $alerts[] = [
                'type' => 'info',
                'message' => "{$lowBalanceCount} accounts below minimum balance",
                'count' => $lowBalanceCount
            ];
        }
        
        return $alerts;
    }
    
    private function getDashboardKPIs($dateFrom, $dateTo, $whereClause, $params) {
        // Calculate KPIs
        $dateParams = array_merge($params, [$dateFrom, $dateTo]);
        
        $query = "
            SELECT 
                (SELECT COUNT(*) FROM collections c WHERE DATE(c.collection_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_collections,
                (SELECT COUNT(CASE WHEN c.status = 'completed' THEN 1 END) FROM collections c WHERE DATE(c.collection_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as completed_collections,
                (SELECT COALESCE(SUM(c.total_collected), 0) FROM collections c WHERE DATE(c.collection_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_collected,
                (SELECT COALESCE(SUM(c.total_amount), 0) FROM collections c WHERE DATE(c.collection_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as total_target,
                (SELECT COUNT(*) FROM loans l WHERE DATE(disbursement_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as disbursed_loans,
                (SELECT COUNT(CASE WHEN l.status = 'completed' THEN 1 END) FROM loans l WHERE DATE(disbursement_date) BETWEEN ? AND ? " . ($whereClause ? "AND {$whereClause}" : "") . ") as completed_loans
        ";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute($dateParams);
        $data = $stmt->fetch();
        
        return [
            'collection_completion_rate' => $data['total_collections'] > 0 ? 
                round($data['completed_collections'] / $data['total_collections'] * 100, 2) : 0,
            'collection_efficiency' => $data['total_target'] > 0 ? 
                round($data['total_collected'] / $data['total_target'] * 100, 2) : 0,
            'loan_completion_rate' => $data['disbursed_loans'] > 0 ? 
                round($data['completed_loans'] / $data['disbursed_loans'] * 100, 2) : 0
        ];
    }
    
    /**
     * Utility methods
     */
    private function getPeriodStartDate($period) {
        switch ($period) {
            case 'day':
                return date('Y-m-d');
            case 'week':
                return date('Y-m-d', strtotime('-7 days'));
            case 'month':
                return date('Y-m-01');
            case 'quarter':
                return date('Y-m-d', strtotime('-3 months'));
            case 'year':
                return date('Y-01-01');
            default:
                return date('Y-m-01');
        }
    }
    
    private function getPeriodMonths($period) {
        $months = [];
        $count = 0;
        
        switch ($period) {
            case 'month':
                $count = 1;
                break;
            case 'quarter':
                $count = 3;
                break;
            case 'year':
                $count = 12;
                break;
            default:
                $count = 1;
        }
        
        for ($i = $count - 1; $i >= 0; $i--) {
            $months[] = date('Y-m', strtotime("-{$i} months"));
        }
        
        return $months;
    }
    
    private function generateCustomReport($input) {
        // This would implement custom report generation based on user input
        // For now, return a placeholder
        return [
            'report_name' => $input['report_name'],
            'data_sources' => $input['data_sources'],
            'filters' => $input['filters'],
            'columns' => $input['columns'],
            'message' => 'Custom report generation not fully implemented yet'
        ];
    }
    
    private function exportToExcel($data, $reportType) {
        // This would implement Excel export functionality
        // For now, return a placeholder
        $this->success([
            'format' => 'excel',
            'report_type' => $reportType,
            'data' => $data,
            'message' => 'Excel export not fully implemented yet'
        ], 'Report exported successfully');
    }
    
    private function exportToPDF($data, $reportType) {
        // This would implement PDF export functionality
        // For now, return a placeholder
        $this->success([
            'format' => 'pdf',
            'report_type' => $reportType,
            'data' => $data,
            'message' => 'PDF export not fully implemented yet'
        ], 'Report exported successfully');
    }
}

?>
