/**
 * ================================================================
 * MOBILE ROUTE JAVASCRIPT - KOPERASI BERJALAN
 * Geolocation-enabled route management for collectors
 * ================================================================ */

class MobileRoute {
    constructor() {
        this.init();
        this.setupEventListeners();
        this.loadRouteData();
        this.initializeGeolocation();
    }
    
    init() {
        this.state = {
            route: [],
            currentMemberIndex: 0,
            currentPosition: null,
            isNavigating: false,
            completedMembers: [],
            sortBy: 'distance',
            watchId: null
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
        
        // Network status monitoring
        window.addEventListener('online', () => this.handleOnlineStatus(true));
        window.addEventListener('offline', () => this.handleOnlineStatus(false));
        
        // Page visibility
        document.addEventListener('visibilitychange', () => this.handleVisibilityChange());
        
        // Back button handling
        window.addEventListener('popstate', (event) => {
            if (this.state.isNavigating) {
                this.stopNavigation();
            }
        });
    }
    
    async loadRouteData() {
        try {
            // Load route data from API
            const response = await this.apiCall('/api/collector/today-route');
            
            if (response.success) {
                this.state.route = response.data || [];
                this.renderMemberList();
                this.updateRouteStats();
                this.updateProgress();
            } else {
                this.showError('Gagal memuat data rute');
            }
        } catch (error) {
            console.error('Failed to load route data:', error);
            this.showError('Gagal memuat data rute');
        }
    }
    
    renderMemberList() {
        const memberList = document.getElementById('member-list');
        if (!memberList) return;
        
        memberList.innerHTML = '';
        
        if (this.state.route.length === 0) {
            memberList.innerHTML = `
                <div class="empty-state p-4">
                    <i class="fas fa-users fa-3x text-muted mb-3"></i>
                    <p>Belum ada anggota dalam rute</p>
                    <button class="btn btn-primary btn-sm mt-2" onclick="mobileRoute.generateRoute()">
                        <i class="fas fa-plus"></i> Buat Rute
                    </button>
                </div>
            `;
            return;
        }
        
        this.state.route.forEach((member, index) => {
            const memberItem = this.createMemberItem(member, index);
            memberList.appendChild(memberItem);
        });
        
        // Enable swipe actions
        this.enableSwipeActions();
    }
    
    createMemberItem(member, index) {
        const div = document.createElement('div');
        div.className = 'member-item swipeable';
        div.dataset.memberId = member.id;
        div.dataset.index = index;
        
        const isCompleted = this.state.completedMembers.includes(member.id);
        const distance = this.calculateDistance(member);
        const status = this.getMemberStatus(member);
        
        div.innerHTML = `
            <div class="swipe-actions">
                <div class="swipe-action swipe-action-left bg-success" onclick="mobileRoute.collectPayment(${member.id})">
                    <i class="fas fa-money-bill"></i> Bayar
                </div>
                <div class="swipe-action swipe-action-right bg-info" onclick="mobileRoute.showMemberDetails(${member.id})">
                    <i class="fas fa-info"></i> Detail
                </div>
            </div>
            <div class="swipe-content">
                <div class="member-info p-3">
                    <div class="d-flex justify-content-between align-items-start">
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center mb-1">
                                <h6 class="member-name mb-0 me-2">${member.person_name}</h6>
                                ${isCompleted ? '<i class="fas fa-check-circle text-success"></i>' : ''}
                            </div>
                            <small class="member-address text-muted d-block mb-2">${member.address}</small>
                            <div class="member-details">
                                <span class="badge ${status.class}">${status.text}</span>
                                <small class="text-muted ms-2">
                                    <i class="fas fa-map-marker-alt"></i> ${distance} km
                                </small>
                            </div>
                        </div>
                        <div class="text-end">
                            <div class="loan-amount">${this.formatCurrency(member.loan_amount)}</div>
                            <small class="loan-info">Angsuran</small>
                            ${!isCompleted ? `
                                <div class="mt-2">
                                    <button class="btn btn-sm btn-outline-primary" onclick="mobileRoute.navigateToMember(${member.id})">
                                        <i class="fas fa-directions"></i> Arahkan
                                    </button>
                                </div>
                            ` : ''}
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        return div;
    }
    
    initializeGeolocation() {
        if ('geolocation' in navigator) {
            // Get current position
            navigator.geolocation.getCurrentPosition(
                (position) => this.handleLocationUpdate(position),
                (error) => this.handleLocationError(error),
                {
                    enableHighAccuracy: true,
                    timeout: 10000,
                    maximumAge: 60000
                }
            );
        } else {
            this.showError('Geolocation tidak didukung browser ini');
        }
    }
    
    startNavigation() {
        if (this.state.route.length === 0) {
            this.showError('Tidak ada rute untuk dinavigasikan');
            return;
        }
        
        this.state.isNavigating = true;
        this.state.currentMemberIndex = 0;
        
        // Show navigation controls
        document.getElementById('navigation-controls').style.display = 'block';
        
        // Start watching position
        if ('geolocation' in navigator) {
            this.state.watchId = navigator.geolocation.watchPosition(
                (position) => this.handleNavigationPosition(position),
                (error) => this.handleLocationError(error),
                {
                    enableHighAccuracy: true,
                    timeout: 5000,
                    maximumAge: 0
                }
            );
        }
        
        // Update UI
        this.updateNavigationInfo();
        this.showNotification('Navigasi dimulai', 'success');
        
        // Push state for back button handling
        history.pushState({ navigating: true }, '', window.location.href);
    }
    
    stopNavigation() {
        this.state.isNavigating = false;
        
        // Stop watching position
        if (this.state.watchId) {
            navigator.geolocation.clearWatch(this.state.watchId);
            this.state.watchId = null;
        }
        
        // Hide navigation controls
        document.getElementById('navigation-controls').style.display = 'none';
        
        // Update UI
        this.showNotification('Navigasi dihentikan', 'info');
    }
    
    handleNavigationPosition(position) {
        this.state.currentPosition = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
            accuracy: position.coords.accuracy
        };
        
        // Update navigation info
        this.updateNavigationInfo();
        
        // Check if user arrived at destination
        this.checkArrival();
    }
    
    updateNavigationInfo() {
        if (!this.state.isNavigating || !this.state.currentPosition) return;
        
        const currentMember = this.state.route[this.state.currentMemberIndex];
        if (!currentMember) return;
        
        const distance = this.calculateDistanceFromCoords(
            this.state.currentPosition,
            { lat: currentMember.lat, lng: currentMember.lng }
        );
        
        const estimatedTime = this.estimateTravelTime(distance);
        
        document.getElementById('current-location').textContent = 
            `${this.state.currentPosition.lat.toFixed(6)}, ${this.state.currentPosition.lng.toFixed(6)}`;
        document.getElementById('next-destination').textContent = currentMember.person_name;
        document.getElementById('distance-to-destination').textContent = `${distance.toFixed(1)} km`;
        document.getElementById('estimated-time').textContent = `${estimatedTime} menit`;
    }
    
    checkArrival() {
        if (!this.state.isNavigating || !this.state.currentPosition) return;
        
        const currentMember = this.state.route[this.state.currentMemberIndex];
        if (!currentMember) return;
        
        const distance = this.calculateDistanceFromCoords(
            this.state.currentPosition,
            { lat: currentMember.lat, lng: currentMember.lng }
        );
        
        // Check if user is within 50 meters of destination
        if (distance < 0.05) {
            this.showNotification(`Anda telah tiba di ${currentMember.person_name}`, 'success');
            
            // Auto-open member details
            this.showMemberDetails(currentMember.id);
        }
    }
    
    navigateToMember(memberId) {
        const memberIndex = this.state.route.findIndex(m => m.id === memberId);
        if (memberIndex === -1) return;
        
        const member = this.state.route[memberIndex];
        
        if (!member.lat || !member.lng) {
            this.showError('Lokasi anggota tidak tersedia');
            return;
        }
        
        // Open in maps app
        const url = `https://maps.google.com/maps?q=${member.lat},${member.lng}`;
        window.open(url, '_blank');
    }
    
    collectPayment(memberId) {
        const member = this.state.route.find(m => m.id === memberId);
        if (!member) return;
        
        // Show payment modal
        const modal = document.getElementById('payment-modal');
        document.getElementById('payment-member-id').value = memberId;
        document.getElementById('payment-member-name').value = member.person_name;
        document.getElementById('payment-amount').value = member.loan_amount;
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
    }
    
    async submitPayment() {
        const memberId = document.getElementById('payment-member-id').value;
        const amount = document.getElementById('payment-amount').value;
        const method = document.getElementById('payment-method').value;
        const notes = document.getElementById('payment-notes').value;
        
        if (!amount || !method) {
            this.showError('Mohon lengkapi semua field');
            return;
        }
        
        try {
            const response = await this.apiCall('/api/loans/payment', {
                method: 'POST',
                body: JSON.stringify({
                    member_id: memberId,
                    amount: amount,
                    payment_method: method,
                    notes: notes
                })
            });
            
            if (response.success) {
                this.showNotification('Pembayaran berhasil', 'success');
                
                // Close modal
                const modal = document.getElementById('payment-modal');
                bootstrap.Modal.getInstance(modal).hide();
                
                // Refresh route data
                this.loadRouteData();
            } else {
                this.showError(response.error || 'Pembayaran gagal');
            }
        } catch (error) {
            this.showError('Gagal memproses pembayaran');
        }
    }
    
    markCompleted(memberId) {
        if (!this.state.completedMembers.includes(memberId)) {
            this.state.completedMembers.push(memberId);
        }
        
        // Update UI
        this.updateProgress();
        this.renderMemberList();
        
        // Show notification
        const member = this.state.route.find(m => m.id === memberId);
        this.showNotification(`${member.person_name} ditandai selesai`, 'success');
        
        // Move to next member if navigating
        if (this.state.isNavigating) {
            this.moveToNextMember();
        }
    }
    
    markAllCompleted() {
        this.state.route.forEach(member => {
            if (!this.state.completedMembers.includes(member.id)) {
                this.state.completedMembers.push(member.id);
            }
        });
        
        this.updateProgress();
        this.renderMemberList();
        this.showNotification('Semua anggota ditandai selesai', 'success');
        
        if (this.state.isNavigating) {
            this.stopNavigation();
        }
    }
    
    skipCurrent() {
        if (this.state.isNavigating) {
            this.moveToNextMember();
        }
    }
    
    moveToNextMember() {
        this.state.currentMemberIndex++;
        
        if (this.state.currentMemberIndex >= this.state.route.length) {
            this.showNotification('Rute selesai', 'success');
            this.stopNavigation();
        } else {
            this.updateNavigationInfo();
            this.showNotification('Menuju anggota berikutnya', 'info');
        }
    }
    
    showMemberDetails(memberId) {
        const member = this.state.route.find(m => m.id === memberId);
        if (!member) return;
        
        const modal = document.getElementById('member-modal');
        const detailsContainer = document.getElementById('member-details');
        
        detailsContainer.innerHTML = `
            <div class="member-details">
                <div class="mb-3">
                    <h6>${member.person_name}</h6>
                    <p class="text-muted">${member.address}</p>
                </div>
                
                <div class="row mb-3">
                    <div class="col-6">
                        <small class="text-muted">No. Anggota</small>
                        <p>${member.member_number}</p>
                    </div>
                    <div class="col-6">
                        <small class="text-muted">No. Telepon</small>
                        <p>${member.phone || '-'}</p>
                    </div>
                </div>
                
                <div class="mb-3">
                    <small class="text-muted">Informasi Pinjaman</small>
                    <p>Jumlah: ${this.formatCurrency(member.loan_amount)}</p>
                    <p>Tenor: ${member.loan_tenure || '-'} bulan</p>
                    <p>Status: <span class="badge bg-primary">${member.loan_status || 'Aktif'}</span></p>
                </div>
                
                ${member.lat && member.lng ? `
                <div class="mb-3">
                    <small class="text-muted">Koordinat</small>
                    <p>Lat: ${member.lat}, Lng: ${member.lng}</p>
                    <button class="btn btn-sm btn-outline-primary" onclick="mobileRoute.navigateToMember(${member.id})">
                        <i class="fas fa-map"></i> Buka Peta
                    </button>
                </div>
                ` : ''}
            </div>
        `;
        
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
    }
    
    showNotes() {
        const modal = document.getElementById('notes-modal');
        const modalInstance = new bootstrap.Modal(modal);
        modalInstance.show();
    }
    
    saveNotes() {
        const notes = document.getElementById('route-notes').value;
        
        // Save notes to localStorage or API
        localStorage.setItem('route-notes', notes);
        
        this.showNotification('Catatan disimpan', 'success');
        
        const modal = document.getElementById('notes-modal');
        bootstrap.Modal.getInstance(modal).hide();
    }
    
    generateRoute() {
        // Navigate to route generator page
        window.location.href = '/collector/route-generator';
    }
    
    sortBy(criteria) {
        this.state.sortBy = criteria;
        
        // Update button states
        document.querySelectorAll('.btn-group .btn').forEach(btn => {
            btn.classList.remove('active');
        });
        event.target.classList.add('active');
        
        // Sort route
        switch (criteria) {
            case 'distance':
                this.state.route.sort((a, b) => this.calculateDistance(a) - this.calculateDistance(b));
                break;
            case 'status':
                this.state.route.sort((a, b) => this.getMemberStatus(a).priority - this.getMemberStatus(b).priority);
                break;
            case 'amount':
                this.state.route.sort((a, b) => b.loan_amount - a.loan_amount);
                break;
        }
        
        this.renderMemberList();
    }
    
    updateRouteStats() {
        document.getElementById('total-members').textContent = this.state.route.length;
        document.getElementById('completed-members').textContent = this.state.completedMembers.length;
    }
    
    updateProgress() {
        const total = this.state.route.length;
        const completed = this.state.completedMembers.length;
        const percentage = total > 0 ? Math.round((completed / total) * 100) : 0;
        
        document.getElementById('route-percentage').textContent = `${percentage}%`;
        document.getElementById('route-progress-bar').style.width = `${percentage}%`;
    }
    
    // Geolocation methods
    handleLocationUpdate(position) {
        this.state.currentPosition = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
            accuracy: position.coords.accuracy
        };
        
        // Update distances in member list
        this.updateDistances();
    }
    
