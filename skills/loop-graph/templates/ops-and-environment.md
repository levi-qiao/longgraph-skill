<!--
loop-graph template: ops.md — durable context index, gates, and environment facts.
Always generate this file: cold nodes depend on its exact pointers and verification
commands. When there are no non-trivial environment/data facts, keep only the index,
gates, standards pointer, and host lifecycle fields. Keep it factual.
It is ambient context, not a timeline: runtime nodes read it; the author/owner updates
superseded facts in place rather than appending history. Git is the history. The single
runtime-node write is the Timers block at the bottom, where each node records the ID of
its own timer so it can stop it at terminal state. The owner never types those IDs.
Keep this file under {{FILE_LINE_CAP|200}} lines.
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
or more IDs here; nodes follow those pointers instead of searching the workspace.
Index only what is specific to this run. A repo that already routes its own rules
(`AGENTS.md`, `CLAUDE.md`, a docs map) is one row pointing at that file — re-listing
what it routes doubles the per-fire tax and drifts the moment the repo moves. -->

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

## Timers

<!-- Each node owns one recurring timer and writes only its own ID here, on its first
invocation, so it can stop that timer at terminal state. Seed both cells `pending`.
Never ask the owner to type an ID. No node reads the other's row — nothing wakes
anything, and a stale ID belonging to a session you are not in is simply replaced by
the one you resolve. Keep this section only when the selected host reference says each
node must persist its own timer ID. Delete it when that reference says IDs are not
run state. -->

| Node | Interval | Timer ID |
| --- | --- | --- |
| executor | {{EXEC_INTERVAL}} | pending |
| supervisor | {{SUP_INTERVAL}} | pending |
