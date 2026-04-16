# NomadAir Lesson 01

Flutter project for lesson 01.

## Run the app

```bash
flutter pub get
flutter run
```

## Project cleanup

The root `cleanup.sh` script:

- stops running Docker containers
- removes unused Docker containers, images, volumes, build cache, and networks
- attempts to stop Docker service on Windows (`com.docker.service`) when possible

Run from project root:

```bash
chmod +x cleanup.sh
./cleanup.sh
```

PowerShell alternative:

```powershell
bash cleanup.sh
```

## Files in root

- `.gitignore`
- `requirements.txt`
- `cleanup.sh`
- `README.md`
