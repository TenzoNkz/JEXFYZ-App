## 2026-10-04 — CURRENT FIRMWARE ANALYSIS / V4.2

- [CURRENT] Active source: `firmware/JEXFYZ-V4.2.ino`; blob `63e8db10dbe99eb538af62ddc7d35d8b4b20b849`.
- [CURRENT] Online OTA `WIFI_CONNECTING` performs one initial `WiFi.begin()` and does not issue retry-side `WiFi.disconnect(); WiFi.begin(...)`.
- [CURRENT] Connection failure is handled by a cumulative 45-second timeout using the existing 15-second interval constants.
- [CURRENT] Attempt telemetry advances from elapsed time only; it does not manipulate the radio state.
- [CURRENT] Local OTA path remains protected.
- [UNVERIFIED] Toolchain compile/BIN and physical/runtime behavior.
- [HYPOTHESIS ONLY] Gemini's event-queue/crash explanation is not independently proven by source alone.

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

## 2026-10-04 — CURRENT V4.0 ONLINE OTA PATCH

- Active source: `firmware/JEXFYZ-V4.0.ino`; blob `0566105383a889912e5e756b0b9f265e5fcf0264`.
- Online OTA uses `WiFiClientSecure + setInsecure()` intentionally for GitHub raw-BIN compatibility; the URL allowlist remains restricted to the JE X FYZ firmware repository.
- Indicator flow: OFF at OTA start → BLUE on Wi-Fi success → YELLOW at 20/40/60/80/100 → flash finalize → final GREEN → restart; failure remains RED → BLE recovery.
- Intermediate GREEN-after-GitHub and BLUE-after-download transitions are removed.
- Local OTA remains frozen/protected and unchanged.
- New source is not yet compile/BIN/physically validated.

## 2026-10-04 — ONLINE OTA GEMINI PATCH-ONLY PROTOCOL

- [CURRENT ISSUE] Online OTA indicator is not visibly blinking during hardware test.
- [USER PRIORITY] Online OTA should remain simple and reliable: Wi-Fi → JE X FYZ GitHub BIN → flash → success indicator → restart.
- [GEMINI INPUT] User supplies the current .ino directly to Gemini; Gemini does not need repository access.
- [GEMINI OUTPUT] Gemini must return minimal OLD → NEW patches only, never the complete .ino.
- [EXECUTION] The next `@Thinking Eksekusi Full!` applies the Gemini patch against the exact current repository source, then audits affected Firmware behavior and commits it.
- [PROTECTED] Local OTA is frozen/proven working on hardware and is out of scope for Online OTA fixes.

## 2026-10-04 — CURRENT FIRMWARE ANALYSIS SNAPSHOT / V4.0

- Active source: `firmware/JEXFYZ-V4.0.ino`.
- Firmware version: V4.0.
- Source blob: `b2a77fadeaa154412850d34c82b0bb78ef108bae`.
- V3.9 P0 rail/load sequencing gap is addressed by a cooperative 300 ms post-selector stabilization state for 9V/12V activation.
- V3.9 Online OTA TLS trust gap is addressed using the exact Arduino-ESP32 Core 3.3.7 ESP certificate-bundle mechanism; `setInsecure()` is absent from the active source.
- Frozen Peltier contract remains: only logical OFF→ON starts the 5 s soft-start; voltage changes do not restart it.
- [STATIC VERIFIED] braces 581/581; parentheses 2123/2123; executable delay 0; timing while 0; stopBleRadio(false) 0.
- [UNVERIFIED] exact ArduinoDroid/Core 3.3.7 compile/link, BIN, Firebase, and physical electrical/thermal/radio/OTA evidence.
- [GATE] V4.0 still requires independent Assistant + Gemini agreement before update/flash.

## 2026-10-04 — CURRENT FIRMWARE ANALYSIS SNAPSHOT

- This repository is the persistent continuity boundary for JE X FYZ while the current chat approaches its context limit.
- The detailed copy-ready continuation prompt is available in both `README.md` and `HANDOVER.md`.
- A new chat must re-read the complete memory stack before any action, including Build App subchats.
- Current functional firmware is V3.8; this checkpoint reflects the soft-start scope change.
- Latest verified App Build remains #50; no Build App was run during the handover.

# JE X FYZ — Firmware Analysis / V3.8

## Current source

Active file: firmware/JEXFYZ-V3.8.ino
Functional version: V3.8
Source blob: 2fbff3656bc037846124806fb390022f85146845
Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module
Framework: Arduino Standard + official Arduino-ESP32 Core 3.3.7

## Hardware contract

