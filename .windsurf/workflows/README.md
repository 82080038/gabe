# Windsurf Workflows

This directory contains custom workflows for the Windsurf IDE.

## Creating Workflows

To create a new workflow:
1. Create a new `.md` file in this directory
2. Use the following YAML frontmatter format:

```yaml
---
description: [short title describing the workflow]
---
```

3. Add specific steps below the frontmatter
4. Use `// turbo` annotation for steps that can be auto-run

## Example Workflow

```markdown
---
description: Deploy the application
---
1. Build the application
// turbo
2. Deploy to production server
3. Run health checks
```

## Available Workflows

- **/deploy** - Deploy the Koperasi Berjalan application
- **/test-application** - Run comprehensive application tests  
- **/database-setup** - Setup and configure database for Koperasi Berjalan
- **/quick-login** - Test quick login demo for all user roles
- **/mobile-testing** - Test mobile responsiveness and PWA features

## Application Overview

**Koperasi Berjalan v1.1.0** adalah sistem koperasi digital yang production-ready dengan:

### ✅ **Latest Features (v1.1.0):**
- Database-driven authentication dengan password hashing
- Clean dashboard tanpa PHP errors
- Multi-schema database architecture
- Helper functions untuk format Indonesia
- All 6 user roles tested dan working

### 🏗️ **Core Features:**
- Multi-role authentication (6 user roles)
- Responsive design dengan Bootstrap 5
- PWA features untuk mobile collectors
- MySQL database dengan multi-schema
- Comprehensive Puppeteer E2E testing
- Door-to-door collection services

## Quick Start

1. Start XAMPP: `sudo /opt/lampp/lampp start`
2. Access application: `http://localhost/gabe/`
3. Quick login demo: `http://localhost/gabe/pages/quick_login.php`
4. Run tests: `cd /opt/lampp/htdocs/gabe/tests && npm test`

## User Credentials

| Role | Username | Password | Status |
|------|----------|----------|--------|
| Administrator | admin | admin | ✅ Tested |
| Manager | manager | manager | ✅ Tested |
| Branch Head | branch_head | branch_head | ✅ Tested |
| Collector | collector | collector | ✅ Tested |
| Cashier | cashier | cashier | ✅ Tested |
| Staff | staff | staff | ✅ Tested |
