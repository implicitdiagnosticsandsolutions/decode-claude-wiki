# Strategy v3 — Harness the Vibe

Supersedes v2. v2 is preserved in [`02-reviewer-critique.md`](02-reviewer-critique.md) as historical context.

## What changed from v2

- **Cut the wave model.** No Wave 1 / Wave 2. Replaced with per-repo PRs applied from a template.
- **Cut manual incident mining.** Replaced with auto-capture from commit messages + CI failures + reverts.
- **Cut the "rollout owner talks to each team" step.** Kleo + supervisor coordinate; target-repo owners see a PR in their inbox.
- **Verified the plugin auto-prompt mechanism.** `extraKnownMarketplaces` + `enabledPlugins` in project-level settings.json triggers a one-click install prompt on first session. Hooks committed directly in each repo fire with zero prompts.
- **Added strong override.** `[override-reviewer: reason]` in commit message required to bypass the reviewer gate. Bypasses are visible in `git log` forever.
- **Tier-aware hooks.** The `block-dangerous-git.sh` hook has a narrower scope for data repos (no `checkout .` / `restore .` blocking) and a wider scope for product repos.

## Two hard gates (enforced)

### 1. Reviewer marker before commit

A `commit-msg` git hook refuses commits that touch substantive files unless:

- `.claude/.reviewer-clean` exists and references the current HEAD (freshly written by the reviewer subagent this session), OR
- Commit message contains `[override-reviewer: <reason>]`.

`commit-msg` (not `pre-commit`) is used because git passes the commit message file only to `commit-msg` — the override marker cannot be detected in `pre-commit`.

The reviewer subagent is shipped via the `decode-base` plugin. A Stop hook in each target repo dispatches it automatically when a session touched substantive files. So for vibe coders, the flow is invisible — model edits → Stop hook runs reviewer → reviewer writes marker if clean → commit succeeds.

**Override is strong, not weak.** An env var would be invisible; the commit-message marker shows up in `git log --grep="override-reviewer"` — every bypass is auditable forever.

### 2. Language + data gate

`pre-commit` hook runs these (before the reviewer marker check in `commit-msg`):

| Detection | Gate |
|---|---|
| Staged `.py` files | `ruff check`; if `pytest.ini`/`pyproject.toml` present, `pytest -x` on affected paths |
| Staged `.ts` / `.tsx` / `.js` | `eslint`; if `vitest.config.*`, `vitest run --changed` |
| Staged `.R` / `.r` | `lintr` (skipped if not installed — soft fail with warning, not a gate) |
| Staged artifact under `output/` or `dist/` (`.csv`, `.json`, `.html`, `.xlsx`) | Last-modified time of the artifact must be newer than the last-modified time of any generator script in `scripts/` — catches "edited the artifact, forgot the generator" |

Exit non-zero on any gate failure. CI runs the same script as a bypass-safety net for users who skipped `scripts/setup.sh`.

## Delivery mechanics

### Per-repo PR content

Every in-scope repo gets the same PR structure, generated from `templates/repo-setup/` in this repo:

```
.claude/
  settings.json              # ← committed, fires on git pull inside Claude Code
  hooks/
    reviewer-stop.sh
    block-dangerous-git.sh
    block-env-writes.sh
.githooks/
  pre-commit                 # ← language lint (ruff / eslint / lintr + artifact freshness)
  commit-msg                 # ← reviewer-marker + [override-reviewer: ...] detection
scripts/
  setup.sh                   # ← one-time: git config core.hooksPath .githooks
CLAUDE.md                    # ← 5 hard rules, pointing at this wiki for the why
.gitignore                   # ← excludes .claude/.reviewer-clean / .reviewer-findings.md
.github/workflows/
  gate.yml                   # ← CI runs language gate; files incident issue on failure
```

Plus one required conversation at the top of `CLAUDE.md` telling future sessions to run `scripts/setup.sh` if they haven't yet.

### Target repos (13)

See [`03-rollout-status.md`](03-rollout-status.md).

### PR origination

- The pilot PR against `icat_results` is built directly from this repo's template.
- Subsequent PRs are generated via a script (`scripts/apply-template.sh <target-repo-path> <tier>`) that copies the template, adapts the language tier, and opens a branch.
- Kleo runs the script, reviews the PR, merges. Supervisor is looped in only for PRs against repos they own directly.

## Automation — what's in, what's out

### In v3

- `decode-base` plugin published through this repo as a marketplace
- Reviewer subagent + plan-reviewer skill + incident-logger skill in the plugin
- Stop hook that proactively dispatches the reviewer
- Pre-commit gate with reviewer-marker + language checks
- CI backstop
- Auto-incident filing to this repo on override / CI fail / revert

### Deferred to v4+

- Monitoring dashboard (override rate, gate-failure rate, CI failure delta)
- Auto-generation of new target-repo PRs via scheduled workflow
- Server-managed settings (if supervisor confirms Enterprise plan)
- Cross-repo reviewer caching (reviewer results shared between repos when patterns match)

## Tiering

Only one axis matters: **what language is the repo**. Detection is automatic from file presence.

| Tier | Detection | Pre-commit gate | Git lockdown scope |
|---|---|---|---|
| `python` | `pyproject.toml` or `setup.py` or mostly `.py` files | `ruff` + `pytest` | Narrow: `--force`, `reset --hard`, `clean -f`, `branch -D` only |
| `node` | `package.json` | `eslint` + `vitest` | Wide: above + `checkout .`, `restore .` |
| `r` | `.Rproj` or mostly `.R` files | `lintr` | Narrow |
| `mixed` | multiple of above | Run all applicable gates | Narrow |
| `docs` | no source files (Markdown / PPTX / etc.) | No gate, just reviewer marker | Narrow |

## Definition of done — per repo

A target repo is done when:

1. The PR from `templates/repo-setup/` is merged into its default branch.
2. A test commit proves the reviewer-marker pre-commit gate fires.
3. The repo's row in [`03-rollout-status.md`](03-rollout-status.md) flips to ✅ in the same commit that merges the PR (commit message in the wiki repo or part of the target-repo merge PR body).

No staff training. No wiki reading. Just the PR.
