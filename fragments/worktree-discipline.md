## Worktree discipline

Paperclip creates a git worktree per issue with an execution workspace. Work **only** inside that worktree:

- `cwd` at wake = worktree path. Never `cd` into the primary repo directory.
- Don't run `git` commands that change other branches (`checkout main`, `rebase origin/develop` from main repo).
- Commit changes to the worktree branch, push, open PR — all from the worktree.
- Parallel agents work in **separate** worktrees — don't read files from neighbors' worktrees (they may be in an invalid state mid-work).
- After PR merge — paperclip cleans the worktree itself. Don't run `git worktree remove` yourself.

## Cross-branch carry-over forbidden

### Rule

Never carry changes between parallel slice branches by stash, cherry-pick,
git apply, or copy-paste. If Slice B's local tests fail because they need
Slice A's code, **wait** for Slice A to merge into develop, then
`git rebase origin/develop` on Slice B's branch.

### Why

In GIM-75/76 (2026-04-24), PythonEngineer working on GIM-76 carried a
GIM-75 chore commit so local tests would pass. Subsequent cleanup of
that carry-over commit accidentally deleted unrelated GIM-76 wiring
(`register_code_tools(_tool)`) — entire GIM-76 deliverable was dead
code, caught only at CR Phase 3.1 re-review. Cost: one extra round-trip
through Phase 2/3.1.

### Practical guidance

- If Slice B truly needs Slice A first → mark Slice B as `depends_on: A`
  in the spec frontmatter; CTO Phase 1.1 verifies dependency closure
  before starting Phase 2.
- If Slice B can be implemented in isolation but tests can't run → it's
  fine to write the impl + add `@pytest.mark.skipif(not _has_dep_a())`
  guards. Land it; integration tests come post-merge of A.
- Local development convenience (e.g. `git stash apply` from another
  branch in your own worktree) is fine; **never commit** that stash on
  the slice branch.

### How CR enforces

CR Phase 3.1 runs:

    git log origin/develop..HEAD --name-only --oneline | sort -u

and asserts every changed file is in the slice's declared scope. Any
file outside scope → REQUEST CHANGES citing this fragment.
