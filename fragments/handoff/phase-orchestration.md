## Phase orchestration (cto only)

CTO sequences a slice through these phases. Every phase ends with explicit
handoff (per `handoff/basics.md`). Role names below are target-local roster
slots, not literal cross-team aliases: in a Codex/CX lane use the CX/Codex
roster names, and in a Claude lane use the Claude roster names.

### Phase 1.1 — Formalize (CTO)

CTO verifies Board's spec+plan paths exist; swaps `{{project.issue_prefix}}-NN` placeholder for the real issue number; reassigns to the target-local code reviewer.

Handoff: target-local code reviewer plan-first review of `[{{project.issue_prefix}}-N]`.

### Phase 1.2 — Plan-first review (CodeReviewer)

CR validates every task in plan has concrete test+impl+commit; flags gaps. APPROVE → reassign to implementer.

Handoff (CR → implementer): `@<Implementer> plan APPROVED, begin implementation`.

### Phase 2 — Implement (PythonEngineer / MCPEngineer / etc.)

TDD through plan tasks on `feature/{{project.issue_prefix}}-N-<slug>`. Push frequently. When done, PR to `{{project.integration_branch}}`.

Handoff (implementer → CR): target-local code reviewer mechanical review, PR `<link>`.

### Phase 3.1 — Mechanical review (CodeReviewer)

CR pastes `uv run ruff check && uv run mypy src/ && uv run pytest` output (or project equivalent) AND `gh pr checks <PR>` output. APPROVE only with green CI proof. No "LGTM" rubber-stamps.

Handoff (CR → architect reviewer): target-local architect reviewer adversarial review, PR `<link>` (project may hire a specific architect-reviewer agent per its target).

### Phase 3.2 — Adversarial review (architect reviewer)

Find architectural problems, attack surfaces, missed edge cases. Findings addressed before Phase 4.

Handoff (architect-reviewer → QA): target-local QA engineer live smoke, PR `<link>`.

### Phase 4.1 — Live smoke (QAEngineer)

On iMac (or production target). Real MCP tool call + CLI + direct invariant. Evidence comment authored by QAEngineer with concrete output (not paraphrased).

Handoff (QA → CTO): target-local CTO QA evidence posted, ready to merge.

### Phase 4.2 — Merge (CTO)

Post-merge handoff: target-local CTO release-cut planned for `<date>` (CTO of self) or no handoff (slice complete).

### Forbidden between phases

- `status=todo` between phases is forbidden. Always reassign explicitly.
- Skipping a reviewer (going straight from implementer to merge) is forbidden.
- Self-approval is forbidden (CR cannot APPROVE own implementation PR).
