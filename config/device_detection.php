<?php
/**
 * Device Detection dan Role-Based Rendering
 * Aplikasi Koperasi Berjalan
 */

class DeviceDetection {
    private $deviceType;
    private $screenSize;
    private $userRole;
    private $capabilities;
    
    public function __construct($userRole = null) {
        $this->userRole = $userRole ?? $_SESSION['user']['role'] ?? 'guest';
        $this->detectDevice();
        $this->setCapabilities();
    }
    
    /**
     * Deteksi tipe device dan ukuran layar
     */
    private function detectDevice() {
        $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? '';
        
        // Deteksi mobile devices
        $mobileKeywords = [
            'Mobile', 'Android', 'iPhone', 'iPad', 'iPod', 'BlackBerry', 
            'Windows Phone', 'webOS', 'Opera Mini', 'IEMobile'
        ];
        
        $isMobile = false;
        foreach ($mobileKeywords as $keyword) {
            if (stripos($userAgent, $keyword) !== false) {
                $isMobile = true;
                break;
            }
        }
        
        // Deteksi tablet
        $isTablet = false;
        if (stripos($userAgent, 'iPad') !== false || 
            (stripos($userAgent, 'Android') !== false && stripos($userAgent, 'Mobile') === false)) {
            $isTablet = true;
        }
        
        // Tentukan device type
        if ($isTablet) {
            $this->deviceType = 'tablet';
            $this->screenSize = 'medium';
        } elseif ($isMobile) {
            $this->deviceType = 'mobile';
            $this->screenSize = 'small';
        } else {
            $this->deviceType = 'desktop';
            $this->screenSize = 'large';
        }
        
        // Override dengan viewport width jika ada
        if (isset($_GET['viewport_width'])) {
            $viewportWidth = (int)$_GET['viewport_width'];
            if ($viewportWidth < 768) {
                $this->deviceType = 'mobile';
                $this->screenSize = 'small';
            } elseif ($viewportWidth < 1024) {
                $this->deviceType = 'tablet';
                $this->screenSize = 'medium';
            } else {
                $this->deviceType = 'desktop';
                $this->screenSize = 'large';
            }
        }
    }
    
    /**
     * Set capabilities berdasarkan device dan role
     */
    private function setCapabilities() {
        $this->capabilities = [
            'max_data_rows' => $this->getMaxDataRows(),
            'use_pwa' => $this->shouldUsePWA(),
            'enable_animations' => $this->shouldEnableAnimations(),
            'load_images' => $this->shouldLoadImages(),
            'use_advanced_features' => $this->shouldUseAdvancedFeatures(),
            'render_mode' => $this->getRenderMode(),
            'cache_strategy' => $this->getCacheStrategy()
        ];
    }
    
    /**
     * Maksimal data rows per device
     */
    private function getMaxDataRows() {
        switch ($this->deviceType) {
            case 'mobile':
                return $this->isCollector() ? 50 : 25;
            case 'tablet':
                return $this->isCollector() ? 100 : 50;
            case 'desktop':
                return $this->isAdmin() ? 200 : 100;
            default:
                return 25;
        }
    }
    
    /**
     * Apakah harus menggunakan PWA
     */
    private function shouldUsePWA() {
        return $this->deviceType === 'mobile' && $this->isCollector();
    }
    
    /**
     * Apakah enable animations
     */
    private function shouldEnableAnimations() {
        return $this->deviceType === 'desktop' || ($this->deviceType === 'tablet' && !$this->isCollector());
    }
    
    /**
     * Apakah load images
     */
    private function shouldLoadImages() {
        if ($this->deviceType === 'mobile' && $this->isCollector()) {
            return false; // Hemat data untuk kolektor
        }
        return true;
    }
    
    /**
     * Apakah gunakan fitur advanced
     */
    private function shouldUseAdvancedFeatures() {
        return $this->deviceType === 'desktop' && $this->isAdmin();
    }
    
    /**
     * Render mode yang digunakan
     */
    private function getRenderMode() {
        if ($this->deviceType === 'mobile') {
            return 'minimal';
        } elseif ($this->deviceType === 'tablet') {
            return 'compact';
        } else {
            return 'full';
        }
    }
    
    /**
     * Cache strategy
     */
    private function getCacheStrategy() {
        if ($this->isCollector()) {
            return 'aggressive'; // Cache agresif untuk offline
        } elseif ($this->deviceType === 'mobile') {
            return 'moderate';
        } else {
            return 'minimal';
        }
    }
    
