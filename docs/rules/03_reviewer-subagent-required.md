---
number: 03
title: reviewer-subagent-required
tiers: [product, data-python, data-r]
enforcement: reviewer-stop.sh + commit-msg gate
justification: proactive-risk
incidents: []
status: shipped
---

# 03. Dispatch the reviewer subagent before committing non-trivial work

## Rule statement

For any change that modifies source code, generator scripts, methodology, data outputs, or architectural invariants, dispatch the `feature-dev:code-reviewer` subagent before committing. The Stop hook blocks session end until the reviewer has run on the pending diff; the commit-msg hook blocks the commit until a fresh `.decode-reviewer-clean` marker is written.

Small mechanical changes are allowed to use the fast path in `CLAUDE.md`: skip brainstorming, spec documents, multi-step implementation plans, and subagent-driven development when the change is a localized pattern copy or small fix with no design uncertainty. The reviewer requirement still applies once, over the final diff.

## Why

`justification: proactive-risk`. This is the foundation of Gate 1 (Golden Rule). An agent reviewing its own work has well-documented blind spots: assumption-drift between spec and implementation, missed edge cases in its own code, overconfident summaries. An independent reviewer — different model session, constrained to review-only, findings-first — materially raises the floor on what ships.

DECODE has not had its own documented incident yet; the rule is adopted proactively because:

1. The target cost of the review step is sub-90 seconds per final diff.
2. The blast radius of an agent-authored bug reaching master is high — especially for a non-technical team that does not routinely PR-review each other.
3. The enforcement mechanism (marker file bound to diff hash) is tamper-resistant by construction; agents cannot silently bypass it.

The rule is not meant to turn every small code edit into a heavy design workflow.
For low-uncertainty pattern-copy tasks, use one direct implementation pass, run
focused verification, and dispatch one final reviewer pass. Do not multiply the
reviewer gate by forcing "one commit per micro-task."

If a real DECODE incident materialises later (reviewer caught X, reviewer would have caught Y), add it to `incidents:` and flip `justification` to `incident`.

## How to apply

On any session that has modified substantive files (`.py`, `.ts`, `.tsx`, `.js`, `.jsx`, `.R`, `.r`, `.java`, `.sql`, or anything under `scripts/`):

1. Stage the intended final commit explicitly. Do not use `git add -A` or `git add .`.
2. Run `bash scripts/reviewer-diff.sh --staged` via Bash. If there are substantive unstaged leftovers, either stage them intentionally or set them aside before review.
3. Dispatch `feature-dev:code-reviewer` via the Agent tool. Pass the full staged reviewer diff output as context. Target sub-90-second latency; report only blocking issues (confidence ≥ 80).
4. On clean review: compute `DIFF_HASH=$(bash scripts/reviewer-hash.sh --staged)` and write `.decode-reviewer-clean` with `<HEAD-SHA> <DIFF-HASH> <ISO-8601-UTC-timestamp>`.
5. On blocking findings: write `.decode-reviewer-findings.md` with the list. Do not write the clean marker.

The reviewer must not edit code directly. If it does, disclose those edits and treat them as part of the change under review — run another review pass over the final diff.

Hard escape hatch only: `[override-reviewer: <reason>]` anywhere in the commit message. Logged forever via `git log --grep="override-reviewer"`.

### Fast-path checklist

Use the small mechanical change fast path only when all are true:

- the intended change is easy to state in one sentence;
- an existing nearby pattern can be copied or extended;
- no public API, schema, data model, methodology, security, permission, or generated-output contract changes;
- no broad refactor, dependency change, migration, or cross-repo behavior change;
- the agent can name the focused verification command before editing.
- if unsure whether the change qualifies, use the normal workflow.

Eligible examples:

- copy an already existing formatting rule to another analogous config block;
- fix a typo in a user-facing label and update the matching snapshot/test;
- add one missing test case for an already implemented branch.

Not eligible:

- adding a new workflow, feature, command, or data output;
- changing business logic, permission behavior, schemas, prompts, or APIs;
- touching generated artifacts without updating and rerunning the generator.

Fast-path workflow:

1. State the one-sentence scope.
2. Inspect the analogous pattern.
3. Implement directly.
4. Run focused verification.
5. Run the reviewer procedure once over the final diff.
6. Commit the whole small change as one task.

If the change grows or design uncertainty appears, leave the fast path and use
the normal workflow.

## Enforcement

- **Hook:** `.claude/hooks/reviewer-stop.sh` (SessionStop) blocks session end when substantive files changed and no fresh marker exists.
- **Gate:** `.githooks/commit-msg` blocks commits when the marker's HEAD and staged DIFF hashes do not match the commit payload.
- **Reviewer check:** the subagent itself. The marker is the evidence that it ran; the staged diff hash is the evidence that reviewed content and committed content match, including file-mode changes.

## Tiers

- [x] product
- [x] data-python
- [x] data-r
- [ ] meta (usually off)

## Related rules

- Rule 02 (patch the source) — the reviewer is the primary catch for this.
- Rule 07 (invariants exit non-zero) — the commit-msg gate is itself an invariant check; it hard-fails when the marker is missing or stale.
- Rule 08 (destructive ops require sign-off) — complementary rail; the reviewer runs before commit, block-dangerous-git.sh runs on every Bash.