    handleLocationError(error) {
        console.warn('Geolocation error:', error);
        
        let message = 'Tidak dapat mendapatkan lokasi';
        switch (error.code) {
            case 1:
                message = 'Izinkan akses lokasi untuk fitur navigasi';
                break;
            case 2:
                message = 'Posisi tidak tersedia';
                break;
            case 3:
                message = 'Timeout mendapatkan lokasi';
                break;
        }
        
        this.showError(message);
    }
    
    updateDistances() {
        if (!this.state.currentPosition) return;
        
        document.querySelectorAll('.member-distance').forEach(element => {
            const memberId = element.closest('.member-item').dataset.memberId;
            const member = this.state.route.find(m => m.id == memberId);
            
            if (member && member.lat && member.lng) {
                const distance = this.calculateDistanceFromCoords(
                    this.state.currentPosition,
                    { lat: member.lat, lng: member.lng }
                );
                
                element.textContent = `${distance.toFixed(1)} km`;
            }
        });
    }
    
    calculateDistance(member) {
        if (!this.state.currentPosition || !member.lat || !member.lng) {
            return Math.floor(Math.random() * 10) + 1; // Random distance for demo
        }
        
        return this.calculateDistanceFromCoords(
            this.state.currentPosition,
            { lat: member.lat, lng: member.lng }
        );
    }
    
