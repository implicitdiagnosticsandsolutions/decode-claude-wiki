# Changelog

One line per meaningful change. Dated.

## 2026-04-19

- **Shared language gate added.** `templates/repo-setup/scripts/language-gate.sh` is now the single deterministic lint gate used by both local `pre-commit` and CI.
- **Artifact warning de-noised.** The old mtime heuristic was replaced with a narrower advisory warning: artifact changes under `output/` or `dist/` without a staged generator change under `scripts/`.
- **`deslop` brought into the template.** `templates/repo-setup/.claude/skills/deslop/SKILL.md` adds a repo-local advisory cleanup skill for final review-readiness passes before commit.
- **Docs aligned to shipped behavior.** Reviewer flow now describes the Stop hook honestly as a blocker that points the model at the reviewer procedure, not as an automatic subagent dispatch. Incident auto-capture docs now distinguish shipped CI-failure filing from planned override/revert capture.
- **DECODE-facing operating model added.** New reference docs capture a DECODE agentic coding model and a repo readiness checklist adapted from the stronger generic parts of the BrainSuite `claude-skills` repo.

## 2026-04-15

- **Scaffold committed** with v3 strategy.
- **Template validated** in `decode-claude-sandbox` pilot (11 of 13 scenarios green).
- **`decode-base` plugin removed.** It duplicated the repo-committed hooks and added no value. Hooks now live only in `templates/repo-setup/.claude/hooks/` and get deployed per-repo. All productivity skills come from Anthropic's official marketplace (`feature-dev`, `code-simplifier`, `claude-md-management`, `superpowers`). DECODE no longer publishes its own plugin marketplace.
- **Template fixes discovered during pilot**: corrected `$schema` URL; removed over-broad `permissions.deny` rules; moved reviewer marker from `.claude/.reviewer-clean` to `.decode-reviewer-clean` (Claude Code protects `.claude/` dir regardless of allow rules); fixed Bash permission pattern syntax (use `:*` suffix per docs); replaced Stop hook `exit 2 + stderr` with `{"decision": "block", "reason": "..."}` JSON to keep terminal UI quiet.
