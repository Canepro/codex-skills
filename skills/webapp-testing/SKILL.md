---
name: webapp-testing
description: Verify web applications through realistic user flows using browser automation, exploratory checks, accessibility smoke tests, and responsive validation. Use when the user wants end-to-end UI verification, regression coverage for a frontend change, form or navigation testing, or confidence that the interface works across important states and screen sizes.
metadata:
  short-description: Verify real web app behavior
---

# Webapp Testing

Use this skill to decide what to test, how to test it, and what evidence counts as confidence.

## Use when

- the user wants browser-based regression checks
- a UI change needs end-to-end verification
- forms, auth flows, navigation, dashboards, or critical journeys must be tested
- the team needs confidence beyond static code review

## Do not use when

- the request is mainly to automate a browser without a testing plan. Use `playwright`.
- the request is a visual redesign. Use `frontend-anti-slop`.
- the request is only about breakpoint fixes. Use `responsive-design`.

## Core principle

Test the user journey, not just isolated clicks.

Good webapp testing covers:
- the happy path
- a small number of high-value edge cases
- visible error handling
- responsive behavior at key widths
- basic accessibility and keyboard sanity

## Security and sensitive data handling

- Do not include real secrets in test artifacts such as logs, screenshots, traces, or shared notes.
- Use only masked or test-only credentials for authentication checks.
- Keep tokens redacted in reports, and avoid printing token values to console output.
- Private keys are out of scope for this skill. If private key behavior must be tested, route it through the security review flow first.
- Ask for explicit approval before using any real credentials, tokens, or private keys in a live run.

## Workflow

### 1. Identify the critical journey

Start with one or two flows that would matter most if broken:
- sign in
- create / edit / delete
- checkout or submit
- search / filter / inspect
- admin or operator actions

### 2. Define the assertions before driving the browser

Check for:
- visible confirmation of success
- stable route or state transition
- error copy for expected failures
- preserved user input where appropriate
- absence of obvious console or network failures when relevant

### 3. Choose the right test layers

Use:
- **browser automation** for end-to-end flow verification
- **exploratory testing** for weird state transitions
- **responsive checks** for key widths
- **a11y smoke checks** for labels, focus order, and keyboard navigation

### 4. Use real browser evidence

Prefer:
- screenshots
- snapshots
- traces
- precise notes about the failing step

If using terminal automation, pair this skill with `playwright`.

### 5. Report confidence honestly

State:
- what flows were exercised
- what widths or environments were checked
- what remains untested
- whether the confidence is strong enough for merge or release

## Test design guidance

- Prefer a small set of high-value journeys over broad shallow coverage.
- Avoid brittle assertions tied to incidental DOM details.
- Include at least one unhappy path for critical forms or mutations.
- Verify post-submit states, not just the click that triggered them.

## References

- Read `references/coverage-map.md` for a default coverage model.
- Use `playwright` when you need the actual browser-driving commands.

## Workflow Coordination

This skill owns its domain work. Use `vincent-workflow` for durable decisions, blockers, resume handoffs, known issues, commit/push/cleanup obligations, or project-local follow-up state. Use `codex-closeout` for final chat delivery, `codex-html-report` for durable reader-facing proof, and `second-brain-context` only for cross-repo or future local-brain retrieval.
