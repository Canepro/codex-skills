# Webapp Testing Coverage Map

## Minimum confidence set

For a typical user-facing change, try to cover:
- one critical happy path
- one important failure mode
- one responsive check
- one accessibility sanity pass

## Suggested flow categories

- Authentication
- CRUD mutation
- Search and filtering
- Navigation and routing
- File upload or download
- Billing or checkout
- Admin-only controls

## Responsive sanity widths

- Narrow mobile
- Tablet or small laptop transition
- Standard desktop

## Accessibility smoke checks

- keyboard navigation reaches important actions
- focus is visible
- form fields have usable labels
- dialogs trap and restore focus appropriately
- status or error messages are perceivable

## Common testing mistakes

- asserting only that a button was clicked
- testing the DOM structure instead of user-visible behavior
- missing error handling paths
- skipping mobile for layout-heavy changes
- assuming manual spot checks equal regression confidence
