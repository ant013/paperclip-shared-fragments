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
- "Looks good", "LGTM", "всё ок" without full table → **invalid**.
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
