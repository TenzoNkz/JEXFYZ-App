# JE X FYZ / JE Cooler — Current Handover

Last reconciled against live GitHub on 2026-10-17 (Asia/Jakarta) after Build #71. Dashboard motion continuity and manual-voltage-toggle styling are now included in the latest verified APK; phone-side visuals and live telemetry remain unverified.

## Current App and release state

- Canonical repo: TenzoNkz/JEXFYZ-App, branch `main`. Latest verified App release: [Build #71 / run 39008259484](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39008259484), source commit `d9e026f70ec62455763de05048cba1557edfaf23`.
- All 21 active workflow steps passed: App audit, dependencies, Dart analysis, **88/88 Flutter tests**, Android production compile/configured gate, obfuscated APK, V1/V2/V3 signing/certificate, matching source ZIP, Release publication and re-downloaded asset/hash/signature checks.
- Android unit-test gate succeeded, but native unit-test compile/test tasks were NO-SOURCE after FPS-specific native tests were retired; no native JUnit cases ran in Build #71.
- APK asset `649710440`, `54,603,867` bytes, SHA-256 `fdffa5d61ad403153c544cd3a62ea130e810844930f9de96fdd28343f6d041ca`: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk
- Corresponding source ZIP asset `649710439`, `2,847,410` bytes, SHA-256 `3d7dc30fa99d3bfb86bee069e4a9b60292942f215c11c27e519f0b51ca8a24b0`: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip
- Release tag `jexfyz-latest` targets exact source commit `d9e026f70ec62455763de05048cba1557edfaf23`. Full build evidence and non-blocking warnings are in `APP_BUILD_REPORT.md`. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan Speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
- Install/update using the Build #71 APK. Verify indicator phase continuity across OFF/ON, Peltier spark motion, the neutral active manual-voltage toggle with red/green/blue labels, and all six Floating Monitor metrics plus live Fan Speed. FPS/Shizuku diagnostics are retired; do not treat CI as proof of phone-side visuals or live BLE telemetry.

## Firmware / OTA boundary

- Firmware source: firmware/JEXFYZ-V6.6.ino; blob f51ba6db5d0e91318f63fea4014bb87f7bf76222; FW_VERSION="V6.6"; exactly one versioned active .ino. User accepts V6.6 as final and reports compile plus two same-version Online OTA updates. USER-REPORTED; source-to-BIN provenance remains UNVERIFIED.
- Artifact repository TenzoNkz/JEXFYZ-Firmware contains exactly JEXFYZ.cpp.bin, 1,455,936 bytes, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6. Do not read/change the BIN or add notes there.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. Install [the Build #71 APK](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) and visually check indicator phase continuity across OFF/ON, Peltier spark orbit, Battery ripple/flame loop smoothness, and the neutral active manual VOLTAGE toggle. Also verify six metric labels and live Fan Speed.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
