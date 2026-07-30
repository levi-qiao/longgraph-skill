# Host dialects

The methodology is host-agnostic — the same discipline runs on any agent that can
loop or hold a goal. Only the *invocation syntax*, the *primitives a host actually
has*, and the *wake/notify* hooks differ. This table is the single owner of those
differences; skills point here instead of re-describing each host.

## What each host has (and therefore which arm it can run)

| Host | `loop` (scheduled/self-paced repeat) | `goal` (set-objective + verify-to-done) | Runs loop-graph arm? | Runs quest arm? |
|------|:---:|:---:|:---:|:---:|
| **Grok** | ✅ `/loop` | ✅ `/goal` — native adversarial verifier | ✅ | ✅ |
| **Claude Code** | ✅ `/loop` | ⚠️ no standalone command — the loop-graph **supervisor** is its verifier | ✅ | via loop-graph |
| **Codex** | ✅ `/loop <interval>` → heartbeat automation¹ | ✅ task self-drives (adaptive) — **no** native refuter | ✅¹ | ✅ |
| **Cursor** | ✅ loop/repeat (run capped ~20 min) | ❌ | ✅ | ❌ |
| **shell / cron** | ✅ `while … sleep` / crontab | ❌ | ✅ | ❌ |

**Grok and Codex run both arms; Claude Code runs both\*; only Cursor and shell are
loop-only** (no goal → loop-graph arm). So the arm is a **task-shape** choice on most
hosts — the host only rules options out. Grok is the only host whose goal carries a
*native adversarial verifier*; on Codex and Claude Code a "verified goal" leans on the
objective's own acceptance criteria. (\*Claude Code has no separate `/goal` — its quest
is a self-paced single `/loop`; for an independent verifier use loop-graph, where the
supervisor is the verifier.)

¹ **Codex has two drive modes, and which you use depends on the arm:**
- **quest** — a task / `/goal` **self-drives to done** (adaptive, auto-wakes each round,
  no command needed); "done" is a real terminus, so this is the quest arm's natural fit.
  No separate refuter — the acceptance criteria carry verification.
- **loop-graph** — drive **both** nodes with a `/loop <interval>` typed in conversation,
  which Codex compiles to a **heartbeat automation** (needs an *explicit* interval like
  `4m`, or no timer is created). **Never drive a loop-graph node with a goal /
  self-driving task:** a loop-graph node legitimately *parks* (`pending-audit`, `stalled`,
  awaiting a supervisor directive), and a goal harness has no "parked, waiting" rest
  state — it reads "not done" and re-fires the parked node forever (**livelock**,
  burning tokens on "still stalled" turns). The interval heartbeat parks cleanly: it
  ticks, cheap-no-ops while parked, and deletes its own automation on a terminal status.

## Loop primitive (drives the executor / a plain repeating task)

