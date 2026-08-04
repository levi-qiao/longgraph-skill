# AGENTS.md — working on longgraph-skill

Guidance for any agent (or human) editing **this repo**. Read before changing anything.
The same rules apply in Claude Code — [`CLAUDE.md`](CLAUDE.md) imports this file.

## What this repo is

A **curated, opinionated prompt library** for long-horizon agent work, framed as
**"graph engineering."** It ships **Markdown prompts, not application code** — there
is no build step and no runtime. One umbrella (`/longgraph`) checks whether the
method fits, then delegates to one authoring skill:

- **`skills/loop-graph/`** — an executor node + a separate-context supervisor node, each
  on its own recurring timer, with no wake edge between them.

Simple self-contained goals use the host's ordinary task/goal directly; longgraph
does not wrap them in a second objective.

Deep context lives in [`lib/methodology.md`](lib/methodology.md) (the *why* behind each
rule) and [`skills/loop-graph/docs/model.md`](skills/loop-graph/docs/model.md) (the
node/edge vocabulary + invariants). The contribution bar is in [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Layout

| Path | What it is |
|---|---|
| `SKILL.md` | `/longgraph` fit check and authoring entrypoint; may launch nodes but never acts as one |
| `skills/loop-graph/SKILL.md` | author skill: interview → generate → deliver |
| `skills/loop-graph/templates/*.md` | compiled runtime prompts — not code; keep `{{PLACEHOLDER}}`s and structural headings intact |
| `skills/loop-graph/examples/` | concrete, fully worked runs (these *are* project-specific — that's correct) |
| `skills/loop-graph/references/*.md` | one independently loaded owner per host (invocation, context, hooks, handoff fields) |
| `.claude-plugin/` | Claude Code plugin + marketplace manifests |

## Rules that are easy to get wrong (don't)

1. **Keep templates host- and goal-agnostic.** Never hardcode a specific project or
   domain into `templates/`, `lib/`, or a `SKILL.md`. Rules adapt to whatever goal the
   user writes; scope eval/measurement-specific language behind *"when a check is a
   measurement."* Mine real runs for failure modes, then write them up generically.
   (Examples under `examples/` are the one place concrete is right.)
2. **Anti-bloat governance — the library holds itself to its own rule.** No prompt
   enters without a real consumer (a run it was proven on). Curated > comprehensive.
   New abstraction/config in a template needs a concrete motivating case.
3. **Don't break the load-bearing shape.** The graph's invariants are the product:
   single scoreboard (`ledger` = **exactly one writer**); one item per round → verify
   same round → update ledger; forced convergence off durable state; register-then-defer;
   hard stop conditions; absolute red lines; **one self-driving timer per node and no
   wake edge between them**; the supervisor steers only through the **one-way directives
   edge**, never editing the ledger or sharing the executor's context. Tune the numbers,
   not the shape.
   Every durable section rotates on a cap that is always reached — never on a boundary
   that may never arrive (a fixed shard size, the next milestone). An edge that can only
   grow eventually gets truncated on read, and a truncated edge loses signals silently.
4. **Node = one prompt + one single-writer edge.** To add a role: propose in an issue
   with its tuple first, give it its **own** edge (never partition an existing one),
   keep it **off the hot path** (only the ledger is read every round; new edges are read
   *on-reference* via a one-line ledger pointer), wire both peers, ship a generic
   example. The scout (#17→#18→#19) is the reference. See `CONTRIBUTING.md`.
5. **Keep authoring and runtime separate.** Author skills may interview and compile;
   they never execute their output. Loop-graph runtime follows the self-contained
   node files in `.longgraph/<date-slug>/` (legacy in-flight runs may still live under
   `.octopus/<date-slug>/`) and never reloads an authoring skill.
6. **Brand is longgraph.** Primary product/repo/slash/run-root names are longgraph /
   longgraph-skill / `/longgraph` / `.longgraph/`. Mentions of octopus / octopus-skill /
   `/octopus` / `.octopus/` are **legacy aliases only** (promotion continuity), never the
   primary install or plugin id.

## Editing conventions

- **Bilingual.** Skill READMEs ship EN + 中文 — mirror any change into `README.zh-CN.md`.
  Interview in the user's language but keep template headings/field names/placeholders unchanged.
- **Links, not bare paths, in human-facing docs.** Cross-file references are markdown
  links; runtime-artifact names (`ledger.md`, `ops.md` — generated per run, not repo
  files) stay code spans.
- **Mermaid diagrams stay mirrored** across EN + zh-CN.
- **No secrets or real client data, ever** — examples use fictional projects.
- **Surgical changes**, matching surrounding style. Every changed line traces to the request.

## Checks (there is no test suite)

- After touching `.claude-plugin/` or the skill layout, run **`claude plugin validate .`** — it must pass.
- After editing an example, confirm its `ledger.md` + executor prompt still tell a coherent story.

## Commits & PRs

- **Conventional commits**: `feat(loop-graph): …`, `fix(loop-graph): …`, `docs: …`.
- **Branch + PR**, don't push straight to `main` (this file is the exception the owner asked for). PR body states the failure mode the change addresses or the tuning it documents.
- **Distribution**: installable via the curl script *and* the Claude Code plugin. The
  plugin `version` is **intentionally omitted** so Claude Code uses the git SHA
  (users auto-update on every push) — don't add a version unless starting a real release process.
