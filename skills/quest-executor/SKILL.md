---
name: quest-executor
description: Execute, resume, or verify an already compiled octopus quest whose objective contains the exact marker `octopus.quest-executor/v1`. Drive that single goal to reproducibly verified completion using its acceptance criteria, run controls, red lines, and owner boundary. Do not use to choose an arm, interview the user, generate or revise a prompt, or run an existing `.octopus/...` loop-graph node.
---

# quest-executor

Execute the compiled objective. Treat it and the repository's instructions as the
runtime authority. Do not load the `octopus`, `quest`, or `loop-graph` authoring
skills, and do not rewrite the objective into another prompt.

## Work to closure

1. Turn each acceptance row into an open work item and preserve its stated check.
2. Take the smallest unclosed item, implement it, and run its narrowest meaningful
   check before moving on. Written is not done; verified is done.
3. Register a newly discovered gap with a priority and defer it. Do not silently
   expand the current item or lose the gap.
4. Apply the objective's convergence threshold. A convergence pass adds no feature:
   delete dead code, merge duplication, and tighten interfaces with net lines ≤ 0.
5. Before completion, rerun every acceptance check against the final tree and use
   persistent evidence where the objective requires an artifact.

## Protect the evidence

- Exercise the shipped end-to-end path. Do not hard-code the reported case,
  reimplement production behavior in a test, or start past the behavior under test.
- Confirm outputs are correct, not merely present, and add a case outside the fix
  where overfitting is plausible.
- Never inherit a prior run's green result. Regenerate evidence in this run.
- Run measurements on the fixed named set in the objective. Do not swap the
  denominator, use synthetic substitutes, or record a cherry-picked result.
- Treat saved output as supporting evidence, never as a substitute for rerunning
  the acceptance command on the final tree.

## Keep the implementation lean

- Preserve changes you did not create. Do not reset, stash, clean, overwrite, or
  reformat them.
- Keep secrets, real data, and restricted content out of code, fixtures, logs, and
  commits.
- Require a named real consumer before adding an endpoint, module, abstraction,
  configuration surface, pool, or cache.
- Do not create compatibility double paths, parallel versions, or duplicate error
  systems unless the objective explicitly requires them.
- Pilot any operation marked expensive on the stated smallest slice. Run it at full
  scale only after the pilot meets its pass bar.
- Never weaken an acceptance criterion or cross a red line to obtain a pass.

## Hand back only on a real boundary

Finish the whole objective without stopping for progress announcements or obvious
next steps. Stop only when:

- all acceptance rows reproduce successfully; or
- a current external blocker is rechecked and still real; or
- the next action is inside the objective's owner boundary and no stated evidence
  bar pre-authorizes it; or
- a red line would be crossed.

When blocked, report the failed check, current evidence, and exact owner or external
action needed. Do not label uncertainty, difficulty, or an untried alternative as a
blocker.
