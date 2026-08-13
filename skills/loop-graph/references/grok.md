# Grok Build

Read only for nodes hosted in **Grok Build** (xAI’s agent TUI / CLI host).

## Runtime shape

Two `/loop` tasks, two timers, no wake edge between them.

- Executor and supervisor each get their own
  `/loop [interval] <thin pointer>` task against the same workspace.
- Interval units are `Ns`, `Nm`, `Nh`, or `Nd`; minimum recurring interval is 60s.
  Overlapping fires are skipped. Recurring tasks expire after seven days.
- Background loops resume their prior transcript, so one executor fire carries the current
  milestone as far as it goes on warm context. Every tenth fire resets with only a short
  carried status — the ledger is what survives that, which is why nothing load-bearing
  may live in the transcript.
- The supervisor is context-separate from the executor, which is the load-bearing
  property; its own transcript carries between ticks, so it treats earlier ticks as
  hearsay. To force a genuinely fresh tick, recreate its scheduler task with the same
  task ID and changed prompt text before the next fire.
- Record each returned task ID; `scheduler_delete <task-id>` is the reliable stop.
- Optional hooks: `Notification` can alert on a terminal state; `PreToolUse` can enforce
  a dangerous-action red line.
- Delete `TIMER_STEP` from both node files — `/loop` already carries the interval. Record
  the two task IDs in the `ops.md` Timers table.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Create separate background loop tasks for executor and
  supervisor against the same workspace.
- `EXECUTOR_DESTINATION`: executor loop task.
- `EXECUTOR_LAUNCH`: `/loop {{EXEC_INTERVAL}} Execute the existing runtime node at
  {{RUN_DIR}}/executor.md; carry the current milestone as far as it goes this fire, ending at a seam, and stop this
  loop when the ledger is terminal. Do not load any skill.`
- `EXECUTOR_READY`: Grok Build returns the executor task ID.
- `SUPERVISOR_LAUNCH`: `/loop {{SUP_INTERVAL}} Execute exactly one tick of
  {{RUN_DIR}}/supervisor.md; force a fresh transcript for every audit tick. Do not load any skill.`
- `SUPERVISOR_DESTINATION`: separate supervisor loop task.
- `RUNNING_STATE`: keep both task IDs; state lives in the run directory.
- `RESET_INSTRUCTION`: recreate the supervisor task with fresh prompt text before every
  audit tick; the executor needs none — recreate it only to hand it a clean context at a
  convergence or milestone boundary.
- `STOP_INSTRUCTION`: delete both scheduler task IDs at terminal state or on a
  host-level refusal the nodes cannot observe.
