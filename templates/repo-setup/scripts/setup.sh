#!/usr/bin/env bash
#
# DECODE repo setup — run once after cloning or pulling this hardening PR.
# Wires the .githooks/pre-commit into git.
#
# Idempotent: safe to re-run.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

# Wire the hooks path
if [ -d ".githooks" ]; then
  git config core.hooksPath .githooks
  echo "[setup] core.hooksPath set to .githooks"
else
  echo "[setup] WARN: .githooks/ not found — pre-commit gate will not run"
  exit 1
fi

# Ensure hooks are executable
chmod +x .githooks/* 2>/dev/null || true
chmod +x .claude/hooks/*.sh 2>/dev/null || true

echo "[setup] Done. On your next commit, the reviewer-marker + language gate will run."
echo "[setup] To bypass (with audit trail): git commit -m '... [override-reviewer: reason]'"
