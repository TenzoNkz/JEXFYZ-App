# JE X FYZ / JE Cooler — Current Handover

Last reconciled against live GitHub on 2026-10-19 (Asia/Jakarta). The complete repository audit began at main HEAD/tree `e224c5e1d3e86def06a5b97b0111a6e9c33e979a` (67 entries, recursive tree not truncated); the current pre-transfer parent will be recorded in `CHAT_TRANSFER.md`. Build #83 is the latest successful App artifact run; all 21 workflow steps and 96/96 Flutter tests passed for source `dfc7e6633298498bb6eac21182c9306d5e3cac1d`. Current main App source/test have a later dashboard animation refresh that is not packaged in Build #83. Current source hashes are lib/main.dart 88e98bb705393bef9aa0c9dd7de3224acf06d5ba and test/widget_test.dart df58405b142a48cab48f2ff2eef449f5e83fe80e; the refresh is NOT RUN / NOT RELEASED. Overall release handoff remains BLOCKED: Release metadata/assets target the Build #83 source but Git tag `jexfyz-latest` still points to `9136f11799143d91eb58e947ea10e9e576bb579f`. The workflow YAML syntax repair is committed but not yet exercised.

## Current App and release state

- Canonical repo: `TenzoNkz/JEXFYZ-App`, branch `main`. Latest successful artifact run: [Build #83 / run 39192430789](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39192430789), exact source commit `dfc7e6633298498bb6eac21182c9306d5e3cac1d`. Tag-ref handoff remains blocked.
- All 21 Build #83 workflow steps passed; Flutter analysis reported 23 info-level deprecations and **96/96 Flutter tests passed**. Android configured gate, obfuscated APK, V1/V2/V3 signing/certificate, corresponding source ZIP and re-downloaded asset checks passed. Native JUnit tasks were NO-SOURCE; no native JUnit cases ran.
- Build #83 APK [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk): asset `655087433`, `54,620,251` bytes, SHA-256 `1b5e2cf4a16e6e521a7a332b2ab252c45a2f632a39f259203f9dce47602e9b92`.
- Matching Build #83 [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip): asset `655087446`, `2,854,731` bytes, SHA-256 `c7e3952d20510d203f2d9fbf901033d5289fdcdbf8c6c141c7ff29b9a413c018`. Both artifacts match exact source marker `dfc7e6633298498bb6eac21182c9306d5e3cac1d`, but tag ref still mismatches.
- Build #83 includes the current Dashboard/painter and test source; main/test blobs match current live main. The remaining release mismatch is in Git tag ref / workflow dispatch, not App source.

## Build #83 App source coverage and post-build workflow repair — 2026-10-19

- Hotside: replaced the separated tube and bulb outlines with one continuous outer contour; liquid fill/highlight is clipped within the silhouette.
- App-source note: the visual changes described below were included in Build #83, rather than remaining source-only.
- Home animation policy follows `DESIGN_NOTES.md`: Battery/Hotside/Voltage loop while BLE is connected; Adaptive/Peltier/Fan/Fan Speed/LED animate only when authoritative state is ON; OFF outputs are static except the Fan's one-shot connected coast-down; Bluetooth remains static. Existing source and tests enforce this. The earlier note claiming OFF output icons idle-looped was stale and is corrected.
- Rounded text-block layout is included in Build #80. This follow-up renders the warning symbol using a direct Flutter `Icon` instead of `JexAnimatedIcon.glyph`; its shape/glyph, size and color do not change. All message strings/order, per-block colors/typography, rounded boxes, heading and developer contact action are preserved.
- Peltier, Adaptive and LED switches use neutral surfaces like Manual Voltage,
- When Bluetooth is disconnected, all five submenu areas (Voltage, Control, Adaptive, LED, Temperature) share one blur/dim layer and one lock panel centered over the entire selected submenu. Tabs/Home Bluetooth remain usable. When connected and Adaptive is active or transitioning, only Voltage/Control/Temperature receive the centered `LOCKED BY ADAPTIVE MODE` overlay. The underlying submenu is ignored for pointer input.
- New test contracts cover the lock-policy matrix, centered one-overlay structure, three switch styles, continuous Hotside contour and distinct animation signatures. The existing TamperScreen widget contract also checks the new framed-text style; copy, order, colors, warning icon and contact action are unchanged.
- Build #83 packaged source/test fingerprints at that time were lib/main.dart `99bdf225b990fbe8a4ff92c224b4fccc4ae4624a` and test/widget_test.dart `9fffea531bdb19315c01aaf0e253ebdfacd7a1ed`. The static TamperScreen warning Icon and earlier Home painter are part of that packaged artifact; current main has newer dashboard animation changes not yet built.
- Build #83's analysis and 96/96 Flutter tests passed for the current App source. The newer workflow-only YAML repair is not yet tested by Actions; no App Build was launched by `@Thinking Eksekusi Full!`. Latest observed Actions run is #87, a zero-job push failure; issue #34 did not produce a newer issue-trigger run. The tag mismatch remains unresolved. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Dashboard animation refresh — source-only, NOT RELEASED

- Current live source blobs: lib/main.dart 88e98bb705393bef9aa0c9dd7de3224acf06d5ba; test/widget_test.dart df58405b142a48cab48f2ff2eef449f5e83fe80e.
- Battery/Hotside use moving layered flames plus rising/fading teardrop lava fragments; Voltage adds short staggered branch strikes; Adaptive gains a restrained halo/inner highlights; Peltier keeps its six-branch crystal/snowfall with a faceted center; Fan becomes a five-blade swept rotor with layered hub and three fixed airflow ribbons independent of voltage/PWM; Fan Speed maps a true semicircle from left OFF to right 100%, retargets smooth live PWM, and hides the needle when output/speed is unknown.
- Added source-contract assertions cover lava motion, fixed airflow, rotor layering, gauge endpoints and known-state wiring. They have NOT RUN after these edits; no analyzer, Flutter test, App Build or release was started. Physical rendering/Fan Speed telemetry remain UNVERIFIED. Firmware, BIN, BLE protocol, control behavior, OTA, Firebase, safety and device operations were not changed.

## Workflow YAML syntax defect and current release gate

- The pre-fix workflow had four tag-verification shell statements outside any `run: |` block, after the Release-publish script ended and before the next step. That malformed YAML is a concrete likely explanation for push runs #84–#87 failing with zero jobs and no newer issue-trigger run.
- Fix commit: [0c266f3064d77a394d660acd16595ff43166fb7f](https://github.com/TenzoNkz/JEXFYZ-App/commit/0c266f3064d77a394d660acd16595ff43166fb7f), workflow blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`. The orphaned duplicate was removed and final tag equality check now runs inside the downloaded-asset step. Trigger remains issue opened/reopened only with owner/title/token guard intact.
- Validation after the fix is still pending. The latest Actions query had #87 as the newest run; no Build App was triggered by this `Eksekusi Full` command. Tag still points at `9136f11799143d91eb58e947ea10e9e576bb579f` while Release artifacts target `dfc7e6633298498bb6eac21182c9306d5e3cac1d`. Do not manually move the tag; use the authorized official workflow and verify it after the next Build App command.

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
