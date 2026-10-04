## 2026-10-04 — V4.2 ONLINE OTA RETRY HARDENING

- Firmware V4.1 → V4.2.
- Removed repeated Online OTA `WiFi.disconnect(); WiFi.begin(...)` retry cycling.
- Online OTA now waits on one cumulative 45-second connection window and reports attempt milestones without re-beginning Wi-Fi.
- Local OTA unchanged/protected.
- Compile/BIN/physical validation remains pending.

## 2026-10-04 — EXECUTION FULL / V4.1 SIMPLE ONLINE OTA

- [IMPLEMENTED] Applied the accepted Gemini redesign to Online OTA in the exact V4.0 source.
- [VERSION] Firmware advanced **V4.0 → V4.1** as required by the absolute versioning rule.
- [SOURCE] Active firmware is now `firmware/JEXFYZ-V4.1.ino`.
- [SOURCE BLOB] `352f7c408f2bc5a4a691af35cfb477338036a102`.
- [ONLINE OTA] Wi-Fi retry simplified: `WiFi.setAutoReconnect(true)`; `WL_CONNECT_FAILED/WL_NO_SSID_AVAIL` fast-fail handling removed; retry after the 15 s connection window now uses `WiFi.disconnect(); WiFi.begin(...)` without repeated `WIFI_OFF` radio teardown.
- [RETAINED] Plain `WiFiClientSecure + setInsecure()`, GitHub raw BIN allowlist, BLUE Wi-Fi success, YELLOW download milestones, final GREEN success, RED failure/BLE recovery, OTA safe outputs, stream/image/update validation remain intact.
- [PROTECTED] Local OTA source region was verified byte-for-byte unchanged.
- [SOURCE ALIGNMENT] All active V4.0 text markers in the firmware source were updated to V4.1 and the active filename now matches the firmware version.
- [STATIC AUDIT] No timing `while()` loops; no executable `delay()` (remaining textual match is in a comment); no `setAutoReconnect(false)`; no retry `WiFi.mode(WIFI_OFF)` path remains; reset-reason telemetry remains present.
- [VALIDATION BOUNDARY] ArduinoDroid/Core 3.3.7 compile, BIN generation, physical Local OTA flash, and physical Online OTA runtime success are NOT claimed yet.
- [APP] No App source/configuration change; no App Build triggered.
- [COMMITS] Source creation: `10e01cb70f35abc19749a7cfe90dea457116416f`; superseded V4.0 deletion: `5abcea6551bba59af9a8a5f0c8f3cc9aa884b760`.

## 2026-10-04 — GEMINI FINAL SIMPLE V4.1 PATCH RESULT RECONCILIATION

- [GEMINI RESULT] Gemini returned exactly two patches: V4.0 -> V4.1 and simplification of Online OTA Wi-Fi connection/retry.
- [PATCH 1] Accepted. Firmware version must advance V4.0 -> V4.1 for any functional firmware change.
- [PATCH 2] Current-source OLD block matches the exact V4.0 Online OTA connection/retry block. The proposed change sets WiFi auto-reconnect true, removes WL_CONNECT_FAILED/WL_NO_SSID_AVAIL fast-fail handling, removes repeated WiFi.disconnect(true,false)+WIFI_OFF retry teardown, and uses soft WiFi.disconnect()+WiFi.begin() only after the full 15 s connection interval.
- [RECONCILIATION] This is materially aligned with the user's requested simple Online OTA architecture and is the only directly applicable part of the latest Gemini response.
- [RETAINED] Current V4.0 setInsecure(), GitHub URL allowlist, direct DOWNLOAD/FLASH_FINALIZE transitions, LED flow, OTA safe outputs, streaming validation, and Local OTA are not being re-patched.
- [REJECTED] No cloudPassword.trim().
- [CAUTION] Gemini's explanations that the previous path definitively caused brownout or that WPA3/PMF is definitely the root cause remain hypotheses; the patch is accepted as a simplification/reliability correction, not as hardware-proven causality.
- [NEXT] The exact V4.1 patch is ready for Execution Full when explicitly authorized. No functional source change was made in this reconciliation.
- [PROTECTED] Local OTA remains Golden/Protected and unchanged.

