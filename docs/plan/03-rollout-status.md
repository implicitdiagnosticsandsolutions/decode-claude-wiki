# Rollout Status

**Kept current.** Every rollout PR updates this file in the same commit as the code change. Status of this file is ground truth for "where are we."

Last updated: 2026-04-15

---

## Pilot (gates before any wave ships)

| Gate | Status | Owner | Notes |
|---|---|---|---|
| This repo scaffolded with plan docs | ✅ Done (2026-04-15) | Supervisor | You are reading the scaffold |
| Incident log seeded with ≥5 real incidents | ⬜ Not started | Rollout owner | Mine `~/.claude/projects/-home-scheier-projects-decode/memory/feedback_*.md` + decoder/Velocity git history |
| Plugin marketplace mechanism verified | ⬜ Not started | Rollout owner | Half-day empirical test. See [`04-open-questions.md`](04-open-questions.md) Q1 |
| Hook templates extracted from `strategy-suite` | ⬜ Not started | Rollout owner | Copy `block-dangerous-git`, `monitor-ci`, `session-reflect`, `check-doc-index`, build `block-env-writes` (new) and `stop-invariants` (refactor) |
| DECODE base CLAUDE.md drafted (with incident refs) | ⬜ Not started | Rollout owner | Blocked on incident log |
| Willi looped in on Wave 1 scope | ⬜ Not started | Supervisor | Velocity is his repo, needs collaboration not imposition |

**Wave 1 cannot start until all Pilot gates are done.**

---

## Wave 1 — customer-facing (blast-radius priority)

| Repo | Tier | Status | Notes |
|---|---|---|---|
| `datasystem-backend` | product | ⬜ Not started | Java/Spring Boot. Willi's repo. Needs Java-appropriate `.githooks/pre-commit` gate. |
| `datasystem-frontend` | product | ⬜ Not started | Next.js. Closest analog to `strategy-suite`. Reuse most hook config. |
| `decoder_transformations` | data-r | ⬜ Not started | R + Python + Lambda. `data-r` tier hooks — minimal git lockdown. |

---

## Wave 2 — heavy internal users

| Repo | Tier | Status | Notes |
|---|---|---|---|
| `PBI_team_utils` | data-python | ⬜ Not started | Silke owns. 21 attributed Claude commits, zero CLAUDE.md today. |
| `bi2pyhton2point` | data-python | ⬜ Not started | Roshan owns. Has hidden `.claude/claude.md`; needs to move to root + hook config. |

---

## Wave 3 — Streamlit apps

| Repo | Tier | Status | Notes |
|---|---|---|---|
| `icat_app` | data-python | ⬜ Not started | Juliane owns. Port data-analysis rules from `social-media-analytics` reference. |
| `icat_results` | data-python | ⬜ Not started | Has CLAUDE.md already. |
| `network_html` | data-python | ⬜ Not started | Has CLAUDE.md already. |

---

## Wave 4 — the rest

| Repo | Tier | Status |
|---|---|---|
| `cmix-programmatic` | product | ⬜ |
| `questionnaire-editor` | product | ⬜ |
| `synthetic-consumer` | data-python | ⬜ |
| `new-research-paradigms` | data-python | ⬜ |
| `videoextraction_app` | data-python | ⬜ |
| `Blob-Scanner-Azure` | data-python | ⬜ |
| `PBI-URL-Updater` | data-python | ⬜ |
| `velocity-planning` | meta | ⬜ — has CLAUDE.md, just needs hooks |
| `dashboard` | meta | ⬜ — low Claude usage, low priority |
| `DECODE-App-Substitution` | meta | ⬜ — Power Automate docs repo |
| `organize-github` | meta | ⬜ — admin tooling |

---

## Retired / not in scope

| Repo | Reason |
|---|---|
| `strategy-suite` | Already configured — serves as the reference implementation for other product-tier repos |
| `01_simplicit`, `cloudstack`, `decode_pbi` | Legacy / archived |
| `project-calendar`, `velocity-troubleshooting`, `Database_Spielplatz` | Empty placeholders |

---

## Legend

- ⬜ Not started
- 🟨 In progress
- ✅ Done
- ⏸️ Paused / blocked (reason in notes)
- ❌ Won't do (reason in notes)
