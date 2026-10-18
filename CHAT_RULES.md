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

- Latest verified App release is Build #80 / run `39171729285`, exact source/release commit `4e9f14b959cdbf60136158187db26d0bb65f6287`. All 21 active workflow steps passed, Dart analysis reported 23 non-fatal info-level deprecations and **96/96 Flutter tests passed**; Android production compilation/configured gate, obfuscated APK, V1/V2/V3 signing/certificate, matching source ZIP and downloaded Release checks passed. Native JUnit tasks were NO-SOURCE and no native JUnit cases ran. Detailed evidence is in `APP_BUILD_REPORT.md`.
- Release `jexfyz-latest`: APK asset `654626935`, 54,620,251 bytes, SHA-256 `b403ccd3813f1974b82703730fce2c60bab972b067bc7ac4875d51d0e55558c6`; corresponding source ZIP asset `654626933`, 2,852,944 bytes, SHA-256 `bae47230267438073c9fd2bdf9ee58bfd768a5fcdfedf7102983c05dc23bf0cc`.
- Current `main` source-only UI checkpoint after explicit static warning-icon cleanup: main source blob `522e108dd78d9b413316a6c79c8a4f0144f5e58f`; widget test blob `5098c30291cbd70422cd351f03cd9325f0870258`. Build #80 includes the rounded TamperScreen text blocks and Dashboard animation/state-gating, toggle and menu-lock changes; it does not include the new direct-Icon simplification and regression assertion. All 10 text blocks, colors, typography, frame, icon glyph/size/color and developer contact action are preserved. Flutter tests/Dart analysis are NOT RUN for the latest small source delta.
- App version: `pubspec.yaml` `1.0.0+3`; Android applicationId `com.horizontalzzz.jexfyz`, minSdk 24, targetSdk 36; preserve Gradle `versionName "Telegram @horizontalzzz"` exactly. The current App workflow is `.github/workflows/jexfyz-app-build-trigger.yml` (blob `8a8533aff7e0e0e01412bf522e1966e81aa1a39f`), owner/title/token guarded, issue opened/reopened only; no push/PR trigger.
- Active Firmware source: `firmware/JEXFYZ-V6.7.ino`, `FW_VERSION="V6.7"`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`; exactly one active versioned `.ino`. On 2026-10-18 the user reported V6.7 compiled successfully and was updated online. This is USER-REPORTED; compile log, binary/source identity, OTA logs and current installed version are not independently verified. The artifact repo `TenzoNkz/JEXFYZ-Firmware` contains only `JEXFYZ.cpp.bin` (blob `68167e65d26137eeb1ce4d6d4ba798dc282454e6`, 1,455,936 bytes); source-to-BIN provenance is UNVERIFIED.
- Live repository inventory at last check: complete recursive App tree, 67 entries (49 blobs, 18 trees), five branches and zero open PRs. Always re-fetch live HEAD/tree/hashes before further work.
- Firmware hardware baseline: ESP32-C3 Super Mini/Dev Module; GPIO0 NTC, GPIO1 TTP223 touch, GPIO3 12V selector, GPIO4 9V selector, GPIO5 Peltier MOSFET PWM, GPIO6 Fan MOSFET PWM, GPIO7 WS2812. NTC 10k + 10k divider, Beta 3950, assumed 3.3V reference, one calibrated `analogReadMilliVolts(PIN_NTC)` sample/sec. Hotside limit 40–50°C (default 45°C), re-arm at `hotLimit - 1°C` for 5 continuous seconds. Peltier PWM 20kHz/8-bit, usual OFF→ON ramp 5 sec; Fan PWM 25kHz/8-bit. Selector deadtime 200 ms, shared rail settle 1 sec. Preserve cooperative `millis()` timing; do not add executable `delay()` or timing `while()`.
- Adaptive source contract: HOTSIDE startup default; HOTSIDE_BATTERY runtime-only; phone Battery heartbeat 1 Hz, freshness TTL 5 sec; 30 sec safety stage on 12V/9V/5V; Peltier off/Fan 100% during stage; stable recovery at `hotLimit - 1°C` for 5 sec cancels; if no recovery at 5V, terminal lock requires manual restart; upward recovery requires 60 sec stable and stays within saved ceiling. The separate rapid Hotside-rise shutdown/manual re-arm request remains NOT IMPLEMENTED in V6.7.
- Adaptive Fan PWM at 12V uses the current V6.7 source contract: downshift requires ten recent one-second NTC samples, mean and every sample ≤ `hotLimit - 2°C`, no meaningful warming trend, one continuous 10-second stable interval, then 10-point reductions each 10 sec to 50%; lost margin/trend increases 10 points only when a warming trend is confirmed and the 3-second guard permits; configured hotLimit forces 100%; 5V/9V retain full fan behavior. User reports V6.7 compiled and updated online; source/BIN identity and hardware behavior remain unverified.
- OTA remains PROTECTED / FROZEN. Current Online OTA uses `cloudClient.setInsecure()`, explicitly bypassing HTTPS server-certificate identity validation; this followed the user-observed CA/NTP-gated failure but exact cause wasn't isolated from logs. Preserve raw URL allowlist, redirect blocking, status/size/image-magic checks, streaming Update lifecycle, safe outputs, recovery/restart and App reconnect/P1 handling. Read `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md` before OTA work, and `VOLTAGE_TRANSITION_MEMORY.md` before rail/Peltier sequencing edits.
- Permanent rules remain: discussions are read-only; `@Thinking Eksekusi Full!` does not authorize App Build or Firmware/device operations; `@Thinking Eksekusi Build App!` is required for App build/release; Firmware compilation/BIN/Firebase/OTA/flash/device operations need separate explicit approval. Keep all memory/docs in App repo; keep artifact repo BIN-only; do not expose credential contents; preserve approved JE grille/brand design and no standalone Battery Protection Guard in the UI.
