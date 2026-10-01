# Report types and section order

One template shell serves every report type. Pick the closest type, keep the
sections listed for it in this order, and delete the rest. Rename a section
heading when the label below reads better for the audience; keep the `id`
so internal links and the table of contents keep working.

Section ids available in `templates/report.html`: `outcome`, `next-action`,
`facts`, `gates`, `changes`, `verification`, `timeline`, `environment`,
`risks`, `evidence`.

| Type | Sections in order | Notes |
| --- | --- | --- |
| `implementation-closeout` | outcome, next-action, changes, verification, risks, evidence | Default type. `facts` strip shows files changed, checks passed, open risks. |
| `ops-incident` | outcome, next-action, gates, timeline, environment, risks, evidence | Timeline uses observed timestamps. Gates list stop conditions before the next risky move. |
| `support-case` | outcome, next-action, timeline, verification, evidence | Outcome states the customer-safe position. Evidence redacts customer data and credentials. |
| `code-review` | outcome, changes, verification, risks, evidence | Outcome is the verdict. `changes` lists findings by file. `verification` records test gaps as Not verified. |
| `research-brief` | outcome, next-action, changes, risks, evidence | `changes` becomes "Findings" or "Decision matrix". Evidence lists sources with URLs or paths. |
| `architecture-plan` | outcome, gates, changes, timeline, risks, evidence | `changes` becomes "Proposed design". `timeline` becomes "Migration path". Gates are the preconditions for each phase. |

Every type keeps `outcome` first and `evidence` last. If a type needs a
section not listed here, add it between `next-action` and `risks` and say why
in the report.
