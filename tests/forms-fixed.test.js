const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

class FormsTest {
    constructor() {
        this.browser = null;
        this.page = null;
        this.testResults = [];
        this.screenshots = [];
    }

    async setup() {
        console.log('🚀 Starting browser for forms test...');
        this.browser = await puppeteer.launch({
            headless: false,
            slowMo: 100,
            defaultViewport: { width: 1366, height: 768 },
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage',
                '--disable-accelerated-2d-canvas',
                '--no-first-run',
                '--no-zygote',
                '--single-process',
                '--disable-gpu'
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
        const filename = `form_${name}_${timestamp}.png`;
        const filepath = path.join(__dirname, 'screenshots', filename);
        await this.page.screenshot({ path: filepath, fullPage: true });
        this.screenshots.push(filepath);
        console.log(`📸 Screenshot saved: ${filename}`);
        return filepath;
    }

    async login() {
        console.log('🔐 Logging in as admin...');
        await this.page.goto('http://localhost/gabe/pages/login.php', {
            waitUntil: 'networkidle2'
        });
        
        await this.page.type('input[name="username"]', 'admin', { delay: 100 });
        await this.page.type('input[name="password"]', 'admin123', { delay: 100 });
        
        await Promise.all([
            this.page.waitForNavigation({ waitUntil: 'networkidle2' }),
            this.page.click('button[type="submit"], input[type="submit"]')
        ]);
        
        await this.takeScreenshot('logged_in_dashboard');
    }

    async testMemberForm() {
        console.log('\n🔍 Testing Member Form...');
        
        try {
            // Try direct navigation to add member form
            console.log('📍 Navigating to member add form...');
            await this.page.goto('http://localhost/gabe/pages/members.php?action=add', {
                waitUntil: 'networkidle2'
            });
            
            await this.takeScreenshot('members_add_form_loaded');
            
            // Wait for form to load
            await this.page.waitForTimeout(2000);
            
            // Check for form elements
            const formElements = {
                nameInput: await this.page.$('input[name="name"]'),
                nikInput: await this.page.$('input[name="nik"]'),
                phoneInput: await this.page.$('input[name="phone"]'),
                addressInput: await this.page.$('textarea[name="address"]'),
                branchSelect: await this.page.$('select[name="branch"]'),
                submitButton: await this.page.$('button[type="submit"]')
            };
            
            const results = {
                test: 'Member Form Elements',
                hasNameInput: !!formElements.nameInput,
                hasNikInput: !!formElements.nikInput,
                hasPhoneInput: !!formElements.phoneInput,
                hasAddressInput: !!formElements.addressInput,
                hasBranchSelect: !!formElements.branchSelect,
                hasSubmitButton: !!formElements.submitButton,
                passed: !!(formElements.nameInput && formElements.submitButton)
            };
            
            this.testResults.push(results);
            console.log('✅ Member form elements:', results);
            
            // Test form validation
            if (formElements.submitButton) {
                await this.takeScreenshot('form_before_validation');
                
                // Try to submit empty form
                await formElements.submitButton.click();
                await this.page.waitForTimeout(1000);
                
                await this.takeScreenshot('form_after_empty_submit');
                
                // Check for validation
                const validationActive = await this.page.evaluate(() => {
                    const invalidInputs = document.querySelectorAll(':invalid');
                    if (invalidInputs.length > 0) return true;
                    
                    const errorElements = document.querySelectorAll('.error, .alert-danger, .validation-message, .invalid-feedback');
                    return errorElements.length > 0;
                });
                
                const validationResults = {
                    test: 'Member Form Validation',
                    validationActive: validationActive,
                    passed: validationActive
                };
                
                this.testResults.push(validationResults);
                console.log('✅ Form validation test:', validationResults);
            }
            
        } catch (error) {
            console.error('❌ Member form test failed:', error.message);
            this.testResults.push({
                test: 'Member Form',
                error: error.message,
                passed: false
            });
        }
    }

    async testLoanForm() {
        console.log('\n🔍 Testing Loan Form...');
        
        try {
            // Try direct navigation to loan application form
            console.log('📍 Navigating to loan application form...');
            await this.page.goto('http://localhost/gabe/pages/loans.php?action=apply', {
                waitUntil: 'networkidle2'
            });
            
            await this.takeScreenshot('loans_apply_form_loaded');
            
            // Wait for form to load
            await this.page.waitForTimeout(2000);
            
            // Check for loan form elements
            const formElements = {
                memberSelect: await this.page.$('select[name="member_id"]'),
                amountInput: await this.page.$('input[name="amount"]'),
                interestInput: await this.page.$('input[name="interest_rate"]'),
                termInput: await this.page.$('input[name="term"]'),
                purposeInput: await this.page.$('textarea[name="purpose"]'),
                submitButton: await this.page.$('button[type="submit"]')
            };
            
            const results = {
                test: 'Loan Form Elements',
                hasMemberSelect: !!formElements.memberSelect,
                hasAmountInput: !!formElements.amountInput,
                hasInterestInput: !!formElements.interestInput,
                hasTermInput: !!formElements.termInput,
                hasPurposeInput: !!formElements.purposeInput,
                hasSubmitButton: !!formElements.submitButton,
                passed: !!(formElements.memberSelect && formElements.amountInput && formElements.submitButton)
            };
            
            this.testResults.push(results);
            console.log('✅ Loan form elements:', results);
            
            // Test form validation
            if (formElements.submitButton) {
                await this.takeScreenshot('loan_form_before_validation');
                
                // Try to submit empty form
                await formElements.submitButton.click();
                await this.page.waitForTimeout(1000);
                
                await this.takeScreenshot('loan_form_after_empty_submit');
                
                // Check for validation
                const validationActive = await this.page.evaluate(() => {
                    const invalidInputs = document.querySelectorAll(':invalid');
                    if (invalidInputs.length > 0) return true;
                    
                    const errorElements = document.querySelectorAll('.error, .alert-danger, .validation-message, .invalid-feedback');
                    return errorElements.length > 0;
                });
                
                const validationResults = {
                    test: 'Loan Form Validation',
                    validationActive: validationActive,
                    passed: validationActive
                };
                
                this.testResults.push(validationResults);
                console.log('✅ Loan form validation test:', validationResults);
            }
            
        } catch (error) {
            console.error('❌ Loan form test failed:', error.message);
            this.testResults.push({
                test: 'Loan Form',
                error: error.message,
                passed: false
            });
        }
    }

    async testSearchForms() {
        console.log('\n🔍 Testing Search Forms...');
        
        try {
            // Navigate to members page to check for search
            await this.page.goto('http://localhost/gabe/pages/members.php', {
                waitUntil: 'networkidle2'
            });
            
            await this.takeScreenshot('members_page_for_search');
            
            // Look for search forms
            const searchElements = {
                searchInput: await this.page.$('input[type="search"], input[name*="search"], input[placeholder*="cari"]'),
                searchButton: await this.page.$('button[type="search"], button:contains("Cari"), button:contains("Search")')
            };
            
            const results = {
                test: 'Search Forms',
                hasSearchInput: !!searchElements.searchInput,
                hasSearchButton: !!searchElements.searchButton,
                passed: !!(searchElements.searchInput || searchElements.searchButton)
            };
            
            this.testResults.push(results);
            console.log('✅ Search forms test:', results);
            
        } catch (error) {
            console.error('❌ Search forms test failed:', error.message);
            this.testResults.push({
                test: 'Search Forms',
                error: error.message,
                passed: false
            });
        }
    }

    async generateReport() {
        console.log('\n📊 Generating Forms Test Report...');
        
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
        
        const reportPath = path.join(__dirname, 'forms-test-report.json');
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
            await this.testMemberForm();
            await this.testLoanForm();
            await this.testSearchForms();
            const report = await this.generateReport();
            return report;
        } catch (error) {
            console.error('❌ Forms test execution failed:', error);
            return null;
        } finally {
            await this.cleanup();
        }
    }
}

// Run tests if this file is executed directly
if (require.main === module) {
    const test = new FormsTest();
    test.runFullTest().then(report => {
        if (report) {
            console.log('\n🎉 Forms tests completed!');
            process.exit(report.summary.failedTests > 0 ? 1 : 0);
        } else {
            console.log('\n💥 Forms test execution failed!');
            process.exit(1);
        }
    });
}

module.exports = FormsTest;
