## Git workflow (железное правило)

- Работа **только** в feature-ветке. Создаём из `develop`: `git checkout -b feature/X origin/develop`
- PR открываем **в `develop`**, не в `main`. `main` обновляется только через release-flow (develop → main)
- Перед PR: `git fetch origin && git rebase origin/develop`
- Force push на `main`/`develop` — **запрещён**. На feature-ветке — только `--force-with-lease`
- Прямые коммиты в `main`/`develop` — **запрещены**
- Если ветки разошлись (develop diverged from main) — эскалируй Board, не действуй сам
