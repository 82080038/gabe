<?php
/**
 * Database Configuration untuk Aplikasi Koperasi Berjalan
 * Multi-Database: schema_person, schema_address, schema_app
 */

return [
    // Database untuk data personal dan hubungan keluarga
    'person' => [
        'host' => 'localhost',
        'dbname' => 'schema_person',
        'username' => 'root',
        'password' => 'root',
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'options' => [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    ],
    
    // Database untuk data alamat Indonesia (rename dari alamat_db)
    'address' => [
        'host' => 'localhost',
        'dbname' => 'schema_address',
        'username' => 'root',
        'password' => 'root',
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'options' => [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    ],
    
    // Database untuk aplikasi dan transaksi
    'app' => [
        'host' => 'localhost',
        'dbname' => 'schema_app',
        'username' => 'root',
        'password' => 'root',
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'options' => [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    ],
    
    // Default connection untuk aplikasi utama
    'default' => 'app'
];

/**
 * Database Connection Class
 * Menangani koneksi ke multiple database
 */
class DatabaseConnection {
    private static $instances = [];
    private static $config = null;
    
    public static function setConfig($config) {
        self::$config = $config;
    }
    
    public static function getConnection($database = 'default') {
        if (!isset(self::$config)) {
            self::$config = require __DIR__ . '/database.php';
        }
        
        $dbKey = $database === 'default' ? self::$config['default'] : $database;
        
        if (!isset(self::$instances[$dbKey])) {
            $config = self::$config[$dbKey];
            
            try {
                $dsn = "mysql:host={$config['host']};dbname={$config['dbname']};charset={$config['charset']}";
                self::$instances[$dbKey] = new PDO($dsn, $config['username'], $config['password'], $config['options']);
            } catch (PDOException $e) {
                throw new Exception("Database connection failed for {$dbKey}: " . $e->getMessage());
            }
        }
        
        return self::$instances[$dbKey];
    }
    
    public static function getPersonConnection() {
        return self::getConnection('person');
    }
    
    public static function getAddressConnection() {
        return self::getConnection('address');
    }
    
    public static function getAppConnection() {
        return self::getConnection('app');
    }
    
    public static function beginTransaction($database = 'app') {
        $pdo = self::getConnection($database);
        $pdo->beginTransaction();
        return $pdo;
    }
    
    public static function executeCrossDatabaseQuery($query, $params = []) {
        // Untuk cross-database query, gunakan schema_app sebagai primary
        $pdo = self::getAppConnection();
        
        try {
            $stmt = $pdo->prepare($query);
            $stmt->execute($params);
            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw new Exception("Cross-database query failed: " . $e->getMessage());
        }
    }
    
    public static function testConnections() {
        $results = [];
        
        try {
            $person = self::getPersonConnection();
            $results['person'] = 'Connected successfully';
        } catch (Exception $e) {
            $results['person'] = 'Failed: ' . $e->getMessage();
        }
        
        try {
            $address = self::getAddressConnection();
            $results['address'] = 'Connected successfully';
        } catch (Exception $e) {
            $results['address'] = 'Failed: ' . $e->getMessage();
        }
        
        try {
            $app = self::getAppConnection();
            $results['app'] = 'Connected successfully';
        } catch (Exception $e) {
            $results['app'] = 'Failed: ' . $e->getMessage();
        }
        
        return $results;
    }
}

// Helper functions untuk kemudahan
function db_person() {
    return DatabaseConnection::getPersonConnection();
}

function db_address() {
    return DatabaseConnection::getAddressConnection();
}

function db_app() {
    return DatabaseConnection::getAppConnection();
}

function db_query($query, $params = []) {
    return DatabaseConnection::executeCrossDatabaseQuery($query, $params);
}

function db_transaction($callback) {
    $pdo = DatabaseConnection::beginTransaction();
    
    try {
        $result = $callback($pdo);
        $pdo->commit();
        return $result;
    } catch (Exception $e) {
        $pdo->rollBack();
        throw $e;
    }
}

?>
