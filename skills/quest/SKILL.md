---
name: quest
description: Author one compiled quest objective for a goal-capable host. Use when the user asks to interview, generate, revise, or deliver a single self-contained octopus quest for Grok `/goal` or a Codex task. This is an authoring skill only. Do not use to execute or resume an objective marked `octopus.quest-executor/v1`; use `quest-executor` for that. Use `loop-graph` authoring for gated milestones, split executor/supervisor runs, or loop-only hosts.
---

# quest — one objective, riding the host's own verifier

## What it does & why

Some hosts already drive the graph for you. Grok's `/goal` plans acceptance
criteria, works across rounds, and only marks the goal complete after an
**independent adversarial verifier** reproduces the evidence (defaulting to
*refuted* if it can't). A Codex task self-drives an objective to done across rounds.
On such a host, generating a separate executor + supervisor + two loops is
redundant — you'd pay tokens to re-describe what the harness enforces for free.

The quest arm emits **one task-specific objective** marked
`octopus.quest-executor/v1`. The runtime skill carries the reusable execution
discipline; the compiled objective carries only the goal, reproducible acceptance,
run controls, concrete red lines, and owner boundary.

## When to use quest vs loop-graph

Use the **quest arm** when *all* hold:
- one self-contained goal (no strict-ordered milestones with a non-skippable gate);
- the host has a goal command that self-drives to done (**Grok `/goal`**, a **Codex
  task**);
- executor and reviewer live in the **same** run (you're not splitting them across
  hosts/models);
- no owner-only decision sits on the goal's critical path.

Use the **[loop-graph arm](../loop-graph)** when *any* hold: multi-milestone phases,
executor and supervisor on different hosts/models/cadences, owner red-lines/gates
that must stop the run, cross-session durability, or a host that **only loops** and
has no goal command (**Claude Code**, **Cursor**, shell) — there loop-graph supplies
the verifier as the supervisor node. See [`host-dialects.md`](../../lib/host-dialects.md) for which host
has what.

## How to run it

**Step 1 — Interview** (fill the blanks, don't assume; surface tradeoffs, don't
silently pick). Ask in order — skip only if context already answers:

1. **Host** — where does the goal run? (**Grok `/goal`**, a **Codex task**). This
   picks the invocation dialect ([`host-dialects.md`](../../lib/host-dialects.md)). If the host has **no**
   goal command — Claude Code, Cursor, shell — stop and switch to the loop-graph arm.
2. **Objective** — the goal in one sentence.
3. **Acceptance criteria** — the North Star, each as a check the host's verifier can
   **reproduce without the agent**: a command that must pass, or an artifact at a
   persistent path showing a bar met on a named eval set. Push until every criterion
   is checkable ("`make test` green", "scorecard ≥ X on the frozen set"), not "make
   it work". This is the single most important step — Grok's verifier defaults to
   *refuted* on anything it can't reproduce, and a Codex task has no separate refuter
   at all, so the criteria are your only guardrail there.
4. **Red lines and owner boundary** — the concrete non-negotiables that halt the
   work (push/commit auth, destructive ops, secrets/real data, frozen contracts,
   metrics-only-go-up), plus the genuinely case-by-case decisions only the owner
   may make. Write `none` when no owner-only call remains.
5. **Expensive-op guard** — is there a full-cohort eval / bulk sweep / migration? If
   so, it pilots first.

**Milestone check.** If the answers reveal strict-ordered phases with a gate, or an
owner-only call on the critical path, say so and switch to the loop-graph arm — the
quest arm deliberately has no gate and no owner-stop loop.

**Step 2 — Generate.** Copy [`templates/quest.md`](templates/quest.md), replace every
`{{PLACEHOLDER}}`, and delete guidance comments. Keep the execution marker unchanged.
Interview in the user's language and mirror it in the task-specific prose; keep
structural headings unchanged. Do not inline the reusable discipline from
[`quest-executor`](../quest-executor/SKILL.md).

**Step 3 — Deliver.** Hand the filled objective to the host's goal command, and tell
the user how **in the chat** (print it, don't assume this session is the host):

- **Grok:** `/goal <the filled objective>` — optionally `--budget <tokens>`. Manage
  with `/goal status` · `pause` · `resume` · `clear`.
- **Codex:** delegate a task with the filled objective as its brief; it self-drives
  across rounds. The marker routes execution to `quest-executor`; the objective's
  acceptance criteria remain the verification authority.

Optional reliability upgrade on Grok (from [`host-dialects.md`](../../lib/host-dialects.md)): a `Stop`
hook to hold the turn open until a gate passes; a `Notification` hook to ping the
owner when the goal parks on a real blocker.

**Durability note.** A goal harness's state is ephemeral (Grok's scratch dir is
deleted when the goal ends). If the goal must survive across sessions or you want an
inspectable scoreboard, also seed a `ledger.md` from the loop-graph arm's template
and tell the objective to keep it current — but that is the seam where you should
probably be using the loop-graph arm outright.

## Files in this skill

- [`templates/quest.md`](templates/quest.md) — the single objective prompt.
- [`quest-executor`](../quest-executor/SKILL.md) — the runtime discipline loaded by
  the compiled objective; it is not an authoring dependency during execution.
- shared: [`host-dialects.md`](../../lib/host-dialects.md) (which primitive each host has + syntax),
  [`methodology.md`](../../lib/methodology.md) (why the discipline rules exist).
