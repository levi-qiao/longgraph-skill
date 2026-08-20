# Contributing to longgraph-skill

Thanks for helping! longgraph-skill is a small, opinionated prompt library: `/longgraph`
checks fit, `loop-graph` compiles durable runtime nodes, focused preset entries such as
`/loop-converge`, `/loop-deliver`, and `/loop-research` bind a goal pack and follow that
compiler, `lib/` holds shared
methodology, and `skills/loop-graph/references/` isolates host facts. Contributions that keep it curated rather than
comprehensive are the most welcome.

## Good contributions

- **Real-world tunings** of the defaults (convergence interval, net-line cap, loop
  cadence) with a note on the project shape they suited.
- **New worked examples** under the skill's `examples/` — fully generic fictional
  projects, or public-Git evidence about *this* repo; secret-free (see below and
  [`docs/public-private-boundary.md`](docs/public-private-boundary.md)).
- **Clarity fixes** to the skill templates, `lib/methodology.md`, or a per-host
  reference (corrections to what a host actually supports are
  especially valued).
- **Translations** — skill READMEs ship EN + 中文; more languages welcome, mirror the
  existing structure.
- **New host dialects** — add one `skills/loop-graph/references/<host>.md`; do not
  load it from the main skill until that host is selected.
- **New preset entries** — a thin `skills/<name>/` that binds a pack and follows
  `loop-graph`; follow the [preset contract](skills/loop-graph/docs/preset-contract.md),
  do not fork templates or add a runtime node.

## Adding a new node role (`loop-graph`)

The graph grows one node at a time — a node is **one Markdown prompt + one inspectable edge**, no runtime. The scout ([#17](https://github.com/levi-qiao/longgraph-skill/issues/17) → [#18](https://github.com/levi-qiao/longgraph-skill/pull/18) → [#19](https://github.com/levi-qiao/longgraph-skill/issues/19)) is the reference example; the path that merged cleanly:

1. **Propose in an issue first.** State the node's *tuple* — `(prompt, model, activation, read-set, write-set, authority, stop-condition)` — and which existing role it's distinct from. The vocabulary lives in [`skills/loop-graph/docs/model.md`](skills/loop-graph/docs/model.md).
2. **Give it its own single-writer edge.** Never partition an existing edge — the ledger has exactly one writer. A new writer means a new file it alone writes; other nodes read it. Preserve the edge invariants in `model.md`.
3. **Keep it off the hot path.** Only the ledger is read every round. A new edge is read *on-reference* (a one-line ledger pointer), so it never bloats the per-round token cost.
4. **Wire both peers.** A node nobody dispatches or consumes is dead — add the handoff to `executor.md` / `supervisor.md`, kept optional (“delete if no *X* node”).
5. **Ship a worked example** under the skill's `examples/` proving the full dispatch → consume flow, generic and secret-free.

## Hard rules

- **No secrets, no real client data, ever** — in examples, fixtures, docs, or commit
  messages. Examples must use fictional projects (or public Git facts about *this*
  open-source repo). See the full do/don’t lists in
  [`docs/public-private-boundary.md`](docs/public-private-boundary.md).
- **Showcase cards declare an evidence boundary** — every public case linked from
  root Evidence must state evidence class, re-check path, and what was excluded
  (same doc). Redacted real-run cards are **function-only** (control-plane verbs +
  coarse buckets) — never private ledgers, audit-report bodies, or identifying metrics.
- **No prompt enters the library without a real consumer** — a run it was actually
  proven on. This is longgraph's own anti-bloat rule turned on itself; curated and
  opinionated beats a junk drawer.
- **Keep it minimal.** New abstraction or config in a template needs a concrete
  motivating case. The library preaches anti-bloat; the repo should practice it.
- **Don't break the shape.** The methodology's load-bearing parts (single scoreboard,
  one-item rounds with same-round verification, a forcing function against growth,
  register-then-defer, hard stop conditions, absolute red lines, and — for
  `loop-graph` — a supervisor node whose context is separate from the executor's)
  are the product. Tune the numbers, not the shape.
- **Don't mix phases.** Author skills interview and compile; runtime contracts
  execute. A loop-graph tick follows its self-contained node under
  `.longgraph/<date-slug>/` and must not reload an author skill.

## How to submit

1. Fork and branch.
2. Make the change; if you touched an example, sanity-check that its ledger and
   executor prompt still tell a coherent story.
3. Open a PR describing the failure mode your change addresses or the tuning it
   documents.

By contributing, you agree your contributions are licensed under the [MIT License](LICENSE).
