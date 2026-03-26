#!/bin/bash

# ================================================================
# COMPREHENSIVE TEST RUNNER - KOPERASI BERJALAN
# Automated testing script for the cooperative management system
# ================================================================

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
TEST_DIR="/opt/lampp/htdocs/gabe/tests"
BASE_URL="http://localhost"
HEADLESS=${HEADLESS:-true}
TIMEOUT=${TIMEOUT:-30000}

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  KOPERASI BERJALAN - SYSTEM TESTING${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo -e "${CYAN}Date: $(date)${NC}"
    echo -e "${CYAN}Base URL: $BASE_URL${NC}"
    echo -e "${CYAN}Headless: $HEADLESS${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_step() {
    echo -e "\n${PURPLE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

check_prerequisites() {
    print_step "Checking prerequisites..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js 16.0.0 or higher."
        exit 1
    fi
    
    NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 16 ]; then
        print_error "Node.js version 16.0.0 or higher is required. Current version: $(node --version)"
        exit 1
    fi
    print_success "Node.js version: $(node --version)"
    
    # Check if we're in the right directory
    if [ ! -f "$TEST_DIR/package.json" ]; then
        print_error "Test directory not found. Please run this script from the tests directory."
        exit 1
    fi
    print_success "Test directory found"
    
    # Check if PHP server is running
    if ! curl -s --head --request GET "$BASE_URL" | grep -q "200 OK"; then
        print_error "PHP server is not running on $BASE_URL"
        print_warning "Please start the PHP server before running tests:"
        echo "  cd /opt/lampp/htdocs/gabe"
        echo "  php -S localhost:8000"
        exit 1
    fi
    print_success "PHP server is running on $BASE_URL"
    
    # Check database connection
    if ! curl -s "$BASE_URL/api/health" | grep -q "OK"; then
        print_warning "Database health check failed. Tests may not work properly."
    else
        print_success "Database connection is healthy"
    fi
}

install_dependencies() {
    print_step "Installing dependencies..."
    
    cd "$TEST_DIR"
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        echo "Installing Puppeteer..."
        npm install puppeteer
        print_success "Dependencies installed"
    else
        print_success "Dependencies already installed"
    fi
    
    # Create screenshots directory
    mkdir -p screenshots
    print_success "Screenshots directory created"
}

run_quick_tests() {
    print_step "Running quick tests..."
    
    cd "$TEST_DIR"
    
    echo "Running authentication tests..."
    if HEADLESS=$HEADLESS node -e "
        const t = require('./puppeteer-comprehensive-test.js');
        const tester = new t();
        tester.runTestSuite('authentication').then(() => {
            console.log('✅ Authentication tests passed');
            process.exit(0);
        }).catch((error) => {
            console.error('❌ Authentication tests failed:', error.message);
            process.exit(1);
        });
    "; then
        print_success "Authentication tests passed"
    else
        print_error "Authentication tests failed"
        return 1
    fi
    
    echo "Running dashboard tests..."
    if HEADLESS=$HEADLESS node -e "
        const t = require('./puppeteer-comprehensive-test.js');
        const tester = new t();
        tester.runTestSuite('dashboard').then(() => {
            console.log('✅ Dashboard tests passed');
            process.exit(0);
        }).catch((error) => {
            console.error('❌ Dashboard tests failed:', error.message);
            process.exit(1);
        });
    "; then
        print_success "Dashboard tests passed"
    else
        print_error "Dashboard tests failed"
        return 1
    fi
    
    return 0
}

run_full_tests() {
    print_step "Running comprehensive tests..."
    
    cd "$TEST_DIR"
    
    echo "Starting full test suite..."
    if HEADLESS=$HEADLESS node puppeteer-comprehensive-test.js; then
        print_success "All tests passed"
        return 0
    else
        print_error "Some tests failed"
        return 1
    fi
}

run_performance_tests() {
    print_step "Running performance tests..."
    
    cd "$TEST_DIR"
    
    echo "Testing page load performance..."
    if HEADLESS=$HEADLESS node -e "
        const t = require('./puppeteer-comprehensive-test.js');
        const tester = new t();
        tester.runTestSuite('performance').then(() => {
            console.log('✅ Performance tests passed');
            process.exit(0);
        }).catch((error) => {
            console.error('❌ Performance tests failed:', error.message);
            process.exit(1);
        });
    "; then
        print_success "Performance tests passed"
    else
        print_error "Performance tests failed"
        return 1
    fi
    
    return 0
}

run_mobile_tests() {
    print_step "Running mobile responsiveness tests..."
    
    cd "$TEST_DIR"
    
    echo "Testing mobile responsiveness..."
    if HEADLESS=$HEADLESS node -e "
        const t = require('./puppeteer-comprehensive-test.js');
        const tester = new t();
        tester.runTestSuite('mobile-responsiveness').then(() => {
            console.log('✅ Mobile tests passed');
            process.exit(0);
        }).catch((error) => {
            console.error('❌ Mobile tests failed:', error.message);
            process.exit(1);
        });
    "; then
        print_success "Mobile tests passed"
    else
        print_error "Mobile tests failed"
        return 1
    fi
    
    return 0
}

