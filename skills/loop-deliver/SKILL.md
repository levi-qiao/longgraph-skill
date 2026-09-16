---
name: loop-deliver
description: Use only when the user explicitly invokes /loop-deliver or names this skill. Authors a loop-deliver run. Do not use unless named. Do not execute or resume generated runtime node files.
disable-model-invocation: true
---

# loop-deliver — a loop-graph preset for requirements

A thin authoring entry. It binds a requirement-delivery pack, starts the owner
interview, then follows [`loop-graph`](../loop-graph/SKILL.md) to compile the normal
executor, ledger, directives, ops, and supervisor artifacts. It is not a second runtime
and it does not ship a second template set.

## Fit check

- Use this when a feature, integration, migration, or behavior change needs several
  verified slices and an independent acceptance audit.
- Use [`../loop-converge/SKILL.md`](../loop-converge/SKILL.md) when the goal is code
  cleanup or consolidation. Use [`../loop-research/SKILL.md`](../loop-research/SKILL.md)
  when the decision between approaches is still open.
- If the requirement fits one normal host task, say so and send it directly. Do not wrap
  it in a graph.

## On invoke

1. Inspect the workspace and current host the same way loop-graph does. Never ask which
   client this is when context already identifies it.
2. Read and bind [`preset.md`](preset.md). That pack is the North Star, supervisor
   requirement, interview, shape, method guards, knob overrides, and artifact emphasis.
   Do not redesign them.
3. Start the owner interview immediately. Ask only the pack's unresolved choices —
   outcome/acceptance, authority, and launch — as recommended A/B (or A/B/C) choices.
   Do not ask the owner to invent a plan.
4. Read and follow [`../loop-graph/SKILL.md`](../loop-graph/SKILL.md) from **When called
   from a preset skill** through generate and deliver. Compile only from
   loop-graph's [`templates/`](../loop-graph/templates/). This skill never executes the
   generated nodes.
