---
name: bwoc-task
description: Manage a BWOC team's shared task list — add, list, claim, complete, plan, approve, reject. Wraps `bwoc task`. Use to coordinate work across a team.
---

# bwoc-task

Manage a team's shared task list. Wraps the `bwoc task` subcommands.

```bash
bwoc task <COMMAND> ...
```

## Subcommands (exact usage)

- **add** — `bwoc task add <TEAM> <TITLE> [--deps a,b] [--id <ID>] [--requires-plan] [--json]`
  Add a task. `--deps` gates it on other task ids; `--requires-plan` gates completion on lead plan approval (Pavāraṇā).
- **list** — `bwoc task list <TEAM> [--json]`
  List a team's tasks with state + claimant. Read-only.
- **claim** — `bwoc task claim <TEAM> <TASK> --as <AGENT> [--json]`
  Claim a pending, unblocked task as a team member.
- **complete** — `bwoc task complete <TEAM> <TASK> --as <AGENT> [--json]`
  Complete an in-progress task you claimed.
- **plan** — `bwoc task plan <TEAM> <TASK> [--as <AGENT>] [--plan "<TEXT>" | --plan-file <FILE>]`
  Submit/revise a plan for a claimed task, or show the current plan (omit `--as` and plan text to just show).
- **approve** — `bwoc task approve <TEAM> <TASK>`
  Lead approves a submitted plan so the claimant may complete.
- **reject** — `bwoc task reject <TEAM> <TASK>`
  Lead rejects a submitted plan; claimant must revise + resubmit.

All subcommands accept `--workspace <PATH>` and `--lang <en|th>`.

## Examples

```bash
bwoc task list build-squad
bwoc task add build-squad "Wire the new endpoint" --deps t1,t2
bwoc task claim build-squad t3 --as agent-luban
bwoc task plan build-squad t3 --as agent-luban --plan "1. spec 2. impl 3. test"
bwoc task approve build-squad t3
bwoc task complete build-squad t3 --as agent-luban
```

Quote titles and plan text safely. This is a thin wrapper — no business logic.
