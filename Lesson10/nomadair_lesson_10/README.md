# NomadAir — Lesson 10: Screen Architecture and the Feature Folder Pattern

**Module:** 2 — Core Screens, Navigation, and Basic State

## What This Teaches

- Feature-folder pattern: `discovery/`, `search/`, `booking/`, `profile/`
- Page vs Screen vs Widget — the three distinct concepts and naming convention
- `abstract final class NavigatorRoutes` — route constants, GoRouter-ready
- Barrel `index.dart` with `show` clauses — enforced public API per feature
- Each feature: `screens/`, `widgets/`, `models/`, `state/`

## Folder Structure

```
lib/
├── main.dart
├── routes/
│   └── navigator_routes.dart
└── features/
    ├── discovery/
    │   ├── index.dart
    │   ├── models/   destination_model.dart
    │   ├── screens/  discovery_screen.dart  destination_detail_screen.dart
    │   ├── widgets/  destination_card_widget.dart  filter_chip_bar_widget.dart
    │   └── state/    discovery_state.dart
    ├── search/       index.dart  models/ screens/ widgets/ state/
    ├── booking/      index.dart  models/ screens/ widgets/ state/
    └── profile/      index.dart  models/ screens/ widgets/ state/
```

## Run

```
flutter pub get && flutter run -d emulator-5554
```

## Cleanup

From `Lesson10/temp_validation_2/`, run:

```
bash ./cleanup.sh
```

This script stops emulator/adb and Docker resources, and removes transient directories/files such as `node_modules`, `venv`, `.pytest_cache`, `*.pyc`, and `*istio*`.
