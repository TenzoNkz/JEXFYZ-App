# JE X FYZ / JE Cooler — Permanent Rules

This file contains durable workflow, evidence and safety rules. Current implementation facts belong in the relevant canonical subject note and must be checked against live source.

## 1. Canonical commands

- @Thinking Diskusi! — read-only technical analysis and planning. Do not change executable source/config/workflow; do not run builds or operate firmware, BIN, Firebase, OTA, flash or devices. After a substantive discussion reaches a durable conclusion, update project-memory documentation only.
- @Thinking Diskusi! Tanya Gemini! — produce one self-contained prompt grounded in current source, constraints and the exact question. Do not execute the patch.
- @Thinking Diskusi! Jawaban Gemini! — assess the user's pasted answer against source and project memory. Do not accept it automatically or execute while in Discussion mode.
- @Thinking Eksekusi Full! — fully execute the specifically authorized engineering scope: scoped source/docs/tests, appropriate static audit and tests, canonical note updates, verification and commit to main. This does not authorize App Build/release or Firmware/device operations.
- @Thinking Eksekusi Build App! — the sole end-to-end App Build/QC/release command. Follow the current guarded workflow and update APP_BUILD_REPORT.md for every attempt/fix/result. Retry only after a concrete repair or evidence-based transient failure; never retry blindly.
- @Thinking Chat Stuck! — recover an interrupted, already-authorized operation from actual logs and live state. Do not duplicate side effects, commits or builds. This command does not broaden scope or independently authorize a build. If the inherited scope cannot be established, diagnose read-only and ask for a valid command before writing.

Tanya Gemini! and Jawaban Gemini! require Diskusi! in the same command. Retired aliases @Thinking Build App! and @Thinking Eksekusi & Build App! are invalid.

## 2. Chat-limit handling

Use only the two templates in CHAT_TRANSFER_PROMPTS.md:
1. General engineering: Discussion, an explicitly authorized Eksekusi Full task, or recovery of an already-authorized interrupted operation.
2. Build App: one-shot LOAD + CONTINUE for an already authorized App Build/QC operation.

A replacement chat must LOAD and CONTINUE; do not create a recap-only chat or ask the user to repeat saved requirements. The copy-ready blocks in CHAT_TRANSFER_PROMPTS.md use the short command name alone as their first line, without the @Thinking prefix. Prompt 1 defaults to Diskusi!; for an explicitly authorized Eksekusi Full scope or a Chat Stuck recovery, replace only its first line with Eksekusi Full! or Chat Stuck!. Prompt 2 starts with Eksekusi Build App! and is only for that guarded workflow. Paste the selected block as one complete message without a duplicate command line above it. The selected mode cannot widen the rest of the payload's scope. If authorized execution was interrupted, use Chat Stuck! rather than silently switching to Discussion or starting another build.

GitHub is the durable project-memory store, not an automatic transcript of the conversation. Only changes actually committed to main and verified should be described as saved. Checkpoint after each durable decision, significant finding, logical task milestone, test result, or blockage. At the end of every substantive Discussion/Eksekusi Full task, update CHAT_TRANSFER.md and the relevant canonical notes before reporting completion. During Build App, append each actual attempt and its evidence to APP_BUILD_REPORT.md as work progresses and refresh CHAT_TRANSFER.md at each logical milestone, then finalize both at success/blockage. Before an expected chat limit, record the last verified step, active authorization/scope, remaining work, current run status, blockers, evidence links and next action. If interruption occurs before the commit is verified, resume from the last saved checkpoint/live evidence; never claim the unsaved chat tail was automatically preserved.

Before ending any substantive project chat, perform a save pass over the conversation since the last verified checkpoint. Persist new durable decisions, requirements, findings, progress, blockers and next steps in canonical notes; do not wait for a separate save request. If no durable information changed, keep the prior checkpoint rather than creating a no-op commit.

## 3. Source-of-truth and memory discipline

