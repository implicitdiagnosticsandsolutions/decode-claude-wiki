# DECODE Repo Readiness Checklist

Use this before pushing a DECODE repo toward heavier agentic coding.

The point is not to score repos for prestige. The point is to avoid giving high-autonomy workflows to repos that cannot safely absorb the extra change velocity.

## Ready Enough

A DECODE repo is meaningfully ready when most of these are true:

- the repo has a real `CLAUDE.md` or can accept one without ambiguity
- setup, run, and verification commands are explicit
- at least one human can explain the normal dev loop without tribal knowledge
- local checks and CI mostly agree
- reviewers can tell what "good" looks like in that repo
- generated files and source files are distinguishable
- risky areas such as auth, deploy logic, or data pipelines are identifiable

## Fastest Upgrades

These are the highest-leverage improvements for most DECODE repos:

1. Add or clean up `CLAUDE.md` with actual repo-specific instructions.
2. Make the verification commands copy-pasteable.
3. Move repeatable checks into repo-owned scripts.
4. Separate generated artifacts from their generators clearly.
5. Mark sensitive paths and invariants explicitly.
6. Reduce flaky CI or remove checks that everybody ignores.

## Red Flags

Do not expand autonomy aggressively if several of these are true:

- nobody agrees on how to run the repo
- the repo has no written local instructions
- CI is so noisy that red builds are routinely ignored
- generated outputs are commonly hand-edited
- migration or deploy steps live only in one person's head
- ownership of risky parts of the repo is unclear
- reviewers already struggle to understand normal PRs

In that state, Claude will usually amplify the repo's existing mess rather than fix it.

## Practical Levels

### Level 0: Not Ready

Characteristics:

- missing repo instructions
- unclear verification commands
- weak or ignored CI
- no reliable review loop

Recommended action:

- harden the harness first
- do not increase autonomy yet

### Level 1: Assisted

Characteristics:

- Claude helps implement narrow tasks
- humans still keep scope tight
- review remains fairly manual

Recommended action:

- good default for many DECODE repos now
- use the current template and keep PRs small

### Level 2: Feature-Ready

Characteristics:

- repo instructions are current
- local gates and CI are aligned
- reviewers can reason about the output
- migration and deploy expectations are visible

Recommended action:

- allow larger slices of agent work
- tighten reviewer and incident loops

### Level 3: Higher Autonomy

Characteristics:

- strong repo-local instructions
- reliable checks
- clear rollback or forward-fix discipline
- incident learning loop is active

Recommended action:

- appropriate for deeper automation or longer-running agent loops
- only after normal engineering change is already under control
