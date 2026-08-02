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

Delete `TIMER_STEP` from both node files — `/loop` already carries the interval, and
each loop's own stop condition is the terminal ledger status. Delete the `ops.md` Timers
section and record the two background session IDs there instead.

## Create both nodes here

Use this path only after the owner selects direct creation. Do not ask again.

1. Run the capability checks above and resolve the current project root.
2. Start the executor with a real background session, not a subagent:

   ```sh
   claude --bg --name "Octopus executor — {{RUN_SLUG}}" \
     --settings '{"worktree":{"bgIsolation":"none"}}' \
     "{{EXECUTOR_PROMPT}}"
   ```

3. Record its returned session ID in `ops.md`; inspect `claude logs <id>` until its
   `/loop` is registered or it reports a blocker.
4. Start the supervisor harness the same way with `{{SUPERVISOR_PROMPT}}`, a distinct
   name, and the same session-only no-worktree override. Record its session ID.
5. Inspect both with `claude agents --json` and `claude logs <id>`. Report both IDs,
   cadences, `claude agents` as the monitoring view, and
   `claude stop <id>` as the manual stop. If either launch fails, stop the other and
   return the filled prompts; never leave a half-launched graph.

## Fill the generic handoff

- `EXECUTOR_PROMPT`: `/loop {{EXEC_INTERVAL}} Execute the existing runtime node at
  {{RUN_DIR}}/executor.md; re-read the durable files first, carry the
  current milestone as far as it goes this fire, ending at a seam, and stop this loop
  when the ledger is terminal.`
- `SUPERVISOR_PROMPT`: `/loop {{SUP_INTERVAL}} On every fire, spawn one brand-new
  subagent with no inherited conversation to execute exactly one tick of
  {{RUN_DIR}}/supervisor.md. The harness must not audit or edit files itself. Wait for
  the subagent's short brief, then end this fire. Stop the loop when the run is
  terminal.`
- `SESSION_INSTRUCTION`: Run the two commands below from the project root. They
  create separate background sessions in the current checkout; do not open sessions
  or configure worktrees manually.
- `EXECUTOR_DESTINATION`: project terminal.
- `EXECUTOR_LAUNCH`: the complete `claude --bg --name "Octopus executor —
  {{RUN_SLUG}}" --settings '{"worktree":{"bgIsolation":"none"}}'
  "{{EXECUTOR_PROMPT}}"` command.
- `EXECUTOR_READY`: the command returns a session ID and `claude logs <id>` shows the
  executor loop registered.
- `SUPERVISOR_DESTINATION`: the same project terminal.
- `SUPERVISOR_LAUNCH`: the complete equivalent `claude --bg` command using the
  supervisor name and `{{SUPERVISOR_PROMPT}}`.
- `RUNNING_STATE`: keep both background sessions available; use `claude agents` to
  inspect them. Ledger/directives carry shared state.
- `RESET_INSTRUCTION`: no owner action; the executor auto-compacts when needed and
  every real supervisor tick starts in a new subagent context.
- `STOP_INSTRUCTION`: each loop stops itself; fallback is
  `claude stop <executor-id>` and `claude stop <supervisor-id>`.
