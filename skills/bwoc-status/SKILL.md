---
name: bwoc-status
description: Show a per-agent health and identity snapshot for the BWOC fleet. Wraps `bwoc status`. Read-only — use to inspect a single agent or summarize all agents.
---

# bwoc-status

Show a read-only health + identity snapshot for one agent, or a summary table for all.

Wraps the `bwoc` CLI:

```bash
bwoc status [NAME]
```

`NAME` matches by id (`agent-foo`) or bare name (`foo`). Omit it to print the per-agent summary table.

## Options (pass through verbatim)

- `--all` — full detail block for every agent (mutually exclusive with `NAME` and `--banner`).
- `--banner` — replay a named agent's startup liveness banner from its manifest (read-only, no daemon).
- `--json` — emit JSON instead of the human layout.
- `--workspace <PATH>` — override workspace root.
- `--lang <en|th>` — output language.

## Examples

```bash
bwoc status                  # summary table for the whole fleet
bwoc status agent-luban      # single-agent detail
bwoc status luban --json     # JSON snapshot
bwoc status --all            # every agent's detail block
bwoc status luban --banner   # replay startup banner
```

This is a thin, read-only wrapper. Relay the output to the user.
