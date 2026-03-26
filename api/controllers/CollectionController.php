<?php
/**
 * ================================================================
 * COLLECTION CONTROLLER - KOPERASI BERJALAN
 * Complete collection management system with scheduling and tracking
 * ================================================================ */

require_once __DIR__ . '/../index.php';

class CollectionController extends BaseController {
    
    /**
     * Get today's collection route
     * GET /api/collections/today-route
     */
    public function todayRoute() {
        $currentUser = $this->getCurrentUser();
        $branchId = $currentUser['branch_id'];
        $role = $currentUser['role'];
        
        try {
            $whereClause = "";
            $params = [];
            
            // Branch filtering for non-admin users
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $whereClause = "WHERE c.branch_id = ?";
                $params[] = $branchId;
            }
            
            // Filter by collector if not admin
            if ($role === ROLE_COLLECTOR) {
                $whereClause .= ($whereClause ? " AND " : "WHERE ") . "c.collector_id = ?";
                $params[] = $currentUser['user_id'];
            }
            
            // Get today's collection route
            $query = "
                SELECT 
                    c.*,
                    cr.route_name,
                    cr.description as route_description,
                    cr.total_members,
                    cr.total_amount,
                    cr.status as route_status,
                    cr.created_at as route_created_at,
                    u.username as collector_name,
                    u.full_name as collector_full_name
                FROM collections c
                LEFT JOIN collection_routes cr ON c.route_id = cr.id
                LEFT JOIN users u ON c.collector_id = u.id
                {$whereClause}
                AND DATE(c.collection_date) = CURDATE()
                ORDER BY c.priority ASC, c.sequence_number ASC
            ";
            
            $stmt = $this->db->prepare($query);
            $stmt->execute($params);
            $collections = $stmt->fetchAll();
            
            // Get collection members for each collection
            $formattedCollections = [];
            foreach ($collections as $collection) {
                $members = $this->getCollectionMembersData($collection['id']);
                
                $formattedCollections[] = [
                    'id' => $collection['id'],
                    'route' => [
                        'id' => $collection['route_id'],
                        'name' => $collection['route_name'],
                        'description' => $collection['route_description'],
                        'total_members' => $collection['total_members'],
                        'total_amount' => floatval($collection['total_amount']),
                        'status' => $collection['route_status']
                    ],
                    'collector' => [
                        'id' => $collection['collector_id'],
                        'username' => $collection['collector_name'],
                        'full_name' => $collection['collector_full_name']
                    ],
                    'collection_date' => $collection['collection_date'],
                    'status' => $collection['status'],
                    'priority' => $collection['priority'],
                    'sequence_number' => $collection['sequence_number'],
                    'start_time' => $collection['start_time'],
                    'end_time' => $collection['end_time'],
                    'total_collected' => floatval($collection['total_collected']),
                    'members_count' => count($members),
                    'completed_members' => count(array_filter($members, fn($m) => $m['status'] === 'completed')),
                    'pending_members' => count(array_filter($members, fn($m) => $m['status'] === 'pending')),
                    'members' => $members
                ];
            }
            
            $this->success($formattedCollections, 'Today\'s collection route retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in today route', [
                'error' => $e->getMessage(),
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to retrieve today\'s collection route', 500);
        }
    }
    
