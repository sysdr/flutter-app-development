# NomadAir — Lesson 05: Custom Design System Foundations

**Module:** 1 — Environment, Project Bootstrap & Android Workflow

## What This Teaches

- `sealed class` for component variant selection — no boolean flag explosions
- `MaterialStateProperty.resolveWith` for per-state visual resolution
- `InputDecoration` fully token-driven via NomadThemeExtension
- Dartdoc as a public API contract on every component
- WCAG 2.1 accessibility: Semantics, 48dp touch targets, error-via-text

## Components Built

| Component       | Variants                              |
|-----------------|---------------------------------------|
| NomadButton     | FilledVariant · OutlinedVariant · GhostVariant |
| NomadCard       | FlatCard · ElevatedCard · OutlinedCard |
| NomadTextField  | (single class — states via props)      |
| NomadChip       | FilterChip · ActionChip                |

## Run

```
flutter pub get && flutter run -d emulator-5554
```

## Cleanup Notes

- Runtime artifacts such as `node_modules`, `venv`, `.pytest_cache`, `__pycache__`, `*.pyc`, and `*istio*` should be removed from this project when present.
- Docker cleanup utility is available at `./project_cleanup/cleanup.sh`.

## Git Push Essentials

- Keep this `README.md` and the root `.gitignore` in `nomadair_lesson_05/`.
- Ensure runtime/build artifacts stay ignored before pushing.
