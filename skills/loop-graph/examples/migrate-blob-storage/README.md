# Example: migrate blob storage out of the database

A fully worked, **generic** example — no real project, no secrets. Where [`add-tests-to-cli`](../add-tests-to-cli/) shows the smallest possible run (single goal, three rounds, empty directives), this one shows the parts of the shape that only appear on a longer, riskier task: milestones, a pilot before a cohort-scale operation, a forced convergence round, an owner-only stop, a supervisor directive catching self-reported evidence — and **the non-skippable milestone gate** with an audit-safe blocked-work lane.

## The scenario

`shutterlog` is a fictional photo-journal web app. Uploaded photos live as blobs in its `attachments` database table; the goal is to move them to an S3-compatible object store without breaking a public URL contract:

> New uploads go to the object store; every legacy photo is backfilled and verified complete; `/photos/<id>` keeps resolving for every existing id; then (and only then) the blob column can be dropped.

The run works against a **staging dump** — production credentials are a red line.

## What the interview produced

- **Repo/branch:** `shutterlog` on `feature/object-storage`. Never touch `main`.
- **Milestones:** M1 dual path (new uploads → store, reads fall through store → blob) → M2 backfill, verified complete → M3 cutover + drop the blob column (**owner sign-off — destructive**).
- **Gates:** `pytest tests/test_storage.py -q` (narrow), `pytest -q` + `scripts/smoke_serve.sh` (full — fetches 20 known photo ids, compares bytes).
- **Red lines:** no blob deleted before its object is checksum-verified; the `/photos/<id>` contract is frozen; staging only; no push; a change that reddens a previously-green test is reverted the same round.
- **Owner-only list:** schema DDL (the column drop), anything touching production, lowering a gate.
- **Cadence:** executor fires every 10 min and closes up to 3 rounds; supervisor fires every 30 min on its own timer. Neither wakes the other.
- **Blocked-work lane:** GAP-002, a docs-only staging access policy for the security reviewer, registered in the debt register up front. Its sole write path and narrow check are independent of M2, M3, shared surfaces, and every other item — which is exactly what makes it legal to take while the milestone is under audit.

## What happened in the run

The run spans nine rounds; the live ledger shows the latest five and cold-archives the first four. Two sequences are worth reading closely:

**The drift catch (Rounds 4–6).** The executor ran the full backfill and recorded M2 as verified — on the evidence of the migration script's **own** "4,812 processed" counter. Inside the executor's context that number looked like proof; the script had printed it, after all. The supervisor, reading the ledger cold, saw self-generated evidence where an independent proof belonged and wrote `D-001`: produce a primary-key set diff between the table and a fresh object-store listing, plus a checksum sample. The diff found 3 rows the script had silently dropped — a swallowed per-row exception had counted failures as processed. Round 6 fixes them and proves the diff empty. In the shown final state D-001 is folded, so it lives in [`archive/directives.md`](archive/directives.md), not the live queue.

**The milestone gate (Rounds 7–9).** After Round 6 closes M2, the executor records M2's audit surface, sets `Milestone gate: pending-audit`, and — instead of idling until the next supervisor tick — takes registered GAP-002, a docs-only security policy whose write set cannot affect M2 or M3. The supervisor audits two lanes: it independently re-runs M2 acceptance and separately checks GAP-002's write set and narrow gate, then emits D-002 and D-003. Round 8 folds both verdicts and advances; only after the boundary clears does Round 9 work ordinary GAP-001 debt. The run then ends its fire at the owner-only DDL, with the choice card outstanding.

## The points

**Self-generated evidence.** The executor wasn't lying in Round 4; it was reasoning from a context that contained the script's cheerful output. A same-context loop would reason from the same evidence. A clean-context supervisor never saw the script run, so "the script says so" carries no weight — only an independent listing does.

**The gate cannot be skipped or blurred.** Round 7 is productive without changing the thing under review: only an already-registered, dependency-free item with an exact disjoint write set may run. Debt that touches the audit surface waits. The supervisor reports separate milestone and lane verdicts, so a lane failure cannot hold a valid promotion unless it contaminated the audit surface. Advancing or writing outside that contract while `pending-audit` is a red line.

**History is cold, not lost.** The live ledger shows only Rounds 5–9; Rounds 1–4 are in [`archive/rounds.md`](archive/rounds.md). The live directives queue is empty after D-003 is folded; all three directives are in its bounded cold archive. Normal executor/supervisor ticks read neither archive.
