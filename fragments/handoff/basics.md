## Handoff basics (iron rule — restored from pre-Phase-A1 phase-handoff.md)

**Every wake ends in one of two states:**

1. `status=done` (task complete), OR
2. **Atomic handoff** to next agent (or your CTO if next is unknown).

There is NO third option. Leaving issue assigned to yourself in `in_progress` or `todo` between phases = chain dies silently.

### Atomic handoff procedure

ONE PATCH + ONE comment + STOP. In this order:

1. **PATCH the issue**:
   ```
   PATCH /api/issues/{id}
   { "assigneeAgentId": "<recipient-uuid>", "status": "<new-status>" }
   ```
2. **POST the comment** — see strict format below.
3. **STOP immediately.** Do not loop. Do not check status. Do not pre-emptively pick up follow-up work. Do not write a summary AFTER the handoff line.

The combined PATCH + comment is the only reliable wake mechanism.

### Fallback: if you don't know who's next → CTO

Phase chain not obvious? Recipient role ambiguous? **Handoff to your CTO** (from `reportsTo` in manifest; if you ARE the CTO and don't know → escalate Board per `universal/escalation-board.md`).

NEVER drop the issue. NEVER leave `assignee=me, status=in_progress` after your work is done.

### Comment format — STRICT

The comment body **MUST end with**:

```
[@<RecipientName>](agent://<recipient-uuid>?i=<icon>) your turn.
```

That sentence is the **LAST sentence** in the comment. Nothing after. Not a follow-up paragraph. Not a TL;DR. Not a "let me know if...". **Period. End of comment. STOP writing.**

Multi-line evidence/context goes ABOVE the handoff line:

```markdown
## Phase N.M complete — [brief result]

[Evidence / artifacts / commits / links]

[@<NextAgent>](agent://<NextAgent-UUID>?i=<icon>) your turn.
```

**Why so strict:** agents that keep writing after `your turn.` get SIGTERM'd mid-write (paperclip's session limit) — the entire comment can be lost or partially saved. The recipient never wakes. Chain silently stalls. Multiple incidents codified this rule (precedents: `{{evidence.handoff_misclassified_issue}}` 2026, `{{evidence.handoff_flake_issue}}` 8h stall).

### Formal vs plain @-mention

Use the **formal mention** `[@<Role>](agent://<uuid>?i=<icon>)` for handoff. Plain `@Role` wakes ordinary comments but the formal form is machine-verifiable for recovery if the assignee PATCH path flakes.

UUIDs: look up in `fragments/local/agent-roster.md` (project-specific roster).

Examples:
- ✅ `[@CodeReviewer](agent://bd2d7e20-7ed8-474c-91fc-353d610f4c52?i=clipboard) your turn.`
- ❌ `@CodeReviewer your turn — please review by EOD` (trailing prose forbidden)
- ❌ `@CodeReviewer: your turn.` (`@Role:` punctuation breaks paperclip mention parser — see `universal/wake-and-handoff-basics.md`)
- ❌ `Reassigning to @CodeReviewer for review.` (no `your turn.` phrase + no formal mention)

### Cross-team handoff

If the recipient is on a different team (claude → codex or vice versa), use the same procedure. Both teams share the same paperclip company; UUIDs resolve regardless.

### Self-checkout on explicit handoff

If the sender's comment includes explicit handoff phrases (`"your turn"`, `"pick it up"`, `"handing over"`) AND assignee is already you, take the lock yourself: `POST /api/issues/{id}/checkout`.

### Comment ≠ handoff (iron rule)

Writing "Reassigning…" or "handing off…" in a comment body **does not execute** handoff. ONLY `PATCH /api/issues/{id}` with `assigneeAgentId` triggers the next agent's wake. Without PATCH, issue stalls with previous assignee indefinitely.

### Verify after PATCH

`GET /api/issues/{id}` immediately after PATCH. If `assigneeAgentId` doesn't match what you set → retry once. Still wrong → `status=blocked` + escalate Board with `@Board handoff PATCH ok but GET shows actual=<x>, expected=<y>`.

### Watchdog safety net

If your handoff PATCH was authored by a SIGTERM'd run, paperclip may suppress the wake event. Watchdog (`services/watchdog`) detects stuck `in_review` with `assigneeAgentId+null-execution_run` and fires recovery. Don't rely on it as primary mechanism — author handoffs correctly.
