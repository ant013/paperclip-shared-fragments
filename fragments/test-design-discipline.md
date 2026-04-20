## Test-design discipline (iron rule)

**Substrate** = external library classes (DB drivers, HTTP clients, protocol
libraries), subprocesses, filesystem-as-subject. NOT substrate = your
project's own modules + pure functions + time/random.

### Don't mock substrate in happy-path tests

A type-safe mock (configured to look like an external class) passes
attribute access the real API won't support. Common failure: test passes
against mock, production crashes because mocked methods don't exist in
the installed library version, or a new call path hits a method the mock
never configured.

Use real substrate where feasible: test containers for databases, real
subprocess invocations for CLI tools, temp directories for filesystem,
transport-level mocks for HTTP (not client-class mocks).

**Error-path tests MAY continue to use mocks freely.** This rule targets
happy-path only. Explicit examples of legitimate mock usage:

- Timeouts (`asyncio.wait_for` raising `TimeoutError` / `asyncio.TimeoutError`).
- Driver exceptions (connection resets, service-unavailable, client errors).
- OS-level errors in subprocess streams.
- HTTP 5xx responses via transport-level mocks.
- Specific race conditions hard to reproduce on real substrate.

The rule is: use real substrate for the **success path** of substrate-touching
code. Error paths retain mocks — real substrate rarely reproduces them cleanly
and doing so blows up CI runtime.

### Touching shared infrastructure → full test suite, not scoped

When your diff changes entry points (application startup), shared
schema/storage, or framework runners, run the full test suite before
pushing. Scoped runs (single directory, keyword filter) can miss
downstream regressions in tests that depend on the shared code but live
in unrelated directories.

### CR checklist (enforced Phase 1.2 + 3.1)

- [ ] Plan task mocks a substrate class in happy path → CRITICAL finding.
- [ ] Diff adds a new mock of a substrate class → NUDGE; verify a
      real-fixture integration test exists for the same code path.
- [ ] Compliance-comment test output shows scoping (directory filter,
      keyword filter, or similar) when the diff touches shared
      infrastructure → NUDGE, rerun the full suite.

Your project's local test-design addendum lists concrete shared-infra
paths and past incidents.
