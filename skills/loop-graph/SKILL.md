---
name: loop-graph
description: Author and optionally direct-launch one durable loop-graph run as executor, ledger, directives, and supervisor artifacts under a dated `.octopus` directory, then present copy-ready host prompts. Use for multi-round work with gated milestones, independent audit, cross-host execution, or durable state. Detect Codex or Claude Code from context and create both same-host runtime nodes when the owner chooses direct launch. Existing runtime nodes are self-contained.
---

# loop-graph — a graph of agent nodes, not a drifting loop

## What it does & why

Turns a vague long-horizon request ("make it production-ready", "accuracy above baseline", "finish the migration") into a small **graph of agent nodes** that stays on-spec across many rounds:

- an **executor node** — drives the work round by round against a single scoreboard;
- a **clean-context supervisor node** — audits the work from *outside* the executor's context (re-verifying claimed-done against the shared standards) and corrects course before drift compounds.

Why a graph, not a loop: an agent grinding a long task **is inside the context that drifted**, so it rationalizes scope creep and calls half-done work "done". The nodes talk only through durable, inspectable state (ledger, git tree, directives file) — never a shared, polluted context. The supervisor boots fresh each tick and judges the run like an outside reviewer.

## The graph it builds

```
        ┌─────────────┐   reads / rewrites   ┌──────────────┐
        │  EXECUTOR    │ ───────────────────▶ │              │
        │  node        │ ◀─────────────────── │  ledger.md   │  ← single scoreboard
        │ (does work)  │                      │ (shared state)│
        └─────────────┘                      └──────────────┘
              ▲                                      ▲
              │ reads each round                     │ reads only (never writes it)
              │                                      │
        ┌───────────────┐   appends corrections ┌──────────────────┐
        │ directives.md │ ◀──────────────────── │   SUPERVISOR     │  ← fresh, CLEAN context
        └───────────────┘                       │   node (watches) │     every tick
                                                 └──────────────────┘
                                                     │ checkpoint-commits clean work
                                                     │ escalates human-only calls
                                                     ▼
                                                   git / you
```

Five live artifacts from a short interview:

1. **`executor.md`** — executor prompt: one task book, one cadence, anti-bloat rules, stop conditions, red lines.
2. **`ledger.md`** — the single scoreboard both nodes read; the executor rewrites it every round.
3. **`directives.md`** — the bounded one-way corrections queue: current STANDING locks + not-yet-folded numbered corrections; folded history rotates into cold archive shards.
4. **`ops.md`** *(optional)* — current env facts (build commands, credential/data policy) the executor consults, not re-derives; update facts in place, never as a timeline.
5. **`supervisor.md`** *(optional)* — supervisor prompt, scheduled; independently re-verifies claimed-done work, checkpoint-commits what passes, decides pending items, and corrects drift / steers the plan via the directives file.

**Run directory — fixed, one per run.** Everything above goes in `.octopus/<YYYY-MM-DD-slug>/` at the repo root (workspace root for multi-repo runs), plus an `archive/` subdir for in-run rotations. **A new run gets a new directory, generated fresh from the templates — never retarget or edit a previous run's files**: patching stale prompts wastes tokens and leaves leftover text steering toward the old goal. The old directory stays untouched (it *is* the archive); distill what still holds into the new ledger's starting snapshot and copy still-in-force STANDING directives forward. Commit the run directory unless data policy forbids — it's the durable state the graph depends on.

Invariants: **ledger = the only scoreboard**; **one item per round → verify → update ledger**; **the supervisor steers only through `directives.md` (a one-way edge) — it never edits the ledger or shares the executor's context**.

## When to use it

- Task spans many rounds; the user won't babysit each one.
- "Done" is verifiable (tests, gates, metrics) — the graph needs a definition of done it can check itself.
- Real risk of scope creep, "looks done" work, or quietly changing contracts / lowering the bar.

