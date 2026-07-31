# Cursor

Read only for nodes hosted in Cursor.

## Runtime shape

- In-session `/loop [interval] <thin pointer>` may be self-paced or fixed-interval.
- The session context carries across iterations and has no forced-reset control.
- A cloud background agent is different: `/loop` is unavailable there and each run
  is capped at roughly 20 minutes.
- Cursor cannot provide a strict fresh-context supervisor. Use Cursor for the
  executor and put the supervisor on shell/cron or another fresh-per-run host when
  independent audit is required.
- Stop the tracked in-session loop/sleeper when the ledger becomes terminal.
- Delete `HOST_DRIVE_STEP` and `HOST_CONTROL_STEP`. Keep the context-chain ledger
  field, but delete `CONTEXT_RESET_STEP`; restart in a new session manually at a
  green reset boundary.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Open the executor in the target Cursor workspace; open the
  supervisor on the selected fresh-context host.
- `EXECUTOR_DESTINATION`: Cursor executor session.
- `EXECUTOR_LAUNCH`: `/loop {{EXEC_INTERVAL}} Execute the existing runtime node at
  {{RUN_DIR}}/executor.md; do one ledger round and stop when the ledger is terminal.`
- `EXECUTOR_READY`: the loop is registered and its first round begins.
- `SUPERVISOR_DESTINATION`: copy from the selected supervisor host's reference.
- `SUPERVISOR_LAUNCH`: copy from the selected supervisor host's reference.
- `RUNNING_STATE`: keep the workspace and external supervisor available.
- `RESET_INSTRUCTION`: at a green Context-chain boundary, stop the old Cursor loop,
  open a fresh session in the same workspace, and paste the same filled
  `EXECUTOR_LAUNCH`; never reset mid-item.
- `STOP_INSTRUCTION`: stop the Cursor loop and the supervisor's scheduler.
