const puppeteer = require('puppeteer');

async function debugAuthTest() {
    console.log('🔍 Debug authentication test...');
    
    let browser;
    let page;
    
    try {
        browser = await puppeteer.launch({ 
            headless: false, 
            args: ['--no-sandbox', '--disable-setuid-sandbox'] 
        });
        page = await browser.newPage();
        
        // Enable request monitoring
        page.on('request', request => {
            console.log('📤 Request:', request.method(), request.url());
        });
        
        page.on('response', response => {
            console.log('📥 Response:', response.status(), response.url());
        });
        
        // Go to login page
        console.log('📍 Navigating to login page...');
        await page.goto('http://localhost/gabe/pages/login.php', { waitUntil: 'networkidle2' });
        
        // Fill login form
        console.log('📝 Filling login form...');
        await page.type('#username', 'admin', { delay: 100 });
        await page.type('#password', 'admin', { delay: 100 });
        
        // Submit form
        console.log('🚀 Submitting login form...');
        
        // Wait for navigation after form submission
        const navigationPromise = page.waitForNavigation({ waitUntil: 'networkidle2', timeout: 15000 });
        
        await Promise.all([
            navigationPromise,
            page.click('button[type="submit"]')
        ]);
        
        console.log('✅ Navigation completed');
        
        // Check current URL
        const currentUrl = page.url();
        console.log('🌐 Current URL:', currentUrl);
        
        // Check page content
        const title = await page.title();
        console.log('📄 Page title:', title);
        
        // Look for dashboard elements
        const dashboardContainer = await page.$('.container-fluid');
        const userInfo = await page.$('.alert-info');
        
        console.log('Dashboard elements found:');
        console.log('  Container:', dashboardContainer ? '✅' : '❌');
        console.log('  User info:', userInfo ? '✅' : '❌');
        
        // Take screenshot
        await page.screenshot({ path: 'debug-auth-success.png', fullPage: true });
        console.log('📸 Screenshot saved: debug-auth-success.png');
        
    } catch (error) {
        console.error('❌ Debug test failed:', error.message);
        
        if (page) {
            await page.screenshot({ path: 'debug-auth-error.png', fullPage: true });
            console.log('📸 Error screenshot saved: debug-auth-error.png');
        }
    } finally {
        if (browser) {
            await browser.close();
        }
    }
}

debugAuthTest().catch(console.error);
