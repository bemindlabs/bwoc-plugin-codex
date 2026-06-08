---
name: bwoc-send
description: Append a message to a BWOC agent's inbox (fire-and-forget). Wraps `bwoc send`. Use to hand work or notes to an agent asynchronously.
---

# bwoc-send

Append a message to an agent's inbox (`.bwoc/inbox.jsonl`). Fire-and-forget — it does **not** wait for a reply (use `bwoc-run` for that).

Wraps the `bwoc` CLI:

```bash
bwoc send <TO> <MESSAGE>
```

- `<TO>` — recipient agent, by id (`agent-foo`) or bare name (`foo`).
- `<MESSAGE>` — message text. Quote multi-word messages. Mutually exclusive with `--file`.

## Options (pass through verbatim)

- `--file <FILE>` — use a file's full contents as the message body (instead of `<MESSAGE>`).
- `--from <FROM>` — sender identity. Default `user`. Pass an agent name for agent→agent messaging (the named sender must exist in the registry).
- `--reply-to <MESSAGE_ID>` — thread this as a reply to a prior envelope (`msg-<slug>-<hex>`).
- `--no-wakeup` — skip the best-effort tmux wakeup ping.
- `--workspace <PATH>` — override workspace root.
- `--lang <en|th>` — output language.

## Examples

```bash
bwoc send agent-luban "Please draft the API spec for the new endpoint."
bwoc send luban --file ./brief.md
bwoc send luban "ack" --from agent-caoguojiu --reply-to msg-foo-1a2b
```

Always quote the message safely so shell metacharacters in user text are not interpreted. This is a thin wrapper — no business logic.
