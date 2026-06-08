# bwoc-plugin-codex

> **BWOC → OpenAI Codex plugin adapter.** Exposes the BWOC agent fleet — coordination CLI, agents-as-subagents, skills, and deep-memory — into **OpenAI Codex** by wrapping the `bwoc` CLI.

**Status:** 🚧 WIP scaffold.
Part of the BWOC **八仙過海・各顯神通** host-adapter set (Eight Immortals crossing the sea — each adapter crosses into a foreign host by its own plugin format).

**Steward:** `agent-caoguojiu` (Cao Guojiu 曹國舅) — debased to this project ([`bwoc debase`](https://github.com/bemindlabs/BWOC-Framework)).

## What it exposes

| Surface | Wraps |
|---|---|
| Coordination | `bwoc list / status / send / run / chat / task / team` |
| Agents | BWOC `agents/agent-*` re-exported as OpenAI Codex sub-agents |
| Skills | BWOC skills re-exported as OpenAI Codex skills |
| Deep-memory | `bwoc memory` bridge |

Mechanism: **shell-out to the `bwoc` CLI** — no standing server. The host must have `bwoc` on `PATH`.

## Manifest

Host plugin manifest: `.codex-plugin/plugin.json`

## License

MIT © Bemind Technology
