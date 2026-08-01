# Codex

Read only for nodes hosted in Codex.

## Detect

Treat Codex as detected when the system context identifies the Codex app and exposes
project-task and Scheduled-task actions. Do not ask the user which host they are on.
If those actions are unavailable, keep the detected dialect but use prompts-only
delivery.

## Runtime shape

- Executor: one persisted `/goal` in one task; no schedule or heartbeat of its own.
- Supervisor: an independent Scheduled task in the same local project — never the
  authoring chat, the executor's task, or a worktree. Each run starts fresh; Codex shows
  each as its own task, the cost of clean-context audit. Fallback where standalone
  scheduling is unreliable on the account: a recurring task in the current thread at the
  same cadence — no longer clean context, so the generated prompt must say so and lean on
  durable state.
- Resume: the supervisor is the executor's only way back, so a park costs a tick.
  Its pointer is the launch prompt without `/goal`; never a bare `继续。`.
- Stop: delete or pause the Scheduled task at terminal run state.

Exact behavior ships in the `Generate` fills below — do not restate it here.

## Generate

- Replace `HOST_DRIVE_STEP` with: keep closing ledger rounds in this goal activation;
  a long productive turn is expected, and re-reading directives every round is what keeps
  it steerable. Record the park and return idle only at `pending-audit`, an unresolved
  owner block, `stalled`, terminal state, a stop directive, an exhausted declared budget,
  or a due context reset — re-entry is how this host grants a fresh context. A later
  short pointer re-enters the same persisted goal; re-read only the hot index/state and
  continue — and if the run is parked with nothing unfolded, return immediately rather
  than inventing work. A blocked slice is not a park: fall through to the executor's
  blocked-work rule and keep closing rounds until nothing legal remains.
  In the first round, write your own task/session ID into the `ops.md` host-control
  block, replacing `pending`; if the host exposes no stable self-ID, record that instead
  so the supervisor stops looking.
- Replace `HOST_CONTROL_STEP` with a setup section that is explicit on all four points:
  run setup **only on the first invocation**, when the schedule ID in `ops.md` is still
  pending; create **one** run-named standalone Scheduled task — a separate scheduled
  task, not attached to this authoring chat and not to the executor's task — whose saved
  prompt is exactly `Run one audit tick from {{RUN_DIR}}/supervisor.md.`, at
  `{{SUP_INTERVAL}}`; write the returned schedule ID into `ops.md`, then perform this
  tick. A recorded ID is never trusted on sight: confirm the schedule it names is live and
  reachable from here before updating it in place, and when it is not — the usual case
  after a restart, since the old one belongs to a session you are not in — treat it as
  stale, create one here, and overwrite. Never create a second for the same run. Every
  later invocation skips setup entirely and goes straight to Hot start. Vague placement
  wording is the failure here: a supervisor that cannot tell "which thread" from "a new
  task" will improvise one or duplicate the other. Read executor task ID,
  supervisor schedule ID, resume prompt, and `last dispatched directive` from
  `ops.md`/`Supervisor state`. The executor writes its own task ID there in its first
  round, overwriting any stale value — never infer it, never guess it from goal text,
  never adopt a task you cannot reach; while it is `pending`, or while it names a task
  that does not respond, dispatch to the run-named pointer and pick the ID up next tick
  rather than blocking setup. Never query executor status — the ledger is the
  signal. Audit first, then dispatch the recorded short resume prompt at most once per
  tick and only when `Run status` is `parked` with work remaining; never while it is
  `active`, and treat `active` with no new round line across two consecutive ticks as dead
  (resume once, record it). If send fails, record `unsent` and retry next tick; never
  duplicate the directive or dispatch, and escalate after three consecutive `unsent`. Host
  control never decides the audit. At terminal state, pause/delete the supervisor schedule.
- Create `ops.md`; replace `HOST_CONTROL_FACTS` with executor task ID, supervisor
  schedule ID, and the exact short resume prompt. Seed both IDs as pending: the executor
  fills its own in round one and the supervisor fills the schedule ID at setup. Do not
  ask the owner to type either, and do not resolve the executor by goal-path guessing.
  State in the file that both fields are **self-healing**: each node overwrites its own
  field whenever the recorded value is not itself, so relaunching a node into a fresh
  thread repairs the pointers instead of stranding the run against a dead one.
