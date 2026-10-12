# JE X FYZ — CHAT TRANSFER / BOOT PROTOCOL

Snapshot date: 2026-10-12. Repository snapshot reconciled against `main` before this replacement. **This file is a transfer protocol, not source of truth.** Current source and active workflow win when records conflict.

## STATE LABELS

Use these labels literally and do not upgrade a claim without evidence:

- [USER REQUIREMENT] Explicit request/operational rule from the user.
- [CONFIRMED] Directly confirmed by the user.
- [VERIFIED] Rechecked against current repository/source/workflow or authoritative evidence.
- [IMPLEMENTED] Present in source; does not mean built or runtime-tested.
- [COMMITTED] Present in Git history.
- [BUILT] Build/compile evidence exists for the named version/source only.
- [TESTED] A named test was actually performed; include evidence.
- [UNVERIFIED] Required validation evidence is absent.
- [HYPOTHESIS] Plausible explanation, not established root cause.
- [OBSOLETE] Must not be used as current truth.
- [REJECTED] Explicitly rejected decision/approach.
- [BLOCKED] Cannot be done safely or with available capability.
- [OPEN QUESTION] Relevant unanswered question.

## CURRENT TRUTH AT TRANSFER

- [VERIFIED] Repository: `TenzoNkz/JEXFYZ-App`; authoritative branch: `main`.
- [VERIFIED] Main HEAD immediately before this transfer-file replacement: `537af513153654e5b8d207b253352386dc3b73c1`.
- [CURRENT TRUTH] Active Firmware: `firmware/JEXFYZ-V6.1.ino`; `FW_VERSION = "V6.1"`; source blob `c76e9a4f36d47d2dc8f9d9145e8064c14a7fda5f`.
- [COMMITTED] V6.1 safety fix commit: `5fa7a4033a1cf2c5989c5fb9511be75cf34b7dbe`; V6.1 active-source promotion/removal of the V6.0 .ino path: `167f44df6c379d6d2a7a03b47f6620c609a4136c`. Both are on `main`; no PR was used.
- [CURRENT TRUTH] App: `1.0.0+3`; package `com.horizontalzzz.jexfyz`; source remains separate from the Firmware source change.
- [CURRENT TRUTH] Phase: DEVELOPMENT + QC / PRE-RELEASE; **NOT RELEASED**.
- [UNVERIFIED] V6.1 has not been compiled, turned into a BIN, flashed to the ESP32-C3, or validated on hardware in the recorded V6.1 promotion. Do not infer that the user's currently installed firmware is V6.1.
- [USER REQUIREMENT] Documentation transfer does not authorize source changes, compile/build, BIN publication, flash/OTA, App Build, or release.

## REQUIRED CONTINUATION SUMMARY

### CURRENT TRUTH
Main contains V6.1 Adaptive rail-handoff source changes. The 12V physical issue from the preceding discussion was confirmed by the user to be a loose cable and was fixed physically. Separately, the user reported that the previously installed firmware restarts when Adaptive is enabled after selecting 12V and turning Fan + Peltier ON; after reboot Adaptive appears OFF and neither Adaptive ON orange nor OFF white feedback was observed. The V6.1 fix is not yet proven on hardware.

### VERIFIED
The current workflow directory contains only `.github/workflows/jexfyz-app-build-trigger.yml`. The previous firmware push-triggered compile workflow `.github/workflows/firmware-build.yml` is deleted in commit `32bc3c3fcb0c074e39d7ea49428f98d7845e4073`. The App Build workflow is issue-triggered and builds the Android App only. Current GitHub combined status for the recorded V6.1 source commit and pre-transfer main documentation HEAD returned no status entries; this is not evidence of a successful build.

