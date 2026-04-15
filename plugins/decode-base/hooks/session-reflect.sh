#!/usr/bin/env bash
#
# decode-base plugin — PreCompact hook.
# Forces the model to save session learnings to memory before context
# is compressed.
#
# Based on the strategy-suite pattern.

set -euo pipefail

cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "PreCompact",
    "additionalContext": "SESSION REFLECTION: Before compacting, reflect and save to memory anything you learned this session that should survive into future sessions. Check: (1) Did any gate or pre-commit check fail, and what was the root cause? (2) Did you hardcode something that should use a shared module? (3) Did you create a new doc without indexing it in docs/INDEX.md? (4) Did CI fail after a push? (5) Did you override the reviewer gate? If any of these happened, save a feedback memory about what to do differently. The principle: engineer the environment, not the prompt."
  }
}
JSON
