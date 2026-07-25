---
name: react-native
description: Run, build, and test React Native / Expo apps. Use for RN/Expo projects — detect Expo vs bare React Native first.
---
# React Native / Expo

## Detect
- `app.json`/`app.config.*` with an `expo` dependency → **Expo**.
- `ios/` + `android/` native dirs and no expo → **bare RN**.
- Package manager: detect as in the `web-frontend` skill.

## Expo
- Install: `<pm> install`
- Start: `npx expo start` (`-i` iOS sim, `-a` Android)
- Native prebuild: `npx expo prebuild`
- Checks: `npx tsc --noEmit`, `<pm> lint`, `<pm> test`

## Bare RN
- iOS: `cd ios && pod install` then `npx react-native run-ios`
- Android: `npx react-native run-android`

Read `package.json` scripts first.
