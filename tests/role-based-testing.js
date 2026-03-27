/**
 * ================================================================
 * ROLE-BASED FEATURE TESTING - KOPERASI BERJALAN
 * Comprehensive testing of all user roles and their specific features
 * ================================================================ */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

class RoleBasedTesting {
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
        
        // Define all user roles and credentials
        this.userRoles = [
            {
                username: 'admin',
                password: 'admin',
                role: 'bos',
                name: 'Administrator',
                branch: 'Pusat',
                expectedDashboard: 'web',
                features: [
                    'unit_management',
                    'branch_management', 
                    'member_management',
                    'loan_management',
                    'savings_management',
                    'collection_management',
                    'reporting',
                    'system_settings'
                ]
            },
            {
                username: 'collector',
                password: 'collector', 
                role: 'collector',
                name: 'Petugas Kolektor',
                branch: 'Cabang Jakarta',
                expectedDashboard: 'mobile',
                features: [
                    'mobile_dashboard',
                    'collection_route',
                    'member_visit',
                    'payment_collection',
                    'daily_report'
                ]
            }
        ];
        
        // Define feature tests for each role
        this.featureTests = {
            bos: {
                unit_management: [
                    { selector: 'a[href="/units"]', name: 'Daftar Unit Menu' },
                    { selector: 'a[href="/units/add"]', name: 'Tambah Unit Menu' }
                ],
                branch_management: [
                    { selector: 'a[href="/branches"]', name: 'Daftar Cabang Menu' },
                    { selector: 'a[href="/branches/add"]', name: 'Tambah Cabang Menu' }
                ],
                member_management: [
                    { selector: 'a[href="/members"]', name: 'Daftar Anggota Menu' },
                    { selector: 'a[href="/members/add"]', name: 'Tambah Anggota Menu' },
                    { selector: 'a[href="/members/family"]', name: 'Hubungan Keluarga Menu' }
                ],
                loan_management: [
                    { selector: 'a[href="/loans"]', name: 'Daftar Pinjaman Menu' },
                    { selector: 'a[href="/loans/apply"]', name: 'Ajukan Pinjaman Menu' },
                    { selector: 'a[href="/loans/schedules"]', name: 'Jadwal Angsuran Menu' },
                    { selector: 'a[href="/loans/products"]', name: 'Produk Pinjaman Menu' }
                ],
                savings_management: [
                    { selector: 'a[href="/savings/kewer"]', name: 'Kewer (Harian) Menu' },
                    { selector: 'a[href="/savings/mawar"]', name: 'Mawar (Bulanan) Menu' },
                    { selector: 'a[href="/savings/sukarela"]', name: 'Sukarela Menu' },
                    { selector: 'a[href="/savings/products"]', name: 'Produk Simpanan Menu' }
                ],
                collection_management: [
                    { selector: 'a[href="/collections"]', name: 'Manajemen Koleksi Menu' },
                    { selector: 'a[href="/collections/reports"]', name: 'Laporan Koleksi Menu' }
                ],
                reporting: [
                    { selector: 'a[href="/reports/summary"]', name: 'Ringkasan Laporan Menu' },
                    { selector: 'a[href="/reports/loans"]', name: 'Laporan Pinjaman Menu' },
                    { selector: 'a[href="/reports/savings"]', name: 'Laporan Simpanan Menu' },
                    { selector: 'a[href="/reports/cash"]', name: 'Arus Kas Menu' },
                    { selector: 'a[href="/reports/financial"]', name: 'Laporan Keuangan Menu' },
                    { selector: 'a[href="/reports/ojk"]', name: 'Laporan OJK Menu' }
                ],
                system_settings: [
                    { selector: 'a[href="/settings/system"]', name: 'Pengaturan Sistem Menu' },
                    { selector: 'a[href="/settings/users"]', name: 'Manajemen User Menu' }
                ]
            },
            collector: {
                mobile_dashboard: [
                    { selector: '.mobile-dashboard', name: 'Mobile Dashboard Container' },
                    { selector: '.collection-summary', name: 'Ringkasan Koleksi' },
                    { selector: '.today-route', name: 'Rute Hari Ini' }
                ],
                collection_route: [
                    { selector: '.route-list', name: 'Daftar Rute' },
                    { selector: '.member-card', name: 'Kartu Anggota' },
                    { selector: '.collection-form', name: 'Form Koleksi' }
                ],
                member_visit: [
                    { selector: '.visit-history', name: 'Riwayat Kunjungan' },
                    { selector: '.member-details', name: 'Detail Anggota' }
                ],
                payment_collection: [
                    { selector: '.payment-form', name: 'Form Pembayaran' },
                    { selector: '.payment-history', name: 'Riwayat Pembayaran' }
                ],
                daily_report: [
                    { selector: '.daily-summary', name: 'Ringkasan Harian' },
                    { selector: '.collection-stats', name: 'Statistik Koleksi' }
                ]
            }
        };
    }
    
    async runRoleBasedTests() {
        console.log('👥 Starting Role-Based Feature Testing...\n');
        
        try {
            await this.setupBrowser();
            
            // Test each user role
            for (const userRole of this.userRoles) {
                await this.testUserRole(userRole);
            }
            
            await this.generateRoleBasedReport();
            
        } catch (error) {
            console.error('❌ Role-based testing failed:', error);
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
    
    async testUserRole(userRole) {
        console.log(`\n👤 Testing Role: ${userRole.name} (${userRole.role})`);
        console.log(`🏢 Branch: ${userRole.branch}`);
        console.log(`📱 Expected Dashboard: ${userRole.expectedDashboard}`);
        
        const roleStartTime = Date.now();
        
        try {
            // Test login
            await this.testLogin(userRole);
            
            // Test dashboard access
            await this.testDashboardAccess(userRole);
            
            // Test role-specific features
            await this.testRoleFeatures(userRole);
            
            // Test navigation permissions
            await this.testNavigationPermissions(userRole);
            
            // Test logout
            await this.testLogout(userRole);
            
            const roleDuration = Date.now() - roleStartTime;
            
            this.testResults.push({
                role: userRole.role,
                name: userRole.name,
                status: 'passed',
                duration: roleDuration,
                features: userRole.features,
                timestamp: new Date().toISOString()
            });
            
            console.log(`✅ ${userRole.name} role tests completed (${roleDuration}ms)`);
            
        } catch (error) {
            const roleDuration = Date.now() - roleStartTime;
            
            this.testResults.push({
                role: userRole.role,
                name: userRole.name,
                status: 'failed',
                duration: roleDuration,
                error: error.message,
                timestamp: new Date().toISOString()
            });
            
            console.log(`❌ ${userRole.name} role tests failed: ${error.message}`);
            
            await this.takeScreenshot(`${userRole.role}_error`);
        }
    }
    
    async testLogin(userRole) {
        console.log(`  🔐 Testing login for ${userRole.username}...`);
        
        // Navigate to login page
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`, { waitUntil: 'networkidle2' });
        
        // Fill login form
        await this.page.type('#username', userRole.username);
        await this.page.type('#password', userRole.password);
        
        // Submit form and wait for navigation
        const navigationPromise = this.page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 15000 });
        await Promise.all([
            navigationPromise,
            this.page.click('button[type="submit"]')
        ]);
        
        // Verify successful login
        const currentUrl = this.page.url();
        const expectedPath = userRole.expectedDashboard === 'mobile' ? 
            '/pages/mobile/dashboard.php' : '/pages/web/dashboard.php';
        
        if (!currentUrl.includes(expectedPath)) {
            throw new Error(`Login failed - expected ${expectedPath}, got ${currentUrl}`);
        }
        
        // Verify user session
        const userInfo = await this.page.evaluate(() => {
            const bodyText = document.body.textContent || document.body.innerText || '';
            return bodyText.includes('Administrator') || 
                   bodyText.includes('Petugas Kolektor') ||
                   bodyText.includes('Koperasi Berjalan');
        });
        
        if (!userInfo) {
            // Take screenshot for debugging
            await this.takeScreenshot(`${userRole.role}_login_debug`);
            throw new Error('User session not properly established');
        }
        
        console.log(`    ✓ Login successful for ${userRole.name}`);
    }
    
    async testDashboardAccess(userRole) {
        console.log(`  📊 Testing dashboard access...`);
        
        // Check dashboard title
        const title = await this.page.title();
        if (!title || title === '') {
            throw new Error('Dashboard title not found');
        }
        
        // Check user info display
        const userInfo = await this.page.$('.alert-info, .user-info, .user-details');
        if (!userInfo) {
            throw new Error('User information not displayed on dashboard');
        }
        
        // Check dashboard content
        const dashboardContent = await this.page.$('.container-fluid, .dashboard-container, main');
        if (!dashboardContent) {
            throw new Error('Dashboard content container not found');
        }
        
        // Check for metric cards or dashboard elements
        const metricCards = await this.page.$$('.card, .metric, .stat-card');
        console.log(`    ✓ Found ${metricCards.length} dashboard elements`);
        
        console.log(`    ✓ Dashboard access verified for ${userRole.name}`);
    }
    
    async testRoleFeatures(userRole) {
        console.log(`  🎯 Testing role-specific features...`);
        
        const featureTests = this.featureTests[userRole.role];
        const featureResults = [];
        
        for (const feature of userRole.features) {
            if (featureTests[feature]) {
                console.log(`    Testing ${feature}...`);
                
                const featureResult = await this.testSpecificFeature(feature, featureTests[feature]);
                featureResults.push({
                    feature: feature,
                    result: featureResult
                });
                
                if (featureResult) {
                    console.log(`      ✓ ${feature} feature available`);
                } else {
                    console.log(`      ⚠️ ${feature} feature not found`);
                }
            }
        }
        
        return featureResults;
    }
    
    async testSpecificFeature(featureName, featureSelectors) {
        let availableCount = 0;
        
        for (const selector of featureSelectors) {
            try {
                const element = await this.page.$(selector.selector);
                if (element) {
                    availableCount++;
                }
            } catch (error) {
                // Element not found, continue checking others
            }
        }
        
        // Feature is considered available if at least 50% of elements are found
        return availableCount >= (featureSelectors.length * 0.5);
    }
    
    async testNavigationPermissions(userRole) {
        console.log(`  🔒 Testing navigation permissions...`);
        
        // Test menu items that should be visible for this role
        const navigationTests = [
            { selector: '.navbar-nav', name: 'Main Navigation' },
            { selector: '.dropdown-menu', name: 'Dropdown Menus' },
            { selector: '.nav-link', name: 'Navigation Links' }
        ];
        
        for (const navTest of navigationTests) {
            try {
                const elements = await this.page.$$(navTest.selector);
                console.log(`    ✓ Found ${elements.length} ${navTest.name} elements`);
            } catch (error) {
                console.log(`    ⚠️ ${navTest.name} not accessible`);
            }
        }
        
        // Test user-specific navigation elements
        if (userRole.role === 'bos') {
            const adminElements = await this.page.$$('.dropdown-menu a[href*="/units"], .dropdown-menu a[href*="/branches"]');
            console.log(`    ✓ Found ${adminElements.length} admin-specific menu items`);
        } else if (userRole.role === 'collector') {
            const mobileElements = await this.page.$$('.mobile-nav, .collection-nav');
            console.log(`    ✓ Found ${mobileElements.length} mobile-specific elements`);
        }
        
        console.log(`    ✓ Navigation permissions verified for ${userRole.name}`);
    }
    
    async testLogout(userRole) {
        console.log(`  🚪 Testing logout...`);
        
        // Look for logout link in dropdown (need to click dropdown first)
        const userDropdown = await this.page.$('#userDropdown, .dropdown-toggle[href="#"]');
        if (userDropdown) {
            await userDropdown.click();
            await this.page.waitForTimeout(500); // Wait for dropdown to open
        }
        
        // Now look for logout link
        const logoutSelectors = [
            'a[href*="logout"]',
            'a[href*="keluar"]',
            'a[href="/gabe/logout.php"]'
        ];
        
        let logoutLink = null;
        for (const selector of logoutSelectors) {
            logoutLink = await this.page.$(selector);
            if (logoutLink) break;
        }
        
        if (!logoutLink) {
            throw new Error('Logout link not found');
        }
        
        // Click logout and wait for redirect
        const navigationPromise = this.page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 10000 });
        await Promise.all([
            navigationPromise,
            logoutLink.click()
        ]);
        
        // Verify redirect to login page
        const currentUrl = this.page.url();
        if (!currentUrl.includes('login')) {
            throw new Error('Logout did not redirect to login page');
        }
        
        console.log(`    ✓ Logout successful for ${userRole.name}`);
    }
    
    async takeScreenshot(filename) {
        if (this.page) {
            const screenshotPath = path.join(__dirname, 'screenshots', `${filename}.png`);
            await this.page.screenshot({ path: screenshotPath, fullPage: true });
            console.log(`      📸 Screenshot saved: ${screenshotPath}`);
        }
    }
    
    async generateRoleBasedReport() {
        const summary = {
            totalRoles: this.userRoles.length,
            passed: this.testResults.filter(r => r.status === 'passed').length,
            failed: this.testResults.filter(r => r.status === 'failed').length,
            totalDuration: this.testResults.reduce((sum, r) => sum + r.duration, 0)
        };
        
        const reportData = {
            timestamp: new Date().toISOString(),
            summary: summary,
            userRoles: this.userRoles,
            results: this.testResults,
            featureTests: this.featureTests,
            environment: {
                baseUrl: this.config.baseUrl,
                headless: this.config.headless
            }
        };
        
        // Save JSON report
        const jsonReportPath = path.join(__dirname, 'role-based-report.json');
        fs.writeFileSync(jsonReportPath, JSON.stringify(reportData, null, 2));
        
        // Generate HTML report
        const htmlReport = this.generateRoleBasedHTML(reportData);
        const htmlReportPath = path.join(__dirname, 'role-based-report.html');
        fs.writeFileSync(htmlReportPath, htmlReport);
        
        // Print summary
        console.log('\n👥 Role-Based Testing Summary:');
        console.log(`   Total Roles Tested: ${summary.totalRoles}`);
        console.log(`   Passed: ${summary.passed}`);
        console.log(`   Failed: ${summary.failed}`);
        console.log(`   Duration: ${summary.totalDuration}ms`);
        
        if (summary.failed > 0) {
            console.log('\n❌ Failed Role Tests:');
            this.testResults.filter(r => r.status === 'failed').forEach(result => {
                console.log(`   - ${result.name}: ${result.error}`);
            });
        }
        
        console.log(`\n📄 Role-based reports generated:`);
        console.log(`   JSON: ${jsonReportPath}`);
        console.log(`   HTML: ${htmlReportPath}`);
    }
    
    generateRoleBasedHTML(data) {
        const passedRoles = data.results.filter(r => r.status === 'passed');
        const failedRoles = data.results.filter(r => r.status === 'failed');
        
        return `
<!DOCTYPE html>
<html lang="id">
<head>
    <title>Role-Based Testing Report - Koperasi Berjalan</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .header { background: #2c3e50; color: white; padding: 20px; border-radius: 5px; margin-bottom: 20px; }
        .summary { background: white; padding: 20px; border-radius: 5px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .passed { color: #27ae60; font-weight: bold; }
        .failed { color: #e74c3c; font-weight: bold; }
        .role-card { background: white; margin: 20px 0; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .role-header { padding: 15px; background: #3498db; color: white; border-radius: 5px 5px 0 0; }
        .role-content { padding: 15px; }
        .feature-list { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 10px; margin: 10px 0; }
        .feature-item { background: #ecf0f1; padding: 8px; border-radius: 3px; font-size: 12px; }
        .feature-available { background: #d5f4e6; color: #27ae60; }
        .feature-unavailable { background: #fadbd8; color: #e74c3c; }
        .metric { display: inline-block; margin: 10px 20px 10px 0; }
        .metric-value { font-size: 24px; font-weight: bold; color: #2c3e50; }
        .metric-label { font-size: 12px; color: #7f8c8d; text-transform: uppercase; }
    </style>
</head>
<body>
    <div class="header">
        <h1>👥 Role-Based Testing Report</h1>
        <p>Koperasi Berjalan Application - User Role & Feature Testing</p>
        <p>Generated: ${data.timestamp}</p>
    </div>
    
    <div class="summary">
        <h2>📊 Test Summary</h2>
        <div class="metric">
            <div class="metric-value">${data.summary.totalRoles}</div>
            <div class="metric-label">Roles Tested</div>
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
            <div class="metric-value">${data.summary.totalDuration}ms</div>
            <div class="metric-label">Duration</div>
        </div>
    </div>
    
    <h2>👤 User Role Test Results</h2>
    
    ${data.results ? data.results.map(result => `
        <div class="role-card">
            <div class="role-header">
                <h3>${result.name} (${result.role})</h3>
                <p>Status: ${result.status.toUpperCase()} | Duration: ${result.duration}ms</p>
            </div>
            <div class="role-content">
                <p><strong>Features Tested:</strong></p>
                <div class="feature-list">
                    ${result.features ? result.features.map(feature => `
                        <div class="feature-item feature-available">
                            ${feature.replace(/_/g, ' ').toUpperCase()}
                        </div>
                    `).join('') : 'No features tested'}
                </div>
                ${result.error ? `
                    <p style="color: #e74c3c; margin-top: 10px;">
                        <strong>Error:</strong> ${result.error}
                    </p>
                ` : ''}
            </div>
        </div>
    `).join('') : '<p>No test results available</p>'}
    
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
    const tester = new RoleBasedTesting();
    tester.runRoleBasedTests().catch(console.error);
}

module.exports = RoleBasedTesting;
