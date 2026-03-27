// ================================================================
// SERVICE WORKER - DISABLED FOR APPLICATION DEVELOPMENT
// ================================================================
// PWA features are disabled to focus on core application logic
// and business flow development. Will be re-enabled when application
// logic is complete and stable.
// ================================================================

console.log('[SW-DISABLED] Service Worker DISABLED - Application Development Mode');

// Install event - do nothing
self.addEventListener('install', (event) => {
    console.log('[SW-DISABLED] Install event - SKIPPED');
    self.skipWaiting();
});

// Activate event - do nothing
self.addEventListener('activate', (event) => {
    console.log('[SW-DISABLED] Activate event - SKIPPED');
    event.waitUntil(self.clients.claim());
});

// Fetch event - PASS THROUGH TO NETWORK ONLY
self.addEventListener('fetch', (event) => {
    console.log('[SW-DISABLED] Fetch event - NETWORK ONLY');
    event.respondWith(fetch(event.request));
});

// All other events disabled
self.addEventListener('push', (event) => {
    console.log('[SW-DISABLED] Push event - DISABLED');
});

self.addEventListener('sync', (event) => {
    console.log('[SW-DISABLED] Sync event - DISABLED');
});

self.addEventListener('notificationclick', (event) => {
    console.log('[SW-DISABLED] Notification click - DISABLED');
});

self.addEventListener('message', (event) => {
    console.log('[SW-DISABLED] Message event - DISABLED');
});

// NO CACHING
// NO OFFLINE FUNCTIONALITY  
// NO PUSH NOTIFICATIONS
// NO BACKGROUND SYNC
// FOCUS ON APPLICATION LOGIC ONLY
