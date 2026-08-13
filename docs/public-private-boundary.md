# Public / private boundary

longgraph is a **public prompt library**. Most useful long-horizon *runs* are not public.
This page is the publication rule for docs, examples, and showcases.

## What the public repo should answer

> **How does an longgraph loop work?**

Schemas of the method, host-agnostic templates, fictional worked examples, and
**sanitized** evidence that a reader can re-check (public Git facts, redacted
narratives, pedagogical ledgers).

## What project-local state should answer

> **What is *this* goal doing right now?**

Live `.longgraph/<date-slug>/` (or legacy `.octopus/`) trees, private ledgers, real
corpus paths, customer names, raw model traces, and metrics that identify a private
deployment.

---

## Public (safe in this repository)

| Kind | Examples |
| --- | --- |
| Method & shape | `lib/methodology.md`, `skills/loop-graph/docs/model.md`, node/edge vocabulary |
| Templates & skills | `templates/*`, root and skill `SKILL.md` (placeholders only — no real projects) |
| Host facts | `skills/loop-graph/references/*` |
| Fictional pedagogy | `examples/add-tests-to-cli/`, `examples/migrate-blob-storage/`, `examples/scout-library-choice/` |
| Public Git evidence | Commit SHAs, titles, dates, `git log` counts for **this** open-source repo |
| Redacted showcases | Generalized domain labels, **function-only** control-plane patterns, coarse scale buckets, explicit evidence boundaries (see `examples/redacted-multiday-control-plane/`) |
| Install & plugin | `install.sh`, `.claude-plugin/*` manifests |

## Private (keep out of git / public docs)

| Kind | Examples |
| --- | --- |
| Live run state | Project `.longgraph/` ledgers, directives, ops with real env facts, archives of private rounds |
| Identity | Customer, employer, or non-public product names; personal emails; team handles that imply a private program |
| Paths & infra | Absolute home paths, internal hostnames, VPN/cluster names, private package registries |
| Secrets | Tokens, keys, `.env`, session cookies, cloud account IDs |
| Raw agent evidence | Session JSONL, tool dumps, full transcripts, private screenshots |
| Identifying metrics | Accuracy/recall on a named private corpus, production SLOs, unreleased benchmark scores |
| Audit / review documents | Audit-report bodies, findings, recommendations, or excerpts from private engagements |
| Third-party confidential | Contracts, unreleased designs, internal doc URLs |

**Rule of thumb:** if a stranger on the internet could map the artifact to a
real private engagement, it does not belong here.

---

## Showcase / evidence card rule

Every public case under `examples/` or linked from root **Evidence** must declare:

1. **Evidence class** — public Git / synthetic pedagogy / redacted real run (if ever used).
2. **What is claimed** — e.g. calendar window, commit count, method feature list.
3. **How to re-check** — commands or links a reader can run without private access.
4. **Evidence boundary** — a short do/don’t list of what was excluded.
5. **Disclaimer** when using time — *elapsed wall-clock / project lifetime ≠ continuous model hours ≠ unattended production autonomy*.

Cases may enter docs **before** they have a runnable synthetic demo, but status
must say so. Prefer a modest claim over a dramatic one.

### Preferred first public artifacts

| Priority | Artifact | Why |
| --- | --- | --- |
| 1 | Self-iteration of **this** skill repo | Zero customer risk; Git-checkable |
| 2 | Fictional full ledgers | Teach shape without secrets |
| 3 | Redacted multi-day case (**function only**) | Coarse scale + control-plane verbs; never private ledger paste |

### Function-only redacted runs

When a case is inspired by real multi-day work but must stay public-safe:

- Publish **what the graph did** (scoreboard, gates, clean-context overturn,
  blocked-work lane, owner A/B/C), not **what the private system measured**.
- Use **buckets** (multi-day, tens of rounds, many directives) — not exact private
  round indices, directive IDs, score tables, or audit-report substance.
- Do **not** claim public Git re-checkability for the private engagement.
- Do **not** paste a private ledger “with numbers deleted” if remaining structure
  still identifies the engagement (unique milestone names, internal service names,
  fingerprintable paths, etc.). When in doubt, omit.

See [`examples/redacted-multiday-control-plane/`](../skills/loop-graph/examples/redacted-multiday-control-plane/).

---

## Templates vs examples (AGENTS.md alignment)

| Surface | Concrete private work? | Concrete *fictional* work? |
| --- | --- | --- |
| Core `templates/`, `lib/`, core `SKILL.md` | **Never** | No — stay host- and goal-agnostic |
| Preset `SKILL.md` + pack | **Never** | Reusable goal-domain rules only; no project facts |
| `examples/` | **Never** | **Yes** — that is their job |
| Self-iteration case | N/A (this public repo only) | N/A |

Hardening lessons mined from private runs must be rewritten as **generic failure
modes** before they touch templates or methodology.

---

## Contributor checklist (before you open a PR with a case)

- [ ] No absolute paths under a user home or internal mount
- [ ] No customer / employer / private product names
- [ ] No raw accuracy tables from a private corpus
- [ ] No credentials, tokens, or live env URLs
- [ ] Every hero number has a public source (Git command or labeled synthetic)
- [ ] Time claims include the wall-clock vs continuous-execution disclaimer
- [ ] EN and 中文 skill/root copy that state numbers stay consistent in substance

If in doubt, leave it project-local and open an issue describing the *pattern*
without the payload.

## Related

- [CONTRIBUTING.md](../CONTRIBUTING.md)
- [Self-iteration example](../skills/loop-graph/examples/self-iteration-longgraph-skill/README.md)
- [AGENTS.md](../AGENTS.md) — anti-bloat and “no secrets” rules for editors
