# JE X FYZ / JE Cooler

Flutter Android companion App and ESP32-C3 Firmware source for the JE X FYZ thermoelectric cooler.

## Start here

1. [MASTER_PROMPT.md](MASTER_PROMPT.md) — single authoritative operating policy: commands, authorization, LOAD + CONTINUE, Gemini handoff, memory-save cadence, evidence labels and protected contracts.
2. [CHAT_TRANSFER.md](CHAT_TRANSFER.md) — latest durable checkpoint. Read fully, then verify live main.
3. [PROJECT_STATE.md](PROJECT_STATE.md) — concise current product/source/release/validation truth.
4. [MEMORY_INDEX.md](MEMORY_INDEX.md) — canonical document map and Markdown retention policy.
5. [HANDOVER.md](HANDOVER.md) — immediate next action.
6. [CHAT_TRANSFER_PROMPTS.md](CHAT_TRANSFER_PROMPTS.md) — exactly two copy-ready LOAD + CONTINUE prompts.
7. [CHAT_RULES.md](CHAT_RULES.md) — compatibility pointer to the Master Prompt.
8. App, Firmware, OTA, voltage-transition and BLE-auth contracts: [APP_NOTES.md](APP_NOTES.md), [DESIGN_NOTES.md](DESIGN_NOTES.md), [FIRMWARE_NOTES.md](FIRMWARE_NOTES.md), [Firmware technical reference](firmware/FIRMWARE_TECHNICAL_REFERENCE.md), [OTA protection](OTA_PROTECTION.md), [OTA incident record](OTA_REGRESSION_MEMORY.md), [voltage transition memory](VOLTAGE_TRANSITION_MEMORY.md), [BLE App authorization](BLE_APP_AUTH.md).
9. [BUILD_NOTES.md](BUILD_NOTES.md) is the current App release procedure; [APP_BUILD_REPORT.md](APP_BUILD_REPORT.md) is its append-only attempt/evidence ledger.
10. [CHANGELOG.md](CHANGELOG.md) is dated history. [archive/](archive/) contains immutable forensic snapshots.

## Operating modes

- Diskusi! — analysis and planning, read-only for executable source/config/tests/workflow/build/device operations. Documentation-only memory updates may follow a substantive conclusion.
- Eksekusi Full! — only the specifically authorized source/docs/tests/static-audit scope. No App Build or Firmware/device operations.
- Eksekusi Build App! — guarded App Build/QC/release only.
- Chat Stuck! — recover only an already-authorized in-progress operation.

The Master Prompt is authoritative; chat-transfer blocks select a mode but do not widen it.

## Gemini second opinion

During Discussion, the assistant may proactively prepare a complete Gemini review prompt when another opinion would materially reduce uncertainty. Gemini cannot access this repository or its GitHub pages. The prompt must include all relevant facts and source/test excerpts itself; the owner pastes it manually. Gemini's answer is advisory and must be checked against live main.

## Repository boundaries

- All editable App/Firmware source, tests, workflow and canonical project memory belong in TenzoNkz/JEXFYZ-App.
- The separate TenzoNkz/JEXFYZ-Firmware repository is restricted to JEXFYZ.cpp.bin; do not add documentation or other files there.
- Preserve Android Gradle versionName exactly: Telegram @horizontalzzz.
- Do not infer App Build, Firmware compile, BIN/Firebase mutation, OTA, flashing or device authorization from a general request.

## Current status

Current release, field-device evidence, Firmware version, open validation gaps and next action are maintained in [PROJECT_STATE.md](PROJECT_STATE.md) and [CHAT_TRANSFER.md](CHAT_TRANSFER.md). Re-fetch live Actions/Release/tag data before describing any artifact as latest.