**Not** for a one-shot edit, or when success needs a human to judge every time — say so, suggest a plain task.

## Language

Interview in the user's language and mirror it in the prose inside the artifacts (goals, notes, red lines). Keep structural keywords, headings, and field names as in the templates so files stay tool-friendly.

## How to run it

**Step 1 — Discover, then interview.** Before asking anything, inspect the workspace and current system/tool context. Infer the current authoring host, project root, repos, branches, dirty state, repo instructions, likely gates, and any explicit goal/constraints. **Never ask the user which client or host this is when the system context already identifies it.** Capture the dirty-state baseline before this session changes anything — whatever you go on to move, archive, generate, or delete becomes indistinguishable from the owner's uncommitted work unless your own paths are enumerated in the ledger's starting snapshot.

Ask one short batch of at most three questions containing only unresolved owner
decisions. Propose the answer; do not ask the owner to design it. If more than three
details remain, prioritize goal/proof, safety authority, and launch mode; infer or
defer the rest. Ask a follow-up only when the run would otherwise be unsafe or
unverifiable:

1. **North Star and proof**, only when the request does not already imply a checkable outcome. Offer one concise recommended wording.
2. **Authority**, only where not already stated. Recommended default: local edits and verification allowed; no push, destructive git, production/remote mutation, secret or real-data exposure, unbounded spend, or lowering an acceptance bar. Ask whether commits are allowed only when the run needs them. When the run performs metered or expensive work, put the actual numbers in `ops.md` — "spend beyond budget" is an owner-only tripwire, and an undeclared budget makes it unenforceable.
3. **Milestones**, only when two materially different decompositions exist. Present the recommended phase split and exit checks as A; offer B only when it changes the outcome or risk. Single goal means no milestone question. Sequence so the smallest slice that unblocks the main line comes first: a large enabling refactor placed ahead of the delivery milestone concentrates risk and delays every proof behind it. Split such a milestone into the narrow unblocking part and a remainder that runs alongside the main line instead of in front of it.
4. **Launch mode**, unless the user already chose it: **A (Recommended) — create both runtime nodes here on the detected Codex or Claude Code host**; **B — print copy-ready prompts only**. Ask target hosts only for B or when the user explicitly requests a cross-host run.

Do not ask for repo paths, branches, host, test commands, red lines, or supervisor interval when they are discoverable. If a gate is missing or ambiguous after inspection, propose the narrowest credible command and ask one A/B choice. Long-horizon loop-graph runs include the clean-context supervisor by default; ask whether to omit it only when its value is genuinely doubtful.

For each supervised milestone boundary, name its exact promotion audit surface and exit checks. Seed Gate-wait work whenever a clearly independent, one-round, verified, write-disjoint item exists — a park costs a full restart, and on hosts where only the supervisor can resume, a wait for its next tick; omit it only when nothing qualifies. Expect the run to block for reasons other than promotion (owner decisions, missing inputs, unmet dependencies): seed the Debt & gap register with enough real, independent work that the executor always has a legal next item instead of stopping. Fix the **owner-only decision list** (typical: DDL/schema, credentials / remote env / real-data exposure, spend beyond budget, lowering a metric bar, frozen contracts, push) — everything off that list the supervisor decides itself.

- **Pre-adjudicate critical-path calls now.** Research the project and draft the evidence bar yourself; do not ask the owner to design it. Present: **A (Recommended)** accept the drafted standing authorization, **B** keep the action owner-blocked, and only when real, **C** a clearly different safe alternative. Explain each outcome in plain language and accept a one-letter reply. Write accepted bars as STANDING directives. Only a decision that genuinely needs case-by-case human judgment stays blocking.
- **Owner decision UX is a runtime contract.** Every later owner escalation must use the decision-card format below. The owner should not need to understand internal symbols, reconstruct history, or propose the solution.

