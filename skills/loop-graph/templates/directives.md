<!--
loop-graph template: directives.md — the ONE-WAY corrections edge.
Seeded near-empty at generation time into the run directory. The supervisor node (or the
designated owner when no supervisor exists) is its single writer; the executor node reads
it whole every round and folds numbered items above its ledger watermark — it never
writes this file.

This is a LIVE QUEUE, not a log. It holds the supervisor's state line, the STANDING
authority block, and at most {{OPEN_DIRECTIVE_CAP|8}} not-yet-folded corrections —
nothing else, and never more than {{FILE_LINE_CAP|200}} lines. Before appending, the
writer moves every correction at or below the ledger's `Last directive folded` watermark
verbatim into `archive/directives.md` and deletes it here; normal audit logic never loads
that archive. Number the next correction from the greater of the watermark and the
highest live ID, so a rotated ID is never reused. A policy change rewrites its STANDING
subject in place; STANDING never accumulates runtime history.
On a successor run, reset Supervisor state and copy still-in-force STANDING items.
-->

# {{PROJECT}} — Directives (supervisor → executor, one-way)

## Supervisor state (updated in place; executor ignores)

Last completed tick: none | audited through round: 0 | repo tips: pending

## STANDING — authority only (always in force; treat like red lines)

<!-- AUTHORITY, NOT METHOD: what the executor may and may not do. HOW it works lives
     in `executor.md`. Restating method here is the main way this file silently
     doubles, and every entry is re-read every round. Cap {{STANDING_CAP|12}} live
     entries; a superseded entry is rewritten in place, never appended.
     Also the home for OWNER PRE-AUTHORIZATIONS decided at interview time: an
     owner-only action the executor MAY do autonomously once an objective evidence
     bar is met (owner retro-reviews). This is what keeps a loop whose own work is
     owner-only (e.g. dropping dead tables) from stalling on propose-and-wait.
     Format: S-001 · PRE-AUTH — <action> is authorized once <checkable evidence bar>; apply via <reversible method>. -->

{{none yet, or items carried over from the previous run — including owner pre-authorizations from the interview}}

## Corrections (numbered; live queue = not-yet-folded only)

<!-- One compact packet, at most eight lines; point, do not restate source material.
Format: D-001 · <date> · <accept|redo|plan|stop>
Context: <ops context IDs + exact paths/symbols/evidence>
Action: <one bounded action>
Verify: <exact command/observable result>
Stop: <condition that prevents widening or repeat work> -->

(none yet)
