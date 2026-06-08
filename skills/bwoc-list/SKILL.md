---
name: bwoc-list
description: List BWOC agents registered in the workspace. Wraps `bwoc list`. Use to discover which agents exist, their backend, status, and pending inbox counts.
---

# bwoc-list

List the agents registered in the enclosing BWOC workspace's `agents.toml`.

This is a **read-only** wrapper over the `bwoc` CLI. Run:

```bash
bwoc list
```

## Options (pass through verbatim)

- `--json` — emit machine-readable JSON instead of the table.
- `--status <STATUS>` — filter by status (`active`, `stopped`, `retired`).
- `--backend <BACKEND>` — filter by backend (`claude`, `antigravity`, `codex`, `kimi`, `copilot`, `ollama`, `openai-compatible`).
- `--running` — only agents whose daemon is actually running.
- `--inbox-pending` — only agents with at least one pending inbox envelope.
- `--sort <id|inbox|incarnated|backend>` — sort key.
- `--count` — print just the integer count of matching agents.
- `--names-only` — bare agent ids, one per line (handy for `for name in $(...)` loops).
- `--workspace <PATH>` — override workspace root (default: `BWOC_WORKSPACE` env > ancestor walk > cwd).
- `--lang <en|th>` — output language.

## Examples

```bash
bwoc list                              # full table
bwoc list --json                       # JSON for parsing
bwoc list --status active --names-only # ids of active agents
bwoc list --backend codex              # only Codex-backed agents
bwoc list --inbox-pending --count      # how many agents have mail waiting
```

Surface the result back to the user. Do not add business logic — this is a thin wrapper.
