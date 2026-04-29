# NomadAir — Lesson 12: Deep Linking on Android

## What This Teaches

- `AndroidManifest.xml` intent filters: `nomadair://` + `https://nomadair.com`
- `launchMode="singleTop"` — prevents duplicate Activity on deep link
- GoRouter query param extraction: `state.uri.queryParameters`
- `DeepLinkHandler` — URI translation layer (external URL → internal GoRouter path)
- Cold start vs warm start deep link behaviour

## ADB Test Commands

```bash
# Cold start
adb shell am force-stop com.nomadair.lesson12
adb shell am start -W -a android.intent.action.VIEW \
  -d "nomadair://flights/search?from=BOM&to=DXB" com.nomadair.lesson12

# Warm start
adb shell am start -a android.intent.action.VIEW \
  -d "nomadair://discovery" com.nomadair.lesson12
```

## Run

```
flutter pub get && flutter run -d emulator-5554
```

## Cleanup

```
chmod +x cleanup.sh
./cleanup.sh
```
