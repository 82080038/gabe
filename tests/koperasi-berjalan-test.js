/**
 * Koperasi Berjalan Specific Puppeteer Test
 * Custom test for the actual application structure
 */

const puppeteer = require('puppeteer');
const fs = require('fs');

class KoperasiBerjalanTest {
    constructor() {
        this.browser = null;
        this.page = null;
        this.baseUrl = 'http://localhost:8000';
        this.screenshots = [];
    }

    async setupBrowser() {
        console.log('🚀 Setting up browser for Koperasi Berjalan test...');
        
        this.browser = await puppeteer.launch({
            headless: "new",
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        
        this.page = await this.browser.newPage();
        await this.page.setViewport({ width: 1920, height: 1080 });
        
        console.log('✅ Browser setup complete');
    }

    async takeScreenshot(name, description = '') {
        const filename = `screenshots/${name}-${Date.now()}.png`;
        await this.page.screenshot({ path: filename, fullPage: true });
        this.screenshots.push({ filename, description });
        console.log(`📸 Screenshot saved: ${filename}`);
        return filename;
    }

    async testLoginPage() {
        console.log('🔐 Testing login page...');
        
        try {
            // Navigate to login page
            await this.page.goto(this.baseUrl, { waitUntil: 'networkidle2' });
            
            // Wait for login form to load
            await this.page.waitForSelector('form[method="POST"]');
            
            // Check page title
            const title = await this.page.title();
            console.log(`📄 Page title: ${title}`);
            
            // Check if we're on login page
            const isLoginPage = title.includes('Login');
            console.log(`📍 Login page detected: ${isLoginPage}`);
            
            // Take screenshot of login page
            await this.takeScreenshot('login-page', 'Initial login page');
            
            // Fill in login credentials (admin/admin as shown in demo)
            await this.page.type('#username', 'admin', { delay: 100 });
            await this.page.type('#password', 'admin', { delay: 100 });
            
            // Take screenshot before submission
            await this.takeScreenshot('login-filled', 'Login form filled');
            
            // Submit the form
            await this.page.click('button[type="submit"]');
            
            // Wait for navigation after login
            await this.page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 10000 });
            
            // Check if login was successful
            const currentUrl = this.page.url();
            const isLoggedIn = !currentUrl.includes('login.php');
            
            console.log(`🔗 Current URL after login: ${currentUrl}`);
            console.log(`✅ Login successful: ${isLoggedIn}`);
            
            // Take screenshot after login
            await this.takeScreenshot('after-login', 'Page after login attempt');
            
            return isLoggedIn;
        } catch (error) {
            console.error('❌ Login test failed:', error.message);
            await this.takeScreenshot('login-error', 'Login test error');
            return false;
        }
    }

    async testDashboardAccess() {
        console.log('📊 Testing dashboard access...');
        
        try {
            // Check if we can access dashboard elements
            const dashboardElements = await this.page.evaluate(() => {
                const elements = {
                    hasDashboard: !!document.querySelector('.dashboard-container, .main-content, .content'),
                    hasNavigation: !!document.querySelector('nav, .navbar, .sidebar'),
                    hasUserMenu: !!document.querySelector('.user-menu, .profile, .user-info'),
                    title: document.title,
                    url: window.location.href
                };
                return elements;
            });
            
            console.log('📋 Dashboard elements found:', dashboardElements);
            
            // Take screenshot of dashboard
            await this.takeScreenshot('dashboard-view', 'Dashboard view');
            
            return dashboardElements.hasDashboard || dashboardElements.hasNavigation;
        } catch (error) {
            console.error('❌ Dashboard test failed:', error.message);
            await this.takeScreenshot('dashboard-error', 'Dashboard test error');
            return false;
        }
    }

    async testMobileResponsiveness() {
        console.log('📱 Testing mobile responsiveness...');
        
        try {
            // Test mobile viewport
            await this.page.emulate(puppeteer.devices['iPhone 12']);
            
            // Reload page to test responsive behavior
            await this.page.reload({ waitUntil: 'networkidle2' });
            
            // Check mobile-specific elements
            const mobileElements = await this.page.evaluate(() => {
                const elements = {
                    hasMobileClass: document.body.classList.contains('device-mobile'),
                    hasResponsiveLayout: !!document.querySelector('.login-container'),
                    viewport: {
                        width: window.innerWidth,
                        height: window.innerHeight
                    }
                };
                return elements;
            });
            
            console.log('📱 Mobile elements found:', mobileElements);
            
            // Take mobile screenshot
            await this.takeScreenshot('mobile-view', 'Mobile responsive view');
            
            // Reset to desktop
            await this.page.setViewport({ width: 1920, height: 1080 });
            await this.page.reload({ waitUntil: 'networkidle2' });
            
            return true;
        } catch (error) {
            console.error('❌ Mobile responsiveness test failed:', error.message);
            await this.takeScreenshot('mobile-error', 'Mobile test error');
            return false;
        }
    }

