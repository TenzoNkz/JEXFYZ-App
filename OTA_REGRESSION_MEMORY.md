# JE X FYZ / JE Cooler — Online OTA Regression Memory

Last updated: 2026-10-14 (Asia/Jakarta)
Status: The Online OTA correction was introduced in the V6.3 revision and remains in active V6.4 source; compile and GitHub-connect recovery were user-reported; full OTA apply/reboot is not independently verified.

## 1. Incident and observed symptom

- Active source of truth is `firmware/JEXFYZ-V6.4.ino` in this repository, not the BIN-only production repository.
- The V6.3 Online OTA path contained an inline ISRG Root X1 PEM constant named `GITHUB_ROOT_CA`, configured via `cloudClient.setCACert(GITHUB_ROOT_CA)`.
- The same path introduced an OTA-only asynchronous NTP gate: `configTime(0, 0, "pool.ntp.org", "time.google.com")`, `OnlineOtaFlow::TIME_SYNCING`, and a 20-second timeout.
- User-reported symptom: Wi-Fi reached the connected state and the first blue indicator appeared, then a red indicator appeared at the GitHub connection stage. The device could not continue to the GitHub BIN response/download.
- Do not invent an HTTP/TLS error code: no serial diagnostic transcript establishing a specific error code was supplied.

## 2. Correction applied to V6.3

Commit: https://github.com/TenzoNkz/JEXFYZ-App/commit/a87bbcecdca26b3648abff9cb88937e250b41f1f

Active source blob after correction: `8a8c64ae2a3fc7ac722a02c05feaeb614087092a`

- Removed the `GITHUB_ROOT_CA` PEM declaration and `setCACert()` call.
- Restored `cloudClient.setInsecure()` for the Online OTA HTTPClient/TLS connection.
- Removed the OTA-only `configTime()`, `TIME_SYNCING` state, epoch-validity condition, and 20-second NTP timeout gate.
- Restored the observed sequence: Wi-Fi connects → blue indicator → `prepareOnlineOtaDownload()` → GitHub GET attempt.
- Kept the target repository URL allowlist (`https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/`), redirect blocking, HTTP response/length checks, OTA size limit, ESP image magic-byte check (`0xE9`), streaming download, safe output shutdown, OTA lifecycle, and failure recovery.
- The OTA contract source was updated in commit https://github.com/TenzoNkz/JEXFYZ-App/commit/dc0d6ec13d3f58ab864e006e7defb543fd4752b6. Live test blob: `bf9d96cf671547e48465525c4661e48afd9863ee`. The Flutter test itself has not been run.

## 3. User confirmation and exact evidence boundary

- [USER-REPORTED — 2026-10-13] User reports V6.3 compiled successfully after the correction and Online OTA could connect to GitHub again.
- [NOT INDEPENDENTLY VERIFIED HERE] No build log or serial log was inspected by the assistant. The user report must be preserved as a user report, not upgraded to an assistant-performed compile/test.
- [NOT CONFIRMED AS END-TO-END] A complete BIN body transfer, successful `Update.end()`, reboot, and post-reboot firmware version confirmation were not separately established in this record.
- [NO ASSISTANT-SIDE RELEASE] The assistant did not compile the firmware, generate or publish a BIN, flash hardware, run physical OTA, edit Firebase release metadata, or Build App as part of this correction.
- The user attributes the failure to the CA trust addition. Technically, the CA validation and the OTA-only NTP gate were removed in the same correction; therefore this is strong before/after evidence for the combined CA/TLS/time-gated path, but it does not isolate whether the CA PEM alone or the added NTP gate alone caused the failure. Do not rewrite this as a proven single-variable experiment.

## 4. Security decision made for the current build

The user explicitly chose to restore the previous `setInsecure()` connection behavior because the CA-based Online OTA path failed in their observed environment.

Important consequence: `setInsecure()` still encrypts the TLS channel but skips peer certificate identity validation. URL allowlisting and redirect blocking constrain the requested URL/flow but do not cryptographically authenticate the GitHub server. Preserve the user-approved current behavior unless the user asks for a security redesign; do not silently re-add a CA, certificate pinning, or NTP dependency.

## 5. Regression-prevention rules

1. **Freeze the Online OTA transport baseline.** Do not add/remove a CA root, change `setInsecure()`/certificate validation, add time synchronization, or add a TLS state to the OTA state machine without prior discussion and explicit user approval.
2. **One transport change at a time.** If a future experiment is authorized, record the exact source diff and diagnostic stage/result; change one variable at a time so the actual cause can be distinguished.
3. **Do not infer a GitHub error from LEDs alone.** Blue then red narrows the failure stage, but the exact error needs `otaDiagnosticStage`, `otaDiagnosticErrorCode`, `otaDiagnosticError`, HTTP response code, or a serial/device log.
4. **Protect OTA behavior.** Preserve Wi-Fi↔BLE single-radio handoff, safe outputs, retry/timeouts, raw BIN URL allowlist, redirect policy, stream/size/image validation, Update lifecycle, failure recovery, and final restart path. Unrelated work must not refactor this code.
5. **Keep tests aligned with the chosen baseline.** Static regression checks should assert `setInsecure()` exists exactly on the Online OTA client path; the CA PEM and OTA-only NTP gate are absent; blue feedback leads to the GitHub connection attempt; the allowlist and redirect blocking remain. A test file is not evidence that the test ran.
6. **Separate source from release artifact.** Canonical source is in `TenzoNkz/JEXFYZ-App/firmware/JEXFYZ-V6.4.ino`. `TenzoNkz/JEXFYZ-Firmware` is an artifact repository containing `JEXFYZ.cpp.bin`; do not assume its BIN matches current source unless build provenance or matching hashes/version are verified.
7. **Authorization boundaries remain active.** User compiles firmware. Do not trigger Build App, firmware compile, BIN generation/publication, flashing, physical OTA, Firebase/production metadata update, or release unless separately and explicitly requested.
8. **Record status precisely.** The current known fact is user-reported compile success and restored GitHub connectivity. End-to-end installation is a separate QC gate until confirmed.

## 6. Current source audit

At commit/source blob `8a8c64ae2a3fc7ac722a02c05feaeb614087092a`, static inspection found:
- one `cloudClient.setInsecure()` call in the GitHub OTA preparation path;
- no `GITHUB_ROOT_CA`, embedded certificate PEM, `setCACert()`, `configTime()`, `TIME_SYNCING`, or OTA-only NTP time gate;
- target raw GitHub firmware URL prefix allowlist retained;
- `HTTPC_DISABLE_FOLLOW_REDIRECTS` retained;
- normal GitHub GET and failure-handling path retained.

This is a static source audit only; it is not a firmware compile, runtime test, or full OTA success certificate.
