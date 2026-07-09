---
name: codex-html-report
description: "Create durable, self-contained HTML reports from any agent session: proof and completed-work reports, implementation closeouts, deployment verification, code reviews, ops or support case summaries, research briefs, and architecture plans meant to be read in a browser. Includes evidence, verification, risks, next steps. Not for quick answers or when the user wants Markdown or plain text."
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

Prefer the installed `build-web-data-visualization:data-visualization` vendor plugin when the main task is chart choice, analytical dashboard design, maps, Gantt timelines, UML/software diagrams, D3/Canvas/WebGL visualization, visualization accessibility/testing, or report/slide/PDF exports centered on data graphics. Use this skill for Codex work artifacts and proof reports; embed charts only when they support the report rather than being the product.

## Goal

Create a self-contained browser-native report: lightweight, visually pleasing, evidence-first, dark-first by default, and readable from `file://` with no build step.

The report should feel like a polished internal product, not a decorative dashboard. Preserve a rich but restrained editorial feel: a strong title, clear surface layering (page, panel, inset), restrained color, useful tables, timelines, proof blocks, and honest status over ornamental visuals. Keep the editorial polish without flattening into a plain admin page.

Default to dark mode/dark-first styling for read-mostly reports. A light mode override is allowed only when light mode is requested by the user, the destination platform requires it, or there is a clear accessibility/user-context reason. Avoid jarring mode switches after dark-mode work surfaces.

## Workflow Coordination

This skill owns reader-facing proof artifacts. It does not own task state.
When another owner skill governs the underlying work, run that gate first and
let the report present its outcome.

Use `vincent-workflow` when the report creates or captures a durable decision,
blocker, known issue, handoff, or closeout obligation. The report can show those
facts, but the project-local workflow record should live in the workflow surface
when it needs to survive beyond the artifact.

Use `codex-closeout` for the final chat reply after the report is created.
Keep the reply short and link the report path.

Use `mira-review-gate` before treating a report as acceptance evidence when the
report covers a risky change, architecture decision, pre-merge review, shared
behavior, local tooling change, runtime authority, secrets surface, or
user-facing workflow. The report can present the review, but it should not
replace the review gate.

Do not let a report become a substitute for finishing the task. If the work
also requires installs, runtime sync, tests, commit/push, or cleanup, complete
those steps or name the real blocker before treating the report as done.

## Default Location

Write reports under the current working context:
- preferred: `reports/YYYY-MM-DD-short-topic.html`
- projectless sessions: use the active Codex workspace directory
- existing repo convention wins if there is already a `reports/`, `docs/reports/`, or similar artifact folder

Do not write to the home directory unless the user asks.

## Template

Use `templates/report.html` as the canonical starting point. Copy it into the destination report and replace the sample content with task-specific content.

Do not hand-build a parallel report shell when this skill applies. Preserve the
canonical template signature unless the user explicitly asks for a different
design or the target platform requires a different structure:
- the `Codex HTML Report Template v...` version comment
- `html lang="en" data-theme="dark"`
- topbar tools for theme and print when keeping browser-native behavior
- the standard section anchors: outcome, next action, gates, changes,
  verification, timeline, risks, and evidence
- reusable status pills, table wrappers, evidence `<pre>` blocks, and print CSS

If you intentionally do not use `templates/report.html`, state the exception in
the report or closeout and explain why the canonical template was not suitable.

Keep the report single-file by default:
- embedded CSS
- minimal embedded JavaScript only for useful interactions such as collapsible evidence, copy buttons, or filtering
- no external fonts, CDNs, image dependencies, or build step unless the user asks

When improving the template itself, read `references/template-improvements.md` first and update it with the decision, reason, and verification. Use `references/report-qa.md` as the review checklist before calling a report or template change done.

## Report Types

Choose the closest type and adapt the section labels:
- `implementation-closeout`: summary, changes, verification, files, risks
- `ops-incident`: status, impact, timeline, evidence, next action
- `support-case`: ticket issue, current state, what was done, proof, customer-safe next step
- `code-review`: verdict, findings, affected files, evidence, test gaps
- `research-brief`: answer, sources/evidence, decision matrix, recommendation
- `architecture-plan`: decision, constraints, proposed design, migration path, risks

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

Use a reusable visual system:
- dark-first base styling with comfortable contrast for long reading
- layered surfaces (page, panel, inset) with hairline borders and soft shadows so panels separate from the background
- an editorial hero: short eyebrow, strong title, one-line lede, then a key-facts strip
- status strip for Done / Partial / Blocked / Risk
- outcome panel with the plain-English verdict
- gate checklist for ops, migration, deployment, and incident reports
- proof rail for commands, logs, screenshots, tickets, and changed files
- tables for files, tests, risks, and decisions
- timestamped timeline for event order when it matters; use actual observed times, not generic "Step 1" labels alone
- collapsible appendix for raw evidence
- sticky or top navigation for longer reports, with explicit internal anchors on major sections (for example `#summary`, `#verification`, `#risks`) and a matching table of contents that links to them

Avoid:
- huge decorative gradients
- overly slick teal/purple/blue "AI dashboard" accents
- fake metrics
- fake precision or invented event times
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
