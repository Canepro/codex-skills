# Template Improvements

Use this file when changing the canonical `templates/report.html` or the report system behavior. Keep entries short, evidence-based, and useful for future template tuning.

## Current Version

`v0.6.0`

## Version Rules

- Patch version: small visual, contrast, copy, or QA improvements.
- Minor version: new reusable section pattern, report type, layout system, or interaction.
- Major version: incompatible structure change or a new report-generation model.

## Improvement Backlog

| Priority | Idea | Reason | Status |
| --- | --- | --- | --- |
| P1 | Add report-type variants | Support cases, code reviews, and ops incidents need different default section order. | Proposed |
| P1 | Add print/export polish | Durable reports may be shared or printed later. | Done in v0.5.0 (light panels, dark-on-light code, nav hidden) |
| P2 | Add optional theme toggle | Dark-first should stay default, but light mode can be useful for print or sharing. | Done in v0.6.0 (topbar toggle, dark default, light palette) |
| P2 | Add screenshot/media pattern | Some reports need proof images with captions and local paths. | Proposed |
| P3 | Add compact mode | Dense support/ops reports may need less vertical space. | Proposed |

## Decision Log

### 2026-06-18 - v0.6.0 - Optional interactivity: theme toggle, copy, tabs

Added broadly reusable interactivity after report feedback that a faithfully-filled template read as generic. Kept dark-first default and the v0.5.0 editorial system; layered in optional, feature-detected behaviors.

Changes:
- topbar tools: a light/dark theme toggle (dark stays the default via `data-theme="dark"`) and a Save-PDF button (`window.print()`)
- added an `html[data-theme="light"]` palette (cream surfaces, dark ink, darker amber for AA contrast) so the toggle has a real light mode without a jarring switch
- converted status pills from hardcoded rgba to `color-mix(in srgb, var(--token) ..%, transparent)` so they adapt to either theme
- copy-to-clipboard button injected on every `<pre>` evidence block (JS wraps each `pre` in `.pre-wrap`); shows on hover/focus, falls back to a manual-copy hint when the Clipboard API is unavailable
- added a reusable, accessible tabs pattern (`role=tablist`/`tab`/`tabpanel`) as a new optional `Options` section plus a nav entry, for comparing options/environments/before-after
- print styles hide the toolbar and copy buttons and reveal all hidden tabpanels so no content is lost on export
- all new JS is feature-detected and wrapped in one IIFE, so deleting any section keeps the report working
- added an empty data-URL favicon so local static-server QA does not create a misleading `/favicon.ico` console error

Preserved: every contract section (Outcome, Next, Gates, Changes, Verification, Timeline, Risks, Evidence), the timestamped timeline, dark-first default, the graphite/amber palette, and single-file self-contained output.

Reason: future reports should ship with the polish and explorability that landed well in a live report (the n8n/Zoho architecture plan), without specializing the template to one topic.

Verification:
- rendered the template in a browser via a local static server; confirmed hero, facts strip, nav (now nine anchors incl. Options), sections, and footer
- exercised behaviors in-page: theme toggle flips light/dark and back; Options tabs switch panels (A hidden when B shown); a copy button is injected on the single `<pre>` block; no console errors
- self-contained check: no `http(s)`, `cdn`, or `@import`; one intentional inline favicon; single intentional `<script>`; section tags balance 11/11; no duplicate IDs
- light-theme amber (`#a9711f`) and ink (`#1c2027`) chosen for AA contrast on cream surfaces

### 2026-05-30 - v0.5.0 - Editorial redesign with layered surfaces

Reworked the visual system after review feedback that the v0.4.0 pass still read as a flat dark admin surface: panels did not separate from the page, the hero wasted space, and the amber accent was underused.

Changes:
- introduced an explicit elevation system (page below section below inset) with distinct surface tokens, hairline borders, and soft shadows so panels read as separate objects
- replaced the two-column hero (which stretched against the taller meta column and left a dead zone) with a full-width editorial headline band plus a horizontal four-up key-facts strip
- added an amber kicker above the title, fixed the title scale so it no longer wraps oversized, and tightened the type rhythm
- kept the editorial serif for the title and section headings but supported it with amber eyebrows and crisper hierarchy so it reads intentional rather than bolted on
- turned the timeline into a real connected sequence with amber nodes and a vertical rail
- refined nav, status pills, tables, code/pre, and collapsible details; strengthened print styles
- nudged the muted label color brighter so table headers clear WCAG AA

Preserved from v0.4.0 and v0.3: Outcome, Next, Gates, Changes, Verification, Timeline, Risks, the evidence index, the timestamped timeline, long-value handling, dark-first default, the restrained graphite/amber palette, and single-file self-contained output.

Reason: the information architecture from v0.3 and v0.4 was right, but the surface needed real depth, a stronger hero, and bolder-but-restrained accent use to feel like a polished browser-native report instead of a plain dark panel stack.

Verification:
- rendered desktop (1280px) and mobile (375px) in a browser and confirmed hero, facts strip, sections, timeline, and collapsibles
- confirmed all eight nav anchors resolve and there are no duplicate IDs (DOM audit)
- confirmed no external assets: no link/script/img tags, and no `http`, `cdn`, or `@import` in source
- checked that table, details, and section tags balance
- recomputed WCAG contrast for ink, muted, labels, table headers, links, status pills, and code; all key pairs clear AA

### 2026-05-30 - v0.4.0 - Restore richer report typography

Restored a more designed report surface after review feedback that the v0.3.1 pass had become too plain compared with the richer external design direction.

Changes:
- kept the v0.3 operational additions: `Next`, `Gates`, `Risks`, evidence index, timestamped timeline, and long-value handling
- restored richer display typography using a local system serif stack for report titles and section headings
- added a more deliberate dark hero treatment, subtle rule accent, and stronger panel hierarchy
- retained the restrained graphite/amber palette instead of returning to teal/purple AI-dashboard styling
- removed viewport-width font scaling from the main title and used fixed responsive breakpoints instead

Reason: the live template needed the information architecture hardening from v0.3, but the visual system should still feel like a polished browser-native report rather than a plain admin page.

Verification:
- checked template anchors resolve
- checked table/detail tags remain balanced
- confirmed the template remains self-contained
- recalculated core dark-mode contrast pairs

### 2026-05-30 - v0.3.1 - Template polish after external review

Applied small fixes after reviewing an external pass on the skill.

Changes:
- aligned the skill UI brand color with the graphite/amber template palette
- added `Timeline` to the default navigation because the template ships with a timeline section
- strengthened print styles so dark panels and muted text do not print as dark-mode leftovers
- replaced the placeholder `href="#"` source link with an internal report anchor

Reason: the v0.3.0 template was directionally sound, but a few defaults were stale or incomplete enough to create friction in generated reports.

Verification:
- checked template anchors resolve
- checked table/detail tags remain balanced
- confirmed the template remains self-contained
- recalculated core dark-mode contrast pairs

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
