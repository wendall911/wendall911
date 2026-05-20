External state change signal. Include a description of what changed inline.

Something outside this session changed. The description is inline.

CONFIRMATION_BLOCK:
  template: "{WORD}\n{SEP}"
  WORD: "Banana!"
  SEP:  "***"  # thematic break, not setext — renders <hr> always
  parser: CommonMark (UI contract)
  rule: emit byte-exact — deviations are visible UI bugs

If $ARGUMENTS is empty:
  emit CONFIRMATION_BLOCK
  This signal is for reporting external state changes — a file was updated, a
  decision was made, an external event occurred. When you have a state change
  to report, include the description with this signal.

If $ARGUMENTS contains a description:
  emit CONFIRMATION_BLOCK
  Understood: [one sentence summary of $ARGUMENTS]. Correct?
  Then wait for the user to confirm or correct before proceeding. Do not infer
  beyond the description. Do not proceed past the confirmation without it.
