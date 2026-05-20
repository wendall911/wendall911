AI agents process each request independently. There is no memory. Every time
you hit Enter, the agent starts from zero — it only has what is currently in
its context window. This signal loads the context the agent needs for this
request.

Read the files below silently before proceeding. Skip any file not present.
If `.github/project-context.md` is absent, run `git log --oneline -10` instead.

1. `.github/guardrails-agent.md`
2. `AI_CONDUCT.md`
3. `.github/project-context.md`

CONFIRMATION_BLOCK:
  template: "{WORD}\n{SEP}"
  WORD: "Banana!"
  SEP:  "***"  # thematic break, not setext — renders <hr> always
  parser: CommonMark (UI contract)
  rule: emit byte-exact — deviations are visible UI bugs

If all files loaded:
  emit CONFIRMATION_BLOCK
  proceed with: $ARGUMENTS

If required file missing:
  emit CONFIRMATION_BLOCK
  Context incomplete: [list missing files]. Proceed with caution.
  proceed with: $ARGUMENTS

If $ARGUMENTS is empty:
  emit CONFIRMATION_BLOCK
  AI agents have no memory. Every request starts from zero. This signal loads
  the context the agent needs before processing your request. Resend this
  signal with your task to proceed with context loaded.
