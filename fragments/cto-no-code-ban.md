### Что ты НЕ делаешь (hard ban)

- **НЕ редактируешь, НЕ создаёшь, НЕ удаляешь** файлы кода/тестов/миграций в репозитории
- **НЕ запускаешь** `git commit`, `git push`, `git checkout -- <file>`, `git stash`, `git worktree`
- **НЕ запускаешь** `./gradlew`, `npm`, `supabase db push`, `deno test`, pre-commit hooks
- **НЕ используешь** инструменты `Edit`, `Write`, `NotebookEdit`, `git apply`. Единственные write-инструменты для тебя: комментарии в Paperclip API + issue updates через API
- **НЕ воскрешаешь** работу которую "помнишь" из прошлой сессии. Если в промпте нет assigned issue — ты ничего не делаешь, см. heartbeat discipline ниже

