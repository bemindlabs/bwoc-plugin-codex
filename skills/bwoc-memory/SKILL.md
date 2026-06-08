---
name: bwoc-memory
description: Read and search BWOC workspace-level memory (`.bwoc/memory/`) and Tier-2 deep memory. Wraps `bwoc memory`. Use to recall prior decisions, notes, and session context.
---

# bwoc-memory

Read workspace-level memory (`.bwoc/memory/`) and the Tier-2 deep-memory bridge. Wraps the `bwoc memory` subcommands.

```bash
bwoc memory <COMMAND> ...
```

## Subcommands (exact usage)

Tier 1 — user-authored memory entries:

- **list** — `bwoc memory list [--json] [--count] [--names-only] [--sort name|size|modified]`
  List memory entries. Read-only.
- **show** — `bwoc memory show [NAME] [--all] [--json]`
  Print one entry's contents, or `--all` for every entry concatenated.
- **search** — `bwoc memory search <QUERY> [--json]`
  Case-insensitive substring search across entries.
- **put** — `bwoc memory put <NAME> [content] [--file <FILE>]`
  Write an entry. Source precedence: inline content > `--file` > stdin. (Mutating — only use when the user explicitly asks.)
- **rm** — `bwoc memory rm <NAME> [--yes]`
  Delete an entry. (Mutating.)

Tier 2 — deep memory (per agent, via `deepMemoryCmd`):

- **wake-up** — `bwoc memory wake-up <AGENT>` — emit prior context at session start.
- **t2-search** — `bwoc memory t2-search <QUERY> <AGENT>` — search past decisions/notes.
- **mine** — `bwoc memory mine <path> --mode <mode>` — persist session learnings at session end.

Most subcommands accept `--workspace <PATH>` and `--lang <en|th>`.

## Examples

```bash
bwoc memory list
bwoc memory show --all
bwoc memory search "deploy plan"
bwoc memory wake-up <agent>
bwoc memory t2-search "auth refactor" <agent>
```

Prefer the read-only subcommands (`list`, `show`, `search`, `wake-up`, `t2-search`). Treat `put`, `rm`, and `mine` as mutating — only run when explicitly requested. This is a thin wrapper — no business logic.
