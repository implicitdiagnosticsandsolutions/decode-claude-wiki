# Doc Index

## Plan

- [`plan/00-overview.md`](plan/00-overview.md) — the problem, constraints, two hard gates, delivery model
- [`plan/01-strategy.md`](plan/01-strategy.md) — v3 strategy (current)
- [`plan/02-reviewer-critique.md`](plan/02-reviewer-critique.md) — v1→v2→v3 history
- [`plan/03-rollout-status.md`](plan/03-rollout-status.md) — per-repo checklist
- [`plan/04-open-questions.md`](plan/04-open-questions.md) — decisions pending

## Incidents

Auto-captured going forward from override markers, CI failures, and revert commits. See [`incidents/README.md`](incidents/README.md) for format and triage process.

## Rules

- [`rules/README.md`](rules/README.md) — rules catalog
- [`rules/_template.md`](rules/_template.md) — per-rule template (incident link required)

## Reference

- [`reference/claude-code-patterns.md`](reference/claude-code-patterns.md) — Claude Code mechanisms (hooks, plugins, settings) we use
- [`reference/repo-inventory.md`](reference/repo-inventory.md) — current state of Claude Code adoption across the org

## Templates (not under `docs/`)

- [`../templates/repo-setup/`](../templates/repo-setup/) — the per-repo PR content that ships the hardening (hooks, gates, CI workflow, CLAUDE.md)

Productivity plugins (`feature-dev`, `code-simplifier`, `claude-md-management`, `superpowers`) come from Anthropic's official marketplace (`anthropics/claude-plugins-official`) — no DECODE-hosted marketplace needed.
