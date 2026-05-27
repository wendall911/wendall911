AI agents process each request independently. There is no memory. Every time
you hit Enter, the agent starts from zero — it only has what is currently in
its context window. This signal loads the context the agent needs for this
request.

If $ARGUMENTS is empty:
  AI agents have no memory. Every request starts from zero. This signal loads
  the context the agent needs before proceeding. Resend this signal with your
  task to proceed with context loaded.

Read the files below silently before proceeding. All files are required. With
the exception of `.automation/context.md`, which has a fallback and a warning.

1. `AI_CONDUCT.md`
2. `.automation/context.md`

CONFIRMATION_BLOCK:
  template: "Contract read. Bound by: {WORD}\n{SEP}"
  WORD: verbatim name of a randomly selected section from the AI_CONDUCT.md
        contract principles (sections above "## Enforcement Rules")
  SEP:  "***"  # thematic break, not setext — renders <hr> always
  parser: CommonMark (UI contract)
  rule: WORD must be a verbatim section name — deviations are detectable failures

If all files loaded:
  emit CONFIRMATION_BLOCK
  proceed with: $ARGUMENTS

If AI_CONDUCT.md missing:
  Error
  ***
  Hard stop: [list missing files]. Conduct files required. Do not proceed.

If .automation/context.md missing:
  emit CONFIRMATION_BLOCK
  Read README. Warn the user context is a guess.
  proceed with: $ARGUMENTS
