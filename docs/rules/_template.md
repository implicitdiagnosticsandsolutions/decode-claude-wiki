---
number: NN
title: short-name
tiers: [product, data-python, data-r]  # or a subset
enforcement: [hook-name | gate-name | none]
justification: incident | proactive-risk  # one of; see below
incidents:  # empty allowed ONLY when justification is proactive-risk
  - ../incidents/YYYY-MM-DD_repo_shortname.md
status: draft  # one of: draft, ready, shipped
---

# NN. Rule title

> **Hard requirement for `shipped`:** active enforcement in target-repo templates (hook, gate, or CI check) AND documented justification in the `## Why` section below.
>
> Justification comes in two flavours:
> - **incident**: one or more entries in `../incidents/` documenting a past failure. Preferred — a rule with a scar is the strongest rule.
> - **proactive-risk**: a short note in `## Why` explaining why we built enforcement before a failure. Legitimate for rails adopted from industry standards, cross-org learnings, or threat models that we chose to close preemptively rather than wait for a real incident.
>
> A rule with neither justification flavour is a `draft` — a suggestion, not a rule.

## Rule statement

One imperative sentence. This is what goes into CLAUDE.md. A reader must be able to predict whether their action complies without asking.

## Why

What failure this prevents. For `justification: incident`, cite the specific incident(s) under `../incidents/` (date, repo, SHA, cost). For `justification: proactive-risk`, state the threat model or standard the rule closes against, and acknowledge that no DECODE incident has driven it yet. If a real incident later materialises, add it to `incidents:` and promote justification to `incident`.

## How to apply

Concrete when/where guidance. A reader should be able to tell whether an action complies without asking.

## Enforcement

- **Hook:** which hook operationalizes this (e.g. `.claude/hooks/block-env-writes.sh`). If none, mark as "CLAUDE.md advisory only" and flag as tech debt if enforcement is feasible.
- **Gate:** which `.githooks/pre-commit` gate catches violations at commit time.
- **Reviewer check:** what a reviewer agent should look for. One bullet.

## Tiers

- [x] product
- [x] data-python
- [x] data-r
- [ ] meta (usually off)

## Related rules

Other rule files that cover adjacent concerns.
