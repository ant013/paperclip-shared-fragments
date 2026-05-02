# Codex New Task Spec Gate

## Context

Codex agents are being prepared to work as Paperclip-compatible agents across
local and server environments. New repository-changing tasks should not start
with implementation. They need a visible branch and a reviewable spec first, so
the human operator can confirm scope before code changes happen.

This rule was added to the local global Codex instructions in
`/Users/ant013/.codex/AGENTS.md`. This spec records the intended behavior so it
can be reviewed, versioned, and later propagated to server Codex configs and
Paperclip agent bundles.

## Assumptions

- The repository may use `develop` as its integration branch, but this shared
  fragments repository currently has no remote `develop`; `main` is the
  integration branch here.
- Consumer repositories may already have their own Paperclip worktree and branch
  discipline. This rule must not force an agent to switch out of an assigned
  Paperclip issue worktree.
- The established spec location should be reused when present. If absent, use
  `docs/superpowers/specs/` for consistency with existing Paperclip projects.

## Scope

- Define the global Codex behavior for new repository-changing tasks.
- Require an up-to-date integration branch before creating a new task branch.
- Require a spec file before implementation.
- Require the branch name and spec path to be reported to the user for review.
- Keep implementation edits out of the spec commit.

## Out Of Scope

- Changing Paperclip adapter/model settings.
- Rewriting Paperclip build or deploy scripts.
- Updating existing project-specific role instructions.
- Installing or modifying Codex skills, subagents, or MCP servers.

## Required Behavior

For every new user-requested task that will change a repository, the agent must:

1. Fetch remote state with `git fetch origin --prune`.
2. Verify the integration branch is current before branching.
   - Prefer `develop` when it exists.
   - If `develop` does not exist, use the repository's established integration
     branch and state the choice.
3. Create a fresh task branch from the updated integration branch.
   - Prefer the repository's existing branch convention.
   - Otherwise use a scoped prefix such as `feature/`, `features/`, `core/`, or
     `fix/`.
4. Write a spec file in the repository's established specs location.
5. Include in the spec:
   - assumptions
   - scope and out-of-scope
   - affected files or areas
   - acceptance criteria
   - verification plan
   - open questions, if any
6. Commit and push only the spec.
7. Report the branch name and exact spec file path to the user.
8. Wait for review or approval before changing implementation files.

If the agent wakes inside an already assigned Paperclip issue worktree, it must
not switch out of that worktree. It should follow the existing worktree branch,
create or update the issue spec, report the path, and wait for approval unless
the issue already has an approved spec.

## Affected Areas

- Global Codex instructions: `/Users/ant013/.codex/AGENTS.md`
- Server Codex instructions, if synced later: `/Users/anton/.codex/AGENTS.md`
- Future Paperclip agent instruction bundles that should inherit the same
  behavior.

## Acceptance Criteria

- Global Codex instructions contain a section requiring branch + spec gate before
  implementation.
- A repository-changing task starts from an up-to-date integration branch.
- The first pushed commit for a new task contains the spec only.
- The user receives the branch name and spec path before implementation begins.
- Paperclip issue worktrees are not disrupted by branch switching.

## Verification Plan

- Confirm the global instruction file contains the new rule.
- In this repository, confirm the spec branch was created from the updated
  integration branch.
- Confirm the spec file is the only file staged/committed for this task.
- Push the branch and provide the path for review.

## Open Questions

- Should the same global rule be synced immediately to the iMac Codex config?
- Should Paperclip role templates include this rule directly, or should they rely
  on global Codex instructions only?
