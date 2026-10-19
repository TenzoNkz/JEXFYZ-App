# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub on 2026-10-19 (Asia/Jakarta), with execution baseline main HEAD `8ffcabb6668f0a095eabb0d0e051520fcae29310`. The latest successful verified release is Build #91 from `e9f6d8ca3ea936a1c4c05b2fbbd228dda5e2cdd1`; current post-build source/test changes and exact final HEAD are recorded in `CHAT_TRANSFER.md`. Build #91 passed 97/97 Flutter tests and all required release gates. The present small source follow-up is NOT RUN / NOT RELEASED; no App Build or Firmware/device operation was performed.

Last reconciled against live GitHub on 2026-10-19 (Asia/Jakarta). The complete repository audit began at main HEAD/tree `e224c5e1d3e86def06a5b97b0111a6e9c33e979a` (67 entries, recursive tree not truncated); the current pre-transfer parent will be recorded in `CHAT_TRANSFER.md`. Build #83 is the latest successful App artifact run; all 21 workflow steps and 96/96 Flutter tests passed for source `dfc7e6633298498bb6eac21182c9306d5e3cac1d`. Current main App source/test have a later dashboard animation refresh that is not packaged in Build #83. Current source hashes are lib/main.dart f52c1921dffd7fa360cfc01bb41cfecf352acdb6 and test/widget_test.dart dbb62587a5aefdf9af623dcd45781837cb28e8b0; the refresh is NOT RUN / NOT RELEASED. Overall release handoff remains BLOCKED: Release metadata/assets target the Build #83 source but Git tag `jexfyz-latest` still points to `9136f11799143d91eb58e947ea10e9e576bb579f`. The workflow YAML syntax repair is committed but not yet exercised.

## Latest successful build and current source boundary

- Latest successful verified artifact is **Build #91** / [Actions run `39207456720`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39207456720), source commit `e9f6d8ca3ea936a1c4c05b2fbbd228dda5e2cdd1`. All 21 gates completed, **97/97 Flutter tests passed**, analyzer passed with 23 informational deprecation findings, and APK signing/certificate, source ZIP, downloaded asset digests, Release metadata and `jexfyz-latest` tag target all matched. Native JUnit remained NO-SOURCE.
- Build #91 APK asset `655397774`, 54,636,635 bytes, SHA-256 `8a111df269a5093dd3b7de9e086ab0c2fddda4bc5f1c71a1cf237daa7542863c`. Corresponding source ZIP asset `655397777`, 2,857,331 bytes, SHA-256 `78ccbbdeaf3dfd9353f652c09e4e6ddcf2aa83ce77b771ad1822078a5a541ed6`.
- The Home indicator motion approved in this discussion is already present in the Build #91 source. This execution adds a small source follow-up: generic navigation/settings/action glyphs stop looping continuously and become static; Home telemetry indicators continue to use their dedicated state-gated painter. A regression source-contract test accompanies the change. New blobs: `lib/jex_animated_glyph.dart` `b37fc4e0807c874b2f01db00c7f606810cb5deca`; `test/widget_test.dart` `5f1c5345f6ea1e0114c72360414362d3667be276`.
- The follow-up source/test update is **NOT RUN / NOT RELEASED** until separately authorized Build App validation. Do not report new test/analyzer success based only on Build #91, because that run predates this follow-up. Build #91 remains the latest successful artifact and exactly matches its historical Release/tag source.
- No App Build/release, Firmware compile/edit, BIN read/write, Firebase change, OTA, flash or physical device operation is part of `@Thinking Eksekusi Full!`. The guarded workflow and all release gates remain unchanged.

## Approved animation behavior

- Industrial Premium, balanced geometric silhouettes; Precise movement responds to telemetry/status changes, not arbitrary perpetual loops.
- Hotside/Battery: tapered molten-lava layers and three rising/fading teardrop fragments, 280 ms warning transition; existing thresholds/semantic colors unchanged.
- Voltage: closed lightning silhouette with staggered inner branch strikes; 5V red, 9V green, 12V blue.
- Adaptive: two directional arcs with restrained halo; Peltier: six-branch crystal/falling branched flakes/faceted center.
- Fan: five swept rotor blades, layered hub and exactly three airflow ribbons fixed behind the rotor; only rotor angular speed follows existing voltage/PWM policy. Fan Speed: upper-half gauge, smooth PWM retarget; unknown/disconnected state hides the needle. OFF outputs remain static except one permitted connected Fan coast-down.
- BLE disconnection stops/resets custom icon controllers; unknown sensors/outputs do not become fabricated zero/OFF states. Bluetooth remains static and communicates connection through semantic colour.
- Generic settings/navigation/action glyphs are static because they are not live indicators. The native Floating Monitor remains letters-only B/H/V/A/P/F, with F = Fan Speed; values follow telemetry and unknown values remain `--`. Replacing the overlay labels with pictograms is not included in this patch.



## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan/Kipas label; current value is live speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
- Build #83 is the latest successful artifact run. The workflow repair removes orphaned tag-check shell lines outside `run: |` and keeps the final tag assertion inside the downloaded-asset verification step; no official run has exercised the repair yet.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.7.ino`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`; `FW_VERSION="V6.7"`; exactly one active versioned sketch. The user reports V6.7 compiled successfully and was updated online, but no compile log, resulting BIN, OTA log, source-to-BIN provenance or current device version was inspected here. V6.6 compile/OTA reports remain historical user reports.
- Artifact repository TenzoNkz/JEXFYZ-Firmware currently has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
