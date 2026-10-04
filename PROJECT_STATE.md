# JE X FYZ — CURRENT PROJECT STATE

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Current HEAD at transfer: 9875cbe8e10f52572341e71cb1427f6f7bdc0e13
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- Active Firmware: V4.5
- Active Firmware source: firmware/JEXFYZ-V4.5.ino
- Firmware source blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App main source blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- App build workflow blob: 5c7faeb8fece972179a0607ffd2278bdfd174704
- App trigger workflow blob: 04d2293725e97c3cbc67ce8b6f0d9c1230802afd
- Latest verified downloadable App Build: #50
- Build #53 passed App validation gates through signing but failed artifact creation due GitHub Actions quota.

## CURRENT TASK / TRANSFER
- No functional source/release/build action is authorized by this transfer.
- Persist a complete context snapshot in CHAT_TRANSFER.md and keep source/workflows unchanged.

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
- Both App Build workflows were deleted and recreated on 2026-10-04.
- App Build remains manual-by-issue-trigger only.
- Release workflow requests actions: write and clears all current Actions artifacts before packaging.
- Cleanup repeats page 1 until the artifact list is empty, then asserts zero remaining artifacts.
- Release workflow publishes exactly one direct APK: JEXFYZ-release.apk, overwrite=true, retention-days=7.
- Dart symbols are generated for the obfuscated build but are not uploaded.
- Push/PR release triggers remain excluded.
- Cleanup workflow behavior is not yet proven by a successful post-reset artifact upload.

## VALIDATION BOUNDARY
- App source CI gates: PASS through production signing verification in Build #53.
- Downloadable release artifact: BLOCKED by Actions artifact quota at Build #53.
- Firmware V4.5 physical compile/BIN/flash/OTA validation: UNVERIFIED.
- No Build #53 APK is available for delivery.

## EXACT NEXT ACTION
- Keep the transfer docs synchronized.
- On the next explicit Build App command, execute the recreated manual workflow and verify artifact cleanup + one APK publication.
- Separately compile/flash V4.5 and perform physical Online OTA BLE disconnect/reconnect plus Local OTA validation.
