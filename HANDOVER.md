# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub main on 2026-10-19 (Asia/Jakarta). Build #106 remains the latest successful release; the current left-aligned NOTIFY and Battery/Hotside/Voltage animation update is source-only, NOT RUN / NOT RELEASED. CHAT_TRANSFER.md is the final handoff snapshot.

## Latest successful build and current source boundary

- Latest successful release is Build #106 / Actions run 39279938461, source `9f90cf6063ee7786613f8b5dfa1c6b0412d89638`. Analyzer exited 0 with 25 info findings/no errors or warnings, 108 Flutter tests passed, and the configured Android, signing, source ZIP and asset verification gates passed.
- Build #106 APK asset ID `656702702`, 54,734,939 bytes, SHA-256 `bab332a4312c628178e384a88d513cf8546ff15ab4b4e3f3becf2e70b10830cc`; corresponding source ZIP asset ID `656702729`, 2,866,720 bytes, SHA-256 `0bb86c4e6bd7d3cb7a6bb894658bd707acee48bac106fc5227f8adcba584ec98`.
- Current source after Build #106 is NOT RUN / NOT RELEASED. `lib/main.dart` `7e09a3d28b4efe24bdced858db4274cf70806284`; `lib/app_settings.dart` `8f228000d38d73038c06f569c052b1af601288a5`; `test/widget_test.dart` `5a82cf79e6c5c40fc34489ce90cf1200cf9faccb`.
- Home NOTIFY has no separate CONNECTED/DISCONNECTED badge; its heading and body are left-aligned and the body wraps to at most two lines. Battery/Hotside use clipped oval ember bursts instead of old tapered flame/drop particles. Voltage uses outer-contour pulses rather than a moving central spine or branch strikes. Firmware thresholds and all other icon families are unchanged.
Build #106 succeeded on older source and does not include these changes.
- No App Build/release, Firmware/BIN/Firebase/OTA/flash/device operation occurred. Request @Thinking Eksekusi Build App! separately before validation/release.

## Current approved icon behavior

- Battery/Hotside: complete silhouette when inactive/unknown; clipped oval ember bursts only under the existing thermal warning predicates.
- Voltage: bevelled static bolt face with edge-following pulses; no central spine/inner strikes. 5V red / 9V green / 12V blue.
- Adaptive: two distinct arrowheads and recessed track; rotates only when authoritatively ON.
- Peltier: six-branch faceted crystal; snow particles only while existing active-state rules permit them.
- Fan: exactly three swept blades, fixed airflow ribbons, bearing and blade-face highlights; existing voltage/PWM mapping and phase retarget remain.
- Fan Speed: semicircle, recessed bezel, 11 graded ticks and layered pivot; valid PWM drives the needle, unknown/disconnected values hide it.
- Static nav/settings/action glyphs remain static. Floating Monitor remains letters-only B/H/V/A/P/F; no telemetry/control/safety semantics change.

## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan/Kipas label; current value is live speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
Historical note: Build #95 was a successful intermediate release, later superseded by Build #100 and then Build #106. The current left-aligned NOTIFY and Battery/Hotside/Voltage visual follow-up is newer than Build #106 and remains untested/unreleased pending separate validation.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.8.ino`, blob `4f8011337fc3c9e3f1ace717fbd7179e1331bff8`; embedded `FW_VERSION="V6.8"`. The Adaptive 12 V Fan selector now maps Hotside-limit distance directly to 100/90/80/70/60/50%. V6.8 is SOURCE UPDATED / NOT COMPILED / NOT INSTALLED; only V6.7 has a prior user-reported compile/online update, not independently verified. Source-to-BIN identity and installed device version remain UNVERIFIED.
- Artifact repository TenzoNkz/JEXFYZ-Firmware currently has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
