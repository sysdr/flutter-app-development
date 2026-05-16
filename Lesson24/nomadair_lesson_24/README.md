# nomadair_lesson_24

NomadAir **Lesson 24** — Animated transitions, Hero animations, deep links, local cache, and HTTP (mock data by default).

Standalone Flutter project. No code generator or parent folder required.

## Prerequisites

- Flutter SDK 3.3+ (stable channel recommended)
- Android SDK (for Android emulator/device) or Xcode (for iOS)

## Quick start

```bash
flutter pub get
flutter run -d emulator-5554
```

List devices: `flutter devices`

## Tests (145 tests)

```bash
flutter test
```

Run a subset:

```bash
flutter test test/transitions/
flutter test test/deeplink/
```

## Regenerate code (only if you change `@freezed` / `@HiveType` models)

Generated files are already committed. After editing models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Amadeus API (optional)

Credentials are **not** in the repo. Mock flights are used by default (`MockConfig.useMock = true`).

```bash
flutter run \
  --dart-define=AMADEUS_KEY=your_client_id \
  --dart-define=AMADEUS_SECRET=your_client_secret
```

## Deep link demo (Android)

```bash
adb shell am start -a android.intent.action.VIEW \
  -d "nomadair://search?from=BOM&to=DXB" \
  com.nomadair.nomadair_lesson_24

# With date (cache-first search):
adb shell am start -a android.intent.action.VIEW \
  -d "nomadair://search?from=BOM&to=DXB&date=2026-05-16" \
  com.nomadair.nomadair_lesson_24
```

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/stop.sh` | Stop app, emulator, Dart/Gradle processes |
| `scripts/cleanup.sh` | Stop + Docker prune + `flutter clean` |

```bash
bash scripts/stop.sh
bash scripts/cleanup.sh
```

## Project structure

```
lib/
  core/          domain, cache, network, deeplink, transitions
  features/      search, discovery, mastery, booking, shell
  router/        GoRouter + CustomTransitionPage
packages/
  core/          design tokens, theme
  ui/            shared widgets
test/            unit tests (domain, storage, HTTP, cache, deeplink, transitions)
```

## Features (L24)

- `TransitionConfig` / `NomadTransitions` — slideUp, slideRight, fadeScale
- `HeroTags` — deterministic Hero tags on flight price and destination banner
- Custom transitions on flight and destination detail routes
- Deep links, Hive persistence, flight search cache (from prior lessons)
