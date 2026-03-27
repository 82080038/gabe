const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

class LoginTest {
    constructor() {
        this.browser = null;
        this.page = null;
        this.testResults = [];
        this.screenshots = [];
    }

    async setup() {
        console.log('🚀 Starting browser...');
        this.browser = await puppeteer.launch({
            headless: false,
            slowMo: 100,
            defaultViewport: { width: 1366, height: 768 },
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage'
            ]
        });
        this.page = await this.browser.newPage();
        
        // Enable request interception for debugging
        await this.page.setRequestInterception(true);
        this.page.on('request', request => {
            console.log(`🌐 Request: ${request.method()} ${request.url()}`);
            request.continue();
        });
        
        this.page.on('response', response => {
            console.log(`📥 Response: ${response.status()} ${response.url()}`);
        });

        // Set up screenshots directory
        const screenshotDir = path.join(__dirname, 'screenshots');
        if (!fs.existsSync(screenshotDir)) {
            fs.mkdirSync(screenshotDir);
        }
    }

    async takeScreenshot(name) {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const filename = `${name}_${timestamp}.png`;
        const filepath = path.join(__dirname, 'screenshots', filename);
        await this.page.screenshot({ path: filepath, fullPage: true });
        this.screenshots.push(filepath);
        console.log(`📸 Screenshot saved: ${filename}`);
        return filepath;
    }

    async testLoginPage() {
        console.log('\n🔍 Testing Login Page...');
        
        try {
            // Navigate to login page
            await this.page.goto('http://localhost/gabe/pages/login.php', {
                waitUntil: 'networkidle2'
            });
            
            await this.takeScreenshot('login_page_loaded');
            
            // Check if login form exists
            const loginForm = await this.page.$('form');
            const usernameInput = await this.page.$('input[name="username"]');
            const passwordInput = await this.page.$('input[name="password"]');
            const loginButton = await this.page.$('button[type="submit"], input[type="submit"]');
            
            const results = {
                test: 'Login Page Elements',
                loginFormExists: !!loginForm,
                usernameInputExists: !!usernameInput,
                passwordInputExists: !!passwordInput,
                loginButtonExists: !!loginButton,
                passed: !!(loginForm && usernameInput && passwordInput && loginButton)
            };
            
            this.testResults.push(results);
            console.log('✅ Login page elements check:', results);
            
            return results;
        } catch (error) {
            console.error('❌ Login page test failed:', error);
            this.testResults.push({
                test: 'Login Page Elements',
                error: error.message,
                passed: false
            });
            return null;
        }
    }

    async testAdminLogin() {
        console.log('\n🔍 Testing Admin Login...');
        
        try {
            // Fill in admin credentials
            await this.page.type('input[name="username"]', 'admin', { delay: 100 });
            await this.page.type('input[name="password"]', 'admin123', { delay: 100 });
            
            await this.takeScreenshot('admin_credentials_filled');
            
            // Click login button
            await Promise.all([
                this.page.waitForNavigation({ waitUntil: 'networkidle2' }),
                this.page.click('button[type="submit"], input[type="submit"]')
            ]);
            
            await this.takeScreenshot('admin_login_result');
            
            // Check if redirected to dashboard
            const currentUrl = this.page.url();
            const isLoggedIn = currentUrl.includes('dashboard') || currentUrl.includes('admin');
            
            const results = {
                test: 'Admin Login',
                currentUrl: currentUrl,
                isLoggedIn: isLoggedIn,
                passed: isLoggedIn
            };
            
            this.testResults.push(results);
            console.log('✅ Admin login test:', results);
            
            return results;
        } catch (error) {
            console.error('❌ Admin login test failed:', error);
            this.testResults.push({
                test: 'Admin Login',
                error: error.message,
                passed: false
            });
            return null;
        }
    }

    async testDashboardElements() {
        console.log('\n🔍 Testing Dashboard Elements...');
        
        try {
            // Wait for dashboard to load
            await this.page.waitForSelector('body', { timeout: 5000 });
            
            await this.takeScreenshot('dashboard_loaded');
            
            // Check for common dashboard elements
            const elements = {
                navigation: await this.page.$('nav, .navbar, .sidebar'),
                dashboardTitle: await this.page.$('h1, .dashboard-title, .page-title'),
                userMenu: await this.page.$('.user-menu, .dropdown, .profile'),
                logoutButton: await this.page.$('a[href*="logout"], button[href*="logout"]')
            };
            
            const results = {
                test: 'Dashboard Elements',
                hasNavigation: !!elements.navigation,
                hasDashboardTitle: !!elements.dashboardTitle,
                hasUserMenu: !!elements.userMenu,
                hasLogoutButton: !!elements.logoutButton,
                passed: !!(elements.navigation && elements.dashboardTitle)
            };
            
            this.testResults.push(results);
            console.log('✅ Dashboard elements check:', results);
            
            return results;
        } catch (error) {
            console.error('❌ Dashboard test failed:', error);
            this.testResults.push({
                test: 'Dashboard Elements',
                error: error.message,
                passed: false
            });
            return null;
        }
    }

    async testLogout() {
        console.log('\n🔍 Testing Logout...');
        
        try {
            // Look for logout button/link
            const logoutSelectors = [
                'a[href="/gabe/logout.php"]',
                'a[href*="logout"]',
                'button[href*="logout"]',
                '.logout',
                '[onclick*="logout"]'
            ];
            
            let logoutElement = null;
            for (const selector of logoutSelectors) {
                logoutElement = await this.page.$(selector);
                if (logoutElement) break;
            }
            
            if (logoutElement) {
                await this.takeScreenshot('before_logout');
                
                // Check if it's in a dropdown and handle dropdown
                const isDropdownChild = await this.page.evaluate((el) => {
                    const dropdown = el.closest('.dropdown-menu');
                    return dropdown !== null;
                }, logoutElement);
                
                if (isDropdownChild) {
                    // Find and click the dropdown toggle first
                    const dropdownToggle = await this.page.$('#userDropdown, .dropdown-toggle[href="#"], .nav-link.dropdown-toggle');
                    if (dropdownToggle) {
                        await dropdownToggle.click();
                        await this.page.waitForTimeout(1500); // Increased wait time
                        await this.takeScreenshot('dropdown_opened');
                        
                        // Wait for dropdown menu to be visible with better selector
                        try {
                            await this.page.waitForSelector('.dropdown-menu.show', { visible: true, timeout: 5000 });
                        } catch (e) {
                            // Try alternative dropdown selector
                            await this.page.waitForSelector('.dropdown-menu[style*="display: block"], .dropdown-menu.show', { visible: true, timeout: 3000 });
                        }
                        
                        // Find logout link again after dropdown is open with multiple selectors
                        logoutElement = await this.page.$('a[href="/gabe/logout.php"]');
                        if (!logoutElement) {
                            logoutElement = await this.page.$('.dropdown-menu a[href*="logout"]');
                        }
                        if (!logoutElement) {
                            logoutElement = await this.page.$('a:contains("Logout"), a:contains("Keluar")');
                        }
                        
                        // Additional wait for logout link to be clickable
                        if (logoutElement) {
                            await this.page.waitForTimeout(500);
                        }
                    }
                }
                
                // Click logout
                await Promise.all([
                    this.page.waitForNavigation({ waitUntil: 'networkidle2' }),
                    logoutElement.click()
                ]);
                
                await this.takeScreenshot('after_logout');
                
                const currentUrl = this.page.url();
                const isLoggedOut = currentUrl.includes('login') || currentUrl.includes('auth');
                
                const results = {
                    test: 'Logout',
                    currentUrl: currentUrl,
                    isLoggedOut: isLoggedOut,
                    passed: isLoggedOut
                };
                
                this.testResults.push(results);
                console.log('✅ Logout test:', results);
                
                return results;
            } else {
                console.log('⚠️ Logout element not found');
                this.testResults.push({
                    test: 'Logout',
                    error: 'Logout element not found',
                    passed: false
                });
                return null;
            }
        } catch (error) {
            console.error('❌ Logout test failed:', error);
            this.testResults.push({
                test: 'Logout',
                error: error.message,
                passed: false
            });
            return null;
        }
    }

    async generateReport() {
        console.log('\n📊 Generating Test Report...');
        
        const report = {
            timestamp: new Date().toISOString(),
            summary: {
                totalTests: this.testResults.length,
                passedTests: this.testResults.filter(r => r.passed).length,
                failedTests: this.testResults.filter(r => !r.passed).length
            },
            results: this.testResults,
            screenshots: this.screenshots
        };
        
        const reportPath = path.join(__dirname, 'puppeteer-test-report.json');
        fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
        
        console.log(`📄 Report saved to: ${reportPath}`);
        console.log(`📸 Screenshots saved: ${this.screenshots.length} files`);
        console.log(`✅ Passed: ${report.summary.passedTests}/${report.summary.totalTests}`);
        
        return report;
    }

    async cleanup() {
        if (this.browser) {
            await this.browser.close();
            console.log('🔚 Browser closed');
        }
    }

    async runFullTest() {
        try {
            await this.setup();
            await this.testLoginPage();
            await this.testAdminLogin();
            await this.testDashboardElements();
            await this.testLogout();
            const report = await this.generateReport();
            return report;
        } catch (error) {
            console.error('❌ Test execution failed:', error);
            return null;
        } finally {
            await this.cleanup();
        }
    }
}

// Run tests if this file is executed directly
if (require.main === module) {
    const test = new LoginTest();
    test.runFullTest().then(report => {
        if (report) {
            console.log('\n🎉 All tests completed!');
            process.exit(report.summary.failedTests > 0 ? 1 : 0);
        } else {
            console.log('\n💥 Test execution failed!');
            process.exit(1);
        }
    });
}

module.exports = LoginTest;
