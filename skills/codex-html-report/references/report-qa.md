# Report QA Checklist

Use this checklist before finishing a substantial report or any canonical template change.

## Required

- The report opens from `file://` with no build step.
- No external fonts, CDNs, scripts, or network-only assets are required.
- The first viewport states the outcome, status, report type, and next step.
- The report includes evidence for the main claim: commands, files, logs, screenshots, tickets, or source links as applicable.
- Verification is explicit: passed, failed, skipped, or not verified.
- The report does not replace the underlying work proof. Installs, runtime sync,
  tests, commits, pushes, deploys, or cleanup are verified separately when the
  report claims they happened.
- Timelines include actual observed timestamps when a sequence is shown. If exact time was not captured, say that instead of inventing one.
- Ops, migration, deployment, and incident reports include gates or stop conditions before risky next moves.
- Residual risk is either real and stated, or omitted/marked low without theater.
- Local file paths are absolute when they need to be clickable or inspectable.
- Mobile layout does not clip text, tables, nav, or status labels.
- Full-page screenshots, print/PDF paths, and normal scrolling show report
  sections by default. Do not hide evidence or major sections behind
  scroll-triggered reveal animation.
- Reports are dark-first by default unless the user or target platform explicitly requires light mode.
- Dark-first contrast remains readable for body text, muted text, code, tables, and links.
- The report does not create a jarring light-mode switch after dark-mode work surfaces.
- The accent palette is restrained and domain-appropriate; avoid glossy AI-dashboard styling.
- Substantial reports created through this skill preserve the canonical
  `templates/report.html` shell unless an explicit exception is documented:
  template version comment, `data-theme="dark"`, topbar tools, standard anchors,
  status pills, table wrappers, evidence blocks, and print CSS.
- The final chat reply links the report and mentions any verification limitation.

## Template Change Checks

- Update the version comment in `templates/report.html`.
- Update `references/template-improvements.md` with the decision and verification.
- Check the template remains self-contained with a search for `http://`, `https://`, `cdn`, `@import`, and `<script` unless script behavior is intentional.
- Keep CSS and section patterns reusable rather than tuned only for one report.
- Apply the same important fix to any current example report when it is being used as proof.
