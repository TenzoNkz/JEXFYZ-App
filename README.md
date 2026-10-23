# JE X FYZ / JE Cooler

Flutter Android companion App and ESP32-C3 Firmware source for the JE X FYZ thermoelectric cooler.

## Production baseline

- **Latest independently verified App release:** Build #129, [GitHub Actions run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), packaged source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`.
- APK SHA-256: `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`; matching source ZIP SHA-256: `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`. [Download APK](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) · [Download source ZIP](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip).
- The owner previously reported installing/overwriting Build #128 on the sold/shipped unit; Build #129 installation is **not independently confirmed**. Firmware V7.1 compile/Online OTA remains USER-REPORTED. App CI does not prove Firmware BIN identity or physical-device behavior.
- Build #129 passed all 21 workflow gates and 122 Flutter tests, including Home-equivalent DPI canvas regression coverage. Native Android JUnit tasks were `NO-SOURCE`; physical-device/OEM layout QA remains outstanding.
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

## Durable project memory and chat continuity

- The repository is the shared project-memory source, but it does not automatically receive the ChatGPT transcript. A checkpoint is durable only after a real commit to `main` is verified.
- Before ending any substantive project chat, compare the conversation against the last checkpoint and save new durable details; no separate save request is required. If there is no new durable information, retain the existing checkpoint instead of creating an empty commit.
- Checkpoint after every durable decision, meaningful finding, logical work milestone, test result, or blocker; also refresh the handoff at substantive task completion. Do not wait for the owner to request a save.
- Before a chat-limit transfer, update `CHAT_TRANSFER.md` with the exact last verified state, active mode/authorization, completed milestone, remaining task, run status, evidence, blockers, and next safe step. During Build App, update `APP_BUILD_REPORT.md` as attempts progress.
- Use only the two complete LOAD + CONTINUE blocks in `CHAT_TRANSFER_PROMPTS.md`. A replacement chat must read saved records and re-check live GitHub state. An unsaved conversation tail cannot be guaranteed to survive an abrupt interruption.

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
