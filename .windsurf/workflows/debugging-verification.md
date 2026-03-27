---
description: Standard debugging and verification workflow
---

# Debugging & Verification Workflow

## 1. Investigation Phase
- Search for problematic code locations
- Analyze root cause thoroughly  
- Identify all potential dependencies
- Check existing documentation for similar issues

## 2. Implementation Phase
- Make minimal, focused changes
- Follow existing code style patterns
- Avoid over-engineering solutions
- Use single-line changes when sufficient

## 3. Immediate Verification
- Test functionality immediately after fix
- Check impact on other code sections
- Verify no regression in related features
- Test in multiple browsers if UI-related

## 4. Cross-Impact Analysis
- Search for other uses of modified functions/variables
- Test dependent functionality
- Verify database operations if applicable
- Check mobile responsiveness for UI changes

## 5. Documentation
- Update relevant documentation
- Create fix reports for significant changes
- Store workflow in winsurf for future reference
- Tag related team members if needed

## 6. Final Validation
- End-to-end testing of affected features
- Performance impact assessment
- Security considerations check
- User experience validation

**Core Principle:** "Fix, Test, Verify, Document" - always verify immediately after each fix.
