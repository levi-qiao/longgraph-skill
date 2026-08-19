# loop-converge pack

Authoring-only. Bind this pack, then compile the run from
[`../loop-graph/templates/`](../loop-graph/templates/). Do not copy these
rules into a second executor or supervisor template.

## North Star

In the declared scope, keep existing behavior and reduce unused code,
duplicate implementations, and unshared twins — reuse, merge, slim.
Proof: the project's tests stay green; declared detectors move down or
stay at zero; every work round has net production lines ≤ 0; no new public
surface without a named existing consumer; the candidate register keeps
refilling and every area of the scope gets swept.

**This is a sweeping run, not a checklist.** Candidates are discovered by the
executor each round, never handed to it as a fixed list — an author sees one
context window of a tree the run will cross many times. Termination is a yield
check (below), never an empty queue.

## Supervisor

Required. Do not ask to omit it. It audits under-delivery — no-change rounds,
fires ending under the output floor, a register that stopped refilling, a sweep
with no merge, areas never swept before a terminal claim — with the same rigor
as it audits violations, and it never bans a whole directory or a whole class of
action.

## Interview (at most these three)

After inspection, propose answers; do not ask the owner to design them.

1. **Scope.** **A (Recommended)** — the inspected hot path (name the
   directories). **B** — the whole repository.
2. **Authority.** **A (Recommended)** — local edits and verification
   allowed; existing tests must stay green; public APIs stay frozen; no new
   features; commits only when the run needs them and the repo already
   commits. No push, destructive git, production/remote mutation, secrets
   or real-data exposure, unbounded spend, or lowering the acceptance bar.
   **B** — edits and tests only; no commits. **C** — allow a named public-API
   merge under a drafted STANDING evidence bar.
3. **Launch.** **A (Recommended when supported)** — create both runtime nodes
   here on Codex or Claude Code. **B** — print copy-ready prompts for another
   host.

## Shape (present as A unless inspection differs)

A rotation, not a phase chain. Round one pins the detectors that exist here,
measures every baseline, and lands its first cheap deletion in the same round —
inventory that produces nothing is spinning. After that, each round: refill the
register from the detectors, take one family, prove it, land it, record it.

Rotate over the whole scope (partition it by directory or layer) and pick the
next area by staleness, detector density, or adjacency to the last real find.
An area is "swept" when a fresh detector pass there yields under the floor —
not when someone has looked at it. Per sweep, land at least one real merge or
extraction; two consecutive sweeps of deletions only means the run is picking
soft targets.

Prefer delete > merge > extract > rename, and sequence so the smallest proven
deletion unblocks later merges; do not put a large enabling rewrite in front of
every proof. Phase gates that only flip a status are not rounds — fold an
acceptance into the next work round.

## Method guards (`PROJECT_SPECIFIC_METHOD_GUARDS`)

- Priority is delete, then merge, then extract, then rename. "Elegant" or
  "generic" means one owner, not a new framework.
- Do not extract a new shared abstraction before three existing call sites;
  merging two twins into an existing owner is allowed. No consumer → do not
  build.
- Every work round nets ≤ 0 lines. Inventory rounds write only the ledger.
  An extract and the deletion of its copies belong in the same round.
- Every candidate names its scope and verifier, then records before/after
  evidence plus a persistent pointer. No proof packet → no deletion or merge.
- Keep each open candidate in one bounded Debt/gap row:
  `lane | scope | baseline | verifier | evidence/window | verdict`. Rewrite
  the row in place and remove it when its round closes; do not add a new edge
  or unbounded candidate log.
- Detectors generate candidates; they never decide one. Record each detector's
  blind spots (files it cannot parse, constructs it ignores) — a detector that
  silently skips a file reads as "clean".
- A "keep" verdict must name the specific divergence — the input, branch, or
  caller that makes two things not the same thing. "They differ" is not a
  verdict, and a run that only ever keeps is a run that never converged.
- Tier the proof bar by risk: cheap gates for code the product does not run,
  the expensive gate for the paths it does. Identical output is the fast path
  through that gate, not the only one — a bar meetable only by changing nothing
  forbids the merges this run exists to make. Batch several candidates into one
  run of a slow gate and bisect within the batch on failure.
- Static suspicion is not proof for plugins, reflection, public APIs, or
  generated paths. When existing runtime observability can decide the case,
  use its narrowest available probe and record the observation window in
  `ops.md`; delete only on a later round after the window closes. Otherwise
  register the candidate instead of deleting it.
- Do not merge similar-but-divergent implementations without a named shared
  contract and a compact behavior matrix covering representative and edge
  cases; preserve intentional differences explicitly.
- A compatibility double path is a defect, not a migration strategy, unless
  a STANDING directive already authorizes it.
- Behavior-preserving: existing tests stay green. A critical path with no
  test gets one narrow characterization test in the same round before the
  edit; keep the round net ≤ 0 or register the candidate instead.
- When review rejects a candidate, the supervisor records the failure class
  and tightens its detector, scope, or proof through a directive. It never
  lowers the bar or leaves the lesson only in either node's context.

## Knob overrides

`CONVERGE_EVERY=6`, `NET_LINE_CAP=200`, `FIRE_ROUND_CAP=20` (a backstop, not a
target — the output floor is what paces a fire), `FIRE_OUTPUT_FLOOR` = three
verified candidates landed or a clear net-line reduction, `YIELD_FLOOR=3` new
qualifying candidates per swept area. Every work round is already net ≤ 0 here,
so converging every third round buys ceremony; a convergence round in this run
must itself remove code. Other knobs stay at the loop-graph defaults.

## Detector hints (compile into `ops.md` only)

Prefer detectors already present in the repo. Typical: JS/TS — knip,
jscpd; Python — ruff unused, vulture, jscpd; any stack — the project's
test command plus `git diff --stat` net lines. Cover both halves: an
unused-symbol detector and a duplication detector, since without the second
one the run will only ever delete. If the stack has no duplication detector,
generate a throwaway one into the run's untracked evidence directory rather
than adding a tracked dependency, and freeze its first output as the baseline.
If no detector exists at all, round one is a manual inventory that still lands
a change, and the supervisor audits its quality. Never hardcode a detector into
a loop-graph template.

## Slug

Use `converge` unless a narrower scope slug is clearer
(`.longgraph/<YYYY-MM-DD>-converge`).