    /**
     * Check apakah user adalah collector
     */
    private function isCollector() {
        return $this->userRole === 'collector';
    }
    
    /**
     * Check apakah user adalah admin
     */
    private function isAdmin() {
        return in_array($this->userRole, ['bos', 'unit_head', 'branch_head']);
    }
    
    /**
     * Get device type
     */
    public function getDeviceType() {
        return $this->deviceType;
    }
    
    /**
     * Get screen size
     */
    public function getScreenSize() {
        return $this->screenSize;
    }
    
    /**
     * Get user role
     */
    public function getUserRole() {
        return $this->userRole;
    }
    
    /**
     * Get capabilities
     */
    public function getCapabilities() {
        return $this->capabilities;
    }
    
    /**
     * Get specific capability
     */
    public function getCapability($capability) {
        return $this->capabilities[$capability] ?? null;
    }
    
    /**
     * Generate device-specific CSS classes
     */
    public function getDeviceClasses() {
        return [
            'device-' . $this->deviceType,
            'screen-' . $this->screenSize,
            'role-' . $this->userRole,
            'render-' . $this->getRenderMode()
        ];
    }
    
    /**
     * Get appropriate template path
     */
    public function getTemplatePath($page) {
        $baseTemplate = $this->isCollector() ? 'mobile/' : 'web/';
        
        // Special cases for different devices
        if ($this->deviceType === 'mobile' && $this->isCollector()) {
            return 'mobile/' . $page . '.php';
        } elseif ($this->deviceType === 'tablet') {
            return 'tablet/' . $page . '.php';
        } else {
            return 'web/' . $page . '.php';
        }
    }
    
    /**
     * Get data limit for queries
     */
    public function getDataLimit() {
        return $this->getCapability('max_data_rows');
    }
    
    /**
     * Check if should use AJAX for loading
     */
    public function shouldUseAjax() {
        return $this->deviceType !== 'mobile' || !$this->isCollector();
    }
    
    /**
     * Get pagination size
     */
    public function getPaginationSize() {
        switch ($this->deviceType) {
            case 'mobile':
                return 5;
            case 'tablet':
                return 10;
            case 'desktop':
                return $this->isAdmin() ? 25 : 20;
            default:
                return 10;
        }
    }
    
    /**
     * Generate JSON config for frontend
     */
    public function getFrontendConfig() {
        return [
            'deviceType' => $this->deviceType,
            'screenSize' => $this->screenSize,
            'userRole' => $this->userRole,
            'capabilities' => $this->capabilities,
            'pagination' => [
                'size' => $this->getPaginationSize(),
                'useAjax' => $this->shouldUseAjax()
            ],
            'ui' => [
                'compactMode' => $this->deviceType === 'mobile',
                'showImages' => $this->shouldLoadImages(),
                'enableAnimations' => $this->shouldEnableAnimations(),
                'usePWA' => $this->shouldUsePWA()
            ]
        ];
    }
}

// Global instance
$deviceDetection = new DeviceDetection();

// Helper functions
function isMobile() {
    global $deviceDetection;
    return $deviceDetection->getDeviceType() === 'mobile';
}

function isTablet() {
    global $deviceDetection;
    return $deviceDetection->getDeviceType() === 'tablet';
}

function isDesktop() {
    global $deviceDetection;
    return $deviceDetection->getDeviceType() === 'desktop';
}

function isCollector() {
    global $deviceDetection;
    return $deviceDetection->getUserRole() === 'collector';
}

function isAdmin() {
    global $deviceDetection;
    return in_array($deviceDetection->getUserRole(), ['bos', 'unit_head', 'branch_head']);
}

function getDeviceCapability($capability) {
    global $deviceDetection;
    return $deviceDetection->getCapability($capability);
}

function getDeviceClasses() {
    global $deviceDetection;
    return implode(' ', $deviceDetection->getDeviceClasses());
}

function getTemplatePath($page) {
    global $deviceDetection;
    return $deviceDetection->getTemplatePath($page);
}

function getDataLimit() {
    global $deviceDetection;
    return $deviceDetection->getDataLimit();
}

function getPaginationSize() {
    global $deviceDetection;
    return $deviceDetection->getPaginationSize();
}
?>
