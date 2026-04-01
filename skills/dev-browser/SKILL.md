---
name: dev-browser
description: Browser automation with persistent page state. Use when users ask to navigate websites, click around, fill forms, take screenshots, extract rendered web data, test web apps, or automate browser workflows in a stateful session.
---

# Dev Browser

Use this skill when the task needs a real browser session that keeps page state across multiple steps.

## When to use

- Navigate a live site or app through multiple pages
- Click controls, fill forms, or submit flows in sequence
- Capture screenshots of rendered UI states
- Extract data that only appears after scripts run or interactions complete
- Reproduce browser-side bugs that depend on stateful navigation or auth

## Workflow

1. Open the target site or app in a persistent browser session.
2. Keep the same page or browser context alive while navigating, clicking, filling, and capturing evidence.
3. Use screenshots when layout, rendered state, or visible errors matter.
4. Extract only the data the user asked for instead of dumping whole pages.
5. Prefer the real browser path when the task depends on rendered behavior, session state, or authenticated flows.

## Tooling

Install the CLI if it is not already present:

```bash
npm install -g dev-browser
dev-browser install
```

Then inspect the available commands:

```bash
dev-browser --help
```

## Notes

- Use this for stateful browser work; use other local skills such as `playwright` or `webapp-testing` when the user is asking for broader UI verification or browser-driven evidence collection.
- Do not invent credentials. Reuse the existing session or the user's normal login flow when auth is required.
