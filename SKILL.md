---
name: octopus
description: Route an octopus authoring request to the right arm. Use when the user explicitly invokes /octopus, asks to design a long-horizon run, wants a quest objective or loop-graph generated, or needs help choosing between them. Do not use to execute or resume a compiled quest marked `octopus.quest-executor/v1`, or to follow an existing `.octopus/.../executor.md` or `supervisor.md`; those are runtime work.
---

# octopus 🐙 — one brain, many arms

A curated prompt library for long-horizon agent work. On an authoring request,
**pick the arm, then read and follow that arm's `SKILL.md`.** Do not execute the
generated work from this router.

## Architecture

Keep three layers distinct:

| Layer | Owner | Output |
|---|---|---|
| Router | this skill | arm choice |
| Author | [`quest`](skills/quest/SKILL.md) or [`loop-graph`](skills/loop-graph/SKILL.md) | compiled runtime contract |
| Runtime | [`quest-executor`](skills/quest-executor/SKILL.md) or generated loop-graph node files | verified work |

The two author skills are peers: interview → generate → deliver. Runtime contracts
differ only where the host shape requires it: quest loads one focused execution
skill for one continuous goal; loop-graph freezes its executor and supervisor into
the run directory so every scheduled activation uses the same auditable contract.

## Pick the arm — task shape decides; the host only gates what's available

Decide by **task shape first**, then check the host can run it (full matrix in
[`lib/host-dialects.md`](lib/host-dialects.md)):

| Choose | When |
|--------|------|
| **[`quest`](skills/quest/SKILL.md)** | a *single self-contained* goal · reproducible acceptance · no non-skippable milestone gate · no owner-only call on the critical path → emit **one task-specific objective** marked for `quest-executor`, then ride the host's goal harness — no second loop |
| **[`loop-graph`](skills/loop-graph/SKILL.md)** | *any* of: multi-milestone phases with a non-skippable gate · executor and supervisor on different hosts/models/cadences · owner red-lines/gates that must stop the run · cross-session durability · you want an **independent** verifier → build the **executor + clean-context supervisor** two-loop graph |

The host only **gates which arms are reachable** — most now do both:

| Host | Can run | How |
|------|---------|-----|
| **Grok** | both | quest rides its **native adversarial verifier**; loop-graph = two `/loop`s |
| **Codex** | both | quest = `/goal` / send-as-task (self-drives to done). **loop-graph = drive *both* nodes with an interval `/loop` (heartbeat), never `/goal`** — a goal harness re-fires a parked/stalled node forever (livelock), having no "waiting for a directive" rest state. Codex `/loop` **needs an explicit interval** (e.g. `4m`) or no timer is created. |
| **Claude Code** | both\* | quest = a self-paced single `/loop` (\*no `/goal` command, no independent verifier); loop-graph = two `/loop`s (its supervisor is the verifier) |
| **Cursor**, **shell/cron** | loop-graph only | no goal primitive |

Default when genuinely unsure: **loop-graph** (it carries its own verifier and runs
on every loop-capable host).

## Then

Read the chosen author skill and run its interview → generation → delivery.
Shared reference both arms rest on:
- [`lib/host-dialects.md`](lib/host-dialects.md) — per-host `/loop` · goal · hook syntax, which primitive each host has, and wake/notify primitives.
- [`lib/methodology.md`](lib/methodology.md) — why each discipline rule exists and the failure mode it prevents.
