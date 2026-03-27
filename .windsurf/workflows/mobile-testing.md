---
description: Test mobile responsiveness and PWA features
---
1. Test mobile viewport (375x667)
2. Test tablet viewport (768x1024)
3. Test responsive navigation
4. Verify PWA service worker
5. Test offline functionality
6. Check touch interactions

## Device Testing
```bash
# Run mobile-specific tests
cd /opt/lampp/htdocs/gabe/tests && npm run test:mobile

# Test PWA features
npm run test:pwa

# Manual testing URLs
http://localhost/gabe/pages/responsive-demo.php
```

## PWA Features
- Service worker registration
- Offline capability
- App installation
- Cache management
- Push notifications

## Responsive Breakpoints
- Mobile: 320px - 767px
- Tablet: 768px - 1023px  
- Desktop: 1024px+
