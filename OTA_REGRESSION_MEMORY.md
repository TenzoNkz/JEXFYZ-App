# JE X FYZ / JE Cooler — Online OTA Regression Memory

Last reconciled: 2026-10-14 (Asia/Jakarta). This is the canonical incident record in the App repo; check live source before editing the transport.

## Symptom and prior attempt

- User reported Online OTA reached Wi-Fi connected/blue feedback, then failed/red indication at the GitHub connection/download stage after the path added an inline ISRG Root X1 PEM CA certificate plus an OTA-only NTP/time validation gate.
- No serial transcript establishing an exact HTTP/TLS error code was supplied. Do not invent one based on LEDs.
- The failed path used `GITHUB_ROOT_CA`, `cloudClient.setCACert(...)`, `configTime(0, 0, "pool.ntp.org", "time.google.com")`, `OnlineOtaFlow::TIME_SYNCING`, epoch-validity state and a 20-second gate.

## Correction retained in active V6.6

- The correction originated in the then-current V6.3 source and remains in active `firmware/JEXFYZ-V6.6.ino` (last observed source blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`).
- Restored `cloudClient.setInsecure()` for the Online OTA client.
- Removed the embedded CA PEM, `setCACert()`, `configTime()`, `TIME_SYNCING`, epoch-validity condition and OTA-only 20-second NTP time gate.
- Flow is Wi-Fi success → blue feedback → `prepareOnlineOtaDownload()` → GitHub GET attempt.
- Kept allowlisted URL prefix `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/`, redirect blocking, HTTP/length/size/image checks, ESP image magic byte `0xE9`, streaming Update lifecycle, all-safe output, OTA lifecycle and failure recovery.
- Static test contract lives in `test/v6_6_qc_contract_test.dart` (live blob `2bee4d960d014f0765422dcb5ed1c9870ba6ee3a` at this checkpoint; tests were not executed). Presence of assertions does not mean the test was executed.

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

## Current static audit checklist

- [ ] Confirm active file and `FW_VERSION` on live `main`.
- [ ] One `cloudClient.setInsecure()` call exists on the intended GitHub OTA client path.
- [ ] No embedded CA PEM, `setCACert()`, `configTime()`, `TIME_SYNCING` or OTA-only NTP gate remains.
- [ ] Raw GitHub URL prefix allowlist and redirect blocking remain.
- [ ] HTTP status/length, image/size checks, safe output and update lifecycle remain.
- [ ] App expected-disconnect/recovery logic and ambiguous-ACK behavior remain aligned.
- [ ] Distinguish source review, test execution, compile, BIN, flash, end-to-end OTA and installed-version verification.
