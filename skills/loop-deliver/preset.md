# loop-deliver pack

Authoring-only. Bind this pack, then compile the run from
[`../loop-graph/templates/`](../loop-graph/templates/). Do not copy these rules into a
second executor or supervisor template.

## North Star

Deliver the declared requirement as observable user or system behavior, with every
accepted behavior mapped to a real consumer path and a repeatable acceptance check. Keep
the requested contract intact; do not add speculative features, configuration, or public
surface. Proof is the declared acceptance suite plus the project's relevant gates, with
each completed vertical slice independently demonstrable.

## Supervisor

Required. It independently checks the changed behavior against the requirement,
traceability rows, real consumer path, and acceptance gate. It audits under-delivery too:
a fire that stops before the next legal slice, a slice that proves only a helper, or a
milestone that claims completion while an acceptance row remains open.

## Interview (at most these three)

After inspection, propose answers; do not ask the owner to design the run.

1. **Outcome and acceptance.** **A (Recommended)** — compile the stated requirement into
   the inspected user/system path and its observable acceptance checks. **B** — deliver a
   narrower named behavior now and register the remainder. Ask only if the request or
   repository leaves the contract materially ambiguous.
2. **Authority.** **A (Recommended)** — local edits, tests, and commits when the repo
   already commits; no push, destructive git, production/remote mutation, secrets or
   real-data exposure, unbounded spend, schema/public-contract changes, or lowered
   acceptance bar. **B** — edits and tests only; no commits. **C** — authorize one named
   contract or migration change under a drafted STANDING evidence bar.
3. **Launch.** **A (Recommended when supported)** — create both runtime nodes here on
   Codex or Claude Code. **B** — print copy-ready prompts for another host.

## Shape (present as A unless inspection differs)

Use a short chain of vertical slices, each traversing one real consumer path from input
to observable outcome. Start with the smallest behavior that removes uncertainty for the
next slice; do not front-load a broad framework or cleanup. A slice may include all
coupled edits, tests, fixtures, and migration steps that share one behavior claim and
acceptance gate. Verify it before the next slice, record its traceability, then move on.

At each milestone boundary, the ledger names the remaining acceptance rows, audit
surface, and exact promotion gate. A failed slice becomes a bounded redo or debt row; it
does not silently change the requirement.

## Method guards (`PROJECT_SPECIFIC_METHOD_GUARDS`)

- Write each requirement row as `behavior | real consumer | acceptance proof | status`.
  A helper, mock-only test, or undocumented assumption cannot close a row.
- Keep one behavior claim per workset. Include every coupled production and test edit
  needed for that claim; defer a neighboring behavior rather than widening it.
- Prefer the existing seam and owner. Introduce an abstraction, option, or public API
  only when an existing consumer requires it and the acceptance row names that consumer.
- Characterize existing behavior before changing a risky or undocumented path. The
  characterization test must exercise the real path, not duplicate implementation logic.
- A migration, compatibility period, or contract change needs an explicit authority bar,
  rollback/forward story, and consumer proof. Otherwise register it rather than guessing.
- Keep acceptance evidence comparable to the baseline: same input class, configuration,
  and gate. A green narrower test does not substitute for a declared acceptance check.
- When a supervisor rejects a slice, preserve the requirement and record the failure
  class in a directive; fix the slice or narrow it explicitly, never lower the bar.

## Knob overrides

`FIRE_ROUND_CAP=8`; `FIRE_OUTPUT_FLOOR` = one accepted vertical slice or a named
blocker plus the next legal slice; `CONVERGE_EVERY=5`; `NET_LINE_CAP=400`. The fire cap
is a per-fire backstop, never a run cap. Other knobs stay at the loop-graph defaults.

## Artifact emphasis

- In `ledger.md`, put the requirement traceability table in Gate scoreboard and make the
  Current slice name one behavior, consumer path, and acceptance check.
- In `ops.md`, pin the requirement source, affected interfaces, real consumer entrypoint,
  and exact gates; record migration/data facts and costs only when relevant.
- In `directives.md`, keep authority and scope decisions only; method belongs in the
  executor prompt.
- In `supervisor.md`, independently follow the strongest changed consumer path before
  accepting a slice or milestone.

## Slug

Use `deliver` unless a narrower requirement slug is clearer
(`.longgraph/<YYYY-MM-DD>-deliver-<topic>`).
