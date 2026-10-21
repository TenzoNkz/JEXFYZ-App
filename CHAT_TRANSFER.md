# JE X FYZ / JE Cooler — LIVE CHAT CHECKPOINT

Checkpoint maintenance date: 2026-10-21 (Asia/Jakarta). This is a concise continuation checkpoint, not a transcript summary. Always verify live `main` before relying on hashes or current Actions/Release state.

## Production status — confirmed by product owner

- **Android App:** the sold unit is using **Build #124**, as confirmed by the owner.
- **Firmware:** **V7.1 was compiled and successfully updated through Online OTA**, as confirmed by the owner.
- **Product:** unit sold and shipped to the buyer. It is not available for routine physical disassembly or repair.
- Treat Build #124 + Firmware V7.1 as the **production baseline**. Future maintenance may use the App and online firmware-update path, but avoid discretionary updates and any change that could strand the remote device.
- These deployment/compile/OTA outcomes are **USER-REPORTED**. The source repository and App CI alone do not independently verify the installed device, exact BIN identity, live OTA behavior, reboot, BLE recovery, or thermal/electrical behavior. Do not turn this evidence limitation into a claim that the owner-reported deployment did not happen.

## Repository and release evidence

- Canonical repository: `TenzoNkz/JEXFYZ-App`, branch `main`; work directly on main unless explicitly asked otherwise.
- Latest code checkpoint before this documentation cleanup: HEAD `ca143274994316ebfee6195b47c59bab9cd1b3bb` (2026-10-20); recursive tree contained 68 entries and was not truncated. Re-fetch HEAD/tree on each new chat.
- Latest independently verified App release record: Build #124 / Actions run [39386733061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39386733061), package source `7d4e7262c6a3474eefa8ccb58b08f070df3ac15a`. It passed 116 Flutter tests and configured release gates; native Android unit-test tasks were NO-SOURCE. APK SHA-256 `c0738d3607b120b716841610c849d9608f954a5f1f28017a8018790f4f4b6318`; corresponding source ZIP SHA-256 `e00ac34cb6cf7f04a5485c8ab8ee74d4acc1b20dc1a213ac733a8bf8c43cc152`.
- Active editable Firmware source: `firmware/JEXFYZ-V7.1.ino`, `FW_VERSION="V7.1"`, current blob `c44e076b2c1ee2d0b66b4fcd308d0febc69976e9`. The owner's compile/OTA confirmation applies to the product in the field; no binary payload was inspected and its source-to-BIN identity is not independently proven here.
- Current source-contract fingerprints after comment-only maintenance: QC `test/firmware_qc_contract_test.dart` blob `367acddd4ca9123c2834f8a5177039d9dadaabc9`; Touch/Adaptive sync `test/firmware_touch_adaptive_sync_test.dart` blob `dfa1f604327f1705b52134aa794d7ce60232841e`; Floating Monitor layout `test/floating_monitor_layout_contract_test.dart` blob `1159ac2970381cd6811a7a4a84c9d92321080f7b`.
- Comment-only equivalence was checked for all changed source/test/config files against their pre-cleanup blobs. No runtime logic changed. No test, analysis, Gradle build, Arduino compile, App Build, BIN, Firebase, OTA, flash or device operation ran in this cleanup.

- `TenzoNkz/JEXFYZ-Firmware` is BIN-only and must contain only `JEXFYZ.cpp.bin`. Never inspect or edit the payload during documentation cleanup.
- Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.

## Firmware behavior contract — preserve as-is

- Adaptive Fan target bands are relative to configured Hotside limit using whole-degree temperature categories: delta ≤2°C →100%; 3–4°C →90%; 5–6°C →80%; 7–8°C →70%; 9–10°C →60%; ≥11°C →50%. At limit 40°C: 40/39/38 →100%; 37/36 →90%; 35/34 →80%; 33/32 →70%; 31/30 →60%; ≤29 →50%.
- Raw-decimal safety remains immediate: at/above the configured Hotside limit, Fan 100% and Peltier OFF. Adaptive PWM increases by 10 percentage points per second and decreases by 10 points per 10 seconds; Adaptive 5 V/9 V remains 100%.
- Keep Touch/P1, single-radio Wi-Fi↔BLE handoff, BLE state reconciliation, Peltier and rail timing, Local OTA, Online OTA, output-safe recovery and restart behavior unchanged during maintenance.
- Online OTA intentionally retains `cloudClient.setInsecure()`; this encrypts transport but does not authenticate server certificate identity. Keep the raw-GitHub BIN allowlist, redirect policy and image/size/status checks. Do not add firmware checksum/signature fields to Firebase metadata without explicit approval.

