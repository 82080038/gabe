/**
 * ================================================================
 * RESPONSIVE ENHANCED - KOPERASI BERJALAN
 * Advanced responsive design system with complete mobile optimization
 * ================================================================ */

class ResponsiveEnhanced {
    constructor() {
        this.init();
        this.setupAdvancedFeatures();
        this.setupBreakpointManager();
        this.setupOrientationHandler();
        this.setupDeviceDetection();
        this.setupPerformanceMonitoring();
    }
    
    init() {
        this.state = {
            currentBreakpoint: this.getCurrentBreakpoint(),
            orientation: this.getOrientation(),
            deviceType: this.getDeviceType(),
            pixelRatio: this.getPixelRatio(),
            touchSupport: this.getTouchSupport(),
            connectionType: this.getConnectionType(),
            memoryInfo: this.getMemoryInfo()
        };
        
        this.setupEventListeners();
        this.applyResponsiveClasses();
        this.setupViewportOptimization();
    }
    
    setupAdvancedFeatures() {
        // Setup container queries polyfill
        this.setupContainerQueries();
        
        // Setup picture element optimization
        this.setupPictureOptimization();
        
        // Setup responsive typography
        this.setupResponsiveTypography();
        
        // Setup responsive images
        this.setupResponsiveImages();
        
        // Setup responsive videos
        this.setupResponsiveVideos();
    }
    
    setupBreakpointManager() {
        this.breakpoints = {
            xs: 0,
            sm: 576,
            md: 768,
            lg: 992,
            xl: 1200,
            xxl: 1400
        };
        
        this.breakpointNames = Object.keys(this.breakpoints);
        
        // Create resize observer for efficient breakpoint detection
        this.resizeObserver = new ResizeObserver(entries => {
            this.handleResize(entries[0]);
        });
        
        // Observe body for size changes
        this.resizeObserver.observe(document.body);
        
        // Setup media query listeners
        this.setupMediaQueryListeners();
    }
    
    setupOrientationHandler() {
        // Handle orientation change
        window.addEventListener('orientationchange', () => {
            this.handleOrientationChange();
        });
        
        // Handle screen orientation API
        if (screen.orientation) {
            screen.orientation.addEventListener('change', () => {
                this.handleOrientationChange();
            });
        }
        
        // Initial orientation setup
        this.applyOrientationClasses();
    }
    
    setupDeviceDetection() {
        this.deviceInfo = {
            type: this.getDeviceType(),
            os: this.getOperatingSystem(),
            browser: this.getBrowser(),
            version: this.getBrowserVersion(),
            isMobile: this.isMobile(),
            isTablet: this.isTablet(),
            isDesktop: this.isDesktop(),
            isTouch: this.isTouchDevice(),
            isRetina: this.isRetinaDisplay(),
            pixelRatio: window.devicePixelRatio || 1,
            screenWidth: window.screen.width,
            screenHeight: window.screen.height,
            colorDepth: screen.colorDepth,
            colorGamut: screen.colorGamut
        };
        
        this.applyDeviceClasses();
        this.setupDeviceSpecificOptimizations();
    }
    
    setupPerformanceMonitoring() {
        this.performanceMetrics = {
            fps: 0,
            loadTime: 0,
            renderTime: 0,
            memoryUsage: 0,
            networkSpeed: 0
        };
        
        this.setupFPSMonitoring();
        this.setupMemoryMonitoring();
        this.setupNetworkMonitoring();
        this.setupPerformanceReporting();
    }
    
