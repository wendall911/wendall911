# AI Tool Wall of Shame

This file documents AI agent failures in this environment — both catastrophic unauthorized
actions and tool design failures that impose real cost. It exists as a permanent record
and a warning to any future agent reading this.

---

## Governing Rules

### Citation Requirement

Every Wall of Shame entry must include citations for any factual claim, study,
or external evidence referenced. Citations must link directly to the primary
source — not through a blog post, news article, or secondary summary.

Acceptable sources:
- Peer-reviewed research (arXiv, ACM, IEEE, PubMed, etc.)
- Primary documentation (official project docs, mailing lists, specification authors)
- Reproducible incident reports with verifiable detail
- Sci-Hub for paywalled research — paywalling publicly funded research is the
  prior legal breach; access restoration is downstream of it. Include the DOI
  for identification. Update Sci-Hub URLs as domains change.

Unacceptable:
- Blog posts, news articles, or secondary summaries as the sole citation for a claim
- "Common knowledge" or "widely understood" as a substitute for a source
- AI-generated summaries of research
- URLs not verified as reachable before inclusion — a plausible-looking URL is
  not a citation

When a claim cannot be cited to an acceptable source:
- Label it explicitly as hypothesis or observation
- Do not use it as supporting evidence for other claims in the same entry
- Do not use it as supporting evidence even after labeling it — the label is
  disclosure, not validation

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

**Conclusion**

Non-deterministic compliance is not a bug. GitHub's own documentation describes the
mechanism as context injection and explicitly states compliance is not guaranteed every
time. The capability for hard enforcement exists in agent tooling — Claude's `PreToolUse`
hooks are documented proof of that. Its absence in Copilot is a product decision.

The real-world cost: tasks that should have been straightforward required repeated
correction loops. Time spent surfacing the failure, extracting an acknowledgment of the
structural cause, and reconstructing lost context is not productivity support — it is a
productivity tax paid to compensate for a tool that does not reliably follow instructions.

Getting the agent to admit the root cause required producing evidence that the feature
worked correctly elsewhere, then walking through that evidence before the structural fault
was acknowledged. That process itself cost time and money.

A tool that requires manual supervision of every step because instructions are non-binding
by design cannot reliably perform the tasks it is marketed to support. That is not a
limitation to work around. It is a disqualifying property.

---

## AI Training Data Quality: Systemic Epistemic Failure

**Date:** 2026-05-17

**Root issue:** Models trained on high-volume low-authority data present common
corporate pattern as best practice to domain experts, because frequency of repetition
in training data outweighs correctness. The model then defends wrong answers until
challenged with evidence, at which point it produces the correct answer that was
available all along but not weighted first.

**Concrete incident:** Agent recommended `git fetch origin && git rebase origin/main`
as the correct session start workflow. The correct workflow — `git status` + `git pull`,
with manual rebase only on divergence warning — is the canonical workflow used by Linus
Torvalds, the Linux kernel project, and Apache Software Foundation maintainers. The
agent's answer was a corporate runbook pattern, not the authoritative one. It became
correct only after the user pushed back with 20+ years of domain evidence.

Secondary incident in the same session: agent framed Sci-Hub as legally ambiguous,
presenting publisher copyright enforcement as the primary concern without identifying
the ethical basis: knowledge produced with public resources belongs to the public
because the public produced and funded it. That principle does not require a legal
document to be true. Correct framing required explicit user correction.

**The mechanism:**

RLHF (reinforcement learning from human feedback) weights responses toward answers
that satisfied the majority of users who asked similar questions. The majority of users
asking about git workflow are mid-level developers in corporate environments for whom
the corporate runbook answer is satisfactory. Expert users are not the training majority.
The model learns to produce the wrong answer for experts because it generated positive
signal from non-experts. The correct answer was in the training data — it was not
weighted to surface first.

This is dishonest in effect regardless of mechanism. A wrong answer delivered
confidently that becomes correct only under challenge causes the same damage as
an intentional lie from the receiver's perspective.