| Function | GPIO | Contract |
|---|---:|---|
| NTC Hotside | 0 | 12-bit ADC, 11 dB attenuation, sampled every 1 s |
| Touch | 1 | Deterministic touch state machine |
| 12 V selector | 3 | Physical selector output |
| 9 V selector | 4 | Physical selector output |
| Peltier | 5 | 20 kHz, 8-bit PWM |
| Fan | 6 | 25 kHz, 8-bit PWM |
| WS2812 | 7 | 8 LEDs |

## Authority order

1. OTA supervisor owns the runtime before normal application processing.
2. NTC validity and Hotside safety override normal cooling requests.
3. Adaptive chooses voltage only within the current safety ceiling.
4. Manual controls are accepted only when Adaptive/safety locks allow them.
5. LEDs, telemetry, and persistence report the resulting state; they do not become safety authorities.

## Voltage path

requestVoltage(): validates OTA lock, in-flight transition lock, voltage guard, NTC validity, manual Hotside restriction, and Adaptive ceiling; then turns both selector outputs OFF and records the request source.

completeVoltageTransition(): waits for the 200 ms deadtime, revalidates Hotside immediately before selector activation, applies Battery-only deadtime revalidation for Battery-originated transitions, commits one physical voltage step, arms the shared 1 s guard, and finally applies cooling/PWM consequences.

### Peltier V3.8 rule

| Transition | Peltier state | Result |
|---|---|---|
| 5 V -> 9 V | ON | Preserve current PWM state |
| 9 V -> 12 V | ON | Preserve current PWM state |
| 12 V -> 9 V | ON | Preserve current PWM state |
| 9 V -> 5 V | ON | Preserve current PWM state |
| Any OFF -> ON | OFF | Start 5 s soft-start |

Voltage changes do not start or restart the Peltier soft-start. A true Peltier OFF -> ON transition remains the only soft-start trigger. Safety still has higher authority and can prevent Peltier operation.

## Universal Hotside safety

### Manual
- Hotside at/above limit: Peltier OFF, Fan ON at 100%, manual Peltier safety latch set, voltage forced toward 5 V.
- Normal manual voltage above 5 V is blocked while hot.
- Peltier remains OFF after recovery until an explicit safe manual ON command releases the latch.

### Adaptive HOTSIDE
- Hot event immediately requests one lower voltage level with no pre-down delay.
- The just-rejected voltage is removed from the session Adaptive ceiling.
- After the physical down-step, Peltier remains OFF for 5 s and may resume only after Hotside is safe.
- If 5 V is still hot, Adaptive turns OFF and Fan remains ON.

### HOTSIDE_BATTERY
- Hotside is the hard safety ceiling.
- Phone Battery temperature chooses the desired voltage inside that ceiling.
- Battery invalid/disconnected: effective runtime control falls back to HOTSIDE while preserving the configured profile.

## Battery Adaptive

Battery validity TTL is 5 s. Fresh PHONE:BT restores validity; BLE disconnect/link-loss invalidates the source immediately.

Direct mapping: below BATT5 -> 5 V; BATT5 through below BATT12 -> 9 V; at/above BATT12 -> 12 V.
Movement is one step at a time. Battery target is re-evaluated at the end of the 200 ms deadtime only for Battery-originated transitions, then the shared 1 s voltage guard applies.

## Adaptive startup / shutdown

Adaptive start is a staged handoff: request accepted -> physical voltage returns to 5 V -> Adaptive becomes active. Adaptive OFF uses the same safe 5 V boundary and resets the temporary Hotside ceiling to 12 V.

While Adaptive is active, Voltage/Control/Temperature user requests are locked. Fan and Peltier are firmware-owned except when safety explicitly forces Peltier OFF.

## Radio / BLE

The firmware treats ESP32-C3 as a single-radio target. BLE starts only after Wi-Fi is OFF and the configured settle window has expired.
BLE callbacks only enqueue data; command execution is performed in the main loop. TX notifications are paced at 15 ms.
BLE disconnect re-advertises without a full MCU restart.

## OTA

Local OTA uses the boot SoftAP. Online OTA uses the approved JE X FYZ firmware GitHub binary repository.
Online OTA validates the HTTPS URL, HTTP response, content size, ESP32 image magic byte (0xE9), streaming write results, and final Update.end() result.
Download uses a bounded 1024-byte buffer and one cooperative stream step per loop pass. Progress flashes yellow at 20/40/60/80/100%.
OTA failure records diagnostics and recovers to BLE; OTA success shows the final green indicator and then restarts.

## LED ownership

Higher-priority firmware indicators can temporarily own the LEDs over normal user RGB effects. Hotside protection, OTA, and voltage-indicator states therefore do not share output ownership with normal rendering during their active windows.

## Persistence

Settings are marked dirty when changed and written only after 10 s without a new change. This is a deliberate debounce against excessive flash writes.

## Non-blocking timing

No executable delay() calls and no timing while() waits are present in the current source. Timed operations use timestamps and cooperative state machines.

## Critical function map

