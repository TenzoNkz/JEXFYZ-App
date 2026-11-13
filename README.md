# JE X FYZ / JE Cooler

Flutter Android companion App and ESP32-C3 Firmware source for the JE X FYZ thermoelectric cooler.

> **Current work status:** [Open 00_WORK_STATUS.md](00_WORK_STATUS.md) for the latest project interaction, work-item state, external-operation state, last milestone and next action. Every JE X FYZ project message opens as IN_PROGRESS and closes with its actual result.

## Start here

1. [MASTER_PROMPT.md](MASTER_PROMPT.md) — single authoritative operating policy: modes, authorization, skills, tools, Gemini, memory cadence, evidence and protected contracts.
2. [AGENTS.md](AGENTS.md) — lightweight entrypoint for Codex/Copilot/repository-aware agents.
3. [SKILLS_INDEX.md](SKILLS_INDEX.md) — twelve reusable engineering skills, platform locations and capability boundaries.
4. [CHAT_TRANSFER.md](CHAT_TRANSFER.md) — latest durable checkpoint. Read fully, then verify live main.
5. [PROJECT_STATE.md](PROJECT_STATE.md) — concise current product/source/release/validation truth.
6. [MEMORY_INDEX.md](MEMORY_INDEX.md) — canonical document map and Markdown retention policy.
7. [HANDOVER.md](HANDOVER.md) — immediate next action.
8. [CHAT_TRANSFER_PROMPTS.md](CHAT_TRANSFER_PROMPTS.md) — exactly two copy-ready LOAD + CONTINUE prompts.
9. [CHAT_RULES.md](CHAT_RULES.md) — compatibility pointer to the Master Prompt.
10. App, Firmware, OTA, voltage-transition and BLE-auth contracts: [APP_NOTES.md](APP_NOTES.md), [DESIGN_NOTES.md](DESIGN_NOTES.md), [PRODUCT_DESIGN_CONSTITUTION.md](PRODUCT_DESIGN_CONSTITUTION.md), [VISUAL_QUALITY_GATE.md](VISUAL_QUALITY_GATE.md), [FIRMWARE_NOTES.md](FIRMWARE_NOTES.md), [Firmware technical reference](firmware/FIRMWARE_TECHNICAL_REFERENCE.md), [OTA protection](OTA_PROTECTION.md), [OTA incident record](OTA_REGRESSION_MEMORY.md), [voltage transition memory](VOLTAGE_TRANSITION_MEMORY.md), [BLE App authorization](BLE_APP_AUTH.md).
11. [BUILD_NOTES.md](BUILD_NOTES.md) is the current App release procedure; [APP_BUILD_REPORT.md](APP_BUILD_REPORT.md) is its append-only attempt/evidence ledger.
12. [APP_PREBUILD_AUDIT.md](APP_PREBUILD_AUDIT.md) — current full App pre-build findings, prioritized remediation and definition of build-ready.
13. [CHANGELOG.md](CHANGELOG.md) is dated history. [archive/](archive/) contains immutable forensic snapshots.

## Operating modes

- Diskusi! — analysis and planning, read-only for executable source/config/tests/workflow/build/device operations. Documentation-only memory updates may follow a substantive conclusion.
- Eksekusi Full! — only the specifically authorized source/docs/tests/static-audit scope. No App Build or Firmware/device operations.
- Eksekusi Build App! — guarded App Build/QC/release only.
- Chat Stuck! — recover only an already-authorized in-progress operation.

The Master Prompt is authoritative; chat-transfer blocks select a mode but do not widen it. The status lifecycle is governed by Section 2A of MASTER_PROMPT.md: update at each project-interaction start, real milestone/state transition and terminal close. It is event-driven, not a background heartbeat.

## Reusable engineering skills

Twelve project-specific skill workflows are available for repository forensics, code review, product design/visual quality, Flutter engineering/testing, BLE P1, ESP32-C3 safety, OTA/release integrity, GitHub Actions triage, electronics/power/thermal analysis, technical research/Gemini and documentation governance. Read [SKILLS_INDEX.md](SKILLS_INDEX.md) for triggers and locations. Codex-compatible canonical skills are under `.agents/skills/`; GitHub Copilot mirrors are under `.github/skills/`.

## Product design and visual quality

For non-trivial UI/UX work, follow [PRODUCT_DESIGN_CONSTITUTION.md](PRODUCT_DESIGN_CONSTITUTION.md) and pass the evidence-based [VISUAL_QUALITY_GATE.md](VISUAL_QUALITY_GATE.md). The product-design skill protects JE Cooler identity and rejects generic AI styling; it does not authorize a redesign or override existing screen contracts.

## Gemini second opinion

During Discussion, the assistant may proactively prepare a complete Gemini review prompt when another opinion would materially reduce uncertainty. Gemini cannot access this repository or its GitHub pages. The prompt must include all relevant facts and source/test excerpts itself; the owner pastes it manually. Gemini's answer is advisory and must be checked against live main.

## Repository boundaries

- All editable App/Firmware source, tests, workflow and canonical project memory belong in TenzoNkz/JEXFYZ-App.
- The separate TenzoNkz/JEXFYZ-Firmware repository is restricted to JEXFYZ.cpp.bin; do not add documentation or other files there.
- Preserve Android Gradle versionName exactly: Telegram @horizontalzzz.
- Do not infer App Build, Firmware compile, BIN/Firebase mutation, OTA, flashing or device authorization from a general request.

## Current status

Current release, field-device evidence, Firmware version, open validation gaps and next action are maintained in [PROJECT_STATE.md](PROJECT_STATE.md) and [CHAT_TRANSFER.md](CHAT_TRANSFER.md). Re-fetch live Actions/Release/tag data before describing any artifact as latest.