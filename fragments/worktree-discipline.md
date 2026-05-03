## Worktree discipline

Paperclip creates a git worktree per issue with an execution workspace. Work **only** inside that worktree:

- `cwd` at wake = worktree path. Never `cd` into the primary repo directory.
- Don't run `git` commands that change other branches (`checkout main`, `rebase origin/develop` from main repo).
- Commit changes to the worktree branch, push, open PR — all from the worktree.
- Parallel agents work in **separate** worktrees — don't read files from neighbors' worktrees (they may be in an invalid state mid-work).
- After PR merge — paperclip cleans the worktree itself. Don't run `git worktree remove` yourself.

## Shared codebase memory

Worktree isolation does not mean memory isolation. Claude and CX/Codex teams share the same code knowledge:

- Use `palace.code.*` / codebase-memory with project `repos-gimle` for indexed code search, architecture, snippets, and impact.
- Use `serena` only for the current worktree (`cwd`) and current branch state.
- Write durable findings through `palace.memory.decide(...)`; read them through `palace.memory.lookup(...)`.
- Each written finding needs provenance: issue id, branch, commit SHA when available, source path or symbol, `canonical` or `provisional`, and verification evidence.
- Treat `canonical` as facts grounded in `origin/develop` or merged commits. Treat `provisional` as branch-local hints that require local verification.
- Never treat another team's uncommitted worktree files as project truth. Share cross-team facts through commits, PRs, issue comments, or `palace.memory`.

## Cross-branch carry-over forbidden

Never carry commits between parallel slice branches via cherry-pick or
copy-paste. If Slice B's tests need Slice A, declare `depends_on: A`
in spec and rebase on develop after A merges.

Why: GIM-75/76 incident (2026-04-24) — see `docs/postmortems/2026-04-26-fragment-extraction-postmortems.md`.

CR enforcement: every changed file must be in slice's declared scope.

## QA returns checkout to develop after Phase 4.1

Before run exit, QA on iMac verifies the current team checkout or issue worktree
returns to the expected integration branch state:

    git switch develop && git pull --ff-only

Verify: `git branch --show-current` outputs `develop`.

Do not `cd` into another team's checkout to do this. Claude and CX/Codex teams
may have separate workspace roots; use the root or worktree assigned to your
current run.

Why: team checkouts drive deploys/observability for their own runtime. Incident
GIM-48 (2026-04-18).
