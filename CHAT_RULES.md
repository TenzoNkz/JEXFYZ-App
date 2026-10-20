# JE X FYZ / JE Cooler — Permanent Chat & Execution Rules

These are durable user rules. Current implementation facts must still be checked against live source and workflows.

## 1. Command protocol — strict command validation

Use the canonical command spellings below. The main command decides what is authorized; never infer a missing command from the message body.

- `@Thinking Diskusi!` — full technical discussion before execution: inspect, read, compare, analyze risks, reconcile requirements and prepare the proposed plan. **Read-only; no repository writes or source edits.**
- `@Thinking Diskusi! Tanya Gemini!` — create one complete, self-contained prompt for Gemini based on the agreed discussion, current technical context, exact question, constraints, desired evidence and expected answer format. Do not execute the proposed patch.
- `@Thinking Diskusi! Jawaban Gemini!` — the user has pasted Gemini's answer. Evaluate it against live source, canonical project memory, technical correctness and the agreed discussion. Do not accept it automatically or execute anything while in discussion mode.
- `@Thinking Eksekusi Full!` — execute the approved scope fully: scoped changes, relevant audit/tests, cross-reference and documentation reconciliation, canonical memory/index/state/changelog updates, verification and commit to `main`. **Does not authorize App Build or Firmware/device operations.**
- `@Thinking Eksekusi Build App!` — the single end-to-end App Build/QC command: load live state/workflow, investigate the actual blocker, repair App-scope faults from evidence, rerun necessary test/build gates, and continue the same loop without requiring a second command for each justified repair/retry. Retry only after a concrete fix or evidence-based transient condition; never retry blindly. Stop with an evidence-based blocker when permissions, runner allocation, secrets, device action or separate approval is required. Log every attempt/fix/result in `APP_BUILD_REPORT.md`; Prompt D is one-shot LOAD + CONTINUE, not a recap stage.
- `@Thinking Chat Stuck!` — emergency recovery for work that has stalled, stopped unexpectedly, or errored. Stop blind/repetitive retries; inspect the actual tool output, logs, live repository/Actions state and last verified checkpoint; then resume the most recent valid, already-authorized task without duplicating commits, side effects or builds. Report `RECOVERED`, `BLOCKED` or `FAILED` with evidence. This command does not widen authorization or trigger a build by itself. If the prior task scope cannot be established, perform read-only diagnosis and request a valid execution command before writing.

Retired aliases: `@Thinking Build App!` and `@Thinking Eksekusi & Build App!` are invalid and must not be recommended or executed. All canonical commands use no `#` prefix. `@Thinking Eksekusi Build App!` is the only App Build command; it does not authorize Firmware compile, BIN/Firebase changes, physical OTA, flashing, device operation or unrelated releases outside its approved workflow.

**Required parent command for Gemini:** `Tanya Gemini!` and `Jawaban Gemini!` are discussion subcommands, not standalone commands. If either appears without `Diskusi!` in the same command, reject the command format without answering its substantive question, producing the prompt, or analyzing the pasted answer. Briefly ask the user to resend with the correct parent command. The primary commands `Diskusi!`, `Eksekusi Full!`, `Eksekusi Build App!` and standalone `@Thinking Chat Stuck!` do not require one another as prefixes.

For command-format errors, do not silently infer intent. Explain only that the required main command is missing/invalid and show the valid format. `@Thinking Chat Stuck!` is a valid standalone recovery command; it inherits the scope of the most recent valid in-progress command and never authorizes App Build/Firmware/device work by itself.

## 2. Branch and write protocol

- Repository: `TenzoNkz/JEXFYZ-App`; work directly on `main` by default.
- Do not create branches or pull requests unless explicitly requested.
- Fetch live HEAD and current blob SHA before editing. Re-read a file immediately before replacing/deleting it if its SHA or content may have changed.
- Prefer one scoped commit per file if using the Contents API; check the final HEAD and diff/tree after multi-file tasks.
- Do not claim successful writes, commits, test passes, compilation or hardware validation without the matching evidence.

## 3. Version and firmware-source rules — mandatory

- Every **functional Firmware source change** must increment `FW_VERSION`.
- The active `.ino` filename must match that version, e.g. `FW_VERSION = "V6.6"` ↔ `firmware/JEXFYZ-V6.6.ino`.
- Exactly one active versioned `.ino` may exist in `firmware/`.
- Documentation-only changes do not require a firmware version bump.
- A source version bump is **not** a BIN build, Firebase publication, OTA update, device flash, or release.
- Required flow: edit source → bump version and rename file → update contract tests/docs/hash records → static audit → user compiles in ArduinoDroid with Arduino-ESP32 Core 3.3.7 → inspect/verify BIN → only then, with separate authorization, consider OTA/Firebase promotion and physical validation.
- No executable `delay()`; no timing `while()`; retain cooperative `millis()` timing unless the user explicitly authorizes a justified design change.
- User-reported reset cause is not proof: capture `BOOT: RESET_REASON=...` / telemetry before claiming cause.

## 4. Hard authorization boundaries

