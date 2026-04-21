---
number: NN
title: short-name
tiers: [product, data-python, data-r]  # or a subset
enforcement: [hook-name | gate-name | none]
incidents:  # REQUIRED — non-empty. If empty, rule is NOT ship-ready.
  - ../incidents/YYYY-MM-DD_repo_shortname.md
status: draft  # one of: draft, ready, shipped. "ready" requires non-empty incidents list.
---

# NN. Rule title

> **Hard requirement:** the `incidents:` frontmatter MUST have at least one entry pointing at a real file in `../incidents/`. A rule with zero incidents is not a rule — it is a suggestion.

## Rule statement

One imperative sentence. This is what goes into CLAUDE.md. A reader must be able to predict whether their action complies without asking.

## Why

What failure this prevents. Cite the specific incident(s) under `../incidents/` that justify this rule. Each incident should include date, repo, SHA, and what it cost.

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
