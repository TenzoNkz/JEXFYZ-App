# JE X FYZ — CURRENT PROJECT STATE

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Last functional workflow fix commit: b449fc15659efa781063ac178754d99c5501c8b5
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- Active Firmware: V4.5
- Active Firmware source: firmware/JEXFYZ-V4.5.ino
- Firmware source blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App main source blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- Active App Build workflow: .github/workflows/jexfyz-build.yml
- App Build workflow blob: 08a137b4d315cc12e830a7e8dbc1ea40c3d2873d
- Legacy app-build.yml and app-build-trigger.yml are deleted.
- Latest verified downloadable App Build: #50
- Historical new-workflow Build run #1: 37199918015 [BUILT][VERIFIED] through signing; [BLOCKED] legacy Actions-artifact upload by quota.
- Build #53 passed App validation gates through signing but failed legacy artifact creation due GitHub Actions quota.
- Workflow delivery fix is committed: APK publication now uses a GitHub Release asset and no longer depends on Actions-artifact creation.

## CURRENT TASK / TRANSFER
- The current execution fixed CI delivery without changing App/Firmware runtime source.
- The next explicit Build App is required to prove end-to-end GitHub Release delivery.

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
- Current App source has passed audit, Dart analysis, Flutter tests, release APK compilation, and production signing verification in Build #53.
- Build #51 source parser defect and Build #52 signing-shell defect are fixed.
- Build #53 did not create a downloadable artifact because Actions quota was exhausted.

## CI / BUILD
- Legacy App Build workflows were deleted; one new single workflow `.github/workflows/jexfyz-build.yml` is current.
- App Build remains manual-by-issue-trigger only.
- Current workflow requests contents: write so it can publish a GitHub Release asset.
- The workflow no longer calls actions/upload-artifact and no longer relies on Actions-artifact storage.
- Release workflow publishes exactly one direct APK as GitHub Release asset jexfyz-latest/JEXFYZ-release.apk; existing asset is replaced with --clobber.
- Dart symbols are generated for the obfuscated build but are not uploaded.
- Push/PR release triggers remain excluded.
- The release publication path is [IMPLEMENTED][NOT YET VERIFIED] until the next explicit Build App run.

## VALIDATION BOUNDARY
- App source CI gates: PASS through production signing verification in Build #53.
- Downloadable release artifact: Build #50 remains the latest verified APK; the new Release-asset delivery path is implemented but awaits a real build.
- Actions-artifact quota is no longer a required delivery dependency for future builds.
- Firmware V4.5 physical compile/BIN/flash/OTA validation: UNVERIFIED.
- No Build #53 APK is available for delivery.

## EXACT NEXT ACTION
- Keep the transfer docs synchronized.
- On the next explicit Build App command, execute `.github/workflows/jexfyz-build.yml` and verify CI gates, signing, GitHub Release creation/update, and exactly one JEXFYZ-release.apk asset.
- Separately compile/flash V4.5 and perform physical Online OTA BLE disconnect/reconnect plus Local OTA validation.
