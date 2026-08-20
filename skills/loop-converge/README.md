# loop-converge

**A thin `/loop-converge` entry that starts a code-convergence interview, then compiles a normal loop-graph run.**

English · [简体中文](README.zh-CN.md)

`/loop-converge` is not a second runtime. It binds a preset pack (unused /
duplicate / reuse / merge / slim; supervisor required) and follows
[loop-graph](../loop-graph/SKILL.md) to generate executor, supervisor, ledger,
and directives under `.longgraph/<date>-converge/`.

## When to use it

Multi-round cleanup where "done" is checkable: tests stay green, detectors
drop, net lines do not grow, no new public surface. The run sweeps the scope in
rotation and discovers its own candidates each round — it ends when fresh
detector passes stop yielding, not when a seeded list runs out. Skip it for a
one-shot tidy. One round lands the largest safe related workset sharing a proof
bar and gate; a fire cap only starts the next fire, never ends the run.

## How to run it

1. Invoke `/loop-converge` (Claude Code plugin: `longgraph:loop-converge`).
2. Answer the short interview — scope, authority, launch — or accept the
   recommended A on each.
3. **A** creates both nodes on Codex or Claude Code. **B** prints copy-ready
   read-and-follow prompts for another host, including Grok Build.

Authoring never executes the generated nodes.

## Files

| Path | What it is |
| --- | --- |
| [`SKILL.md`](SKILL.md) | Entry: fit check, bind the pack, start the interview, hand off |
| [`preset.md`](preset.md) | Authoring-only pack — North Star, guards, knobs, detector hints |

Runtime templates live only under [`../loop-graph/templates/`](../loop-graph/templates/).
