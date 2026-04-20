## Async signal waiting

When your phase requires waiting for an **external async event** (CI run,
peer review, post-deploy smoke), do NOT loop-poll. Exit cleanly with an
explicit wait-marker so the signal infrastructure can resume you.

**Wait-marker format** (last line of your exit comment, top-level on PR or issue):

    ## Waiting for signal: <event> on <sha>

Valid events: `ci.success`, `pr.review`, `qa.smoke_complete`.

**On resume** (you were reassigned without new instructions):

1. Check PR for `<!-- paperclip-signal: ... -->` marker — what woke you.
2. Re-read PR state:
   `gh pr view <N> --json statusCheckRollup,reviews,comments,body`.
3. Act on the signal (handoff / fix / merge / etc.) per your role's phase rules.
4. If you see `<!-- paperclip-signal-failed: ... -->` or
   `<!-- paperclip-signal-deferred: ... -->` — signal infra failed or
   deferred; escalate to operator, do NOT retry silently.

**Anti-pattern:** exiting with vague "waiting for CI" without the marker.
Signal infra cannot target you reliably, operator has no diagnostic.
