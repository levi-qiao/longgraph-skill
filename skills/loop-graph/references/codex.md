# Codex

Read only for nodes hosted in Codex.

## Detect

Treat Codex as detected when the system context identifies the Codex app and exposes
project-task and Scheduled-task actions. Do not ask the user which host they are on.
If those actions are unavailable, keep the detected dialect but use prompts-only
delivery.

## Runtime shape

- Executor: one persisted `/goal` in its own task. Its objective points to
  `executor.md`; it self-drives until a real park.
- Supervisor: an independent Scheduled task in the same local project, not a
  worktree or current-chat heartbeat. Each scheduled run starts fresh.
- Resume: after adjudicating a park, continue the idle executor task with exactly
  `继续。`. The persisted goal still owns the instructions; never put directives or a
  restated objective in the wake message.
- Stop: delete or pause the Scheduled task at terminal run state.

## Generate

- Replace `HOST_DRIVE_STEP` with: keep closing ledger rounds in the same goal
  activation until a real park; at `pending-audit`, an unresolved owner block,
  `stalled`, or terminal state, return idle. A later `继续。` is only a control signal:
  re-read the durable files and continue the same persisted goal. Do not take
  Gate-wait work while parked.
- Replace `HOST_CONTROL_STEP` with: read the executor task ID and schedule ID from
  `ops.md`; after an audit, send exactly `继续。` to the same idle executor only when
  the tick made progress possible. Never restate the goal or put corrections in the
  wake message. Do not wake an active or owner-paused task. At terminal state, delete
  or pause the recorded schedule. A pending schedule ID is allowed only during the
  manual setup tick; unattended runs stop rather than guess an ID.
- Create `ops.md`; replace `HOST_CONTROL_FACTS` with executor task ID, supervisor
  schedule ID, and the fixed wake message `继续。`. Seed both IDs as pending and
  resolve them before unattended supervision.
- Omit Gate-wait work; the executor returns idle at `pending-audit`.
- The executor context carries across goal continuations. The standalone supervisor
  is fresh each run; delete its `CONTEXT_RESET_STEP`.

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
4. Create one **standalone Scheduled task** named
   `Octopus supervisor — {{RUN_SLUG}}`, against the same local project, with the
   filled supervisor prompt and `{{SUP_INTERVAL}}`. Each scheduled run must start a
   new task from that saved prompt; never attach it to this authoring chat or the
   executor chat.
5. Write the returned schedule/automation ID into `ops.md`, then inspect both
   resources once. Report the executor task link/ID, schedule ID/cadence, and the
   stop instruction. Do not create a separate supervisor-setup task.

The Scheduled prompt executes one `supervisor.md` tick. When that tick makes progress
possible, it sends exactly `继续。` to the recorded idle executor task. At terminal
state it deletes or pauses its own recorded schedule.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Open two new Codex tasks in the same local project. Paste
  the executor first; after the goal appears and emits a first status, paste the
  supervisor setup into Task 2.
- `EXECUTOR_DESTINATION`: Task 1.
- `EXECUTOR_LAUNCH`:

  ```text
  /goal Execute the existing runtime node at {{RUN_DIR}}/executor.md. Treat that
  file and its ledger as the complete contract. Keep closing rounds until a real
  park or terminal state. When this task later receives only "继续。", continue the
  same goal by re-reading the durable run files. Do not invoke authoring skills.
  ```

- `EXECUTOR_READY`: the goal is attached and the task has emitted its first status.
- `SUPERVISOR_DESTINATION`: Task 2.
- `SUPERVISOR_LAUNCH`: instruct Codex to:
  1. find the one non-archived task in this project whose persisted goal references
     `{{RUN_DIR}}/executor.md`, then record its ID in `ops.md`; stop with a recommended
     choice if the match is not unique;
  2. run one manual setup tick of `supervisor.md`; the schedule ID may be pending
     only for this tick; require no protocol error, no ledger edit, and a short brief;
  3. if nonterminal, create an independent local-project Scheduled task named
     `Octopus supervisor — {{RUN_SLUG}}` every `{{SUP_INTERVAL}}` whose prompt executes
     one `supervisor.md` tick;
  4. record the schedule ID in `ops.md` and report that supervision is active.
- `RUNNING_STATE`: leave the executor goal and Scheduled task running. Scheduled
  ticks audit from fresh context and use only `继续。` to continue the executor.
- `RESET_INSTRUCTION`: no owner action during normal running; the persisted executor
  carries context and the Scheduled supervisor starts fresh each run.
- `STOP_INSTRUCTION`: the supervisor deletes or pauses its recorded schedule.

Codex Scheduled management is a product action, not a slash command. Direct creation
uses the host's project-task and automation actions. Prompts-only delivery prints the
natural-language setup prompt; never invent `/loop` syntax.
