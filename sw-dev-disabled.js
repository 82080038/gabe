// ================================================================
// SERVICE WORKER - DEVELOPMENT MODE (DISABLED)
// ================================================================
// This is a disabled service worker for development
// The original sw.js is causing issues during development
// ================================================================

console.log('[SW-DEV] Service Worker is DISABLED for development');

// Install event - do nothing
self.addEventListener('install', (event) => {
    console.log('[SW-DEV] Service Worker install event - DISABLED');
    self.skipWaiting();
});

// Activate event - do nothing
self.addEventListener('activate', (event) => {
    console.log('[SW-DEV] Service Worker activate event - DISABLED');
    event.waitUntil(self.clients.claim());
});

// Fetch event - pass through to network
self.addEventListener('fetch', (event) => {
    console.log('[SW-DEV] Fetch event - PASSING TO NETWORK');
    event.respondWith(fetch(event.request));
});

// Push event - disabled
self.addEventListener('push', (event) => {
    console.log('[SW-DEV] Push event - DISABLED');
});

// Sync event - disabled
self.addEventListener('sync', (event) => {
    console.log('[SW-DEV] Sync event - DISABLED');
});

// Notification click - disabled
self.addEventListener('notificationclick', (event) => {
    console.log('[SW-DEV] Notification click - DISABLED');
    event.notification.close();
});
