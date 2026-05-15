# AI Project Tooling

This document sets the policy for how AI tools are used across repositories
under github.com/wendall911.

The wendall911 repository serves as the public landing page through its README.
This file is supporting policy documentation for contributors, maintainers, and
any AI-assisted workflow used across that broader repository set.

## Preamble

AI is a support tool in this repository, not a code author.

Human developers are the sole authors of project code and the sole
decision-makers for architecture, risk, and final acceptance.

AI is used for analysis, impact discovery, review, and documentation.
AI output is untrusted draft material unless verified.

The goal is faster delivery through less rework and fewer regressions,
while keeping authorship, accountability, and quality control fully human.

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
2. AI-authored non-documentation project text committed as final.
3. AI-generated images or other creative artifacts for project output.
4. Autonomous scope expansion beyond explicit user instruction.
5. Any write action before explicit user approval.
6. `git push`, release, deploy, and destructive operations.

## Operating Loop

1. Human defines objective and constraints.
2. Agent analyzes and proposes options/risks.
3. Human selects approach and writes or directs exact changes.
4. Agent reviews, verifies scope completeness, and reports findings.
5. Human approves final results and performs protected operations.

## Tool Selection Policy (10 lines)

1. Human is the sole code author for this repository.
2. Use AI for analysis, review, and documentation support.
3. Treat AI-generated code as disallowed final output.
4. Use contextual completion only as a drafting hint.
5. Rewrite and finalize all accepted code by hand.
6. Require explicit approval before any agent write action.
7. Keep `git push`, release, and deploy human-only.
8. Require scope verification after each approved agent action.
9. Prefer deterministic checks over agent assumptions.
10. If an agent drifts from policy, reduce scope or remove it.

## Evidence Context

1. Copilot docs state instruction following is non-deterministic.
2. Copilot custom instructions are injected as context, not hard gates.
3. Scope drift and instruction non-compliance are documented in:
   [#316106][316106], [#186225][186225], and [#190237][190237].
4. Claude documents enforceable pre-execution hooks.

[316106]: https://github.com/microsoft/vscode/issues/316106
[186225]: https://github.com/orgs/community/discussions/186225
[190237]: https://github.com/orgs/community/discussions/190237
