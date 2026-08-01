# Codex

Read only for nodes hosted in Codex.

## Detect

Treat Codex as detected when the system context identifies the Codex app and exposes
project-task and Scheduled-task actions. Do not ask the user which host they are on.
If those actions are unavailable, keep the detected dialect but use prompts-only
delivery.

## Runtime shape

- Executor: one persisted `/goal` in one task. No executor schedule or heartbeat.
  One activation closes as many verified rounds as it can and parks only at a real
  gate/block/terminal state. Codex has no executor heartbeat, so parking costs a wait
  for the next supervisor tick — park on a real condition, never on turn length.
  Re-reading directives each round is what keeps a long activation steerable.
- Supervisor: an independent Scheduled task in the same local project, not a
  worktree or current-chat heartbeat. Each scheduled run starts fresh. Codex shows
  each run as a separate task; that is the expected cost of clean-context audit.
  Fallback only when standalone scheduling is unavailable or unreliable on the account:
  a recurring task in the current thread at the same cadence. It is no longer clean
  context, so the prompt must say so — the supervisor leans on durable state and treats
  its own earlier turns in that thread as hearsay, not as audit evidence.
- Resume: the supervisor sends the executor task the same short pointer used at launch,
  without `/goal`: `Execute {{RUN_DIR}}/executor.md.` **Only when the ledger `Run status`
  is `parked`** and work remains, at most once per tick — whether or not this tick wrote a
  directive. An `active` executor re-reads directives at the start of every round, so it
  needs no prompt and a prompt would only interrupt it. The ledger is the signal: no status
  lookup, and no bare `继续。`. Treat `active` with no new round line across two consecutive
  ticks as dead — resume once and record it.
- Stop: delete or pause the Scheduled task at terminal run state.

## Generate

- Replace `HOST_DRIVE_STEP` with: keep closing ledger rounds in this goal activation;
  a long productive turn is expected, and re-reading directives every round is what keeps
  it steerable. Record the park and return idle only at `pending-audit`, an unresolved
  owner block, `stalled`, terminal state, a stop directive, an exhausted declared budget,
  or a due context reset — re-entry is how this host grants a fresh context. A later
  short pointer re-enters the same persisted goal; re-read only the hot index/state and
  continue — and if the run is parked with nothing unfolded, return immediately rather
  than inventing work. A blocked slice is not a park: fall through to the executor's
  blocked-work rule and keep closing rounds until nothing legal remains.
  In the first round, write your own task/session ID into the `ops.md` host-control
  block, replacing `pending`; if the host exposes no stable self-ID, record that instead
  so the supervisor stops looking.
- Replace `HOST_CONTROL_STEP` with a setup section that is explicit on all four points:
  run setup **only on the first invocation**, when the schedule ID in `ops.md` is still
  pending; create **one** run-named standalone Scheduled task — a separate scheduled
  task, not attached to this authoring chat and not to the executor's task — whose saved
  prompt is exactly `Run one audit tick from {{RUN_DIR}}/supervisor.md.`, at
  `{{SUP_INTERVAL}}`; write the returned schedule ID into `ops.md`, then perform this
  tick. If `ops.md` already records an ID or a run-named schedule already exists, inspect
  and update that one in place — never create a second. Every later invocation skips
  setup entirely and goes straight to Hot start. Vague placement wording is the failure
  here: a supervisor that cannot tell "which thread" from "a new task" will improvise one
  or duplicate the other. Read executor task ID,
  supervisor schedule ID, resume prompt, and `last dispatched directive` from
  `ops.md`/`Supervisor state`. The executor writes its own task ID there in its first
  round — never infer it, never guess it from goal text, never adopt a task you cannot
  confirm; while it is `pending`, dispatch to the run-named pointer and pick the ID up
  next tick rather than blocking setup. Never query executor status — the ledger is the
  signal. Audit first, then dispatch the recorded short resume prompt at most once per
  tick and only when `Run status` is `parked` with work remaining; never while it is
  `active`, and treat `active` with no new round line across two consecutive ticks as dead
  (resume once, record it). If send fails, record `unsent` and retry next tick; never
  duplicate the directive or dispatch, and escalate after three consecutive `unsent`. Host
  control never decides the audit. At terminal state, pause/delete the supervisor schedule.
