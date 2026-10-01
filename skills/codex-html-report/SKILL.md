---
name: codex-html-report
description: "Create self-contained HTML proof reports meant to be read in a browser: implementation closeouts, deployment or incident summaries, support cases, code reviews, research briefs, architecture plans. Not for quick answers or when Markdown is wanted."
metadata:
  short-description: Create polished self-contained HTML reports
---

# Codex HTML Report

Use this skill when the output should live beyond the chat as a readable artifact:
- implementation closeouts with proof
- ops incidents, support cases, or deployment verification
- code reviews, architecture plans, research briefs, or complex explanations
- any durable report where layout, navigation, tables, screenshots, or collapsible evidence would improve comprehension
- when refreshing or creating durable browser-native proof reports.
- before calling a PR implementation ready when the user expects durable proof.

Do not use this skill for tiny answers, paste-ready support replies, one-command outputs, or when the user explicitly asks for Markdown/plain text.

When the main task is chart choice, dashboard design, maps, Gantt timelines, software diagrams, or data-graphics export, route to the installed visualization specialist first: the `build-web-data-visualization:data-visualization` plugin on Codex, or the bundled `dataviz` skill on Claude Code. When neither is installed, build the chart inline with plain SVG or a table and say so. Use this skill for work artifacts and proof reports; embed charts only when they support the report rather than being the product.

## Goal

Create a self-contained browser-native report: lightweight, evidence-first, dark-first by default, and readable from `file://` with no build step.

The report should read like a well-set engineering document, not a dashboard. Flat neutral surfaces, system sans type, one accent reserved for links and the active table-of-contents item, and colour only on status pills. Tables, timelines, proof blocks, and honest status carry the content; decoration does not.

Default to dark mode/dark-first styling for read-mostly reports. A light mode override is allowed only when light mode is requested by the user, the destination platform requires it, or there is a clear accessibility/user-context reason. Avoid jarring mode switches after dark-mode work surfaces.

## Boundaries

The report presents evidence. It does not replace the underlying work, review,
or verification. Keep the chat reply short and link the report path.

When the underlying task requires a specialist or formal review, complete that
review independently. A report can present the evidence but cannot approve the
change.

Do not let a report substitute for finishing the task. If the work
also requires installs, runtime sync, tests, commit/push, or cleanup, complete
those steps or name the real blocker before treating the report as done.

## Default Location

Write reports under the current working context:
- preferred: `reports/YYYY-MM-DD-short-topic.html`
- the active environment's designated deliverable directory wins
- projectless sessions: use the task's designated `outputs/` directory when
  present, otherwise use the active Codex workspace directory
- existing repo convention wins if there is already a `reports/`, `docs/reports/`, or similar artifact folder

Do not write to the home directory unless the user asks.

## Template

Use `templates/report.html` as the canonical starting point. Copy it into the destination report and replace the sample content with task-specific content.

Do not hand-build a parallel report shell when this skill applies. Preserve the
canonical template signature unless the user explicitly asks for a different
design or the target platform requires a different structure:
- the `Codex HTML Report Template v...` version comment
- `html lang="en" data-theme="dark"`
- topbar with the author lane and project on the left, theme toggle and
  Save PDF on the right
- the sticky left table of contents that collapses to a top bar on narrow
  screens
- the standard section ids: outcome, next-action, gates, changes,
  verification, timeline, environment, risks, and evidence. Keep the id of
  every section you retain; when a report type drops a section, delete the
  section and its contents entry together. The `facts` strip sits outside
  the section list and stays in every report
- reusable status pills, table wrappers, evidence `<pre>` blocks with copy
  buttons, and print CSS

If you intentionally do not use `templates/report.html`, state the exception in
the report or closeout and explain why the canonical template was not suitable.

Keep the report single-file by default:
- embedded CSS
- minimal embedded JavaScript only for useful interactions such as collapsible evidence, copy buttons, or filtering
- no external fonts, CDNs, image dependencies, or build step unless the user asks

When improving the template itself, read `references/template-improvements.md` first and update it with the decision, reason, and verification. Use `references/report-qa.md` as the review checklist before calling a report or template change done.

## Report Types

Choose the closest type and keep its sections in the order given in
`references/report-types.md`. The six types are `implementation-closeout`,
`ops-incident`, `support-case`, `code-review`, `research-brief`, and
`architecture-plan`. Every type keeps `outcome` first and `evidence` last.
Delete sections the type does not need, and their contents entries, instead
of leaving placeholders. Retained sections keep their ids.

## Minimum Contract

