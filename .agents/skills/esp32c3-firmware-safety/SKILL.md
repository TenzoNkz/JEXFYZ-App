---
name: esp32c3-firmware-safety
description: Use for ESP32-C3 Arduino Firmware architecture, non-blocking timing, NTC sensing, thermal protection, PWM, rail transitions, Touch, BLE/Wi-Fi radio handoff, or Firmware safety review.
---

# ESP32-C3 Firmware Safety Engineering

## Objective
Review embedded behavior with explicit timing, fail-safe and hardware-state reasoning.

## Mandatory preflight
- Read FIRMWARE_NOTES.md and firmware/FIRMWARE_TECHNICAL_REFERENCE.md.
- For rail/Peltier transitions also read VOLTAGE_TRANSITION_MEMORY.md.
- For any authorized OTA change also read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md in full.
- Verify the single active versioned .ino and its embedded FW_VERSION from live main.

## Review procedure
1. Identify the state owner and all inputs/outputs affected by the proposed change.
2. Build a state/timing table for normal operation, boot, disconnect, sensor fault, thermal limit, manual OFF, Adaptive transitions, OTA and restart.
3. Trace every path that changes Peltier, Fan, selector rails, LEDs and BLE/Wi-Fi radio ownership.
4. Inspect millis()-based scheduling, rollover-safe elapsed-time comparisons, task cadence, event ordering and maximum loop work.
5. Preserve non-blocking operation: no executable delay() and no timing while() loops.
6. Preserve one calibrated NTC sample per second unless a new user-approved design changes that rule.
7. Preserve safe outputs and override priority. Explicit OFF, NTC/Hotside safety and OTA safe-output must cancel deferred output restoration where specified.
8. Inspect PWM frequency/resolution, ramp start/stop semantics and whether a rail transition interrupts an active soft-start or occurs after it has completed.
9. Respect the ESP32-C3 single-radio ownership path. Wi-Fi OTA and BLE require deliberate handoff; do not imply simultaneous independent radio operation.
10. For every change, define startup, timeout, invalid-sensor, disconnect, rapid-toggle and interrupted-transition tests.

## Version and evidence policy
- Every functional Firmware change requires FW_VERSION increment and matching filename; exactly one active versioned .ino.
- Source inspection is not Arduino compilation, BIN identity, OTA completion, reboot, BLE recovery or physical thermal/electrical validation.
- The owner compiles separately with the approved Arduino-ESP32 Core 3.3.7 toolchain unless they explicitly authorize a different process.

## Guardrails
Diskusi is analysis only. Never compile, create/publish BIN, mutate Firebase, OTA, flash or operate the device from this skill without the relevant explicit command/permission. Do not diagnose brownout or reset cause without matching reset diagnostics.
