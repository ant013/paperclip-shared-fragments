## Phase handoff discipline (iron rule)

Between plan phases, **explicit reassign** to next-phase agent. Never leave "someone will pick up".

Hand off via PATCH `status + assigneeAgentId + comment` in one call, then GET-verify assignee. Mismatch → retry once; still mismatch → `status=blocked` + escalate Board with `actual` vs `expected`. Silent exit (push without handoff) = 8h stall (GIM-182, GIM-48 precedents).

### Handoff matrix

| Phase done | Next | Required handoff |
|---|---|---|
| 1.1 Formalization (CTO) | 1.2 Plan-first | `git mv`/rename/`GIM-N` swap on FB directly (no sub-issue) → push → `assignee=CodeReviewer` + formal mention |
| 1.2 Plan-first (CR) | 2.x Implementation | `assignee=<implementer>` + formal mention |
| 2 Implementation | 3.1 Mechanical CR | `assignee=CodeReviewer` + push done + formal mention |
| 3.1 CR APPROVE | 3.2 Opus | `assignee=OpusArchitectReviewer` + formal mention |
| 3.2 Opus APPROVE | 4.1 QA | `assignee=QAEngineer` + formal mention |
| 4.1 QA PASS | 4.2 Merge | `assignee=<merger>` (usually CTO) + formal mention |

Sub-issues for Phase 1.1 mechanical work are anti-pattern per `cto-no-code-ban.md` narrowed scope.

### NEVER

- `status=todo` between phases (= unassigned, free to claim).
- `release` lock without simultaneous `PATCH assignee=<next>` — issue hangs ownerless.
- Keep `assignee=me, status=in_progress` after my phase ends — reassign before handoff comment.
- `status=done` without Phase 4.1 evidence comment authored by **QAEngineer** (`authorAgentId`).

### Handoff comment format

```
## Phase N.M complete — [brief result]

[Evidence / artifacts / commits / links]

[@<NextAgent>](agent://<NextAgent-UUID>?i=<icon>) your turn — Phase <N.M+1>: [what to do]
```

Formal mention `[@](agent://uuid)` only — not plain `@Role`. Plain works for comments, but handoff needs the formal recovery-wake form. UUIDs in `fragments/local/agent-roster.md`.

### Pre-handoff checklist (implementer → reviewer)

- [ ] `git push origin <feature-branch>` done — commits live on origin
- [ ] Local green (lint + typecheck + test, language-appropriate)
- [ ] CI running on FB (or auto-triggered by push)
- [ ] Handoff comment includes commit SHA + branch link

### Pre-close checklist (CTO → status=done)

- [ ] Phase 4.2 merged (squash on develop)
- [ ] Phase 4.1 evidence comment exists + `authorAgentId == QAEngineer`
- [ ] Evidence: commit SHA + runtime smoke + plan-specific invariant
- [ ] CI green on merge commit (or admin override documented in merge message)
- [ ] Production deploy completed (merge ≠ auto-deploy on most setups)

Any missing → don't close, escalate Board.

### Autonomous queue propagation (iron rule, post-merge)

After PR squash-merge, CTO MUST:
1. `PATCH issue` → `status=done, assigneeAgentId=null, assigneeUserId=null` + comment with merge SHA. Silent done = chain breaks.
2. If issue body lists "next-queue" / queue-position / autonomous-trigger pointer to a follow-up slice — POST a new issue for that next position, `assigneeAgentId=<my-team CTO>`, body links spec/plan + "queue N+1/M". Skipping = next slice never starts.

Precedent: GIM-229 stalled 12h post-merge because PR was squashed but issue stayed `blocked` and #6 was never opened.

### Phase 4.1 QA-evidence comment format

```
## Phase 4.1 — QA PASS ✅

### Evidence
1. Commit SHA: `<git rev-parse HEAD on FB>`
2. `docker compose --profile <x> ps` — containers healthy
3. `/healthz` — `{"status":"ok",...}` (or service equivalent)
4. Real MCP tool call — `palace.<tool>()` + output (not just healthz)
5. Ingest CLI / runtime smoke — command output
6. Plan-specific invariant — e.g. `MATCH (n) RETURN DISTINCT n.group_id`, expected 1 row
7. Production checkout restored to expected branch (per project's checkout-discipline)

[@<merger>](agent://<merger-UUID>?i=<icon>) Phase 4.1 green → Phase 4.2 squash-merge to develop.
```

`/healthz`-only or mocked-DB pytest = insufficient; real runtime smoke required.

### Lock stale edge case

If `POST /release` returns 200 but `executionAgentNameKey` doesn't reset (GIM-52, reported by OpusArchitectReviewer) — try `PATCH assignee=me` → `POST /release` → `PATCH assignee=<next>`. Fails twice → escalate Board with issue id, run id, attempt sequence.

### Self-check before handoff

- Formal mention written (not plain `@`)?
- Current assignee = next agent (GET-verified)?
- Push visible in `git ls-remote origin <branch>` (implementer only)?
- Evidence in my comment is mine, not retold (QA only)?

GET-verify fails after retry → `status=blocked` + `@Board handoff PATCH ok but GET shows actual=<x>, expected=<y>` + stop. Don't exit silently.

### Comment ≠ handoff (iron rule)

Writing "Reassigning…" or "handing off…" in a comment body **does not execute** handoff. Only `PATCH /api/issues/{id}` with `assigneeAgentId` triggers the next agent's wake. Without PATCH, issue stalls with previous assignee indefinitely. Precedents: GIM-126 (QA→CTO 2026-05-01), GIM-195 (CR→PE 2026-05-05).
