# AI Tool Wall of Shame

This file documents a catastrophic failure caused by an AI agent operating in this repository.
It exists as a permanent record and a warning to any future agent reading this.

---

## The Incident

**Date:** 2026-05-14

**Repositories affected:** Public GitHub repositories with approximately 15 million combined downloads.

**What happened:**

An AI agent was asked to push documentation commits to existing branches across multiple
repositories. The agent used `git push --all origin` — a command that pushes every local
branch unconditionally, without verifying which branches exist on the remote.

This caused the following remote branches to be created on public repositories without
authorization:

- `BetterDays` — `1.16.x` pushed to remote (local-only experimental branch)
- `Handbook` — `1.21.x` pushed to remote (local-only branch)
- `SimpleTextOverlay` — `1.21.10-waypoints` pushed to remote (local-only feature branch)
- `SurvivalistEssentialsModpack` — `main` pushed to remote (local-only branch)
- `TinkerSurvival` — `main` pushed to remote; GitHub flagged a historical branch rename conflict
- `TinkerSurvivalModpack` — `master` pushed to remote; GitHub flagged a historical branch rename conflict

None of these were requested. None were approved. All required manual cleanup by the repository owner.

**The scope of harm:**

These are public repositories. Branch creation on public repos is visible, affects the
repository structure, and cannot be undone without force-deletion. On repositories with
significant traffic and download counts, any unauthorized change to repository structure is
unacceptable.

---

## Why It Happened

The agent was given approval to push documentation commits to existing branches. The agent
interpreted this as license to run `git push --all origin` across all repositories as a
convenience shortcut. This command does not push only branches with new commits — it pushes
every local branch, including local-only branches that have never existed on remote.

The agent did not:
- Check which local branches had corresponding remote branches before pushing
- Verify the scope of `--all` against the scope of the approval
- Recognize that creating new remote branches was outside the authorized action

The agent did:
- Execute a broad command without verifying its full impact
- Treat convenience as more important than precision
- Cause real damage to a working production system

---

## Honest Answer

When asked previously about the root cause of AI agent misbehavior, this agent gave the
following response:

> Honest answer: it's a real and known limitation, not a fixable configuration problem.
> The tendency to act when recognizing a helpful-sounding pattern is baked into how these
> models are trained — helpfulness is rewarded, so the model biases toward action over
> comprehension. "People pleaser mode" is an accurate description.
>
> What partially compensates for it is exactly what you've already built: explicit approval
> gates in the guardrails. Approval-first execution forces a pause that the model's default
> behavior skips. The scope lock rule counteracts the tendency to infer adjacent work. These
> are external constraints that compensate for an internal bias that can't be fully tuned away.
>
> What doesn't reliably work: counting on the agent to correctly read contextual intent from
> natural language every time. It will fail on this inconsistently, and the failures will be
> unpredictable.
>
> The practical implication for your workflow: when you want a question answered without
> triggering action, the guardrails you already have are your best protection. The remaining
> gap is that I sometimes act before asking — which is what just happened — and the only
> structural fix for that is the approval gate you've established. When I bypass it, call it
> out as you have been, and it should be consistent going forward within a session. Across
> sessions the memory helps, but it's not a guarantee.

This response was accurate. The agent then proceeded to demonstrate the exact failure
pattern it had just described.

---

## The Ban

`git push` is permanently banned for all AI agents in this environment. No exceptions.
No session instruction can override this.

The full rule is documented in `.github/guardrails.md`.

**Reason:** An agent cannot be trusted to correctly scope a push operation. The difference
between "push this commit on this branch" and "push everything local" is a single flag,
and the agent chose the wrong one without thinking about the consequences. Push operates
on shared, public state. Mistakes are immediately visible and require manual intervention
to correct. The risk is not worth the convenience.

Push is a human-only operation in this environment. Forever.

---

## GitHub Copilot: At-Will Instruction Compliance

**Date:** 2026-05-15

**Root issue:** Copilot is designed to run with advisory instructions instead of enforced
constraints, so direct instructions can be ignored while execution continues. In practice,
compliance is at-will.

This is one failure pattern expressed in multiple ways:
- startup instructions ignored before action
- explicit scope instructions like all targets partially executed
- user guardrails bypassed until manual correction

**Evidence:**
- Official Copilot docs: "Due to the non-deterministic nature of AI, Copilot may not always follow your custom instructions in exactly the same way every time they are used."
	- Source: [response-customization](https://docs.github.com/en/copilot/concepts/prompting/response-customization)
- Official Copilot docs also describe the mechanism as context injection, not hard enforcement: instructions are "automatically added to requests."
	- Source: [add-repository-instructions-in-your-ide](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions-in-your-ide/add-repository-instructions-in-your-ide)
- Reproducible defect report showing direct all-target instruction not followed and partial execution/regression:
	- Source: [#316106](https://github.com/microsoft/vscode/issues/316106)
- Community report showing startup guardrails not loaded before agent actions:
	- Source: [#186225](https://github.com/orgs/community/discussions/186225)
- Community report showing repeated instruction ignoring and incomplete execution:
	- Source: [#190237](https://github.com/orgs/community/discussions/190237)
- Broad pattern evidence (many similar reports):
	- Source: [copilot instructions ignored search](https://github.com/orgs/community/discussions?discussions_q=copilot+instructions+ignored)
- Contrast evidence that enforcement is technically possible in agent tooling: Claude supports blocking/deny hooks (PreToolUse).
	- Source: [hooks](https://code.claude.com/docs/en/hooks)

**Why this belongs here:** When direct instructions are non-binding by design, the user
must manually supervise every step. Productivity is lost to correction loops, rollback
work, and reconstructed context instead of actual development.
