# JE X FYZ / JE Cooler — Firmware & Hardware Contract

Durable hardware/user requirements live here. The source-level architecture and implementation reference is firmware/FIRMWARE_TECHNICAL_REFERENCE.md. Protected OTA details are in OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md; voltage incidents/transition sequencing live in VOLTAGE_TRANSITION_MEMORY.md.

## Production baseline and evidence

- Owner reports the sold/shipped unit uses App Build #124 and Firmware V7.1, compiled and updated through Online OTA. This is USER-REPORTED.
- The App package is independently evidenced by Actions run 39386733061, packaged source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a. This does not independently verify Firmware compilation, source-to-BIN identity, installed version, physical OTA/reboot, BLE recovery or electrical/thermal behavior.
- Active editable Firmware source: firmware/JEXFYZ-V7.1.ino; FW_VERSION="V7.1"; current blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- The unit is not available for routine physical repair. Avoid discretionary release/update risk.

## BLE authorization — BLOCKED / NOT IMPLEMENTED

- Desired daily UX: power on cooler → open JE Cooler → Connect BLE → use it. No QR, no extra Touch gesture; preserve existing gestures.
- RX writes are encrypted/bonded, but pairing uses Just Works and SYNC_READY opens the command gate. This does not prove official App identity or block nRF Connect/manual command writing.
- Do not accept a key from any first-connected client. A trusted backend, device-bound enrollment grant, per-install App signing key, firmware-pinned trust anchor and fresh nonce/signature session verification are required. See BLE_APP_AUTH.md.
- OTA and hardware safety remain independent of App authorization.

## Hardware and pinout

- MCU: ESP32-C3 Super Mini / ESP32-C3 Dev Module; assume a 3.3 V logic/ADC reference.
- GPIO 0: Hotside NTC ADC. GPIO 1: TTP223 Touch. GPIO 3: 12 V selector. GPIO 4: 9 V selector. GPIO 5: Peltier MOSFET PWM. GPIO 6: Fan MOSFET PWM. GPIO 7: WS2812 LED.
- NTC model: nominal 10 kΩ at 25°C, 10 kΩ fixed divider and Beta 3950. Use calibrated analogReadMilliVolts(PIN_NTC), one reading per second.
- The owner explicitly rejected median, trimmed-mean and multi-sample NTC filtering. Do not add them without explicit approval.
- Invalid NTC/sensor state follows the existing fail-safe: Peltier OFF, Fan 100%, Adaptive OFF and safe 5 V.
- Wiring note: GPIO → R100 → MOSFET gate; 100 kΩ gate-source pull-down. Fan positive is supply-side (called "Decoy" in the wiring note); Fan negative goes to MOSFET drain. Verify physical wiring before diagnosing unexpected voltage/current.

## Output and timing invariants

- Peltier PWM: 20 kHz, 8-bit; normal OFF→ON ramp is 5 seconds.
- Fan PWM: 25 kHz, 8-bit; Manual Fan target 50–100%; cooling/safety may force 100%.
- Selector break-before-make: 200 ms. Shared voltage settle/guard: 1 second.
- Adaptive upward voltage steps use a 5-second non-blocking dwell after each completed increase. Downward steps are immediate unless the active safety transition says otherwise.
- Use cooperative millis() timing. No executable delay() or timing while() loops.
- Every functional Firmware change increments FW_VERSION and renames the active sketch to match. Exactly one active versioned .ino may exist.
- Settings use a shared 10-second quiet-period debounce; write only changed persisted values. Adaptive Profile is runtime-only.

## Hotside / Adaptive safety

