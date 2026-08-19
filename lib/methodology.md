# The longgraph methodology

Every rule here exists to prevent a specific, observed failure mode of long-running agent work. This document explains the *why* so you can adapt the rules without breaking them.

## Why a graph, not a loop

A single agent grinding a long task is a *loop*: the same context, growing round after round, judging its own output. The failure is structural — by round 30 the context is full of the shortcuts, half-truths, and quietly-lowered bars that got it there, and that polluted history is exactly what it reasons from. It cannot audit its own drift, because the audit runs in the drifted context.

loop-graph makes the run a small **graph of nodes that share no context** — only durable, inspectable state:

- the **executor node** advances the work, round by round;
- the **supervisor node** boots fresh every tick, reads only the ledger and git tree, and judges the run from the outside;
- the edges between them are files a human can open: the **ledger** (shared scoreboard), the **directives file** (one-way corrections), the **git tree** (checkpoints).

Rules 1–7 keep the *executor* honest within a round. Rule 8 — clean-context separation — is what a loop structurally cannot give you, and it's the reason this is a graph. Rule 9 keeps successive *runs* honest with each other.

## 1. One scoreboard (the ledger)

**Rule:** a single `ledger.md` is the only source of truth. When code, docs, and ledger disagree, the ledger is fixed first, then the code.

**Prevents:** *state fragmentation and history-shaped token growth.* Without one canonical place, round 30 rediscovers a decision made in round 5, re-opens a closed question, or builds a thing that already exists. The ledger is small on purpose — it's read every round, so it must stay cheap. It retains current state, unresolved rows, and only the latest rounds; closed rows retire after their closure is recorded. The directives edge follows the same rule: one supervisor state line, fixed-at-generation STANDING subjects, and a capped queue of unconsumed corrections. Policy changes replace their subject instead of appending history, so a slow executor cannot accumulate an infinite queue. Old rounds and folded corrections move into `archive/`, and normal nodes never read them.

**The rotation rule has to fire on something that always arrives.** Rotate by *count against a cap* — rounds past the keep-window, corrections at or below the folded watermark — and cap every live file by line count as a backstop. Keying rotation to a boundary that may never be reached (a fixed shard size, the next milestone) is indistinguishable from having no rule: in one observed run the directives file was capped at eight live entries but told to shard "every 100 IDs", so after 33 corrections nothing had ever rotated, the file was 57 KB, the executor read only its tail and silently missed the four newest directives, and the supervisor — reading the same truncated tail — reissued IDs it had already used. Unbounded growth doesn't just cost tokens; past a threshold it corrupts the edge.

## 2. One item per round → verify same round → update ledger

**Rule:** each round picks the single smallest unclosed item, implements it, verifies it with the narrowest test/gate/smoke, and records the result — all in one round. "Smallest" means the smallest **independently verifiable** increment, not the smallest possible edit: on a host whose rounds resume the previous round's context, each extra round re-carries every earlier round's output, so slicing past that point buys nothing and costs quadratically (see the selected [host reference](../skills/loop-graph/references/)). Siblings that share one verification belong in one round.

A round is not an activation. Each node fires on its own timer and closes several verified rounds per fire, because a fire boundary costs a cold re-derivation while the rounds inside one share warm context and a cached prefix. Keep the *round* small and verified; let the *fire* be productive.

**Prevents:** *batching debt and fake progress.* Batching hides which change broke a gate. "I'll test later" becomes "never". Verifying in the same round means "done" always means "verified to closure", not "written". The same instinct scales up: an expensive full-cohort operation (whole-set eval, bulk VLM/API sweep, migration) gets a **smallest-slice pilot first** — validate on a handful of items, then go wide; burning the full set to discover a config bug is the batch-debt failure at cohort scale.

## 3. Forced convergence rounds

**Rule:** a convergence round does zero new features — only deletion, de-duplication, interface tightening; net lines ≤ 0. It fires on whichever comes **first**: N rounds since the last convergence (default 5) or accumulated net production lines over the cap (default 400). The trigger is **explicit durable state, not a recomputed count**: the ledger's status header carries a convergence tracker — rounds-since, net-lines-since, and a `next round converges` flag — that the executor updates each round and resets after converging.

