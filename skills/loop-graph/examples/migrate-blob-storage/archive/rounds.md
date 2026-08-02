# shutterlog — Archived rounds 1–4

- R1 2026-07-20 | M1 object-store client + upload write path | gate: green | net +74/−3 | open: reads use blob | next: read fall-through
- R2 2026-07-20 | M1 store-first read with blob fallback; logged GAP-001 | gate: green | net +58/−6 | open: GAP-001 | next: M2 pilot
- R3 2026-07-20 | M2 backfill pilot 25/25 with checksum verification | gate: green | net +49/−0 | open: full cohort | next: full backfill
- R4 2026-07-20 | M2 full backfill 4,812; accepted self-reported counter provisionally | gate: green | net +12/−0 | open: — | next: convergence
