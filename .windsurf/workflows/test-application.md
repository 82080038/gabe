---
description: Run comprehensive application tests
---
1. Navigate to tests directory
2. Install test dependencies if needed
// turbo
3. Run comprehensive test suite
4. Generate test reports
5. Check test coverage
6. Review performance metrics

## Test Commands
```bash
# Run all tests
cd /opt/lampp/htdocs/gabe/tests && npm test

# Run specific test suites
npm run test:auth
npm run test:mobile
npm run test:pwa
npm run test:dashboard
npm run test:quick-login

# Run with visible browser for debugging
HEADLESS=false npm test
```

## Test Coverage
- Multi-role authentication (6 user roles)
- Responsive design (mobile, tablet, desktop)
- PWA features (service worker, caching)
- Navigation system
- Quick login demo
- Performance metrics