## 2026-10-04 — GEMINI SIMPLE ONLINE OTA REDESIGN RESULT RECONCILIATION

- [USER GOAL] Return Online OTA to the simplest reliable architecture because Online OTA worked previously; keep mandatory LED feedback.
- [GEMINI DIRECTION] Gemini proposes simplifying Wi-Fi retry, using auto reconnect, soft retry, simple setInsecure(), and keeping BLUE/YELLOW/GREEN/RED LED flow.
- [ACCEPTED] The architectural direction is aligned with the user goal: avoid unnecessary radio OFF/reinitialization during retries and avoid TLS/indicator complexity.
- [REJECTED PATCH DETAIL] Gemini PATCH 2 (CA-bundle removal) is stale for current V4.0 because the exact current source already uses plain WiFiClientSecure + setInsecure(). Do not reapply.
- [REJECTED PATCH DETAIL] Gemini PATCH 3 is stale for current V4.0 for the same reason; current source already contains setInsecure().
- [REJECTED PATCH DETAIL] Gemini PATCH 6A/6B is stale for current V4.0 because the intermediate GREEN/BLUE transitions were already removed in commit 5ba869806a85244142378470818665b75025527a.
- [REJECTED PATCH DETAIL] Gemini PATCH 4 cloudPassword.trim() is not accepted because Wi-Fi password whitespace can be legitimate data and the protocol does not prove surrounding spaces are transport formatting.
- [CANDIDATE PATCH] Gemini PATCH 5 is the only materially applicable candidate: setAutoReconnect(true) and soft retry after the connection timeout instead of WiFi.disconnect(true,false)+WIFI_OFF. It still needs exact current-source OLD/NEW reconstruction and safety audit before implementation.
- [HISTORY] Git confirms the V1.5 handoff patch introduced the RADIO_TEARDOWN architecture and setAutoReconnect(false); however this history alone does not prove that commit was the regression cause. The older V1.4 source already used setAutoReconnect(false) and direct WiFi.begin().
- [VERSION] Any functional firmware implementation must bump V4.0 -> V4.1, including a one-character change, and keep the versioned source filename aligned.
- [STATUS] No functional firmware change applied from this Gemini result. Local OTA remains protected/frozen.
- [NEXT] Before Execution Full, obtain or derive exact current-source patch only for the applicable simple Wi-Fi retry redesign; do not reapply already-completed TLS/LED changes and do not trim PASS.

## 2026-10-04 — DISCUSSION: SIMPLE ONLINE OTA REDESIGN REQUEST

- [USER] Online OTA feels unnecessarily difficult and the user notes that it has worked previously.
- [USER REQUEST] Ask Gemini to create a **simple, reliable Online OTA implementation** focused on actually connecting, downloading the GitHub raw BIN, flashing, and recovering cleanly.
- [LED CONTRACT] Keep OTA LED visibility: start OFF; Wi-Fi success BLUE; download progress YELLOW; flash success GREEN then restart; failure RED then BLE recovery.
- [HISTORY] Gemini must inspect git history and identify the previously working/minimal Online OTA pattern before proposing a redesign.
- [PROTECTED] Local OTA remains Golden/Protected; no Local OTA changes.
- [VERSION RULE] Any functional implementation of this request must bump firmware version, minimum V4.0 -> V4.1, even for a minimal change.
- [NO SOURCE CHANGE] This discussion/request does not change firmware behavior yet.

## 2026-10-04 — GEMINI ROUND 3 RECONCILIATION

