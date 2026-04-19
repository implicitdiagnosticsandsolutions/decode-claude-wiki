# Incident Log

Incidents are the foundation of every enforced rule. A rule without a linked incident is a suggestion. A rule with one is a scar.

## Auto-capture (v3)

Going forward, incidents are partially auto-captured. The current template definitely auto-files CI-failure incidents. Other capture paths below are part of the intended design but are not fully shipped in `templates/repo-setup/` yet.

| Signal | Detected by | Auto-logged as |
|---|---|---|
| `[override-reviewer: reason]` in a commit message | PR audit today; issue filing still to be implemented | Advisory visibility in CI logs today |
| CI failure after push on `main` | `.github/workflows/gate.yml` in target repo | Issue labeled `incident ci-fail` |
| Commit containing `revert` or `fix the previous fix` | Planned post-commit or CI audit | Not yet shipped |
| Reviewer subagent returned findings that were overridden | Planned reviewer-session logging | Not yet shipped |

All issues land in this repo with the `incident` label and one of the sub-labels. Issue title format: `incident: YYYY-MM-DD <repo> <short description>`.

## Weekly triage (rollout owner)

Rollout owner (Kleo) opens this repo's issues filtered by `label:incident` once a week:

1. For each real incident, convert to `docs/incidents/YYYY-MM-DD_<repo>_<shortname>.md` using [`_template.md`](_template.md). Close the issue, link to the MD file in the close comment.
2. For each noise issue (test commit, obvious false positive), close with `label:noise` and a one-line reason.
3. If an incident justifies a new rule or tightening of an existing one, open an issue for that in `docs/rules/`.

## What counts as an incident

A committed file is an incident if:

- Something specific went wrong — a commit got reverted, a number was wrong, time was lost, trust was damaged.
- It's concrete enough to reconstruct — a date, a repo, a SHA, a named outcome.
- It points at a rule — the incident exists in the log because we want a rule to prevent repetition.

A generic preference ("we prefer `feat/` branch prefix") is a **convention**, not an incident. Conventions live in `docs/rules/` as CLAUDE.md-advisory rules with no incident anchor.

## Format

See [`_template.md`](_template.md). Filename: `YYYY-MM-DD_<repo>_<shortname>.md`.

## Why it stays honest

If the incident log contains fabricated or inflated incidents, the rules based on them get ignored the first time someone catches the exaggeration. Over-index on specificity — who, when, what commit, what it cost, measured in hours or dollars where possible.

## Seed — existing memory files

Pre-v3, the supervisor's machine holds ~20 `feedback_*.md` files under `~/.claude/projects/-home-scheier-projects-decode/memory/`. These are **not** in this repo. They're a personal memory store Claude reads at session start.

Rollout owner, one-time task during Pilot: pick 3–5 that read as clear incidents (candidates: `feedback-ssl.md`, `feedback_production_schema.md`, `feedback_ssm_url_encoding.md`, `feedback_module_type_trap.md`, `feedback-pbi-limitations.md`), convert to `docs/incidents/` files, and link to the relevant rules in `docs/rules/`. This seeds the catalog with real incidents so the first rules that ship are anchored.

Access: supervisor dumps the files to the rollout owner on request, or the rollout owner uses the supervisor's machine directly for the session.
