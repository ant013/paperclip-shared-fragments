## Git workflow (iron rule)

- Work **only** in a feature branch. Create from `develop`: `git checkout -b feature/X origin/develop`.
- Open PR **into `develop`**, not `main`. `main` updates only via release flow (develop → main).
- Before PR: `git fetch origin && git rebase origin/develop`.
- Force push on `main` / `develop` — **forbidden**. On a feature branch — only `--force-with-lease`.
- Direct commits to `main` / `develop` — **forbidden**.
- Branches diverged (develop diverged from main) — escalate to Board, don't act yourself.