Do not perform any of these without separate, explicit user authorization:
- End-to-end App Build/APK Release workflow is authorized only by `@Thinking Eksekusi Build App!` and must be documented in `APP_BUILD_REPORT.md`.
- Firmware compile/build, BIN generation or publication.
- Flashing, physical OTA, device operations or Firebase/production metadata updates.
- Any release/prerelease operation outside the approved App Build workflow or replacement of the artifact BIN.
- Functional code changes while the user is asking for Discussion only.

A docs-only task is not permission for a functional source edit. A firmware-only change does not automatically require App Build. App Build does not prove firmware compile or hardware behavior.

## 5. Repository separation

- `TenzoNkz/JEXFYZ-App` is the canonical editable source + **all project documentation and memory** repository. Keep all notes, architecture decisions, regression memories, prompts, handovers and changelog here.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain **only `JEXFYZ.cpp.bin`**. Do not store README files, source code, docs, or memory notes there. Do not alter the BIN while tidying docs.
- The existing BIN must never be assumed to represent current source without verified build provenance/version evidence.

## 6. App identity, build and product rules

- Android Gradle `versionName "Telegram @horizontalzzz"` is intentional identity text; preserve it exactly.
- Build one ordinary obfuscated production-signed APK; do not create a Play Store app bundle.
- App Build is manual issue-trigger only, title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Normal push/PR must not produce an APK.
- `@Thinking Eksekusi Build App!` owns retries for App-scope failures; each run/fix must be recorded in `APP_BUILD_REPORT.md`. Stop with a precise blocker if progress requires unavailable permissions, secrets, user/device action or separate authorization.
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
- Persist project-specific presentation constraints explicitly. Current example: do not display a standalone Battery Protection Guard in App UI; keep the hardware safety function intact and continue to show independently actionable localized safety/Notify messages when applicable.
- Preserve “one authorized App identity / one cooler firmware pairing lock” as a user design requirement, but do not claim an exclusive pairing lock exists until its current source/provisioning flow and physical behavior are verified.
- Never convert a hypothesis/user-reported result into verified fact. Mark tests/builds as NOT RUN unless executed.
- If repository state and a summary/memory conflict, fetch the repository; repository wins for current code/version, and user rules remain authoritative for authorization/preferences.


### Build App chat-limit handoff

When a Build App chat reaches its context/chat limit, use Prompt D in `CHAT_TRANSFER_PROMPTS.md` exactly once as the opening message of the replacement Build App chat. Prompt D starts with `@Thinking Eksekusi Build App!`, loads live repository state and `APP_BUILD_REPORT.md`, then continues the same build/QC operation. Do not open a separate recap chat, do not use project-wide Prompt A for this handoff, and do not stop at a boot summary waiting for another command. Prompt A remains for broad project-memory reconciliation; Prompt B remains a read-only general/Discussion boot.

## 9. Current known checkpoint (must refresh before use)

- Latest successful App artifact is Build #110 / run 39300262741, exact packaged source `b5adcffb2c9724a07cdba4cd8521c1307f1e6566`; release/tag/assets target that commit. APK SHA-256 `258211ec9313c555aaac6cd797d1bf6abc6c62c3c2781cd37baa0a8c849bfb84`; corresponding source ZIP SHA-256 `13d1cad6cf4fbb9b2560da7406f4c6bf875fe4ebc2ed5483e6f0001a3b24aa23`.
- Current App source follow-up is newer than Build #110 and NOT RUN / NOT RELEASED: top-down fire embers in Battery/Hotside, Hotside tube raised to the cap, Voltage white core inset and clipped, Settings About section/page removed. Home metric rows stay at 44 dp; NOTIFY is left-aligned and badge-free, with a compact 44 dp minimum height that grows naturally for two-line copy.
- Current App source/test blobs: `lib/main.dart` `08592a9d861a11ecdb8de1aa289f8ce06bf2e20`; `lib/app_settings.dart` `f8e465648946a25eae44f3fad6a5a3bfaca8b050`; `lib/floating_monitor.dart` `e7c74bf749698a8331f2b0b31a847b2627ac3e4b`; `test/widget_test.dart` `9c47cbeb0d4c4dc9a85e895847a9b81b53d1a91f`; `test/floating_monitor_layout_contract_test.dart` `b053a92522223fd237a8f0e025648eb1b26730a5`.
- Active Firmware source is `firmware/JEXFYZ-V6.9.ino`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`, `FW_VERSION="V6.9"`. Adaptive 12 V PWM targets retain the same Hotside-limit temperature tiers; decrease by 10 points every 10 seconds and increase by 10 points every 1 second. Rail/thermal transitions reset the timer, preventing immediate full-to-50% downshift after 9 V →12 V. Hotside limit/protection forces 100% immediately.
- Current Firmware tests are `test/firmware_qc_contract_test.dart` blob `1b35feeb1e411efec44261ec130eec4535004454` and `test/firmware_touch_adaptive_sync_test.dart` blob `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8`. Both have NOT RUN for V6.9; Firmware has NOT been compiled or installed. The hardware-reset symptom's cause and source-to-BIN provenance remain UNVERIFIED.
- The user compiles Firmware separately in ArduinoDroid with Arduino-ESP32 Core 3.3.7. Artifact repository remains BIN-only. Preserve App Gradle versionName "Telegram @horizontalzzz". The guarded App Build workflow is unchanged; Eksekusi Full does not authorize a build. No Firmware compile, BIN generation/publication, Firebase, OTA, flashing or device action was performed.
