# decode-base plugin

The base Claude Code plugin shipped to every in-scope DECODE target repo.

## What it provides

### Agents

This plugin does not ship its own reviewer subagent. The **`feature-dev:code-reviewer`** from `claude-plugins-official` is used instead — better-built, officially maintained, confidence-filtered output. Target repos enable `feature-dev@claude-plugins-official` alongside `decode-base@decode` in their `.claude/settings.json`.

### Skills

- (future) `incident-logger` — programmatic interface to file an incident issue into `decode-claude-wiki`.
- (future) `plan-reviewer` — peer-review a plan before implementation starts (stronger than the code reviewer; focuses on design, not correctness).

### Hooks (distributed via plugin)

Note: the *critical* hooks (reviewer-stop, block-dangerous-git, block-env-writes) are committed directly in each target repo under `.claude/hooks/` so they fire on `git pull` with zero prompt. This plugin may ship additional, non-critical hooks over time.

## How it ships

The repo at `implicitdiagnosticsandsolutions/decode-claude-wiki` is registered as a Claude Code marketplace via `.claude-plugin/marketplace.json` at the root. Target repos declare the marketplace and this plugin in their `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "decode": {
      "source": {"source": "github", "repo": "implicitdiagnosticsandsolutions/decode-claude-wiki"}
    }
  },
  "enabledPlugins": {
    "decode-base@decode": true
  }
}
```

First Claude Code session in a target repo prompts the user to install. One click, then silent.

## Updates

Push to the `main` branch of `decode-claude-wiki`. Claude Code pulls the latest on the next session.

## Dependencies (for hooks)

- `bash`
- `jq`
- `git`
- `gh` (for the incident-logger skill; skip if `gh` unavailable and warn)
