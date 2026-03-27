const puppeteer = require('puppeteer');

async function simpleAuthTest() {
    console.log('🧪 Starting Simple Authentication Test...');
    
    let browser;
    let page;
    
    try {
        // Setup browser
        browser = await puppeteer.launch({
            headless: false,
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        
        page = await browser.newPage();
        
        // Test 1: Access login page
        console.log('📱 Testing login page access...');
        await page.goto('http://localhost/gabe/pages/login.php');
        
        // Wait for login container
        await page.waitForSelector('.login-container', { timeout: 10000 });
        console.log('✅ Login page loaded successfully');
        
        // Test 2: Fill login form
        console.log('🔐 Testing login form...');
        await page.type('#username', 'admin');
        await page.type('#password', 'admin');
        
        // Submit form
        await page.click('button[type="submit"]');
        
        // Wait for navigation
        await page.waitForNavigation({ waitUntil: 'networkidle0', timeout: 10000 });
        
        // Check if redirected to dashboard
        const currentUrl = page.url();
        if (currentUrl.includes('dashboard')) {
            console.log('✅ Login successful - redirected to dashboard');
        } else {
            console.log('❌ Login failed - still on login page');
            console.log('Current URL:', currentUrl);
        }
        
        // Test 3: Check dashboard content
        if (currentUrl.includes('dashboard')) {
            try {
                await page.waitForSelector('body', { timeout: 5000 });
                const pageTitle = await page.title();
                console.log('✅ Dashboard page title:', pageTitle);
            } catch (error) {
                console.log('⚠️ Dashboard loaded but content may be incomplete');
            }
        }
        
        console.log('🎉 Simple authentication test completed!');
        
    } catch (error) {
        console.error('❌ Test failed:', error.message);
        
        // Take screenshot on error
        if (page) {
            await page.screenshot({ 
                path: '/opt/lampp/htdocs/gabe/tests/screenshots/simple-auth-error.png' 
            });
        }
    } finally {
        if (browser) {
            await browser.close();
        }
    }
}

// Run test
simpleAuthTest();
