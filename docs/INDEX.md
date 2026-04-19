# Doc Index

## Plan

- [`plan/00-overview.md`](plan/00-overview.md) — the problem, constraints, two hard gates, delivery model
- [`plan/01-strategy.md`](plan/01-strategy.md) — v3 strategy (current)
- [`plan/02-reviewer-critique.md`](plan/02-reviewer-critique.md) — v1→v2→v3 history
- [`plan/03-rollout-status.md`](plan/03-rollout-status.md) — per-repo checklist
- [`plan/04-open-questions.md`](plan/04-open-questions.md) — decisions pending

## Incidents

CI failures are auto-captured today. See [`incidents/README.md`](incidents/README.md) for current capture status, format, and triage process.

## Rules

- [`rules/README.md`](rules/README.md) — rules catalog
- [`rules/_template.md`](rules/_template.md) — per-rule template (incident link required)

## Reference

- [`reference/claude-code-patterns.md`](reference/claude-code-patterns.md) — Claude Code mechanisms (hooks, plugins, settings) we use
- [`reference/decode-agentic-coding-model.md`](reference/decode-agentic-coding-model.md) — DECODE operating model for agentic coding with mostly non-programmer repo owners
- [`reference/repo-inventory.md`](reference/repo-inventory.md) — current state of Claude Code adoption across the org
- [`reference/repo-readiness-checklist.md`](reference/repo-readiness-checklist.md) — how to judge whether a DECODE repo can absorb more agentic coding safely

## Templates (not under `docs/`)

- [`../templates/repo-setup/`](../templates/repo-setup/) — the per-repo PR content that ships the hardening (hooks, gates, CI workflow, CLAUDE.md)
- `../templates/repo-setup/.claude/skills/deslop/SKILL.md` — repo-local cleanup skill for final review-readiness passes

Productivity plugins (`feature-dev`, `code-simplifier`, `claude-md-management`, `superpowers`) come from Anthropic's official marketplace (`anthropics/claude-plugins-official`) — no DECODE-hosted marketplace needed.
