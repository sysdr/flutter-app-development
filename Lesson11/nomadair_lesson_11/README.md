# NomadAir — Lesson 11: GoRouter Declarative Navigation

**Module:** 2 — Core Screens, Navigation, and Basic State

## What This Teaches

- `GoRouter` vs `Navigator.pushNamed` — the architectural difference
- `StatefulShellRoute.indexedStack` — per-tab back stacks
- `context.go` / `context.push` — replace all `Navigator.push` calls
- `state.extra as T` — typed route parameters
- `redirect` guard — auth gate skeleton (Firebase Auth in Lesson 25)
- `GoRouter.errorBuilder` — 404 for unmatched deep links
- `GoRouter.debugLogDiagnostics` — console route tracing

## Tab Stack Isolation

Navigate Discover → tap destination → tap Search tab → tap Discover tab
→ detail screen is still open (tab remembered its stack).

## Run

```
flutter pub get && flutter run -d emulator-5554
```

## Project Cleanup

From this project root, use:

```
flutter clean
```

Optional manual cleanup:
- Delete `.dart_tool/` and `build/` if they exist
- Re-run `flutter pub get`
