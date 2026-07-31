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

- Executor: one background session with `/loop {{EXEC_INTERVAL}}` pointing at
  `executor.md`; one verified ledger round per fire.
- Supervisor harness: a second background session with `/loop {{SUP_INTERVAL}}`.
  On every fire it spawns **one brand-new subagent** to execute one `supervisor.md`
  tick. The harness never audits or edits files itself; the fresh subagent is the
  supervisor node.
- Both background sessions use a session-only
  `{"worktree":{"bgIsolation":"none"}}` override so they share the current checkout.
  Never change project/user settings and never let either session move to a separate
  worktree.
- Executor and harness conversations carry context. The actual supervisor is fresh
  every tick because it is a new subagent. Delete both `CONTEXT_RESET_STEP` blocks;
  rely on the bounded ledger and Claude Code's normal compaction for the executor.
- No cross-session wake is needed: the executor's next loop fire folds new
  directives. Each loop stops itself at terminal state; `claude stop <session-id>` is
  the host-level fallback.

Replace `HOST_DRIVE_STEP` with one-round-per-fire behavior. Replace
`HOST_CONTROL_STEP` with: do not audit in the harness; spawn a new subagent for each
tick, let only that subagent execute `supervisor.md`, and at terminal state stop the
recorded supervisor background session. Create `ops.md` and replace
`HOST_CONTROL_FACTS` with the executor and supervisor background session IDs.

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
  {{RUN_DIR}}/executor.md; do exactly one ledger round per fire, re-read the durable
  files first, and stop this loop when the ledger is terminal.`
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
