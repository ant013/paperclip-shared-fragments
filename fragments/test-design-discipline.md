> **DEPRECATED (UAA Phase A, 2026-05).** QA-relevant content moved to `fragments/qa/smoke-and-evidence.md`.
> Will be removed at UAA cleanup gate (spec §10.5).

## Test Design Discipline

**Substrate** means external systems/classes: DB drivers, HTTP clients, protocol libraries, subprocesses, or filesystem-as-subject.

Not substrate: project modules, pure functions, time, or random.

### Happy Path

Do not mock substrate classes in happy-path tests.

Use real substrate where feasible:

- Test containers for databases.
- Real subprocesses for CLI tools.
- Temp directories for filesystem behavior.
- Transport-level HTTP mocks instead of client-class mocks.

Reason: substrate-class mocks can pass methods/attributes the real installed API does not support.

### Error Path

Mocks are allowed for error-path tests, including:

- Timeouts.
- Driver/client exceptions.
- OS-level subprocess stream errors.
- HTTP 5xx via transport-level mocks.
- Hard-to-reproduce races.

### Shared Infrastructure

If a diff touches entry points, shared schema/storage, or framework runners, run the full test suite before pushing. Scoped tests are insufficient.

### Code Review Checklist (Phase 1.2 + 3.1)

- Happy-path substrate-class mock in plan: CRITICAL.
- New substrate-class mock in diff: NUDGE; require real-fixture integration coverage for same path.
- Shared-infra diff with scoped-only test output: NUDGE; rerun full suite.

Project's local test-design addendum lists concrete shared-infra paths and past incidents.
