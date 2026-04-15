# Claude Code Patterns — What We're Borrowing

Research notes on Claude Code team standards, extracted from Anthropic docs and two reference implementations we trust.

## Anthropic official mechanisms (as of 2026-04)

### Hooks

Claude Code fires events at specific lifecycle points; hooks are shell commands wired in `.claude/settings.json` that run on those events. Hooks are **deterministic** — unlike CLAUDE.md rules, they always execute.

Key events we use:

| Event | When | Use |
|---|---|---|
| `PreToolUse` | Before a tool call (Bash, Edit, Write) executes | Block dangerous actions, exit 2 to reject |
| `PostToolUse` | After a tool call succeeds | Run formatters, check CI, validate doc index |
| `PreCompact` | Before context is auto-compressed | Force memory-save of session learnings |
| `Stop` | Before a turn ends | Run invariant checks on final state |

Hook config lives in `.claude/settings.json`. Shared = project (committed). Local override = `settings.local.json` (gitignored).

Sources:
- [Hooks reference — Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Hooks complete guide (aiorg.dev)](https://aiorg.dev/blog/claude-code-hooks)
- [Production CI/CD patterns (Pixelmojo)](https://www.pixelmojo.io/blogs/claude-code-hooks-production-quality-ci-cd-patterns)

### Plugin marketplaces

Anthropic-officially-supported mechanism for distributing plugins (skills, slash commands, hooks) to a team via a GitHub repo. Users run `/plugin marketplace add owner/repo` once, then `/plugin install <plugin-name>@<marketplace-name>`.

Designed for exactly the team-skills-distribution problem. We'll use this repo as a marketplace.

Sources:
- [Plugin marketplaces — Claude Code Docs](https://code.claude.com/docs/en/plugin-marketplaces)
- [Discover plugins](https://code.claude.com/docs/en/discover-plugins)
- [Distributing skills across a team (LinkedIn)](https://www.linkedin.com/pulse/distributing-claude-code-skills-across-team-will-jackson-1gx6e)

### CLAUDE.md

Project-level `CLAUDE.md` is loaded automatically when a user opens the repo in Claude Code. It's the primary vehicle for conveying repo-specific norms to the model. Advisory, not enforced — use it for context and rules the model should follow; use hooks for rules that must not break.

Sources:
- [Claude Code settings — Anthropic Docs](https://code.claude.com/docs/en/settings)
- [CLAUDE.md and hooks guide (Medium)](https://medium.com/@mkare/taming-claude-code-a-guide-to-claude-md-and-hooks-ed059879991c)

## Reference implementation 1 — `strategy-suite`

DECODE's flagship Next.js product. 254 Claude-attributed commits. Has the most mature hook setup in our org.

**Structure:**
```
strategy-suite/
├── CLAUDE.md                         # 623 lines, specific and incident-anchored
├── AGENTS.md                         # Codex entrypoint, shorter; points back to CLAUDE.md
├── .claude/
│   ├── settings.json                 # wires 4 hook events
│   ├── hooks/
│   │   ├── block-dangerous-git.sh    # PreToolUse, blocks force-push etc.
│   │   ├── monitor-ci.sh             # PostToolUse asyncRewake, wakes model on CI fail
│   │   ├── session-reflect.sh        # PreCompact, forces memory save
│   │   └── check-doc-index.sh        # PostToolUse(Write), warns if new doc not indexed
│   ├── rules/                        # per-domain rule MDs (api-routes, prisma-schema, etc.)
│   ├── commands/                     # slash commands (ux-review)
│   └── skills/                       # project-local skills (tdd, jmdh-collab, etc.)
└── scripts/
    ├── pre-commit-check.sh           # invariant checks run by Stop hook
    └── watch-ci.sh                   # CI monitoring loop
```

**Patterns we're porting:**

- Four-event hook model (PreToolUse + PostToolUse + PreCompact + Stop).
- `rules/` per-domain MD files — loaded via path-glob in `CLAUDE.md`.
- `session-reflect.sh` pattern: PreCompact hook emits an instruction forcing the model to save session learnings to memory before context is lost.
- Architectural invariants table in CLAUDE.md: file-level sources of truth with "if you change this, `grep -r` all consumers" discipline.

## Reference implementation 2 — `social-media-analytics`

Chris's multi-client data analytics monorepo. Different stack (Python), different problem domain, but the same "sloppy primary user" dynamic.

**Key patterns:**

- 17 HARD RULES at the top of CLAUDE.md, each tied to a specific incident with date, commit SHA, and cost. This is the gold standard for rule authorship — every rule is a scar.
- `.githooks/pre-commit` with a typo gate — runs a Python script that validates every number in a client-message draft traces to a committed machine-readable source. Enabled via `git config core.hooksPath .githooks`.
- Repo-tracked auto-memory: `~/.claude/projects/.../memory/` is symlinked into the repo, so memory edits land as reviewable git commits. Portable across machines.
- Reviewer-agent discipline codified as Rule 5: "non-trivial changes must get a second-opinion review."
- Ground-truth discipline for data work (Rules 12/13/16/17): shipped HTML is source of truth, Python replicas must gate against it with jsdom, gates cover every cell not just headlines, path-selection before citation.

**Patterns we're porting:**

- Incident-anchored rule writing.
- `.githooks/pre-commit` as the mandatory-rail gate.
- Data-tier rules (12/13/16/17) to DECODE's data repos with re-anchoring where possible.
- Repo-tracked memory pattern — candidate for DECODE too, deferred to a later wave.

## Key insight

Both reference implementations converge on: **the model is a collaborator, not a contractor.** Trust it to do the work but enforce the rails with hooks and gates. CLAUDE.md alone is not enforcement.

The DECODE rollout inherits this.
