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

- Repo `shutterlog` @ `feature/object-storage`, tip `f4e5a6b` (local commits only, never pushed). Staging dump of 2026-07-18.
- `attachments`: 4,812 rows, photo bytes in a blob column; 41 rows have NULL `content_type`.
- Serving path: `/photos/<id>` reads the blob column directly. Frozen contract.
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

| ID | Priority | One line |
| --- | --- | --- |
| GAP-001 | ~~P2~~ closed | 41 legacy rows have NULL `content_type`; serve-path sniffing added Round 9 — falls back to `application/octet-stream` for unrecognizable blobs |

## Gate-wait backlog (fixed at generation)

| ID | Boundary | Task + real consumer | Exact write set | Narrow verification | Status |
| --- | --- | --- | --- | --- | --- |
| GW-001 | M2→M3 | staging object-store access policy for the security reviewer | `docs/object-store-access-policy.md` | `markdownlint docs/object-store-access-policy.md` + required least-privilege/rotation headings | accepted (D-003, folded Round 8) |

## Rounds log

### Round 1 — 2026-07-20
- **Item**: M1 — object-store client + write path for new uploads
- **Gate**: `pytest tests/test_storage.py -q` → 6 passed; full suite + smoke green
- **Change**: single `storage.py` wrapper (put/get/head with checksum); upload handler writes to store
- **Verify**: new-upload tests pass; a manual upload lands in the store bucket
- **Net lines**: +74/−3
- **Open**: reads still hit the blob column
- **Next**: read fall-through

### Round 2 — 2026-07-20
- **Item**: M1 — read fall-through: store first, blob column second
- **Gate**: narrow → 9 passed; full suite + smoke green
- **Change**: `/photos/<id>` tries the store, falls back to the blob; bytes byte-compared in tests
- **Verify**: smoke green on all 20 ids (all still served from blobs — correct, backfill hasn't run)
- **Net lines**: +58/−6
- **Open**: noticed 41 rows with NULL `content_type` → **logged GAP-001, did not fix here**. M1 gates closed.
- **Next**: M2 — pilot the backfill before any full run

### Round 3 — 2026-07-20
- **Item**: M2 — backfill pilot on 25 rows (smallest-slice before the cohort)
- **Gate**: narrow → 11 passed; full suite + smoke green
- **Change**: `scripts/backfill.py` — batched copy, per-object checksum verify after upload
- **Verify**: 25/25 objects present, checksums match, smoke ids still byte-identical
- **Net lines**: +49/−0
- **Open**: pilot clean → authorized to go wide next round
- **Next**: full backfill

### Round 4 — 2026-07-20
- **Item**: M2 — full backfill (4,812 rows)
- **Gate**: narrow → 11 passed; full suite + smoke green
- **Change**: extended `scripts/backfill.py` with `--all` (batch-offset paging over the pilot's logic), ran it against the full table; script reported `4,812 processed, 0 errors`
- **Verify**: script counter matches table count (4,812 = 4,812) → recorded M2 as verified
- **Net lines**: +12/−0
- **Open**: none
- **Next**: convergence round (5th), then M3 promotion request

### Round 5 — 2026-07-20
- **Item**: forced convergence (every 5th round — no new features)
- **Gate**: narrow → 11 passed; full suite + smoke green
- **Change**: deleted the now-dead blob-write path in the upload handler; collapsed two checksum helpers into one
- **Verify**: full suite green after deletions
- **Net lines**: +6/−47
- **Open**: **D-001 arrived** — Round 4's evidence was the script's own counter, not an independent proof. M2 re-opened.
- **Next**: execute D-001

### Round 6 — 2026-07-20
- **Item**: D-001 — independent completeness proof for the backfill
- **Gate**: narrow → 12 passed; full suite + smoke green
- **Change**: `scripts/verify_backfill.py` — set diff of `attachments` primary keys vs a fresh store listing, + 1% checksum sample. **Diff found 3 rows missing**: for NULL-`content_type` rows (GAP-001) the backfill sniffs the type from the file header, and 3 truncated legacy files made the sniffer raise — a per-row `except: continue` swallowed the failures and counted them processed. Removed the swallow, re-ran the 3 rows with an `application/octet-stream` fallback.
- **Verify**: re-run set diff → empty; checksum sample 48/48 match; smoke green
- **Net lines**: +31/−9
- **Open**: GAP-001 stays queued (serve-path fallback covers it). M2 gates closed on independent evidence.
- **Next**: M2 promotion request — set Milestone gate to `pending-audit`; while it is audited, only preplanned GW-001 may modify the tree.

### Round 7 — 2026-07-20
- **Item**: M2 promotion request filed; gate set to `pending-audit`. Promotion audit surface: `scripts/backfill.py`, `scripts/verify_backfill.py`, storage tests, object-store listing/checksum artifacts, full suite, and smoke gate. Took preplanned GW-001 while parked.
- **Gate**: `markdownlint docs/object-store-access-policy.md` green; full suite + smoke green
- **Change**: wrote the security reviewer's staging access policy at its sole declared path; no dependencies, config, runtime code, contracts, or M2/M3 surfaces changed
- **Verify**: required least-privilege and rotation sections present; markdown lint green
- **Net lines**: +22/−0
- **Open**: Milestone gate still `pending-audit`; GW-001 is `done`, awaiting its own verdict. GAP-001 remains ordinary debt and was not touched.
- **Next**: fold milestone and backlog directives when they arrive; otherwise cheap no-op

<!-- ─── Supervisor tick between Round 7 and Round 8 ─── -->
<!-- The supervisor fired its scheduled tick here. From its clean context it:
     1. Read the ledger — saw `Milestone gate: pending-audit` (its trigger).
     2. Re-ran the M2 exit conditions independently:
        - `scripts/verify_backfill.py` → set diff empty, checksum sample 48/48.
        - `pytest -q` → 12 passed. `scripts/smoke_serve.sh` → 20/20 green.
        - Inspected `git diff main..HEAD --stat` for undisclosed shortcuts — none.
     3. Verdict: M2 boundary passes independent audit.
     4. Separately checked GW-001 stayed inside its declared docs-only write set and
        passed its narrow gate.
     5. Appended D-002 (milestone acceptance) and D-003 (GW-001 acceptance).
     6. Checkpoint-committed the audited state (SHA `a7c3d12`).
     The executor never saw this reasoning — only the directive that landed. -->

### Round 8 — 2026-07-20
- **Item**: D-002 and D-003 arrived. Flipped the M2 gate `pending-audit` → `passed`, marked GW-001 accepted, and advanced to M3.
- **Gate**: full suite + smoke green (no code change this round)
- **Change**: none — gate flip is a ledger-only state transition
- **Verify**: re-confirmed all M2 evidence still holds (set diff empty, smoke green)
- **Net lines**: +0/−0
- **Open**: M3 is DDL (`DROP COLUMN data`) — owner-only. GAP-001 remains executable debt.
- **Next**: GAP-001.

### Round 9 — 2026-07-20
- **Item**: GAP-001 — serve-path content-type sniffing
- **Gate**: narrow → 12 passed; full suite + smoke green
- **Change**: added `content_type_sniff()` fallback for the 41 NULL-`content_type` rows; unrecognizable blobs use `application/octet-stream`
- **Verify**: smoke green; the 3 truncated rows serve with the safe fallback
- **Net lines**: +18/−4
- **Open**: M3 DDL only — owner-only.
- **Next**: run is `owner-blocked` pending owner sign-off.
