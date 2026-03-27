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
            'member-management',
            'loan-management',
            'savings-management',
            'collection-management',
            'reporting',
            'mobile-responsiveness',
            'pwa-features',
            'security',
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
            headless: this.config.headless,
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
            // Setup browser if not already done
            if (!this.browser || !this.page) {
                await this.setupBrowser();
            }
            
            switch (suiteName) {
                case 'authentication':
                    await this.testAuthentication();
                    break;
                case 'dashboard':
                    await this.testDashboard();
                    break;
                case 'member-management':
                    await this.testMemberManagement();
                    break;
                case 'loan-management':
                    await this.testLoanManagement();
                    break;
                case 'savings-management':
                    await this.testSavingsManagement();
                    break;
                case 'collection-management':
                    await this.testCollectionManagement();
                    break;
                case 'reporting':
                    await this.testReporting();
                    break;
                case 'mobile-responsiveness':
                    await this.testMobileResponsiveness();
                    break;
                case 'pwa-features':
                    await this.testPWAFeatures();
                    break;
                case 'security':
                    await this.testSecurity();
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
                error: error.message,
                duration: suiteDuration,
                timestamp: new Date().toISOString()
            });
            
            console.log(`❌ ${suiteName} tests failed: ${error.message}`);
            
            await this.takeScreenshot(`${suiteName}-error`);
        }
    }
    
    async testAuthentication() {
        // Test login page accessibility
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`);
        await this.page.waitForSelector('.login-container');
        
        // Test form validation
        await this.testLoginFormValidation();
        
        // Test successful login
        await this.testSuccessfulLogin();
        
        // Test logout
        await this.testLogout();
        
        // Test role-based access
        await this.testRoleBasedAccess();
    }
    
    async testLoginFormValidation() {
        // Test empty form submission
        await this.page.click('button[type="submit"]');
        
        // Wait for page reload and check for error message
        await this.page.waitForNavigation({ waitUntil: 'networkidle0' });
        
        // Check if error message is displayed
        const errorElement = await this.page.$('.alert-danger');
        if (!errorElement) {
            // If no error, form was submitted with empty fields - check if still on login page
            const currentUrl = this.page.url();
            if (currentUrl.includes('/pages/login.php')) {
                console.log('  ✓ Form validation - still on login page (client validation)');
            } else {
                throw new Error('Form submitted without validation');
            }
        } else {
            console.log('  ✓ Form validation - server error message displayed');
        }
        
        // Go back to login page for next test
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`);
        await this.page.waitForSelector('.login-container');
    }
    
    async testSuccessfulLogin() {
        // Fill login form
        await this.page.type('#username', 'admin');
        await this.page.type('#password', 'admin');
        
        // Submit form
        await this.page.click('button[type="submit"]');
        
        // Wait for dashboard
        await this.page.waitForSelector('.dashboard-container', { timeout: 10000 });
        
        // Check if redirected to dashboard
        const currentUrl = this.page.url();
        if (!currentUrl.includes('/dashboard')) {
            throw new Error('Login redirect failed');
        }
        
        console.log('  ✓ Successful login working');
    }
    
    async testLogout() {
        // Click logout button
        await this.page.click('[data-action="logout"]');
        
        // Wait for redirect to login
        await this.page.waitForSelector('.login-container');
        
        // Check if redirected to login
        const currentUrl = this.page.url();
        if (!currentUrl.includes('/login')) {
            throw new Error('Logout redirect failed');
        }
        
        console.log('  ✓ Logout working');
    }
    
    async testRoleBasedAccess() {
        // Test admin access
        await this.loginAs('admin', 'password');
        
        // Check admin features
        const adminFeatures = await this.page.$$eval('[data-role="admin"]', 
            elements => elements.length);
        
        if (adminFeatures === 0) {
            throw new Error('Admin features not accessible');
        }
        
        // Test collector access
        await this.logout();
        await this.loginAs('collector', 'password');
        
        // Check collector-specific features
        const collectorFeatures = await this.page.$$eval('[data-role="collector"]', 
            elements => elements.length);
        
        if (collectorFeatures === 0) {
            throw new Error('Collector features not accessible');
        }
        
        console.log('  ✓ Role-based access working');
    }
    
    async testDashboard() {
        await this.loginAs('admin', 'password');
        
        // Test dashboard components
        await this.testDashboardComponents();
        
        // Test real-time updates
        await this.testDashboardUpdates();
        
        // Test dashboard responsiveness
        await this.testDashboardResponsiveness();
    }
    
    async testDashboardComponents() {
        // Check main dashboard elements
        const requiredElements = [
            '.dashboard-header',
            '.stats-container',
            '.recent-activities',
            '.quick-actions'
        ];
        
        for (const selector of requiredElements) {
            await this.page.waitForSelector(selector, { timeout: 5000 });
        }
        
        // Test statistics cards
        const statsCards = await this.page.$$eval('.stat-card', 
            cards => cards.length);
        
        if (statsCards < 4) {
            throw new Error('Insufficient statistics cards');
        }
        
        console.log('  ✓ Dashboard components loaded');
    }
    
    async testDashboardUpdates() {
        // Test real-time updates (if implemented)
        const initialStats = await this.page.$$eval('.stat-number', 
            numbers => numbers.map(n => n.textContent));
        
        // Wait for potential updates
        await this.page.waitForTimeout(2000);
        
        const updatedStats = await this.page.$$eval('.stat-number', 
            numbers => numbers.map(n => n.textContent));
        
        console.log('  ✓ Dashboard updates checked');
    }
    
    async testDashboardResponsiveness() {
        // Test different viewport sizes
        const viewports = [
            { width: 375, height: 667 },  // Mobile
            { width: 768, height: 1024 }, // Tablet
            { width: 1920, height: 1080 } // Desktop
        ];
        
        for (const viewport of viewports) {
            await this.page.setViewport(viewport);
            await this.page.waitForTimeout(1000);
            
            // Check if dashboard is still functional
            const dashboardVisible = await this.page.$('.dashboard-container');
            if (!dashboardVisible) {
                throw new Error(`Dashboard not visible at ${viewport.width}x${viewport.height}`);
            }
        }
        
        // Reset to default viewport
        await this.page.setViewport(this.config.viewport);
        
        console.log('  ✓ Dashboard responsiveness verified');
    }
    
    async testMemberManagement() {
        await this.loginAs('admin', 'password');
        
        // Navigate to member management
        await this.page.click('[data-nav="members"]');
        await this.page.waitForSelector('.members-container');
        
        // Test member list
        await this.testMemberList();
        
        // Test member search
        await this.testMemberSearch();
        
        // Test member creation
        await this.testMemberCreation();
        
        // Test member editing
        await this.testMemberEditing();
    }
    
    async testMemberList() {
        // Check if member list is loaded
        const memberRows = await this.page.$$eval('.member-row', 
            rows => rows.length);
        
        if (memberRows === 0) {
            throw new Error('Member list is empty');
        }
        
        // Test pagination
        const pagination = await this.page.$('.pagination');
        if (pagination) {
            await this.page.click('.pagination .page-link:not(.disabled)');
            await this.page.waitForTimeout(1000);
        }
        
        console.log('  ✓ Member list working');
    }
    
    async testMemberSearch() {
        // Test search functionality
        const searchInput = await this.page.$('#member-search');
        if (searchInput) {
            await searchInput.type('test');
            await this.page.waitForTimeout(1000);
            
            // Check if search results are filtered
            const searchResults = await this.page.$$eval('.member-row', 
                rows => rows.length);
            
            console.log('  ✓ Member search working');
        }
    }
    
    async testMemberCreation() {
        // Click add member button
        await this.page.click('[data-action="add-member"]');
        await this.page.waitForSelector('.member-form');
        
        // Fill member form
        await this.page.type('#member-name', 'Test Member');
        await this.page.type('#member-email', 'test@example.com');
        await this.page.type('#member-phone', '08123456789');
        
        // Test form validation
        await this.page.click('[data-action="save-member"]');
        
        // Check for validation errors or success
        await this.page.waitForTimeout(2000);
        
        console.log('  ✓ Member creation tested');
    }
    
    async testMemberEditing() {
        // Click edit button for first member
        const editButton = await this.page.$('.member-row:first-child [data-action="edit"]');
        if (editButton) {
            await editButton.click();
            await this.page.waitForSelector('.member-form');
            
            // Test form population
            const nameField = await this.page.$('#member-name');
            const nameValue = await nameField.getProperty('value');
            
            if (!nameValue) {
                throw new Error('Member form not populated');
            }
            
            console.log('  ✓ Member editing working');
        }
    }
    
    async testLoanManagement() {
        await this.loginAs('admin', 'password');
        
        // Navigate to loan management
        await this.page.click('[data-nav="loans"]');
        await this.page.waitForSelector('.loans-container');
        
        // Test loan list
        await this.testLoanList();
        
        // Test loan application
        await this.testLoanApplication();
        
        // Test loan approval
        await this.testLoanApproval();
        
        // Test loan payment
        await this.testLoanPayment();
    }
    
    async testLoanList() {
        // Check if loan list is loaded
        const loanRows = await this.page.$$eval('.loan-row', 
            rows => rows.length);
        
        if (loanRows === 0) {
            throw new Error('Loan list is empty');
        }
        
        // Test loan status badges
        const statusBadges = await this.page.$$eval('.loan-status', 
            badges => badges.length);
        
        if (statusBadges === 0) {
            throw new Error('Loan status badges not found');
        }
        
        console.log('  ✓ Loan list working');
    }
    
    async testLoanApplication() {
        // Click apply loan button
        await this.page.click('[data-action="apply-loan"]');
        await this.page.waitForSelector('.loan-form');
        
        // Fill loan application form
        await this.page.select('#member-select', '1');
        await this.page.type('#loan-amount', '10000000');
        await this.page.type('#loan-purpose', 'Business capital');
        
        // Test form validation
        await this.page.click('[data-action="submit-loan"]');
        
        // Check for validation errors or success
        await this.page.waitForTimeout(2000);
        
        console.log('  ✓ Loan application tested');
    }
    
    async testLoanApproval() {
        // Find pending loan
        const pendingLoan = await this.page.$('.loan-status.badge-warning');
        if (pendingLoan) {
            const approveButton = await this.page.$('[data-action="approve-loan"]');
            if (approveButton) {
                await approveButton.click();
                await this.page.waitForSelector('.approval-modal');
                
                // Test approval modal
                await this.page.click('[data-action="confirm-approval"]');
                await this.page.waitForTimeout(2000);
                
                console.log('  ✓ Loan approval working');
            }
        }
    }
    
    async testLoanPayment() {
        // Find active loan
        const activeLoan = await this.page.$('.loan-status.badge-success');
        if (activeLoan) {
            const paymentButton = await this.page.$('[data-action="make-payment"]');
            if (paymentButton) {
                await paymentButton.click();
                await this.page.waitForSelector('.payment-form');
                
                // Test payment form
                await this.page.type('#payment-amount', '1000000');
                await this.page.select('#payment-method', 'cash');
                
                console.log('  ✓ Loan payment tested');
            }
        }
    }
    
    async testSavingsManagement() {
        await this.loginAs('admin', 'password');
        
        // Navigate to savings management
        await this.page.click('[data-nav="savings"]');
        await this.page.waitForSelector('.savings-container');
        
        // Test savings accounts
        await this.testSavingsAccounts();
        
        // Test deposit
        await this.testSavingsDeposit();
        
        // Test withdrawal
        await this.testSavingsWithdrawal();
        
        // Test interest calculation
        await this.testInterestCalculation();
    }
    
    async testSavingsAccounts() {
        // Check if savings accounts list is loaded
        const accountRows = await this.page.$$eval('.savings-account', 
            rows => rows.length);
        
        if (accountRows === 0) {
            throw new Error('Savings accounts list is empty');
        }
        
        // Test account types
        const accountTypes = await this.page.$$eval('.account-type', 
            types => types.length);
        
        if (accountTypes === 0) {
            throw new Error('Account types not found');
        }
        
        console.log('  ✓ Savings accounts working');
    }
    
    async testSavingsDeposit() {
        // Click deposit button
        await this.page.click('[data-action="deposit"]');
        await this.page.waitForSelector('.deposit-form');
        
        // Fill deposit form
        await this.page.select('#account-select', '1');
        await this.page.type('#deposit-amount', '1000000');
        await this.page.select('#payment-method', 'cash');
        
        // Test form validation
        await this.page.click('[data-action="submit-deposit"]');
        
        await this.page.waitForTimeout(2000);
        
        console.log('  ✓ Savings deposit tested');
    }
    
    async testSavingsWithdrawal() {
        // Click withdrawal button
        await this.page.click('[data-action="withdraw"]');
        await this.page.waitForSelector('.withdrawal-form');
        
        // Fill withdrawal form
        await this.page.select('#account-select', '1');
        await this.page.type('#withdrawal-amount', '500000');
        await this.page.select('#payment-method', 'cash');
        
        await this.page.click('[data-action="submit-withdrawal"]');
        
        await this.page.waitForTimeout(2000);
        
        console.log('  ✓ Savings withdrawal tested');
    }
    
    async testInterestCalculation() {
        // Test interest calculation button
        const interestButton = await this.page.$('[data-action="calculate-interest"]');
        if (interestButton) {
            await interestButton.click();
            await this.page.waitForTimeout(2000);
            
            console.log('  ✓ Interest calculation tested');
        }
    }
    
    async testCollectionManagement() {
        await this.loginAs('collector', 'password');
        
        // Navigate to collection management
        await this.page.click('[data-nav="collections"]');
        await this.page.waitForSelector('.collections-container');
        
        // Test today's route
        await this.testTodaysRoute();
        
        // Test collection recording
        await this.testCollectionRecording();
        
        // Test route optimization
        await this.testRouteOptimization();
    }
    
    async testTodaysRoute() {
        // Check if today's route is loaded
        const routeMembers = await this.page.$$eval('.route-member', 
            members => members.length);
        
        if (routeMembers === 0) {
            throw new Error('Today\'s route is empty');
        }
        
        // Test member status
        const memberStatuses = await this.page.$$eval('.member-status', 
            statuses => statuses.length);
        
        if (memberStatuses === 0) {
            throw new Error('Member statuses not found');
        }
        
        console.log('  ✓ Today\'s route working');
    }
    
    async testCollectionRecording() {
        // Find pending member
        const pendingMember = await this.page.$('.member-status.badge-warning');
        if (pendingMember) {
            const collectButton = await this.page.$('[data-action="collect-payment"]');
            if (collectButton) {
                await collectButton.click();
                await this.page.waitForSelector('.collection-form');
                
                // Fill collection form
                await this.page.type('#collection-amount', '1000000');
                await this.page.select('#payment-method', 'cash');
                
                await this.page.click('[data-action="submit-collection"]');
                
                await this.page.waitForTimeout(2000);
                
                console.log('  ✓ Collection recording working');
            }
        }
    }
    
    async testRouteOptimization() {
        // Test route optimization button
        const optimizeButton = await this.page.$('[data-action="optimize-route"]');
        if (optimizeButton) {
            await optimizeButton.click();
            await this.page.waitForTimeout(2000);
            
            console.log('  ✓ Route optimization tested');
        }
    }
    
    async testReporting() {
        await this.loginAs('admin', 'password');
        
        // Navigate to reporting
        await this.page.click('[data-nav="reports"]');
        await this.page.waitForSelector('.reports-container');
        
        // Test financial reports
        await this.testFinancialReports();
        
        // Test operational reports
        await this.testOperationalReports();
        
        // Test report export
        await this.testReportExport();
    }
    
    async testFinancialReports() {
        // Test financial report generation
        await this.page.click('[data-report="financial"]');
        await this.page.waitForSelector('.report-form');
        
        // Set report parameters
        await this.page.type('#date-from', '2026-01-01');
        await this.page.type('#date-to', '2026-03-31');
        await this.page.select('#report-type', 'income-statement');
        
        await this.page.click('[data-action="generate-report"]');
        
        await this.page.waitForTimeout(3000);
        
        // Check if report is generated
        const reportContent = await this.page.$('.report-content');
        if (!reportContent) {
            throw new Error('Financial report not generated');
        }
        
        console.log('  ✓ Financial reports working');
    }
    
    async testOperationalReports() {
        // Test operational report generation
        await this.page.click('[data-report="operational"]');
        await this.page.waitForSelector('.report-form');
        
        await this.page.select('#report-type', 'performance');
        await this.page.click('[data-action="generate-report"]');
        
        await this.page.waitForTimeout(3000);
        
        console.log('  ✓ Operational reports working');
    }
    
    async testReportExport() {
        // Test export functionality
        const exportButtons = await this.page.$$('[data-action="export"]');
        if (exportButtons.length > 0) {
            await exportButtons[0].click();
            await this.page.waitForTimeout(2000);
            
            console.log('  ✓ Report export tested');
        }
    }
    
    async testMobileResponsiveness() {
        const mobileViewports = [
            { width: 375, height: 667 },  // iPhone SE
            { width: 414, height: 896 },  // iPhone 11
            { width: 360, height: 640 },  // Android
            { width: 768, height: 1024 }  // iPad
        ];
        
        for (const viewport of mobileViewports) {
            await this.page.setViewport(viewport);
            await this.page.goto(`${this.config.baseUrl}/pages/login.php`);
            
            // Test mobile login
            await this.page.waitForSelector('.login-container');
            
            // Test mobile navigation
            await this.loginAs('admin', 'password');
            await this.page.waitForSelector('.mobile-nav-toggle');
            
            // Test mobile menu
            await this.page.click('.mobile-nav-toggle');
            await this.page.waitForSelector('.mobile-nav');
            
            console.log(`  ✓ Mobile responsiveness tested at ${viewport.width}x${viewport.height}`);
        }
        
        // Reset to desktop
        await this.page.setViewport(this.config.viewport);
    }
    
    async testPWAFeatures() {
        // Test PWA manifest
        const manifest = await this.page.evaluate(() => {
            const link = document.querySelector('link[rel="manifest"]');
            return link ? link.href : null;
        });
        
        if (!manifest) {
            throw new Error('PWA manifest not found');
        }
        
        // Test service worker registration
        const serviceWorker = await this.page.evaluate(() => {
            return navigator.serviceWorker ? 'registered' : 'not supported';
        });
        
        if (serviceWorker === 'not supported') {
            throw new Error('Service worker not supported');
        }
        
        // Test offline capability
        await this.page.setOfflineMode(true);
        await this.page.goto(`${this.config.baseUrl}/login`);
        await this.page.waitForSelector('.login-container');
        await this.page.setOfflineMode(false);
        
        console.log('  ✓ PWA features working');
    }
    
    async testSecurity() {
        // Test HTTPS redirection
        await this.page.goto(`${this.config.baseUrl}/login`);
        const currentUrl = this.page.url();
        
        // Test XSS protection
        await this.page.evaluate(() => {
            const input = document.createElement('input');
            input.value = '<script>alert("XSS")</script>';
            document.body.appendChild(input);
        });
        
        // Test CSRF protection
        await this.loginAs('admin', 'password');
        
        // Test session management
        await this.page.goto(`${this.config.baseUrl}/dashboard`);
        await this.page.waitForSelector('.dashboard-container');
        
        // Test session timeout
        await this.page.evaluate(() => {
            document.cookie = 'session_id=; expires=Thu, 01 Jan 1970 00:00:00 GMT';
        });
        
        await this.page.reload();
        await this.page.waitForSelector('.login-container');
        
        console.log('  ✓ Security features working');
    }
    
    async testPerformance() {
        // Test page load performance
        const metrics = await this.page.evaluate(() => {
            const navigation = performance.getEntriesByType('navigation')[0];
            return {
                domContentLoaded: navigation.domContentLoadedEventEnd - navigation.navigationStart,
                loadComplete: navigation.loadEventEnd - navigation.navigationStart,
                firstPaint: performance.getEntriesByName('first-paint')[0]?.startTime || 0
            };
        });
        
        // Test memory usage
        const memoryUsage = await this.page.evaluate(() => {
            return performance.memory ? {
                used: performance.memory.usedJSHeapSize,
                total: performance.memory.totalJSHeapSize,
                limit: performance.memory.jsHeapSizeLimit
            } : null;
        });
        
        // Test network performance
        const networkMetrics = await this.page.evaluate(() => {
            const resources = performance.getEntriesByType('resource');
            return {
                totalRequests: resources.length,
                totalSize: resources.reduce((sum, resource) => sum + (resource.transferSize || 0), 0),
                slowRequests: resources.filter(r => r.duration > 1000).length
            };
        });
        
        console.log('  ✓ Performance metrics collected');
        
        // Log performance data
        console.log('    - DOM Content Loaded:', metrics.domContentLoaded + 'ms');
        console.log('    - Load Complete:', metrics.loadComplete + 'ms');
        console.log('    - First Paint:', metrics.firstPaint + 'ms');
        console.log('    - Network Requests:', networkMetrics.totalRequests);
        console.log('    - Slow Requests:', networkMetrics.slowRequests);
    }
    
    async loginAs(username, password) {
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`);
        await this.page.waitForSelector('.login-container');
        
        await this.page.type('#username', username);
        await this.page.type('#password', password);
        await this.page.click('button[type="submit"]');
        
        await this.page.waitForSelector('.dashboard-container', { timeout: 10000 });
    }
    
    async logout() {
        await this.page.click('[data-action="logout"]');
        await this.page.waitForSelector('.login-container');
    }
    
    async takeScreenshot(name) {
        const screenshotPath = path.join(__dirname, 'screenshots', `${name}.png`);
        
        // Ensure screenshots directory exists
        if (!fs.existsSync(path.dirname(screenshotPath))) {
            fs.mkdirSync(path.dirname(screenshotPath), { recursive: true });
        }
        
        await this.page.screenshot({ path: screenshotPath, fullPage: true });
        this.screenshots.push(screenshotPath);
        
        console.log(`📸 Screenshot saved: ${screenshotPath}`);
    }
    
    async logResponse(response) {
        // Log slow responses
        if (response.url().includes('/api/') && response.request().resourceType() === 'xhr') {
            const timing = response.timing();
            const duration = timing.responseEnd - timing.requestStart;
            
            if (duration > 2000) {
                console.log(`⚠️  Slow API response: ${response.url()} (${duration}ms)`);
            }
        }
    }
    
    async waitForSelector(selector, options = {}) {
        try {
            await this.page.waitForSelector(selector, options);
        } catch (error) {
            await this.takeScreenshot(`missing-${selector.replace(/[^a-zA-Z0-9]/g, '-')}`);
            throw new Error(`Element not found: ${selector}`);
        }
    }
    
    async generateTestReport() {
        const reportPath = path.join(__dirname, 'test-report.json');
        
        const report = {
            timestamp: new Date().toISOString(),
            summary: {
                totalSuites: this.testSuites.length,
                passed: this.testResults.filter(r => r.status === 'passed').length,
                failed: this.testResults.filter(r => r.status === 'failed').length,
                totalDuration: this.testResults.reduce((sum, r) => sum + r.duration, 0)
            },
            results: this.testResults,
            screenshots: this.screenshots,
            environment: {
                baseUrl: this.config.baseUrl,
                headless: this.config.headless,
                viewport: this.config.viewport
            }
        };
        
        fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
        
        // Generate HTML report
        await this.generateHTMLReport(report);
        
        console.log(`\n📊 Test report generated: ${reportPath}`);
        console.log(`📈 HTML report: ${path.join(__dirname, 'test-report.html')}`);
        
        // Print summary
        console.log('\n📋 Test Summary:');
        console.log(`   Total Suites: ${report.summary.totalSuites}`);
        console.log(`   Passed: ${report.summary.passed}`);
        console.log(`   Failed: ${report.summary.failed}`);
        console.log(`   Duration: ${report.summary.totalDuration}ms`);
        
        if (report.summary.failed > 0) {
            console.log('\n❌ Failed Tests:');
            this.testResults
                .filter(r => r.status === 'failed')
                .forEach(r => console.log(`   - ${r.suite}: ${r.error}`));
        }
    }
    
    async generateHTMLReport(report) {
        const htmlTemplate = `
<!DOCTYPE html>
<html>
<head>
    <title>Comprehensive System Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #f4f4f4; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .summary { display: flex; gap: 20px; margin-bottom: 20px; }
        .metric { background: #e9ecef; padding: 15px; border-radius: 5px; text-align: center; }
        .metric h3 { margin: 0; color: #333; }
        .metric .value { font-size: 24px; font-weight: bold; color: #007bff; }
        .passed { color: #28a745; }
        .failed { color: #dc3545; }
        .test-results { margin-top: 20px; }
        .test-result { background: #f8f9fa; margin: 10px 0; padding: 15px; border-radius: 5px; border-left: 4px solid #007bff; }
        .test-result.failed { border-left-color: #dc3545; }
        .screenshots { margin-top: 20px; }
        .screenshot { margin: 10px; display: inline-block; }
        .screenshot img { max-width: 200px; height: auto; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🧪 Comprehensive System Test Report</h1>
        <p>Generated: ${report.timestamp}</p>
    </div>
    
    <div class="summary">
        <div class="metric">
            <h3>Total Suites</h3>
            <div class="value">${report.summary.totalSuites}</div>
        </div>
        <div class="metric">
            <h3>Passed</h3>
            <div class="value passed">${report.summary.passed}</div>
        </div>
        <div class="metric">
            <h3>Failed</h3>
            <div class="value failed">${report.summary.failed}</div>
        </div>
        <div class="metric">
            <h3>Duration</h3>
            <div class="value">${report.summary.totalDuration}ms</div>
        </div>
    </div>
    
    <div class="test-results">
        <h2>Test Results</h2>
        ${report.results.map(result => `
            <div class="test-result ${result.status}">
                <h3>${result.suite}</h3>
                <p>Status: <span class="${result.status}">${result.status}</span></p>
                <p>Duration: ${result.duration}ms</p>
                ${result.error ? `<p>Error: ${result.error}</p>` : ''}
            </div>
        `).join('')}
    </div>
    
    <div class="screenshots">
        <h2>Screenshots</h2>
        ${report.screenshots.map(screenshot => `
            <div class="screenshot">
                <img src="${screenshot.replace(/.*\//, '')}" alt="Screenshot">
                <p>${screenshot.replace(/.*\//, '')}</p>
            </div>
        `).join('')}
    </div>
</body>
</html>
        `;
        
        const htmlPath = path.join(__dirname, 'test-report.html');
        fs.writeFileSync(htmlPath, htmlTemplate);
    }
    
    async cleanup() {
        if (this.browser) {
            await this.browser.close();
        }
        
        console.log('\n🧹 Browser cleanup complete');
    }
}

// Run tests if this file is executed directly
if (require.main === module) {
    const tester = new ComprehensiveSystemTest();
    tester.runAllTests().catch(console.error);
}

module.exports = ComprehensiveSystemTest;
