# Overview

## The problem

DECODE has ~26 GitHub repos and 5–6 active Claude Code users with uneven maturity. Heavy users (Silke, Roshan) have no `CLAUDE.md` or hooks at all. Customer-facing repos (Velocity backend/frontend) are just starting with Claude. The flagship product repo (`strategy-suite`) has mature config but it's tailored to one project.

Worse: the primary user (Chris, tech lead/co-founder) has self-identified as **very sloppy** in both code and data analysis. Past incidents confirm this — patched artifacts instead of generators, shipped numbers that didn't match client-facing HTMLs, claimed "it's in memory" when it wasn't.

The gap is not documentation. The gap is **deterministic enforcement** that works without anyone reading a wiki.

## The five layers

| Layer | Purpose | Reach | Enforcement |
|---|---|---|---|
| **1. Repo-tracked hooks + gates** (mandatory rails) | `.claude/settings.json`, `.claude/hooks/*.sh`, `.githooks/pre-commit` committed in each repo | Everyone who clones | Hard — commit fails / Claude tool call blocked |
| **2. Repo-tracked CLAUDE.md** | Shared base rules imported by every repo's `CLAUDE.md` | Everyone who opens the repo in Claude Code | Advisory to the model (but loaded automatically) |
| **3. Plugin marketplace** (productivity) | Shared skills, slash commands, templates distributed via this repo as a plugin marketplace | Opt-in via one command | Zero — it's a productivity boost, not a gate |
| **4. Incident log** | Real failures with date, cost, rule-they-justify | Referenced from rules | Foundation — rules without incidents get cut |
| **5. Rollout tracker** | Per-repo, per-wave status | Supervisor / rollout owner | Living document |

## Design principle

**Enforcement must be repo-tracked.** Anything that depends on a human running `/plugin install` or remembering to configure their machine is advisory at best. The hard rails are files committed in each repo.

**Plugins are productivity, not enforcement.** They make the work faster. They are not how we prevent sloppy behavior.

**Every hard rule must trace to a real incident.** A generic principle ("verify before claiming") gets ignored. A rule that reads *"Never claim 'it's in memory' without first reading it — cost: 2026-04-11, I told a user v10 reproduction command was in memory; it was in a README that isn't auto-loaded memory; user had to discover the gap"* sticks.

## What's implemented now

See [`03-rollout-status.md`](03-rollout-status.md). Short version: **nothing shipped yet, only the plan is here.** Pilot = build out incident log + verify plugin marketplace mechanism before touching other repos.

## What's next

Three gates before Wave 1:

1. Verify plugin marketplace mechanism works for an arbitrary GitHub-org repo (half-day).
2. Seed the incident log with 5–10 real DECODE incidents mined from existing memory files + git history.
3. Loop in Willi (Velocity owner) — his repos are Wave 1 by blast radius, which means collaboration, not imposition.

Then Wave 1 (Velocity). See [`03-rollout-status.md`](03-rollout-status.md) for the wave breakdown.
