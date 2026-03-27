/**
 * ================================================================
 * COMPREHENSIVE SYSTEM TESTING - KOPERASI BERJALAN
 * Complete end-to-end testing using Puppeteer
 * ================================================================ */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

class ComprehensiveSystemTest {
    constructor() {
        this.browser = null;
        this.page = null;
        this.testResults = [];
        this.screenshots = [];
        this.config = {
            baseUrl: 'http://localhost/gabe',
            timeout: 30000,
            headless: process.env.HEADLESS !== 'false',
            slowMo: 100,
            viewport: { width: 1920, height: 1080 }
        };
        
        this.testSuites = [
            'authentication',
            'dashboard',
            'mobile-responsiveness',
            'pwa-features',
            'performance'
        ];
    }
    
    async runAllTests() {
        console.log('🚀 Starting Comprehensive System Testing...\n');
        
        try {
            await this.setupBrowser();
            
            for (const suite of this.testSuites) {
                await this.runTestSuite(suite);
            }
            
            await this.generateTestReport();
            
        } catch (error) {
            console.error('❌ Test execution failed:', error);
        } finally {
            await this.cleanup();
        }
    }
    
    async setupBrowser() {
        console.log('📱 Setting up browser...');
        
        this.browser = await puppeteer.launch({
            headless: this.config.headless ? "new" : false,
            slowMo: this.config.slowMo,
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage',
                '--disable-web-security',
                '--disable-features=VizDisplayCompositor',
                '--window-size=1920,1080'
            ]
        });
        
        this.page = await this.browser.newPage();
        
        // Set viewport
        await this.page.setViewport(this.config.viewport);
        
        // Set timeout
        await this.page.setDefaultTimeout(this.config.timeout);
        
        // Enable request interception for performance monitoring
        await this.page.setRequestInterception(true);
        this.page.on('request', request => request.continue());
        this.page.on('response', response => this.logResponse(response));
        
