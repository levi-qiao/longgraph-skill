# shutterlog — Octopus Ledger

> This ledger is the run's only scoreboard. Authority order: the task book in `executor.md` > this ledger. Supervisor corrections: `directives.md`.

## Status header

Current milestone: M3 cutover — owner-only DDL | Round: 9 | Last round net lines: +18/−4
Smallest unclosed item: M3 (owner-only: drop the blob column)
Last directive folded: D-003
Convergence tracker: rounds since last 5: **4** | net lines since last +400: **+58** | **next round converges: no**
Milestone gate: `passed` (D-002 acceptance directive released M2→M3 boundary in Round 8)
Run status: `active` (OB-001 outstanding; the fire ended with no legal item left, the next one re-checks)

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

| ID | Decision in plain language | Recommended choice | Other choice(s) | Why now |
| --- | --- | --- | --- | --- |
| OB-001 | Remove the old photo-data column now that every photo is verified in object storage? | A — remove it with a reversible migration | B — keep it for one release and remove later | M3 cannot finish while both storage copies remain |

Owner card emitted: **A (Recommended)** removes the duplicate column now; all 4,812
rows are present in object storage and checks pass. **B** keeps the duplicate for one
release, using more storage but delaying the destructive step. Reply with `A` or `B`.

## Debt & gap register

(none — GAP-001 closure is recorded in Round 9; GAP-002 closure in Round 8)

## Rounds log — last 5 only (older → `archive/rounds.md`)

- R5 2026-07-20 | CONVERGE; D-001 reopens M2 self-reported proof | gate: green | net +6/−47 | open: D-001, GAP-001 | next: D-001
- R6 2026-07-20 | D-001 independent set diff + checksum sample; repaired 3 swallowed rows | gate: green | net +31/−9 | open: GAP-001 | next: M2 promotion
- R7 2026-07-20 | M2 pending-audit; lane: GAP-002 staging access policy (docs-only, disjoint from the audit surface) | gate: green | net +22/−0 | open: M2 audit, GAP-001 | next: directives
- R8 2026-07-20 | folded D-002/D-003; M2 passed, GAP-002 accepted | gate: green | net +0/−0 | open: M3 owner DDL, GAP-001 | next: GAP-001

### Round 9 — 2026-07-20
- **Item**: GAP-001 — serve-path content-type sniffing
- **Gate**: narrow → 12 passed; full suite + smoke green
- **Change**: added `content_type_sniff()` fallback for the 41 NULL-`content_type` rows; unrecognizable blobs use `application/octet-stream`
- **Verify**: smoke green; the 3 truncated rows serve with the safe fallback
- **Net lines**: +18/−4
- **Open**: M3 DDL only — owner-only.
- **Next**: nothing legal left in the lane — fire ended with OB-001 awaiting the owner's `A`/`B`.
