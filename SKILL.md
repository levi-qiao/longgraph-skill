---
name: longgraph
description: Use only when the user explicitly invokes /longgraph or names this skill. Routes and authors a durable longgraph run. Do not use unless named. Do not execute or resume generated runtime node files.
disable-model-invocation: true
---

# longgraph — route to the right durable run

longgraph has one shared compiler, [`loop-graph`](skills/loop-graph/SKILL.md),
and focused entries that bind only goal-specific rules. All compile the same
executor, supervisor, ledger, directives, and ops artifacts. Do not execute the
generated runtime nodes from this authoring skill.

## Fit and route

- Use [`loop-converge`](skills/loop-converge/SKILL.md) for multi-round unused
  code, duplication, consolidation, reuse, or slimming.
- Use [`loop-deliver`](skills/loop-deliver/SKILL.md) for a product or engineering
  requirement that needs incremental implementation and acceptance proof.
- Use [`loop-research`](skills/loop-research/SKILL.md) to compare feasible
  approaches with open-source implementations, primary research, and controlled
  experiments before committing to one.
- Use [`loop-graph`](skills/loop-graph/SKILL.md) directly only when none of the
  focused packs fits but the work still needs durable state, gates, owner
  boundaries, host switching, or independent verification.
- If the request is one self-contained task that fits a normal host goal/task,
  explain that longgraph adds no value and recommend sending the task directly. Do
  not wrap it in another objective or invent a lighter longgraph mode.

Shared reference: [`lib/methodology.md`](lib/methodology.md) explains why the graph's
discipline exists. The baseline and pack boundary is in
[`skills/loop-graph/docs/preset-contract.md`](skills/loop-graph/docs/preset-contract.md).
