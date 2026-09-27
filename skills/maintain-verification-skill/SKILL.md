---
name: maintain-verification-skill
description: Audit and repair a project-local verification skill and its feature map using source inspection plus one live pass. Use when verification instructions, harness commands, selectors, or documented user features may have drifted.
metadata:
  upstream: https://github.com/cursor/plugins/tree/main/pstack/skills/maintain-verification-skill
  upstream-commit: 60c641e4fad674784b30abcf9f8915dea39df38d
  maintenance-source: https://github.com/cursor/plugins/blob/ecc249f1e306fc64ddf83c7bed16cacf7c2239db/pstack/skills/maintain-verification-skill/SKILL.md
  adapted-for: Agent Skills multi-harness layout
---

# Maintain a verification skill

Keep a repository's verification skill honest. Cover every mapped feature from
source, exercise every reachable feature through the real user-facing surface,
and ship at most one focused correction to the verification skill itself.

This workflow adapts pstack's `maintain-verification-skill` for a shared Agent
Skills layout. It does not authorize product-code changes.

## Outcomes

Finish with exactly one outcome:

- `clean`: Every mapped feature received source and live coverage. No change is
  needed.
- `changed`: One verified change repairs the skill, its feature map, or a helper
  it owns.
- `blocked`: Coverage could not finish safely. Name the exact missing
  prerequisite or failed proof; an unreachable route remains incomplete live
  proof.

When any required coverage remains incomplete, `blocked` takes precedence over
`changed`. Report substantive repairs inside that blocked result and name the
remaining proof; a repair alone does not complete the audit.

## Locate the owner

Find the repository-owned verification skill, usually under
`.agents/skills/verify-*/` or an established equivalent. If several harness
paths exist, resolve their targets and identify the single canonical owner.
Stop on divergent copies instead of editing all of them independently.

If no verification skill exists, use `create-verification-skill` rather than
inventing a maintenance target.

## Audit and repair

1. Compare the feature-map index with its feature files. Fix missing, duplicate,
   stale, or dead entries.
2. Read the source path for every mapped feature. Record likely documentation,
   selector, command, or prerequisite drift with exact source references.
3. Sweep recent user-facing code changes for important features missing from
   the map. Require a concrete source path before adding one.
4. Follow the verification skill's own launch and doctor contract. Temporary
   listeners must bind to loopback. Do not drive an instance whose identity,
   build, or health is uncertain.
5. Exercise every reachable mapped feature. Capture proof before cleanup and
   confirm the proof survives cleanup.
   - Before another drive after surprising behavior, run doctor. If the process
     is healthy but the user surface is wedged, restore the skill's known user
     state. Relaunch a run-owned instance only when its documented launch
     contract restores that state.
   - Remove drive-owned residue after a failed attempt. Keep a shared instance
     when its launch contract requires one; clean the failed drive's residue,
     not the shared instance. Recheck retained proof after cleanup.
   - If doctor failure shows owned instruction, feature-map, selector, or helper
     drift, repair it, restart only what the repair invalidated, and run one
     fresh doctor-and-drive retry. A failed retry is `blocked`.
   - For an unreachable feature, record the attempted route and exact unmet
     prerequisite in the run notes. If the map omitted that prerequisite,
     repair the map; the feature still lacks live proof.
6. Classify each mismatch:
   - Wrong instructions or feature description: repair the verification skill.
   - Working product that the harness cannot drive: repair the owned harness.
   - Broken product behavior: report the product defect. Do not hide it by
     changing the verification contract.
7. Re-drive every corrected path before shipping. At final teardown, remove
   only processes and scratch state started by this run, then confirm retained
   proof still exists.

Keep edits inside the canonical verification-skill directory. For `changed`,
review every changed file and ship one focused commit or pull request when the
repository task includes normal collaboration. For `clean` or `blocked`, do not
create a change merely to record the run.

