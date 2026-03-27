/**
 * Simple Puppeteer Test Demo
 * This test demonstrates basic Puppeteer functionality
 */

const puppeteer = require('puppeteer');

class SimplePuppeteerTest {
    constructor() {
        this.browser = null;
        this.page = null;
    }

    async setupBrowser() {
        console.log('🚀 Setting up browser...');
        
        this.browser = await puppeteer.launch({
            headless: "new", // Use new headless mode
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });
        
        this.page = await this.browser.newPage();
        
        // Set viewport
        await this.page.setViewport({ width: 1920, height: 1080 });
        
        console.log('✅ Browser setup complete');
    }

    async testWebNavigation() {
        console.log('🌐 Testing web navigation...');
        
        try {
            // Navigate to a public website
            await this.page.goto('https://example.com', { waitUntil: 'networkidle2' });
            
            // Get page title
            const title = await this.page.title();
            console.log(`📄 Page title: ${title}`);
            
            // Take a screenshot
            await this.page.screenshot({ 
                path: 'screenshots/example-homepage.png',
                fullPage: true 
            });
            console.log('📸 Screenshot saved: screenshots/example-homepage.png');
            
            // Get page content
            const content = await this.page.content();
            console.log(`📝 Page content length: ${content.length} characters`);
            
            // Evaluate JavaScript in the page context
            const heading = await this.page.evaluate(() => {
                return document.querySelector('h1')?.textContent || 'No heading found';
            });
            console.log(`🎯 Main heading: ${heading}`);
            
            return true;
        } catch (error) {
            console.error('❌ Navigation test failed:', error.message);
            return false;
        }
    }

    async testFormInteraction() {
        console.log('📝 Testing form interaction...');
        
        try {
            // Navigate to a test form page
            await this.page.goto('https://www.google.com', { waitUntil: 'networkidle2' });
            
            // Find the search input and type something
            await this.page.waitForSelector('textarea[name="q"]');
            await this.page.type('textarea[name="q"]', 'Puppeteer testing', { delay: 100 });
            
            // Take screenshot of filled form
            await this.page.screenshot({ 
                path: 'screenshots/google-search-filled.png' 
            });
            console.log('📸 Form screenshot saved: screenshots/google-search-filled.png');
            
            // Clear the input
            await this.page.click('textarea[name="q"]');
            await this.page.keyboard.down('Control');
            await this.page.keyboard.press('a');
            await this.page.keyboard.up('Control');
            await this.page.keyboard.press('Backspace');
            
            console.log('✅ Form interaction test completed');
            return true;
        } catch (error) {
            console.error('❌ Form interaction test failed:', error.message);
            return false;
        }
    }

    async testMobileEmulation() {
        console.log('📱 Testing mobile emulation...');
        
        try {
            // Set mobile viewport
            await this.page.emulate(puppeteer.devices['iPhone 12']);
            
            // Navigate to a responsive website
            await this.page.goto('https://example.com', { waitUntil: 'networkidle2' });
            
            // Take mobile screenshot
            await this.page.screenshot({ 
                path: 'screenshots/example-mobile.png',
                fullPage: true 
            });
            console.log('📸 Mobile screenshot saved: screenshots/example-mobile.png');
            
            // Reset to desktop viewport
            await this.page.setViewport({ width: 1920, height: 1080 });
            
            console.log('✅ Mobile emulation test completed');
            return true;
        } catch (error) {
            console.error('❌ Mobile emulation test failed:', error.message);
            return false;
        }
    }

    async testPagePerformance() {
        console.log('⚡ Testing page performance metrics...');
        
        try {
            // Navigate to a page and get performance metrics
            await this.page.goto('https://example.com', { waitUntil: 'networkidle2' });
            
            const metrics = await this.page.metrics();
            console.log('📊 Performance Metrics:');
            console.log(`   - Timestamp: ${metrics.Timestamp}`);
            console.log(`   - Documents: ${metrics.Documents}`);
            console.log(`   - Frames: ${metrics.Frames}`);
            console.log(`   - JSEventListeners: ${metrics.JSEventListeners}`);
            console.log(`   - Nodes: ${metrics.Nodes}`);
            console.log(`   - LayoutCount: ${metrics.LayoutCount}`);
            console.log(`   - RecalcStyleCount: ${metrics.RecalcStyleCount}`);
            console.log(`   - LayoutDuration: ${metrics.LayoutDuration.toFixed(2)}ms`);
            console.log(`   - RecalcStyleDuration: ${metrics.RecalcStyleDuration.toFixed(2)}ms`);
            console.log(`   - ScriptDuration: ${metrics.ScriptDuration.toFixed(2)}ms`);
            console.log(`   - TaskDuration: ${metrics.TaskDuration.toFixed(2)}ms`);
            console.log(`   - JSHeapUsedSize: ${(metrics.JSHeapUsedSize / 1024 / 1024).toFixed(2)}MB`);
            console.log(`   - JSHeapTotalSize: ${(metrics.JSHeapTotalSize / 1024 / 1024).toFixed(2)}MB`);
            
            console.log('✅ Performance metrics test completed');
            return true;
        } catch (error) {
            console.error('❌ Performance metrics test failed:', error.message);
            return false;
        }
    }

    async cleanup() {
        console.log('🧹 Cleaning up...');
        
        if (this.browser) {
            await this.browser.close();
        }
        
        console.log('✅ Cleanup complete');
    }

    async runAllTests() {
        console.log('🎯 Starting Simple Puppeteer Test Demo\n');
        
        try {
            // Create screenshots directory
            const fs = require('fs');
            if (!fs.existsSync('screenshots')) {
                fs.mkdirSync('screenshots');
            }
            
            await this.setupBrowser();
            
            const tests = [
                { name: 'Web Navigation', fn: () => this.testWebNavigation() },
                { name: 'Form Interaction', fn: () => this.testFormInteraction() },
                { name: 'Mobile Emulation', fn: () => this.testMobileEmulation() },
                { name: 'Page Performance', fn: () => this.testPagePerformance() }
            ];
            
            let passedTests = 0;
            
            for (const test of tests) {
                console.log(`\n--- ${test.name} ---`);
                const result = await test.fn();
                if (result) {
                    passedTests++;
                    console.log(`✅ ${test.name} PASSED`);
                } else {
                    console.log(`❌ ${test.name} FAILED`);
                }
            }
            
            console.log(`\n📊 Test Results: ${passedTests}/${tests.length} tests passed`);
            
            if (passedTests === tests.length) {
                console.log('🎉 All tests completed successfully!');
            } else {
                console.log('⚠️  Some tests failed. Check the logs above.');
            }
            
        } catch (error) {
            console.error('💥 Test execution failed:', error);
        } finally {
            await this.cleanup();
        }
    }
}

// Run the tests
if (require.main === module) {
    const tester = new SimplePuppeteerTest();
    tester.runAllTests().catch(console.error);
}

module.exports = SimplePuppeteerTest;
