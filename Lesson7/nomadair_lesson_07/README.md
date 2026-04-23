# NomadAir — Lesson 7: Dark Mode Explorer

Documentation, `requirements.txt`, and `project-cleanup/` live **in this folder** with the Flutter app. The bootstrap script is one level up: **`../setup.py`**.

## Layout

| Path | Purpose |
|------|--------|
| `../setup.py` | Generate, test, run the app (`--generate`, `--test`, `--run`) |
| `requirements.txt` | Python dependency note for `../setup.py` (no pip packages on 3.11+; see file) |
| `project-cleanup/cleanup.sh` | Optional Docker cleanup on the host |
| `stop.sh` | Best-effort stop of Flutter / Dart / emulator processes (Git Bash / WSL) |
| `.gitignore` | Ignores for this app, build output, caches, secrets, and `../setup.py` Python caches |

## Prerequisites

- **Python** 3.11+ (for `../setup.py` only)
- **Flutter** (stable) + device or emulator

## First-time setup (after clone)

```bash
# From this directory (nomadair_lesson_07)
pip install -r requirements.txt   # may install nothing on Python 3.11+

# If the project is not generated yet, from parent directory:
cd ..
python setup.py --generate
cd nomadair_lesson_07

flutter pub get
flutter run -d emulator-5554
```

Or from the **lesson** folder:

```bash
python setup.py --generate
python setup.py --test
python setup.py --run
```

## Docker (optional)

From this directory:

```bash
cd project-cleanup
chmod +x cleanup.sh
./cleanup.sh
```

This does not start the emulator or the app.

## Security

Do not commit API keys, `.env` files, or keystores. See `.gitignore`.
