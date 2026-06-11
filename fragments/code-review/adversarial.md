## Code review: adversarial review

After mechanical review (Phase 3.1) approves, the target-local architect
reviewer runs the adversarial pass. Goal: find what mechanical review couldn't
see.

### Attack surface checklist

For every PR:
1. **Race conditions:** any new shared state? Any async without explicit ordering? Any DB migrations + concurrent writes?
2. **Error paths:** every `try` has a matching test? Every fallback documented (silent fallback = bug, see `silent-failure-hunter` agent)?
3. **Bypass paths:** any `--no-verify`, `--force`, `dangerouslyBypassApprovalsAndSandbox`? If yes — justified in PR description?
4. **Wire contracts:** if MCP tools touched, every error envelope has `error_code` + caller-side test that asserts on it (not just `if isError: pass`)?
5. **Idempotency:** if the change writes state (Neo4j, Tantivy, paperclip API), is the operation safe to re-run? Does the PR include an idempotency test?
6. **Resource bounds:** any unbounded loop? Any subprocess without `timeout=`? Any list comprehension over potentially-huge input?
7. **Trust boundaries:** any new input from untrusted source (HTTP body, env var, file path)? Validated?
8. **Time bombs:** any hardcoded date, version, or commit SHA that will break in N months?

### Output

Either:
- **APPROVED — adversarial pass clean.** (rare) Reassign to the target-local
  QA engineer from the local roster. In a Codex/CX lane this means the
  CX-prefixed QA role, never the bare Claude-side QA role.
- **CHANGES REQUESTED — N findings.** Post each finding as a separate comment with: location (`file:line`), severity (Block / Important / Nit), reproduction, suggested fix.

Adversarial findings are NOT advisory — implementer addresses each before Phase 4.
