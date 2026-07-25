---
name: flutter
description: Run, test, analyze, build, and format Flutter / Dart apps. Use for Flutter projects (pubspec.yaml present).
---
# Flutter / Dart

- Deps: `flutter pub get`
- Run: `flutter run` (`-d <device>`; list with `flutter devices`)
- Test: `flutter test`
- Analyze: `flutter analyze`
- Format: `dart format .`
- Build: `flutter build <apk|ios|web|macos>`

Detect via `pubspec.yaml`. Respect existing `analysis_options.yaml` lint rules.
