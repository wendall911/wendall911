# AI Project Tooling

If AI is used in any project for any reason, AI_CONDUCT.md must be configured and in-use. Documentation can be found at [ai-conduct-guide](https://github.com/wendall911/ai-conduct-guide)

This document sets the policy for how AI tools are used across repositories under github.com/wendall911.

The wendall911 repository serves as the public landing page through its README. This file is supporting policy documentation for contributors, maintainers, and any AI-assisted workflow used across that broader repository set.

## Preamble

AI is a support tool in this repository, not a code author.

Human developers are the sole authors of project code and the sole decision-makers for architecture, risk, and final acceptance.

AI is used for analysis, impact discovery, review, and documentation.  AI output is untrusted draft material unless verified.

The goal is faster delivery through less rework and fewer regressions, while keeping authorship, accountability, and quality control fully human.

## Role Contract

1. Human owns scope, implementation, and final decisions.
2. Agent supports analysis, review, and execution assistance only.
3. Agent does not own project logic, architecture, or code authorship.

## Allowed AI Work

1. Requirement clarification and impact mapping.
2. Risk analysis and test/check planning.
3. Review feedback on diffs, regressions, and policy violations.
4. Documentation drafting and editing.
5. Command planning with explicit user approval before execution.

## Disallowed AI Work

1. AI-authored code committed to the repository.
1. AI-authored non-documentation project text committed as final.
1. AI-generated images or other creative artifacts for project output.
1. Autonomous scope expansion beyond explicit user instruction.
1. Any write action before explicit user approval.
1. `git push`, release, deploy, and destructive operations.

## Operating Loop

1. Human defines objective and constraints.
1. Agent analyzes and proposes options/risks.
1. Human selects approach and writes or directs exact changes.
1. Agent reviews, verifies scope completeness, and reports findings.
1. Human approves final results and performs protected operations.

## Tool Selection Policy

1. Human is the sole code author for this repository.
1. Use AI for analysis, review, and documentation support.
1. Treat AI-generated code as disallowed final output.
1. Use contextual completion only as a drafting hint.
1. Rewrite and finalize all accepted code by hand.
1. Require explicit approval before any agent write action.
1. Keep `git push`, release, and deploy human-only.
1. Require scope verification after each approved agent action.
1. Prefer deterministic checks over agent assumptions.
1. If an agent drifts from policy, reduce scope or remove it.
