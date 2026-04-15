# Strategy (v2 — post-critique)

This is the current rollout strategy. v1 was drafted and reviewed; the critique is preserved in [`02-reviewer-critique.md`](02-reviewer-critique.md) and the changes from v1 → v2 are summarized there.

## Architectural decision: mandatory rails first, plugins second

| Role | Mechanism | Enforcement |
|---|---|---|
| **Mandatory rails** | Committed in each repo: `CLAUDE.md`, `.claude/settings.json`, `.claude/hooks/`, `.githooks/pre-commit`, one-time `git config core.hooksPath .githooks` in `scripts/setup.sh` | Runs for everyone who clones. Unavoidable. |
| **Productivity layer** | `decode-claude-wiki` plugin marketplace → skills, slash commands, shared snippets | Opt-in via `/plugin install` |
| **Knowledge layer** | `decode-claude-wiki/docs/` — incident log, rule catalog, reference | Reference material |

The plugin marketplace is a productivity boost. It does **not** carry enforcement. Every repo's own `.claude/hooks/` and `.githooks/pre-commit` are what make the standards real.

## Tiered hooks (two profiles, not one)

Scope the git-safety hook differently for product code vs data exploration. `git checkout .` / `git restore .` are dangerous in a Next.js repo and routine in a scratch analysis repo.