    calculateDistanceFromCoords(pos1, pos2) {
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
    
    estimateTravelTime(distance) {
        // Estimate travel time in minutes (assuming average speed of 30 km/h)
        const speed = 30; // km/h
        return Math.ceil((distance / speed) * 60);
    }
    
    // Touch events
    setupTouchEvents() {
        let touchStartX = 0;
        let touchStartY = 0;
        
        document.addEventListener('touchstart', (e) => {
            touchStartX = e.touches[0].clientX;
            touchStartY = e.touches[0].clientY;
        });
        
        document.addEventListener('touchend', (e) => {
            const touchEndX = e.changedTouches[0].clientX;
            const touchEndY = e.changedTouches[0].clientY;
            
            const deltaX = touchEndX - touchStartX;
            const deltaY = touchEndY - touchStartY;
            
            // Check if it's a horizontal swipe
            if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > 50) {
                const swipeable = document.elementFromPoint(touchStartX, touchStartY)?.closest('.swipeable');
                
                if (swipeable) {
                    if (deltaX > 0) {
                        this.swipeRight(swipeable);
                    } else {
                        this.swipeLeft(swipeable);
                    }
                }
            }
        });
    }
    
    swipeLeft(element) {
        element.classList.add('swiped-left');
        element.classList.remove('swiped-right');
        
        setTimeout(() => {
            const action = element.querySelector('.swipe-action-left');
            if (action) {
                action.click();
            }
        }, 300);
    }
    
