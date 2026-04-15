---
date: YYYY-MM-DD
repo: repo-name
sha: abc1234 (if applicable)
rule: ../rules/NN_short-name.md
---

# Short description of what went wrong

## What happened

One factual paragraph. First-person is fine. No embellishment. No blame.

## What it cost

- Time: N hours
- Trust: customer / internal / none
- Money: €N (if applicable)
- Customer impact: what did the customer see or not see

## Root cause

One sentence. Technical or process.

## Rule it justifies

Link to `../rules/NN_short-name.md`. If the rule is new, draft it in the same commit as this incident file.

## What the fix was

Short description of the remediation at the time (code fix, process change, etc.). Not a future promise — past tense, what was actually done.

## Detection

How the incident was caught. Self-discovered? Client reported? CI? Reviewer agent? Staff member noticed? This is often the most useful field for future rules — it tells us which detection layer needs strengthening.
