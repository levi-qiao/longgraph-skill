<!--
octopus quest arm: quest.md — the SINGLE objective prompt.
Replace every {{PLACEHOLDER}}, delete guidance comments, then hand the result to
the host's goal command (Grok `/goal <this>`; Codex: delegate a task with this brief).
There is NO separate supervisor prompt and NO second loop: the host's own harness
is the acceptance auditor. Reusable execution discipline lives in quest-executor;
this file carries only task-specific authority.
-->

Execution contract: `octopus.quest-executor/v1`

Load and follow the `quest-executor` skill. This is an already compiled runtime
objective: do not invoke the `octopus`, `quest`, or `loop-graph` authoring skills.

{{OBJECTIVE_ONE_SENTENCE}} — in {{PROJECT_OR_REPOS}}. Deliver everything below
yourself; do not stop to ask permission for the obvious next step.

## Done means verified (the acceptance criteria the verifier will re-check)

{{EXIT_TABLE — one row per goal, each with a *reproducible* check the verifier can
run without you. Example:
| # | Goal | Verified by (command / artifact) |
| G1 | … | `make test` green |
| G2 | metric ≥ baseline | scorecard at <persistent path> shows ≥ X on the frozen eval set |
The verifier must be able to reproduce every row from the final tree and persistent
evidence, with zero manual correction.}}

## Run controls

- Converge after {{CONVERGE_EVERY|5}} completed items or more than
  {{NET_LINE_CAP|400}} net production lines, whichever comes first.
- Expensive operation: {{EXPENSIVE_OP_POLICY — `pilot required: <smallest slice and
  pass bar>` or `none`}}.

## Red lines (violate → stop immediately)

{{RED_LINES — task-specific non-negotiables. Include concrete resources and
authorizations; do not repeat the generic quest-executor discipline. Typical set:
- Commit authorization: {{allowed scope or none}}.
- Push authorization: {{allowed scope or none}}.
- Protected resources: {{named DBs, branches, services, or data}}.
- Data policy: {{task-specific restriction}}.
- Frozen contracts: {{exact files/interfaces or none}}.
- Metric floor: {{named metric and minimum, or none}}.}}

## Owner boundary

{{OWNER_BOUNDARY — name the owner and the genuinely case-by-case decisions that
must return to them; `none` when all critical-path decisions are pre-authorized.}}
