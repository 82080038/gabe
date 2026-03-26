/**
 * ================================================================
 * MOBILE DASHBOARD JAVASCRIPT - KOPERASI BERJALAN
 * Touch-friendly interface for collectors with PWA integration
 * ================================================================ */

class MobileDashboard {
    constructor() {
        this.init();
        this.setupEventListeners();
        this.setupPWAFeatures();
        this.loadDashboardData();
        this.startRealTimeUpdates();
    }
    
    init() {
        // Initialize dashboard state
        this.state = {
            user: null,
            todayRoute: [],
            summary: {},
            currentPosition: null,
            isOnline: navigator.onLine,
            pendingActions: []
        };
        
        // Check if we're in mobile view
        this.isMobile = window.innerWidth <= 768;
        
        // Setup mobile-specific optimizations
        if (this.isMobile) {
            this.setupMobileOptimizations();
        }
    }
    
    setupEventListeners() {
        // Touch events for mobile
        if ('ontouchstart' in window) {
            this.setupTouchEvents();
        }
        
        // Geolocation for route tracking
        if ('geolocation' in navigator) {
            this.setupGeolocation();
        }
        
        // Network status monitoring
        window.addEventListener('online', () => this.handleOnlineStatus(true));
        window.addEventListener('offline', () => this.handleOnlineStatus(false));
        
        // Visibility change for background/foreground
        document.addEventListener('visibilitychange', () => this.handleVisibilityChange());
        
        // Pull to refresh
        this.setupPullToRefresh();
        
        // Swipe gestures
        this.setupSwipeGestures();
    }
    
    setupPWAFeatures() {
        // Check if PWA is installed
        if (window.matchMedia('(display-mode: standalone)').matches) {
            document.body.classList.add('pwa-installed');
        }
        
        // Setup service worker communication
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.addEventListener('message', (event) => {
                this.handleServiceWorkerMessage(event);
            });
        }
        
