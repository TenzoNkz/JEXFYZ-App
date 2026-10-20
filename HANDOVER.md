# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub main on 2026-10-20 (Asia/Jakarta). Build #113 / run 39350217172 is the latest successful App release, source 05e4f644d6bf82ae2682154082c3e44a4876205a. A newer source-only Home/layout/thermal-layer follow-up has been applied after that build; validation/release remain pending.

## Latest successful build and current source boundary

- Build #113 passed 109 Flutter tests, Dart analyzer exit 0 (25 info diagnostics), configured Android Gradle gate, APK V1/V2/V3 and official-certificate checks, ZIP integrity, downloaded-asset comparison and exact tag/commit checks. Native Android test tasks were NO-SOURCE.
- APK asset 657872748, 54,718,555 bytes, SHA-256 7252e952983560254822b8d77a9a1c47d5a3f91d80bf8ed50e58586bbe2c2991; source ZIP asset 657872749, 2,866,922 bytes, SHA-256 0fcccecc639e20f16d65976a5f3c334dd2ce4f7692d2a4d95b5b8aaad7dae59f.
- Current lib/main.dart blob d0fdb7482d939b34b0a1824b33d37f6457835818 and test/widget_test.dart blob af692cb7473f8447e1ab27939a3dc281d21737ad are newer than packaged source; SOURCE UPDATED / NOT RUN / NOT RELEASED.
- Home contract: seven 45 dp rows; 3 dp gap before fixed 44 dp NOTIFY; left-aligned body text scales down to fit up to two lines; cooler image stays in stable row constraints independent of notice length.
- Battery/Hotside fire is drawn behind the foreground silhouette and clipped OUTSIDE it. Thresholds remain Battery ≥40°C and Hotside at configured limit.
- User reports Firmware V6.9 compile/install success. Compile logs, source-to-BIN provenance, installed version and physical PWM/thermal results remain independently unverified. No App Build/Firmware/device operation occurred here.

## Current approved icon behavior

- Battery/Hotside: complete silhouette when inactive/unknown; clipped top-down falling orange/gold fire embers with bright cores only under the existing thermal warning predicates. The Hotside inner tube starts closer to the outer cap.
- Voltage: bevelled static bolt face with edge-following pulses; no central spine/inner strikes. The white inner core is inset and clipped to the bolt silhouette to prevent spill at the upper-right edge. 5V red / 9V green / 12V blue.
- Adaptive: two distinct arrowheads and recessed track; rotates only when authoritatively ON.
- Peltier: six-branch faceted crystal; snow particles only while existing active-state rules permit them.
- Fan: exactly three swept blades, fixed airflow ribbons, bearing and blade-face highlights; existing voltage/PWM mapping and phase retarget remain.
- Fan Speed: semicircle, recessed bezel, 11 graded ticks and layered pivot; valid PWM drives the needle, unknown/disconnected values hide it.
- Static nav/settings/action glyphs remain static. Floating Monitor remains letters-only B/H/V/A/P/F; no telemetry/control/safety semantics change.

## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan/Kipas label; current value is live speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
Historical note: Build #95 was an intermediate release, later superseded by Builds #100, #106, #108 and #110. The current top-down falling-fire/icon-geometry/Settings-About removal follow-up is newer than Build #110 and remains untested/unreleased pending separate validation.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`; embedded `FW_VERSION="V6.9"`. Adaptive 12 V target tiers remain 100/90/80/70/60/50%; downshift steps −10 percentage points every 10 seconds and upshift steps +10 points every 1 second. Voltage/thermal transitions reset the clock; Hotside limit/protection forces 100% immediately. V6.9 is SOURCE UPDATED / NOT COMPILED / NOT INSTALLED. Source-to-BIN identity and installed device version remain UNVERIFIED.
- Artifact repository TenzoNkz/JEXFYZ-Firmware currently has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `9fdd915c3d298cad4de720765dab7fb03f47024d`, 1,456,368 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
