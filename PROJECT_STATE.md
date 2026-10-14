# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-10-14 (Asia/Jakarta). **Refresh the live repository before relying on this snapshot.** History belongs in `CHANGELOG.md`; this document must not accumulate old “current” sections.

## Release phase

- **Phase:** DEVELOPMENT + QC / PRE-RELEASE.
- **Release state:** NOT RELEASED.
- **Active Firmware source:** `firmware/JEXFYZ-V6.4.ino`.
- **Firmware version constant:** `FW_VERSION = "V6.4"`.
- **Current Firmware source blob:** `f0dd9d1ebdc7d9d0966384f557efa2e2123df792`.
- **Active App source:** `lib/main.dart`, blob `535e396005a3bd1429db3096c627d87043b0e1b4`.
- **App/package version:** `1.0.0+3`, package `com.horizontalzzz.jexfyz`.
- **Android Gradle identity:** `versionName "Telegram @horizontalzzz"`; intentional and preserved.
- **Regression contracts:** `test/v6_4_qc_contract_test.dart` (blob `f071c9642c1a06726d25b8c26a814845b02a55d6`), `test/firmware_touch_adaptive_sync_test.dart`, `test/v5_9_contract_test.dart`, and `test/widget_test.dart`.
- **Current source has not been compiled by the assistant.** The previous V6.3 compile/GitHub connection result is user-reported and applies to the prior revision, not proof of V6.4.
- No current verification claim is made for latest Flutter test/analyze, V6.4 Arduino compile, BIN provenance, physical flash/OTA, thermal safety, BLE pairing or App↔Firmware integration.

## Current V6.4 firmware behavior in source

### Voltage transition and Peltier soft-start

- For Manual Volt and ordinary Adaptive rail changes, pause Peltier PWM at 0% only if the 5-second soft-start is still active when the transition is accepted.
- An interrupted ramp stays at 0% during selector handoff, preserves the existing 200 ms break-before-make sequence and 1-second settle, then restarts a fresh full 5-second ramp.
- If soft-start already completed, keep PWM at 100% continuously through the transition. Do not force 0% or restart soft-start merely because the rail changes.
- If Peltier is OFF, a rail change must not turn it on. Explicit Peltier-OFF, thermal/sensor safety or OTA safe-output must cancel any pending resume.
- Fan remains ON/forced to 100% during the protected handoff.
- A user-reported restart occurred when switching 5 V → 12 V with Peltier/Fan on during an active ramp. Supply transient/brownout is a **hypothesis**, not a confirmed cause. Diagnostics include `BOOT: RESET_REASON=...`.

### Thermal and Adaptive protection

- Hotside limit configurable from 40–50°C; default 45°C.
- Hotside NTC is the authoritative thermal input; one calibrated ADC sample per second, no median or multi-sample averaging.
- Manual Peltier safety re-arm remains latched until Hotside is at/below `hotLimit - 1°C` continuously for 5 seconds.
- Adaptive thermal safety stages: 30-second window at 12 V, 9 V and 5 V; Peltier OFF and Fan 100%. Recovery at/below `hotLimit - 1°C` for 5 seconds before timeout cancels the stage; otherwise 12 V/9 V steps down one rail and unrecovered 5 V enters terminal lock requiring manual restart.
- After thermal step-down, rail restoration requires 60 continuous seconds at/below `hotLimit - 1°C` for each upward step, capped by the saved pre-downshift ceiling.
- Adaptive start/stop has its own safe-5V handoff; a previously running Peltier is restored only through safety gates and the normal 5-second OFF→ON ramp.
- HOTSIDE is the startup Adaptive profile; HOTSIDE_BATTERY is runtime selectable and not persisted. Battery sensor loss falls back to HOTSIDE behavior without changing profile.

### Online OTA status

- The V6.3-origin correction remains in V6.4 source: `cloudClient.setInsecure()`; inline root CA validation and OTA-only NTP/TIME_SYNCING gate are absent.
- On successful Wi-Fi connection, blue feedback leads into the GitHub GET attempt. Raw GitHub BIN URL allowlist, redirect blocking, HTTP/size/image checks, OTA lifecycle and safe-output/failure recovery must remain.
- `setInsecure()` bypasses server certificate identity validation: this is a known security trade-off, not authenticated TLS.
- User reported successful compile and restored GitHub connection on the prior V6.3 revision. Full BIN transfer/apply, reboot and installed-version confirmation are not independently verified.
- Read `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md` before any OTA change.

## Current App behavior/contracts

- Firmware telemetry is authoritative for physical hardware state; do not optimistically invent physical state from ACK alone.
- Voltage selection awaits matching `VOLTAGE` telemetry before representing a transition as complete.
- BLE reconnect respects Auto Connect, known paired identity, Bluetooth/permission/location prerequisites, and syncing state. Do not run passive scanning when these prerequisites fail.
- An Online OTA `CLOUDOTA` ACK timeout/disconnect is ambiguous rather than proof of rejection. Preserve OTA recovery state and wait for reconnection/result; roll back only on definite rejection while BLE remains connected.
- Offline Dashboard/Floating Monitor output status must be unknown (`--`) rather than stale “on/off”.
- Safety/Notify state clears only after healthy live safety telemetry, not from unrelated command ACK.
- OTA screens/protocol text must use localization, not expose raw firmware protocol tokens.

## Current build / release workflow

- Only workflow: `.github/workflows/jexfyz-app-build-trigger.yml`.
- Build requires explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`.
- Issue title: `JE X FYZ — BUILD APP TRIGGER`; body token: `JEXFYZ_BUILD_TRIGGER_V1`.
- Workflow uses Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, Ubuntu 24.04; intended output is one obfuscated, production-signed `JEXFYZ-release.apk` on GitHub Release `jexfyz-latest`.
- Normal push/PR must not build a release APK.
- Historical successful run hashes in old notes require live re-verification before they are presented as current/latest.

## Exact open validation gates

1. User compiles V6.4 using ArduinoDroid + Arduino-ESP32 Core 3.3.7; verify compile output and `FW_VERSION`.
2. Verify source/BIN provenance before using or publishing `JEXFYZ.cpp.bin`; do not assume existing production BIN equals V6.4.
3. Test physical voltage change during active soft-start: expect PWM 0% during handoff, 1-second settle, fresh 5-second ramp.
4. Test physical voltage change after ramp completion: expect uninterrupted 100% PWM throughout transition.
5. Verify Peltier-OFF and safety override cancel pending resume; record reset reason if any reboot recurs.
6. Recheck NTC sensor validity, thermal lock/re-arm, Adaptive timeout and rail-recovery behavior.
7. Run explicit App regression/test/analyze only when authorized; test execution is not implied by presence of tests.
8. Validate Local OTA and Online OTA + BLE recovery on hardware before any release promotion.
9. Do not Build App unless explicitly requested, and do not infer App Build is required just because Firmware source changed.

## Current repository boundaries

- All source and memory documents live in `TenzoNkz/JEXFYZ-App`.
- `TenzoNkz/JEXFYZ-Firmware` is reserved for `JEXFYZ.cpp.bin` only; do not store notes there.
- No firmware build, BIN publication, Firebase metadata update, flash, OTA or release was performed by this documentation task.