| Hook | Product tier (NextJS / Java / core products) | Data tier (Python data / R) |
|---|---|---|
| `block-dangerous-git.sh` | Full: `--force`, `reset --hard`, `checkout .`, `restore .`, `clean -f`, `branch -D` | Narrow: `--force`, `reset --hard`, `clean -f`, `branch -D` only |
| `block-env-writes.sh` | Yes (blocks writes to `.env*`, `credentials*`, `*.pem`) | Yes |
| `monitor-ci.sh` | Yes (async-rewake on `git push`) | Repo-specific |
| `session-reflect.sh` | Yes (PreCompact — force memory save) | Yes |
| `stop-invariants.sh` | Yes (Stop — run repo's invariant check) | Yes |
| `check-doc-index.sh` | Yes | Optional |

Two hook profiles shipped as templates, one per tier. Repos pick their tier via `scripts/setup.sh`.

## Per-repo tier assignment

| Tier | Repos |
|---|---|
| **product** | `strategy-suite`, `datasystem-backend`, `datasystem-frontend`, `questionnaire-editor`, `cmix-programmatic` |
| **data-python** | `PBI_team_utils`, `bi2pyhton2point`, `synthetic-consumer`, `icat_app`, `icat_results`, `network_html`, `videoextraction_app`, `new-research-paradigms`, `Blob-Scanner-Azure`, `PBI-URL-Updater` |
| **data-r** | `decoder_transformations` |
| **docs / meta** | `velocity-planning`, `decode-claude-wiki`, `organize-github` |

## Rollout waves (blast-radius ordered)

| Wave | Repos | Rationale |
|---|---|---|
| **Pilot** | `decode-claude-wiki` (this repo), `strategy-suite` (already configured) | Can't roll rules without an incident log. Must verify plugin marketplace mechanism. |
| **Wave 1** (parallel) | `datasystem-backend`, `datasystem-frontend`, `decoder_transformations` | **Customer-facing** — highest blast radius. Willi + rollout owner collaborate. |
| **Wave 2** | `PBI_team_utils`, `bi2pyhton2point` | Heavy Claude usage (Silke, Roshan) + zero guardrails today. Internal tooling. |
| **Wave 3** | `icat_app`, `icat_results`, `network_html` | Streamlit apps. Port data-analysis rules from `social-media-analytics` reference. |
| **Wave 4** | `cmix-programmatic`, `questionnaire-editor`, `synthetic-consumer`, Azure Functions, rest | Lower-risk standardization pass. |

## Incident log — the foundation

Generic rules are wiki-grade noise. Real rules must reference real failures.

Before any rollout wave, the incident log must contain at least one DECODE incident per hard rule being enforced. Candidate sources already visible in memory files:

- `feedback-ssl.md` — SSL / `sslmode=require` mandatory since PG17 upgrade (misleading "password authentication failed" without it)
- `feedback_production_schema.md` — dual Prisma schema trap
- `feedback_territory_colors.md` — territory color drift
- `feedback_ssm_url_encoding.md` — SSM URL encoding gotcha
- `feedback_module_type_trap.md` — module type matching pitfall
- `feedback_check_deploy.md` — always check CI after push
- `feedback-pbi-limitations.md` — PBI tool limitations

Each becomes one file under `docs/incidents/`. Rules cite them with (date, repo, SHA, cost).

## CLAUDE.md sizing — the actual constraint

No fixed line limit. Constraint: **every rule must be specific** — either (a) linked to a real incident with date and SHA, or (b) naming a concrete file path it enforces. Vague rules get cut, period.

`strategy-suite/CLAUDE.md` is 623 lines and works *because* it's specific. A 150-line CLAUDE.md of platitudes is worse than a 600-line one anchored in reality.

## Bypass — the honest picture

The enforcement layers have different bypass risk. Stating it plainly:

| Layer | Bypass possible? | Notes |
|---|---|---|
| `.claude/settings.json` hooks | **No** (if user works in Claude Code) | Loaded automatically when a user opens the repo in Claude Code. Fires for every tool call. No install step. |
| `.claude/settings.json` hooks (user not in Claude Code) | **N/A** | Hooks only exist inside Claude Code sessions. Someone editing via vim + terminal isn't bound by them at all. |
| `.githooks/pre-commit` | **Yes, until user runs `scripts/setup.sh`** | Git only runs hooks from `.githooks/` if `core.hooksPath` is set. This is one-time per clone, documented in the repo README, but it is opt-in. |
| CI gate | **Not once it's wired** | Runs the same gate scripts on GitHub Actions. Cannot be bypassed on merges to protected branches. |

**Current reality:** CI gates are not wired in any DECODE repo yet. Until CI runs the same scripts as `.githooks/pre-commit`, a user who skips `scripts/setup.sh` has no hard rails during that time window — only the in-Claude-Code `.claude/` hooks, which only fire when they're using Claude Code.

**Mitigation sequence:**
1. Ship `.claude/settings.json` hooks in each wave — immediate hard rail for Claude Code sessions.
2. Ship `.githooks/pre-commit` + `scripts/setup.sh` — opt-in hard rail at commit time.
3. Wire CI to run the same gate scripts — closes the `scripts/setup.sh`-bypass gap.
4. Protect `main` on each repo so CI must pass — makes bypass impossible at merge.

Steps 3 and 4 are not in the Pilot. They are a follow-up wave after Wave 1 ships the base gate scripts. Until then, the bypass risk for `.githooks/pre-commit` is real and not papered over.

## Definition of done for Wave N

A repo is "Wave N complete" when:

1. `.claude/settings.json` with the tier-appropriate hook set is committed.
2. `.claude/hooks/*.sh` are committed and executable.
3. `CLAUDE.md` imports the DECODE base rules and adds repo-specific ones.
4. `.githooks/pre-commit` runs the tier-appropriate gate.
5. `scripts/setup.sh` installs the hook path.
6. A sanity PR has been merged that proves the hooks fire correctly.
7. [`03-rollout-status.md`](03-rollout-status.md) is updated in the same commit as the rollout PR.

## What v1 → v2 changed

See [`02-reviewer-critique.md`](02-reviewer-critique.md). Summary:

- Architecture inverted: plugins were the center in v1, repo-tracked artifacts are the center in v2.
- Rollout order flipped: Velocity (customer-facing) moved ahead of Silke's PBI utils (internal).
- Hook scoping split: product vs data tier — `checkout .` was overreach for data repos.
- CLAUDE.md line limit dropped in favor of a specificity criterion.
- Incident log made a hard prerequisite for any rollout wave.
