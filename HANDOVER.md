# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #116 / run 39355262101 is the latest successful App release recorded in this handover. The bilingual localization copy pass remains source-only. Firmware has been version-bumped to V7.0 to align filename and `FW_VERSION` with the whole-degree Adaptive Fan fix; V7.0 is NOT COMPILED / NOT INSTALLED / NOT OTA-DEPLOYED.

## Latest successful build and current source boundary

- Build #116 passed 109 Flutter tests, Dart analyzer exit 0 (25 info diagnostics), configured Android gate, APK V1/V2/V3 and official-certificate checks, ZIP integrity, downloaded-asset comparison and exact tag/commit checks. Native Android test tasks were NO-SOURCE.
- APK asset `657979004`, 54,734,939 bytes, SHA-256 `8570914f331583d2cc462f61881609c0eae56639a139f2d60a832e4aaa81ea27`; source ZIP asset `657979008`, 2,867,315 bytes, SHA-256 `60ef4e79529aabcbb4f4093b9f8a18b5d383d5c651c1c303dd8bb774e7b0dd5d`.
- Current Home NOTIFY follow-up blobs: lib/main.dart `24cd98e54944cca57bcdade80d335f66aeefdc9e`; lib/app_settings.dart `44431e926bfa2557c26345899e2333bd767f3f8e`; test/widget_test.dart `e55a41dfeacc9ab5aee0e9bb31a0e21221bd9156`. These postdate Build #116 and are SOURCE UPDATED / NOT RUN / NOT RELEASED.
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

## Home NOTIFY live-state and localization fix — 2026-10-20 (source-only / NOT RUN / NOT RELEASED)

- Latest source/test fingerprints: `lib/main.dart` `24cd98e54944cca57bcdade80d335f66aeefdc9e`; `lib/app_settings.dart` `44431e926bfa2557c26345899e2333bd767f3f8e`; `test/widget_test.dart` `e55a41dfeacc9ab5aee0e9bb31a0e21221bd9156`.
- Home NOTIFY now follows the newest confirmed cooling telemetry instead of treating a successful command acknowledgement as a permanent message. Accepted Adaptive/Voltage/Fan/Peltier/Fan Speed commands move the card to a compact summary built from current mode, voltage, Fan state/speed and Peltier state.
- A genuine change in cooling telemetry, safety reason or Hotside-limit state retires an older ordinary acknowledgement. Repeated identical telemetry is not treated as a new change.
- Safety has priority over older success messages and ordinary summaries. Hotside at/above its configured limit displays the current measured temperature and configured limit. Home warning presentation also recognizes that live threshold.
- Stored bilingual strings are re-resolved for the selected app language. A language listener rebuilds Home immediately, republishes Floating Monitor telemetry, and updates the connected-device foreground notification without waiting for new BLE traffic.
- BLE protocol/ownership, Firmware safety rules, OTA transport and Android Gradle `versionName` remain unchanged.
- Regression cases cover bilingual live summaries, Hotside temperature/limit wording, stored-message relocalization and listener wiring. Flutter tests and Dart analysis have NOT RUN. No App Build, Firmware compile, BIN/Firebase, OTA, flash or device operation occurred. Build #116 remains the latest verified App release; this source is NOT RELEASED and live-device behavior remains UNVERIFIED.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V7.0.ino`, current blob `823f6f31176695a3ff3a923995b1b3cd5f42c683`; embedded `FW_VERSION="V7.0"`. Adaptive 12 V targets use floored whole-degree Hotside categories (at a 40°C limit, 36.x°C targets 70%, 37.x°C targets 80%). The raw-decimal safety override still forces 100% at the configured limit. Ramp cadence remains −10 percentage points every 10 seconds / +10 points every 1 second. Prior V6.9 compile/install was user-reported; V7.0 is NOT compiled/installed and source-to-BIN identity remains UNVERIFIED. OTA still needs a matching compiled/published BIN and Firebase metadata `version: "V7.0"`.
- Artifact repository TenzoNkz/JEXFYZ-Firmware has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `821b022f97353d9a7aea4695b2e37c98b7488e15`, 1,456,560 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
