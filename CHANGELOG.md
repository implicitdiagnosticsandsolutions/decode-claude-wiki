# Changelog

One line per meaningful change. Dated.

## 2026-04-15

- **Scaffold committed** with v3 strategy.
- **Template validated** in `decode-claude-sandbox` pilot (11 of 13 scenarios green).
- **`decode-base` plugin removed.** It duplicated the repo-committed hooks and added no value. Hooks now live only in `templates/repo-setup/.claude/hooks/` and get deployed per-repo. All productivity skills come from Anthropic's official marketplace (`feature-dev`, `code-simplifier`, `claude-md-management`, `superpowers`). DECODE no longer publishes its own plugin marketplace.
- **Template fixes discovered during pilot**: corrected `$schema` URL; removed over-broad `permissions.deny` rules; moved reviewer marker from `.claude/.reviewer-clean` to `.decode-reviewer-clean` (Claude Code protects `.claude/` dir regardless of allow rules); fixed Bash permission pattern syntax (use `:*` suffix per docs); replaced Stop hook `exit 2 + stderr` with `{"decision": "block", "reason": "..."}` JSON to keep terminal UI quiet.
