<h1 align="center">bwoc-plugin-codex</h1>

<p align="center">
  <strong>BWOC → OpenAI Codex</strong> plugin adapter — bring the BWOC agent fleet into <a href="https://developers.openai.com/codex">OpenAI Codex</a>.
</p>

<p align="center">
  <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg">
  <img alt="Status" src="https://img.shields.io/badge/status-WIP-orange">
  <img alt="Host" src="https://img.shields.io/badge/host-OpenAI%20Codex-10a37f">
  <img alt="Part of BWOC" src="https://img.shields.io/badge/part%20of-BWOC-6f42c1">
  <img alt="Mechanism" src="https://img.shields.io/badge/mechanism-wraps%20bwoc%20CLI-informational">
</p>

---

## ✨ Overview

`bwoc-plugin-codex` packages the [**BWOC**](https://github.com/bemindlabs/BWOC-Framework) agent fleet as an **OpenAI Codex plugin** — a bundle of skills, hooks, and (optionally) MCP servers that let Codex drive your BWOC workspace: list agents, send work, run headless tasks, coordinate teams, and read shared memory.

It is **declarative + shell-out**: every skill wraps the `bwoc` CLI. No background server, no daemon.

> [!NOTE]
> **Status: WIP.** Coordination skills, hooks, and a repo-local marketplace are implemented and wrap the `bwoc` CLI. Remaining: skill re-export and a host smoke-test — see the [roadmap](#️-roadmap).

## 🧩 What it exposes

| Surface | BWOC capability | Wraps |
|---|---|---|
| **Skills** | Coordinate the fleet | `bwoc list` · `status` · `send` · `run` · `chat` · `task` · `team` |
| **Skills** | Reuse BWOC skills | BWOC skills re-exported as `skills/<name>/SKILL.md` |
| **Hooks** | Lifecycle side effects | `hooks/hooks.json` |
| **Memory** | Shared deep-memory | `bwoc memory` bridge |

## 🏗️ How it works

```
Codex  ──@bwoc skill──▶  skill instructions  ──exec──▶  bwoc CLI  ──▶  BWOC workspace
                                                                       (agents, teams,
                                                                        tasks, memory)
```

Hook commands receive `PLUGIN_ROOT` and `PLUGIN_DATA` in the environment. Every surface is a thin wrapper over a `bwoc` subcommand.

## 📋 Prerequisites

- [OpenAI Codex](https://developers.openai.com/codex)
- The [`bwoc` CLI](https://github.com/bemindlabs/BWOC-Framework) installed and on `PATH`
- A BWOC workspace (`bwoc init`) reachable from where Codex runs

## 📦 Installation

Add this repo to a marketplace, then enable it. A repo-local marketplace lives at `$REPO_ROOT/.agents/plugins/marketplace.json`; a personal one at `~/.agents/plugins/marketplace.json`.

```bash
# browse / install from the Codex CLI
/plugins
```

Enable in `~/.codex/config.toml`:

```toml
[plugins."bwoc@bwoc"]
enabled = true
```

## 🚀 Usage

```text
@bwoc list                 # list registered agents
@bwoc status <agent>   # health + identity snapshot
@bwoc send <agent> ... # append a message to an agent's inbox
@bwoc run  <agent> ... # run a single task headless, capture result
"Summarize the BWOC team's open tasks"   # natural-language invocation
```

## 🗂️ Repository layout

```
bwoc-plugin-codex/
├── .codex-plugin/
│   └── plugin.json          # plugin manifest (name/version/description/skills/hooks)
├── skills/                  # skills wrapping `bwoc` (skills/<name>/SKILL.md)
├── hooks/hooks.json         # lifecycle hooks
├── .mcp.json                # optional MCP servers
└── scripts/                 # validate.sh / build.sh
```

## 🛠️ Development

```bash
bash scripts/validate.sh     # validate .codex-plugin/plugin.json
bash scripts/build.sh        # regenerate the host tree from the live workspace
prettier --check .           # lint
```

## 🗺️ Roadmap

- [x] Scaffold: manifest, README, license
- [x] Coordination skills (`list/status/send/run/chat/task/team`)
- [x] Deep-memory skill
- [x] `.agents/plugins/marketplace.json` for repo-local install
- [ ] Skill re-export from BWOC skills
- [ ] Smoke test inside Codex

## 🔗 BWOC host-adapter set

One of five BWOC → host adapters, one per agent host:

| Host | Repo |
|---|---|
| Claude Code | [bwoc-plugin-claude](https://github.com/bemindlabs/bwoc-plugin-claude) |
| **OpenAI Codex** | [bwoc-plugin-codex](https://github.com/bemindlabs/bwoc-plugin-codex) |
| Antigravity | [bwoc-plugin-agy](https://github.com/bemindlabs/bwoc-plugin-agy) |
| OpenClaw | [bwoc-plugin-openclaw](https://github.com/bemindlabs/bwoc-plugin-openclaw) |
| Hermes | [bwoc-plugin-hermes](https://github.com/bemindlabs/bwoc-plugin-hermes) |

## 🙏 Maintainer

Maintained by **Bemind Technology**, part of the BWOC host-adapter set. This connector is **generic**: it ships no agents, teams, or workspace identities of its own — it discovers your fleet from the local `bwoc` workspace at runtime.

## 🤝 Contributing

Issues and PRs welcome. Keep the plugin a **thin wrapper over the `bwoc` CLI** — logic belongs in the framework, not here.

## 📄 License

[MIT](LICENSE) © Bemind Technology
