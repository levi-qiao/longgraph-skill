# loop-research pack

Authoring-only. Bind this pack, then compile the run from
[`../loop-graph/templates/`](../loop-graph/templates/). Do not copy these rules into a
second executor or supervisor template.

## North Star

Choose the best feasible approach for the declared decision **under explicit criteria**,
not by popularity or a persuasive narrative. Build a comparable evidence set from
available open-source implementations, primary research where it exists, and a controlled
evaluation. Proof is a reproducible decision record: candidate versions and sources,
predeclared metrics and constraints, comparable experiment results, and a winner whose
advantages and tradeoffs are visible. If that evidence cannot distinguish the candidates,
the valid outcome is `insufficient evidence`, not a fabricated winner.

## Supervisor

Required. It independently samples source claims, checks that source versions and
licenses were recorded, reruns or inspects the decisive evaluation, and rejects
cherry-picked metrics, unmatched test conditions, or a conclusion stronger than the
evidence. It also audits under-delivery: a citation-only fire, an experiment that never
compares alternatives, or a claimed choice with an open decision criterion.

## Interview (at most these three)

After inspection, propose answers; do not ask the owner to design the research.

1. **Decision and candidate boundary.** **A (Recommended)** — compare the named product
   decision against the inspected viable alternatives and state the measurable selection
   criteria. **B** — constrain the choice to a named platform, license, or deployment
   boundary. Ask only when the stated decision cannot be made testable.
2. **Evidence, data, and budget.** **A (Recommended)** — use public/open sources,
   primary papers where available, and a reproducible offline benchmark or controlled A/B
   test on approved data; no production exposure, paid calls, or private-data export.
   **B** — evidence-plan-only: sources and an experiment-ready protocol, but no winner
   selection; the run may close only as `insufficient evidence` until an evaluation is
   authorized. **C** — allow a named paid, remote, or sensitive-data evaluation under an
   explicit spend and data policy.
3. **Launch.** **A (Recommended when supported)** — create both runtime nodes here on
   Codex or Claude Code. **B** — print copy-ready prompts for another host.

## Shape (present as A unless inspection differs)

Run one decision funnel, not an endless literature loop:

1. Pin the decision, candidate inclusion rule, baseline, metrics, constraints, approved
   data, and stopping threshold before reading results.
2. Collect a comparison-ready candidate cohort. For every viable candidate, record its
   source implementation/version, primary research or the explicit absence of it, license,
   maintenance evidence, and claimed mechanism.
3. Build or reuse one fair harness. Every candidate gets the same corpus, configuration,
   resource limit, and measured outputs. Use a controlled A/B test when randomized or
   paired comparison is possible; otherwise use a same-harness benchmark or ablation and
   record why A/B is not applicable. Either is a required empirical comparison, not a
   source-only choice.
4. Evaluate the cohort in batches, preserve failures and variance, then compare against
   the predeclared threshold. Start with a small pilot only to validate the harness; do
   not select from pilot results.
5. Close the decision only after the supervisor audits the winner against the strongest
   rejected alternative. A requirement implementation begins in `/loop-deliver`, not here.

## Method guards (`PROJECT_SPECIFIC_METHOD_GUARDS`)

- Give every claim a source type and stable pointer: project repository/release, primary
  paper, official documentation, or measured result. A blog may lead to evidence but
  cannot be the decisive source by itself.
- Never select a winner from source notes alone. A selection run completes a paired
  empirical evaluation: a controlled A/B when it has a control, treatment, and assignment
  rule; otherwise a same-harness benchmark or ablation that records why A/B is inapplicable.
- Freeze candidate versions, harness revision, corpus identity, environment, random seed
  when applicable, metric definition, and resource budget before comparing outcomes.
- The comparison table must preserve all evaluated candidates, failed runs, and exclusion
  reasons. Do not replace a weak result with a new metric or a different test set after
  seeing it.
- Use the same test conditions for every candidate. If a candidate needs a different
  condition, record the incompatibility as a tradeoff rather than comparing scores as if
  they were equivalent.
- Report uncertainty honestly: sample size, variance/confidence where the data permits,
  and material threats to validity. A smaller but statistically or operationally clear win
  may beat a larger unverified claim.
- A controlled experiment needs a control, a treatment, a declared assignment rule, and
  one outcome metric. Without those, call it a benchmark or observation, not A/B evidence.
- No production users, paid services, private data, or irreversible environment changes
  without a STANDING authorization that states scope, spend, data handling, and stop rule.
- The final recommendation names the winner, runner-up, rejected alternatives, decisive
  measurements, constraint tradeoffs, and the exact implementation handoff. A claim of
  "best" means best under those recorded criteria only.

## Knob overrides

`FIRE_ROUND_CAP=6`; `FIRE_OUTPUT_FLOOR` = one comparison-ready candidate cohort or one
completed comparable evaluation batch; `CONVERGE_EVERY=4`; `NET_LINE_CAP=400`. The fire
cap ends only the current fire and never the run. Other knobs stay at the loop-graph
defaults.

## Artifact emphasis

- In `ledger.md`, use Gate scoreboard for the decision criteria and Metric snapshot for
  measured outcomes. The Current slice names the candidate cohort, pinned harness, and
  next comparison.
- In `ops.md`, pin source locations, candidate versions, corpus/harness, resource budget,
  data policy, and exact evaluation commands. Raw output stays at an indexed evidence path;
  the ledger remains the only authoritative conclusion.
- In `directives.md`, record authority for data, spend, and experiments only; source notes
  and method belong in the executor/ops evidence path.
- In `supervisor.md`, independently compare the proposed winner with the strongest
  rejected candidate and rerun or inspect the decisive evidence before accepting it.

## Slug

Use `research` unless the decision topic is clearer
(`.longgraph/<YYYY-MM-DD>-research-<topic>`).
