#!/usr/bin/env bash
#
# decode-base plugin — Stop hook that dispatches the reviewer subagent
# when the session touched substantive files.
#
# This version ships via the plugin. The target repo also has its own
# local copy at .claude/hooks/reviewer-stop.sh which is what fires first
# (committed in the repo, loads on git pull with zero prompt). The plugin
# copy is the canonical version — updates flow from decode-claude-wiki.
#
# Contract:
# - Substantive files = source code (.py, .ts, .tsx, .js, .jsx, .R, .r,
#   .java, .sql), generator scripts in scripts/, and data outputs
#   under output/ or dist/.
# - If any of these are modified vs HEAD (staged, unstaged, or untracked),
#   dispatch the reviewer subagent via hookSpecificOutput asking Claude
#   to run the Agent tool with subagent_type=reviewer.
# - The reviewer writes .claude/.reviewer-clean or .claude/.reviewer-findings.md.
#
# Exit codes:
# - 0: no substantive changes; nothing to do.
# - 0 with hookSpecificOutput: substantive changes detected; ask Claude to run reviewer.

set -euo pipefail

# Only run in a git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  exit 0
fi

cd "$(git rev-parse --show-toplevel)"

# Substantive file patterns (source code, generators, data outputs)
PATTERNS='\.(py|ts|tsx|js|jsx|R|r|java|sql)$|^scripts/|^output/|^dist/'

# Collect all modified files — staged, unstaged, and untracked — normalized
# so rename targets and paths with spaces are handled correctly. Uses the
# same detection approach as the commit-msg gate for consistency.
MODIFIED=$( {
  git diff --name-only --diff-filter=ACMRD HEAD 2>/dev/null || true
  git ls-files --others --exclude-standard 2>/dev/null || true
  git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || true
} | sort -u )

if ! echo "$MODIFIED" | grep -qE "$PATTERNS"; then
  # No substantive changes
  exit 0
fi

# Check if reviewer already ran cleanly this session (marker exists and matches current HEAD)
MARKER=".claude/.reviewer-clean"
if [ -f "$MARKER" ]; then
  MARKED_SHA=$(awk 'NR==1 {print $1}' "$MARKER" 2>/dev/null || echo "")
  CURRENT_SHA=$(git rev-parse HEAD 2>/dev/null || echo "initial")
  if [ "$MARKED_SHA" = "$CURRENT_SHA" ]; then
    # Fresh clean marker — no action needed
    exit 0
  fi
fi

# Stop hook schema per Claude Code docs supports top-level fields only
# (continue, stopReason, decision, reason, systemMessage) — NOT the
# hookSpecificOutput+additionalContext envelope used by PreToolUse/PostToolUse.
# Use exit 2 + stderr: that pipes the message into the model's context and
# blocks the Stop so the model processes the instruction before ending the
# session. Once the reviewer writes the marker, the next Stop check above
# matches HEAD and exits 0 cleanly.

cat >&2 <<'EOF'
REVIEWER REQUIRED: This session modified substantive files (source code, generators, or data outputs). Before the user commits, dispatch the `reviewer` subagent via the Agent tool (subagent_type: reviewer). The reviewer reads the git diff and writes either .claude/.reviewer-clean (a single line with HEAD SHA and timestamp) or .claude/.reviewer-findings.md. The commit-msg hook blocks commits without a fresh .claude/.reviewer-clean marker matching HEAD, unless the commit message contains [override-reviewer: reason]. Do not commit until the reviewer has run or an override is explicitly justified.
EOF
exit 2
