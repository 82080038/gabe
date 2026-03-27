/**
 * Responsive Manager untuk Aplikasi Koperasi Berjalan
 * Mengelola tampilan web vs mobile berdasarkan device dan role
 */

class ResponsiveManager {
    constructor() {
        this.deviceType = this.detectDeviceType();
        this.screenSize = this.getScreenSize();
        this.userRole = window.userRole || 'guest';
        this.config = window.deviceConfig || {};
        
        this.init();
    }
    
    /**
     * Inisialisasi responsive manager
     */
    init() {
        this.setupDeviceClasses();
        this.setupViewportMeta();
        this.setupResponsiveHandlers();
        this.setupRoleBasedUI();
        this.setupPerformanceOptimizations();
        this.setupPWAFeatures();
        
        // Emit ready event
        document.dispatchEvent(new CustomEvent('responsiveManager:ready'));
    }
    
    /**
     * Deteksi tipe device
     */
    detectDeviceType() {
        const userAgent = navigator.userAgent.toLowerCase();
        const screenWidth = window.screen.width;
        
        // Priority: viewport width > user agent
        if (window.innerWidth < 768) {
            return 'mobile';
        } else if (window.innerWidth < 1024) {
            return 'tablet';
        } else {
            return 'desktop';
        }
    }
    
    /**
     * Get screen size category
     */
    getScreenSize() {
        const width = window.innerWidth;
        
        if (width < 576) return 'xs';
        if (width < 768) return 'sm';
        if (width < 992) return 'md';
        if (width < 1200) return 'lg';
        if (width < 1400) return 'xl';
        return 'xxl';
    }
    
    /**
     * Setup device classes
     */
    setupDeviceClasses() {
        const body = document.body;
        
        // Remove existing device classes
        body.classList.remove('device-mobile', 'device-tablet', 'device-desktop');
        body.classList.remove('screen-xs', 'screen-sm', 'screen-md', 'screen-lg', 'screen-xl', 'screen-xxl');
        
        // Add current device classes
        body.classList.add(`device-${this.deviceType}`);
        body.classList.add(`screen-${this.screenSize}`);
        body.classList.add(`role-${this.userRole}`);
        
        // Add render mode
        const renderMode = this.getRenderMode();
        body.classList.add(`render-${renderMode}`);
        
        console.log(`Device: ${this.deviceType}, Screen: ${this.screenSize}, Role: ${this.userRole}, Render: ${renderMode}`);
    }
    
    /**
     * Setup viewport meta tag
     */
    setupViewportMeta() {
        let viewport = document.querySelector('meta[name="viewport"]');
        
        if (!viewport) {
            viewport = document.createElement('meta');
            viewport.name = 'viewport';
            document.head.appendChild(viewport);
        }
        
        // Different viewport settings per device
        if (this.deviceType === 'mobile') {
            viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        } else {
            viewport.content = 'width=device-width, initial-scale=1.0';
        }
    }
    
