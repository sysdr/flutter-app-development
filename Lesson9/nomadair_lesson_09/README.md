# NomadAir — Lesson 09: Mastery Challenge — The NomadAir Shell

**Module:** 1 — Environment, Project Bootstrap & Android Workflow

## Rubric

| Criterion           | Verification                                              |
|---------------------|-----------------------------------------------------------|
| Theme Consistency   | grep for Color(0x in features/ returns zero               |
| Token Usage         | Save dark → force-quit → relaunch → opens dark            |
| Accessibility       | TalkBack: all 3 screens navigable by swipe + double-tap   |
| Responsiveness      | Portrait: NavBar · Landscape: NavRail · Fold: NavRail ext |
| Component Purity    | grep for ElevatedButton in features/ returns zero         |

## Run

```
flutter pub get && flutter run -d emulator-5554
```

## Cleanup

Project cleanup script:

```
bash scripts/cleanup.sh
```

What it does:
- Stops Android emulator and adb processes
- Stops all running Docker containers
- Removes unused Docker containers/images/networks/volumes
- Prints final status

Python requirements file for this lesson lives at:

`../requirements.txt`

## Peer Review Submission

1. Screen recording: Discover → Search (validation) → Trips → theme toggle
2. GitHub repository link
3. Self-assessment checklist from lesson_article.md
