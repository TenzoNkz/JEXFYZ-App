# JE X FYZ — BUILD NOTES

## CURRENT PHASE
- Firmware V6.1 candidate is in **QC / PRE-RELEASE** on branch fix/adaptive-power-sequencing.
- main remains at V6.0 pending review/merge; V6.1 is **NOT RELEASED**.
- Firmware compile/BIN/flash/physical QC is unverified.
- App Build remains a separate explicit operation and was not requested.


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
