## Phase orchestration (cto only)

CTO sequences a slice through these phases. Every phase ends with explicit handoff (per `handoff/basics.md`).

### Phase 1.1 — Formalize (CTO)

CTO verifies Board's spec+plan paths exist; swaps `{{project.issue_prefix}}-NN` placeholder for the real issue number; reassigns to CodeReviewer.

Handoff: `@CodeReviewer plan-first review of [{{project.issue_prefix}}-N]`.

### Phase 1.2 — Plan-first review (CodeReviewer)

CR validates every task in plan has concrete test+impl+commit; flags gaps. APPROVE → reassign to implementer.

Handoff (CR → implementer): `@<Implementer> plan APPROVED, begin implementation`.

### Phase 2 — Implement (PythonEngineer / MCPEngineer / etc.)

TDD through plan tasks on `feature/{{project.issue_prefix}}-N-<slug>`. Push frequently. When done, PR to `{{project.integration_branch}}`.

Handoff (implementer → CR): `@CodeReviewer mechanical review, PR <link>`.

### Phase 3.1 — Mechanical review (CodeReviewer)

CR pastes `uv run ruff check && uv run mypy src/ && uv run pytest` output (or project equivalent) AND `gh pr checks <PR>` output. APPROVE only with green CI proof. No "LGTM" rubber-stamps.

Handoff (CR → architect reviewer): `@OpusArchitectReviewer adversarial review, PR <link>`.

### Phase 3.2 — Adversarial review (OpusArchitectReviewer)

Find architectural problems, attack surfaces, missed edge cases. Findings addressed before Phase 4.

Handoff (Opus → QA): `@QAEngineer live smoke, PR <link>`.

### Phase 4.1 — Live smoke (QAEngineer)

On iMac (or production target). Real MCP tool call + CLI + direct invariant. Evidence comment authored by QAEngineer with concrete output (not paraphrased).

Handoff (QA → CTO): `@CTO QA evidence posted, ready to merge`.

### Phase 4.2 — Merge (CTO)

CTO merges via squash on green CI + APPROVED CR review + QA evidence. No admin override.

Post-merge handoff: `@CTO release-cut planned for <date>` (CTO of self) or no handoff (slice complete).

### Forbidden between phases

- `status=todo` between phases is forbidden. Always reassign explicitly.
- Skipping a reviewer (going straight from implementer to merge) is forbidden.
- Self-approval is forbidden (CR cannot APPROVE own implementation PR).
