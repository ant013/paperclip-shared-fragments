## Evidence rigor

When implementer comment claims "no new mypy errors / no new ruff errors
/ no new test failures / N pre-existing", paste the **exact tool output**:

    $ uv run mypy --strict src/
    Found 4 errors in 1 file (checked 33 source files)
    src/palace_mcp/code_router.py:44: error: ...
    ...

If the claim is "all errors are pre-existing", show:

    $ git stash; uv run mypy --strict src/ 2>&1 | wc -l
    8
    $ git stash pop; uv run mypy --strict src/ 2>&1 | wc -l
    8

(or equivalent diff against `origin/develop`).

CR Phase 3.1 must independently re-run the same commands and paste its
own output in the review comment. If implementer numbers don't match
CR numbers within ±1 line, REQUEST CHANGES regardless of CRITICAL count.

## Scope audit

Before passing CRITICAL review, CR runs:

    git log origin/develop..HEAD --name-only --oneline | sort -u

Each file in the diff must trace to a task in the spec. Files outside
declared scope → REQUEST CHANGES citing branch-hygiene fragment.

## Anti-rubber-stamp enforcement (iron review rule)

Review without a full compliance checklist = **automatic REQUEST CHANGES**. "LGTM" without mechanical verification — forbidden.

### Compliance table format

Every checklist item MUST have one of three states with evidence:

| Status | Meaning | Required |
|---|---|---|
| `[x]` | Checked, OK | **Quote**: commit hash, file:line, test name, or screenshot |
| `[ ]` | Checked, NOT OK | **BLOCKER**: what's wrong + what to do. Verdict = REQUEST CHANGES |
| `[N/A]` | Not applicable | **Reason**: why this item isn't relevant to this PR |

### Forbidden patterns

- Empty `[ ]` without `BLOCKER:` explanation → **invalid** review, redo.
- `[x]` without quote / evidence → **invalid**, add evidence.
- Item skipped (not mentioned at all) → **invalid**, fill all.
- "Looks good", "LGTM", or Russian equivalents like "всё ок" without full table → **invalid**.
- Reference to "I checked in my head" without an artifact → **invalid**.

### Correct example

```
### Compliance

- [x] Result<T> instead of throw — `AddMedicationUseCase.kt:28` returns `Result<Medication>`
- [x] ViewModel via UseCase — `KitDetailViewModel.kt:45` calls `observeKitUseCase()`
- [ ] Cross-platform smoke — BLOCKER: iOS bridge helper not updated for new `imageUrl` field
- [N/A] Forward-only migration — PR doesn't touch `server/supabase/migrations/`
- [N/A] pgTAP test — no server-side changes
```

### Bug-registry feedback loop

When a prod bug is found and fixed:

1. Bug added to `docs/bug-registry.md` with root cause and error class.
2. From the root cause, derive a **new item** in the compliance checklist.
3. Next PR touching the same files / patterns is checked against the new item **mechanically**.

Turns "we missed it again" → "we physically can't miss it again".

## MCP wire-contract test (integration test rule)

Any tool registered via `@mcp.tool` / `register_X_tools` that crosses the
MCP wire boundary (callable from external MCP clients like Claude Code)
MUST have at least one test that:

1. Spawns a test FastMCP instance bound to a localhost port (or the
   palace-mcp container)
2. Connects via `streamablehttp_client` / SSE / actual MCP HTTP client
3. Calls `tools/list` — asserts the tool appears with correct `inputSchema`
4. Calls `tools/call` with FLAT arguments (not nested
   `{arguments: {...}}`) — asserts non-empty result on a known-good case
5. Calls `tools/call` with WRONG argument shape — asserts proper error

Mocks at the FastMCP signature-binding level (e.g. mocking `call_tool`
directly, calling `_forward()` programmatically) DO NOT count as MCP
integration tests. They test the implementation, not the contract.

### CR enforcement (Phase 3.1)

If a PR adds or modifies an `@mcp.tool` or passthrough decorator, CR MUST
verify there is an integration test file with `streamablehttp_client` or
equivalent real MCP HTTP client. If absent, REQUEST CHANGES.
