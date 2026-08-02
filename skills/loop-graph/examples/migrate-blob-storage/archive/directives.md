# shutterlog — Folded directives D-001–D-003

D-001 · 2026-07-20 — Round 4 recorded M2 as verified on the backfill script's own `processed` counter: self-generated evidence, not an independent proof → produce a primary-key set diff between `attachments` and a fresh object-store listing plus a 1% checksum sample; M2 stays open until the diff is empty. (Decided under delegated authority — re-verification is reversible and touches no owner-only item.)

D-002 · 2026-07-20 — **M2 milestone acceptance.** Independent audit of the M2 boundary: re-ran `scripts/verify_backfill.py` (set diff empty), full `pytest -q` (12 passed), `scripts/smoke_serve.sh` (20/20 byte-identical), inspected diff for undisclosed shortcuts (none found). All exit conditions verified from clean context. → Executor: flip Milestone gate to `passed` and advance to M3. (Decided under delegated authority — M2→M3 promotion is not itself DDL or production-touching; the DDL is M3's *content*, gated separately by the owner-only list.)

D-003 · 2026-07-20 — **GAP-002 acceptance.** Diff is confined to `docs/object-store-access-policy.md`; it is independent of M2/M3 and shared surfaces, and its required headings + markdown lint pass. → Executor: mark GAP-002 accepted and close its row. This verdict does not change the Milestone gate.
