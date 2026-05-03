# Codex plan skill name alignment

## Assumptions

- `paperclip-shared-fragments` has no `develop` branch; `main` is the integration branch.
- Claude agents are the production baseline and must keep the existing `superpowers:writing-plans` instruction unchanged.
- Codex agents have the `create-plan` skill installed and visible at runtime.
- The current mismatch is limited to generated Codex instructions referencing the Claude skill name.

## Scope

- Align Codex-target planning instructions with the installed Codex skill name.
- Preserve Claude-target wording and behavior.
- Keep the change limited to shared fragments / target substitution logic.

## Affected Areas

- `fragments/plan-first-producer.md`
- Any target map or build substitution needed to render Claude as `superpowers:writing-plans` and Codex as `create-plan`
- Generated validation output for Codex bundles

## Acceptance Criteria

- Claude output still references `superpowers:writing-plans`.
- Codex output references `create-plan`, not `codex-discipline:writing-plans` or `superpowers:writing-plans`.
- `rg "codex-discipline:writing-plans" .` returns no live instruction references.
- Existing Codex runtime map continues to list `create-plan`.
- The build/validation commands pass for the Codex target where available.

## Verification Plan

- Run repository search for the stale skill names.
- Run the fragment build for Codex in the consuming Gimle-Palace repo if needed.
- Run Codex target validation in the consuming repo if available.

## Open Questions

- None for this slice. A broader alias skill can be considered later, but this fix should use the currently installed `create-plan` skill directly.
