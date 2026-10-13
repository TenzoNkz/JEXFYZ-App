## CURRENT V6.2 FULL EXECUTION — 2026-10-13

- Active Firmware: `firmware/JEXFYZ-V6.2.ino`, blob SHA `eaf7ac76d20b7ba67dfc5a0abf5b4ef7083b9265`; last Firmware source update commit `cac71e8bdfc701a7ffb9b5e3fb1ea1bc6817884d`. V6.1 source retired.
- App: `lib/main.dart`, blob SHA `b30c641efafa61661798c5d42c445c2773318195`; latest App correction commit `116921bd28d280039ba191371fa276149466c802`; version unchanged at `1.0.0+3`.
- Thermal rules: 30-second protection stage at 12 V, 9 V and 5 V; Peltier OFF immediately, Fan 100%. Hotside <= `hotLimit - 1°C` for 5 continuous seconds before the 30-second deadline cancels the stage and keeps the rail. Otherwise 12 V/9 V steps down one rail and an unrecovered 5 V stage enters terminal manual-restart lock.
- Thermal voltage recovery: each upward rail needs 60 continuous seconds at or below `hotLimit - 1°C`, up to the saved Adaptive ceiling. Terminal 5 V lock does not auto-recover. Manual re-arm threshold is -1°C plus 5-second stability.
- Online OTA uses HTTPS CA validation while retaining the raw GitHub allowlist for `TenzoNkz/JEXFYZ-Firmware`. BLE command writes require an encrypted bonded connection with Secure Connections/Just Works. Local OTA was intentionally left unchanged.
- App updates: normal BLE reconnect scheduling after disconnect state update; OTA disconnect marker is armed before `CLOUDOTA`; voltage ACK is followed by authoritative `VOLTAGE` telemetry confirmation; RGB colors normalize optional `#`; Dashboard/Floating Monitor show unknown output status while offline; safety copy uses -1°C.
- Regression tests added/updated; `.gitignore` added. `pubspec.lock` remains BLOCKED until real dependency resolution can run with Flutter/Dart—no lockfile was fabricated.
- Validation: Flutter tests/analyze could not run because no Flutter/Dart executables or local checkout are available. No APK build, firmware compile, BIN, flash, OTA or physical-device validation was performed.
- Release state: V6.2 source-only DEVELOPMENT + QC / PRE-RELEASE, NOT RELEASED. Production firmware repository and Firebase metadata were not changed.

# JE X FYZ — BUILD NOTES

## CURRENT PHASE
- Firmware V6.1 is the active **source-only QC / PRE-RELEASE** target.
- V6.1 is **NOT RELEASED** and has no current compile/BIN/flash evidence.
- App Build remains a separate explicit operation.


## APP BUILD POLICY
- App Build is explicit and separate from Firmware build/flash.
- Manual issue trigger only.
- Issue title: JE X FYZ — BUILD APP TRIGGER
- Required token: JEXFYZ_BUILD_TRIGGER_V1
- One normal APK, not a Play Store bundle.
- Obfuscation is required.
- Java 17 / Flutter 3.47.2 stable / Gradle 9.3.1 / ubuntu-24.04.
- Production signing certificate SHA256: dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0

## CURRENT DELIVERY WORKFLOW
- [COMMITTED] .github/workflows/jexfyz-app-build-trigger.yml is the only active App Build workflow.
- [COMMITTED] It is triggered only by issue opened/reopened events and gated by repository owner, exact title, and JEXFYZ_BUILD_TRIGGER_V1.
- [VERIFIED] Current `.github/workflows` directory contains only `jexfyz-app-build-trigger.yml`; the former `.github/workflows/firmware-build.yml` was deleted in commit `32bc3c3fcb0c074e39d7ea49428f98d7845e4073`.
- [USER REQUIREMENT] Firmware compile/build must be explicitly requested; do not start it as an automatic consequence of source execution or documentation sync.
- [COMMITTED] Normal push/PR do not trigger App Build.
- [COMMITTED] Release build is obfuscated and production-signed.
- [COMMITTED] Exactly one APK is published to GitHub Release jexfyz-latest as JEXFYZ-release.apk.
- [COMMITTED] Actions-artifact upload is not used.
- [VERIFIED] Latest downloadable Release delivery is workflow run 37245703677.

## LATEST VERIFIED RELEASE BUILD
- [BUILT][VERIFIED] Workflow run: 37245703677.
- [VERIFIED] Source commit: fc4b89ce0c76b4b7826fc25cb8ac68ea843dc366.
- [VERIFIED] Security/architecture audit, dependencies, Dart analysis, Flutter tests, obfuscated APK compilation, production signing, and filename preparation passed.
- [VERIFIED] GitHub Release jexfyz-latest updated successfully.
- [VERIFIED] Exactly one Release asset exists: JEXFYZ-release.apk.
- [VERIFIED] Asset ID: 610989112; size: 54,327,520 bytes; SHA-256: a9d93bb3f359285bca1f2658f1336b502fd87539b0dec169282a9f2e59df1fc2.
- [VERIFIED] Actions artifact list for the run is empty.

## QC / BUILD BOUNDARY
- Firmware QC does not imply App Build.
- App Build does not prove Firmware compile, flash, OTA, or physical behavior.
- Do not run App Build unless the explicit Build App command is given.

- Firmware-only/integrated QC changes do not automatically trigger or require App Build.
- This V5.9 integrated execution did not start an App Build.
- Do not infer Firmware compile/BIN/physical validation from an App Build result.