```text
Decision needed: <one plain-language sentence>
Why now: <what is blocked and what happens if we wait>
Recommendation: A — <choice> (<one-sentence reason>)
A (Recommended) — <outcome and main tradeoff>
B — <outcome and main tradeoff>
C — <only when genuinely distinct; otherwise omit>
Reply with: A / B / C
```

Use at most three mutually exclusive options. Put the safest reversible option first unless evidence clearly favors another. Translate technical evidence into consequences; place paths, commands, and jargon in an optional `Technical note` after the choices. Never end with "what do you think?" or make the owner invent option D. If no answer arrives, remain parked at the safe no-change state.

**Host & pacing.** Infer the current authoring host from system context and callable tools. Codex and Claude Code are the supported direct-launch planners. When A is chosen, place both runtime nodes on that detected host and read only its reference; do not ask about or print other-host syntax. When B or an explicit cross-host request is chosen, read one reference per selected node:

- [Claude Code](references/claude-code.md)
- [Codex](references/codex.md)
- [Grok](references/grok.md)
- [Cursor](references/cursor.md)
- [shell / cron](references/shell-cron.md)

Do not load unrelated host references. The selected reference owns capability checks, creation, invocation, context carry/reset, wake, and stop behavior. Other hosts may execute prepared prompts, but direct creation is supported only from Codex or Claude Code.

**Round granularity is host-aware, and finer is not cheaper.** A round is the smallest independently verifiable increment, but on a context-carrying host each extra round re-carries prior output. Batch sibling items that share one verification, keep bulk output out of the transcript, and pair coarser rounds with the ledger's bounded history. Set `CHAIN_BUDGET` only when the selected reference says context carries. A supervisor must start clean each tick; choose a host combination that actually provides that property.

**Compile context, do not narrate it.** Host prompts are one-line pointers to the
runtime Markdown. At authoring time, build an `ops.md` Context index with exact files,
symbols/headings, evidence paths, and narrow gates. Every Current slice and correction
points to those IDs. Runtime nodes read the hot state plus referenced rows only; they
do not scan the workspace, reopen whole authority documents, or restate source text.
The supervisor audits deltas since its durable watermark and runs full gates only at
promotion/checkpoint or when a narrow gate is insufficient.

Compute intervals only for scheduled nodes (supervisor ≈ 3–4× executor for two-loop hosts, phase-offset). All scheduled nodes stop on terminal ledger state.

Decide from context what you reasonably can and state the assumption; anything genuinely the user's call (data policy, DB access, lowering a bar) becomes a red line, a **standing authorization** (offer your drafted recommendation as a choice), or an `owner-blocked` item (only if it truly can't be pre-decided). Never hand the owner an unstructured problem.

**Step 2 — Generate** a fresh `.octopus/<YYYY-MM-DD-slug>/` from `templates/`:

- Always: `executor.md`, `ledger.md`, `directives.md`, and `archive/`.
- When useful: `ops.md`. Add `supervisor.md` only when chosen.
- Replace every placeholder and delete guidance comments. Keep paths inside the run directory.
- Keep host launch prompts to a pointer plus the host primitive (`/goal`, schedule,
  process). Put behavior in `executor.md`/`supervisor.md`, never duplicate it in the
  handoff prompt. Two words matter in every launch prompt: **read-and-follow, never an
  authoring verb** ("set up", "create", "author", "plan" read as permission to build
  something, and a fresh node answers by creating a goal or a second run) — and **"do not
  load any skill"**, because a host that matches skills by name or path can inject the
  authoring skill before the node opens its own file.
- Compile an `ops.md` Context index before writing the first ledger slice. Each row
  names when to read it, exact source pointers, and exact verification. Make the
  ledger Current slice and every directive cite those rows.
