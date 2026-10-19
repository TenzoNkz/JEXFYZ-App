# JE X FYZ / JE Cooler — Current Handover

Refreshed against live `main` on 2026-10-19 (Asia/Jakarta). The newest verified artifact is Build #92 from `6610fecb3e47d9941cbf96043b7da3b2a869753b`, with 98/98 Flutter tests passing and all guarded release checks verified. This task adds a newer seven-icon source/test follow-up; it is **NOT RUN / NOT RELEASED**. Exact post-write HEAD/tree/source/doc hashes belong in `CHAT_TRANSFER.md`. No App Build or Firmware/device operation is authorized by this command.

## Latest successful build and current source boundary

- Latest successful verified artifact remains **Build #92** / [Actions run `39211726896`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39211726896), source commit `6610fecb3e47d9941cbf96043b7da3b2a869753b`. All 21 workflow steps passed; **98/98 Flutter tests passed**, analysis passed with 23 informational deprecations, Android configured gate, obfuscated APK, required V1/V2/V3 signing/certificate, corresponding-source ZIP, downloaded asset hashes, and Release/tag/source equality passed. Native JUnit tasks were NO-SOURCE.
- Build #92 APK: asset `655482761`, 54,636,635 bytes, SHA-256 `ee3ce9cb9697b8bcabf4da829fc64c16524bbe914eb83901f5d21c855d706926`. Source ZIP: asset `655482764`, 2,857,021 bytes, SHA-256 `7ec969d092638790dd36b5d71c758b68cdc11a0e8db2bdfb390c812f541e677a`.
- **Current follow-up after Build #92:** `lib/main.dart` changes thermal warning to include falling fire particles inside Battery/Hotside; converts Fan from five narrow blades to exactly three broad swept blades; and adds a consistent, restrained luminous-core effect to Battery/Hotside, Voltage, Adaptive, Peltier, Fan, and the Fan Speed gauge. The six-branch snow crystal, two-arrow Adaptive motion, Voltage spine/branch pulse, PWM gauge state gates and fixed three airflow ribbons remain distinct.
- Source/test blobs: `lib/main.dart` `ec8d682432946bd5b9afea925685855d632610b8`; `test/widget_test.dart` `ab0862470846455465b65ec294d33d39c07aac62`. Regression contracts now cover falling fire, exactly three rotor blades, and the shared luminous-core style. They have **NOT RUN**.
- Follow-up state: **SOURCE IMPLEMENTED / NOT RUN / NOT RELEASED**. Build #92 remains the latest successful APK and does not contain this follow-up. No Dart analysis, Flutter tests, App Build/release, firmware/BIN/Firebase/OTA/flash or device operation was performed in this Full execution.

## Approved seven-icon behavior

- **Battery Temperature:** recognizable battery shell and temperature level; warning state adds anchored heat tongues and three pointed ember particles falling inside the battery cavity, fading in and out.
- **Hotside Temperature:** continuous thermometer contour and live temperature column; warning state adds falling embers clipped to the thermometer body and a restrained thermal halo. Existing configured threshold is unchanged.
- **Voltage:** lightning bolt with luminous core, pulsed current along its closed spine and staggered internal branch strikes; 5V red, 9V green, 12V blue.
- **Adaptive:** two opposite arrowheads on separate arcs rotate together when authoritative Adaptive state is ON; OFF remains full-colour and static.
- **Peltier:** six-branch snowflake/crystal with faceted core and falling branched snowflakes behind it. State/intensity policy remains unchanged.
- **Fan:** exactly three broad swept blades, layered hub, smooth phase rotation according to existing voltage/PWM policy, and exactly three fixed airflow ribbons behind it. The airflow does not change shape/count/colour with PWM; only the rotor changes speed.
- **Fan Speed:** upper-half gauge and smooth retargeting to known PWM. OFF maps to the established left endpoint, 100% to right; unknown/disconnected values hide the needle.
- Generic navigation/settings glyphs remain static. Bluetooth remains static and indicates state through semantic colour. BLE disconnect stops/resets telemetry-driven icon animation.
- Floating Monitor is still letter-only B/H/V/A/P/F (F = Fan Speed); replacing those letters with pictograms requires a separate design/layout approval. All values remain firmware-telemetry-derived; no fabricated OFF or 0 values.
- Visual preview, physical-screen motion, live BLE/PWM response and thermal/safety behavior are **UNVERIFIED** until separately validated. Only `@Thinking Eksekusi Build App!` authorizes App analyzer/test/build/release workflow.


## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan/Kipas label; current value is live speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
- Build #92 is the latest successful artifact run and exercised the repaired tag-check workflow; release metadata and `jexfyz-latest` matched the Build #92 source. The current seven-icon visual follow-up is newer and remains untested/unreleased pending the separate Build App command.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.7.ino`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`; `FW_VERSION="V6.7"`; exactly one active versioned sketch. The user reports V6.7 compiled successfully and was updated online, but no compile log, resulting BIN, OTA log, source-to-BIN provenance or current device version was inspected here. V6.6 compile/OTA reports remain historical user reports.
- Artifact repository TenzoNkz/JEXFYZ-Firmware currently has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