| Host | Command | Interval | Adaptive? | Stop |
|------|---------|----------|-----------|------|
| **Claude Code** | `/loop [interval] <prompt>` | optional — omit to self-pace | **yes** (self-paced re-invokes when the round returns) | `ScheduleWakeup` `stop:true`; or `CronDelete` if scheduled via `CronCreate` |
| **Grok** | `/loop [interval] <prompt>` | `Ns/Nm/Nh/Nd`, min 60s; recurring expires after **7 days** | no — interval-driven, but a fire whose previous iteration is still running is **skipped**, so a long round is never doubled (no lock needed) | `scheduler_delete <job-id>` (id printed when the loop is created; also in each fire's own `<system-reminder>`) |
| **Codex** | `/loop <interval> <prompt>` (in conversation) → **heartbeat automation** | **required** — e.g. `4m`; **no interval ⇒ no timer created** | no — interval heartbeat (the task self-drive is goal-mode, not for loop-graph nodes — see ¹) | pause/delete the automation, or have the prompt stop it on a terminal ledger status |
| **Cursor** | `/loop [interval] <prompt>` — a background shell sentinel wakes the agent **in the current session** | optional — omit for its dynamic (self-paced) mode | **yes** in dynamic mode; interval-driven otherwise | kill the tracked loop/sleeper PID in-client |
| **shell/cron** | `while …; do …; sleep <interval>; done` / crontab | interval-driven | no | `break` on a terminal ledger status / `CronDelete` |

Cursor's **cloud background agents** are a different feature from its in-session `/loop`
(the `/loop` skill is disabled in cloud environments): that path is the one with a
per-run wall-clock cap (~20 min), so a round driven by a background agent must finish
under it.

**Adaptive vs interval** is the load-bearing distinction for the loop-graph arm's
gate-park: on the adaptive host (Claude Code self-paced) re-invocation is automatic,
so a round never gets cut off and a parked executor resumes for free. On interval
hosts (Grok `/loop`, Cursor in fixed mode, **Codex** heartbeat, shell/cron) **both loops must be
scheduled** and the executor keeps cheap-ticking until release — a loop that writes a
terminal status and stops cannot restart itself. (A Codex loop-graph node therefore
uses the interval heartbeat, never a goal — see ¹.)

## Context carry across rounds — what a round actually costs

A loop host does **not** hand each round a blank slate. Where the next fire's context
comes from is the biggest lever on what a run costs, and — for the supervisor — on
whether the clean-context invariant holds at all. Only shell/cron is genuinely
fresh per tick.

| Host | The next round starts from | Forced-reset control |
|------|---------------------------|----------------------|
| **Claude Code** `/loop` | the same conversation, auto-compacted as it grows | none per round |
| **Grok** `/loop` (default `[scheduler] background_loops = true`) | a **detached subagent that resumes the previous fire's transcript**; every **10th** fire starts fresh carrying only the prior status **truncated to 600 chars** | **yes** — `scheduler_create` with the task's own `task_id` and *changed* prompt text; the next fire then starts a clean transcript with **no** carry-over |
| **Grok** `/loop` where the task was created `foreground: true` | a turn in the owner's own conversation (shared context, not isolated) | none |
| **Codex** `/loop` heartbeat | `<heartbeat>` turns appended to the **same target thread**, auto-compacted | `/compact` |
| **Cursor** `/loop` | the same session — the sentinel wakes the agent in-place | none |
| **shell/cron** | a new CLI process — genuinely fresh every tick | inherent |

Four consequences the loop-graph arm is tuned against:

1. **Per-round cost is quadratic in rounds-per-chain, not linear.** On an accumulating
   host round *N* re-sends every earlier round's tool output. Splitting work into more,
   finer rounds pays that prefix more times for the same result — so **size rounds
   coarser** (batch sibling items that share one verification) and keep bulk output
   **out** of the transcript (write it to a file, report the delta). Bounding the ledger
   (`KEEP_ROUNDS` rotation, archive to `rounds-archive.md`) still matters, but it caps
   only the *re-read*, not the accumulated prefix.
2. **Reset at a boundary you choose, not where the host chops.** A blind reset lands
   mid-item and keeps only its truncated carry-over — that is where a long run visibly
   loses its thread. A deliberate reset at a **milestone boundary** (or straight after a
   convergence round), ledger current and gates green, loses nothing: the ledger is the
   memory. Corollary: put the pointer (run dir + next item) in the **first few hundred
   characters** of every round's closing status — on a blind reset that prefix is all
   that survives.
3. **The supervisor's clean context is not free here.** On a chain-carrying host the
   supervisor's tick *N* resumes its own previous audits, so it stops being an outside
   reviewer — the one property the node exists for. Where a forced reset exists, the
   supervisor must use it **every tick**; where it doesn't, prefer a host whose ticks are
   fresh (shell/cron) for that node.
4. **A host-level refusal never reaches the node.** If the account's balance or rate
   limit is exhausted the fire errors before the model runs, so the node cannot write a
   terminal status and the loop keeps firing on a dead run until it expires (Grok: 7
   days). Deleting the job is an owner action — `scheduler_delete` / pause the automation.

Measured on one real Grok run (2026-07-28, both nodes on `/loop`): executor chains grew
75 KB → ~1 MB of transcript over 10 fires; a supervisor chain reached 662 KB by its 10th
tick; 305 fires over two days carried ≈80 MB, ~90 % of it resume-chain prefix, and
exhausted the account mid-run — after which ~90 further fires errored for seven hours.
Transcript bytes from the session store, not billed counts; the shape is the point.

## Goal primitive (a built-in executor+verifier — the quest arm rides this)

| Host | Command | Built-in verifier? |
|------|---------|--------------------|
| **Grok** | `/goal <objective> [--budget <tokens>]` · `status`/`pause`/`resume`/`clear` | **yes** — plans acceptance criteria, works across rounds, and only marks complete after an **independent adversarial verifier** reproduces the evidence (defaults to *refuted* if it can't); anti-ratchet so it converges instead of re-litigating |
| **Codex** | `/goal <objective>` or just send it as a task — self-drives (**quest only**) | **adaptive** — self-drives to done and auto-wakes each round; no separate clean-context refuter, so lean on the objective's acceptance criteria. **Do not use this to drive a loop-graph node — it livelocks at a park state (see ¹); use the interval `/loop` heartbeat there.** |
| **Claude Code** | *(no standalone `/goal`)* — use the loop-graph arm; its clean-context supervisor is the verifier | n/a |
| **Cursor** | *(none — Cursor only loops)* — use the loop-graph arm | n/a |

In the **quest arm** on a native-goal host (Grok, or Codex-as-quest), the
host's own harness is the acceptance layer — don't bolt a second supervisor loop on
top; that's the redundancy the quest arm exists to avoid. A Codex **loop-graph** run is
different: there is no goal there — both nodes are interval `/loop` heartbeats and the
supervisor loop is the verifier, exactly as on every loop host.

## Wake / notify / keep-alive primitives

| Need | Claude Code | Grok | Cursor |
|------|-------------|------|--------|
| **Keep the agent working until a condition holds** (tests green, gate passes) | loop re-invocation | **`Stop` hook** — blocks the turn from ending until the condition holds, feeds the reason back to the model | — |
| **Ping the owner when a run parks / finishes** | — | **`Notification` hook** — HTTP/shell on task-finish or a surfaced notice | — |
| **Guard a red line before a tool runs** | hooks / permissions | **`PreToolUse` hook** — deny a dangerous command before it runs | — |

For the loop-graph arm's "supervisor unresponsive at gate" backstop, a Grok
`Notification` hook turns a silent stall into an owner ping; a `Stop` hook can hold
the executor turn open until an acceptance directive lands instead of letting the
loop end. These are optional reliability upgrades, not required for the base pattern.
