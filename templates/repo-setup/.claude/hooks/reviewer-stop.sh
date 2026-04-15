#!/usr/bin/env bash
#
# decode-base plugin — Stop hook that asks the parent model to run the
# feature-dev:code-reviewer subagent and write a marker for the commit-msg
# gate to check.
#
# We do not maintain our own reviewer. feature-dev:code-reviewer from
# claude-plugins-official is better-built (confidence filter, CLAUDE.md
# adherence, official Anthropic-maintained) so we compose on top:
#   - The reviewer itself is third-party (Sonnet, read-only).
#   - The parent model wraps it: fetches the diff, dispatches the reviewer,
#     writes the marker based on the outcome.
#   - The commit-msg hook is the deterministic gate (checks for marker or
#     override).
#
# This hook is repo-committed (in .claude/hooks/) so it fires with zero
# prompt on git pull. Plugin-install is optional productivity layer.
#
# Exit codes:
# - 0: no substantive changes, or fresh marker already exists.
# - 2 + stderr: substantive changes without marker — block stop, pipe
#   instruction to the model.

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

cd "$(git rev-parse --show-toplevel)"

PATTERNS='\.(py|ts|tsx|js|jsx|R|r|java|sql)$|^scripts/|^output/|^dist/'

MODIFIED=$( {
  git diff --name-only --diff-filter=ACMRD HEAD 2>/dev/null || true
  git ls-files --others --exclude-standard 2>/dev/null || true
  git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || true
} | sort -u )

if ! echo "$MODIFIED" | grep -qE "$PATTERNS"; then
  exit 0
fi

# Fresh marker already exists?
MARKER=".decode-reviewer-clean"
if [ -f "$MARKER" ]; then
  MARKED_SHA=$(awk 'NR==1 {print $1}' "$MARKER" 2>/dev/null || echo "")
  CURRENT_SHA=$(git rev-parse HEAD 2>/dev/null || echo "initial")
  if [ "$MARKED_SHA" = "$CURRENT_SHA" ]; then
    exit 0
  fi
fi

# Ask the parent model to orchestrate the review.
# Stop hook schema supports stderr + exit 2 to block stop and pipe to model.
cat >&2 <<'EOF'
REVIEWER REQUIRED: This session modified substantive files. Before the session ends (or the user commits), run the feature-dev:code-reviewer subagent and produce a marker the commit-msg gate can check.

Steps (do all of these, in order):

1. Run `git diff HEAD` via Bash and keep the output in context.
2. Dispatch the `feature-dev:code-reviewer` subagent via the Agent tool. Pass the diff as context and instruct it to review only the changes, skipping codebase exploration beyond the diff unless a specific blocker needs confirmation. Tell the reviewer: target latency under 90 seconds; report only blocking issues (confidence ≥ 80).
3. When the reviewer returns:
   a. If it reports NO blocking issues (confidence ≥ 80), run `git rev-parse HEAD` via Bash, then Write `.decode-reviewer-clean` with exactly one line: `<HEAD-SHA> <ISO-8601-UTC-timestamp>`.
   b. If it reports blocking issues, Write `.decode-reviewer-findings.md` with the list. Do NOT write `.reviewer-clean`.
4. Return. If the user then attempts to commit, the commit-msg hook reads the marker and either allows or blocks the commit. Without a marker and without `[override-reviewer: reason]` in the commit message, the commit is blocked.

If the feature-dev plugin is not installed in this repo, stop and tell the user to run `/plugin install feature-dev@claude-plugins-official` — this is required for the reviewer subagent to be available.
EOF
exit 2
