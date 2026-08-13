# loop-converge pack

Authoring-only. Bind this pack, then compile the run from
[`../loop-graph/templates/`](../loop-graph/templates/). Do not copy these
rules into a second executor or supervisor template.

## North Star

In the declared scope, keep existing behavior and reduce unused code,
duplicate implementations, and unshared twins — reuse, merge, slim.
Proof: the project's tests stay green; declared detectors move down or
stay at zero; every work round has net production lines ≤ 0; no new public
surface without a named existing consumer.

## Supervisor

Required. Do not ask to omit it.

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

## Milestones (present as A unless inspection differs)

1. Inventory the scope and pin the detectors that actually exist here.
2. Delete code only after its reachability is disproved with evidence suited
   to the path.
3. Merge twin implementations only after a behavior matrix shows the shared
   contract and divergent edge cases.
4. Extract a shared owner only when there are at least three call sites.
5. Tighten names and interfaces; net lines ≤ 0.
6. Dry run: detectors + the full gate green; no new public surface.

Prefer delete > merge > extract > rename. Sequence so the smallest proven
deletion unblocks later merges; do not put a large enabling rewrite in
front of every proof.

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

`CONVERGE_EVERY=3`, `NET_LINE_CAP=200`, `FIRE_ROUND_CAP=8`. Other knobs
stay at the loop-graph defaults.

## Detector hints (compile into `ops.md` only)

Prefer detectors already present in the repo. Typical: JS/TS — knip,
jscpd; Python — ruff unused, vulture, jscpd; any stack — the project's
test command plus `git diff --stat` net lines. If no detector exists, the
first milestone is a manual inventory and the supervisor audits its
quality. Never hardcode a detector into a loop-graph template.

## Slug

Use `converge` unless a narrower scope slug is clearer
(`.longgraph/<YYYY-MM-DD>-converge`).