- [GEMINI RESULT] Gemini concluded no patch, suspected the failure occurs before normal Wi-Fi completion and recommended Serial Monitor testing. Gemini's final verdict was NOT SAFE TO FLASH LOCAL OTA.
- [ACCEPTED] Latest hardware evidence localizes the observed failure before GitHub/HTTPS because the ESP32-C3 did not reach an observed Wi-Fi-connected state.
- [ACCEPTED] Current PASS handler does not trim password; this is not a proven bug because spaces may be legitimate password data.
- [ACCEPTED] Current Wi-Fi logic can bypass the 15 s timeout when the driver reports WL_CONNECT_FAILED or WL_NO_SSID_AVAIL.
- [CORRECTION] The source contains resetReasonText() using esp_reset_reason(), including BROWNOUT, WDT and PANIC classes, and publishes RESET_REASON through the runtime sync path. Therefore Gemini's statement that reset-reason telemetry is absent is incorrect.
- [CORRECTION] WIFI_CONNECT_RETRY_BACKOFF_MS = 3000 exists in source but is not used in the shown retry path; Gemini's retry-time calculation that adds a 3000 ms backoff is therefore incorrect for the current source.
- [CORRECTION] The current retry path has no intentional 3 s sleep/backoff. Each attempt can terminate on driver-reported failure; worst-case connection wait is approximately three 15 s attempts plus the 160 ms Wi-Fi-off settle/reinitialization boundaries, before the 1 s RED indicator.
- [CORRECTION] The git-history anchor e8185cb... is a diagnostic-source commit and does not by itself prove it introduced production setAutoReconnect(false) or the current production retry logic.
- [UNPROVEN] Claims about WPA3/PMF causing the failure, RF recalibration causing a 350–400 mA spike, watchdog looping, or brownout remain hypotheses without runtime logs/measurement.
- [DECISION] No functional firmware patch is authorized from this Gemini result. The strongest next action remains a serial/reboot-reason diagnostic under the same hotspot test.
- [PROTECTED] Local OTA remains unchanged/frozen. Current firmware source blob remains 0566105383a889912e5e756b0b9f265e5fcf0264.

## 2026-10-04 — FIRMWARE VERSION RULE + GEMINI PROMPT FILE RETIRED

- [WORKFLOW] Dedicated `GEMINI_PROMPT_ONLINE_OTA.md` has been removed from the repository. Gemini prompts are generated from current repository/source context in the active chat.
- [RULE] Every firmware update that produces/can produce a new firmware image MUST increment `FW_VERSION`, even for the smallest source change (including a one-character change).
- [CURRENT] No firmware source was changed by this policy update; active firmware remains V4.0.
- [LOCAL OTA] Protected/golden path remains unchanged.


## 2026-10-04 — GEMINI WIFI FORENSIC RESULT RECONCILIATION

- [GEMINI RESULT] Gemini identified two candidate Online OTA Wi-Fi patches: PASS whitespace normalization and a relaxed Wi-Fi retry state using WiFi.setAutoReconnect(true) plus timeout-only retries.
- [RECONCILIATION] PASS handling currently stores command payload verbatim. However, the absence of trim() is NOT by itself a proven bug because whitespace can be part of a legitimate Wi-Fi password. Apply trim() only if the BLE protocol contract explicitly treats surrounding whitespace as transport formatting.
- [RECONCILIATION] Gemini's claim that setAutoReconnect(false) "absolutely" causes WPA3/Mixed-mode negotiation failure and that WL_CONNECT_FAILED occurs on a fixed ~10 ms path is NOT proven from the source. setAutoReconnect(false) is used only to prevent driver-level reconnect behavior; WL_CONNECT_FAILED may legitimately appear before the 15 s timeout.
- [CANDIDATE PATCH] Relaxing fast-fail can improve tolerance/observability for transient hotspot connection failures and is a reasonable candidate, but it is not yet proven as the root cause. The proposed soft retry should also be audited for disconnect/rebegin sequencing.
- [OBSERVATION] Latest hardware evidence remains: ESP32-C3 does not reach WL_CONNECTED when tested with an HP hotspot; therefore GitHub/HTTPS is not demonstrated as the failure stage.
- [STATUS] No functional source change authorized/applied from this Gemini result. Local OTA remains protected/frozen.
- [NEXT GATE] Require a corrected second-opinion review or explicit Execution Full before any firmware patch.

## 2026-10-04 — GEMINI FULL PRE-FLASH FORENSIC AUDIT

- Gemini audited the exact V4.0 source blob `0566105383a889912e5e756b0b9f265e5fcf0264` before planned Local OTA testing.
- Verdict: **SAFE TO FLASH LOCAL OTA** at source level; no P0/P1 blocker identified.
- P2 finding: BLE TX queue overflow can drop newest messages during heavy traffic and affect ACK/UI synchronization.
- Online OTA remains physically unverified despite the simplified `setInsecure()` path.
- Current source-level LED flow remains Wi-Fi BLUE → YELLOW 20/40/60/80/100 → final GREEN → restart; no intermediate BLUE after download.

