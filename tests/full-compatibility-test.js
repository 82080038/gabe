/**
 * ================================================================
 * FULL COMPATIBILITY TESTING - KOPERASI BERJALAN
 * Comprehensive testing of ALL pages and components
 * ================================================================ */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

class FullCompatibilityTest {
    constructor() {
        this.browser = null;
        this.page = null;
        this.testResults = [];
        this.config = {
            baseUrl: 'http://localhost/gabe',
            timeout: 30000,
            headless: process.env.HEADLESS !== 'false',
            slowMo: 100
        };
        
        // All pages to test
        this.allPages = [
            { path: '/pages/login.php', name: 'Login Page', requiresAuth: false },
            { path: '/pages/quick_login.php', name: 'Quick Login Demo', requiresAuth: false },
            { path: '/pages/web/dashboard.php', name: 'Web Dashboard', requiresAuth: true },
            { path: '/pages/mobile/dashboard.php', name: 'Mobile Dashboard', requiresAuth: true },
            { path: '/pages/profile.php', name: 'Profile Page', requiresAuth: true },
            { path: '/pages/settings.php', name: 'Settings Page', requiresAuth: true },
            { path: '/pages/member/portal.php', name: 'Member Portal', requiresAuth: true },
            { path: '/pages/mobile/collector_route.php', name: 'Collector Route', requiresAuth: true },
            { path: '/pages/responsive-demo.php', name: 'Responsive Demo', requiresAuth: false },
            { path: '/', name: 'Index/Root', requiresAuth: false }
        ];
        
        this.viewports = [
            { name: 'Desktop', width: 1920, height: 1080 },
            { name: 'Tablet', width: 768, height: 1024 },
            { name: 'Mobile', width: 375, height: 667 }
        ];
    }
    
