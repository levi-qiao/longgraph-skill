# loop-research

**A thin `/loop-research` entry for selecting a technical approach with comparative evidence.**

English · [简体中文](README.zh-CN.md)

`/loop-research` binds a research-and-selection pack, then uses
[loop-graph](../loop-graph/SKILL.md) to compile the shared executor, supervisor, ledger,
directives, and ops files. It adds no research runtime, node, or template set.

## When to use it

Use it when the approach is not chosen and the decision needs open-source evidence,
primary research, and a fair benchmark or controlled A/B evaluation. The outcome is
evidence-backed under declared criteria; if the evidence is not comparable or decisive,
it reports that rather than inventing a winner. Use `/loop-deliver` after selection.

## How to run it

1. Invoke `/loop-research` (Claude Code plugin: `longgraph:loop-research`).
2. Answer only unresolved choices: decision boundary, evidence/data/budget authority, and
   launch — or accept the recommended option.
3. **A** creates the two nodes on Codex or Claude Code. **B** prints copy-ready prompts
   for another host.

Authoring never executes generated runtime nodes.

## Files

| Path | What it is |
| --- | --- |
| [`SKILL.md`](SKILL.md) | Fit check, pack binding, and the focused interview |
| [`preset.md`](preset.md) | Evidence funnel, selection guards, knobs, and artifact emphasis |

Runtime templates live only under [`../loop-graph/templates/`](../loop-graph/templates/).
