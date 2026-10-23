# JE X FYZ / JE Cooler

Flutter Android companion App and ESP32-C3 Firmware source for the JE X FYZ thermoelectric cooler.

## Production baseline

- App Build #124 is the package the owner reports using on the sold/shipped unit.
- Firmware V7.1 was compiled and updated through Online OTA, according to the owner.
- These deployment facts are USER-REPORTED. Build #124 is independently supported by GitHub Actions run 39386733061. App CI does not prove Firmware BIN identity or physical-device behavior.
- The field unit is not available for routine disassembly. Avoid discretionary product changes and preserve BLE/OTA/safety behavior.

## Read first

1. [CHAT_TRANSFER.md](CHAT_TRANSFER.md) — rolling checkpoint. Read fully, then verify live main.
2. [CHAT_RULES.md](CHAT_RULES.md) — commands, authorization and engineering guardrails.
3. [MEMORY_INDEX.md](MEMORY_INDEX.md) — source-of-truth map and retention policy for all Markdown records.
4. [PROJECT_STATE.md](PROJECT_STATE.md) — concise current-only status.
5. [HANDOVER.md](HANDOVER.md) — immediate continuation instructions.
6. [CHAT_TRANSFER_PROMPTS.md](CHAT_TRANSFER_PROMPTS.md) — exactly two LOAD + CONTINUE prompts: general engineering, and Build App.
7. [APP_NOTES.md](APP_NOTES.md), [DESIGN_NOTES.md](DESIGN_NOTES.md) — App behavior and approved design.
8. [FIRMWARE_NOTES.md](FIRMWARE_NOTES.md), [firmware/FIRMWARE_TECHNICAL_REFERENCE.md](firmware/FIRMWARE_TECHNICAL_REFERENCE.md) — hardware, safety and firmware invariants.
9. [OTA_PROTECTION.md](OTA_PROTECTION.md), [OTA_REGRESSION_MEMORY.md](OTA_REGRESSION_MEMORY.md), [VOLTAGE_TRANSITION_MEMORY.md](VOLTAGE_TRANSITION_MEMORY.md) — protected OTA and rail/Peltier behavior.
10. [BUILD_NOTES.md](BUILD_NOTES.md), [APP_BUILD_REPORT.md](APP_BUILD_REPORT.md), [.github/workflows/jexfyz-app-build-trigger.yml](.github/workflows/jexfyz-app-build-trigger.yml) — App release procedure and evidence.
11. [BLE_APP_AUTH.md](BLE_APP_AUTH.md) — App-identity authorization blocker.
12. [CHANGELOG.md](CHANGELOG.md) — dated change history only. [archive/](archive/) contains immutable forensic records.

## Current verified App release

Build #124 / [Actions run 39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061) packages source commit 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a. It passed 116 Flutter tests and configured release gates; native Android unit-test tasks were NO-SOURCE.

- APK SHA-256: c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318
- Source ZIP SHA-256: e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152

Fetch live Actions and Release data before describing any future package as latest.

## Repository and authorization boundaries

- TenzoNkz/JEXFYZ-App owns all editable App/Firmware source, tests, workflow and project memory.
- TenzoNkz/JEXFYZ-Firmware must contain only JEXFYZ.cpp.bin. Do not edit or inspect its payload during documentation cleanup.
- Preserve Android Gradle versionName "Telegram @horizontalzzz".
- @Thinking Diskusi! is read-only for code/config/workflow/build/device operations; after a durable discussion conclusion, documentation-only checkpoint updates are allowed.
- @Thinking Eksekusi Full! authorizes only the approved source/docs/tests/static-audit scope. It never implies App Build/release, Firmware compilation, BIN/Firebase changes, OTA, flash or device operations.
- @Thinking Eksekusi Build App! is the only App Build/release authorization. Firmware compilation, BIN publication, Firebase, OTA, flash and device work need separate explicit authorization.
