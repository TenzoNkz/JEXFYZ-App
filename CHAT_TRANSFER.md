# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after the V6.8 Adaptive Fan PWM temperature-tier change on 2026-10-20 (Asia/Jakarta). This file is written last after source/test/docs updates. The HEAD/tree below describe live main immediately before this transfer write; this blob cannot self-reference its future hash.

## 1. Authority, scope and protocol

- Canonical editable repository: TenzoNkz/JEXFYZ-App, branch main. Continue directly on main; do not create branches/PRs unless explicitly requested.
- Pre-transfer HEAD: d6307def7b8cb2c71e20dec7e58eaf721aa0fcdf. Parent: f36a52cf512bcc7b7dddff5793f443699b471277. Recursive tree: d6307def7b8cb2c71e20dec7e58eaf721aa0fcdf, 67 entries (49 blobs / 18 trees), not truncated.
- Diskusi is read-only. Eksekusi Full authorizes scoped source/tests/docs/audit/commit only, not App Build, Firmware compilation, BIN generation/publication, Firebase, OTA, flash or device operations. Eksekusi Build App alone authorizes end-to-end App build/QC/release. Chat Stuck recovers an existing authorized operation but does not widen scope.
- User compiles Firmware in ArduinoDroid with Arduino-ESP32 Core 3.3.7. Do not infer compile/install/BIN provenance from source-contract checks.
- Preserve Android Gradle versionName "Telegram @horizontalzzz". App repo owns code, tests and project memory; TenzoNkz/JEXFYZ-Firmware remains BIN-only.
- Protected OTA behavior and its TLS trade-off remain unchanged. No BIN, Firebase, OTA, flash or physical-device action was performed.

## 2. Current Firmware source — V6.8

- Exactly one active versioned sketch is present: `firmware/JEXFYZ-V6.8.ino`, blob `7b4df708708e021aad39258468eed2fde94d202f`, embedded `FW_VERSION="V6.8"`. The prior V6.7 sketch was removed.
- V6.8 replaces the Adaptive 12 V Fan trend/stability controller: no ten-sample downshift state, four-sample warming-trend state, 10-second step-down timer or 3-second step-up timer.
- Target PWM is selected directly from `delta = hotLimit - hotsideC`, with no extra hysteresis: delta <1.5°C →100%; 1.5–<2.5°C →90%; 2.5–<3.5°C →80%; 3.5–<4.5°C →70%; 4.5–<5.5°C →60%; delta ≥5.5°C →50%. User-facing whole-degree examples remain 1°C below limit=100%, 2°C=90%, 3°C=80%, 4°C=70%, 5°C=60%, and 6°C or more=50%. At ≥6°C below limit, target stays 50% while that condition remains true. Fractional temperatures switch at half-degree boundaries.
- Hotside limit or active Hotside protection forces 100%. Adaptive 5 V/9 V remains at 100%. Existing invalid-NTC fail-safe, voltage transition, thermal dwell, inactive/paused-output conditions and Peltier safety priority are preserved. Manual PWM remains Manual/12 V only. BLE protocol/telemetry and protected OTA code were not intentionally changed.
- NTC acquisition remains one calibrated `analogReadMilliVolts(PIN_NTC)` sample per second; no filter, executable `delay()` or timing `while()` was introduced.
- Static source audit passed: V6.8 filename/embedded version, each target tier, removal of old trend/timer state, force-100% safety branch, Adaptive 12-V gate, exactly one NTC read, and absence of prohibited timing constructs.
- **Validation status: SOURCE UPDATED / TESTS NOT RUN / NOT COMPILED / NOT INSTALLED.** `test/firmware_qc_contract_test.dart` blob `59f376af6b3ec1c22d24f71db6afa40927a835fd` checks tier mapping, old-state removal, safety gates and NTC cadence. `test/firmware_touch_adaptive_sync_test.dart` blob `a96b501d694b6eb4ad42fca0c61a8a430b129105` now reads V6.8.
- The retired `test/v6_7_qc_contract_test.dart` and `firmware/JEXFYZ-V6.7.ino` are absent from the live tree. Remaining V6.7 references in the changelog/report/regression history are historical only.

## 3. App / release boundary

