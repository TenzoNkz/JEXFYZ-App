# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-12 (Asia/Jakarta).

## Latest verified App release — Build #157 SUCCESS

- Actions run [43247876115](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43247876115), job 131285336987, attempt 1; immutable package source SHA `10d106537e92060e0aac3fc17fd37f56e746bcd5`. All workflow gates 1–21 and cleanup 39–43 passed.
- QC: security/architecture audit passed; analyzer **23 infos / 0 warnings / 0 errors**; Flutter **187/187 tests passed**; Android Gradle `BUILD SUCCESSFUL in 3m19s`.
- Native Android JUnit caveat: app test compile/process/test tasks were `NO-SOURCE`; no native Android JUnit cases executed despite Gradle gate pass.
- Release ID 403010611 / tag `jexfyz-latest` target exact tested source SHA. Exactly one APK + one corresponding source ZIP. Workflow downloaded both, matched hashes, verified ZIP integrity/source marker, and rechecked downloaded APK V1/V2/V3, one signer and pinned cert.
- APK: 55,980,123 bytes, SHA-256 `24a42feb2ec8968209ac5dd764c6acb789c09fb0fc9a26df8e7d4bf5e1652aef`. [Download APK](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk).
- Source ZIP: 2,932,445 bytes, SHA-256 `3b6f0a84a760b26587ca39a946f14383f2acee933fb5b30247270713a32e6a06`. [Download corresponding source](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip).
- Certificate: RSA 4096, pinned SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 pass. Keep self-signed PKIX trust-chain/no timestamp caveat explicit; not publicly CA-trusted.
- Android `versionName "Telegram @horizontalzzz"` preserved exactly.
- Build #154/#155/#156 failures remain preserved; #157 passed after the concrete analyzer and widget/test-contract repairs. Full chronology is in APP_BUILD_REPORT.md.

## Boundaries / next action

Build #157 proves hosted App CI/package/release only. No Firmware V7.2 compile/BIN, Firebase/OTA/flash, physical BLE/device/NVS/rail/LED, cooling electrical/thermal test, owner installation or OEM visual acceptance occurred.

Next: install Build #157 and perform physical App/BLE/OEM visual acceptance at 350-dp/420-dp, Light/Dark, EN/ID, reconnect and Lock Voltage. No further App Build unless App source changes.