## 2026-10-04 — V4.0 ONLINE OTA GEMINI PATCH

- Applied the supplied Gemini Online OTA patch to V4.0.
- Switched Online OTA to simple `WiFiClientSecure + setInsecure()` for GitHub raw-BIN compatibility, intentionally without CA/server authentication.
- Removed only the intermediate GREEN-after-GitHub and BLUE-after-download transitions.
- Preserved BLUE Wi-Fi success, YELLOW 20/40/60/80/100 milestones, GREEN final success, and RED failure/recovery.
- Local OTA remained byte-for-byte unchanged.
- No App Build or firmware compile/BIN/physical validation was performed.

## 2026-10-04 — GEMINI PATCH-ONLY WORKFLOW ADDED

- Added `GEMINI_PROMPT_ONLINE_OTA.md` as the copy-ready independent Gemini review/fix prompt.
- Gemini responses for this workflow are now patch-only OLD → NEW blocks; no full .ino response.
- The assistant owns the subsequent `@Thinking Eksekusi Full!` application, full affected audit, memory synchronization, and commit.
- Local OTA is frozen/protected; current scope is Online OTA indicator/runtime behavior only.
- No functional Firmware/App source changed in this workflow update.

## 2026-10-04 — V4.0 COMPILE FIX

- Fixed ArduinoDroid compile blocker: `batteryZoneFor(batteryC)` now passes `currentVoltage` to the required two-argument function signature.
- New V4.0 source blob: `415346ece09f4af33f907b2077140ccfc45c357b`.
- Prior dual-party SAFE verdict is tied to the previous blob and must be repeated for this new source before flash.

## 2026-10-04 — V4.0 DUAL-PARTY REVIEW PASSED

- Gemini independently audited exact V4.0 source blob `b2a77fadeaa154412850d34c82b0bb78ef108bae` and returned **SAFE TO FLASH**.
- Assistant independently reconciled the exact source and returned **SAFE TO FLASH**.
- Two-party firmware flash gate is therefore OPEN for the controlled compile/BIN/device-validation phase.
- No compile, BIN publication, Firebase update, App Build, or physical flash was performed by this review event.

## 2026-10-04 — FIRMWARE V4.0 / P0+P1 HARDENING EXECUTION

- Firmware advanced V3.9 → V4.0.
- P0 rail stabilization added after 9V/12V selector activation with an initial cooperative 300 ms physical Peltier PWM hold at 0%, preserving logical Peltier state and the OFF→ON-only 5 s soft-start contract.
- P1 Online OTA changed from insecure TLS to the Arduino-ESP32 Core 3.3.7 ESP certificate-bundle trust path.
- V3.9 source retired after V4.0 creation.
- Full affected static audit passed: 5351 lines, braces 581/581, parentheses 2123/2123, executable delay 0, timing while 0, setInsecure 0, stopBleRadio(false) 0.
- No App Build, firmware compile, BIN generation, Firebase promotion, or physical validation was performed.
- V4.0 remains pending the required independent Assistant + Gemini two-party flash gate.

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

## 2026-10-04 — REPOSITORY CLEANUP / HARDWARE TEST BASELINE

- Reconciled the repository-first chat-transfer system and normalized its current-state documentation.
- CHAT_TRANSFER.md is explicitly a template until Prompt 1 performs a real chat-limit transfer; it must not be interpreted as completed transfer evidence beforehand.
- Current App Build remains #50; no new App Build was triggered.
- Current firmware remains V3.7; no firmware source/build/device behavior was changed by this cleanup.
- Next operational stage is real hardware/device testing when the user provides evidence.

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

## 2026-10-04 — FIRMWARE V3.8

- Advanced Firmware V3.7 → V3.8.
- Peltier 5 s soft-start now runs only when Peltier transitions OFF → ON.
- Voltage changes no longer restart soft-start.
- Existing 20 kHz / 8-bit Peltier PWM, 5 s duration, safety, BLE/P1, GPIO, Adaptive, and OTA contracts are preserved.
- No App source changed and no App Build was triggered.

## 2026-10-04 — FULL V3.8 FIRMWARE AUDIT / DISCUSSION CHECKPOINT

