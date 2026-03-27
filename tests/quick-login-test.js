const puppeteer = require('puppeteer');

async function quickLoginTest() {
    console.log('🧪 Starting Quick Login Demo Test...');
    
    let browser;
    let page;
    
    try {
        browser = await puppeteer.launch({
            headless: false,
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        
        page = await browser.newPage();
        
        // Test quick login page
        console.log('📱 Testing quick login page...');
        await page.goto('http://localhost/gabe/pages/quick_login.php');
        
        await page.waitForSelector('body', { timeout: 10000 });
        console.log('✅ Quick login page loaded');
        
        // Get page title
        const pageTitle = await page.title();
        console.log('Page title:', pageTitle);
        
        // Test role cards
        const roleCards = await page.$$('.role-card');
        console.log(`Found ${roleCards.length} role cards`);
        
        // Test each role
        const roles = [
            { username: 'admin', password: 'admin', role: 'Administrator' },
            { username: 'manager', password: 'manager', role: 'Manager' },
            { username: 'branch_head', password: 'branch_head', role: 'Branch Head' },
            { username: 'collector', password: 'collector', role: 'Collector' },
            { username: 'cashier', password: 'cashier', role: 'Cashier' },
            { username: 'staff', password: 'staff', role: 'Staff' }
        ];
        
        for (const role of roles) {
            console.log(`\n🔐 Testing ${role.role} role...`);
            
            // Go back to login page
            await page.goto('http://localhost/gabe/pages/login.php');
            await page.waitForSelector('.login-container');
            
            // Fill credentials
            await page.type('#username', role.username);
            await page.type('#password', role.password);
            await page.click('button[type="submit"]');
            
            // Wait for navigation
            await page.waitForNavigation({ waitUntil: 'networkidle0', timeout: 10000 });
            
            const currentUrl = page.url();
            if (currentUrl.includes('dashboard')) {
                console.log(`✅ ${role.role} login successful`);
            } else {
                console.log(`❌ ${role.role} login failed`);
            }
            
            // Logout for next test
            if (currentUrl.includes('dashboard')) {
                try {
                    // Try to find logout link or button
                    const logoutSelectors = [
                        'a[href*="logout"]',
                        'button[onclick*="logout"]',
                        '[data-action="logout"]',
                        '.logout'
                    ];
                    
                    let logoutFound = false;
                    for (const selector of logoutSelectors) {
                        const logoutElement = await page.$(selector);
                        if (logoutElement) {
                            await logoutElement.click();
                            await page.waitForNavigation({ timeout: 5000 });
                            logoutFound = true;
                            break;
                        }
                    }
                    
                    if (!logoutFound) {
                        console.log(`⚠️ No logout button found for ${role.role}`);
                    }
                } catch (error) {
                    console.log(`⚠️ Logout failed for ${role.role}`);
                }
            }
        }
        
        console.log('\n🎉 Quick login demo test completed!');
        
    } catch (error) {
        console.error('❌ Test failed:', error.message);
        
        if (page) {
            await page.screenshot({ 
                path: '/opt/lampp/htdocs/gabe/tests/screenshots/quick-login-error.png' 
            });
        }
    } finally {
        if (browser) {
            await browser.close();
        }
    }
}

// Run test
quickLoginTest();
