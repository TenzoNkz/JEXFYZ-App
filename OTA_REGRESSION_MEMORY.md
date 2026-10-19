# JE X FYZ / JE Cooler — Online OTA Regression Memory

Last reconciled: 2026-10-19 (Asia/Jakarta). This is the canonical incident record in the App repo; check live source before editing the transport.

## Symptom and prior attempt

- User reported Online OTA reached Wi-Fi connected/blue feedback, then failed/red indication at the GitHub connection/download stage after the path added an inline ISRG Root X1 PEM CA certificate plus an OTA-only NTP/time validation gate.
- No serial transcript establishing an exact HTTP/TLS error code was supplied. Do not invent one based on LEDs.
- The failed path used `GITHUB_ROOT_CA`, `cloudClient.setCACert(...)`, `configTime(0, 0, "pool.ntp.org", "time.google.com")`, `OnlineOtaFlow::TIME_SYNCING`, epoch-validity state and a 20-second gate.

## Historical OTA correction retained in current V6.8 source

- The correction originated in the then-current V6.3 source and remains present in the active `firmware/JEXFYZ-V6.8.ino` (live source blob `4f8011337fc3c9e3f1ace717fbd7179e1331bff8`). The older V6.7 blobs are historical checkpoints, not the live source.
- Restored `cloudClient.setInsecure()` for the Online OTA client.
- Removed the embedded CA PEM, `setCACert()`, `configTime()`, `TIME_SYNCING`, epoch-validity condition and OTA-only 20-second NTP time gate.
- Flow is Wi-Fi success → blue feedback → `prepareOnlineOtaDownload()` → GitHub GET attempt.
- Kept allowlisted URL prefix `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/`, redirect blocking, HTTP/length/size/image checks, ESP image magic byte `0xE9`, streaming Update lifecycle, all-safe output, OTA lifecycle and failure recovery.
- Historical OTA source-contract evidence: `test/v6_7_qc_contract_test.dart` was used in App Build #35 (`38669526891`, code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`); all 74 Flutter tests passed at that older checkpoint. That file has since been retired with V6.7. Current suite `test/firmware_qc_contract_test.dart` includes the OTA transport assertions and reads V6.8, but has NOT RUN for the current source. These static checks are not Firmware compilation, physical Online OTA or end-to-end update/reboot validation.

## User-reported evidence boundary

- User reported the V6.3 correction compiled successfully and Online OTA could connect to GitHub again.
- That report refers to V6.3, before the V6.4 Peltier voltage-transition fix; it does not certify V6.6 compilation.
- A complete BIN download, successful `Update.end()`, restart, BLE recovery and post-reboot installed-version confirmation were not independently established here.
- CA verification and NTP gate were removed together; evidence does not isolate which one alone caused the earlier failure.
- No assistant-side Firmware compile, BIN generation/publication, Firebase update, device flash, physical OTA or App Build was performed for the correction.

## Security trade-off / approved baseline

`setInsecure()` does not authenticate the HTTPS server certificate identity. The user chose restoration of this prior connection behavior after the observed CA/NTP-gated path failed. Keep this as an explicit security trade-off, not as “validated HTTPS identity.”

Do not add/remove CA roots, change certificate validation, add an NTP gate, or add TLS state transitions without:
1. a demonstrated defect and explicit prior user approval;
2. a recorded precise diagnostic stage/error (not LED-only interpretation);
3. a one-variable-at-a-time experiment where practical;
4. a complete re-audit of Wi-Fi/BLE handoff, output safety, URL allowlist, redirects, image checks, timeout/retries, Update lifecycle, failure recovery, App reconnect/P1 and result reporting.

## Historical V6.7 evidence boundary — 2026-10-18

- Current source is `firmware/JEXFYZ-V6.8.ino`, `FW_VERSION="V6.8"`, blob `4f8011337fc3c9e3f1ace717fbd7179e1331bff8`. V6.8 only changes Adaptive Fan PWM tiers in this task and has NOT been compiled or installed. The V6.7 compilation/online-update report is historical and user-reported; source-to-BIN provenance and installed-device version remain unverified.
- HISTORICAL App Build #65 / run 38851040144 passed 88/88 Flutter tests and an FPS parser JUnit gate. Later App Build #70 / run 38998407325 passed 86/86 Flutter tests and the FPS-retired source's release gates; native JUnit tasks were NO-SOURCE. Neither App run is an Arduino compile, physical Online OTA, update-apply/reboot or installed-version proof.
- Latest successful App artifact run Build #83 (run `39192430789`, source `dfc7e6633298498bb6eac21182c9306d5e3cac1d`) is App-only and does not validate the OTA transport or Firmware compile/BIN identity; the overall Release handoff is still blocked by the stale Git tag ref. The user reports V6.7 compiled and completed an online update; the report has not been independently verified. Hosted BIN provenance and current installed version remain unverified. Keep the setInsecure() certificate-identity trade-off explicit and do not infer the earlier HTTP/TLS failure root cause from LEDs alone.

## Preflight checklist for a future explicitly authorized OTA change — NOT RUN by this reconciliation

Leave these unchecked until an authorized OTA task performs each check against the live source. Build #65's App source-contract and FPS parser tests are not a full Local/Online OTA audit, Firmware compile, or device OTA test. This documentation reconciliation did not modify or execute the protected OTA path.

- [ ] Confirm active file and `FW_VERSION` on live `main`.
- [ ] One `cloudClient.setInsecure()` call exists on the intended GitHub OTA client path.
- [ ] No embedded CA PEM, `setCACert()`, `configTime()`, `TIME_SYNCING` or OTA-only NTP gate remains.
- [ ] Raw GitHub URL prefix allowlist and redirect blocking remain.
- [ ] HTTP status/length, image/size checks, safe output and update lifecycle remain.
- [ ] App expected-disconnect/recovery logic and ambiguous-ACK behavior remain aligned.
- [ ] Distinguish source review, test execution, compile, BIN, flash, end-to-end OTA and installed-version verification.
