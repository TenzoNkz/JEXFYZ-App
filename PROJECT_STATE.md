# JE X FYZ — CURRENT PROJECT STATE

## CURRENT TRUTH
- Project: JE X FYZ / JE Cooler
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- Active Firmware: V4.5
- Active Firmware source: firmware/JEXFYZ-V4.5.ino
- Firmware source blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App main source blob: f762f6d1cdd1351e57e7d93665ff2f5898769b42
- App settings source blob: f11235bab559b291928550e06984532581ddad6a
- App test source blob: aa86778beb8fcc3ce6a12454f6354f96ec99a160
- App build workflow blob: 5c7faeb8fece972179a0607ffd2278bdfd174704
- Latest verified downloadable App Build: #50
- Build #53 validation passed through signing but artifact upload was blocked by Actions quota.

## FIRMWARE
- V4.4 OTA: user-confirmed PASS for all OTA paths.
- V4.5 fixes active-GATT disconnect ordering, emits OTA_UP_TO_DATE as a one-shot event, and gates rapid-rise protection on Peltier ON.
- Local OTA remains Golden/Protected.
- Online OTA remains the V3.2-style bounded Wi-Fi/retry/result-indicator path.
- Yellow Online OTA progress layer remains removed.
- Functional Firmware version/file alignment: V4.5 / JEXFYZ-V4.5.ino.
- No executable delay() and no timing while() loops.

## APP
- BLE/P1 architecture is preserved.
- Online OTA recovery is explicit, independent of passive Auto Connect, and resumes normal P1 sync after restart.
- App/Firmware safety, Adaptive Ceiling, battery thresholds, and OTA stage presentation are synchronized.
- Current App source has passed Dart analysis, Flutter tests, release APK compilation, and production signing verification in Build #53.
- Build #51 source syntax issue and Build #52 signing shell issue are fixed.
- Build #53 produced no artifact because Actions artifact quota was exhausted.

## CI / BUILD
- Both App Build workflows were deleted and recreated on 2026-10-04.
- App Build remains manual-by-issue-trigger only.
- Explicit App Build starts by deleting all existing workflow artifacts, then publishes one APK only. Cleanup uses `actions: write` and repeats page 1 until the artifact list is empty.
- Issue title: JE X FYZ — BUILD APP TRIGGER
- Token: JEXFYZ_BUILD_TRIGGER_V1
- Workflow now publishes exactly one direct APK artifact named JEXFYZ-release.apk with overwrite enabled and 7-day retention.
- Dart symbols are generated for the obfuscated build but are not uploaded as a second artifact.
- Workflow has no push/PR release trigger.
- Trigger workflow blob: 04d2293725e97c3cbc67ce8b6f0d9c1230802afd.
- Current release workflow blob: 5c7faeb8fece972179a0607ffd2278bdfd174704.

## VALIDATION BOUNDARY
- App source CI validation: PASS in Build #53 through production signing verification.
- Release artifact delivery: BLOCKED by existing GitHub Actions storage quota.
- Firmware V4.5 compile/BIN/flash/physical validation: still pending on hardware.
- No Build #53 APK is available for delivery.

## EXACT NEXT ACTION
Delete or allow obsolete GitHub Actions artifacts to expire so storage usage can recalculate, then run the manual Build App trigger again. Separately compile/flash Firmware V4.5 and perform the physical OTA/BLE validation.
