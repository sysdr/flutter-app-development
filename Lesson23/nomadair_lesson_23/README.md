# nomadair_lesson_23

Flutter lesson app. This folder is self-contained: no parent `setup.py` or generator is required to build or run.

## Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable), with `flutter doctor` clean for your target platform.

## Run

From this directory:

```bash
flutter pub get
flutter run
```

Generated Dart sources (`*.freezed.dart`, `*.g.dart`) are included so you do not need `build_runner` for a normal clone and run.

## Amadeus API (optional)

The app runs without credentials (mock/offline paths as implemented). For live Amadeus calls, pass keys at build time—do not commit real secrets:

```bash
flutter run --dart-define=AMADEUS_KEY=your_key --dart-define=AMADEUS_SECRET=your_secret
```

## Notes

- Commit `pubspec.lock` with the app so `flutter pub get` resolves the same versions on every machine.
- Do not commit `build/`, `.dart_tool/`, or `android/.gradle/`; they are listed in `.gitignore` and are recreated locally.

## Optional maintenance (Git Bash / WSL)

Scripts in `project_cleanup/` stop local dev processes and prune safe Docker/filesystem junk **inside this app folder only**:

```bash
bash ./project_cleanup/stop.sh
bash ./project_cleanup/cleanup.sh
```
