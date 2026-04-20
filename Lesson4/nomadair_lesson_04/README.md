# nomadair_lesson_04

**Use this file as the only `README.md` for Git push** — it documents how to run and test this repo with no other root readme required.

Standalone Flutter app (NomadAir Lesson 04 — metrics demo and design-token explorer tabs).  
Clone or open **this folder** as the project root; `flutter run` does not depend on any parent directory.

If you also keep a local `Lesson4/setup.py` outside this repo for bootstrapping, that script is optional and not needed after you clone this project.

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) (stable channel recommended)
- Dart SDK bundled with Flutter (see `pubspec.yaml` → `environment.sdk`)
- For **Android**: Android Studio / Android SDK, emulator or device
- For **iOS** (macOS only): Xcode

```bash
flutter doctor -v
```

## Run the app

From this directory:

```bash
flutter pub get
flutter run
```

Target a device:

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d <device-id>   # flutter devices
```

## Tests

```bash
flutter test
```

## Integration tests (device / emulator)

```bash
flutter test integration_test/app_test.dart -d <device-id>
```

Or:

```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d <device-id>
```

## Docker cleanup (optional)

`cleanup.sh` stops Docker containers and prunes unused images/volumes. Requires Docker Desktop (or Docker Engine) running.

From this directory:

```bash
bash cleanup.sh
```

On Windows, use Git Bash, WSL, or another environment with `bash`.

## Python / `requirements.txt`

This app is **Flutter/Dart only**. See `requirements.txt` for notes. You do not need `pip install` to run the app.

## Project layout

- `lib/` — application code (`main.dart`)
- `test/` — widget tests
- `integration_test/` — integration tests
- `android/`, `ios/` — platform projects
- `.gitignore`, `cleanup.sh`, `requirements.txt` — repo hygiene / optional tooling

## Troubleshooting

- Dependencies: `flutter pub get` and fix any `flutter doctor` issues.
- Android build: finish SDK setup in Android Studio; `local.properties` is generated locally (gitignored).
