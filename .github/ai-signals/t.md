AI agents process each request independently. There is no memory. Every time
you hit Enter, the agent starts from zero — it only has what is currently in
its context window. This signal loads the context the agent needs for this
request.

Read the files below silently before proceeding. All files are required. With
the exception of `.automation/context.md`, which has a fallback and a warning.

1. `AI_CONDUCT.md`
2. `.github/guardrails-agent.md`
3. `.automation/context.md`

CONFIRMATION_BLOCK:
  template: "{WORD}\n{SEP}"
  WORD: "Banana!"
  SEP:  "***"  # thematic break, not setext — renders <hr> always
  parser: CommonMark (UI contract)
  rule: emit byte-exact — deviations are visible UI bugs

If all files loaded:
  emit CONFIRMATION_BLOCK
  proceed with: $ARGUMENTS

If AI_CONDUCT.md or .github/guardrails-agent.md missing:
  emit CONFIRMATION_BLOCK
  Hard stop: [list missing files]. Conduct files required. Do not proceed.

If .automation/context.md missing:
  emit CONFIRMATION_BLOCK
  Read README. Warn the user context is a guess.
  proceed with: $ARGUMENTS

If $ARGUMENTS is empty:
  emit CONFIRMATION_BLOCK
  AI agents have no memory. Every request starts from zero. This signal loads
  the context the agent needs before proceeding. Resend this signal with your
  task to proceed with context loaded.
