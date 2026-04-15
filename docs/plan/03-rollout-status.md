# Rollout Status

**Kept current.** Every merge of a template PR into a target repo flips that row to ✅ in this file in the same commit (either in the wiki repo, or referenced from the target repo's PR body).

Last updated: 2026-04-15

---

## Pilot

| Gate | Status | Notes |
|---|---|---|
| v3 scaffold + `decode-base` plugin + `templates/repo-setup/` committed in this repo | 🟨 In progress | |
| Empirical verification of plugin auto-prompt flow in Claude Code | ⬜ Not started | Open once pilot PR lands |
| Pilot PR merged in `icat_results` | ⬜ Not started | Pilot target — small, data-analysis-tier, low blast radius |
| Pilot observed working for one Kleo + one Juliane session | ⬜ Not started | Validate zero-friction claim |

**No further target-repo rollouts until pilot is green.**

---

## Target repos (13)

| Repo | Owner | Tier | Status | Notes |
|---|---|---|---|---|
| `icat_results` | Juliane | python | ⬜ Pilot target | |
| `PBI_team_utils` | Silke | python | ⬜ Not started | Heavy Claude user, zero current config |
| `bi2pyhton2point` | Roshan | python | ⬜ Not started | Has hidden `.claude/claude.md`; migrate to root |
| `dashboard` | Silke | python | ⬜ Not started | Low Claude activity |
| `icat_app` | Juliane | python | ⬜ Not started | |
| `network_html` | Juliane | python | ⬜ Not started | |
| `videoextraction_app` | — | python | ⬜ Not started | |
| `synthetic-consumer` | supervisor | python | ⬜ Not started | Supervisor-authored but in scope |
| `new-research-paradigms` | supervisor | python | ⬜ Not started | |
| `Blob-Scanner-Azure` | — | python | ⬜ Not started | Azure Function |
| `PBI-URL-Updater` | — | python | ⬜ Not started | Azure Function |
| `DECODE-App-Substitution` | unknown | docs | ⬜ Not started | Docs-only, gate is reviewer-marker only |
| `velocity-planning` | supervisor | docs | ⬜ Not started | Docs-only repo |

---

## Excluded

| Repo | Reason |
|---|---|
| `strategy-suite` | Supervisor's flagship — already has mature `.claude/` config, out of this rollout |
| `cmix-programmatic` | Supervisor's — out of this rollout |
| `questionnaire-editor` | Supervisor's — out of this rollout |
| `datasystem-backend` | Willi's — separate conversation required before any rollout |
| `datasystem-frontend` | Willi's — separate conversation required before any rollout |
| `decoder_transformations` | Willi's — separate conversation required before any rollout |
| `01_simplicit`, `cloudstack`, `decode_pbi` | Legacy / archived |
| `project-calendar`, `velocity-troubleshooting`, `Database_Spielplatz` | Empty placeholders |
| `organize-github` | Org-admin tooling, not application code |
| `decode-claude-wiki` | This repo — it's the source, not a target |

---

## Legend

- ⬜ Not started
- 🟨 In progress
- ✅ Done
- ⏸️ Paused / blocked (reason in notes)
- ❌ Won't do (reason in notes)
