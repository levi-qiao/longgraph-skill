<!--
loop-graph template: directives.md — the ONE-WAY corrections edge.
Seeded near-empty at generation time into the run directory. The supervisor node
(or the designated owner when no supervisor exists) is its single writer; the
executor node reads it each round and folds numbered items after
its ledger watermark into the round — it never writes this file. This live queue
contains one supervisor-owned comparison baseline, the fixed-at-generation STANDING subjects, and at most
{{OPEN_DIRECTIVE_CAP|8}} not-yet-folded corrections. A policy change replaces
its subject in place; it never grows STANDING with runtime history. Before adding signals, the designated writer moves
folded corrections into 100-ID cold shards such as
`archive/directives-0001-0100.md`; normal audit logic never loads those shards.
The directives writer performs only a targeted ID check while rotating.
The executor's ledger stores the highest fully applied D-xxx as
`Last directive folded`; number the next correction from the greater of that
watermark or the live IDs. Preserve ordering across rotation.
On a successor run, reset Supervisor state and copy still-in-force STANDING items.
-->

# {{PROJECT}} — Directives (supervisor → executor, one-way)

## Supervisor state (updated in place; executor ignores)

Last completed tick: none | audited through round: 0 | repo tips: pending | last dispatched directive: none

## STANDING (always in force — carried across runs; treat like red lines)

<!-- Also the home for OWNER PRE-AUTHORIZATIONS decided at interview time: an
     owner-only action the executor MAY do autonomously once an objective evidence
     bar is met (owner retro-reviews). This is what keeps a loop whose own work is
     owner-only (e.g. dropping dead tables) from stalling on propose-and-wait.
     Format: S-001 · PRE-AUTH — <action> is authorized once <checkable evidence bar>; apply via <reversible method>. -->

{{none yet, or items carried over from the previous run — including owner pre-authorizations from the interview}}

## Corrections (numbered; live queue = not-yet-folded only)

<!-- One compact context packet; point, do not restate source material.
Format: D-001 · <date> · <accept|redo|plan|stop>
Context: <ops context IDs + exact paths/symbols/evidence>
Action: <one bounded action>
Verify: <exact command/observable result>
Stop: <condition that prevents widening or repeat work> -->

(none yet)
