const LoginTest = require('./login.test.js');
const NavigationTest = require('./navigation.test.js');
const FormsTest = require('./forms-fixed.test.js');
const MobileTest = require('./mobile.test.js');
const fs = require('fs');
const path = require('path');

class TestRunner {
    constructor() {
        this.allResults = [];
        this.startTime = new Date();
    }

    async runAllTests() {
        console.log('🚀 Starting Complete Application Test Suite...');
        console.log('================================================');
        
        try {
            // Run Login Tests
            console.log('\n📱 Running Login Tests...');
            const loginTest = new LoginTest();
            const loginResults = await loginTest.runFullTest();
            if (loginResults) {
                this.allResults.push({
                    suite: 'Login Tests',
                    ...loginResults
                });
            }

            // Run Navigation Tests
            console.log('\n🧭 Running Navigation Tests...');
            const navigationTest = new NavigationTest();
            const navigationResults = await navigationTest.runFullTest();
            if (navigationResults) {
                this.allResults.push({
                    suite: 'Navigation Tests',
                    ...navigationResults
                });
            }

            // Run Forms Tests
            console.log('\n📝 Running Forms Tests...');
            const formsTest = new FormsTest();
            const formsResults = await formsTest.runFullTest();
            if (formsResults) {
                this.allResults.push({
                    suite: 'Forms Tests',
                    ...formsResults
                });
            }

            // Run Mobile Tests
            console.log('\n📱 Running Mobile Tests...');
            const mobileTest = new MobileTest();
            const mobileResults = await mobileTest.runFullTest();
            if (mobileResults) {
                this.allResults.push({
                    suite: 'Mobile Tests',
                    ...mobileResults
                });
            }

            // Generate comprehensive report
            await this.generateComprehensiveReport();
            
        } catch (error) {
            console.error('❌ Test suite execution failed:', error);
            process.exit(1);
        }
    }

    async generateComprehensiveReport() {
        console.log('\n📊 Generating Comprehensive Test Report...');
        
        const endTime = new Date();
        const duration = endTime - this.startTime;
        
        // Calculate overall statistics
        const totalTests = this.allResults.reduce((sum, suite) => sum + suite.summary.totalTests, 0);
        const totalPassed = this.allResults.reduce((sum, suite) => sum + suite.summary.passedTests, 0);
        const totalFailed = this.allResults.reduce((sum, suite) => sum + suite.summary.failedTests, 0);
        const overallSuccessRate = totalTests > 0 ? ((totalPassed / totalTests) * 100).toFixed(2) : 0;
        
        const comprehensiveReport = {
            metadata: {
                startTime: this.startTime.toISOString(),
                endTime: endTime.toISOString(),
                duration: `${duration}ms`,
                testSuites: this.allResults.length
            },
            overallSummary: {
                totalTests: totalTests,
                totalPassed: totalPassed,
                totalFailed: totalFailed,
                successRate: `${overallSuccessRate}%`
            },
            testSuites: this.allResults,
            recommendations: this.generateRecommendations(),
            issues: this.collectIssues()
        };
        
        // Save comprehensive report
        const reportPath = path.join(__dirname, 'comprehensive-test-report.json');
        fs.writeFileSync(reportPath, JSON.stringify(comprehensiveReport, null, 2));
        
        // Generate HTML report
        await this.generateHtmlReport(comprehensiveReport);
        
        // Print summary to console
        this.printSummary(comprehensiveReport);
        
        console.log(`\n📄 Comprehensive report saved to: ${reportPath}`);
        console.log(`🌐 HTML report saved to: ${path.join(__dirname, 'test-report.html')}`);
        
        return comprehensiveReport;
    }

