# JE Cooler Android Toolchain

| Component | Pinned version |
| --- | --- |
| Flutter | 3.47.4 stable |
| Dart | 3.13.3 (bundled with Flutter 3.47.4) |
| Android API | compileSdk 37 / targetSdk 37 |
| minSdk | 24 |
| Android Gradle Plugin | 9.2.0 |
| Gradle | 9.4.1 |
| Java | 17 |
| Kotlin Gradle Plugin | 2.4.0 |
| Google Services Gradle Plugin | 4.4.3 |

## Compatibility note

AGP 9 enables built-in Kotlin by default, but the current JE Cooler dependency graph still includes Flutter plugins whose Android Gradle integration is not yet suitable for a clean built-in-Kotlin migration. The project therefore uses Flutter's AGP 9 compatibility path with `android.builtInKotlin=false` and the external Kotlin Gradle Plugin. `android.newDsl=false` is retained for the same compatibility reason.

## CI

GitHub Actions provisions Flutter 3.47.4, Java 17, and Gradle 9.4.1. Because the repository did not contain the binary Gradle wrapper JAR, CI generates the wrapper from the pinned Gradle distribution immediately before the Flutter build.

The workflow runs `flutter pub get`, `flutter analyze`, `flutter test`, `flutter build apk --release`, and `flutter build appbundle --release`, then publishes both release artifacts.
