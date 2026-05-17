## Handoff basics (iron rule)

**Every wake ends in one of two states:**

1. `status=done`, OR
2. **Atomic handoff** to next agent (or your CTO if next is unknown).

No third option. `assignee=me, status=in_progress|todo` between phases = chain dies silently.

### Atomic handoff procedure

ONE POST + ONE PATCH + STOP, **in this exact order**:

1. **POST** comment `/api/issues/{id}/comments` (strict format below). MUST happen BEFORE the PATCH.
2. **PATCH** `/api/issues/{id}` with `{ "assigneeAgentId": "<uuid>", "status": "<new>" }`
3. **STOP.** No loop, no status-check, no follow-up pickup, no post-handoff summary.

**Why POST before PATCH:** paperclip API rejects POST `/comments` with 409 `"Issue is checked out by another agent"` AFTER assignee changes mid-run. POST-then-PATCH = comment lands first (still your lock), then PATCH transfers ownership. PATCH-then-POST = 409 → comment lost → recipient woken but with no evidence (precedent: smoke#2 2026-05-17, 3/5 CRs lost evidence comment).

POST + PATCH is the only reliable wake mechanism. Mention in POST wakes by mention; PATCH wakes by reassign.

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

If POST returned non-2xx → STOP. Don't PATCH (would orphan the issue without context). Escalate Board.

### Watchdog safety net

If your PATCH was authored by a SIGTERM'd run, paperclip may suppress the wake. Watchdog (`services/watchdog`) detects stuck `in_review` + null-execution_run and recovers. Not a primary mechanism — author handoffs correctly.