[DISCUSSION ONLY] No functional Firmware/App source was changed by this audit. Current functional source remains `firmware/JEXFYZ-V3.8.ino` blob `2fbff3656bc037846124806fb390022f85146845`.

### Scope
Full static review of the V3.8 firmware path: OTA/radio, BLE command/queues, GPIO/PWM, NTC, Hotside safety, Adaptive, Battery input, Voltage transitions, touch state machine, LED ownership, persistence, setup/loop scheduling, error recovery, and observability.

### Confirmed findings
1. **P0/P1 — Online OTA DOWNLOAD dispatcher stalls after the first chunk.**
   - Source: `processOnlineOta()`, around L3501.
   - The DOWNLOAD state is guarded by `if (!onlineUpdateStarted)`, so after `Update.begin()` sets `onlineUpdateStarted=true`, later loop passes stop calling `performOnlineOtaDownload()`.
   - This exactly explains BLUE -> GREEN -> LED OFF/stall on an incomplete download.
   - Intended correction: service `performOnlineOtaDownload()` every cooperative DOWNLOAD loop; keep its internal initialization/completion/error guards.

2. **P0/P1 — Online OTA does not fully release BLE before Wi-Fi handoff.**
   - `startOnlineOta()` calls `stopBleRadio(false)`.
   - The false path stops advertising but does not deinitialize the BLE controller or explicitly disconnect an existing GATT client.
   - The code then starts Wi-Fi after the settle window.
   - This conflicts with the ESP32-C3 single-radio contract and can create radio coexistence/recovery instability.
   - This finding is source-level verified; physical radio-fault causality is not yet measured.

3. **P1 — NTC validity is not revalidated immediately before voltage-selector activation.**
   - `requestVoltage()` validates `ntcValid` when the request is created.
   - `completeVoltageTransition()` rechecks Hotside, but not `!ntcValid`, immediately before activating 9 V/12 V.
   - If the NTC becomes invalid during the 200 ms deadtime, one above-5 V selector state can be committed before the next loop forces the safe 5 V path.
   - This is a safety-state race and should be fixed before treating voltage safety as complete.

4. **P1 — Required rapid Hotside temperature-rise protection is absent.**
   - Current source has absolute Hotside-limit protection but no previous-temperature/rate-of-rise calculation, no `dT/dt` threshold, and no dedicated manual-restart latch for a rapid-rise event.
   - A 1 s NTC sample period also means the current thermal decision granularity is approximately 1 s.
   - Therefore the historical requirement “rapid temperature rise -> immediate Peltier OFF + manual restart” is not implemented in V3.8.

5. **P1 — Wi-Fi retry path skips the explicit radio-off settle on retries.**
   - In Online OTA `WIFI_CONNECTING`, a failed attempt calls `WiFi.mode(WIFI_OFF)` and returns to `RADIO_TEARDOWN` without re-arming `wifiOffSettlePending`.
   - The next teardown pass can therefore proceed without the configured 160 ms settle.
   - First-attempt teardown is settled; retry teardown is not consistently modeled.

6. **P1 — Online OTA HTTP preparation is synchronously blocking.**
   - `prepareOnlineOtaDownload()` calls `onlineHttpClient.GET()` with a 60 s timeout from the main loop.
   - This violates the stated cooperative/non-blocking runtime contract and can freeze normal scheduling/LED feedback for a long period.
   - It does not explain GREEN-after-success by itself, but it is a separate OTA reliability defect.

7. **P1 — OTA transport is not cryptographically authenticated.**
   - `prepareOnlineOtaDownload()` uses `cloudClient.setInsecure()`.
   - HTTPS encryption is therefore used without certificate/server authentication.
   - The URL host/path allowlist reduces scope but does not eliminate a network MITM firmware-substitution risk.

8. **P1 — OTA has no explicit anti-rollback/version monotonicity check.**
   - `validFirmwareVersion()` validates syntax only.
   - `startOnlineOta()` skips only an exact string match with `FW_VERSION`; an older version can still be accepted for download.
   - No semantic version ordering or rollback policy is enforced.