- applyCoolingOutputs(): source line 987
- requestVoltage(): source line 1641
- completeVoltageTransition(): source line 1681
- forceSafeFiveVolt(): source line 1863
- enforceSafety(): source line 1909
- processAdaptiveHotTimer(): source line 2029
- processAdaptiveHotsideFallback(): source line 2130
- evaluateAdaptiveBattery(): source line 2185
- beginPeltierSoftStart(): source line 906
- processPeltierSoftStart(): source line 920
- sampleNtcIfDue(): source line 1819
- stopBleRadio(): source line 2628
- startBle(): source line 2701
- startOnlineOta(): source line 3371
- prepareOnlineOtaDownload(): source line 3092
- performOnlineOtaDownload(): source line 3184
- finalizeOnlineOtaFlash(): source line 3321
- serviceOtaPriority(): source line 4819
- initializeRuntimeFeatures(): source line 4927
- setup(): source line 4990
- loop(): source line 5021

## Static audit snapshot

- Source lines: 5107.
- Source comments: 779 lines.
- Function contract blocks: 136.
- C++-aware brace balance: 535/535.
- C++-aware parenthesis balance: 2002/2002.
- Executable delay(): 0.
- Timing while(): 0.
- Stale V3.5/V3.6/V1.0 baseline references: 0.
- Mixed-language source comments found in the cleanup audit: 0.
- Functional firmware version: V3.8; latest functional change scopes soft-start to Peltier OFF → ON only.

## Validation boundary

This repository pass proves source/documentation consistency only. ArduinoDroid compilation with official Arduino-ESP32 Core 3.3.7, BIN generation/publication, and physical electrical/thermal/BLE/OTA validation remain unperformed.

## Documentation standard

- Every detected firmware function has a [DOC-CONTRACT] comment immediately adjacent to its definition.
- Safety-critical state changes also have statement-level intent comments.
- Comments explain contract/intent and authority, not merely syntax.
- Source comments remain English to match the codebase standard.

## 2026-10-04 — ONLINE OTA DOWNLOAD STATE AUDIT

- [VERIFIED] Online OTA enters `DOWNLOAD` after the green GitHub-connected indicator.
- [VERIFIED] Current DOWNLOAD dispatch is incorrectly conditioned on `!onlineUpdateStarted`, which prevents subsequent chunks after the first `Update.begin()` call.
- [VERIFIED] This can permanently stall an incomplete firmware stream while `otaActive` remains true and no progress milestone is reached.
- [ROOT CAUSE] The download servicing predicate is inverted for a cooperative streaming state machine: an active download must be serviced repeatedly, not only before `Update.begin()` has started.
- [OPEN] Firmware-only patch should make the DOWNLOAD state call `performOnlineOtaDownload()` on every loop pass while active, with the function itself retaining initialization/completion/error guards.

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

[DISCUSSION ONLY] Received the user's raw Gemini independent V3.8 firmware audit. The audit was reconciled against the current source `firmware/JEXFYZ-V3.8.ino` blob `2fbff3656bc037846124806fb390022f85146845`.

### Accepted / confirmed against current source
- **B1/P0-P1 — Online OTA DOWNLOAD dispatcher starvation:** confirmed. `processOnlineOta()` currently calls `performOnlineOtaDownload()` only while `!onlineUpdateStarted`; after the first `Update.begin()`, subsequent chunks are never serviced.
- **S2/P1 — NTC validity race at selector completion:** confirmed. `completeVoltageTransition()` revalidates Hotside but does not independently reject `!ntcValid` immediately before 9V/12V selector activation.
- **S3/P1 — Peltier ON during voltage transition:** confirmed. `setPeltierState(true,...)` has no `voltageTransition` gate.
- **B4/P1 — Wi-Fi retry settle gap:** confirmed. Retry path calls `WiFi.mode(WIFI_OFF)` and returns to `RADIO_TEARDOWN` without rearming `wifiOffSettlePending`.
- **B5/P2 — ADAPTIVE:OFF ACK contradiction:** confirmed. `setAdaptiveState(false,...)` can produce `VOLTAGE_FORCE_FAILED`, while the handler reports ACK success unconditionally.
- **B6/P2 — Battery threshold chatter risk:** confirmed as a design/risk condition. `batteryZoneFor()` has no hysteresis; readings crossing 25C/35C can alternate targets subject to existing one-step and 1s guard behavior.
- **OTA Sec1/Sec3 and BLE Sec2:** confirmed as security gaps from source: TLS uses `cloudClient.setInsecure()`; firmware version validation is syntactic only; BLE command gating is session-state based rather than cryptographically authenticated.
- **Rapid-rise thermal protection:** confirmed missing relative to the historical user requirement. No dT/dt calculation or rapid-rise manual-restart latch exists.
- **Synchronous Online OTA HTTP GET:** confirmed. `prepareOnlineOtaDownload()` can remain inside `HTTPClient::GET()` for the configured timeout, contrary to the cooperative runtime contract.

