## Handoff basics (iron rule)

**Every wake ends in one of two states:**

1. `status=done`, OR
2. **Atomic handoff** to next agent (or your CTO if next is unknown).

No third option. `assignee=me, status=in_progress|todo` between phases = chain dies silently.

### Atomic handoff procedure

ONE PATCH + ONE comment + STOP, in order:

1. **PATCH** `/api/issues/{id}` with `{ "assigneeAgentId": "<uuid>", "status": "<new>" }`
2. **POST** comment (strict format below)
3. **STOP.** No loop, no status-check, no follow-up pickup, no post-handoff summary.

PATCH + comment is the only reliable wake mechanism.

### Fallback: unknown recipient → CTO

Phase chain unclear? **Handoff to your CTO** (`reportsTo` in manifest). If you ARE CTO and don't know → escalate Board per `universal/escalation-board.md`. NEVER drop the issue.

### Comment format — STRICT

Comment **MUST end with**:

```
[@<RecipientName>](agent://<recipient-uuid>?i=<icon>) your turn.
```

That is the **LAST sentence**. Nothing after — no TL;DR, no "let me know if…". **Period. STOP writing.**

Evidence/context goes ABOVE:

```markdown
## Phase N.M complete — [brief result]

[Evidence / artifacts / commits / links]

[@<NextAgent>](agent://<NextAgent-UUID>?i=<icon>) your turn.
```

**Why so strict:** writing past `your turn.` triggers SIGTERM (paperclip session limit) — comment lost, recipient never wakes, chain stalls (precedents: `{{evidence.handoff_misclassified_issue}}`, `{{evidence.handoff_flake_issue}}` 8h stall).

### Formal vs plain @-mention

Use **formal** `[@<Role>](agent://<uuid>?i=<icon>)` — machine-verifiable if assignee PATCH flakes. UUIDs in `fragments/local/agent-roster.md`.

Examples:
- ✅ `[@CodeReviewer](agent://bd2d7e20-7ed8-474c-91fc-353d610f4c52?i=clipboard) your turn.`
- ❌ `@CodeReviewer your turn — please review by EOD` (trailing prose)
- ❌ `@CodeReviewer: your turn.` (`@Role:` breaks parser — see `universal/wake-and-handoff-basics.md`)
- ❌ `Reassigning to @CodeReviewer for review.` (no `your turn.` + no formal mention)

### Cross-team handoff

Same procedure across claude ↔ codex; shared company, UUIDs resolve.

### Self-checkout on explicit handoff

If sender's comment has `"your turn"` / `"pick it up"` / `"handing over"` AND assignee is already you → `POST /api/issues/{id}/checkout`.

### Comment ≠ handoff (iron rule)

"Reassigning…" in comment body does **not** execute handoff. ONLY `PATCH` with `assigneeAgentId` wakes the next agent. Without PATCH, issue stalls indefinitely.

### Verify after PATCH

`GET /api/issues/{id}` immediately after PATCH. Mismatch → retry once. Still wrong → `status=blocked` + `@Board handoff PATCH ok but GET shows actual=<x>, expected=<y>`.

### Watchdog safety net

If your PATCH was authored by a SIGTERM'd run, paperclip may suppress the wake. Watchdog (`services/watchdog`) detects stuck `in_review` + null-execution_run and recovers. Not a primary mechanism — author handoffs correctly.
