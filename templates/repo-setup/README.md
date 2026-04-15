# repo-setup template

Copy-paste source for the hardening PR applied to each in-scope DECODE repo.

## What this template gives a target repo

```
.claude/
  settings.json                 # declares anthropics/claude-plugins-official marketplace,
                                # enables feature-dev + code-simplifier + claude-md-management + superpowers,
                                # wires the Claude Code hooks, pre-approves reviewer tool calls
  hooks/
    reviewer-stop.sh            # Stop: dispatch the reviewer subagent
    block-dangerous-git.sh      # PreToolUse(Bash): block destructive git
    block-env-writes.sh         # PreToolUse(Edit/Write): block .env / credentials
.githooks/
  pre-commit                    # language-tier gate (ruff/eslint/lintr + artifact freshness)
  commit-msg                    # reviewer-marker check + strong override detection
scripts/
  setup.sh                      # one-time: git config core.hooksPath .githooks
.github/workflows/
  gate.yml                      # CI runs the language gate; files incidents on failure
.gitignore                      # excludes .claude/.reviewer-clean and .reviewer-findings.md
CLAUDE.md.template              # rules import; target repo fills in the per-repo section
```

### Why the gate is split across two hooks

- **`pre-commit`** runs before the commit message is written. It can only lint staged files. Does not know the commit message.
- **`commit-msg`** runs after the message is written (git passes it as `$1`). This is the only reliable place to detect the `[override-reviewer: reason]` marker.

The original single-file design (reviewer check + language gate + override check all in pre-commit) does not work — git does not provide the commit message to pre-commit. Fixed in the current template.

## How to apply to a target repo

Minimal manual path (pilot):

```bash
TARGET=~/projects/decode/icat_results
cd <this-repo>
# Copy template (excluding CLAUDE.md.template; handle separately)
rsync -av --exclude README.md --exclude CLAUDE.md.template templates/repo-setup/ "$TARGET/"
# Template → real CLAUDE.md for target repo
cp templates/repo-setup/CLAUDE.md.template "$TARGET/CLAUDE.md"   # or merge with existing
chmod +x "$TARGET/.claude/hooks/"*.sh "$TARGET/.githooks/pre-commit" "$TARGET/scripts/setup.sh"
# In target repo: commit, push, open PR
cd "$TARGET"
git checkout -b feature/claude-code-hardening
git add .claude .githooks scripts .github CLAUDE.md
git commit -m "feat(claude-code): add DECODE hardening — reviewer gate, language gate, CI backstop"
git push -u origin feature/claude-code-hardening
gh pr create --title "Add DECODE Claude Code hardening" --body "..."
```

**Scripted path**: not yet implemented. The pilot is done manually with `rsync` per the block above. Once the pilot against `icat_results` is validated, a `scripts/apply-template.sh` helper will be added to this repo to generate per-repo PRs reproducibly. Until then, the rsync recipe is the canonical mechanism and is documented here for any future rollout owner.

## Tier detection

The pre-commit gate auto-detects tier from files present in the target repo:

| File | Tier |
|---|---|
| `pyproject.toml` / `setup.py` / majority `.py` files | `python` |
| `package.json` (and no Python markers) | `node` |
| `.Rproj` / majority `.R` files | `r` |
| None of the above, mostly Markdown / PPTX / XLSX | `docs` |

Tier only affects which lint / test commands run. The reviewer-marker check and dangerous-git block are tier-independent (with the dangerous-git scope narrower for data tiers — see the plugin's hook source).

## Updating the template

All target repos will drift. When this template changes:

1. Commit the change here with a `CHANGELOG.md` entry at the repo root.
2. For each already-hardened target repo, either:
   - (preferred) open a small PR that cherry-picks the relevant changes, or
   - (future) have a scheduled workflow in this repo open PRs automatically.

All productivity plugins are sourced from Anthropic's official marketplace (`anthropics/claude-plugins-official`) — updates come from upstream automatically on session start. DECODE does not maintain its own plugin marketplace.