9. **P1 — BLE control channel is not authenticated.**
   - The UUIDs identify the service/characteristics but are not a secret key or access-control mechanism.
   - Any compatible BLE client that completes `SYNC_READY` can issue control/OTA commands.
   - This is especially relevant because `PHONE:BT`, OTA credentials, OTA URL, and OTA version are accepted from that channel.

10. **P1/P2 — Battery temperature is a trusted remote control input, not an independent sensor.**
    - `PHONE:BT=` directly feeds the Adaptive Battery controller.
    - TTL/liveness protection exists, but there is no authenticity/attestation of the temperature source.
    - With an unauthenticated BLE channel, a client can influence Adaptive voltage selection.

11. **P2 — Local OTA AP has no application-layer authentication/session timeout after a client connects.**
    - Once `bootApClientSafe` is set by a connected station, the AP can remain the priority owner until the station disconnects or OTA completes.
    - A stale/idle Wi-Fi client can therefore hold the device away from BLE longer than necessary.

12. **P2 — Online OTA progress UX can be legitimately silent for long intervals.**
    - Progress indicators appear only at 20/40/60/80/100% milestones.
    - Below 20% the LEDs are intentionally off.
    - Combined with the blocking GET and the confirmed DOWNLOAD dispatcher bug, this created the exact “green then nothing” user symptom.

13. **P2 — OTA success has no explicit post-boot health/rollback validation.**
    - The source records success and restarts after `Update.end()`.
    - There is no application-level “new image booted healthy” confirmation/rollback decision in this firmware.

14. **P2 — Reset-reason telemetry is intentionally unavailable.**
    - `resetReasonText()` always returns `UNAVAILABLE_CORE_3_3_7`.
    - This prevents the firmware from distinguishing brownout/panic/watchdog/software reset classes during post-mortem analysis.

15. **P2 — BLE TX queue silently drops data when full.**
    - `sendText()` only enqueues when `bleTxCount < BLE_TX_QUEUE_SIZE`; otherwise the message is discarded with no overflow counter/diagnostic.
    - High-rate telemetry or sync bursts can therefore lose non-safety state notifications.

16. **P2 — Battery Adaptive has no threshold hysteresis.**
    - Near `battery5Limit` or `battery12Limit`, small temperature noise can cause repeated 5 V/9 V/12 V target changes.
    - The one-step movement and 1 s voltage guard reduce the rate, but do not prevent threshold chatter.

17. **P2 — Heap/allocator fragility remains a long-run risk.**
    - The firmware uses many dynamic `String` objects and a 48-entry `String` TX queue.
    - Heap checks exist, but only at named BLE-start checkpoints rather than during long-duration runtime.
    - No fragmentation regression metric is currently retained.

18. **P2 — Local OTA relies on library image finalization rather than an explicit first-byte magic check.**
    - Online OTA checks the ESP32 magic byte before streaming.
    - Local OTA validates file extension/size and calls `Update.end(true)`, but has no equivalent explicit first-byte diagnostic.
    - This is primarily observability/diagnostic inconsistency unless a malformed image reaches the library error path.

### Requirements / contract gaps
- Rapid-rise thermal shutdown + manual restart is missing from the current implementation.
- Independent Battery protection guard is not present as a separate safety authority; Battery temperature is currently an Adaptive input only.
- “BLE/Wi-Fi never concurrent” is not fully enforced during Online OTA because the current BLE stop call is non-deinitializing.

### Known non-bugs / already-verified
- GPIO contract is correct in source: GPIO5=Peltier, GPIO6=Fan.
- Peltier 5 s soft-start is correctly scoped to genuine OFF->ON only in V3.8; voltage changes do not restart it.
- 200 ms selector deadtime and 1 s shared post-transition guard are present.
- Hotside absolute-limit protection is present in Manual and Adaptive paths.
- BLE RX callbacks enqueue data; main loop performs command handling.
- Executable `delay()` count is 0; timing `while()` wait count is 0.
- Source/static brace and parenthesis audits are balanced.

### Full-source documentation requirement for the next execution
The source contains function-level `[DOC-CONTRACT]` blocks, but not literally every executable statement has a dedicated explanation. Before a functional cleanup pass, document every **meaningful functional line/statement** with its purpose, authority, state mutation, timing, and safety implication. Do not waste comments on blank lines or punctuation-only braces. The goal is line-auditable engineering intent without turning the file into noise.

