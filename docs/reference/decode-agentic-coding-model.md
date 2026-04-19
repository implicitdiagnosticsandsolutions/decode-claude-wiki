# DECODE Agentic Coding Model

This document defines how DECODE should treat agentic coding as an operating model, not just a tool choice.

The DECODE constraint is sharper than in a typical engineering org: most repo owners are not programmers by training. That means the quality system has to live in the repo and in the harness, not in everyone's judgment alone.

## What We Mean by Agentic Coding

Agentic coding means staff increasingly delegate implementation work to Claude Code and related tools while humans remain responsible for:

- task framing
- architecture and scope
- reviewing whether the result is actually correct
- checking whether the verification is real
- deciding whether a change is safe to merge

At DECODE, this is not optional future planning. It is already how code is being produced in practice.

## The Core Risk

The main failure mode is not "the model writes ugly code".

The main failure mode is:

- plausible but unchecked code gets accepted
- generated outputs are edited directly instead of fixing the source
- staff believe the model verified something that it did not verify
- fragile repos absorb more change than their harness can safely support

So the operating goal is not "stop vibe coding". The goal is to put rails around it so the output remains reviewable, reproducible, and fixable.

## Human Accountability Does Not Go Away

Using Claude does not transfer accountability away from DECODE staff.

Humans still own:

- what problem is being solved
- which repo should change
- whether the change fits the repo's architecture
- whether the right files were edited
- whether the verification was real
- whether the change is safe to commit, merge, and deploy

If nobody can explain why a change is correct, that change is not ready.

## DECODE's Enforcement Philosophy

The harness should distinguish two categories:

### Deterministic checks

These should block:

- destructive commands
- missing reviewer markers
- lint failures that are known and repeatable
- obvious secret-file writes

### Heuristic checks

These should start advisory:

- artifact-vs-generator suspicion
- slop scans
- architectural pressure smells
- reviewer hints based on patterns rather than proof

If a heuristic is noisy, do not make it a hard gate just because it feels strict.

## What Must Live In The Repo

Because many DECODE contributors will not remember local conventions from memory, each serious repo should eventually have:

- `CLAUDE.md` with the repo-specific operating manual
- repo-owned hook and gate scripts
- explicit local commands for verification
- documented "do not touch casually" areas
- rollout or migration notes where relevant

If a rule only exists in somebody's head, the model will violate it and the human reviewer may miss it.

## Review Model

For DECODE, the minimum viable review model is:

1. Make the task concrete enough that the model is solving the right problem.
2. Run deterministic local checks.
3. Run a second-pass reviewer for non-trivial changes.
4. Require an explicit override marker when someone chooses to bypass that review.

This is lighter than a deep engineering review process, but it is much stronger than "Claude changed it and it looked fine".

## Repo Readiness Matters

Not every repo can absorb the same level of autonomy.

A repo is less ready when:

- nobody agrees on the right run/test command
- CI is ignored because it is flaky
- generated files and source-of-truth files are mixed together
- deploy or migration steps live only in chat history

In those repos, more agentic coding increases churn faster than value.

Use [`repo-readiness-checklist.md`](repo-readiness-checklist.md) before rolling the full harness out to a repo or raising its autonomy level.

## Near-Term DECODE Standard

The near-term standard for in-scope repos is:

- repo-committed Claude hooks
- a repo-local advisory `deslop` skill for final cleanup passes
- local git hooks wired by `scripts/setup.sh`
- a shared language gate used by both local hooks and CI
- a required reviewer marker or visible override
- incident capture at least for CI failures, with more capture paths added as the template matures

That is enough to reduce the worst failure modes now, without requiring non-programmers to learn a full engineering process first.