- Create `ops.md`; replace `HOST_CONTROL_FACTS` with executor task ID, supervisor
  schedule ID, and the exact short resume prompt. Seed both IDs as pending: the executor
  fills its own in round one and the supervisor fills the schedule ID at setup. Do not
  ask the owner to type either, and do not resolve the executor by goal-path guessing.
- Seed Gate-wait work whenever a genuinely disjoint one-round item exists; on this host
  a park costs a wait for the next supervisor tick, so idling at `pending-audit` is
  expensive. Omit it only when nothing qualifies — the blocked-work rule still applies
  to every other kind of block.
- The executor context carries in one goal task; the standalone supervisor is fresh
  each run. Delete both template context-reset blocks.

## Create both nodes here

Use this path only after the owner selects direct creation. The choice authorizes
these two scoped runtime creations; do not ask again.

1. Resolve the current saved project from the workspace path. Use its **local**
   checkout: executor and supervisor must see the same run files. Never create a
   worktree for either node.
2. Create one project task named `Octopus executor — {{RUN_SLUG}}` with the filled
   `EXECUTOR_LAUNCH`. Wait until its goal is attached and the first status arrives.
3. Write the returned task/thread ID into `ops.md`. Stop if creation failed. If the
   host returns no usable ID, leave it `pending` and continue — the executor writes its
   own in round one; never ask the owner to supply it.
4. Before creating anything, read `ops.md` and look up the recorded supervisor
   schedule ID (or the exact run-scoped name). If it exists, inspect and update that
   one schedule in place; never create a second schedule for the same run. Otherwise
   create one **standalone Scheduled task** named `Octopus supervisor — {{RUN_SLUG}}`,
   against the same local project, with the filled supervisor prompt and
   `{{SUP_INTERVAL}}`. Each scheduled run must start a new task from that saved
   prompt; never attach it to this authoring chat or the executor chat.
5. Write the returned schedule/automation ID into `ops.md`, then inspect both
   resources once. Report the executor task link/ID, schedule ID/cadence, and stop
   instruction. Do not create a separate supervisor-setup task.

The Scheduled prompt is only a pointer to `supervisor.md`. The supervisor reads the
indexed hot state, writes directives, and dispatches the short executor pointer only
for a newly actionable directive. At terminal state it stops its own schedule.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Open one Codex task for the executor and one standalone
  Scheduled task for the supervisor in the same local project. Separate supervisor
  run tasks are expected; they keep each audit clean.
- `EXECUTOR_DESTINATION`: Task 1.
- `EXECUTOR_LAUNCH`:

  ```text
  /goal Read {{RUN_DIR}}/executor.md and follow it exactly. Do not load any skill.
  ```

- `EXECUTOR_READY`: the goal is attached and the task has emitted its first status.
- `SUPERVISOR_DESTINATION`: the current authoring task; `supervisor.md` performs the
  idempotent one-time setup of its standalone local-project Scheduled task.
- `SUPERVISOR_LAUNCH`:

  ```text
  Read {{RUN_DIR}}/supervisor.md and follow it exactly. Do not load any skill.
  ```

  Never phrase this as "set up", "create", "author" or "plan" — an authoring verb in a
  fresh thread reads as permission to build something, and the node responds by creating
  a goal or a second run instead of acting as the supervisor. Read-and-follow only, and
  the no-skill guard belongs in the prompt itself: a host that matches skills by name or
  path may inject the authoring skill before the node ever opens its own file.
- `RUNNING_STATE`: leave the executor goal and Scheduled task running. Scheduled
  ticks audit from fresh context; a new actionable directive dispatches the short
  executor pointer back to the same goal task.
- `RESET_INSTRUCTION`: executor stays in one goal task; every standalone supervisor
  run starts fresh and therefore appears as a separate task.
- `STOP_INSTRUCTION`: the supervisor deletes or pauses its recorded schedule.

The saved Scheduled-task prompt remains
`Run one audit tick from {{RUN_DIR}}/supervisor.md.` Codex Scheduled management is a
product action, not a slash command. Direct creation uses the host's project-task and
automation actions. Prompts-only delivery prints the natural-language setup prompt;
never invent `/loop` syntax.
