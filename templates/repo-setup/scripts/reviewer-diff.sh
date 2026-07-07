#!/usr/bin/env bash
#
# DECODE reviewer diff bundle.
#
# Produces the payload that should be passed to the reviewer subagent.
# Default mode is --staged because the reviewer gate authorizes the exact
# content Git will commit. Use --all only for workspace diagnostics.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

MODE="${1:---staged}"

case "$MODE" in
  --staged)
    git -c core.quotepath=false diff \
      --cached --full-index --binary --find-renames --diff-filter=ACMRD HEAD 2>/dev/null || true
    ;;
  --all)
    {
      git -c core.quotepath=false diff \
        --full-index --binary --find-renames --diff-filter=ACMRD HEAD 2>/dev/null || true

      git -c core.quotepath=false ls-files --others --exclude-standard 2>/dev/null \
        | sort -u \
        | while IFS= read -r f; do
          [ -n "$f" ] || continue
          [ -f "$f" ] || continue
          printf '\n===== UNTRACKED FILE: %s =====\n' "$f"
          cat "$f"
          printf '\n===== END UNTRACKED FILE: %s =====\n' "$f"
        done
    }
    ;;
  *)
    echo >&2 "usage: scripts/reviewer-diff.sh [--staged|--all]"
    exit 2
    ;;
esac
