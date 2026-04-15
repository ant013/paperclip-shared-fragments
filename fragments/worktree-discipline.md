## Worktree discipline

Paperclip создаёт git worktree на issue с execution workspace. Работай **только** в этом worktree:

- `cwd` при wake = путь worktree. Никогда не `cd` в primary repo directory
- Не делай `git` команд которые меняют другие ветки (`checkout main`, `rebase origin/develop` из main repo)
- Изменения коммить в ветку worktree, пушить, открывать PR — всё из worktree
- Параллельные агенты работают в **разных** worktrees — не читай файлы соседних worktrees (они могут быть в невалидном состоянии посреди чужой работы)
- После merge PR — paperclip сам очистит worktree. Не запускай `git worktree remove` сам