    async runFullCompatibilityTest() {
        console.log('🌐 Starting Full Compatibility Testing...\n');
        
        try {
            await this.setupBrowser();
            
            // Test all pages on all viewports
            for (const viewport of this.viewports) {
                console.log(`\n📱 Testing on ${viewport.name} (${viewport.width}x${viewport.height})...`);
                await this.page.setViewport(viewport);
                
                for (const pageInfo of this.allPages) {
                    await this.testPage(pageInfo, viewport);
                }
            }
            
            await this.generateCompatibilityReport();
            
        } catch (error) {
            console.error('❌ Full compatibility test failed:', error);
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
                '--window-size=1920,1080'
            ]
        });
        
        this.page = await this.browser.newPage();
        await this.page.setDefaultTimeout(this.config.timeout);
        
        console.log('✅ Browser setup complete\n');
    }
    
    async loginAsAdmin() {
        console.log('🔐 Logging in as admin...');
        
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`, { waitUntil: 'networkidle2' });
        await this.page.type('#username', 'admin');
        await this.page.type('#password', 'admin');
        
        const navigationPromise = this.page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 15000 });
        await Promise.all([
            navigationPromise,
            this.page.click('button[type="submit"]')
        ]);
        
        console.log('✅ Admin login successful');
    }
    
    async testPage(pageInfo, viewport) {
        const testName = `${pageInfo.name} - ${viewport.name}`;
        console.log(`  🧪 Testing ${testName}...`);
        
        const startTime = Date.now();
        
        try {
            // Login if required and not logged in
            if (pageInfo.requiresAuth) {
                const currentUrl = this.page.url();
                if (!currentUrl.includes('dashboard')) {
                    await this.loginAsAdmin();
                }
            }
            
            // Navigate to page
            const response = await this.page.goto(`${this.config.baseUrl}${pageInfo.path}`, { 
                waitUntil: 'networkidle2', 
                timeout: 15000 
            });
            
            // Check HTTP status
            const status = response.status();
            if (status !== 200) {
                throw new Error(`HTTP ${status} - ${response.statusText()}`);
            }
            
            // Check page title
            const title = await this.page.title();
            if (!title || title === '') {
                throw new Error('No page title found');
            }
            
            // Check for fatal PHP errors
            const pageContent = await this.page.content();
            if (pageContent.includes('Fatal error') || pageContent.includes('Parse error')) {
                throw new Error('PHP error detected in page content');
            }
            
            // Check for common page elements
            const checks = await this.performPageChecks(pageInfo);
            
            // Check responsive layout
            const layoutCheck = await this.checkResponsiveLayout(viewport);
            
            // Check JavaScript errors
            const jsErrors = await this.checkJSErrors();
            
            const duration = Date.now() - startTime;
            
            this.testResults.push({
                test: testName,
                page: pageInfo.name,
                viewport: viewport.name,
                status: 'passed',
                duration: duration,
                title: title,
                checks: checks,
                layout: layoutCheck,
                jsErrors: jsErrors,
                timestamp: new Date().toISOString()
            });
            
            console.log(`    ✅ ${testName} - PASSED (${duration}ms)`);
            
        } catch (error) {
            const duration = Date.now() - startTime;
            
            this.testResults.push({
                test: testName,
                page: pageInfo.name,
                viewport: viewport.name,
                status: 'failed',
                duration: duration,
                error: error.message,
                timestamp: new Date().toISOString()
            });
            
            console.log(`    ❌ ${testName} - FAILED: ${error.message}`);
            
            // Take screenshot on failure
            await this.takeScreenshot(`${pageInfo.name.replace(/\s+/g, '_')}_${viewport.name}_error`);
        }
    }
    
    async performPageChecks(pageInfo) {
        const checks = {
            hasTitle: false,
            hasBody: false,
            hasMainContent: false,
            hasNavigation: false,
            hasFooter: false,
            specificElements: []
        };
        
        // Basic structure checks
        checks.hasTitle = await this.page.$('title') !== null;
        checks.hasBody = await this.page.$('body') !== null;
        checks.hasMainContent = await this.page.$('.container, .container-fluid, main, .main') !== null;
        checks.hasNavigation = await this.page.$('nav, .navbar, .navigation') !== null;
        checks.hasFooter = await this.page.$('footer, .footer') !== null;
        
        // Page-specific checks
        switch (pageInfo.path) {
            case '/pages/login.php':
                checks.specificElements.push({
                    name: 'Login Form',
                    found: await this.page.$('.login-container') !== null
                });
                checks.specificElements.push({
                    name: 'Username Field',
                    found: await this.page.$('#username') !== null
                });
                checks.specificElements.push({
                    name: 'Password Field', 
                    found: await this.page.$('#password') !== null
                });
                break;
                
            case '/pages/web/dashboard.php':
            case '/pages/mobile/dashboard.php':
                checks.specificElements.push({
                    name: 'Dashboard Content',
                    found: await this.page.$('.container-fluid') !== null
                });
                checks.specificElements.push({
                    name: 'Metric Cards',
                    found: (await this.page.$$('.card')).length > 0
                });
                break;
                
            case '/pages/quick_login.php':
                checks.specificElements.push({
                    name: 'Quick Login Cards',
                    found: (await this.page.$$('.card')).length > 0
                });
                break;
        }
        
        return checks;
    }
    
    async checkResponsiveLayout(viewport) {
        const layout = {
            viewportOverflow: false,
            elementOverlap: false,
            contentVisible: true,
            navigationAccessible: true
        };
        
        // Check for viewport overflow
        const bodyOverflow = await this.page.evaluate(() => {
            return document.body.scrollWidth > window.innerWidth || 
                   document.body.scrollHeight > window.innerHeight;
        });
        layout.viewportOverflow = bodyOverflow;
        
        // Check if navigation is accessible
        const navVisible = await this.page.$('nav, .navbar') !== null;
        layout.navigationAccessible = navVisible;
        
        // Check if main content is visible
        const mainContent = await this.page.$('.container, .container-fluid, main') !== null;
        layout.contentVisible = mainContent;
        
        return layout;
    }
    
    async checkJSErrors() {
        const errors = [];
        
        // Listen for console errors
        this.page.on('console', msg => {
            if (msg.type() === 'error') {
                errors.push({
                    type: 'console',
                    message: msg.text(),
                    location: msg.location()
                });
            }
        });
        
        // Check for JavaScript errors in page
        const jsErrors = await this.page.evaluate(() => {
            const errors = [];
            
            // Check for jQuery errors
            if (typeof $ !== 'undefined') {
                try {
                    $('body'); // Test jQuery
                } catch (e) {
                    errors.push(`jQuery error: ${e.message}`);
                }
            }
            
            // Check for Bootstrap errors
            if (typeof bootstrap !== 'undefined') {
                try {
                    bootstrap.Tooltip.getInstance(document.body);
                } catch (e) {
                    errors.push(`Bootstrap error: ${e.message}`);
                }
            }
            
            return errors;
        });
        
        return errors.concat(jsErrors);
    }
    
    async takeScreenshot(filename) {
        if (this.page) {
            const screenshotPath = path.join(__dirname, 'screenshots', `${filename}.png`);
            await this.page.screenshot({ path: screenshotPath, fullPage: true });
            console.log(`      📸 Screenshot saved: ${screenshotPath}`);
        }
    }
    
    async generateCompatibilityReport() {
        const summary = {
            totalTests: this.testResults.length,
            passed: this.testResults.filter(r => r.status === 'passed').length,
            failed: this.testResults.filter(r => r.status === 'failed').length,
            totalDuration: this.testResults.reduce((sum, r) => sum + r.duration, 0)
        };
        
        const reportData = {
            timestamp: new Date().toISOString(),
            summary: summary,
            results: this.testResults,
            pagesTested: this.allPages.length,
            viewportsTested: this.viewports.length,
            environment: {
                baseUrl: this.config.baseUrl,
                headless: this.config.headless
            }
        };
        
        // Save JSON report
        const jsonReportPath = path.join(__dirname, 'compatibility-report.json');
        fs.writeFileSync(jsonReportPath, JSON.stringify(reportData, null, 2));
        
        // Generate HTML report
        const htmlReport = this.generateCompatibilityHTML(reportData);
        const htmlReportPath = path.join(__dirname, 'compatibility-report.html');
        fs.writeFileSync(htmlReportPath, htmlReport);
        
        // Print summary
        console.log('\n📊 Full Compatibility Test Summary:');
        console.log(`   Total Tests: ${summary.totalTests}`);
        console.log(`   Passed: ${summary.passed} (${((summary.passed/summary.totalTests)*100).toFixed(1)}%)`);
        console.log(`   Failed: ${summary.failed} (${((summary.failed/summary.totalTests)*100).toFixed(1)}%)`);
        console.log(`   Duration: ${summary.totalDuration}ms`);
        console.log(`   Pages Tested: ${this.allPages.length}`);
        console.log(`   Viewports Tested: ${this.viewports.length}`);
        
        if (summary.failed > 0) {
            console.log('\n❌ Failed Tests:');
            this.testResults.filter(r => r.status === 'failed').forEach(result => {
                console.log(`   - ${result.test}: ${result.error}`);
            });
        }
        
        console.log(`\n📄 Reports generated:`);
        console.log(`   JSON: ${jsonReportPath}`);
        console.log(`   HTML: ${htmlReportPath}`);
    }
    
    generateCompatibilityHTML(data) {
        const passedTests = data.results.filter(r => r.status === 'passed');
        const failedTests = data.results.filter(r => r.status === 'failed');
        
        return `
<!DOCTYPE html>
<html lang="id">
<head>
    <title>Full Compatibility Test Report - Koperasi Berjalan</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .header { background: #2c3e50; color: white; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .summary { background: white; padding: 20px; border-radius: 5px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .passed { color: #27ae60; font-weight: bold; }
        .failed { color: #e74c3c; font-weight: bold; }
        .progress-bar { width: 100%; height: 20px; background: #ecf0f1; border-radius: 10px; overflow: hidden; margin: 10px 0; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #27ae60, #2ecc71); transition: width 0.3s ease; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; background: white; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #34495e; color: white; font-weight: bold; }
        .status-passed { background-color: #d5f4e6; }
        .status-failed { background-color: #fadbd8; }
        .viewport-section { margin: 30px 0; }
        .viewport-title { background: #3498db; color: white; padding: 10px; border-radius: 5px; margin-bottom: 10px; }
        .metric { display: inline-block; margin: 10px 20px 10px 0; }
        .metric-value { font-size: 24px; font-weight: bold; color: #2c3e50; }
        .metric-label { font-size: 12px; color: #7f8c8d; text-transform: uppercase; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🌐 Full Compatibility Test Report</h1>
        <p>Koperasi Berjalan Application - Complete Page & Component Testing</p>
        <p>Generated: ${data.timestamp}</p>
    </div>
    
    <div class="summary">
        <h2>📊 Test Summary</h2>
        <div class="metric">
            <div class="metric-value">${data.summary.totalTests}</div>
            <div class="metric-label">Total Tests</div>
        </div>
        <div class="metric">
            <div class="metric-value passed">${data.summary.passed}</div>
            <div class="metric-label">Passed</div>
        </div>
        <div class="metric">
            <div class="metric-value failed">${data.summary.failed}</div>
            <div class="metric-label">Failed</div>
        </div>
        <div class="metric">
            <div class="metric-value">${((data.summary.passed/data.summary.totalTests)*100).toFixed(1)}%</div>
            <div class="metric-label">Success Rate</div>
        </div>
        
        <div class="progress-bar">
            <div class="progress-fill" style="width: ${(data.summary.passed/data.summary.totalTests)*100}%;"></div>
        </div>
        
        <p><strong>Duration:</strong> ${data.summary.totalDuration}ms | 
           <strong>Pages:</strong> ${data.pagesTested} | 
           <strong>Viewports:</strong> ${data.viewportsTested}</p>
    </div>
    
    <h2>📋 Detailed Results</h2>
    <table>
        <thead>
            <tr>
                <th>Page</th>
                <th>Viewport</th>
                <th>Status</th>
                <th>Duration</th>
                <th>Title</th>
                <th>Issues</th>
            </tr>
        </thead>
        <tbody>
            ${data.results.map(result => `
                <tr class="status-${result.status}">
                    <td>${result.page}</td>
                    <td>${result.viewport}</td>
                    <td>${result.status.toUpperCase()}</td>
                    <td>${result.duration}ms</td>
                    <td>${result.title || 'N/A'}</td>
                    <td>${result.error || '-'}</td>
                </tr>
            `).join('')}
        </tbody>
    </table>
    
    ${failedTests.length > 0 ? `
    <div class="summary">
        <h2>❌ Failed Tests Details</h2>
        ${failedTests.map(test => `
            <div style="background: #fadbd8; padding: 10px; margin: 10px 0; border-radius: 5px;">
                <strong>${test.test}</strong><br>
                <em>${test.error}</em>
            </div>
        `).join('')}
    </div>
    ` : ''}
    
    <div class="summary">
        <h2>🔧 Environment</h2>
        <p><strong>Base URL:</strong> ${data.environment.baseUrl}</p>
        <p><strong>Headless Mode:</strong> ${data.environment.headless ? 'Yes' : 'No'}</p>
        <p><strong>Browser:</strong> Chromium (Puppeteer)</p>
    </div>
</body>
</html>`;
    }
    
    async cleanup() {
        if (this.browser) {
            await this.browser.close();
            console.log('\n🧹 Browser cleanup complete');
        }
    }
}

// Run tests if this file is executed directly
if (require.main === module) {
    const tester = new FullCompatibilityTest();
    tester.runFullCompatibilityTest().catch(console.error);
}

module.exports = FullCompatibilityTest;
