# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-12 (Asia/Jakarta).

## Latest verified App release — Build #151 SUCCESS

- Repository: TenzoNkz/JEXFYZ-App, branch main.
- Actions run #151: [43080954412](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/43080954412), attempt 1; job 130733048413; immutable source SHA `e383924067b7ab2da27f2e41f21232cfb7144ec0`. Steps 1–21 and cleanup 39–43 all passed.
- App repair in this source: commit `4368c9b81741690cfbcaa30ab00df6438e61d40f` restores `await Navigator.push<void>(` in `lib/main.dart::_openSettings()`; Lock Voltage callback preserved.
- QC: analyzer 23 infos / zero warnings/errors; Flutter 171/171 passed; Android Gradle `BUILD SUCCESSFUL` in 3m01. Android native JUnit task `:app:testDebugUnitTest` was `NO-SOURCE` (no native Android JUnit tests executed).
- Release ID 403010611, tag `jexfyz-latest`, exact target source SHA above. Exactly one APK + one matching source ZIP; downloaded asset SHA, ZIP integrity/source marker and APK signature/certificate verified.
- APK: 55,881,819 bytes, SHA-256 `4e69ee9bdbc716fc7dfe9679fd630e5ddde8694c61a5b618450026eae83f0935`. [Download](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk).
- Source ZIP: 2,923,217 bytes, SHA-256 `2ad9f745196665e667fdff02ae0d92900665667ee2358f57d14b7e0da0273ac1`. [Download](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip).
- Certificate: pinned JE X FYZ identity, RSA 4096; V1/V2/V3 verified. Retain self-signed/PKIX trust-chain and no-timestamp jarsigner warnings. Android `versionName "Telegram @horizontalzzz"` remains unchanged.
- Build #150 / run 43080229957 remains a historical analyzer failure; source syntax defect and repair are fully retained in APP_BUILD_REPORT.md.

## Boundaries / not verified

This proves hosted App CI and packaging only. No Firmware compilation, BIN, Firebase, OTA, flash or device operation occurred. Firmware V7.2 compile/BIN, physical BLE/NVS/rail/LED, thermal/electrical cooling and OEM visual acceptance remain NOT RUN / UNVERIFIED. Owner installation and physical App/BLE/OEM visual QA are separate follow-up evidence.

## Next action

Install the Build #151 APK and perform owner-side app launch, 350-dp/420-dp visual acceptance and physical BLE/reconnect/Lock Voltage validation; record observed results separately. Do not trigger another build unless App source changes.
