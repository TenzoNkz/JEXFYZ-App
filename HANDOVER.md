# JE X FYZ / JE Cooler — Current Handover

Latest verified App release is Build #124 / run 39386733061, packaged source commit 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a. It includes Wi-Fi password show/hide. Firmware V7.1 is a later source-only change and is NOT COMPILED / NOT DEPLOYED; prior V7.0 user-reported compile/OTA does not validate V7.1.

Reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #123 / run 39371864780 is the latest verified App release for source 14e90e7e26b8eb4400bd01ec8d0eab5ed4195f1c. The Wi-Fi password visibility patch remains source-only. User reports V7.0 compile and Online OTA success; exact source-to-BIN provenance / installed identity are not independently verified.

## Latest task checkpoint — 2026-10-20 (Firmware V7.1 source-only)

- Adaptive Fan targets now use 2°C whole-degree bands relative to configured Hotside Limit. At 40°C: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29 →50%.
- Active source `firmware/JEXFYZ-V7.1.ino`, blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`; QC `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive sync contract `7c203a11f79de62744af8536bbf2e3219d7f0909`.
- PWM cadence remains −10 points every 10 seconds / +10 points every 1 second. Raw-decimal limit safety, Adaptive 5/9 V fan speed, 1 Hz NTC sample, non-blocking timing, and rail/Peltier behavior remain unchanged.
- Contract tests and Arduino compile have NOT RUN for V7.1. Previous user-reported V7.0 compile/Online OTA does not validate this source revision. No V7.1 BIN/Firebase/OTA/flash/device operation occurred.
- OTA is protected and unchanged; Touch gestures unchanged. BLE App-only authorization remains BLOCKED pending trusted backend enrollment/signing.

## Latest successful App build and current source boundary

Build #124 / run `39386733061`, packaged source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`, APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`, source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`. It includes the Wi-Fi password Show/Hide toggle and Home NOTIFY, passed 116 Flutter tests and configured App release gates; analyzer exited 0 with 25 info diagnostics, native Android test tasks were NO-SOURCE.

- Build #124's APK/source ZIP do not contain the later Firmware V7.1 source update. V7.1 is NOT COMPILED / NOT DEPLOYED. Android `versionName "Telegram @horizontalzzz"` remains unchanged.
- This Firmware-only update did not modify App source or run another App Build.

## Current approved icon behavior

- Battery/Hotside: complete foreground silhouette when inactive/unknown. At warning thresholds, small falling orange/gold flame shapes with bright cores are drawn first, clipped to the rounded background frame minus the foreground silhouette, and painted behind the icon. The Hotside inner tube starts closer to the outer cap.
- Voltage: bevelled static bolt face with edge-following pulses; no central spine/inner strikes. The white inner core is inset and clipped to the bolt silhouette to prevent spill at the upper-right edge. 5V red / 9V green / 12V blue.
- Adaptive: two distinct arrowheads and recessed track; rotates only when authoritatively ON.
- Peltier: six-branch faceted crystal; snow particles only while existing active-state rules permit them.
- Fan: exactly three swept blades, fixed airflow ribbons, bearing and blade-face highlights; existing voltage/PWM mapping and phase retarget remain.
- Fan Speed: semicircle, recessed bezel, 11 graded ticks and layered pivot; valid PWM drives the needle, unknown/disconnected values hide it.
- Static nav/settings/action glyphs remain static. Home displays the localized `Notification` / `Notifikasi` heading; its fixed 44 dp card and two-line localized body remain. Floating Monitor remains letters-only B/H/V/A/P/F; no telemetry/control/safety semantics change.

## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan/Kipas label; current value is live speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
Historical note: Build #95 was an intermediate release, later superseded by Builds #100, #106, #108 and #110. The current top-down falling-fire/icon-geometry/Settings-About removal follow-up is newer than Build #110 and remains untested/unreleased pending separate validation.

## Adaptive Fan target update — V7.1 source-only / NOT COMPILED

- Active source `firmware/JEXFYZ-V7.1.ino` blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`; QC contract `12e30d7ec16b322e7411cefa7c99cd42aff6c056`; Touch/Adaptive sync contract `7c203a11f79de62744af8536bbf2e3219d7f0909`.
- Target bands relative to configured `hotLimit`: delta ≤2°C →100%; 3–4°C →90%; 5–6°C →80%; 7–8°C →70%; 9–10°C →60%; ≥11°C →50%. At limit 40°C: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29 →50%.
- Preserve immediate raw-decimal safety (Fan 100%, Peltier OFF at/above limit), PWM cadence (+10 points/1 s and −10 points/10 s), single NTC sample/sec, non-blocking loop, Touch and OTA contracts.
- Tests and Arduino compile have NOT RUN for V7.1; the V7.0 user report does not validate it.

## Home NOTIFY — single latest-event message (validated in App Build #124)

- Packaged source blobs: `lib/main.dart` `2d44e1f1f5b88ca1dae8324082da751b6ef1485a`, `lib/app_settings.dart` `637c07be55c412451d9ffde762e080c8bd92fd5e`, `test/widget_test.dart` `90e1a582c49ce3ad1a1d9a3b875921098eaf2545`.
- Home NOTIFY displays one complete sentence for the latest confirmed event; ordinary Temperature samples do not notify, and Hotside-at-limit remains the safety-priority exception.
- Build #124 passed 116 Flutter tests. App CI does not validate Firmware V7.1 or physical thermal behavior.

## Firmware / OTA boundary

- Active source is `firmware/JEXFYZ-V7.1.ino`, blob `6ef355d666b83fc83b4d7c48ee377753828ca02c`, embedded `FW_VERSION="V7.1"`. Adaptive 12 V targets use limit-relative 2°C bands; PWM cadence remains −10 points/10 s and +10 points/1 s; raw-decimal safety remains immediate. V7.1 is NOT COMPILED / NOT INSTALLED.
- Previous V7.0 compile/Online OTA success is USER-REPORTED for the old revision only. V7.1 source-to-BIN provenance, installed version and physical behavior remain UNVERIFIED.
- Artifact repo `TenzoNkz/JEXFYZ-Firmware` remains BIN-only and unchanged. No V7.1 BIN/Firebase/OTA/flash/device action occurred.
- OTA transport/state machine, Touch actions, Peltier soft-start, rail timing and BLE protocol were not changed. Android `versionName "Telegram @horizontalzzz"` is preserved.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
