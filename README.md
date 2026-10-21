# JE X FYZ / JE Cooler

Flutter Android companion App for the JE X FYZ thermoelectric cooler and its ESP32-C3 firmware.

## Production baseline

- **App:** the owner confirms the sold unit is using Build #124.
- **Firmware:** the owner confirms V7.1 compiled successfully and was updated by Online OTA.
- **Product:** sold and shipped; ongoing maintenance must assume the physical unit is not available for routine repair.
- These deployment facts are USER-REPORTED. Build #124 is also supported by the verified App Actions/release record. App CI does not independently prove Firmware BIN identity or physical OTA/reboot behavior.

## Start here

1. [Chat Transfer Checkpoint](CHAT_TRANSFER.md) — current LOAD + CONTINUE checkpoint; read first on a new chat.
2. [Memory Index](MEMORY_INDEX.md) — canonical map of project knowledge.
3. [Chat Rules](CHAT_RULES.md) — command protocol, authorization and safety restrictions.
4. [Current Project State](PROJECT_STATE.md) — current-only baseline, risks and validation boundaries.
5. [Current Handover](HANDOVER.md) — immediate task state and recovery instructions.
6. [App Reference](APP_NOTES.md) — UI, BLE, controls, localization and telemetry.
7. [Firmware Reference](FIRMWARE_NOTES.md) and [Firmware Technical Reference](firmware/FIRMWARE_TECHNICAL_REFERENCE.md) — hardware, safety, control and implementation invariants.
8. [OTA Protection](OTA_PROTECTION.md), [OTA Regression Memory](OTA_REGRESSION_MEMORY.md), and [Voltage Transition Memory](VOLTAGE_TRANSITION_MEMORY.md) — protected update and power-transition behavior.
9. [Build and Release](BUILD_NOTES.md), [App Build Report](APP_BUILD_REPORT.md), and [.github/workflows/jexfyz-app-build-trigger.yml](.github/workflows/jexfyz-app-build-trigger.yml) — guarded App Build and complete attempt evidence.
10. [Design Notes](DESIGN_NOTES.md) and [BLE App Authorization](BLE_APP_AUTH.md) — approved visuals and current BLE identity gap.
11. [Transfer Prompt Templates](CHAT_TRANSFER_PROMPTS.md) — Prompt B for general LOAD + CONTINUE, Prompt D for Build App LOAD + CONTINUE, Prompt A for a full memory reconciliation.
12. [Changelog](CHANGELOG.md) — history only; it never overrides live source.
13. `archive/` contains immutable forensic snapshots; archived “CURRENT” text is not current truth.

## Current verified App release evidence

Build #124 / [Actions run 39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061) packages source commit `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`. It passed 116 Flutter tests and configured App release gates. APK SHA-256: `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`; source ZIP SHA-256: `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`. Native Android unit-test tasks were NO-SOURCE. Fetch live release/tag data when validating a future build.

## Repository and execution boundaries

- `TenzoNkz/JEXFYZ-App` owns App source, the editable Firmware `.ino`, tests, workflows and all memory/documentation.
- `TenzoNkz/JEXFYZ-Firmware` must contain only `JEXFYZ.cpp.bin`; never store notes/source there or change the payload during repository cleanup.
- The active editable Firmware is `firmware/JEXFYZ-V7.1.ino`, `FW_VERSION="V7.1"`. Owner-reported compile/OTA status is separate from independently verified BIN provenance and physical validation.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.
- Discussion cannot change executable source/config/workflow or trigger a build/device action. Documentation-only checkpoint writes are allowed after substantive discussions/conclusions. `@Thinking Eksekusi Full!` authorizes only the scoped full execution; `@Thinking Eksekusi Build App!` is the sole App Build/release command. Firmware compile/BIN/Firebase/OTA/flash/device operations require separate explicit authorization.
- Preserve OTA safety, `cloudClient.setInsecure()` trade-off, safe outputs, BLE single-radio handoff and existing timing. A source comment or CI success is not evidence of device safety.

At a chat/context limit, start the replacement general/Discussion chat with Prompt B or the Build App chat with Prompt D. Both use LOAD + CONTINUE, not a separate recap stage. Prompt A is for an explicitly requested full repository-memory reconciliation.