- Tune convergence; otherwise use `CONVERGE_EVERY=5`, `NET_LINE_CAP=400`, `KEEP_ROUNDS=5`, `OPEN_DIRECTIVE_CAP=8`, `STANDING_CAP=12`, `GAP_CAP=12`, and `CHAIN_BUDGET=8` where context carries.
- **Every durable section is bounded and rotates.** Rounds shard, corrections shard, STANDING and the gap register are capped and rewritten in place. Anything re-read every round that can only grow is a compounding tax — if a section has no cap, that is a defect, not a style choice.
- Do not bound an activation by round count. Long productive turns are the goal on hosts that carry context; steerability comes from re-reading directives every round, and every park costs a cold restart. Park conditions belong in the host reference, not a counter.
- Fill host-control placeholders from the selected reference; delete unused blocks. Host-specific facts belong in references, not in the generic templates.
- A node's one-time setup step must be unambiguous on four points, or the node improvises: **where** the recurring task is created (this same thread/session, or a separate standalone one — say which, and say what not to do), the **exact saved prompt** it runs, the **exact cadence**, and that **later invocations skip setup entirely**. Also say where the returned ID is recorded and that an existing one is updated in place, never duplicated.
- Name the host's cheap model tier as `FANOUT_TIER` in `ops.md` when the executor may spawn read-only sub-tasks; delete the section when the host has no cheap concurrent tier. Read-only investigators run cheap; the executor itself does not.
- Render [`templates/handoff.md`](templates/handoff.md) only as the chat response. It
  is a presentation template, not a runtime artifact: never save `handoff.md` in the
  run directory. Delete its supervisor section when no supervisor was selected.
- Keep hot files lean: current state, unresolved rows, recent rounds, and unconsumed directives only.
- Keep supervisor work delta-based: round watermark + repo tips identify the audit
  surface; unchanged context is not reread or re-verified.

**Step 3 — Deliver without making the owner discover the workflow.** Offer only when the user has not already chosen:

- **A (Recommended) — create both nodes here** when the detected host is Codex or Claude Code.
- **B — prompts only** when the owner will launch elsewhere.

Never end at "files generated." End with the exact next action and copy-ready prompt(s).

- **Create both nodes here:** treat the user's A choice as authorization to create the two in-scope runtime tasks/sessions and their schedules. Follow the selected reference's ordered capability check and creation protocol. Use the current project/checkout; do not create a cross-host prompt or silently switch to worktrees. Record returned IDs in `ops.md`, verify both nodes started, and report links/IDs plus how to stop them. Do not ask for a second confirmation.
- **Prompts only:** render the completed [`templates/handoff.md`](templates/handoff.md)
  in chat without persisting it. It must say how many sessions/tasks/processes to
  open, where each prompt goes, when to start the next one, what continues
  automatically, when/how context resets, and how it stops.
- Never leave `{{PLACEHOLDER}}` text or tell the owner merely to "start the loop." Keep executor and supervisor in separate contexts; use a cheap/fast executor and a strong clean-context supervisor when available.

## The rules that make it work (encoded in the templates)

- `ledger.md` is the single, bounded scoreboard; executor writes it, supervisor never does.
- One item per round: implement, verify, record. Register side-gaps for later.
- Force convergence; pilot expensive batches; require a real consumer before new surface area.
- Count only reproducible evidence on the declared real set.
- Pre-authorize checkable owner calls; present genuine exceptions as recommended A/B/C choices.
- Keep the supervisor fresh and separate; it re-verifies, writes only directives, and stops its schedule at terminal state.

## Files in this skill

- [`templates/`](templates/) — host-neutral runtime artifacts plus a chat-only launch-prompt template.
- [`references/`](references/) — one small, independently loaded file per host.
- [`methodology.md`](../../lib/methodology.md) — the deep dive (why each rule exists, failure modes it prevents).
- [`examples/add-tests-to-cli/`](examples/add-tests-to-cli/) — a fully worked, generic example.
- [`examples/migrate-blob-storage/`](examples/migrate-blob-storage/) — a longer worked example: milestones, a cohort pilot, a supervisor directive in action, and the non-skippable milestone gate blocking until the supervisor audits and releases.
