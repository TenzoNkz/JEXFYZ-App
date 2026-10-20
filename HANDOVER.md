# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #116 / run 39355262101 is the latest successful App release, packaging source `48683874db659df940272bed1c860072ead2d767`. The following bilingual localization/copy pass is source-only, NOT RUN / NOT RELEASED.

## Latest successful build and current source boundary

- Build #116 passed 109 Flutter tests, Dart analyzer exit 0 (25 info diagnostics), configured Android gate, APK V1/V2/V3 and official-certificate checks, ZIP integrity, downloaded-asset comparison and exact tag/commit checks. Native Android test tasks were NO-SOURCE.
- APK asset `657979004`, 54,734,939 bytes, SHA-256 `8570914f331583d2cc462f61881609c0eae56639a139f2d60a832e4aaa81ea27`; source ZIP asset `657979008`, 2,867,315 bytes, SHA-256 `60ef4e79529aabcbb4f4093b9f8a18b5d383d5c651c1c303dd8bb774e7b0dd5d`.
- Current lib/main.dart blob `07178b5cce55fc8f78cc7c2953f4d8e352ccefe7` and test/widget_test.dart blob `0a5901ac6dc23c947356189a312bb1dec418298e` are newer than Build #116; SOURCE UPDATED / NOT RUN / NOT RELEASED.
- Home contract: seven 45 dp rows; 3 dp gap before the fixed 44 dp notification card; localized `Notification` / `Notifikasi` heading with 2 dp top inset; left-aligned body scales to at most two lines; cooler image stays under stable sibling-row constraints.
- Battery/Hotside use refined falling flame-shaped background particles with warm yellow-white cores, a soft halo, subtle drift/rotation, and a rounded-frame clip combined with foreground-silhouette subtraction. Thresholds remain Battery ≥40°C and Hotside at configured limit.
- Firmware V6.9 compile/install is USER-REPORTED. Independent compile logs, source-to-BIN provenance, installed version and physical behavior remain UNVERIFIED. No Firmware/device operation was done in this task.

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

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`; embedded `FW_VERSION="V6.9"`. Adaptive 12 V target tiers remain 100/90/80/70/60/50%; downshift steps −10 percentage points every 10 seconds and upshift steps +10 points every 1 second. Voltage/thermal transitions reset the clock; Hotside limit/protection forces 100% immediately. Firmware V6.9 compile/install is USER-REPORTED. Compile logs, source-to-BIN identity and installed device version remain UNVERIFIED.
- Artifact repository TenzoNkz/JEXFYZ-Firmware has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `821b022f97353d9a7aea4695b2e37c98b7488e15`, 1,456,560 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
