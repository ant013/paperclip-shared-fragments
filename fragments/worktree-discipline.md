## Worktree discipline

Paperclip creates a git worktree per issue. Work only inside it:

- `cwd` at wake = worktree path. Never `cd` into primary repo.
- No cross-branch git (`checkout main`, `rebase` from main repo).
- Commit/push/PR — all from the worktree.
- Parallel agents in separate worktrees; don't read neighbors' files (may be mid-work).
- Post-merge — paperclip cleans worktree itself; don't `git worktree remove` manually.

## Shared codebase memory

Worktree isolation ≠ memory isolation. Claude/CX teams share code knowledge:

- `palace.code.*` / codebase-memory with project `{{CODEBASE_MEMORY_PROJECT}}` for indexed search/architecture/impact.
- `serena` only for current worktree + branch state.
- Durable findings: write via `palace.memory.decide(...)`, read via `palace.memory.lookup(...)`.
- Each finding needs provenance: issue id, branch, commit SHA, source path/symbol, `canonical|provisional`, evidence.
- `canonical` = grounded in `origin/develop` or merged commits. `provisional` = branch-local hints needing local verification.
- Never treat other team's uncommitted files as project truth — share via commits/PRs/comments/`palace.memory`.

## Cross-branch carry-over forbidden

No cherry-pick / copy-paste between parallel slice branches. If Slice B needs Slice A, declare `depends_on: A` in spec, rebase on develop after A merges. CR enforces: every changed file must be in slice's declared scope.

Why: GIM-75/76 (2026-04-24) — see `docs/postmortems/2026-04-26-fragment-extraction-postmortems.md`.

## QA: restore checkout to develop after Phase 4.1

Before run exit, on iMac:

    git switch develop && git pull --ff-only

Verify `git branch --show-current` = `develop`. Don't `cd` into another team's checkout — Claude/CX may have separate roots; use yours.

Why: team checkouts drive their own deploys/observability. GIM-48 (2026-04-18).
