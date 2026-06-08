---
name: bwoc-chat
description: Open an interactive chat session with a BWOC agent using its manifest-driven backend/model. Wraps `bwoc chat`. Use for back-and-forth conversation rather than one-shot tasks.
---

# bwoc-chat

Chat interactively with an agent — execs the agent's backend CLI with its manifest-driven model.

Wraps the `bwoc` CLI:

```bash
bwoc chat <NAME>
```

- `<NAME>` — agent by id (`agent-foo`) or bare name (`foo`).

## Options (pass through verbatim)

- `--tmux` — run under tmux instead of exec'ing in this shell (adds a window if already inside tmux; otherwise starts a `bwoc-<id>` session).
- `--ghostty` — open a new Ghostty terminal window (macOS only).
- `--tui` — full-screen ratatui chat client (harness backends only: `ollama` / `openai-compatible`; others fall back to exec).
- `--team <TEAM>` — join a team's shared chat channel (requires `--tui` + harness backend; agent must be a team member).
- `--workspace <PATH>` — override workspace root.
- `--lang <en|th>` — output language.

## Examples

```bash
bwoc chat <agent>
bwoc chat <agent> --tmux
bwoc chat <agent> --tui --team <team>
```

Note: `chat` is interactive and takes over the terminal. In a non-interactive Codex context prefer `bwoc-run` for a captured one-shot result. This is a thin wrapper — no business logic.
