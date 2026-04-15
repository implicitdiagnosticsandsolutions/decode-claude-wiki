# Incident Log

The incident log is the foundation of every hard rule. A rule without an incident is a suggestion; a rule with one is a bruise.

## What counts as an incident

Anything that cost time, trust, or money because of how Claude was used (or how we failed to configure it). Not just bugs — also process failures. Examples:

- Shipped a wrong number to a client because the generator script and the client HTML computed it differently.
- Force-pushed over someone's work.
- Claimed "it's in memory" when the file wasn't actually in auto-memory.
- Edited a generated artifact directly and silently broke reproducibility.
- Ran a data analysis that matched the CSV but didn't match what the client actually saw in their dashboard.

## What does NOT count

- Normal bugs caught by code review before merge.
- Personal preference or style.
- One-off mistakes that didn't cost anything and aren't at risk of recurring.

## Format

One file per incident. Filename: `YYYY-MM-DD_repo_shortname.md`. Use [`_template.md`](_template.md).

Required fields:
- **Date** (YYYY-MM-DD)
- **Repo**
- **Commit SHA** (if applicable)
- **What happened** (1 paragraph, factual)
- **What it cost** (time, trust, money, customer impact)
- **Root cause** (one sentence)
- **Rule it justifies** (link to `../rules/NN_name.md`)

## Lifecycle

1. **Incident occurs** — supervisor, rollout owner, or any contributor writes it up. Honest, first-person, no embellishment.
2. **Rule proposed** — does this incident justify a new hard rule, or reinforce an existing one? If new, draft in `../rules/`.
3. **Rule ships** — incorporated into a CLAUDE.md tier template; incident file is linked from the rule file.
4. **Incident file stays** — never deleted. It's the durable evidence.

## Seed source — mining existing memory

Before Wave 1, the rollout owner mines these for already-documented incidents:

**Memory files** in `~/.claude/projects/-home-scheier-projects-decode/memory/` (on the supervisor's machine):

> These files are **not** in this git repo. They live under Claude Code's auto-memory path on the supervisor's local machine — a persistent knowledge base Claude reads at session start. Each `feedback_*.md` file records a lesson learned from a past incident: what went wrong, why, and the rule the supervisor adopted in response. The rollout owner needs access to the supervisor's machine or a dump of these files to mine them. If access is not available, request the supervisor produce a dump as a first task. Candidate files:

- `feedback-ssl.md`
- `feedback_production_schema.md`
- `feedback_territory_colors.md`
- `feedback_velocity_adapter.md`
- `feedback_ui_components.md`
- `feedback_docker_prisma.md`
- `feedback_check_deploy.md`
- `feedback_check_envs.md`
- `feedback_pipeline_debugging.md`
- `feedback_module_type_trap.md`
- `feedback_ssm_url_encoding.md`
- `feedback_breakouts.md`
- `feedback_allchoice_firstchoice.md`
- `feedback_demo_studies.md`
- `feedback_jtbd_structure.md`
- `feedback_cmix_reactivation.md`
- `feedback-attribute-workflow.md`
- `feedback-pbi-limitations.md`
- `feedback-branch-naming.md`
- `feedback-branching-strategy.md`
- `feedback-windows-paths.md`

**External reference** — `social-media-analytics/CLAUDE.md` has 17 rules with full incident refs. Worth porting those that apply to DECODE data work (rules 1–3, 5, 9–13, 16, 17) and re-anchoring to matching DECODE incidents where they exist.

## Why we keep this list honest

If the incident list contains fabricated or inflated incidents, the rules based on them are ignored the first time someone catches the exaggeration. Over-index on specificity — who, when, what commit, what it cost, measured in hours or dollars where possible.
