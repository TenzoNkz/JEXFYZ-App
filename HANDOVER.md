# JE X FYZ / JE Cooler — Current Handover

Last reconciled against live GitHub on 2026-10-18 (Asia/Jakarta). Build #71 remains the latest verified APK; a new source-only warning-screen change has not been included in a release. Dashboard motion continuity and manual-voltage-toggle styling are now included in the latest verified APK; phone-side visuals and live telemetry remain unverified.

## Current App and release state

- Canonical repo: TenzoNkz/JEXFYZ-App, branch `main`. Latest verified App release: [Build #71 / run 39008259484](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39008259484), source commit `d9e026f70ec62455763de05048cba1557edfaf23`.
- All 21 active workflow steps passed: App audit, dependencies, Dart analysis, **88/88 Flutter tests**, Android production compile/configured gate, obfuscated APK, V1/V2/V3 signing/certificate, matching source ZIP, Release publication and re-downloaded asset/hash/signature checks.
- Android unit-test gate succeeded, but native unit-test compile/test tasks were NO-SOURCE after FPS-specific native tests were retired; no native JUnit cases ran in Build #71.
- APK asset `649710440`, `54,603,867` bytes, SHA-256 `fdffa5d61ad403153c544cd3a62ea130e810844930f9de96fdd28343f6d041ca`: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk
- Corresponding source ZIP asset `649710439`, `2,847,410` bytes, SHA-256 `3d7dc30fa99d3bfb86bee069e4a9b60292942f215c11c27e519f0b51ca8a24b0`: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip
- Release tag `jexfyz-latest` targets exact source commit `d9e026f70ec62455763de05048cba1557edfaf23`. Full build evidence and non-blocking warnings are in `APP_BUILD_REPORT.md`. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Source-only warning-screen change — 2026-10-18

- The existing Android gate compares the installed APK signing certificate with the configured official signer (debug builds remain allowed); the check itself was not weakened or rewritten.
- When that gate rejects launch, the warning page now uses only JE X FYZ branding and full-screen-style Indonesian slang/profanity copy, with scrollable text and a fixed bottom button. It intentionally does not explain the trigger or show technical diagnosis.
- `HUBUNGI DEVELOPER` opens `https://t.me/horizontalzzz` through Android `ACTION_VIEW`; account details do not appear on-screen. If the OS cannot launch the URL, the warning stays visible.
- Source blobs: main.dart `bf2007203455c64c2dd840a84b31368063df44eb`, MainActivity.kt `ef35590cfc91fafe5dec104b7cfd7828011185bf`, app_settings.dart `36927823c91904a35d87d2f21bd77932a2214e83`, widget_test.dart `767e7843f379c854fe7c8ab98293b4ec36008c88`.
- Widget contract added but **NOT RUN**: no local Flutter/Dart SDK is installed and `git clone` was blocked by DNS resolution. No APK Build App, native compile, physical-device test or firmware/cloud action was performed. Build #71 is still the latest verified APK.

## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan/Kipas label; current value is live speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
- Build #71 remains the latest verified APK but does not contain the current integrated 2D icon, localization/RGB-brightness or V6.7 Adaptive Fan source changes. A new APK needs separate `@Thinking Eksekusi Build App!` authorization; physical visuals and telemetry remain unverified.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.7.ino`, blob `1d0fa0d5e308b9789fd1c32211ce0a127d497f6a`; `FW_VERSION="V6.7"`; exactly one active versioned sketch. V6.7 is source-only/uncompiled. V6.6 compile/OTA reports are historical user reports; no BIN/Firebase/OTA/device action occurred in this task.
- Artifact repository TenzoNkz/JEXFYZ-Firmware contains exactly JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not read/change the BIN or add notes there.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. Build #71 remains the latest verified APK. If a new APK is separately authorized with `@Thinking Eksekusi Build App!`, verify the integrated 2D icon redesign, localized labels, RGB-only toggle/master brightness, and Floating Monitor live Fan telemetry on a real phone.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
