# Paperclip Shared Fragments

Reusable building blocks для [Paperclip AI](https://github.com/paperclipai/paperclip) agent teams, переиспользуемые между проектами.

## Содержимое (v0.0.1)

- `fragments/` — атомарные `@include`-блоки правил (heartbeat discipline, git workflow, worktree discipline, pre-work discovery, language)
- `build.sh` — awk-препроцессор: резолвит `<!-- @include fragments/X.md -->`

## Consumers

- [Medic](https://github.com/ant013/Medic) — health/medication kit

## Status

**v0.0.1 — slice #1 validation.** Содержит только 5 existing Medic fragments без правок. Проверяется submodule viability. См. `Gimle-Palace/docs/superpowers/plans/2026-04-15-paperclip-shared-slice-1-submodule-viability.md`.

Расширение scope (fragments Category B, templates, research notes) — только после успеха slice #1.
