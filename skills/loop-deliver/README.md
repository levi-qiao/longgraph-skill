# loop-deliver

**A thin `/loop-deliver` entry for implementing a multi-round requirement through verified vertical slices.**

English · [简体中文](README.zh-CN.md)

`/loop-deliver` binds a requirement-delivery pack, then uses
[loop-graph](../loop-graph/SKILL.md) to compile the shared executor, supervisor, ledger,
directives, and ops files. It adds no runtime node or template set.

## When to use it

Use it for a feature, integration, migration, or behavior change that needs several
verified slices. Every slice ties one requirement behavior to a real consumer path and an
acceptance check. Use `/loop-converge` for cleanup, and `/loop-research` when the choice
of approach is not yet settled.

## How to run it

1. Invoke `/loop-deliver` (Claude Code plugin: `longgraph:loop-deliver`).
2. Answer only unresolved choices: outcome/acceptance, authority, and launch — or accept
   the recommended option.
3. **A** creates the two nodes on Codex or Claude Code. **B** prints copy-ready prompts
   for another host.

Authoring never executes generated runtime nodes.

## Files

| Path | What it is |
| --- | --- |
| [`SKILL.md`](SKILL.md) | Fit check, pack binding, and the focused interview |
| [`preset.md`](preset.md) | North Star, vertical-slice rules, knobs, and artifact emphasis |

Runtime templates live only under [`../loop-graph/templates/`](../loop-graph/templates/).
