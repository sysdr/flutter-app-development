# NomadAir Lesson 13

Generated Flutter lesson project for Discovery Feed.

## Setup

Prerequisites:

- Flutter SDK in PATH

From this directory (`nomadair_lesson_13`):

- `flutter pub get`
- `flutter run -d <device-id>`

## Cleanup

Project cleanup script is available at:

- `./cleanup.sh`

The script attempts to:

- stop Flutter, adb, emulator, and related processes
- stop/remove Docker containers
- prune unused Docker resources (including images/volumes)

Run from this directory with:

- `bash ./cleanup.sh`

## Notes

- `requirements.txt` is included for Python environment clarity.
- No API keys are stored in this lesson directory.