- Latest successful App release remains Build #106 / run 39279938461, packaged source `9f90cf6063ee7786613f8b5dfa1c6b0412d89638`. Analyzer exited 0 with 25 info findings/no errors or warnings; 108 Flutter tests passed; configured Android gate, APK signature/certificate, source ZIP integrity and release-asset checks passed.
- APK asset 656702702, 54,734,939 bytes, SHA-256 `bab332a4312c628178e384a88d513cf8546ff15ab4b4e3f3becf2e70b10830cc`. Corresponding source ZIP asset 656702729, 2,866,720 bytes, SHA-256 `0bb86c4e6bd7d3cb7a6bb894658bd707acee48bac106fc5227f8adcba584ec98`. Release target remains Build #106 source.
- The App UI follow-up is newer than Build #106 and NOT RUN / NOT RELEASED: left-aligned badge-free Home NOTIFY, Battery/Hotside oval ember bursts and Voltage outer-contour pulses. Current blobs: `lib/main.dart` `7e09a3d28b4efe24bdced858db4274cf70806284`; `lib/app_settings.dart` `8f228000d38d73038c06f569c052b1af601288a5`; `test/widget_test.dart` `5a82cf79e6c5c40fc34489ce90cf1200cf9faccb`.
- No App Build was triggered by this Firmware task. Build #106 does not validate the current App UI follow-up or V6.8 Firmware.

## 4. Canonical documentation fingerprints

- FIRMWARE_NOTES.md: `e36f7c1eeddecfa36be3fe9bf43f2c4e9ef91a0c`
- firmware/FIRMWARE_TECHNICAL_REFERENCE.md: `2f37fa5a571aef003a3e0b1faa265e63f5d92ace`
- PROJECT_STATE.md: `50d2edc38e79de8a87a4cc0645ab09f1f4cd2277`
- HANDOVER.md: `1bd43e1db644ee19ce341cda9edefacf9473e4c7`
- MEMORY_INDEX.md: `c8dfb037fcf98579af209f536de3c01a68143356`
- APP_NOTES.md: `0492aff81e3c1f15f6642356d53f846aac4c36e2`
- README.md: `52dec2e6b6d801cd014d45544dfd39411c2d3947`
- OTA_PROTECTION.md: `8384254a05881076d8d7ef70e5606815884d7816`
- OTA_REGRESSION_MEMORY.md: `41a15b7374ba2259e3a07798da54954a3755cb54`
- VOLTAGE_TRANSITION_MEMORY.md: `23c455c4e92c7763852c6650f1075dc62ae171f6`
- CHAT_RULES.md: `4ab0e1a501a52eb8f3a2b0bd18969a839501ce36`
- CHAT_TRANSFER_PROMPTS.md: `99a3d667e82e7d72c29e8c7bcd6e79942a2f8f0d`
- CHANGELOG.md: `b5b3cfcc74e9b63e28926aaa88ff793868144fc6`
- BUILD_NOTES.md: `304ad67924638f9218beb0697053df69d30e8bc2`
- APP_BUILD_REPORT.md: `fdbbb3d9507eea2b858c3b622c63126ceb82a9a2`
- .github/workflows/jexfyz-app-build-trigger.yml: `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12` (guarded issue-trigger workflow unchanged).

## 5. Firmware artifact / device boundary

- TenzoNkz/JEXFYZ-Firmware recursive tree contains exactly one file: `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was checked; the payload was not read. Source-to-BIN provenance remains UNVERIFIED.
- V6.7 compile/online update on 2026-10-18 is historical USER-REPORTED evidence only; it does not validate V6.8.
- No Arduino compile, App Build, BIN generation/publication, Firebase update, OTA, flash or hardware operation was performed. Flutter/Dart contracts were not run for V6.8. Physical PWM behavior, temperature response, installed firmware version and source-to-BIN identity remain UNVERIFIED.

## 6. Recovery disposition

- RECOVERED / EXECUTED: V6.8 Adaptive Fan PWM tiers implemented; V6.7 sketch and stale V6.7 test suite removed; QC contract and Touch/Adaptive test paths updated; canonical memory reconciled.
- Source/doc/test changes are committed directly to `main`. This snapshot is written last; fetch live final HEAD/tree/blob after committing.