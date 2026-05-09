# NomadAir Lesson 22

Standalone Flutter app for Lesson 22. This folder is self-contained and does not require `setup.py`.

## Run Locally

```bash
flutter pub get
flutter test
flutter run -d emulator-5554 --profile
```

## Notes

- API credentials are read from compile-time environment values:
  - `AMADEUS_KEY`
  - `AMADEUS_SECRET`
- No hardcoded production API keys are committed in this project.
