---
name: java
description: Build, test, and run Java projects. Use for Java repos — detect Maven vs Gradle first.
---
# Java

## Detect
- `pom.xml` → Maven.
- `build.gradle` / `build.gradle.kts` → Gradle (prefer the `./gradlew` wrapper).

## Maven
- Compile: `mvn -q compile` · Test: `mvn -q test` · Package: `mvn -q package`

## Gradle
- Build: `./gradlew build` · Test: `./gradlew test` · Run: `./gradlew run`

Format if configured: `mvn spotless:apply` or `./gradlew spotlessApply`.
