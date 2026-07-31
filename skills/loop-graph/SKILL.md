---
name: loop-graph
description: Author one loop-graph run as executor, ledger, directives, and optional supervisor artifacts under a dated `.octopus` run directory. Use when the user asks to interview, generate, revise, or deliver a multi-round octopus run driven by `/loop`, especially for gated milestones, an independent clean-context audit, cross-host execution, or durable state. This is an authoring skill only. Do not use to execute or resume an existing `.octopus/.../executor.md` or `supervisor.md`; those runtime node files are self-contained.
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

**Step 1 — Interview** (fill the blanks, don't assume; present tradeoffs, don't silently pick). Ask in order — skip only if context already answers:

1. **Repos & branches**, and what must never be touched (others' uncommitted work, `main`, remote DBs).
2. **North Star** — the goal in one sentence + **how it's verified**. Push until each goal is checkable ("tests pass", "metric ≥ baseline"), not "make it work".
3. **Milestones** (optional) — ordered phases M1→Mn, each with an exit condition. Single goal → skip. For each supervised boundary, name its exact promotion audit surface (paths, artifacts, gates, and gate inputs) and identify any useful **Gate-wait backlog** items now. Admit only one-round tasks with real consumers, no dependency on the current verdict / next milestone / each other, exact write sets disjoint from the audit surface, the planned next-milestone write set, and every peer item, no shared/global surfaces, and a narrow verification. Uncertain or invented fill-in work is omitted. For supervised Codex, omit Gate-wait work: the executor parks at the M boundary and the cross-M supervisor resumes it after adjudication.
4. **Gates** — the exact per-repo verify commands (test/lint/build); capture special flags for `ops.md`.
5. **Red lines** — halt-the-run non-negotiables: no unauthorized push, no destructive git on others' work, no secrets/real data in code/logs/commits, frozen contracts, metrics-only-up.
6. **Commit authorization** — may the executor commit? push? (Default: executor implements+verifies; commit is a separate authorized step.)
7. **Supervisor?** — want the scheduled clean-context supervisor? It's an **independent acceptance auditor**: each tick it re-runs the gates and checks the real diff against the acceptance bar and the shared standards (`ops.md`, the repo's `AGENTS.md`/`CLAUDE.md`), catching drift / fake-done / concealment, then commits what passes, decides pending items, **adjudicates milestone promotions** (releases the executor into the next milestone when the evidence holds, so it doesn't stall for sign-off at every boundary), and steers the plan via directives. Interval (rough default ~12 min — see §8)? Fix the **owner-only decision list** (typical: DDL/schema, credentials / remote env / real-data exposure, spend beyond budget, lowering a metric bar, frozen contracts, push) — everything off that list the supervisor adjudicates itself so the run never stalls waiting for the owner.
   - **Pre-adjudicate the critical-path ones NOW — don't let the loop discover them.** If an owner-only category sits on the goal's *critical path* — the goal **is** dropping dead tables, so every round hits DDL; the goal **is** cutting cost, so every round hits spend — then leaving it on the blocking list means the loop can't do its own work: it just emits "proposals awaiting owner sign-off" and stalls. That defeats the loop. Settle it with the owner **in this interview**: turn it into a **standing authorization** — an objective, checkable **evidence bar** under which the executor acts autonomously and the owner retro-reviews (e.g. *"drop a table once evidence shows 0 rows + 0 code consumers + 0 reads/writes across all repos, applied via a reversible migration"*). Write each as a STANDING directive (`directives.md`). Only a decision that **genuinely can't be stated as a bar in advance** — one that needs the owner's judgment case by case — stays on the blocking list. Rule of thumb: if you can write the condition under which the answer is "yes", pre-authorize it; don't make the loop stop to ask.
8. **Loop host, pacing & interval** — every runtime is repeatedly invoked and resumes from the ledger; the host never becomes a second scoreboard.
   - **Adaptive:** Claude Code self-paced `/loop`.
   - **Interval:** Grok, Cursor, cron, shell. Size the delay from one round's implementation + gate time: light docs/config ≈ 3m, unit/build ≈ 5–10m, heavy integration/eval ≈ 15m. Cursor rounds must stay under its ~20m cap.
   - **Codex with a supervisor:** use one heartbeat for the cross-milestone supervisor and one long-running executor task. Within each activation the executor closes successive ledger rounds continuously, reusing context, until an M gate, unresolved owner block, correctable `stalled`, or terminal state. Record its session/thread ID in `ops.md`. After resolving a park through `directives.md`, the supervisor wakes that idle task with a thin pointer. Never queue a wake into an active executor or carry correction text in the wake. Without a supervisor, use the ordinary executor heartbeat.

   **Round granularity is host-aware, and finer is not cheaper.** A round is the smallest **independently verifiable** increment — one gate run closes it — but read the host's row in the [context-carry table](../../lib/host-dialects.md) first: almost none boots a round cold, so round *N* re-sends every earlier round's tool output and **splitting work finer pays that prefix more times for the same result.** Size rounds so real work clearly exceeds the carry — **batch sibling items that share one verification into a single round**, keep bulk output out of the transcript — and pair it with the ledger's `KEEP_ROUNDS` rotation: coarser rounds cut the *number* of carries, a bounded ledger cuts the *re-read* cost of each.

   **On a chain-carrying host, plan the resets too.** Set a **`CHAIN_BUDGET`** — rounds a node may accumulate before forcing a fresh transcript — a couple under that host's own blind-reset point, so the reset lands where the run chose (a **milestone boundary**, or right after a convergence round, ledger written and gates green) rather than mid-item. The supervisor is the strict case: **clean every tick**, or it stops being an outside reviewer; if the host exposes no reset, put that node on a fresh-per-tick host instead. Then fill both `{{CONTEXT_RESET_STEP}}` blocks with that host's mechanism from the same table — or delete them, and the ledger's Context-chain field, on a host with no chain.

   Compute executor and supervisor intervals for two-loop hosts (supervisor ≈ 3–4× executor, phase-offset). For supervised Codex, compute only the supervisor interval; the executor has no timer and keeps working between parks. All scheduled loops stop on terminal ledger state. Mixed models and cross-host nodes remain first-class.

Decide from context what you reasonably can and state the assumption; anything genuinely the user's call (data policy, DB access, lowering a bar) becomes a red line, a **standing authorization** (if you can pre-adjudicate it into a checkable evidence bar), or an `owner-blocked` item (only if it truly can't be pre-decided) — never silent, and never a blocking item the loop was supposed to execute.

