# Template Improvements

Use this file when changing the canonical `templates/report.html` or the report system behavior. Keep entries short, evidence-based, and useful for future template tuning.

## Current Version

`v0.7.2`

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
| P2 | Add screenshot/media pattern | Some reports need proof images with captions and local paths. | Done in v0.7.0 (figure with caption, local path, click-to-zoom lightbox) |
| P3 | Add compact mode | Dense support/ops reports may need less vertical space. | Proposed |
| P2 | Add numeric KPI tiles | Infra and review reports benefit from a scannable metrics row with honest figures. | Done in v0.7.0 (stat tiles, meter bars) |
| P3 | Add callout/admonition pattern | Plans and reports need note/warn/danger emphasis blocks. | Done in v0.7.0 (note/tip/success/warn/danger) |

## Decision Log

### 2026-06-20 - v0.7.2 - No-JS control cleanup

Extended the v0.7.1 `<noscript>` fallback to hide controls that only work with
JavaScript: the theme toggle and Save-PDF buttons, the back-to-top button, and
the scroll progress bar. With scripting off these rendered but did nothing, the
same defect class v0.7.1 fixed for the tab bar. The "Generated" date stays in the
topbar, and all content (hero, sections, every tab panel) stays visible. Also
dropped the redundant `.reveal` rule from the noscript block because the base CSS
already keeps `.reveal` opaque.

Reason: a no-JS reader should not see buttons that cannot act. Hiding them matches
how the tab bar is already handled and keeps the no-JS view honest.

Verification:
- faithful no-JS render (script block removed, noscript styles promoted to active)
  served over a local static server
- with scripting off: theme/Save-PDF buttons, back-to-top, progress bar, and tab
  bar all compute `display: none`; the Generated date, hero, and all three tab
  panels stay visible; `document.body.scrollWidth` within client width (no overflow)
- with scripting on: both tool buttons, the tab bar, the injected copy button, and
  all 11 heading anchors present; no console warnings or errors

### 2026-06-20 - v0.7.1 - No-JS tabs and always-visible sections

Added a `<noscript>` fallback so optional tab panels are visible when JavaScript
is disabled. This keeps the v0.7.0 claim that the report still works with JS
off. Also removed content-hiding reveal-on-scroll behavior because it caused
blank regions in full-page mobile screenshots before below-fold sections had
intersected the viewport. Kept safe motion: soft landing on initial render,
hover lift, progress bar, scrollspy, lightbox, theme transitions, and
back-to-top remain.

Reason: browser QA showed the new template rendered well with JS enabled, but
two tab panels stayed hidden with JavaScript disabled. Visual screenshot review
also showed large blank regions from reveal-on-scroll. Reports are evidence
surfaces, so content must be visible by default. Motion is welcome when it does
not hide evidence.

Verification:
- no-JS browser render at 375px shows all tab panels visible
- desktop and mobile browser render still have no console errors or horizontal
  overflow
- full-page mobile screenshot shows sections without reveal-induced blank gaps

### 2026-06-20 - v0.7.0 - Richer reusable patterns and reading polish

Expanded the canonical template so it carries more of the polish a strong live
report needs (plans, closeouts, detailed infra reports) without specializing it
to one topic and without drifting into AI-dashboard gloss. Kept the graphite and
amber editorial identity, dark-first default, single-file output, and every
contract section.

New reusable patterns (each commented "Delete if unused"):
- stat tiles (`.stats`/`.stat`) for honest numeric KPIs, with up/down/flat trend text
- meter bars (`.meter`, `.meter.good/.warn/.bad`) for coverage and rollout progress
- callouts (`.callout` note/tip/success/warn/danger) for emphasis blocks
- spec key-value grid (`.specs`) for environment, config, and infra facts
- media figure (`.figure`) with caption, local path, and click-to-zoom lightbox; ships with a self-contained inline-SVG placeholder to swap for a real screenshot
- a new optional `Metrics` section and an `Environment` section, added to the nav

Reading and accessibility polish (all feature-detected, reduced-motion-aware):
- scroll progress bar at the top of the page
- scrollspy that highlights the nav link for the section in view (IntersectionObserver)
- back-to-top button that appears after scrolling
- reveal-on-scroll for sections, gated behind a JS-added `js-reveal` class so JS-off shows everything and `prefers-reduced-motion` skips it
- skip-to-content link, a global `:focus-visible` ring, `scope="col"` on table headers, and arrow-key navigation across the Options tabs
- theme toggle now persists the manual choice in `localStorage` (best-effort, wrapped in try/catch for `file://`)

Provenance: the hero now has a metadata row (generated-at with timezone, author or
lane, source revision or ticket) and the footer repeats it, satisfying the skill's
provenance-and-dating rule directly in the template instead of leaving it implied.

Hero and surface refinements: deeper page background, faint dot-grid texture (hidden
in print), a soft accent glow on the hero, larger radii, and card hover lift.

Print: hides the progress bar, back-to-top, anchors, and lightbox; forces revealed
sections visible; adds `break-inside: avoid` for stat tiles, callouts, figures, and
specs so new blocks do not split across pages.

Reason: a faithfully filled v0.6.0 report still read as light on structure for
metric-heavy and infra-heavy work. These patterns give the model honest,
restrained building blocks for those reports while keeping the canonical shell.

Verification:
- rendered via a local static server at 1280px and 375px; confirmed hero, facts, nav, 7/5 grid, metrics tiles, meters, gate table, environment specs, and media figure
- exercised behaviors in-page: theme toggle flips light/dark and persists; scrollspy marks the active nav pill; reveal added `.in` to all 11 sections; lightbox opens and closes; back-to-top appears after scroll
- mobile 375px: `document.body.scrollWidth` equals client width, so no horizontal overflow; nav wraps; tiles stack to one column
- console: no warnings or errors at warn level
- self-contained: no external `http(s)`, `cdn`, or `@import`; one intentional inline favicon; single `<script>`; real tags balanced; no duplicate IDs (live DOM audit returned none)
- light-theme amber (`#a9711f`) and ink (`#1b1f26`) kept for AA contrast on cream surfaces

### 2026-06-19 - v0.6.1 - Report completion guardrail

Changed the report workflow and QA checklist, without changing the template, so
durable HTML reports cannot stand in for unfinished implementation work.

Changes:
- `codex-html-report` now says installs, runtime sync, tests, commit/push, and
  cleanup must complete or be named as blockers before a report is treated as
  done.
- `report-qa.md` now checks that underlying work proof is separate from the
  report artifact.

Reason: reports are proof surfaces, not a permission slip to stop early.

Verification:
- no template version bump required because `templates/report.html` was not
  changed
- `bash scripts/check-drift.sh`

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