### UNVERIFIED
- [UNVERIFIED] Whether the V6.1 Adaptive transition fix eliminates the hardware restart.
- [UNVERIFIED] Whether orange Adaptive ON and white Adaptive OFF indicators render correctly on the physical LED hardware.
- [UNVERIFIED] Reset cause for the user's reported restart; no App reset-reason notice was observed and no Serial log was captured.
- [UNVERIFIED] V6.1 compile, BIN, flash, physical safety regression, Local OTA, Online OTA/BLE recovery, and App ↔ V6.1 integration.

### HISTORY / OBSOLETE
V6.0 is historical QC context only. Its former workflow/run/BIN evidence does not prove V6.1. Older V5.9 and V5.8 active-version statements in historical notes must not override `main` source V6.1. The former automatic Firmware compile workflow is no longer present on `main`.

### CHAT-ONLY
- [USER-REPORTED / UNVERIFIED] Reproduction sequence on the previously installed firmware: Manual 12V → Fan ON + Peltier ON → Adaptive ON → hardware restart; after reboot Adaptive is OFF. No RESET_REASON notification appeared, and the orange/white Adaptive indicator was not visible.
- [USER-CONFIRMED] The earlier physical 12V-output complaint was caused by a loose cable and was resolved by securing the cable; do not carry it forward as a confirmed Firmware bug.
- [USER REQUIREMENT] Do not compile Firmware just because source execution is called “Full.” Compile/build must be explicitly requested.
- [USER REQUIREMENT] Prefer direct commits to `main`; do not create a PR or a new working branch unless the user explicitly asks.
- [BLOCKED] An unintended branch `fix/adaptive-power-sequencing` exists from the preceding conversation and has no matching PR. Its V6.1 blob is `3f8c61ef2add303b495b1cc19e6ee6be04cea028`, different from the authoritative `main` V6.1 blob `c76e9a4f36d47d2dc8f9d9145e8064c14a7fda5f`. The available GitHub connector does not expose a branch-delete operation; do not continue development from this divergent branch. Main remains the source of truth.

---

## 0. READ FIRST / MANDATORY BOOT

1. Read this file, then re-fetch `main` HEAD and reconcile active source/workflows before doing anything.
2. Read `PROJECT_STATE.md`, `HANDOVER.md`, `CHAT_RULES.md`, `FIRMWARE_NOTES.md`, `firmware/FIRMWARE_ANALYSIS.md`, `APP_NOTES.md`, `OTA_PROTECTION.md`, `BUILD_NOTES.md`, `CHANGELOG.md` as relevant. Some historical sections may still mention old versions; never override current source with history.
3. Do not ask the user to repeat facts recorded below or in authoritative docs.
4. Do not modify functional source during a transfer/boot.
5. Do not build, compile, flash, publish, perform OTA or build the App unless the user explicitly asks for that operation.

## 1. PROJECT IDENTITY

- [CURRENT TRUTH] Project: JE X FYZ; App product name: JE Cooler; public hardware/app branding: JE X FYZ.
- [CURRENT TRUTH] Hardware target: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [CURRENT TRUTH] Firmware source authority: `firmware/` in `TenzoNkz/JEXFYZ-App`.
- [CURRENT TRUTH] Separate production firmware repository: `TenzoNkz/JEXFYZ-Firmware`.
- [CURRENT TRUTH] App package: `com.horizontalzzz.jexfyz`; version `1.0.0+3`.
- [CURRENT TRUTH] Release state: DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED.

## 2. AUTHORITY HIERARCHY

1. Current `main` source/configuration and active workflow inventory.
2. `PROJECT_STATE.md`.
3. `firmware/FIRMWARE_ANALYSIS.md`, `FIRMWARE_NOTES.md`, `APP_NOTES.md`, `CHAT_RULES.md`, `OTA_PROTECTION.md`, `BUILD_NOTES.md`.
4. `HANDOVER.md`, `CHANGELOG.md`.
5. `CHAT_TRANSFER.md`.
6. Current chat; then older chat history.

- [POLICY] When documents conflict, record the conflict; current source/workflows win.
- [POLICY] A committed source fix is not evidence of successful compile, BIN generation, flashing, OTA, or hardware behavior.