**Prevents:** *monotonic growth — and a forcing function that silently never fires.* Agents add far more readily than they remove; without a periodic forcing function the codebase only grows until the run can no longer reason about it. But a forcing function keyed to "every 5th round" is unreliable when each round is a fresh, stateless context: the executor has to remember the rule and recompute `round mod 5` every time, and a cheap/fast model focused on its item routinely skips it — so the convergence round that was supposed to fire just doesn't. Making the trigger a flag in the one scoreboard (checked first thing each round) *and* keying it to real accumulated bloat, not only a blind count, is what makes convergence actually happen — and the supervisor audits that a flagged convergence round truly converged.

Two things have to hold for that to be more than a nice diagram. The tracker must **survive compilation**: in one observed run the generated ledger kept the word "Convergence" but dropped the three counter fields, so there was no state to advance, no flag to check, and 32 rounds passed without a single convergence round. And someone must **notice the flag is stuck**: a `next round converges: yes` carried past one round is exactly as invisible as no rule at all unless a second node reads it every tick and orders the repayment.

## 4. Register-then-defer

**Rule:** any gap found mid-round is logged in the ledger's debt register with a priority and queued for a later round. Never silently patched now; never dropped.

**Prevents:** two opposite failures at once — *scope explosion* (fixing every gap you trip over turns one item into ten) and *silent loss* (noticing a bug and forgetting it). Registering makes gaps visible and schedulable without derailing the current item.

## 5. No speculative building

**Rule:** before adding any endpoint / module / protocol / config / pool, register its real consumer in the ledger. No consumer → don't build. No compat double-paths, no v1/v2 coexistence, no parallel error systems, no second delivery channels.

**Prevents:** *"might need it later" bloat* and *two-truths architecture.* The most expensive drift is a second way to do something that already has a way. Requiring a named consumer kills speculative abstractions at the door.

## 6. Stop conditions

**Rule:** three ways to stop cleanly —
- **Milestone exit all-green** → request promotion. A configured supervisor adjudicates it; otherwise stop for owner sign-off.
- **All remaining items blocked** → stop with an escalation report.
- **Two rounds with no ledger/metric change** → stop with a stall diagnosis.

And one way to stop hard: **any red-line violation halts the run immediately.** A
stop that needs an owner decision is not complete until it presents a small,
plain-language choice set with a recommendation; a technical problem dump is not
an escalation.

**Prevents:** *spinning.* A run with no stop condition burns tokens re-touching the same untouchable items. Explicit stops turn "stuck" into a signal instead of silent churn.

Blocking is not stopping, and the two are constantly confused. A long run blocks often — an owner decision outstanding, an external input missing, a dependency unmet, a promotion under audit — and if every block ends the activation, the run spends most of its life waiting to be restarted. The rule is: record the blocker, then take the next **already-registered** item that has existing authority, no dependency on the blocked verdict, and a write set disjoint from the blocked surface, from any pending promotion audit surface, and from every other item taken this way; end the fire only when nothing qualifies. That keeps register-then-defer intact — nothing new is invented, only registered work is promoted — while removing the dead air. It also means `pending-audit` blocks exactly one boundary, not the whole run: the thing being judged stays still while the rest of the registered work keeps moving.

Two guards keep that from becoming its own failure. **Continuing is not asking.** Removing the stop must not remove the escalation: a blocker on the critical path is raised to the owner in the round it is registered *and* the run moves to the lane. Otherwise a run quietly works around the one thing it needs, indefinitely, and looks busy the whole time. **And the lane must converge.** Lane work is a stopgap, not a career: read-only inventory that ends in another inventory is spinning, however well written, so two consecutive rounds with no change outside the ledger mean the lane is exhausted — restate the outstanding asks and stop. A stall detector that only counts idle rounds will never catch this; it has to count rounds that changed nothing *outside the scoreboard*.

## 7. Red lines

**Rule:** a short list of non-negotiables that halt the run: no push without authorization, no destructive git on others' work, no secrets/real data in code/logs/commits, frozen contracts stay frozen, metrics only go up (a regressing change is rolled back the same round).

**Prevents:** *irreversible or unsafe actions.* These are the things you cannot undo cheaply — a bad push, a leaked key, a silently lowered accuracy bar. They are absolute, not heuristics.

## 8. Clean-context supervisor separation

