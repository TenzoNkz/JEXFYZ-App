# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #110 remains the latest successful App release. Current follow-up after that release includes top-down falling fire embers, Hotside/Voltage geometry corrections, removal of the Settings About section/page, and Firmware V6.9 Adaptive PWM pacing; these are source-only and unvalidated.

## Latest successful build and current source boundary

- Latest successful release: Build #110 / Actions run 39300262741, packaged source commit `b5adcffb2c9724a07cdba4cd8521c1307f1e6566`. Analyzer exited 0 with 25 info-level findings/no warnings or errors, 107 Flutter tests passed, the configured Android gate passed, and APK signing/source ZIP/downloaded assets/source-marker checks were verified.
- APK asset `656953696`, 54,734,939 bytes, SHA-256 `a7e46390a2b8a487eb85e69d33af685dbc79f9814c201cce9fd255e1164cf8ed`; source ZIP asset `656953697`, 2,866,251 bytes, SHA-256 `4b3095747a711888afa9879e70cd8d3fc74b22659e68f338e6e8cbc2430d12be`.
- Current Home geometry correction is newer than Build #110, NOT RUN / NOT RELEASED: `lib/main.dart` blob `08592a9d861a11ecdb8de1aa289f8ce06bf2e20c`; `test/widget_test.dart` blob `ec5e3d0eab341a269c6af91640a46c087481e58f`.
- Restored Home metric rows to 44 dp. NOTIFY is restored to the original left-icon/text-left Row, the separate connection badge is removed, body text stays normal size and wraps to at most two lines, and the card/slot is 56 dp. No other Home layout, tab, image, icon animation, BLE or control behavior was intentionally changed.
- The new row/card source contracts have NOT RUN. Do not infer they passed from Build #110; its source preceded this correction. No App Build was started.
- Firmware V6.9 is source-only / NOT COMPILED / NOT INSTALLED. Downsteps wait 10 seconds per 10 points; upsteps wait 1 second per 10 points, and a 9 V →12 V handoff restarts the downshift clock. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

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
Historical note: Build #95 was a successful intermediate release, later superseded by Builds #100, #106 and #108. The current Home geometry correction (44 dp metric rows, original left-icon/text-left NOTIFY Row, badge removed, 56 dp card/slot) is newer than Build #110 and remains untested/unreleased pending separate validation.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`; embedded `FW_VERSION="V6.9"`. The Adaptive 12 V Fan selector now maps Hotside-limit distance directly to 100/90/80/70/60/50%. V6.8 is SOURCE UPDATED / NOT COMPILED / NOT INSTALLED; only V6.7 has a prior user-reported compile/online update, not independently verified. Source-to-BIN identity and installed device version remain UNVERIFIED.
- Artifact repository TenzoNkz/JEXFYZ-Firmware currently has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