run_pwa_tests() {
    print_step "Running PWA feature tests..."
    
    cd "$TEST_DIR"
    
    echo "Testing PWA features..."
    if HEADLESS=$HEADLESS node -e "
        const t = require('./puppeteer-comprehensive-test.js');
        const tester = new t();
        tester.runTestSuite('pwa-features').then(() => {
            console.log('✅ PWA tests passed');
            process.exit(0);
        }).catch((error) => {
            console.error('❌ PWA tests failed:', error.message);
            process.exit(1);
        });
    "; then
        print_success "PWA tests passed"
    else
        print_error "PWA tests failed"
        return 1
    fi
    
    return 0
}

generate_report() {
    print_step "Generating test report..."
    
    cd "$TEST_DIR"
    
    if [ -f "test-report.json" ]; then
        print_success "JSON report generated"
        
        # Extract summary from JSON
        TOTAL=$(cat test-report.json | jq '.summary.totalSuites')
        PASSED=$(cat test-report.json | jq '.summary.passed')
        FAILED=$(cat test-report.json | jq '.summary.failed')
        DURATION=$(cat test-report.json | jq '.summary.totalDuration')
        
        echo -e "${CYAN}Test Summary:${NC}"
        echo -e "  Total Suites: $TOTAL"
        echo -e "  Passed: ${GREEN}$PASSED${NC}"
        echo -e "  Failed: ${RED}$FAILED${NC}"
        echo -e "  Duration: ${YELLOW}$DURATION${NC}ms"
        
        if [ -f "test-report.html" ]; then
            print_success "HTML report generated"
            echo -e "${BLUE}📊 View report: file://$TEST_DIR/test-report.html${NC}"
        fi
        
        if [ -d "screenshots" ] && [ "$(ls -A screenshots)" ]; then
            print_success "Screenshots available"
            echo -e "${BLUE}📸 Screenshots: $TEST_DIR/screenshots/${NC}"
        fi
    else
        print_error "No test report found"
        return 1
    fi
}

cleanup() {
    print_step "Cleaning up..."
    
    cd "$TEST_DIR"
    
    # Remove old screenshots (keep last 10)
    if [ -d "screenshots" ]; then
        find screenshots -name "*.png" -type f | sort -r | tail -n +11 | xargs -r rm
        print_success "Cleaned up old screenshots"
    fi
    
    # Remove old reports (keep last 5)
    find . -name "test-report-*.json" -type f | sort -r | tail -n +6 | xargs -r rm
    find . -name "test-report-*.html" -type f | sort -r | tail -n +6 | xargs -r rm
    print_success "Cleaned up old reports"
}

show_help() {
    echo -e "${BLUE}Usage: $0 [OPTION]${NC}"
    echo ""
    echo "Options:"
    echo "  quick         Run quick tests (authentication + dashboard)"
    echo "  full          Run comprehensive test suite"
    echo "  performance   Run performance tests only"
    echo "  mobile        Run mobile responsiveness tests"
    echo "  pwa           Run PWA feature tests"
    echo "  report        Generate test report from existing results"
    echo "  cleanup       Clean up old screenshots and reports"
    echo "  help          Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  HEADLESS      Run tests in headless mode (default: true)"
    echo "  BASE_URL      Application base URL (default: http://localhost)"
    echo "  TIMEOUT       Test timeout in milliseconds (default: 30000)"
    echo ""
    echo "Examples:"
    echo "  $0                    # Run quick tests"
    echo "  $0 full              # Run all tests"
    echo "  $0 HEADLESS=false     # Run tests with visible browser"
    echo "  $0 BASE_URL=http://localhost:8000  # Custom base URL"
}

# Main execution
main() {
    print_header
    
    # Parse command line arguments
    case "${1:-quick}" in
        "quick")
            check_prerequisites
            install_dependencies
            if run_quick_tests; then
                generate_report
                print_success "Quick tests completed successfully!"
            else
                print_error "Quick tests failed!"
                exit 1
            fi
            ;;
        "full")
            check_prerequisites
            install_dependencies
            if run_full_tests; then
                generate_report
                print_success "All tests completed successfully!"
            else
                print_error "Some tests failed!"
                exit 1
            fi
            ;;
        "performance")
            check_prerequisites
            install_dependencies
            if run_performance_tests; then
                generate_report
                print_success "Performance tests completed successfully!"
            else
                print_error "Performance tests failed!"
                exit 1
            fi
            ;;
        "mobile")
            check_prerequisites
            install_dependencies
            if run_mobile_tests; then
                generate_report
                print_success "Mobile tests completed successfully!"
            else
                print_error "Mobile tests failed!"
                exit 1
            fi
            ;;
        "pwa")
            check_prerequisites
            install_dependencies
            if run_pwa_tests; then
                generate_report
                print_success "PWA tests completed successfully!"
            else
                print_error "PWA tests failed!"
                exit 1
            fi
            ;;
        "report")
            generate_report
            ;;
        "cleanup")
            cleanup
            print_success "Cleanup completed!"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Trap cleanup on exit
trap cleanup EXIT

# Run main function
main "$@"
