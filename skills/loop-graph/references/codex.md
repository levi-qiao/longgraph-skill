# Codex

Read only for nodes hosted in Codex.

## Detect

Treat Codex as detected when the system context identifies the Codex app and exposes
project-task and Scheduled-task actions. Do not ask the user which host they are on.
If those actions are unavailable, keep the detected dialect but use prompts-only
delivery.

## Runtime shape

- Executor: one persisted `/goal` in its own task, plus a chat-attached heartbeat
  in that same task. The heartbeat re-reads the complete durable executor contract
  and continues lawful work; it never redefines `/goal` or depends on another task
  sending a wake message.
- Supervisor: an independent Scheduled task in the same local project, not a
  worktree or current-chat heartbeat. Each scheduled run starts fresh. Codex shows
  those fresh runs as separate tasks in the task list; that is expected, not a
  handoff away from the current authoring conversation.
- Stop: delete or pause the Scheduled task at terminal run state.

## Generate

- Replace `HOST_DRIVE_STEP` with: keep closing ledger rounds in the same goal
  activation until a real park; at `pending-audit`, an unresolved owner block,
  `stalled`, or terminal state, return idle. The executor's chat-attached heartbeat
  re-enters this same task with the complete durable pointer; it never sends `/goal`
  again or relies on another task to wake it. Do not take Gate-wait work while parked.
- Replace `HOST_CONTROL_STEP` with: read only the recorded supervisor schedule ID
  from `ops.md`. Host control never decides the audit: independently append one
  acceptance/redo verdict to `directives.md` when warranted, even if any unrelated
  host action is unavailable. Never query executor task status, send it a message,
  create/alter its heartbeat, or defer a `pending-audit` verdict. At terminal state,
  delete or pause the recorded supervisor schedule. A pending schedule ID is allowed
  only during the manual setup tick; unattended runs stop rather than guess an ID.
- Create `ops.md`; replace `HOST_CONTROL_FACTS` with executor task ID, executor
  heartbeat ID, and supervisor schedule ID. Seed IDs as pending and resolve them
  before unattended supervision.
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
4. Create one chat-attached executor heartbeat in that executor task. Its saved prompt
   repeats the complete durable executor pointer, never `/goal`; it runs often enough
   to continue a parked run and stops at a terminal or genuine owner block. Write its
   ID into `ops.md`.
5. Before creating anything, read `ops.md` and look up the recorded supervisor
   schedule ID (or the exact run-scoped name). If it exists, inspect and update that
   one schedule in place; never create a second schedule for the same run. Otherwise
   create one **standalone Scheduled task** named `Octopus supervisor — {{RUN_SLUG}}`,
   against the same local project, with the filled supervisor prompt and
   `{{SUP_INTERVAL}}`. Each scheduled run must start a new task from that saved
   prompt; never attach it to this authoring chat or the executor chat.
6. Write the returned schedule/automation ID into `ops.md`, then inspect all three
   resources once. Report the executor task link/ID, heartbeat ID, schedule ID/cadence,
   and the stop instruction. Do not create a separate supervisor-setup task.

The Scheduled prompt executes one `supervisor.md` tick and writes only directives.
The executor heartbeat reads those directives in its own chat. At terminal state the
supervisor deletes or pauses its own recorded schedule.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Open one new Codex executor task in the same local project.
  Paste the executor prompt there. After it emits a first status, paste the
  supervisor setup prompt **in this current authoring task**. That setup creates or
  updates the one independent Scheduled task; its later fresh ticks will appear as
  separate Codex tasks by design.
- `EXECUTOR_DESTINATION`: Task 1.
- `EXECUTOR_LAUNCH`:

  ```text
  /goal Execute the existing runtime node at {{RUN_DIR}}/executor.md. Treat that
  file and its ledger as the complete contract. Keep closing rounds until a real
  park or terminal state. When this task later receives only "继续。", continue the
  same goal by re-reading the durable run files. Do not invoke authoring skills.
  ```

- `EXECUTOR_READY`: the goal is attached and the task has emitted its first status.
- `SUPERVISOR_DESTINATION`: this current authoring task (not another setup task).
- `SUPERVISOR_LAUNCH`: instruct Codex to:
  1. find the one non-archived task in this project whose persisted goal references
     `{{RUN_DIR}}/executor.md`, then record its ID in `ops.md`; stop with a recommended
     choice if the match is not unique;
  2. create or update a chat-attached executor heartbeat in that task. Its saved prompt
     must repeat the full durable executor pointer, never `/goal` and never `继续。`;
  3. run one manual setup tick of `supervisor.md`; the schedule ID may be pending
     only for this tick; require no protocol error, no ledger edit, and a short brief;
  4. if nonterminal, first inspect the schedule ID recorded in `ops.md` (or the exact
     run-scoped name): update it if it exists, otherwise create one independent
     local-project Scheduled task named `Octopus supervisor — {{RUN_SLUG}}` every
     `{{SUP_INTERVAL}}` whose prompt executes one `supervisor.md` tick;
  5. record both automation IDs in `ops.md` and report that supervision is active.
- `RUNNING_STATE`: leave the executor goal and Scheduled task running. Scheduled
  ticks audit from fresh context and write directives; the executor heartbeat continues
  its own same-chat goal from the durable contract.
- `RESET_INSTRUCTION`: no owner action during normal running; the persisted executor
  carries context and the Scheduled supervisor starts fresh each run.
- `STOP_INSTRUCTION`: the supervisor deletes or pauses its recorded schedule.

Codex Scheduled management is a product action, not a slash command. Direct creation
uses the host's project-task and automation actions. Prompts-only delivery prints the
natural-language setup prompt; never invent `/loop` syntax.
