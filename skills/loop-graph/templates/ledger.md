<!--
loop-graph template: ledger.md — THE SINGLE SCOREBOARD (shared state between nodes).
The executor node rewrites this every round; the supervisor node only reads it.
Keep it COMPACT: it is re-read every round, so its size is a per-round token tax — and on
a host whose rounds resume the previous round, each re-read is also carried forward, so
an unbounded Rounds log makes every round cost more than the last (O(n²) over a run).
Hard rule: keep only the last {{KEEP_ROUNDS|5}} round entries here;
when a new round pushes past that, move the oldest into a 100-round cold shard
such as `archive/rounds-0001-0100.md` (never re-read each round). Carry durable
facts in the "Starting snapshot" below; update the durable sections in place,
never by appending.
-->

# {{PROJECT}} — Octopus Ledger

> This ledger is the run's only scoreboard. Authority order: {{AUTHORITY_LAYERS}} > this ledger. Environment facts: `ops.md`. Corrections from the supervisor: `directives.md`.
> Rounds log holds only the last {{KEEP_ROUNDS|5}} rounds; older rounds live in 100-round shards under `archive/` — don't open them unless debugging. Everything a fresh round needs is the snapshot + durable sections below.

## Status header

Current milestone: {{M1 or "single goal"}} | Round: 0 (starts at 1) | Last round net lines: —
Smallest unclosed item: {{FIRST_ITEM}}
Last directive folded: none   <!-- highest numbered D-xxx fully applied; advance only after its action/state change is recorded -->
Convergence: fires at {{CONVERGE_EVERY|5}} rounds since last **or** +{{NET_LINE_CAP|400}} net lines, whichever first | since last: 0 rounds / +0 net | **next round converges: no**
Context chain: 0 of {{CHAIN_BUDGET|8}} rounds since last reset   <!-- Keep only when the selected host reference says rounds carry context. The executor +1s it each round and zeroes it after forcing a context reset — at a milestone boundary, after a convergence round, or on reaching the budget. Purpose: reset where the run chooses instead of where the host chops. -->

Milestone gate: `open`   <!-- open | pending-audit | passed. Only meaningful for multi-milestone runs with a supervisor; single-goal / no-supervisor runs leave it `n/a`. The executor sets it `pending-audit` when it closes the current milestone's last exit condition (promotion requested, executor keeps looping — does NOT advance); the supervisor re-verifies the boundary and, on pass, appends an acceptance directive; the executor flips it `passed` only when that directive lands, and only then starts the next milestone. Advancing while this is `pending-audit` is a red line. -->
Run status: `active`   <!-- active | paused | exit-ready | stalled | closed. A terminal status (exit-ready/stalled/closed) is the signal for both loops to stop themselves. Note: `pending-audit` on the Milestone gate is NOT a terminal Run status — the executor keeps looping. -->

---

## Current slice (the next activation starts here)

Item: {{FIRST_ITEM}}
Write set: {{exact paths or "read-only"}}
Context: {{ops.md context IDs plus exact local pointers}}
Verify: {{one narrow command}}
Done when: {{one observable condition}}

<!-- Rewrite this block in place whenever the next item changes. It replaces broad
workspace rediscovery and must stay under six lines. -->

---

## Starting snapshot (carried-forward — replaces bulk history)

{{SNAPSHOT — everything a fresh executor needs and nothing it doesn't:
- what's already done (closed milestones, with one-line evidence),
- current state of the in-progress milestone,
- baseline metric anchors (for reference, not to be passed off as current measurements),
- working-tree alignment (branch tips, any uncommitted state to reconcile first),
- still-in-force constraints distilled from any prior directives.
Keep it tight.}}

---

## Gate scoreboard

| Gate | Status | Evidence / next action |
| --- | --- | --- |
| {{exit condition 1}} | open / in-progress / closed / owner-blocked | {{...}} |

## Pending promotion (durable while Milestone gate = `pending-audit`)

Boundary: {{none or M1→M2}}
Audit surface: {{exact paths, artifacts, gates, and gate inputs}}
Evidence: {{terse exit-condition evidence}}

## Metric snapshot (if the goal is metric-driven)

| Metric | Baseline | Current |
| --- | --- | --- |
| {{metric}} | {{baseline}} | {{measured or "pending"}} |

## owner-blocked (genuinely case-by-case human decisions only)

<!-- Only items with NO standing authorization. If a STANDING pre-authorization in
     directives.md covers the action and its evidence bar is met, execute it — it does
     not belong here. This list is for calls that truly need the owner case by case. -->

<!-- Keep each row compact, but prepare enough structure for the supervisor to emit
     a plain-language choice card without making the owner reconstruct the issue. -->

| ID | Decision in plain language | Recommended choice | Other choice(s) | Why now |
| --- | --- | --- | --- | --- |
| OB-001 | {{one sentence}} | {{A — outcome}} | {{B/C — outcomes}} | {{blocked work + delay effect}} |

## Debt & gap register (log every gap here; never silently fix or ignore)

<!-- Active gaps only. When a gap closes, record its closure in the current round
and remove its row; the round later rotates into the cold archive. Never hide an
unresolved gap merely to shrink this table. -->

| ID | Priority | Milestone | One line |
| --- | --- | --- | --- |
| GAP-001 | P? | {{M?}} | {{...}} |

## Gate-wait backlog (optional; seed at generation, never add at runtime)

<!-- Work here is allowed only while Milestone gate = pending-audit. List an item
only when it has: no dependency on the current milestone verdict, next milestone,
or another backlog item; an exact write set disjoint from the promotion audit
surface, planned next-milestone write set, and every other backlog write set; no
shared/global surfaces (dependencies, lockfiles, schemas, generated files, gate
config, or public contracts); one-round scope; and a narrow verification that
creates no tracked changes outside that write set. If any condition is uncertain,
omit it. A gap discovered during execution stays in Debt & gap register and never
moves here. -->

| ID | Boundary | Task + real consumer | Exact write set | Narrow verification | Status |
| --- | --- | --- | --- | --- | --- |
| GW-001 | {{M1→M2}} | {{optional independent task + consumer}} | {{exact paths}} | {{command / check}} | ready / done / accepted / skipped |

<!-- After an accepted/skipped verdict is folded and recorded in the current
round, remove that row. Future-boundary rows remain. -->

## Rounds log — last {{KEEP_ROUNDS|5}} only (older → `archive/rounds-NNNN-NNNN.md`)

<!-- ONE TERSE LINE per round — this section is re-read every round, so keep it small.
When appending would exceed {{KEEP_ROUNDS|5}} lines, cut the oldest and append it
verbatim to the 100-round shard containing its round ID
(`archive/rounds-0001-0100.md`, then `0101-0200.md`, ...). Never let history pile
up here or in one unbounded archive file. Line format: -->
<!-- - R<n> <date> | <item> | changed: <exact paths> | verify: <result/evidence pointer> | net +x/-y | next: <item + context IDs> -->

<!-- You MAY keep only the CURRENT round as a short multi-line block when it carries
detail the supervisor must see this tick (e.g. a promotion request's evidence);
collapse it to the one-line form once the next round starts. -->
