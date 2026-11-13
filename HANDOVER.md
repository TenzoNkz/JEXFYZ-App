## Immediate next step — Install and physically review Build #159 — 2026-11-13

**App Build/QC status: COMPLETED / RELEASE VERIFIED.** The four owner-approved App UI refinements are now included in Build #159. CI success does not establish physical/OEM visual acceptance.

- **App source/test implementation:** source changes for the four refinements in `a5d45866bb244a2f260330a0e2ea332c391a9fcd`; test-only correction commit `2c75c5b96db21937ec66c46f954d672a45384a7f` aligns the two Indonesian About role assertions with the current approved/source phrase `Pengembang Aplikasi & Perakit`.
- **Latest verified package:** Build #159, [Actions run 43376503987](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43376503987), job 131724120379, immutable source SHA `cdca38b9e4f2f99006db8feae40c07c6f9bdfb0a`. All workflow gates 1–21 and cleanup 39–43 passed.
- **QC:** analyzer 23 info-level deprecations / 0 warnings / 0 errors; Flutter 187/187 tests passed; Android Gradle `BUILD SUCCESSFUL in 2m51s`. Native Android app JUnit compile/process/test tasks were `NO-SOURCE`, so no native Android JUnit cases executed. Existing Kotlin/Gradle deprecation warnings and the duplicate branch warning at `FloatingMonitorService.kt:738` remain non-blocking.
- **Release:** Release ID 403010611 / tag `jexfyz-latest` target exact Build #159 source SHA. Exactly one APK plus one corresponding source ZIP. Re-downloaded bytes/checksums, ZIP integrity/source marker, downloaded APK V1/V2/V3, one signer and pinned certificate passed.
- **APK:** 55,914,587 bytes; SHA-256 `02bef5960e0b23bea360d2cf8a0532e7dbd202e05f5420e055c98b4dc7a61321`. [Download APK](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk).
- **Source ZIP:** 2,932,978 bytes; SHA-256 `5dbb29ebc7629775835bc65d655069a1a077f6d3240114387c965b5ad4789558`. [Download source ZIP](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip).
- **Signing:** RSA 4096, exactly one signer, pinned certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 pass. The certificate is self-signed and fails public PKIX trust-chain validation; not publicly CA-trusted.
- **Protected version:** Android `versionName "Telegram @horizontalzzz"` unchanged; Flutter version `1.0.0+3`.
- **Build #158 history:** Build #158 remains FAILED at Flutter test gate (185 pass / 2 stale About assertions). The source contract was already correct; only two test literals were repaired before successful Build #159. Keep the failure preserved in APP_BUILD_REPORT.md.
- **Formatter:** the guarded workflow has no Dart formatter gate; `dart format` is not claimed. Optional cache writes were denied by token scope but cleanup and run still succeeded.
- **Visual/physical status:** **VISUAL NOT VERIFIED** pending screenshots and actual owner review at 350-dp/420-dp, portrait/constrained height, EN/ID, Light/Dark. BLE reconnect/Lock Voltage physical behavior, installation, Firmware V7.2 compile/BIN, Firebase, OTA/flash, NVS/rail/LED and thermal/electrical validation remain NOT RUN / NOT VERIFIED.

### Exact next action

Owner installs Build #159 and supplies screenshots/observations for 350-dp/420-dp, portrait/constrained height, English/Indonesian, Light/Dark, plus BLE reconnect and Lock Voltage state transitions. Do not trigger another App Build unless App source changes. Do not infer Firmware/BIN, OTA, flashing or device validation from App CI.

## Latest verified App release — Build #157 SUCCESS

- Actions run [43247876115](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43247876115), job 131285336987, attempt 1; immutable package source SHA `10d106537e92060e0aac3fc17fd37f56e746bcd5`. All workflow gates 1–21 and cleanup 39–43 passed.
- QC: analyzer **23 infos / 0 warnings / 0 errors**; Flutter **187/187 tests passed**; Android Gradle `BUILD SUCCESSFUL in 3m19s`.
- Native Android JUnit compile/process/test tasks were `NO-SOURCE`; no native Android JUnit cases executed.
- Release ID 403010611 / tag `jexfyz-latest` target exact Build #157 source SHA. Exactly one APK plus one corresponding source ZIP; downloaded hashes, ZIP integrity/source marker and APK V1/V2/V3 + pinned certificate were verified.
- APK: 55,980,123 bytes, SHA-256 `24a42feb2ec8968209ac5dd764c6acb789c09fb0fc9a26df8e7d4bf5e1652aef`.
- Source ZIP: 2,932,445 bytes, SHA-256 `3b6f0a84a760b26587ca39a946f14383f2acee933fb5b30270713a32e6a06`.
- Certificate: RSA 4096, pinned SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 pass. Self-signed/PKIX trust-chain/no-timestamp caveat remains. Android `versionName "Telegram @horizontalzzz"` is preserved.

## Protected boundary

No App Build/Release, Firmware compilation/BIN publication, Firebase change, OTA, flashing, physical device action or hardware validation occurred in this Eksekusi Full task. These remain separately authorized scopes.
