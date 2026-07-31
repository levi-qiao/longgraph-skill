# Shell / cron

Read only for nodes hosted by an agent CLI under shell or cron.

## Runtime shape

- Each CLI process starts fresh, so this is the reference fresh-per-tick supervisor.
- Prefer a sequential loop: run one round to closure, inspect ledger terminal state,
  then sleep. Use cron only when its lock and job-removal commands are already known.
- Stop with `break` or remove the cron job at terminal state.
- Delete `HOST_DRIVE_STEP`, `CONTEXT_RESET_STEP`, and `HOST_CONTROL_STEP`; each
  process is already fresh and the wrapper owns scheduling and stop.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Run executor and supervisor as separate processes against
  the same workspace.
- `EXECUTOR_DESTINATION`: executor process.
- `EXECUTOR_LAUNCH`:

  ```sh
  while :; do
    {{EXECUTOR_CLI_COMMAND}} "Read {{RUN_DIR}}/executor.md and do one ledger round"
    grep -qE '^Run status: `(exit-ready|stalled|closed)`' {{RUN_DIR}}/ledger.md && break
    sleep {{EXEC_INTERVAL}}
  done
  ```

  Resolve `EXECUTOR_CLI_COMMAND` from the workspace before delivery. If no concrete
  command is available, choose another host; never print `<cli>` or ask the owner to
  invent the invocation.

- `EXECUTOR_READY`: the first process starts and acquires any configured lock.
- `SUPERVISOR_DESTINATION`: separate cron entry or sequential process.
- `SUPERVISOR_LAUNCH`: provide the same concrete sequential wrapper for
  `{{SUPERVISOR_CLI_COMMAND}}`, with the anchored Run-status check above. Never print
  an unresolved command. Use cron only when the exact lock and removal commands can
  also be filled.
- `RUNNING_STATE`: both processes use only the run directory for shared state.
- `RESET_INSTRUCTION`: none; each CLI process already starts fresh.
- `STOP_INSTRUCTION`: break both loops or delete their cron entries.
