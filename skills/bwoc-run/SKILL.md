---
name: bwoc-run
description: Run a single task on a BWOC agent non-interactively and capture the result (headless). Wraps `bwoc run`. Use when you need a one-shot answer/output back from an agent.
---

# bwoc-run

Run a single task on an agent non-interactively and capture the result (headless mode). Unlike `bwoc-send`, this blocks until the agent finishes and returns its output.

Wraps the `bwoc` CLI:

```bash
bwoc run <AGENT> --task "<TASK>"
```

- `<AGENT>` — agent by id (`agent-foo`) or bare name (`foo`).
- `--task <TASK>` — the task prompt to deliver (**required**).

## Options (pass through verbatim)

- `--json` — structured JSON `{ agent, backend, task, exit_code, duration_ms, output }`.
- `--timeout <SECONDS>` — kill the process and report timeout if it runs longer.
- `--workspace <PATH>` — override workspace root.
- `--lang <en|th>` — output language.

## Examples

```bash
bwoc run <agent> --task "List three risks in the current deploy plan."
bwoc run <agent> --task "Summarize open PRs" --json
bwoc run <agent> --task "Long analysis" --timeout 300
```

Quote the task safely so user text with shell metacharacters is not interpreted. This is a thin wrapper — relay the captured output (or parsed JSON) to the user.
