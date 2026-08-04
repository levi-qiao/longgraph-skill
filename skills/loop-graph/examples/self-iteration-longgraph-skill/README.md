# Example: longgraph self-iteration (public Git evidence)

A **public-safe, commit-backed** case. This is not a fictional project run and not a
private client trajectory. It is the history of **this repository** (published during
the window as `octopus-skill`; product brand is now **longgraph** / `longgraph-skill`)
while the loop-graph method was hardened into a shippable skill.

The point for a first-time reader: longgraph is not only a methodology writeup.
Its durable rules (single scoreboard, clean-context supervisor, no wake edge,
gate-wait backlog, bounded live files) were shaped by multi-day agent work and
then written back into the public library.

## Evidence window (frozen)

| Signal | Value |
| --- | --- |
| Fixed anchor commit | `6efcb7f0e8cb834027e3722342fee57c26cb2fdf` |
| Anchor subject | `fix(loop-graph): give the snapshot a drain and stop mirroring the repo's own routing (#56)` |
| Public Git window | 2026-07-19 10:53 +08:00 → 2026-08-02 14:48 +08:00 |
| Calendar elapsed | ~14.2 days (~340 wall-clock hours of *project lifetime*) |
| Public commits in window | 87 |
| Unique files touched | 74 |
| Cumulative insertions / deletions | 6981 / 3958 |
| Days with at least one public commit | 12 |

**How to read these numbers.** They are **public Git facts**, not continuous model
execution hours and not a claim of unattended production autonomy. Calendar
elapsed is wall-clock project time from the first public commit to the anchor.
Readers can re-check the window against the fixed anchor:

```bash
# Freeze numbers against the fixed anchor (not whatever HEAD is today)
ANCHOR=6efcb7f0e8cb834027e3722342fee57c26cb2fdf
git rev-list --count $ANCHOR
git log --name-only --pretty=format: $ANCHOR | sort -u | grep -v '^$' | wc -l
git log --numstat --pretty=format: $ANCHOR | awk 'NF==3{a+=$1;d+=$2} END{print a,d}'
git log --format="%ad" --date=short $ANCHOR | sort -u
git log --oneline --reverse $ANCHOR | head
```

If `HEAD` has moved past the anchor, treat the table above as the frozen case
window, not as "whatever the tip is today."

## What the window shows

Over two public weeks the skill moved from a first loop+supervisor sketch to a
curated graph-engineering library. The work was not a single demo PR. It crossed
host packaging, authoring vs runtime separation, timer design, gate-wait behavior,
ledger bounds, and documentation that teaches the shape.

### Method features distilled in this window

Each item lands as product behavior in the public tree (templates, methodology,
or host references) — not only as chat advice:

| Distilled rule | Public evidence (title + short SHA) |
| --- | --- |
| Separate **authoring** from **runtime** nodes | `324373c` feat: separate authoring and runtime skills (#30) |
| Model **per-host context carry** (not assume every fire is cold) | `220bbe5` feat(loop-graph): model per-host context carry… (#33) |
| **Audit-safe gate-wait backlog** while a milestone is under review | `63cac58` feat(loop-graph): add audit-safe gate-wait backlog |
| **Blocked is not parked** — keep a disjoint write-set lane moving | `8a8b055` feat(loop-graph): blocked is not parked… (#48) |
| **One self-driving timer per node; no wake edge** between executor and supervisor | `8750d1b` feat(loop-graph)!: give each node its own timer; drop the wake edge (#53) |
| **Bound every durable section** so live edges cannot grow forever | `e3617d2` chore(loop-graph): convergence round — bound every durable section (#52) |
| **Size the fire to the milestone**, not a round counter | `95a400d` feat(loop-graph): size the fire to the milestone… (#55) |
| **Goal reached is a written state**, not an inferred vibe | `3e46252` fix(loop-graph): make reaching the goal a state the run writes down (#54) |
| Surface **multi-task loops** and **mid-run host switches** | `29a3bb4` docs: surface multi-task loops and mid-run host switches (#37) |
| Harden from real runs into the graph vocabulary | `ac05d60` docs+quest+scout: … quest hardening from real runs… (#19) (#20) |

These commits are inspectable on GitHub and in any clone. They are the
"efficiency evidence" for this case: the control shape kept changing under real
pressure while remaining a **Markdown skill**, not a new runtime kernel.

## Story (control-plane, not customer domain)

1. **Trigger.** Long coding goals outlive one context window. A single loop with a
   self-check grades itself from the same history that produced the drift.
2. **Shape.** Author once → freeze executor + supervisor prompts and a ledger under
   `.longgraph/<date-slug>/` → each node runs on its own timer and writes only its edge.
3. **Failure modes that forced product changes.** Wake edges that stalled peers;
   "parked" when blocked; milestone audits that idled the executor; live files that
   grew until something important was truncated on read; host fires that looked cold
   but were not.
4. **Writeback.** Each failure mode became a durable rule in templates and
   methodology, then a public commit in this window.
5. **Outcome for the reader.** You can recover *why* the graph looks the way it does
   from Git, without needing private session logs.

## What this case is *not*

- Not a claim of continuous multi-day LLM runtime without human steering.
- Not a production autopilot or orchestration server.
- Not a redacted private-client scorecard (those stay project-local; see the
  [public/private boundary](../../../../docs/public-private-boundary.md)).
- Not a substitute for the pedagogical worked examples
  ([`add-tests-to-cli`](../add-tests-to-cli/),
  [`migrate-blob-storage`](../migrate-blob-storage/)), which show *ledger shape*
  on fictional apps.

## Evidence boundary

**Allowed in this case**

- Public commit SHAs, titles, and dates from this repository
- File counts, insertion/deletion totals from `git log --numstat`
- High-level product rules already documented in `AGENTS.md` / methodology
- Links to other **public** examples in this repo

**Deliberately excluded**

- Private client names, domains, or corpus metrics
- Absolute machine paths, internal hostnames, credentials
- Raw agent transcripts, session JSONL, or private `.longgraph/` ledgers
- Claims that calendar hours equal model-GPU hours or unattended autonomy

## Related reading

- [Public / private boundary](../../../../docs/public-private-boundary.md) — what may enter the public tree
- [Methodology](../../../../lib/methodology.md) — *why* each load-bearing rule exists
- [migrate-blob-storage](../migrate-blob-storage/) — longer *fictional* run that shows gates and a supervisor overturning self-reported evidence
- Root [Evidence](../../../../README.md#evidence) section
