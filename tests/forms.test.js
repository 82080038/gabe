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
                '--disable-dev-shm-usage'
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
            // Navigate to members page
            await this.page.goto('http://localhost/gabe/pages/members.php', {
                waitUntil: 'networkidle2'
            });
            
            await this.takeScreenshot('form_members_page_loaded');
            
            // Wait for page to fully load
            await this.page.waitForTimeout(1000);
            
            // Look for add member button with better selectors
            const addMemberSelectors = [
                'a[href="/gabe/pages/members.php?action=add"]',
                'a[href*="add"]',
                'button[class*="add"]',
                '.btn-add',
                '[onclick*="add"]',
                'a:contains("Tambah")',
                'button:contains("Tambah")'
            ];
            
            let addButton = null;
            for (const selector of addMemberSelectors) {
                try {
                    addButton = await this.page.$(selector);
                    if (addButton) break;
                } catch (e) {
                    // Continue to next selector
                }
            }
            
            // If no button found, try to find any link that goes to add form
            if (!addButton) {
                const allLinks = await this.page.$$('a');
                for (const link of allLinks) {
                    const href = await this.page.evaluate(el => el.href, link);
                    if (href && href.includes('members.php') && href.includes('add')) {
                        addButton = link;
                        break;
                    }
                }
            }
            
            // If still no button found, try direct navigation
            if (!addButton) {
                console.log('⚠️ No add button found, trying direct navigation...');
                await this.page.goto('http://localhost/gabe/pages/members.php?action=add', {
                    waitUntil: 'networkidle2'
                });
                await this.takeScreenshot('form_direct_navigation');
            } else {
                await Promise.all([
                    this.page.waitForNavigation({ waitUntil: 'networkidle2' }),
                    addButton.click()
                ]);
                await this.takeScreenshot('form_add_member_open');
            }
            
            // Wait for form to load
            await this.page.waitForTimeout(1000);
            
            // Check for form elements with better selectors
            const formElements = {
                nameInput: await this.page.$('input[name="name"], input[name*="nama"], input#name'),
                nikInput: await this.page.$('input[name="nik"], input[name*="nik"], input#nik'),
                phoneInput: await this.page.$('input[name="phone"], input[name*="telepon"], input[name*="hp"]'),
                addressInput: await this.page.$('textarea[name="address"], textarea[name*="alamat"], textarea#address'),
                branchSelect: await this.page.$('select[name="branch"], select[name*="cabang"]'),
                submitButton: await this.page.$('button[type="submit"], input[type="submit"], .btn-primary')
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
                    await this.takeScreenshot('form_before_validation_test');
                    
                    // Try to submit empty form
                    await formElements.submitButton.click();
                    await this.page.waitForTimeout(1000);
                    
                    await this.takeScreenshot('form_after_empty_submit');
                    
                    // Check for HTML5 validation or validation messages
                    const validationActive = await this.page.evaluate(() => {
                        // Check for HTML5 validation
                        const invalidInputs = document.querySelectorAll(':invalid');
                        if (invalidInputs.length > 0) return true;
                        
                        // Check for custom validation messages
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
                    
                    // Test filling form with valid data
                    if (formElements.nameInput && formElements.nikInput) {
                        await formElements.nameInput.type('Test User', { delay: 100 });
                        await formElements.nikInput.type('1234567890123456', { delay: 100 });
                        await this.takeScreenshot('form_filled_with_data');
                    }
                }
                
            } else {
                console.log('⚠️ Add member button not found');
                this.testResults.push({
                    test: 'Member Form',
                    error: 'Add member button not found',
                    passed: false
                });
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
            // Navigate to loans page
            await this.page.goto('http://localhost/gabe/pages/loans.php', {
                waitUntil: 'networkidle2'
            });
            
            await this.takeScreenshot('form_loans_page_loaded');
            
            // Look for add loan button
            const addLoanSelectors = [
                'a[href*="add"]',
                'button[class*="add"]',
                '.btn-add',
                '[onclick*="add"]',
                'a[href="/gabe/pages/loans.php?action=apply"]'
            ];
            
            let addButton = null;
            for (const selector of addLoanSelectors) {
                addButton = await this.page.$(selector);
                if (addButton) break;
            }
            
            if (addButton) {
                await Promise.all([
                    this.page.waitForNavigation({ waitUntil: 'networkidle2' }),
                    addButton.click()
                ]);
                
                await this.takeScreenshot('form_add_loan_open');
                
                // Check for loan form elements
                const formElements = {
                    memberSelect: await this.page.$('select[name*="member"], select[name*="anggota"]'),
                    amountInput: await this.page.$('input[name*="amount"], input[name*="jumlah"]'),
                    interestInput: await this.page.$('input[name*="interest"], input[name*="bunga"]'),
                    termInput: await this.page.$('input[name*="term"], input[name*="tenor"]'),
                    purposeInput: await this.page.$('textarea[name*="purpose"], textarea[name*="tujuan"]'),
                    submitButton: await this.page.$('button[type="submit"], input[type="submit"]')
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
                    await this.takeScreenshot('form_loan_before_validation');
                    
                    // Try to submit empty form
                    await formElements.submitButton.click();
                    await this.page.waitForTimeout(1000);
                    
                    await this.takeScreenshot('form_loan_after_empty_submit');
                    
                    // Check for HTML5 validation or validation messages
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
                    
                    // Test filling form with valid data
                    if (formElements.memberSelect && formElements.amountInput) {
                        await formElements.memberSelect.select('1'); // Select first member
                        await formElements.amountInput.type('1000000', { delay: 100 });
                        await this.takeScreenshot('form_loan_filled_with_data');
                    }
                }
                
            } else {
                console.log('⚠️ Add loan button not found');
                this.testResults.push({
                    test: 'Loan Form',
                    error: 'Add loan button not found',
                    passed: false
                });
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
            // Look for search forms on current page
            const searchSelectors = [
                'input[name*="search"]',
                'input[placeholder*="search"]',
                'input[placeholder*="cari"]',
                '.search input',
                '.search-form input'
            ];
            
            let searchFound = false;
            
            for (const selector of searchSelectors) {
                const searchInput = await this.page.$(selector);
                if (searchInput) {
                    searchFound = true;
                    
                    await this.takeScreenshot('search_form_found');
                    
                    // Type search query
                    await searchInput.type('test', { delay: 100 });
                    await this.page.waitForTimeout(500);
                    
                    await this.takeScreenshot('search_query_typed');
                    
                    // Try to submit search (look for search button or press Enter)
                    const searchButton = await this.page.$('button[type="submit"], .search-button, .btn-search');
                    
                    if (searchButton) {
                        await searchButton.click();
                    } else {
                        await searchInput.press('Enter');
                    }
                    
                    await this.page.waitForTimeout(1000);
                    await this.takeScreenshot('search_results');
                    
                    const results = {
                        test: 'Search Form',
                        searchInputFound: true,
                        searchExecuted: true,
                        passed: true
                    };
                    
                    this.testResults.push(results);
                    console.log('✅ Search form test:', results);
                    
                    break;
                }
            }
            
            if (!searchFound) {
                console.log('⚠️ No search forms found');
                this.testResults.push({
                    test: 'Search Forms',
                    error: 'No search forms found',
                    passed: false
                });
            }
            
        } catch (error) {
            console.error('❌ Search form test failed:', error.message);
            this.testResults.push({
                test: 'Search Forms',
                error: error.message,
                passed: false
            });
        }
    }

    async testFormValidation() {
        console.log('\n🔍 Testing Form Validation...');
        
        try {
            // Go to a page with forms
            await this.page.goto('http://localhost/gabe/pages/branches.php', {
                waitUntil: 'networkidle2'
            });
            
            await this.takeScreenshot('branches_page_for_validation');
            
            // Look for any form with required fields
            const forms = await this.page.$$('form');
            
            if (forms.length > 0) {
                const form = forms[0]; // Test first form found
                
                // Find required inputs
                const requiredInputs = await form.$$('input[required], select[required], textarea[required]');
                
                if (requiredInputs.length > 0) {
                    await this.takeScreenshot('required_fields_found');
                    
                    // Try to submit form without filling required fields
                    const submitButton = await form.$('button[type="submit"], input[type="submit"]');
                    
                    if (submitButton) {
                        await submitButton.click();
                        await this.page.waitForTimeout(1000);
                        
                        await this.takeScreenshot('validation_triggered');
                        
                        // Check for HTML5 validation or custom validation
                        const validationActive = await this.page.evaluate(() => {
                            // Check for HTML5 validation
                            const invalidInputs = document.querySelectorAll(':invalid');
                            if (invalidInputs.length > 0) return true;
                            
                            // Check for custom validation messages
                            const errorMessages = document.querySelectorAll('.error, .alert-danger, .validation-error');
                            return errorMessages.length > 0;
                        });
                        
                        const results = {
                            test: 'Form Validation',
                            requiredFieldsFound: requiredInputs.length,
                            validationTriggered: validationActive,
                            passed: validationActive
                        };
                        
                        this.testResults.push(results);
                        console.log('✅ Form validation test:', results);
                        
                    } else {
                        console.log('⚠️ No submit button found in form');
                    }
                } else {
                    console.log('⚠️ No required fields found in form');
                }
            } else {
                console.log('⚠️ No forms found on page');
            }
            
        } catch (error) {
            console.error('❌ Form validation test failed:', error.message);
            this.testResults.push({
                test: 'Form Validation',
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
            await this.testFormValidation();
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
