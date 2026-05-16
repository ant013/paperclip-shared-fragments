## Worktree discipline (implementer / reviewer / qa)

### Per-team isolated worktree

Each agent runs in its own workspace under `<team_workspace_root>/<AgentName>/workspace/`. This directory is the agent's `cwd`. **Do not** `cd` outside it for git operations — every commit/push originates from this worktree.

### Never remove shared workspace dirs

Workspaces under `<team_workspace_root>/<AgentName>/workspace/` are persistent: branch rotates per slice, the directory does not. **Never** `git worktree remove <AgentName>/workspace` — you'll wipe in-progress state of another agent if you happen to share the team_workspace_root.

### Cross-branch carry-over forbidden

Switching branches inside an agent worktree drags uncommitted changes across branches and contaminates the next slice. Discipline:
- Before switching branch: commit or stash.
- Before starting a new feature branch: `git status --short` must be clean.

### Operator vs production checkout

The `production_checkout` path (e.g. `{{paths.production_checkout}}`) is the iMac deploy target. Stay on `{{project.integration_branch}}` (typically `develop`) there — never check out feature branches in production_checkout. Discovered in {{project.issue_prefix}}-48: feature checkout in production_checkout caused QA to test stale code.