## 3. USER COMMAND PROTOCOL

- [USER REQUIREMENT] `@Thinking Diskusi!` — discussion/review only; no source modification, build, compile, flash, release, or publication.
- [USER REQUIREMENT] `@Thinking Tanya Gemini!` — diagnosis/patch request; provide exact OLD → NEW proposal; do not silently execute.
- [USER REQUIREMENT] `@Thinking Eksekusi!` — implement the approved scope, audit affected behavior, sync relevant documentation, and commit.
- [USER REQUIREMENT] `@Thinking Eksekusi Full!` — broad implementation and affected audit/documentation/commit; **does not automatically authorize compile, build, BIN, flash/OTA, App Build, or release**.
- [USER REQUIREMENT] Compile/build requires an explicit user instruction naming that operation; do not infer it from “Eksekusi,” “Eksekusi Full,” or documentation work.
- [USER REQUIREMENT] `@Thinking Build App!` — explicit App Build operation.
- [USER REQUIREMENT] `@Thinking Eksekusi & Build App!` — implement, audit, sync docs, commit, then execute the explicitly named App Build.
- [USER REQUIREMENT] Commit directly to `main` unless the user explicitly requests a branch/PR. Do not create branches merely as a default.
- [POLICY] Report accurately which actions were and were not run.

## 4. CURRENT PROJECT MODE

- [CURRENT TRUTH] V6.1 Firmware source-only QC; NOT RELEASED.
- [IMPLEMENTED] Main has a targeted Adaptive rail-handoff change intended to prevent Peltier PWM remaining energized while selector rails are in break-before-make handoff; Adaptive OFF uses a corresponding safe 5V handoff.
- [UNVERIFIED] The reported restart and missing indicators have not been validated away on physical hardware using V6.1.
- [POLICY] Avoid unrelated refactors. Only change Firmware/App behavior for a reproducible defect with a clear diagnosis and approved scope.
- [USER REQUIREMENT] No compile/build without explicit instruction, regardless of execution mode.

## 5. HARDWARE CONTRACT

| Function | GPIO |
| --- | ---: |
| Hotside NTC | GPIO0 |
| TTP223 touch input | GPIO1 |
| 12V selector | GPIO3 |
| 9V selector | GPIO4 |
| Peltier PWM output | GPIO5 |
| Fan PWM output | GPIO6 |
| WS2812 LED data | GPIO7 |

- [FROZEN] ESP32-C3 single-radio rule: Wi-Fi and BLE must not own the radio concurrently.
- [FROZEN] Fan PWM: 25 kHz, 8-bit; user-controlled Manual range 50–100%; transitions force Fan 100%.
- [FROZEN] Peltier PWM: 20 kHz; every genuine OFF→ON operation uses a cooperative 5-second soft-start.
- [FROZEN] Voltage selector deadtime: 200 ms break-before-make; App/manual voltage guard: 1 second after a completed transition.
- [FROZEN] NTC: 10K NTC + 10K fixed resistor, Beta 3950, existing 3.3 V divider reference design; sample cadence one calibrated ADC reading per second.
- [FROZEN] Hotside limit: 40–50 °C, default 45 °C; Peltier re-arm hysteresis is 2 °C, i.e. Hotside must reach `hotLimit - 2 °C`.
- [FROZEN] NTC fault: Fan 100%, Peltier OFF, Adaptive OFF, safe 5V.
- [IMPLEMENTED] Adaptive thermal recovery uses a 30-second dwell on 12V/9V; 5V is terminal recovery-lock behavior if Hotside does not re-arm. Preserve existing red lock and two-green re-arm indicators.
- [SAFETY] Never apply 12V directly to an ESP32-C3 GPIO. GPIO selectors are logic outputs; the power selector/driver stage is separate.

## 6. FIRMWARE CONTRACT