**Rule:** the supervisor is a **different node with a fresh context**, spun up each tick — and on most hosts that freshness is something the run has to *enforce*, not something the loop primitive gives it (see the selected [host reference](../skills/loop-graph/references/)). It reads only durable state (ledger + git) **plus the shared standards both nodes obey** (`ops.md`, the repo's `AGENTS.md`/`CLAUDE.md`/lint), and it is an **independent acceptance auditor, not just a watchdog**: it **re-verifies the executor's claimed-done work itself** — re-running the gates and inspecting the real diff/artifact against the acceptance bar and those standards — so it catches drift, fake-done, and undisclosed shortcuts the executor's own context hides. It checkpoint-commits **only what passes its audit**, and corrects drift, wasteful *method*, and a stale plan **only through the directives file the executor reads** — never by editing the ledger the executor is actively writing, never by joining the executor's context. It is also a **decider**: it adjudicates every call **off the owner-only list** itself — directive plus a one-line rationale the owner can retro-review — escalating only the short list of genuinely human calls.

**Prevents:** *self-blind drift and concealment, write contention — and escalation stalls.* A same-context agent can't catch the drift its own context caused, and it will report its own shortcuts as "done"; a clean-context auditor that re-runs acceptance against the shared standards catches both, because it wasn't there when the corner was cut and it doesn't take the ledger's word for it. Two agents editing the same scoreboard corrupt it — so the directives file is a strict one-way edge: supervisor writes, executor reads. Checkpoint commits are the supervisor's job precisely because commit authorization is a red line for the executor. And a supervisor that only watches and escalates leaves the run idling for hours on calls a competent reviewer could make — delegated authority with a logged rationale keeps the run moving while keeping the owner able to overrule after the fact. The deeper stall is upstream: if an owner-only category sits on the goal's *own critical path* — the goal **is** dropping dead tables, so every round hits DDL — then no amount of supervisor delegation helps, because the decision genuinely belongs to the owner. The fix is to move it earlier: **pre-adjudicate it in the interview into a standing authorization** — an objective evidence bar (e.g. "drop once 0 rows + 0 consumers + 0 reads/writes, via reversible migration") the executor acts under autonomously and the owner retro-reviews. Without that, the loop can only emit "proposals awaiting sign-off" and stop — which is not a loop. Only a decision that truly can't be written as a bar in advance stays blocking. This node separation is the load-bearing difference between a graph and a loop.

Two failure modes follow from the separation and have to be designed against.

**Liveness — solved by giving each node its own timer, not by letting them wake each other.** The tempting design is one loop that dispatches the other: the executor runs until it blocks, and the supervisor resumes it when its audit finds the run idle. It reads well and it stalls in practice. Now liveness depends on a chain of judgments that all have to be right at once — is the run really idle or mid-activation, is the recorded session ID still reachable, did the dispatch send, was there anything new to send — and each one is a place the run can die quietly. An observed run spent hours alternating between a supervisor deciding not to interrupt and an executor answering a dispatch with "nothing newer than D-027; no action taken", while the owner typed "trigger it" by hand. **Two independent clocks remove the whole class.** The executor fires on its own cadence, closes several rounds, and ends; the supervisor fires on a slower one, audits, appends, and ends; a correction is folded on the executor's next fire. A tick with nothing to say is then a complete tick rather than a missed heartbeat, an unreachable peer costs one interval instead of the run, and there is no idle-detection, no resume prompt, and no session pointer to go stale. What steering still requires is cheap and local: re-read the directives edge at the start of every round, so a long fire stays correctable while it runs. The cost of the design is bounded latency — a correction waits up to one executor interval — and that is the right thing to pay, because latency is recoverable and a stalled run is not.

**Checkpoints:** supervisor-owned commits assume the supervisor can safely commit what it audited. On a long unattended run with short activations, or a milestone whose job is deleting code, that assumption breaks and the executor needs its own narrow authorization — commit a slice only when its own narrow gate and the repo's promotion gate are both green, never push. Without a green checkpoint there is nothing to roll back to and nothing to bisect, and "recoverable in the working tree" stops being true the moment an untracked file is removed.

## 9. Owner decisions are choice cards, not homework

**Rule:** investigate first, recommend one option, and ask the owner to choose from
at most three mutually exclusive outcomes. State the decision and delay impact in
plain language; label the recommendation; accept an `A` / `B` / `C` reply. Put
paths, commands, and specialist detail in an optional technical note after the
choices. If the owner does not answer, preserve the safe no-change state.

**Prevents:** *decision dumping.* An owner who does not know the implementation
should not have to reconstruct the run, understand internal symbols, or invent the
solution. The agent owns analysis and recommendation; the owner supplies authority
or preference.

## 10. One run, one directory

**Rule:** every run generates its artifacts fresh into its own `.longgraph/<YYYY-MM-DD-slug>/` directory. A successor run never edits the previous run's prompts or ledger — it distills what still holds into its own starting snapshot, carries still-in-force STANDING directives forward, and leaves the old directory untouched as the archive.

**Prevents:** *state bleed between runs.* Retargeting an old executor prompt or ledger means patching stale goals line by line — token-expensive, error-prone, and the leftover text quietly steers the new run toward the old goal. Fresh generation from templates plus a distilled snapshot carries exactly the learnings and none of the stale scaffolding; a fixed, predictable location means the supervisor cron and a fresh executor always find state in the same place.

## 11. Discovery-driven runs: seed the method, not the list

**Rule:** when the work has to be *found* before it can be done — dead code, duplication, missing coverage, stale config — the authoring pass seeds **detectors, a refill quota, and a rotation over the whole surface**, not the targets. The register is rolling: a round that closes N candidates refills at least N it discovered itself, and a round that finds the queue short re-runs the detectors before taking work. Termination is a **yield** condition — two consecutive full sweeps whose fresh detector pass produces fewer than a threshold of qualifying candidates — never "the seeded list is empty".

**Prevents:** *the seed becoming the ceiling.* An author has one context window and sees a fraction of the tree, so a hand-written candidate list is a sample, not an inventory. In one observed run the ledger shipped eleven seeded candidates; the executor worked exactly those, ruled the survivors "keep", and set `exit-ready` in eighteen rounds — while 229 detector hits and 149 near-duplicate pairs still stood untouched in the same repo. No rule was broken: the contract said "finish this list", so finishing it looked like success. Seeding the method makes the run's reach a function of the detectors and the rotation instead of what the author happened to notice.

## 12. A budget is a scope decision in disguise

**Rule:** price each gate by what it actually costs — money, wall-clock, or risk — and say which. A gate that costs only time is **batched**, never rationed: many candidates ride one run of it. Never leave a scarce-resource cap sitting in front of a whole area of the work. If a cap makes an area unreachable, that is a scope decision and it belongs in the scope question, not in a budget line.

**Prevents:** *a budget quietly redrawing the map.* Cap a gate at six runs, then require that gate for any change to the main package, and the rational executor spends the whole run in the cheap corner and reports the main package as clean. That is what happened in the run above: the package that held two thirds of the detector hits never had a single line touched, and every local decision along the way was defensible. Ration what is genuinely scarce; let the rest be slow.

## 13. The supervisor is also an accelerator

**Rule:** the audit checks under-delivery with the same rigor as it checks violations — rounds that changed nothing outside the ledger, fires that ended under the output floor, areas never swept before a terminal claim, a rolling register that stopped refilling, a sweep that produced no merge. And its corrections stay **scoped, reasoned, and expiring**: a `Stop` names exact symbols or paths, why, and what lifts it. A directive that forbids a whole directory or a whole class of action (no merging, no deleting, no detector work) is a starvation risk, and every packet must dispatch the next concrete move rather than only forbidding.

**Prevents:** *a supervised run starving under a stack of locally correct prohibitions.* An auditor rewarded only for catching defects converges on forbidding work, because forbidding never produces a defect to catch. In the observed run four consecutive directives banned the expensive gate, the main package, merging, and detector hunts; the executor obeyed, closed nothing outside the scoreboard for eleven of eighteen rounds, and the supervisor accepted the terminal status it had itself made inevitable. Auditing the *rate of real change* is what keeps the brake from becoming the outcome.

---

## Tuning

The numbers (convergence every 5, 400-line cap, 3 rounds per fire, a supervisor tick at 3–4× the executor interval, 200-line file cap, and any output floor or yield threshold an open-ended run needs) are defaults, not dogma. Tune them in the interview to your project's rhythm. What must not change is the *shape*: a single scoreboard, one-item rounds with same-round verification, a forcing function against growth, visible-and-deferred gaps, hard stop conditions, absolute red lines, one self-driving timer per node with no wake edge between them, and — above all — a supervisor node whose context is separate from the executor's. Remove any one of those and the graph collapses back into a drifting loop.