    /**
     * Get collection members
     * GET /api/collections/{id}/members
     */
    public function getCollectionMembers($collectionId) {
        try {
            $query = "
                SELECT 
                    cm.*,
                    m.member_number,
                    p.name as member_name,
                    p.phone,
                    p.address,
                    l.loan_number,
                    l.amount as loan_amount,
                    l.interest_rate,
                    l.tenure_months,
                    ls.due_date,
                    ls.installment_number,
                    u.username as collector_name
                FROM collection_members cm
                LEFT JOIN members m ON cm.member_id = m.id
                LEFT JOIN schema_person.persons p ON m.person_id = p.id
                LEFT JOIN loans l ON cm.loan_id = l.id
                LEFT JOIN loan_schedules ls ON l.id = ls.loan_id AND ls.installment_number = 1
                LEFT JOIN collections c ON cm.collection_id = c.id
                LEFT JOIN users u ON c.collector_id = u.id
                WHERE cm.collection_id = ?
                ORDER BY cm.sequence_number
            ";
            
            $stmt = $this->db->prepare($query);
            $stmt->execute([$collectionId]);
            $members = $stmt->fetchAll();
            
            $this->success($members, 'Collection members retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in getCollectionMembers', [
                'error' => $e->getMessage(),
                'collection_id' => $collectionId
            ]);
            $this->error('Failed to retrieve collection members', 500);
        }
    }
    