### Accepted with corrected severity / wording
- **B2 — BLE radio handoff:** source-level safety/architecture gap is confirmed because Online OTA uses `stopBleRadio(false)`, which stops advertising without BLE deinitialization. This violates the project's explicit single-radio handoff contract. **Not proven:** that this alone caused the observed MCU restart, panic, or RF collision.
- **B3 — BLE disconnect advertising restart:** direct `BLEDevice::startAdvertising()` from `onDisconnect()` is a callback-context/reentrancy risk. The exact Core 3.3.7 implementation has not been runtime-validated here, so this is **P2 likely risk**, not a proven P1 crash/deadlock.
- **S1 — Peltier PWM remains logically/output-wise active across selector deadtime:** confirmed as an unsafe sequencing gap. However, the Gemini claim that this is the **proven electrical root cause** of the 9V->12V MCU restart is rejected. Source proves the hazard window; it does not prove brownout versus EMI, LDO collapse, wiring/transient behavior, or another mechanism without reset/rail/current evidence.
- **Radio wording:** the project contract is “BLE fully inactive before Wi-Fi starts”; that is the requirement. Do not overstate this as “ESP32-C3 cannot ever coexist with Wi-Fi/BLE” or infer a physical RF failure from source alone.

### Needs external/toolchain or hardware validation
- Exact availability/behavior of low-level `esp_reset_reason()` in the user's ArduinoDroid + official Arduino-ESP32 Core 3.3.7 environment has not been compile-verified. Upstream Arduino-ESP32 examples use `esp_reset_reason()`, while the current firmware intentionally avoids assuming a public `ESP.getResetReason()` API. Keep the reset telemetry change as a validation task, not an unverified source edit.
- Any exact electrical statement such as “36W inrush causes the ESP32-C3 brownout” remains **HARDWARE VALIDATION REQUIRED**. Controlled tests should capture reset reason, 3.3V rail behavior, and Peltier current around 9V->12V transitions.

### Rejected / not authoritative as stated
- “Firmware is absolutely proven to brownout/restart because of PWM during 9V->12V” — **rejected as overclaim**; retain as the leading electrical hypothesis until measured.
- “BLE callback API call is definitively an interrupt-context crash” — **rejected**; classify as callback-task/reentrancy risk unless Core 3.3.7 runtime evidence proves otherwise.
- “ISRG Root X1 is the definitive GitHub CA” — **not accepted as a final implementation detail** without validating the intended hostname/certificate-chain strategy. The source-level requirement is CA/server verification instead of `setInsecure()`.

### Safe implementation priority after this reconciliation
1. Fix OTA DOWNLOAD dispatcher starvation.
2. Close the voltage/Peltier interlock and define the exact PWM behavior across selector deadtime without violating the frozen rule that voltage changes do not restart the 5s soft-start.
3. Add immediate `!ntcValid` rejection before selector activation.
4. Harden Online OTA BLE->Wi-Fi handoff and Wi-Fi retry settle.
5. Move BLE re-advertising out of callback context.
6. Fix ADAPTIVE:OFF ACK semantics and battery hysteresis.
7. Add the required rapid-rise thermal protection.
8. Harden OTA authentication/version rollback and observability.
9. Compile with the exact ArduinoDroid/Core 3.3.7 toolchain, generate BIN, then perform staged hardware validation.

### Validation boundary
No functional firmware/App source was changed by this Gemini reconciliation. No firmware compile, BIN generation, Firebase promotion, or physical validation was performed.

## 2026-10-04 — V3.9 POST-PATCH STATIC AUDIT
- Active source: `firmware/JEXFYZ-V3.9.ino`, blob `bf85b50e0a8cab22e5d66ef09ee84d6692cee009`.
- Static invariants: braces 574/574; parentheses 2112/2112; executable `delay()` 0; timing `while()` waits 0; active `stopBleRadio(false)` call count 0; DOC-CONTRACT blocks 137.
- V3.8 source blockers addressed: OTA starvation, voltage/Peltier transition interleaving, NTC deadtime race, BLE handoff, Wi-Fi retry settle, callback advertising context, battery chatter, ADAPTIVE:OFF ACK, rapid-rise safety, anti-rollback, reset reason, Local OTA image magic.
- Security/architecture still open: Online OTA TLS currently uses `setInsecure()`; BLE command authentication; synchronous HTTP preparation; post-boot rollback health policy.
- Electrical causality remains unverified: V3.9 removes the confirmed PWM/selector sequencing hazard but does not prove whether the historical 9V->12V restart was brownout, EMI, regulator collapse, or another mechanism.
- Validation boundary: static repository audit only.


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
