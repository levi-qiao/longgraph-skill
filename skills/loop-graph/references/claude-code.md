# Claude Code

Read only for nodes hosted in Claude Code.

## Detect

Treat Claude Code as detected when its system context and CLI are present. Do not ask
the user which host they are on. Direct creation requires all of:

- Claude Code 2.1.143 or later;
- background sessions/agent view enabled (`claude agents --json` works);
- `/loop` and cron tools enabled;
- a trusted workspace.

Check these directly. If one fails, explain the single blocker and deliver filled
prompts; do not ask the owner to diagnose the client.

## Runtime shape

Two background sessions, two `/loop` timers, no wake edge between them.

- Executor: one background session running `/loop {{EXEC_INTERVAL}}` against
  `executor.md`. Its conversation carries between fires, so one fire carries the
  current milestone as far as it goes on warm context.
- Supervisor harness: a second background session running `/loop {{SUP_INTERVAL}}`. On
  every fire it spawns **one brand-new subagent** to execute one `supervisor.md` tick and
  then ends the fire. The harness never audits or edits files itself; the fresh subagent
  is the supervisor node, which is what makes this host's supervisor genuinely fresh
  per tick.
- Both background sessions use a session-only `{"worktree":{"bgIsolation":"none"}}`
  override so they share the current checkout. Never change project/user settings and
  never let either session move to a separate worktree.
- No cross-session wake: the executor's next loop fire folds new directives, and each
  loop stops itself at terminal state. `claude stop <session-id>` is the fallback.

Delete the `ops.md` Timers section. Report session IDs in the delivery message; never
ask the owner to write them.

- Executor `TIMER_STEP` (the looping session owns the timer):

  > At a terminal ledger status, stop this `/loop`. Do not create a second loop,
  > and do not write `ops.md`.

- Supervisor: delete `TIMER_STEP`. The audit tick is a one-shot subagent; the
  harness `/loop` below is what stops.

## Create both nodes here

Use this path only after the owner selects direct creation. Do not ask again.

1. Run the capability checks above and resolve the current project root.
2. Start the executor with a real background session, not a subagent:

   ```sh
   claude --bg --name "longgraph executor — {{RUN_SLUG}}" \
     --settings '{"worktree":{"bgIsolation":"none"}}' \
     "{{EXECUTOR_PROMPT}}"
   ```

3. Inspect `claude logs <id>` until its `/loop` is registered or it reports a blocker.
4. Start the supervisor harness the same way with `{{SUPERVISOR_PROMPT}}`, a distinct
   name, and the same session-only no-worktree override.
5. Inspect both with `claude agents --json` and `claude logs <id>`. Report both IDs,
   cadences, `claude agents` as the monitoring view, and
   `claude stop <id>` as the manual stop. Do not ask the owner to write those IDs
   into `ops.md`. If either launch fails, stop the other and return the filled
   prompts; never leave a half-launched graph.

## Fill the generic handoff

- `EXECUTOR_PROMPT`: `/loop {{EXEC_INTERVAL}} Execute the existing runtime node at
  {{RUN_DIR}}/executor.md. Do not load any skill.`
- `SUPERVISOR_PROMPT`: `/loop {{SUP_INTERVAL}} On every fire, spawn one brand-new
  subagent with no inherited conversation to execute exactly one tick of
  {{RUN_DIR}}/supervisor.md. The harness must not audit or edit files itself. Stop
  this loop when the ledger is terminal. Do not load any skill.`
- `SESSION_INSTRUCTION`: Paste each `/loop` below into its own Claude Code session
  in this checkout. Do not type session IDs into `ops.md`.
- `EXECUTOR_DESTINATION`: Claude Code executor session.
- `EXECUTOR_LAUNCH`: the filled `EXECUTOR_PROMPT`.
- `EXECUTOR_READY`: the loop is registered and the first fire starts. Paste the
  supervisor prompt next.
- `SUPERVISOR_DESTINATION`: a second Claude Code session.
- `SUPERVISOR_LAUNCH`: the filled `SUPERVISOR_PROMPT`.
- `RUNNING_STATE`: keep both background sessions available; use `claude agents` to
  inspect them. Ledger/directives carry shared state.
- `RESET_INSTRUCTION`: no owner action; the executor auto-compacts when needed and
  every real supervisor tick starts in a new subagent context.
- `STOP_INSTRUCTION`: each loop stops itself; fallback is
  `claude stop <executor-id>` and `claude stop <supervisor-id>`.
