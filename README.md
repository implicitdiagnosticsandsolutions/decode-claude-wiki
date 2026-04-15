# decode-claude-wiki

Standards, rules, and rollout coordination for Claude Code usage across DECODE's GitHub org (`implicitdiagnosticsandsolutions`).

## What this repo is

The single source of truth for:

1. **The plan**: what Claude Code standards DECODE is rolling out, why, and in what order.
2. **The incident log**: real failures (code + data) that justify each hard rule. Rules without a linked incident get cut.
3. **The rules catalog**: the library of hard rules our repos enforce.
4. **The rollout status**: which repo is on what tier, what's done, what's next.
5. **The plugin marketplace** (future): productivity skills, slash commands, and shared snippets distributed to staff via `/plugin install`.

## What this repo is NOT

- Not a wiki that staff are expected to read. Nobody reads wikis.
- Not the enforcement layer. Enforcement lives in each repo as `.claude/settings.json`, `.claude/hooks/`, `.githooks/pre-commit` — committed and run automatically.
- Not tied to any specific person. The rollout is designed to survive a rotation of owners.

## How to navigate

| You are… | Start here |
|---|---|
| Reading for the first time | [`docs/plan/00-overview.md`](docs/plan/00-overview.md) |
| Owning the rollout | [`docs/plan/03-rollout-status.md`](docs/plan/03-rollout-status.md) |
| Adding a newly-discovered incident | [`docs/incidents/README.md`](docs/incidents/README.md) |
| Writing a new hard rule | [`docs/rules/README.md`](docs/rules/README.md) |
| Looking for what Claude Code config patterns we're borrowing | [`docs/reference/claude-code-patterns.md`](docs/reference/claude-code-patterns.md) |
| Auditing current Claude usage across the org | [`docs/reference/repo-inventory.md`](docs/reference/repo-inventory.md) |

## How this repo stays alive

- Every rollout wave updates `docs/plan/03-rollout-status.md` in the same commit that deploys the wave.
- Every new incident gets a file under `docs/incidents/` before the rule that cites it ships.
- Every rule change updates `docs/rules/` and points at the incident file that justifies it.
- The `CHANGELOG.md` at the root gets one line per meaningful change (dated).

## Doc index

- [`docs/INDEX.md`](docs/INDEX.md) — full map

## License / visibility

Currently public. See [`docs/plan/04-open-questions.md`](docs/plan/04-open-questions.md) — question #2 tracks whether this should move to private before the incident log fills with customer-sensitive material.
