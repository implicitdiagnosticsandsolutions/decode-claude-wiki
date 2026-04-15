# decode-claude-wiki

Standards, rules, plugin marketplace, and rollout coordination for Claude Code usage across DECODE's GitHub org (`implicitdiagnosticsandsolutions`).

## What this repo is

1. **A Claude Code plugin marketplace.** The `decode-base` plugin (reviewer subagent, incident-logger skill, plan-reviewer skill) is published from `plugins/decode-base/` and installed into target repos via one prompt on first Claude Code session.
2. **A template for hardening any DECODE repo.** `templates/repo-setup/` is copy-pasted into each in-scope repo as a single PR, adding `.claude/` hooks, `.githooks/pre-commit` gate, `CLAUDE.md`, and `.github/workflows/gate.yml` CI backstop.
3. **The rollout tracker + open decisions.** `docs/plan/` has the current strategy, rollout status per repo, and open questions.
4. **The incident log.** `docs/incidents/` — real failures that justify each rule. Auto-captured from override markers, CI failures, and revert commits going forward.
5. **The rules catalog.** `docs/rules/` — the library of hard rules the target repos enforce.

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
| Editing the reviewer agent | [`plugins/decode-base/agents/reviewer.md`](plugins/decode-base/agents/reviewer.md) |
| Adding a hook to all target repos | [`plugins/decode-base/hooks/`](plugins/decode-base/hooks/) + update `templates/repo-setup/.claude/settings.json` |
| Reading the design history | [`docs/plan/02-reviewer-critique.md`](docs/plan/02-reviewer-critique.md) |

## Doc index

- [`docs/INDEX.md`](docs/INDEX.md) — full map

## Repo structure

```
decode-claude-wiki/
├── .claude-plugin/
│   └── marketplace.json              # catalog for Claude Code
├── plugins/
│   └── decode-base/                  # the plugin distributed to target repos
│       ├── plugin.json
│       ├── README.md
│       ├── hooks/                    # hooks added by plugin install
│       └── agents/                   # reviewer subagent
├── templates/
│   └── repo-setup/                   # copy-paste source for per-repo PRs
│       ├── .claude/
│       ├── .githooks/
│       ├── .github/
│       ├── scripts/
│       └── CLAUDE.md.template
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
