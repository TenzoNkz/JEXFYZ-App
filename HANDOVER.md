# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub main on 2026-10-19 (Asia/Jakarta). Build #100 is the latest successful release for source 51bea70b2ca17f285bf35c3e547dc44c70f26d59. Notification copy/localization source changes are newer and NOT RUN / NOT RELEASED. CHAT_TRANSFER.md is the final handoff snapshot.

## Latest successful build and current source boundary

- Latest successful release is Build #100 / https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39237262140, source 51bea70b2ca17f285bf35c3e547dc44c70f26d59. All 21 workflow steps passed; 103/103 Flutter tests passed; analyzer exited 0 with 25 info-level findings and no errors/warnings; Android gate, APK signature/certificate, corresponding source ZIP and downloaded asset verification passed. Native JUnit steps were NO-SOURCE.
- Build #100 APK ID 655957943, SHA-256 a59c0a37b2025ad2b250bd4354b887379d96658e9f7757692691fa23b7b4d0a2. Source ZIP ID 655957946, SHA-256 e60c4705097009d843b624bf8f0f989770a76aba6fdfbdd8d2159d77f98890f1.
- Notification text/localization follow-up after Build #100 is source-only / NOT RUN / NOT RELEASED. Blobs: lib/main.dart 931b7e2d074b1006622b0f83cc6db3f8ce43a400; lib/app_settings.dart e91ecd2a00eafdec3f681daabb74fd49fcd25bf2; test/widget_test.dart ff419072b6eca1f3dc2c932b6290e3d664f75c17.
- The change normalizes Home status bodies, maps known safety reasons, hides raw internal tokens, classifies failed/unconfirmed commands in both languages, and shortens category labels. New regression tests are not run. Build #100 remains latest and does not include this source change.
- No App Build/release, Firmware/BIN/Firebase/OTA/flash/device operation occurred. Request @Thinking Eksekusi Build App! separately before validation/release.

## Current approved icon behavior

- Battery/Hotside: complete silhouette when inactive/unknown; falling ember effect follows existing state/warning predicates.
- Voltage: bevelled static bolt face; travelling current/branch sparks remain state-gated; 5V red / 9V green / 12V blue.
- Adaptive: two distinct arrowheads and recessed track; rotates only when authoritatively ON.
- Peltier: six-branch faceted crystal; snow particles only while existing active-state rules permit them.
- Fan: exactly three swept blades, fixed airflow ribbons, bearing and blade-face highlights; existing voltage/PWM mapping and phase retarget remain.
- Fan Speed: semicircle, recessed bezel, 11 graded ticks and layered pivot; valid PWM drives the needle, unknown/disconnected values hide it.
- Static nav/settings/action glyphs remain static. Floating Monitor remains letters-only B/H/V/A/P/F; no telemetry/control/safety semantics change.

## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan/Kipas label; current value is live speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
- Historical note: Build #95 was a successful intermediate release and validated the guarded tag/source check at that time. It was superseded by Build #100. The latest source-only notification text follow-up is newer than Build #100 and remains untested/unreleased pending separate validation.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.7.ino`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`; `FW_VERSION="V6.7"`; exactly one active versioned sketch. The user reports V6.7 compiled successfully and was updated online, but no compile log, resulting BIN, OTA log, source-to-BIN provenance or current device version was inspected here. V6.6 compile/OTA reports remain historical user reports.
- Artifact repository TenzoNkz/JEXFYZ-Firmware currently has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
