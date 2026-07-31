---
name: octopus
description: Author and optionally direct-launch one durable loop-graph run for long-horizon agent work. Use when the user invokes /octopus, asks to design or start a multi-round run, needs durable state, gated milestones, owner decision boundaries, cross-host continuity, or independent audit. Detect Codex or Claude Code from context instead of asking. For a self-contained task, recommend the host's ordinary task or goal directly. Do not execute or resume existing runtime node files from this authoring skill.
---

# octopus 🐙 — author a loop-graph run

octopus has one authoring path: [`loop-graph`](skills/loop-graph/SKILL.md). Read and
follow that skill to interview, generate, and deliver the run. Do not execute the
generated runtime nodes from this authoring skill.

## Fit check

- Use loop-graph when the work needs durable state, many rounds, milestone gates,
  owner boundaries, host switching, or independent verification.
- If the request is one self-contained task that fits a normal host goal/task,
  explain that octopus adds no value and recommend sending the task directly. Do
  not wrap it in another objective or invent a lighter octopus mode.

Shared reference: [`lib/methodology.md`](lib/methodology.md) explains why the graph's
discipline exists. The loop-graph author loads one small per-host reference only after
the host is selected.
