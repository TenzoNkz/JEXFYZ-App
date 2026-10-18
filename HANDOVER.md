# JE X FYZ / JE Cooler — Current Handover

Last reconciled against live GitHub on 2026-10-18 (Asia/Jakarta) after repository-memory cleanup. At that snapshot, `main` was `272c053cd896a9a8e28c67aeb84ccb72f725381e`; recursive tree complete, 67 entries (49 blobs/18 trees), five branches and zero open PRs. Build #73 remains the latest verified APK. The Hotside/indicator motion, Peltier/Adaptive/LED toggle and whole-submenu lock-overlay changes remain source-only after Build #73, not built or device-verified.

## Current App and release state

- Canonical repo: `TenzoNkz/JEXFYZ-App`, branch `main`. Latest verified release: [Build #73 / run 39098410865](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39098410865), exact source commit `f1e81450428ffb113a76d430590c312ad6fa4781`.
- All 21 release workflow steps passed for Build #73; Flutter analysis reported 23 info-level deprecations and **91/91 Flutter tests passed**. Android production compilation/configured gate, obfuscated APK, V1/V2/V3 signing/certificate, matching source ZIP and re-downloaded asset verification passed. Native JUnit compile/test tasks were NO-SOURCE, so no native JUnit cases ran.
- APK [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk): asset `652517541`, `54,538,331` bytes, SHA-256 `90ed2f36658ea0e4fa487d43ea7e4347545c9875b13d703ec9c2765445eea48b`.
- Matching [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip): asset `652517543`, `2,846,735` bytes, SHA-256 `ed7429aa9f6cb36e327d6d7b85efdf0b895ee8529c09a159053b98c8628902ef`. Both release assets were re-downloaded and verified against the exact source marker.
- Build #73 includes the previous TamperScreen profanity/contact behavior, but **does not include** the current changes described next.

## Source-only UI update — 2026-10-18

- Hotside: replaced the separated tube and bulb outlines with one continuous outer contour; liquid fill/highlight is clipped within the silhouette.
- Indicator animation: Battery has a travelling fill sheen; Hotside gets a liquid/bulb highlight; Voltage gets a clipped bolt flash; Adaptive uses two moving directional arcs plus arrowheads; Peltier gets sequential branch highlights without sparks; Fan keeps phase-controlled rotor/coast-down; Speed adds gauge glint/retargeted needle; LED has a travelling wave/dot; Bluetooth stem highlight/pulse keeps the existing no-ripple-ring rule.
- All non-Fan indicator kinds retain restrained idle motion after the 440 ms fade. This is visual ambient movement only and does not claim hardware is active. The Fan rotor remains stopped once OFF coast-down completes.
- Peltier, Adaptive and LED switches now use neutral surfaces like Manual Voltage, hide the knob check and adjacent ON/OFF label, and keep theme-primary toggle accent. Fan switch presentation is unchanged.
- When Bluetooth is disconnected, all five submenu areas (Voltage, Control, Adaptive, LED, Temperature) share one blur/dim layer and one lock panel centered over the entire selected submenu. Tabs/Home Bluetooth remain usable. When connected and Adaptive is active or transitioning, only Voltage/Control/Temperature receive the centered `LOCKED BY ADAPTIVE MODE` overlay. The underlying submenu is ignored for pointer input.
- New test contracts cover the lock-policy matrix, centered one-overlay structure, three switch styles, continuous Hotside contour and distinct animation signatures.
- Current source/test fingerprints: `lib/main.dart` `0f6335435570691c5e9509f3f1a2619cf351e732`; `lib/floating_monitor.dart` `31b45ea08b08ac7fc25ebd991dca873b889fdd14`; `lib/app_settings.dart` `36927823c91904a35d87d2f21bd77932a2214e83`; `test/widget_test.dart` `661130f0bc2197478cc5f0e083324bdc41c8e6a3`; `test/floating_monitor_layout_contract_test.dart` `87e805095202ac3edfe55b9aeb3138c7c6886375`; `test/v6_7_qc_contract_test.dart` `6b71cc2ebbef9b3f1c9757728067eec4d11ff5ee`; `test/app_protocol_notify_contract_test.dart` `92214dd90178c705844d3979d3f8f7bd17bcc4b8`; `test/firmware_touch_adaptive_sync_test.dart` `94c0f074247f47fce7d939a72b0130eb1b2d70fa`; Android `MainActivity.kt` `ef35590cfc91fafe5dec104b7cfd7828011185bf`.
- **Flutter tests/Dart analysis were not run** for this current UI update: Flutter/Dart executables are not available in this runtime. Static checks were used, not runtime evidence. No App Build, Android compile, physical-phone test, Firmware compile, BIN/Firebase, OTA, flash or device operation occurred. Build #73 remains the latest verified APK.

## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan/Kipas label; current value is live speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
- Build #73 remains the latest verified APK but does not contain the current Hotside contour, indicator animations, Peltier/Adaptive/LED toggle styling or centered menu-lock overlays. A new APK needs separate `@Thinking Eksekusi Build App!` authorization; tests for these source-only changes have not been run and physical visuals remain unverified.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.7.ino`, blob `1d0fa0d5e308b9789fd1c32211ce0a127d497f6a`; `FW_VERSION="V6.7"`; exactly one active versioned sketch. V6.7 is source-only/uncompiled. V6.6 compile/OTA reports are historical user reports; no BIN/Firebase/OTA/device action occurred in this task.
- Artifact repository TenzoNkz/JEXFYZ-Firmware contains exactly JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not read/change the BIN or add notes there.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. Build #73 remains the latest verified APK. If a new APK is separately authorized with `@Thinking Eksekusi Build App!`, verify the current Hotside contour, all indicator motions, Peltier/Adaptive/LED toggle styling and whole-submenu centered lock overlay on a real phone, alongside existing BLE/Fan telemetry.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