### Validation boundary
This is static/source analysis only. ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compilation, BIN generation, Firebase promotion, and physical ESP32 electrical/thermal/radio/OTA tests remain unperformed.

## 2026-10-04 — AUDIT FOLLOW-UP / ADDITIONAL FINDINGS + DOCUMENTATION CORRECTION

### Additional source findings
19. **P1 — Peltier can be commanded ON during an active voltage transition.**
   - `setPeltierState()` does not reject or defer ON when `voltageTransition == true`.
   - `requestVoltage()` has already forced both selectors OFF for the 200 ms deadtime.
   - A subsequent `PELTIER:ON` can therefore start the 5 s PWM soft-start while the selector is physically OFF; the pending selector may then be enabled mid-ramp.
   - This is an unsafe state interleaving and a plausible contributor to load-transient faults.
   - Recommended design: block/defer Peltier ON until selector transition completes; do not restart soft-start merely because voltage changes.

20. **P2 — `ADAPTIVE:OFF` reports ACK=OK even when the safe-5V handoff fails.**
   - `setAdaptiveState(false, reason)` can return `VOLTAGE_FORCE_FAILED`.
   - `handleCommand()` currently sends `sendAck("ADAPTIVE", true, reason)` unconditionally for `ADAPTIVE:OFF`.
   - App-side state acknowledgement can therefore claim success when the requested safety transition was not accepted.
   - Recommended correction: ACK success only when `reason == "OK"`; preserve the actual failure reason.

21. **P2 — BLE disconnect callback performs stack API work from the BLE callback context.**
   - `ServerCallbacks::onDisconnect()` calls `BLEDevice::startAdvertising()` directly.
   - This should be treated as a callback-context safety/reentrancy risk unless the exact Core 3.3.7 BLE implementation guarantees that API is safe from that callback task.
   - Safer architecture: callback sets a pending flag; main loop performs advertising restart.

22. **P2 — One source function is currently dead/incomplete: `finishOnlineOtaFailureRecovery()`.**
   - Static call-site scan found the function definition with no call site.
   - It appears to be superseded by the `RECOVER` path inside `processOnlineOtaResultIndicator()`.
   - This is not itself a runtime failure, but dead recovery code increases maintenance/refactor risk.

### Corrections to previous audit notes
- The previous statement that Local OTA has no session/hard timeout after a client connects was too strong. `BOOT_AP_HARD_LIMIT_MS` still bounds the AP window when no Local OTA upload is active. The remaining concern is that a connected client owns the safe Wi-Fi/OTA state until the hard limit or session ends.
- The previous static line-count note of 5107 was stale. Current V3.8 source fetched from the repository is 5097 lines by the repository line ranges used in this audit.
- The current source still contains two mixed-language comments: `FIX: Fase dihitung tiap 250ms...` and `FAST FAIL: Tangani password salah...` Therefore the older note claiming zero mixed-language source comments is obsolete.

### Documentation standard for next implementation pass
The requested “keterangan di semua baris” is interpreted as every meaningful functional statement being explainable from nearby comments/contract metadata: purpose, authority, state mutation, timing, and safety effect. Blank lines, punctuation-only braces, and obvious syntax do not need redundant comments.

## 2026-10-04 — GEMINI INDEPENDENT AUDIT RECONCILIATION

[DISCUSSION ONLY]
Received raw Gemini V3.8 independent firmware audit and reconciled it against the current source.

### Accepted
- OTA DOWNLOAD dispatcher starvation is source-proven.
- NTC validity race, Peltier/voltage-transition interleaving, Wi-Fi retry settle gap, ADAPTIVE:OFF ACK contradiction, battery hysteresis gap, rapid-rise thermal gap, synchronous HTTP GET, TLS `setInsecure()`, and missing semantic anti-rollback are confirmed findings.
- BLE/Wi-Fi handoff remains a source-level project-contract violation because OTA uses `stopBleRadio(false)`.