- Seed Gate-wait work whenever a genuinely disjoint one-round item exists; on this host
  a park costs a wait for the next supervisor tick, so idling at `pending-audit` is
  expensive. Omit it only when nothing qualifies — the blocked-work rule still applies
  to every other kind of block.
- The executor context carries in one goal task; the standalone supervisor is fresh
  each run. Delete both template context-reset blocks.

## Create both nodes here

Use this path only after the owner selects direct creation. The choice authorizes
these two scoped runtime creations; do not ask again.

1. Resolve the current saved project from the workspace path. Use its **local**
   checkout: executor and supervisor must see the same run files. Never create a
   worktree for either node.
2. Create one project task named `Octopus executor — {{RUN_SLUG}}` with the filled
   `EXECUTOR_LAUNCH`. Wait until its goal is attached and the first status arrives.
3. Write the returned task/thread ID into `ops.md`. Stop if creation failed. If the
   host returns no usable ID, leave it `pending` and continue — the executor writes its
   own in round one; never ask the owner to supply it.
4. Before creating anything, read `ops.md` and look up the recorded supervisor
   schedule ID (or the exact run-scoped name). If it exists, inspect and update that
   one schedule in place; never create a second schedule for the same run. Otherwise
   create one **standalone Scheduled task** named `Octopus supervisor — {{RUN_SLUG}}`,
   against the same local project, with the filled supervisor prompt and
   `{{SUP_INTERVAL}}`. Each scheduled run must start a new task from that saved
   prompt; never attach it to this authoring chat or the executor chat.
5. Write the returned schedule/automation ID into `ops.md`, then inspect both
   resources once. Report the executor task link/ID, schedule ID/cadence, and stop
   instruction. Do not create a separate supervisor-setup task.

The Scheduled prompt is only a pointer to `supervisor.md`. The supervisor reads the
indexed hot state, writes directives, and dispatches the short executor pointer only
for a newly actionable directive. At terminal state it stops its own schedule.

## Fill the generic handoff

- `SESSION_INSTRUCTION`: Open one Codex task for the executor and one standalone
  Scheduled task for the supervisor in the same local project. Separate supervisor
  run tasks are expected; they keep each audit clean.
- `EXECUTOR_DESTINATION`: Task 1.
- `EXECUTOR_LAUNCH`:

  ```text
  /goal Read {{RUN_DIR}}/executor.md and follow it exactly. Do not load any skill.
  ```

- `EXECUTOR_READY`: the goal is attached and the task has emitted its first status.
- `SUPERVISOR_DESTINATION`: the current authoring task; `supervisor.md` performs the
  idempotent one-time setup of its standalone local-project Scheduled task.
- `SUPERVISOR_LAUNCH`:

  ```text
  Read {{RUN_DIR}}/supervisor.md and follow it exactly. Do not load any skill.
  ```

  Never phrase this as "set up", "create", "author" or "plan" — an authoring verb in a
  fresh thread reads as permission to build something, and the node responds by creating
  a goal or a second run instead of acting as the supervisor. Read-and-follow only, and
  the no-skill guard belongs in the prompt itself: a host that matches skills by name or
  path may inject the authoring skill before the node ever opens its own file.
- `RUNNING_STATE`: leave the executor goal and Scheduled task running. Scheduled
  ticks audit from fresh context; a new actionable directive dispatches the short
  executor pointer back to the same goal task.
- `RESET_INSTRUCTION`: executor stays in one goal task; every standalone supervisor
  run starts fresh and therefore appears as a separate task.
- `STOP_INSTRUCTION`: the supervisor deletes or pauses its recorded schedule.

The saved Scheduled-task prompt remains
`Run one audit tick from {{RUN_DIR}}/supervisor.md.` Codex Scheduled management is a
product action, not a slash command. Direct creation uses the host's project-task and
automation actions. Prompts-only delivery prints the natural-language setup prompt;
never invent `/loop` syntax.
