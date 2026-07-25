---
name: swiftui
description: Build, run, and test SwiftUI / Xcode iOS apps from the CLI. Use for Swift/SwiftUI projects (.xcodeproj, .xcworkspace, or Package.swift).
---
# SwiftUI / iOS (Xcode)

## Detect
- `*.xcworkspace` → use `-workspace`; else `*.xcodeproj` → `-project`; or SwiftPM `Package.swift`.

## Commands
- List schemes: `xcodebuild -list`
- Build: `xcodebuild -scheme <Scheme> -destination 'generic/platform=iOS' build`
- Simulator: add `-destination 'platform=iOS Simulator,name=iPhone 16'`
- Test: `xcodebuild -scheme <Scheme> -destination 'platform=iOS Simulator,name=iPhone 16' test`
- SwiftPM: `swift build`, `swift test`
- Format (if installed): `swift-format -i -r Sources`

Pipe through `xcbeautify` or `xcpretty` for readable output when available.
