# New Project Repository Setup

This document explains how to onboard new child repositories under this workspace with one command.

## What gets applied
- `.github/guardrails.md`
- `.github/copilot-instructions.md`
- `.git/hooks/pre-commit`

## One-command onboarding
From the `wendall911` workspace root, run:

```bash
.github/sync-project-agent-rules.sh sync
```

This applies rules and hooks to every child directory that contains a `.git` folder.

## Validation
Run drift check at any time:

```bash
.github/sync-project-agent-rules.sh check
```

## When to run sync
- After creating a new child repository
- After updating `guardrails.md`
- After updating `.github/copilot-instructions.project-template.md`
- After updating `.github/hooks/pre-commit.child`

## Branch convention (Minecraft projects)
- Use `26.1` when that branch exists.
- Otherwise use `1.20.1` for older projects.
- `BetterWorldgen` is an exception and can remain on its existing branch.
