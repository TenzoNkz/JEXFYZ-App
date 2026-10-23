# JE X FYZ — Firmware Technical Reference

Last reconciled: 2026-10-23 (Asia/Jakarta). Source identity and behavior are rechecked against live main before every task. This is the current technical reference; previous-version algorithms belong in CHANGELOG.md.

## Current source and evidence

- Active source: firmware/JEXFYZ-V7.1.ino.
- Embedded version: FW_VERSION="V7.1".
- Live source blob at the start of this documentation rework: c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- Owner reports V7.1 compilation and Online OTA installation on the sold/shipped unit. USER-REPORTED; exact BIN provenance, installed-version query and physical post-update behavior remain UNVERIFIED.
- Target toolchain: ESP32-C3 Super Mini / ESP32-C3 Dev Module; Arduino-ESP32 Core 3.3.7.
- Build #124 is Android App release evidence only, not a Firmware compile.

## Architecture and runtime invariants

- Cooperative main loop; time-based control uses millis(), without executable delay() or timing while().
- OTA supervision takes priority over ordinary application work.
- ESP32-C3 has one radio path. Wi-Fi OTA and BLE must transfer radio ownership deliberately, never operate as concurrent owners.
- Hotside NTC is the universal thermal safety input. Use one calibrated analogReadMilliVolts(PIN_NTC) sample per second; do not add averaging/filtering without explicit approval.
- Firmware owns actual hardware state and streams telemetry/state deltas to App. App must not infer physical state from ACK alone.
- NTC invalid state fails safe according to current code (Peltier OFF, Fan 100%, Adaptive OFF, safe 5 V).
- Persistent settings use a shared quiet-period debounce; Adaptive Profile is runtime-only.
- BLE app-only authentication is BLOCKED: encrypted/bonded writes plus Just Works and SYNC_READY do not prove official App identity. See BLE_APP_AUTH.md.

## Hardware, pins and timing

| Function | Pin / contract |
|---|---|
| Hotside NTC ADC | GPIO0 |
| TTP223 Touch input | GPIO1 |
| 12 V selector | GPIO3 |
| 9 V selector | GPIO4 |
| Peltier MOSFET PWM | GPIO5; 20 kHz, 8-bit; ordinary OFF→ON ramp 5 s |
| Fan MOSFET PWM | GPIO6; 25 kHz, 8-bit; Manual target 50–100% |
| WS2812 LED | GPIO7 |
| Selector deadtime | 200 ms break-before-make |
| Voltage settle/guard | 1,000 ms |
| NTC sample/telemetry cadence | one calibrated sample each second |

Electrical assumptions: 3.3 V reference; 10 kΩ fixed divider and 10 kΩ nominal NTC, Beta 3950. Hotside limit is configurable 40–50°C, default 45°C.

## Voltage transition and Peltier soft-start

See VOLTAGE_TRANSITION_MEMORY.md for the two separate reset incidents and full static acceptance checklist.

- A Peltier already OFF remains OFF through a rail change.
- An active five-second soft-start is captured and paused at 0% before selector switching; keep the 200 ms break-before-make and one-second guard, then restart only the saved interrupted ramp.
- A completed ramp stays at 100% continuously through rail transitions; do not add an unnecessary pause or soft-start.
- Fan stays ON/100% during handoff.
- Explicit OFF, Hotside/NTC safety and OTA safe-output cancel deferred resumes. Adaptive entry/exit uses the safe-5V handoff without a redundant Peltier OFF/ON cycle.
- Reset causes require BOOT: RESET_REASON=... or equivalent real diagnostics. Brownout is not assumed.

## Hotside, Adaptive and Fan

- Manual Peltier re-arm requires Hotside at/below hotLimit − 1°C for five continuous seconds.
- Adaptive thermal stage: 30 seconds at 12 V, 9 V and 5 V with Peltier OFF / Fan 100%; five seconds stable at/below hotLimit − 1°C may recover where allowed. Otherwise 12/9 V step down; unrecovered 5 V terminal-locks for manual restart. Restoration requires 60 seconds stable at/below limit − 1°C per upward rail and cannot exceed the saved ceiling.
- HOTSIDE is default at boot. HOTSIDE_BATTERY is runtime-only; if phone Battery input is stale, runtime behavior falls back to HOTSIDE without rewriting the selected profile.
- Adaptive Fan target uses floor(hotsideC) and delta = hotLimit − temperatureCategoryC. Delta ≤2°C→100%, 3–4→90%, 5–6→80%, 7–8→70%, 9–10→60%, ≥11→50%. At limit 40°C: 40/39/38→100%, 37/36→90%, 35/34→80%, 33/32→70%, 31/30→60%, ≤29→50%.
- Fan target ramps in 10-point steps: +10 points per second; −10 points per ten seconds. Direction changes start a fresh clock. Adaptive at 5 V/9 V remains Fan 100%.
- Raw-decimal safety is separate: at/above the configured limit, Fan 100% immediately and the existing safety supervisor shuts Peltier OFF.
- Rapid Hotside-rise/rate-of-rise shutdown with manual re-arm is NOT IMPLEMENTED in V7.1.

## Touch, LEDs and persisted data

- Recorded TTP223 timings: about 1,000 ms startup grace, 30 ms qualification, valid tap 60–500 ms, double-tap window 800 ms, long press 5,000 ms. Inspect live source before changing these values.
- Decorative LED mode IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7; ID 3 is retired. Safety/OTA indications take priority over RGB animation.
- Firmware sends LED_SYNC:<mode>,<phase_ms>,<cycle_ms> atomically immediately before notification.
- Persistent settings include Hotside limit, phone Battery thresholds and RGB enable/mode/brightness/color; write only changed data after ten seconds of quiet. Adaptive Profile is not persisted.
- App phone Battery data arrives via PHONE:BT at 1 Hz; Battery validity expires after five seconds; 5 V/12 V threshold defaults are 25°C/35°C with 0.5°C hysteresis.

## OTA — protected

Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any authorized OTA change.

- Local OTA boot SoftAP: ten-second no-client timeout, 60-second hard limit after interaction, and existing 160 ms Wi-Fi-off settle before BLE starts. Preserve current source semantics.
- Online OTA currently uses cloudClient.setInsecure(). This does not authenticate server certificate identity. Keep the raw GitHub allowlist, redirect blocking, status/length/size/image-magic checks, streaming Update lifecycle, safe outputs, failure recovery and restart semantics.
- Firebase metadata is version + link only; no custom firmware hash/signature requirement without explicit approval.
- App protocol order: OTAENTER → SSID → PASS → URL → VERSION → CLOUDOTA. A timeout/disconnect ACK is ambiguous; normal P1 synchronization is required after reconnect.

## Evidence boundaries

Static source contracts can verify strings, constants and code ordering. They do not certify Arduino compilation, exact BIN provenance, sensor accuracy, current draw, physical thermal response, rail stability, BLE pairing security, or end-to-end OTA/reboot. Record each gate independently.