    swipeRight(element) {
        element.classList.add('swiped-right');
        element.classList.remove('swiped-left');
        
        setTimeout(() => {
            const action = element.querySelector('.swipe-action-right');
            if (action) {
                action.click();
            }
        }, 300);
    }
    
    enableSwipeActions() {
        // Enable swipe actions on member items
        document.querySelectorAll('.member-item').forEach(item => {
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
                
                if (Math.abs(deltaX) > Math.abs(deltaY)) {
                    e.preventDefault();
                    
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
                
                setTimeout(() => {
                    item.classList.remove('swipe-left', 'swipe-right');
                }, 300);
            });
        });
    }
    
    triggerSwipeAction(item, direction) {
        const memberId = item.dataset.memberId;
        
        if (direction === 'right') {
            this.collectPayment(memberId);
        } else {
            this.showMemberDetails(memberId);
        }
    }
    
    // Utility methods
    getMemberStatus(member) {
        const isCompleted = this.state.completedMembers.includes(member.id);
        
        if (isCompleted) {
            return {
                text: 'Selesai',
                class: 'bg-success',
                priority: 3
            };
        }
        
        switch (member.loan_status) {
            case 'late':
                return {
                    text: 'Terlambat',
                    class: 'bg-warning',
                    priority: 1
                };
            case 'default':
                return {
                    text: 'Default',
                    class: 'bg-danger',
                    priority: 0
                };
            default:
                return {
                    text: 'Aktif',
                    class: 'bg-primary',
                    priority: 2
                };
        }
    }
    
    formatCurrency(amount) {
        return new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR',
            minimumFractionDigits: 0
        }).format(amount);
    }
    
    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `mobile-notification notification-${type}`;
        notification.innerHTML = `
            <div class="notification-content">
                <i class="fas fa-${this.getNotificationIcon(type)}"></i>
                <span>${message}</span>
            </div>
        `;
        
        document.body.appendChild(notification);
        
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
    
    showError(message) {
        this.showNotification(message, 'error');
    }
    
    handleOnlineStatus(isOnline) {
        const statusIndicator = document.getElementById('online-status');
        if (statusIndicator) {
            statusIndicator.className = `online-status ${isOnline ? 'online' : 'offline'}`;
            statusIndicator.innerHTML = isOnline ? 
                '<i class="fas fa-wifi"></i> Online' : 
                '<i class="fas fa-wifi-slash"></i> Offline';
        }
        
        if (isOnline) {
            this.showNotification('Koneksi tersambung kembali', 'success');
        }
    }
    
    handleVisibilityChange() {
        if (document.visibilityState === 'visible' && this.state.isNavigating) {
            // Refresh navigation info when page becomes visible
            this.updateNavigationInfo();
        }
    }
    
    setupMobileOptimizations() {
        // Prevent zoom on double tap
        let lastTouchEnd = 0;
        document.addEventListener('touchend', (event) => {
            const now = Date.now();
            if (now - lastTouchEnd <= 300) {
                event.preventDefault();
            }
            lastTouchEnd = now;
        });
        
        document.body.style.touchAction = 'pan-y';
    }
    
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
            if (!navigator.onLine) {
                throw new Error('Offline - Action saved for sync');
            }
            
            throw error;
        }
    }
}

// Initialize mobile route when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.mobileRoute = new MobileRoute();
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = MobileRoute;
}
