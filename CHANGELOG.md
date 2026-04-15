# Changelog

One line per meaningful change. Dated.

## 2026-04-15

- Scaffold committed with v3 strategy. No target repos hardened yet.
- Plan docs, `decode-base` plugin, `templates/repo-setup/` template, `.claude-plugin/marketplace.json` all in place.
- Two-round reviewer critique applied before first commit: marker moved to `commit-msg` hook (pre-commit cannot read commit message), reviewer agent granted `Write` tool (was missing — marker file couldn't be written), `.gitignore` added (marker files would have polluted every commit), `rm -rf /` pattern anchored (was blocking legitimate `rm -rf /tmp/foo`), `git status` parsing in Stop hook replaced with rename-safe detection.
