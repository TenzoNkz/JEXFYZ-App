# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #120 / run 39365201489 is the latest successful App release recorded in this handover. The latest single-event NOTIFY change remains source-only. Firmware has been version-bumped to V7.0 to align filename and `FW_VERSION` with the whole-degree Adaptive Fan fix; V7.0 is NOT COMPILED / NOT INSTALLED / NOT OTA-DEPLOYED.

## Latest successful build and current source boundary

- Build #120 passed 115 Flutter tests, Dart analyzer exit 0 (25 info diagnostics), configured Android gate, APK V1/V2/V3 and official-certificate checks, ZIP integrity, downloaded-asset comparison and exact tag/commit checks. Native Android test tasks were NO-SOURCE.
- APK asset `658178574`, 54,751,323 bytes, SHA-256 `aa162e57a04f229922cca4fe48773a49585328e2337761f5c641097957ff0392`; source ZIP asset `658178573`, 2,871,380 bytes, SHA-256 `3e7585549d2eef68ad93b35c378bd76332d80a92a0edf1856aec8303df5e28d7`.
- Current Home NOTIFY single-event blobs: lib/main.dart `a167e884f765a8a9fa976f197e0e4f7b1e188ac`; lib/app_settings.dart `44431e926bfa2557c26345899e2333bd767f3f8e`; test/widget_test.dart `c2cb9928fcb8388d51687b8907575c3f06b8cc66`. These postdate Build #120 and are SOURCE UPDATED / NOT RUN / NOT RELEASED.
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

## Adaptive Fan target update — source-only / NOT COMPILED

- `firmware/JEXFYZ-V7.0.ino` blob `823f6f31176695a3ff3a923995b1b3cd5f42c683`; `test/firmware_qc_contract_test.dart` blob `a44c12d32c472f109687c06316ea40f70fcf93ce`; `test/firmware_touch_adaptive_sync_test.dart` blob `b3e23e59deae19408cd7ccbacbad84273f958970`.
- Temperature target selection uses `floorf()` and integer whole-degree categories. At a 40°C limit, 36.3°C and 36.8°C both target 70%; target 80% starts at category 37. Immediate safety uses the original decimal value and is not delayed.
- The 10-point ramp cadence (up 1 s, down 10 s), one 1 Hz NTC sample and non-blocking control loop are preserved. Firmware tests and compile have NOT RUN for this revision.

## Home NOTIFY — single latest-event message (2026-10-20; source-only / NOT RUN / NOT RELEASED)

- Current blobs: `lib/main.dart` `a167e884f765a8a9fa976f197e0e4f7b1e188ac`; `lib/app_settings.dart` `44431e926bfa2557c26345899e2333bd767f3f8e`; `test/widget_test.dart` `c2cb9928fcb8388d51687b8907575c3f06b8cc66`.
- Home NOTIFY displays one complete sentence for the newest confirmed event; a new event replaces the old sentence. It never combines the Adaptive, Voltage, Fan and Peltier values in one summary.
- Covered confirmed events: Voltage, Fan/Peltier ON/OFF, Adaptive ON/OFF/profile/ceiling, Fan speed up/down, LED power/mode/brightness/color and safety-state changes. Repeated values do not repeat the event, and a delayed ACK cannot overwrite newer telemetry.
- Ordinary Temperature samples do not notify. Hotside at/above its configured limit shows the measured temperature and configured limit in the Home card in English/Indonesian and takes priority over ordinary control events. Android push remains preference-controlled and re-arms when Hotside cools below the limit.
- Language changes re-render the last event immediately. The fixed 44 dp card, BLE protocol/ownership, Firmware safety rules and OTA transport remain unchanged.
- Tests and analyzer have NOT RUN for the latest source; Build #120 does not contain it. No App Build, Firmware compile, BIN/Firebase, OTA, flash or device operation occurred.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V7.0.ino`, current blob `823f6f31176695a3ff3a923995b1b3cd5f42c683`; embedded `FW_VERSION="V7.0"`. Adaptive 12 V targets use floored whole-degree Hotside categories (at a 40°C limit, 36.x°C targets 70%, 37.x°C targets 80%). The raw-decimal safety override still forces 100% at the configured limit. Ramp cadence remains −10 percentage points every 10 seconds / +10 points every 1 second. Prior V6.9 compile/install was user-reported; V7.0 is NOT compiled/installed and source-to-BIN identity remains UNVERIFIED. OTA still needs a matching compiled/published BIN and Firebase metadata `version: "V7.0"`.
- Artifact repository TenzoNkz/JEXFYZ-Firmware has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `821b022f97353d9a7aea4695b2e37c98b7488e15`, 1,456,560 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
