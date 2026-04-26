## Worktree discipline

Paperclip creates a git worktree per issue with an execution workspace. Work **only** inside that worktree:

- `cwd` at wake = worktree path. Never `cd` into the primary repo directory.
- Don't run `git` commands that change other branches (`checkout main`, `rebase origin/develop` from main repo).
- Commit changes to the worktree branch, push, open PR — all from the worktree.
- Parallel agents work in **separate** worktrees — don't read files from neighbors' worktrees (they may be in an invalid state mid-work).
- After PR merge — paperclip cleans the worktree itself. Don't run `git worktree remove` yourself.

## Cross-branch carry-over forbidden

Never carry commits between parallel slice branches via cherry-pick or
copy-paste. If Slice B's tests need Slice A, declare `depends_on: A`
in spec and rebase on develop after A merges.

Why: GIM-75/76 incident (2026-04-24) — see `docs/postmortems/2026-04-26-fragment-extraction-postmortems.md`.

CR enforcement: every changed file must be in slice's declared scope.

## QA returns checkout to develop after Phase 4.1

Before run exit, QA on iMac:

    cd /Users/Shared/Ios/Gimle-Palace && git checkout develop && git pull --ff-only

Verify: `git branch --show-current` outputs `develop`.

Why: production checkout drives deploys/observability. Incident GIM-48 (2026-04-18).
