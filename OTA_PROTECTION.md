# JE X FYZ / JE Cooler — OTA Protection Contract

> **OTA PROTECTED / FROZEN.** Do not alter casually while fixing unrelated App or Firmware issues.

## Scope protected by this contract

- Local OTA state machine and boot SoftAP path.
- Boot SoftAP window and Wi-Fi→BLE radio handoff timings: current Firmware uses a 10-second no-client timeout, a 60-second AP hard limit, and a 160 ms Wi-Fi-off settle before BLE ownership. Verify live source before referring to a changed value; unrelated work must not retime this protected path.
- Online OTA connection, URL/path validation and image download.
- OTA priority over ordinary control/UI work.
- Wi-Fi↔BLE single-radio ownership handoff.
- Output-safe state during OTA (Peltier and Fan OFF, selector safe at 5 V, LED/state-machine handling).
- Timeout/retry state, progress/results, cancellation, update finalization, failure recovery and restart behavior.
- App OTA version selection, protocol order, expected BLE disconnect, reconnect/P1 sync and result delivery.
- URL allowlist, redirect blocking, HTTP/length/size/image checks and streaming update lifecycle.

## Authorization required

Change OTA only if there is a demonstrated OTA defect and the user explicitly authorizes the change after discussion. Before editing:
1. Read this file and `OTA_REGRESSION_MEMORY.md` completely.
2. Identify exact symptom, logs/diagnostic stage and reproduction steps. Do not infer HTTP/TLS code from LED colors alone.
3. State scope and safeguards. Change one variable at a time where possible.
4. Update source-level contract tests and audit Local OTA, Online OTA, Wi-Fi/BLE handoff, safe outputs, timeouts, recovery and App reconnect end-to-end.
5. Update the canonical memory, `PROJECT_STATE.md` if current state changed, `CHANGELOG.md` and `CHAT_TRANSFER.md`.
6. Label test/compile/hardware evidence precisely. Static assertions are not an OTA success certificate.

Current source pointer is `firmware/JEXFYZ-V6.7.ino` (`FW_VERSION="V6.7"`, blob `1d0fa0d5e308b9789fd1c32211ce0a127d497f6a`). The changes target Fan PWM and LED handling, not the OTA transport sequence. V6.7 remains uncompiled and has not been OTA-tested.

## Current Online OTA contract (must re-check live source)

- Canonical editable Firmware source is in the App repo: `firmware/JEXFYZ-V6.7.ino`.
- The V6.3-origin restoration uses `cloudClient.setInsecure()`; embedded CA certificate validation, `setCACert()`, `configTime()`, `TIME_SYNCING`, epoch-validity gate and OTA-only 20-second NTP timeout are absent.
- On successful Wi-Fi connection, blue indication proceeds to the GitHub GET attempt.
- Raw URL allowlist remains restricted to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/`.
- `HTTPC_DISABLE_FOLLOW_REDIRECTS`, HTTP status/length checks, download size limit, ESP image magic byte check (`0xE9`), streaming write/update lifecycle, output-safe sequence, failure recovery and restart semantics remain protected.
- Known security trade-off: `setInsecure()` bypasses server certificate identity validation. This was chosen after the prior CA + NTP-gated path failed in the user's observed environment. The exact single cause was not isolated. Do not silently re-introduce CA/NTP validation.
- Firebase OTA metadata remains firmware version + link; no added user-approved SHA/signature layer.
- Artifact repo `TenzoNkz/JEXFYZ-Firmware` must contain `JEXFYZ.cpp.bin` only. Documentation lives in `TenzoNkz/JEXFYZ-App`.

## App side contract

- Expected OTA command order: `OTAENTER`, `SSID`, `PASS`, `URL`, `VERSION`, `CLOUDOTA`.
- Mark the expected OTA disconnect/recovery before sending `CLOUDOTA`.
- A `TIMEOUT` or `DISCONNECTED` acknowledgement is ambiguous, not proof of rejection. Keep recovery state and await reconnect/result. Roll back only on a definite rejection while the BLE session remains connected.
- On reconnect, complete normal P1/session sync and surface the one-shot OTA result.
- App-visible reason/status text must be localized and must not reveal internal protocol tokens.

## Version and release boundaries

- Functional Firmware edits require version constant + active filename bump and exactly one active versioned `.ino`.
- User compiles Firmware; no automatic compile as a side effect.
- Never generate/publish BIN, change Firebase metadata, flash/OTA hardware, start App Build or release without separate explicit authorization.
- Success at one gate (compile, BIN, BLE command, or Wi-Fi connect) does not prove end-to-end OTA install/reboot.