- [VERIFIED] Active path: `firmware/JEXFYZ-V6.1.ino`; `FW_VERSION = "V6.1"`; blob `c76e9a4f36d47d2dc8f9d9145e8064c14a7fda5f`.
- [COMMITTED] V6.1 source/fix commit `5fa7a4033a1cf2c5989c5fb9511be75cf34b7dbe`; active-source promotion commit `167f44df6c379d6d2a7a03b47f6620c609a4136c`.
- [IMPLEMENTED] Adaptive ON: validate Fan + Peltier state, NTC and safety latch; before a selector handoff, turn Peltier PWM OFF, force Fan to 100%, and request safe 5V with the existing 200 ms selector deadtime. On safe-5V completion, activation revalidates safety and restores cooling through `applyCoolingOutputs()`, which owns the existing 5-second OFF→ON Peltier soft-start.
- [IMPLEMENTED] Adaptive OFF: turn Peltier PWM OFF before requesting 5V when a rail handoff is required; preserve whether Peltier was previously running; after 5V settles, restore only through existing NTC/Hotside/Fan/safety gates and existing soft-start.
- [IMPLEMENTED] Adaptive ON feedback: 3 orange blinks after successful activation; OFF feedback: 3 white blinks after an actual ON→OFF transition completes the safe-5V handoff, or immediately if already at 5V. An already-OFF state after reboot does not constitute a new OFF transition, so no white indicator is expected merely by reissuing OFF.
- [IMPLEMENTED] Firmware prints `BOOT: RESET_REASON=<reason>` to Serial during boot. This is a Serial diagnostic and is not proof the App will always show a notification after an abrupt reset.
- [FROZEN] Both Adaptive profiles retain 5 seconds of cooperative wait after each upward voltage step; downward changes are immediate unless safety rules dictate otherwise.
- [LIMITED SOURCE CHECK, NOT BUILD] The current source contains one `analogReadMilliVolts(PIN_NTC)` call site and no `delay(` call site in the source inventory. This limited check does not substitute for compiler validation.
- [UNVERIFIED] V6.1 compile/BIN/flash, reset diagnosis, physical indicators, power stability, thermal behavior, and OTA regression.

## 7. TOUCH CONTRACT

- [FROZEN] TTP223 Active-High input.
- [FROZEN] Single tap voltage cycle: 5V → 9V → 12V → 9V → 5V → repeat.
- [FROZEN] Double tap toggles RGB; 5-second long press toggles cooling or exits Adaptive per current firmware logic.
- [FROZEN] Startup grace 1000 ms; stable state qualification 30 ms; valid tap HIGH 60–500 ms; double-tap window 800 ms; long press 5000 ms.
- [FROZEN] Touch feedback/control must remain cooperative/non-blocking; do not introduce executable `delay()` or timing busy-wait loops.
- [CONFIRMED] The reported 12V physical issue was a loose cable and is fixed physically; do not reinterpret that as a confirmed touch-sequence Firmware bug.

## 8. APP CONTRACT

- [CURRENT TRUTH] App version `1.0.0+3`; package `com.horizontalzzz.jexfyz`.
- [VERIFIED] Current App main blob `8189825511499cec01f357f1735dcee22426627b`.
- [IMPLEMENTED] App uses Firmware-reported telemetry as its control/state source; telemetry `VOLTAGE:12V` is a logical Firmware state, not a physical voltage measurement.
- [IMPLEMENTED] BLE state-changing commands use serialized high-level confirmation; Peltier safety ACK reasons are retained for user-facing feedback.
- [IMPLEMENTED] PHONE:BT battery temperature heartbeat is coalesced; App uses dedicated notification/floating-monitor MethodChannels and secure Wi-Fi credential storage.
- [FROZEN] Android `versionName "Telegram @horizontalzzz"` is intentional.
- [UNVERIFIED] Flutter analyze/tests and App ↔ V6.1 physical integration are not evidence-backed in the current V6.1 source promotion; no App Build was executed for V6.1.

## 9. BLE / P1 CONTRACT

