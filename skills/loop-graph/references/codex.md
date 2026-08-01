# Codex

Read only for nodes hosted in Codex.

## Detect

Treat Codex as detected when the system context identifies the Codex app and exposes
project-task and Scheduled-task actions. Do not ask the user which host they are on.
If those actions are unavailable, keep the detected dialect but use prompts-only
delivery.

## Runtime shape

- Executor: one persisted `/goal` in one task. No executor schedule or heartbeat.
  One activation closes as many verified rounds as practical, then parks only at a
  real gate/block/terminal state.
- Supervisor: an independent Scheduled task in the same local project, not a
  worktree or current-chat heartbeat. Each scheduled run starts fresh. Codex shows
  each run as a separate task; that is the expected cost of clean-context audit.
- Resume: only after writing a new actionable directive, the supervisor sends the
  executor task the same short pointer used at launch, without `/goal`:
  `Execute {{RUN_DIR}}/executor.md.` No status lookup and no bare `继续。`.
- Stop: delete or pause the Scheduled task at terminal run state.

## Generate

- Replace `HOST_DRIVE_STEP` with: keep closing ledger rounds in the same goal
  activation until a real park; at `pending-audit`, an unresolved owner block,
  `stalled`, or terminal state, return idle. A later short pointer re-enters the same
  persisted goal; re-read only the hot index/state and continue. Do not take Gate-wait
  work while parked.
- Replace `HOST_CONTROL_STEP` with: when the recorded IDs are pending, treat this
  invocation as setup: resolve the unique executor task whose persisted goal points
  to `executor.md`, create or update the one run-named standalone Scheduled task with
  the exact supervisor pointer and cadence, record both IDs, then perform this tick.
  With resolved IDs, never create another schedule. Read executor task ID, supervisor
  schedule ID, resume prompt, and `last dispatched directive` from
  `ops.md`/`Supervisor state`. Never query executor status. Audit first; only when
  this tick adds a new directive that enables work, send the recorded short resume
  prompt once and record its ID as dispatched. If send fails, record `unsent` and
  retry once next tick; never duplicate the directive or dispatch. Host control never
  decides the audit. At terminal state, pause/delete the supervisor schedule.
- Create `ops.md`; replace `HOST_CONTROL_FACTS` with executor task ID, supervisor
  schedule ID, and the exact short resume prompt. Seed IDs as pending; a first manual
  tick may resolve the executor by a unique goal-path match.
- Omit Gate-wait work; the executor returns idle at `pending-audit`.
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
3. Write the returned task/thread ID into `ops.md`. Stop if creation failed or the
   task is not uniquely identifiable.
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
  /goal Execute {{RUN_DIR}}/executor.md.
  ```

- `EXECUTOR_READY`: the goal is attached and the task has emitted its first status.
- `SUPERVISOR_DESTINATION`: the current authoring task; `supervisor.md` performs the
  idempotent one-time setup of its standalone local-project Scheduled task.
- `SUPERVISOR_LAUNCH`:

  ```text
  Set up {{RUN_DIR}}/supervisor.md.
  ```
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
