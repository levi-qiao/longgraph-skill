<div align="center">

# octopus 🐙

**Long-horizon agent skill for Claude Code, Cursor, Codex & Grok.**

Stop agent drift with a durable ledger, a clean-context supervisor, and verified gates.
Queue many long tasks in one loop — even unrelated ones — and keep going after a host switch
by re-sending the same prompt against the files.

Design once → compile to a loop or a goal → verify all the way to done.

[![GitHub stars](https://img.shields.io/github/stars/levi-qiao/octopus-skill?style=flat-square&color=6C63FF)](https://github.com/levi-qiao/octopus-skill/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-14B8A6?style=flat-square)](LICENSE)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-22C55E?style=flat-square)](CONTRIBUTING.md)
![Hosts: Claude Code · Grok · Cursor · Codex](https://img.shields.io/badge/Hosts-Claude%20Code%20·%20Grok%20·%20Cursor%20·%20Codex-111827?style=flat-square)
![Type: Claude Code skill · prompt library](https://img.shields.io/badge/Type-Claude%20Code%20skill%20·%20prompt%20library-0EA5E9?style=flat-square)

English · [简体中文](README.zh-CN.md)

</div>

<img alt="Executor and clean-context supervisor loops running side by side" src="assets/graph.png" width="100%" />

**octopus** (`octopus-skill`) is a curated **Claude Code skill / agent skill** and
cross-host **prompt library** for **long-running / long-horizon** agent work —
multi-hour coding, multi-milestone migrations, a **queue of long tasks in one
loop** (they need not be related), and anything that outlives one context window.
It is **graph engineering for agents**: specialized roles (executor · supervisor ·
scout) connected through durable, inspectable files — not another orchestration
runtime. Because the scoreboard lives on disk, you can **change hosts mid-run**:
open the same workspace, re-send the frozen node prompt, and continue.

> **One brain, many arms.** The discipline stays the same; each arm compiles it
> to the native shape of your host (Claude Code plugin, Cursor, Codex, Grok).

## When to use this

Reach for octopus when you need any of:

- A **long-horizon agent** that keeps working after context compaction / session resets
- A **durable task ledger** (single scoreboard) instead of chat-memory progress
- **Several long tasks in one loop** — a continuous queue, even when items are unrelated
- **Host-portable continuity** — switch Claude Code ↔ Cursor ↔ Codex ↔ Grok mid-run by re-sending the prompt against the same files
- An independent **clean-context supervisor** — not the same agent grading itself
- **Verified done**: acceptance gates re-run against real output, not self-reported “done”
- Multi-milestone work with **non-skippable gates** and explicit owner red lines
- A **Markdown skill / prompt library** that works across **Claude Code · Cursor · Codex · Grok**

### When *not* to use this

- One-shot edits, small PR-sized tasks, or anything that fits a single clean session
- You want a **runtime framework** (LangGraph, CrewAI, AutoGen, custom agent server)
- You only need a single short prompt with no ledger, gates, or independent review

### How it compares

| Approach | Runtime / server? | Independent verifier | Durable scoreboard | Multi-task queue + mid-run host switch |
| --- | --- | --- | --- | --- |
| LangGraph / CrewAI / AutoGen | Yes | You build it | Usually yes | Framework-bound; often one deployment stack |
| One mega-prompt / single skill | No | No (self-check) | Weak (chat memory) | Weak — progress dies with the session |
| **octopus (this repo)** | **No — Markdown only** | **Yes (supervisor arm)** | **Yes (`ledger.md`)** | **Yes — files are the run; re-send the prompt** |

Also called / related searches: *long-running agent skill*, *prevent agent drift*,
*multi-task agent loop*, *switch AI coding host mid-task*, *Claude Code multi-agent
supervisor*, *agent ledger*, *loop skill*, *quest skill*, *graph engineering for
agents*, *clean-context review*.

## Why octopus

Long-running agents tend to drift in predictable ways: scope expands, “done”
becomes self-reported, tests stop proving the real path, and early decisions
disappear from context. octopus moves the safeguards outside the model’s memory:

- **Verified, not merely written** — acceptance gates are rerun against real output.
- **Durable state** — the ledger survives context loss and remains the single scoreboard.
- **Many long tasks, one loop** — the ledger is a continuous queue; items can be
  independent (migrations, test debt, docs, gates) without forcing one mega-goal.
- **Host-portable** — progress is files under `.octopus/<date-slug>/`, not chat
  history. Point another host at the same workspace, re-send the compiled node
  prompt, and pick up the next open ledger item.
- **Clean-context review** — an independent supervisor can catch drift the executor cannot see.
- **Forced convergence** — growth is periodically stopped, measured, and simplified.
- **Explicit owner boundaries** — destructive or unauthorized actions halt the run.

It is Markdown, not an orchestration framework: no application runtime, server,
or vendor lock-in. Install it as a **Claude Code plugin** or symlink the skills
into Cursor / Codex / Grok.

## Multi-task loops & switching hosts

**One loop is a queue, not a single story.** Each round still does one ledger item
end-to-end (implement → verify → record), but the ledger can hold many long items
at once — related milestones *or* unrelated backlog (the gate-wait backlog pattern
is the extreme case: useful work with no dependency on the item under audit). You
do not need a new graph every time the next long task is about something else.

**The host is swappable; the files are not.** A compiled loop-graph run freezes
prompts and state under `.octopus/<date-slug>/`. To continue elsewhere:

1. Use a workspace that can see those files (and the project).
2. Re-send the same frozen executor (and, if used, supervisor) prompt on the new host.
3. The node reads `ledger.md` / `directives.md` and continues from the next open item.

You are not exporting chat transcripts. Invocation syntax still follows each host’s
dialect ([host matrix](lib/host-dialects.md)) — only the *progress* is portable.

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
| **Grok** | ✅ `/goal <objective>` with a native adversarial verifier | ✅ executor `/loop` + supervisor `/loop`; fires chain their context, so plan the resets |
| **Codex** | ✅ `/goal`, or send the objective as a task | ✅ long-running executor task + supervisor heartbeat that resumes it after a real park |
| **Claude Code** | ⚠️ one self-paced `/loop`; no independent verifier | ✅ self-paced executor `/loop` + supervisor `/loop` |
| **Cursor** | ❌ no goal primitive | ✅ executor `/loop` + supervisor `/loop`, in-session; a cloud background agent instead caps a round at ~20 minutes |
| **shell / cron** | ❌ no goal primitive | ✅ schedule both loops; the only host that is genuinely fresh per tick |

The authoritative syntax, pacing behavior, per-host **context-carry model** (what a round
starts from, and what that costs), and host-specific hooks live in
[the host dialect matrix](lib/host-dialects.md). Mid-run host switches reuse the same
durable run directory; only how you start each tick changes.

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
