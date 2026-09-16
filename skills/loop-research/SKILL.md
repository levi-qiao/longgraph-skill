---
name: loop-research
description: Use only when the user explicitly invokes /loop-research or names this skill. Authors a loop-research run. Do not use unless named. Do not execute or resume generated runtime node files.
disable-model-invocation: true
---

# loop-research — a loop-graph preset for evidence-led choices

A thin authoring entry. It binds a research-and-selection pack, starts the owner
interview, then follows [`loop-graph`](../loop-graph/SKILL.md) to compile the normal
executor, ledger, directives, ops, and supervisor artifacts. It is not a research node,
a second runtime, or a second template set.

## Fit check

- Use this when the approach is undecided and a decision needs comparative evidence from
  open-source projects, primary research, and a controlled benchmark or A/B experiment.
- Use [`../loop-deliver/SKILL.md`](../loop-deliver/SKILL.md) once the approach is chosen,
  or [`../loop-converge/SKILL.md`](../loop-converge/SKILL.md) for code consolidation.
- For a short answer, one source lookup, or non-comparative literature summary, use the
  host's ordinary research task instead of a graph.

## On invoke

1. Inspect the workspace, existing evidence, experiment harnesses, data policy, and
   current host the same way loop-graph does. Never ask which client this is when context
   already identifies it.
2. Read and bind [`preset.md`](preset.md). That pack is the North Star, supervisor
   requirement, interview, evidence shape, method guards, knob overrides, and artifact
   emphasis. Do not redesign them.
3. Start the owner interview immediately. Ask only the pack's unresolved choices —
   decision/scope, evidence budget and data authority, and launch — as recommended A/B
   (or A/B/C) choices. Do not ask the owner to invent evaluation criteria.
4. Read and follow [`../loop-graph/SKILL.md`](../loop-graph/SKILL.md) from **When called
   from a preset skill** through generate and deliver. Compile only from
   loop-graph's [`templates/`](../loop-graph/templates/). This skill never executes the
   generated nodes.