- Configurable Hotside limit is 40–50°C, default 45°C. At or above the limit, the current safety supervisor immediately forces Fan 100% and shuts Peltier OFF.
- Manual Peltier safety latch re-arms only after Hotside remains at or below hotLimit − 1°C for five continuous seconds. One low sample must not bypass this condition.
- Adaptive thermal handling allows a 30-second recovery stage at each rail (12 V, 9 V, 5 V), Peltier OFF and Fan 100%. Five continuous seconds at/below hotLimit − 1°C before timeout cancels the stage where allowed; otherwise 12 V/9 V step down a rail, and unrecovered 5 V enters terminal lock requiring manual restart.
- After an Adaptive thermal downshift, recovery raises one rail at a time only after 60 seconds continuously at/below hotLimit − 1°C and never above the saved pre-downshift ceiling.
- HOTSIDE is the Adaptive startup default. HOTSIDE_BATTERY is runtime selectable, not persisted. If phone Battery data is stale/missing, control falls back to HOTSIDE without rewriting the selected profile.
- Adaptive Fan targets at 12 V use floored whole-degree temperature categories relative to the configured limit: delta ≤2°C→100%; 3–4°C→90%; 5–6°C→80%; 7–8°C→70%; 9–10°C→60%; ≥11°C→50%. At 40°C: 40/39/38→100%, 37/36→90%, 35/34→80%, 33/32→70%, 31/30→60%, ≤29→50%. Bands move with the configured limit.
- PWM moves in 10-point increments: up every 1 second and down every 10 seconds. Direction changes start a fresh clock. Adaptive 5 V/9 V remain at Fan 100%. Raw-decimal safety is independent of these target bands.
- RAPID HOTSIDE RISE / RATE-OF-RISE SHUTDOWN + MANUAL RE-ARM is a USER REQUIREMENT, still NOT IMPLEMENTED in V7.1. Do not imply Adaptive Fan trends or ordinary limit protection satisfy it. Any future implementation must be separately scoped, version-bumped and safety-tested.

## Touch, LEDs and durable indicator decisions

- TTP223 timings recorded by QC: about 1,000 ms startup grace, 30 ms qualification, valid raw HIGH tap 60–500 ms, double-tap window 800 ms and long press 5,000 ms. Verify live source before changing.
- Adaptive ON indication: three orange blinks; OFF indication: three white blinks, deferred until safe 5 V handoff completes when needed. The white OFF blink reportedly appeared missing immediately after restart; this remains USER-REPORTED / PHYSICALLY UNVERIFIED.
- Voltage LED defaults: 5 V red, 9 V green, 12 V blue; colors configurable.
- Decorative RGB IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7. ID 3 / Mirror Pulse is retired; invalid stored values migrate to Static and new MODE:3 commands are rejected.
- Firmware emits LED_SYNC:<mode>,<phase_ms>,<cycle_ms> atomically at BLE notification time. Safety/OTA indications outrank decorative animation.

## Telemetry and phone Battery

- Hotside telemetry is sent every second; other state should send only when changed.
- App physical state must follow authoritative Firmware telemetry, including hardware Touch actions. Do not treat command ACK alone as a confirmed physical state.
- App sends PHONE:BT=<Celsius> once per second while the BLE session is ready and coalesces pending heartbeats. Firmware considers phone Battery input stale after 5 seconds.
- Battery zone defaults: 5 V threshold 25°C, 12 V threshold 35°C, 0.5°C hysteresis. When data expires, HOTSIDE_BATTERY falls back to HOTSIDE behavior without silently changing the selected runtime profile.

## OTA boundary

- OTA is protected/frozen except for a demonstrated defect and explicit prior authorization. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before related source changes.
- ESP32-C3 has one radio path. Wi-Fi must be fully shut down and allowed to settle before BLE becomes active.
- Local OTA uses a 10-second no-client SoftAP window and a 60-second hard limit after interaction, with existing 160 ms radio-settle delay before BLE starts. Preserve exact source semantics and inspect live source before any authorized adjustment.
- Online OTA currently uses cloudClient.setInsecure(); TLS encrypts transport but does not authenticate server certificate identity. Preserve the raw GitHub BIN allowlist, redirect blocking, HTTP status/length/size/image checks, streaming Update lifecycle, safe outputs, recovery and restart contract.
- Firebase OTA metadata is version + link. Do not add custom Firmware hash/signature fields without explicit user approval.

## Evidence and incident routing

- The owner-reported compile/OTA result must remain distinct from independent BIN/device evidence.
- Two restart incidents were reported: (1) Manual 5 V→12 V while Peltier/Fan were ON and the 5-second ramp was active; (2) enabling Adaptive after 12 V + Peltier/Fan ON. Keep them separate; reset cause is not established, and brownout remains a hypothesis. See VOLTAGE_TRANSITION_MEMORY.md.
- Static test presence does not prove execution. The V7.1 contract tests are not independently run by this docs rework; there was no Firmware compile, BIN generation/publication, Firebase update, physical OTA, flash or device operation.
