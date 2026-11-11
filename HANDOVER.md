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

## V7.2 Lock Voltage — current source and validation boundary

- V7.2 source and App integration are present in the Build #151 package. Firmware blob `140e758e7101cadc3ccc58cc5c52e49534b0032c`, App `lib/main.dart` blob `ddbb94fa325e134a2248674032128b38c863070d`, and Lock source-contract test blob `0150cbf22bb2550e0d9a690eafb3a6b7d480499b` match current `main`.
- Build #151 hosted App CI passed analyzer (23 info-level findings, zero warnings/errors) and Flutter **171/171** tests, including four Lock Voltage/App contracts and the V7.2 Touch-cycle contract. Android `:app:testDebugUnitTest` was `NO-SOURCE`. This does not compile or execute ESP32 Firmware.
- Source review confirms firmware-owned NVS lock, central/final 5V gates, P1 full-sync state, one-way Touch cycle and nonblocking two-red-pulse rejection. Adaptive is forced OFF while locked; unlock leaves 5V and Adaptive OFF, with explicit re-enable required after unlock.
- Source header has a documentation typo (`V7.1 Firmware` comment vs `FW_VERSION="V7.2"`). BLE App-only identity remains BLOCKED: a different bonded/manual client may issue `VOLTAGE_LOCK:OFF`.

## Boundaries / not verified

This proves hosted App CI and packaging only. No Arduino-ESP32 Core 3.3.7 Firmware compilation, BIN provenance, Firebase, OTA, flash or device operation occurred. NVS power-cycle, BLE physical behavior/security, selector/rail/LED response, thermal/electrical cooling and OEM visual acceptance remain NOT RUN / UNVERIFIED. Owner installation and App/BLE/OEM visual QA are separate follow-up evidence.

## Next action

Recommended first: obtain the independent Gemini review prompt prepared in the current Diskusi handoff for the V7.2 Lock Voltage/NVS/selector-transition edge cases; it has NOT been sent. Then, before any firmware distribution, the owner should compile `firmware/JEXFYZ-V7.2.ino` with the approved Arduino-ESP32 Core 3.3.7 toolchain and preserve compile/BIN identity evidence. Do not publish BIN, change Firebase, perform OTA/flash or operate the device without separate explicit authorization. Install the already released Build #151 APK and complete 350-dp/420-dp App/OEM and BLE acceptance independently.