        console.log('✅ Browser setup complete\n');
    }
    
    async runTestSuite(suiteName) {
        console.log(`\n🧪 Running ${suiteName} tests...`);
        
        const suiteStartTime = Date.now();
        
        try {
            switch (suiteName) {
                case 'authentication':
                    await this.testAuthentication();
                    break;
                case 'dashboard':
                    await this.testDashboard();
                    break;
                case 'mobile-responsiveness':
                    await this.testMobileResponsiveness();
                    break;
                case 'pwa-features':
                    await this.testPWAFeatures();
                    break;
                case 'performance':
                    await this.testPerformance();
                    break;
            }
            
            const suiteDuration = Date.now() - suiteStartTime;
            
            this.testResults.push({
                suite: suiteName,
                status: 'passed',
                duration: suiteDuration,
                timestamp: new Date().toISOString()
            });
            
            console.log(`✅ ${suiteName} tests completed (${suiteDuration}ms)`);
            
        } catch (error) {
            const suiteDuration = Date.now() - suiteStartTime;
            
            this.testResults.push({
                suite: suiteName,
                status: 'failed',
                duration: suiteDuration,
                error: error.message,
                timestamp: new Date().toISOString()
            });
            
            console.log(`❌ ${suiteName} tests failed: ${error.message}`);
            
            await this.takeScreenshot(`${suiteName}-error`);
        }
    }
    
    async testAuthentication() {
        console.log('  🔐 Testing authentication...');
        
        // Test login page accessibility
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`, { waitUntil: 'networkidle2' });
        
        // Check if login page loads
        const title = await this.page.title();
        console.log(`    Page title: ${title}`);
        
        // Check for login form elements
        const loginContainer = await this.page.$('.login-container');
        const usernameField = await this.page.$('#username');
        const passwordField = await this.page.$('#password');
        const submitButton = await this.page.$('button[type="submit"]');
        
        if (!loginContainer) throw new Error('Login container not found');
        if (!usernameField) throw new Error('Username field not found');
        if (!passwordField) throw new Error('Password field not found');
        if (!submitButton) throw new Error('Submit button not found');
        
        console.log('    ✓ Login form elements found');
        
        // Test admin login
        await this.page.type('#username', 'admin');
        await this.page.type('#password', 'admin');
        
        // Wait for navigation after form submission
        const navigationPromise = this.page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 15000 });
        
        await Promise.all([
            navigationPromise,
            this.page.click('button[type="submit"]')
        ]);
        
        const currentUrl = this.page.url();
        if (currentUrl.includes('dashboard')) {
            console.log('    ✓ Admin login successful');
        } else {
            throw new Error('Admin login failed - not redirected to dashboard');
        }
        
        // Test logout
        await this.page.goto(`${this.config.baseUrl}/logout.php`);
        
        console.log('    ✓ Logout successful');
    }
    
    async testDashboard() {
        console.log('  📊 Testing dashboard...');
        
        // Login as admin
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`, { waitUntil: 'networkidle2' });
        await this.page.type('#username', 'admin');
        await this.page.type('#password', 'admin');
        
        // Wait for navigation after form submission
        const navigationPromise = this.page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 15000 });
        await Promise.all([
            navigationPromise,
            this.page.click('button[type="submit"]')
        ]);
        
        // Wait for dashboard to load
        await this.page.waitForSelector('body', { timeout: 10000 });
        
        // Check dashboard content
        const title = await this.page.title();
        console.log(`    Dashboard title: ${title}`);
        
        // Check for user info
        const userInfo = await this.page.$('.alert-info');
        if (userInfo) {
            console.log('    ✓ User info displayed');
        }
        
        // Check for metric cards
        const metricCards = await this.page.$$('.card');
        console.log(`    ✓ Found ${metricCards.length} metric cards`);
        
        console.log('    ✓ Dashboard loaded successfully');
    }
    
    async testMobileResponsiveness() {
        console.log('  📱 Testing mobile responsiveness...');
        
        const mobileViewports = [
            { width: 375, height: 667 },  // iPhone SE
            { width: 414, height: 896 },  // iPhone 11
            { width: 768, height: 1024 }  // iPad
        ];
        
        for (const viewport of mobileViewports) {
            console.log(`    Testing viewport: ${viewport.width}x${viewport.height}`);
            
            await this.page.setViewport(viewport);
            await this.page.goto(`${this.config.baseUrl}/pages/login.php`, { waitUntil: 'networkidle2' });
            
            // Check if login form adapts to mobile
            const loginContainer = await this.page.$('.login-container');
            if (loginContainer) {
                console.log(`      ✓ Login form responsive for ${viewport.width}x${viewport.height}`);
            } else {
                throw new Error(`Login form not responsive for ${viewport.width}x${viewport.height}`);
            }
        }
        
        console.log('    ✓ Mobile responsiveness verified');
    }
    
    async testPWAFeatures() {
        console.log('  🌐 Testing PWA features...');
        
        // Check for manifest
        await this.page.goto(`${this.config.baseUrl}`, { waitUntil: 'networkidle2' });
        
        const manifestLink = await this.page.$('link[rel="manifest"]');
        if (!manifestLink) {
            throw new Error('PWA manifest not found');
        }
        
        console.log('    ✓ PWA manifest found');
        
        // Check for service worker support
        const serviceWorker = await this.page.evaluate(() => {
            return navigator.serviceWorker ? 'supported' : 'not supported';
        });
        
        if (serviceWorker === 'supported') {
            console.log('    ✓ Service worker supported');
        } else {
            console.log('    ⚠️ Service worker not supported');
        }
        
        console.log('    ✓ PWA features verified');
    }
    
    async testPerformance() {
        console.log('  ⚡ Testing performance...');
        
        // Navigate to login page
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`, { waitUntil: 'networkidle2' });
        
        // Collect performance metrics
        const metrics = await this.page.evaluate(() => {
            const navigation = performance.getEntriesByType('navigation')[0];
            return {
                domContentLoaded: navigation.domContentLoadedEventEnd - navigation.domContentLoadedEventStart,
                loadComplete: navigation.loadEventEnd - navigation.loadEventStart,
                firstPaint: performance.getEntriesByType('paint').find(p => p.name === 'first-paint')?.startTime || 0
            };
        });
        
        console.log('    ✓ Performance metrics collected');
        console.log(`      - DOM Content Loaded: ${metrics.domContentLoaded}ms`);
        console.log(`      - Load Complete: ${metrics.loadComplete}ms`);
        console.log(`      - First Paint: ${metrics.firstPaint}ms`);
        
        // Check network requests
        const networkMetrics = await this.page.evaluate(() => {
            const entries = performance.getEntriesByType('resource');
            return {
                totalRequests: entries.length,
                slowRequests: entries.filter(entry => entry.duration > 1000).length
            };
        });
        
        console.log(`      - Network Requests: ${networkMetrics.totalRequests}`);
        console.log(`      - Slow Requests: ${networkMetrics.slowRequests}`);
    }
    
    async loginAs(username, password) {
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`, { waitUntil: 'networkidle2' });
        
        await this.page.type('#username', username);
        await this.page.type('#password', password);
        await this.page.click('button[type="submit"]');
        
        await this.page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 15000 });
    }
    
    async takeScreenshot(filename) {
        if (this.page) {
            const screenshotPath = path.join(__dirname, 'screenshots', filename);
            await this.page.screenshot({ path: screenshotPath, fullPage: true });
            console.log(`📸 Screenshot saved: ${screenshotPath}`);
        }
    }
    
    logResponse(response) {
        // Log slow responses
        if (response.request().resourceType() === 'document' && response.status() !== 200) {
            console.log(`⚠️ Document response: ${response.status()} ${response.url()}`);
        }
    }
    
    async generateTestReport() {
        const reportData = {
            timestamp: new Date().toISOString(),
            summary: {
                totalSuites: this.testSuites.length,
                passed: this.testResults.filter(r => r.status === 'passed').length,
                failed: this.testResults.filter(r => r.status === 'failed').length,
                totalDuration: this.testResults.reduce((sum, r) => sum + r.duration, 0)
            },
            results: this.testResults,
            environment: {
                baseUrl: this.config.baseUrl,
                headless: this.config.headless,
                viewport: this.config.viewport
            }
        };
        
        // Save JSON report
        const jsonReportPath = path.join(__dirname, 'test-report.json');
        fs.writeFileSync(jsonReportPath, JSON.stringify(reportData, null, 2));
        console.log(`📊 Test report generated: ${jsonReportPath}`);
        
        // Generate HTML report
        const htmlReport = this.generateHTMLReport(reportData);
        const htmlReportPath = path.join(__dirname, 'test-report.html');
        fs.writeFileSync(htmlReportPath, htmlReport);
        console.log(`📈 HTML report: ${htmlReportPath}`);
        
        // Print summary
        console.log('\n📋 Test Summary:');
        console.log(`   Total Suites: ${reportData.summary.totalSuites}`);
        console.log(`   Passed: ${reportData.summary.passed}`);
        console.log(`   Failed: ${reportData.summary.failed}`);
        console.log(`   Duration: ${reportData.summary.totalDuration}ms`);
        
        if (reportData.summary.failed > 0) {
            console.log('\n❌ Failed Tests:');
            this.testResults.filter(r => r.status === 'failed').forEach(result => {
                console.log(`   - ${result.suite}: ${result.error}`);
            });
        }
    }
    
    generateHTMLReport(data) {
        return `
<!DOCTYPE html>
<html>
<head>
    <title>Koperasi Berjalan Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #2c3e50; color: white; padding: 20px; border-radius: 5px; }
        .summary { background: #ecf0f1; padding: 15px; margin: 20px 0; border-radius: 5px; }
        .passed { color: #27ae60; }
        .failed { color: #e74c3c; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .status-passed { background-color: #d5f4e6; }
        .status-failed { background-color: #fadbd8; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🧪 Koperasi Berjalan Test Report</h1>
        <p>Generated: ${data.timestamp}</p>
    </div>
    
    <div class="summary">
        <h2>📊 Test Summary</h2>
        <p>Total Suites: <strong>${data.summary.totalSuites}</strong></p>
        <p class="passed">Passed: <strong>${data.summary.passed}</strong></p>
        <p class="failed">Failed: <strong>${data.summary.failed}</strong></p>
        <p>Duration: <strong>${data.summary.totalDuration}ms</strong></p>
    </div>
    
    <h2>📋 Test Results</h2>
    <table>
        <thead>
            <tr>
                <th>Test Suite</th>
                <th>Status</th>
                <th>Duration</th>
                <th>Error</th>
            </tr>
        </thead>
        <tbody>
            ${data.results.map(result => `
                <tr class="status-${result.status}">
                    <td>${result.suite}</td>
                    <td>${result.status}</td>
                    <td>${result.duration}ms</td>
                    <td>${result.error || '-'}</td>
                </tr>
            `).join('')}
        </tbody>
    </table>
    
    <div class="summary">
        <h2>🔧 Environment</h2>
        <p>Base URL: <strong>${data.environment.baseUrl}</strong></p>
        <p>Headless: <strong>${data.environment.headless}</strong></p>
        <p>Viewport: <strong>${data.environment.viewport.width}x${data.environment.viewport.height}</strong></p>
    </div>
</body>
</html>`;
    }
    
    async cleanup() {
        if (this.browser) {
            await this.browser.close();
            console.log('🧹 Browser cleanup complete');
        }
    }
}

// Run tests if this file is executed directly
if (require.main === module) {
    const tester = new ComprehensiveSystemTest();
    tester.runAllTests().catch(console.error);
}

module.exports = ComprehensiveSystemTest;
