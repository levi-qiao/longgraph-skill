# Preset Contract

`loop-graph` is the shared compiler. A preset makes one recurring goal easier to
author; it never creates another runtime, template set, node, scoreboard, or timer.

## Ownership

| Owner | Owns |
| --- | --- |
| [`loop-graph`](../SKILL.md) | graph invariants, shared templates, generic interview mechanics, host handoff |
| A preset entry | fit check, its short interview, and binding its pack |
| A preset pack | North Star, proof, work shape, method guards, knob overrides, artifact emphasis, slug |
| A host reference | timer lifecycle and host syntax |

The compiler maps a pack into the same five runtime artifacts:

| Artifact | Preset may specify | Must remain true |
| --- | --- | --- |
| `executor.md` | workset definition, workflow, method guards, output floor | one ledger writer; one verified work item per round |
| `ledger.md` | goal rows, state needed for the next slice, proof and decision fields | the only scoreboard |
| `ops.md` | exact source pointers, gates, evidence paths, data/cost facts | facts, not a timeline or a second plan |
| `directives.md` | standing authority and scoped corrections | supervisor is its sole writer; it carries authority, not duplicated method |
| `supervisor.md` | independent audit surface and under-delivery checks | it never writes the ledger or shares executor context |

## Required pack headings

Every focused pack contains these authoring-only sections. Keep a fact in its one
owner; do not repeat template instructions in the pack.

1. **North Star** — bounded outcome and checkable proof.
2. **Supervisor** — whether it is required and what it independently audits.
3. **Interview** — at most three unresolved owner choices, with a recommended option.
4. **Shape** — how work becomes one independently verifiable work item or workset.
5. **Method guards** — only the rules unique to this goal class.
6. **Knob overrides** — only numbers that differ from the baseline, including an output
   floor when a fire must be productive.
7. **Artifact emphasis** — which facts belong in each shared runtime artifact.
8. **Slug** — the default run-directory suffix.

## Workset rule

One ledger item is an independently verifiable workset. It may contain all related
changes that share one behavior claim, write set, and gate. A preset should make that
grouping explicit when its goal benefits from it, while keeping unrelated changes and
deferred verification out of the workset. A fire cap ends only that fire; it never sets a
terminal run status.

## Extension test

If a pack needs a new writer, a new live file, or a new timer, it is no longer a preset.
First apply the node-and-edge test in [`model.md`](model.md): define the tuple, give the
writer its own on-reference edge, and prove the graph needs it. Otherwise compile the
requirement into the existing artifacts above.
