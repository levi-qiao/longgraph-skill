# shutterlog — Octopus Ledger

> This ledger is the run's only scoreboard. Authority order: the task book in `executor.md` > this ledger. Supervisor corrections: `directives.md`.

## Status header

Current milestone: M3 cutover — owner-only DDL | Round: 9 | Last round net lines: +18/−4
Smallest unclosed item: M3 (owner-only: drop the blob column)
Last directive folded: D-003
Convergence: fires at 5 rounds since last or +400 net lines, whichever first | since last: 4 rounds / +58 net | **next round converges: no**
Milestone gate: `passed` (D-002 acceptance directive released M2→M3 boundary in Round 8)
Run status: `owner-blocked`

---

## Starting snapshot

- Repo `shutterlog` @ `feature/object-storage`, tip `a7c3d12` (local commits only, never pushed). Staging dump of 2026-07-18.
- `attachments`: 4,812 rows, photo bytes in a blob column; 41 rows have NULL `content_type`.
- Serving path: `/photos/<id>` reads object storage first, falls back to the blob column, and safely sniffs missing content types. Frozen URL contract.
- Baseline: full `pytest -q` green; `scripts/smoke_serve.sh` green on 20 known ids.

---

## Gate scoreboard

| Gate | Status | Evidence / next action |
| --- | --- | --- |
| New uploads land in the object store, not the blob column | closed | `tests/test_storage.py` green since Round 1 |
| Every legacy photo exists in the object store | closed | set diff empty (Round 6), checksum sample 48/48 |
| `/photos/<id>` serves identical bytes for every id | closed | smoke green every round since Round 1 |
| Full suite green | closed | `pytest -q` green as of Round 9 |

## Pending promotion

none (M2→M3 adjudicated by D-002 in Round 8)

## owner-blocked

- M3 cutover: `ALTER TABLE attachments DROP COLUMN data` is schema DDL (owner-only). Promotion request written Round 8 — awaiting sign-off.

## Debt & gap register

(none — GAP-001 closure is recorded in Round 9)

## Gate-wait backlog (fixed at generation)

(none — GW-001 acceptance is recorded in Round 8)

## Rounds log — last 5 only

- R5 2026-07-20 | forced convergence; D-001 reopens M2 self-reported proof | gate: green | net +6/−47 | open: D-001, GAP-001 | next: D-001
- R6 2026-07-20 | D-001 independent set diff + checksum sample; repaired 3 swallowed rows | gate: green | net +31/−9 | open: GAP-001 | next: M2 promotion
- R7 2026-07-20 | M2 pending-audit + GW-001 access policy | gate: green | net +22/−0 | open: M2/GW audits, GAP-001 | next: directives
- R8 2026-07-20 | folded D-002/D-003; M2 passed, GW-001 accepted | gate: green | net +0/−0 | open: M3 owner DDL, GAP-001 | next: GAP-001

### Round 9 — 2026-07-20
- **Item**: GAP-001 — serve-path content-type sniffing
- **Gate**: narrow → 12 passed; full suite + smoke green
- **Change**: added `content_type_sniff()` fallback for the 41 NULL-`content_type` rows; unrecognizable blobs use `application/octet-stream`
- **Verify**: smoke green; the 3 truncated rows serve with the safe fallback
- **Net lines**: +18/−4
- **Open**: M3 DDL only — owner-only.
- **Next**: run is `owner-blocked` pending owner sign-off.
