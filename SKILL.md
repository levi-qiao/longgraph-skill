---
name: longgraph
description: Author and optionally direct-launch one durable loop-graph run for long-horizon agent work. Use when the user invokes /longgraph (or legacy /octopus), asks to design or start a multi-round run, needs durable state, gated milestones, owner decision boundaries, cross-host continuity, or independent audit. Detect Codex, Claude Code, or Grok Build from context instead of asking. For unused/duplicate/slim loops, use /loop-converge. For a self-contained task, recommend the host's ordinary task or goal directly. Do not execute or resume existing runtime node files from this authoring skill.
---

# longgraph — author a loop-graph run

> Formerly published as **octopus** / `/octopus` / `octopus-skill`. Same method;
> new brand. Slash `/octopus` remains a supported alias where the host still
> resolves that skill name (see install legacy symlink).

longgraph authors through [`loop-graph`](skills/loop-graph/SKILL.md). Specialized
entries such as [`loop-converge`](skills/loop-converge/SKILL.md) bind a preset
pack and then follow that skill. Do not execute the generated runtime nodes from
this authoring skill.

## Fit check

- Use loop-graph when the work needs durable state, many rounds, milestone gates,
  owner boundaries, host switching, or independent verification.
- If the request is specifically multi-round unused / duplicate / reuse / slim
  work, read and follow [`loop-converge`](skills/loop-converge/SKILL.md) instead
  of designing the North Star from scratch.
- If the request is one self-contained task that fits a normal host goal/task,
  explain that longgraph adds no value and recommend sending the task directly. Do
  not wrap it in another objective or invent a lighter longgraph mode.

Shared reference: [`lib/methodology.md`](lib/methodology.md) explains why the graph's
discipline exists. The loop-graph author loads one small per-host reference only after
the host is selected.
