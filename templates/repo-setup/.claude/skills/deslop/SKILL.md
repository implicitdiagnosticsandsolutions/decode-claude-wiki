---
name: deslop
description: Run a final cleanup and review-readiness pass on a nearly finished change. Use when the change already works and you want to reduce AI slop, remove unnecessary indirection, preserve source-of-truth files and types, and tighten the diff before commit.
allowed-tools: Read, Glob, Grep, Bash
---

# Deslop

Use this skill after the change is functionally correct and before `commit`.

The goal is not beautification.
The goal is to pressure the last part of the diff so the committed version is:

- smaller
- clearer
- more repo-consistent
- less invented

## What This Skill Is For

Use it to catch:

- fake seams and pass-through wrappers
- duplicated or widened local types
- repo-local conventions invented without payoff
- debug leftovers and placeholder comments
- swallowed errors and empty catches
- edits to generated artifacts that should have been made at the source

Do not use it to:

- discover the solution
- rewrite unrelated stable code
- turn a straightforward change into a cleanup project

## Core Review Vectors

Every deslop pass should cover these three vectors:

1. Rules and repo conformance
- are we following `CLAUDE.md`, nested instructions, and local docs
- did we drift from repo conventions or file ownership boundaries

2. Source of truth and verification
- did we preserve canonical source files and types
- did we patch a generated artifact instead of the generator
- did we claim verification that was not actually run

3. Overengineering and simplification
- did we write more code than needed
- did we add helpers, wrappers, or abstractions that do not earn their keep
- can the same behavior be expressed more directly

## Workflow

### 1. Gather the smallest useful context bundle

Read only what defines the rules for the changed area:

- repo-root `CLAUDE.md`
- nested instructions for the touched area, if any
- the changed files plus enough nearby context to judge them properly
- any spec, plan, or issue that defined the work

### 2. Run the three review vectors

Cover all three vectors deliberately.

The point is not the tool shape.
The point is to check:

- repo conformance
- source-of-truth discipline
- unnecessary complexity

### 3. Run slop tooling only when it fits

If the repo already has a native slop command, prefer that.

Examples:

```bash
pnpm lint:slop
pnpm lint:slop:delta
npm run lint:slop
```

If the repo has no wrapper but `slop-scan` is appropriate and available, use it directly:

```bash
npx slop-scan scan . --lint
npx slop-scan scan . --json
```

Treat `slop-scan` as a heuristic pass, not an oracle.

### 4. Fix what is clearly in scope

High-value deslop fixes:

- remove dead helpers and pass-through wrappers
- remove type drift and duplicated local types
- replace invented protocols with normal repo patterns
- remove debug leftovers and placeholder comments
- fix empty catches and error-swallowing patterns
- move edits from generated outputs back to the actual source of truth

### 5. Re-validate narrowly

After cleanup:

- rerun the narrowest relevant checks
- rerun lint or typecheck for the touched area
- rerun `slop-scan` if you used it

The final diff should describe the post-deslop state, not the earlier draft state.

## What Good Deslop Looks Like

Good outcomes:

- one less wrapper
- one less fake boundary
- stronger source-of-truth discipline
- stronger compile-time guarantees where the repo already supports them
- less ceremony around a straightforward change

Bad outcomes:

- broad cleanup outside the task
- large code churn for aesthetic reasons
- optimizing for scanner score instead of code quality
- deleting useful structure just to make the diff shorter

## Stop Rules

- Do not widen scope just because cleanup opportunities exist nearby.
- Do not optimize for scanner score over code quality.
- Do not remove real abstraction that carries its weight.
- Do not add defensive runtime checks inside trusted internal code unless the boundary is actually untrusted.
- If a cleanup is subjective and not clearly better, leave it alone.