    /**
     * Create new collection route
     * POST /api/collections/routes
     */
    public function createRoute() {
        $currentUser = $this->getCurrentUser();
        
        // Validate input
        $requiredFields = ['route_name', 'collector_id', 'member_ids'];
        $input = $this->validate($requiredFields);
        
        if (!$input) {
            return;
        }
        
        try {
            // Validate collector exists and is active
            $collectorQuery = "SELECT * FROM users WHERE id = ? AND role = 'collector' AND is_active = 1";
            $stmt = $this->db->prepare($collectorQuery);
            $stmt->execute([$input['collector_id']]);
            $collector = $stmt->fetch();
            
            if (!$collector) {
                $this->error('Collector not found or inactive', 400);
                return;
            }
            
            // Validate member IDs
            $memberIds = is_array($input['member_ids']) ? $input['member_ids'] : explode(',', $input['member_ids']);
            $memberIds = array_filter($memberIds, 'is_numeric');
            
            if (empty($memberIds)) {
                $this->error('No valid member IDs provided', 400);
                return;
            }
            
            // Validate members exist and have active loans
            $placeholders = str_repeat('?,', count($memberIds) - 1) . '?';
            $membersQuery = "
                SELECT 
                    m.id, m.member_number, p.name as member_name,
                    l.id as loan_id, l.loan_number, l.amount, l.monthly_payment,
                    l.status as loan_status, ls.due_date, ls.amount as installment_amount
                FROM members m
                LEFT JOIN schema_person.persons p ON m.person_id = p.id
                LEFT JOIN loans l ON l.member_id = m.id AND l.status IN ('active', 'late')
                LEFT JOIN loan_schedules ls ON l.id = ls.loan_id AND ls.status = 'pending'
                WHERE m.id IN ($placeholders) AND m.status = 'active'
                ORDER BY p.name
            ";
            
            $stmt = $this->db->prepare($membersQuery);
            $stmt->execute($memberIds);
            $members = $stmt->fetchAll();
            
            if (empty($members)) {
                $this->error('No valid members with active loans found', 400);
                return;
            }
            
            // Calculate total amount
            $totalAmount = array_sum(array_column($members, 'monthly_payment'));
            
            // Start transaction
            $this->db->beginTransaction();
            
            try {
                // Create collection route
                $routeQuery = "
                    INSERT INTO collection_routes (
                        route_name, description, collector_id, total_members, 
                        total_amount, status, branch_id, created_by, created_at
                    ) VALUES (?, ?, ?, ?, ?, 'draft', ?, ?, NOW())
                ";
                
                $stmt = $this->db->prepare($routeQuery);
                $stmt->execute([
                    $input['route_name'],
                    $input['description'] ?? null,
                    $input['collector_id'],
                    count($members),
                    $totalAmount,
                    $currentUser['branch_id'],
                    $currentUser['user_id']
                ]);
                
                $routeId = $this->db->lastInsertId();
                
                // Add members to route
                $sequence = 1;
                foreach ($members as $member) {
                    $memberRouteQuery = "
                        INSERT INTO collection_route_members (
                            route_id, member_id, loan_id, sequence_number, 
                            amount, due_date, priority, created_at
                        ) VALUES (?, ?, ?, ?, ?, ?, 1, NOW())
                    ";
                    
                    $stmt = $this->db->prepare($memberRouteQuery);
                    $stmt->execute([
                        $routeId,
                        $member['id'],
                        $member['loan_id'],
                        $sequence,
                        $member['monthly_payment'],
                        $member['due_date']
                    ]);
                    
                    $sequence++;
                }
                
                // Log activity
                Logger::info('Collection route created', [
                    'route_id' => $routeId,
                    'route_name' => $input['route_name'],
                    'collector_id' => $input['collector_id'],
                    'total_members' => count($members),
                    'total_amount' => $totalAmount,
                    'user_id' => $currentUser['user_id']
                ]);
                
                // Commit transaction
                $this->db->commit();
                
                $this->success([
                    'route_id' => $routeId,
                    'route_name' => $input['route_name'],
                    'collector_id' => $input['collector_id'],
                    'total_members' => count($members),
                    'total_amount' => $totalAmount
                ], 'Collection route created successfully');
                
            } catch (Exception $e) {
                $this->db->rollback();
                throw $e;
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in route creation', [
                'error' => $e->getMessage(),
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to create collection route', 500);
        }
    }
    
    /**
     * Generate daily collection schedule
     * POST /api/collections/generate-schedule
     */
    public function generateSchedule() {
        $currentUser = $this->getCurrentUser();
        
        // Validate input
        $input = $this->validate(['collection_date', 'collector_assignments']);
        
        if (!$input) {
            return;
        }
        
        try {
            $collectionDate = $input['collection_date'];
            $collectorAssignments = $input['collector_assignments']; // array of [collector_id => member_ids]
            
            // Validate collection date
            if (!strtotime($collectionDate)) {
                $this->error('Invalid collection date', 400);
                return;
            }
            
            // Clear existing collections for this date
            $clearQuery = "DELETE FROM collections WHERE collection_date = ?";
            $stmt = $this->db->prepare($clearQuery);
            $stmt->execute([$collectionDate]);
            
            $totalCollections = 0;
            $totalAmount = 0;
            
            // Start transaction
            $this->db->beginTransaction();
            
            try {
                foreach ($collectorAssignments as $collectorId => $memberIds) {
                    // Validate collector
                    $collectorQuery = "SELECT * FROM users WHERE id = ? AND role = 'collector' AND is_active = 1";
                    $stmt = $this->db->prepare($collectorQuery);
                    $stmt->execute([$collectorId]);
                    $collector = $stmt->fetch();
                    
                    if (!$collector) {
                        continue; // Skip invalid collectors
                    }
                    
                    // Get members with active loans
                    $placeholders = str_repeat('?,', count($memberIds) - 1) . '?';
                    $membersQuery = "
                        SELECT 
                            m.id, m.member_number, p.name as member_name,
                            l.id as loan_id, l.monthly_payment, ls.due_date
                        FROM members m
                        LEFT JOIN schema_person.persons p ON m.person_id = p.id
                        LEFT JOIN loans l ON l.member_id = m.id AND l.status IN ('active', 'late')
                        LEFT JOIN loan_schedules ls ON l.id = ls.loan_id AND ls.status = 'pending'
                        WHERE m.id IN ($placeholders) AND m.status = 'active'
                        ORDER BY p.name
                    ";
                    
                    $stmt = $this->db->prepare($membersQuery);
                    $stmt->execute($memberIds);
                    $members = $stmt->fetchAll();
                    
                    if (empty($members)) {
                        continue; // Skip if no valid members
                    }
                    
                    // Create collection for this collector
                    $collectionQuery = "
                        INSERT INTO collections (
                            collector_id, collection_date, status, priority,
                            total_amount, branch_id, created_by, created_at
                        ) VALUES (?, ?, 'pending', 1, ?, ?, ?, NOW())
                    ";
                    
                    $memberTotalAmount = array_sum(array_column($members, 'monthly_payment'));
                    $stmt = $this->db->prepare($collectionQuery);
                    $stmt->execute([
                        $collectorId,
                        $collectionDate,
                        $memberTotalAmount,
                        $currentUser['branch_id'],
                        $currentUser['user_id']
                    ]);
                    
                    $collectionId = $this->db->lastInsertId();
                    
                    // Add collection members
                    $sequence = 1;
                    foreach ($members as $member) {
                        $memberCollectionQuery = "
                            INSERT INTO collection_members (
                                collection_id, member_id, loan_id, sequence_number,
                                amount, due_date, status, created_at
                            ) VALUES (?, ?, ?, ?, ?, ?, 'pending', NOW())
                        ";
                        
                        $stmt = $this->db->prepare($memberCollectionQuery);
                        $stmt->execute([
                            $collectionId,
                            $member['id'],
                            $member['loan_id'],
                            $sequence,
                            $member['monthly_payment'],
                            $member['due_date']
                        ]);
                        
                        $sequence++;
                    }
                    
                    $totalCollections++;
                    $totalAmount += $memberTotalAmount;
                }
                
                // Log activity
                Logger::info('Collection schedule generated', [
                    'collection_date' => $collectionDate,
                    'total_collections' => $totalCollections,
                    'total_amount' => $totalAmount,
                    'user_id' => $currentUser['user_id']
                ]);
                
                // Commit transaction
                $this->db->commit();
                
                $this->success([
                    'collection_date' => $collectionDate,
                    'total_collections' => $totalCollections,
                    'total_amount' => $totalAmount
                ], 'Collection schedule generated successfully');
                
            } catch (Exception $e) {
                $this->db->rollback();
                throw $e;
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in schedule generation', [
                'error' => $e->getMessage(),
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to generate collection schedule', 500);
        }
    }
    
    /**
     * Record collection payment
     * POST /api/collections/{id}/collect
     */
    public function collectPayment($id) {
        $currentUser = $this->getCurrentUser();
        $collectionId = intval($id);
        
        // Validate input
        $input = $this->validate(['member_id', 'amount', 'payment_method', 'notes']);
        
        if (!$input) {
            return;
        }
        
        try {
            // Get collection details
            $collectionQuery = "SELECT * FROM collections WHERE id = ?";
            $stmt = $this->db->prepare($collectionQuery);
            $stmt->execute([$collectionId]);
            $collection = $stmt->fetch();
            
            if (!$collection) {
                $this->error('Collection not found', 404);
                return;
            }
            
            // Check permissions
            if (!$this->hasCollectionAccess($collection, $currentUser)) {
                $this->error('Access denied', 403);
                return;
            }
            
            // Validate collection status
            if ($collection['status'] !== 'pending') {
                $this->error('Collection is not in pending status', 400);
                return;
            }
            
            // Get collection member
            $memberQuery = "
                SELECT cm.*, l.loan_number, l.interest_rate, l.tenure_months
                FROM collection_members cm
                LEFT JOIN loans l ON cm.loan_id = l.id
                WHERE cm.collection_id = ? AND cm.member_id = ?
            ";
            
            $stmt = $this->db->prepare($memberQuery);
            $stmt->execute([$collectionId, $input['member_id']]);
            $collectionMember = $stmt->fetch();
            
            if (!$collectionMember) {
                $this->error('Collection member not found', 404);
                return;
            }
            
            // Validate member status
            if ($collectionMember['status'] !== 'pending') {
                $this->error('Member already collected', 400);
                return;
            }
            
            // Validate payment amount
            if ($input['amount'] <= 0) {
                $this->error('Payment amount must be greater than 0', 400);
                return;
            }
            
            if ($input['amount'] > $collectionMember['amount']) {
                $this->error('Payment amount exceeds required amount', 400);
                return;
            }
            
            // Start transaction
            $this->db->beginTransaction();
            
            try {
                // Create collection payment record
                $paymentQuery = "
                    INSERT INTO collection_payments (
                        collection_id, member_id, loan_id, amount, payment_method,
                        notes, status, created_by, created_at
                    ) VALUES (?, ?, ?, ?, ?, ?, 'completed', ?, NOW())
                ";
                
                $stmt = $this->db->prepare($paymentQuery);
                $stmt->execute([
                    $collectionId,
                    $input['member_id'],
                    $collectionMember['loan_id'],
                    $input['amount'],
                    $input['payment_method'],
                    $input['notes'] ?? null,
                    $currentUser['user_id']
                ]);
                
                $paymentId = $this->db->lastInsertId();
                
                // Update collection member status
                $updateMemberQuery = "
                    UPDATE collection_members 
                    SET status = 'completed', collected_amount = ?, 
                        collected_at = NOW(), updated_at = NOW()
                    WHERE id = ?
                ";
                
                $stmt = $this->db->prepare($updateMemberQuery);
                $stmt->execute([$input['amount'], $collectionMember['id']]);
                
                // Process loan payment
                $this->processLoanPayment($collectionMember['loan_id'], $input['amount'], $input['payment_method'], $input['notes'], $currentUser);
                
                // Update collection total
                $newTotal = $collection['total_collected'] + $input['amount'];
                $updateCollectionQuery = "UPDATE collections SET total_collected = ?, updated_at = NOW() WHERE id = ?";
                $stmt = $this->db->prepare($updateCollectionQuery);
                $stmt->execute([$newTotal, $collectionId]);
                
                // Check if all members are collected
                $checkQuery = "SELECT COUNT(*) as pending FROM collection_members WHERE collection_id = ? AND status = 'pending'";
                $stmt = $this->db->prepare($checkQuery);
                $stmt->execute([$collectionId]);
                $pendingCount = $stmt->fetch()['pending'];
                
                if ($pendingCount == 0) {
                    // Mark collection as completed
                    $completeQuery = "UPDATE collections SET status = 'completed', end_time = NOW() WHERE id = ?";
                    $stmt = $this->db->prepare($completeQuery);
                    $stmt->execute([$collectionId]);
                }
                
                // Log activity
                Logger::info('Collection payment recorded', [
                    'collection_id' => $collectionId,
                    'payment_id' => $paymentId,
                    'member_id' => $input['member_id'],
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
                    'collection_total' => $newTotal,
                    'remaining_members' => $pendingCount
                ], 'Collection payment recorded successfully');
                
            } catch (Exception $e) {
                $this->db->rollback();
                throw $e;
            }
            
        } catch (PDOException $e) {
            Logger::error('Database error in collection payment', [
                'error' => $e->getMessage(),
                'collection_id' => $collectionId,
                'input' => $input,
                'user_id' => $currentUser['user_id']
            ]);
            $this->error('Failed to record collection payment', 500);
        }
    }
    
    /**
     * Get collection statistics
     * GET /api/collections/statistics
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
                $whereClause = "WHERE c.branch_id = ?";
                $params[] = $branchId;
            }
            
            // Get collection statistics
            $statsQuery = "
                SELECT 
                    COUNT(*) as total_collections,
                    COUNT(CASE WHEN c.status = 'completed' THEN 1 END) as completed_collections,
                    COUNT(CASE WHEN c.status = 'pending' THEN 1 END) as pending_collections,
                    COUNT(CASE WHEN c.status = 'cancelled' THEN 1 END) as cancelled_collections,
                    COALESCE(SUM(c.total_amount), 0) as total_target,
                    COALESCE(SUM(c.total_collected), 0) as total_collected,
                    COALESCE(AVG(c.total_amount), 0) as average_target,
                    COUNT(CASE WHEN DATE(c.collection_date) BETWEEN ? AND ? THEN 1 END) as collections_period,
                    COALESCE(SUM(CASE WHEN DATE(c.collection_date) BETWEEN ? AND ? THEN c.total_collected ELSE 0 END), 0) as collected_period
                FROM collections c
                {$whereClause}
            ";
            
            if (empty($params)) {
                $params = [$dateFrom, $dateTo, $dateFrom, $dateTo];
            } else {
                $params[] = $dateFrom;
                $params[] = $dateTo;
                $params[] = $dateFrom;
                $params[] = $dateTo;
            }
            
            $stmt = $this->db->prepare($statsQuery);
            $stmt->execute($params);
            $stats = $stmt->fetch();
            
            // Get monthly trends
            $trendsQuery = "
                SELECT 
                    DATE_FORMAT(collection_date, '%Y-%m') as month,
                    COUNT(*) as collection_count,
                    COALESCE(SUM(total_amount), 0) as total_target,
                    COALESCE(SUM(total_collected), 0) as total_collected,
                    COALESCE(AVG(total_amount), 0) as average_target
                FROM collections
                WHERE collection_date >= DATE_SUB(?, INTERVAL 12 MONTH)
                " . ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN ? "AND branch_id = ?" : "") . "
                GROUP BY DATE_FORMAT(collection_date, '%Y-%m')
                ORDER BY month DESC
            ";
            
            $trendsParams = [date('Y-m-d')];
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $trendsParams[] = $branchId;
            }
            
            $stmt = $this->db->prepare($trendsQuery);
            $stmt->execute($trendsParams);
            $trends = $stmt->fetchAll();
            
            // Get collector performance
            $collectorQuery = "
                SELECT 
                    u.id, u.username, u.full_name,
                    COUNT(c.id) as total_collections,
                    COUNT(CASE WHEN c.status = 'completed' THEN 1 END) as completed_collections,
                    COALESCE(SUM(c.total_collected), 0) as total_collected,
                    COALESCE(SUM(c.total_amount), 0) as total_target,
                    COUNT(CASE WHEN DATE(c.collection_date) BETWEEN ? AND ? THEN 1 END) as collections_period,
                    COALESCE(SUM(CASE WHEN DATE(c.collection_date) BETWEEN ? AND ? THEN c.total_collected ELSE 0 END), 0) as collected_period
                FROM collections c
                LEFT JOIN users u ON c.collector_id = u.id
                " . ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN ? "WHERE c.branch_id = ?" : "") . "
                GROUP BY u.id, u.username, u.full_name
                ORDER BY total_collected DESC
            ";
            
            $collectorParams = [$dateFrom, $dateTo, $dateFrom, $dateTo];
            if ($role !== ROLE_SUPER_ADMIN && $role !== ROLE_ADMIN) {
                $collectorParams[] = $branchId;
            }
            
            $stmt = $this->db->prepare($collectorQuery);
            $stmt->execute($collectorParams);
            $collectors = $stmt->fetchAll();
            
            // Calculate performance metrics
            $completionRate = $stats['total_collections'] > 0 ? 
                round(($stats['completed_collections'] / $stats['total_collections']) * 100, 2) : 0;
            
            $collectionRate = $stats['total_target'] > 0 ? 
                round(($stats['total_collected'] / $stats['total_target']) * 100, 2) : 0;
            
            $response = [
                'summary' => [
                    'total_collections' => intval($stats['total_collections']),
                    'completed_collections' => intval($stats['completed_collections']),
                    'pending_collections' => intval($stats['pending_collections']),
                    'cancelled_collections' => intval($stats['cancelled_collections']),
                    'total_target' => floatval($stats['total_target']),
                    'total_collected' => floatval($stats['total_collected']),
                    'average_target' => floatval($stats['average_target']),
                    'collections_period' => intval($stats['collections_period']),
                    'collected_period' => floatval($stats['collected_period'])
                ],
                'performance' => [
                    'completion_rate' => $completionRate,
                    'collection_rate' => $collectionRate
                ],
                'monthly_trends' => $trends,
                'collector_performance' => $collectors
            ];
            
            $this->success($response, 'Collection statistics retrieved successfully');
            
        } catch (PDOException $e) {
            Logger::error('Database error in collection statistics', [
                'error' => $e->getMessage(),
                'user_role' => $role,
                'branch_id' => $branchId
            ]);
            $this->error('Failed to retrieve collection statistics', 500);
        }
    }
    
    /**
     * Helper methods
     */
    
    private function getCollectionMembersData($collectionId) {
        try {
            $query = "
                SELECT 
                    cm.*,
                    m.member_number,
                    p.name as member_name,
                    p.phone,
                    p.address,
                    l.loan_number,
                    l.amount as loan_amount,
                    l.interest_rate,
                    l.tenure_months,
                    ls.due_date,
                    ls.installment_number,
                    u.username as collector_name
                FROM collection_members cm
                LEFT JOIN members m ON cm.member_id = m.id
                LEFT JOIN schema_person.persons p ON m.person_id = p.id
                LEFT JOIN loans l ON cm.loan_id = l.id
                LEFT JOIN loan_schedules ls ON l.id = ls.loan_id AND ls.installment_number = 1
                LEFT JOIN collections c ON cm.collection_id = c.id
                LEFT JOIN users u ON c.collector_id = u.id
                WHERE cm.collection_id = ?
                ORDER BY cm.sequence_number
            ";
            
            $stmt = $this->db->prepare($query);
            $stmt->execute([$collectionId]);
            return $stmt->fetchAll();
            
        } catch (PDOException $e) {
            Logger::error('Database error in getCollectionMembersData', [
                'error' => $e->getMessage(),
                'collection_id' => $collectionId
            ]);
            return [];
        }
    }
    
    private function processLoanPayment($loanId, $amount, $paymentMethod, $notes, $currentUser) {
        try {
            // Get next pending installment
            $installmentQuery = "
                SELECT * FROM loan_schedules 
                WHERE loan_id = ? AND status = 'pending' 
                ORDER BY installment_number
                LIMIT 1
            ";
            
            $stmt = $this->db->prepare($installmentQuery);
            $stmt->execute([$loanId]);
            $installment = $stmt->fetch();
            
            if (!$installment) {
                return; // No pending installments
            }
            
            // Create loan payment record
            $paymentQuery = "
                INSERT INTO loan_payments (
                    loan_id, schedule_id, amount, payment_method,
                    notes, status, created_by, created_at
                ) VALUES (?, ?, ?, ?, ?, 'completed', ?, NOW())
            ";
            
            $stmt = $this->db->prepare($paymentQuery);
            $stmt->execute([
                $loanId,
                $installment['id'],
                $amount,
                $paymentMethod,
                $notes,
                $currentUser['user_id']
            ]);
            
            // Update installment status
            if ($amount >= $installment['amount']) {
                $updateQuery = "
                    UPDATE loan_schedules 
                    SET status = 'paid', paid_amount = ?, paid_date = NOW(), payment_id = LAST_INSERT_ID()
                    WHERE id = ?
                ";
                
                $stmt = $this->db->prepare($updateQuery);
                $stmt->execute([$amount, $installment['id']]);
            } else {
                $updateQuery = "
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
                
                $stmt = $this->db->prepare($updateQuery);
                $stmt->execute([$amount, $amount, $amount, $installment['id']]);
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
            
        } catch (PDOException $e) {
            Logger::error('Database error in loan payment processing', [
                'error' => $e->getMessage(),
                'loan_id' => $loanId,
                'amount' => $amount
            ]);
            throw $e;
        }
    }
    
    private function hasCollectionAccess($collection, $currentUser) {
        // Admin and super admin can access all collections
        if (in_array($currentUser['role'], [ROLE_SUPER_ADMIN, ROLE_ADMIN, ROLE_BRANCH_HEAD, ROLE_UNIT_HEAD])) {
            return true;
        }
        
        // Collectors can only access their own collections
        if ($currentUser['role'] === ROLE_COLLECTOR) {
            return $collection['collector_id'] == $currentUser['user_id'];
        }
        
        return false;
    }
}

?>
