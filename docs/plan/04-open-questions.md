# Open Questions

Decisions still pending. Resolved questions moved to the bottom.

---

## Q1. Public or private repo?

**Context:** This repo is public. As it accumulates auto-captured incidents, some will reference client names, cost narratives, or internal decisions. That's sensitive.

**Options:** Public (easier onboarding) or private (protects incident log; only org members can `/plugin marketplace add` it, but that's everyone who matters).

**Owner:** Supervisor
**Blocks:** Not blocking — decide anytime before incident volume grows
**Recommendation:** Private. Switch anytime via `gh repo edit ... --visibility private`.
**Status:** ⬜

---

## Q2. Monitoring destination for the weekly signals?

**Context:** Three signals worth tracking after rollout: override count per repo per week, pre-commit gate failure count, CI failure rate delta pre/post rollout. Destination options:

- GitHub Issue (rolling, one per month) in this repo
- Slack channel via webhook
- Dashboard (e.g. Grafana, simple static HTML in this repo rendered nightly)

**Owner:** Supervisor + Kleo
**Blocks:** v4 monitoring work (deferred from v3)
**Status:** ⬜

---

## Q3. Reviewer agent latency — acceptable?

**Context:** The Stop-hook reviewer dispatches a subagent. Latency is typically 30–90s depending on diff size. For small vibe-coding sessions this adds a noticeable pause before commit.

**Owner:** Kleo (observes during pilot)
**Blocks:** Nothing — empirical question for the pilot
**Resolution:** Track latency during the `icat_results` pilot. If >60s median, consider switching to a lighter-weight reviewer (diff-only, skip codebase exploration) by default.
**Status:** ⬜ Track during pilot

---

## Q4. Strong override marker format — `[override-reviewer: reason]` or something shorter?

**Context:** Vibe coders copy-paste commit messages from Claude. A verbose marker is fine if clear; a short one (`!R: reason`) is easier to type but less obviously an override.

**Owner:** Supervisor
**Blocks:** pre-commit gate implementation (default in template)
**Recommendation:** `[override-reviewer: reason]`. Verbose on purpose — override should feel slightly weighty to use.
**Status:** ⬜ Defaulted to verbose; easy to change later

---

## Resolved

### ~~Q: Does the plugin auto-install mechanism work for arbitrary org repos?~~ Resolved 2026-04-15

**Answer:** Yes. `extraKnownMarketplaces` + `enabledPlugins` in project `.claude/settings.json` triggers a one-click install prompt on first session when the user trusts the folder. Updates ship from the marketplace repo on subsequent sessions. True zero-click auto-install is a feature request not yet shipped, but one prompt per user per machine is acceptable for our "git pull = hardened" goal.

See [`../reference/claude-code-patterns.md`](../reference/claude-code-patterns.md) for sources.

### ~~Q: Enterprise server-managed settings?~~ Deferred indefinitely

**Answer:** Not blocking. Repo-tracked artifacts remain the primary enforcement layer. If DECODE does turn out to be on Enterprise (unknown, supervisor check pending), server-managed settings become an additional layer on top — they don't invalidate the current design.

### ~~Q: How do non-programmers use this?~~ Answered by design

The design assumes vibe coding. The non-programmer interaction is: describe what you want → Claude edits → Stop hook runs reviewer → reviewer reports clean or findings → if findings, Claude iterates → commit. No direct tool invocation required. The plan for Juliane/Dirk-style contributors is no different from the plan for anyone else.

### ~~Q: Sentry/monitoring coverage across Wave 1 repos?~~ Scoped out of v3

The v2 proposal included Willi's Velocity repos in Wave 1. v3 excludes them entirely (Willi's repos are out of scope). So the Sentry question becomes: do Silke / Roshan / Juliane's repos need monitoring? For vibe coding, **yes** — but this is a v4 question, tracked in Q2.
