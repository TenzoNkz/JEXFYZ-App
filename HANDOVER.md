# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-12 (Asia/Jakarta).

## Latest verified App release — Build #153 SUCCESS

- Actions run [43145542329](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43145542329), job 130942369953, attempt 1; immutable source SHA `1834a78e20273c9ea6cd51ad4d52b64370c5bd9e`. All workflow steps 1–21 and cleanup 39–43 succeeded.
- QC: Dart analyzer 23 infos / zero warnings/errors; Flutter 176/176 tests passed; Android Gradle `BUILD SUCCESSFUL in 3m41`. Android native `:app:testDebugUnitTest` was `NO-SOURCE` (no native Android JUnit cases executed).
- Release ID 403010611 / tag `jexfyz-latest`, exact source SHA above. Exactly one APK + one corresponding source ZIP; downloaded SHA values, ZIP integrity/source marker and downloaded APK signing/certificate were verified.
- APK: 55,996,507 bytes, SHA-256 `d956959414eb085e1779c30bf035a0bbc64d18330e19b85251cc0ead90f5661c`. [Download](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk).
- Source ZIP: 2,929,311 bytes, SHA-256 `87808fe37f31e7fec589477a3c658a2f10fa06362bd72b173eeada95d3b03604`. [Download](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip).
- Certificate: RSA 4096, pinned JE X FYZ DN; V1/V2/V3 verified. Preserve self-signed PKIX/no-timestamp `jarsigner` caveat. Android `versionName "Telegram @horizontalzzz"` remains unchanged.
- Build #152 / run 43144337555 remains a historical Flutter test failure (171 pass / 5 fail); the exact error and three test-only repairs are retained in APP_BUILD_REPORT.md. Build #153 passed 176/176 afterward.

## Boundaries / not verified

This proves hosted App CI and release only. No Firmware compilation, BIN generation/publication, Firebase modification, OTA, flashing, physical BLE/device/NVS/rail/LED testing, thermal/electrical cooling test, owner installation confirmation or OEM visual acceptance occurred. Firmware V7.2 compile/BIN and field validation remain separate.

## Next action

Owner install Build #153 and perform physical App/BLE/OEM visual acceptance: 350-dp/420-dp, Light/Dark, English/Indonesian, reconnect and Lock Voltage. Record observed results separately; do not trigger another build unless App source changes.