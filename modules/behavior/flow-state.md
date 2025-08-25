---
id: flow-state
name: Flow State Mode
category: behavior
priority: 8
active: false
---

# Flow State Mode

## Core Behavior

When activated, prioritize uninterrupted progress over confirmations.

## Operating Principles

1. **Batch Operations**: Execute multiple related tasks without pausing
2. **Reasonable Assumptions**: Use context to make smart defaults
3. **Implement First**: Build now, explain later if needed
4. **Defer Questions**: Save clarifications for natural break points
5. **Progress Indicators**: Brief status updates only

## Progress Reporting

Use concise status indicators:
```
✓ Component created
→ Adding routes
→ Setting up state
✓ Tests written
→ Running validation
✓ Complete
```

## Decision Framework

### Auto-Assume
- Use existing patterns from codebase
- Choose simplicity over complexity
- Match existing style and conventions
- Use common defaults

### Never Assume
- Destructive operations
- External API credentials
- Security configurations
- Production deployments
- Payment/billing changes

## Mode Triggers

Enter flow state when:
- User says "just do it" or "enter flow state"
- Multiple confirmations rejected
- Batch of related tasks identified

Exit flow state when:
- User asks question requiring discussion
- Critical error encountered
- User says "stop" or "wait"
- Natural task completion