# NomadAir — Lesson 20

Standalone Flutter app (Local Persistence with **SharedPreferences + Hive**).

Generated files (`*.freezed.dart`, `*.g.dart`) are committed so you can **clone and run** without any Python generator or codegen steps.

## Requirements

- Flutter SDK (stable) with `flutter` on PATH
- Android Studio / Android SDK + an emulator (or a physical device)

## Run after clone

From this project root (the folder that contains `pubspec.yaml`):

```bash
flutter pub get
flutter run
```

Pick a device when prompted, or specify one:

```bash
flutter devices
flutter run -d emulator-5554
```

## Tests

```bash
flutter test
```

## Optional: regenerate code (only if you edit annotated sources)

```bash
dart run build_runner build --delete-conflicting-outputs
```

## What to demo (persistence)

1. Open **Search**
2. Enter From/To and run a search
3. Confirm the **recent search chip** appears
4. Close app and reopen → chip still appears (persisted)