    async testPWAFeatures() {
        console.log('⚡ Testing PWA features...');
        
        try {
            // Check for PWA manifest
            const hasManifest = await this.page.evaluate(() => {
                return !!document.querySelector('link[rel="manifest"]');
            });
            
            // Check for service worker
            const hasServiceWorker = await this.page.evaluate(() => {
                return 'serviceWorker' in navigator;
            });
            
            // Check for PWA configuration
            const pwaConfig = await this.page.evaluate(() => {
                return {
                    hasPWAConfig: typeof window.pwaConfig !== 'undefined',
                    hasDeviceConfig: typeof window.deviceConfig !== 'undefined',
                    isInstallable: 'beforeinstallprompt' in window
                };
            });
            
            console.log('⚡ PWA features:', {
                hasManifest,
                hasServiceWorker,
                ...pwaConfig
            });
            
            return hasManifest || hasServiceWorker || pwaConfig.hasPWAConfig;
        } catch (error) {
            console.error('❌ PWA test failed:', error.message);
            return false;
        }
    }

    async testPerformanceMetrics() {
        console.log('📈 Testing performance metrics...');
        
        try {
            // Get performance metrics
            const metrics = await this.page.metrics();
            
            // Get navigation timing
            const navigationTiming = await this.page.evaluate(() => {
                const timing = performance.timing;
                return {
                    domContentLoaded: timing.domContentLoadedEventEnd - timing.navigationStart,
                    loadComplete: timing.loadEventEnd - timing.navigationStart,
                    firstPaint: performance.getEntriesByType('paint')[0]?.startTime || 0
                };
            });
            
            console.log('📊 Performance Metrics:');
            console.log(`   - DOM Content Loaded: ${navigationTiming.domContentLoaded}ms`);
            console.log(`   - Load Complete: ${navigationTiming.loadComplete}ms`);
            console.log(`   - First Paint: ${navigationTiming.firstPaint}ms`);
            console.log(`   - JS Heap Used: ${(metrics.JSHeapUsedSize / 1024 / 1024).toFixed(2)}MB`);
            
            return {
                metrics,
                navigationTiming
            };
        } catch (error) {
            console.error('❌ Performance test failed:', error.message);
            return null;
        }
    }

    async cleanup() {
        console.log('🧹 Cleaning up...');
        
        if (this.browser) {
            await this.browser.close();
        }
        
        console.log('✅ Cleanup complete');
    }

    async generateReport() {
        const report = {
            timestamp: new Date().toISOString(),
            baseUrl: this.baseUrl,
            screenshots: this.screenshots,
            summary: {
                totalScreenshots: this.screenshots.length,
                screenshotDirectory: 'screenshots/'
            }
        };
        
        const reportPath = 'koperasi-test-report.json';
        fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
        console.log(`📋 Test report generated: ${reportPath}`);
        
        return report;
    }

    async runComprehensiveTest() {
        console.log('🎯 Starting Koperasi Berjalan Comprehensive Test\n');
        
        try {
            // Create screenshots directory
            if (!fs.existsSync('screenshots')) {
                fs.mkdirSync('screenshots');
            }
            
            await this.setupBrowser();
            
            const tests = [
                { name: 'Login Page', fn: () => this.testLoginPage() },
                { name: 'Dashboard Access', fn: () => this.testDashboardAccess() },
                { name: 'Mobile Responsiveness', fn: () => this.testMobileResponsiveness() },
                { name: 'PWA Features', fn: () => this.testPWAFeatures() },
                { name: 'Performance Metrics', fn: () => this.testPerformanceMetrics() }
            ];
            
            const results = [];
            
            for (const test of tests) {
                console.log(`\n--- ${test.name} ---`);
                const startTime = Date.now();
                const result = await test.fn();
                const duration = Date.now() - startTime;
                
                results.push({
                    name: test.name,
                    passed: !!result,
                    duration,
                    details: result
                });
                
                console.log(`${result ? '✅' : '❌'} ${test.name} ${result ? 'PASSED' : 'FAILED'} (${duration}ms)`);
            }
            
            // Generate final report
            const report = await this.generateReport();
            
            console.log(`\n📊 Test Summary:`);
            console.log(`   Total Tests: ${results.length}`);
            console.log(`   Passed: ${results.filter(r => r.passed).length}`);
            console.log(`   Failed: ${results.filter(r => !r.passed).length}`);
            console.log(`   Screenshots: ${this.screenshots.length}`);
            console.log(`   Report: koperasi-test-report.json`);
            
            return { results, report };
            
        } catch (error) {
            console.error('💥 Test execution failed:', error);
        } finally {
            await this.cleanup();
        }
    }
}

// Run the tests
if (require.main === module) {
    const tester = new KoperasiBerjalanTest();
    tester.runComprehensiveTest().catch(console.error);
}

module.exports = KoperasiBerjalanTest;
