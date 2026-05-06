# NomadAir — Lesson 19

Standalone Flutter app (**data modeling with Freezed**). Domain models live in `lib/core/domain/`. Generated `*.freezed.dart` files are committed so you can **clone and run** without codegen or Python.

> Use this `README.md` as the only project readme for GitHub. Optional parent lesson files (`setup.py`, etc.) are outside this folder and are not required to build or run this app.

## Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable), `flutter` on your `PATH`
- For Android: Android SDK / emulator or device
- For iOS (macOS): Xcode

## Run after clone

From **this project root** (the folder that contains `pubspec.yaml`):

```bash
flutter pub get
flutter run
```

Pick a device when prompted, or specify one:

```bash
flutter devices
flutter run -d <device_id>
```

## Tests

```bash
flutter test test/domain/domain_models_test.dart
```

## Regenerate Freezed code (optional)

Only needed if you change `@freezed` sources under `lib/core/domain/`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Layout

| Path | Description |
|------|-------------|
| `lib/` | App entry, router, features |
| `lib/core/domain/` | Freezed domain models + `*.freezed.dart` |
| `packages/core` | Shared design tokens / theme package |
| `packages/ui` | Shared widgets package |
| `test/domain/` | Domain model tests |

## Optional scripts (Git Bash / WSL)

`scripts/stop.sh` and `scripts/cleanup.sh` are optional helpers for adb/emulator/Docker; the app does not require them.

`scripts/requirements.txt` documents **optional** Python tooling only. The Flutter app does **not** use Python at runtime; use `pubspec.yaml` + `flutter pub get` for all app dependencies. See comments inside `scripts/requirements.txt` for when to use pip.

## Security

Do not commit API keys or `.env` files. This sample uses mocks and local prefs only.