- Start by reading CHAT_TRANSFER.md fully; then fetch live main HEAD and the complete recursive tree. Read MEMORY_INDEX.md, PROJECT_STATE.md and HANDOVER.md. Read the full canonical reference(s) for the active task.
- Repository state wins over stale summaries for current code/version. User instructions remain authoritative for permissions and preferences.
- CHAT_TRANSFER.md is a rolling checkpoint, not a transcript. PROJECT_STATE.md is current-only. CHANGELOG.md is dated history. APP_BUILD_REPORT.md is the authoritative build-attempt ledger. Subject references own detailed engineering contracts. Files in archive/ are immutable forensic history, never current truth.
- After a substantive Discussion conclusion or execution completion/blockage, update the checkpoint and the relevant canonical document. Keep proposals separate from decisions; label user-reported outcomes and independently verified evidence separately.
- Do not store a source fingerprint inventory that quickly becomes stale. Record hashes only where they materially identify a release, artifact, test evidence or a reproducible current-state comparison. Re-fetch files before relying on any SHA.
- Don't call a test/build/compile/device check passed unless its result was actually observed. Test-file presence is not test execution. App CI does not prove Firmware compile, BIN provenance, OTA application or physical safety.
- Before deletion, rename or moving a file, search all links and path-based tests, update all references and verify the final tree. Keep user-approved constraints and important failed approaches.
- Do not expose credentials or secrets in prompts or summaries.

## 4. Main branch and write policy

- Canonical repository: TenzoNkz/JEXFYZ-App. Work directly on main by default; do not create a branch or PR unless asked.
- Fetch the live main HEAD/tree and each file's current content/blob before edits. Re-read a file just before replacing/deleting if it may have changed.
- For multi-file edits, verify every resulting path/content and the final commit/tree. Never report a failed or unconfirmed write as successful.

## 5. Firmware source contract

- Every functional Firmware edit increments FW_VERSION and renames the active file to match. Exactly one active versioned .ino may exist in firmware/.
- Firmware compilation is separate from source editing; the owner compiles with ArduinoDroid and the approved Arduino-ESP32 Core 3.3.7 toolchain.
- No executable delay() and no timing while() loops. Retain cooperative millis() timing unless a justified change is explicitly approved.
- A source edit/version bump is not a BIN, Firebase publication, OTA, flash or installed-device confirmation.
- Do not claim a reset cause without BOOT: RESET_REASON=... or matching diagnostic evidence.

## 6. Hard safety and product boundaries

Never infer authorization for any of the following from a general repository task:
- App Build/APK/Release; only @Thinking Eksekusi Build App! authorizes the guarded App release workflow.
- Firmware compile, BIN generation/publication/replacement, Firebase/production metadata changes.
- Physical OTA, flashing, device operation or any other release outside the authorized App workflow.

Protected Firmware/App contracts:
- Preserve BLE P1 UUIDs/protocol, authoritative telemetry, radio ownership and command/reconnect semantics.
- Preserve safe outputs, Peltier/selector/rail timing, Touch behavior, sensor-fault protection and existing OTA recovery.
- OTA is frozen unless a demonstrated defect has been discussed and explicitly authorized. Before any OTA change, read OTA_PROTECTION.md, OTA_REGRESSION_MEMORY.md and the live related source/tests.
- Current Online OTA intentionally uses cloudClient.setInsecure(); this encrypts transport but does not authenticate server certificate identity. Preserve the trade-off and GitHub BIN allowlist, redirect blocking and image/size/status validation unless an explicitly approved redesign says otherwise.
- Do not add Firmware hash/signature requirements to Firebase OTA metadata without explicit user approval.
- Android Gradle versionName "Telegram @horizontalzzz" is intentional and must remain exact.
- Do not show a standalone Battery Protection Guard UI. This is a presentation restriction, not permission to weaken Firmware safety.
- Exclusive BLE App identity authorization remains BLOCKED until trusted backend enrollment/signing and Firmware verification are implemented. Bonded writes plus SYNC_READY do not prove the official App identity.

## 7. Documentation roles

- README.md: project introduction and entry points.
- CHAT_TRANSFER.md: rolling load/continue checkpoint.
- CHAT_TRANSFER_PROMPTS.md: exactly two chat-limit prompts, not a historical prompt library.
- CHAT_RULES.md: durable instructions, never a duplicated live-state report.
- MEMORY_INDEX.md: map, authority and Markdown retention policy.
- PROJECT_STATE.md: concise present truth and open validation gaps.
- HANDOVER.md: short immediate continuation handoff.
- APP_NOTES.md and DESIGN_NOTES.md: current App behavior contract and approved visual constraints.
- FIRMWARE_NOTES.md and firmware/FIRMWARE_TECHNICAL_REFERENCE.md: durable hardware/safety decisions and current source-level technical reference.
- OTA_PROTECTION.md, OTA_REGRESSION_MEMORY.md and VOLTAGE_TRANSITION_MEMORY.md: protected contracts and specific incident/transition memory.
- BUILD_NOTES.md: current build procedure; APP_BUILD_REPORT.md: append-only attempt/fix evidence.
- CHANGELOG.md: dated history only. archive/*.md is preserved, immutable historical evidence.
