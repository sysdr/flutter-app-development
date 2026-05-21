# nomadair_lesson_25

NomadAir **Lesson 25** — Booking flow: `getFlightDetails`, 404 and 412 handling. Builds on L24 (transitions, Hero, deep links, cache, HTTP).

Standalone Flutter project. Clone and run without any generator script.

## Prerequisites

- Flutter SDK 3.3+ (stable channel recommended)
- Android SDK (`adb`, emulator) or Xcode (for iOS)
- Git Bash or WSL on Windows (for `scripts/*.sh`)
- Docker (optional, for `cleanup.sh`)

See `scripts/requirements.txt` for the tool list.

## Quick start

```bash
flutter pub get
flutter run -d emulator-5554
```

List devices: `flutter devices`

## Tests (160 tests)

```bash
flutter test
```

Run a subset:

```bash
flutter test test/booking/
flutter test test/transitions/
flutter test test/deeplink/
```

## Regenerate code (only if you change `@freezed` / `@HiveType` models)

Generated files are already committed. After editing models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Amadeus API (optional)

No API keys are stored in the repository. Mock flights are used by default (`MockConfig.useMock = true`).

```bash
flutter run \
  --dart-define=AMADEUS_KEY=your_client_id \
  --dart-define=AMADEUS_SECRET=your_client_secret
```

See `.env.example` for variable names (do not commit `.env`).

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/stop.sh` | Stop app, emulator, Dart/Gradle processes |
| `scripts/cleanup.sh` | Stop + Docker prune + remove caches + `flutter clean` |

```bash
bash scripts/stop.sh
bash scripts/cleanup.sh
```

## Deep link demo (Android)

```bash
adb shell am start -n com.nomadair.nomadair_lesson_25/.MainActivity \
  -a android.intent.action.VIEW \
  -d "nomadair://search?from=BOM&to=DXB"

adb shell am start -n com.nomadair.nomadair_lesson_25/.MainActivity \
  -a android.intent.action.VIEW \
  -d "nomadair://search?from=BOM&to=DXB&date=2026-05-21"
```

## Lesson 25 additions

- `lib/features/booking/` — booking errors, notifier, confirmation screen
- `test/booking/booking_notifier_test.dart` — 16 tests
- Router: `/booking/confirm` with slide-up transition

## Project structure

```
lib/
  core/           network, cache, deeplink, domain, transitions
  features/       search, booking, discovery, mastery, shell
  router/         go_router routes
packages/         nomadair_core, nomadair_ui
test/             domain, storage, network, cache, deeplink, transitions, booking
scripts/          stop.sh, cleanup.sh, requirements.txt
```
