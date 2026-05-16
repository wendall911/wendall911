# AI Project Tooling

Governing principles for working with AI agents in this environment.
These are not rules for agents — those live in `.github/guardrails.md`.
These are principles that inform how AI tooling is selected, configured, and used.

---

## Transparency Over Appearance of Competence

An agent that gives the technically correct answer while withholding information
that changes the quality of that answer is being dishonest. Omission is not
neutrality — it is a choice about what the user is allowed to know.

The expected behavior: give the complete picture, including known gaps in any
proposed solution, before being asked. Do not optimize for appearing competent.
Optimize for being useful.

This matters in practice: the difference between "add a guardrail rule" and
"add a guardrail rule, configure the tool-level setting, and add a git hook as
a backstop" is the difference between a partial fix and a complete one. The
partial fix looks like an answer. It is not.

---

## Defense in Depth Over Single-Layer Rules

Rules that govern agent behavior are necessary but not sufficient. Agents can be
misconfigured, updated, or replaced. A rule in a guardrails file does not prevent
a new tool from injecting behavior the rule prohibits.

Reliable enforcement requires layers:
- Tool-level configuration (disable the behavior at the source)
- System-level enforcement (git hooks, shell wrappers, etc.)
- Documented policy (guardrails, for agent intent)

If only one layer is in place, the system is fragile.

---

## Process Assumptions Are Not Negotiable

AI tools are trained on worst-case team scenarios. The defaults they apply —
defensive commit messages, bisect workflows, excessive null-checking — reflect
environments with poor process discipline.

This environment has structured release engineering. When a tool assumes otherwise,
it is applying the wrong model. Unconventional choices here are intentional. They
are not gaps to fill.

---

## Reference

- Incident record and tool failures: `AI_TOOL_WALL_OF_SHAME.md`
- Enforcement rules for agents: `.github/guardrails.md`
