# Skills

This directory holds the Codex plugin's skills, in the standard
`skills/<name>/SKILL.md` format (YAML frontmatter `name`/`description` + body).

## Committed coordination skills (`bwoc-*`)

The `bwoc-*/` skills are thin, hand-maintained wrappers over the `bwoc` CLI
(list, status, send, run, chat, task, team, memory, fleet). These are checked
into git.

## Generated framework re-exports (`fw-*`)

The `fw-*/` skills are **generated locally and gitignored** — they are not
checked in. They re-export the BWOC framework skills available in a given
workspace so Codex can invoke them.

Regenerate them by pointing `BWOC_WORKSPACE` at a BWOC workspace and running the
generator:

```bash
BWOC_WORKSPACE=/path/to/workspace bash scripts/sync-skills.sh
```

Each generated skill is named `bwoc-fw-<name>`, carries the framework skill's
description, and points back to `modules/skills/<name>/SPEC.md` in the
workspace. Empty workspaces (no skills) produce nothing. Re-run the script
whenever the workspace's skills change.
