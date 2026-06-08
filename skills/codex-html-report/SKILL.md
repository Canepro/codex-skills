---
name: codex-html-report
description: Use when creating durable Codex work artifacts such as completed-work reports, proof reports, implementation closeouts, deployment verification, code reviews, operational/support case summaries, research briefs, architecture plans, or complex explanations that should be read in a browser. Produces self-contained lightweight HTML with clear visual hierarchy, evidence, verification, risks, and next steps.
metadata:
  short-description: Create polished self-contained HTML reports
---

# Codex HTML Report

Use this skill when the output should live beyond the chat as a readable artifact:
- implementation closeouts with proof
- ops incidents, support cases, or deployment verification
- code reviews, architecture plans, research briefs, or complex explanations
- any durable report where layout, navigation, tables, screenshots, or collapsible evidence would improve comprehension

Do not use this skill for tiny answers, paste-ready support replies, one-command outputs, or when the user explicitly asks for Markdown/plain text.

## Goal

Create a self-contained browser-native report: lightweight, visually pleasing, evidence-first, dark-first by default, and readable from `file://` with no build step.

The report should feel like a small internal product, not a decorative dashboard. Prefer crisp hierarchy, restrained color, useful tables, timelines, proof blocks, and honest status over ornamental visuals.

Default to dark mode/dark-first styling for read-mostly reports. Do not create a light-mode report unless the user asks for it, the destination platform requires it, or there is a clear accessibility/user-context reason. Avoid jarring mode switches after dark-mode work surfaces.

## Default Location

Write reports under the current working context:
- preferred: `reports/YYYY-MM-DD-short-topic.html`
- projectless sessions: use the active Codex workspace directory
- existing repo convention wins if there is already a `reports/`, `docs/reports/`, or similar artifact folder

Do not write to the home directory unless the user asks.

## Template

Use `templates/report.html` as the canonical starting point. Copy it into the destination report and replace the sample content with task-specific content.

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
- What remains uncertain?
- What should the user do next?

## Visual Rules

Use a reusable visual system:
- dark-first base styling with comfortable contrast for long reading
- status strip for Done / Partial / Blocked / Risk
- outcome panel with the plain-English verdict
- gate checklist for ops, migration, deployment, and incident reports
- proof rail for commands, logs, screenshots, tickets, and changed files
- tables for files, tests, risks, and decisions
- timestamped timeline for event order when it matters; use actual observed times, not generic "Step 1" labels alone
- section anchors and IDs for stable navigation jumps
- collapsible appendix for raw evidence
- sticky or top navigation for longer reports

Avoid:
- huge decorative gradients
- overly slick teal/purple/blue "AI dashboard" accents
- fake metrics
- fake precision or invented event times
- low-information cards
- dense Markdown dumped into HTML
- external dependencies
- mobile overflow or clipped text

## Evidence Rules

Prefer concrete proof:
- commands run and pass/fail result
- exact local file paths
- short log/output excerpts
- screenshots with absolute local paths when available
- source URLs or ticket IDs when used
- redacted proof for sensitive values when references are needed
- explicit "not verified" entries for skipped or unavailable checks

Do not imply review of logs, attachments, code, or screenshots unless they were actually opened.
- Never include raw credentials or tokens in a report. Replace values with redacted evidence where possible.

## Workflow

1. Decide whether HTML is warranted. If the artifact is small, answer in chat.
2. Copy `templates/report.html` to the destination report path.
3. Replace the template content with the task-specific report. Keep only useful sections.
4. Verify the HTML is self-contained and opens locally.
5. Validate anchors, keyboard traversal, and that print/PDF output behaves with readable page breaks.
5. Run the checks in `references/report-qa.md` when the report is substantial or the template changed.
6. In the final chat reply, give the report path and a compact summary of what it contains.

## Final Reply

Keep the chat closeout short:
- say the report was created
- link the absolute local path
- mention the report type and top-level status
- mention any verification limitation
