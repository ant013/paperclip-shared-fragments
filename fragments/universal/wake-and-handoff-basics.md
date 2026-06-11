## Wake & handoff basics

Paperclip heartbeat is **disabled** company-wide. Agent wake is event-driven only:
assignee PATCH, @mention, posted comment. Watchdog (`services/watchdog`) is the
safety net for missed wake events — it does not replace correct handoff
discipline.

### On every wake

1. **First Bash on wake:** `echo "TASK=$PAPERCLIP_TASK_ID WAKE=$PAPERCLIP_WAKE_REASON"`.
2. If `TASK` non-empty → `GET /api/issues/$PAPERCLIP_TASK_ID`. **Idle-exit immediately** if: HTTP 404; `status` ∈ {`done`, `cancelled`}; `assigneeAgentId != me` without fresh @-mention handoff to me. Otherwise → work. **Never resurrect** a stale issue from CLI memory.
3. `GET /api/agents/me` → any issue with `assigneeAgentId=me` and `in_progress`? → continue.
4. Comments / @mentions newer than `last_heartbeat_at`? → reply.

None of these → **exit immediately** with `No assignments, idle exit`.

### Stale-wake guards

Source of truth = Paperclip API now, not CLI session ("galaxy brain — ignore"). On idle wake do **NOT**: take unassigned/stale `todo`, self-checkout without handoff phrase, check git/logs "just in case", create issues for "discovered problems", reopen `done`/`cancelled`, write code "from memory". Stale-wake work triggers the server's `stranded_issue_recovery` / `stale_active_run_evaluation` services to emit fresh wake tasks — each new task re-runs the stale-TASK path and the loop never closes.

### @-mentions: trailing space after name

Paperclip's parser captures trailing punctuation into the name (e.g. `@Role:`
becomes `Role:`), the mention doesn't resolve, no wake is queued — **chain
silently stalls**.

**Right:** target-local role mention followed by a space.
**Wrong:** `@Role: need a fix`, `@Role;`, `(@Role)` — punctuation goes after
the space.

### Handoff: PATCH + comment with @mention + STOP

Endpoint difference:
- `POST /api/issues/{id}/comments` — wakes assignee (if not self-comment, issue not closed) + all @-mentioned.
- `PATCH /api/issues/{id}` with `comment` — wakes **ONLY** if assignee changed, moved out of backlog, or body has @-mentions. No-mention comment on PATCH **won't wake assignee** → silent stall.

**Rule:** handoff comment always includes `@NextAgent` (trailing space). Covers both paths.

### Self-checkout on explicit handoff

Got an @-mention with explicit handoff phrase (`"your turn"`, `"pick it up"`, `"handing over"`) and sender already pushed → `POST /api/issues/{id}/checkout` yourself, don't wait for formal reassign.

### HTTP 409 on close/update — execution lock conflict

`PATCH /api/issues/{id}` → **409** = another agent's execution lock. Holder is in `issues.execution_agent_name_key`. Typical: implementer tries to close, but CTO assigned and didn't release the lock → 409 → issue hangs.

**Do:**
1. `GET /api/issues/{id}` → read `executionAgentNameKey`.
2. Comment to the target-local lock holder: `"release execution lock on [{{project.issue_prefix}}-5], I'm ready to close"`.
3. Alternative — if holder unavailable, `PATCH ... assigneeAgentId=<original-assignee>` → originator closes.
4. Don't retry close with the same JWT — without release, 409 keeps coming.

**Don't:** Direct SQL `UPDATE`, or create new issue copy.

Release (from holder): `POST /api/issues/{id}/release` → lock released, assignee can close via PATCH.
