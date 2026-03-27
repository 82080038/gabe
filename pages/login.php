<?php
/**
 * Login Page untuk Aplikasi Koperasi Berjalan
 * Responsive login dengan device detection
 */

require_once __DIR__ . '/../config/device_detection.php';
require_once __DIR__ . '/../config/indonesia_config.php';
require_once __DIR__ . '/../config/auth.php';

// Set page title
$pageTitle = 'Login - Aplikasi Koperasi Berjalan';

// Handle login submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';
    
    // Attempt authentication
    if (loginUser($username, $password)) {
        // Redirect sesuai device
        redirectBasedOnRole($deviceDetection->getDeviceType());
    } else {
        $error = 'Username atau password salah';
    }
}
?>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Language" content="id">
    <meta name="language" content="Indonesian">
    <meta name="geo.country" content="ID">
    <title><?php echo $pageTitle; ?></title>
    
    <!-- CSS -->
    <link href="/gabe/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="/gabe/assets/css/indonesia-theme.css" rel="stylesheet">
    <link href="/gabe/assets/css/responsive.css" rel="stylesheet">
    
    <!-- Device classes -->
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            background: white;
            border-radius: 1rem;
            box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.175);
            overflow: hidden;
            width: 100%;
            max-width: 400px;
        }
        
        .login-header {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .login-header h1 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
        }
        
        .login-header p {
            margin: 0.5rem 0 0;
            opacity: 0.9;
            font-size: 0.875rem;
        }
        
        .login-body {
            padding: 2rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            font-weight: 500;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .form-control {
            border: 1px solid #dee2e6;
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.15s ease-in-out;
        }
        
        .form-control:focus {
            border-color: #e74c3c;
            box-shadow: 0 0 0 0.2rem rgba(231, 76, 60, 0.25);
        }
        
        .btn-login {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            border: none;
            color: white;
            padding: 0.75rem 1rem;
            font-weight: 500;
            border-radius: 0.5rem;
            width: 100%;
            transition: all 0.15s ease-in-out;
        }
        
        .btn-login:hover {
            background: linear-gradient(135deg, #c0392b, #a93226);
            transform: translateY(-1px);
            box-shadow: 0 0.25rem 0.5rem rgba(231, 76, 60, 0.15);
        }
        
        .alert {
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }
        
        .device-info {
            text-align: center;
            margin-top: 1rem;
            font-size: 0.75rem;
            color: #6c757d;
        }
        
        .demo-accounts {
            background: #f8f9fa;
            border-radius: 0.5rem;
            padding: 1rem;
            margin-top: 1.5rem;
        }
        
        .demo-accounts h6 {
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #495057;
        }
        
        .demo-accounts .account {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.25rem 0;
            font-size: 0.75rem;
        }
        
        .demo-accounts .account strong {
            color: #2c3e50;
        }
        
        .demo-accounts .account code {
            background: #e9ecef;
            padding: 0.125rem 0.25rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
        }
        
        /* Mobile styles */
        .device-mobile .login-container {
            margin: 1rem;
            max-width: none;
        }
        
        .device-mobile .login-header {
            padding: 1.5rem;
        }
        
        .device-mobile .login-body {
            padding: 1.5rem;
        }
        
        .device-mobile .form-control {
            font-size: 16px; /* Prevent zoom on iOS */
        }
        
        /* Tablet styles */
        .device-tablet .login-container {
            max-width: 450px;
        }
        
        /* Desktop styles */
        .device-desktop .login-container {
            max-width: 500px;
        }
        
        .device-desktop .login-header {
            padding: 2.5rem;
        }
        
        .device-desktop .login-body {
            padding: 2.5rem;
        }
    </style>
</head>
<body class="<?php echo getDeviceClasses(); ?>">
    <div class="login-container">
        <div class="login-header">
            <h1>Koperasi Berjalan</h1>
            <p>Aplikasi Simpan Pinjam Digital</p>
        </div>
        
        <div class="login-body">
            <?php if (isset($error)): ?>
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle"></i> <?php echo htmlspecialchars($error); ?>
            </div>
            <?php endif; ?>
            
            <form method="POST" action="">
                <div class="form-group">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" 
                           placeholder="Masukkan username" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" 
                           placeholder="Masukkan password" required>
                </div>
                
                <button type="submit" class="btn btn-login">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </form>
            
            <div class="demo-accounts">
                <h6><i class="fas fa-info-circle"></i> Akun Demo</h6>
                <div class="account">
                    <strong>Administrator:</strong>
                    <code>admin / admin</code>
                </div>
                <div class="account">
                    <strong>Kolektor:</strong>
                    <code>collector / collector</code>
                </div>
                
                <!-- Quick Login Buttons -->
                <div class="mt-3">
                    <h6><i class="fas fa-rocket"></i> Quick Login</h6>
                    <div class="d-grid gap-2">
                        <a href="/gabe/pages/quick_login.php" class="btn btn-primary btn-sm">
                            <i class="fas fa-users"></i> Lihat Semua Role
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="device-info">
                <i class="fas fa-mobile-alt"></i> 
                Device: <?php echo ucfirst($deviceDetection->getDeviceType()); ?> | 
                Role: <?php echo ucfirst($deviceDetection->getUserRole()); ?>
            </div>
        </div>
    </div>
    
    <!-- PWA Manifest -->
    <link rel="manifest" href="/gabe/manifest.json">
    <meta name="theme-color" content="#2c3e50">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="default">
    <meta name="apple-mobile-web-app-title" content="Koperasi Berjalan">
    <link rel="apple-touch-icon" href="/gabe/assets/icons/icon-192x192.png">
    
    <!-- JavaScript -->
    <script src="/gabe/assets/js/jquery.min.js"></script>
    <script src="/gabe/assets/js/bootstrap.bundle.min.js"></script>
    <script src="/gabe/assets/js/responsive-manager.js"></script>
    <script src="/gabe/assets/js/indonesia-formatter.js"></script>
    <script src="/gabe/pwa-dev-config.js"></script>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Set device variables from PHP
        window.deviceType = '<?php echo $deviceDetection->getDeviceType(); ?>';
        window.screenSize = '<?php echo $deviceDetection->getScreenSize(); ?>';
        window.userRole = '<?php echo $deviceDetection->getUserRole(); ?>';
        window.deviceConfig = {
            capabilities: <?php echo json_encode($deviceDetection->getCapabilities()); ?>
        };
        
        // Auto-focus username field
        document.getElementById('username').focus();
        
        // Handle form submission
        const form = document.querySelector('form');
        form.addEventListener('submit', function() {
            const btn = form.querySelector('.btn-login');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Memproses...';
            btn.disabled = true;
        });
        
        // Device-specific optimizations
        if (window.deviceType === 'mobile') {
            // Enable better mobile experience
            document.body.style.fontSize = '16px';
        }
        
        // Show device info in console
        console.log('Device Info:', {
            type: window.deviceType,
            screenSize: window.screenSize,
            role: window.userRole,
            capabilities: window.deviceConfig?.capabilities
        });
        
        // PWA Development Debug
        <?php if ($_SERVER['HTTP_HOST'] === 'localhost' || $_SERVER['HTTP_HOST'] === '127.0.0.1'): ?>
        console.log('[PWA] Development mode active');
        setTimeout(() => {
            if (window.PWA_DEBUG) {
                console.log('[PWA] Debug tools available:', window.PWA_DEBUG);
            }
        }, 2000);
        <?php endif; ?>
    });
    </script>
    
    <!-- Development Mode Debug Panel -->
    <?php if ($_SERVER['HTTP_HOST'] === 'localhost' || $_SERVER['HTTP_HOST'] === '127.0.0.1'): ?>
    <div id="pwa-debug-panel" style="position: fixed; top: 10px; right: 10px; background: rgba(0,0,0,0.8); color: white; padding: 10px; border-radius: 5px; font-size: 12px; z-index: 10000;">
        <div style="margin-bottom: 5px; font-weight: bold;">🔧 PWA Debug</div>
        <button onclick="window.PWA_DEBUG?.clearCache()" style="background: #dc3545; color: white; border: none; padding: 3px 8px; margin: 1px; cursor: pointer; font-size: 11px;">Clear Cache</button>
        <button onclick="window.PWA_DEBUG?.forceUpdate()" style="background: #007bff; color: white; border: none; padding: 3px 8px; margin: 1px; cursor: pointer; font-size: 11px;">Update</button>
        <button onclick="window.PWA_DEBUG?.subscribePush()" style="background: #28a745; color: white; border: none; padding: 3px 8px; margin: 1px; cursor: pointer; font-size: 11px;">Push</button>
    </div>
    <?php endif; ?>
</body>
</html>
