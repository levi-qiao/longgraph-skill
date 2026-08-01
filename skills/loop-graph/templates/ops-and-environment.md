<!--
loop-graph template: ops.md — durable environment facts.
The executor node consults this instead of re-deriving build/env/data facts every round.
Only create this file if there ARE non-trivial facts worth pinning. Keep it factual.
It is ambient context, not a timeline: runtime nodes read it; the author/owner updates
superseded facts in place rather than appending history. Git is the history. The single
exception is the host-control block at the bottom, where each node records its own
control ID once so the peers can find each other.
Red line: secrets / credentials / real data content NEVER go in this file — only policy
about them (where they come from, that they're env-injected, that they never get logged).
-->

# {{PROJECT}} — Environment & Ops Facts

> Read the index first, then only the row needed by the current ledger item. Do not
> re-read this whole file every round.
> Red line: license / keys / real data content never enter the repo, logs, or commits — only the policy for handling them lives here.

## Context index

<!-- Compile this at authoring time. Prefer exact files, symbols, headings, and gate
commands over prose. Every live ledger item and supervisor correction points to one
or more IDs here; nodes follow those pointers instead of searching the workspace. -->

| ID | Use when | Read | Verify |
| --- | --- | --- | --- |
| C-01 | {{task/surface}} | {{exact file#heading, symbol, or narrow glob}} | {{exact command}} |

Always-hot: `ledger.md` status/current slice + directives above the watermark.
On-reference only: the indexed rows above, repo standards, evidence artifacts, and
archives. Never bulk-open an authority document when an exact heading/symbol is known.

## Build / test

{{Per-repo exact commands and any required flags. Example:
- Python: `.venv/bin/python -m pytest <file>`; full gate `make lint && make test`.
- Java: `mvn -s <path-to-settings> -pl <module> test` (the `-s` is required — without it, dependency resolution fails).
- Frontend: `pnpm build && tsc --noEmit`.
}}

## Standards / conventions (the shared yardstick)

{{The repo's own standards both nodes obey and the supervisor audits against — point at the source of truth, don't restate it: `AGENTS.md` / `CLAUDE.md`, lint & style config, naming/format conventions, "definition of done". E.g. "conventions in `AGENTS.md`; `make lint` enforces style; a change is done only when its gate is green AND lint passes." Delete if the repo has none.}}

## Credentials / secrets policy

{{How secrets are provided (env injection), and the hard rule that they are never printed / stored / logged / committed. Sample config values left blank. No actual values here.}}

## Data policy

{{Where the real/sensitive data lives, that outputs keep only anonymized aggregate metrics, and that real names / values never get persisted. If not applicable, delete this section.}}

## Cost / resource notes (optional)

{{If the run's work changes the resource footprint, record the bounded analysis here so it's not re-litigated: what's the bottleneck, what extra memory/CPU/disk/network it needs, and why it's bounded.}}

## Fan-out tier (only when the executor may spawn read-only sub-tasks)

{{FANOUT_TIER — the host's cheap model tier by name, plus its reasoning-effort setting if
the host has one (cheap model + high effort is usually the right read-only investigator).
Name the tier here, not in the executor prompt, so it stays host-specific. Delete this
section when the host offers no cheap concurrent tier — that means no fan-out at all.}}

## Spend budget (only when the run performs expensive or metered work)

{{Exact numbers, not adjectives: the per-pilot and per-batch cap, the per-day cap, and
the unit they are counted in (items, calls, currency). State that diagnostic reruns
count too. "Spend beyond budget" is typically an owner-only decision — an undeclared
budget makes that tripwire unenforceable, so declare it or delete this section.}}

{{HOST_CONTROL_FACTS — insert only durable IDs and control facts required by the
selected host reference. Never place instructions, secrets, or transient status here;
delete this block when no host-control facts are required. This block is the one part
of this file a runtime node may write, and only its own control ID (each node writes its
own, never another's) — everything else stays author-owned.
The IDs are self-healing, not write-once: a node overwrites its own field whenever the
recorded value is not itself, and never trusts a recorded value without confirming it is
reachable from where it is running. Relaunching a node into a fresh session is normal, and
a stale pointer left in place is what silently strands a run against a dead peer.}}
