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
  hearsay. To force a genuinely fresh tick, that node updates its own scheduler task
  in place (`scheduler_create` with the same `task_id` and changed prompt text) before
  the next fire. The owner does not do this.
- `scheduler_delete <task-id>` is the reliable stop. Each node writes only its own
  `ops.md` Timers cell on first fire and deletes that task at terminal state.
- Optional hooks: `Notification` can alert on a terminal state; `PreToolUse` can enforce
  a dangerous-action red line.

## Generate

- Keep the `ops.md` Timers table. Seed both IDs `pending`. Never ask the owner to type
  either ID.
- Replace `TIMER_STEP` in **both** node files with the matching block below. `/loop`
  already carries the interval — do not also create a second scheduler task.

  Executor:

  > **First fire only.** Call `scheduler_list` and take the unique task whose prompt
  > points at `{{RUN_DIR}}/executor.md`. Write that ID into the executor row of the
  > `ops.md` Timers table — never the supervisor row. If that row already names a
  > reachable ID, keep it. Do not create another `/loop` or scheduler task.
  >
  > **Stop.** At a terminal ledger status, `scheduler_delete` the ID in your Timers
  > row. If the cell is still `pending` or the ID is gone, resolve again from
  > `scheduler_list` by the same pointer and delete that.

  Supervisor:

  > **First fire only.** Call `scheduler_list` and take the unique task whose prompt
  > points at `{{RUN_DIR}}/supervisor.md`. Write that ID into the supervisor row of
  > the `ops.md` Timers table — never the executor row. If that row already names a
  > reachable ID, keep it. Do not create another `/loop` or scheduler task.
  >
  > **Every tick, before you end.** If the ledger is not terminal, update this same
  > task in place (`scheduler_create` with that `task_id`) so the next fire's prompt
  > text changes: keep `Execute the existing runtime node at {{RUN_DIR}}/supervisor.md.
  > Do not load any skill.` and bump a `tick=N` suffix. Do not wrap it in a second
  > `/loop`. If the ledger is terminal, `scheduler_delete` that ID instead.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Paste each prompt below as its own `/loop` against this
  workspace. Do not edit `ops.md` or type any task ID.
- `EXECUTOR_DESTINATION`: executor `/loop`.
- `EXECUTOR_LAUNCH`: `/loop {{EXEC_INTERVAL}} Execute the existing runtime node at
  {{RUN_DIR}}/executor.md. Do not load any skill.`
- `EXECUTOR_READY`: the first fire starts on its own. Paste the supervisor prompt next.
- `SUPERVISOR_LAUNCH`: `/loop {{SUP_INTERVAL}} Execute the existing runtime node at
  {{RUN_DIR}}/supervisor.md. Do not load any skill.`
- `SUPERVISOR_DESTINATION`: supervisor `/loop`.
- `RUNNING_STATE`: both loops keep firing; state lives in the run directory.
- `RESET_INSTRUCTION`: none. The supervisor refreshes its own next-fire prompt; the
  executor stays warm.
- `STOP_INSTRUCTION`: each node deletes its own scheduler task at terminal state.
  Fallback: `scheduler_delete` on the two IDs in the `ops.md` Timers table.
