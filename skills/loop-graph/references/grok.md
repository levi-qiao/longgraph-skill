# Grok

Read only for nodes hosted in Grok.

## Runtime shape

- Executor and supervisor use separate `/loop [interval] <thin pointer>` tasks.
- Interval units are `Ns`, `Nm`, `Nh`, or `Nd`; minimum recurring interval is 60s.
- Overlapping fires are skipped. Recurring tasks expire after seven days.
- Record each returned task ID; `scheduler_delete <task-id>` is the reliable stop.
- Default background loops resume their prior transcript. Every tenth fire resets
  with only a short carried status. To force a clean supervisor tick, recreate its
  scheduler task with the same task ID and changed prompt text before the next fire.
- Optional hooks: `Notification` can alert on a park; `Stop` can hold a turn until a
  condition passes; `PreToolUse` can enforce a dangerous-action red line.
- Delete `HOST_DRIVE_STEP`. Fill `CONTEXT_RESET_STEP` with scheduler recreation at
  each planned executor reset and every supervisor tick. Fill `HOST_CONTROL_STEP`
  with the recorded task IDs and `scheduler_delete` terminal stop.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Create separate background loop tasks for executor and
  supervisor against the same workspace.
- `EXECUTOR_DESTINATION`: executor loop task.
- `EXECUTOR_LAUNCH`: `/loop {{EXEC_INTERVAL}} Execute the existing runtime node at
  {{RUN_DIR}}/executor.md; do one ledger round and stop when the ledger is terminal.`
- `EXECUTOR_READY`: Grok returns the executor task ID.
- `SUPERVISOR_DESTINATION`: separate supervisor loop task.
- `SUPERVISOR_LAUNCH`: `/loop {{SUP_INTERVAL}} Execute exactly one tick of
  {{RUN_DIR}}/supervisor.md; force a fresh transcript for every audit tick.`
- `RUNNING_STATE`: keep both task IDs; state lives in the run directory.
- `RESET_INSTRUCTION`: recreate the executor task at a planned green reset boundary;
  recreate the supervisor task with fresh prompt text before every audit tick.
- `STOP_INSTRUCTION`: delete both scheduler task IDs at terminal state or on a
  host-level refusal the nodes cannot observe.
