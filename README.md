<div align="center">

# longgraph

**Long-horizon agent skill for Claude Code, Cursor, Codex & Grok Build.**

Stop agent drift with a durable ledger, a clean-context supervisor, and verified gates.
Queue many long tasks in one loop — even unrelated ones — and keep going after a host switch
by re-sending the same prompt against the files.

Design once → compile a durable loop-graph → verify all the way to done.

[![GitHub stars](https://img.shields.io/github/stars/levi-qiao/longgraph-skill?style=flat-square&color=6C63FF)](https://github.com/levi-qiao/longgraph-skill/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-14B8A6?style=flat-square)](LICENSE)
[![PRs welcome](https://img.shields.io/badge/PRs-welcome-22C55E?style=flat-square)](CONTRIBUTING.md)
![Hosts: Claude Code · Cursor · Codex · Grok Build](https://img.shields.io/badge/Hosts-Claude%20Code%20·%20Cursor%20·%20Codex%20·%20Grok%20Build-111827?style=flat-square)
![Type: agent skill · prompt library](https://img.shields.io/badge/Type-agent%20skill%20·%20prompt%20library-0EA5E9?style=flat-square)

English · [简体中文](README.zh-CN.md)

</div>

<img alt="Executor and clean-context supervisor loops running side by side" src="assets/graph.png" width="100%" />

**longgraph** (`longgraph-skill`) is a curated **agent skill** and cross-host
**prompt library** for **long-running / long-horizon** agent work — multi-hour
coding, multi-milestone migrations, a **queue of long tasks in one loop** (they
need not be related), and anything that outlives one context window. It is
**graph engineering for agents**: specialized roles (executor · supervisor ·
scout) connected through durable, inspectable files — not another orchestration
runtime. Because the scoreboard lives on disk, you can **change hosts mid-run**:
open the same workspace, re-send the frozen node prompt, and continue.

> **One durable graph, portable across hosts.** For a simple self-contained goal,
> use the host's normal task or goal directly; longgraph starts where durable graph
> structure adds value.

> **Renamed from octopus.** Same library; primary brand is now **longgraph** /
> `longgraph-skill` / `/longgraph` / `.longgraph/`. Older posts that say
> `octopus-skill`, `/octopus`, or `.octopus/` still work via GitHub repo redirect,
> install legacy symlinks, and in-flight run-dir alias (see [Install](#quick-start)
> and [Migration](#renamed-from-octopus)).

## Evidence

These are not one-shot demos. longgraph is a **Markdown skill / prompt library**
(not an orchestration runtime). The table mixes **checkable public Git**, a
**function-only redacted multi-day pattern**, and **synthetic pedagogy**.

| Case | What a reader can verify | Kind |
| --- | --- | --- |
| [**Self-iteration of this skill**](skills/loop-graph/examples/self-iteration-longgraph-skill/README.md) | **87** public commits across **~14 calendar days** (2026-07-19 → 2026-08-02), **74** files, method rules written back into the library (no wake edge, gate-wait backlog, blocked≠parked, bounded live edges, authoring≠runtime) | Public Git facts — fixed anchor `6efcb7f` |
| [**Multi-day control-plane pattern**](skills/loop-graph/examples/redacted-multiday-control-plane/README.md) | Multi-day wall-clock, tens of rounds, many directives: durable ledger, clean-context supervisor overturns self-reported evidence, non-skippable gates, blocked-work lane, owner A/B/C — **functions only**, no private payload | Redacted real-run pattern |
| [**migrate-blob-storage**](skills/loop-graph/examples/migrate-blob-storage/README.md) | Multi-milestone ledger: pilot → cohort, forced convergence, supervisor overturns self-reported evidence, non-skippable gate + blocked-work lane | Synthetic pedagogy (fictional app) |
| [**add-tests-to-cli**](skills/loop-graph/examples/add-tests-to-cli/README.md) | Smallest full run: three rounds, register-then-defer, clean-context supervisor intent | Synthetic pedagogy (fictional CLI) |

**How to read the clock.** The self-iteration window’s ~14 days / ~340 hours is
**project wall-clock** (first public commit → frozen anchor), not continuous model
execution and not a claim of unattended production autonomy. Re-check Git with the
commands in the [self-iteration case](skills/loop-graph/examples/self-iteration-longgraph-skill/README.md).
The redacted multi-day card uses **coarse buckets only** and is **not** private-Git
re-checkable — see its evidence boundary.

Publication rules for future cases:
[public / private boundary](docs/public-private-boundary.md).

## When to use this

Reach for longgraph when you need any of:

- A **long-horizon agent** that keeps working after context compaction / session resets
- A **durable task ledger** (single scoreboard) instead of chat-memory progress
- **Several long tasks in one loop** — a continuous queue, even when items are unrelated
- **Host-portable continuity** — switch Claude Code ↔ Cursor ↔ Codex ↔ Grok Build mid-run by re-sending the prompt against the same files
- An independent **clean-context supervisor** — not the same agent grading itself
- **Verified done**: acceptance gates re-run against real output, not self-reported “done”
- Multi-milestone work with **non-skippable gates** and explicit owner red lines
- A **Markdown skill / prompt library** that works across **Claude Code · Cursor · Codex · Grok Build**

### When *not* to use this

- One-shot edits, small PR-sized tasks, or anything that fits a single clean session
- You want a **runtime framework** (LangGraph, CrewAI, AutoGen, custom agent server)
- You only need a single short prompt with no ledger, gates, or independent review

### How it compares

| Approach | Runtime / server? | Independent verifier | Durable scoreboard | Multi-task queue + mid-run host switch |
| --- | --- | --- | --- | --- |
| LangGraph / CrewAI / AutoGen | Yes | You build it | Usually yes | Framework-bound; often one deployment stack |
| One mega-prompt / single skill | No | No (self-check) | Weak (chat memory) | Weak — progress dies with the session |
| **longgraph (this repo)** | **No — Markdown only** | **Yes (supervisor node)** | **Yes (`ledger.md`)** | **Yes — files are the run; re-send the prompt** |

Also called / related searches: *longgraph skill*, *long-horizon agent skill*,
*long-running agent skill*, *prevent agent drift*, *multi-task agent loop*,
*switch AI coding host mid-task*, *Claude Code multi-agent supervisor*,
*Grok Build agent loop*, *agent ledger*, *loop-graph*, *graph engineering for
agents*, *clean-context review*.

## Why longgraph

Long-running agents tend to drift in predictable ways: scope expands, “done”
becomes self-reported, tests stop proving the real path, and early decisions
disappear from context. longgraph moves the safeguards outside the model’s memory:

- **Verified, not merely written** — acceptance gates are rerun against real output.
- **Durable state** — the ledger survives context loss and remains the single scoreboard.
- **Many long tasks, one loop** — the ledger is a continuous queue; items can be
  independent (migrations, test debt, docs, gates) without forcing one mega-goal.
- **Host-portable** — progress is files under `.longgraph/<date-slug>/`, not chat
  history. Point another host at the same workspace, re-send the compiled node
  prompt, and pick up the next open ledger item.
- **Clean-context review** — an independent supervisor can catch drift the executor cannot see.
- **Forced convergence** — growth is periodically stopped, measured, and simplified.
- **Low-friction owner decisions** — genuine owner-only calls arrive as a short
  recommended A/B/C choice, not a technical homework assignment.

It is Markdown, not an orchestration framework: no application runtime, server,
or vendor lock-in. Install as a **Claude Code plugin**, symlink into **Codex /
Cursor** (see install script), or run **prompts-only** on **Grok Build** (and
other hosts) via the per-host references.

## Multi-task loops & switching hosts

**One loop is a queue, not a single story.** Each round still does one ledger item
end-to-end (implement → verify → record), but the ledger can hold many long items
at once — related milestones *or* unrelated backlog (the gate-wait backlog pattern
is the extreme case: useful work with no dependency on the item under audit). You
do not need a new graph every time the next long task is about something else.

**The host is swappable; the files are not.** A compiled loop-graph run freezes
prompts and state under `.longgraph/<date-slug>/`. To continue elsewhere:

1. Use a workspace that can see those files (and the project).
2. Re-send the same frozen executor (and, if used, supervisor) prompt on the new host.
3. The node reads `ledger.md` / `directives.md` and continues from the next open item.

You are not exporting chat transcripts. Invocation syntax still follows each host’s
dialect ([per-host references](skills/loop-graph/references/)) — only the *progress* is portable.

## Is longgraph the right tool?

| Your task shape | Choose | What you get |
| --- | --- | --- |
| One self-contained goal that fits a normal task/session | Use the host's ordinary task or goal directly | No longgraph wrapper or extra prompt layer |
| Many rounds, durable state, non-skippable gates, owner boundaries, host switching, or independent verification | [**longgraph / loop-graph**](skills/loop-graph/README.md) | An executor loop plus a clean-context supervisor, coordinated through durable files |

**Rule of thumb:** if you do not need the graph, do not use longgraph.

## Quick start

### Claude Code

Install the plugin from the marketplace:

```text
/plugin marketplace add levi-qiao/longgraph-skill
/plugin install longgraph@longgraph-skill
```

### Codex or Cursor

Install the library and symlink `/longgraph` (plus legacy `/octopus`) into hosts
whose loaders follow symlinks:

```sh
curl -fsSL https://raw.githubusercontent.com/levi-qiao/longgraph-skill/main/install.sh | sh
```

From a local clone, run `./install.sh` at the repository root.

### Grok Build (and other prompts-only hosts)

Author on Claude Code or Codex when you want direct node creation, **or** choose
prompts-only and paste the frozen executor / supervisor pointers into
[Grok Build](skills/loop-graph/references/grok.md) `/loop` tasks (same run
directory). Cursor and shell/cron use the same prompts-only path — see
[host compatibility](#host-compatibility).

### Design a run

Invoke `/longgraph`. It detects Codex or Claude Code, inspects the workspace, and asks
only for unresolved owner decisions before compiling the run. Choose direct creation
to have it start both same-host runtime nodes, or prompts-only for manual/cross-host
launch (including Grok Build). You can also invoke `loop-graph` directly.

Authoring and runtime stay separate: the author skill compiles the work but never
executes it. Generated nodes follow their frozen run contract under
`.longgraph/<date-slug>/`.

## How the graph works

| Role | Responsibility | Durable edge |
| --- | --- | --- |
| **Executor** | Works one ledger item, verifies it in the same round, then records the result | Reads and writes `ledger.md` |
| **Supervisor** | Re-verifies from its own separate context, checkpoints passing work, and corrects drift | Reads the ledger; writes only the directives edge (live queue + cold archive) |
| **Scout** *(optional)* | Researches a bounded question away from the critical path | Writes a findings file read only on reference |

The load-bearing rule is **one node = one prompt + one single-writer edge**.
The ledger has exactly one writer. The supervisor never shares the executor’s
context, never edits its scoreboard, and steers only through the one-way
directives edge.

For the rationale behind every constraint, read
[the methodology](lib/methodology.md). For the node and edge model, see
[the loop-graph model](skills/loop-graph/docs/model.md).

## Host compatibility

| Host | loop-graph execution |
| --- | --- |
| [**Codex**](skills/loop-graph/references/codex.md) | ✅ detects the host and directly creates both runtime nodes |
| [**Claude Code**](skills/loop-graph/references/claude-code.md) | ✅ detects the host and directly creates two background runtime sessions when capability checks pass |
| [**Grok Build**](skills/loop-graph/references/grok.md) | prompts-only — two `/loop` tasks (executor + supervisor), no wake edge |
| [**Cursor**](skills/loop-graph/references/cursor.md) | prompts-only execution target |
| [**shell / cron**](skills/loop-graph/references/shell-cron.md) | prompts-only execution target |

Authoritative syntax, pacing, context carry, and hooks live in separate
[per-host references](skills/loop-graph/references/), so authoring loads only the selected host. Mid-run host switches reuse the same
durable run directory; only how you start each tick changes.

## Renamed from octopus

| Was (legacy / still accepted) | Now (primary) |
| --- | --- |
| Product `octopus`, repo `octopus-skill` | **longgraph**, repo **longgraph-skill** |
| Slash `/octopus` | **`/longgraph`** (install still symlinks `/octopus` → same tree) |
| Plugin `octopus@octopus-skill` | **`longgraph@longgraph-skill`** |
| Run dir `.octopus/<date-slug>/` | **`.longgraph/<date-slug>/`** (continue in-flight `.octopus/` runs in place) |
| Contract `octopus.loop-graph.*` | **`longgraph.loop-graph.*`** (old headers on existing files still mean the same family) |

GitHub renames redirect old clone/curl URLs (`…/octopus-skill/…` → `…/longgraph-skill/…`).
Re-run `install.sh` or reinstall the plugin once so primary names win on disk.

## Repository map

| Path | Purpose |
| --- | --- |
| [Root `SKILL.md`](SKILL.md) | `/longgraph` entrypoint; checks fit and delegates authoring to loop-graph |
| [Loop-graph author](skills/loop-graph/SKILL.md) | Generates executor, supervisor, ledger, and directive artifacts |
| [`lib/`](lib) | Shared methodology |
| [Host references](skills/loop-graph/references) | One independently loaded owner for each host's runtime facts |
| [Worked examples](skills/loop-graph/examples) | Public-Git self-iteration plus fictional ledgers showing gates in action |
| [Public / private boundary](docs/public-private-boundary.md) | What may enter the public tree vs stay project-local |

## Governance

longgraph applies its own anti-bloat rule to the library: **no prompt enters
without a real run that proved its value.** Curated and opinionated beats
comprehensive.

Contributions are welcome. Start with [the contribution guide](CONTRIBUTING.md).

## Credits

The loop-graph skill grew from real runs and community input. A
[public-Git self-iteration case](skills/loop-graph/examples/self-iteration-longgraph-skill/README.md)
records how the method was hardened into this library. Special thanks to
[@BrightProgrammer7](https://github.com/BrightProgrammer7) for the
`migrate-blob-storage` example and the discussions that sharpened milestone
gates and the node/edge vocabulary.

## License

[MIT](LICENSE) © 2026 [levi-qiao](https://github.com/levi-qiao)
