# JE X FYZ / JE Cooler — Permanent Chat & Execution Rules

These are durable user rules. Current implementation facts must still be checked against live source and workflows.

## 1. Command protocol

- `@Thinking Diskusi!` — inspect, read, compare and discuss only. **No repository writes**, functional source edits, builds, releases, Firebase changes, BIN changes, flash or OTA.
- `@Thinking Tanya Gemini!` — diagnosis/patch request; return precise OLD → NEW patch instructions unless the user states another format.
- `@Thinking Eksekusi!` — perform only the agreed change, its direct tests/audit and required memory sync.
- `@Thinking Eksekusi Full!` — perform the authorized change plus full scope audit, relevant tests/contracts, documentation reconciliation, memory/index/transfer refresh and commit. **It does not imply App Build, firmware compile, BIN generation, flash, OTA or release.**
- `@Thinking Build App!` — explicit App Build operation. It must follow the manual issue-trigger workflow, not a push-trigger or informal compile.
- `@Thinking Eksekusi & Build App!` — execute the approved code task and then perform the explicitly authorized App Build workflow.
- Do not execute firmware compile merely because firmware source changed. The user compiles firmware themselves.

## 2. Branch and write protocol

- Repository: `TenzoNkz/JEXFYZ-App`; work directly on `main` by default.
- Do not create branches or pull requests unless explicitly requested.
- Fetch live HEAD and current blob SHA before editing. Re-read a file immediately before replacing/deleting it if its SHA or content may have changed.
- Prefer one scoped commit per file if using the Contents API; check the final HEAD and diff/tree after multi-file tasks.
- Do not claim successful writes, commits, test passes, compilation or hardware validation without the matching evidence.

## 3. Version and firmware-source rules — mandatory

- Every **functional Firmware source change** must increment `FW_VERSION`.
- The active `.ino` filename must match that version, e.g. `FW_VERSION = "V6.4"` ↔ `firmware/JEXFYZ-V6.4.ino`.
- Exactly one active versioned `.ino` may exist in `firmware/`.
- Documentation-only changes do not require a firmware version bump.
- A source version bump is **not** a BIN build, Firebase publication, OTA update, device flash, or release.
- Required flow: edit source → bump version and rename file → update contract tests/docs/hash records → static audit → user compiles in ArduinoDroid with Arduino-ESP32 Core 3.3.7 → inspect/verify BIN → only then, with separate authorization, consider OTA/Firebase promotion and physical validation.
- No executable `delay()`; no timing `while()`; retain cooperative `millis()` timing unless the user explicitly authorizes a justified design change.
- User-reported reset cause is not proof: capture `BOOT: RESET_REASON=...` / telemetry before claiming cause.

## 4. Hard authorization boundaries

Do not perform any of these without separate, explicit user authorization:
- App Build/APK release workflow.
- Firmware compile/build, BIN generation or publication.
- Flashing, physical OTA, device operations or Firebase/production metadata updates.
- Release/prerelease creation or replacement of the artifact BIN.
- Functional code changes while the user is asking for Discussion only.

A docs-only task is not permission for a functional source edit. A firmware-only change does not automatically require App Build. App Build does not prove firmware compile or hardware behavior.

## 5. Repository separation

- `TenzoNkz/JEXFYZ-App` is the canonical editable source + **all project documentation and memory** repository. Keep all notes, architecture decisions, regression memories, prompts, handovers and changelog here.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain **only `JEXFYZ.cpp.bin`**. Do not store README files, source code, docs, or memory notes there. Do not alter the BIN while tidying docs.
- The existing BIN must never be assumed to represent current source without verified build provenance/version evidence.

## 6. App identity, build and product rules

- Android Gradle `versionName "Telegram @horizontalzzz"` is intentional identity text; preserve it exactly.
- Build one ordinary obfuscated production-signed APK; do not create a Play Store app bundle.
- App Build is manual issue-trigger only, title `JE X FYZ — BUILD APP TRIGGER`, body token `JEXFYZ_BUILD_TRIGGER_V1`. Normal push/PR must not produce an APK.
- Current workflow `.github/workflows/jexfyz-app-build-trigger.yml` is authoritative. Re-read it before any build; never rely only on old run hashes.
- Do not add firmware SHA/signature/checksum semantics to Firebase OTA metadata without explicit user approval; intended metadata is firmware version + link.
- Do not add a second BLE radio / concurrent Wi-Fi+BLE model: ESP32-C3 has one radio path. Wi-Fi OTA and BLE ownership must hand off.

## 7. OTA and safety protection

- `OTA_PROTECTION.md`, `OTA_REGRESSION_MEMORY.md`, current OTA source and their regression tests are mandatory reading before any OTA/TLS/recovery change.
- OTA has priority over normal application work; safe outputs and Wi-Fi↔BLE radio ownership must be preserved.
- Do not casually refactor/optimize Local OTA, Online OTA, OTA state machine, retry/timeout, image checks, redirect policy, failure recovery, or App reconnect lifecycle.
- A real OTA defect, prior discussion/approval and a full re-audit are required before changing protected behavior.
- The chosen current Online OTA path uses `cloudClient.setInsecure()`; this **does not authenticate server certificate identity**. The GitHub raw-BIN allowlist, redirect blocking and image/size checks remain important. Do not silently restore CA/NTP gates or alter the TLS trade-off.

## 8. Memory discipline — do not rely on chat recall

- Read `CHAT_TRANSFER.md` first at new-chat boot, then fetch live `main` HEAD/tree and read `MEMORY_INDEX.md`.
- Read every current source-of-truth file relevant to the requested area **to completion**, not only the first screen/first lines. Before reorganizing the memory system, audit all text files and cross-references.
- `PROJECT_STATE.md` is current-only; `CHANGELOG.md` is history-only; subject-specific docs own detailed facts; `CHAT_TRANSFER.md` is a refreshed snapshot/boot prompt.
- After any meaningful execution, record the durable decision/result/uncertainty in its canonical note. At chat-limit, read the old transfer snapshot completely, reconcile it with the repo, then replace it.
- Update all references/hashes after renames; do not leave contradictory legacy “current truth” blocks.
- Preserve user-approved designs, hard constraints, previous failures, rejected approaches and why they were rejected.
- Never convert a hypothesis/user-reported result into verified fact. Mark tests/builds as NOT RUN unless executed.
- If repository state and a summary/memory conflict, fetch the repository; repository wins for current code/version, and user rules remain authoritative for authorization/preferences.

## 9. Current known checkpoint (must refresh before use)

- Active source currently expected: `firmware/JEXFYZ-V6.4.ino`, `FW_VERSION = "V6.4"`.
- App package: `com.horizontalzzz.jexfyz`; pubspec version `1.0.0+3`; Gradle identity `Telegram @horizontalzzz`.
- Current V6.4 is source-only and has not been independently compiled or hardware-tested by the assistant.
- Last observed open-PR search returned zero; verify live state again.
