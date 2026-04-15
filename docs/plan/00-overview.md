# Overview

## The problem

DECODE has 26 GitHub repos and ~6 people touching code. Only **one** is a programmer by training (Willi). Roshan has some Python. Silke knows DAX but not Python. Everyone else is **vibe coding** — they describe what they want, Claude writes the code, they accept.

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

- A `.claude/.reviewer-clean` marker file exists, freshly written by the reviewer subagent in this session, referencing the current HEAD commit.
- The commit message contains `[override-reviewer: <reason>]`. The reason is public in `git log` forever.

(The marker check lives in `commit-msg`, not `pre-commit`, because only `commit-msg` receives the commit message as a file. `pre-commit` runs first for language lint but cannot read the intended message.)

The reviewer agent itself is shipped via the `decode-base` plugin — a subagent dispatched automatically by a Stop hook whenever the session touched substantive files, so for vibe coders the flow is transparent: model edits, Stop hook fires reviewer, reviewer returns findings or clean, model iterates or commits.

### Gate 2: Language + data gate at pre-commit

Runs in `pre-commit` (before the message is written, so it doesn't need the override marker):

- Python: `ruff check` on staged Python files. If `pytest` exists, run affected tests.
- Node: `eslint` on staged JS/TS. If `vitest` or similar, run changed.
- R: `lintr` on staged R files (soft-warn only; R coverage varies).
- Data outputs: if diff changes any committed CSV/JSON/HTML under `output/` or `dist/`, warn when the artifact is newer than any generator script in `scripts/` — catches "edited the artifact, forgot the generator."

Exit non-zero on failure. CI (GitHub Actions) runs the same lint gate as a bypass-safety net. If Gate 2 fails locally, the user can still commit via `[override-reviewer: reason]` in the commit message — but CI will still fail on the lint, catching the bypass at PR time.

## Delivery model

One PR per in-scope repo. The PR adds:

```
.claude/
  settings.json                 # declares marketplace, wires hooks, points at plugin
  hooks/
    reviewer-stop.sh            # Stop hook, dispatches reviewer proactively
    block-dangerous-git.sh      # PreToolUse(Bash), tier-aware
    block-env-writes.sh         # PreToolUse(Edit/Write)
.githooks/
  pre-commit                    # language-tier lint gate (ruff / eslint / lintr)
  commit-msg                    # reviewer-marker check + strong override detection
scripts/
  setup.sh                      # one-time: git config core.hooksPath .githooks
CLAUDE.md                       # 5 hard rules, pointing at the wiki for why
.gitignore                      # excludes .claude/.reviewer-clean / .reviewer-findings.md
.github/workflows/
  gate.yml                      # CI runs the language gate; files incidents on failure
```

The PR is generated from `templates/repo-setup/` in this repo and adapted minimally (tier = python / node / r, detected from repo contents). Kleo reviews and merges.

**On `git pull` by any user, zero further action is needed** for the `.claude/` hooks to fire inside Claude Code, and for CI to run the gate on push.

The only opt-in is `scripts/setup.sh` to wire `git config core.hooksPath .githooks` — which activates the local pre-commit hook. CI backstops users who never ran it.

## The third layer — productivity plugins (one prompt, then silent)

`.claude/settings.json` in each target repo declares the marketplace (this repo) and enables plugins:

```json
{
  "extraKnownMarketplaces": {
    "decode": {"source": {"source": "github", "repo": "implicitdiagnosticsandsolutions/decode-claude-wiki"}}
  },
  "enabledPlugins": {
    "decode-base@decode": true
  }
}
```

First time a user opens the repo in Claude Code, they see one prompt: *"This repo declares the `decode` marketplace and plugin `decode-base`. Install?"* One click, then silent forever. Updates ship on the next session.

`decode-base` currently contains: the reviewer subagent, an incident-logger skill, a plan-reviewer skill. More skills can be added to the plugin over time without any target-repo change.

## Incident capture — automated

Human curation of incidents is replaced by **auto-capture**. Signals that trigger an incident log entry:

1. **Override used** — pre-commit sees `[override-reviewer: reason]` in commit message, writes a GitHub issue titled `incident: YYYY-MM-DD <repo> override` with the reason, SHA, files changed.
2. **CI failure after push** — `.github/workflows/gate.yml` on failure opens an issue in `decode-claude-wiki` via `gh issue create`.
3. **Revert commit** — post-commit hook detects `revert` or `fix the previous` pattern, files an issue.
4. **Reviewer found issues** — logged in session summary; if user overrode, becomes an incident.

Issues land in this repo with label `incident`. Kleo's weekly task: triage, convert the real ones into `docs/incidents/YYYY-MM-DD_*.md` files, link to rules. That's all the human curation needed.

## Rollout status

Nothing deployed to other repos yet. 13 repos in scope. See [`03-rollout-status.md`](03-rollout-status.md) for the checklist.

Scope excludes: `strategy-suite`, `cmix-programmatic`, `questionnaire-editor` (supervisor's repos, already configured or handled separately), `datasystem-backend`, `datasystem-frontend`, `decoder_transformations` (Willi's, separate conversation), and legacy / empty / meta repos.

## Why this survives Kleo's departure

Every artifact needed to continue the rollout is in this repo:

- The template at `templates/repo-setup/` is copy-pasteable into any new repo.
- The plugin at `plugins/decode-base/` is the active code surface.
- The checklist at `03-rollout-status.md` tracks which repos are done.
- The open questions at `04-open-questions.md` are scoped and self-contained.

A replacement reads README.md → `docs/plan/00-overview.md` → `docs/plan/03-rollout-status.md` and knows what to do next.