## App behavior and product constraints

- BLE P1: service `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`, RX `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`, TX `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`.
- Firmware telemetry, not command ACK alone, is authoritative for physical state. When disconnected, physical values should remain unknown (`--`) rather than fabricated.
- Preserve bilingual English/Indonesian copy, latest-event Home NOTIFY, the no-standalone-Battery-Protection-Guard UI rule, Floating Monitor metrics B/H/V/A/P/F with Fan speed under F, and settings/storage compatibility.
- BLE App-only authorization remains BLOCKED / NOT IMPLEMENTED until trusted backend enrollment/signing is designed and implemented; encrypted/bonded writes and `SYNC_READY` are not proof of official App identity.

## Commands and authorization

- `@Thinking Diskusi!`: technical discussion. No executable source/config/workflow edits, build/release, firmware/BIN/Firebase, OTA, flashing or device operations. After a substantive discussion concludes, documentation-only checkpoint and canonical memory updates are allowed and expected.
- `@Thinking Eksekusi Full!`: perform the specifically approved source/docs/tests/static-audit task and commit to main. It does not authorize App Build/APK release, Firmware compile, BIN publication, Firebase production changes, OTA, flashing or physical-device work.
- `@Thinking Eksekusi Build App!`: sole end-to-end App Build/QC authorization. Follow the live guarded workflow and update `APP_BUILD_REPORT.md`.
- `@Thinking Chat Stuck!`: recover the last valid authorized operation from live logs/state without blind retries or widening scope.
- `Tanya Gemini!` and `Jawaban Gemini!` require `Diskusi!` in the same command. Retired commands remain invalid.

## Chat-limit LOAD + CONTINUE — no recap stage

- General/Discussion replacement chat: use **Prompt B** in `CHAT_TRANSFER_PROMPTS.md`. It reads this checkpoint + live repository and resumes the prior workstream without a recap-only chat.
- Build App replacement chat: use **Prompt D** once. It reads live source, workflow and `APP_BUILD_REPORT.md`, then resumes the same authorized Build App operation.
- **Prompt A is only for a requested full memory reconciliation**, not default chat-limit recovery.
- After each substantive Discussion reaches a conclusion and after each execution completes/blocks, update this checkpoint and relevant canonical note(s). During an ongoing execution, save durable milestones and blockers when they become known. A hard interruption before a checkpoint write can leave the latest unsaved chat content unavailable; recovery must be honest about that boundary.

## Canonical references

- Current-only state: `PROJECT_STATE.md`; quick index: `MEMORY_INDEX.md`; immediate handoff: `HANDOVER.md`.
- App/UI/BLE: `APP_NOTES.md`; hardware/firmware: `FIRMWARE_NOTES.md` and `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`.
- OTA: `OTA_PROTECTION.md`, `OTA_REGRESSION_MEMORY.md`; voltage/Peltier transitions: `VOLTAGE_TRANSITION_MEMORY.md`.
- Build/release: `BUILD_NOTES.md`, `APP_BUILD_REPORT.md`, `.github/workflows/jexfyz-app-build-trigger.yml`.
- Design constraints: `DESIGN_NOTES.md`; history: `CHANGELOG.md`; permanent rules and prompts: `CHAT_RULES.md`, `CHAT_TRANSFER_PROMPTS.md`.
- `archive/` is immutable forensic history. Never treat an archived “CURRENT” statement as present truth.

## Last completed task — repository hygiene and LOAD + CONTINUE handoff

- Current-state docs and navigation were reconciled with the owner's Build #124 / Firmware V7.1 deployment confirmation, while preserving separate independent-evidence labels and dated history.
- Added explanatory comments to source/test/config files that lacked clear file-level contracts; exact comparison with pre-cleanup blobs proves the edits are comment-only. Protected behavior and executable logic were not changed.
- General chat-limit recovery now uses Prompt B to LOAD + CONTINUE; Build App retains Prompt D; Prompt A is reserved for explicitly requested full memory reconciliation.
- No tests/build/analysis/compile/release/BIN/Firebase/OTA/flash/device operation was run by this maintenance task. Next step: load live main and await the user's next specific request; do not start discretionary product changes.
