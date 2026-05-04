# NomadAir — Lesson 17

Flutter app: mock flight search, discovery feed, and navigation (GoRouter + Provider).

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable), `flutter` on your `PATH`
- For **Android**: Android SDK (via Android Studio) and an emulator or device
- For **iOS** (macOS only): Xcode

## Run

From this directory (`nomadair_lesson_17/`):

```bash
flutter pub get
flutter run
```

Run tests:

```bash
flutter test
```

The app uses **local path packages** under `packages/core` and `packages/ui`; everything needed is inside this repository—no external generator or parent folder required.

## Optional: stop services & cleanup (Git Bash / WSL)

From this directory:

```bash
bash stop.sh      # stop adb emulators + running Docker containers
bash cleanup.sh   # runs stop.sh, removes venv/node_modules/caches/pyc/istio junk, then Docker prune
```

`requirements.txt` documents that the app uses **Dart only** (`pubspec.yaml`); Python is not required unless you add Python tooling.

**Warning:** `cleanup.sh` runs aggressive **`docker system prune -af --volumes`** (machine-wide unused Docker data).

## Git / clone

Do not commit machine-specific files (they are listed in `.gitignore`): `build/`, `.dart_tool/`, Android `local.properties`, IDE folders, and generated iOS Flutter scripts. After cloning, run **`flutter pub get`** then **`flutter run`**.
