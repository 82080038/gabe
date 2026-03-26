// ================================================================
// SERVICE WORKER - KOPERASI BERJALAN PWA
// Development-ready with offline caching and sync capabilities
// ================================================================

const CACHE_NAME = 'koperasi-berjalan-v1.0.0';
const STATIC_CACHE = 'koperasi-static-v1.0.0';
const DYNAMIC_CACHE = 'koperasi-dynamic-v1.0.0';
const API_CACHE = 'koperasi-api-v1.0.0';

// Files to cache for offline functionality
const STATIC_ASSETS = [
    '/',
    '/index.php',
    '/pages/login.php',
    '/pages/web/dashboard.php',
    '/assets/css/bootstrap.min.css',
    '/assets/css/responsive.css',
    '/assets/js/bootstrap.bundle.min.js',
    '/assets/js/responsive-manager.js',
    '/assets/js/app.js',
    '/manifest.json',
    '/assets/icons/icon-192x192.png',
    '/assets/icons/icon-512x512.png'
];

// API endpoints to cache
const API_ENDPOINTS = [
    '/api/auth/login',
    '/api/auth/logout',
    '/api/user/profile',
    '/api/dashboard/stats',
    '/api/members/list',
    '/api/loans/list',
    '/api/savings/list'
];

// ================================================================
// INSTALL EVENT - Cache static assets
// ================================================================
self.addEventListener('install', (event) => {
    console.log('[SW] Installing Service Worker v1.0.0');
    
    event.waitUntil(
        caches.open(STATIC_CACHE)
            .then((cache) => {
                console.log('[SW] Caching static assets');
                return cache.addAll(STATIC_ASSETS);
            })
            .then(() => {
                console.log('[SW] Static assets cached successfully');
                return self.skipWaiting();
            })
            .catch((error) => {
                console.error('[SW] Failed to cache static assets:', error);
            })
    );
});

// ================================================================
// ACTIVATE EVENT - Clean up old caches
// ================================================================
self.addEventListener('activate', (event) => {
    console.log('[SW] Activating Service Worker v1.0.0');
    
    event.waitUntil(
        caches.keys()
            .then((cacheNames) => {
                return Promise.all(
                    cacheNames.map((cacheName) => {
                        if (cacheName !== STATIC_CACHE && 
                            cacheName !== DYNAMIC_CACHE && 
                            cacheName !== API_CACHE &&
                            cacheName !== CACHE_NAME) {
                            console.log('[SW] Deleting old cache:', cacheName);
                            return caches.delete(cacheName);
                        }
                    })
                );
            })
            .then(() => {
                console.log('[SW] Service Worker activated');
                return self.clients.claim();
            })
    );
});

// ================================================================
// FETCH EVENT - Handle network requests
// ================================================================
self.addEventListener('fetch', (event) => {
    const { request } = event;
    const url = new URL(request.url);
    
    // Skip non-HTTP requests
    if (!request.url.startsWith('http')) {
        return;
    }
    
    // Handle different request types
    if (request.method === 'GET') {
        // Static assets - Cache First Strategy
        if (isStaticAsset(request.url)) {
            event.respondWith(cacheFirst(request, STATIC_CACHE));
        }
        // API requests - Network First Strategy
        else if (isAPIRequest(request.url)) {
            event.respondWith(networkFirst(request, API_CACHE));
        }
        // Other requests - Stale While Revalidate
        else {
            event.respondWith(staleWhileRevalidate(request, DYNAMIC_CACHE));
        }
    }
    // Handle POST/PUT/DELETE requests
    else {
        event.respondWith(handleMutatingRequest(request));
    }
});

// ================================================================
// CACHE STRATEGIES
// ================================================================

// Cache First - For static assets
async function cacheFirst(request, cacheName) {
    try {
        const cachedResponse = await caches.match(request);
        if (cachedResponse) {
            return cachedResponse;
        }
        
        const networkResponse = await fetch(request);
        if (networkResponse.ok) {
            const cache = await caches.open(cacheName);
            cache.put(request, networkResponse.clone());
        }
        return networkResponse;
    } catch (error) {
        console.error('[SW] Cache First failed:', error);
        return getOfflineFallback(request);
    }
}

// Network First - For API requests
async function networkFirst(request, cacheName) {
    try {
        const networkResponse = await fetch(request);
        if (networkResponse.ok) {
            const cache = await caches.open(cacheName);
            cache.put(request, networkResponse.clone());
        }
        return networkResponse;
    } catch (error) {
        console.log('[SW] Network failed, trying cache:', error);
        const cachedResponse = await caches.match(request);
        if (cachedResponse) {
            return cachedResponse;
        }
        return getAPIFallback(request);
    }
}

// Stale While Revalidate - For dynamic content
async function staleWhileRevalidate(request, cacheName) {
    const cache = await caches.open(cacheName);
    const cachedResponse = await cache.match(request);
    
    const fetchPromise = fetch(request).then((networkResponse) => {
        if (networkResponse.ok) {
            cache.put(request, networkResponse.clone());
        }
        return networkResponse;
    }).catch((error) => {
        console.error('[SW] Stale While Revalidate failed:', error);
    });
    
    return cachedResponse || fetchPromise;
}

