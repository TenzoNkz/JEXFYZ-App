# JE X FYZ / JE Cooler — OTA Protection Contract

> OTA IS PROTECTED / FROZEN. Do not alter it as part of unrelated App, UI or Firmware maintenance.

## Protected scope

- Local OTA state machine and boot SoftAP lifecycle.
- Boot SoftAP timing and the Wi-Fi→BLE single-radio handoff.
- Online OTA connection, URL validation, download, image checks and streaming Update lifecycle.
- OTA priority and output-safe behavior.
- Timeout/retry, progress/result, cancellation, finalization, failure recovery and restart.
- App OTA command order, expected BLE disconnect, reconnect/P1 synchronization and result delivery.
- URL allowlist, redirect blocking and HTTP/length/size/image validation.
- Firebase metadata shape: firmware version + URL only; no custom checksum/signature field without explicit approval.

## Required authorization and audit

Change protected OTA only for a demonstrated defect after discussion and explicit user authorization. Before editing:
1. Read this file, OTA_REGRESSION_MEMORY.md and the exact current Firmware/App OTA source and related tests in full.
2. Identify the symptom, diagnostic stage, available logs and reproduction. LED colors alone do not prove an HTTP/TLS error code.
3. State the scope, safety conditions and rollback/recovery strategy. Test one variable at a time where practical.
4. Audit Local OTA, Online OTA, single-radio handoff, safe outputs, timeouts/retries, image/download checks, Update finalization, restart/recovery, BLE reconnect/P1 and result presentation.
5. Update relevant source-contract tests and canonical memory. Static assertions do not prove a successful physical OTA.

## Current Firmware baseline pointer

- Active editable source: firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1", live blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- The owner reports V7.1 compiled and was installed through Online OTA on the sold unit. This is USER-REPORTED, not an independently inspected compile log or source-to-BIN proof.
- Build #124 is App-only CI evidence; it does not validate Firmware compilation or field OTA behavior.
- Current Firmware's Online OTA path uses cloudClient.setInsecure(). TLS transport is encrypted, but server certificate identity is not authenticated. The CA certificate and OTA-only NTP/TIME_SYNCING gate are absent. Do not silently restore that path or conceal the security trade-off.
- Allowlisted raw URL prefix remains https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/. Preserve redirect blocking, HTTP status/length, download-size and ESP image-magic (0xE9) checks.
- Preserve OTA-safe output sequence, streaming Update lifecycle, failure recovery and restart semantics. Check current source before making any statement about exact LED signaling or stage timing.

## App-side contract

- Established command order: OTAENTER → SSID → PASS → URL → VERSION → CLOUDOTA.
- Arm expected OTA disconnect/recovery before CLOUDOTA.
- TIMEOUT/DISCONNECTED acknowledgment is ambiguous, not proof of command rejection. Preserve recovery state and await reconnect/update result; roll back only on a definite rejection while BLE remains connected.
- After reconnect, require normal P1 session synchronization before surfacing the one-shot OTA result.
- User-facing result/cause copy must be localized and must not expose raw protocol tokens.
- The physical OTA, restart, BLE recovery and installed-version result are separate gates from code review or App CI.

## Release/operation boundaries

- Firmware functional changes require a version bump and matching filename; exactly one active versioned .ino.
- The owner compiles Firmware separately. Do not compile, generate or publish BIN, change Firebase metadata, perform physical OTA, flash hardware, operate devices, or run App Build unless each is separately authorized.
- App Build does not authorize Firmware operations. Eksekusi Full does not authorize App Build.
