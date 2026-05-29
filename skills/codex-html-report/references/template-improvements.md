# Template Improvements

Use this file when changing the canonical `templates/report.html` or the report system behavior. Keep entries short, evidence-based, and useful for future template tuning.

## Current Version

`v0.3.0`

## Version Rules

- Patch version: small visual, contrast, copy, or QA improvements.
- Minor version: new reusable section pattern, report type, layout system, or interaction.
- Major version: incompatible structure change or a new report-generation model.

## Improvement Backlog

| Priority | Idea | Reason | Status |
| --- | --- | --- | --- |
| P1 | Add report-type variants | Support cases, code reviews, and ops incidents need different default section order. | Proposed |
| P1 | Add print/export polish | Durable reports may be shared or printed later. | Proposed |
| P2 | Add optional theme toggle | Dark-first should stay default, but light mode can be useful for print or sharing. | Proposed |
| P2 | Add screenshot/media pattern | Some reports need proof images with captions and local paths. | Proposed |
| P3 | Add compact mode | Dense support/ops reports may need less vertical space. | Proposed |

## Decision Log

### 2026-05-16 - v0.3.0 - Live ops report hardening

Changed the canonical template after reviewing a live operations report as a representative use case.

Changes:
- replaced the teal-accent visual direction with a quieter graphite/amber palette
- added a gate checklist pattern for ops, migration, deployment, and incident reports
- made the default nav include `Next`, `Gates`, `Risks`, and `Evidence`
- changed timeline examples to require actual timestamps instead of generic step labels
- added an evidence index table before collapsible raw proof blocks
- added table wrappers and path/hash code classes for long operational values

Reason: the live report showed that operational artifacts need clearer stop/go semantics, timestamped chronology, less AI-dashboard gloss, and better handling for long paths, hashes, and proof blocks.

Verification:
- checked the template remains self-contained
- updated the report QA checklist to require timestamps, gates, and restrained accents
- applied the same pattern to the live operations report used as the evidence case

### 2026-05-16 - v0.2.0 - Dark-first readability pass

Changed the canonical template from warm light mode to dark-first. Increased contrast for body text, muted text, navigation pills, code chips, tables, panels, and preformatted evidence blocks.

Reason: the first generated report had readability issues in the in-app browser, and dark mode is a better default for proof/report surfaces used during engineering work.

Verification:
- checked the template and current example report remained self-contained
- confirmed no external `http`, CDN, `@import`, or script dependency
- calculated contrast pairs for body text, muted text, accent links, code chips, and table headers; all key pairs were comfortably above WCAG thresholds

### 2026-05-16 - v0.1.0 - Initial canonical template

Created the first global `codex-html-report` skill and a single-file HTML template with status cards, navigation, tables, timeline, collapsible evidence, and residual-risk sections.

Reason: durable Codex reports should be browser-native, self-contained, visually readable, and reusable across sessions/projects.

Verification:
- created the skill, template, metadata, and first example report
- validated skill metadata YAML
- checked the template was self-contained
