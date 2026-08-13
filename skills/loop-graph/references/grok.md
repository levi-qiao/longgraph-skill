# Grok Build

Read only for nodes hosted in **Grok Build** (xAI’s agent TUI / CLI host).

## Detect

Treat Grok Build as detected when the system context identifies the Grok /
xAI TUI or CLI, or exposes `scheduler_create` / `/loop` as this host's
recurring-task primitive. Do not ask the user which host they are on. Direct
creation requires `scheduler_create` and `scheduler_delete` to be callable
in this session. If they are not, keep the detected dialect but use
prompts-only delivery.

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

## Create both nodes here

Use this path only after the owner selects direct creation. The choice
authorizes these two scheduler tasks; do not ask again.

1. Resolve the current workspace root. Both nodes must see the same run
   files. Never create a worktree.
2. Confirm `scheduler_create` and `scheduler_delete` are callable. If
   either is missing, stop and deliver the filled `/loop` prompts below;
   do not ask the owner to diagnose the client.
3. Create the executor with `scheduler_create`: `interval` =
   `{{EXEC_INTERVAL}}` (minimum 60s), `durable` = true,
   `fire_immediately` = true, `prompt` = the filled `EXECUTOR_LAUNCH`
   **body** (the instruction after the interval — do not wrap it in a
   second `/loop`). Create no other task for this node.
4. Create the supervisor the same way at `{{SUP_INTERVAL}}` (3–4× the
   executor, phase-offset when the host allows), `durable` = true,
   `fire_immediately` = true, `prompt` = the filled `SUPERVISOR_LAUNCH`
   body. The two tasks must not wake each other.
5. Write both returned task IDs into the `ops.md` Timers table. Report
   both IDs, both cadences, and that stopping means
   `scheduler_delete <task-id>` on each. If either create fails, delete
   the other and fall back to prompts-only for both; never leave a
   half-launched graph.

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
