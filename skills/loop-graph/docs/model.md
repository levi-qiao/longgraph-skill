# Loop-Graph Model

This document defines the shared vocabulary for designing loop-graph runs. Read it once when proposing a new node or edge; templates implement these concepts implicitly — running nodes never parse this file.

**Scope:** loop-graph only. Simple self-contained goals should use the host's
ordinary task/goal directly; this model begins where durable graph state is useful.

---

## The Law

> No load-bearing state may live only in a node's context; it must be externalized onto a typed edge.

This is the checkable definition of drift: **drift = load-bearing state that stayed in context and never made it onto an edge.**

Code-review test for a new template: does this node derive X from its own prior rounds' context instead of reading it from the ledger? → bug.

Runtime test for the same law: most loop hosts hand a round the *previous* round's context (see the selected [host reference](../references/)), so a node can silently start leaning on it — and the violation only surfaces when the host truncates the chain mid-item. **The fire boundary is where the Law gets tested**: a node ends its turn, its timer brings it back, and whatever it can no longer reconstruct from the ledger, the directives file and `ops.md` was load-bearing state that never made it onto an edge. Warm context is a cache, never a store.

The convergence tracker (#7) and the milestone gate (#11) both work because they moved a computed predicate — "should I converge?", "may I advance?" — from the executor's mental arithmetic onto the state edge where a stateless re-activation reads it cold.

---

## Nodes

A node is a specialized agent role. Each node is described by a tuple:

```
(prompt, model, activation, read-set, write-set, authority, stop-condition)
```

| Field | What it answers |
|-------|-----------------|
| `prompt` | What does this node do? (the `.md` file) |
| `model` | Which model tier runs it? |
| `activation` | When does it fire? (cadence, event, manual) |
| `read-set` | Which edges + ambient context may it read? |
| `write-set` | Which edges may it write? |
| `authority` | What may it decide without escalation? |
| `stop-condition` | When does it end its loop? |

### Current roles

| Role | Model | Activation | Reads | Writes | Authority | Stops when |
|------|-------|------------|-------|--------|-----------|------------|
| **Executor** | cheap/fast | own timer; N verified rounds per fire | ledger, directives, ambient | ledger | implementation decisions | ledger reaches `exit-ready`, `stalled`, or `closed` |
| **Supervisor** | strong | own timer, 3–4× the executor's | ledger, git diff, ambient | directives | drift corrections, acceptance, plan adjustments | ledger terminal after a final audit |
| **Scout** | cheap/fast | on-demand (research brief in directives) | ledger (read-only), ambient, external | findings | advisory — options + tradeoffs, no plan/impl changes | brief answered, cap hit, or blocked |

`authority` is the field #9 exposed as missing: "who decides X without escalating?" The executor decides *how* to implement; the supervisor decides *whether* the work meets acceptance criteria; the owner decides DDL, credentials, red-line exceptions.

### Round work item

A ledger item is one **independently verifiable workset**. It may contain multiple
related edits when they share one behavior claim, write set, and gate; the executor
implements and verifies the whole set in the same round. This preserves attribution and
same-round proof while avoiding artificial cold starts between coupled edits. Unrelated
changes remain separate items.

---

## Edges

An edge is a durable, typed channel between nodes. Two types:

| Type | Discipline | Example |
|------|------------|---------|
| **State** (blackboard) | single-writer, overwrite | `ledger.md` — the scoreboard |
| **Signal** (queue) | single-writer, ordered, one-way; consume + cold-archive | `directives.md` — supervisor → executor |

### Findings edge (scout → executor)

| Property | Value |
|----------|-------|
| Type | **State** (single-writer, overwrite) |
| Writer | scout (single-writer per findings file) |
| Reader | executor (read-on-reference, via `blocked-on: findings#<brief-id>` ledger pointer) |
| Discipline | read-on-reference; consume-and-retire |
| File | `findings.md` (single) or `findings/<brief-id>.md` (parallel) |

Why state, not signal? The scout overwrites its findings file as it refines (partial → complete). Latest-value-wins, not append-only.

**Pointer convention:** the executor logs `blocked-on: findings#<brief-id>` at the decision's ledger row, continues unblocked work, and opens the findings file only when it circles back to that row.

**Retire convention:** once consumed, the executor records the decision in its round log, moves the finding to `archive/findings-<brief-id>.md`, and removes the pointer. The executor never edits findings content — moving a spent file is custody, not authorship.

### What is NOT an edge

**Ambient context** — read-only files that exist before and after a run: `ops.md`, `AGENTS.md`/`CLAUDE.md`, lint config, the templates themselves. Nobody writes them *between* nodes at runtime; they don't carry information along a run's timeline. They're the repo, not the graph. A host-lifecycle Timers cell in `ops.md` is not an edge: only the owning node writes its own cell, and only when the selected reference keeps that section.

The live signal file is a bounded queue, not the audit archive: it holds current STANDING policy plus unconsumed directives. The consumer watermark acknowledges ordered signals; before each append the single writer moves every acknowledged entry into the cold archive. Rotating against the watermark — a condition that arrives on its own — is what keeps this bounded; rotating at a fixed shard size is a rule that can wait forever while the live queue grows past the point where a reader still reads all of it.

The test: can you determine "reuse an existing edge vs create a new one" using only state + signal? Yes — #9 proved it. The proposed `gates.md` had signal discipline (ordered, supervisor → executor) but its content was a single flag (pass/fail per milestone) → that's a field on the state edge (`ledger.md`). Two types were enough.

---

## Applying the vocabulary

When proposing a new construct (node, edge, flag), fill in the tuple / classify the edge type first. If the proposal collapses into an existing construct, it wasn't needed.

| Proposal | Analysis | Outcome |
|----------|----------|---------|
| Auditor node (#9) | Activation = "at milestone gates" needs event-bus the graph doesn't have; degrades to cadence poller = supervisor. Authority = acceptance = already supervisor's. | Collapsed into a tracked flag + red line on the existing supervisor |
| `gates.md` edge | Signal discipline, but content = one flag per milestone → fits as a field on the state edge | Collapsed into `Milestone gate:` header in `ledger.md` |
| Scout node (#17) | Activation = on-demand (not cadence/event) — distinct from supervisor. Authority = advisory only (no plan/impl changes) — distinct from executor and supervisor. Write-set = dedicated findings edge (not ledger) — new single-writer file, not a partition of an existing edge. | **Does not collapse** — genuinely new information-flow pattern: off-critical-path research → dedicated state edge → read-on-reference consumption |

The vocabulary earns its keep when filling in the tuple saves one issue → discussion → rewrite cycle.

---

## References

- #7 — convergence tracker (state edge field)
- #9 — auditor proposal → gate rule
- #11 — milestone gate implementation
- #12 — this vocabulary's design discussion
- #15 — worked example showing the gate in action
- #17 — scout node proposal
- #18 — scout node implementation (templates + findings edge + worked example)
- #19 — executor handoff protocol (blocked-on pointer + consume/retire)