    generateRecommendations() {
        const recommendations = [];
        
        this.allResults.forEach(suite => {
            const failedTests = suite.results.filter(test => !test.passed);
            
            failedTests.forEach(test => {
                if (test.error && test.error.includes('not found')) {
                    recommendations.push({
                        priority: 'high',
                        category: 'Missing Elements',
                        issue: test.test,
                        suggestion: 'Add missing UI elements or update selectors'
                    });
                }
                
                if (test.error && test.error.includes('timeout')) {
                    recommendations.push({
                        priority: 'medium',
                        category: 'Performance',
                        issue: test.test,
                        suggestion: 'Optimize page load time or increase timeout'
                    });
                }
                
                if (test.test && test.test.includes('Validation') && !test.passed) {
                    recommendations.push({
                        priority: 'medium',
                        category: 'User Experience',
                        issue: test.test,
                        suggestion: 'Implement proper form validation'
                    });
                }
            });
        });
        
        // Remove duplicates
        const uniqueRecommendations = recommendations.filter((rec, index, self) => 
            index === self.findIndex(r => r.issue === rec.issue)
        );
        
        return uniqueRecommendations;
    }

    collectIssues() {
        const issues = [];
        
        this.allResults.forEach(suite => {
            const failedTests = suite.results.filter(test => !test.passed);
            
            failedTests.forEach(test => {
                issues.push({
                    suite: suite.suite,
                    test: test.test,
                    error: test.error || 'Test failed',
                    severity: this.determineSeverity(test.test, test.error)
                });
            });
        });
        
        return issues;
    }

    determineSeverity(testName, error) {
        if (testName.includes('Login') || testName.includes('Authentication')) {
            return 'critical';
        }
        if (testName.includes('Navigation') || testName.includes('Dashboard')) {
            return 'high';
        }
        if (error && error.includes('not found')) {
            return 'high';
        }
        return 'medium';
    }

