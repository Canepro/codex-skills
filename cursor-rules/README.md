# Cursor rules from codex-skills

Templates installed by `scripts/install.sh` into `~/.cursor/codex-skills-rules/`.

## Global (every project)

1. Open **Cursor Settings → Rules → User Rules**
2. Paste the contents of `USER-RULE-anti-ai.txt`

User Rules apply to Agent and Chat across all workspaces on this machine.

## Per project

Copy `anti-ai-writing.mdc` into the repo at `.cursor/rules/anti-ai-writing.mdc`.

Set type to **Always Apply** if Cursor does not pick up `alwaysApply: true` from frontmatter.
