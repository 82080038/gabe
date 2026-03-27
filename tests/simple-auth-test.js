const puppeteer = require('puppeteer');

async function simpleAuthTest() {
    console.log('🧪 Starting simple authentication test...');
    
    let browser;
    let page;
    
    try {
        // Launch browser
        browser = await puppeteer.launch({
            headless: false, // Show browser for debugging
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        
        page = await browser.newPage();
        await page.setViewport({ width: 1920, height: 1080 });
        
        // Test 1: Login page accessibility
        console.log('📍 Testing login page accessibility...');
        await page.goto('http://localhost/gabe/pages/login.php');
        
        // Wait for page to load
        await page.waitForSelector('body', { timeout: 10000 });
        
        // Check if login container exists
        const loginContainer = await page.$('.login-container');
        if (loginContainer) {
            console.log('✅ Login container found');
        } else {
            console.log('❌ Login container not found');
        }
        
        // Check if form elements exist
        const usernameField = await page.$('#username');
        const passwordField = await page.$('#password');
        const submitButton = await page.$('button[type="submit"]');
        
        console.log('Form elements check:');
        console.log('  Username field:', usernameField ? '✅' : '❌');
        console.log('  Password field:', passwordField ? '✅' : '❌');
        console.log('  Submit button:', submitButton ? '✅' : '❌');
        
        // Test 2: Login with admin credentials
        console.log('🔐 Testing admin login...');
        
        if (usernameField && passwordField && submitButton) {
            await page.type('#username', 'admin');
            await page.type('#password', 'admin');
            await page.click('button[type="submit"]');
            
            // Wait for redirect or response
            await page.waitForNavigation({ timeout: 10000 });
            
            const currentUrl = page.url();
            console.log('Current URL after login:', currentUrl);
            
            if (currentUrl.includes('dashboard')) {
                console.log('✅ Login successful - redirected to dashboard');
            } else {
                console.log('❌ Login failed - not redirected to dashboard');
            }
        }
        
        // Take screenshot
        await page.screenshot({ path: 'simple-auth-test.png', fullPage: true });
        console.log('📸 Screenshot saved: simple-auth-test.png');
        
    } catch (error) {
        console.error('❌ Test failed:', error.message);
        
        // Take screenshot on error
        if (page) {
            await page.screenshot({ path: 'simple-auth-error.png', fullPage: true });
            console.log('📸 Error screenshot saved: simple-auth-error.png');
        }
    } finally {
        if (browser) {
            await browser.close();
        }
    }
    
    console.log('🏁 Simple authentication test completed');
}

// Run the test
simpleAuthTest().catch(console.error);