    setupEventListeners() {
        // Window resize with debouncing
        let resizeTimeout;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(() => {
                this.handleResize();
            }, 100);
        });
        
        // Device orientation
        window.addEventListener('deviceorientation', (event) => {
            this.handleDeviceOrientation(event);
        });
        
        // Connection change
        if (navigator.connection) {
            navigator.connection.addEventListener('change', () => {
                this.handleConnectionChange();
            });
        }
        
        // Visibility change
        document.addEventListener('visibilitychange', () => {
            this.handleVisibilityChange();
        });
        
        // Online/offline status
        window.addEventListener('online', () => this.handleOnlineStatus(true));
        window.addEventListener('offline', () => this.handleOnlineStatus(false));
    }
    
    getCurrentBreakpoint() {
        const width = window.innerWidth;
        
        for (let i = this.breakpointNames.length - 1; i >= 0; i--) {
            const name = this.breakpointNames[i];
            if (width >= this.breakpoints[name]) {
                return name;
            }
        }
        
        return 'xs';
    }
    
    getOrientation() {
        if (screen.orientation) {
            return screen.orientation.type;
        }
        
        // Fallback for older browsers
        return window.innerHeight > window.innerWidth ? 'portrait' : 'landscape';
    }
    
    getDeviceType() {
        const width = window.innerWidth;
        
        if (width < 576) return 'mobile';
        if (width < 768) return 'tablet';
        if (width < 992) return 'small-desktop';
        if (width < 1200) return 'desktop';
        return 'large-desktop';
    }
    
    getPixelRatio() {
        return window.devicePixelRatio || 1;
    }
    
    getTouchSupport() {
        return 'ontouchstart' in window || navigator.maxTouchPoints > 0;
    }
    
    getConnectionType() {
        if (navigator.connection) {
            return navigator.connection.effectiveType || 'unknown';
        }
        return 'unknown';
    }
    
    getMemoryInfo() {
        if (navigator.deviceMemory) {
            return {
                deviceMemory: navigator.deviceMemory,
                totalJSHeapSize: performance.memory?.totalJSHeapSize || 0,
                usedJSHeapSize: performance.memory?.usedJSHeapSize || 0
            };
        }
        return null;
    }
    
    getOperatingSystem() {
        const userAgent = navigator.userAgent.toLowerCase();
        
        if (userAgent.includes('android')) return 'android';
        if (userAgent.includes('ios')) return 'ios';
        if (userAgent.includes('windows')) return 'windows';
        if (userAgent.includes('mac')) return 'macos';
        if (userAgent.includes('linux')) return 'linux';
        
        return 'unknown';
    }
    
    getBrowser() {
        const userAgent = navigator.userAgent.toLowerCase();
        
        if (userAgent.includes('chrome')) return 'chrome';
        if (userAgent.includes('firefox')) return 'firefox';
        if (userAgent.includes('safari')) return 'safari';
        if (userAgent.includes('edge')) return 'edge';
        if (userAgent.includes('opera')) return 'opera';
        
        return 'unknown';
    }
    
    getBrowserVersion() {
        const userAgent = navigator.userAgent;
        const browser = this.getBrowser();
        
        let version = 'unknown';
        
        switch (browser) {
            case 'chrome':
                version = userAgent.match(/chrome\/(\d+)/)?.[1] || 'unknown';
                break;
            case 'firefox':
                version = userAgent.match(/firefox\/(\d+)/)?.[1] || 'unknown';
                break;
            case 'safari':
                version = userAgent.match(/version\/(\d+)/)?.[1] || 'unknown';
                break;
            case 'edge':
                version = userAgent.match(/edge\/(\d+)/)?.[1] || 'unknown';
                break;
            case 'opera':
                version = userAgent.match(/opera\/(\d+)/)?.[1] || 'unknown';
                break;
        }
        
        return version;
    }
    
    isMobile() {
        return this.deviceInfo.type === 'mobile';
    }
    
    isTablet() {
        return this.deviceInfo.type === 'tablet';
    }
    
    isDesktop() {
        return this.deviceInfo.type === 'desktop' || 
               this.deviceInfo.type === 'small-desktop' || 
               this.deviceInfo.type === 'large-desktop';
    }
    
    isTouchDevice() {
        return this.deviceInfo.isTouch;
    }
    
    isRetinaDisplay() {
        return this.deviceInfo.pixelRatio > 1;
    }
    
    handleResize(entries) {
        const { width, height } = entries.contentRect;
        const newBreakpoint = this.getCurrentBreakpoint();
        const newOrientation = width > height ? 'landscape' : 'portrait';
        
        // Update state
        this.state.currentBreakpoint = newBreakpoint;
        this.state.orientation = newOrientation;
        
        // Apply changes
        this.applyResponsiveClasses();
        this.applyOrientationClasses();
        
        // Emit events
        this.emitResponsiveEvent('resize', {
            width,
            height,
            breakpoint: newBreakpoint,
            orientation: newOrientation
        });
        
        // Update layout
        this.updateLayout();
    }
    
    handleOrientationChange() {
        const newOrientation = this.getOrientation();
        
        if (this.state.orientation !== newOrientation) {
            this.state.orientation = newOrientation;
            this.applyOrientationClasses();
            
            this.emitResponsiveEvent('orientationchange', {
                orientation: newOrientation
            });
            
            // Handle orientation-specific layouts
            this.handleOrientationLayout(newOrientation);
        }
    }
    
    handleDeviceOrientation(event) {
        if (event.alpha !== null && event.beta !== null && event.gamma !== null) {
            this.emitResponsiveEvent('deviceorientation', {
                alpha: event.alpha,
                beta: event.beta,
                gamma: event.gamma
            });
            
            // Handle device-specific features
            this.handleDeviceOrientationFeatures(event);
        }
    }
    
    handleConnectionChange() {
        const newConnectionType = this.getConnectionType();
        
        this.emitResponsiveEvent('connectionchange', {
            connectionType: newConnectionType,
            downlink: navigator.connection.downlink,
            rtt: navigator.connection.rtt,
            saveData: navigator.connection.saveData
        });
        
        // Adjust content based on connection
        this.adjustContentForConnection(newConnectionType);
    }
    
    handleVisibilityChange() {
        const isVisible = !document.hidden;
        
        this.emitResponsiveEvent('visibilitychange', {
            visible: isVisible
        });
        
        // Pause/resume animations based on visibility
        this.toggleAnimations(isVisible);
    }
    
    handleOnlineStatus(isOnline) {
        this.emitResponsiveEvent('connectivitychange', {
            online: isOnline
        });
        
        // Handle offline/online states
        this.handleOfflineState(!isOnline);
    }
    
    applyResponsiveClasses() {
        const body = document.body;
        const html = document.documentElement;
        
        // Remove all breakpoint classes
        this.breakpointNames.forEach(bp => {
            body.classList.remove(`breakpoint-${bp}`);
            html.classList.remove(`breakpoint-${bp}`);
        });
        
        // Add current breakpoint class
        const currentBreakpoint = this.state.currentBreakpoint;
        body.classList.add(`breakpoint-${currentBreakpoint}`);
        html.classList.add(`breakpoint-${currentBreakpoint}`);
        
        // Add device type classes
        body.classList.remove('device-mobile', 'device-tablet', 'device-desktop');
        body.classList.add(`device-${this.deviceInfo.type}`);
        
        // Add feature classes
        body.classList.toggle('touch-enabled', this.deviceInfo.isTouch);
        body.classList.toggle('retina-display', this.deviceInfo.isRetina);
        body.classList.toggle('high-density', this.deviceInfo.pixelRatio >= 2);
    }
    
    applyOrientationClasses() {
        const body = document.body;
        
        body.classList.remove('orientation-portrait', 'orientation-landscape');
        body.classList.add(`orientation-${this.state.orientation}`);
    }
    
    setupContainerQueries() {
        // Polyfill for container queries
        if (!CSS.supports('container', 'width')) {
            this.containerQueryPolyfill();
        }
    }
    
    containerQueryPolyfill() {
        // Simple container query polyfill
        const containers = document.querySelectorAll('[data-container]');
        
        containers.forEach(container => {
            const observer = new ResizeObserver(entries => {
                const { width } = entries[0].contentRect;
                
                // Apply container-based classes
                if (width < 576) {
                    container.classList.add('container-xs');
                    container.classList.remove('container-sm', 'container-md', 'container-lg', 'container-xl');
                } else if (width < 768) {
                    container.classList.add('container-sm');
                    container.classList.remove('container-xs', 'container-md', 'container-lg', 'container-xl');
                } else if (width < 992) {
                    container.classList.add('container-md');
                    container.classList.remove('container-xs', 'container-sm', 'container-lg', 'container-xl');
                } else if (width < 1200) {
                    container.classList.add('container-lg');
                    container.classList.remove('container-xs', 'container-sm', 'container-md', 'container-xl');
                } else {
                    container.classList.add('container-xl');
                    container.classList.remove('container-xs', 'container-sm', 'container-md', 'container-lg');
                }
            });
            
            observer.observe(container);
        });
    }
    
    setupPictureOptimization() {
        // Optimize picture elements for responsive loading
        const pictures = document.querySelectorAll('picture');
        
        pictures.forEach(picture => {
            this.optimizePicture(picture);
        });
    }
    
    optimizePicture(picture) {
        const sources = picture.querySelectorAll('source');
        const img = picture.querySelector('img');
        
        if (!img) return;
        
        // Setup responsive image loading
        const updateSource = () => {
            const width = window.innerWidth;
            
            sources.forEach(source => {
                const mediaQuery = source.media;
                
                if (!mediaQuery || window.matchMedia(mediaQuery).matches) {
                    img.src = source.srcset;
                    return;
                }
            });
        };
        
        // Initial update
        updateSource();
        
        // Update on resize
        window.addEventListener('resize', updateSource);
    }
    
    setupResponsiveTypography() {
        // Setup fluid typography
        this.setupFluidTypography();
        
        // Setup responsive font sizes
        this.setupResponsiveFontSizes();
        
        // Setup line height optimization
        this.setupLineHeightOptimization();
    }
    
    setupFluidTypography() {
        // Implement fluid typography using clamp()
        const root = document.documentElement;
        
        // Set CSS custom properties for fluid typography
        const fluidTypography = {
            'font-size-fluid': 'clamp(1rem, 2.5vw, 1.25rem)',
            'line-height-fluid': 'clamp(1.4, 1.5, 1.6)',
            'letter-spacing-fluid': 'clamp(-0.025em, 0.1vw, 0.025em)'
        };
        
        Object.entries(fluidTypography).forEach(([property, value]) => {
            root.style.setProperty(`--${property}`, value);
        });
    }
    
    setupResponsiveFontSizes() {
        // Adjust font sizes based on screen size
        const adjustFontSize = () => {
            const breakpoint = this.getCurrentBreakpoint();
            const root = document.documentElement;
            
            const fontSizes = {
                xs: '14px',
                sm: '15px',
                md: '16px',
                lg: '16px',
                xl: '17px',
                xxl: '18px'
            };
            
            root.style.setProperty('--font-size-base', fontSizes[breakpoint]);
        };
        
        adjustFontSize();
        window.addEventListener('resize', adjustFontSize);
    }
    
    setupLineHeightOptimization() {
        // Optimize line height for reading
        const optimizeLineHeight = () => {
            const breakpoint = this.getCurrentBreakpoint();
            const root = document.documentElement;
            
            const lineHeights = {
                xs: '1.5',
                sm: '1.5',
                md: '1.6',
                lg: '1.6',
                xl: '1.65',
                xxl: '1.7'
            };
            
            root.style.setProperty('--line-height-base', lineHeights[breakpoint]);
        };
        
        optimizeLineHeight();
        window.addEventListener('resize', optimizeLineHeight);
    }
    
    setupResponsiveImages() {
        // Setup lazy loading for images
        this.setupLazyLoading();
        
        // Setup responsive image loading
        this.setupResponsiveImageLoading();
        
        // Setup image optimization
        this.setupImageOptimization();
    }
    
    setupLazyLoading() {
        // Implement lazy loading for images
        const images = document.querySelectorAll('img[data-src]');
        
        const imageObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.remove('lazy');
                    imageObserver.unobserve(img);
                }
            });
        });
        
        images.forEach(img => {
            img.classList.add('lazy');
            imageObserver.observe(img);
        });
    }
    
    setupResponsiveImageLoading() {
        // Load appropriate image sizes based on device
        const images = document.querySelectorAll('img[data-srcset]');
        
        images.forEach(img => {
            const updateImageSrc = () => {
                const width = window.innerWidth;
                const pixelRatio = this.deviceInfo.pixelRatio;
                
                // Select appropriate image size
                let srcset = img.dataset.srcset;
                
                if (this.deviceInfo.isRetina) {
                    srcset = img.dataset.srcsetRetina || srcset;
                }
                
                img.srcset = srcset;
            };
            
            updateImageSrc();
            window.addEventListener('resize', updateImageSrc);
        });
    }
    
    setupImageOptimization() {
        // Optimize image loading and rendering
        const images = document.querySelectorAll('img');
        
        images.forEach(img => {
            // Add loading attribute
            if (!img.loading) {
                img.loading = 'lazy';
            }
            
            // Add decoding attribute
            if (!img.decoding) {
                img.decoding = 'async';
            }
            
            // Add fetchpriority for important images
            if (img.classList.contains('priority')) {
                img.fetchpriority = 'high';
            }
        });
    }
    
    setupResponsiveVideos() {
        // Setup responsive video loading
        const videos = document.querySelectorAll('video');
        
        videos.forEach(video => {
            this.optimizeVideo(video);
        });
    }
    
    optimizeVideo(video) {
        // Setup video optimization
        video.loading = 'lazy';
        video.playsInline = true;
        video.muted = true;
        video.autoplay = false;
        
        // Setup poster image
        if (!video.poster && video.dataset.poster) {
            video.poster = video.dataset.poster;
        }
    }
    
    setupMediaQueryListeners() {
        // Create media query listeners for different breakpoints
        Object.entries(this.breakpoints).forEach(([name, width]) => {
            const mediaQuery = window.matchMedia(`(min-width: ${width}px)`);
            
            mediaQuery.addListener((matches) => {
                if (matches) {
                    this.handleBreakpointChange(name);
                }
            });
        });
    }
    
    handleBreakpointChange(breakpoint) {
        this.emitResponsiveEvent('breakpointchange', {
            breakpoint,
            width: window.innerWidth,
            height: window.innerHeight
        });
        
        // Apply breakpoint-specific optimizations
        this.applyBreakpointOptimizations(breakpoint);
    }
    
    applyBreakpointOptimizations(breakpoint) {
        // Apply optimizations for specific breakpoints
        switch (breakpoint) {
            case 'xs':
                this.applyMobileOptimizations();
                break;
            case 'sm':
                this.applySmallTabletOptimizations();
                break;
            case 'md':
                this.applyTabletOptimizations();
                break;
            case 'lg':
                this.applyDesktopOptimizations();
                break;
            case 'xl':
                this.applyLargeDesktopOptimizations();
                break;
            case 'xxl':
                this.applyExtraLargeDesktopOptimizations();
                break;
        }
    }
    
    applyMobileOptimizations() {
        // Mobile-specific optimizations
        document.body.classList.add('mobile-optimized');
        
        // Reduce animations for better performance
        this.reduceAnimations(true);
        
        // Optimize touch interactions
        this.optimizeTouchInteractions();
        
        // Reduce image quality for faster loading
        this.reduceImageQuality();
    }
    
    applySmallTabletOptimizations() {
        document.body.classList.add('small-tablet-optimized');
        this.reduceAnimations(false);
    }
    
    applyTabletOptimizations() {
        document.body.classList.add('tablet-optimized');
        this.reduceAnimations(false);
    }
    
    applyDesktopOptimizations() {
        document.body.classList.add('desktop-optimized');
        this.reduceAnimations(false);
        this.enableAdvancedFeatures();
    }
    
    applyLargeDesktopOptimizations() {
        document.body.classList.add('large-desktop-optimized');
        this.enableAdvancedFeatures();
        this.enableHighResolutionFeatures();
    }
    
    applyExtraLargeDesktopOptimizations() {
        document.body.classList.add('extra-large-desktop-optimized');
        this.enableAdvancedFeatures();
        this.enableHighResolutionFeatures();
        this.enableUltraHDFeatures();
    }
    
    reduceAnimations(reduce) {
        const style = document.createElement('style');
        style.textContent = reduce ? 
            '* { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; }' : 
            '';
        
        if (reduce) {
            document.head.appendChild(style);
            this.animationReductionStyle = style;
        } else if (this.animationReductionStyle) {
            document.head.removeChild(this.animationReductionStyle);
        }
    }
    
    optimizeTouchInteractions() {
        // Optimize for touch interactions
        document.body.classList.add('touch-optimized');
        
        // Increase touch targets
        const touchTargets = document.querySelectorAll('.btn, .nav-link, .form-control');
        touchTargets.forEach(target => {
            target.classList.add('touch-target');
        });
    }
    
    reduceImageQuality() {
        // Reduce image quality for faster loading on mobile
        const images = document.querySelectorAll('img');
        images.forEach(img => {
            if (img.dataset.lowQuality) {
                img.src = img.dataset.lowQuality;
            }
        });
    }
    
    enableAdvancedFeatures() {
        // Enable advanced features for desktop
        document.body.classList.add('advanced-features');
    }
    
    enableHighResolutionFeatures() {
        // Enable high resolution features
        document.body.classList.add('high-resolution');
    }
    
    enableUltraHDFeatures() {
        // Enable ultra HD features
        document.body.classList.add('ultra-hd');
    }
    
    setupDeviceSpecificOptimizations() {
        // Apply device-specific optimizations
        if (this.deviceInfo.os === 'ios') {
            this.applyIOSOptimizations();
        } else if (this.deviceInfo.os === 'android') {
            this.applyAndroidOptimizations();
        } else if (this.deviceInfo.os === 'windows') {
            this.applyWindowsOptimizations();
        }
    }
    
    applyIOSOptimizations() {
        // iOS-specific optimizations
        document.body.classList.add('ios-optimized');
        
        // Handle safe area
        this.setupSafeArea();
        
        // Handle iOS scroll behavior
        this.setupIOSScroll();
    }
    
    applyAndroidOptimizations() {
        // Android-specific optimizations
        document.body.classList.add('android-optimized');
        
        // Handle Android scroll behavior
        this.setupAndroidScroll();
    }
    
    applyWindowsOptimizations() {
        // Windows-specific optimizations
        document.body.classList.add('windows-optimized');
        
        // Handle Windows scroll behavior
        this.setupWindowsScroll();
    }
    
    setupSafeArea() {
        // Setup safe area for iOS devices
        const root = document.documentElement;
        
        root.style.setProperty('--safe-area-inset-top', 'env(safe-area-inset-top)');
        root.style.setProperty('--safe-area-inset-right', 'env(safe-area-inset-right)');
        root.style.setProperty('--safe-area-inset-bottom', 'env(safe-area-inset-bottom)');
        root.style.setProperty('--safe-area-inset-left', 'env(safe-area-inset-left)');
    }
    
    setupIOSScroll() {
        // Setup iOS scroll behavior
        document.body.style.webkitOverflowScrolling = 'touch';
    }
    
    setupAndroidScroll() {
        // Setup Android scroll behavior
        document.body.style.overflowScrolling = 'touch';
    }
    
    setupWindowsScroll() {
        // Setup Windows scroll behavior
        document.body.style.scrollBehavior = 'smooth';
    }
    
    setupViewportOptimization() {
        // Optimize viewport meta tag
        const viewport = document.querySelector('meta[name="viewport"]');
        
        if (viewport) {
            let content = viewport.content;
            
            // Add device-specific optimizations
            if (this.deviceInfo.isMobile) {
                content += ', width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            } else {
                content += ', width=device-width, initial-scale=1.0';
            }
            
            // Add high DPI support
            if (this.deviceInfo.isRetina) {
                content += ', target-densitydpi=device-dpi';
            }
            
            viewport.content = content;
        }
    }
    
    setupFPSMonitoring() {
        let lastTime = performance.now();
        let frameCount = 0;
        
        const measureFPS = (currentTime) => {
            frameCount++;
            
            if (currentTime - lastTime >= 1000) {
                this.performanceMetrics.fps = frameCount;
                frameCount = 0;
                lastTime = currentTime;
                
                this.emitResponsiveEvent('fpsupdate', {
                    fps: this.performanceMetrics.fps
                });
            }
            
            requestAnimationFrame(measureFPS);
        };
        
        requestAnimationFrame(measureFPS);
    }
    
    setupMemoryMonitoring() {
        // Monitor memory usage
        if (performance.memory) {
            const checkMemory = () => {
                this.performanceMetrics.memoryUsage = performance.memory.usedJSHeapSize;
                
                this.emitResponsiveEvent('memoryupdate', {
                    used: performance.memory.usedJSHeapSize,
                    total: performance.memory.totalJSHeapSize,
                    limit: performance.memory.jsHeapSizeLimit
                });
            };
            
            setInterval(checkMemory, 5000);
        }
    }
    
    setupNetworkMonitoring() {
        // Monitor network performance
        if (navigator.connection) {
            const checkNetwork = () => {
                this.performanceMetrics.networkSpeed = navigator.connection.downlink;
                
                this.emitResponsiveEvent('networkupdate', {
                    downlink: navigator.connection.downlink,
                    rtt: navigator.connection.rtt,
                    effectiveType: navigator.connection.effectiveType,
                    saveData: navigator.connection.saveData
                });
            };
            
            checkNetwork();
            navigator.connection.addEventListener('change', checkNetwork);
        }
    }
    
    setupPerformanceReporting() {
        // Report performance metrics
        setInterval(() => {
            this.emitResponsiveEvent('performancereport', {
                ...this.performanceMetrics,
                breakpoint: this.state.currentBreakpoint,
                deviceType: this.deviceInfo.type,
                orientation: this.state.orientation
            });
        }, 10000);
    }
    
    handleOrientationLayout(orientation) {
        // Handle orientation-specific layouts
        if (orientation === 'landscape') {
            document.body.classList.add('landscape-layout');
            document.body.classList.remove('portrait-layout');
        } else {
            document.body.classList.add('portrait-layout');
            document.body.classList.remove('landscape-layout');
        }
    }
    
    handleDeviceOrientationFeatures(event) {
        // Handle device orientation features
        if (Math.abs(event.gamma) > 30) {
            // Device is tilted significantly
            document.body.classList.add('device-tilted');
        } else {
            document.body.classList.remove('device-tilted');
        }
    }
    
    adjustContentForConnection(connectionType) {
        // Adjust content based on connection type
        switch (connectionType) {
            case 'slow-2g':
            case '2g':
                this.applyLowBandwidthOptimizations();
                break;
            case '3g':
                this.applyMediumBandwidthOptimizations();
                break;
            case '4g':
                this.applyHighBandwidthOptimizations();
                break;
        }
    }
    
    applyLowBandwidthOptimizations() {
        // Apply optimizations for slow connections
        document.body.classList.add('low-bandwidth');
        this.reduceImageQuality();
        this.reduceAnimations(true);
    }
    
    applyMediumBandwidthOptimizations() {
        document.body.classList.add('medium-bandwidth');
        this.reduceAnimations(false);
    }
    
    applyHighBandwidthOptimizations() {
        document.body.classList.add('high-bandwidth');
        this.enableAdvancedFeatures();
    }
    
    toggleAnimations(isVisible) {
        // Toggle animations based on visibility
        const animations = document.querySelectorAll('[data-animate]');
        
        animations.forEach(element => {
            if (isVisible) {
                element.classList.remove('animation-paused');
            } else {
                element.classList.add('animation-paused');
            }
        });
    }
    
    handleOfflineState(isOffline) {
        // Handle offline state
        if (isOffline) {
            document.body.classList.add('offline-mode');
            this.showOfflineIndicator();
        } else {
            document.body.classList.remove('offline-mode');
            this.hideOfflineIndicator();
        }
    }
    
    showOfflineIndicator() {
        // Show offline indicator
        let indicator = document.getElementById('offline-indicator');
        
        if (!indicator) {
            indicator = document.createElement('div');
            indicator.id = 'offline-indicator';
            indicator.className = 'offline-indicator';
            indicator.innerHTML = `
                <div class="offline-content">
                    <i class="fas fa-wifi-slash"></i>
                    <span>Offline Mode</span>
                </div>
            `;
            
            document.body.appendChild(indicator);
        }
    }
    
    hideOfflineIndicator() {
        const indicator = document.getElementById('offline-indicator');
        if (indicator) {
            indicator.remove();
        }
    }
    
    updateLayout() {
        // Update layout based on current state
        this.updateGridLayout();
        this.updateNavigation();
        this.updateComponents();
    }
    
    updateGridLayout() {
        // Update grid layout
        const grids = document.querySelectorAll('[data-grid]');
        
        grids.forEach(grid => {
            const columns = grid.dataset.grid;
            const breakpoint = this.state.currentBreakpoint;
            
            // Apply responsive grid classes
            grid.classList.remove('grid-1', 'grid-2', 'grid-3', 'grid-4', 'grid-5', 'grid-6');
            grid.classList.add(`grid-${columns}`);
        });
    }
    
    updateNavigation() {
        // Update navigation based on device type
        const navigation = document.querySelector('[data-navigation]');
        
        if (navigation) {
            if (this.deviceInfo.isMobile) {
                navigation.classList.add('mobile-nav');
                navigation.classList.remove('desktop-nav');
            } else {
                navigation.classList.add('desktop-nav');
                navigation.classList.remove('mobile-nav');
            }
        }
    }
    
    updateComponents() {
        // Update components based on responsive state
        const components = document.querySelectorAll('[data-responsive]');
        
        components.forEach(component => {
            const type = component.dataset.responsive;
            
            switch (type) {
                case 'card':
                    this.updateResponsiveCard(component);
                    break;
                case 'table':
                    this.updateResponsiveTable(component);
                    break;
                case 'form':
                    this.updateResponsiveForm(component);
                    break;
                case 'chart':
                    this.updateResponsiveChart(component);
                    break;
            }
        });
    }
    
    updateResponsiveCard(card) {
        // Update card for responsive display
        if (this.deviceInfo.isMobile) {
            card.classList.add('card-mobile');
            card.classList.remove('card-desktop');
        } else {
            card.classList.add('card-desktop');
            card.classList.remove('card-mobile');
        }
    }
    
    updateResponsiveTable(table) {
        // Update table for responsive display
        if (this.deviceInfo.isMobile) {
            table.classList.add('table-mobile');
            table.classList.remove('table-desktop');
        } else {
            table.classList.add('table-desktop');
            table.classList.remove('table-mobile');
        }
    }
    
    updateResponsiveForm(form) {
        // Update form for responsive display
        if (this.deviceInfo.isMobile) {
            form.classList.add('form-mobile');
            form.classList.remove('form-desktop');
        } else {
            form.classList.add('form-desktop');
            form.classList.remove('form-mobile');
        }
    }
    
    updateResponsiveChart(chart) {
        // Update chart for responsive display
        if (this.deviceInfo.isMobile) {
            chart.classList.add('chart-mobile');
            chart.classList.remove('chart-desktop');
        } else {
            chart.classList.add('chart-desktop');
            chart.classList.remove('chart-mobile');
        }
    }
    
    emitResponsiveEvent(eventName, data) {
        // Emit custom responsive events
        const event = new CustomEvent(`responsive:${eventName}`, {
            detail: data
        });
        
        document.dispatchEvent(event);
    }
    
    // Public API methods
    getCurrentState() {
        return { ...this.state };
    }
    
    getDeviceInfo() {
        return { ...this.deviceInfo };
    }
    
    getPerformanceMetrics() {
        return { ...this.performanceMetrics };
    }
    
    on(eventName, callback) {
        document.addEventListener(`responsive:${eventName}`, callback);
    }
    
    off(eventName, callback) {
        document.removeEventListener(`responsive:${eventName}`, callback);
    }
    
    forceUpdate() {
        // Force update responsive state
        this.handleResize({
            contentRect: {
                width: window.innerWidth,
                height: window.innerHeight
            }
        });
    }
    
    destroy() {
        // Clean up event listeners
        this.resizeObserver.disconnect();
        
        // Remove classes
        document.body.className = '';
        
        // Remove styles
        if (this.animationReductionStyle) {
            document.head.removeChild(this.animationReductionStyle);
        }
    }
}

// Initialize responsive enhanced when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.responsiveEnhanced = new ResponsiveEnhanced();
    
    // Make it globally available
    window.ResponsiveEnhanced = ResponsiveEnhanced;
});

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ResponsiveEnhanced;
}
