# decode-claude-wiki

Standards, rules, plugin marketplace, and rollout coordination for Claude Code usage across DECODE's GitHub org (`implicitdiagnosticsandsolutions`).

## What this repo is

1. **A template for hardening any DECODE repo.** `templates/repo-setup/` is copy-pasted into each in-scope repo as a single PR, adding `.claude/` hooks, `.githooks/{pre-commit,commit-msg}` gates, `CLAUDE.md`, and `.github/workflows/gate.yml` CI backstop.
2. **The rollout tracker + open decisions.** `docs/plan/` has the current strategy, rollout status per repo, and open questions.
3. **The incident log.** `docs/incidents/` — real failures that justify each rule. Auto-captured from override markers, CI failures, and revert commits going forward.
4. **The rules catalog.** `docs/rules/` — the library of hard rules the target repos enforce.

Target repos install productivity plugins (`feature-dev`, `code-simplifier`, `claude-md-management`, `superpowers`) directly from Anthropic's official marketplace. This repo does not publish its own plugin marketplace — hooks ship as repo-committed files, plugins come from upstream.

## What this repo is NOT

- Not a wiki that staff are expected to read. Vibe coders don't read wikis.
- Not the enforcement layer. Enforcement lives **inside each target repo** as committed `.claude/` hooks + `.githooks/pre-commit` + CI workflow.
- Not tied to any single person. A successor reads this README and `docs/plan/00-overview.md` and can continue without context transfer.

## How to navigate

| You are… | Start here |
|---|---|
| Reading for the first time | [`docs/plan/00-overview.md`](docs/plan/00-overview.md) |
| Owning the rollout | [`docs/plan/03-rollout-status.md`](docs/plan/03-rollout-status.md) + [`templates/repo-setup/README.md`](templates/repo-setup/README.md) |
| Reviewing an auto-captured incident | [`docs/incidents/README.md`](docs/incidents/README.md) |
| Editing reviewer behavior | Adjust the "Reviewer procedure" section in `templates/repo-setup/CLAUDE.md.template`. The reviewer itself is `feature-dev:code-reviewer` from `anthropics/claude-plugins-official`, not a DECODE-owned agent. |
| Adding a hook to all target repos | Edit the relevant file under `templates/repo-setup/.claude/hooks/` and `.githooks/`, then open a PR against each target repo to sync the change. |
| Reading the design history | [`docs/plan/02-reviewer-critique.md`](docs/plan/02-reviewer-critique.md) |

## Doc index

- [`docs/INDEX.md`](docs/INDEX.md) — full map

## Repo structure

```
decode-claude-wiki/
├── templates/
│   └── repo-setup/                   # copy-paste source for per-repo PRs
│       ├── .claude/                  # settings.json + hooks (repo-committed)
│       ├── .githooks/                # pre-commit + commit-msg gates
│       ├── .github/workflows/        # CI backstop
│       ├── scripts/setup.sh          # core.hooksPath wiring
│       ├── .gitignore                # excludes .decode-reviewer-* files
│       └── CLAUDE.md.template        # base rules + reviewer procedure
├── docs/
│   ├── INDEX.md
│   ├── plan/
│   │   ├── 00-overview.md
│   │   ├── 01-strategy.md            # current strategy (v3)
│   │   ├── 02-reviewer-critique.md   # v1→v2→v3 history
│   │   ├── 03-rollout-status.md
│   │   └── 04-open-questions.md
│   ├── incidents/
│   ├── rules/
│   └── reference/
├── CHANGELOG.md
└── README.md
```

## Visibility

Currently public. See [`docs/plan/04-open-questions.md`](docs/plan/04-open-questions.md) Q1 on whether to switch to private as the incident log fills.
