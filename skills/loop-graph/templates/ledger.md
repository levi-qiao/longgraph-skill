<!--
loop-graph template: ledger.md — THE SINGLE SCOREBOARD (shared state between nodes).
The executor node rewrites this every round; the supervisor node only reads it.
Keep it COMPACT: it is re-read every round, so its size is a per-round token tax — and
because the executor's context carries across rounds and fires, each re-read is also
carried forward, so an unbounded log makes every round cost more than the last.
Hard rules: the whole file stays under {{FILE_LINE_CAP|200}} lines; the Rounds log keeps
only the last {{KEEP_ROUNDS|5}} entries and the excess is appended verbatim to
`archive/rounds.md` (never re-read). Carry durable facts in the "Starting snapshot"
below; update durable sections in place, never by appending.
-->

# {{PROJECT}} — longgraph Ledger

> This ledger is the run's only scoreboard. Authority order: {{AUTHORITY_LAYERS}} > this ledger. Environment facts: `ops.md`. Corrections from the supervisor: `directives.md`.
> Older rounds live in `archive/rounds.md` — don't open it unless debugging. Everything a fresh round needs is the snapshot + durable sections below.

## Status header

Current milestone: {{M1 or "single goal"}} | Round: 0 (starts at 1) | Last round net lines: —
Smallest unclosed item: {{FIRST_ITEM}}
Last directive folded: none   <!-- highest numbered D-xxx fully applied; advance only after its action/state change is recorded -->

Convergence tracker: rounds since last {{CONVERGE_EVERY|5}}: **0** | net lines since last +{{NET_LINE_CAP|400}}: **+0** | **next round converges: no**
<!-- Durable state, not arithmetic the executor redoes. It updates all three fields every
round and flips the flag to `yes` when either counter is reached; the next round is then
the convergence round, after which both counters and the flag reset. A `yes` carried past
one round is a defect the supervisor orders repaid. -->

Discovery tracker: queue **0** | closed this sweep **0** / refilled **0** | areas swept **0**/{{AREA_COUNT}} | sweeps with no yield: **0**
<!-- Discovery-driven runs only (items found by detectors/sweeps, not a fixed list); delete
this line otherwise. The register is rolling: closing N candidates obliges the executor to
discover at least N, and a short queue means re-running the indexed detectors before taking
work. Terminal status needs a yield check — consecutive full sweeps under {{YIELD_FLOOR|3}}
new qualifying candidates — never an empty queue. -->

Milestone gate: `open`   <!-- open | pending-audit | passed. Only meaningful for multi-milestone runs with a supervisor; single-goal / no-supervisor runs leave it `n/a`. The executor sets it `pending-audit` when it closes the current milestone's last exit condition (promotion requested — it does NOT advance, but the rest of the run keeps moving under the blocked-work rule); the supervisor re-verifies the boundary and, on pass, appends an acceptance directive; the executor flips it `passed` only when that directive lands, and only then starts the next milestone. Advancing while this is `pending-audit` is a red line. -->
Run status: `active`   <!-- active | exit-ready | stalled | closed. A terminal status (exit-ready/stalled/closed) is the signal for both nodes to stop their own timers. There is no waiting state: each node runs on its own timer, so an activation that finds nothing legal to do simply ends and the next fire looks again. -->

---

## Current slice (the next round starts here)

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
- working-tree alignment: branch tips, and uncommitted state split by OWNER — what the
  owner/predecessor left dirty versus what this authoring session itself created (files
  it moved, archived, generated, deleted). Enumerate the authoring session's own paths,
  or point at a list file; otherwise the executor cannot tell them apart, and "preserve
  work you did not create" silently protects the wrong set. Say how each side is to be
  resolved,
- still-in-force constraints distilled from any prior directives.
Keep it tight. This section is the sink other sections fold into, so it is also the one
that silently grows forever: it must drain too. A fact belongs here only while it still
changes what the executor does next — the moment its milestone is accepted, the detail
that supported it collapses to one evidence line and the rest goes.}}

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
     not belong here. Keep each row compact, but structured enough that the supervisor
     can emit a plain-language choice card without the owner reconstructing the issue. -->

| ID | Decision in plain language | Recommended choice | Other choice(s) | Why now |
| --- | --- | --- | --- | --- |
| OB-001 | {{one sentence}} | {{A — outcome}} | {{B/C — outcomes}} | {{blocked work + delay effect}} |

## Debt & gap register (log every gap here; never silently fix or ignore)

<!-- Active gaps only. When a gap closes, record its closure in the current round and
remove its row. This table is also the executor's fallback queue: when the Current slice
blocks, it takes the next row here that meets the blocked-work conditions instead of
ending the fire. Keep rows concrete enough to be picked up that way — a one-line gap
nobody can act on is dead air waiting to happen. Cap {{GAP_CAP|12}} live rows: past that,
merge duplicates and fold anything no longer actionable into the Starting snapshot as one
line. Seed this register at generation with enough real, independent work that the
executor always has a legal next item. On a discovery-driven run, seed the *method* — the
detectors, the refill quota, the rotation, and measured baselines — rather than a list of
targets an author's single pass happened to spot; the list would otherwise become the
run's ceiling. -->

| ID | Priority | Milestone | One line |
| --- | --- | --- | --- |
| GAP-001 | P? | {{M?}} | {{...}} |

## Rounds log — last {{KEEP_ROUNDS|5}} only (older → `archive/rounds.md`)

<!-- ONE TERSE LINE per round — this section is re-read every round, so keep it small.
When appending would exceed {{KEEP_ROUNDS|5}} lines, cut the oldest and append it
verbatim to `archive/rounds.md`. Line format: -->
<!-- - R<n> <date> | <item> | changed: <exact paths> | verify: <result/evidence pointer> | net +x/-y | next: <item + context IDs> -->
<!-- Tag a convergence round `CONVERGE` so the supervisor can confirm it fired. -->

<!-- You MAY keep only the CURRENT round as a short multi-line block when it carries
detail the supervisor must see this tick (e.g. a promotion request's evidence);
collapse it to the one-line form once the next round starts. -->
