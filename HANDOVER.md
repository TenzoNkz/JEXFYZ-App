# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-14 (Asia/Jakarta). Re-fetch live `main` and source hashes before acting; this handover is a guide, not proof of current repository state.

## Current state

- Active Firmware source: `firmware/JEXFYZ-V6.5.ino`; `FW_VERSION = "V6.5"`; source blob observed at last reconciliation: `645c93226d607084ef31408b8fdbba752646ccd5`.
- Active App source: `lib/main.dart`, last observed blob `535e396005a3bd1429db3096c627d87043b0e1b4`, pubspec version `1.0.0+3`, package `com.horizontalzzz.jexfyz`.
- Current Firmware status: source-only DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED. V6.5 not independently compiled/hardware validated here.
- Main V6.5 QC contract: `test/v6_5_qc_contract_test.dart`. It exists but has not been run in this task.
- Open PR search last returned zero. Verify live; use main by default.
- Artifact repository `TenzoNkz/JEXFYZ-Firmware` is intended to contain only `JEXFYZ.cpp.bin`; all notes belong in this repo.
- App memory explicitly records a 1 Hz Android phone-battery heartbeat, firmware 5-second battery-data freshness TTL, and the requirement not to display a standalone Battery Protection Guard. One-App/one-cooler exclusive pairing is a user design intent whose exact enforcement remains unverified.

## First steps in the next session

1. Read `CHAT_TRANSFER.md` in full and then `MEMORY_INDEX.md`, `CHAT_RULES.md`, `PROJECT_STATE.md`.
2. Fetch current main HEAD/tree, current source blobs, tests, workflow, open PR state and artifact repo root. Do not quote the hashes above as current without rechecking.
3. Read the relevant canonical memory before changing code: `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md` for OTA; `VOLTAGE_TRANSITION_MEMORY.md` for rail/Peltier timing; `APP_NOTES.md` for App behavior; `FIRMWARE_NOTES.md` + `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` for firmware; `BUILD_NOTES.md` for build.
4. Respect the command protocol and authorization boundaries from `CHAT_RULES.md`.
5. Preserve these battery UI and pairing requirements in `APP_NOTES.md`; do not ask the user to repeat them. If exclusive pairing-lock work is requested, audit the exact BLE security/provisioning code first and report implementation versus intent.

## Exact next QC actions (only when authorized)

1. User compiles active V6.5 using ArduinoDroid with Arduino-ESP32 Core 3.3.7. Confirm the binary/version provenance; do not assume the already-published BIN matches source.
2. With hardware, reproduce Manual Volt and Adaptive voltage changes while the 5-second soft-start is still active. Expected: GPIO5 PWM 0% during selector handoff, preserve 200 ms deadtime, hold through 1-second settle, then start a fresh 5-second ramp. Adaptive ON/OFF must not introduce a separate Peltier OFF cycle. Capture reset reason if reboot recurs.
3. Repeat after soft-start completes, including Adaptive ON and OFF. Expected: Peltier PWM remains 100% continuously throughout rail transition unless explicit OFF or safety shuts it down; no Adaptive-specific OFF/ON cycle.
4. Verify Peltier-OFF, Hotside/NTC protection and OTA safe-output cancel all pending ramp resume.
5. Verify Adaptive timeout/recovery, Hotside re-arm, Touch telemetry sync, LED feedback, Wi-Fi→BLE handoff and both OTA routes.
6. Separately authorize/run Flutter test and analyze. A test file or static inspection alone is not a pass.
7. Build App only on explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`, and only after reviewing the current workflow.

## Known uncertainty

- User reported the V6.3 OTA connection correction compiled and Online OTA connected to GitHub. This does not prove V6.5 compile, complete BIN download/apply, reboot, or installed-version confirmation.
- The 5 V→12 V reboot during active Peltier ramp could be a supply transient/brownout, but this has not been proved. Preserve and collect `BOOT: RESET_REASON=...` diagnostics.
- The selected Online OTA path uses `cloudClient.setInsecure()`: HTTPS server certificate identity is not authenticated. This trade-off was chosen after the CA/NTP-gated attempt failed in the user's observed environment; don't change it without explicit discussion/approval.
- No App Build, firmware compile, BIN publication, Firebase update, physical flash/OTA or release was performed by this handover/documentation refresh.

## Reference routing

Use `MEMORY_INDEX.md` to find canonical notes. Use `CHANGELOG.md` for history only. Never copy old V5.x/V6.1/V6.2 status blocks forward as current truth. The complete cross-chat startup and memory-reconciliation procedure is in `CHAT_TRANSFER_PROMPTS.md`.
