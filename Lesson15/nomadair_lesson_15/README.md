# nomadair_lesson_15 — NomadAir Lesson 15

Flutter app demonstrating **setState** scope, prop drilling, and **`AutomaticKeepAliveClientMixin`**.

This repository is standalone. You can clone and run it directly without any parent-folder tooling.

## Requirements

- **Flutter** SDK (stable), Dart **>=3.3.0** (see `pubspec.yaml`).
- Python is optional (only needed if you add your own helper scripts later).

## Run (after clone)

From **this directory** (`nomadair_lesson_15`):

```bash
flutter pub get
flutter run
```

Do not commit build output (`build/`, `.dart_tool/`, etc.). On first Android build, Gradle downloads dependencies. **`android/local.properties`** is machine-specific and gitignored.

## Cleanup & stopping services

| Script | Purpose |
|--------|---------|
| [`scripts/stop.sh`](scripts/stop.sh) | Stop Docker containers, Flutter/Dart (Windows), Android emulators. |
| [`scripts/cleanup.sh`](scripts/cleanup.sh) | Runs `stop.sh`, Docker prune, cleans Python caches and Flutter/Android caches **inside this app only**. |

```bash
bash scripts/cleanup.sh
```

## Security

Do not commit API keys or `.env` files.