    async generateHtmlReport(report) {
        const htmlTemplate = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Application Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; margin-bottom: 30px; }
        .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .summary-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; text-align: center; }
        .summary-card.success { background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%); }
        .summary-card.danger { background: linear-gradient(135deg, #f44336 0%, #da190b 100%); }
        .suite-section { margin-bottom: 30px; }
        .suite-title { font-size: 24px; color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .test-item { margin: 10px 0; padding: 10px; border-left: 4px solid #ddd; background: #f9f9f9; }
        .test-item.passed { border-left-color: #4CAF50; }
        .test-item.failed { border-left-color: #f44336; }
        .recommendations { margin-top: 30px; }
        .recommendation { margin: 10px 0; padding: 15px; border-radius: 5px; }
        .recommendation.high { background: #ffebee; border-left: 4px solid #f44336; }
        .recommendation.medium { background: #fff3e0; border-left: 4px solid #ff9800; }
        .recommendation.low { background: #e8f5e8; border-left: 4px solid #4CAF50; }
        .status-badge { padding: 4px 8px; border-radius: 12px; color: white; font-size: 12px; }
        .status-badge.passed { background: #4CAF50; }
        .status-badge.failed { background: #f44336; }
        .progress-bar { width: 100%; height: 20px; background: #e0e0e0; border-radius: 10px; overflow: hidden; margin: 10px 0; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #4CAF50, #45a049); transition: width 0.3s ease; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 Application Test Report</h1>
            <p>Generated on ${new Date().toLocaleString()}</p>
        </div>
        
        <div class="summary">
            <div class="summary-card">
                <h3>Total Tests</h3>
                <h2>${report.overallSummary.totalTests}</h2>
            </div>
            <div class="summary-card success">
                <h3>Passed</h3>
                <h2>${report.overallSummary.totalPassed}</h2>
            </div>
            <div class="summary-card danger">
                <h3>Failed</h3>
                <h2>${report.overallSummary.totalFailed}</h2>
            </div>
            <div class="summary-card">
                <h3>Success Rate</h3>
                <h2>${report.overallSummary.successRate}</h2>
            </div>
        </div>
        
        <div class="progress-bar">
            <div class="progress-fill" style="width: ${report.overallSummary.successRate}"></div>
        </div>
        
        ${report.testSuites.map(suite => `
        <div class="suite-section">
            <h2 class="suite-title">${suite.suite}</h2>
            <div class="summary">
                <div class="summary-card">
                    <h4>Total</h4>
                    <p>${suite.summary.totalTests}</p>
                </div>
                <div class="summary-card success">
                    <h4>Passed</h4>
                    <p>${suite.summary.passedTests}</p>
                </div>
                <div class="summary-card danger">
                    <h4>Failed</h4>
                    <p>${suite.summary.failedTests}</p>
                </div>
            </div>
            
            ${suite.results.map(test => `
            <div class="test-item ${test.passed ? 'passed' : 'failed'}">
                <strong>${test.test}</strong>
                <span class="status-badge ${test.passed ? 'passed' : 'failed'}">${test.passed ? 'PASSED' : 'FAILED'}</span>
                ${test.error ? `<p style="color: #d32f2f; margin: 5px 0;">Error: ${test.error}</p>` : ''}
            </div>
            `).join('')}
        </div>
        `).join('')}
        
        ${report.recommendations.length > 0 ? `
        <div class="recommendations">
            <h2>📋 Recommendations</h2>
            ${report.recommendations.map(rec => `
            <div class="recommendation ${rec.priority}">
                <h4>${rec.issue}</h4>
                <p><strong>Priority:</strong> ${rec.priority.toUpperCase()}</p>
                <p><strong>Suggestion:</strong> ${rec.suggestion}</p>
            </div>
            `).join('')}
        </div>
        ` : ''}
        
        ${report.issues.length > 0 ? `
        <div class="issues">
            <h2>🐛 Issues Found</h2>
            ${report.issues.map(issue => `
            <div class="test-item failed">
                <strong>${issue.suite} - ${issue.test}</strong>
                <span class="status-badge failed">${issue.severity.toUpperCase()}</span>
                <p style="color: #d32f2f;">${issue.error}</p>
            </div>
            `).join('')}
        </div>
        ` : ''}
    </div>
</body>
</html>`;
        
        const htmlPath = path.join(__dirname, 'test-report.html');
        fs.writeFileSync(htmlPath, htmlTemplate);
    }

    printSummary(report) {
        console.log('\n' + '='.repeat(60));
        console.log('📊 TEST EXECUTION SUMMARY');
        console.log('='.repeat(60));
        console.log(`⏱️  Duration: ${report.metadata.duration}`);
        console.log(`📱 Total Tests: ${report.overallSummary.totalTests}`);
        console.log(`✅ Passed: ${report.overallSummary.totalPassed}`);
        console.log(`❌ Failed: ${report.overallSummary.totalFailed}`);
        console.log(`📈 Success Rate: ${report.overallSummary.successRate}`);
        
        if (report.recommendations.length > 0) {
            console.log('\n📋 TOP RECOMMENDATIONS:');
            report.recommendations.slice(0, 5).forEach((rec, index) => {
                console.log(`${index + 1}. [${rec.priority.toUpperCase()}] ${rec.issue}`);
                console.log(`   💡 ${rec.suggestion}`);
            });
        }
        
        if (report.issues.length > 0) {
            console.log('\n🐛 CRITICAL ISSUES:');
            const criticalIssues = report.issues.filter(issue => issue.severity === 'critical');
            if (criticalIssues.length > 0) {
                criticalIssues.forEach(issue => {
                    console.log(`❌ ${issue.suite} - ${issue.test}`);
                    console.log(`   ${issue.error}`);
                });
            }
        }
        
        console.log('\n' + '='.repeat(60));
    }
}

// Run all tests if this file is executed directly
if (require.main === module) {
    const runner = new TestRunner();
    runner.runAllTests().then(() => {
        console.log('\n🎉 Complete test suite finished!');
        process.exit(0);
    }).catch(error => {
        console.error('💥 Test suite failed:', error);
        process.exit(1);
    });
}

module.exports = TestRunner;