**Step 2 — Generate** into a fresh `.octopus/<YYYY-MM-DD-slug>/` from `templates/`: `executor.md`, `ledger.md` (seed directive watermark + convergence tracker + milestone gate + durable Pending promotion + gate board + optional Gate-wait backlog + empty rounds log), `directives.md` (seeded from its template), `ops.md` (only if non-trivial env facts, or always for supervised Codex host control), `supervisor.md` (only if wanted), and `archive/` for cold shards. Point every internal path (`{{LEDGER_PATH}}`, `{{DIRECTIVES_PATH}}`) into the run directory. Replace every `{{PLACEHOLDER}}`, delete guidance comments. For supervised Codex, fill `HOST_DRIVE_STEP` with continuous-rounds-until-park semantics, seed `HOST_CONTROL_FACTS` with `PENDING-CODEX-LAUNCH`, and fill `HOST_CONTROL_STEP` with the idle-after-park wake rule; do not seed Gate-wait work. Delete those host blocks on other hosts. For each supervised milestone, make its Pending promotion state record the exact audit surface; seed only Gate-wait items that satisfy every interview-time independence condition, otherwise leave the section empty. **Set the convergence bounds from the plan** — `CONVERGE_EVERY` / `NET_LINE_CAP` aren't dogma: a feature-dense milestone converges more often (smaller N / cap), a cleanup or migration plan can loosen them (default 5 rounds / 400 net lines) — and seed them into the ledger's convergence tracker. Also set **`KEEP_ROUNDS`** (default 5), **`OPEN_DIRECTIVE_CAP`** (default 8), and 100-ID archive shards for rounds/directives so no live or cold file grows with the whole run. On a chain-carrying host, set **`CHAIN_BUDGET`** (default 8) plus both `{{CONTEXT_RESET_STEP}}` blocks (executor + supervisor) with that host's reset mechanism; seed the ledger's Context-chain field. On a fresh-per-tick host (shell/cron) delete the reset steps and that field instead of leaving a placeholder. **Write lean** — bullets over prose, reference `ops.md` / repo standards instead of inlining, no repeated rationale (mirror the repo's own `AGENTS.md` / standards style). Keep hot state compact: retain only current snapshot/state, unresolved rows, the latest `KEEP_ROUNDS` entries, and unconsumed directives. Closed rows are recorded in the current round then removed; folded directives and old rounds rotate into `archive/` shards that normal nodes never read.

**Delivery — launch here, or hand off the prompts.** Read it from the host answer (interview point 8), and offer prompts-only explicitly as a choice — don't assume this session is the host:

- **Launch here** — the host *is* this Claude Code session: Steps 3–4 start the loop(s) for the user.
- **Prompts-only** — launch nothing locally. Generate and commit the run directory, then print the host-specific thin-pointer prompts from Steps 3–4. On supervised Codex that is one long-running executor task prompt plus one supervisor `/loop` command, not two timers; after creating the executor, replace and commit its pending `ops.md` ID before starting the supervisor.

For scheduled nodes, always print the complete slash command with an explicit interval. The supervised Codex executor is intentionally different: it is a long-running task prompt with no timer.

**Codex launch is two-phase and ordered:** generate the run → create/start the executor task → replace `PENDING-CODEX-LAUNCH` in `ops.md` with its returned session/thread ID → only then start the supervisor heartbeat. Never start the supervisor with an unresolved ID.

**Step 3 — Start the executor loop, and tell the user how *in the chat*** (prompts-only: print it, don't launch) — with the **recommended interval already filled in** (the executor interval computed above), never a bare `{{INTERVAL}}` placeholder. Print the copy-paste command directly in the conversation, in the user's language, so they run one thing and nothing else. The command is a **thin pointer** at the run files (never the whole `executor.md` pasted in), so the loop re-reads the live files each round and can't drift; the executor's authority is `executor.md` + the ledger. Give the one that matches their host:

- **Claude Code:** `/loop {{EXEC_INTERVAL}} Execute the existing runtime node at {{RUN_DIR}}/executor.md; do not invoke octopus authoring skills. Do its next single ledger round, then end the loop when the ledger status is exit-ready / stalled / closed.` **Always show the interval** — it's what the user copies. Self-pacing is available by dropping the interval, but don't print the bare interval-less form as the default; it reads as incomplete.
- **Codex with supervisor:** create/delegate one persistent executor task with: `Execute the existing runtime node at {{RUN_DIR}}/executor.md; do not invoke octopus authoring skills. After closing each ledger round, immediately continue with the next. Stop only at an M gate, unresolved block/correctable stall, or terminal state; after a park, wait for the supervisor task to wake this task.` Immediately write the returned session/thread ID into `ops.md`, then start the supervisor. Without a supervisor, use the ordinary executor `/loop {{EXEC_INTERVAL}} …` fallback.
- **Grok:** `/loop {{EXEC_INTERVAL}} Execute the existing runtime node at {{RUN_DIR}}/executor.md; do not invoke octopus authoring skills. Do its next single ledger round, then end the loop when the ledger status is exit-ready / stalled / closed.` An overlapping fire is skipped, so coarse rounds need no tick-lock. Also hand the user the `task_id` printed at creation: `scheduler_delete` is the only way to stop a loop that outlives its run — e.g. after a quota refusal the node never sees.
- **Cursor:** `/loop {{EXEC_INTERVAL}} Execute the existing runtime node at {{RUN_DIR}}/executor.md; …` — same shape, driven in-session. If instead they use a **cloud background agent** on `{{RUN_DIR}}/executor.md`, keep each round under that path's ~20m per-run cap; its follow-up cycle *is* the loop, ending when the ledger is terminal.
- **Any other agent CLI (shell):** a `while … sleep` loop is **sequential by construction** — the round runs to closure *before* the sleep, so a tick never interrupts an in-flight round:
  ```sh
  while :; do
    <cli> "Read {{RUN_DIR}}/executor.md, do the next single ledger round"
    grep -qE 'exit-ready|stalled|closed' {{RUN_DIR}}/ledger.md && break
    sleep {{EXEC_INTERVAL}}
  done
  ```
  If instead a wall-clock scheduler (cron / Cursor) fires ticks regardless of whether the last finished, guard each tick with a portable lock so an overlapping tick **skips** rather than starting a second round: `mkdir {{RUN_DIR}}/.round.lock 2>/dev/null || exit 0; trap 'rmdir {{RUN_DIR}}/.round.lock' EXIT; <cli> "…one round…"`.

The loop runs fine on a **cheap/fast model** — structure, not model, keeps it on-spec. It **stops itself** when the ledger reaches a terminal status: the loop is dumb, the ledger decides.

**Step 4 — Start the supervisor loop** (if chosen; prompts-only: print it, don't launch) with `/loop {{SUP_INTERVAL}} Execute the existing runtime node at {{RUN_DIR}}/supervisor.md; do not invoke octopus authoring skills.` On Codex this is the **only heartbeat**: after resolving a park it reads the executor thread ID from `ops.md` and wakes that task only if idle; an unexpectedly idle task with ledger `running` may also be recovered. It never sends correction text in the wake message. On other hosts it remains the second, longer, phase-offset loop. It only observes and checkpoints clean boundaries — it never interrupts an in-flight executor round. Never run it as a subagent inside the executor loop. Give it a strong model and make its context fresh each tick using the host reset mechanism. Each tick:

- reads only durable state (ledger + `git status`) **and the shared standards both nodes obey** (`ops.md`, the repo's `AGENTS.md`/`CLAUDE.md`/lint) — never the executor's context;
- **independently audits acceptance**: re-runs the claimed-done item's gate/eval and inspects the real diff/artifact against the acceptance criteria and those shared standards, catching **drift, fake-done, and undisclosed shortcuts** the executor's own context hides — trusting its own re-verification, not the ledger's word;
- checkpoint-commits only **audited**, clean, gate-green, complete work (never half-written), local-only unless push is authorized;
- corrects drift **and wasteful method** and steers the plan only through the bounded `directives.md` queue; it appends new signals, rotates folded ones into cold shards, and never edits the ledger;
- **decides by default**: adjudicates anything off the owner-only list itself (directive + one-line rationale for retro-review), sweeps `owner-blocked` each tick for items it can unblock — including any whose STANDING pre-authorization bar is now met — and escalates only genuine case-by-case owner-only calls; **adjudicates milestone promotion** — at a boundary it re-verifies the milestone's exit conditions and, if evidence is sufficient, releases the executor into the next milestone via an acceptance directive instead of letting it idle for human sign-off (escalating only the final / North Star promotion or an owner-only boundary);
- **stops its own loop when the run is over** — ledger `closed`/`exit-ready`, tree clean, final item's audit passed (final checkpoint first), or stalled-and-escalated with the executor no longer advancing — so the monitoring loop never idles overnight.

## The rules that make it work (encoded in the templates)

- **One scoreboard.** The ledger is the only source of truth. Code/docs/ledger conflict → fix the ledger first.
- **Bounded hot edges.** The ledger keeps current state + the latest rounds; `directives.md` keeps fixed-at-generation STANDING subjects + a capped queue of unconsumed corrections. Retired history moves into 100-ID cold shards under `archive/`, which normal rounds/ticks never read. Unresolved work stays visible; only closed rows retire.
- **One item per round → verify same round → update ledger.** No batching, no "I'll test later".
- **Forced convergence — tracked in the ledger, not in the agent's head.** The status header carries a convergence tracker (rounds-since + net-lines-since + an explicit `next round converges` flag), so a stateless per-round loop reads the trigger instead of recomputing a modulo it can silently skip. A convergence round — zero features, only delete/merge/tighten, net lines ≤ 0 — fires on whichever comes **first**: N rounds since the last one (default 5) or accumulated net production lines over the cap (default 400); then the tracker resets. N and the cap are tuned to the plan's feature density at generation, and the supervisor audits that a flagged convergence actually converged.
- **Register-then-defer.** A gap found mid-round goes into the ledger's debt register by priority — never silently patched on the side, never dropped.
- **No speculative building.** New endpoint/module/abstraction/pool needs a named real consumer in the ledger first. No compat double-paths, v1/v2 coexistence, or parallel error systems.
- **Pilot before full batch.** Expensive full-cohort operations (whole-set evals, bulk VLM/API sweeps, migrations) run a smallest-slice pilot first; full run only after the pilot verifies clean.
- **Honest measurement.** A metric counts only on the real, declared eval set (the frozen holdout in the ledger). Numbers from synthetic/self-generated inputs or a cherry-picked subset aren't progress and are never recorded — benchmark-gaming the clean-context supervisor must catch. Evidence artifacts (scorecards, eval reports) land at versioned persistent paths — the run directory or the repo, never scratch/tmp; a number whose artifact has vanished is struck and re-measured.
- **Stop conditions end or park the drive.** Supervised Codex keeps running ordinary rounds within the current M and returns idle only at its `pending-audit` boundary, an unresolved block/correctable stall, or a terminal state; the cross-M supervisor wakes it after adjudication. Timer-driven hosts retain their normal tick behavior. Final/owner-only promotion, all-items-blocked, two unchanged non-parked rounds, or a red-line violation stop the run.
- **Clean-context separation, delegated authority.** The supervisor is a different node with a fresh context: it **independently re-verifies claimed-done work against the acceptance bar and the shared standards** (`ops.md`, repo `AGENTS.md`/`CLAUDE.md`) — catching drift, fake-done, and concealment the executor can't see in its own context — commits only what passes, **decides everything off the owner-only list itself** (logged rationale, retro-reviewable), and shapes the plan through the directives edge; escalating only genuine owner-only calls, never merging into the executor's context or writing its ledger.
- **Pre-adjudicate, don't propose-and-wait.** Owner-only decisions on the goal's critical path are settled at interview time into **standing authorizations** — an objective evidence bar the executor acts under autonomously (owner retro-reviews). A loop whose own work is owner-only (dropping dead tables, cutting spend) must not stall emitting proposals for the owner to sign; only a call that genuinely can't be stated as a bar in advance stays blocking.

## Files in this skill

- [`templates/`](templates/) — the five fill-in artifacts (executor, ledger, directives, ops, supervisor). The executor and supervisor prompts encode the loop's self-stop.
- [`methodology.md`](../../lib/methodology.md) — the deep dive (why each rule exists, failure modes it prevents).
- [`examples/add-tests-to-cli/`](examples/add-tests-to-cli/) — a fully worked, generic example.
- [`examples/migrate-blob-storage/`](examples/migrate-blob-storage/) — a longer worked example: milestones, a cohort pilot, a supervisor directive in action, and the non-skippable milestone gate blocking until the supervisor audits and releases.
