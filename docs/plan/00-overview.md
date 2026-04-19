# Overview

## The problem

DECODE currently has 27 GitHub repos and ~6 people touching code. Only **one** is a programmer by training (Willi). Roshan has some Python. Silke knows DAX but not Python. Everyone else is **vibe coding** — they describe what they want, Claude writes the code, they accept.

The supervisor (tech lead / co-founder) has self-identified as sloppy in code and data. Past incidents confirm it — patched artifacts instead of generators, shipped numbers that didn't match client-facing HTMLs, claimed "it's in memory" when it wasn't.

We are not rolling out coding standards to engineers. We are **harnessing vibe coding** so the model produces work that holds up — without asking anyone to read a wiki, install a plugin, or learn git.

## Constraints

| Constraint | Implication |
|---|---|
| No staff action beyond `git pull` | Hardening must ship inside the repo as committed files |
| No plugin-install nagging | Hooks committed in each repo fire automatically inside Claude Code; plugins are a separate one-prompt layer for skills only |
| Team is non-technical | Friction budget is near-zero. One Claude prompt is fine; a setup script is borderline; "learn git hooks" is too much |
| Primary user is sloppy | Gates must be hard (exit non-zero), bypasses must be visible in `git log` |
| Only Kleo + supervisor coordinate | No wave-by-wave conversations. One template PR per target repo, Kleo merges |

## The two hard gates (everything else is polish)

### Gate 1: Mandatory reviewer before commit

A **commit-msg hook** blocks any commit that touches substantive files (source code, generator scripts, data-output JSON/CSV/HTML, notebooks) unless one of:

- A `.decode-reviewer-clean` marker file exists, freshly written by the reviewer procedure in this session, binding to both the current HEAD commit and a content hash of `git diff HEAD` (any edit after review invalidates the marker).
- The commit message contains `[override-reviewer: <reason>]`. The reason is public in `git log` forever.

(The marker check lives in `commit-msg`, not `pre-commit`, because only `commit-msg` receives the commit message as a file. `pre-commit` runs first for language lint but cannot read the intended message.)

The reviewer agent is `feature-dev:code-reviewer` from Anthropic's official marketplace (`anthropics/claude-plugins-official`). A Stop hook in each target repo blocks session end when substantive files changed and no fresh marker exists. The model is then expected to run the reviewer procedure from `CLAUDE.md`, write the clean marker if appropriate, or surface findings.

### Gate 2: Language + data gate at pre-commit

Runs in `pre-commit` (before the message is written, so it doesn't need the override marker):

- Python: `ruff check` on staged Python files.
- Node: `eslint` on staged JS/TS when the repo already has `node_modules/.bin/eslint`.
- R: `lintr` on staged R files (soft-warn only; R coverage varies).
- Data outputs: if diff changes committed artifacts under `output/` or `dist/` but no generator change under `scripts/` is staged alongside them, warn — a heuristic for "edited the artifact, forgot the generator."

Exit non-zero on deterministic lint failure. CI (GitHub Actions) runs the same shared `scripts/language-gate.sh` logic as a bypass-safety net. Advisory warnings stay non-blocking locally and in CI.

## Delivery model

One PR per in-scope repo. The PR adds:

```
.claude/
  settings.json                 # declares marketplace, wires hooks, points at plugin
  hooks/
    reviewer-stop.sh            # Stop hook, blocks session end until reviewer procedure is handled
    block-dangerous-git.sh      # PreToolUse(Bash), tier-aware
    block-env-writes.sh         # PreToolUse(Edit/Write)
.githooks/
  pre-commit                    # language-tier lint gate (ruff / eslint / lintr)
  commit-msg                    # reviewer-marker check + strong override detection
scripts/
  setup.sh                      # one-time: git config core.hooksPath .githooks
CLAUDE.md                       # 5 hard rules, pointing at the wiki for why
.gitignore                      # excludes .decode-reviewer-clean / .decode-reviewer-findings.md
.github/workflows/
  gate.yml                      # CI runs the language gate; files incidents on failure
```

The PR is generated from `templates/repo-setup/` in this repo and adapted minimally (tier = python / node / r, detected from repo contents). Kleo reviews and merges.

**On `git pull` by any user, zero further action is needed** for the `.claude/` hooks to fire inside Claude Code, and for CI to run the gate on push.

The only opt-in is `scripts/setup.sh` to wire `git config core.hooksPath .githooks` — which activates the local pre-commit hook. CI backstops users who never ran it.

## The third layer — productivity plugins from Anthropic's official marketplace

`.claude/settings.json` in each target repo declares Anthropic's official marketplace and enables the plugins we use:

```json
{
  "extraKnownMarketplaces": {
    "claude-plugins-official": {"source": {"source": "github", "repo": "anthropics/claude-plugins-official"}}
  },
  "enabledPlugins": {
    "feature-dev@claude-plugins-official": true,
    "code-simplifier@claude-plugins-official": true,
    "claude-md-management@claude-plugins-official": true,
    "superpowers@claude-plugins-official": true
  }
}
```

Plugins install on first Claude Code session via CLAUDE.md-triggered install commands. Updates ship automatically thereafter. `feature-dev` provides the `code-reviewer` subagent used by the reviewer procedure and `code-architect` (plan review). `superpowers` adds TDD / brainstorming / verification skills. `code-simplifier` and `claude-md-management` are quality helpers.

DECODE does not publish its own plugin marketplace. All plugins come from upstream; DECODE-specific enforcement ships as repo-committed hooks.

## Incident capture — automated

Human curation of incidents is reduced, but not eliminated. The current template definitely auto-captures CI failures. Other incident signals are part of the intended design and should be treated as roadmap unless the template explicitly implements them.

1. **Override used** — today this is surfaced in PR audit output; issue filing is still to be implemented.
2. **CI failure after push** — `.github/workflows/gate.yml` on failure opens an issue in `decode-claude-wiki` via `gh issue create`.
3. **Revert commit** — planned post-commit or CI audit, not yet shipped in the current template.
4. **Reviewer found issues** — planned session logging path, not yet shipped in the current template.

Issues land in this repo with label `incident`. Kleo's weekly task: triage, convert the real ones into `docs/incidents/YYYY-MM-DD_*.md` files, link to rules. That's all the human curation needed.

## Rollout status

Nothing deployed to other repos yet. 13 repos in scope. See [`03-rollout-status.md`](03-rollout-status.md) for the checklist.

Scope excludes: `strategy-suite`, `cmix-programmatic`, `questionnaire-editor` (supervisor's repos, already configured or handled separately), `datasystem-backend`, `datasystem-frontend`, `decoder_transformations` (Willi's, separate conversation), and legacy / empty / meta repos.

## Why this survives Kleo's departure

Every artifact needed to continue the rollout is in this repo:

- The template at `templates/repo-setup/` is copy-pasteable into any new repo.
- The templates at `templates/repo-setup/` are the canonical sources for hooks, gates, and CLAUDE.md rules.
- The checklist at `03-rollout-status.md` tracks which repos are done.
- The open questions at `04-open-questions.md` are scoped and self-contained.

A replacement reads README.md → `docs/plan/00-overview.md` → `docs/plan/03-rollout-status.md` and knows what to do next.
