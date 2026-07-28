<div align="center">

# octopus 🐙

**Graph engineering for long-horizon agents.**

Design once. Compile to a loop or a goal. Verify all the way to done.

[![GitHub stars](https://img.shields.io/github/stars/levi-qiao/octopus-skill?style=flat-square&color=6C63FF)](https://github.com/levi-qiao/octopus-skill/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-14B8A6?style=flat-square)](LICENSE)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-22C55E?style=flat-square)](CONTRIBUTING.md)
![Hosts: Claude Code · Grok · Cursor · Codex](https://img.shields.io/badge/Hosts-Claude%20Code%20·%20Grok%20·%20Cursor%20·%20Codex-111827?style=flat-square)

English · [简体中文](README.zh-CN.md)

</div>

<img alt="Executor and clean-context supervisor loops running side by side" src="assets/graph.png" width="100%" />

octopus is a curated prompt library for agent work that lasts longer than one
context window. Instead of making one loop increasingly complicated, it wires
specialized roles — executor, supervisor, scout — into a small graph connected
through durable, inspectable files.

> **One brain, many arms.** The discipline stays the same; each arm compiles it
> to the native shape of your host.

## Why octopus

Long-running agents tend to drift in predictable ways: scope expands, “done”
becomes self-reported, tests stop proving the real path, and early decisions
disappear from context. octopus moves the safeguards outside the model’s memory:

- **Verified, not merely written** — acceptance gates are rerun against real output.
- **Durable state** — the ledger survives context loss and remains the single scoreboard.
- **Clean-context review** — an independent supervisor can catch drift the executor cannot see.
- **Forced convergence** — growth is periodically stopped, measured, and simplified.
- **Explicit owner boundaries** — destructive or unauthorized actions halt the run.

It is Markdown, not an orchestration framework: no application runtime, server,
or vendor lock-in.

## Choose an arm in 30 seconds

| Your task shape | Choose | What you get |
| --- | --- | --- |
| One self-contained goal that can drive itself to verified completion | [**quest**](skills/quest/SKILL.md) | One task-specific objective that loads the focused [**quest-executor**](skills/quest-executor/SKILL.md) runtime discipline |
| Multiple milestones, non-skippable gates, owner approvals, or a truly independent verifier | [**loop-graph**](skills/loop-graph/README.md) | An executor loop plus a clean-context supervisor loop, coordinated through durable files |

**Rule of thumb:** task shape chooses the arm; the host only rules options out.

## Quick start

### Claude Code

Install the plugin from the marketplace:

```text
/plugin marketplace add levi-qiao/octopus-skill
/plugin install octopus@octopus-skill
```

### Codex or Cursor

Install the library and symlink it into supported hosts:

```sh
curl -fsSL https://raw.githubusercontent.com/levi-qiao/octopus-skill/main/install.sh | sh
```

To install from a local clone, run `./install.sh` from the repository root.

### Design a run

Invoke `/octopus`. It interviews you about the goal, acceptance evidence,
milestones, red lines, and host, then compiles the appropriate arm. If you
already know the shape, invoke `quest` or `loop-graph` directly.

Authoring and runtime stay separate: author skills compile the work but never
execute it. A compiled quest selects `quest-executor`; generated loop-graph
nodes follow their frozen run contract under `.octopus/<date-slug>/`.

## How the graph works

| Role | Responsibility | Durable edge |
| --- | --- | --- |
| **Executor** | Works one ledger item, verifies it in the same round, then records the result | Reads and writes `ledger.md` |
| **Supervisor** | Re-verifies from a clean context, checkpoints passing work, and corrects drift | Reads the ledger; writes only `directives.md` |
| **Scout** *(optional)* | Researches a bounded question away from the critical path | Writes a findings file read only on reference |

The load-bearing rule is **one node = one prompt + one single-writer edge**.
The ledger has exactly one writer. The supervisor never shares the executor’s
context, never edits its scoreboard, and steers only through the one-way
directives edge.

For the rationale behind every constraint, read
[the methodology](lib/methodology.md). For the node and edge model, see
[the loop-graph model](skills/loop-graph/docs/model.md).

## Host compatibility

| Host | **quest** — one self-contained goal | **loop-graph** — gated or independently verified work |
| --- | --- | --- |
| **Grok** | ✅ `/goal <objective>` with a native adversarial verifier | ✅ executor `/loop` + supervisor `/loop` |
| **Codex** | ✅ `/goal`, or send the objective as a task | ✅ both nodes on interval `/loop` heartbeats; never use `/goal` for a parked node |
| **Claude Code** | ⚠️ one self-paced `/loop`; no independent verifier | ✅ self-paced executor `/loop` + supervisor `/loop` |
| **Cursor** | ❌ no goal primitive | ✅ executor `/loop` + supervisor `/loop`; keep each round under 20 minutes |
| **shell / cron** | ❌ no goal primitive | ✅ schedule both loops; stop on a terminal ledger status |

The authoritative syntax, pacing behavior, and host-specific hooks live in
[the host dialect matrix](lib/host-dialects.md).

## Repository map

| Path | Purpose |
| --- | --- |
| [Root `SKILL.md`](SKILL.md) | `/octopus` authoring router; chooses an arm and never executes generated work |
| [Quest author](skills/quest/SKILL.md) | Interviews, compiles, and delivers one goal objective |
| [Quest executor](skills/quest-executor/SKILL.md) | Focused runtime discipline loaded only by a compiled quest |
| [Loop-graph author](skills/loop-graph/SKILL.md) | Generates executor, supervisor, ledger, and directive artifacts |
| [`lib/`](lib) | Shared methodology and the single owner of host-specific facts |
| [Worked examples](skills/loop-graph/examples) | Concrete loop-graph runs showing the ledger and gates in action |

## Governance

octopus applies its own anti-bloat rule to the library: **no prompt enters
without a real run that proved its value.** Curated and opinionated beats
comprehensive.

Contributions are welcome. Start with [the contribution guide](CONTRIBUTING.md).

## Credits

The loop-graph arm grew from real runs and community input. Special thanks to
[@BrightProgrammer7](https://github.com/BrightProgrammer7) for the
`migrate-blob-storage` example and the discussions that sharpened milestone
gates and the node/edge vocabulary.

## License

[MIT](LICENSE) © 2026 [levi-qiao](https://github.com/levi-qiao)
