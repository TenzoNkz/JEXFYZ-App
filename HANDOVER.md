# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-12 (Asia/Jakarta).

## Latest verified App release — Build #153 SUCCESS

- Actions run [43145542329](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43145542329), job 130942369953, attempt 1; immutable source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`. All workflow steps 1–21 and cleanup 39–43 passed.
- QC: App audit passed; analyzer 23 infos / zero warnings/errors; Flutter 176/176 tests passed; Android Gradle `BUILD SUCCESSFUL in 3m41`. Native app JUnit tasks were `NO-SOURCE`; no native Android JUnit cases executed.
- Release ID 403010611 / tag `jexfyz-latest` target exact source SHA above. Exactly one APK + one corresponding source ZIP; downloaded SHA values, ZIP integrity/source marker and downloaded APK V1/V2/V3/pinned-certificate verification passed.
- APK: 55,996,507 bytes, SHA-256 `d956959414eb085e1779c30bf035a0bbc64d18330e19b85251cc0ead90f5661c`. [Download](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk).
- Source ZIP: 2,929,311 bytes, SHA-256 `87808fe37f31e7fec589477a3c658a2f10fa06362bd72b173eeada95d3b03604`. [Download](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip).
- Certificate: RSA 4096, JE X FYZ DN, pinned SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 verified. Keep self-signed PKIX trust-chain/no-timestamp `jarsigner` caveat explicit.
- Android `versionName "Telegram @horizontalzzz"` unchanged; app version 1.0.0+3.
- Build #152 / run `43144337555` remains a historical failure at Flutter tests (171 pass / 5 fail), no artifact. Its five failures, the three test-only repair commits and preservation of the failure are documented in APP_BUILD_REPORT.md. Build #153 passed 176/176 afterward.

## Boundaries / not verified

Build #153 proves hosted App CI/package/release only. No Firmware compilation, BIN generation/publication, Firebase modification, OTA, flashing, physical BLE/device/NVS/rail/LED testing, thermal/electrical cooling test, owner installation confirmation or OEM visual acceptance occurred. Firmware V7.2 compile/BIN and field validation remain separate.

## Current App source change — not yet packaged

- Main source commit `5296ba50f7fe0ba2c0ecff4e6112bed6e40dab2a` is newer than the Build #153 APK/Release.
- Peltier prerequisite popup is centered/fixed and compact (296-dp max width), without a scroll/drag surface or inherited text decoration. FAN:ON ACK remains mandatory before PELTIER:ON.
- Temperature tab's Reset Temperature Settings button, App handler and UI label have been removed. Protocol acknowledgement classification remains.
- GitHub source read-back and static contract checks passed. Flutter/Dart formatter/tests/analyzer were not run because the toolchain is unavailable. No new Build App or physical/device validation occurred; visual result is NOT VERIFIED.

## Next action

Issue a separate `Eksekusi Build App!` for the current main source, then install the newly produced APK and inspect actual Android screenshots of the Peltier popup and Temperature tab. Build #153 remains the latest published package until that guarded workflow completes. Firmware/BIN/Firebase/OTA/flash/device work remains separately gated.