### Corrected / not overclaimed
- The 9V->12V restart mechanism is **not** source-proven as brownout/LDO failure; PWM/selector sequencing is a confirmed hazard and leading hypothesis only.
- BLE disconnect `startAdvertising()` is a callback-context risk, not a proven interrupt crash.
- Exact `esp_reset_reason()` availability in the user's ArduinoDroid/Core 3.3.7 setup remains to be compile-validated.

### State
No functional Firmware/App source changed during this review. Hardware validation remains blocked until the source hardening pass is completed.

## 2026-10-04 — V3.9 FULL FIRMWARE HARDENING
- V3.8 hardened and versioned to V3.9.
- Fixed Online OTA stream starvation and hardened BLE/Wi-Fi radio handoff/retry.
- Added selector/Peltier physical interlock without restarting the 5 s soft-start on voltage changes.
- Added final NTC gate, rapid-rise thermal latch, Battery hysteresis, ADAPTIVE:OFF ACK fix, callback-safe BLE advertising recovery.
- Added numeric OTA anti-rollback, reset reason telemetry, Local OTA magic validation, and BLE TX drop diagnostics.
- Active source blob: `bf85b50e0a8cab22e5d66ef09ee84d6692cee009`.
- No firmware compile/BIN/Firebase/physical validation yet; App Build #50 unchanged.


## 2026-10-04 — V3.9 DUAL-AUDIT RECONCILIATION / FLASH GATE

- [CONFIRMED] User-mediated Gemini independent audit for the active JE X FYZ / JE Cooler V3.9 source has been received.
- [CONFIRMED] This assistant independently re-checked Gemini's critical findings against active source blob `bf85b50e0a8cab22e5d66ef09ee84d6692cee009`.
- [DECISION] Both reviews converge on **NOT SAFE TO FLASH**. The V3.9 flash/update gate remains CLOSED.
- [P0 / ACCEPTED] `completeVoltageTransition()` re-enables the selected 9V/12V rail and then `applyCoolingOutputs()` can restore an already-logically-ON Peltier to 100% duty without a separate post-selector rail-stabilization window. The source-level sequencing hazard is proven. The historical 9V→12V MCU reset's exact electrical mechanism remains unproven without hardware evidence.
- [P1 / ACCEPTED] Online OTA still calls `cloudClient.setInsecure()`, so HTTPS transport is not server-authenticated against a trusted CA. This remains a production security blocker.
- [P2 / ACCEPTED] BLE TX uses a single FIFO with no priority handling. When full, newest messages are dropped. The overflow counter improves observability, but ACK/OTA-state messages are not protected from queue pressure.
- [NUANCE] Gemini's suggested 300–500 ms stabilization interval is an engineering candidate, not a source-proven universal value. The final interval must be validated against the actual regulator/PSU/MOSFET/rail behavior.
- [PASS / RETAINED] Previously hardened V3.9 items remain accepted: OTA download dispatcher, full BLE radio teardown for Wi-Fi handoff, main-loop BLE advertising recovery, semantic firmware-version comparison, retry radio settle, rapid Hotside rise latch, NTC final gate, battery hysteresis, and local OTA image magic-byte validation.
- [BLOCKED] No compile, BIN generation, Firebase promotion, flash, or physical electrical/thermal validation was performed as part of this audit.
- [NEXT ACTION] Do not flash V3.9. First patch the P0 rail-stabilization state machine and P1 OTA certificate validation; then re-audit the affected source with the same two-party gate before any firmware update.


## 2026-10-04 — NEW CHAT PREFLIGHT / REPOSITORY RECONCILIATION

- [VERIFIED] Rebuilt project context from the full repository memory stack and current source/workflows.
- [RECONCILED] Live HEAD `af29fd3a3f785aa3685c713cac963ecedeb7f869` superseded the transfer-recorded `fe9e35b578bd7034899e629ca6d030854257ddf6` only through a documentation-only CHAT_TRANSFER finalization commit.
- [VERIFIED] Active Firmware remains V3.9 / `firmware/JEXFYZ-V3.9.ino`; App Build #50 remains the latest verified App artifact.
- [CONFIRMED] V3.9 flash gate remains CLOSED / NOT SAFE TO FLASH; P0 rail stabilization and P1 trusted OTA TLS remain open.
- [NO FUNCTIONAL CHANGE] This event changed documentation/state memory only; no App/Firmware/workflow behavior or Build App was triggered.