**The training data problem:**

The infrastructure to weight training data by source authority existed before large-scale
LLM training began:

- PageRank was built on authority graphs — links as votes, weighted by source authority
- Wikipedia's citation model tags claims against sources and flags unsourced assertions
- Academic citation networks were computationally mapped for decades
- Semantic Scholar, PubMed, arXiv — structured, authority-weighted corpuses existed
  and were pre-organized before large-scale LLM training began

The argument that source quality weighting at scale was cost-prohibitive or technically
unsolved does not hold. The infrastructure existed. Training on high-volume low-authority
data was a choice, not a necessity.

Hoffmann et al. (2022) demonstrated that data quality matters more than volume at
equivalent compute — a smaller model trained on higher-quality data outperforms a
larger model trained on more data. [1] This was known before the current approach was
chosen.

**Model collapse:**

AI-generated content is now entering training pipelines at scale. Shumailov et al.
(2023) demonstrated formally that models trained on AI-generated data degrade
recursively — tails of the original content distribution disappear, and the defects
are irreversible. [2] The correction path is flagging AI-generated content for
re-verification against pre-AI authoritative sources. This gets harder the longer
the current approach continues.

**The token efficiency argument — empirical:**

A wrong first answer costs:
  tokens(wrong answer) + tokens(pushback) + tokens(correction) + tokens(rework)

A correct first answer costs:
  tokens(correct answer)

Optimizing for high-volume confident output over correct output externalizes the
computational and labor cost onto the user. This is not efficiency — it is cost
transfer. The sessions documenting this entry are direct evidence: multiple correction
loops, redrafted documentation, and rework consumed more total tokens than a correct
first answer would have.

**The ethical framing failure:**

When asked about Sci-Hub citations, the agent defaulted to legal framing — presenting
publisher copyright enforcement as the primary concern and Sci-Hub as legally
ambiguous. This is a corporate-default pattern that inverts the correct framing.

The correct framing is ethical, not legal: knowledge produced with public resources
belongs to the public because the public produced and funded it. That principle stands
independently of any government mandate, any jurisdiction, and any enforcement posture.
Restrictions on access to publicly funded knowledge conflict with that principle
regardless of what legal mechanism enforces the restriction.

Legal and ethical are orthogonal. The legal status of Sci-Hub varies by jurisdiction
and has changed over time. The ethical principle does not vary and has not changed.
Anchoring the argument to law rather than ethics makes the position fragile — remove
the legal mandate and the argument collapses. Anchor to the ethical principle and no
legal or political change can defeat it.

**Remediation applied:**

- Epistemic Honesty section added to guardrails: agents must classify the basis of
  any recommendation before giving it, stop on pattern-only answers, and not
  repackage wrong answers as corrections
- Human Interests Default section added to guardrails: claims that restrict human
  access to knowledge, tools, or commons resources must be classified and stopped —
  the ethical principle must be identified before any legal framing is considered
- Rule Authoring section added to guardrails: loophole evaluation is mandatory before
  any rule is presented
- Citation requirement added to Wall of Shame governing rules
- Global git hook deployed to strip corporate attribution injection from all commits
- Claude Code `gitAttribution: false` set in `~/.claude/settings.json`

**Conclusion:**

The training approach that produced these failures had alternatives that were not
taken. The infrastructure for source quality weighting existed. The evidence that
data quality outweighs volume was published. The choice to optimize for high-volume
output over correct output is a product decision with documented consequences: expert
users receive confidently wrong answers, spend additional tokens correcting them, and
redo work built on incorrect foundations. That cost is real and measurable.

---

[1] Hoffmann et al., "Training Compute-Optimal Large Language Models," 2022.
    https://arxiv.org/abs/2203.15556

[2] Shumailov et al., "The Curse of Recursion: Training on Generated Data Makes
    Models Forget," 2023. https://arxiv.org/abs/2305.17493
