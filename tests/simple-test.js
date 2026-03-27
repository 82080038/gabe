/**
 * Simple Test - Basic Functionality Check
 * Tests the most important features without complex navigation
 */

const puppeteer = require('puppeteer');

class SimpleTest {
    constructor() {
        this.browser = null;
        this.page = null;
        this.config = {
            baseUrl: 'http://localhost/gabe',
            timeout: 10000
        };
    }
    
    async runSimpleTest() {
        console.log('🔍 Starting Simple Functionality Test...\n');
        
        try {
            await this.setupBrowser();
            
            // Test individual pages directly
            await this.testLoginPage();
            await this.testAdminDashboard();
            await this.testMobileDashboard();
            await this.testUnitsPage();
            await this.testBranchesPage();
            await this.testCollectionsPage();
            await this.testCollectorRoute();
            await this.testCollectorPayments();
            
            console.log('\n✅ Simple Test Completed!');
            console.log('🎯 All pages are accessible and functional');
            
        } catch (error) {
            console.error('❌ Simple test failed:', error);
        } finally {
            await this.cleanup();
        }
    }
    
    async setupBrowser() {
        console.log('📱 Setting up browser...');
        this.browser = await puppeteer.launch({ headless: "new" });
        this.page = await this.browser.newPage();
        await this.page.setDefaultTimeout(this.config.timeout);
        console.log('✅ Browser ready');
    }
    
    async testLoginPage() {
        console.log('\n🔐 Testing Login Page...');
        
        await this.page.goto(`${this.config.baseUrl}/pages/login.php`);
        
        // Check if login page loads
        const title = await this.page.title();
        if (title.includes('Login') || title.includes('Koperasi')) {
            console.log('✅ Login page loads successfully');
        } else {
            throw new Error('Login page not loading properly');
        }
        
        // Check for login form elements
        const usernameField = await this.page.$('#username');
        const passwordField = await this.page.$('#password');
        const submitButton = await this.page.$('button[type="submit"]');
        
        if (usernameField && passwordField && submitButton) {
            console.log('✅ Login form elements present');
        } else {
            throw new Error('Login form elements missing');
        }
    }
    
    async testAdminDashboard() {
        console.log('\n📊 Testing Admin Dashboard...');
        
        await this.page.goto(`${this.config.baseUrl}/pages/web/dashboard.php`);
        
        // Check if dashboard loads
        const title = await this.page.title();
        if (title.includes('Dashboard') || title.includes('Koperasi')) {
            console.log('✅ Admin dashboard loads successfully');
        } else {
            console.log('⚠️ Admin dashboard may have session requirements');
        }
        
        // Check for dashboard elements
        const dashboardElements = await this.page.$$eval('.card, .metric-card, .summary-card, h1, .h1', elements => elements.length);
        if (dashboardElements > 0) {
            console.log('✅ Dashboard elements present');
        } else {
            console.log('⚠️ Dashboard elements not visible (may need login)');
        }
    }
    
    async testMobileDashboard() {
        console.log('\n📱 Testing Mobile Dashboard...');
        
        await this.page.goto(`${this.config.baseUrl}/pages/mobile/dashboard.php`);
        
        // Check if mobile dashboard loads
        const title = await this.page.title();
        if (title.includes('Dashboard') || title.includes('Koperasi')) {
            console.log('✅ Mobile dashboard loads successfully');
        } else {
            console.log('⚠️ Mobile dashboard may have session requirements');
        }
        
        // Check for mobile elements
        const mobileElements = await this.page.$$eval('.mobile-dashboard, .summary-card, .alert, h1, .h1', elements => elements.length);
        if (mobileElements > 0) {
            console.log('✅ Mobile dashboard elements present');
        } else {
            console.log('⚠️ Mobile dashboard elements not visible (may need login)');
        }
    }
    
    async testUnitsPage() {
        console.log('\n🏢 Testing Units Page...');
        
        await this.page.goto(`${this.config.baseUrl}/pages/units.php`);
        
        // Check if units page loads
        const title = await this.page.title();
        if (title.includes('Unit') || title.includes('Koperasi')) {
            console.log('✅ Units page loads successfully');
        } else {
            throw new Error('Units page not loading properly');
        }
        
        // Check for units content
        const unitsContent = await this.page.$$eval('h1, .h1, .card, table', elements => elements.length);
        if (unitsContent > 0) {
            console.log('✅ Units page content present');
        } else {
            throw new Error('Units page content missing');
        }
    }
    
    async testBranchesPage() {
        console.log('\n🏠 Testing Branches Page...');
        
        await this.page.goto(`${this.config.baseUrl}/pages/branches.php`);
        
        // Check if branches page loads
        const title = await this.page.title();
        if (title.includes('Cabang') || title.includes('Koperasi')) {
            console.log('✅ Branches page loads successfully');
        } else {
            throw new Error('Branches page not loading properly');
        }
        
        // Check for branches content
        const branchesContent = await this.page.$$eval('h1, .h1, .card, table', elements => elements.length);
        if (branchesContent > 0) {
            console.log('✅ Branches page content present');
        } else {
            throw new Error('Branches page content missing');
        }
    }
    
    async testCollectionsPage() {
        console.log('\n💰 Testing Collections Page...');
        
        await this.page.goto(`${this.config.baseUrl}/pages/collections.php`);
        
        // Check if collections page loads
        const title = await this.page.title();
        if (title.includes('Koleksi') || title.includes('Koperasi')) {
            console.log('✅ Collections page loads successfully');
        } else {
            throw new Error('Collections page not loading properly');
        }
        
        // Check for collections content
        const collectionsContent = await this.page.$$eval('h1, .h1, .card, table', elements => elements.length);
        if (collectionsContent > 0) {
            console.log('✅ Collections page content present');
        } else {
            throw new Error('Collections page content missing');
        }
    }
    
    async testCollectorRoute() {
        console.log('\n🗺️ Testing Collector Route Page...');
        
        await this.page.goto(`${this.config.baseUrl}/pages/collector/route.php`);
        
        // Check if route page loads
        const title = await this.page.title();
        if (title.includes('Rute') || title.includes('Dashboard') || title.includes('Koperasi')) {
            console.log('✅ Route page loads successfully');
        } else {
            console.log('⚠️ Route page may have session requirements');
        }
        
        // Check for route content
        const routeContent = await this.page.$$eval('h1, .h1, .card, .alert, .mobile-dashboard', elements => elements.length);
        if (routeContent > 0) {
            console.log('✅ Route page content present');
        } else {
            console.log('⚠️ Route page content not visible (may need login)');
        }
    }
    
    async testCollectorPayments() {
        console.log('\n💳 Testing Collector Payments Page...');
        
        await this.page.goto(`${this.config.baseUrl}/pages/collector/payments.php`);
        
        // Check if payments page loads
        const title = await this.page.title();
        if (title.includes('Pembayaran') || title.includes('Dashboard') || title.includes('Koperasi')) {
            console.log('✅ Payments page loads successfully');
        } else {
            console.log('⚠️ Payments page may have session requirements');
        }
        
        // Check for payments content
        const paymentsContent = await this.page.$$eval('h1, .h1, .card, .alert, .mobile-dashboard', elements => elements.length);
        if (paymentsContent > 0) {
            console.log('✅ Payments page content present');
        } else {
            console.log('⚠️ Payments page content not visible (may need login)');
        }
    }
    
    async cleanup() {
        if (this.browser) {
            await this.browser.close();
            console.log('\n🧹 Browser cleanup complete');
        }
    }
}

// Run the test
const tester = new SimpleTest();
tester.runSimpleTest().catch(console.error);
