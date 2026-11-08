# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-08 (Asia/Jakarta).

## Latest verified state

- **Latest App release:** Build #131, [Actions run 42474266430](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/42474266430), source `b3c4fee432fddc49430840daeb1e2eecbe78a0db`; run terminal success, all 21 main workflow steps passed.
- **Release/tag:** `jexfyz-latest`, Release ID `403010611), tag and Release both target the exact packaged source SHA. Exactly one APK and one corresponding source ZIP are attached and verified by post-publication re-download.
- **APK:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), SHA-256 `d614bc42c6270fa3de616d944d043fc833cd0ab0ffc391d89526627606c3ee35`, 54,849,627 bytes. V1/V2/V3 signing and expected certificate passed.
- **Source ZIP:** [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), SHA-256 `cca5609e5a471f204118f2bdfc40e6aa0fa7dcb6dc151a4b306e6c9ca4615177`, 2,888,040 bytes; ZIP integrity and exact source marker passed.
- **QC:** 142 Flutter tests passed; analyzer exit 0 with 25 info-level diagnostics; Android Gradle gate succeeded. Native Android JUnit tasks were `NO-SOURCE`, so no native JUnit test case ran.
- Compact Settings/Connection UI, localization corrections, Bluetooth scan state presentation and passive/manual/one-shot scanner ownership are now included in the Build #131 package. Build #130 failed on three stale test contracts; source/test fixes were committed before the successful #131 retry. Full attempt chronology remains in APP_BUILD_REPORT.md.
- All later commits after packaged source SHA `b3c4fee432fddc49430840daeb1e2eecbe78a0db` are documentation/checkpoint updates only; they do not modify the package source.
- Android Gradle `versionName "Telegram @horizontalzzz"` remains unchanged.
- No active/queued/waiting App Build run remains.

## Next safe action

The build/release operation is complete. No further build is pending for the same source.

1. Owner downloads and installs Build #131; installation is not yet independently confirmed.
2. Perform physical visual review of Settings and Bluetooth Connection at 350-dp/420-dp, English/Indonesian, and Light/Dark themes. Hosted widget tests are not screenshot/OEM visual acceptance.
3. Perform real-device BLE lifecycle validation: passive rediscovery, prerequisite cancellation, manual-sheet pre-emption/dismissal, selected-device handoff, fresh primary/fallback scan handling, adapter loss and reconnect.
4. Record field evidence separately. Do not infer Firmware, BIN, OTA, cooling/thermal or hardware status from App CI.

## Evidence and safety boundary

- Firmware V7.1 compile/Online OTA remains USER-REPORTED. Exact field BIN identity, installed App identity and physical device behavior remain UNVERIFIED.
- No Firmware compile, BIN publication/replacement, Firebase operation, OTA, flashing or device operation occurred in this App Build run.
- BLE App-only identity authorization remains BLOCKED / NOT IMPLEMENTED; rapid Hotside-rise/rate-of-rise shutdown plus manual re-arm is also NOT IMPLEMENTED in Firmware V7.1.
- The single operating policy is [MASTER_PROMPT.md](MASTER_PROMPT.md). [CHAT_RULES.md](CHAT_RULES.md) is only a compatibility pointer. [CHAT_TRANSFER.md](CHAT_TRANSFER.md) is the latest durable continuation checkpoint; [APP_BUILD_REPORT.md](APP_BUILD_REPORT.md) contains the append-only build evidence.
