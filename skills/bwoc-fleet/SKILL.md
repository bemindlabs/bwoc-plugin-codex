---
name: bwoc-fleet
description: Overview of how to coordinate the BWOC agent fleet from OpenAI Codex. Explains when to use each bwoc verb (list/status/send/run/chat/task/team/memory) and how they fit together. Start here for any multi-agent coordination request.
---

# bwoc-fleet — coordinating the BWOC fleet from Codex

This plugin exposes the **BWOC** agent fleet into OpenAI Codex by wrapping the `bwoc` CLI. Every skill is a thin shell-out — there is no server or daemon. The BWOC workspace (with `.bwoc/agents.toml`) must be reachable from where Codex runs, and `bwoc` must be on `PATH`.

## Mental model

```
Codex  ──@skill──▶  skill instructions  ──exec──▶  bwoc CLI  ──▶  BWOC workspace
                                                                  (agents, teams,
                                                                   tasks, memory)
```

Agents are persistent, named, backend-neutral workers (Claude, Codex, Antigravity, Kimi, Copilot, Ollama, …). Teams are named subsets sharing a task list. Memory is workspace-level recall.

## Which verb when

| Goal | Skill | Command |
|---|---|---|
| Discover what agents exist | `bwoc-list` | `bwoc list` |
| Inspect one agent's health/identity | `bwoc-status` | `bwoc status <name>` |
| Hand work to an agent, async (no reply) | `bwoc-send` | `bwoc send <to> "<msg>"` |
| Get a one-shot result back (headless) | `bwoc-run` | `bwoc run <agent> --task "..."` |
| Interactive back-and-forth | `bwoc-chat` | `bwoc chat <name>` |
| Coordinate work across a team | `bwoc-task` | `bwoc task <add\|list\|claim\|complete\|plan\|approve>` |
| Organize agents into groups | `bwoc-team` | `bwoc team <create\|list\|retire>` |
| Recall prior decisions/notes | `bwoc-memory` | `bwoc memory <list\|show\|search\|wake-up\|t2-search>` |

## A typical coordination flow

1. **Survey** — `bwoc list` (optionally `--status active --json`) to see who's available and which backend they run.
2. **Inspect** — `bwoc status <name>` on candidates to confirm health/identity.
3. **Delegate**:
   - Need an answer now? `bwoc run <agent> --task "..."` and relay the captured output.
   - Just queuing work? `bwoc send <agent> "..."` (fire-and-forget).
4. **Coordinate a team** — `bwoc team create <id> --members ...`, then drive the shared list with `bwoc task add/list/claim/complete`. Plan-gated tasks use `task plan` → `task approve` → `task complete` (Pavāraṇā).
5. **Remember** — `bwoc memory search "<topic>"` or `bwoc memory wake-up <agent>` to pull prior context before deciding.

## Safety rules

- Prefer **read-only** verbs when exploring: `list`, `status`, `team list`, `task list`, `memory list/show/search/wake-up/t2-search`.
- **Mutating** verbs (`send`, `run`, `chat`, `task add/claim/complete`, `team create/retire`, `memory put/rm/mine`) act on the live fleet — run them only when the user's intent is clear.
- Always quote user-supplied text (messages, task titles, plans) so shell metacharacters are not interpreted.
- Keep everything a thin wrapper — business logic lives in the BWOC framework, not in this plugin.

## Useful flags shared across verbs

- `--json` — machine-readable output (available on most verbs) for parsing before you act.
- `--workspace <PATH>` — point at a specific workspace root if not auto-resolved.
- `--lang <en|th>` — output language.
