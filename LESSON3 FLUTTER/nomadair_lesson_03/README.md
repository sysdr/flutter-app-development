# Lesson 03 Flutter Workspace

This directory contains the Lesson 03 scaffold generator (`setup.py`) and the generated Flutter app (`nomadair_lesson_03/`).

## Common Commands (PowerShell)

```powershell
cd "C:\Users\syste\OneDrive\Documents\Flutter\lesson3 flutter"
python ".\setup.py" --test
python ".\setup.py" --verify
python ".\setup.py" --run
```

## Cleanup

Run:

```bash
bash ./cleanup.sh
```

The cleanup script attempts to:
- stop Docker containers
- remove Docker containers/images/unused resources
- stop Docker service/processes
- remove Python cache artifacts in this workspace

