# Codex

Read only for nodes hosted in Codex.

## Detect

Treat Codex as detected when the system context identifies the Codex app and exposes
thread and automation actions. Do not ask the user which host they are on. If those
actions are unavailable, keep the detected dialect but use prompts-only delivery.

## Runtime shape

Two tasks, two timers, no wake edge between them.

- Each node lives in its own Codex task and arms **one recurring wakeup of its own
  thread** on its first invocation. Codex has no loop slash command: the wakeup is
  created by the node itself, from the explicit instruction compiled into its `.md`
  file, using the app's automation action.
- Thread wakeups resume the same thread, so an executor fire reuses the warm context of
  the previous fire — the reason a fire closes several rounds instead of one.
- The supervisor is context-separate from the executor, which is the load-bearing
  property, but its own thread also carries: it treats its earlier ticks as hearsay and
  re-verifies from durable state. When a strictly fresh-per-tick supervisor is required,
  host it on shell/cron or Claude Code instead.
- Never `/goal`. A persisted goal re-injects its objective and budget on every turn, and
  its "keep the full objective intact" continuation fights the one-item round.
- No node dispatches, resumes, or queries the other. A correction is folded on the
  executor's next fire.
- Give each automation a deterministic name containing the run slug and node role.
  Before creating, resolve that exact name plus target thread and reuse it if present.
- Stop: at terminal ledger state, each node resolves its own exact automation by name
  and target thread, then deletes it. Automation IDs are host state, not run state.

## Generate

- Replace `TIMER_STEP` in **both** node files with the arming instruction below,
  substituting that node's file, interval, and wake instruction:

  > **First invocation only.** Resolve the exact automation name
  > `longgraph {{NODE}} — {{RUN_SLUG}}` for this thread. If none exists, create exactly
  > one recurring wakeup of **this thread** at `{{INTERVAL}}` with that name and the
  > instruction `{{WAKE_TEXT}}`; otherwise reuse the exact match. Never create a second
  > automation for this node, attach one to another thread, or create a thread, task, or
  > goal. Every later invocation skips this step and goes straight to Hot start.

  Wake text is `Run one executor activation from {{RUN_DIR}}/executor.md.` at
  `{{EXEC_INTERVAL}}`, and `Run one audit tick from {{RUN_DIR}}/supervisor.md.` at
  `{{SUP_INTERVAL}}`.
- On this host, "stop your own timer" means resolving the exact deterministic name for
  this thread and deleting that automation. Say so in both node files. Do not persist
  automation IDs or generate an `ops.md` Timers table.

## Create both nodes here

Use this path only after the owner selects direct creation. The choice authorizes these
two thread creations; do not ask again.

1. Resolve the current saved project from the workspace path and use its **local**
   checkout — both nodes must see the same run files. Never create a worktree.
2. Create one task named `longgraph executor — {{RUN_SLUG}}` with the filled
   `EXECUTOR_LAUNCH`, and one named `longgraph supervisor — {{RUN_SLUG}}` with the filled
   `SUPERVISOR_LAUNCH`. Create no automations yourself: each node arms its own on its
   first invocation.
3. Wait until each has emitted its first status. Report both task links/IDs, both
   cadences, the two deterministic automation names, and how to stop them.
   If either creation fails, say so plainly and fall back to prompts-only for both;
   never leave a half-launched graph.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Open two Codex tasks in the same local project — one executor,
  one supervisor. Each arms its own recurring wakeup on its first reply; you create no
  automations by hand.
- `EXECUTOR_DESTINATION`: Task 1.
- `EXECUTOR_LAUNCH`:

  ```text
  Read {{RUN_DIR}}/executor.md and follow it exactly. Do not load any skill.
  ```

- `EXECUTOR_READY`: the task replies and confirms the named wakeup is armed.
- `SUPERVISOR_DESTINATION`: Task 2.
- `SUPERVISOR_LAUNCH`:

  ```text
  Read {{RUN_DIR}}/supervisor.md and follow it exactly. Do not load any skill.
  ```

- Both launch prompts are **read-and-follow, never an authoring verb**: "set up",
  "create", "author" or "plan" in a fresh thread reads as permission to build something,
  and the node answers by creating a second run instead of acting as a node. The
  no-skill guard belongs in the prompt itself, because a host that matches skills by name
  or path may inject the authoring skill before the node opens its own file.
- `RUNNING_STATE`: leave both tasks open. Each wakes itself on its own cadence and reads
  the run directory; the supervisor's directives are folded on the executor's next fire.
- `RESET_INSTRUCTION`: none is needed per fire. To hand the executor a genuinely fresh
  context, delete its automation, open a new task with the same launch prompt, and let it
  re-arm; the run directory carries everything it needs.
- `STOP_INSTRUCTION`: each node resolves and deletes its own named automation at
  terminal state; manually, delete the two named automations or the two tasks.
