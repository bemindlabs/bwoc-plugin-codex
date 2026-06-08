---
name: bwoc-team
description: Manage BWOC Saṅgha teams — create, list, retire a named subset of agents sharing a task list. Wraps `bwoc team`. Use to organize agents into coordinating groups.
---

# bwoc-team

Manage Saṅgha teams — a named subset of agents sharing a task list. Wraps the `bwoc team` subcommands.

```bash
bwoc team <COMMAND> ...
```

## Subcommands (exact usage)

- **list** — `bwoc team list [--json]`
  List teams in the workspace with member + task counts. Read-only.
- **create** — `bwoc team create <ID> [--members a,b,c] [--json]`
  Create a team with a member list. `<ID>` is kebab-case by convention; `--members` is comma-separated agent ids.
- **retire** — `bwoc team retire <ID> [--yes] [--json]`
  Retire a team (removes its membership file + task list). `--yes` skips the confirmation prompt.

All subcommands accept `--workspace <PATH>` and `--lang <en|th>`.

> To add/remove members of an existing team, edit `.bwoc/teams/<team>.toml` directly — there is no member-add subcommand.

## Examples

```bash
bwoc team list
bwoc team create build-squad --members agent-luban,agent-nezha,agent-taibai
bwoc team retire build-squad --yes
```

This is a thin wrapper — no business logic. Surface results to the user.