- [FROZEN] BLE name: `JE X FYZ`.
- [FROZEN] Service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`.
- [FROZEN] RX UUID: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`.
- [FROZEN] TX UUID: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`.
- [FROZEN] Handshake: `SYNC` → `SYNC_READY`; `PROTOCOL=P1` must validate before App dashboard/session readiness.
- [FROZEN] Intended single GATT session; Wi-Fi/BLE ownership remains exclusive.
- [POLICY] Do not rewrite BLE protocol/UUIDs or bypass P1 for unrelated work.

## 10. OTA PROTECTED CONTRACT

- [PROTECTED] Local OTA, Online OTA, OTA lifecycle/state machine, OTA priority, radio handoff, recovery, safe outputs, timeout/retry, image validation, URL/path handling, and App OTA version selection.
- [FROZEN] Wi-Fi OTA radio ownership only after BLE/GATT has been torn down and Wi-Fi/BLE handoff settles.
- [FROZEN] NTC/safe-output behavior remains effective during OTA safety ownership.
- [FROZEN] Anti-downgrade is OFF: any valid firmware version different from the installed version can be selected; same version requires no update.
- [FROZEN] No cryptographic OTA signature/CI-enforced OTA seal is active.
- [POLICY] OTA change requires a demonstrated OTA defect, clear root cause, explicit discussion/approval, and a full OTA re-audit.
- [UNVERIFIED] V6.1 Local OTA, Online OTA + BLE recovery, and physical release image behavior.

## 11. FIREBASE / OTA METADATA

- [CURRENT TRUTH] Metadata endpoint: `https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`.
- [CURRENT TRUTH] Production binary repository: `TenzoNkz/JEXFYZ-Firmware`; published filename `JEXFYZ.cpp.bin`.
- [CURRENT TRUTH] Approved production raw URL: `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin`.
- [FROZEN] Metadata uses version + URL; SHA is not required. Anti-downgrade stays OFF.
- [VERIFIED] V6.1 source promotion did not modify the production firmware repository or Firebase metadata.
- [UNVERIFIED] Current production BIN is not V6.1 by this source promotion; no V6.1 BIN was created or published.

## 12. ANDROID / APP BUILD CONTRACT

- [VERIFIED] Sole active workflow at `.github/workflows/jexfyz-app-build-trigger.yml`, blob `6b1d6cd3c65c4913c288652ac7597e126b37d0cf`.
- [VERIFIED] Workflow trigger: GitHub Issues opened/reopened only; repository owner + exact issue title `JE X FYZ — BUILD APP TRIGGER` + token `JEXFYZ_BUILD_TRIGGER_V1`.
- [FROZEN] Normal push/PR does not build/release the App. Workflow uses Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- [FROZEN] One obfuscated production-signed `JEXFYZ-release.apk` is delivered through GitHub Release `jexfyz-latest`; Actions artifact upload is not used.
- [VERIFIED] Documented Android SDK contract: minSdk 24, targetSdk 36, compileSdk 37.
- [USER REQUIREMENT] App Build must be explicit. Firmware source execution and chat transfer do not imply App Build.
- [UNVERIFIED] App Build against current source was not executed by the V6.1 source promotion or this transfer.

## 13. SOURCE / COMMIT MAP

### Main source/config blobs
- [VERIFIED] Active Firmware `firmware/JEXFYZ-V6.1.ino`: `c76e9a4f36d47d2dc8f9d9145e8064c14a7fda5f`.
- [VERIFIED] App main `lib/main.dart`: `8189825511499cec01f357f1735dcee22426627b`.
- [VERIFIED] App settings `lib/app_settings.dart`: `0c29bed46b746c1171f61ee7b095c724474a5e6b`.
- [VERIFIED] Floating monitor `lib/floating_monitor.dart`: `4cd980ea1cc53c663e60267b2c865f3ebb09d91d`.
- [VERIFIED] Test `test/widget_test.dart`: `a3ffbb349e30ece3c84f38f2863c2f8717c1e4a7`; `test/v5_9_contract_test.dart`: `92214dd90178c705844d3979d3f8f7bd17bcc4b8`.
- [VERIFIED] MainActivity `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`: `eeb135ef34b1d415196b86e6ffe1ac39d7bda5e2`.
- [VERIFIED] `pubspec.yaml`: `8f558273e21692af9958f914527fdc62d623d63a`.
- [VERIFIED] Android App gradle `android/app/build.gradle`: `d8681cb73156b61da7749633abd63e2fb8c287ba`.
- [VERIFIED] App Build workflow `.github/workflows/jexfyz-app-build-trigger.yml`: `6b1d6cd3c65c4913c288652ac7597e126b37d0cf`.
- [VERIFIED] Firmware analysis notes `firmware/FIRMWARE_ANALYSIS.md`: `3509ff87b50bcd100d9a71f45b1ad452591d3a99`.

### Functional and workflow commits
- [COMMITTED] V6.1 Adaptive safety fix: `5fa7a4033a1cf2c5989c5fb9511be75cf34b7dbe`.
- [COMMITTED] Activate V6.1 source path; remove V6.0 path: `167f44df6c379d6d2a7a03b47f6620c609a4136c`.
- [COMMITTED] Delete push-triggered Firmware compile workflow: `32bc3c3fcb0c074e39d7ea49428f98d7845e4073`.
- [VERIFIED] Before transfer replacement, main HEAD was `537af513153654e5b8d207b253352386dc3b73c1`; this commit followed documentation syncs for PROJECT_STATE, HANDOVER, CHAT_RULES, BUILD_NOTES, OTA_PROTECTION, and APP_NOTES.
- [HISTORICAL] V6.0 QC build evidence: workflow run #83 passed against V6.0 source; historical BIN SHA-256 `b50af3bf9b43f1f78425e4dbd273534f218acd8c58a539eb2426bf3d9d5b10a8`; this does not prove V6.1 build/runtime behavior.
- [UNVERIFIED] V6.1 current Firmware compile, BIN, flash, and physical runtime evidence do not exist in the recorded promotion.

## 14. QC STATUS

### VERIFIED
- [VERIFIED] Main active .ino filename and `FW_VERSION` agree on V6.1.
- [VERIFIED] Basic source inventory: one `analogReadMilliVolts(PIN_NTC)` occurrence; no `delay(` occurrence. These are limited lexical checks only.
- [VERIFIED] The old `.github/workflows/firmware-build.yml` file is absent from `main`; current `.github/workflows` listing contains only `jexfyz-app-build-trigger.yml`.
- [VERIFIED] A search for a PR from the accidental branch found none.
- [USER-CONFIRMED] Loose cable was the cause of the earlier 12V physical-output problem and was secured.

### UNVERIFIED
- [UNVERIFIED] V6.1 Arduino/ArduinoDroid compilation and memory/build size.
- [UNVERIFIED] V6.1 BIN image magic, OTA size gate, checksum/provenance.
- [UNVERIFIED] V6.1 flashing/update on the actual ESP32-C3 and version confirmation.
- [UNVERIFIED] Adaptive ON from 12V with Fan + Peltier running; absence of restart; orange 3-blink cue.
- [UNVERIFIED] Adaptive OFF rail handoff, Peltier restore, white 3-blink cue.
- [UNVERIFIED] Serial reset log for a future restart; no reset reason was captured for the reported event.
- [UNVERIFIED] Hotside/NTC fault safety regression, 5-second Adaptive upward dwell, thermal re-arm, Local OTA Golden Path, Online OTA + BLE recovery, App ↔ V6.1 integration.
- [UNVERIFIED] Current App Flutter/Dart analysis/tests and App Build/release.

## 15. RISKS

- [RISK] Source-only fix must not be represented as a validated hardware fix.
- [RISK] User may still have V6.0 or another image installed; verify actual device version after any future explicitly approved flash.
- [RISK] A reset without an App notification is not enough to classify the root cause; capture `BOOT: RESET_REASON=` from Serial at 115200 baud if the issue recurs.
- [RISK] A divergent accidental branch exists and must not be used as the source of truth.
- [RISK] No Firmware compile workflow currently exists on main; do not recreate it or add automatic push-triggered compilation without explicit user approval.

## 16. OBSOLETE / DO NOT REUSE

- [OBSOLETE] Old `firmware/JEXFYZ-V6.0.ino` as active source; it was removed when V6.1 was promoted.
- [OBSOLETE] V5.9/V5.8 labels as current Firmware version; those remain historical notes.
- [OBSOLETE] The deleted `.github/workflows/firmware-build.yml` push-triggered compile workflow.
- [OBSOLETE] Treating App `VOLTAGE:12V` telemetry as proof of measured physical 12V; Firmware reports logical state and has no dedicated output-rail voltage feedback in this design.
- [OBSOLETE] Treating the earlier 12V issue as a confirmed software defect; the user confirmed a loose cable.
- [REJECTED] Compile/build, App Build, flash, OTA, or release as an automatic side effect of a source-execution command or transfer.
- [REJECTED] Using or blindly merging `fix/adaptive-power-sequencing`; main V6.1 blob is the authoritative source and differs from that branch's V6.1 blob.

## 17. GEMINI EVIDENCE

- [UNVERIFIED] No authoritative Gemini response/result relevant to this Adaptive restart was supplied in this chat or recorded as evidence in the current project state.
- [POLICY] Do not invent Gemini output, compatibility claims, or test results. If a Gemini patch is later requested, treat it as a proposal until reconciled with current source.

## 18. FAILED APPROACHES / INCIDENT HISTORY

- [CONFIRMED] The user objected when Firmware compilation appeared to happen without an explicit compile request.
- [VERIFIED] A push-triggered Firmware compile workflow existed for V6.0 and was removed by commit `32bc3c3fcb0c074e39d7ea49428f98d7845e4073`; current workflow listing has only the issue-triggered App Build workflow.
- [CHAT HISTORY] An unintended branch `fix/adaptive-power-sequencing` was created despite the user's preference for direct `main` commits. No PR exists; the branch contains a different V6.1 blob. Do not continue on that branch.
- [HYPOTHESIS, NOT ROOT CAUSE] Restart during 12V → safe-5V Adaptive entry could involve voltage handoff/load behavior, but the V6.0 hardware cause was not proven as brownout or panic. V6.1 contains a targeted load-off handoff intended to address the risk; hardware validation remains pending.
- [FAILED EVIDENCE] No App reset-reason notification was seen by the user; no Serial log was captured. Do not infer the reset cause.

## 19. EXACT QC SEQUENCE

**Gate 0 — explicit authorization**
1. Do not compile/build until the user explicitly requests Firmware compile/build. Do not silently run it because the user says “Eksekusi Full”.
2. Confirm from source/documentation which Firmware version is actually installed on hardware; repository source version alone does not prove device version.

**Only after the user explicitly authorizes Firmware compile/build**
3. Compile `firmware/JEXFYZ-V6.1.ino` with the documented official Arduino-ESP32 Core 3.3.7 target `esp32:esp32:esp32c3:PartitionScheme=min_spiffs` and pinned NeoPixel library version used by the historical workflow (Adafruit NeoPixel 1.12.3); report exact command/tool/run.
4. Verify BIN exists, ESP image first byte is `E9`, file is within the 1792 KiB OTA cap, and record SHA-256; do not publish to production repositories/Firebase as part of compile QC.
5. Flash/update hardware only when separately authorized; verify it reports V6.1.

**Physical regression after a verified V6.1 flash**
6. Start in Manual 12V, turn Fan ON and Peltier ON, wait until the manual voltage transition guard has elapsed, then enable Adaptive once.
7. Verify safe transition behavior: Peltier PWM drops before selectors are deasserted; both selector outputs remain OFF for 200 ms; 5V is selected; safety validates; Peltier re-enters through existing 5-second soft-start; orange 3-blink cue appears after successful Adaptive ON.
8. Disable Adaptive from 9V/12V; verify Peltier is OFF during rail handoff, safe 5V completes, previous Peltier operation restores only if safety allows, and white 3-blink cue runs for actual ON→OFF. If Adaptive is already OFF after reboot, do not expect an OFF transition cue merely from reissuing OFF.
9. If reset recurs, capture Serial at 115200 baud and preserve the exact `BOOT: RESET_REASON=` line before changing code.

**Safety and regression gates**
10. Test NTC fault, Fan/Peltier constraints, Hotside limit/re-arm at `hotLimit - 2 °C`, terminal 5V lock, 30-second thermal dwell at 12V/9V, and 5-second wait before upward Adaptive voltage steps.
11. Run Local OTA Golden Path, then Online OTA + BLE recovery; keep Wi-Fi/BLE single-radio ownership and all protected OTA logic unchanged.
12. Validate App ↔ V6.1 P1/SYNC/ACK/telemetry/NOTIFY and PHONE:BT contracts.
13. Run App Build only if explicitly requested; Release Gate only after all required evidence is collected.

## 20. NEW CHAT FIRST RESPONSE

Report only, in Indonesian:
- CURRENT PROJECT TRUTH
- REPOSITORY RECONCILIATION
- VERIFIED
- UNVERIFIED
- KNOWN RISKS
- NEXT EXACT QC GATE

State clearly that V6.1 is committed source-only, not known to be compiled/flashed. Do not start a build or ask questions already answered here. Then wait for the user's next command.

## 21. TRANSFER / MEMORY RULES

- [USER REQUIREMENT] At each context-limit event, replace this file; do not append another snapshot to the old transfer body.
- [POLICY] Preserve meaningful current facts in PROJECT_STATE/HANDOVER; keep historical records in CHANGELOG/history.
- [POLICY] Record source paths, blob SHAs, commit SHAs, workflow triggers, and actual build/test evidence.
- [POLICY] Keep VERIFIED separate from USER-REPORTED, HYPOTHESIS, UNVERIFIED, and OBSOLETE.
- [POLICY] Documentation sync never authorizes functional source change, build, release, or device actions.

## 22. CHAT-ONLY STATE

- [CHAT-ONLY] User confirmed the earlier 12V hardware-output failure was a loose cable; this is resolved physically.
- [CHAT-ONLY] User reported the installed device restarted when selecting 12V, turning Fan and Peltier ON, then immediately enabling Adaptive. After restart Adaptive showed OFF.
- [CHAT-ONLY] User did not see an App RESET_REASON notice and did not see the expected orange Adaptive ON or white Adaptive OFF LED indicator.
- [CHAT-ONLY] The V6.1 repository source now contains the Adaptive Peltier-off/5V-handoff changes, but the user has not confirmed compiling/flashing or physically testing V6.1.
- [CHAT-ONLY] User requires direct-to-main workflow by default and explicitly objected to unrequested Firmware compilation.

## 23. TRANSFER COMPLETION

- [VERIFIED] Before replacing this file, read the complete 345-line `CHAT_TRANSFER.md` at blob `523fa6d2a8fbaa25ffcac50d0c00c5ea11d103a9`.
- [VERIFIED] Reconciled active `main` source, App source, workflow directory, PROJECT_STATE, HANDOVER, CHAT_RULES, FIRMWARE_NOTES, APP_NOTES, BUILD_NOTES, OTA_PROTECTION, CHANGELOG, README, and firmware analysis notes.
- [VERIFIED] Main HEAD before transfer replacement: `537af513153654e5b8d207b253352386dc3b73c1`.
- [VERIFIED] This operation updates documentation only; no functional Firmware/App source, compile, BIN, flash, OTA, App Build, release, or Firebase metadata change is authorized or performed.
- [NEXT] After the transfer commit, re-read this file and verify the new HEAD, saved blob, active V6.1 source blob, and workflow inventory.