        // Setup background sync for offline actions
        this.setupBackgroundSync();
    }
    
    async loadDashboardData() {
        try {
            // Show loading state
            this.showLoadingState();
            
            // Load dashboard data from API
            const [summary, route, notifications] = await Promise.all([
                this.apiCall('/api/dashboard/stats'),
                this.apiCall('/api/collector/today-route'),
                this.apiCall('/api/notifications')
            ]);
            
            // Update UI with data
            this.updateSummaryCards(summary.data);
            this.updateRouteList(route.data);
            this.updateNotificationBadge(notifications.data);
            
            // Hide loading state
            this.hideLoadingState();
            
        } catch (error) {
            console.error('Failed to load dashboard data:', error);
            this.showErrorState('Gagal memuat data dashboard');
        }
    }
    
    updateSummaryCards(summary) {
        // Update summary cards with animations
        this.animateNumber('#visited-count', summary.members?.new_members_today || 0);
        this.animateNumber('#collected-amount', summary.financial?.total_debits_today || 0);
        this.animateNumber('#pending-count', summary.loans?.late_loans || 0);
        
        // Update progress bars
        this.updateProgressBar('collection-progress', summary.performance?.collections?.success_rate || 0);
        this.updateProgressBar('loan-progress', summary.performance?.loans?.approval_rate || 0);
    }
    
    updateRouteList(route) {
        const routeContainer = document.getElementById('route-list');
        if (!routeContainer) return;
        
        routeContainer.innerHTML = '';
        
        if (route.length === 0) {
            routeContainer.innerHTML = `
                <div class="empty-state text-center py-4">
                    <i class="fas fa-route fa-3x text-muted mb-3"></i>
                    <p class="text-muted">Belum ada rute hari ini</p>
                    <button class="btn btn-primary btn-sm mt-2" onclick="mobileDashboard.generateRoute()">
                        <i class="fas fa-plus"></i> Buat Rute
                    </button>
                </div>
            `;
            return;
        }
        
        route.forEach((member, index) => {
            const routeItem = this.createRouteItem(member, index);
            routeContainer.appendChild(routeItem);
        });
        
        // Enable swipe actions
        this.enableSwipeActions();
    }
    
    createRouteItem(member, index) {
        const div = document.createElement('div');
        div.className = 'route-item swipeable';
        div.dataset.memberId = member.id;
        
        const status = this.getMemberStatus(member);
        const distance = this.calculateDistance(member);
        
        div.innerHTML = `
            <div class="swipe-actions">
                <div class="swipe-action swipe-action-left bg-success" onclick="mobileDashboard.quickCollect(${member.id})">
                    <i class="fas fa-money-bill"></i> Bayar
                </div>
                <div class="swipe-action swipe-action-right bg-info" onclick="mobileDashboard.viewDetails(${member.id})">
                    <i class="fas fa-info"></i> Detail
                </div>
            </div>
            <div class="swipe-content">
                <div class="d-flex justify-content-between align-items-center p-3">
                    <div class="flex-grow-1">
                        <h6 class="mb-1">${member.person_name}</h6>
                        <small class="text-muted">${member.address}</small>
                        <div class="mt-1">
                            <span class="badge ${status.class}">${status.text}</span>
                            <small class="text-muted ml-2">
                                <i class="fas fa-map-marker-alt"></i> ${distance} km
                            </small>
                        </div>
                    </div>
                    <div class="text-right">
                        <div class="text-primary fw-bold">${this.formatCurrency(member.loan_amount)}</div>
                        <small class="text-muted">Angsuran</small>
                    </div>
                </div>
                <div class="progress" style="height: 3px;">
                    <div class="progress-bar bg-${status.progressColor}" style="width: ${status.progress}%"></div>
                </div>
            </div>
        `;
        
        return div;
    }
    
    setupTouchEvents() {
        let touchStartX = 0;
        let touchStartY = 0;
        let touchEndX = 0;
        let touchEndY = 0;
        
        document.addEventListener('touchstart', (e) => {
            touchStartX = e.changedTouches[0].screenX;
            touchStartY = e.changedTouches[0].screenY;
        });
        
        document.addEventListener('touchend', (e) => {
            touchEndX = e.changedTouches[0].screenX;
            touchEndY = e.changedTouches[0].screenY;
            this.handleSwipeGesture(touchStartX, touchStartY, touchEndX, touchEndY);
        });
    }
    
    handleSwipeGesture(startX, startY, endX, endY) {
        const deltaX = endX - startX;
        const deltaY = endY - startY;
        
        // Check if it's a horizontal swipe
        if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > 50) {
            const swipeable = document.elementFromPoint(startX, startY)?.closest('.swipeable');
            
            if (swipeable) {
                if (deltaX > 0) {
                    this.swipeRight(swipeable);
                } else {
                    this.swipeLeft(swipeable);
                }
            }
        }
    }
    
    swipeLeft(element) {
        element.classList.add('swiped-left');
        element.classList.remove('swiped-right');
        
        // Trigger action after animation
        setTimeout(() => {
            const action = element.querySelector('.swipe-action-right');
            if (action) {
                action.click();
            }
        }, 300);
    }
    
    swipeRight(element) {
        element.classList.add('swiped-right');
        element.classList.remove('swiped-left');
        
        // Trigger action after animation
        setTimeout(() => {
            const action = element.querySelector('.swipe-action-left');
            if (action) {
                action.click();
            }
        }, 300);
    }
    
    setupGeolocation() {
        if ('geolocation' in navigator) {
            navigator.geolocation.watchPosition(
                (position) => this.handleLocationUpdate(position),
                (error) => this.handleLocationError(error),
                {
                    enableHighAccuracy: true,
                    timeout: 5000,
                    maximumAge: 60000 // 1 minute
                }
            );
        }
    }
    
    handleLocationUpdate(position) {
        this.state.currentPosition = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
            accuracy: position.coords.accuracy
        };
        
        // Update distance indicators
        this.updateDistances();
        
        // Check if user is near a member location
        this.checkProximityAlerts();
    }
    
    handleLocationError(error) {
        console.warn('Geolocation error:', error);
        
        // Show user-friendly message
        if (error.code === 1) {
            this.showNotification('Izinkan akses lokasi untuk fitur rute', 'warning');
        } else if (error.code === 3) {
            this.showNotification('Timeout mendapatkan lokasi', 'warning');
        }
    }
    
    updateDistances() {
        if (!this.state.currentPosition) return;
        
        document.querySelectorAll('.route-item').forEach(item => {
            const memberId = item.dataset.memberId;
            const member = this.findMemberById(memberId);
            
            if (member && member.lat && member.lng) {
                const distance = this.calculateDistanceFromCoords(
                    this.state.currentPosition,
                    { lat: member.lat, lng: member.lng }
                );
                
                const distanceElement = item.querySelector('.distance');
                if (distanceElement) {
                    distanceElement.textContent = `${distance.toFixed(1)} km`;
                }
            }
        });
    }
    
    calculateDistanceFromCoords(pos1, pos2) {
        // Haversine formula for calculating distance
        const R = 6371; // Earth's radius in km
        const dLat = this.toRadians(pos2.lat - pos1.lat);
        const dLon = this.toRadians(pos2.lng - pos1.lng);
        
        const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                  Math.cos(this.toRadians(pos1.lat)) * Math.cos(this.toRadians(pos2.lat)) *
                  Math.sin(dLon/2) * Math.sin(dLon/2);
        
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
        return R * c;
    }
    
    toRadians(degrees) {
        return degrees * (Math.PI / 180);
    }
    
    setupPullToRefresh() {
        let startY = 0;
        let isPulling = false;
        
        const container = document.querySelector('.container-fluid');
        
        container.addEventListener('touchstart', (e) => {
            if (window.scrollY === 0) {
                startY = e.touches[0].pageY;
                isPulling = true;
            }
        });
        
        container.addEventListener('touchmove', (e) => {
            if (!isPulling) return;
            
            const currentY = e.touches[0].pageY;
            const pullDistance = currentY - startY;
            
            if (pullDistance > 0) {
                e.preventDefault();
                this.showPullIndicator(pullDistance);
            }
        });
        
        container.addEventListener('touchend', (e) => {
            if (!isPulling) return;
            
            isPulling = false;
            const pullDistance = e.changedTouches[0].pageY - startY;
            
            if (pullDistance > 100) {
                this.refreshDashboard();
            } else {
                this.hidePullIndicator();
            }
        });
    }
    
    showPullIndicator(distance) {
        const indicator = document.getElementById('pull-indicator');
        if (!indicator) {
            const div = document.createElement('div');
            div.id = 'pull-indicator';
            div.className = 'pull-indicator';
            div.innerHTML = '<i class="fas fa-sync-alt"></i>';
            document.body.appendChild(div);
        }
        
        const height = Math.min(distance * 0.5, 60);
        indicator.style.height = `${height}px`;
        indicator.style.opacity = Math.min(distance / 100, 1);
    }
    
    hidePullIndicator() {
        const indicator = document.getElementById('pull-indicator');
        if (indicator) {
            indicator.style.height = '0';
            indicator.style.opacity = '0';
            setTimeout(() => indicator.remove(), 300);
        }
    }
    
    async refreshDashboard() {
        this.showPullIndicator(100);
        
        try {
            await this.loadDashboardData();
            this.showNotification('Dashboard diperbarui', 'success');
        } catch (error) {
            this.showNotification('Gagal memperbarui dashboard', 'error');
        } finally {
            this.hidePullIndicator();
        }
    }
    
    setupBackgroundSync() {
        // Register background sync for offline actions
        if ('serviceWorker' in navigator && 'sync' in window.ServiceWorkerRegistration.prototype) {
            navigator.serviceWorker.ready.then((registration) => {
                // Register sync for pending actions
                this.registerBackgroundSync(registration);
            });
        }
    }
    
    registerBackgroundSync(registration) {
        // Check for pending actions and register sync
        const pendingActions = this.getPendingActions();
        
        if (pendingActions.length > 0) {
            registration.sync.register('background-sync');
        }
    }
    
    getPendingActions() {
        return JSON.parse(localStorage.getItem('pendingActions') || '[]');
    }
    
    savePendingAction(action) {
        const pendingActions = this.getPendingActions();
        pendingActions.push({
            ...action,
            timestamp: Date.now(),
            id: this.generateId()
        });
        
        localStorage.setItem('pendingActions', JSON.stringify(pendingActions));
        
        // Register background sync
        if ('serviceWorker' in navigator && 'sync' in window.ServiceWorkerRegistration.prototype) {
            navigator.serviceWorker.ready.then((registration) => {
                registration.sync.register('background-sync');
            });
        }
    }
    
    generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }
    
    // API Methods
    async apiCall(endpoint, options = {}) {
        const token = localStorage.getItem('authToken');
        
        const config = {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            ...options
        };
        
        try {
            const response = await fetch(`/api${endpoint}`, config);
            
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            
            return await response.json();
        } catch (error) {
            // Handle offline scenario
            if (!navigator.onLine) {
                this.savePendingAction({
                    endpoint,
                    options: config,
                    type: 'api_call'
                });
                
                throw new Error('Offline - Action saved for sync');
            }
            
            throw error;
        }
    }
    
    // UI Helper Methods
    animateNumber(selector, targetValue) {
        const element = document.querySelector(selector);
        if (!element) return;
        
        const duration = 1000;
        const startValue = 0;
        const startTime = performance.now();
        
        const animate = (currentTime) => {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            
            const currentValue = Math.floor(startValue + (targetValue - startValue) * progress);
            element.textContent = this.formatNumber(currentValue);
            
            if (progress < 1) {
                requestAnimationFrame(animate);
            }
        };
        
        requestAnimationFrame(animate);
    }
    
    updateProgressBar(selector, percentage) {
        const progressBar = document.querySelector(`#${selector}`);
        if (progressBar) {
            progressBar.style.width = `${percentage}%`;
            progressBar.setAttribute('aria-valuenow', percentage);
        }
    }
    
    formatNumber(num) {
        return new Intl.NumberFormat('id-ID').format(num);
    }
    
    formatCurrency(amount) {
        return new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR',
            minimumFractionDigits: 0
        }).format(amount);
    }
    
    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `mobile-notification notification-${type}`;
        notification.innerHTML = `
            <div class="notification-content">
                <i class="fas fa-${this.getNotificationIcon(type)}"></i>
                <span>${message}</span>
            </div>
        `;
        
        document.body.appendChild(notification);
        
        // Auto remove after 3 seconds
        setTimeout(() => {
            notification.classList.add('notification-hide');
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }
    
    getNotificationIcon(type) {
        const icons = {
            success: 'check-circle',
            error: 'exclamation-circle',
            warning: 'exclamation-triangle',
            info: 'info-circle'
        };
        return icons[type] || 'info-circle';
    }
    
    showLoadingState() {
        const loader = document.createElement('div');
        loader.id = 'dashboard-loader';
        loader.className = 'dashboard-loader';
        loader.innerHTML = `
            <div class="spinner-border text-primary" role="status">
                <span class="sr-only">Loading...</span>
            </div>
            <p class="mt-2">Memuat data...</p>
        `;
        
        document.body.appendChild(loader);
    }
    
    hideLoadingState() {
        const loader = document.getElementById('dashboard-loader');
        if (loader) {
            loader.remove();
        }
    }
    
    showErrorState(message) {
        const errorContainer = document.getElementById('error-container');
        if (errorContainer) {
            errorContainer.innerHTML = `
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${message}
                    <button class="btn btn-sm btn-outline-danger ml-2" onclick="mobileDashboard.refreshDashboard()">
                        <i class="fas fa-sync-alt"></i> Coba Lagi
                    </button>
                </div>
            `;
        }
    }
    
    // Action Methods
    async quickCollect(memberId) {
        try {
            // Show quick collect modal
            this.showQuickCollectModal(memberId);
        } catch (error) {
            this.showNotification('Gagal membuka form pembayaran', 'error');
        }
    }
    
    showQuickCollectModal(memberId) {
        // Create modal for quick payment
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Pembayaran Cepat</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="quick-collect-form">
                            <input type="hidden" name="member_id" value="${memberId}">
                            <div class="mb-3">
                                <label for="amount" class="form-label">Jumlah Pembayaran</label>
                                <input type="number" class="form-control" id="amount" name="amount" required>
                            </div>
                            <div class="mb-3">
                                <label for="payment_method" class="form-label">Metode Pembayaran</label>
                                <select class="form-select" id="payment_method" name="payment_method" required>
                                    <option value="">Pilih metode</option>
                                    <option value="cash">Tunai</option>
                                    <option value="transfer">Transfer</option>
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                        <button type="button" class="btn btn-primary" onclick="mobileDashboard.submitQuickCollect()">Bayar</button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Show modal
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
        
        // Clean up on hide
        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove();
        });
    }
    
    async submitQuickCollect() {
        const form = document.getElementById('quick-collect-form');
        const formData = new FormData(form);
        
        try {
            const response = await this.apiCall('/api/loans/payment', {
                method: 'POST',
                body: JSON.stringify(Object.fromEntries(formData))
            });
            
            if (response.success) {
                this.showNotification('Pembayaran berhasil', 'success');
                
                // Close modal
                const modal = form.closest('.modal');
                bootstrap.Modal.getInstance(modal).hide();
                
                // Refresh dashboard
                this.loadDashboardData();
            } else {
                this.showNotification(response.error || 'Pembayaran gagal', 'error');
            }
        } catch (error) {
            this.showNotification('Gagal memproses pembayaran', 'error');
        }
    }
    
    viewDetails(memberId) {
        // Navigate to member details page
        window.location.href = `/collector/member/${memberId}`;
    }
    
    generateRoute() {
        // Navigate to route generation page
        window.location.href = '/collector/route-generator';
    }
    
    // Real-time updates
    startRealTimeUpdates() {
        // Update every 30 seconds
        setInterval(() => {
            if (document.visibilityState === 'visible') {
                this.loadDashboardData();
            }
        }, 30000);
    }
    
    handleVisibilityChange() {
        if (document.visibilityState === 'visible') {
            // Page became visible, refresh data
            this.loadDashboardData();
        }
    }
    
    handleOnlineStatus(isOnline) {
        this.state.isOnline = isOnline;
        
        // Update UI
        const statusIndicator = document.getElementById('online-status');
        if (statusIndicator) {
            statusIndicator.className = isOnline ? 'online' : 'offline';
            statusIndicator.innerHTML = isOnline ? 
                '<i class="fas fa-wifi"></i> Online' : 
                '<i class="fas fa-wifi-slash"></i> Offline';
        }
        
        // Show notification
        if (isOnline) {
            this.showNotification('Koneksi tersambung kembali', 'success');
            // Sync pending actions
            this.syncPendingActions();
        } else {
            this.showNotification('Koneksi terputus', 'warning');
        }
    }
    
    async syncPendingActions() {
        const pendingActions = this.getPendingActions();
        
        for (const action of pendingActions) {
            try {
                await this.apiCall(action.endpoint, action.options);
                this.removePendingAction(action.id);
            } catch (error) {
                console.error('Failed to sync action:', error);
            }
        }
    }
    
    removePendingAction(actionId) {
        const pendingActions = this.getPendingActions();
        const filteredActions = pendingActions.filter(action => action.id !== actionId);
        localStorage.setItem('pendingActions', JSON.stringify(filteredActions));
    }
    
    handleServiceWorkerMessage(event) {
        if (event.data?.type === 'SYNC_COMPLETED') {
            this.showNotification('Data berhasil disinkronisasi', 'success');
            this.loadDashboardData();
        }
    }
    
    // Utility methods
    getMemberStatus(member) {
        // Determine member status based on loan payments
        const status = {
            text: 'Aktif',
            class: 'bg-success',
            progressColor: 'success',
            progress: 100
        };
        
        if (member.loan_status === 'late') {
            status.text = 'Terlambat';
            status.class = 'bg-warning';
            status.progressColor = 'warning';
            status.progress = 60;
        } else if (member.loan_status === 'default') {
            status.text = 'Default';
            status.class = 'bg-danger';
            status.progressColor = 'danger';
            status.progress = 30;
        }
        
        return status;
    }
    
    calculateDistance(member) {
        // Calculate distance from current position or use default
        if (this.state.currentPosition && member.lat && member.lng) {
            return this.calculateDistanceFromCoords(
                this.state.currentPosition,
                { lat: member.lat, lng: member.lng }
            );
        }
        
        return Math.floor(Math.random() * 10) + 1; // Random distance for demo
    }
    
    findMemberById(memberId) {
        // Find member in today's route
        return this.state.todayRoute.find(member => member.id === memberId);
    }
    
    setupMobileOptimizations() {
        // Add mobile-specific classes
        document.body.classList.add('mobile-optimized');
        
        // Prevent zoom on double tap
        let lastTouchEnd = 0;
        document.addEventListener('touchend', (event) => {
            const now = Date.now();
            if (now - lastTouchEnd <= 300) {
                event.preventDefault();
            }
            lastTouchEnd = now;
        });
        
        // Optimize scrolling
        document.body.style.touchAction = 'pan-y';
        
        // Setup viewport for mobile
        const viewport = document.querySelector('meta[name="viewport"]');
        if (viewport) {
            viewport.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');
        }
    }
    
    enableSwipeActions() {
        // Enable swipe actions on route items
        document.querySelectorAll('.route-item').forEach(item => {
            item.addEventListener('touchstart', (e) => {
                item.dataset.touchStartX = e.touches[0].clientX;
                item.dataset.touchStartY = e.touches[0].clientY;
            });
            
            item.addEventListener('touchmove', (e) => {
                const touchX = e.touches[0].clientX;
                const touchY = e.touches[0].clientY;
                const startX = parseFloat(item.dataset.touchStartX);
                const startY = parseFloat(item.dataset.touchStartY);
                
                const deltaX = touchX - startX;
                const deltaY = touchY - startY;
                
                // Only handle horizontal swipes
                if (Math.abs(deltaX) > Math.abs(deltaY)) {
                    e.preventDefault();
                    
                    // Add visual feedback
                    if (deltaX > 50) {
                        item.classList.add('swipe-right');
                        item.classList.remove('swipe-left');
                    } else if (deltaX < -50) {
                        item.classList.add('swipe-left');
                        item.classList.remove('swipe-right');
                    } else {
                        item.classList.remove('swipe-left', 'swipe-right');
                    }
                }
            });
            
            item.addEventListener('touchend', (e) => {
                const touchX = e.changedTouches[0].clientX;
                const startX = parseFloat(item.dataset.touchStartX);
                const deltaX = touchX - startX;
                
                if (Math.abs(deltaX) > 100) {
                    if (deltaX > 0) {
                        this.triggerSwipeAction(item, 'right');
                    } else {
                        this.triggerSwipeAction(item, 'left');
                    }
                }
                
                // Reset classes
                setTimeout(() => {
                    item.classList.remove('swipe-left', 'swipe-right');
                }, 300);
            });
        });
    }
    
    triggerSwipeAction(item, direction) {
        const memberId = item.dataset.memberId;
        
        if (direction === 'right') {
            this.quickCollect(memberId);
        } else {
            this.viewDetails(memberId);
        }
    }
    
    updateNotificationBadge(notifications) {
        const badge = document.getElementById('notification-badge');
        if (badge) {
            const unreadCount = notifications.filter(n => !n.read).length;
            badge.textContent = unreadCount;
            badge.style.display = unreadCount > 0 ? 'block' : 'none';
        }
    }
}

// Initialize mobile dashboard when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.mobileDashboard = new MobileDashboard();
    
    // Make it globally available for inline onclick handlers
    window.mobileDashboard = window.mobileDashboard;
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = MobileDashboard;
}
