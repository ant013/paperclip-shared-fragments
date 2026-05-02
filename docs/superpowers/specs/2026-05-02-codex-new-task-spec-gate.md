# Codex Paperclip Team Spec Gate

## Context

The current Paperclip agent teams run on Claude and are considered working
production behavior. The migration goal is not to rewrite or weaken those
Claude instructions. The goal is to make it possible to assemble a duplicate
Paperclip agent team on Codex with comparable effectiveness, using Codex
models, MCP servers, plugins, skills, and subagents where equivalent behavior is
available.

New repository-changing Codex tasks must not start with implementation. They
need a visible branch and a reviewable spec first, so the human operator can
confirm scope before code changes happen.

This rule was added to the local global Codex instructions in
`/Users/ant013/.codex/AGENTS.md`. This spec records the intended behavior so it
can be reviewed, versioned, and later propagated to server Codex configs and
Paperclip agent bundles.

## Assumptions

- Claude agents are the baseline. Existing Claude workflows, skill names, role
  names, and handoff mechanics must not be removed from the Claude target.
- Codex may need analogous, not identical, runtime components. For example,
  Claude `superpowers:*` skills require confirmed Codex skill or instruction
  equivalents before Codex target rollout.
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
- Record the compatibility policy for creating Codex agent bundles alongside
  existing Claude bundles.

## Out Of Scope

- Removing or weakening Claude-specific workflows from the Claude target.
- Changing live Claude Paperclip agent bundles.
- Changing Paperclip adapter/model settings.
- Rewriting Paperclip build or deploy scripts.
- Installing or modifying Codex skills, subagents, or MCP servers.

## Claude Preservation Policy

- Claude target remains production baseline.
- Do not delete Claude workflow instructions from Claude output.
- Do not replace Claude skill names with Codex names inside Claude output.
- Do not rename working Claude roles in a way that changes Paperclip handoff
  semantics unless a separate migration spec covers the runtime rename.
- Any shared-fragment edit must preserve Claude behavior or be isolated behind a
  Codex-only target path.
- Claude output diffs are regression evidence. If a change modifies Claude
  output, the spec must explain why the behavior is unchanged or why the change
  is explicitly approved.

## Codex Duplicate Team Policy

The end state is a duplicate Codex Paperclip team with the same role coverage and
comparable operational discipline as the Claude team.

For every Claude runtime concept used by an agent instruction, the Codex target
must provide one of:

- a confirmed Codex skill/plugin/subagent/MCP equivalent;
- an explicit Codex instruction block that preserves the same behavioral
  discipline without invoking a missing skill;
- a documented gap that blocks Codex parity for that role.

Initial mapping categories:

| Claude concept | Codex target requirement |
|---|---|
| `CLAUDE.md` project rules | `AGENTS.md` or explicit project rules file |
| Claude MCP servers | Codex `config.toml` MCP servers |
| Claude `superpowers:*` skills | Confirmed Codex skills or explicit discipline text |
| Claude subagents | Codex agents from `~/.codex/agents` or role-specific aliases |
| Opus/high-tier reviewer model | Codex high-tier model setting and reviewer role |
| Claude-specific plugin names | Codex plugin/skill equivalent or documented gap |

Codex target must add analogs; it must not remove the Claude source behavior.

## Integration Branch Policy

- Prefer `develop` when the repository has `origin/develop`.
- If `origin/develop` does not exist, use the repository's established
  integration branch. Determine it from `origin/HEAD`, repo docs, or existing
  branch/deploy conventions.
- The agent must state the fallback reason. Example: "No `origin/develop`;
  using `origin/main` because `origin/HEAD -> origin/main`."
- Paperclip product repos that already require `develop` keep that requirement
  unless their own spec changes it.

## Git Preflight Algorithm

Before creating a task branch, run the equivalent of:

```bash
git status --porcelain
git fetch origin --prune
git branch -r
git symbolic-ref refs/remotes/origin/HEAD
```

Then:

1. If the worktree is dirty before the task starts, stop and report the dirty
   files. Do not stash, discard, or mix unrelated changes without explicit user
   approval.
2. If `origin` is missing, stop and report that branch/spec gate cannot verify
   remote state.
3. If fetch fails, stop and report the failure. Do not branch from stale refs.
4. Choose the integration branch using the Integration Branch Policy.
5. Switch to the integration branch, or create/reset a local tracking branch only
   when doing so does not overwrite local work.
6. Fast-forward only:

```bash
git switch <integration-branch>
git pull --ff-only origin <integration-branch>
test "$(git rev-parse <integration-branch>)" = "$(git rev-parse origin/<integration-branch>)"
```

7. Create a fresh task branch from the updated integration branch:

```bash
git switch -c <task-branch>
```

If the task branch already exists, choose a unique branch name or ask the user.

## Allowed Pre-Approval Change

The spec commit is the only allowed pre-approval repository change.

Before user approval, do not change implementation files, tests, migrations,
generated artifacts, dependency files, formatting-only files, or live deployment
configuration. The spec branch may contain only the spec and directly required
spec-directory scaffolding.

This gate intentionally applies to every repository-changing task, including
docs-only changes, typo fixes, and one-line hotfixes. The only exception is an
explicit user instruction to skip the spec gate for the current task. Emergency
hotfixes require explicit user wording and a post-fact spec note.

## Required Behavior

For every new user-requested task that will change a repository, the agent must:

1. Complete the Git Preflight Algorithm.
2. Create a fresh task branch from the updated integration branch.
   - Prefer the repository's existing branch convention.
   - Otherwise use a scoped prefix such as `feature/`, `features/`, `core/`, or
     `fix/`.
3. Write a spec file in the repository's established specs location.
4. Include in the spec:
   - assumptions
   - scope and out-of-scope
   - affected files or areas
   - acceptance criteria
   - verification plan
   - open questions, if any
5. Commit and push only the spec.
6. Report the branch name and exact spec file path to the user.
7. Wait for review or approval before changing implementation files.

If the agent wakes inside an already assigned Paperclip issue worktree, it must
not switch out of that worktree. It should follow the existing worktree branch,
create or update the issue spec, report the path, and wait for approval unless
the issue already has an approved spec.

## Failure Modes

- Dirty worktree: stop, list files, ask for direction.
- Missing `origin`: stop, report that remote freshness cannot be verified.
- Fetch failure: stop, report command and error.
- Missing `develop`: use documented fallback branch and state why.
- Detached HEAD: switch to the integration branch before branching, if safe.
- Existing task branch: choose a unique name or ask.
- Existing approved spec: report the existing spec path and proceed only within
  that approved scope.
- Paperclip worktree: do not switch away from the assigned worktree branch.

## Affected Areas

- Global Codex instructions: `/Users/ant013/.codex/AGENTS.md`
- Server Codex instructions, if synced later: `/Users/anton/.codex/AGENTS.md`
- Future Codex Paperclip agent instruction bundles.
- Future Codex target build/mapping for Paperclip roles.

## Acceptance Criteria

- Global Codex instructions contain a section requiring branch + spec gate before
  implementation.
- A repository-changing task starts from an up-to-date integration branch.
- Missing `develop` is handled through the documented fallback policy.
- Dirty worktree, missing remote, and fetch failure block branch/spec creation.
- The first pushed commit for a new task contains the spec only.
- The user receives the branch name and spec path before implementation begins.
- Paperclip issue worktrees are not disrupted by branch switching.
- Existing approved specs are reused instead of duplicated.
- Claude target behavior is not removed or weakened while adding Codex target
  support.
- Codex target work documents mappings for MCP servers, plugins, skills, and
  agents instead of deleting Claude runtime concepts.

## Verification Plan

- Confirm the global instruction file contains the new rule.
- In this repository, confirm the spec branch was created from the updated
  integration branch.
- Confirm the spec file is the only file staged/committed for this task.
- Push the branch and provide the path for review.
- For future Codex target work, compare Claude output before/after and verify
  that Claude-only workflow text remains in Claude output.
- For future Codex target work, verify Codex output has explicit analogs or
  documented gaps for each Claude runtime concept used by the role.

## Required Follow-Ups

- Decide whether to sync this global rule to `/Users/anton/.codex/AGENTS.md` on
  the iMac.
- Decide whether Paperclip role templates should include this gate directly, or
  rely on global Codex instructions.
- Align any future Codex role-prime fragments with the Integration Branch Policy
  without changing the working Claude role-prime behavior.
- Create a mapping spec for the duplicate Codex Paperclip team: role by role,
  MCP by MCP, skill by skill, plugin by plugin, and subagent by subagent.

## Open Questions

- Should Codex agent bundles be generated into separate `dist/codex/` outputs or
  managed as separate Paperclip agent records?
- Which Claude `superpowers:*` skills have confirmed Codex skill equivalents,
  and which should be represented as explicit instruction text?