    /**
     * Setup responsive handlers
     */
    setupResponsiveHandlers() {
        // Handle resize events
        let resizeTimer;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(() => {
                this.handleResize();
            }, 250);
        });
        
        // Handle orientation change
        window.addEventListener('orientationchange', () => {
            setTimeout(() => {
                this.handleOrientationChange();
            }, 100);
        });
        
        // Setup media queries
        this.setupMediaQueries();
    }
    
    /**
     * Handle resize events
     */
    handleResize() {
        const oldDeviceType = this.deviceType;
        const oldScreenSize = this.screenSize;
        
        this.deviceType = this.detectDeviceType();
        this.screenSize = this.getScreenSize();
        
        // Update classes if device changed
        if (oldDeviceType !== this.deviceType || oldScreenSize !== this.screenSize) {
            this.setupDeviceClasses();
            this.updateUIForDevice();
            
            // Emit change event
            document.dispatchEvent(new CustomEvent('responsiveManager:deviceChanged', {
                detail: {
                    oldDeviceType,
                    newDeviceType: this.deviceType,
                    oldScreenSize,
                    newScreenSize: this.screenSize
                }
            }));
        }
    }
    
    /**
     * Handle orientation change
     */
    handleOrientationChange() {
        if (this.deviceType === 'mobile') {
            // Re-render mobile layout
            this.updateUIForDevice();
            
            // Emit orientation change event
            document.dispatchEvent(new CustomEvent('responsiveManager:orientationChanged'));
        }
    }
    
    /**
     * Setup media queries
     */
    setupMediaQueries() {
        const mediaQueries = {
            mobile: window.matchMedia('(max-width: 767px)'),
            tablet: window.matchMedia('(min-width: 768px) and (max-width: 1023px)'),
            desktop: window.matchMedia('(min-width: 1024px)')
        };
        
        Object.keys(mediaQueries).forEach(device => {
            mediaQueries[device].addListener((mq) => {
                if (mq.matches && this.deviceType !== device) {
                    this.deviceType = device;
                    this.setupDeviceClasses();
                    this.updateUIForDevice();
                }
            });
        });
    }
    
    /**
     * Get render mode based on device and role
     */
    getRenderMode() {
        if (this.deviceType === 'mobile') {
            return this.userRole === 'collector' ? 'minimal' : 'compact';
        } else if (this.deviceType === 'tablet') {
            return 'compact';
        } else {
            return this.userRole === 'collector' ? 'compact' : 'full';
        }
    }
    
    /**
     * Setup role-based UI
     */
    setupRoleBasedUI() {
        // Hide/show elements based on role
        const roleElements = document.querySelectorAll('[data-role]');
        
        roleElements.forEach(element => {
            const allowedRoles = element.dataset.role.split(',');
            const shouldShow = allowedRoles.includes(this.userRole) || allowedRoles.includes('all');
            
            element.style.display = shouldShow ? '' : 'none';
        });
        
        // Setup collector-specific features
        if (this.userRole === 'collector') {
            this.setupCollectorFeatures();
        }
        
        // Setup admin-specific features
        if (['bos', 'unit_head', 'branch_head'].includes(this.userRole)) {
            this.setupAdminFeatures();
        }
    }
    
    /**
     * Setup collector features
     */
    setupCollectorFeatures() {
        // Optimize for field work
        if (this.deviceType === 'mobile') {
            // Enable GPS tracking
            this.enableGPSTracking();
            
            // Enable camera for receipts
            this.enableCameraAccess();
            
            // Setup offline mode
            this.setupOfflineMode();
        }
        
        // Simplify navigation
        this.simplifyNavigation();
        
        // Focus on daily route
        this.focusOnDailyRoute();
    }
    
    /**
     * Setup admin features
     */
    setupAdminFeatures() {
        // Enable advanced features only on desktop
        if (this.deviceType === 'desktop') {
            this.enableAdvancedCharts();
            this.enableBulkOperations();
            this.enableAdvancedFilters();
        }
        
        // Show comprehensive dashboard
        this.showComprehensiveDashboard();
    }
    
    /**
     * Setup performance optimizations
     */
    setupPerformanceOptimizations() {
        const renderMode = this.getRenderMode();
        
        switch (renderMode) {
            case 'minimal':
                this.enableMinimalMode();
                break;
            case 'compact':
                this.enableCompactMode();
                break;
            case 'full':
                this.enableFullMode();
                break;
        }
    }
    
    /**
     * Enable minimal mode (mobile collector)
     */
    enableMinimalMode() {
        // Disable animations
        this.disableAnimations();
        
        // Lazy load images
        this.enableLazyLoading();
        
        // Reduce DOM elements
        this.reduceDOMElements();
        
        // Optimize data loading
        this.optimizeDataLoading();
        
        // Enable aggressive caching
        this.enableAggressiveCaching();
    }
    
    /**
     * Enable compact mode (tablet/mobile non-collector)
     */
    enableCompactMode() {
        // Reduce animations
        this.reduceAnimations();
        
        // Optimize tables
        this.optimizeTables();
        
        // Simplify forms
        this.simplifyForms();
    }
    
    /**
     * Enable full mode (desktop)
     */
    enableFullMode() {
        // Enable all features
        this.enableAllFeatures();
        
        // Load all data
        this.loadAllData();
        
        // Enable animations
        this.enableAnimations();
    }
    
    /**
     * Enable all features for full mode
     */
    enableAllFeatures() {
        // Enable all UI components
        document.body.classList.remove('compact-mode', 'mobile-mode');
        document.body.classList.add('full-mode');
        
        // Enable all charts and graphs
        const charts = document.querySelectorAll('.chart-container');
        charts.forEach(chart => chart.style.display = 'block');
        
        // Enable all advanced features
        const advancedFeatures = document.querySelectorAll('.advanced-feature');
        advancedFeatures.forEach(feature => feature.classList.remove('d-none'));
    }
    
    /**
     * Load all data for full mode
     */
    loadAllData() {
        // Trigger data loading events
        this.emit('loadAllData');
    }
    
    /**
     * Enable animations for full mode
     */
    enableAnimations() {
        // Remove animation restrictions
        const animationStyles = document.querySelector('style[data-animations-restricted]');
        if (animationStyles) {
            animationStyles.remove();
        }
    }
    
    /**
     * Setup PWA features
     */
    setupPWAFeatures() {
        if (this.config.usePWA && this.deviceType === 'mobile') {
            // Register service worker
            this.registerServiceWorker();
            
            // Setup offline support
            this.setupOfflineSupport();
            
            // Enable app-like experience
            this.enableAppLikeExperience();
        }
    }
    
    /**
     * Update UI for current device
     */
    updateUIForDevice() {
        // Update navigation
        this.updateNavigation();
        
        // Update tables
        this.updateTables();
        
        // Update forms
        this.updateForms();
        
        // Update charts
        this.updateCharts();
        
        // Update pagination
        this.updatePagination();
    }
    
    /**
     * Update navigation for device
     */
    updateNavigation() {
        const navbar = document.querySelector('.navbar');
        if (!navbar) return;
        
        if (this.deviceType === 'mobile') {
            // Collapse navbar
            navbar.classList.add('navbar-expand-sm');
            navbar.classList.remove('navbar-expand-lg');
            
            // Simplify menu items
            this.simplifyNavbarItems();
        } else if (this.deviceType === 'tablet') {
            navbar.classList.add('navbar-expand-md');
            navbar.classList.remove('navbar-expand-lg', 'navbar-expand-sm');
        } else {
            // Full navbar
            navbar.classList.add('navbar-expand-lg');
            navbar.classList.remove('navbar-expand-sm', 'navbar-expand-md');
        }
    }
    
    /**
     * Update tables for device
     */
    updateTables() {
        const tables = document.querySelectorAll('.table');
        
        tables.forEach(table => {
            if (this.deviceType === 'mobile') {
                // Convert to card view
                this.convertTableToCards(table);
            } else if (this.deviceType === 'tablet') {
                // Compact table
                this.makeTableCompact(table);
            }
        });
    }
    
    /**
     * Convert table to cards for mobile
     */
    convertTableToCards(table) {
        if (table.dataset.converted === 'true') return;
        
        const container = document.createElement('div');
        container.className = 'table-cards';
        
        const headers = Array.from(table.querySelectorAll('thead th')).map(th => th.textContent.trim());
        const rows = table.querySelectorAll('tbody tr');
        
        rows.forEach(row => {
            const cells = row.querySelectorAll('td');
            const card = document.createElement('div');
            card.className = 'card mb-2';
            
            let cardHTML = '<div class="card-body">';
            
            cells.forEach((cell, index) => {
                if (headers[index]) {
                    cardHTML += `
                        <div class="row mb-1">
                            <div class="col-4 text-muted small">${headers[index]}</div>
                            <div class="col-8">${cell.innerHTML}</div>
                        </div>
                    `;
                }
            });
            
            cardHTML += '</div>';
            card.innerHTML = cardHTML;
            container.appendChild(card);
        });
        
        table.parentNode.replaceChild(container, table);
        table.dataset.converted = 'true';
    }
    
    /**
     * Make table compact for tablet
     */
    makeTableCompact(table) {
        table.classList.add('table-sm');
        
        // Reduce font size
        table.style.fontSize = '0.875rem';
        
        // Reduce padding
        const cells = table.querySelectorAll('th, td');
        cells.forEach(cell => {
            cell.style.padding = '0.5rem';
        });
    }
    
    /**
     * Update forms for device
     */
    updateForms() {
        const forms = document.querySelectorAll('form');
        
        forms.forEach(form => {
            if (this.deviceType === 'mobile') {
                // Stack form elements
                this.stackFormElements(form);
                
                // Use full-width inputs
                this.useFullWidthInputs(form);
                
                // Simplify validation
                this.simplifyValidation(form);
            }
        });
    }
    
    /**
     * Update charts for device
     */
    updateCharts() {
        const charts = document.querySelectorAll('[data-chart]');
        
        charts.forEach(chart => {
            if (this.deviceType === 'mobile') {
                // Simplify chart
                this.simplifyChart(chart);
            }
        });
    }
    
    /**
     * Update pagination for device
     */
    updatePagination() {
        const pagination = document.querySelectorAll('.pagination');
        
        pagination.forEach(pag => {
            if (this.deviceType === 'mobile') {
                // Simplify pagination
                this.simplifyPagination(pag);
            }
        });
    }
    
    /**
     * Simplify pagination for mobile
     */
    simplifyPagination(pagination) {
        const items = pagination.querySelectorAll('.page-item');
        
        // Show only first, prev, current, next, last
        const visibleItems = [];
        
        items.forEach((item, index) => {
            if (index <= 1 || index >= items.length - 2) {
                visibleItems.push(item);
            } else if (item.classList.contains('active')) {
                visibleItems.push(item);
            }
        });
        
        items.forEach(item => {
            if (!visibleItems.includes(item)) {
                item.style.display = 'none';
            }
        });
    }
    
    /**
     * Enable GPS tracking for collectors
     */
    enableGPSTracking() {
        if ('geolocation' in navigator) {
            navigator.geolocation.watchPosition(
                (position) => {
                    // Send location to server
                    this.sendLocationToServer(position);
                },
                (error) => {
                    console.warn('GPS error:', error);
                },
                {
                    enableHighAccuracy: true,
                    timeout: 5000,
                    maximumAge: 60000
                }
            );
        }
    }
    
    /**
     * Enable camera access for collectors
     */
    enableCameraAccess() {
        // Setup camera buttons
        const cameraButtons = document.querySelectorAll('[data-action="camera"]');
        
        cameraButtons.forEach(button => {
            button.addEventListener('click', () => {
                this.openCamera();
            });
        });
    }
    
    /**
     * Open camera
     */
    openCamera() {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = 'image/*';
        input.capture = 'environment';
        
        input.onchange = (event) => {
            const file = event.target.files[0];
            if (file) {
                this.processCameraPhoto(file);
            }
        };
        
        input.click();
    }
    
    /**
     * Process camera photo
     */
    processCameraPhoto(file) {
        // Compress image
        this.compressImage(file, (compressedFile) => {
            // Upload to server
            this.uploadImage(compressedFile);
        });
    }
    
    /**
     * Compress image
     */
    compressImage(file, callback) {
        const reader = new FileReader();
        reader.onload = (event) => {
            const img = new Image();
            img.onload = () => {
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                
                // Resize to max 800px
                let width = img.width;
                let height = img.height;
                const maxSize = 800;
                
                if (width > height) {
                    if (width > maxSize) {
                        height = (height * maxSize) / width;
                        width = maxSize;
                    }
                } else {
                    if (height > maxSize) {
                        width = (width * maxSize) / height;
                        height = maxSize;
                    }
                }
                
                canvas.width = width;
                canvas.height = height;
                
                ctx.drawImage(img, 0, 0, width, height);
                
                canvas.toBlob((blob) => {
                    callback(new File([blob], file.name, {
                        type: 'image/jpeg',
                        lastModified: Date.now()
                    }));
                }, 'image/jpeg', 0.7);
            };
            img.src = event.target.result;
        };
        reader.readAsDataURL(file);
    }
    
    /**
     * Get device-specific data limit
     */
    getDataLimit() {
        return this.config.pagination?.size || 25;
    }
    
    /**
     * Check if should use lazy loading
     */
    shouldUseLazyLoading() {
        return this.deviceType === 'mobile' || this.config.ui?.compactMode;
    }
    
    /**
     * Emit custom event
     */
    emit(eventName, data = {}) {
        document.dispatchEvent(new CustomEvent(`responsiveManager:${eventName}`, {
            detail: data
        }));
    }
    
    /**
     * Reduce animations for performance
     */
    reduceAnimations() {
        // Disable animations for better performance
        const style = document.createElement('style');
        style.textContent = `
            * {
                animation-duration: 0.01ms !important;
                animation-delay: 0.01ms !important;
                transition-duration: 0.01ms !important;
                transition-delay: 0.01ms !important;
            }
        `;
        document.head.appendChild(style);
    }
    
    /**
     * Optimize tables for mobile
     */
    optimizeTables() {
        const tables = document.querySelectorAll('table');
        tables.forEach(table => {
            table.classList.add('table-responsive');
        });
    }
    
    /**
     * Simplify forms for mobile
     */
    simplifyForms() {
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            // Add mobile-friendly classes
            form.classList.add('mobile-form');
        });
    }
}

// Initialize responsive manager
document.addEventListener('DOMContentLoaded', () => {
    window.responsiveManager = new ResponsiveManager();
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ResponsiveManager;
}
