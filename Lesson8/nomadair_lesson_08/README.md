# NomadAir — Lesson 08: Inclusive Design and WCAG 2.1 Foundations

**Module:** 1 — Environment, Project Bootstrap & Android Workflow

## What This Teaches

- Flutter's SemanticsNode tree vs widget tree — separate concerns
- `Semantics`, `MergeSemantics`, `ExcludeSemantics` — when to use each
- 5 key semantic properties: label, button, textField, selected, liveRegion
- Touch target enforcement: 48×48dp via ConstrainedBox
- `AccessibilityAudit` — programmatic a11y check service
- TalkBack gesture simulation: focus, activate, navigate, scroll
- WCAG 2.1 AA contrast verification on all token pairs

## Android Verification

```
# Enable TalkBack
adb shell settings put secure enabled_accessibility_services \
  com.google.android.marvin.talkback/com.google.android.marvin.talkback.TalkBackService

# Disable TalkBack
adb shell settings put secure enabled_accessibility_services ""
```

Navigate Components tab with TalkBack — every teal-boxed component
must announce its label correctly and activate on double-tap.

## Run

```
flutter pub get && flutter run -d emulator-5554
```

## Cleanup

Project cleanup helper is available at:

`../tools/cleanup.sh`

This script:
- Stops running Android emulator and Flutter/Dart processes
- Stops all Docker containers
- Removes unused Docker containers/images/networks/volumes
- Cleans project artifacts: `node_modules`, `venv`, `.pytest_cache`, `*.pyc`

Run from the project root:

```bash
bash ../tools/cleanup.sh
```
