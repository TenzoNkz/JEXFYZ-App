# JE X FYZ — CURRENT PROJECT STATE

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Current HEAD at last workflow-state verification: aebda225240ac3c686a82c659ded1026bd151ca7
- Last functional workflow fix commit: b449fc15659efa781063ac178754d99c5501c8b5
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- Active Firmware: V4.5
- Active Firmware source: firmware/JEXFYZ-V4.5.ino
- Firmware source blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App main source blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- Active App Build trigger: .github/workflows/jexfyz-app-build-trigger.yml
- App Build trigger blob: 606d5dbef8b1b17054e510d6101a663359566073
- Active reusable App Build engine: .github/workflows/jexfyz-app-build-engine.yml
- App Build engine blob: 0452535b14ce1537368082fec4b716d6c7c36f67
- The temporary `.github/workflows/jexfyz-build.yml` Release-asset workflow is removed.
- The restored pair is based on the proven Build #50-era workflow configuration.
- Latest verified downloadable App Build: workflow run #2 (37201925842) / GitHub Release jexfyz-latest.
- Historical new-workflow Build run #1: 37199918015 [BUILT][VERIFIED] through signing; [BLOCKED] legacy Actions-artifact upload by quota.
- Build #53 passed App validation gates through signing but failed legacy artifact creation due GitHub Actions quota.
- Workflow delivery fix is committed and [VERIFIED]: APK publication now uses a GitHub Release asset; Actions-artifact creation is not used.

## CURRENT TASK / TRANSFER
- This execution restored the proven two-workflow App Build architecture under new filenames without changing App/Firmware runtime source.
- No App Build was executed by this workflow restore.

## FIRMWARE
- V4.5 remains active.
- V4.4 OTA was user-confirmed PASS for all OTA paths before V4.5 promotion.
- V4.5 fixes active-GATT disconnect ordering, emits OTA_UP_TO_DATE as a one-shot result, and gates rapid-rise protection on Peltier ON.
- Local OTA remains Golden/Protected.
- Online OTA remains V3.2-style bounded Wi-Fi/retry/result-indicator behavior.
- Yellow Online OTA progress layer remains removed.
- No executable delay() and no timing while() loops.
- V4.5 physical compile/BIN/flash/OTA validation remains unverified.

## APP
- BLE/P1 architecture is preserved.
- Online OTA recovery is explicit, independent of passive Auto Connect, and returns through normal P1 sync.
- Adaptive Ceiling, safety semantics, battery threshold ranges, OTA stage mapping, and password masking are synchronized with firmware.
- Current App source has passed audit, Dart analysis, Flutter tests, release APK compilation, and production signing verification in Build #53 and workflow run #2.
- Build #51 source parser defect and Build #52 signing-shell defect are fixed.
- Workflow run #2 successfully created/updated the GitHub Release and uploaded the APK.

## CI / BUILD
- App Build uses a manual issue trigger plus a reusable build engine.
- Trigger: `.github/workflows/jexfyz-app-build-trigger.yml` (issue `opened`/`reopened`, title/token gated).
- Engine: `.github/workflows/jexfyz-app-build-engine.yml` (`workflow_call`).
- The restored engine uses `actions/upload-artifact@v7` for the APK and Dart symbols, matching the proven Build #50-era delivery path.
- Normal push/PR events do not trigger App Build.
- The GitHub Release `jexfyz-latest` / `JEXFYZ-release.apk` from workflow run #2 remains the latest verified downloadable APK, but no post-restore build has been executed.

## VALIDATION BOUNDARY
- App source CI gates: PASS through production signing verification in Build #53.
- Downloadable release: workflow run #2 is the latest verified APK delivery via GitHub Release.
- Release asset: JEXFYZ-release.apk, 54,327,520 bytes, SHA-256 24fcd6f4d1f7843f34e8a31c352b43f23a581b57fc2d29ae71053eb7924092bb.
- GitHub Release tag: jexfyz-latest; Release ID: 403010611; asset ID: 609813273.
- Actions-artifact storage quota is again a known delivery dependency because the restored engine intentionally uses artifacts.
- Firmware V4.5 physical compile/BIN/flash/OTA validation: UNVERIFIED.
- No Build #53 APK is available for delivery.

## EXACT NEXT ACTION
- Keep the transfer docs synchronized.
- Continue using `.github/workflows/jexfyz-app-build-trigger.yml` for future explicit Build App commands; it invokes `.github/workflows/jexfyz-app-build-engine.yml`.
- Separately compile/flash V4.5 and perform physical Online OTA BLE disconnect/reconnect plus Local OTA validation.
