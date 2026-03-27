const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

class MobileTest {
    constructor() {
        this.browser = null;
        this.page = null;
        this.testResults = [];
        this.screenshots = [];
    }

    async setup() {
        console.log('🚀 Starting browser for mobile test...');
        this.browser = await puppeteer.launch({
            headless: false,
            slowMo: 100,
            defaultViewport: { width: 375, height: 667 }, // iPhone SE size
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage',
                '--user-agent=Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1'
            ]
        });
        this.page = await this.browser.newPage();
        
        const screenshotDir = path.join(__dirname, 'screenshots');
        if (!fs.existsSync(screenshotDir)) {
            fs.mkdirSync(screenshotDir);
        }
    }

    async takeScreenshot(name) {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const filename = `mobile_${name}_${timestamp}.png`;
        const filepath = path.join(__dirname, 'screenshots', filename);
        await this.page.screenshot({ path: filepath, fullPage: true });
        this.screenshots.push(filepath);
        console.log(`📸 Screenshot saved: ${filename}`);
        return filepath;
    }

    async login() {
        console.log('🔐 Logging in as admin on mobile...');
        await this.page.goto('http://localhost/gabe/pages/login.php', {
            waitUntil: 'networkidle2'
        });
        
        await this.page.type('input[name="username"]', 'admin', { delay: 100 });
        await this.page.type('input[name="password"]', 'admin123', { delay: 100 });
        
        await Promise.all([
            this.page.waitForNavigation({ waitUntil: 'networkidle2' }),
            this.page.click('button[type="submit"], input[type="submit"]')
        ]);
        
        await this.takeScreenshot('mobile_logged_in_dashboard');
    }

    async testMobileLogin() {
        console.log('\n🔍 Testing Mobile Login Experience...');
        
        try {
            // Navigate to login page first
            await this.page.goto('http://localhost/gabe/pages/login.php', {
                waitUntil: 'networkidle2'
            });
            
            await this.takeScreenshot('mobile_login_page');
            
            // Check if login form is mobile-friendly
            const loginFormMobile = await this.page.evaluate(() => {
                const form = document.querySelector('form');
                const inputs = document.querySelectorAll('input[type="text"], input[type="password"]');
                const button = document.querySelector('button[type="submit"], input[type="submit"]');
                
                return {
                    hasForm: !!form,
                    inputCount: inputs.length,
                    hasSubmitButton: !!button,
                    viewportWidth: window.innerWidth,
                    isMobileViewport: window.innerWidth <= 768,
                    formAction: form ? form.action : null,
                    formMethod: form ? form.method : null
                };
            });
            
            const results = {
                test: 'Mobile Login Form',
                hasForm: loginFormMobile.hasForm,
                inputCount: loginFormMobile.inputCount,
                hasSubmitButton: loginFormMobile.hasSubmitButton,
                viewportWidth: loginFormMobile.viewportWidth,
                isMobileViewport: loginFormMobile.isMobileViewport,
                passed: loginFormMobile.hasForm && loginFormMobile.hasSubmitButton && loginFormMobile.inputCount >= 2
            };
            
            this.testResults.push(results);
            console.log('✅ Mobile login form test:', results);
            
            // Test login functionality on mobile
            if (loginFormMobile.hasForm && loginFormMobile.inputCount >= 2) {
                await this.page.type('input[name="username"]', 'admin', { delay: 100 });
                await this.page.type('input[name="password"]', 'admin123', { delay: 100 });
                
                await Promise.all([
                    this.page.waitForNavigation({ waitUntil: 'networkidle2' }),
                    this.page.click('button[type="submit"], input[type="submit"]')
                ]);
                
                await this.takeScreenshot('mobile_login_success');
                
                const loginSuccess = await this.page.evaluate(() => {
                    const currentUrl = window.location.href;
                    return currentUrl.includes('dashboard') || !currentUrl.includes('login');
                });
                
                const loginResults = {
                    test: 'Mobile Login Functionality',
                    loginSuccess: loginSuccess,
                    currentUrl: this.page.url(),
                    passed: loginSuccess
                };
                
                this.testResults.push(loginResults);
                console.log('✅ Mobile login functionality test:', loginResults);
            }
            
        } catch (error) {
            console.error('❌ Mobile login test failed:', error.message);
            this.testResults.push({
                test: 'Mobile Login Form',
                error: error.message,
                passed: false
            });
        }
    }

    async testMobileNavigation() {
        console.log('\n🔍 Testing Mobile Navigation...');
        
        try {
            // Check if navigation is mobile-friendly
            const mobileNav = await this.page.evaluate(() => {
                const navbar = document.querySelector('.navbar');
                const navbarToggler = document.querySelector('.navbar-toggler');
                const navbarCollapse = document.querySelector('.navbar-collapse');
                const navLinks = document.querySelectorAll('.navbar-nav .nav-link');
                
                return {
                    hasNavbar: !!navbar,
                    hasNavbarToggler: !!navbarToggler,
                    hasNavbarCollapse: !!navbarCollapse,
                    navLinkCount: navLinks.length,
                    isCollapsed: navbarCollapse ? navbarCollapse.classList.contains('collapse') : false
                };
            });
            
            const results = {
                test: 'Mobile Navigation',
                hasNavbar: mobileNav.hasNavbar,
                hasNavbarToggler: mobileNav.hasNavbarToggler,
                hasNavbarCollapse: mobileNav.hasNavbarCollapse,
                navLinkCount: mobileNav.navLinkCount,
                isCollapsed: mobileNav.isCollapsed,
                passed: mobileNav.hasNavbar && mobileNav.hasNavbarToggler
            };
            
            this.testResults.push(results);
            console.log('✅ Mobile navigation test:', results);
            
            // Test mobile menu toggle
            if (mobileNav.hasNavbarToggler) {
                await this.takeScreenshot('mobile_menu_before_toggle');
                
                await this.page.click('.navbar-toggler');
                await this.page.waitForTimeout(500);
                
                await this.takeScreenshot('mobile_menu_after_toggle');
                
                const menuExpanded = await this.page.evaluate(() => {
                    const navbarCollapse = document.querySelector('.navbar-collapse');
                    return navbarCollapse ? navbarCollapse.classList.contains('show') : false;
                });
                
                const toggleResults = {
                    test: 'Mobile Menu Toggle',
                    menuExpanded: menuExpanded,
                    passed: menuExpanded
                };
                
                this.testResults.push(toggleResults);
                console.log('✅ Mobile menu toggle test:', toggleResults);
            }
            
        } catch (error) {
            console.error('❌ Mobile navigation test failed:', error.message);
            this.testResults.push({
                test: 'Mobile Navigation',
                error: error.message,
                passed: false
            });
        }
    }

    async testMobileDashboard() {
        console.log('\n🔍 Testing Mobile Dashboard...');
        
        try {
            // Check if dashboard is mobile-friendly
            const mobileDashboard = await this.page.evaluate(() => {
                const cards = document.querySelectorAll('.card');
                const tables = document.querySelectorAll('.table');
                const charts = document.querySelectorAll('canvas');
                const container = document.querySelector('.container-fluid');
                
                return {
                    cardCount: cards.length,
                    tableCount: tables.length,
                    chartCount: charts.length,
                    hasContainer: !!container,
                    containerPadding: container ? window.getComputedStyle(container).padding : null
                };
            });
            
            const results = {
                test: 'Mobile Dashboard Layout',
                cardCount: mobileDashboard.cardCount,
                tableCount: mobileDashboard.tableCount,
                chartCount: mobileDashboard.chartCount,
                hasContainer: mobileDashboard.hasContainer,
                passed: mobileDashboard.hasContainer && mobileDashboard.cardCount > 0
            };
            
            this.testResults.push(results);
            console.log('✅ Mobile dashboard test:', results);
            
        } catch (error) {
            console.error('❌ Mobile dashboard test failed:', error.message);
            this.testResults.push({
                test: 'Mobile Dashboard Layout',
                error: error.message,
                passed: false
            });
        }
    }

    async testMobileForms() {
        console.log('\n🔍 Testing Mobile Forms...');
        
        try {
            // Navigate to members page
            await this.page.goto('http://localhost/gabe/pages/members.php', {
                waitUntil: 'networkidle2'
            });
            
            await this.takeScreenshot('mobile_members_page');
            
            // Check form elements for mobile usability
            const mobileForms = await this.page.evaluate(() => {
                const inputs = document.querySelectorAll('input, select, textarea');
                const buttons = document.querySelectorAll('button, .btn');
                const forms = document.querySelectorAll('form');
                
                let touchFriendlyInputs = 0;
                inputs.forEach(input => {
                    const style = window.getComputedStyle(input);
                    const height = parseInt(style.height);
                    if (height >= 44) touchFriendlyInputs++; // 44px minimum touch target
                });
                
                return {
                    inputCount: inputs.length,
                    buttonCount: buttons.length,
                    formCount: forms.length,
                    touchFriendlyInputs: touchFriendlyInputs,
                    touchFriendlyRatio: inputs.length > 0 ? touchFriendlyInputs / inputs.length : 0
                };
            });
            
            const results = {
                test: 'Mobile Form Usability',
                inputCount: mobileForms.inputCount,
                buttonCount: mobileForms.buttonCount,
                touchFriendlyInputs: mobileForms.touchFriendlyInputs,
                touchFriendlyRatio: Math.round(mobileForms.touchFriendlyRatio * 100),
                passed: mobileForms.touchFriendlyRatio >= 0.8 // 80% should be touch-friendly
            };
            
            this.testResults.push(results);
            console.log('✅ Mobile forms test:', results);
            
        } catch (error) {
            console.error('❌ Mobile forms test failed:', error.message);
            this.testResults.push({
                test: 'Mobile Form Usability',
                error: error.message,
                passed: false
            });
        }
    }

    async testMobileTouchTargets() {
        console.log('\n🔍 Testing Mobile Touch Targets...');
        
        try {
            // Check touch target sizes
            const touchTargets = await this.page.evaluate(() => {
                const clickableElements = document.querySelectorAll('a, button, input[type="submit"], input[type="button"], .btn');
                let validTargets = 0;
                let invalidTargets = 0;
                
                clickableElements.forEach(element => {
                    const rect = element.getBoundingClientRect();
                    const minDimension = Math.min(rect.width, rect.height);
                    
                    if (minDimension >= 44) { // 44px minimum for touch
                        validTargets++;
                    } else {
                        invalidTargets++;
                    }
                });
                
                return {
                    totalTargets: clickableElements.length,
                    validTargets: validTargets,
                    invalidTargets: invalidTargets,
                    validRatio: clickableElements.length > 0 ? validTargets / clickableElements.length : 0
                };
            });
            
            const results = {
                test: 'Mobile Touch Targets',
                totalTargets: touchTargets.totalTargets,
                validTargets: touchTargets.validTargets,
                invalidTargets: touchTargets.invalidTargets,
                validRatio: Math.round(touchTargets.validRatio * 100),
                passed: touchTargets.validRatio >= 0.9 // 90% should be valid
            };
            
            this.testResults.push(results);
            console.log('✅ Mobile touch targets test:', results);
            
        } catch (error) {
            console.error('❌ Mobile touch targets test failed:', error.message);
            this.testResults.push({
                test: 'Mobile Touch Targets',
                error: error.message,
                passed: false
            });
        }
    }

    async generateReport() {
        console.log('\n📊 Generating Mobile Test Report...');
        
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
        
        const reportPath = path.join(__dirname, 'mobile-test-report.json');
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
            await this.login();
            await this.testMobileLogin();
            await this.testMobileNavigation();
            await this.testMobileDashboard();
            await this.testMobileForms();
            await this.testMobileTouchTargets();
            const report = await this.generateReport();
            return report;
        } catch (error) {
            console.error('❌ Mobile test execution failed:', error);
            return null;
        } finally {
            await this.cleanup();
        }
    }
}

// Run tests if this file is executed directly
if (require.main === module) {
    const test = new MobileTest();
    test.runFullTest().then(report => {
        if (report) {
            console.log('\n🎉 Mobile tests completed!');
            process.exit(report.summary.failedTests > 0 ? 1 : 0);
        } else {
            console.log('\n💥 Mobile test execution failed!');
            process.exit(1);
        }
    });
}

module.exports = MobileTest;
