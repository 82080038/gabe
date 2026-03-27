<?php
/**
 * Disable PWA for Development
 * This script helps disable PWA features during development
 */

// Check if we want to disable PWA for development
$disablePWA = true;

if ($disablePWA) {
    // Disable service worker registration
    $disableSW = true;
    
    // Disable manifest link
    $disableManifest = true;
    
    // Add development mode indicator
    $devMode = true;
} else {
    // Enable PWA for production
    $disableSW = false;
    $disableManifest = false;
    $devMode = false;
}

// Return JSON response for AJAX calls
if (isset($_GET['ajax'])) {
    header('Content-Type: application/json');
    echo json_encode([
        'pwa_disabled' => $disablePWA,
        'sw_disabled' => $disableSW,
        'manifest_disabled' => $disableManifest,
        'dev_mode' => $devMode
    ]);
    exit;
}

// HTML snippet to include in templates
?>
<?php if ($disablePWA): ?>
<!-- PWA DISABLED FOR DEVELOPMENT -->
<script>
    console.log('[DEV] PWA features are DISABLED for development');
    
    // Disable service worker registration
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.getRegistrations().then(function(registrations) {
            for(let registration of registrations) {
                registration.unregister();
                console.log('[DEV] Service Worker unregistered:', registration.scope);
            }
        });
    }
    
    // Remove PWA install prompts
    window.addEventListener('beforeinstallprompt', function(e) {
        e.preventDefault();
        console.log('[DEV] PWA install prompt disabled');
        return false;
    });
    
    // Disable offline functionality
    window.addEventListener('online', function() {
        console.log('[DEV] Online - PWA disabled');
    });
    
    window.addEventListener('offline', function() {
        console.log('[DEV] Offline - PWA disabled, showing offline fallback');
        // Show basic offline message
        if (!document.getElementById('dev-offline-message')) {
            const offlineDiv = document.createElement('div');
            offlineDiv.id = 'dev-offline-message';
            offlineDiv.style.cssText = 'position: fixed; top: 0; left: 0; right: 0; background: #ff6b6b; color: white; text-align: center; padding: 10px; z-index: 9999;';
            offlineDiv.innerHTML = '⚠️ Development Mode: You are offline. PWA features are disabled.';
            document.body.appendChild(offlineDiv);
        }
    });
    
    // Development mode indicator
    document.addEventListener('DOMContentLoaded', function() {
        const devIndicator = document.createElement('div');
        devIndicator.style.cssText = 'position: fixed; top: 10px; right: 10px; background: #28a745; color: white; padding: 5px 10px; border-radius: 5px; font-size: 12px; z-index: 9999;';
        devIndicator.innerHTML = '🔧 DEV MODE';
        document.body.appendChild(devIndicator);
    });
</script>

<style>
    /* Disable PWA-related CSS for development */
    .pwa-install-prompt {
        display: none !important;
    }
    
    .offline-indicator {
        display: none !important;
    }
    
    /* Development mode styles */
    .dev-mode-indicator {
        position: fixed;
        top: 10px;
        right: 10px;
        background: #28a745;
        color: white;
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 12px;
        z-index: 9999;
    }
    
    /* Highlight development elements */
    .dev-highlight {
        border: 2px dashed #007bff !important;
        background-color: rgba(0, 123, 255, 0.1) !important;
    }
</style>

<?php else: ?>
<!-- PWA ENABLED FOR PRODUCTION -->
<link rel="manifest" href="/gabe/manifest.json">
<script>
    // Register service worker for production
    if ('serviceWorker' in navigator) {
        window.addEventListener('load', function() {
            navigator.serviceWorker.register('/gabe/sw.js')
                .then(function(registration) {
                    console.log('[PWA] Service Worker registered:', registration.scope);
                })
                .catch(function(error) {
                    console.log('[PWA] Service Worker registration failed:', error);
                });
        });
    }
</script>
<?php endif; ?>

<?php
// Function to check PWA status
function isPWAEnabled() {
    global $disablePWA;
    return !$disablePWA;
}

// Function to get PWA configuration
function getPWAConfig() {
    global $disablePWA, $disableSW, $disableManifest, $devMode;
    return [
        'enabled' => !$disablePWA,
        'sw_enabled' => !$disableSW,
        'manifest_enabled' => !$disableManifest,
        'dev_mode' => $devMode
    ];
}
?>