Every substantial report must answer:
- What is the outcome?
- Is it done, partial, blocked, or risky?
- What changed or was discovered?
- How was it verified?
- What evidence supports the claim?
- If outcome is partial, risky, or blocked, include open risk items with a named risk owner or next action, and a due date when one is known.
- What remains uncertain?
- What should the user do next?

## Visual Rules

Use the template's visual system:
- dark-first neutral palette with a light theme behind the toggle; contrast tuned for long reading in both
- flat surfaces separated by hairline borders, no gradients or decorative shadows
- system sans for text, monospace only for commands, paths, and hashes
- a tight hero: eyebrow, title, one-line lede, one metadata row with status pill
- a single key-facts strip with three to five honest figures
- status pills for Done / Partial / Blocked / Not verified
- gate checklist for ops, migration, deployment, and incident reports
- tables for files, checks, risks, and decisions
- timestamped timeline when event order matters; use observed times, never generic "Step 1" labels alone
- `<details>` blocks around evidence, open by default; only a raw appendix
  may start collapsed, because a no-script print cannot open it
- a copy button on every `<pre>` block, added by the template script
- sticky left table of contents whose links match the section ids

Avoid:
- gradients, glows, or "AI dashboard" accent colours
- tabs or any control that hides report content behind a click
- fake metrics, fake precision, or invented event times
- low-information cards
- dense Markdown dumped into HTML
- external dependencies
- mobile overflow or clipped text

## Accessibility Baseline

Build reports with accessibility defaults that reduce rework:
- target WCAG 2.1 AA checks for semantic headings, labels, contrast, and landmarks.
- ensure the report is fully keyboard reachable, including copy buttons and disclosure widgets, and that tab focus follows a logical focus order.
- add visible focus styles, and do not remove focus outlines unless a stronger visual is proven better.
- add descriptive alt text for informative images and meaningful icon controls.
- provide screen reader labels and table summaries so screen reader users can parse purpose quickly.
- respect prefers-reduced-motion by disabling non-essential transitions when reduced motion is requested.
- print and export checks are mandatory for durable artifacts:
  - verify the browser print flow
  - ensure the report exports cleanly to PDF when needed
  - use page-break control to avoid breaking tables and code blocks across pages
  - include `@media print` CSS controls for margins, background behavior, link visibility, and page breaks when the report may be printed or exported

## Evidence Rules

Prefer concrete proof:
- commands run and pass/fail result
- command evidence should include the exit code when available
- exact local file paths
- short log/output excerpts
- screenshots with absolute local paths when available
- source URLs or ticket IDs when used
- redacted proof for any sensitive material, including credentials and tokens
- explicit "not verified" entries for skipped or unavailable checks
- keep an asset budget: compress screenshots, avoid large embedded assets, and watch the file size; a report hiding megabytes of base64 is not lightweight

For redacted proof, include enough detail to confirm intent without exposing secret values, for example `credentials` purpose and owner, token type and short suffix, and the command or context where it was used.
Do not imply review of logs, attachments, code, or screenshots unless they were actually opened.

## Provenance and Dating

Every substantial report should include a metadata strip in the visible header or footer with:
- generated at: timezone-aware timestamp for when the artifact was built
- report author: person or lane identity that created the report
- source revision: commit hash, ticket, source URL, or upstream artifact revision
- if updated later, note the revision delta from the previous version

## Workflow

1. Decide whether HTML is warranted. If the artifact is small, answer in chat.
2. Check whether a review, workflow, domain, or authority skill must run first.
   Reports do not approve risky work by themselves.
3. Copy `templates/report.html` to the destination report path.
4. Replace the template content with the task-specific report. Keep only useful sections, but preserve the canonical template shell unless an explicit exception applies.
5. Verify the HTML is self-contained and opens locally. For substantial reports, also validate the HTML with an HTML validator or lint pass; opening it locally does not catch malformed markup or broken anchors.
6. Run a link integrity pass before closeout: every internal anchor resolves with no missing targets, and local evidence links point at files that exist.
7. Check the layout at mobile and desktop viewport widths for overflow and clipped text.
8. Run the checks in `references/report-qa.md` when the report is substantial,
   risky, reader-facing, or the template changed.
9. If the report summarizes code, config, infra, automation, or skill changes,
   verify the underlying work separately and record skipped checks explicitly.
10. In the final chat reply, give the report path and a compact summary of what it contains.

## Final Reply

Keep the chat closeout short:
- say the report was created
- link the absolute local path
- mention the report type and top-level status
- mention any verification limitation
