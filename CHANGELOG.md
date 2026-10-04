## 2026-10-04 — CHAT-LIMIT HANDOVER CHECKPOINT

- Current chat is being handed over because the context limit is near.
- README.md already contains the detailed copy-ready new-chat prompt and is the mandatory first-read entry point.
- HANDOVER.md is the portable handoff artifact; the embedded prompt remains the required continuation prompt.
- Current firmware remains V3.7; active source is `firmware/JEXFYZ-V3.7.ino`.
- Latest verified App Build remains #50; no App Build was triggered by this handover checkpoint.
- Firmware V3.7 ArduinoDroid/Core 3.3.7 compile, BIN publication, Firebase promotion, and physical validation remain unperformed.
- Next chat must perform the full repository memory preflight before any action.

## 2026-10-04 — EXECUTION FULL / MEMORY ARCHITECTURE COMPLETED

- Completed the persistent continuity stack: README.md, PROJECT_STATE.md, CHAT_RULES.md, APP_NOTES.md, FIRMWARE_NOTES.md, BUILD_NOTES.md, CHANGELOG.md, HANDOVER.md, plus firmware/FIRMWARE_ANALYSIS.md.
- README.md now serves as the mandatory new-chat entry point and contains a detailed copy-ready continuation prompt.
- PROJECT_STATE.md is the current-state snapshot.
- Build App is explicitly treated as a complex workflow across separate subchats.
- Every meaningful project event requires an automatic memory synchronization pass; the user does not need to request it.
- No functional App/Firmware behavior changed in this continuity task.
- No App Build or firmware compile was triggered.

## 2026-10-04 — DUAL CHAT-LIMIT PROMPT SYSTEM

- Added Prompt A — CHAT-LIMIT RECAP for complete context export from a chat approaching its context limit.
- Added Prompt B — NEW CHAT TRANSFER for fresh-chat memory preflight, current-source reconciliation, and safe continuation.
- Defined the recap as transfer evidence rather than a source-of-truth replacement.
- Applied the mechanism to separate Build App subchats as well.
- Documentation/process change only; no functional App/Firmware source or build output changed.
## 2026-10-04 — REPOSITORY-FIRST CHAT TRANSFER IMPLEMENTED

- Added CHAT_TRANSFER.md as the canonical rolling transfer snapshot.
- Prompt 1 is CHAT → REPOSITORY: read the entire old chat, reconcile it, save the complete snapshot, and verify persistence.
- Prompt 2 is REPOSITORY → NEW CHAT: read all memory and CHAT_TRANSFER.md, verify current source/workflow, reconcile, and continue.
- Manual copy-paste between chats is no longer the intended transfer mechanism.
- Documentation/process only; functional App/Firmware behavior unchanged and no Build App triggered.

# JE X FYZ — CHANGELOG

## 2026-10-04 — CONTINUITY SYSTEM

### Documentation architecture
- Added the project operating manual and copy-ready continuation prompt.
- Added current-state snapshot, build-memory history, milestone history, and portable handover documentation.
- Formalized automatic memory synchronization across Discussion, Execution, Build, Gemini, compile, and hardware-test events.
- Formalized mandatory memory preflight before **any** project action, including separate Build App subchats.
- Formalized successful App Build as a persistent memory checkpoint.

## 2026-10-04 — FIRMWARE V3.7

- Firmware advanced V3.6 → V3.7.
- Peltier remains 20 kHz, 8-bit, 5 s soft-start.
- Peltier OFF → ON starts soft-start.
- Every upward voltage transition while Peltier is ON restarts soft-start.
- Downward voltage transitions do not restart soft-start.
- No BLE UUID/token/GPIO contract change.

## 2026-10-04 — FIRMWARE V3.6

- Universal Hotside safety for Manual, HOTSIDE, and HOTSIDE_BATTERY.
- Manual hot forces 5 V, Fan 100%, Peltier safety latch.
- Adaptive hot steps down immediately and applies post-step Peltier cooldown.
- HOTSIDE_BATTERY keeps Hotside as the safety ceiling.
- Battery loss falls back to HOTSIDE runtime behavior.
- Hotside event LED: 5 s red non-blocking indicator.

## 2026-10-04 — FIRMWARE V3.4 / V3.5 CORRECTIONS

- Corrected V3.3 function-placement/source-structure issue.
- Advanced to V3.4 for the corrective source.
- V3.5 introduced the broader Adaptive/Hotside safety flow later finalized in V3.6.

## 2026-10-04 — FIRMWARE V3.0–V3.3

- Battery Adaptive evolved to direct-zone, one-step voltage movement with a shared 1 s dwell.
- Added Battery-originated deadtime revalidation and source tracking.
- Added Hotside-only Adaptive behavior, Battery-loss fallback, LED brightness range enforcement, OTA progress indicators, and cooperative no-delay processing.

## 2026-10-03 — FIRMWARE V2.9

- Deterministic Touch state machine.
- Retired per-voltage user-configurable LED colors.
- OTA firmware size hard cap moved to 1792 KiB.
- VOLTAGE-only guard narrowing.

## APP BUILD HISTORY

### Build #50
- Run: 36996987220
- Source: bf01595253eb5a1912471c4aee57c4eed4421f0f
- APK artifact: 11222007634
- APK SHA256: 82a2320d8e3663800d6884f4cb0d009ff1b31b5b19cc64420f9ee5c6b01d01b0
- Symbols artifact: 11222132522
- Symbols SHA256: a87a3181bada92e229da3c1f79d9a59339d7669c11b32ac1d8c219ae435c9062
- Gates: security, dependency, analysis, tests, release, and signing passed.

### Build #49
- Run: 36968864365
- APK artifact: 11210039662
- Size: 54,327,376 bytes
- APK SHA256: bc72694942a6ad80db6b6733f9d053015ebf2baf4dc1fbcab650707e3c6560ca
- Symbols artifact: 11210314367
- Symbols SHA256: ba1285ee76a86d6011aa7759582fd9029e2191bbbd237bea85ff458c0d105d71
- Gates: security, dependency, analysis, tests, release, and signing passed.

## CHANGELOG RULE

This file is milestone history, not the current source of truth.
For current truth, always read PROJECT_STATE.md and the current repository source.