// ================================================================
// MUTATING REQUESTS - Handle POST/PUT/DELETE
// ================================================================
async function handleMutatingRequest(request) {
    try {
        const networkResponse = await fetch(request);
        
        // If successful, invalidate relevant caches
        if (networkResponse.ok) {
            await invalidateRelatedCaches(request);
        }
        
        return networkResponse;
    } catch (error) {
        console.error('[SW] Mutating request failed:', error);
        
        // Store failed request for background sync
        if ('sync' in self.registration) {
            await storeRequestForSync(request);
            return new Response(
                JSON.stringify({ 
                    success: false, 
                    message: 'Request stored for background sync' 
                }),
                { status: 202, headers: { 'Content-Type': 'application/json' } }
            );
        }
        
        throw error;
    }
}

// ================================================================
// BACKGROUND SYNC - Handle failed requests
// ================================================================
self.addEventListener('sync', (event) => {
    if (event.tag === 'background-sync') {
        event.waitUntil(processBackgroundSync());
    }
});

async function processBackgroundSync() {
    try {
        const failedRequests = await getStoredRequests();
        
        for (const request of failedRequests) {
            try {
                await fetch(request);
                await removeStoredRequest(request.id);
            } catch (error) {
                console.error('[SW] Background sync failed for request:', error);
            }
        }
    } catch (error) {
        console.error('[SW] Background sync process failed:', error);
    }
}

// ================================================================
// PUSH NOTIFICATIONS
// ================================================================
self.addEventListener('push', (event) => {
    const options = {
        body: event.data ? event.data.text() : 'Notifikasi baru dari Koperasi Berjalan',
        icon: '/assets/icons/icon-192x192.png',
        badge: '/assets/icons/badge-72x72.png',
        vibrate: [100, 50, 100],
        data: {
            dateOfArrival: Date.now(),
            primaryKey: 1
        },
        actions: [
            {
                action: 'explore',
                title: 'Lihat Detail',
                icon: '/assets/icons/checkmark.png'
            },
            {
                action: 'close',
                title: 'Tutup',
                icon: '/assets/icons/xmark.png'
            }
        ]
    };
    
    event.waitUntil(
        self.registration.showNotification('Koperasi Berjalan', options)
    );
});

self.addEventListener('notificationclick', (event) => {
    event.notification.close();
    
    if (event.action === 'explore') {
        event.waitUntil(
            clients.openWindow('/')
        );
    }
});

// ================================================================
// UTILITY FUNCTIONS
// ================================================================

function isStaticAsset(url) {
    return url.includes('/assets/') || 
           url.includes('.css') || 
           url.includes('.js') || 
           url.includes('.png') || 
           url.includes('.jpg') || 
           url.includes('.svg') ||
           url.endsWith('/manifest.json');
}

function isAPIRequest(url) {
    return url.includes('/api/') || url.includes('/ajax/');
}

async function getOfflineFallback(request) {
    if (request.url.includes('/pages/')) {
        return caches.match('/pages/offline.php') || 
               new Response('Halaman tidak tersedia offline', { status: 503 });
    }
    
    return new Response('Offline - Tidak ada koneksi internet', { 
        status: 503,
        headers: { 'Content-Type': 'text/plain' }
    });
}

async function getAPIFallback(request) {
    return new Response(
        JSON.stringify({ 
            success: false, 
            message: 'Offline - Data tidak tersedia',
            cached: true 
        }),
        { 
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        }
    );
}

async function invalidateRelatedCaches(request) {
    const url = new URL(request.url);
    
    // Clear dynamic cache for page requests
    if (url.pathname.includes('/pages/')) {
        await caches.delete(DYNAMIC_CACHE);
    }
    
    // Clear API cache for API requests
    if (url.pathname.includes('/api/')) {
        await caches.delete(API_CACHE);
    }
}

// ================================================================
// BACKGROUND SYNC STORAGE (IndexedDB)
// ================================================================

async function storeRequestForSync(request) {
    const requestData = {
        id: Date.now() + Math.random(),
        url: request.url,
        method: request.method,
        headers: Object.fromEntries(request.headers.entries()),
        body: await request.text(),
        timestamp: Date.now()
    };
    
    // Store in IndexedDB (simplified version)
    const db = await openSyncDB();
    const tx = db.transaction('requests', 'readwrite');
    await tx.objectStore('requests').add(requestData);
}

async function getStoredRequests() {
    const db = await openSyncDB();
    const tx = db.transaction('requests', 'readonly');
    return await tx.objectStore('requests').getAll();
}

async function removeStoredRequest(id) {
    const db = await openSyncDB();
    const tx = db.transaction('requests', 'readwrite');
    await tx.objectStore('requests').delete(id);
}

async function openSyncDB() {
    return new Promise((resolve, reject) => {
        const request = indexedDB.open('koperasi-sync-db', 1);
        
        request.onerror = () => reject(request.error);
        request.onsuccess = () => resolve(request.result);
        
        request.onupgradeneeded = (event) => {
            const db = event.target.result;
            if (!db.objectStoreNames.contains('requests')) {
                db.createObjectStore('requests', { keyPath: 'id' });
            }
        };
    });
}

// ================================================================
// MESSAGE HANDLING - Communication with main thread
// ================================================================
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SKIP_WAITING') {
        self.skipWaiting();
    }
    
    if (event.data && event.data.type === 'FORCE_REFRESH') {
        self.clients.matchAll().then((clients) => {
            clients.forEach((client) => {
                client.navigate(client.url);
            });
        });
    }
});

console.log('[SW] Service Worker loaded successfully');
