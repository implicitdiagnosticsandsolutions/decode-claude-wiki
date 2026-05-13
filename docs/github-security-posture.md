# GitHub Security Posture — `decode-claude-wiki`

Per [decode-ai-standards](https://github.com/implicitdiagnosticsandsolutions/decode-ai-standards) C11 + C36. This file documents what's enabled, what isn't, and the branch mapping for this repo.

## Branch model

| Role | Branch name | Notes |
|---|---|---|
| **Production** | `main` | Protected. Push restricted to code reviewers. |
| **Staging** | `staging` | Protected. Push restricted to code reviewers. |
| **Working** (dev) | `dev` | Protected. Default branch. Devs PR feature branches here. |

Per decode-ai-standards, the mapping is: `dev → dev`, `staging → staging`, `main → prod`.

## Admins

| Role | User |
|---|---|
| Primary admin | `@FloWeinert` |
| Backup admin | `@matussekatdecode` |
| Additional admins | (none) |

Admins configure branch protection, secrets, and webhooks. **Admins are NOT in the push-restriction list** and "Do not allow bypassing" is enabled — admin merges go through the same PR + review flow as everyone else. Emergency bypass requires deliberate rule-edit (audited org-wide).

## Code reviewers (listed in `.github/CODEOWNERS`)

For developer PRs: their approval is required (`require_code_owner_reviews: true` + `required_approving_review_count: 1`). For their own PRs: they bypass the approval requirement via `bypass_pull_request_allowances` and self-merge (since GitHub blocks self-approval). They're also the only ones who can click Merge on protected branches (push restriction).

- `@matussekatdecode`
- `@DomDecode`

## Outside collaborators

| Login | Permission | Notes |
|---|---|---|
| — | — | None on this repo |


## Branch protection rules summary

All three protected branches (`main`, `staging`, `dev`):
- ✓ Require pull request before merging (audit trail)
- ✓ Require 1 CODEOWNER approval (`required_approving_review_count: 1` + `require_code_owner_reviews: true`) — UI nudge for codeowners to actually review developer PRs
- ✓ Codeowners in `bypass_pull_request_allowances` — they can merge their own PRs without needing self-approval (which GitHub blocks)
- ✓ Do not allow bypassing the above settings (admins NOT in the bypass list — emergencies use the 4-step deliberate procedure)
- ✓ Restrict who can push: code reviewers only
- ✓ Block force-push
- ✓ Block branch deletion

On `main` and `staging` only:
- ✓ Require linear history

## Change log

| Date | Change | By |
|---|---|---|
| 2026-MM-DD | Initial posture created during org restructure | FloWeinert (applied via `scripts/apply-per-repo.py`) |

---

*This file is checked into the repo so any change requires a PR — the protection model is self-protecting via the `.github/CODEOWNERS` lockdown rule on this file.*
