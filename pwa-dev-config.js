/**
 * ================================================================
 * PWA DEVELOPMENT CONFIGURATION
 * Development-ready setup that doesn't interfere with development
 * ================================================================
 */

// Development environment detection
const isDevelopment = window.location.hostname === 'localhost' || 
                      window.location.hostname === '127.0.0.1' ||
                      window.location.hostname.includes('.local') ||
                      window.location.port !== '80' && window.location.port !== '443';

// PWA Configuration
const PWA_CONFIG = {
    // Service Worker Registration
    serviceWorker: {
        enabled: true,
        script: '/gabe/sw.js',
        developmentMode: isDevelopment,
        updateInterval: isDevelopment ? 30000 : 3600000, // 30s dev, 1hr prod
        forceUpdate: false
    },
    
    // Manifest Registration
    manifest: {
        enabled: true,
        href: '/gabe/manifest.json',
        developmentMode: isDevelopment
    },
    
    // Cache Configuration
    cache: {
        enabled: true,
        developmentMode: isDevelopment,
        version: '1.0.0',
        maxSize: 50 * 1024 * 1024, // 50MB
        clearOnUpdate: !isDevelopment
    },
    
    // Push Notifications
    push: {
        enabled: true,
        developmentMode: isDevelopment,
        publicKey: 'YOUR_VAPID_PUBLIC_KEY_HERE',
        subscribeOnLoad: false
    },
    
    // Background Sync
    sync: {
        enabled: true,
        developmentMode: isDevelopment,
        maxRetries: 3,
        retryDelay: 5000
    },
    
    // Offline Support
    offline: {
        enabled: true,
        developmentMode: isDevelopment,
        showOfflineIndicator: true,
        fallbackPage: '/pages/offline.php'
    },
    
    // App Installation
    install: {
        enabled: true,
        developmentMode: isDevelopment,
        showInstallPrompt: true,
        postponeInstallDays: 0,
        minTimeBeforePrompt: 30000 // 30 seconds
    },
    
    // Performance Monitoring
    performance: {
        enabled: isDevelopment,
        logCacheHits: true,
        logNetworkRequests: true,
        logServiceWorkerEvents: true
    }
};

// ================================================================
// PWA MANAGER CLASS
// ================================================================
class PWAManager {
    constructor(config = PWA_CONFIG) {
        this.config = config;
        this.serviceWorkerRegistration = null;
        this.installPrompt = null;
        this.isOnline = navigator.onLine;
        this.subscribedToPush = false;
        
        this.init();
    }
    
    async init() {
        this.setupEventListeners();
        await this.registerServiceWorker();
        await this.registerManifest();
        this.setupInstallPrompt();
        this.setupOnlineStatus();
        
        if (this.config.performance.enabled) {
            this.setupPerformanceLogging();
        }
    }
    
    // ============================================================
    // SERVICE WORKER REGISTRATION
    // ============================================================
    async registerServiceWorker() {
        if (!('serviceWorker' in navigator) || !this.config.serviceWorker.enabled) {
            console.warn('[PWA] Service Worker not supported or disabled');
            return;
        }
        
        try {
            this.serviceWorkerRegistration = await navigator.serviceWorker.register(
                this.config.serviceWorker.script,
                { 
                    scope: '/gabe/',
                    updateViaCache: this.config.serviceWorker.developmentMode ? 'all' : 'none'
                }
            );
            
            console.log('[PWA] Service Worker registered:', this.serviceWorkerRegistration.scope);
            
            // Setup update checking
            this.setupUpdateChecking();
            
            // Setup message handling
            this.setupMessageHandling();
            
        } catch (error) {
            console.error('[PWA] Service Worker registration failed:', error);
            
            if (this.config.serviceWorker.developmentMode) {
                console.warn('[PWA] Continuing without Service Worker in development mode');
            }
        }
    }
    
