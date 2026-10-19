# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub on 2026-10-19 (Asia/Jakarta). Build #99 is the latest successful release for source bc1498d5b3db7621ee18f5ca6f021e6013c73b09; a separate static/unknown-state redraw after that release is not tested or packaged. CHAT_TRANSFER.md is the final handoff snapshot.

Refreshed against live `main` on 2026-10-19 (Asia/Jakarta). The newest verified artifact is Build #95 from `cd691b874ddb0e454ba69891a3e0da3001df892f`, with 99/99 Flutter tests passing and all guarded release checks verified. The current animation smoothness follow-up is newer source and is **NOT RUN / NOT RELEASED**. Exact final HEAD/tree/source/doc hashes are in `CHAT_TRANSFER.md`; no App Build or Firmware/device operation was performed by this source task.

## Latest successful build and current source boundary

- Latest successful artifact: Build #99 / [Actions run 39230380636](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39230380636), exact source bc1498d5b3db7621ee18f5ca6f021e6013c73b09. All 21 workflow steps passed, analyzer passed with 25 info-level findings/no errors or warnings, 102/102 Flutter tests passed, APK signing/certificate and source ZIP integrity passed, and Release/tag/source equality was independently verified. Native JUnit tasks were NO-SOURCE.
- APK asset 655835412 SHA-256 06a3e4edc7ff911c66cda8b152d4f2acbc11f41b2ccd2f009aa966510aa89096; source ZIP asset 655835414 SHA-256 490ef913574a38fd47644422aa52b11f09c2d47895ba4f3e21db466e47aa8229.
- New source/test blobs after Build #99: lib/main.dart 6a008c5c3e5ba7118e948e0b1f36277c01e73529; test/widget_test.dart 94dad7a7506fbcbeea63f300ea25b7f32299d471. They are NOT RUN / NOT RELEASED and not in Build #99.
- The redraw targets the disconnected/static appearance: battery recess plus neutral thermal motif; thermometer recess, graduations and bulb bezel; voltage inset face; bolder Adaptive arrows; stronger faceted snowflake; Fan bearing plus blade highlights; speedometer bezel plus 11 ticks. Unknown battery/temperature state never receives a fabricated level. Peltier flakes and speed needle remain appropriately gated.
- Build #99's tested smoothness implementation remains intact: periodic falling particle phases/fades, 26 dp glyph in the original 38×38 tile, decoupled Peltier crystal motion, exactly three Fan blades/three fixed ribbons, and integrated phase-preserving Fan speed retarget.
- The new static-state source and tests have not been analyzed/tested in this execution. Real-phone appearance, frame-time smoothness, BLE/PWM and cooling/safety behavior remain UNVERIFIED. No App Build, Firmware/BIN/Firebase/OTA/flash/device operation was performed.

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
- Build #95 is the latest successful artifact run and exercised the guarded release/tag verification; release metadata, source ZIP and `jexfyz-latest` matched the Build #95 source. The current animation-smoothness follow-up is newer and remains untested/unreleased pending separate validation.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.7.ino`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`; `FW_VERSION="V6.7"`; exactly one active versioned sketch. The user reports V6.7 compiled successfully and was updated online, but no compile log, resulting BIN, OTA log, source-to-BIN provenance or current device version was inspected here. V6.6 compile/OTA reports remain historical user reports.
- Artifact repository TenzoNkz/JEXFYZ-Firmware currently has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