    setupUpdateChecking() {
        if (!this.config.serviceWorker.developmentMode) {
            return; // Skip in development
        }
        
        // Check for updates frequently in development
        setInterval(async () => {
            if (this.serviceWorkerRegistration) {
                await this.serviceWorkerRegistration.update();
            }
        }, this.config.serviceWorker.updateInterval);
        
        // Listen for updates
        this.serviceWorkerRegistration.addEventListener('updatefound', () => {
            const newWorker = this.serviceWorkerRegistration.installing;
            
            newWorker.addEventListener('statechange', () => {
                if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
                    console.log('[PWA] New Service Worker available');
                    this.notifyUpdateAvailable();
                }
            });
        });
    }
    
    setupMessageHandling() {
        navigator.serviceWorker.addEventListener('message', (event) => {
            if (this.config.performance.logServiceWorkerEvents) {
                console.log('[PWA] Message from Service Worker:', event.data);
            }
            
            // Handle custom messages
            switch (event.data?.type) {
                case 'CACHE_UPDATED':
                    console.log('[PWA] Cache updated:', event.data.cacheName);
                    break;
                case 'SYNC_COMPLETED':
                    console.log('[PWA] Background sync completed');
                    break;
                case 'OFFLINE_MODE':
                    this.handleOfflineMode();
                    break;
                case 'ONLINE_MODE':
                    this.handleOnlineMode();
                    break;
            }
        });
    }
    
    // ============================================================
    // MANIFEST REGISTRATION
    // ============================================================
    async registerManifest() {
        if (!this.config.manifest.enabled) {
            return;
        }
        
        // Create manifest link if not exists
        if (!document.querySelector('link[rel="manifest"]')) {
            const link = document.createElement('link');
            link.rel = 'manifest';
            link.href = this.config.manifest.href;
            document.head.appendChild(link);
            
            console.log('[PWA] Manifest registered:', this.config.manifest.href);
        }
        
        // Setup theme color
        this.setupThemeColor();
    }
    
    setupThemeColor() {
        const themeColor = '#2c3e50';
        
        // Update existing or create new meta tag
        let metaThemeColor = document.querySelector('meta[name="theme-color"]');
        if (!metaThemeColor) {
            metaThemeColor = document.createElement('meta');
            metaThemeColor.name = 'theme-color';
            document.head.appendChild(metaThemeColor);
        }
        metaThemeColor.content = themeColor;
        
        // Apple touch icon
        let appleTouchIcon = document.querySelector('link[rel="apple-touch-icon"]');
        if (!appleTouchIcon) {
            appleTouchIcon = document.createElement('link');
            appleTouchIcon.rel = 'apple-touch-icon';
            appleTouchIcon.href = '/assets/icons/icon-192x192.png';
            document.head.appendChild(appleTouchIcon);
        }
    }
    
    // ============================================================
    // INSTALL PROMPT
    // ============================================================
    setupInstallPrompt() {
        if (!this.config.install.enabled || !this.config.install.showInstallPrompt) {
            return;
        }
        
        // Listen for beforeinstallprompt event
        window.addEventListener('beforeinstallprompt', (event) => {
            event.preventDefault();
            this.installPrompt = event;
            
            console.log('[PWA] Install prompt available');
            
            // Show install prompt after delay
            setTimeout(() => {
                this.showInstallPrompt();
            }, this.config.install.minTimeBeforePrompt);
        });
        
        // Listen for app installed
        window.addEventListener('appinstalled', () => {
            console.log('[PWA] App installed successfully');
            this.installPrompt = null;
            
            // Track installation
            if (typeof gtag !== 'undefined') {
                gtag('event', 'pwa_install', {
                    'event_category': 'PWA',
                    'event_label': 'App Installed'
                });
            }
        });
    }
    
    showInstallPrompt() {
        if (!this.installPrompt) {
            return;
        }
        
        // Create custom install prompt UI
        const installBanner = this.createInstallBanner();
        document.body.appendChild(installBanner);
        
        // Handle user interaction
        const installBtn = installBanner.querySelector('.install-btn');
        const dismissBtn = installBanner.querySelector('.dismiss-btn');
        
        installBtn.addEventListener('click', async () => {
            const result = await this.installPrompt.prompt();
            console.log('[PWA] Install prompt result:', result);
            
            installBanner.remove();
            this.installPrompt = null;
        });
        
        dismissBtn.addEventListener('click', () => {
            installBanner.remove();
            
            // Postpone install for configured days
            const postponeUntil = Date.now() + (this.config.install.postponeInstallDays * 24 * 60 * 60 * 1000);
            localStorage.setItem('pwa_install_postponed', postponeUntil);
        });
    }
    
    createInstallBanner() {
        const banner = document.createElement('div');
        banner.className = 'pwa-install-banner';
        banner.innerHTML = `
            <style>
                .pwa-install-banner {
                    position: fixed;
                    bottom: 20px;
                    left: 20px;
                    right: 20px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 20px;
                    border-radius: 12px;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                    z-index: 10000;
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    animation: slideUp 0.3s ease-out;
                }
                
                @keyframes slideUp {
                    from { transform: translateY(100%); opacity: 0; }
                    to { transform: translateY(0); opacity: 1; }
                }
                
                .pwa-install-banner .icon {
                    width: 60px;
                    height: 60px;
                    background: white;
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 24px;
                }
                
                .pwa-install-banner .content {
                    flex: 1;
                }
                
                .pwa-install-banner .title {
                    font-weight: bold;
                    margin-bottom: 5px;
                }
                
                .pwa-install-banner .description {
                    font-size: 14px;
                    opacity: 0.9;
                }
                
                .pwa-install-banner .actions {
                    display: flex;
                    gap: 10px;
                }
                
                .pwa-install-banner .install-btn {
                    background: white;
                    color: #667eea;
                    border: none;
                    padding: 10px 20px;
                    border-radius: 8px;
                    font-weight: bold;
                    cursor: pointer;
                    transition: transform 0.2s;
                }
                
                .pwa-install-banner .install-btn:hover {
                    transform: scale(1.05);
                }
                
                .pwa-install-banner .dismiss-btn {
                    background: transparent;
                    color: white;
                    border: 1px solid white;
                    padding: 10px 20px;
                    border-radius: 8px;
                    cursor: pointer;
                }
                
                @media (max-width: 768px) {
                    .pwa-install-banner {
                        flex-direction: column;
                        text-align: center;
                    }
                    
                    .pwa-install-banner .actions {
                        width: 100%;
                        justify-content: center;
                    }
                }
            </style>
            
            <div class="icon">📱</div>
            <div class="content">
                <div class="title">Install Koperasi Berjalan</div>
                <div class="description">Dapatkan pengalaman yang lebih baik dengan aplikasi kami</div>
            </div>
            <div class="actions">
                <button class="install-btn">Install</button>
                <button class="dismiss-btn">Nanti</button>
            </div>
        `;
        
        return banner;
    }
    
    // ============================================================
    // ONLINE/OFFLINE STATUS
    // ============================================================
    setupOnlineStatus() {
        window.addEventListener('online', () => {
            this.isOnline = true;
            console.log('[PWA] Back online');
            this.handleOnlineMode();
        });
        
        window.addEventListener('offline', () => {
            this.isOnline = false;
            console.log('[PWA] Gone offline');
            this.handleOfflineMode();
        });
    }
    
    handleOnlineMode() {
        // Remove offline indicator
        const offlineIndicator = document.querySelector('.offline-indicator');
        if (offlineIndicator) {
            offlineIndicator.remove();
        }
        
        // Trigger background sync
        if ('serviceWorker' in navigator && 'sync' in window.ServiceWorkerRegistration.prototype) {
            navigator.serviceWorker.ready.then((registration) => {
                return registration.sync.register('background-sync');
            });
        }
        
        // Show notification
        this.showNotification('Koneksi internet tersedia kembali', 'success');
    }
    
    handleOfflineMode() {
        if (!this.config.offline.showOfflineIndicator) {
            return;
        }
        
        // Show offline indicator
        const indicator = document.createElement('div');
        indicator.className = 'offline-indicator';
        indicator.innerHTML = `
            <style>
                .offline-indicator {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    background: #ff6b6b;
                    color: white;
                    padding: 10px;
                    text-align: center;
                    z-index: 10000;
                    animation: slideDown 0.3s ease-out;
                }
                
                @keyframes slideDown {
                    from { transform: translateY(-100%); }
                    to { transform: translateY(0); }
                }
            </style>
            <div>📡 Tidak ada koneksi internet - Mode offline aktif</div>
        `;
        
        document.body.appendChild(indicator);
    }
    
    // ============================================================
    // PUSH NOTIFICATIONS
    // ============================================================
    async subscribeToPushNotifications() {
        if (!this.config.push.enabled || !('serviceWorker' in navigator)) {
            return false;
        }
        
        try {
            const registration = await navigator.serviceWorker.ready;
            const subscription = await registration.pushManager.subscribe({
                userVisibleOnly: true,
                applicationServerKey: this.urlBase64ToUint8Array(this.config.push.publicKey)
            });
            
            this.subscribedToPush = true;
            console.log('[PWA] Push notification subscription successful');
            
            // Send subscription to server
            await this.sendPushSubscriptionToServer(subscription);
            
            return subscription;
        } catch (error) {
            console.error('[PWA] Push notification subscription failed:', error);
            return false;
        }
    }
    
    urlBase64ToUint8Array(base64String) {
        const padding = '='.repeat((4 - base64String.length % 4) % 4);
        const base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
        const rawData = window.atob(base64);
        const outputArray = new Uint8Array(rawData.length);
        
        for (let i = 0; i < rawData.length; ++i) {
            outputArray[i] = rawData.charCodeAt(i);
        }
        
        return outputArray;
    }
    
    async sendPushSubscriptionToServer(subscription) {
        // Implementation depends on your backend API
        try {
            await fetch('/api/push/subscribe', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(subscription)
            });
        } catch (error) {
            console.error('[PWA] Failed to send push subscription to server:', error);
        }
    }
    
    // ============================================================
    // PERFORMANCE LOGGING
    // ============================================================
    setupPerformanceLogging() {
        if (!this.config.performance.enabled) {
            return;
        }
        
        // Log cache hits
        if (this.config.performance.logCacheHits) {
            this.logCachePerformance();
        }
        
        // Log network requests
        if (this.config.performance.logNetworkRequests) {
            this.logNetworkPerformance();
        }
    }
    
    logCachePerformance() {
        // Monitor cache performance
        const originalFetch = window.fetch;
        window.fetch = async (...args) => {
            const start = performance.now();
            const response = await originalFetch(...args);
            const end = performance.now();
            
            console.log(`[PWA] Fetch: ${args[0]} - ${(end - start).toFixed(2)}ms`);
            
            return response;
        };
    }
    
    logNetworkPerformance() {
        // Monitor network performance
        if ('connection' in navigator) {
            const connection = navigator.connection;
            console.log('[PWA] Network Info:', {
                effectiveType: connection.effectiveType,
                downlink: connection.downlink,
                rtt: connection.rtt,
                saveData: connection.saveData
            });
        }
    }
    
    // ============================================================
    // UTILITY METHODS
    // ============================================================
    async clearCache() {
        if ('caches' in window) {
            const cacheNames = await caches.keys();
            await Promise.all(
                cacheNames.map(cacheName => caches.delete(cacheName))
            );
            console.log('[PWA] All caches cleared');
        }
    }
    
    async forceUpdate() {
        if (this.serviceWorkerRegistration) {
            // Send message to service worker to skip waiting
            if (navigator.serviceWorker.controller) {
                navigator.serviceWorker.controller.postMessage({ type: 'SKIP_WAITING' });
            }
            
            // Force refresh
            window.location.reload();
        }
    }
    
    showNotification(message, type = 'info') {
        // Create custom notification
        const notification = document.createElement('div');
        notification.className = `pwa-notification pwa-notification-${type}`;
        notification.innerHTML = `
            <style>
                .pwa-notification {
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: ${type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : '#17a2b8'};
                    color: white;
                    padding: 15px 20px;
                    border-radius: 8px;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
                    z-index: 10001;
                    animation: slideInRight 0.3s ease-out;
                    max-width: 300px;
                }
                
                @keyframes slideInRight {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
                
                .pwa-notification-close {
                    margin-left: 10px;
                    cursor: pointer;
                    font-weight: bold;
                }
            </style>
            <span>${message}</span>
            <span class="pwa-notification-close">×</span>
        `;
        
        document.body.appendChild(notification);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
        
        // Manual close
        notification.querySelector('.pwa-notification-close').addEventListener('click', () => {
            notification.remove();
        });
    }
    
    setupEventListeners() {
        // Listen for visibility change to refresh when app becomes visible
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden && this.isOnline) {
                // App became visible, check for updates
                if (this.serviceWorkerRegistration) {
                    this.serviceWorkerRegistration.update();
                }
            }
        });
    }
    
    notifyUpdateAvailable() {
        this.showNotification('Update tersedia! Refresh untuk mendapatkan versi terbaru.', 'info');
        
        // Add update button to UI
        const updateBtn = document.createElement('button');
        updateBtn.className = 'pwa-update-btn';
        updateBtn.textContent = 'Update Sekarang';
        updateBtn.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #007bff;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
            z-index: 10000;
            font-weight: bold;
        `;
        
        updateBtn.addEventListener('click', () => {
            this.forceUpdate();
            updateBtn.remove();
        });
        
        document.body.appendChild(updateBtn);
    }
}

// ================================================================
// AUTO-INITIALIZE PWA
// ================================================================
document.addEventListener('DOMContentLoaded', () => {
    // Check if user postponed install
    const postponedUntil = localStorage.getItem('pwa_install_postponed');
    if (postponedUntil && Date.now() < parseInt(postponedUntil)) {
        // User postponed, don't show install prompt
        PWA_CONFIG.install.showInstallPrompt = false;
    }
    
    // Initialize PWA Manager
    window.pwaManager = new PWAManager(PWA_CONFIG);
    
    // Expose PWA Manager globally for development
    if (isDevelopment) {
        window.PWA_DEBUG = {
            manager: window.pwaManager,
            config: PWA_CONFIG,
            clearCache: () => window.pwaManager.clearCache(),
            forceUpdate: () => window.pwaManager.forceUpdate(),
            subscribePush: () => window.pwaManager.subscribeToPushNotifications()
        };
        
        console.log('[PWA] Development mode active. Use window.PWA_DEBUG for debugging.');
    }
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { PWAManager, PWA_CONFIG };
}
