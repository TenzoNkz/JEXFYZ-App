## 2026-10-04 — GEMINI FULL PRE-FLASH FORENSIC AUDIT

- [GEMINI VERDICT] Exact V4.0 source blob `0566105383a889912e5e756b0b9f265e5fcf0264`: **SAFE TO FLASH LOCAL OTA** source-level.
- [FINDING] No P0/P1 blockers identified. P2: BLE TX FIFO overflow can drop newest messages under heavy pressure, potentially affecting ACK/UI synchronization.
- [ONLINE OTA] Gemini considers the current `setInsecure()` path more compatible than the removed CA-bundle path, but real Online OTA success remains unverified.
- [LOCAL OTA] No Local OTA defect was identified; Local OTA remains frozen/protected.
- [RECONCILIATION] Gemini's text describing a BLUE indicator after download is outdated for the current exact source. The current patch removed that intermediate BLUE transition; final GREEN remains after successful `Update.end()`.
- [UNVERIFIED] Compile/Core 3.3.7, BIN generation, physical flash, rail/current response, and real Online OTA runtime are still unverified.

## 2026-10-04 — V4.0 ONLINE OTA GEMINI PATCH EXECUTED

- Applied the supplied Gemini patch against source blob `415346ece09f4af33f907b2077140ccfc45c357b`.
- Replaced the custom certificate-bundle client with plain `WiFiClientSecure cloudClient` + `setInsecure()`; this is an intentional compatibility trade-off, not authenticated server TLS.
- Removed intermediate GREEN after GitHub/HTTP preparation and intermediate BLUE after download completion.
- Preserved Wi-Fi-success BLUE, YELLOW 20/40/60/80/100 milestones, final GREEN, and RED failure/recovery.
- Local OTA source is unchanged and remains protected.
- Current V4.0 source blob: `0566105383a889912e5e756b0b9f265e5fcf0264`.
- Compile/BIN/Firebase/physical validation remains pending; fresh Assistant + Gemini review is required before flashing.

## 2026-10-04 — GEMINI PATCH-ONLY HANDOFF PROTOCOL

- [WORKFLOW] Gemini is to receive the current .ino file directly from the user and return only the minimal Online OTA patch as OLD → NEW blocks.
- [NO FULL FILE] Gemini must not return the complete .ino.
- [EXECUTION] The assistant applies Gemini's patch during the following `@Thinking Eksekusi Full!`, after exact OLD-block matching against the repository source.
- [SCOPE] Current Online OTA issue: indicator LED does not visibly blink during hardware testing.
- [PROTECTED] Local OTA remains frozen and must not be changed as part of this fix.
- [CURRENT PRIORITY] Simple Online OTA GitHub download/flash/restart flow; CA-bundle/custom-CA complexity is not required.

## 2026-10-04 — ONLINE OTA SIMPLICITY REQUIREMENT

- [USER REQUIREMENT] Online OTA prioritizes successful GitHub download/flash over TLS certificate security.
- [APPROACH] Remove CA-bundle/custom-CA complexity from Online OTA; simple `WiFiClientSecure` + `setInsecure()` is acceptable when applying the user's requested fix.
- [URL] Online OTA binary source remains the user's JE X FYZ firmware repository URL.
- [SUCCESS CRITERIA] Wi-Fi connects, GitHub `.bin` downloads, OTA partition writes/finalizes, success indicator displays, and device restarts into the new firmware.
- [PROTECTED] Local OTA is frozen/proven working and must not be changed as part of Online OTA fixes.

## 2026-10-04 — ONLINE OTA INDICATOR BUG REPORT

- [RUNTIME OBSERVATION] V4.0 Online OTA was tested and the expected OTA LED indicator blink was not visible.
- [SOURCE OBSERVED] Online OTA has indicator state-machine calls for Wi-Fi success/download/finalize/result paths, so the hardware observation requires runtime/state interaction analysis rather than assuming the indicator code is absent.
- [PENDING] User will provide Gemini's independent diagnosis/fix for the Online OTA indicator.
- [RULE] Apply Gemini's supplied fix within the Online OTA scope only. Local OTA must remain unchanged unless a separately reproduced Local OTA defect occurs.

## 2026-10-04 — V4.0 ARITY/COMPILE FIX

- [ERROR] ArduinoDroid reported `no matching function for call to 'batteryZoneFor'` at the live-zone calculation in `completeVoltageTransition()`.
- [ROOT CAUSE] `batteryZoneFor()` requires `(float temperature, Voltage referenceVoltage)` but one call passed only `batteryC`.
- [FIX] Updated to `batteryZoneFor(batteryC, currentVoltage)`.
- [SOURCE] New V4.0 blob: `415346ece09f4af33f907b2077140ccfc45c357b`.
- [AUDIT] All `batteryZoneFor` call sites now use the two-argument signature; no one-argument stale call remains.
- [GATE] Because the functional source blob changed, prior Gemini + Assistant approval is superseded and must be repeated on the exact new blob.

## 2026-10-04 — V4.0 GEMINI + ASSISTANT DUAL-PARTY REVIEW

- [GEMINI VERDICT] Exact V4.0 blob `b2a77fadeaa154412850d34c82b0bb78ef108bae`: **SAFE TO FLASH**.
- [ASSISTANT VERDICT] Independently reviewed the exact same blob and agrees: **SAFE TO FLASH**.
- [GATE OPEN] Both parties agree, satisfying the user's mandatory two-party requirement.
- [SCOPE] This opens the gate to the next controlled phase: ArduinoDroid/Core 3.3.7 compile → BIN generation → staged physical validation.
- [NOT CLAIMED] Compilation, BIN integrity, Firebase publication, or physical device validation has not yet succeeded merely from this review.
- [VERIFIED] P0 selector/load sequencing hardening and P1 Online OTA TLS trust hardening remain present.

## 2026-10-04 — EXECUTION FULL / FIRMWARE V4.0 P0+P1 HARDENING

### Source/version
- [COMMITTED] Firmware advanced V3.9 → V4.0.
- [CURRENT] Active source: `firmware/JEXFYZ-V4.0.ino`.
- [CURRENT] Active source blob: `b2a77fadeaa154412850d34c82b0bb78ef108bae`.
- Source creation commit: `43b6e3dfc49f114aba49c73762a9bdc4822d30de`.
- V3.9 retirement commit: `e743b3b84e1a603c64747936242d1d44ee1b7746`.

### P0 — selector/rail stabilization
- Added `PELTIER_RAIL_STABILIZE_MS = 300` as the initial cooperative post-selector stabilization interval.
- After a validated 9V/12V selector activation, `peltierRailStabilizing` holds physical Peltier PWM at 0% until the stabilization deadline.
- Logical `peltierOn` remains unchanged, and `peltierSoftStartAtMs` is not reset. Therefore voltage changes do not manufacture a new OFF→ON soft-start event.
- 5V destination does not arm the post-selector rail-stabilization state because no 9V/12V rail is being activated.
- The 300 ms value is an engineering starting point and still requires physical rail/current validation; it is not claimed as a universal electrical constant.

### P1 — Online OTA TLS trust
- Removed `cloudClient.setInsecure()`.
- Added `JexTrustedWiFiClientSecure`, which enables the ESP32 certificate-bundle attach hook through the protected Core 3.3.7 `NetworkClientSecure` state.
- Verified against the Arduino-ESP32 **3.3.7** upstream source that the library provides `attach_ssl_certificate_bundle(...)`, `esp_crt_bundle_attach`, and the `_use_ca_bundle` path used during TLS setup.
- This implementation intentionally uses the bundled trust store instead of guessing/pinning a GitHub leaf/root certificate.
- Exact ArduinoDroid/Core 3.3.7 compile compatibility remains to be proven locally.

### Full affected static audit
- Source lines: 5351.
- Braces: 581/581.
- Parentheses: 2123/2123.
- Executable `delay()`: 0.
- Timing `while()`: 0.
- `setInsecure()`: 0.
- `stopBleRadio(false)`: 0.
- `FW_VERSION = V4.0`: 1.
- Stale V3.9 literals in active source: 0.
- DOC-CONTRACT blocks: 137.
- Existing V3.9 hardening remains present (NTC gate, Peltier transition interlock, rapid-rise latch, battery hysteresis, anti-rollback, Local OTA magic, callback-safe BLE recovery, full BLE teardown, OTA dispatcher, reset diagnostics).

### Validation boundary
- [VERIFIED SOURCE/STATIC] P0 and P1 source changes are present in the active V4.0 blob.
- [UNVERIFIED] ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile/link.
- [UNVERIFIED] BIN generation and checksum.
- [UNVERIFIED] Firebase promotion.
- [UNVERIFIED] Physical flash/device validation.
- [UNVERIFIED] Oscilloscope/current/rail evidence and proof of the historical 9V→12V reset mechanism.
- [GATE CLOSED] V4.0 requires the same independent Assistant + Gemini review before update/flash.
- [NO APP BUILD] App Build #50 remains the current App baseline.

## 2026-10-04 — CHAT-LIMIT HANDOVER CHECKPOINT

- Current chat is being handed over because the context limit is near.
- README.md already contains the detailed copy-ready new-chat prompt and is the mandatory first-read entry point.
- HANDOVER.md is the portable handoff artifact; the embedded prompt remains the required continuation prompt.
- Current firmware remains V3.7; active source is `firmware/JEXFYZ-V3.7.ino`.
- Latest verified App Build remains #50; no App Build was triggered by this handover checkpoint.
- Firmware V3.7 ArduinoDroid/Core 3.3.7 compile, BIN publication, Firebase promotion, and physical validation remain unperformed.
- Next chat must perform the full repository memory preflight before any action.

## 2026-10-04 — EXECUTION FULL / MEMORY FOUNDATION BOOTSTRAP

- Repository memory now has a dedicated current-state snapshot at `PROJECT_STATE.md`, plus README operating instructions, build checkpoints, changelog, and portable handover.
- Firmware source remains `firmware/JEXFYZ-V3.7.ino`; this execution did not change firmware behavior or version.
- The mandatory memory preflight applies even when the task is App Build-related and the active subchat is separate from the firmware discussion chat.
- Firmware compile/BIN/device validation remains separate from source/documentation validation.
- No firmware BIN promotion, Firebase update, dedicated binary-repository update, or physical validation was performed by this memory-system execution.

## 2026-10-04 — EXECUTION FULL / PERMANENT MEMORY CONTINUITY SYSTEM

- Added the project-wide continuity documents: `README.md`, `PROJECT_STATE.md`, `BUILD_NOTES.md`, `CHANGELOG.md`, and `HANDOVER.md`.
- Firmware continuity remains source-first: current source must be inspected after the memory preflight before any firmware conclusion or cross-layer App Build decision.
- App Build memory checkpoints must not be interpreted as firmware compile/BIN/device validation.
- Firmware validation boundaries for V3.7 remain unchanged: ArduinoDroid/Core 3.3.7 compile, BIN generation, Firebase promotion, and physical validation are still unperformed.
- No functional firmware behavior was changed by this continuity-system execution.

## 2026-10-04 — PROCESS CONTINUITY / CROSS-LAYER MEMORY PREFLIGHT

- Firmware context must be re-read before every JE X FYZ action that can intersect firmware behavior, including App Build analysis when the App embeds, references, or releases firmware-related metadata.
- Build App and Firmware are separate validation layers, but the memory preflight is project-wide: the current Firmware notes remain part of the mandatory continuity read.
- A Build App result must never overwrite or imply firmware compile/BIN/device validation status. If a build changes firmware-relevant metadata, that exact cross-layer change must be recorded explicitly.
- Persistent project memory is the handoff mechanism between separate subchats; chat history alone is not sufficient.

## 2026-10-04 — DOCUMENTATION PASS / V3.7 FIRMWARE ANALYSIS MAP

- Added `firmware/FIRMWARE_ANALYSIS.md` as the repository-level architecture and safety map for V3.7.
- The analysis covers hardware mapping, authority order, Voltage/Adaptive/Hotside/Battery state machines, Peltier PWM rules, BLE/radio ownership, OTA flow, LED ownership, persistence, timing, and validation boundaries.
- Critical source functions are indexed with current source line numbers.
- The functional firmware version remains **V3.7**; no runtime logic was changed by the analysis-document addition.
- Analysis document commit: `e2ab50edeb428e95ce21a9b5a54e169d904ade84`.
- Physical compilation, BIN generation, Firebase promotion, dedicated binary repository update, and hardware validation remain unperformed.

## 2026-10-04 — DISCUSSION / HARDWARE TEST STAGE PAUSED

- User confirmed that the next phase is real hardware/device validation.
- No firmware source change was made in this discussion.
- When results return, capture exact ESP32 board/binary/version, expected vs observed behavior, evidence, pass/fail, and remaining electrical/thermal/BLE/OTA risks.
- Do not infer successful firmware compilation, BIN publication, or physical safety from source/static audit alone.

# JE X FYZ — FIRMWARE NOTES

## AUTHORITATIVE MEMORY CORE — V3.8 — 2026-10-04

### Current source of truth
- Repository: `TenzoNkz/JEXFYZ-App`
- Active firmware source: `firmware/JEXFYZ-V3.8.ino`
- Current firmware version: `V3.8`
- Current source blob: `2fbff3656bc037846124806fb390022f85146845`
- Documentation/cleanup commit: `ef4519b8f4d032a6d2d1f84101785c05b8a89cfa`
- The dedicated `TenzoNkz/JEXFYZ-Firmware` repository remains binary-only and was not changed by this execution.

### Hardware / I/O contract
- Board: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- Arduino Standard + official Arduino-ESP32 Core 3.3.7.
- GPIO0 = NTC, GPIO1 = Touch, GPIO3 = 12 V selector, GPIO4 = 9 V selector.
- GPIO5 = Peltier, GPIO6 = Fan, GPIO7 = WS2812.
- App BLE tokens remain logical: `FAN:*` controls Fan and `PELTIER:*` controls Peltier.
- Fan PWM: 25 kHz, 8-bit, 50–100%.
- Peltier PWM: 20 kHz, 8-bit, 5 s soft-start.
- NTC: fixed 10 kΩ / 10 kΩ divider model, beta 3950, 12-bit ADC, 11 dB attenuation, sampled every 1 s.

### Voltage / safety contract
- Physical selector deadtime: 200 ms; shared post-transition voltage guard: 1 s.
- Hotside Limit is the universal thermal boundary for Manual Voltage, Adaptive HOTSIDE, and HOTSIDE_BATTERY.
- Manual Hotside event: force 5 V, Fan 100% ON, Peltier OFF safety latch; normal voltage above 5 V is rejected while hot.
- Adaptive Hotside event: immediate one-level down, reached voltage removed from the temporary Adaptive ceiling, Peltier OFF for 5 s after the physical down-step, then resume only when safe.
- At 5 V while still hot, Adaptive turns OFF.
- Hotside event indicator: red blink, 5 s duration, non-blocking 250 ms phase.

### Adaptive contract
- Adaptive startup and shutdown both return hardware to 5 V first.
- Adaptive keeps Voltage/Control/Temperature user control locked while active.
- HOTSIDE uses physical NTC Hotside temperature for normal voltage decisions.
- HOTSIDE_BATTERY uses phone Battery temperature for normal voltage decisions inside the Hotside ceiling.
- Invalid/disconnected Battery source in HOTSIDE_BATTERY falls back to HOTSIDE runtime behavior without rewriting the configured profile.
- Battery mapping is direct-zone: below BATT5 → 5 V; BATT5 through below BATT12 → 9 V; at/above BATT12 → 12 V.
- Battery Adaptive moves one voltage step at a time and continuously re-evaluates the live target.

### Peltier PWM contract — V3.8
- Peltier OFF → ON always starts the 5 s soft-start.
- Voltage transitions do not start or restart the 5 s soft-start.
- Voltage changes preserve the existing Peltier PWM state.
- A genuine Peltier OFF → ON transition starts the 5 s soft-start.
- Safety authority still overrides the PWM request when Peltier cannot safely run.

### OTA / radio contract
- Wi-Fi and BLE are never intentionally operated concurrently; BLE starts only after Wi-Fi is OFF and settled.
- Boot SoftAP and Online OTA own the radio through cooperative state machines.
- OTA safe outputs are Fan/Peltier OFF and selector state 5 V.
- Online OTA accepts only the approved JE X FYZ GitHub firmware repository and `.bin` files.
- OTA runtime uses non-blocking timing; executable `delay()` and timing `while()` waits are prohibited.

### Validation boundary
- Static/model source audit: completed.
- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile: NOT performed in this environment.
- BIN generation/publication: NOT performed.
- Firebase firmware metadata promotion: NOT performed.
- Dedicated binary repository update: NOT performed.
- Physical ESP32 electrical/thermal/BLE/OTA validation: NOT performed.
- App Build: NOT triggered by this firmware documentation execution.

---

## 2026-10-04 — EXECUTION FULL / FIRMWARE V3.7 PELTIER PWM SOFT-START RULE

### Source/version
- Functional firmware revision advanced **V3.6 → V3.7**.
- Active source: `firmware/JEXFYZ-V3.7.ino`.
- Superseded `firmware/JEXFYZ-V3.6.ino` was retired from the active source tree.
- Source is kept in the App repository under `firmware/`; the dedicated firmware repository remains binary-only and is not modified by this execution.

### Implemented Peltier PWM behavior
- Peltier PWM hardware remains **20 kHz / 8-bit** with the existing **5-second soft-start ramp**.
- Every **upward voltage transition** now explicitly restarts the Peltier soft-start when Peltier is ON:
  - 5V → 9V: soft-start.
  - 9V → 12V: soft-start.
  - Any other upward one-step transition: soft-start.
- **Downward voltage transitions never restart Peltier soft-start**:
  - 12V → 9V: no soft-start restart.
  - 9V → 5V: no soft-start restart.
- A genuine **Peltier OFF → ON** transition always starts the soft-start through the existing `applyCoolingOutputs()` state transition.
- Repeated ON application while Peltier is already ON does **not** restart the ramp.
- Hotside safety down-steps therefore do not create a PWM ramp solely because voltage decreases.
- When Hotside cooldown later turns Peltier back ON, that is a genuine OFF → ON transition and therefore correctly starts the soft-start.

### Implementation boundary
- The soft-start trigger is applied only after the voltage transition physically completes and the final voltage state is established.
- The trigger is based on the actual transition direction (`currentVoltage > previousVoltage`), so Manual, Touch, Adaptive, and Battery-originated upward transitions share the same rule.
- Existing 200 ms selector deadtime, voltage guard/source tracking, Hotside safety authority, Adaptive ceiling, and no-blocking-timing architecture are unchanged.

### Static validation
- `FW_VERSION` = V3.7.
- Active V3.7 source contains the new upward-transition soft-start trigger.
- Superseded V3.6 source path removed from active tree.
- Braces: 550/550.
- Parentheses: 2041/2041.
- Executable `delay(...)` calls: 0.
- Timing `while(...)` patterns: 0.
- Peltier soft-start call paths remain limited to the existing OFF → ON path plus the new voltage-rise path.
- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile: **NOT performed in this environment**.
- BIN generation/publication: **NOT performed**.
- Firebase firmware metadata: **NOT promoted**.
- Dedicated binary repository: **NOT modified**.
- Physical ESP32/Peltier thermal/electrical validation: **NOT performed**.
- App Build: **NOT triggered**.

### Commits
- V3.7 source creation: `83c900fd611be3fdb4f20a79b4cb5524121fda38`.
- V3.6 retirement: `8aa974eb2c2861e6362e0048cf2c10ae83faeff7`.

### Validation boundary
- Repository/source implementation and static checks are complete for V3.7.
- Hardware behavior remains pending ArduinoDroid/Core 3.3.7 compile plus real ESP32 testing.
  
## 2026-10-04 — EXECUTION FULL / FIRMWARE V3.6 UNIVERSAL HOTSIDE SAFETY + ADAPTIVE FLOW

### Source/version
- Functional firmware revision advanced **V3.5 → V3.6**.
- Active source: `firmware/JEXFYZ-V3.6.ino`.
- V3.5 is superseded by V3.6 after the deeper full regression found two safety/authority edge cases in the V3.5 implementation.
- Source commit: `03ede906a34a5e06082f2c9520a29687f0abd710`.
- V3.6 retains BLE/P1 UUIDs, logical FAN/PELTIER tokens, GPIO mapping, 200 ms selector deadtime, and no-delay runtime architecture.

### Implemented — universal Hotside limit
1. **One Hotside Limit for Manual + Adaptive**
   - The configured Hotside temperature limit is now the universal thermal safety boundary for Manual, Adaptive HOTSIDE, and Adaptive HOTSIDE_BATTERY.
2. **Manual Voltage safety**
   - When Hotside reaches the limit, Peltier is forced OFF and a manual Peltier safety latch is set.
   - Voltage is forcibly returned to **5V**.
   - Fan remains ON and is forced to **100%** during the safety condition.
   - Peltier remains OFF after the temperature recovers until the user explicitly turns Peltier ON from a valid manual control path.
   - Manual Peltier ON is rejected while Hotside is still at/above the limit; the latch is released only by a safe explicit manual ON command.
   - Normal manual voltage requests above 5V are rejected while Hotside remains at/above the limit.
3. **Adaptive HOTSIDE**
   - Adaptive startup still forces the selector to 5V first.
   - Fan and Peltier are ON during normal Adaptive operation.
   - Upward Hotside-only movement is one level at a time with a **5-second rise dwell**.
   - When Hotside reaches the limit, voltage steps down immediately by one level without a pre-down delay.
   - The reached voltage is removed from the Adaptive ceiling for the current Adaptive session.
   - After the down-step physically completes, Peltier remains OFF for **5 seconds**, then may resume only if Hotside is safe.
   - Fan remains ON throughout.
   - If 5V itself is at/above the Hotside limit, Peltier stays OFF and **Adaptive immediately turns OFF**.
   - Adaptive OFF resets the temporary Hotside ceiling back to 12V.
4. **Adaptive HOTSIDE_BATTERY**
   - Hotside remains the higher-priority thermal ceiling.
   - Battery temperature continues to control the requested voltage only within the currently allowed Hotside ceiling.
   - A Hotside-triggered ceiling reduction therefore prevents Battery from selecting the blocked voltage.
   - If Battery data disappears, effective runtime control falls back to HOTSIDE behavior without rewriting the configured profile.
5. **Battery transition authority hardening**
   - If Battery data becomes invalid during a 200 ms Battery-originated selector deadtime, the stale Battery step is canceled and the current physical selector is restored instead of applying the stale target.
   - Hotside safety is also revalidated immediately before selector activation so a hot condition cannot allow a pending target above the safe endpoint.
6. **Hotside LED event**
   - Each Hotside protection event starts a dedicated **red LED blink for 5 seconds** using a non-blocking 250 ms phase.
   - The event indicator has LED ownership priority over the normal RGB/voltage indicator for its active window.
   - A continuous hot condition does not retrigger the same event every loop; a later re-entry/new protection event can trigger again.
7. **No blocking delay**
   - Runtime source contains no executable `delay()` calls and no timing `while` loop.
   - Main loop remains fast; timing is handled by state/timestamp checks.

### Static validation
- V3.6 version marker and versioned source path verified.
- V3.5 removed from the active source tree.
- Key function-definition duplication checks passed for voltage/safety/LED functions.
- Delimiters balanced.
- `delay(...)` count: 0.
- No timing `while(...)` loop detected.
- Source-level Hotside Manual, Adaptive, Battery-ceiling, 5-second Peltier cooldown, and 5-second red LED indicator paths verified.
- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile: **NOT performed in this environment**.
- BIN generation/publication: **NOT performed**.
- Firebase firmware metadata: **NOT promoted**.
- Dedicated binary repository: **NOT modified**.
- Physical ESP32 flash/thermal/selector/BLE/OTA validation: **NOT performed**.
- App Build: **NOT triggered**.

### Validation boundary
- Repository/source transformation and static/model review are complete for V3.6.
- Hardware behavior, exact selector electrical timing, Peltier thermal response, LED physical behavior, BLE runtime, and OTA runtime remain unverified until the firmware is compiled with Core 3.3.7 and tested on the real ESP32-C3 hardware.

## 2026-10-04 — CORRECTIVE EXECUTION FULL / FIRMWARE V3.4 EXACT-SOURCE AUDIT REPAIR

### Source/version
- Corrective implementation commit: `2182794cb98964a8a7432d0ea75587b44b508573`.
- The V3.3 post-commit exact-source audit found two helper blocks syntactically nested inside existing function bodies due to an insertion-placement error.
- Those placement errors are corrected here without changing the intended V3.3 feature behavior.
- Per mandatory firmware versioning, the corrected candidate advances **V3.3 → V3.4** and uses `firmware/JEXFYZ-V3.4.ino`.
- V3.3 is superseded immediately; it was never compiled, flashed, or promoted.

### Corrective validation
- `FW_VERSION` = V3.4; filename/version aligned.
- `adaptiveProfileText()` / `effectiveAdaptiveProfile()` are at global scope.
- Battery invalidation/TTL/fallback helpers are at global scope.
- Exactly one active `lowerVoltage()` definition and one `updateBatteryValidity()` implementation remain.
- Braces 523/523; parentheses 1978/1978.
- `delay(...)` calls: 0; timing `while (...)` loops: 0.
- Global-scope static-function-depth audit found no nested function definitions.
- No BIN/Firebase/dedicated-binary-repository update, physical validation, or App Build was performed.

### Validation boundary
- V3.4 is still uncompiled/unflashed. ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile remains the next validation layer.

## 2026-10-04 — EXECUTION FULL / FIRMWARE V3.3 ADAPTIVE FALLBACK + OTA PROGRESS + FULL NO-DELAY

### Source/version
- User issued `@Thinking Eksekusi Full!` after the V3.2 firmware discussion.
- Functional firmware revision advanced **V3.2 → V3.3**.
- Active source is `firmware/JEXFYZ-V3.3.ino`; V3.2 is retired from the active source tree.
- Existing BLE/P1 UUIDs, logical FAN/PELTIER tokens, GPIO mapping, Hotside safety authority, Battery direct-zone semantics, 200 ms selector deadtime, and shared 1-second Battery voltage dwell remain intact unless listed below.

### Implemented
1. **Adaptive profile behavior**
   - HOTSIDE-only Adaptive now completes its mandatory 5V startup handoff and then requests/resumes **12V** whenever Hotside is below the configured safety limit.
   - HOTSIDE-only does not use phone Battery temperature for normal voltage control.
   - HOTSIDE_BATTERY continues to use phone Battery temperature for normal voltage selection while physical NTC Hotside protection remains authoritative.
2. **Immediate Battery-loss fallback**
   - BLE disconnect raises a main-loop signal that immediately invalidates the phone Battery source.
   - Battery source timeout at 5 seconds uses the same invalidation path when BLE remains connected but Battery updates stop.
   - When Adaptive is configured as HOTSIDE_BATTERY and Battery is unavailable, the effective runtime profile becomes HOTSIDE and the controller resumes toward 12V when Hotside is safe.
   - The configured profile is not rewritten/persisted. A fresh PHONE:BT value restores the effective HOTSIDE_BATTERY runtime profile.
3. **LED/Fan ranges**
   - Fan remains 50–100% with the existing 10% step.
   - LED brightness is now strictly 1–100%; stored legacy 0% is clamped to 1%.
4. **Online OTA progress**
   - Online firmware download emits a one-shot **yellow flash at 20%, 40%, 60%, 80%, and 100%**, once per milestone per OTA session.
   - Each flash is 200 ms and is driven by a nonblocking state machine, not a delay.
   - Existing OTA Wi-Fi/green/blue/red indicators remain in place.
5. **Full no-delay / cooperative scheduling**
   - Removed timing `while (...)` waits from BLE shutdown, Wi-Fi-off settling, Local OTA failure handoff, and Online OTA firmware download.
   - Online download now performs one bounded 1024-byte stream read/write per main-loop pass instead of a long inner download loop.
   - Main loop is not globally changed to a 100 ms tick; it remains fast/nonblocking and uses per-task state/timers where needed.
6. **Full-audit source repairs**
   - Added the missing `updateBatteryValidity()` implementation for the existing 5-second Battery TTL call.
   - Removed a duplicate active `lowerVoltage()` definition that would create a compile error.
7. **Not guessed**
   - #118 and #124 were not reinterpreted because their original numbered descriptions were not present in the authoritative notes/source available during this execution.

### Static validation
- V3.3 marker and versioned filename content verified.
- Braces: 523/523.
- Parentheses: 1978/1978.
- Active `lowerVoltage()` definitions: 1.
- Active `updateBatteryValidity()` definitions: 1.
- `delay(...)` calls: 0.
- Timing `while (...)` loops: 0.
- Battery disconnect signal, Battery fallback, brightness 1–100, and OTA milestone state present.
- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile: **NOT performed here**.
- BIN generation/publication: **NOT performed**.
- Firebase firmware metadata: **NOT promoted**.
- Dedicated binary repository: **NOT modified**.
- Physical ESP32 flash/runtime/thermal/BLE/OTA validation: **NOT performed**.
- App Build: **NOT triggered**.

### Validation boundary
- This execution proves repository/source transformation and static structural checks only. V3.3 still needs ArduinoDroid/Core 3.3.7 compilation and real-device validation before binary/OTA promotion.

## 2026-10-04 — FOLLOW-UP EXECUTION FULL / FIRMWARE V3.2 BATTERY TRANSITION SOURCE ISOLATION

### Source/version
- Full V3.1 regression identified one additional authority-boundary edge case: deadtime revalidation needed to distinguish Battery Adaptive transitions from higher-priority Safety/HOTSTEP and other voltage requests.
- Functional firmware revision advanced **V3.1 → V3.2** to isolate the Battery-specific retarget/cancel logic.
- Active continuity source is `firmware/JEXFYZ-V3.2.ino`.
- Superseded `firmware/JEXFYZ-V3.1.ino` was removed from the active source tree.
- Corrective source commit: 536877e644731e3ed0a64b87508c18de9270eede.
- No firmware BIN, Firebase metadata, dedicated binary-repository update, App Build, or physical device validation was performed.

### Corrective implementation
- Added `voltageTransitionSource` so every in-flight voltage transition records its originating request source.
- The 200 ms deadtime revalidation/cancel/retarget block now runs **only** when the in-flight transition source is `BATTERY`.
- Higher-authority `SAFETY`, `HOTSTEP`, `ADAPTIVE`, manual, and touch transitions are no longer eligible for Battery Adaptive retargeting.
- Battery Adaptive still has no FIFO queue, no hysteresis, and no stale target after the deadtime boundary.
- The shared 1-second dwell remains measured from the completion/cancellation boundary, with Battery up/down using `bypassGuard=false`.
- No change was made to the Hotside safety authority, Adaptive ceiling, 200 ms deadtime, one-step movement, BLE protocol, GPIO mapping, or OTA architecture.

### Full regression rerun
- V3.2 version and active filename verified.
- V3.1 retired from active tree.
- No obsolete Battery hysteresis/stable-zone/pending-state symbols remain.
- Battery boundary logic remains direct: below BATT5 → 5V; BATT5 through below BATT12 → 9V; at/above BATT12 → 12V.
- Battery Adaptive remains one-step only.
- Battery up/down remains symmetric through the shared 1-second guard.
- Battery in-flight deadtime target is revalidated only for Battery-originated transitions.
- Safety/HOTSTEP transition cannot be overwritten by Battery revalidation.
- Braces and parentheses are balanced.
- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile was **NOT performed in this environment**.
- BIN generation/publication was **NOT performed**.
- Physical ESP32 flash/runtime validation was **NOT performed**.
- Firebase firmware metadata was **NOT promoted**.
- App Build was **NOT triggered**.

### Validation boundary
- Repository/source implementation and static/behavioral-model regression are complete for this execution sequence. Physical selector behavior, supply stability, thermal behavior, BLE runtime, OTA runtime, and actual compile compatibility remain unverified until the Core 3.3.7 build and hardware tests are performed.

## 2026-10-04 — FOLLOW-UP EXECUTION FULL / FIRMWARE V3.1 BATTERY DEADTIME REVALIDATION

### Source/version
- During the full regression of V3.0, an edge case was identified: Battery Adaptive target could change during the 200 ms selector deadtime while `voltageTransition` was already in flight.
- Functional firmware revision advanced **V3.0 → V3.1** to correct that edge case before firmware validation proceeds.
- Active continuity source is `firmware/JEXFYZ-V3.1.ino`.
- Superseded `firmware/JEXFYZ-V3.0.ino` was removed from the active source tree.
- Corrective source commit: eaa8bdb55f1b47d29ae27b37a374463bd2a8c311.
- No firmware BIN, Firebase metadata, dedicated binary-repository update, App Build, or physical device validation was performed.

### Corrective implementation
- `completeVoltageTransition()` now re-evaluates the live Battery Adaptive target immediately before selector activation, after the full 200 ms deadtime.
- If the live Battery target has returned to the current voltage, the stale in-flight step is canceled and the current selector is restored instead of applying the stale target.
- If the live target changed direction, the in-flight pending step is replaced with the correct one-step target from the current physical voltage.
- A canceled deadtime attempt still arms the shared 1-second dwell because both selectors were physically de-asserted for the deadtime; this prevents immediate re-attempt chatter.
- The 1-second dwell still starts from a completed physical voltage-transition boundary, and Battery Adaptive up/down requests remain on the same guarded path with `bypassGuard=false`.
- No FIFO Battery command queue was introduced.

### Full regression rerun
- V3.1 source version/file naming verified.
- No obsolete hysteresis, stable-zone, Battery pending-state, or old Adaptive-step-delay symbols remain.
- Direct threshold mapping remains:
  - below BATT5 → 5V
  - BATT5 through below BATT12 → 9V
  - at/above BATT12 → 12V
- One-step movement remains 5V→9V→12V and 12V→9V→5V.
- 1-second shared voltage dwell remains symmetric for Battery up/down.
- 200 ms selector deadtime remains intact.
- Stale target protection is now covered both before the next 1-second step and at the end of an in-flight 200 ms deadtime.
- Braces and parentheses are balanced.
- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile was **NOT performed in this environment**.
- BIN generation/publication was **NOT performed**.
- Physical ESP32 flash/runtime validation was **NOT performed**.
- Firebase firmware metadata was **NOT promoted**.
- App Build was **NOT triggered**.

### Validation boundary
- This execution establishes source implementation and static/behavioral-model regression only. Hardware switching, selector/relay behavior, supply droop, Fan/Peltier thermal behavior, BLE runtime, OTA runtime, and physical safety remain unverified until the firmware is compiled and tested on the real ESP32 hardware.

## 2026-10-04 — EXECUTION FULL / FIRMWARE V3.0 BATTERY ADAPTIVE NO-HYSTERESIS + UNIFIED VOLTAGE DWELL

### Source/version
- User issued `@Thinking Eksekusi Full!` after Gemini's Battery Adaptive audit.
- Functional firmware revision advanced **V2.9 → V3.0** because Battery Adaptive voltage-control semantics changed.
- Active continuity source is `firmware/JEXFYZ-V3.0.ino`.
- Superseded `firmware/JEXFYZ-V2.9.ino` was removed from the active source tree.
- Firmware source implementation commit: 38dc74ca92833ee3a6c8b7a67b0ecccf66e27025.
- No firmware BIN, Firebase metadata, dedicated binary-repository update, App Build, or physical device validation was performed.

### Implemented changes
1. **Battery Adaptive temperature mapping**
   - Removed the 1.0°C Battery hysteresis completely.
   - Removed `batteryZoneForStable()`, `lastBatteryZone`, and the Adaptive Battery pending-state/timer variables that existed only around the old hysteresis/delayed-command model.
   - Battery zone is now evaluated directly from the live Battery temperature:
     - below `battery5Limit` → 5V;
     - `battery5Limit <= temperature < battery12Limit` → 9V;
     - at/above `battery12Limit` → 12V.
   - Boundary equality is therefore immediate: BATT5 exactly → 9V; BATT12 exactly → 12V.
   - 9V remains a real operating level.

2. **Continuous Battery Adaptive evaluation**
   - Removed the separate Battery up/down delayed execution queues.
   - `evaluateAdaptiveBattery()` now calculates the live desired voltage every loop, clamps it to `adaptiveCeiling`, and selects exactly one higher/lower voltage step toward that current target.
   - There is no FIFO/stale Battery command. If the Battery target returns to the current physical voltage before a step is allowed, no transition is executed.
   - Large temperature jumps still move only one level per physical transition: 5V→9V→12V or 12V→9V→5V.

3. **Unified voltage hardware dwell**
   - Battery Adaptive up and down requests now both use the shared voltage guard; Battery down no longer bypasses the guard.
   - `requestVoltage()` no longer timestamps the 1-second guard when a request is created.
   - The shared 1-second voltage dwell now starts when a physical voltage transition actually completes, after the existing 200 ms selector deadtime and target-selector activation.
   - The completed-transition timestamp is stored in `lastVoltageTransitionCompleteMs`.
   - Existing explicit `bypassGuard=true` remains available only for higher-authority safety/Adaptive startup paths that must be able to force a voltage change; Battery Adaptive always uses the guarded path.

### Full regression checks completed
- Source version literal = V3.0.
- Active source filename = `JEXFYZ-V3.0.ino`.
- V2.9 source file retired from active tree.
- No retired Battery hysteresis/stable-zone/pending-state terms remain in active V3.0 source.
- Direct threshold semantics verified in source: `T < BATT5` → 5V; `T < BATT12` → 9V; otherwise 12V.
- Battery Adaptive physical step call is guarded with `bypassGuard=false`.
- Voltage guard timestamp is written only on completed physical transition.
- Braces and parentheses are balanced.
- Behavioral model cross-checks were performed for the agreed boundary, one-step, no-stale-target, and rate-limit scenarios.
- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile was **NOT performed in this environment**.
- BIN generation/publication was **NOT performed**.
- Physical ESP32 flash/runtime validation was **NOT performed**.
- Firebase firmware metadata was **NOT promoted**.
- App Build was **NOT triggered**.

### Validation boundary
- This execution proves repository/source transformation plus static/behavioral model checks only.
- It does not prove actual selector timing, supply stability, Fan/Peltier behavior, thermal behavior, BLE runtime, OTA runtime, or physical switching safety on the ESP32 hardware.

## 2026-10-03 — EXECUTION / FIRMWARE V2.9 TOUCH + CONTROL CLEANUP + OTA CAP

### Source/version
- Implemented the approved V2.7 audit items in the firmware continuity source.
- Intermediate V2.8 source commit ed5502fcfc626b0261d391babf7784bdfed2462a was immediately superseded because the final cross-check preserved the accepted Touch Adaptive-OFF behavior required by #42/#57.
- Active continuity source is firmware/JEXFYZ-V2.9.ino.
- Active source commit: 5254ac4112aba63429ee075497f165d253541649.
- Functional version is V2.9; no BIN, Firebase metadata, or physical device state was changed.

### Implemented changes
1. TOUCH
   - Removed the OneButton dependency and its 50 ms debounce/callback path.
   - Replaced it with a deterministic non-blocking state machine in the main loop.
   - Tap press duration is limited to 500 ms.
   - The decision window is 500 ms from the first completed tap.
   - 1 tap resolves to the next manual voltage level 5V->9V->12V->5V.
   - 2 taps resolve to RGB ON/OFF.
   - 3 or more taps inside the 500 ms decision window cancel with no action; the sequence cannot fall through into a single/double action.
   - 5-second hold toggles Fan/Peltier together when Adaptive is OFF, while existing safety remains authoritative.
   - When Adaptive is ON, a 5-second hold preserves the accepted Adaptive-OFF path and its existing indicator rather than bypassing the Fan/Peltier lock.

2. Per-voltage LED color cleanup
   - Removed user-configurable V5/V9/V12 color variables and persistence.
   - Removed V5COLOR/V9COLOR/V12COLOR command handlers, voltage-color reset handling, and COLOR_5V/COLOR_9V/COLOR_12V telemetry.
   - Fixed voltage-indicator colors remain internal firmware constants: 5V red, 9V green, 12V blue.
   - Legacy color preference keys are purged from Preferences on load so old configurable values are no longer retained.

3. Control anti-spam guard
   - Removed the generic user-control guard, its state, and its dispatch hook.
   - The existing 1-second voltage guard remains in requestVoltage(), so anti-spam/rate limiting applies only to actual VOLTAGE control paths.
   - No additional duplicate voltage guard was introduced.

4. OTA firmware-size guard
   - Reduced OTA_MAX_FIRMWARE_BYTES from 2 MiB to 1792 KiB (1.75 MiB / 1,835,008 bytes).
   - Existing ESP.getFreeSketchSpace() and Update.begin() checks remain authoritative in addition to the hard cap.
   - The repository still does not contain the exact partition CSV, so 1.75 MiB remains a conservative engineering target rather than a proven exact partition capacity.

### Validation completed
- Source transformation was validated before write and after final commit.
- Delimiter sanity check passed (balanced braces and parentheses).
- Obsolete OneButton object/API paths, generic guard paths, obsolete voltage-color command/telemetry paths, and old Touch LED-mode callback are absent from the active V2.9 source.
- Fixed voltage color constants and legacy Preferences cleanup are present.
- Active firmware version is V2.9 and source filename matches.
- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile was NOT performed in this environment.
- BIN generation/publication was NOT performed.
- Firebase firmware metadata was NOT promoted.
- Physical ESP32 flash/runtime validation was NOT performed.
- App Build was NOT triggered.

### Validation boundary
- This execution establishes the repository/source implementation state only. It does not prove Touch timing against the physical sensor, voltage-switch hardware behavior, Fan/Peltier PWM behavior, BLE runtime behavior, OTA update behavior, thermal behavior, or device safety under load.
- Because the App source was not changed in this execution, the next App implementation/build pass must remove any remaining UI/storage/protocol dependence on the retired per-voltage color controls before treating the App/Firmware contract as fully synchronized.

## 2026-10-03 — V2.7 AUDIT / GROUPS M–S USER DECISIONS

### M. PREFERENCES / STORAGE — #75–#77
- #75: remove configurable per-voltage LED color persistence because #53 removed the feature. Fixed voltage-indicator colors remain internal firmware behavior.
- #76: KEEP 10-second save debounce after settings changes.
- #77: KEEP runtime cooling state non-persistent; boot starts from safe baseline as defined by firmware.

### N. LOCAL OTA — #78–#84
- #78: KEEP boot AP/local OTA startup behavior.
- #79: KEEP 10-second initial AP timeout and 60-second hard limit.
- #80: KEEP local OTA client safety behavior: Fan/Peltier/LED OFF and BLE OFF while OTA client session owns the radio.
- #81: current 2 MB firmware hard cap is considered too close to the available OTA partition budget. Recommended new hard cap for discussion/execution is **1.75 MB (1792 KiB)**, while retaining the existing runtime `ESP.getFreeSketchSpace()` check and `Update.begin()` validation.
- Hardware/repository notes identify the board baseline as 4 MB flash with `no_fs`; the exact partition CSV is not present in the App repository, so 1.75 MB is recorded as a conservative engineering target rather than a proven exact partition capacity.
- #82–#84: KEEP local `.bin` validation, exact-size write/verify lifecycle, green success indication, and red failure/retry behavior.

### O. ONLINE OTA — #85–#94
- #85: KEEP Firebase/App metadata plane and GitHub binary plane.
- #86: KEEP fixed approved GitHub Raw URL restriction and `.bin` validation.
- #87: KEEP simple firmware-version comparison policy: a syntactically valid version that differs from the current version is accepted; do not add SHA linking or a downgrade-blocking rule under this current requirement.
- #88–#94: KEEP current radio handoff, bounded Wi-Fi retry, HTTP download, 0xE9 image validation, Update.h flash lifecycle, success restart, and failure BLE recovery behavior.

### P. OTA LED STATE MACHINE — #95
- #95: KEEP the current multi-stage OTA LED state machine exactly as already designed; user accepts the existing blue/green/red stage indicators.

### Q. OTA DIAGNOSTICS / NOTIFY — #96–#98
- #96: KEEP OTA diagnostic telemetry including stage/progress/error information.
- #97: KEEP one-shot OTA result event semantics.
- #98: KEEP one-boot OTA success handoff and event consumption behavior.

### R. RESET REASON — #99
- #99: KEEP the current Core 3.3.7 diagnostic sentinel behavior and App filtering semantics.

### S. SAFETY / STATE REASON — #100
- #100: KEEP current safety/state reason vocabulary and firmware safety authority.

### #81 ENGINEERING CLARIFICATION
- A hard 1.75 MB cap is intended to provide conservative headroom below the estimated 4 MB/no_fs OTA application budget, but it does NOT replace `ESP.getFreeSketchSpace()` or `Update.begin()` validation.
- 'Breathing room' here means flash/OTA partition margin; it is not runtime heap/RAM headroom. Runtime RAM safety continues to be governed by the existing heap diagnostics and normal firmware behavior.
- No source change was made in this audit discussion. #81 remains a recommendation until explicitly executed.

## 2026-10-02 — V2.7 AUDIT / GROUPS H–L USER DECISIONS

- #39: remove the 50 ms Touch debounce; tap window = 500 ms; single tap = voltage cycle; double tap = RGB ON/OFF; 3+ taps within the decision window = cancel; 5 s hold = Fan+Peltier toggle subject to safety.
- #40: KEEP.
- #41: corrected — double tap controls RGB ON/OFF, not LED mode.
- #42: KEEP.
- #43–#51: KEEP.
- #52: KEEP fixed voltage-indicator colors.
- #53: remove per-voltage configurable colors.
- #54–#57: KEEP.
- #58–#65: KEEP.
- #66: anti-spam guard applies only to VOLTAGE; do not add a generic control throttle. Avoid stacking duplicate voltage guards.
- #67–#69: KEEP.
- #70: not needed after #53; obsolete per-voltage color command/persistence/telemetry paths are cleanup items. Fixed indicator colors remain.
- #71–#74: KEEP.
- Current V2.7 source is unchanged by this discussion event.

## 2026-10-02 — V2.7 AUDIT / GROUPS H–L USER DECISIONS

### H. TOUCH SENSOR — #39–#42
- #39 is a functional firmware change to be implemented later:
  - remove the explicit 50 ms OneButton debounce setting;
  - tap timing limit remains 500 ms;
  - 1 tap = change voltage to the next manual level (5V→9V→12V→5V);
  - 2 taps = toggle RGB ON/OFF;
  - 3 taps or more within the tap/click interpretation window = cancel/fail with no action;
  - 5-second hold = toggle Fan + Peltier ON/OFF, subject to existing safety rules;
  - implementation should use a single multi-click decision path so 3+ taps cannot accidentally trigger the 1-tap or 2-tap action.
- #40 user status: KEEP / ACCEPTED.
- #41 replaces the old behavior: **2 taps no longer change LED mode; 2 taps toggle RGB ON/OFF**.
- #42 user status: KEEP / ACCEPTED.

### I. RGB / LED — #43–#51
- #43–#51 user status: KEEP / ACCEPTED.
- 8 NeoPixel hardware and the seven current LED render modes remain unchanged.

### J. VOLTAGE LED COLOR — #52–#57
- #52 user status: KEEP / ACCEPTED: the default voltage color identity remains part of the voltage indicator.
- #53: **REMOVE USER CONFIGURATION**. Custom voltage color settings are no longer used.
- Therefore V5COLOR/V9COLOR/V12COLOR commands, persistent voltage-color settings, and the dedicated voltage-color reset command are obsolete and should be removed in a later implementation pass.
- #54–#57 user status: KEEP / ACCEPTED.
- Important distinction: removing configurable voltage colors does **not** remove the default 5V/9V/12V color mapping needed by the voltage indicator. The defaults become fixed firmware behavior rather than user settings.

### K. BLE — #58–#66
- #58–#65 user status: KEEP / ACCEPTED.
- #66 user status: KEEP, with an important narrowing: the user-control spam guard is wanted **only for VOLTAGE** commands.
- Current V2.7 still routes all commands through the generic user-control guard, although its current guard interval is 0 ms and therefore does not currently delay anything. Later execution must narrow the guard to VOLTAGE only without changing other BLE command behavior.

### L. COMMAND CONTROL — #67–#74
- #67–#69 user status: KEEP / ACCEPTED.
- #70: voltage-color commands should be considered **NOT NEEDED** because #53 removes user-configurable voltage colors. Remove V5COLOR/V9COLOR/V12COLOR command handling in the same cleanup, together with obsolete voltage-color reset/persistence/telemetry paths, while preserving fixed default voltage colors for the voltage indicator.
- #71–#74 user status: KEEP / ACCEPTED.

### VALIDATION / IMPLEMENTATION STATUS
- These H–L decisions are discussion/audit decisions only; no firmware source was changed in this event.
- Current V2.7 source still contains the old Touch single/double mapping and voltage-color command/configuration paths; these are intentionally pending until an explicit execution command.
- No new firmware version is created by this discussion. The next functional firmware implementation must increment V2.7 to the next version before it is treated as an OTA candidate.

## 2026-10-02 — V2.7 EXECUTION / ADAPTIVE COOLING + BATTERY STEP CONTROL\n\n### Source/version\n- Functional firmware revision advanced **V2.6 → V2.7** because the approved Adaptive, Hotside safety, Battery hysteresis, and Battery control-logic changes affect firmware behavior.\n- Active continuity source is now `firmware/JEXFYZ-V2.7.ino`.\n- Superseded `firmware/JEXFYZ-V2.6.ino` was removed; the dedicated `TenzoNkz/JEXFYZ-Firmware` repository remains binary-only and was not modified.\n- Source creation commit: `79b2117f5331bc5b905358d6b07c43df7c443ae`.\n- V2.6 source retirement commit: `868a78090372331d3d7f3052763147f56b960a99`.\n\n### Implemented changes\n1. **Adaptive cooling ownership**\n   - When Adaptive reaches authoritative ON, Fan is forced ON and Peltier is forced ON before normal output application.\n   - While Adaptive is ON, firmware safety enforcement continuously restores Fan ON / 100% and Peltier ON whenever the normal safe conditions allow it.\n   - Manual Fan/Peltier commands were already locked by `ADAPTIVE_ACTIVE` and remain locked.\n   - Touch single-click can no longer force Fan/Peltier OFF while Adaptive is ON; it now returns `ADAPTIVE_ACTIVE` instead.\n   - Safety remains authoritative: an active Hotside protection window can still force Peltier OFF, while Fan remains ON/100%.\n\n2. **Manual Hotside critical response**\n   - When Adaptive is OFF and Hotside reaches the configured critical limit, existing Peltier OFF + Fan ON/100% protection now also forces/requests voltage to **5V**.\n   - Adaptive Hotside protection remains separate and keeps its staged 12V→9V→5V behavior with the existing cooling timer.\n\n3. **Battery configuration limits**\n   - 5V limit range changed from 20–48°C to **20–30°C**.\n   - 12V limit range changed from 22–50°C to **30–40°C**.\n   - The existing validation keeps at least one integer-degree middle value for the 9V region by requiring the 12V boundary to remain at least 2°C above the 5V boundary.\n   - Existing default values remain 25°C / 35°C because the user changed the allowed ranges, not the requested defaults.\n\n4. **Battery hysteresis**\n   - `BATTERY_HYSTERESIS_C` changed from **0.8°C → 1.0°C**.\n   - Stateful Battery control now uses hysteresis around the two boundaries instead of direct three-way voltage lookup.\n\n5. **Battery Adaptive step logic**\n   - Below the configured 5V boundary, the Battery control state moves toward lower voltage.\n   - Above the configured 12V boundary, the Battery control state moves toward higher voltage.\n   - Between the two boundaries, the Battery control state holds.\n   - Actual voltage movement is **one voltage step at a time**: 5V↔9V↔12V, preserving the existing 1-second Adaptive voltage-step delay.\n   - The current V2.6 direct-target scheduling was changed so a high Battery temperature cannot skip 9V when moving 5V→12V.\n   - Phone Battery updates now re-evaluate Battery Adaptive continuously per received Battery sample instead of only when the previous zone label changes, allowing multiple sequential one-step movements when the Battery remains above/below a threshold.\n   - Equality at the raw configured boundaries is not itself a separate movement command; hysteresis governs reversal and prevents rapid oscillation.\n\n6. **Rapid-rise protection**\n   - #23 remains explicitly **NOT NEEDED**. No separate °C/sec or rate-window protection was added.\n\n### Validation completed in this execution\n- Active V2.7 source file fetched from the repository after write.\n- Static checks passed: `FW_VERSION` = V2.7; no V2.6 firmware version literal remains in the active source; hysteresis = 1.0°C; Battery ranges = 5V 20–30°C and 12V 30–40°C; Adaptive Fan/Peltier enforcement present; Adaptive touch lock present; manual Hotside safety force-to-5V path present; one-step Battery up/down scheduling present; PHONE:BT re-evaluation present.\n- Delimiter sanity check passed: braces 526/526 and parentheses 2087/2087.\n- V2.6 source retirement was verified; a repository search for the old filename returns only historical note references.\n- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile was **NOT performed here**.\n- BIN generation/publication was **NOT performed**.\n- Physical V2.7 flash/runtime validation was **NOT performed**.\n- Firebase firmware metadata was **NOT promoted**.\n- App Build was **NOT run**; App Build remains a separate explicit workflow.\n\n### Important validation boundary\n- This execution proves repository/source transformation and static structural checks only. It does not prove PWM behavior, voltage hardware switching, Peltier/Fan physical operation, thermal behavior, BLE runtime behavior, or OTA behavior on hardware.\n\n## 2026-10-02 — FINAL CLARIFICATION / BATTERY ADAPTIVE STEP LOGIC

- User clarified the intended Battery Adaptive behavior: the configured 5V and 12V limits are **trigger thresholds for voltage movement**, not direct voltage-selection zones.
- If Battery temperature is **below the configured 5V limit**, Adaptive Battery should command voltage **down** by one level when a lower level exists (12V→9V, 9V→5V).
- If Battery temperature is **above the configured 12V limit**, Adaptive Battery should command voltage **up** by one level when a higher level exists (5V→9V, 9V→12V).
- If Battery temperature is **between the two configured limits**, Battery Adaptive should **hold the current voltage**; it should not force a direct target and should not treat 9V as a temporary transition.
- Example: 5V limit = 25°C and 12V limit = 37°C:
  - below 25°C → step voltage down;
  - 25°C through 37°C → hold current voltage;
  - above 37°C → step voltage up.
- Example: 5V limit = 29°C and 12V limit = 31°C:
  - below 29°C → step down;
  - 29°C through 31°C → hold current voltage, so 30°C can remain at 9V;
  - above 31°C → step up.
- Exact equality is therefore not itself a movement trigger under the user's wording ('below' and 'above'); equality holds the current voltage.
- The 9V operating level is the middle voltage reached by stepwise movement between 5V and 12V. It is not a separate temporary transition state.
- Battery hysteresis remains a separate requested setting of 1.0°C. During implementation, hysteresis must be designed around the two movement thresholds without changing the user's basic rule: below lower limit = down, above upper limit = up, between = hold.
- This clarified step logic supersedes previous notes that described Battery temperature as directly selecting 5V/9V/12V from a fixed zone function.
- Current V2.6 `batteryZoneFor()` / `scheduleAdaptiveBatteryTarget()` architecture does not match this clarified requirement exactly and must be redesigned during execution.
- No firmware source was changed in this discussion.

## 2026-10-02 — CORRECTED REQUIREMENT / BATTERY ZONE IS BETWEEN TWO CONFIGURED LIMITS

- Supersedes the previous wording that described 9V as a fixed 30°C-only band or generic transition state.
- User clarified the intended model is the same basic three-zone system already used by the firmware: **5V is below/through the configured 5V ceiling, 9V is the entire interval between the two configured limits, and 12V starts at the configured 12V floor**.
- User-configurable limits are constrained to:
  - 5V limit: **20°C–30°C**.
  - 12V limit: **30°C–40°C**.
- The 9V zone is not a special temporary transition. It is the real middle operating zone.
- The two configured boundaries must remain separated by at least **1°C of middle-zone temperature**, which means the 12V boundary must be at least 2°C above the 5V ceiling when using integer-degree boundaries.
- Example A: 5V limit = 25°C and 12V limit = 37°C → 5V = up to 25°C, 9V = 26–36°C, 12V = 37°C and above.
- Example B: 5V limit = 29°C and 12V limit = 31°C → 5V = 29°C, 9V = 30°C, 12V = 31°C.
- Therefore there is never an overlapping '5V 30°C' and '12V 30°C' definition when the boundaries are configured correctly.
- This zone definition is separate from the requested **1.0°C hysteresis**. Hysteresis must be applied around actual zone changes without redefining the three base zones or causing contradictory simultaneous assignments.
- Current V2.6 `batteryZoneFor()` uses the existing threshold direction (`temperature < battery5Limit => 5V; temperature < battery12Limit => 9V; else 12V`), so its boundary semantics currently differ from the clarified user model where `battery5Limit` is the **maximum 5V temperature**. This is an implementation-review item for later execution.
- Current V2.6 default limits are 25°C and 35°C; these remain historical/current source values until an execution changes defaults/constraints. The user's newly stated allowed ranges are the intended future configuration contract.
- No source change was made in this discussion.

## 2026-10-02 — CORRECTION / BATTERY VOLTAGE ZONE INTERPRETATION

- User clarified that the Battery voltage ranges are NOT a transition zone.
- The three voltages are independent temperature zones with a 1°C separation between their boundary values.
- Intended temperature behavior is:
  - 5V zone: 20°C through below 30°C; therefore 29°C = 5V.
  - 9V zone: the single 1°C interval/value between the 5V and 12V zones; 30°C = 9V.
  - 12V zone: above the 9V boundary and through the configured maximum; 31°C = 12V, up to 40°C.
- Critical clarification: there must be NO 5V at 30°C and NO 12V at 30°C. At exactly 30°C the result must be 9V.
- Therefore the intended upward mapping is explicitly: 29°C → 5V, 30°C → 9V, 31°C → 12V.
- The 1°C value is the width/separation of the 9V zone, not a special ramp or temporary transition state.
- Hysteresis is a separate mechanism and remains 1.0°C as previously requested; when implementing, hysteresis must not create an overlap where the same temperature can resolve simultaneously to multiple voltage zones.
- The previous audit note describing 9V as a generic 'transition zone' was imprecise and is superseded by this clarification.
- No source was changed in this discussion. This correction is a requirements/documentation update only.

## 2026-10-02 — V2.6 AUDIT / GROUPS B–G USER DECISIONS + NEW CONTROL REQUIREMENTS

### B. TEMPERATURE / NTC — #6–#9
- User status: KEEP / ACCEPTED.
- #6 NTC model/read cadence accepted.
- #7 NTC temperature calculation accepted.
- #8 NTC fault boundaries/validation accepted.
- #9 invalid-NTC safety response accepted.
- No source change from these points during this discussion.

### C. VOLTAGE SYSTEM — #10–#15
- User status: KEEP / ACCEPTED for all points.
- Voltage states 5V/9V/12V, 200 ms deadtime, 1-second voltage guard, request-source model, manual command rules, and single-click touch cycling remain the baseline.
- No source change from these points during this discussion.

### D. FAN / PELTIER CONTROL — #16–#18
- User status: KEEP / ACCEPTED, with the existing notes/source behavior treated as the baseline.
- Current source already rejects manual Fan/Peltier commands while Adaptive is active (ADAPTIVE_ACTIVE) and enforces the Fan-required safety relationship.
- New user requirement: when Adaptive becomes active, Fan and Peltier must be ON automatically. If either is OFF, firmware must turn it ON automatically.
- New user requirement: while Adaptive is ON, Fan and Peltier remain user-locked and cannot be manually toggled.
- Safety exception is explicit: Hotside protection may force Peltier OFF while Adaptive remains ON. This is a firmware safety override, not a reopening of the user control.
- Current V2.6 source does not explicitly set peltierOn = true when Adaptive activates; this is a real implementation gap to address during a later execution pass.

### E. HOTSIDE SAFETY — #19–#23
- #19–#22 user status: KEEP / ACCEPTED.
- #23 Rapid-Rise Temperature Protection: NOT NEEDED by current user decision. Do not add a separate °C/sec/rate-window protection mechanism unless the user explicitly reopens this requirement.
- New user requirement: during manual-voltage operation (Adaptive OFF), when Hotside reaches the critical limit, firmware must force the voltage to 5V in addition to the existing Fan ON / 100% and Peltier OFF response.
- During Adaptive operation, the existing Hotside staged protection remains: Peltier OFF, Fan 100%, cooling timer, then step down one voltage level (12→9 or 9→5). This manual 5V-force rule is specifically for the manual-voltage safety case and must not accidentally replace the Adaptive staged behavior.

### F. BATTERY TEMPERATURE / ADAPTIVE BATTERY — #24–#29
- #24 Battery source architecture accepted: Battery temperature remains supplied by the App/phone via PHONE:BT, not a second physical NTC.
- #25 Battery validity/TTL accepted.
- #26 Battery zoning accepted conceptually, but the threshold design is changed by the user's new note.
- User's intended example is: 29°C → 5V, 30°C → 9V, 31°C → 12V.
- User also described the desired temperature bands as approximately 5V = 20–30°C, 9V = between the two boundaries, 12V = 30–40°C, with a 1°C spacing between voltage transition boundaries.
- For implementation planning, this is interpreted as a transition sequence centered on 30°C and 31°C, so that the 9V zone occupies the 1°C interval between the 5V and 12V transition points. The exact inclusive/exclusive edge behavior must be coded deliberately to preserve the example.
- Important: this is distinct from hysteresis. The user also explicitly changed #27 hysteresis from 0.8°C → 1.0°C.
- #28–#29 Adaptive Battery target scheduling and pending states are accepted.
- Existing 5V/9V/12V target scheduling remains subject to the Hotside safety override and Adaptive ceiling.

### G. ADAPTIVE MODE — #30–#38
- #30 user status: KEEP / ACCEPTED.
- #31 user status: KEEP / ACCEPTED with the existing source/note semantics:
  - HOTSIDE_PROTECTION evaluates the physical NTC/Hotside safety only.
  - HOTSIDE_BATTERY evaluates physical NTC/Hotside plus App/phone Battery temperature.
  - Hotside remains the safety priority/override in the combined profile.
- #32–#37 user status: KEEP / ACCEPTED.
- #38 user status: KEEP / ACCEPTED for current Adaptive-OFF semantics.
- Adaptive startup still requires the safe 5V handoff before authoritative ADAPTIVE=ON.
- New requirement applies once Adaptive is actually ON: Fan and Peltier must be automatically ON and user-locked, subject to the safety exception for Peltier during Hotside protection.

### IMPLEMENTATION ITEMS CREATED BY THIS AUDIT (NOT YET EXECUTED)
1. Modify Adaptive activation/enforcement so adaptiveOn == true requires fanOn == true and peltierOn == true under normal-safe conditions; automatically restore either output if found OFF.
2. Preserve the existing safety authority so hotsideProtectionActiveNow() / NTC invalidation can still force Peltier OFF and Fan ON/100% as required.
3. Add a manual-mode Hotside safety path that requests/forces 5V when the critical Hotside limit is reached, without replacing the Adaptive 12→9→5 staged protection algorithm.
4. Change Battery hysteresis constant from 0.8°C to 1.0°C and review all stable-zone comparisons for exact boundary behavior.
5. Redesign the Battery 5V/9V/12V threshold defaults/logic to preserve the user's example 29°C→5V, 30°C→9V, 31°C→12V and the intended configurable ranges, without accidentally creating contradictory threshold/hysteresis behavior.
6. Review persistence/reset/App telemetry implications for changed battery thresholds and the temperature reset defaults before execution.

### VALIDATION BOUNDARY
- This is a discussion/audit record only.
- No .ino source, BIN, Firebase metadata, or dedicated binary firmware repository content was modified for these decisions.
- V2.6 ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compilation remains unverified.
- Physical V2.6 validation remains unverified.

## 2026-10-02 — V2.6 AUDIT / GROUP A IDENTITAS & HARDWARE #1–#5

### Audit scope
- User is re-auditing the current V2.6 firmware one numbered group at a time before deciding any source correction.
- Points #1–#3 are accepted as correct for the current design.
- No firmware source, BIN, Firebase metadata, or dedicated binary-repository content was changed by this review event.

### #1 — Firmware identity
- Status: KEEP / ACCEPTED.
- Current identity remains V2.6 / P1 / JE X FYZ / ESP32-C3 / Arduino-ESP32 Core 3.3.7 requirement.

### #2 — GPIO mapping
- Status: KEEP / FROZEN.
- GPIO5 = PELTIER.
- GPIO6 = FAN.
- GPIO0 = NTC, GPIO1 = Touch, GPIO3 = 12V selector, GPIO4 = 9V selector, GPIO7 = WS2812B.
- The GPIO5/Peltier and GPIO6/Fan mapping must not be swapped to compensate for App/protocol issues.

### #3 — Output hardware model
- Status: KEEP / ACCEPTED.
- 9V selector, 12V selector, Fan PWM, Peltier PWM, and 8-LED NeoPixel output remain the current hardware-control model.
- 5V is represented by both voltage-selector outputs OFF.

### #4 — Fan PWM
- Current source configuration: 25 kHz, 8-bit, 50–100% range, 10% step, default 100%.
- User decision: KEEP for now.
- Gemini second opinion also assessed the software configuration as KEEP.
- Engineering refinement to the Gemini response: the familiar 25 kHz PC/4-wire PWM fan range must not be treated as proof that this particular MOSFET-controlled 2-/3-wire fan implements the same standard; 25 kHz remains a reasonable high-frequency choice, not a universal compatibility claim.
- 50% is the project's deliberate operating floor, not a universal rule that every BLDC fan stalls below 30–40%.
- An external flyback diode should not be declared mandatory without confirming the actual fan electronics/load topology.
- No source change is justified from this audit alone.

### #5 — Peltier PWM
- Current source configuration: 20 kHz, 8-bit, 0–255 duty, 5-second linear soft-start.
- User decision: REVIEW / KEEP TEMPORARILY; no source change yet.
- 8-bit / 0–255 is accepted as sufficient resolution for this thermal-control application.
- 5-second linear soft-start is accepted provisionally because it provides a controlled electrical/thermal transition and avoids an abrupt load step; documentation must not overstate this as a capacitor-like Peltier inrush mechanism without hardware evidence.
- The claim that Peltier PWM must stay above 10 kHz or that low-frequency PWM will destroy a TEC in weeks is not accepted as an authoritative project requirement. Such a claim depends on actual thermal/electrical conditions and is not sufficient reason to set a hard firmware threshold.
- The most important unresolved engineering question is the MOSFET/gate-drive behavior at 20 kHz and the interaction between Peltier PWM and the existing 5V/9V/12V voltage-selection architecture.
- Do not label 20 kHz as proven optimal until the actual Peltier current, MOSFET part, gate-drive conditions, and relevant thermal/electrical behavior are known or tested.
- Recommended later hardware validation: observe MOSFET temperature and supply behavior during sustained intermediate-duty operation; this is a physical test requirement, not yet a verified result.

### Gemini second-opinion record
- Gemini classified Fan PWM #4 as KEEP and Peltier PWM #5 as software KEEP / hardware REVIEW.
- Gemini raised MOSFET switching-loss concerns for high-current Peltier PWM and noted that voltage selection may be a more efficient primary power-control mechanism than relying on large PWM reductions at a fixed high voltage.
- Gemini also proposed a fan flyback diode and a >10 kHz lower bound for Peltier PWM; those are recorded as third-party suggestions only and are not frozen requirements.
- The assistant's audit rejects any unverified claim as a firmware rule until it is supported by the actual hardware design or testing.

### Current audit status
- Confirmed: #1 KEEP, #2 KEEP, #3 KEEP, #4 KEEP.
- Pending engineering review: #5.
- V2.6 source remains the active continuity source at firmware/JEXFYZ-V2.6.ino.
- ArduinoDroid + official Arduino-ESP32 Core 3.3.7 compile of V2.6 remains pending unless separately recorded elsewhere.
- Physical V2.6 validation remains pending; this audit does not constitute a hardware test.

## 2026-10-02 — CORRECTIVE STATIC PASS AFTER ONE-SHOT OTA COMMIT

- Removed the final explicit LAST_OTA_RESULT send from ONLINE_UP_TO_DATE; OTA result events remain limited to fresh success/failure envelopes.
- Corrected the companion App regression-test syntax typo.
- No OTA transport, BLE/P1, GPIO, safety behavior, Firebase metadata, or production BIN was changed.

## 2026-10-02 — V2.5 / ONE-SHOT OTA RESULT LIFECYCLE

- Functional firmware revision bumped V2.4 → V2.5 because OTA result lifecycle is functional firmware behavior.
- Removed persistent lastOta NVS history; the legacy key is purged on boot.
- OTA results are RAM-only pending events. Successful OTA uses a one-boot otaBootResult handoff written only immediately before restart and removed at next boot; it is not OTA history.
- LAST_OTA_RESULT is now one-shot: the first full BLE sync consumes the pending result; later syncs send NONE.
- App Home NOTIFY consumes only fresh OTA_SUCCESS|... / OTA_FAILED|... events, and newer App events replace the OTA message.
- Power removal before the final restart boundary creates no persistent OTA result.
- BLE UUIDs, command vocabulary, OTA transport, safety, GPIO, LED indicators, Firebase metadata, and production BIN were not changed.
- No V2.5 BIN or Firebase promotion occurred; ArduinoDroid/Core 3.3.7 compile and physical validation remain pending.
## 2026-10-01 — CLEANUP COMMIT AUDIT TRAIL

- Dedicated firmware repository cleanup was executed with deletion commits after the repository-boundary mistake was identified.
- `JEXFYZ-V2.4.ino` is removed from `TenzoNkz/JEXFYZ-Firmware`.
- `FIRMWARE_NOTES.md` is removed from `TenzoNkz/JEXFYZ-Firmware`.
- Verified dedicated-repository cleanup history includes commits `0c53737f022623a705a0c4705bf51607c178f281` and `523f2ffb562947aefdd95857228e2bd061b42aa8`; the latter is confirmed by commit diff as the `FIRMWARE_NOTES.md` deletion.
- The dedicated repository still contains `JEXFYZ.cpp.bin`.
- The V2.4 firmware source remains in the App repository at `firmware/JEXFYZ-V2.4.ino`.
- The repository-boundary mistake was introduced by a previous execution step that incorrectly synchronized source/notes into the dedicated firmware repository. It has now been reverted and the boundary is frozen.

## 2026-10-01 — DEDICATED FIRMWARE REPO CLEANUP

- Removed the mistakenly mirrored `JEXFYZ-V2.4.ino` and `FIRMWARE_NOTES.md` from the dedicated firmware repository.
- Root cause: previous execution crossed the repository boundary and placed source/notes in the distribution repo.
- Correct boundary: `TenzoNkz/JEXFYZ-App` is the continuity/engineering source repository; `TenzoNkz/JEXFYZ-Firmware` is the binary distribution repository.
- Current V2.4 source remains at `firmware/JEXFYZ-V2.4.ino` in the App repository.
- No firmware functional code, BIN, Firebase metadata, BLE/P1, GPIO, OTA, or safety behavior was changed by this cleanup.
## 2026-10-01 — CHAT RULES FINAL RECORDING UPDATE

- `CHAT_RULES.md` now requires a maintenance-note record for every JE X FYZ project workflow/event, including audits, build/compile attempts, tests, failures, and no-change reviews when they establish validation status.
- CHAT_RULES final mandatory event-recording commit: `48e962648a7fbe0ec71a732f518ac21e99086d1a`.
## 2026-10-01 — PROCESS RULE UPDATE / FIRMWARE VERSIONING ENFORCED

- Project-wide `CHAT_RULES.md` now explicitly requires a firmware version increment for every functional firmware/source change before OTA candidacy.
- Current source remains **V2.4**.
- Every meaningful firmware event must be documented in `FIRMWARE_NOTES.md`, including changes, compile attempts/results, failures, physical tests, validation boundaries, and unresolved risks.
- This rules-only change does not alter firmware code, BIN, Firebase metadata, BLE/P1, GPIO, OTA, or safety behavior.

## 2026-10-01 — FIRMWARE VERSIONING RULE / V2.4

- Firmware source revision was bumped **V2.3 → V2.4** as part of this source change.
- The App mirror is now `firmware/JEXFYZ-V2.4.ino`.
- The exact V2.4 source still requires ArduinoDroid/Core 3.3.7 compilation before BIN/OTA promotion.

## 2026-10-01 — FULL EXECUTION / SOURCE-TO-HARDWARE MAPPING RECONCILIATION

- Current V2.4 source was inspected directly in both repositories after the required firmware version bump from V2.3.
- **Authoritative physical mapping:** GPIO5 = PELTIER; GPIO6 = FAN.
- App BLE/P1 logical tokens remain unchanged: `FAN:ON/OFF` controls Fan; `PELTIER:ON/OFF` controls Peltier.
- The firmware output path is internally consistent: Fan PWM writes to `PIN_FAN`; Peltier soft-start/stop writes to `PIN_PELTIER`.
- The dedicated V2.4 source has a compile-time `static_assert` protecting this mapping.
- Safety semantics were not changed: Peltier still requires Fan ON plus the existing NTC/Hotside/OTA protections.
- Dedicated firmware repo current state is **binary-only** with the existing `JEXFYZ.cpp.bin`. Firmware source and firmware notes remain in this App repository.
- Source hardening commit before version bump: `21ceb9ceb3f7b7701a88367a0dbd13090949acc2`.
- V2.4 source creation commit: `bd89ccfbe6aef846e35456fbf875d7ca68b90390`.
- Validation boundary:
  - Source/static consistency: **checked**
  - ArduinoDroid + Core 3.3.7 compile: **pending**
  - Corrected BIN flash: **pending**
  - Physical FAN/PELTIER test: **pending**
- No App command-token swap was made to compensate for the hardware mismatch.
- **Firmware versioning rule:** every functional firmware/source change must increment the firmware version before the changed source is treated as an OTA candidate. Documentation-only changes do not require a version bump.
- V2.4 OTA publication is intentionally incomplete until a V2.4 BIN is compiled from this exact source and the Firebase `version` metadata is promoted to `V2.4` together with the same production BIN URL.
> First-read memory index for Firmware work. Historical revision entries below remain preserved as evidence. Later verified state overrides older pending/obsolete statements.
> Consolidated: 2026-10-01.

## 0. MEMORY PRIORITY
1. Current verified firmware source/repository state.
2. Newest verified maintenance note.
3. ArduinoDroid/Core 3.3.7 compilation evidence.
4. Physical hardware evidence.
5. Older revision history and third-party suggestions.
Never promote a hypothesis or Gemini proposal to confirmed firmware behavior without source/compile/device evidence.

## 1. CURRENT HARDWARE / TOOLCHAIN
- Hardware: ESP32-C3 Super Mini.
- Arduino board target: ESP32-C3 Dev Module.
- Development environment: ArduinoDroid.
- Required framework: official Arduino-ESP32 Core 3.3.7.
- API rule: Arduino Standard + official Arduino-ESP32 Core 3.3.7 APIs only.
- ESP32-C3 single-radio constraint: do not assume simultaneous independent Wi-Fi and BLE operation.

## 2. GPIO MAP — FROZEN
- GPIO0 = NTC.
- GPIO1 = Touch.
- GPIO3 = 12V selector.
- GPIO4 = 9V selector.
- GPIO5 = PELTIER.
- GPIO6 = FAN.
- GPIO7 = WS2812B.
- Critical wiring correction: GPIO5 and GPIO6 must never be swapped.

## 3. CURRENT FIRMWARE VERSION
- Functional revision: V2.6.
- Firmware repository: TenzoNkz/JEXFYZ-Firmware (production repo is binary-only).
- Continuity source is kept under the App repository firmware/ directory.
- Current V2.6 source is firmware/JEXFYZ-V2.6.ino and still must be explicitly compiled in ArduinoDroid/Core 3.3.7 and physically validated before being called a hardware-validated release.
- Source version alone never implies a published or Firebase-promoted BIN.

## 4. BLE P1 — FROZEN CONTRACT
- Device name: JE X FYZ.
- Protocol: P1.
- Service: 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001.
- RX: 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001.
- TX: 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001.
- Do not change UUIDs/protocol for App-only UI/runtime issues.

## 5. ADAPTIVE / THERMAL BASELINE
- Profiles: HOTSIDE = Hotside protection only; HOTSIDE_BATTERY = combined Hotside + Battery protection.
- Profiles/preferences persist and are locked while Adaptive is ON.
- Hotside: 12V hot -> Peltier OFF, Fan ON, cool 10s, step to 9V, may resume; 9V hot -> same sequence then step to 5V; 5V hot -> Peltier OFF, Fan ON, Adaptive OFF, Peltier remains OFF until manual intervention.
- No extra 10s delay after the voltage step.
- Higher voltage is blocked during the active adaptive protection session where source logic defines that guard.
- Battery adaptive uses approximately 1 Hz evaluation with hysteresis/stable-zone handling; Hotside priority is preserved.
- Rapid-rise protection is deliberately not guessed. Do not invent an arbitrary value such as 4 C/s.

## 6. TOUCH BASELINE
- Adaptive OFF: 1 tap = 5V -> 9V -> 12V -> 5V; 2 taps = next LED mode 1..7; 5 s hold = Peltier + Fan toggle.
- Adaptive ON: 1 tap = force Peltier + Fan OFF while Adaptive stays ON; 2 taps = next LED mode; 5 s hold = Adaptive OFF.
- Successful Adaptive OFF indicator: red -> green -> blue -> normal mode.

## 7. LED BASELINE
- 8 WS2812B LEDs.
- Physical path: RIGHT TOP LED0; right side 0,1,2,3; crossover 3->4; left side upward 4,5,6,7.
- Logical arrays: RIGHT_PIXELS={0,1,2,3}; LEFT_PIXELS={7,6,5,4}.
- 7 LED modes.
- TWINKLE is removed.
- Rainbow is one shared moving hue across all 8 LEDs, full cycle 30 s.
- Brightness is 1..100%.

## 8. SAFETY AUTHORITY
- Firmware is final authority for physical safety.
- Peltier must not remain ON with invalid NTC, critical Hotside, Fan OFF, or OTA active.
- Battery protection is a system guard, not a normal consumer-facing status card.
- Temperature telemetry is approximately 1 Hz where defined by current implementation.

## 9. OTA — FROZEN ARCHITECTURE
- Local OTA uses Arduino Update.h.
- Firebase metadata: https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json
- GitHub BIN: https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin
- No SHA-based firmware linking.
- Single-radio Wi-Fi/BLE handoff remains required.
- Outputs OFF during OTA focus.
- Historical Local and Online OTA success is a validated baseline; do not redesign transport/radio handoff/Update.h lifecycle without explicit OTA-change approval.
- Later requested OTA result-indicator acceleration changed the visible result indication to 1 second with 250 ms phases; this did not authorize changing the underlying OTA transport.

## 10. APP <-> FIRMWARE STATE AUTHORITY
- Firmware owns physical state.
- ACK is not proof of physical state.
- Stateful commands return authoritative current telemetry even when the requested state already matches the current state.
- FAN responses echo FAN and current PELTIER.
- PELTIER responses echo FAN and PELTIER.
- Similar authoritative echo behavior covers supported LED/RGB/adaptive/fan-speed/temperature-limit/reset configuration.
- Runtime remains delta-based; no periodic full-sync spam.

## 11. VALIDATION BOUNDARIES
- Static source scan != ArduinoDroid compile.
- Compile != physical validation.
- App Build != firmware validation.
- Historical OTA success != proof of a new firmware revision.
- Current V2.3 physical validation status must be stated explicitly whenever discussing release readiness.

## 12. CURRENT APP ISSUE MUST NOT ALTER FIRMWARE
- The active investigation is the App Android Floating Monitor reliability problem.
- Do not modify firmware to compensate for an Android overlay permission/service/runtime issue.
- Preserve V2.3 GPIO, BLE P1, safety, adaptive, LED, and OTA contracts while the App issue is being solved.


# JE X FYZ Firmware — Master Notes

## 2026-09-30 — V2.3 TOUCH / ADAPTIVE FIX PASS

- Working firmware source advanced from V2.2 to **V2.3** because the new touch behavior is a functional firmware change.
- Touch behavior:
  - Adaptive OFF: 1× tap cycles voltage 5V -> 9V -> 12V -> 5V.
  - Adaptive OFF: 2× tap advances LED mode 1 -> 7 -> 1.
  - Adaptive OFF: hold 5 seconds toggles Fan + Peltier ON/OFF, still subject to firmware safety.
  - Adaptive ON: 1× tap force-shuts Fan + Peltier OFF while leaving Adaptive ON.
  - Adaptive ON: 2× tap still advances LED mode.
  - Adaptive ON: hold 5 seconds turns Adaptive OFF.
  - Successful touch-driven Adaptive OFF shows RED -> GREEN -> BLUE LED indication using non-blocking 250 ms phases, then returns to the selected LED mode.
- Adaptive Battery root fix:
  - Removed the zone-change self-cancel condition in evaluateAdaptiveBattery().
  - Pending Adaptive Battery transitions use the hysteresis-stabilized battery zone consistently instead of recomputing a raw zone.
- Rapid temperature-rise protection was not implemented in V2.3 because the project notes do not define an authoritative rate threshold/window. No guessed thermal threshold is being inserted into production firmware.
- OTA transport/radio ownership, P1 UUIDs, GPIO mapping, Local/Online OTA architecture, and no-explicit-blocking-delay requirement remain unchanged.
- Static V2.3 source checks completed: balanced delimiters and zero delay(), delayMicroseconds(), or vTaskDelay() calls.
- ArduinoDroid/Core 3.3.7 compile and V2.3 physical validation are **still pending**. Production BIN/Firebase metadata remain unchanged.

## 2026-09-30 — V2.2 FINAL ADAPTIVE STATE PASS (HISTORICAL BASELINE)

- Historical V2.2 source baseline was `firmware/JEXFYZ-V2.2.ino`; it is now retired after the V2.3 migration.
- V2.2 firmware version is **V2.2**. Production BIN/Firebase metadata were not promoted.
- Adaptive profile options are `HOTSIDE` (Hotside Protection only) and `HOTSIDE_BATTERY` (combined Hotside + Battery). Hotside is the thermal priority/override in the combined profile.
- Adaptive profile changes are locked while Adaptive is ON and persist across restart.
- Adaptive ON/OFF forces the voltage baseline to 5V when leaving a voltage above 5V.
- Battery-driven Adaptive voltage changes use a 1-second transition delay in both directions.
- Hotside Protection uses a 10-second Peltier-off cooling period at the current hot level, then steps down one voltage level and resumes Peltier at the new voltage; there is no extra 10-second wait after the new voltage is reached.
- 12V hot -> 9V, 9V hot -> 5V; 5V hot -> Peltier OFF + Fan ON and Adaptive OFF. Hotside-restricted higher voltages remain excluded until Adaptive is turned OFF.
- Manual Hotside critical protection remains Peltier OFF + Fan ON with no automatic Peltier restart. Manual Voltage remains unavailable while Adaptive is ON and retains its intentional 1-second voltage guard.
- Generic user-control rate limiting was removed; there is no generic control delay.
- Existing OTA transport/radio ownership/P1 UUIDs/GPIO mapping and blocking-delay-free architecture were preserved.
- Static source checks completed after this pass: balanced delimiters and zero explicit Arduino `delay()`, `delayMicroseconds()`, or `vTaskDelay()` calls.
- ArduinoDroid / Arduino-ESP32 Core 3.3.7 compilation and physical V2.2 validation were not completed before the V2.3 migration.


> **Document role:** permanent firmware engineering memory for the JE X FYZ project.
> This file intentionally lives in the App repository as documentation, even though firmware implementation source and production build files are maintained separately.
> **Reviewed:** 2026-09-28.

## 2026-09-30 — V2.2 ADAPTIVE PROFILE + THERMAL/VOLTAGE STATE UPDATE

### Current source baseline
- Firmware source is now maintained in the App repository under `firmware/JEXFYZ-V2.2.ino`.
- `firmware/JEXFYZ-V2.1.ino` was retired from the App repository.
- The dedicated firmware repository remains binary-only; no V2.2 BIN has been promoted yet.
- V2.2 is a source/implementation revision only until ArduinoDroid/Core 3.3.7 compilation and physical validation are completed.

### V2.2 functional changes
- Firmware version bumped from V2.1 to **V2.2**.
- Added persisted Adaptive profile:
  - `HOTSIDE` = Hotside Protection only (NTC Hotside).
  - `HOTSIDE_BATTERY` = combined Hotside + Battery; Battery controls normal voltage movement, while Hotside remains the primary thermal blocker/override.
- Added P1 `ADAPTIVE_PROFILE:<profile>` command and `ADAPTIVE_PROFILE` telemetry.
- Adaptive profile can only be changed while Adaptive is OFF; profile is locked while Adaptive is ON.
- Adaptive Battery voltage movement now uses a **1-second delay for both upward and downward changes**.
- Removed the extra 250 ms user-control rate guard; no generic command-delay remains.
- Hotside Adaptive protection now uses the final thermal-step behavior:
  - Hotside limit at 12V -> Peltier OFF, Fan ON -> 10 seconds cooling -> step to 9V -> Peltier resumes at the new voltage.
  - Hotside limit at 9V -> Peltier OFF, Fan ON -> 10 seconds cooling -> step to 5V -> Peltier resumes at the new voltage.
  - Hotside limit at 5V -> Peltier OFF, Fan ON -> Adaptive OFF; Peltier remains OFF until manual user activation.
- Each voltage level blocked by Hotside remains excluded for the current Adaptive session until Adaptive is turned OFF.
- The Hotside timer is a cooling period before the voltage step; there is no additional 10-second wait after the new voltage.
- Manual critical Hotside behavior remains Peltier OFF + Fan ON with no automatic Peltier restart.
- Manual Voltage remains protected by the existing 1-second voltage guard.
- Existing OTA transport, BLE UUID/P1 contract, radio ownership, and no-blocking-delay architecture were preserved.

### Validation status
- Static V2.2 checks completed here:
  - brace balance: 0
  - parenthesis balance: 0
  - bracket balance: 0
  - `delay(`, `delayMicroseconds(`, `vTaskDelay(`: 0
  - no stale `HOT_BATTERY` / `ADAPTIVE_UPWARD_DELAY_MS` tokens
- ArduinoDroid/Core 3.3.7 compile: pending.
- Physical V2.2 validation: pending.
- No Firebase/BIN promotion performed.

## 2026-09-28 — V2.0 REMOVE BLOCKING ARDUINO DELAY

- Functional firmware revision bumped from **V1.9 → V2.0**.
- Removed the remaining explicit Arduino `delay(10)` from the Online OTA stream retry path.
- The retry now uses the existing cooperative `yield()` path instead of an Arduino blocking delay; OTA transport, HTTP handling, stream validation, `Update.h` flashing, and recovery behavior are otherwise unchanged.
- Preserved the existing short cooperative BLE/Wi-Fi shutdown waits that use `while (...) { yield(); }`; these were not replaced with busy loops because `yield()` gives ESP32 system tasks an opportunity to run during the required radio transition window.
- No `delay()`, `delayMicroseconds()`, or `vTaskDelay()` calls remain in the firmware source.
- No BLE UUID/P1 protocol, GPIO mapping, safety contract, Firebase metadata, GitHub URL, OTA transport architecture, or OTA result LED timing was changed.
- Static validation for V2.0: source inspection, blocking-delay scan, and delimiter checks; ArduinoDroid/Core 3.3.7 compile and physical V2.0 validation remain pending.


## 2026-09-28 — V1.9 BOOT AP NORMAL RUNTIME BEHAVIOR

- Functional firmware revision bumped from **V1.8 → V1.9**.
- The initial 10-second Wi-Fi SoftAP window is now a **waiting network service**, not automatically a full safety-lock state.
- Immediately after boot, while the AP has **no connected client**:
  - persisted RGB/LED state may render normally;
  - the touch sensor is processed normally for non-cooling gestures;
  - Fan remains **forced OFF**;
  - Peltier remains **forced OFF**;
  - BLE remains disabled until Wi-Fi is turned off, preserving the single-radio handoff.
- When a phone/client actually connects to the boot AP:
  - OTA safe outputs are applied immediately;
  - voltage is forced to the safe 5V state;
  - LED is forced OFF;
  - touch processing is blocked by the OTA priority path;
  - Fan and Peltier are OFF;
  - the existing Local/Online OTA architecture is unchanged.
- If a boot-AP client disconnects before Local OTA starts, the safety lock is released immediately and normal LED/touch processing resumes while BLE remains disabled until Wi-Fi is off.
- Long-press cooling is explicitly blocked during the initial no-client boot AP window so Fan/Peltier cannot be started before startup completes.
- The normal NTC/safety enforcement is bypassed only during this no-client boot AP window because the boot contract requires Fan/Peltier to remain OFF regardless of last state or NTC status. Normal safety enforcement resumes after the startup AP window or immediately when a connected-client/OTA safety state ends.
- No BLE UUID/P1 protocol, GitHub URL, Firebase metadata, HTTPS downloader, Update.h flash lifecycle, OTA recovery, or OTA result-indicator timing was changed.
- Static validation target for V1.9: source-only review and delimiter checks; ArduinoDroid/Core 3.3.7 compile and physical V1.9 validation remain pending.

>
> **Priority rule:** This CURRENT STATE section is the first reference for present-day decisions. The chronological record below is preserved as history. Historical paths, versions, CI experiments, diagnostic branches, and old validation states must not override the Current State unless a newer entry explicitly supersedes them.

## 2026-09-28 — RESET TO V1.0 + LOCAL OTA LED FIX

- User supplied the current firmware source as `JEXFYZ.ino` and requested a clean restart from **V1.0**.
- The working source baseline is therefore reset to **V1.0**. This is a working/source baseline, not a claim that a new V1.0 BIN has been built or published.
- Public firmware distribution history remains preserved below; the previously published V1.7 BIN is historical until the new V1.0 release is deliberately compiled and promoted.
- Local OTA LED issue identified from the supplied source: successful Local OTA entered `OtaState::SUCCESS`, while `processLeds()` returned immediately for that state, so there was no Local OTA success-color render before restart.
- Minimal fix applied in the supplied working source:
  - added a dedicated non-blocking Local OTA result indicator;
  - successful Local OTA renders **green ON/OFF/ON/OFF** over approximately 2 seconds;
  - after the green result window completes, the normal OTA supervisor schedules the existing restart delay;
  - Local OTA failure explicitly clears any success indicator and continues using the existing **red blink** failure indicator;
  - a failed upload keeps the Local OTA AP alive so the user can retry.
- No BLE UUID/protocol, Wi-Fi transport, GPIO mapping, safety logic, adaptive logic, PWM, or Online OTA transport was intentionally changed by this fix.
- The V1.0 source still contains the previously retained heap-diagnostic instrumentation; the instrumentation is not evidence of physical validation.
- Validation completed here: source inspection, exact Local OTA control-flow analysis, brace balance check (470/470), and diff review against the user-supplied source.
- Validation not completed here: ArduinoDroid compile, BIN generation, physical Local OTA success test, physical Local OTA failure test.
- Next boundary: compile the exact V1.0 source in ArduinoDroid/Core 3.3.7, then test Local OTA once with a valid BIN and once with an intentionally rejected/invalid upload, capturing the LED and Serial result.

## 2026-09-28 — FULL V1.0 ONLINE OTA ROOT-CAUSE REVIEW + FIREBASE CONTROL PLANE

### Findings from the user-supplied V1.0 source
- Local OTA and Online OTA share the Arduino `Update.h` flash lifecycle; therefore the previously working Local OTA is useful evidence that the partition/write mechanism itself is not the first suspect for the Online OTA failure.
- The Online OTA path depended on a GitHub-hosted `manifest.json` indirectly through the App, then passed a GitHub raw BIN URL over BLE to the firmware.
- The Online download path used a fragile immediate `stream->peek()` magic-byte check immediately after `HTTPClient::GET()`. This can reject a valid HTTP body before the first byte is actually available from the stream. The check is now moved to the first real body read.
- The Online OTA firmware-side URL validator previously accepted any HTTPS URL. It is now restricted to the JE X FYZ GitHub raw repository and `.bin` files.
- The Online download remains deliberately streamed into the inactive OTA partition with fixed RAM usage; no firmware-sized RAM buffer or Range/resume transport was introduced.
- **Additional high-value root cause:** Online OTA previously called `stopBleRadio(false)`, which intentionally retained Bluetooth memory/resources while the ESP32-C3 then allocated Wi-Fi/TLS/HTTP/OTA resources. Local OTA starts without BLE and therefore did not exercise this contention. V1.0 now calls `stopBleRadio(true)` at the Online OTA radio boundary so Bluetooth resources are released before Wi-Fi/TLS allocation.
- Current source still cannot prove the exact historical failure cause without the device's captured `OTA_STAGE`, `OTA_ERROR_CODE`, `OTA_ERROR`, and Serial output. The new diagnostics are intended to make the next failure attributable to a specific stage rather than guessed.

### New release-discovery architecture
**Firebase = control plane**
- Firebase Realtime Database node: `/firmware_update` (REST: `/firmware_update.json`).
- Expected fields: `version` and `url`.
- The URL must be exactly `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin`.

**GitHub = binary plane**
- GitHub is used only to host the actual firmware `.bin`.
- GitHub `manifest.json` is no longer required for App Online OTA discovery.

The current end-to-end flow is:
Firebase metadata -> App validation -> BLE sends SSID/PASS/VERSION/approved GitHub BIN URL -> firmware Wi-Fi STA -> HTTPS GitHub BIN download -> Arduino `Update` -> finalize -> green result indicator -> restart.

Important: this architecture removes the GitHub manifest from the control path, but the ESP32 still has to establish a TLS/HTTP connection to GitHub to download the binary. Therefore a future TLS/network failure on the BIN fetch is still independent of Firebase metadata discovery.

### V1.0 Online OTA changes made after review
- Added strict GitHub BIN URL validation.
- Removed immediate `stream->peek()` transport gate.
- First actual downloaded byte is validated against ESP32 firmware magic byte `0xE9` after a successful stream read.
- Added Serial logging of the exact accepted GitHub BIN URL immediately before `HTTPClient::GET()`.
- No change to BLE UUIDs, P1 framing, GPIO, safety, adaptive control, PWM, or Local OTA protocol.

### Validation status
- Static source review completed on the 3929-line user-supplied V1.0 baseline.
- Local source after modification: 3945 lines.
- Brace/parenthesis sanity: balanced.
- ArduinoDroid/Core 3.3.7 compile: **not performed here**.
- Physical Online OTA: **not yet validated after the new flow**.
- Physical Local OTA LED success/failure: **not yet revalidated after the complete source review**.

## 2026-09-28 — FINAL FIREBASE OTA NAMING

- Final Firebase RTDB node: `/firmware_update`.
- Final App REST endpoint: `https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`.
- Final GitHub firmware filename: `JEXFYZ.cpp.bin`.
- Final GitHub raw URL:
  `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin`.
- Firebase stores `version` plus this fixed BIN URL.
- App validation accepts only this exact GitHub BIN URL.
- The firmware itself receives the approved URL over BLE; no GitHub manifest is required.

## 2026-09-28 — DEBUGGING WITHOUT SERIAL MONITOR

- User explicitly does not want to use a Serial Monitor for future debugging.
- Serial Monitor output must not be treated as a required user-side diagnostic step.
- Future firmware troubleshooting must first use source inspection, official Arduino-ESP32/Core 3.3.7 API verification, compile/build diagnostics, static state-machine analysis, repository/file inspection, and any physical symptoms or screenshots/logs the user voluntarily provides.
- Do not repeatedly ask the user to capture Serial Monitor output merely because an OTA/runtime problem occurs.
- When a fault cannot be conclusively distinguished from source/build evidence alone, state the uncertainty and narrow the next test to the smallest physical observation required; do not invent a root cause.
- Preserve detailed internal firmware diagnostics in source when useful, but they are optional evidence rather than a user workflow requirement.

## 2026-09-28 — LOCAL OTA PHYSICAL VALIDATION

- User confirmed the current V1.0 firmware successfully completed **Local OTA** on the physical device.
- User specifically confirmed the **success LED now blinks green** as intended.
- This is direct physical validation of the Local OTA success indication.
- Online OTA remains a separate validation path and is not yet considered physically validated.
- No Serial Monitor was required for this validation.

## 2026-09-28 — FIREBASE METADATA READ CHECK

- Physical App screenshot showed the Firebase RTDB node `/firmware_update` populated with `version: V1.0` and a GitHub BIN URL, while the App showed `Metadata unavailable`.
- The current App source already targets the correct REST endpoint: `/firmware_update.json`.
- The remaining configuration dependency is Firebase Realtime Database Rules: the App's unauthenticated HTTPS REST read requires the `firmware_update` node to permit `.read`.
- Recommended RTDB Rules for the public firmware metadata node:
  - `firmware_update/.read = true`
  - `firmware_update/.write = false`
- The App is intentionally not granted write access to firmware metadata.
- This is a Firebase configuration issue, not evidence that the firmware OTA flashing path is broken.
- A new App APK containing the Firebase endpoint change is still required on the phone; source changes alone do not update an already-installed APK.

## 2026-09-28 — FIRMWARE VERSION BUMP RULE

- The current clean firmware baseline is **V1.0**.
- From this point forward, **any functional firmware source change must increment the firmware version before the changed source is treated as the next test/release build**.
- Next functional change after V1.0 = **V1.1**.
- Do not keep modified firmware source labeled V1.0 when the implementation has changed.
- Documentation-only changes do not require a firmware version bump.
- App changes alone do not require a firmware version bump unless the BLE/firmware contract or firmware implementation also changes.
- Every firmware version bump must update the source version constant, the relevant notes/current-state entry, and the Firebase `firmware_update.version` only when that version is intentionally promoted for Online OTA testing/release.
- A version bump does not itself mean the firmware has been compiled or physically validated.

## 2026-09-28 — V1.1 LED/RADIO/RECOVERY FIX

- Because the source implementation changed functionally after the V1.0 physical validation, the firmware version is bumped to **V1.1** before the next test build.
- User-reported symptoms addressed:
  - boot Local OTA window must keep all user outputs and RGB LED OFF until Wi-Fi AP ends;
  - Online OTA must keep the RGB LED OFF during the complete BLE->Wi-Fi connection handoff;
  - Online OTA failure must show a clearly visible repeated RED blink before BLE recovery;
  - after BLE disconnect/recovery, the normal user LED effect must resume on the next safe main-loop iteration instead of waiting for a later state transition.
- Root causes found in the V1.0 source:
  1. LED-off ownership was distributed across several callers instead of being guaranteed by the OTA safe-output function.
  2. The Online OTA result indicator was processed by both `processOnlineOta()` and the generic `processLeds()` in the same loop iteration, so one indicator owned two render calls per loop.
  3. The recovery transition left `OtaState::FAILED` in place until a later generic LED pass, creating an unnecessary state race around BLE restart.
  4. BLE disconnect did not signal the main loop to restart the normal LED effect immediately; advertising and LED rendering were therefore separate state transitions.
  5. Online OTA now also owns an explicit Wi-Fi-OFF settle boundary before entering STA, preventing residual boot-AP state from crossing the radio handoff.
- V1.1 fixes:
  - `FW_VERSION = V1.1`;
  - `applyOtaSafeOutputs()` explicitly forces the RGB LED OFF and physical fan/Peltier/selector outputs safe;
  - Online OTA result indicators use exactly one renderer path and three clear flashes (ON/OFF x3) over 1.8 s;
  - recovery sets OTA state to `IDLE` before restarting BLE;
  - BLE disconnect schedules a main-loop LED resume flag when normal runtime can safely resume;
  - Online OTA enters Wi-Fi through an explicit `disconnect -> SoftAP disconnect -> WIFI_OFF -> settle -> WIFI_STA` boundary using Arduino-ESP32 Core 3.3.7 APIs.
- No BLE UUID/P1 protocol, GPIO mapping, safety thresholds, Local OTA flash lifecycle, or GitHub BIN transport was intentionally redesigned.
- The current Firebase metadata promotion remains **V1.0** until a V1.1 BIN is actually compiled and intentionally published. Do not point Firebase at V1.1 merely because the source version was bumped.
- Validation completed: source diff review, braces 481/481, parentheses 1913/1913, brackets 58/58, and targeted OTA/LED state-flow inspection.
- Validation pending: ArduinoDroid/Core 3.3.7 compile and physical V1.1 test.

## 2026-09-28 — V1.1 PATCH APPLIED AFTER GEMINI REVIEW

- Gemini Patch Plan was reviewed against the actual `JEXFYZ-V1.1.ino` source before application.
- Approved changes were applied to a new final candidate source; Gemini's `volatile bool` recommendation was strengthened to `std::atomic<bool>` because the flag crosses the BLE callback task / Arduino loop boundary and the source already uses `<atomic>` for SPSC synchronization.
- LED result rendering is now phase-change driven using explicit last-phase state for both Online and Local OTA result indicators.
- Wi-Fi fast-fail retry timing now uses an explicit 3-second backoff constant for BOTH the initial `WiFi.begin()` fast-fail and subsequent retry fast-fails. This corrects the Gemini plan's incomplete treatment, which only patched the later retry path.
- The exact old retry-burn expression `cloudPhaseStartedAt -= WIFI_CONNECT_TIMEOUT_MS` is no longer present.
- No Local OTA flash lifecycle, BLE UUID/P1 contract, GPIO mapping, Firebase version, or GitHub BIN URL was changed.
- Firebase remains promoted at V1.0. Do not change it to V1.1 until a V1.1 BIN is actually compiled/published and intentionally promoted.
- Final candidate validation: delimiter balance — braces 486/486, parentheses 1925/1925, brackets 58/58; no stale retry-burn expression; no plain `volatile bool bleLedResumePending`; `std::atomic<bool>` flag present.
- ArduinoDroid compilation and physical V1.1 validation remain pending.

## 2026-09-28 — ARDUINODROID EXTERNAL LIBRARY REQUIREMENTS

- The V1.1 source includes two external Arduino libraries that are not part of the Arduino-ESP32 Core itself:
  - **Adafruit NeoPixel** — header: `Adafruit_NeoPixel.h`; upstream library version checked: **1.15.5**.
  - **OneButton** — header: `OneButton.h`; upstream library version checked: **2.6.2**.
- Standard/core headers such as `<atomic>`, `Arduino.h`, `WiFi.h`, BLE headers, `Update.h`, and `esp_heap_caps.h` are not separate ArduinoDroid library installs for this project.
- V1.1 did not introduce these two external-library dependencies; they are already present in the V1.0 source baseline.
- A "library not found" ArduinoDroid error therefore indicates the corresponding external library is missing from the local ArduinoDroid library set, not that the V1.1 patch changed the dependency.
- Do not replace these libraries as a workaround without first identifying the exact missing header and considering the runtime/LED/button regression risk.
- Required production target remains Arduino-ESP32 Core 3.3.7.

## 1. CURRENT STATE — AUTHORITATIVE

### 1.1 Firmware ownership and repository boundary

- Firmware implementation is maintained separately from the App repository.
- The user owns the firmware source/workspace and the production compile/flash process.
- The production firmware source is compiled/flashed manually in ArduinoDroid.
- The App repository stores this file, FIRMWARE_NOTES.md, as permanent documentation only.
- Firmware .ino implementation, production .bin, firmware working files, and firmware production CI are not part of the App repository.
- A separate public firmware distribution repository may contain release BIN files and manifest.json for App Online OTA integration.
- Do not reintroduce a firmware source directory or firmware build workflow into TenzoNkz/JEXFYZ-App unless the user explicitly changes the repository architecture.

### 1.2 Current documented firmware line

**Current working firmware source candidate: V2.0**

> V2.0 is the current timing-cleanup candidate. It is not yet compiled or physically validated.

> V1.1 is the next test candidate produced from the V1.0 physically validated baseline. It is not yet physically validated.

> V1.0 is the new clean project baseline supplied by the user on 2026-09-28. It has not yet been independently compiled or physically validated in this environment.

Latest documented V1.7 source revision:
- Filename: JEXFYZ-V1.7.ino
- Latest source blob documented in the historical handoff: 7b16727475aa4bc8486ba69b2db63c19ad749ee9
- The V1.7 source includes the ArduinoDroid prototype-visibility repairs for the sketch-scoped enum types.

Current public firmware artifact:
- Filename: JEXFYZ-V1.7.bin
- Public repository: TenzoNkz/JEXFYZ-Firmware
- Public BIN blob documented: e8acabf6484490ba9713a1dc44b06c67252c53b8
- Size documented: 1,456,064 bytes
- Manifest version: V1.7
- Manifest BIN URL:
  https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.7.bin

Important reproducibility rule:
- The V1.7 BIN was supplied as a user-generated ArduinoDroid artifact.
- This environment did not independently reproduce the ArduinoDroid compilation.
- Do not claim source reproducibility, physical validation, or production readiness beyond the exact evidence recorded in the notes.

### 1.3 Toolchain lock

Production firmware environment is locked to:
- Board family: ESP32-C3
- Board profile: ESP32-C3 Dev Module
- Arduino IDE/Droid ecosystem: ArduinoDroid
- Arduino-ESP32 Core: 3.3.7
- Bundled ESP-IDF: documented as v5.5
- Production API rule: use Arduino Standard / official Arduino-ESP32 Core 3.3.7 APIs
- Do not substitute guessed APIs, undocumented wrappers, or configuration-specific BLE APIs merely because they compile elsewhere.

The previously considered Arduino-ESP32 3.3.12 is not the current production target. Keep production analysis pinned to 3.3.7 unless the user explicitly changes the lock.

### 1.4 Board configuration documented for the locked target

Where a build tool or manual board menu requires explicit values, the previously verified target profile is:

- Board: ESP32C3 Dev Module
- Upload speed: 921600
- CDC On Boot: cdc
- CPU frequency: 160 MHz
- Flash frequency: 80 MHz
- Flash mode: DIO
- Flash size: 4 MB
- Partition scheme: no_fs
- Debug level: none
- Erase flash: none
- JTAG adapter: default
- Zigbee mode: default

These values document the known production test environment. Do not silently change them while diagnosing a runtime problem.

## 2. HARDWARE / GPIO AUTHORITY

Current firmware-specific GPIO mapping:

| Function | GPIO |
|---|---:|
| NTC temperature input | GPIO0 |
| Touch sensor | GPIO1 |
| 12V selector | GPIO3 |
| 9V selector | GPIO4 |
| Fan | GPIO5 |
| Peltier | GPIO6 |
| WS2812B status/RGB LED | GPIO7 |

Important:
- The user previously found fan/peltier GPIO assignment confusion. The current firmware note authority is GPIO5 = Fan and GPIO6 = Peltier.
- NTC default hardware model: NTC 10K with 10K resistor unless a newer measured/calibrated value is explicitly documented.
- Only one touch sensor is present.
- ESP32-C3 has the single-antenna constraint: Wi-Fi and BLE cannot be treated as simultaneously active radios in the product design.

## 3. BLE CONTRACT

### 3.1 Identity

- Device name: JE X FYZ
- Protocol: P1

### 3.2 UUIDs

Service:
6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001

RX:
6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001

TX:
6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001

These are integration-contract values shared with the App. Do not change them without coordinated App + firmware review.

### 3.3 BLE radio ownership

- BLE is the normal post-Wi-Fi runtime radio.
- Wi-Fi must be considered fully finished before BLE initialization/advertising.
- Avoid redundant radio teardown calls across both caller and callee boundaries.
- The V1.7 Online OTA hardening specifically removed duplicate Wi-Fi shutdown from startBle() and duplicate teardown before WiFi.mode(WIFI_STA) in startOnlineOta().
- This was a lifecycle cleanup, not a permission to redesign the whole BLE stack.

### 3.4 BLE queue / callback architecture

The firmware moved away from:
- raw FreeRTOS portMUX
- configuration-specific Bluedroid/NimBLE callback overload blocks

Current design uses the project application-level single-producer/single-consumer BLE flow.

Critical maintenance rule:
- BLE callbacks must not reference destroyed application objects.
- Queue ownership/lifetime must remain valid for the entire callback registration period.
- Do not reintroduce a second BLE client or callback lifetime ambiguity.

## 4. WIFI / OTA ARCHITECTURE

### 4.1 Radio model

Hardware has one active antenna path. Product logic therefore follows a controlled sequence:

Boot → short Local OTA Wi-Fi window → Wi-Fi fully off → BLE active

and, for Online OTA:

BLE session teardown → Wi-Fi STA startup → HTTPS download/update → restart → BLE recovery

The exact handoff state must be explicit. Do not assume that issuing a Wi-Fi API call means the radio is already fully stopped.

### 4.2 Boot Local OTA

The established design intent:
- Wi-Fi Local OTA is available during the first 10 seconds after power-up/cable insertion.
- OTA window is controlled and bounded.
- After the Wi-Fi OTA window expires, Wi-Fi is shut down and BLE becomes the post-Wi-Fi radio.
- Device outputs are forced safe/off while OTA/Wi-Fi update control takes priority.

The earlier V1.1 diagnostic confirmed that the official Arduino-ESP32 Core 3.3.7 path should begin AP startup with:
WiFi.softAP(AP_SSID, AP_PASSWORD)

The diagnostic deliberately removed the pre-init sequence:
WiFi.disconnect(true, false) → WiFi.setHostname() → WiFi.setAutoReconnect(false) → WiFi.mode(WIFI_AP)

### 4.3 Online OTA

The firmware Online OTA uses the Arduino-compatible stack documented in the current source/history:
- HTTPS client
- WiFiClientSecure
- HTTPClient
- Arduino Update.h
- GitHub-hosted BIN
- Range probing/chunk/retry logic retained from the established implementation

Arduino Standard OTA lifecycle:
- Update.begin(...)
- Update.write(...)
- Update.end(true)
- Update.abort()
- Update.printError(Serial)

Firmware-size guard:
- use Arduino ESP.getFreeSketchSpace()

Reset reporting:
- use Arduino ESP.getResetReason()

Do not reintroduce the previously removed direct OTA/ESP-IDF lifecycle identifiers:
- esp_ota_*
- esp_err_t
- esp_err_to_name
- ESP_ERR_*

### 4.4 No SHA-only manifest requirement

Firmware selection/versioning is based on:
- firmware version
- manifest
- validated BIN URL

Do not replace this with a SHA-only firmware linking scheme unless the user explicitly redesigns OTA distribution.

### 4.5 OTA indicator contract

Design intent previously defined by the project:
- Wi-Fi connect: blue blink, approximately 1 s cadence
- Wi-Fi connection failure: red indication
- GitHub connection: green indication
- download success: blue indication
- download failure: red indication
- installation success: green indication, then restart
- installation failure: red indication

Local OTA intent:
- first successful file acceptance: blue
- failed upload: red
- successful send/install path: green, then flash/restart

Important validation distinction: these are desired UX/diagnostic patterns. Physical observations on V1.6/V6.6 did not fully match them, so LED behavior must be verified independently rather than assumed from source state transitions.

## 5. SAFETY / DEVICE CONTROL CONTRACT

### 5.1 Peltier / hotside protection

- Hotside temperature is safety-critical.
- The project has used a configurable critical hotside limit; current App range is documented as 40°C–50°C.
- Historical defaults include 45°C and earlier discussions referenced 50°C. Do not silently normalize this conflict; use the active firmware source/configuration as authority for a particular build.
- On a critical hotside event, the peltier must stop and the fan should have time to cool the hotside before normal operation resumes.
- A documented protection behavior is a 10-second peltier-off cooling interval.
- Rapid temperature rise should trigger immediate peltier shutdown and, where the active firmware implementation requires it, manual recovery/restart.

### 5.2 Battery temperature

- Battery temperature is read approximately every second.
- The battery protection guard is an internal safety mechanism and should not be exposed as a normal App UI control/state unless explicitly designed otherwise.
- When the battery temperature reaches its protection target, control behavior includes a defined pause/transition boundary.

### 5.3 Voltage / fan control

Project voltage modes:
- 5V
- 9V
- 12V

Historical default manual LED mapping:
- 5V = red
- 9V = green
- 12V = blue

Manual-mode fan control:
- PWM fan adjustment is active in the supported manual 12V mode.
- App-side percentage range is 50–100%.
- Adaptive mode owns its own control logic and should not be conflated with manual PWM control.

Touch/voltage interaction rules previously defined:
- Adaptive ON locks manual touch-based voltage control.
- When Adaptive is toggled ON, voltage should return to 5V.
- Manual voltage switching should include a controlled delay rather than rapid uncontrolled transitions.

## 6. DATA / PERSISTENCE CONTRACT

- Hotside temperature telemetry: approximately once per second.
- Other feature/state data: send on change where practical rather than flooding the BLE link.
- Preferences should be committed after approximately 10 seconds without a change to avoid unnecessary flash writes.
- Persisted items include user-configurable settings such as LED RGB/color and voltage-color configuration, subject to the active firmware source.
- Keep hardware safety state independent from UI persistence.

## 7. VERSIONING AND ARTIFACT POLICY

### 7.1 Production naming

Current source naming convention:
JEXFYZ-V<version>.ino

Current source:
JEXFYZ-V1.7.ino

Current public production BIN:
JEXFYZ-V1.7.bin

No descriptive suffix should be added to production versioned firmware filenames unless the user explicitly changes the convention.

### 7.2 Test versions

Test-only versions such as V6.6 are not production releases.

A test version must never be promoted to the public production manifest merely because OTA transport succeeded.

### 7.3 Build ownership

Firmware production build/flash is user-owned:
1. take the exact intended .ino
2. open in ArduinoDroid
3. use the locked ESP32-C3/Core 3.3.7 environment
4. compile
5. flash
6. capture actual Serial/runtime result
7. only then report physical validation

Do not manufacture a firmware BIN in a different environment and call it the user's production build.

## 8. DEBUGGING / ROOT-CAUSE RULES

Use this sequence for future firmware faults:

### A. Preserve evidence first
Capture:
- exact source version
- exact board settings
- ArduinoDroid/Core version
- full compile error or Serial boot log
- last successful Serial marker
- reset/panic output
- physical symptom

### B. Isolate the boundary
Examples:
- SoftAP only
- SoftAP + WebServer
- WebServer + Update
- Wi-Fi/BLE handoff
- BLE init/advertising
- BLE callback/queue
- sensor/control path

### C. Verify official API
For Core 3.3.7 behavior, check official Arduino-ESP32 source/examples before changing an API call.

### D. Make one minimal repair
Do not combine:
- OTA transport redesign
- BLE redesign
- GPIO changes
- safety logic changes
- unrelated cleanup
in one diagnostic patch.

### E. Validate again
A source patch is not the same as:
- ArduinoDroid compile success
- BIN generation
- physical boot
- physical OTA
- BLE recovery

Each is a separate evidence layer.

## 9. KNOWN DIAGNOSTIC HISTORY — CURRENTLY RELEVANT

### Boot Wi-Fi / SoftAP investigation
- Production firmware previously showed ESP32-C3 boot/panic behavior around the first Wi-Fi→BLE radio boundary.
- A standalone Wi-Fi OTA test failed to expose its SoftAP SSID.
- The next isolation step used a SoftAP-only test to determine whether the fault was below WebServer/OTA.
- This investigation established the rule: do not modify production OTA transport until the exact Wi-Fi boundary is proven.

### BLE heap diagnostic branch
- A separate diagnostic branch added official heap_caps_check_integrity_all(true) checkpoints.
- Checkpoints targeted the WebServer stop, Wi-Fi shutdown, BLE object allocation, service/characteristic setup, advertising, and delayed post-advertising intervals.
- This branch was diagnostic only and must not be treated as a production release.

### V1.6 BLE / compile history
- V1.6 had an ArduinoDroid compile compatibility issue around a min() template type mismatch.
- The repair changed only the BLE RX enqueue size calculation to an explicit size-safe comparison.
- No BLE queue architecture or OTA behavior was intentionally redesigned by that repair.

### V1.7 ArduinoDroid prototype visibility
- ArduinoDroid generated function prototypes before some sketch-scoped enum declarations.
- First repair added forward declarations for Voltage, LedMode, and VoltageRequestSource.
- Second repair added forward declarations for OtaState, OnlineOtaFlow, and OnlineOtaIndicatorNext.
- These were source-visibility fixes only; no runtime OTA logic was intentionally changed.

### V1.7 Online OTA hardening
Concrete V1.7 radio-lifecycle repair:
- removed redundant Wi-Fi shutdown from startBle()
- removed redundant Wi-Fi teardown before WiFi.mode(WIFI_STA) in startOnlineOta()
- preserved the existing HTTPS download/Update transport
- preserved BLE UUID/protocol, GPIO mapping, safety, PWM, Local OTA, and SPSC queue architecture

This was a lifecycle simplification based on a concrete duplicate-shutdown boundary, not a wholesale OTA rewrite.

## 10. CURRENT VALIDATION STATUS — 2026-09-28

### Source
- Current documented production line: V1.7
- Latest documented source revision: 7b16727475aa4bc8486ba69b2db63c19ad749ee9
- Gold Master OTA protected segments were documented as exact-match after the ArduinoDroid prototype fixes.

### Binary
- User supplied a compiled V1.7 BIN artifact.
- It was promoted to the public firmware repository as JEXFYZ-V1.7.bin.
- Manifest was updated to V1.7.
- Binary was not independently recompiled here.

### Physical runtime
- Historical V1.3 → V1.6 OTA success was recorded.
- Historical V1.6 → V6.6 test OTA success was recorded.
- Online OTA during V1.6/V6.6 reached restart and BLE recovery, with a blue LED observed as static rather than visibly blinking.
- This proves that a particular V1.6/V6.6 physical test completed OTA/restart; it does not prove V1.7 runtime success.
- **V1.7 physical Online OTA and LED behavior remain pending explicit user evidence.**

### Production readiness rule
Do not state “V1.7 fully validated” unless the user provides:
- actual ArduinoDroid build/compile evidence for the intended source
- physical boot evidence
- physical BLE recovery evidence
- Online OTA test evidence where applicable
- LED behavior evidence if the LED contract is being evaluated

## 11. FIRMWARE ↔ APP OTA CONTRACT

The App obtains firmware metadata from the public firmware repository:
https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/manifest.json

Current documented production manifest target:
- version: V1.7
- BIN:
  https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.7.bin

The App is responsible for:
- discovering a different valid version
- validating the manifest/URL
- presenting OTA progress/state
- tolerating the expected BLE disconnect
- reconnecting after firmware restart

The firmware is responsible for:
- entering the proper radio state
- downloading/flashing safely
- protecting peltier/fan/LED outputs as designed
- validating the update lifecycle
- rebooting into the new image
- restoring BLE after the Wi-Fi OTA phase

## 12. MAINTENANCE COMMENT POLICY

Firmware source comments are project memory and should explain:
- why a radio transition exists
- why a timeout exists
- which API is required by Core 3.3.7
- which GPIO is authoritative
- which state is safety-critical
- which block is protected by OTA Gold Master
- which behavior is desired but not yet physically validated

Do not write comments that claim a test passed when only static inspection occurred.

When source is updated, update this note with:
- date
- version
- exact reason
- exact changed area
- what was intentionally not changed
- validation evidence
- next diagnostic boundary

## 13. RULES THAT MUST NOT BE FORGOTTEN

1. **Arduino-ESP32 Core 3.3.7 is the production API target.**
2. **ArduinoDroid is the user's production compile/flash environment.**
3. **Do not guess Arduino or BLE APIs. Verify the official Core 3.3.7 API/source first.**
4. **One antenna means controlled Wi-Fi/BLE handoff, not assumed simultaneous operation.**
5. **GPIO5 = Peltier, GPIO6 = Fan** in the current firmware-specific mapping.
6. **FIRMWARE_NOTES.md stays in the App repo as documentation.**
7. **Firmware implementation source/BIN/build files stay outside the App repo.**
8. **V6.6 is a test version, not production.**
9. **V1.7 physical runtime is not proven merely by public BIN promotion.**
10. **A build result, a binary, and a physical validation result are three different evidence levels.**
11. **No SHA-only firmware manifest mechanism.**
12. **Preserve OTA protected blocks and Gold Master constraints unless a deliberate redesign is explicitly authorized.**
13. **Update the notes after every material discussion/execution so the notes remain newer than the source of confusion.**


## 2026-09-28 — DOCUMENTATION REORGANIZATION

- Rebuilt the top of FIRMWARE_NOTES.md into an authoritative Current State section.
- Separated present firmware ownership/status from historical execution records so old CI experiments, old repository paths, diagnostic branches, and old validation states cannot be mistaken for the current architecture.
- Explicitly recorded the current ownership split: firmware source and production compile/flash are user-owned and maintained separately; this file remains in the App repository as persistent documentation.
- Consolidated the current V1.7 source/BIN status, ArduinoDroid/Core 3.3.7 lock, ESP32-C3 board profile, GPIO map, BLE contract, Wi-Fi/BLE handoff, OTA lifecycle, safety contract, versioning, debugging rules, and validation boundaries.
- Historical entries are intentionally preserved below the master section rather than deleted.
- Documentation cleanup itself does not claim any new firmware compile, physical runtime, OTA, or LED validation.

---

# HISTORICAL EXECUTION RECORD

> The following chronological record is retained to preserve the project trail. Some entries reference repository paths, temporary CI workflows, older versions, diagnostic branches, or validation states that are no longer current. Those references are historical evidence, not current repository architecture. The Current State section above is authoritative for present decisions.

## 2026-09-27 — V1.3 FULL ARDUINO STANDARD REFACTOR

- User execution authorization: Eksekusi Full granted.
- Standing implementation mandate: from this point forward, every firmware change, large or small, must follow Arduino Standard for the pinned Arduino-ESP32 Core 3.3.7.
- Authoritative firmware source: firmware/JEXFYZ.ino.
- Current firmware version: V1.3.
- Source update commit: e520a086f5d86b28970e0eef9685facd939a397a.
- Previous V1.2 source blob: d19d8b3bf7d8637e11148bb63568164107ae0ae1.
- CI workflow audit update: 34347a1001c8817ae01ce9b21b9cfce384c54788.

### Arduino Standard changes

- Local OTA no longer uses direct ESP-IDF OTA lifecycle calls.
- Online OTA no longer uses direct ESP-IDF OTA lifecycle calls.
- Added the official Arduino Update.h lifecycle:
  - Update.begin(...)
  - Update.write(...)
  - Update.end(true)
  - Update.abort()
  - Update.printError(Serial)
- Firmware-size precheck uses the Arduino ESP.getFreeSketchSpace() API.
- Reset-reason reporting uses the Arduino ESP.getResetReason() API.
- Removed direct OTA/ESP-IDF implementation dependencies from the firmware source:
  - esp_ota_*
  - esp_err_t
  - esp_err_to_name
  - ESP_ERR_*
  - raw FreeRTOS portMUX queue locking
  - Bluedroid/NimBLE-specific callback overload blocks
- BLE queues now use the project's single-producer/single-consumer application flow instead of the removed raw portMUX layer.
- Cleaned the fan-PWM indentation defect, removed an empty no-op BLE block, and corrected the boot banner to print the actual FW_VERSION.

### Behavior deliberately preserved

- JE X FYZ BLE service/name/UUID contract remains unchanged.
- GPIO authority remains:
  - GPIO0 NTC
  - GPIO1 touch
  - GPIO3 12V selector
  - GPIO4 9V selector
  - GPIO5 Fan
  - GPIO6 Peltier
  - GPIO7 WS2812B
- Boot Local OTA AP remains deferred from setup() into the first loop() iteration to preserve the controlled Horizon-style runtime boundary.
- Boot AP timeout remains 10 seconds.
- BLE remains the post-Wi-Fi handoff radio.
- OTA safety output shutdown, NTC safety, voltage guards, adaptive logic, PWM, RGB, BLE protocol, settings persistence, and online Range/Retry policy were not intentionally redesigned.
- Online OTA continues to use HTTPS with the pinned GitHub CA certificate and Range probing/chunks/retry logic.
- No SHA-based firmware manifest mechanism was introduced.

### Validation status

- Static source audit before commit: PASS.
- No raw esp_ota_*, esp_err_*, ESP_ERR_*, portMUX, or configuration-specific BLE callback blocks remain in the V1.3 source.
- The CI workflow now explicitly fails if those non-Arduino implementation paths reappear.
- V1.3 CI build has not yet been triggered after this source/CI change.
- Public firmware repository is still on V1.2 until the next successful V1.3 build-and-publish run.
- Next execution boundary: trigger the Firmware Build, verify ArduinoDroid/Core 3.3.7 compile, verify Arduino Standard + OTA audit, verify ESP32-C3 binary generation, then physically flash V1.3 and capture Serial boot/OTA evidence.

## 2026-09-27 — CI AUDIT ALIGNMENT AFTER V1.1 DIAGNOSTIC

- Action: removed only the obsolete hardcoded V1.0 assertion from `.github/workflows/firmware-build.yml`.
- Reason: the source diagnostic revision is V1.1 by project version policy; the workflow already has a separate `Extract firmware version` step that validates the `Vx.y` format, so a fixed V1.0 assertion would reject the intended diagnostic source before compile.
- CI platform remains pinned to Arduino-ESP32 Core 3.3.7 with OneButton 2.6.1 and Adafruit NeoPixel 1.12.5.
- Repository commit: `3b046b7d8084dbad0059577925bccc23d07ed001`.
- Static validation after this CI-only edit: PASS. Verified V1.1 source token, all OTA protected-source audit requirements present, OTA supervisor precedes feature processing, no `delay()` inside the locked OTA engine, Core 3.3.7 pin remains, and the V1.0 hardcoded audit assertion is gone.
- Build status: still not run; no `arduino-cli` is available in the current container, and the project keeps CI firmware compilation behind the explicit `Eksekusi Firmware` action.
- Runtime/root-cause status: unchanged — the V1.1 radio diagnostic has not yet been physically tested, so no root cause is declared.
- Next boundary: run the dedicated Firmware Build for V1.1, then physically test the boot Serial markers. Do not add another runtime patch until the last successful radio-start boundary is known.



## 2026-09-27 — V1.1 RADIO DIAGNOSTIC SOURCE STEP

- Action: replaced only the initial boot-AP startup boundary in `firmware/JEXFYZ.ino`.
- Reason: Core 3.3.7 official source shows `WiFi.softAP()` already performs `AP.begin()` and `AP.create()`; therefore the previous pre-sequence `WiFi.disconnect(true, false)` -> `WiFi.setHostname()` -> `WiFi.setAutoReconnect(false)` -> `WiFi.mode(WIFI_AP)` was not part of the official high-level AP startup path.
- Official source verified at Arduino-ESP32 Core 3.3.7:
  - `libraries/WiFi/src/WiFiAP.cpp`: `softAP(...)` returns `AP.begin() && AP.create(...)`.
  - `libraries/WiFi/src/AP.cpp`: `AP.begin()` calls `WiFi.enableAP(true)` and waits for `ESP_NETIF_STARTED_BIT`.
  - `libraries/WiFi/src/WiFiGeneric.cpp`: `enableAP(true)` calls `mode(currentMode | WIFI_MODE_AP)`; `getMode()` returns `WIFI_MODE_NULL` before low-level Wi-Fi initialization.
  - `libraries/WiFi/src/STA.cpp`: `STA.disconnect()` directly calls `esp_wifi_disconnect()`; the startup diagnostic therefore removes that pre-init teardown call rather than relying on it.
  - Official `WiFiAccessPoint.ino` uses the high-level `WiFi.softAP(ssid, password)` path directly.
- Source change: `startLocalOtaAp()` now starts with official `WiFi.softAP(AP_SSID, AP_PASSWORD)`, then retains the JE X FYZ fixed `WiFi.softAPConfig(...)` and HTTP server setup. BLE, OTA engine, safety logic, PWM, NTC, and feature state were not intentionally changed.
- Firmware version in source advanced from V1.0 to V1.1 because executable firmware behavior changed. V1.1 is a controlled diagnostic source revision, not a production release.
- Repository commit: `379bf1fce91d0df84ab905e23a9820de2d20a9cb`.
- Static source validation after the edit: PASS. Verified V1.1 marker, direct official `WiFi.softAP()`, no initial `WiFi.disconnect(true, false)`, no direct `WiFi.mode(WIFI_AP)` in the initial AP function, `softAPConfig` after SoftAP, and HTTP start after AP bring-up.
- Build status: not run in this step. The active execution rule keeps firmware CI behind the explicit `Eksekusi Firmware` command, and this container has no `arduino-cli` toolchain installed for a local Core 3.3.7 compile.
- Runtime/root-cause status: **still unproven**. The physical panic dump has not been captured; V1.1 must be tested from Serial boot markers to identify the exact last successful boundary.
- Next boundary: compile V1.1 only through the explicit firmware-build action, then physically flash/test and preserve the exact Serial/Guru Meditation output. Do not add BLE or unrelated recovery changes before the radio boundary is proven.

## 2026-09-27 — PASSIVE LIVING-NOTES GOVERNANCE

- Discussion result: project notes are now treated as passive, continuously evolving memory.
- Rule: every JE X FYZ discussion and every execution must leave the relevant notes more current than before, even when no code change occurs.
- Discussion-only updates may record decisions, verified official-source findings, contradictions, diagnostics, runtime evidence, and next boundaries.
- Code/repository modification and build execution still require the explicit user command `Eksekusi Full`.
- Current source/state consistency correction: the actual `firmware/JEXFYZ.ino` is V1.1 diagnostic source; the previous V1.0 physical-panic baseline remains historical/unvalidated.
- No executable source or build was changed by this governance update.
- Unresolved issue: physical V1.1 radio-boundary test and exact Guru Meditation/Serial evidence are still pending.

## 2026-09-27 — DISCUSSION: ISOLATED WIFI OTA TEST PLAN

- User decision: create a separate minimal firmware whose only purpose is to test whether Wi-Fi OTA itself works on the ESP32-C3; the user will compile/flash it manually with ArduinoDroid.
- This is a discussion-stage plan only. No .ino test file was created, no production source was changed, and no build was executed.
- Diagnostic principle: completely isolate the production JE X FYZ firmware. Do not include BLE, NTC, Fan/Peltier control, touch, RGB, Preferences, Adaptive logic, online OTA, or custom radio handoff.
- Official Core 3.3.7 OTA reference verified: libraries/WebServer/examples/WebUpdate/WebUpdate.ino uses WiFi.h, NetworkClient.h, WebServer.h, and Update.h; it starts Wi-Fi, serves /, accepts firmware at /update, uses the official Update.begin() / Update.write() / Update.end(true) lifecycle, and then restarts.
- Official Core 3.3.7 AP reference remains WiFi.softAP(ssid, password).
- Diagnostic goal: first prove the board can run a minimal official-style SoftAP + WebServer OTA path under the user's exact ArduinoDroid/Core 3.3.7 environment. A successful test isolates the earlier panic to interaction with JE X FYZ runtime layers; a failed test points investigation back toward board/toolchain/standalone Wi-Fi OTA behavior.
- The standalone test should use explicit Serial markers around boot, SoftAP start/result, server start, OTA upload start/write/end, OTA error, and restart so the exact failure boundary is visible.
- Versioning: use a diagnostic/test label separate from the production V1.x sequence unless the user explicitly chooses otherwise.
- Execution lock: the actual .ino generation is reserved for the explicit Eksekusi Full command under the current project governance.
- Next boundary: user may issue Eksekusi Full to generate only the standalone .ino, intended for manual ArduinoDroid compilation/flash and physical OTA testing.
## 2026-09-27 — EXECUTION: STANDALONE WIFI OTA TEST FILE

- User explicitly requested `Eksekusi Full` to generate a standalone .ino for manual ArduinoDroid testing.
- Generated file: `JEXFYZ-WiFi-OTA-Test.ino` in the conversation workspace. It is intentionally separate from the production repository firmware source.
- Scope: Wi-Fi SoftAP + WebServer + official Update OTA only. No BLE, NTC, Fan/Peltier control, touch, RGB, Preferences, Adaptive, cloud OTA, or JE X FYZ radio handoff logic.
- Official Core 3.3.7 APIs verified before/while generating: `WiFi.softAP()`, `WebServer`, `server.upload()`, `Update.begin()`, `Update.write()`, `Update.end(true)`, `Update.abort()`, and `UPLOAD_FILE_ABORTED`.
- Diagnostic Serial markers cover boot, SoftAP result, AP IP, HTTP readiness, OTA upload start/write/end, abort, errors, success, and restart.
- Static validation: PASS. Required include/API/lifecycle markers are present.
- Local compile validation: not performed because `arduino-cli` is not installed in the current container. The intended compile target is the user's manual ArduinoDroid environment using Arduino-ESP32 Core 3.3.7.
- Production `firmware/JEXFYZ.ino` was not modified by this standalone test-file generation.
- Runtime/root-cause status: still unproven. The standalone physical test is now the next diagnostic boundary.
- Next boundary: compile/flash this standalone .ino manually in ArduinoDroid, connect to the `JE X FYZ OTA TEST` SoftAP, open `http://192.168.4.1/`, and test a known-good ESP32 firmware .bin upload. Preserve the Serial output exactly.
## 2026-09-27 — RUNTIME RESULT: STANDALONE WIFI OTA TEST SSID NOT VISIBLE

- User physical-test result: after manually compiling/flashing the standalone `JEXFYZ-WiFi-OTA-Test.ino`, the configured Wi-Fi SSID was not visible.
- The standalone file was inspected locally: it calls `WiFi.softAP(AP_SSID, AP_PASSWORD)` directly before WebServer setup, with no BLE or JE X FYZ production runtime layers.
- Official Core 3.3.7 reference remains the same: `WiFiAccessPoint.ino` starts AP directly with `WiFi.softAP(ssid, password)`; the WebUpdate example adds WebServer/Update only after Wi-Fi connection/startup.
- Current diagnostic conclusion: the failure boundary is still unknown. We do not yet know whether the board panics/stops inside `WiFi.softAP()`, returns `false`, starts AP but fails visibility, or is being compiled/flashed with a different ArduinoDroid/Core/board configuration.
- Important isolation decision: do not modify OTA logic yet. The next diagnostic should remove WebServer and Update entirely and use the smallest official-style SoftAP-only sketch, with Serial markers immediately before and after `WiFi.softAP()` and an AP IP print.
- Exact Serial output is now the key evidence. Preserve every line from reset through failure/reboot; especially capture whether `WIFI: STEP 1 SOFTAP` is followed by `SOFTAP RESULT=OK` or a panic/reset.
- No production JE X FYZ source was changed in this discussion.
- No new executable test file was generated in this discussion.
- Next boundary: an `Eksekusi Full` step may generate the SoftAP-only diagnostic file. Do not add OTA/WebServer back until the SoftAP-only boundary is proven.

## 2026-09-27 — EXECUTION: SOFTAP-ONLY DIAGNOSTIC FILE

- User explicitly requested `Eksekusi Full` after the standalone Wi-Fi OTA test failed to expose an SSID.
- Generated file: `JEXFYZ-SoftAP-Only-Test.ino` in the conversation workspace.
- Scope is intentionally reduced to the smallest AP boundary: `#include <WiFi.h>`, `WiFi.softAP(ssid, password)`, and `WiFi.softAPIP()` with Serial markers. No WebServer, Update OTA, BLE, NTC, cooling, RGB, touch, Preferences, or other project libraries.
- The AP call follows the verified Arduino-ESP32 Core 3.3.7 official `WiFiAccessPoint.ino` pattern.
- SSID for this diagnostic: `JE X FYZ SOFTAP TEST`; password: `0987654321`.
- Serial boundary markers explicitly identify: before `WiFi.softAP()`, its returned result, SSID, AP IP, and final AP-ready state.
- Static validation: PASS. Required WiFi APIs/markers are present and the forbidden application/OTA/BLE libraries are absent.
- Compile/flash validation: not performed here; intended manual compile target remains ArduinoDroid with Arduino-ESP32 Core 3.3.7.
- Production `firmware/JEXFYZ.ino` was not changed by this diagnostic.
- Runtime/root-cause status: remains unproven until the SoftAP-only sketch is physically tested.
- Next boundary: flash this sketch and preserve the exact Serial output. The critical evidence is whether `STEP 2: WiFi.softAP() RESULT = OK` appears and whether `RESULT: SOFTAP READY` is reached.

## 2026-09-27 — EXECUTION: WIFI MODE AP-ONLY DIAGNOSTIC

- User supplied physical Serial evidence from the previous SoftAP-only test. The device prints STEP 1: BEFORE WiFi.softAP() and then immediately reports Guru Meditation Error: Core 0 panic'ed (Load access fault); WiFi.softAP() never returns.
- This rules out WebServer and OTA Update as the immediate failure boundary for that test, but WiFi.softAP() internally contains multiple official Wi-Fi/AP lifecycle steps, so the exact internal boundary was still unresolved.
- Official Arduino-ESP32 Core 3.3.7 source verified again:
  - WiFi.softAP() in WiFiAP.cpp calls AP.begin() and AP.create().
  - AP.begin() calls WiFi.enableAP(true) and waits for ESP_NETIF_STARTED_BIT.
  - WiFiGenericClass::enableAP(true) calls the official mode(currentMode | WIFI_MODE_AP) path.
  - WiFiGenericClass::getMode() returns WIFI_MODE_NULL before Wi-Fi low-level initialization.
  - ESP.getCoreVersion() is the official Core-version reporting API and returns ESP_ARDUINO_VERSION_STR.
- User explicitly requested Eksekusi Full. Generated standalone diagnostic file: JEXFYZ-WiFi-Mode-AP-Test.ino.
- Scope: Arduino.h + WiFi.h only; it prints the actual compiled Arduino-ESP32 Core version, chip model/revision, calls WiFi.getMode(), then calls only WiFi.mode(WIFI_AP) and verifies the returned mode. It does not call WiFi.softAP(), WebServer, Update, BLE, or any JE X FYZ feature library.
- Static validation: PASS.
- Build/flash validation: not performed here; user will compile/flash manually in ArduinoDroid.
- Production firmware/JEXFYZ.ino was not modified.
- Current root-cause status: still unproven. The purpose of this test is to distinguish an AP-mode failure from a later AP.create() failure inside the official WiFi.softAP() implementation.
- Next boundary: flash the new test and preserve the entire Serial output. The most important lines are the actual Arduino-ESP32 Core value, STEP 3, and whether STEP 4 is reached or the device panics.

## 2026-09-27 — RUNTIME RESULT: WIFI MODE AP PANICS

- User physical-test result from `JEXFYZ-WiFi-Mode-AP-Test.ino`: actual compiled Arduino-ESP32 Core reported by the official `ESP.getCoreVersion()` API is `3.3.7`.
- Hardware runtime reported by the sketch: Chip = ESP32-C3, Chip revision = 4.
- `WiFi.getMode()` before initialization returned `0`, matching the official Core 3.3.7 `getMode()` path's `WIFI_MODE_NULL` result before low-level Wi-Fi initialization.
- The sketch printed `STEP 3: BEFORE WiFi.mode(WIFI_AP)` and then immediately panicked with `Guru Meditation Error: Core 0 panic'ed (Load access fault)`; `STEP 4: WiFi.mode(WIFI_AP) RESULT` was never reached.
- This narrows the failure boundary from the public `WiFi.softAP()` call to the official `WiFi.mode(WIFI_AP)` path itself or an internal function it invokes.
- Official Core 3.3.7 source reviewed for this boundary: `WiFiGenericClass::mode()` first checks `getMode()`; when Wi-Fi is not initialized and a non-zero mode is requested, it calls the internal official `wifiLowLevelInit(_persistent)`; that path calls `Network.begin()`, then `esp_wifi_init(&cfg)`, registers Wi-Fi events, creates default AP/STA network interfaces, and posts the Wi-Fi ready event.
- Official Network Manager source/docs verified: public global `Network.begin()` initializes the ESP-IDF network interface system through `esp_netif_init()` and initializes network events; the official Network API documentation explicitly presents `Network.begin()` as the initialization entry point.
- Diagnostic conclusion: OTA, WebServer, `WiFi.softAP()` credential/configuration, and JE X FYZ production feature layers are no longer part of this immediate failure boundary. The exact failing internal step is still not proven.
- User explicitly requested `Eksekusi Full`. Generated `JEXFYZ-Network-Begin-Test.ino` containing only `Arduino.h` + official `Network.h`, the actual Core/chip reporting APIs, and `Network.begin()`.
- Static validation: PASS. No Wi-Fi mode/AP, WebServer, Update, BLE, Preferences, NeoPixel, or OneButton calls are present.
- Build/flash validation: not performed here; manual ArduinoDroid test is the next step.
- Production `firmware/JEXFYZ.ino` was not modified.
- Next boundary: flash the Network.begin-only diagnostic and preserve the complete Serial output. The key result is whether `STEP 2: Network.begin() RESULT = OK` is reached or the board panics inside `Network.begin()`.

## 2026-09-27 — RUNTIME RESULT: NETWORK BEGIN TEST ALSO NO SSID

- User reports that the new `JEXFYZ-Network-Begin-Test.ino` also does not result in a visible Wi-Fi SSID.
- No Serial screenshot/output for the Network.begin-only sketch was provided yet, so the exact failure boundary remains unclassified.
- Official Core 3.3.7 source inspection reached `NetworkManager::begin()`: it calls `esp_netif_init()` once and then `initNetworkEvents()`; `initNetworkEvents()` creates the Arduino event group/queue, calls `esp_event_loop_create_default()`, and creates the Arduino network-event task.
- This means the next evidence needed is not another higher-level Wi-Fi sketch. We need to know whether `Network.begin()` itself returns, returns false, or panics inside `esp_netif_init()` / event initialization.
- Diagnostic rule: do not infer hardware failure or change the production firmware from the absence of an SSID alone.
- The previous test already proved the actual Arduino-ESP32 Core is 3.3.7 and the target reports ESP32-C3 revision 4.
- No executable source was changed in this discussion and no build was executed.
- Next boundary: obtain the complete Serial output from `JEXFYZ-Network-Begin-Test.ino`, especially whether `STEP 2: Network.begin() RESULT = OK` appears. Based on that evidence, choose exactly one lower-level diagnostic boundary.

## 2026-09-27 — CORRECTION: NETWORK-BEGIN TEST HAS NO AP BY DESIGN

- Discussion correction: the prior interpretation of the user's statement "SSID tetap tidak muncul" for the Network-begin diagnostic was incorrect.
- The Network-begin diagnostic intentionally contains only Network.begin() and does not call WiFi.mode() or WiFi.softAP(). Therefore it is expected that no Wi-Fi SSID is broadcast by this sketch.
- The test's valid success/failure evidence is its Serial boundary: whether STEP 2: Network.begin() RESULT = OK is printed, whether it prints RESULT: NETWORK BEGIN FAILED, or whether the MCU panics/resets before returning from Network.begin().
- No claim can currently be made about the result of Network.begin() because the corresponding Serial output has not been supplied.
- Important reasoning correction: absence of an SSID must only be evaluated by a test whose purpose includes AP creation. This distinction is now part of the diagnostic boundary.
- No executable source was changed and no build was executed in this discussion.
- Next boundary: interpret the existing Network-begin test strictly from its Serial output; if it completes successfully, proceed to isolate the next official initialization step. Do not infer failure from SSID visibility for this sketch.
## 2026-09-27 — EXECUTION: WIFI LOW-LEVEL INIT DIAGNOSTIC

- User explicitly requested `Eksekusi Full` after the `WiFi.mode(WIFI_AP)` panic evidence.
- Created standalone diagnostic file `JEXFYZ-WiFi-LowLevel-Init-Test.ino` for manual ArduinoDroid testing.
- Diagnostic sequence follows the verified Arduino-ESP32 Core 3.3.7 `wifiLowLevelInit()` ordering only through the `esp_wifi_init()` boundary: report actual Core/chip -> `Network.begin()` -> `WIFI_INIT_CONFIG_DEFAULT()` -> apply the exact non-static-buffer configuration used by Core 3.3.7 -> `esp_wifi_init(&cfg)`.
- The test intentionally does not call AP mode, SoftAP, WebServer, Update OTA, BLE, or any JE X FYZ feature.
- Official source basis verified: Core 3.3.7 `WiFiGeneric.cpp` calls `Network.begin()` before `esp_wifi_init(&cfg)`, and uses `WIFI_INIT_CONFIG_DEFAULT()` with static_tx_buf_num=0, dynamic_tx_buf_num=32, tx_buf_type=1, cache_tx_buf_num=4, static_rx_buf_num=4, dynamic_rx_buf_num=32 when static buffers are disabled.
- Static isolation/API validation: PASS. The generated file contains the required official APIs and no executable AP/WebServer/OTA/BLE/application calls.
- Build/flash validation: not performed here; manual ArduinoDroid testing is required.
- Production `firmware/JEXFYZ.ino` was not modified by this diagnostic.
- Runtime/root-cause status: unresolved. This test is designed to distinguish `Network.begin()` failure from `esp_wifi_init()` failure using separate Serial boundaries.
- Important correction from prior discussion: absence of an SSID is irrelevant for this low-level diagnostic because AP creation is intentionally not attempted.
- Next boundary: flash the low-level diagnostic and preserve the complete Serial output, especially STEP 1 through STEP 7.
## 2026-09-27 — DISCUSSION: HARDWARE TARGET CONFIRMED

- User reconfirmed the physical hardware target: **ESP32-C3 Super Mini**.
- This is consistent with the physical diagnostic output: Chip = ESP32-C3, Chip revision = 4, and the actual compiled Arduino-ESP32 Core = 3.3.7.
- Manual ArduinoDroid board target remains the project reference: **ESP32C3 Dev Module**.
- The current low-level Wi-Fi diagnostic files are intended for this ESP32-C3 hardware and Core 3.3.7 environment.
- No executable source was changed and no build was executed by this discussion; this is a hardware-target clarification only.
- Next boundary remains the existing low-level Wi-Fi initialization diagnostic; interpret results from Serial rather than SSID visibility when the sketch does not create an AP.
## 2026-09-27 — DISCUSSION: STOP SPECULATIVE TEST GENERATION / VERIFY TOOLCHAIN PATH

- User reported that the low-level diagnostic still does not appear to work. Correction: lack of an SSID is not evidence for `JEXFYZ-Network-Begin-Test.ino` because that sketch intentionally does not create an AP.
- Current confirmed runtime boundary from the preceding test is still `WiFi.mode(WIFI_AP)`: actual Arduino-ESP32 Core reported `3.3.7`, chip `ESP32-C3` revision `4`, `WiFi.getMode()` returned `0`, and `WiFi.mode(WIFI_AP)` was followed by a Core 0 Load access fault before returning.
- The result of `Network.begin()` itself is still unverified because its Serial output has not been provided.
- Discussion decision: stop generating speculative diagnostic sketches until the previous boundary is verified. The next evidence required is the complete Serial output from `JEXFYZ-Network-Begin-Test.ino` and/or the ArduinoDroid compile log showing the actual selected WiFi library/core paths.
- Toolchain/library selection must be checked because `ESP.getCoreVersion()` proves the Arduino core version but does not by itself prove that no conflicting external `WiFi.h` library was selected by the build environment.
- No executable source was changed and no build was executed in this discussion.
- Next boundary: inspect the ArduinoDroid compile log and the actual Network-begin Serial result before choosing another test. The official Core 3.3.7 source remains the authority; do not add more custom Wi-Fi lifecycle code until the selected library and current failure boundary are established.
> Current-state override for the next JE X FYZ firmware sub-chat. Historical sections below are retained for chronology.

## 1. Mandatory workflow
Before every firmware conversation or action, read this note and the firmware master context, then inspect the newest `firmware/JEXFYZ.ino`. For cross-layer work, read the app context as well.
The living notes are passive project memory and must continue to grow during both discussion and execution. A discussion may update notes to record decisions, verified findings, contradictions, open questions, and next boundaries without changing executable source.
After every material discussion or action, immediately record the discussion/action, reason, affected file/repository when applicable, actual result or current finding, commit/run/version when available, unresolved issue, and next boundary.
Code edits and build execution remain locked until the user explicitly commands `Eksekusi Full`.

## 2. Official-source-first
Pinned platform: Arduino-ESP32 Core 3.3.7.
Official source repository:
https://github.com/espressif/arduino-esp32
Verified references:
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/examples/WiFiAccessPoint/WiFiAccessPoint.ino
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/WiFiAP.cpp
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/AP.cpp
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/WiFiGeneric.cpp
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/STA.cpp

Official AP path verified:
`WiFi.softAP(ssid, password)` → `AP.begin()` + `AP.create()` → `WiFi.enableAP(true)` → official `WiFiGenericClass::mode()` path.
`AP.begin()` waits for `ESP_NETIF_STARTED_BIT`.

Rule: do not invent a custom radio lifecycle when the pinned upstream implementation already provides the required behavior.

## 3. Active firmware state
- Active source diagnostic version: V1.1
- V1.0 remains the prior physically unvalidated baseline.
- Source: `firmware/JEXFYZ.ino`
- BLE name: JE X FYZ
- Protocol: P1
- Target: ESP32-C3 Super Mini
- Current authoritative pins: GPIO0 NTC, GPIO1 touch, GPIO3 12V, GPIO4 9V, GPIO5 Fan, GPIO6 Peltier, GPIO7 WS2812B.
- GPIO5/GPIO6 must never be silently swapped.

## 4. V1.0 build evidence
Firmware GitHub Actions Run #66:
- ID 36264460597
- SUCCESS
- Core 3.3.7/ArduinoDroid validation PASS
- ESP32-C3 release compile PASS
- OTA source audit PASS
- artifacts PASS
- public publish PASS

Public binary:
https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.0.bin

Manifest:
https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/manifest.json

CI success is compile/publish evidence only.

## 5. V1.0 physical validation
The user manually flashed V1.0 and reported that the ESP32-C3 **still panics during boot**.
Therefore V1.0 is **NOT physically validated**.
The exact V1.0 Guru Meditation register dump is not yet captured in the notes and must be preserved at the next test.

## 6. Official-source finding and current suspect
The active V1.0 source currently performs:
`WiFi.disconnect(true, false)` → `WiFi.setHostname("JE-X-FYZ")` → `WiFi.setAutoReconnect(false)` → `WiFi.mode(WIFI_AP)` → `WiFi.softAPConfig(...)` → `WiFi.softAP(...)`.

The official Core 3.3.7 example does not require this custom pre-sequence. Because V1.0 still panics, the custom pre-sequence is now **suspect / under investigation**, but it is **not proven** to be the root cause.

## 7. Previous runtime evidence
- V4.13: Core 0 Load access fault during Wi-Fi AP startup.
- V5.0: Core 0 Load access fault around `WiFi.mode(WIFI_AP)`.
- V1.0: physical panic repeated after manual flash.

This repeated pattern requires boundary isolation, not more speculative patch stacking.

## 8. Next diagnostic

## 2026-09-27 — RAW ESP-IDF WIFI BOUNDARY TEST GENERATED
- A standalone diagnostic sketch was generated outside the production firmware:
  `/mnt/data/JEXFYZ-Raw-ESP-IDF-WiFi-Boundary-Test.ino`
- Purpose: isolate the Wi-Fi fault below the Arduino `WiFi.h` wrapper without creating a SoftAP and without adding a custom production radio lifecycle.
- The sketch uses the exact public ESP-IDF calls observed in Arduino-ESP32 Core 3.3.7's `wifiLowLevelInit()` path: `esp_netif_init()`, `esp_event_loop_create_default()`, `WIFI_INIT_CONFIG_DEFAULT()` with the Core 3.3.7 non-static buffer values, `esp_wifi_init()`, `esp_wifi_set_storage(WIFI_STORAGE_RAM)`, `esp_wifi_set_mode(WIFI_MODE_AP)`, `esp_wifi_start()`, and `esp_wifi_get_mode()`.
- The sketch prints a numbered marker before and after every boundary and stops on an unexpected ESP-IDF error.
- It intentionally does **not** call `WiFi.softAP()`, create an AP SSID, or initialize BLE.
- This is diagnostic-only; no production source was changed.
- Validation status: file generation confirmed in the workspace; physical execution result is **NOT YET VERIFIED**.
- Important interpretation: because this test does not create a SoftAP, no SSID is expected. Its purpose is to identify the first failing low-level Wi-Fi call.
- Next evidence boundary: ArduinoDroid compile output and the Serial marker/result from this exact file.


## 2026-09-27 — RAW ESP-IDF TEST FIXED
- The first raw ESP-IDF diagnostic file failed to compile in ArduinoDroid with `redefinition of default argument` because `printResult(..., bool allowAlreadyInit = false)` conflicted with Arduino's generated function prototype.
- A corrected diagnostic file was generated:
  `/mnt/data/JEXFYZ-Raw-ESP-IDF-WiFi-Boundary-Test-FIXED.ino`
- The corrected `printResult()` declaration has **no default argument**; every call supplies the third parameter explicitly.
- Static check: PASS for removal of the default argument.
- Production firmware source was not modified.
- Physical execution and hardware result remain unverified.

## 2026-09-27 — RUNTIME RESULT: RAW ESP-IDF WIFI TEST PANICS AT CONFIG MACRO
- User physically ran `JEXFYZ-Raw-ESP-IDF-WiFi-Boundary-Test-FIXED.ino` in ArduinoDroid and supplied the complete Serial boundary screenshot.
- Confirmed runtime environment: Arduino-ESP32 Core `3.3.7`, chip `ESP32-C3`, revision `4`.
- `esp_netif_init()` returned `ESP_OK` (0x0).
- `esp_event_loop_create_default()` returned `ESP_OK` (0x0).
- The sketch printed `STEP 5: BUILD OFFICIAL CORE 3.3.7 WIFI CONFIG`, then immediately produced `Guru Meditation Error: Core 0 panic'ed (Load access fault)`.
- `STEP 6: WIFI CONFIG READY` was never reached. Therefore this test did **not** reach `esp_wifi_init()`, `esp_wifi_set_mode()`, `esp_wifi_start()`, or AP creation.
- Official ESP-IDF v5.5 source was inspected because Arduino-ESP32 Core 3.3.7 declares its bundled `esp32-arduino-libs` package as `idf-release_v5.5-87912cd2-v3`.
- In the official ESP-IDF v5.5 `esp_wifi.h`, `WIFI_INIT_CONFIG_DEFAULT()` is a designated initializer for `wifi_init_config_t`. It reads the exported `g_wifi_default_wpa_crypto_funcs` object into the local configuration and takes the address of `g_wifi_osi_funcs`; it is not itself a Wi-Fi start/AP call.
- Current diagnostic conclusion: the failure boundary is now **below the Arduino WiFi wrapper and before the `esp_wifi_init()` API call**. A likely class of causes is an invalid/incompatible access while materializing the official Wi-Fi init configuration (for example a header/binary/toolchain/library mismatch), but this is **not yet proven** from the available evidence.
- Important: do not claim that the ESP32 Wi-Fi driver itself is proven faulty. The exact PC-to-symbol mapping is not available because the standalone ArduinoDroid test ELF/map was not captured.
- Required next evidence before another production change or another speculative test: the ArduinoDroid compile output/library-selection information for this exact sketch, including any `Multiple libraries were found` lines and the selected ESP32 core/library paths. This is needed to establish whether the header and linked Wi-Fi binary come from the expected Core 3.3.7 / IDF 5.5 package.
- Production `firmware/JEXFYZ.ino` was not modified by this runtime test.

## 2026-09-27 — DISCUSSION: HORIZON COOLER WIFI PATH COMPARISON
- User supplied the full `HorizonCooler.ino` source for direct comparison with the current JE X FYZ firmware.
- Horizon uses the same public Arduino Wi-Fi operations that JE X FYZ ultimately relies on:
  - `WiFi.mode(WIFI_AP)`
  - `WiFi.softAP("Horizon Cooler")`
  - `server.begin()`
- Horizon does **not** call `WIFI_INIT_CONFIG_DEFAULT()`, `esp_wifi_init()`, `esp_wifi_set_mode()`, or other raw `esp_wifi_*()` APIs. Its Wi-Fi startup is delegated entirely to Arduino's `WiFi.h` implementation.
- Horizon's Wi-Fi AP is **not started during `setup()`**. Normal boot initializes hardware, Preferences, RGB, OTA routes, and then starts BLE through `enableBleSignal()`. The Wi-Fi AP is later entered from the main loop after the user holds the left button for 5 seconds.
- The Horizon Wi-Fi path is:
  `disableAllRadios()` → `WiFi.mode(WIFI_AP)` → `WiFi.softAP("Horizon Cooler")` → `server.begin()`.
- In `disableAllRadios()`, Wi-Fi is only stopped when `isWifiActive == true`; on a normal BLE-only boot this is false, so there is no pre-existing Wi-Fi session that Horizon depends on. BLE advertising is suspended immediately before AP startup.
- Therefore the strongest code-level difference is **runtime/startup timing and radio state**, not the high-level Wi-Fi API itself: Horizon lets the complete boot/BLE initialization finish and only starts AP later from `loop()`; current JE X FYZ starts the AP inside `setup()`.
- A second important difference is diagnostic scope: the recent raw ESP-IDF test directly included `esp_wifi.h` and invoked `WIFI_INIT_CONFIG_DEFAULT()`. Horizon never exercises that macro from sketch code. The raw test's crash at the macro therefore must not be interpreted as proof that Horizon's working Arduino Wi-Fi driver is broken.
- Official Arduino-ESP32 Core 3.3.7 remains authoritative: the Arduino `WiFi.mode()` implementation owns the low-level initialization internally. The Horizon source supports keeping production code at the public Arduino Wi-Fi layer rather than reproducing internal driver initialization.
- Current working hypothesis ranking is therefore:
  1. a boot-time/runtime-state difference between Horizon and JE X FYZ;
  2. an ArduinoDroid/library-selection or binary/header mismatch affecting the JE X FYZ build;
  3. an application-specific interaction that corrupts state before the Wi-Fi call.
  No item is declared proven from source comparison alone.
- Next diagnostic principle: reproduce **Horizon's exact public Wi-Fi sequence**, with no raw `esp_wifi.h` / `WIFI_INIT_CONFIG_DEFAULT()`, but invoke it only after boot has completed and from the main loop. Compare the result with the current immediate-`setup()` failure. This is a diagnostic boundary only; no production feature change has been made.
- Production `firmware/JEXFYZ.ino` was not modified by this discussion.

## 2026-09-27 — EXECUTION: HORIZON-STYLE DEFERRED WIFI AP (V1.2)
- User explicitly authorized `Eksekusi Full`.
- Inspected current production source SHA before editing: `d2e9b210e3c059bbbac62ca0197895a3a8409b3d`.
- Applied one controlled runtime change based on the direct HorizonCooler.ino comparison:
  - active firmware marker advanced from V1.1 to **V1.2** because executable behavior changed;
  - `bootApActive` now starts false;
  - added `bootApPending`;
  - removed the direct `startLocalOtaAp()` call from `setup()`;
  - `setup()` now only marks the boot AP as pending;
  - the first `loop()` iteration consumes `bootApPending` and calls `startLocalOtaAp()`.
- No raw `esp_wifi_*` APIs, `WIFI_INIT_CONFIG_DEFAULT()`, BLE implementation, OTA engine, safety logic, GPIO mapping, NTC logic, PWM logic, or application protocol was changed.
- Purpose: isolate the Horizon-vs-JE difference of **Wi-Fi AP invocation from setup() versus loop()** while retaining the existing official Arduino `WiFi.softAP()` path.
- Source static checks: PASS. Verified V1.2 marker, deferred-start marker, loop-start marker, `bootApActive=false`, and removal of the previous direct setup() AP call.
- Repository commit: `bb4b271c2ef6c21bb779b65008ab24c6f98cd080`.
- Build status at this exact action: not yet executed; the workflow is intentionally triggered separately by its dedicated trigger file.
- Hardware result: not yet verified.
- Diagnostic interpretation: this is a controlled test of startup context/timing, not a claim that Horizon's behavior proves the root cause.
- Next boundary: trigger the existing firmware CI, inspect compile/build result, then physically flash V1.2 and compare the Serial boot boundary.

## 2026-09-27 — EXECUTION: TRIGGER V1.2 FIRMWARE CI
- Updated the dedicated `.github/FIRMWARE_BUILD_TRIGGER` file to start the existing firmware workflow for the V1.2 source.
- Trigger commit: `d7f5110668d64c32d87e08f367c54369474f4306`.
- The workflow remains pinned to Arduino-ESP32 Core 3.3.7, OneButton 2.6.1, and Adafruit NeoPixel 1.12.5.
- No firmware logic changed in this action.
- Next boundary: inspect the newly triggered Firmware Build run for compile result, OTA safety audit, artifact generation, and publication result.

## 2026-09-27 — EXECUTION STATUS: V1.2 FIRMWARE BUILD RUN #67
- Firmware Build Run #67 was triggered successfully from commit `d7f5110668d64c32d87e08f367c54369474f4306`.
- Run ID: `36272350341`.
- Head source/trigger commit: `d7f5110668d64c32d87e08f367c54369474f4306`.
- Current status at this checkpoint: **in_progress**.
- The `validate-arduinodroid` job has started; the later compile step has not yet completed at the time of this note.
- No build success/failure is claimed yet.
- Next boundary: inspect Run #67 completion and its compile/audit/artifact results before declaring V1.2 build status.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 TOOLCHAIN INSTALL
- Run #67 remains `in_progress`.
- Job `validate-arduinodroid` is currently installing the pinned ESP32 Arduino Core `3.3.7`; library installation and compilation have not started yet.
- No compile result is available at this checkpoint.
- No hardware conclusion is implied.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 COMPILATION
- Run #67 toolchain installation completed successfully: Arduino-ESP32 Core 3.3.7 and the pinned firmware libraries installed successfully.
- The ArduinoDroid temporary source preparation also completed successfully.
- The `Compile ArduinoDroid temporary source` step is currently `in_progress`.
- No final compile conclusion is claimed yet.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 ARDUINODROID COMPILE ACTIVE
- The pinned Core 3.3.7/toolchain/library setup is complete and the ArduinoDroid temporary source preparation passed.
- The actual ArduinoDroid compile step is still active; no compile success/failure is claimed yet.
- The source under test remains commit `bb4b271c2ef6c21bb779b65008ab24c6f98cd080` with only the Horizon-style setup→loop Wi-Fi deferral change.

## 2026-09-27 — EXECUTION RESULT: RUN #67 ARDUINODROID COMPILE PASS
- Run #67 job `validate-arduinodroid` completed with **success**.
- ESP32 Arduino Core 3.3.7 installation: PASS.
- OneButton 2.6.1 and Adafruit NeoPixel 1.12.5 installation: PASS.
- ArduinoDroid temporary source preparation: PASS.
- ArduinoDroid temporary source compile for ESP32-C3: **PASS**.
- The second job `build-and-publish` is currently queued; release compile/publication results are not yet available.
- This confirms the V1.2 source compiles under the workflow's pinned ArduinoDroid/Core 3.3.7 toolchain. It does **not** prove physical runtime.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 BUILD/PUBLISH ACTIVE
- The ArduinoDroid validation job passed.
- The dependent `build-and-publish` job has started and is currently preparing the Arduino package index.
- Release compile, OTA protected-source audit, artifact upload, and public firmware publication are still pending.
- No public V1.2 binary is claimed yet.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 CORE INSTALL ACTIVE
- `validate-arduinodroid` remains successful.
- `build-and-publish` is now installing the ESP32-C3 Core 3.3.7 in its release-build job.
- Release firmware compilation and publication remain pending.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 RELEASE COMPILE ACTIVE
- Release job completed Core/library setup and source/audit/version steps.
- The `Compile ESP32-C3 firmware` step is currently `in_progress`.
- No release artifact or public V1.2 firmware is claimed until this compile and subsequent publication steps complete.

## 2026-09-27 — EXECUTION DIAGNOSTIC: BUILD LOG ENDPOINT NOT AVAILABLE THROUGH CONNECTOR
- Attempted to read the active Run #67 job log directly through the GitHub connector's fetch action.
- The connector rejected the job-log endpoint as an unsupported URL for this action; therefore no compile-log interpretation was made from that attempt.
- Run #67 remains the authoritative CI source; continue using its job/step status and final artifacts.

## 2026-09-27 — EXECUTION STATUS CHECKPOINT: RUN #67 RELEASE COMPILE STILL ACTIVE
- ArduinoDroid validation remains **PASS**.
- Release `build-and-publish` job remains `in_progress`.
- `Compile ESP32-C3 firmware` remains `in_progress`; artifact upload and public publication have not started yet.
- No release success/failure is claimed at this checkpoint.

## 2026-09-27 — DISCUSSION: REVIEW OF EXTERNAL GEMINI WIFI-OTA CLAIM
- User supplied screenshots containing an external analysis claiming that the Wi-Fi OTA failure is caused by the project using only a low-level ESP-IDF driver test and lacking active networking/OTA implementation.
- The claim is inconsistent with the actual JE X FYZ source and the diagnostic history:
  - The raw ESP-IDF sketch was explicitly a **diagnostic-only boundary test**, not the production firmware and not the intended OTA implementation.
  - Separate diagnostic sketches already tested the higher-level `WiFi.softAP()` path; the physical `WiFi.softAP()` test reached the call boundary and panicked before returning.
  - The production `firmware/JEXFYZ.ino` contains active local OTA networking: `WebServer webServer(80)`, `WiFi.softAP()`, `webServer.on("/", ...)`, `webServer.on("/update", HTTP_POST, ...)`, `webServer.begin()`, and native `esp_ota_begin/write/end/set_boot_partition`.
  - The production source also contains active online OTA networking through `WiFi.begin()`, `HTTPClient`, `WiFiClientSecure`, HTTPS configuration, and the online OTA state machine.
- Therefore the screenshot's statement that the project "only" uses a low-level ESP-IDF driver test and has no active networking/OTA implementation is **factually incorrect** for the current repository.
- The screenshot nevertheless points at a useful distinction: a raw driver test cannot itself demonstrate functional OTA. That is true, but it does not explain the earlier observed production/SoftAP panic because those were separate tests with higher-level Arduino Wi-Fi APIs.
- Current diagnostic fact remains: the most precise standalone boundary recorded so far is `wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();` in the raw ESP-IDF diagnostic, while the higher-level Arduino boundary previously recorded is `WiFi.mode(WIFI_AP)` / `WiFi.softAP()`. These observations should not be conflated.
- V1.2 has already been created to test one concrete difference found in the working HorizonCooler source: deferring the initial AP invocation from `setup()` into the first `loop()` iteration while keeping the official Arduino Wi-Fi APIs. Run #67 ArduinoDroid/Core 3.3.7 compile validation passed; physical runtime remains pending.
- No production change is made by this discussion.

## 2026-09-27 — USER MANDATE: ARDUINO STANDARD ONLY FOR NEXT FIRMWARE WORK
- User explicitly requires the next firmware implementation/test work to use the **Arduino-standard API/examples**, not custom/invented low-level code.
- For Wi-Fi/OTA, prefer the exact official Arduino-ESP32 Core 3.3.7 public APIs and official examples already verified (for example `WiFi.mode()`, `WiFi.softAP()`, `WebServer`, `Update` where appropriate), following the official lifecycle rather than reproducing internal ESP-IDF initialization.
- Do **not** create homemade wrappers, replacement lifecycle functions, guessed API names, or raw `WIFI_INIT_CONFIG_DEFAULT()` / `esp_wifi_*` startup code for the next production/test path unless the user explicitly requests a low-level diagnostic.
- "Arduino Standard" means: use the implementation style demonstrated by the official Arduino-ESP32 examples/source for the exact pinned Core version; project-specific code may orchestrate those official APIs only where the JE X FYZ requirements require it.
- This mandate supersedes the recent raw ESP-IDF diagnostic approach for the next implementation step. The raw diagnostic remains historical evidence only.
- No executable source changed in this discussion.

## 2026-09-27 — DISCUSSION: OFFICIAL ARDUINO-STANDARD STUDY — CORE 3.3.7
- User requested a full study of the Arduino Standard approach from the official source, with future implementation prohibited from using invented/custom low-level replacements.
- Reviewed the official Espressif Arduino-ESP32 Core 3.3.7 repository documentation and source/examples for the areas directly relevant to JE X FYZ:
  - Wi-Fi API: `docs/en/api/wifi.rst`, official `WiFiAccessPoint.ino`, and the WiFi AP/STA classes.
  - Web OTA: `docs/en/ota_web_update.rst` and official `libraries/WebServer/examples/WebUpdate/WebUpdate.ino`.
  - Network API: `docs/en/api/network.rst`.
  - Arduino OTA: `libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino`.
  - HTTP update: `libraries/HTTPUpdate/examples/httpUpdate/httpUpdate.ino`.
  - Web OTA server: `libraries/HTTPUpdateServer/examples/WebUpdater/WebUpdater.ino`.
  - BLE server: `libraries/BLE/examples/Server/Server.ino`.
  - LEDC/PWM: official ESP32 LEDC examples and 3.x API behavior.
  - ADC/GPIO/timer documentation and examples.
  - 2.x→3.x migration guide for API changes.
- Key official Wi-Fi rule confirmed: the public Arduino path is the intended sketch-level API. The official AP example calls `WiFi.softAP(ssid, password)`; the Arduino core internally owns Wi-Fi initialization/startup. Sketch code should not recreate `WIFI_INIT_CONFIG_DEFAULT()` or `esp_wifi_init()` for ordinary Wi-Fi startup.
- Key official Web OTA rule confirmed: the official `WebUpdate.ino` uses `WiFi.h`, `NetworkClient.h`, `WebServer.h`, and `Update.h`; upload handling uses the Arduino `Update.begin()/write()/end(true)` lifecycle and `server.handleClient()` in `loop()`.
- Key official Arduino OTA rule confirmed: `ArduinoOTA.begin()` is paired with `ArduinoOTA.handle()` from `loop()`; Wi-Fi connection is established first.
- Key official network architecture rule confirmed: Core 3.x exposes a unified `Network` layer and `NetworkClient`/server classes; Wi-Fi implementations sit on that layer.
- Key official 3.x GPIO/PWM/timer direction confirmed: use the current Arduino APIs/examples for the target Core; for LEDC the Core 3.3.7 examples use pin-centric APIs such as `ledcAttach()`, `ledcWrite()`, `ledcChangeFrequency()`, and `ledcDetach()`.
- Important implementation discipline for JE X FYZ:
  1. Prefer official Arduino public API/example patterns over reproducing internal driver code.
  2. Do not invent wrapper functions that duplicate official lifecycle behavior.
  3. Use the exact Core 3.3.7 signatures verified in source/docs; do not rely on older 2.x signatures.
  4. For callbacks/events, respect the official thread/task-safety warnings.
  5. Keep project-specific state machines only where they implement JE X FYZ product requirements, not as replacements for framework initialization.
- Official source links retained as authoritative:
  - https://github.com/espressif/arduino-esp32/tree/3.3.7
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/examples/WiFiAccessPoint/WiFiAccessPoint.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WebServer/examples/WebUpdate/WebUpdate.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/HTTPUpdate/examples/httpUpdate/httpUpdate.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/HTTPUpdateServer/examples/WebUpdater/WebUpdater.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/docs/en/api/wifi.rst
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/docs/en/ota_web_update.rst
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/docs/en/migration_guides/2.x_to_3.0.rst
- This was a discussion/source-study action only. No executable project source was changed by this study.
- Next implementation boundary: when the user authorizes the next firmware execution, build from the official Arduino Standard examples/APIs for Core 3.3.7 rather than from the recent raw ESP-IDF diagnostic sketches.

## 2026-09-27 — USER MANDATE CONFIRMED: ARDUINO STANDARD IS THE IMPLEMENTATION BASELINE
- User explicitly confirmed that, from this point onward, JE X FYZ firmware implementation must follow **Arduino Standard** for the pinned Arduino-ESP32 Core 3.3.7.
- This is now a standing implementation rule, not merely a preference for the current Wi-Fi investigation.
- For platform functionality, use official Arduino-ESP32 public APIs and official examples/source for Core 3.3.7 first.
- Do not replace official Arduino abstractions with handwritten ESP-IDF startup/lifecycle code when an official Arduino API already provides the required operation.
- Project-specific state machines, safety logic, OTA policy, BLE protocol, and hardware behavior remain allowed only as application logic around the official Arduino APIs; they must not impersonate or replace framework internals.
- Any future API/signature must be verified against the exact Core 3.3.7 official source before use.
- The recent raw ESP-IDF diagnostic files remain diagnostic evidence only and are not the implementation template.
- No executable source was changed by this confirmation.


## 2026-09-27 — V1.3 ARDUINO STANDARD SOURCE AUDIT / MINIMAL AP ORDER FIX
- Audited the current firmware/JEXFYZ.ino V1.3 source on main against the official Arduino-ESP32 Core 3.3.7 public source and examples.
- Confirmed the current source contains zero occurrences of the previously prohibited low-level ESP-IDF implementation markers: esp_ota_*, esp_err_t, esp_err_to_name, ESP_ERR_*, esp_err.h, esp_ota_ops.h, FreeRTOS/portMUX lifecycle includes, and BLE configuration macros CONFIG_BLUEDROID_ENABLED / CONFIG_NIMBLE_ENABLED.
- Confirmed the Arduino Update lifecycle is the official Core 3.3.7 API: Update.begin(), Update.write(), Update.end(true), Update.abort(), and Update.printError(Serial).
- Confirmed Core 3.3.7 LEDC usage is pin-centric through ledcAttach() / ledcWrite(); no legacy ledcSetup() / ledcAttachPin() remains.
- Confirmed ADC/GPIO, Preferences, WebServer, HTTPClient, WiFiClientSecure, OneButton 2.6.1, and Adafruit NeoPixel 1.12.5 calls used by the source match public APIs verified against the pinned versions.
- Confirmed BLE lifecycle calls used by the source (BLEDevice::init, getInitialized, createServer, setMTU, startAdvertising, deinit, service/characteristic creation) exist in the official Core 3.3.7 BLE headers/examples.
- Confirmed Wi-Fi startup/handoff uses Arduino APIs only and BLE is not started while the boot AP owns the radio.
- Found one concrete source-level alignment issue: the V1.3 Local AP startup called WiFi.softAP() before WiFi.softAPConfig(). Core 3.3.7 official APOTA source uses the opposite order (softAPConfig() then softAP()); the production source was minimally reordered to match that official Arduino pattern.
- No BLE UUID, command vocabulary, safety logic, GPIO mapping, OTA diagnostics, or firmware feature behavior was intentionally changed by the audit.
- GPIO contract remains GPIO5 = PELTIER and GPIO6 = FAN.
- V1.3 remains a release candidate only. CI Core 3.3.7 compile and publish are still required before calling it final/public.

## 2026-09-27 — V1.3 POST-PATCH STATIC AUDIT PASS
- Re-read the updated firmware/JEXFYZ.ino after the minimal SoftAP order change.
- V1.3 identity is intact.
- Forbidden ESP-IDF lifecycle markers remain at zero.
- Legacy LEDC APIs ledcSetup()/ledcAttachPin() remain absent.
- Local AP order is now verified as WiFi.softAPConfig() before WiFi.softAP().
- Required Arduino Update lifecycle calls remain present: begin/write/end(true)/abort/printError.
- GPIO mapping remains GPIO5 = PELTIER and GPIO6 = FAN.
- This static check does not replace the required Core 3.3.7 CI compile.

## 2026-09-27 — RUN #68 COMPILE ROOT CAUSE / V1.3 CORE 3.3.7 FIX
- CI Run #68 reached the pinned Arduino-ESP32 Core 3.3.7 toolchain and failed only in the ArduinoDroid temporary-source compile before the release job.
- Compiler root cause #1: Core 3.3.7 EspClass has no getResetReason() member. Official Core 3.3.7 search/source verification found no Arduino ESP.getResetReason()/getResetInfo() wrapper. The production sync field RESET_REASON is therefore retained but now reports the explicit non-fabricated value UNAVAILABLE_CORE_3_3_7 instead of calling a nonexistent API.
- Compiler root cause #2: stale bleConnectionId = BLE_INVALID_CONN_ID remained after the callback/low-level cleanup, but neither symbol is declared or required by the current Arduino BLE implementation. The unused assignment was removed; BLE UUIDs/protocol and callback behavior were not changed.
- Compiler root cause #3: the official Core 3.3.7 Update.write() signature requires uint8_t*, while the Stream adapter receives const uint8_t*. The adapter now uses const_cast<uint8_t*> only at the official API boundary; official Update.cpp was verified to copy/read the supplied bytes and not modify the input buffer.
- No raw ESP-IDF Wi-Fi/OTA lifecycle was reintroduced. The fixes stay at Arduino/application boundaries and preserve the existing OTA state machine, diagnostics, safety, and radio handoff.
- GPIO mapping remains GPIO5 = PELTIER and GPIO6 = FAN.
- V1.3 is still not release-final/public. A new Core 3.3.7 CI run is required after this fix.

## 2026-09-27 — RUN #69 FINAL CI / ARTIFACT / PUBLIC V1.3 VERIFIED
- Run #69 (`36274477621`) completed successfully on the pinned Arduino-ESP32 Core 3.3.7 toolchain.
- `validate-arduinodroid`: PASS, including the real ArduinoDroid temporary-source compile.
- `build-and-publish`: PASS, including source identity audit, OTA protected-source audit, ESP32-C3 release compile, firmware artifact upload, ArduinoDroid source artifact upload, and public firmware publication.
- Release firmware artifact: `JEXFYZ-V1.3`, 1,465,728 bytes, not expired at verification time.
- ArduinoDroid source artifact: `JEXFYZ-V1.3-ArduinoDroid-Source`, 104,150 bytes, not expired at verification time.
- Final ArduinoDroid `.ino` extracted from the CI source artifact was verified to contain FW_VERSION V1.3, the Core 3.3.7 reset-reason compatibility value `UNAVAILABLE_CORE_3_3_7`, the official Update.write() mutable-buffer adapter, the official SoftAP config-before-start order, and no audited legacy/raw lifecycle markers.
- Public repository `TenzoNkz/JEXFYZ-Firmware` was verified to contain `JEXFYZ-V1.3.bin` and a manifest pointing to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.3.bin`.
- This is the first verified V1.3 CI/public-release completion after the Core 3.3.7 compile fixes. Physical ESP32-C3 flashing/runtime validation is still a separate hardware step and has not been claimed here.

## 2026-09-27 — EXECUTION: WIFI STA-MODE BOUNDARY DIAGNOSTIC
- Current repository source remains the verified V1.3 Arduino-Standard firmware; no production firmware logic was changed.
- Because standalone Core 3.3.7 testing previously showed a panic at the public `WiFi.mode(WIFI_AP)` boundary, the next diagnostic isolates the sibling public STA-mode initialization path.
- Added diagnostic file: `firmware/diagnostics/JEXFYZ-WiFi-STA-Mode-Test.ino`.
- Scope is intentionally minimal: `Arduino.h`, `WiFi.h`, official `ESP.getCoreVersion()`, `ESP.getChipModel()`, `ESP.getChipRevision()`, `WiFi.getMode()`, `WiFi.mode(WIFI_STA)`, and `WiFi.status()`.
- The sketch contains explicit Serial markers immediately before and after `WiFi.mode(WIFI_STA)`; it does not use WebServer, Update, BLE, Preferences, NTC, PWM, RGB, raw ESP-IDF Wi-Fi lifecycle, or project-specific startup code.
- Diagnostic commit: `e8185cb24acb7475a533a859208156b43ecd4c03`.
- Interpretation boundary: if STEP 3 is reached, generic Arduino Wi-Fi initialization can complete in STA mode and the remaining fault is AP-specific; if the board panics between STEP 2 and STEP 3, the failure is below the AP-specific path and production OTA/AP changes should not be attempted blindly.
- Next boundary: compile/flash this diagnostic under the same ArduinoDroid + Arduino-ESP32 Core 3.3.7 setup and preserve the complete Serial output.

## 2026-09-27 — EXECUTION: PURE ARDUINO RUNTIME BOUNDARY DIAGNOSTIC
- User explicitly authorized execution.
- Added diagnostic file: `firmware/diagnostics/JEXFYZ-Pure-Arduino-Runtime-Test.ino`.
- Scope is the smallest Arduino-layer test currently needed: `Arduino.h`, `Serial`, `millis()`, and official Arduino ESP APIs for Core version/chip information.
- No `WiFi.h`, WebServer, Update, BLE, Preferences, NTC, PWM, RGB, or ESP-IDF API is used.
- Serial markers identify entry into `setup()`, the installed Arduino-ESP32 Core version, chip model/revision, successful setup completion, and a 1-second loop heartbeat.
- Diagnostic commit: `9c64bb01e2a22beada7d56116cdd879736a76af1`.
- Purpose: establish whether the board reaches and remains in the Arduino sketch runtime before any Wi-Fi initialization is involved.
- Build/flash was not executed in the current environment; manual ArduinoDroid + Arduino-ESP32 Core 3.3.7 testing remains the next boundary.
- Production `firmware/JEXFYZ.ino` remains unchanged.
- Required evidence: capture output from the first diagnostic line through at least several `HEARTBEAT: LOOP OK` lines, or the complete panic if it resets before/after `setup()`.

## 2026-09-27 — EXECUTION: MINIMAL ARDUINO WIFI + OTA TEST
- User requested a simpler firmware test instead of layered diagnostics.
- Added `firmware/diagnostics/JEXFYZ-Simple-WiFi-OTA-Test.ino`.
- Arduino-Standard scope only: `Arduino.h`, `WiFi.h`, `WebServer.h`, and `Update.h`.
- Wi-Fi uses the direct official `WiFi.softAP(ssid, password)` path with no custom `softAPConfig()`, no manual Wi-Fi mode calls, and no project-specific startup logic.
- OTA uses the standard WebServer upload route with `Update.begin(UPDATE_SIZE_UNKNOWN)`, `Update.write()`, `Update.end(true)`, `Update.abort()`, and `Update.printError(Serial)`.
- No BLE, NTC, Fan/Peltier, RGB, Preferences, Adaptive, raw ESP-IDF lifecycle, or custom radio wrapper is included.
- Diagnostic commit: `f30263cb756877dc883d2eeae5cb924b95160b39`.
- Production `firmware/JEXFYZ.ino` remains unchanged.
- Build/flash execution remains on the user's ArduinoDroid + Core 3.3.7 environment.
- Expected baseline: SSID `JE X FYZ OTA`, password `0987654321`, AP address normally reported by `WiFi.softAPIP()`.


# CURRENT STATE — 2026-09-27 06:00 WIB

## VERIFIED RUNTIME BASELINE: MINIMAL ARDUINO WIFI AP WORKS
- Physical test result from the user's ESP32-C3: diagnostic firmware `JEXFYZ-Simple-WiFi-OTA-Test.ino` successfully exposed the Wi-Fi SSID `JE X FYZ OTA`.
- The phone's Wi-Fi scan visibly showed `JE X FYZ OTA` under Available networks.
- Therefore the board's basic Wi-Fi SoftAP function works with Arduino-ESP32 Core 3.3.7 when using the simple official Arduino path:
  ```
  WiFi.softAP(ssid, password);
  ```
- This directly corrects the earlier unproven assumption that the board/runtime Wi-Fi subsystem itself was necessarily the root cause.
- The successful simple test did not include BLE, NTC, Fan/Peltier, RGB, Preferences, Adaptive logic, custom radio supervisors, manual Wi-Fi mode setup, `softAPConfig()`, or raw ESP-IDF lifecycle code.
- Current conclusion: do not add custom Wi-Fi initialization layers merely to start the AP.

## PERMANENT IMPLEMENTATION RULE — ARDUINO STANDARD + SIMPLE
- Use the public Arduino-ESP32 Core 3.3.7 APIs and the official Arduino example/lifecycle pattern for the required function.
- Prefer the smallest official implementation that satisfies the JE X FYZ requirement.
- Do not invent API names, wrappers, compatibility shims, low-level lifecycle replacements, or guessed ESP/Arduino functions.
- Do not recreate work already owned by the Arduino framework.
- Do not introduce `WiFi.mode()`, `WiFi.disconnect()`, `WiFi.setHostname()`, `WiFi.setSleep()`, `WiFi.setAutoReconnect()`, `softAPConfig()`, or similar startup operations into the production AP path unless a verified Core 3.3.7 requirement proves they are necessary.
- For OTA, use the official Arduino Update lifecycle: `Update.begin()`, `Update.write()`, `Update.end(true)`, `Update.abort()`, and `Update.printError(Serial)`.
- When a platform API is uncertain, stop and verify against the exact pinned Core 3.3.7 source before using it.
- Every production change must compile in the project's pinned Core 3.3.7 CI before being treated as valid.

## PRODUCTION FIRMWARE SAFETY
- Authoritative production source remains `firmware/JEXFYZ.ino` V1.3.
- The production source is not replaced by any diagnostic sketch.
- Diagnostic sketches under `firmware/diagnostics/` are isolated tests only.
- The verified V1.3 release remains the last known-good CI/public build baseline.
- Do not claim physical V1.3 production runtime success merely from CI success; physical production validation remains separate.
- GPIO contract remains GPIO5 = PELTIER and GPIO6 = FAN.

## NEXT FULL EXECUTION BOUNDARY
- The next production execution is ready to be scoped around the verified simple Arduino Wi-Fi/OTA pattern.
- Do not redesign the whole firmware or add another diagnostic layer.
- Preserve JE X FYZ application behavior, BLE UUID/protocol, safety logic, NTC, PWM, RGB, Adaptive logic, settings persistence, and GPIO mapping unless a specific verified issue requires a change.
- Simplify only the production Wi-Fi/OTA startup path where the current implementation is more complex than the proven Arduino Standard baseline.
- After the source change: run the pinned Core 3.3.7 compile/audit, then produce the firmware artifact, and only after that perform the physical test.
- If a new production firmware behavior is created, version it according to the project's existing V1.x sequence rather than silently replacing V1.3.

## LATEST DIAGNOSTIC ARTIFACTS
- `firmware/diagnostics/JEXFYZ-Simple-WiFi-OTA-Test.ino` — commit `f30263cb756877dc883d2eeae5cb924b95160b39`; physical Wi-Fi SSID visibility: PASS.
- `firmware/diagnostics/JEXFYZ-WiFi-STA-Mode-Test.ino` — commit `e8185cb24acb7475a533a859208156b43ecd4c03`; earlier physical output did not expose the sketch banner, so its STA boundary remains non-diagnostic.
- `firmware/diagnostics/JEXFYZ-Pure-Arduino-Runtime-Test.ino` — commit `9c64bb01e2a22beada7d56116cdd879736a76af1`; physical test did not produce visible sketch output in the reported Monitor session.
- The successful Simple Wi-Fi + OTA baseline supersedes the need to continue stacking lower-level Wi-Fi diagnostics unless the simple production pattern itself fails.

## NOTE GOVERNANCE
- This block is the current authoritative operational state and supersedes conflicting earlier hypotheses in the historical log.
- Historical diagnostics are retained for traceability and must not be treated as the current implementation recipe.

## 2026-09-27 — EXECUTION: PRODUCTION V1.4 SIMPLE ARDUINO WIFI BASELINE
- User explicitly authorized full code + firmware execution and requested a manual OTA-ready `.bin`.
- Production source `firmware/JEXFYZ.ino` changed from V1.3 to **V1.4**.
- Production Local SoftAP startup was minimally simplified to the exact path proven physically on the user's ESP32-C3:
  `WiFi.softAP(AP_SSID, AP_PASSWORD)`.
- Removed only the extra Local AP configuration/startup calls from that production boundary: `WiFi.softAPConfig()` and its associated AP configuration result handling.
- No BLE, NTC, Fan/Peltier, RGB, Adaptive, GPIO, settings persistence, BLE UUID/protocol, or online OTA behavior was intentionally redesigned in this execution.
- The production source continues to use the Arduino `Update.h` lifecycle for local/online OTA and the existing OTA safety supervisor/diagnostic policy.
- Source commit: `bf923ba37bdaee96b9f870318401c0d04061e8ff`.
- Pre-CI static sanity check: V1.4 marker present; Local AP contains direct `WiFi.softAP(AP_SSID, AP_PASSWORD)`; `WiFi.softAPConfig()` is absent from production source; GPIO5=Peltier and GPIO6=Fan remain intact; legacy LEDC and audited raw lifecycle markers remain absent.
- Required validation boundary: pinned Arduino-ESP32 Core 3.3.7 ArduinoDroid compile, release compile, OTA protected-source audit, artifact upload, and publication must all pass before the V1.4 binary is presented as verified.
- Physical runtime of V1.4 is not claimed until the user manually flashes the resulting binary.

## 2026-09-27 — RUN #70 COMPILE ERROR / IMMEDIATE FIX
- Run #70 failed only at the ArduinoDroid/Core 3.3.7 compile boundary.
- Exact compiler error: `const apOk = WiFi.softAP(AP_SSID, AP_PASSWORD);` is invalid C++ because the local variable type was omitted.
- No platform/API error was reported; the failure was a source typo introduced during the V1.4 simplification.
- Corrected exactly one line to `const bool apOk = WiFi.softAP(AP_SSID, AP_PASSWORD);`.
- Corrective source commit: `af86fe1db68987acd5d8da01f4f2e0e6a6fe26ce`.
- No other production logic was changed by this correction.
- Run #70 release job was correctly skipped because the validation compile failed.
- Next boundary: rerun the same pinned Core 3.3.7 ArduinoDroid validation and then the release build/publish. No binary from Run #70 is valid for OTA.

## 2026-09-27 — RUN #71 FINAL V1.4 BUILD / ARTIFACT / PUBLICATION PASS
- Run #71 (`36278510756`) completed successfully.
- `validate-arduinodroid`: PASS, including Arduino-ESP32 Core 3.3.7 installation, pinned library installation, ArduinoDroid temporary-source preparation, and ESP32-C3 compile.
- `build-and-publish`: PASS, including firmware source identity audit, version extraction, OTA protected-source audit, ESP32-C3 release compile, artifact upload, ArduinoDroid source artifact upload, and publication to `TenzoNkz/JEXFYZ-Firmware`.
- Production firmware source commit: `af86fe1db68987acd5d8da01f4f2e0e6a6fe26ce`.
- Final firmware version: **V1.4**.
- Final release binary: `JEXFYZ-V1.4.bin`, **1,465,280 bytes**.
- Final artifact ZIP was downloaded and extracted locally; the binary file was present and non-empty.
- Public firmware repository was verified to contain `JEXFYZ-V1.4.bin` at 1,465,280 bytes.
- Public manifest was verified as:
  ```
  {
    "version": "V1.4",
    "url": "https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.4.bin"
  }
  ```
- CI validation is therefore PASS; this does not yet constitute physical V1.4 runtime validation on the user's board.

# OTA POLICY — AUTHORITATIVE CORRECTION / SAFETY RULES — 2026-09-27

## FINAL USER-DEFINED VERSION POLICY
- **Local OTA:** version policy is completely bypassed. A valid compatible `.bin` may be flashed regardless of whether its version is older, equal, or newer than the installed firmware. This explicitly supports downgrade, same-version reflashing, recovery, and repeated OTA testing.
- **Online OTA:** a version update is allowed whenever the remote firmware version is **different** from the currently installed `FW_VERSION`.
- **Online same-version behavior:** when the remote manifest version equals the currently installed firmware version exactly, the device/app must report **Up to date** and must not perform an OTA flash.
- **Online does NOT require the remote version to be newer.** Example: installed V1.4 may receive remote V1.3 or V1.5; installed V1.4 receiving remote V1.4 is Up to date.
- Version comparison is therefore an **equal-vs-different gate**, not a greater-than upgrade-only gate.
- These rules are product policy and must not be silently changed by future implementation work.

## OTA LIFE-SAFETY / RELEASE-GATE RULE
- User explicitly states that OTA integrity is a critical survival requirement for the project: **OTA must not be knowingly broken or released with an unresolved OTA error**.
- Treat OTA as a protected/core subsystem. Do not trade OTA reliability for unrelated feature changes.
- A firmware binary must **never** be presented to the user as OTA-ready merely because the source compiles.
- Before delivering a production OTA `.bin`, require at minimum:
  1. pinned Arduino-ESP32 Core 3.3.7 compile PASS;
  2. ArduinoDroid temporary-source compile PASS;
  3. OTA protected-source audit PASS;
  4. release artifact exists and is non-empty;
  5. artifact contents match the intended firmware version/source revision;
  6. public firmware manifest/link is verified when publication is part of the build;
  7. any known OTA runtime failure remains explicitly marked as unresolved and is not declared fixed without evidence.
- If any release-gate check fails, stop the release and fix the failure before presenting a production binary.
- Never conceal or work around an OTA failure merely to make the upload appear successful.
- Keep Local OTA and Online OTA policy separate so that a version-gate change cannot accidentally alter image validation or flash-writing safety.
- Local OTA must still reject invalid/corrupt/incompatible images through the normal Arduino Update validation path; "no version restriction" does **not** mean "accept arbitrary bytes".
- Online OTA must retain the same image/space/flash validation safety in addition to the equal-vs-different version gate.

## CURRENT DEBUG LESSON — LOCAL OTA CODE 8
- The user's physical V1.4 Local OTA test reached 100% upload and then reported:
  `LOCAL_IMAGE_VERIFY | UPDATE_END_FAILED | code 8`.
- This is an **image verification/end-of-update failure**, not evidence that a same-version file should be blocked by version policy.
- Do not solve this failure by adding a version check.
- The local same-version/downgrade requirement must be implemented independently from the `Update.end(true)` image-validation path.

## HISTORY / NO-REPEAT RULE
- The notes are the project's technical life-history and are to be expanded after every meaningful discussion and execution.
- Historical failed approaches remain recorded for traceability, but current implementation must follow the latest authoritative policy block.
- Do not resurrect superseded hypotheses simply because they appear earlier in the file.
- Do not repeat a diagnostic test when the same boundary has already been conclusively established.
- Prefer a small, evidence-driven change over a large refactor.

## CURRENT AUTHORITATIVE PRODUCTION STATE
- Production source: `firmware/JEXFYZ.ino`
- Current production version: **V1.4**
- V1.4 simple Arduino Wi-Fi baseline: physically verified SSID visibility.
- V1.4 CI Run #71: compile, audit, artifact, and publication PASS.
- Physical V1.4 Local OTA test: **FAILED at `Update.end(true)` with code 8**. Therefore local OTA runtime is **not yet considered fixed** despite CI PASS.
- Physical V1.4 BLE + main application visibility/function: user reported BLE appears and application features work after V1.4 was flashed.
- This means the next OTA work must focus specifically on the Local OTA verification failure while preserving the working Wi-Fi/BLE/application baseline.

## NEXT OTA IMPLEMENTATION BOUNDARY
- Implement the version policy exactly as defined above:
  - Local = no version equality/newer/older restriction.
  - Online = different version allowed; same version => Up to date/no flash.
- Separately investigate and fix the physical Local OTA `UPDATE_END_FAILED` code 8 using the official Arduino-ESP32 Core 3.3.7 Update path.
- Do not redesign BLE, NTC, cooling, RGB, Adaptive, GPIO, or unrelated application features while fixing this OTA issue.
- Every OTA code modification requires a fresh pinned Core 3.3.7 validation before another physical flash test.

## 2026-09-27 — EXECUTION: LOCAL OTA CODE-8 ROOT-CAUSE CORRECTION / V1.5
- User provided physical V1.4 Local OTA evidence: upload reached 100%, then the UI reported `LOCAL_IMAGE_VERIFY | UPDATE_END_FAILED | code 8`.
- Verified the uploaded V1.4 binary itself is a valid ESP32 image: first byte is `0xE9` (ESP image magic), file size 1,465,280 bytes, SHA-256 `d0d1a83711774a13f58d61070d6ff37ffaf5b17c394c3188cbb9a767898c07b2`.
- Verified official Arduino-ESP32 Core 3.3.7 `Update.h` defines `UPDATE_ERROR_MAGIC_BYTE = 8`, but also exposes `getError()` and `errorString()`.
- Root-cause in JE X FYZ diagnostics: the Local OTA failure path was hardcoding `OTA_ERROR_MAGIC_BYTE` (code 8) whenever `Update.end(true)` returned false. Therefore the UI's code 8 did **not** identify the actual Update failure at that stage.
- Verified official Core 3.3.7 WebUpdate example uses the simple Arduino lifecycle `Update.begin()` -> `Update.write()` -> `Update.end(true)`.
- Production Local OTA was changed to use the official simple `Update.begin()` call instead of `Update.begin(localOtaExpectedBytes)`.
- Production Local OTA failure reporting now captures the real `Update.getError()` and `Update.errorString()` before calling the project failure handler, instead of inventing a magic-byte error code.
- Production firmware version advanced to **V1.5** because Local OTA runtime behavior changed.
- Source commit for version bump/final source: `a36c4fa7748b3e9369a92ab1c583f177a0b13705`.
- The change is intentionally limited to Local OTA begin/end error handling and uses the official Arduino Update API pattern. BLE, NTC, Fan/Peltier, RGB, Adaptive, GPIO, settings, online OTA protocol, and app behavior were not intentionally redesigned.
- **Important unresolved runtime status:** V1.4 failed Local OTA at `Update.end(true)`. The V1.5 source fix has not yet been physically tested. Therefore V1.5 must not be declared OTA-fixed until a physical Local OTA upload succeeds.
- Release gate: V1.5 must pass ArduinoDroid/Core 3.3.7 compile, release compile, OTA protected-source audit, artifact verification, and publication before any V1.5 binary is delivered for manual testing.

## 2026-09-27 — RUN #72 FINAL V1.5 LOCAL OTA FIX BUILD PASS
- Run #72 (`36279605827`) completed successfully.
- ArduinoDroid/Core 3.3.7 validation compile: PASS.
- Release ESP32-C3 compile: PASS.
- OTA protected-source audit: PASS.
- Firmware artifact upload: PASS.
- ArduinoDroid source artifact upload: PASS.
- Public firmware publication: PASS.
- Final production source commit: `a36c4fa7748b3e9369a92ab1c583f177a0b13705`.
- Final firmware version: **V1.5**.
- Final binary extracted from the CI artifact: `JEXFYZ-V1.5.bin`, **1,465,488 bytes**.
- Local binary integrity inspection: first byte is `0xE9` (ESP image magic); SHA-256 `c9baa2f8bf263ca51a0909a772300d8bd49e69b0c641b206e3bc3c1953c15eb8`.
- The binary is derived from Run #72's successful release artifact, not the previously failed Run #70.
- V1.5 is **not yet physically proven to complete Local OTA**. The purpose of this release is to test the corrected official Arduino Update flow on the actual device.
- Next required hardware test: upload V1.5 through the Local OTA page using the same device/AP that previously produced `UPDATE_END_FAILED`. Preserve the complete OTA result message and, when available, Serial output.

## 2026-09-27 — WORKFLOW RULE: CODE EXECUTION VS NOTE EXECUTION
- **CODE/REPOSITORY EXECUTION RULE:** Never modify production firmware, diagnostic code, CI workflow, build trigger, release artifact, or other executable project files unless the user explicitly commands execution (for example: "Eksekusi", "Eksekusi Code", "Eksekusi Firmware", or an equivalent explicit command).
- Discussion, approval, planning, screenshots, or requests for analysis do not authorize executable-code changes.
- **NOTES AUTO-UPDATE RULE:** Project history/notes must be updated automatically whenever a meaningful decision, requirement, test result, error, correction, or workflow rule is established in discussion. No separate execution command is required for notes.
- Notes are the project's technical life-history and must record both successful and failed experiments, including the exact boundary, version, commit, error, and resulting decision when those facts are available.
- Current priority remains **Local OTA first**. Online OTA implementation changes are frozen until Local OTA has been physically verified working.
- Latest physical result recorded by user: device was still running V1.4; manual Local OTA to V1.5 failed; Online OTA to V1.5 also failed.
- Next code execution, when explicitly authorized, must focus only on making **Local OTA robust and repeatable** using the official Arduino-ESP32 Core 3.3.7 API/pattern. Do not modify Online OTA in that execution.

## 2026-09-27 — PHYSICAL TEST PLAN LOCKED
- User-defined physical validation sequence:
  1. Flash **V1.5 manually** first.
  2. Verify normal V1.5 startup and application operation.
  3. Manually flash different firmware versions upward/downward to establish that manual flashing behaves correctly.
  4. Test **Local OTA** on the running device, including version changes and the previously failing OTA path.
  5. Record the exact Local OTA result before making any further OTA changes.
  6. Only after Local OTA is physically verified working, resume discussion/implementation of **Online OTA**.
- **Online OTA is frozen during this validation sequence.**
- No production code, firmware source, build, or release changes are authorized merely by this discussion; explicit execution command is still required.
- Notes/history must continue to update automatically as physical test results are reported.

## 2026-09-27 — WORKFLOW VISIBILITY RULE
- User requested explicit progress explanations during every active work session, modeled on the visible GitHub Actions/workflow-style status shown in screenshots.
- For future repository/code/build/audit work, provide clear progress messages before and after meaningful tool operations.
- Progress messages should state, when applicable:
  - **Checking**: what file/API/workflow/source boundary is being inspected and why.
  - **Updating**: what is being changed and the narrow reason for the change.
  - **Verified**: the exact result of a check or build step.
  - **Waiting**: when a GitHub Actions job/build is still running.
  - **Error**: the exact verified error and its cause, without speculation.
  - **Next**: the next concrete step and what evidence is required.
- Keep these progress messages factual and concise enough to follow on a phone screen.
- Do not hide intermediate failures; report them and explain whether they were caused by source code, tool/build infrastructure, or unverified runtime behavior.
- This visibility rule does not authorize code execution. Production code/repository changes still require the user's explicit execution command.
- Notes/history remain auto-updated whenever meaningful project decisions, errors, test results, or rules are established.
## 2026-09-27 — PHYSICAL RESULT: MANUAL VERSION FLASHING PASS / ONLINE OTA V1.0->V1.5 FAIL
- User physically tested manual firmware flashing by changing the firmware version source and flashing:
  1. V1.5 -> V1.5: PASS
  2. V1.5 -> V1.0: PASS
  3. V1.0 -> V1.9: PASS
  4. V1.9 -> V1.5: PASS
  5. V1.5 -> V1.0: PASS
- Current physical firmware state after these tests: V1.0.
- User then tested Online OTA V1.0 -> V1.5: FAIL.
- This manual-flashing history establishes that the board can manually accept and boot the tested firmware versions; therefore the Online OTA failure should be isolated from basic firmware-image compatibility/partition boot behavior unless new evidence contradicts this.
- Current public firmware manifest is V1.5 and points to the public V1.5 binary.
- The current Online OTA implementation uses HTTPS, a range probe, strict 206 Partial Content + Content-Range validation, chunked range requests, Update.begin(totalSize), Update.write(), and Update.end(true).
- No code change is authorized by this discussion. The next execution, when explicitly requested, must focus only on Online OTA failure diagnosis/fix; no unrelated feature changes.
- Before proposing a production Online OTA patch, identify the exact failure stage from the existing OTA diagnostic reporting or Serial output.
- Do not modify BLE, NTC, cooling, RGB, Adaptive, GPIO, Local OTA, or application UI in the Online OTA execution unless a directly verified dependency requires it.
## 2026-09-27 — ONLINE OTA DIAGNOSTIC + LED STATE DESIGN (DISCUSSION / NO CODE EXECUTION)
- User explicitly instructed that Local OTA is considered done/stable and must not be broken during future Online OTA work. Treat Local OTA as a protected subsystem: no unrelated Online OTA change may modify Local OTA logic.
- Historical Local OTA failures remain retained for traceability; "protected/stable" is the current product baseline instruction and does not erase the earlier physical failure evidence.
- User requested complete, stage-by-stage diagnostics for Online OTA from start to finish so the exact failure boundary is visible.
- Online OTA diagnostic requirement: every meaningful stage must publish a clear stage/status message, and any failure must identify the exact stage and error returned by the underlying official API/network operation. Do not collapse multiple failure points into one generic OTA failed message.
- Proposed Online OTA stage flow:
  1. ONLINE_REQUEST — OTA request received / metadata present.
  2. ONLINE_VERSION_CHECK — compare manifest version with current version.
  3. If equal: ONLINE_UP_TO_DATE — show Up to date; do not flash.
  4. If different: ONLINE_WIFI_START — begin Wi-Fi connection process.
  5. ONLINE_WIFI_CONNECTED — Wi-Fi connection succeeded.
  6. ONLINE_WIFI_FAILED — Wi-Fi connection failed.
  7. ONLINE_GITHUB_CONNECT — establish HTTPS connection to GitHub/raw firmware URL.
  8. ONLINE_GITHUB_READY — GitHub connection/HTTP response is valid for firmware download.
  9. ONLINE_GITHUB_FAILED — GitHub connection/download setup failed.
  10. ONLINE_DOWNLOAD_START — firmware download begins.
  11. ONLINE_DOWNLOAD_PROGRESS — firmware download progress reporting.
  12. ONLINE_DOWNLOAD_SUCCESS — complete firmware image downloaded/written to OTA staging.
  13. ONLINE_DOWNLOAD_FAILED — network/stream/range/download failure with exact error detail.
  14. ONLINE_IMAGE_VERIFY — finalize Update.end(true) and verify image.
  15. ONLINE_INSTALL_SUCCESS — firmware accepted and boot partition activation succeeded.
  16. ONLINE_INSTALL_FAILED — image verification/activation failure with exact official Update error.
  17. ONLINE_RESTART — green indication, then controlled restart.
- User-defined Online OTA LED behavior:
  - Wi-Fi connection succeeds: BLUE blink for 1 second, then LED off.
  - Wi-Fi connection fails: RED blink for 1 second, then LED off.
  - Wi-Fi succeeds + GitHub connection/download endpoint succeeds: GREEN blink, then continue.
  - Wi-Fi succeeds + GitHub connection fails: RED blink for 1 second, then LED off / failure state.
  - Firmware download succeeds: BLUE blink, then continue.
  - Firmware download fails: RED blink for 1 second, then LED off / failure state.
  - Firmware installation/verification succeeds: GREEN blink for 1 second, then restart.
  - Firmware installation fails: RED blink for 1 second, then LED off; no restart.
- LED indication must be tied to discrete stage completion/failure, not used as a substitute for textual diagnostics.
- Online same-version policy remains: same remote version as current means Up to date and no flash; different remote version is allowed regardless of whether remote is older or newer.
- Local vs Online policy remains explicitly separated:
  - Local OTA: no version restriction; preserve the working Local OTA path.
  - Online OTA: equal version means Up to date; different version is allowed.
- No code/build/release execution is authorized by this discussion. The next code execution requires an explicit user command and must focus only on the Online OTA diagnostic/LED implementation while preserving Local OTA.
## 2026-09-27 — LOCAL OTA LED STATE DESIGN (DISCUSSION / NO CODE EXECUTION)
- Local OTA remains a protected/stable subsystem. Future Online OTA work must not alter this Local OTA behavior.
- User-defined Local OTA LED sequence is explicitly separated into two success/failure boundaries:
  1. FILE TRANSFER / RECEIVE RESULT
     - Firmware file has been completely received by the device: BLUE blink.
     - File transfer/receive fails: RED blink, then remain in failure state without restart.
  2. FIRMWARE VERIFY / INSTALL RESULT
     - After a complete successful file transfer, the firmware image passes the update/verification step and is accepted for boot: GREEN blink, then complete flash/activation and restart.
     - Firmware verification, flash finalization, or activation fails: RED blink, no restart.
- The exact stage must also be reported in OTA diagnostics so the LED is not the only failure indicator.
- Required Local OTA diagnostic boundaries should distinguish at minimum:
  LOCAL_FILE_CHECK -> LOCAL_UPDATE_BEGIN -> LOCAL_RECEIVE -> LOCAL_FILE_TRANSFER_SUCCESS -> LOCAL_IMAGE_VERIFY -> LOCAL_BOOT_PARTITION -> LOCAL_RESTART.
- A transfer failure must never be reported as an image-verification failure, and an image/activation failure must never be mislabeled as a transfer failure.
- Local OTA version policy remains unchanged: no version restriction; older, same, or newer valid firmware may be flashed locally.
- The existing physical V1.4 Local OTA failure UPDATE_END_FAILED remains historical evidence and must not be deleted from the history.
- Future implementation must use the real Update.getError() / Update.errorString() values rather than a hardcoded error code.
- No code/build/release execution is authorized by this discussion. This update only records the Local OTA LED/diagnostic specification for the next explicit execution.
## 2026-09-27 — OTA NOTIFY MUST BE COMPLETE AND DETAILED
- User explicitly requires OTA notifications to be complete and detailed enough to identify where and why an OTA operation failed.
- This applies to BOTH Local OTA and Online OTA.
- OTA notifications must not use a generic message such as "OTA failed" without diagnostic context.
- At every meaningful OTA boundary, the device/app must expose:
  - MODE: LOCAL or ONLINE
  - STAGE: exact current processing stage
  - ACTION/RESULT: what operation was attempted and whether it succeeded
  - PROGRESS: last known percentage when applicable
  - ERROR CODE: the real code returned by the underlying official API/network operation when available
  - ERROR DETAIL: the real human-readable/native error string when available
  - VERSION: current and target/remote version when relevant
- Minimum Local OTA notification stages should distinguish:
  LOCAL_FILE_CHECK
  LOCAL_UPDATE_BEGIN
  LOCAL_RECEIVE
  LOCAL_FILE_TRANSFER_SUCCESS
  LOCAL_IMAGE_VERIFY
  LOCAL_BOOT_PARTITION
  LOCAL_RESTART
- Minimum Online OTA notification stages should distinguish:
  ONLINE_REQUEST
  ONLINE_VERSION_CHECK
  ONLINE_UP_TO_DATE
  ONLINE_WIFI_START
  ONLINE_WIFI_CONNECTED
  ONLINE_WIFI_FAILED
  ONLINE_GITHUB_CONNECT
  ONLINE_GITHUB_READY
  ONLINE_GITHUB_FAILED
  ONLINE_DOWNLOAD_START
  ONLINE_DOWNLOAD_PROGRESS
  ONLINE_DOWNLOAD_SUCCESS
  ONLINE_DOWNLOAD_FAILED
  ONLINE_IMAGE_VERIFY
  ONLINE_INSTALL_SUCCESS
  ONLINE_INSTALL_FAILED
  ONLINE_RESTART
- The notification must identify the first failed stage rather than only reporting the final generic failure.
- When an official Arduino Update API reports an error, use the actual Update.getError() / Update.errorString() result; never substitute a guessed or hardcoded error code.
- For network/HTTP failures, preserve the actual HTTP/status/connection result and relevant stage in the diagnostic message.
- A successful stage should also be visible so the user can distinguish "file received" from "image verified" from "boot partition activated".
- LED indicators remain secondary to the textual diagnostic notification; LED color alone is never sufficient to diagnose OTA failure.
- No code/build/release execution is authorized by this discussion. This is a requirements/history update only.
## 2026-09-27 — OTA DIAGNOSTIC LOG PERSISTENCE DESIGN (DISCUSSION / NO CODE EXECUTION)
- User proposed sending the complete OTA diagnostic log to Firebase so the log remains visible/persistent instead of disappearing when the OTA page/session closes.
- Desired behavior:
  - During Local or Online OTA, every diagnostic event is appended/published to Firebase.
  - The log remains available after the OTA attempt finishes, including successful and failed stages.
  - The next intended fresh power session should clear the previous OTA diagnostic log so the user starts with a clean history.
  - User's requested clearing action is to unplug power/cable and plug it in again.
- Recommended data model: keep one dedicated OTA diagnostic log area separate from firmware manifest/version data and separate from normal application state. Each record should include timestamp/session marker when available, OTA mode, stage, action/result, progress, version current/target, error code, and error detail.
- Do not overwrite the log with only the final result; preserve the ordered event history for troubleshooting.
- Local and Online OTA logs must remain distinguishable by MODE=LOCAL or MODE=ONLINE.
- The Firebase diagnostic log is an observability channel only; it must not become a prerequisite for OTA flash safety or a reason to continue a failed OTA.
- OTA flash must remain operational even when Firebase logging is unavailable. Logging failure must never corrupt, block, or alter the firmware update transaction.
- The firmware must not require Firebase for local OTA operation.
- Because the current project rules require Arduino Standard APIs and no guessed low-level lifecycle APIs, the exact power-cycle/session-reset mechanism must be designed using a verified Arduino-compatible approach before implementation. Do not invent a reset-reason API.
- Important interaction with the existing OTA rule: Local OTA logs must retain the complete attempt through verification/activation before the device restarts. If a session reset is implemented at boot, the implementation must ensure the previous log can still be retained as required until the user intentionally starts a new power session.
- No code/build/release execution is authorized by this discussion. This update records the Firebase logging design only.
## 2026-09-27 — LOCAL OTA SAFETY-NET BACKUP BEFORE ONLINE OTA (DISCUSSION / NO CODE EXECUTION)
- User explicitly wants the known Local OTA path to remain the safety net while Online OTA is being repaired.
- Operational rule: preserve Local OTA; do not modify its implementation during Online OTA work unless the user explicitly authorizes a direct Local OTA change and the change is independently verified.
- Before any Online OTA execution/testing, keep a downloadable backup of the latest known firmware binary and its matching source (.ino) so the user can recover through Local OTA.
- The backup must be clearly identified by firmware version/build and must correspond to the exact source used to produce that binary. Do not provide a source file as a "matching backup" unless its correspondence to the binary is verified.
- The current repository production source on main is V1.5. The existing V1.5 binary artifact is the current recovery candidate; it remains subject to the project's release gate and must not be described as an Online-OTA-ready build merely because it exists.
- Future Online OTA changes must be isolated and must not knowingly break Local OTA, because Local OTA is the recovery path if an Online OTA test fails.
- No code/build/release execution is authorized by this discussion. This note records the safety-net policy only.


## 2026-09-27 — V1.6 ONLINE OTA EXECUTION RESULT
- User explicitly authorized full firmware/code execution and requested a downloadable .ino + .bin backup before Online OTA testing.
- V1.6 scope:
  - Firmware version bumped V1.5 -> V1.6.
  - Online OTA now validates target firmware version syntax.
  - Online OTA policy: same version => ONLINE_UP_TO_DATE / no flash; any different valid version is permitted (older or newer).
  - Online OTA diagnostic stages were separated for request, version check, Wi-Fi connected/failed, GitHub connect/ready/failed, download success, image verification, install success, boot partition, and restart.
  - Online OTA LED boundaries were separated: Wi-Fi connected BLUE indicator, GitHub ready GREEN indicator, download success BLUE indicator, install success GREEN indicator, failures RED indicator.
  - Online Update.end(true) failures now use the actual Update.getError() / Update.errorString() result instead of a hardcoded magic-byte code.
  - Non-blocking finalize boundary was used for the download-success indicator before Update.end(true).
- Local OTA protection:
  - Local OTA implementation body was verified byte-for-byte identical to the previous V1.5 baseline during the V1.6 patch review.
  - No Local OTA behavior was intentionally changed.
  - Local OTA remains the recovery/safety-net path for Online OTA testing.
- CI history during execution:
  - Run #73 initially failed on a C++ String concatenation error in the new V1.6 Up-to-Date result and on an App test compatibility error after renaming the firmware-version helper.
  - Both errors were corrected with minimal targeted fixes.
  - A compile-order issue in the new OTA LED helper was also identified and fixed by adding a forward declaration for resetBlinkState().
  - Firmware Run #74: ArduinoDroid/Core 3.3.7 compile PASS; release compile PASS; OTA protected-source audit PASS; firmware artifact upload PASS; ArduinoDroid source artifact upload PASS; public firmware publish PASS.
  - App Build #7: security/architecture audit PASS; dependencies PASS; Dart analysis PASS; Flutter tests PASS; release APK build/signature verification/upload PASS.
- V1.6 release artifact:
  - GitHub Actions run: 36282362485 (Firmware Build #74)
  - Firmware artifact name: JEXFYZ-V1.6
  - Extracted binary size: 1,466,768 bytes
  - Extracted binary SHA-256: 703a62d50f0264f493ef193c3fb65654a258d8dafa93b8aab8217c3b4e8d07f
  - CI artifact ZIP digest: sha256:4f97138901d3b83f4141ba08665e90503cd01ff2ded943ad4e70198c1a17161e
  - ArduinoDroid source artifact was produced from the same CI checkout as the release binary.
  - Public manifest now reports V1.6 and points to JEXFYZ-V1.6.bin.
- Firebase OTA diagnostic log persistence:
  - The persistent Firebase logging concept remains recorded as the project design.
  - It was NOT added to V1.6 in this execution because the current firmware does not have a Firebase client path and the app currently uses Firebase Core/App Check without RTDB logging.
  - Do not claim V1.6 provides persistent Firebase OTA logs. A dedicated implementation must preserve the rule that Firebase failure can never block or corrupt OTA.


## 2026-09-27 — OTA PHYSICAL TEST PRIORITY / FIREBASE DEFERRED
- User explicitly deferred Firebase persistent OTA logging for now.
- Current priority is physical OTA validation.
- Test order:
  1. Use the released V1.6 binary through Local OTA as the recovery/safety path.
  2. Verify the device boots and normal Wi-Fi/BLE/application behavior remains healthy.
  3. Only after Local OTA validation, test Online OTA behavior.
- Do not add Firebase logging changes while this OTA validation is in progress unless the user explicitly requests it.
- Local OTA remains a protected subsystem and must not be modified during Online OTA testing.

## 2026-09-27 — V1.6 LOCAL OTA PHYSICAL TEST RESULT
- Physical Local OTA test failed after the upload reached 100% progress.
- Screenshot evidence shows two attempts using `1.8.bin` and `1.6.bin`, both ending at:
  - `MODE=LOCAL`
  - `STAGE=LOCAL_IMAGE_VERIFY`
  - `CODE=3`
  - `ERROR=UPDATE_END_FAILED_Flash Read Failed` (text visibly truncated in the browser, but code 3 is confirmed).
- The transfer path therefore reached the finalization/verification boundary; this is NOT a simple upload-progress failure.
- Official Arduino-ESP32 Core 3.3.7 `Update.end(true)` maps error code 3 to `UPDATE_ERROR_READ` / `Flash Read Failed`.
- Important diagnostic finding: Core 3.3.7 `Update.end(true)` calls the internal bootability path where error code 3 can be produced when the reserved first 16-byte image header is restored or when the just-written OTA partition is read back for bootability. Therefore the current firmware label `LOCAL_IMAGE_VERIFY` is too broad to identify the exact failing sub-step.
- Next investigation must isolate the exact finalization sub-step (header/partition enable write vs bootability read) before changing Local OTA logic.
- No Local OTA code was changed from this physical test result; Firebase remains deferred.

## 2026-09-27 — OTA GOLD MASTER / TWO-LAYER GUARD DECISION
- User approved the concept of a strict two-layer OTA protection system:
  - 🛡️ SATPAM (OTA Guard): exact verification gate for OTA code, structure, ordering, placement, constants, strings, Wi-Fi/AP configuration, WebServer routes, Update lifecycle, diagnostics, LED handling, failure handling, and restart sequence.
  - 📋 SEKRETARIS (OTA Repair): may only restore a known approved OTA Gold Master; it must not invent or guess replacement code.
- Required flow:
  1. Guard compares current OTA against the approved Gold Master.
  2. PASS -> build/audit may continue.
  3. FAIL -> build is blocked and a precise mismatch diagnosis is reported.
  4. Repair restores from Gold Master.
  5. Guard runs again.
  6. If still FAIL -> hard stop; no build/release/OTA.
- Exact-match principle: protected OTA items are treated like a password; a one-character difference is a mismatch and must be blocked.
- Gold Master must be immutable as an approved reference. A new OTA master can only be promoted after deliberate changes, Core 3.3.7 CI/audit, and physical OTA validation.
- Current V1.6 is NOT yet an OTA Gold Master because the physical Local OTA test failed at finalization (LOCAL_IMAGE_VERIFY, error code 3 / Flash Read Failed).
- Current objective is to repair and physically validate OTA first, then establish the first physically verified OTA Gold Master. Firebase logging remains deferred until after this objective.
- No firmware code execution/build was authorized by this discussion; this note records the design decision and test objective only.

## 2026-09-27 — OTA FIX + SATPAM/SEKRETARIS EXECUTION
- User explicitly authorized full firmware/code execution.
- Local OTA regression identified from source history: V1.5 used `Update.begin(localOtaExpectedBytes)`; V1.6 had `Update.begin()`. Local OTA was restored to the exact-size official Update lifecycle.
- Added protected OTA boundaries for safety lock, OTA state/diagnostics, OTA priority supervisor, boot path, loop priority path, and OTA engine.
- Added `firmware/OTA_GOLD_MASTER_LOCK.json` as the current strict OTA lock candidate. Status is `CANDIDATE_NOT_PHYSICALLY_VERIFIED`; it is not yet the final Gold Master.
- Added `.github/scripts/ota_guard.py`:
  - exact byte-level protected-block comparison,
  - protected block ordering check,
  - critical OTA string check (including Wi-Fi SSID/password and Update lifecycle),
  - forbidden low-level/insecure API check,
  - safe block restore for the Secretary path,
  - mandatory guard re-check after repair.
- Firmware CI now executes 🛡️ SATPAM first; on failure it invokes 📋 SEKRETARIS to restore the approved lock candidate and immediately re-runs SATPAM. Build is blocked if the repair/check fails.
- CI is allowed to commit a Secretary restoration of `firmware/JEXFYZ.ino`; the workflow trigger remains limited to `.github/FIRMWARE_BUILD_TRIGGER`, preventing a repair commit from recursively starting another firmware build.
- Two-layer OTA protection is now active, but the lock remains only a candidate until physical Local OTA and subsequent OTA validation pass.
- Firebase remains deferred during this OTA validation cycle.

## 2026-09-27 — FIRMWARE BUILD #76 / SATPAM DIAGNOSTIC
- Firmware Build #76 was intentionally blocked before compilation by the new OTA Satpam gate.
- Satpam detected an incorrect block-order expectation in the first lock candidate: the source order is OTA_SAFETY_LOCK -> OTA_STATE_AND_DIAGNOSTICS -> OTA_ENGINE -> OTA_PRIORITY_SUPERVISOR -> OTA_BOOT_PATH -> OTA_LOOP_PRIORITY.
- The Secretary correctly refused to complete the repair because the source itself was valid but the candidate lock's expected ordering was wrong; this prevented an incorrect automatic rewrite.
- The lock candidate was corrected to the actual source order. No firmware OTA logic was changed because of this CI failure.

## 2026-09-27 — FIRMWARE BUILD #77 / LEGACY AUDIT DIAGNOSTIC
- Firmware Build #77 passed the new 🛡️ OTA SATPAM and ArduinoDroid/Core 3.3.7 validation.
- The build then stopped at the older in-workflow OTA marker audit because its supervisor-marker pattern was too text-layout-specific.
- This was a CI audit false negative: the exact protected marker exists in source and the new Satpam already validated it against the lock candidate.
- The legacy audit marker check was changed to match the stable marker prefix instead of the exact trailing `=` count. No firmware OTA behavior changed.

## 2026-09-27 — FIRMWARE BUILD #78 PASS / LOCAL OTA FIX CANDIDATE
- Firmware Build #78 completed successfully after the OTA guard/audit corrections.
- 🛡️ OTA SATPAM: PASS in both ArduinoDroid validation and release build.
- 📋 OTA SEKRETARIS: not invoked because the protected source matched the current lock candidate.
- ArduinoDroid/Core 3.3.7 compile: PASS.
- OTA protected-source audit: PASS.
- ESP32-C3 release compile: PASS.
- Artifact and public firmware publish: PASS.
- Released candidate binary: `JEXFYZ-V1.6.bin`
- Build #78 binary size: 1,466,768 bytes.
- Build #78 binary SHA-256: `b65bb2eaaaa01d6706e48e3a844d79c43c41f5bbae94287e19ef1096e1ed341f`
- Public manifest remains V1.6 -> `JEXFYZ-V1.6.bin`.
- The Local OTA exact-size lifecycle restoration (`Update.begin(localOtaExpectedBytes)`) is now the physical-test candidate for the previous `LOCAL_IMAGE_VERIFY / CODE=3` failure.
- OTA Gold Master status remains `NOT ESTABLISHED`; it requires physical OTA validation.

## 2026-09-27 — CRITICAL PHYSICAL OTA MATRIX: ArduinoDroid vs REPO V1.6
- User performed a direct ArduinoDroid V1.6 flash and Local OTA tests.
- Physical result:
  - ArduinoDroid V1.6 -> repository V1.6 Local OTA: PASS.
  - repository V1.6 -> repository V1.6 Local OTA: FAIL at finalization.
  - repository V1.6 -> ArduinoDroid V1.6 Local OTA: FAIL at finalization.
- Both failing repository-originated tests reproduce the same `LOCAL_IMAGE_VERIFY / CODE=3 / UPDATE_END_FAILED / Flash Read Failed` boundary.
- This result materially narrows the problem: the Local OTA upload path and target image are demonstrably usable when the running firmware is the ArduinoDroid-built V1.6, while the same OTA mechanism fails when the running firmware is the CI/repository-built V1.6.
- Therefore the previous hypothesis that `Update.begin(localOtaExpectedBytes)` alone would fix the issue is NOT physically validated and must not be treated as the root cause.
- Next investigation must compare the ArduinoDroid and repository build environments/configuration that can affect OTA partition selection, flash layout, boot partition state, image metadata, and runtime Update behavior. Do not make another speculative OTA rewrite before this comparison.
- OTA Gold Master remains NOT established.

## 2026-09-27 — ARDUINODROID BUILD CONFIG / LIBRARY DIFFERENCE CONFIRMED
- User provided ArduinoDroid configuration screenshots from the same physical environment:
  - Board: ESP32C3 Dev Module
  - JTAG Adapter: Disabled
  - USB CDC On Boot: Enabled
  - Partition Scheme: No FS 4MB (2MB APP x2)
  - CPU Frequency: 160MHz (WiFi)
  - Flash Mode: DIO
  - Flash Frequency: 80MHz
  - Flash Size: 4MB (32Mb)
  - Upload Speed: 921600
  - Core Debug Level: None
  - Erase All Flash Before Sketch Upload: Enabled
  - Zigbee Mode: Disabled
- ArduinoDroid installed libraries shown:
  - Adafruit NeoPixel 1.15.5
  - OneButton 2.6.2
  - WS2812FX 1.4.7
- Repository CI is currently configured to compile with ESP32 Arduino Core 3.3.7 and explicitly installs:
  - Adafruit NeoPixel 1.12.5
  - OneButton 2.6.1
- Production firmware includes Adafruit_NeoPixel and OneButton; WS2812FX is not included by the current production source header list.
- Physical OTA matrix remains:
  - ArduinoDroid V1.6 running -> Repo V1.6 OTA: PASS.
  - Repo V1.6 running -> Repo V1.6 OTA: FAIL (CODE=3 / Flash Read Failed at finalization).
  - Repo V1.6 running -> ArduinoDroid V1.6 OTA: FAIL (same finalization boundary).
- The newly confirmed build-environment difference makes library-version and compile-configuration parity a primary investigation target. Do not yet claim it is the root cause.
- Next comparison should reproduce ArduinoDroid settings in CI as closely as the repository build system permits, especially the installed library versions and compile board options. No OTA API rewrite is justified from this evidence alone.

## 2026-09-27 — ARDUINODROID CORE VERSION CORRECTION
- User confirmed ArduinoDroid is also using ESP32 Arduino Core 3.3.7.
- Therefore Core version mismatch is eliminated as a cause in the current ArduinoDroid-vs-CI OTA investigation.
- Keep investigation focused on remaining build parity variables: ArduinoDroid board/build options and installed library versions versus CI, plus resulting firmware image/partition metadata.
- No firmware OTA code was changed from this clarification.


## 2026-09-27 — DISCUSSION: ARDUINODROID GENERATES THREE BINARIES

- User observed that a successful ArduinoDroid compilation produces three .bin files.
- This is expected for ESP32 builds and is diagnostically important because the files normally represent different flash regions (bootloader, partition table, and application/sketch image), rather than three interchangeable firmware images.
- OTA Local/Online using Arduino Update must use the application/sketch firmware image only (the .ino.bin application binary), not the bootloader or partition-table binary.
- Normal USB flashing is different: a full flash operation may write bootloader + partition table + application at their required offsets, or use a merged image produced by the build tool.
- The existence of three ArduinoDroid .bin files by itself does NOT prove the Local OTA failure is caused by ArduinoDroid. However, it is a new build-artifact parity variable that must be handled explicitly in the ArduinoDroid-vs-CI comparison.
- CI currently checks/artifacts only the application binary JEXFYZ-VERSION.bin copied from JEXFYZ.ino.bin; it does not publish the separately generated bootloader/partition binaries as the OTA image.
- Next diagnostic boundary: identify the exact three ArduinoDroid filenames and compare the application .ino.bin against the CI V1.6 application binary. For direct USB flashing, do not mix the three files or treat bootloader/partition binaries as OTA payloads.
- No production firmware/OTA code was changed by this discussion.


## 2026-09-27 — DISCUSSION: ESPFLASH ANDROID OTG FLASH CONFIG

- User supplied ESPFlash Android screenshot for direct USB flashing diagnostics.
- Current visible configuration:
  - Chip Type: ESP32C3
  - SPI Speed: 80MHz
  - SPI Mode: DIO
  - High-Speed Mode (Stub): ON
  - Firmware Compress: ON
  - Baudrate: 115200
- For the first diagnostic flash of the repository application binary, the conservative recommended test configuration is:
  - ESP32C3
  - DIO
  - 80MHz
  - High-Speed Mode (Stub): OFF
  - Firmware Compress: OFF
  - Baudrate: 115200
- The three ArduinoDroid .bin files should not be treated as interchangeable. For full USB flashing, bootloader, partition table, and application must be assigned to their proper flash offsets. For an application-only test preserving the existing partition layout, use only the application .ino.bin at the application offset.
- No production firmware/code was changed by this discussion.


## 2026-09-27 — DISCUSSION: ESPFlash ANDROID USB FLASH CONFIGURATION
- User showed ESPFlash Android app configuration for direct USB flashing.
- Screenshot settings:
  - Chip Type: ESP32C3
  - SPI Speed: 80MHz
  - SPI Mode: DIO
  - High-Speed Mode (Stub): ON
  - Firmware Compress: ON
  - Baudrate: 115200
- Chip type, SPI speed, and DIO match the known ArduinoDroid board/flash configuration used for the project.
- For the first diagnostic flash, prefer conservative transport settings: High-Speed Mode (Stub) OFF and Firmware Compress OFF, with 115200 baud. This removes optional transfer optimizations as variables while diagnosing the ArduinoDroid-vs-CI binary difference.
- The critical item for flashing a single Arduino application .bin is the flash address: the application image is normally placed at the app partition offset (for the project's 2MB APP x2 / no-FS layout, the expected Arduino app offset is 0x10000). Do not flash the application .bin at 0x0; that address is for the bootloader in a full-image flash.
- This is discussion-only; no firmware/repository code was changed by this note.


## 2026-09-27 — RUNTIME RESULT: ESPFlash DIRECT USB REPO V1.6 ALSO REPRODUCES LOCAL OTA FAILURE
- User directly flashed the repository/CI binary JEXFYZ-V1.6.bin to the ESP32-C3 using the Android ESPFlash app, bypassing ArduinoDroid compilation and upload.
- ESPFlash screenshot confirms:
  - File: JEXFYZ-V1.6.bin
  - Chip: ESP32-C3
  - SPI: 80MHz
  - Mode: DIO
  - Address: 0x10000
  - High-Speed Stub: OFF
  - Firmware Compress: OFF
  - Operation Successful
- After the direct USB flash, the device booted normally into JE X FYZ V1.6 and exposed the Local OTA page at 192.168.4.1.
- User then uploaded the same repository JEXFYZ-V1.6.bin through Local OTA.
- Physical result: Local OTA still fails at 100% with:
  MODE=LOCAL, STAGE=LOCAL_IMAGE_VERIFY, CODE=3, ERROR=UPDATE_END_FAILED_Flash Read Failed.
- This is a critical isolation result: the failure reproduces even when the repository binary is flashed directly over USB from ESPFlash, so the ArduinoDroid compile/upload path is no longer a sufficient explanation for the Local OTA failure.
- Current evidence now points more strongly toward the firmware image/build configuration, flash/partition metadata, or the Local OTA finalization behavior itself. Do not claim the root cause yet.
- Important distinction: ESPFlash wrote only the application image at 0x10000; bootloader and partition table were not replaced in this test. Therefore the test proves the CI application binary runs correctly on the existing board flash layout, but it does not by itself prove a complete CI-generated bootloader/partition-table image matches ArduinoDroid.
- Next diagnostic should inspect/compare the exact application binary metadata and partition layout used by ArduinoDroid vs CI, then isolate the Core 3.3.7 Update.end(true) finalization boundary. Do not perform another speculative OTA rewrite from this result alone.


## 2026-09-27 — DISCUSSION: ARDUINODROID PRECOMPILE FILES IDENTIFIED EXACTLY
- User provided the ArduinoDroid precompiled directory screenshot.
- The file manager is displayed in dual-pane mode, so each file appears twice visually; there are actually four unique files in the directory:
  - HorizonCooler.cpp.bin — 1.36 MB
  - JEXFYZ.cpp.bin — 1.39 MB
  - JEXFYZ.cpp.bootloader.bin — 18.38 KB
  - JEXFYZ.cpp.partitions.bin — 3.00 KB
- Therefore ArduinoDroid is indeed producing the expected three JEXFYZ binary components: application, bootloader, and partition table.
- The application binary is specifically named JEXFYZ.cpp.bin in this ArduinoDroid precompiled directory. This is the correct candidate to compare against the repository/CI application binary for Local OTA behavior.
- The bootloader and partitions binaries are not Local OTA payloads; they matter for complete USB flashing/layout comparison.
- The exact ArduinoDroid application filename should not be inferred from the generic *.ino.bin naming used by the CI build directory; the source/precompile naming differs because ArduinoDroid is compiling the sketch as JEXFYZ.cpp internally.
- Next diagnostic: obtain/compare the bytes, size, and image metadata of JEXFYZ.cpp.bin versus the CI JEXFYZ-V1.6.bin, and separately compare JEXFYZ.cpp.partitions.bin against the CI-generated partition table. This will distinguish application-image differences from flash-layout differences.
- No production firmware/code was changed by this discussion.


## 2026-09-27 — BINARY COMPARISON: ARDUINODROID V1.6 VS CI/REPO V1.6
- User uploaded the exact ArduinoDroid precompile artifacts:
  - JEXFYZ.cpp.bin
  - JEXFYZ.cpp.bootloader.bin
  - JEXFYZ.cpp.partitions.bin
- Exact measured ArduinoDroid application binary:
  - size: 1,456,256 bytes
  - SHA-256: 896c208e7b27a3cf12155765cb4c3366270e82f6612f322bd1f57aa23f4cfc94
- Exact CI Build #78 application binary:
  - size: 1,466,768 bytes
  - SHA-256: b65bb2eaaaa01d6706e48e3a844d79c43c41f5bbae94287e19ef1096e1ed341f
- The two application images are therefore NOT byte-identical; CI is 10,512 bytes larger (~0.72%).
- Both images identify as the same ESP32 image class at the header level (magic 0xE9, 6 segments, SPI mode DIO, encoded flash 80 MHz/4 MB), but their image entry address differs:
  - ArduinoDroid: 0x403807e4
  - CI: 0x403807ca
- Their segment layout/lengths also differs, confirming these are genuinely different builds, not just filename differences.
- ArduinoDroid partition table binary is 3,072 bytes and decodes to the expected No-FS 4MB / 2MB APP x2 structure:
  - nvs 0x9000 size 0x5000
  - otadata 0xe000 size 0x2000
  - app0 0x10000 size 0x1f0000
  - app1 0x200000 size 0x1f0000
  - coredump 0x3f0000 size 0x10000
- This is a high-value diagnostic result: the ArduinoDroid application and CI application are different binaries even though both use Core 3.3.7.
- Do not yet assert that this binary difference itself causes the OTA CODE=3 failure. The next comparison should identify which build variables produce the different image (library versions, compiler/build flags, board options, linker/build metadata) and, where possible, compare CI-generated bootloader/partition outputs with the ArduinoDroid precompile artifacts.
- No production source/OTA code changed in this discussion.


## 2026-09-27 — DISCUSSION: CONTROLLED FULL-FLASH BASELINE VIA ESP32Flash/Erase
- User proposed a one-time full flash using the Android ESP32 Flash/Erase tool, supplying three images at the standard offsets:
  - bootloader.bin -> 0x0
  - partition table -> 0x8000
  - application firmware -> 0x10000
- Objective: establish a clean, known flash-layout baseline once, then repeat Local OTA testing without repeatedly changing the flash layout.
- This is a valid diagnostic direction, but the bootloader and partition-table images must be generated from the same Arduino-ESP32 Core 3.3.7 + ESP32-C3 board configuration intended for the application image; they must not be hand-fabricated or guessed.
- The first full-flash test should use the exact CI/repository application V1.6 together with CI-generated bootloader and partition-table images matching the same build configuration. After the one-time full flash and successful boot, re-test Local OTA with the same V1.6 application binary.
- Because the user has only a phone, ESP32 Flash/Erase is the proposed transport for this controlled baseline. Use conservative settings first (ESP32-C3, DIO, 80MHz, 4MB); transport baud/compression are secondary to correct image/offset selection.
- Do not erase or flash yet from this discussion. Execution remains locked behind an explicit execution command.


## 2026-09-27 — DISCUSSION: PROPOSED CI BUILD PROFILE MATCHING ARDUINODROID, WITH A NEWER STABLE CORE
- User proposed reproducing the ArduinoDroid board/build settings in the assistant's build environment while intentionally using a newer stable ESP32 Arduino Core instead of the currently pinned 3.3.7.
- Target board settings to match the screenshot:
  - ESP32-C3 Dev Module
  - JTAG Adapter: Disabled
  - USB CDC On Boot: Enabled
  - No FS 4MB (2MB APP x2)
  - CPU 160MHz (WiFi)
  - Flash Mode DIO
  - Flash Frequency 80MHz
  - Flash Size 4MB
  - Core Debug Level None
  - Erase All Flash Before Sketch Upload Enabled (relevant to physical uploader behavior, not normally a compile flag)
  - Zigbee Mode Disabled
- This would be a diagnostic build profile, not an immediate replacement of the project's pinned production Core 3.3.7 baseline.
- A newer Core changes the compiler/framework/toolchain output, so its resulting binary should not be treated as a like-for-like comparison against ArduinoDroid Core 3.3.7. It is useful as a separate compatibility experiment after the current 3.3.7 evidence is understood.
- Current web access is unavailable, so the exact latest stable Core version as of 2026-09-27 cannot be independently verified in this discussion. Do not invent a version number. Before execution, select the newest stable Core version actually available in the controlled build environment and record the exact version.
- No code/build/release execution occurred from this discussion.


## 2026-09-27 — DISCUSSION: ESP32 FLASH/ERASE FULL-FLASH SCREEN
- User showed the ESP32 Flash/Erase configuration screen for the planned one-time full flash.
- Visible target configuration:
  - Chip: ESP32-C3
  - Baudrate: 921600
  - SPI Mode: DIO
  - SPI Frequency: 80MHz
  - Flash Size: 4MB
  - Bootloader offset: 0x0
  - Partition table offset: 0x8000
  - Firmware/application offset: 0x10000
  - Bootloader Auto: ON
  - Compression: ON
- The three offsets are the expected flash locations for the three-image full-flash layout.
- For the first controlled diagnostic, the recommended conservative transport setup is SPI DIO / 80MHz / 4MB with compression OFF and a lower baudrate such as 115200, to remove transport optimization variables.
- Because the planned test supplies an explicit bootloader.bin, partition-table.bin, and application.bin, avoid relying on an automatically selected replacement image unless the app's Bootloader Auto behavior is confirmed. Do not flash until the exact three CI-generated files and their provenance are confirmed.
- This remains discussion-only; no flash or firmware code execution was performed.


## 2026-09-27 — EXECUTION: V1.6 FULL-FLASH DIAGNOSTIC BUILD WITH ARDUINO-ESP32 3.3.12
- User explicitly authorized full Code & Firmware execution.
- Diagnostic build was kept isolated from the production main firmware/release workflow; production `firmware/JEXFYZ.ino` OTA logic was not changed.
- Verified latest stable Arduino-ESP32 release available during execution: 3.3.12. Arduino-ESP32 4.0.0-RC1 is a prerelease and was not used.
- Build profile:
  - ESP32-C3 Dev Module
  - Core 3.3.12
  - OneButton 2.6.2
  - Adafruit NeoPixel 1.15.5
  - USB CDC On Boot Enabled
  - CPU 160MHz (WiFi)
  - Flash DIO / 80MHz / 4MB
  - No FS 4MB (2MB APP x2)
  - Core Debug None
  - JTAG Disabled via official Core value `JTAGAdapter=default`
  - Zigbee Disabled via official Core value `ZigbeeMode=default`
  - Upload target baudrate recorded as 921600
- Official Core 3.3.12 board-option inspection was run before compile; the exact supported FQBN values were verified from `arduino-cli board details`.
- Build initially encountered two CI-only mistakes:
  1. sketch path was constructed incorrectly;
  2. unsupported FQBN values were used for Zigbee and JTAG.
  Both were corrected without modifying firmware source.
- Successful diagnostic run:
  - Workflow: Firmware Latest Stable Diagnostic
  - Run number: 15
  - Run ID: 36294947204
  - Result: PASS
- Compile result:
  - Sketch uses 1,502,461 bytes (73%) of 2,031,616 bytes.
  - Global variables use 43,816 bytes (13%).
- Full-flash outputs verified and uploaded as one artifact:
  - application: 1,502,608 bytes
  - bootloader: 18,688 bytes
  - partition table: 3,072 bytes
  - source .ino: 107,113 bytes
- SHA-256:
  - application: 0c6f402b3577040b41cf2efd38d595bd75adc5b5d8e6349fb90d7e3626bc522b
  - bootloader: 9da6c687836220a0b2c92544a5243d5af9bd1f0aff9298d48d4562e0e747989b
  - partitions: 6d574ef034d3df9cc43f75e69b0ab9d6a6e6904c8393a1a8cb1a9e789e24adef
  - artifact ZIP digest: 0af4a8cd33d7d2d716b2ac0cb70b7905ee97096b54128bf04d865eabb8cac9f7
- The application image is the diagnostic full-flash candidate for the one-time USB baseline:
  - bootloader -> 0x0000
  - partitions -> 0x8000
  - application -> 0x10000
- This build is NOT a production release and is NOT published to the public firmware manifest.


## 2026-09-27 — DECISION: CANCEL FULL-FLASH CORE 3.3.12 EXPERIMENT
- User decided not to proceed with the one-time full-flash experiment because the process was too complicated.
- Do not ask the user to perform the three-file full flash for this experiment unless explicitly requested again.
- Keep the diagnostic build/branch and recorded artifacts as historical evidence; they are not a production release and must not replace the Core 3.3.7 production baseline or public firmware manifest.
- Current physical OTA investigation remains at the previously established evidence: repository/CI V1.6 application reproduces Local OTA CODE=3 / Flash Read Failed on the board, and ArduinoDroid V1.6 behavior differs by build/image.


## 2026-09-27 — PROPOSED WORKFLOW: AUTOMATED APP, MANUAL ARDUINODROID FIRMWARE, FIREBASE UPDATE DATA
- User proposed simplifying the release workflow:
  - App: fully automated build by CI/assistant.
  - Firmware: compile manually in ArduinoDroid using the user's known-good local environment, then manually upload the resulting application .bin to the GitHub firmware repository.
  - Firebase: used again as the source of the latest firmware version and GitHub raw download link.
- This architecture intentionally avoids using the CI-compiled firmware binary as the physical firmware release artifact, addressing the observed mismatch between ArduinoDroid-generated V1.6 and CI-generated V1.6 binaries.
- Firmware upload/release remains a human-controlled step: select the exact ArduinoDroid application binary, upload it to JEXFYZ-Firmware, then update Firebase metadata to point to that exact file.
- Firebase data should remain simple: firmware version + raw GitHub URL. Do not add SHA-based firmware linking unless explicitly re-approved.
- Online OTA flow should consume Firebase metadata first, then download the binary from the GitHub raw URL. Equal current/target version = no flash; any different target version is allowed according to the established version policy.
- Local OTA remains protected and should not be changed as part of this workflow simplification.
- This is a workflow/architecture decision only; no production code was changed by this note.


## 2026-09-27 — FINALIZED WORKFLOW PROPOSAL: GITHUB-ONLY, MANUAL ARDUINODROID BIN, CHATGPT AUTOMATES PUBLISH
- User decided not to use Firebase for firmware distribution/metadata.
- GitHub is the single source of truth for JE X FYZ firmware.
- Authoritative firmware source remains `JEXFYZ-App/firmware/JEXFYZ.ino`.
- User compiles the firmware manually in ArduinoDroid using the user's known-good hardware/build environment.
- User sends the resulting application `.bin` file into this ChatGPT conversation.
- ChatGPT then handles the publication workflow automatically:
  1. read the authoritative `firmware/JEXFYZ.ino` and determine the intended firmware version;
  2. validate that the uploaded file is the application firmware BIN and that its intended release version matches the source version;
  3. rename the uploaded BIN automatically to the project naming convention `JEXFYZ-VX.Y.bin`;
  4. upload/replace the BIN in the `JEXFYZ-Firmware` GitHub repository;
  5. update the GitHub firmware manifest/metadata to the new version and raw GitHub URL;
  6. verify the uploaded file and public raw URL before reporting completion.
- No Firebase dependency is used in this workflow.
- The App remains fully automated in GitHub Actions for APK builds.
- Local OTA remains protected/stable and is not modified as part of this workflow simplification.
- Online OTA continues to use GitHub-only version/link metadata according to the established version policy; equal version = no flash, any different version is allowed.
- Important safety rule: if the uploaded BIN version cannot be reconciled with the authoritative `firmware/JEXFYZ.ino`, stop before publication rather than guessing or silently choosing a version.
- This chat-based publication flow means the user only performs the ArduinoDroid compile and uploads the resulting BIN here; GitHub naming, firmware-repo upload, and manifest update are automated by ChatGPT.
- This is the new preferred workflow unless the user explicitly changes it later.
## 2026-09-27 — DECISION: BIN VERSION WILL BE DECLARED BY USER BEFORE PUBLICATION

- User clarified the GitHub-only firmware publication workflow: when sending the manually compiled ArduinoDroid application BIN, the user will explicitly state the intended firmware version.
- ChatGPT must treat the user's stated version as release metadata, then cross-check it against the authoritative firmware/JEXFYZ.ino source before any upload, rename, or manifest update.
- The automatic filename convention remains JEXFYZ-VX.Y.bin.
- If the user-stated version and authoritative source version do not match or cannot be reconciled unambiguously, publication must stop; do not guess, silently rename to another version, or update the manifest.
- This does not change the production firmware source or OTA code. It only clarifies the human-to-ChatGPT release handoff.


## 2026-09-27 — EXECUTION: RESET PROJECT BASELINE TO V1.0 + REPO CLEANUP

- User explicitly authorized Code execution to restart the firmware version sequence from the beginning because the project has undergone major changes.
- Authoritative production source remains `firmware/JEXFYZ.ino` and is now declared `FW_VERSION = "V1.0"`.
- Firmware behavior/code was intentionally kept the same; only the firmware version declaration was changed from V1.6 to V1.0.
- OTA Gold Master metadata was aligned from `created_from_firmware: V1.6` to `V1.0`; protected OTA block contents were not intentionally changed.
- Production repository cleanup removed obsolete firmware-build automation and cancelled diagnostic artifacts from the main App repo:
  - `.github/FIRMWARE_BUILD_TRIGGER`
  - `.github/LATEST_STABLE_BUILD_TRIGGER`
  - `.github/workflows/firmware-build.yml`
  - `.github/workflows/firmware-latest-stable-diagnostic.yml`
  - `firmware/diagnostics/JEXFYZ-Pure-Arduino-Runtime-Test.ino`
  - `firmware/diagnostics/JEXFYZ-Simple-WiFi-OTA-Test.ino`
  - `firmware/diagnostics/JEXFYZ-WiFi-STA-Mode-Test.ino`
- The OTA Guard files remain intentionally protected in the production source tree: `firmware/OTA_GOLD_MASTER_LOCK.json` and `.github/scripts/ota_guard.py`.
- App build automation remains intact through `.github/APP_BUILD_TRIGGER` and `.github/workflows/app-build.yml`.
- The public `JEXFYZ-Firmware` repo was inspected and remains intentionally minimal with `JEXFYZ-V1.6.bin` and `manifest.json` until the user supplies the manually compiled ArduinoDroid V1.0 application BIN.
- Do NOT rename the existing V1.6 binary to V1.0 by filename only; the binary's embedded firmware version must match the declared release version.
- New firmware publication workflow remains: user compiles in ArduinoDroid -> user states the BIN version -> ChatGPT validates against `firmware/JEXFYZ.ino` -> ChatGPT renames/uploads the correct BIN -> ChatGPT updates/verifies the GitHub manifest.
- Historical diagnostic failures and prior version history remain preserved in these notes; cleanup removes obsolete working files from the production tree, not the historical record.


## 2026-09-27 — ARDUINODROID OFFICIAL USER BUILD PROFILE LOCKED

- User supplied the ArduinoDroid board/build-options screen and requested that the exact profile be included in the sub-chat handoff prompt.
- ArduinoDroid firmware compile/flash baseline to preserve:
  - Board: ESP32C3 Dev Module
  - JTAG Adapter: Disabled
  - USB CDC On Boot: Enabled
  - Partition Scheme: No FS 4MB (2MB APP x2)
  - CPU Frequency: 160MHz (WiFi)
  - Flash Mode: DIO
  - Flash Frequency: 80MHz
  - Flash Size: 4MB (32Mb)
  - Upload Speed: 921600
  - Core Debug Level: None
  - Erase All Flash Before Sketch Upload: Enabled
  - Zigbee Mode: Disabled
- Confirmed project ArduinoDroid ESP32 Arduino Core: 3.3.7.
- Known ArduinoDroid library environment from the project diagnostics: Adafruit NeoPixel 1.15.5, OneButton 2.6.2, and WS2812FX 1.4.7. Production firmware includes/uses Adafruit NeoPixel and OneButton; WS2812FX is installed but is not used by the production source.
- The ArduinoDroid profile above is now part of the permanent firmware handoff context and must not be lost when moving to another sub-chat.

## 2026-09-27 — EXECUTION: NETWORK-BEGIN BOUNDARY DIAGNOSTIC

- User explicitly authorized `Eksekusi Code dan Firmware Full` and requested the raw `.ino` file for manual ArduinoDroid compilation.
- Generated diagnostic file in the conversation workspace:
  - `JEXFYZ-Network-Begin-Test.ino`
- Purpose: isolate the exact boundary immediately below the confirmed `WiFi.mode(WIFI_AP)` panic without adding another higher-level Wi-Fi/AP/OTA layer.
- Official Arduino-ESP32 Core 3.3.7 source was re-verified before generation:
  - `NetworkManager::begin()` is the public `Network.begin()` entry point.
  - `NetworkManager::begin()` returns `bool`.
  - It initializes the Arduino Network layer through the framework-owned initialization path; the diagnostic therefore calls only the public Arduino `Network.begin()` API.
- Diagnostic scope:
  - `#include <Arduino.h>`
  - `#include <Network.h>`
  - `ESP.getCoreVersion()`
  - `ESP.getChipModel()`
  - `ESP.getChipRevision()`
  - `Network.begin()`
  - Serial heartbeat after a successful return.
- Intentionally excluded:
  - `WiFi.mode()`
  - `WiFi.softAP()`
  - WebServer
  - Update OTA
  - BLE
  - NTC
  - Fan/Peltier
  - RGB
  - Preferences
  - direct ESP-IDF calls
- This diagnostic file is intentionally workspace-only and is not being added to the production firmware source tree.
- Production `firmware/JEXFYZ.ino` remains unchanged at V1.0.
- No firmware binary was compiled in this environment. The intended compile target is the user's locked ArduinoDroid profile with Arduino-ESP32 Core 3.3.7.
- Validation performed before handoff: source text review confirms the diagnostic does not call Wi-Fi/AP/OTA/BLE APIs and uses the verified public Network API.
- Next physical evidence boundary:
  - capture the complete Serial output from reset;
  - confirm whether `STEP 2: Network.begin() RESULT = OK` appears;
  - if it does not appear, preserve the exact panic/reset output;
  - do not add another production/runtime patch before this boundary is classified.

## 2026-09-27 — ARDUINODROID BIN RECEIVED: V1.0

- User supplied the manually compiled ArduinoDroid application firmware BIN and explicitly declared it as V1.0.
- Input file: `V1.0.bin`.
- Binary validation:
  - size: 1,456,256 bytes
  - ESP image magic: `0xE9`
  - image segment count: 6
  - embedded `V1.0` string: present
  - embedded `V1.6` string: absent
  - `JE X FYZ` identity string: present
  - `CORE 3.3.7` marker: present
  - SHA-256 (validation/traceability only): `90cb4235ce05556ee9e12d945233a42bcd7cb7ce6e6fa9b442c526b3afef9a36`
- The binary was renamed locally to the required public distribution name: `JEXFYZ-V1.0.bin`.
- The authoritative source `firmware/JEXFYZ.ino` remains V1.0; no source version mismatch was found.
- Public firmware repository is still unchanged at this action boundary:
  - `JEXFYZ-V1.6.bin` remains the existing public artifact.
  - `manifest.json` remains V1.6.
- Publication was intentionally NOT performed because the available GitHub connector exposes text/blob APIs but no direct binary upload operation from the mounted conversation file. Do not change the manifest until `JEXFYZ-V1.0.bin` is actually uploaded to `TenzoNkz/JEXFYZ-Firmware`.
- This BIN is the user's ArduinoDroid production artifact for the V1.0 release workflow; it must not be replaced by the CI V1.0 binary.

## 2026-09-27 — DISCUSSION: V1.0 BIN PUBLICATION STATE RECHECK

- User questioned why the supplied ArduinoDroid V1.0 BIN was not visible in the public firmware repository.
- Current GitHub state was rechecked directly:
  - `manifest.json` is V1.0 and points to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.0.bin`.
  - Current public firmware repository search returns **no `JEXFYZ-V1.0.bin` file**.
  - Latest public firmware commit is `307780e8573a436519a1e46e02e7440c834148c6` (`release firmware V1.0`), created 2026-09-27 05:12:59Z.
- Root cause of the publication gap: the available GitHub connector can create/update text blobs/files, but the received 1.46 MB binary cannot be transferred from the mounted chat file into the connector call in the current execution environment. The file itself was validated and renamed locally as `JEXFYZ-V1.0.bin`, but that does not create a GitHub release object.
- Important consequence: the public manifest currently advertises V1.0, but the corresponding V1.0 binary is not present in the public firmware repository yet. Do not claim the public V1.0 binary is published until the binary file itself is verified in the repository.
- No source/firmware logic was changed in this discussion. No manifest modification was made by this recheck.

## 2026-09-27 — EXECUTION ATTEMPT: UPLOAD USER V1.0 BIN TO PUBLIC REPOSITORY

- User explicitly asked to try uploading the supplied ArduinoDroid V1.0 application BIN to `TenzoNkz/JEXFYZ-Firmware`.
- Exact source file remains available at `/mnt/data/JEXFYZ-V1.0.bin`, size 1,456,256 bytes.
- Upload path was rechecked against the available GitHub connector capabilities.
- Result: **UPLOAD COULD NOT BE COMPLETED** in the current environment. The GitHub connector exposes text-file/blob operations; its `create_blob` endpoint accepts the full blob as an inline UTF-8/base64 string, but there is no binary-file/path upload operation and the functions runtime cannot pass the mounted attachment bytes/path directly into that field.
- A direct network fallback was also attempted from the container, but external GitHub DNS/network access is unavailable (`Could not resolve host: github.com`).
- No incorrect placeholder blob was created and no binary file was substituted with a different build.
- Public repository state therefore remains: manifest V1.0 points to `JEXFYZ-V1.0.bin`, but that binary is still absent from the repository.
- No firmware logic was changed.
- Next publication boundary: the exact binary must be uploaded through a path that supports binary transfer (for example manual upload to the repository by the user, or a future connector/workflow that accepts the file bytes). After the binary is present, verify the raw URL before relying on Online OTA.

## 2026-09-27 — EXECUTION: USER V1.0 BIN RENAMED/PROMOTED TO PUBLIC V1.0

- User explicitly uploaded the manually compiled ArduinoDroid V1.0 BIN to `TenzoNkz/JEXFYZ-Firmware` as `V1.0.bin` and authorized execution to rename it.
- Action performed: replaced the existing public `JEXFYZ-V1.0.bin` entry (the earlier CI binary) with the exact blob from the user's uploaded `V1.0.bin`, then removed the temporary `V1.0.bin` path using a Git tree/commit operation.
- User BIN blob SHA: `fbb43cff080bff787ab6ea31b08042b744cc8809`.
- User BIN size: **1,456,256 bytes**.
- New public path: `JEXFYZ-V1.0.bin`.
- Public firmware repository commit: `d952b5bf8f8873e1e168236749d84c5237141c33`.
- Verification after update: repository root contains only `JEXFYZ-V1.0.bin` and `manifest.json`; no temporary `V1.0.bin` remains.
- `manifest.json` remains V1.0 and points to the exact public raw URL:
  `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.0.bin`.
- This confirms the public V1.0 binary now corresponds to the user's manually compiled ArduinoDroid binary rather than the earlier CI-generated binary.
- Firmware runtime status: the user's physical device has successfully demonstrated Local OTA in both directions using V1.0/V1.5 test labels. Online OTA test is now ready to proceed from the App using a current APK; do not infer Online OTA transfer success until it is physically executed and logged.

## 2026-09-27 — DISCUSSION: STANDARD USER BIN RENAME WORKFLOW CONFIRMED

- User confirmed the intended recurring firmware publication workflow:
  - User may upload the newly compiled BIN to `TenzoNkz/JEXFYZ-Firmware` using any temporary filename.
  - ChatGPT must identify/verify the newly uploaded BIN, then replace/remove the previous public versioned binary as required and rename the new verified BIN to the official `JEXFYZ-Vx.y.bin` path.
  - The manifest must remain aligned with the declared firmware version and official filename.
- Important operational detail: the source filename is treated as temporary only; the binary contents/blob identity must be preserved during the rename. The previous public binary must not be confused with or accidentally retained as the new release.
- Before any rename/publication, verify the uploaded file's actual size/blob and, when available, embedded firmware version against the user's declared version and source context.
- After rename, verify that the temporary upload path no longer remains unless the user explicitly asks to keep a copy.
- This workflow is now the standard publication procedure for future user-supplied ArduinoDroid BIN releases.

## 2026-09-27 — RUNTIME RESULT: ONLINE OTA V1.5 → V1.0 FAIL AT WIFI CONNECT

- User physically tested Online OTA from a device running test-labeled **V1.5** while the public manifest/target is **V1.0**.
- App-side version gate now behaved correctly: the Firmware dialog showed **Current: V1.5**, **Latest: V1.0**, **Update available** and exposed the Update action.
- After Update was started, the App Home notification showed approximately:
  `OTA in progress • ONLINE • Wi-Fi connect • 0%`.
- The following observed screen showed BLE/device telemetry disconnected/reconnecting and Home values blank (`--`). No completed Online OTA download/install result was observed.
- This means the Online OTA test passed the App version-availability gate and entered the firmware's `ONLINE_WIFI_CONNECT` stage, but did not reach GitHub/range/download stages in the observed session.
- Current firmware source confirms that Online OTA enters this stage by stopping BLE and calling the Wi-Fi STA startup sequence:
  `WiFi.disconnect(true, false)` → `WiFi.softAPdisconnect(true)` → `WiFi.setHostname("JE-X-FYZ")` → `WiFi.mode(WIFI_STA)` → `WiFi.setSleep(false)` → `WiFi.setAutoReconnect(false)` → `WiFi.begin(...)`.
- Earlier isolated physical diagnostics already proved that, on the user's ESP32-C3 / Arduino-ESP32 Core 3.3.7 environment, the sibling public call `WiFi.mode(WIFI_AP)` panics before returning. A dedicated `WiFi.mode(WIFI_STA)` diagnostic source exists in history (commit `e8185cb24acb7475a533a859208156b43ecd4c03`), but its physical runtime boundary has not yet been successfully captured.
- Therefore the current Online OTA failure is **strongly consistent with a failure during STA-mode Wi-Fi initialization**, potentially at `WiFi.mode(WIFI_STA)`, but this is **not yet proven** from the current screenshots alone.
- Important: the failure has not reached HTTPS/GitHub/range/download logic, so do not modify the Range/HTTP/flash portion yet.
- Local OTA remains protected and must not be changed as part of this diagnosis.
- No firmware source or App source was changed by this discussion.
- Next diagnostic boundary: preserve the complete Serial Monitor output from the Online OTA attempt, especially the last line before disconnect/reset; alternatively obtain a valid physical result from the existing minimal `WiFi.mode(WIFI_STA)` diagnostic. Only after the exact STA boundary is confirmed should a production Online OTA fix be executed.

## 2026-09-27 — DISCUSSION: NEXT ACTION FOR ONLINE OTA FAILURE

- User requested clear next-step instructions after the Online OTA V1.5 → V1.0 failure.
- Current evidence boundary is fixed at `ONLINE_WIFI_CONNECT` / 0% with no observed GitHub/HTTPS/download stage.
- Immediate user action: test the existing minimal `firmware/diagnostics/JEXFYZ-WiFi-STA-Mode-Test.ino` with the locked ArduinoDroid profile and Arduino-ESP32 Core 3.3.7. Do not flash the production `firmware/JEXFYZ.ino` for this diagnostic.
- Serial Monitor requirements:
  - baud: 115200
  - start capture from reset/boot
  - preserve every line, including any Guru Meditation/reset/backtrace
  - critical lines are CORE, CHIP, CHIP_REV, STEP 1, STEP 2, STEP 3, STEP 4, and RESULT.
- Interpretation boundary:
  - If `WiFi.mode(WIFI_STA)` returns and `RESULT: WIFI STA MODE READY` appears, the failure is later in the Online OTA STA sequence and the next isolated test is `WiFi.begin()`/connection handling.
  - If the device panics before `STEP 3`, the failure boundary is inside `WiFi.mode(WIFI_STA)`/its internal Core 3.3.7 initialization path; only then should a production patch be designed around the proven boundary.
  - If the diagnostic output is absent or incomplete, first fix the evidence/capture boundary; do not patch production firmware from an ambiguous result.
- Do not modify HTTPS/GitHub/Range/download/flash code yet.
- Do not modify Local OTA.
- No executable source change or build was authorized by this discussion.
- Chat handoff status: **DISCUSSION — NOT YET READY FOR EXECUTION** until the STA diagnostic result is captured and classified.

## 2026-09-27 — DISCUSSION: NON-INTRUSIVE ONLINE OTA DIAGNOSIS PREFERRED

- User does **not** want to replace/reflash the currently installed test firmware and does **not** want to rely on Serial Monitor for the next Online OTA diagnosis.
- Diagnostic preference: use the existing production firmware V1.5 test image and the App's existing OTA notification/telemetry only.
- Therefore do not require the standalone `WiFi.mode(WIFI_STA)` diagnostic at this time and do not ask the user to replace the current device firmware merely to collect the next evidence.
- The current Online OTA attempt already reached `ONLINE_WIFI_CONNECT` at 0%. The existing firmware has a 15-second `WIFI_CONNECT_TIMEOUT_MS` and publishes `ONLINE_WIFI_FAILED` when that timeout is reached.
- Next non-intrusive test: with the device still on the current V1.5 test firmware, run Online OTA again and observe the App Notify panel through the full timeout window. Record the final stage/error/result shown after the Wi-Fi connect attempt, rather than stopping at the transient `Wi-Fi connect • 0%` state.
- If the App reports `ONLINE_WIFI_FAILED` / `WIFI_FAILED`, the failure is confirmed at the STA connection stage without changing firmware.
- If the notification advances to `ONLINE_WIFI_CONNECTED`, `ONLINE_TIME_SYNC`, `ONLINE_GITHUB_CONNECT`, or later, then the failure is later than STA startup and the next diagnosis can target that exact stage.
- If the App/device disconnects and never publishes a terminal OTA status, the next step remains evidence collection from the existing firmware/session behavior; do not invent a root cause and do not alter Local OTA.
- No code, firmware, or App changes are authorized by this discussion.
- Chat handoff status: **DISCUSSION — NON-INTRUSIVE TEST WITH CURRENT FIRMWARE**.

## 2026-09-27 — RUNTIME EVIDENCE: BOOT AP SUCCEEDS BUT HEAP CORRUPTION IS REPORTED

- User supplied fresh Serial Monitor + App screenshots after another Online OTA V1.5 → V1.0 attempt.
- Serial output begins with:
  - `CORRUPT HEAP: Bad head at 0x3fcbff38. Expected 0xabbac234 got 0xAAAAAAAA`
  - then normal boot continues through `BOOT: FEATURES READY`, `BOOT: WIFI AP DEFERRED TO LOOP`, `BOOT: START WIFI AP FROM LOOP`.
  - `WIFI AP: SOFTAP RESULT=OK`
  - `WIFI AP: READY SSID=JE X FYZ IP=192.168.4.1`
  - `WIFI AP: HTTP READY`
  - `WIFI AP: TIMEOUT → BLE HANDOFF`
  - `BLE: STARTBLE: READY/ADVERTISING`
- This is new runtime evidence that the production firmware can successfully start its boot SoftAP and HTTP server on this physical run; therefore the earlier isolated `WiFi.mode(WIFI_AP)` panic cannot by itself be treated as a universal failure of Wi-Fi AP startup.
- The heap-corruption message is a separate and important runtime fault indicator. It appears before the boot banner and is not explained by the screenshot alone. Do not declare its root cause yet.
- App screenshot still shows `OTA in progress • ONLINE • Wi-Fi connect • 0%` and `CONNECTING`, with telemetry fields blank. The observed session still does not show a terminal `ONLINE_WIFI_FAILED` or any GitHub/HTTPS/download stage.
- The sequence therefore remains consistent with an Online OTA session being interrupted/lost before a terminal OTA status was delivered over BLE; however, this screenshot set does not prove whether the interruption is caused by Wi-Fi STA initialization, a reset/heap fault, BLE reconnection timing, or another failure.
- Important new boundary: **HEAP CORRUPTION must be preserved as a first-class runtime issue.** Do not patch Online OTA networking before classifying whether the heap fault is pre-existing at boot or triggered by the OTA transition.
- No source code changed in this discussion.
- Next diagnostic preference remains non-intrusive: do not replace the currently installed firmware. Capture the complete Serial output spanning the exact moment the Online OTA Update button is pressed, including any reset/heap/panic lines, if the user is willing to repeat the test. If the device resets immediately after the button press, that reset/heap evidence becomes the primary boundary.
- Chat handoff status: **DISCUSSION — NEW EVIDENCE, NOT YET READY FOR EXECUTION**.

## 2026-09-27 — RUNTIME CLASSIFICATION: HEAP CORRUPTION OCCURS ON CLOUDOTA START, BEFORE WIFI STA COMPLETION

- User provided the complete Serial trace and confirmed the heap corruption happens immediately after pressing the App Online OTA Update action while the device remains on the current test firmware V1.5.
- Relevant timing/evidence:
  - Boot AP and BLE handoff completed normally at approximately 20:51:28.
  - At approximately 20:52:13, immediately after the user initiated Online OTA, the device reported:
    `CORRUPT HEAP: Bad head at 0x3fcbfeac. Expected 0xabba1234 got 0x3fca0da4`
    followed by
    `assert failed: multi_heap_free multi_heap_poisoning.c:279 (head != NULL)`
  - The device then rebooted with `rst:0xc (RTC_SW_CPU_RST)`.
  - After reboot, the normal boot AP + HTTP + BLE advertising sequence succeeded again.
- App state at the same test boundary remained `OTA in progress • ONLINE • Wi-Fi connect • 0%`; no GitHub/HTTPS/range/download stage was reached.
- Source-path classification:
  - The App sends `OTAENTER`, `SSID:`, `PASS:`, `URL:`, `VERSION:`, then `CLOUDOTA`, waiting for ACK after each command.
  - Firmware `CLOUDOTA` handling only schedules Online OTA.
  - After the BLE TX queue settles or the 1.5 s safety wait expires, `processPendingOnlineOtaStart()` calls `startOnlineOta()`.
  - `startOnlineOta()` first enters `ONLINE_WIFI_CONNECT`, clears BLE queues, calls `stopBleRadio()`, and only after that begins the Wi-Fi STA sequence.
  - `stopBleRadio()` calls the official `BLEDevice::deinit(true)`.
- Exact pinned Arduino-ESP32 Core 3.3.7 upstream `BLEDevice::deinit(true)` was inspected:
  - stops advertising/scanning;
  - deletes BLE advertising/scan/server/client objects;
  - clears the connected-client map;
  - disables and deinitializes the configured BLE stack;
  - disables/deinitializes the Bluetooth controller;
  - with `release_memory=true`, releases BTDM controller memory via `esp_bt_controller_mem_release(ESP_BT_MODE_BTDM)` when enabled.
- Engineering conclusion at this boundary: **the strongest current suspect is the BLE teardown / BLE-to-Wi-Fi radio transition, especially `BLEDevice::deinit(true)` or an asynchronous BLE event/callback interacting with teardown**, because the heap-free assert occurs immediately at Online OTA start and before any confirmed `WiFi.mode(WIFI_STA)` return or GitHub activity. This is a hypothesis, not yet a proven root cause.
- The previous standalone `WiFi.mode(WIFI_AP)` panic remains relevant historical evidence, but the latest production run successfully starts AP and HTTP, so it is not sufficient to explain the current Online OTA heap corruption.
- No code change was executed from this classification. Local OTA remains protected.
- Next diagnostic boundary: inspect the exact BLE teardown ownership/lifecycle in the production path and compare it with the pinned Core 3.3.7 BLE implementation before designing a minimal change. Do not change HTTPS/Range/download/flash logic until the teardown boundary is classified.
- Chat handoff status: **DISCUSSION — ROOT-CAUSE CANDIDATE IDENTIFIED, NOT YET READY FOR EXECUTION**.

## 2026-09-27 — DISCUSSION: HISTORICAL ROOT-CAUSE CORRELATION — BLE deinit(true) INTRODUCED IN V3.6

- Historical source diff was inspected between the pre-V3.6 firmware and the V3.6 firmware commit `be4e1dfba432f2402ce57d17e45a9f92397b18d9`.
- The V3.6 change explicitly changed the Online OTA BLE teardown from:
  `BLEDevice::deinit(false)`
  to:
  `BLEDevice::deinit(true)`.
- The same V3.6 change consolidated the handoff into `stopBleRadio()`, which is used by Online OTA before starting Wi-Fi.
- The current production source retained `BLEDevice::deinit(true)`.
- Pinned Arduino-ESP32 Core 3.3.7 implementation confirms `BLEDevice::deinit(true)` performs normal BLE teardown and, with `release_memory=true`, additionally releases Bluetooth controller memory via `esp_bt_controller_mem_release(ESP_BT_MODE_BTDM)` when that controller path is enabled.
- New physical evidence shows the user's current V1.5 test firmware reports heap corruption/assert immediately after Online OTA is started, during the BLE→Wi-Fi transition, before any confirmed HTTPS/GitHub/download stage.
- This creates a strong historical correlation between the change to `deinit(true)` and the current failure mode. It is still a **root-cause candidate, not a proven causal conclusion**.
- Candidate minimal investigation: compare behavior of Online OTA handoff using `deinit(false)` versus `deinit(true)`, while preserving the rest of the OTA engine and Local OTA path unchanged.
- Do not execute the candidate change yet. No firmware/App source was modified by this discussion.
- Chat handoff status: **DISCUSSION — STRONG ROOT-CAUSE CANDIDATE IDENTIFIED; READY FOR TARGETED EXECUTION ONLY AFTER USER AUTHORIZATION**.

## 2026-09-27 — CLARIFICATION: PHYSICAL "V1.5" IS V1.0 CODE WITH TEST VERSION LABEL

- User clarified that the firmware currently installed on the physical device and displayed as **V1.5** is **not a separate V1.5 codebase**.
- It is the current production `firmware/JEXFYZ.ino` codebase whose firmware version string was manually changed/labeled as `V1.5` solely for controlled Local OTA and Online OTA testing.
- Therefore, all runtime behavior observed during the current Online OTA test belongs to the V1.0 codebase/logic, with only the reported firmware version label changed to V1.5 for version-gate testing.
- This distinction is important: the current failure must not be described as a defect unique to a V1.5 implementation or as evidence that a separate V1.5 release was deployed.
- The `BLEDevice::deinit(true)` candidate remains technically relevant because it is present in the current V1.0 codebase being tested; however, the earlier historical statement that its introduction in a V3.6-labeled release alone proves causality is downgraded to correlation/history. Root cause remains unproven.
- Current controlled test meaning is:
  - Installed/test image: **V1.0 code labeled V1.5**
  - Target/public image: **V1.0**
  - Version gate: V1.5 vs V1.0 => different => Online OTA permitted
  - The test is therefore specifically exercising the Online OTA transition and version-different path without introducing unrelated firmware feature changes.
- No code was changed in this clarification.
- Chat handoff status: **DISCUSSION — CURRENT TEST LINEAGE CORRECTED; TARGETED EXECUTION STILL AVAILABLE BUT ROOT CAUSE IS NOT YET PROVEN**.

## 2026-09-27 — EXECUTION: ONLINE OTA BLE→Wi-Fi HEAP FIX CANDIDATE

- User explicitly authorized `Eksekusi Code dan Firmware Full`.
- Executed targeted firmware source change against the authoritative `firmware/JEXFYZ.ino`.
- Firmware source version advanced from **V1.0 → V1.1** because executable behavior changed. V1.1 is a controlled test candidate; it is not a public production release yet.
- Fix boundary:
  - `stopBleRadio()` now accepts a `releaseBluetoothMemory` parameter, defaulting to `true`.
  - Boot AP/local-OTA handoff explicitly calls `stopBleRadio(true)`, preserving the established Local OTA BLE teardown behavior.
  - Online OTA explicitly calls `stopBleRadio(false)`, so the BLE→Wi-Fi handoff no longer requests Bluetooth controller memory release during the live transition.
  - No HTTPS, GitHub, Range, download, `Update.begin/write/end`, NTC, cooling, RGB, Adaptive, GPIO, or App source logic was changed.
- The current source therefore isolates the suspected failure mechanism to Online OTA only instead of globally changing BLE teardown behavior.
- 🛡️ OTA SATPAM-equivalent static verification against `firmware/OTA_GOLD_MASTER_LOCK.json`: **PASS** after refreshing the lock candidate's protected `OTA_ENGINE` content to the deliberate source state. Lock status remains `CANDIDATE_NOT_PHYSICALLY_VERIFIED`.
- Important protection result: boot/local-OTA path remains explicitly `stopBleRadio(true)`; the Online OTA path is the only path intentionally changed to `false`.
- Git commits:
  - Firmware source: `3732b510cbaa284771a7b8639608d224168870a4`
  - OTA lock candidate refresh: `e9f19a9b0111f0fa1c0a5391004af7c7da26c85f`
- Current authoritative firmware source blob SHA: `33e92493ad34a895c04c33c4a6b2e4c490d9973d`.
- Automated firmware CI build was **not executed** in this environment because the current `main` branch no longer contains `.github/workflows/firmware-build.yml`; only the App workflow is present under `.github/workflows/`. No replacement workflow was invented during this execution.
- No public firmware release was changed. `JEXFYZ-Firmware` remains on public V1.0 and `manifest.json` remains V1.0.
- Next physical validation: compile the current V1.1 source using the locked ArduinoDroid/Core 3.3.7 profile. For Online OTA A/B testing, the device may be manually relabeled V1.5 again so the public V1.0 target remains a version-different update target. Do not change the Local OTA path.
- Success criterion: the device must survive the BLE→Wi-Fi handoff without heap corruption/reboot, then advance beyond `ONLINE_WIFI_CONNECT` to `ONLINE_WIFI_CONNECTED` and subsequent stages. If it still fails, preserve the exact new stage/error before making another source change.
- Chat handoff status: **EXECUTION COMPLETE — PHYSICAL V1.1 TEST PENDING**.

## 2026-09-27 — HANDOFF: V1.1 ONLINE OTA HEAP-FIX .INO READY FOR LOCAL OTA YOLO

- User requested the exact test firmware source file in chat so it can be transferred to the device through the already-working Local OTA path.
- Prepared local source file: `JEXFYZ-V1.1-OnlineOTA-HeapFix.ino`.
- Source lineage: current authoritative V1.0 `firmware/JEXFYZ.ino` plus only the targeted Online OTA BLE→Wi-Fi handoff fix already committed in `3732b510cbaa284771a7b8639608d224168870a4`.
- File changes:
  - `FW_VERSION`: V1.0 → V1.1 test label.
  - `stopBleRadio(bool releaseBluetoothMemory = true)`.
  - Boot/local-OTA path uses `stopBleRadio(true)`.
  - Online OTA path uses `stopBleRadio(false)`.
  - No other source logic intentionally changed.
- Local file size: **107,415 bytes**.
- Local file SHA-256: `ca8c47baf171536b9ab9b90f6137e11a4208e3b5fdb1173393cb5248c8ee3232`.
- This file is a **test candidate**, not a public release and not a change to the public V1.0 manifest/binary.
- User will apply it through the already validated Local OTA path. Expected first physical validation target is survival through BLE→Wi-Fi handoff without the previously observed heap corruption/reboot, followed by progress beyond `ONLINE_WIFI_CONNECT`.

## 2026-09-27 — HANDOFF: V1.1 ONLINE OTA HEAP-FIX .INO DELIVERED

- User requested the executable firmware source file for manual Local OTA/recompile testing.
- Delivered working file: `/mnt/data/JEXFYZ-V1.1.ino` (derived from the current V1.1 heap-fix candidate source).
- File contains:
  - `FW_VERSION = "V1.1"`
  - Online OTA handoff uses `stopBleRadio(false)`
  - Boot/local-OTA handoff uses `stopBleRadio(true)`
- Local file size: 107,415 bytes, 3,766 LF-terminated lines. The GitHub source currently reports 107,387 characters / 3,767 lines because its fetched representation includes a trailing line break difference; executable source content/structure is otherwise the current V1.1 candidate.
- This file is intended for the user's ArduinoDroid compilation and/or Local OTA recovery test. No public firmware release/manifest was changed by this handoff.
- Physical device remains on the existing V1.5 test-labeled V1.0-code image until the user manually applies/tests V1.1.

## 2026-09-27 — FIX: ArduinoDroid DEFAULT-ARGUMENT COMPILATION ERROR

- Physical ArduinoDroid compile of the V1.1 candidate reported:
  `redefinition of default argument` at the `stopBleRadio` definition.
- Cause: the Arduino sketch preprocessor can generate a function prototype, so declaring a default argument again in the function definition is rejected by the compiler.
- Fix applied:
  - `static void stopBleRadio(bool releaseBluetoothMemory = true)`
  - changed to
  - `static void stopBleRadio(bool releaseBluetoothMemory)`
- All current call sites already pass the argument explicitly:
  - boot/local OTA: `stopBleRadio(true)`
  - online OTA: `stopBleRadio(false)`
- Therefore behavior is unchanged; this is a compile-only correction.
- Firmware source commit: `5ca5223a50ff93b735e9ae7e19a04c3f109664be`.
- Physical test candidate remains V1.1.
- Corrected local file: `JEXFYZ-V1.1-FIXED.ino`.
- Chat handoff status: **FIX COMPLETE — READY TO COMPILE IN ARDUINODROID**.

## 2026-09-27 — FIX: ARDUINODROID "REDEFINITION OF DEFAULT ARGUMENT" IN V1.1 .INO

- User attempted to compile the delivered V1.1 Online OTA heap-fix source in ArduinoDroid/Core 3.3.7.
- Compile error reported at the `stopBleRadio` definition:
  `redefinition of default argument`.
- Root cause: the delivered .ino contained a default argument in the function definition:
  `static void stopBleRadio(bool releaseBluetoothMemory = true)`
  Arduino's automatic prototype generation can create a conflicting default-argument declaration.
- Fix applied to the delivered .ino: removed the default value from the definition:
  `static void stopBleRadio(bool releaseBluetoothMemory)`
  Both call sites are already explicit:
  - boot/local OTA: `stopBleRadio(true)`
  - Online OTA: `stopBleRadio(false)`
- No runtime behavior changed by this compile-only correction.
- The authoritative repository source `firmware/JEXFYZ.ino` was rechecked and already contains the corrected no-default signature.
- Corrected local file: `/mnt/data/JEXFYZ-V1.1.ino`
- Corrected local file size: **107,408 bytes**; SHA-256: `d67eb079bf4a2385b06794eabd05e03b990fd9a62348242764796e951dc80016`.
- No public firmware release or manifest was changed.
- Chat handoff status: **FIX COMPLETE — RETRY COMPILE/LOCAL OTA WITH CORRECTED V1.1 SOURCE**.

## 2026-09-27 — EXECUTION: V1.1 BINARY PUBLISHED FROM USER UPLOAD

- User explicitly reported that the newly compiled/tested **V1.1 BIN** had been uploaded to `TenzoNkz/JEXFYZ-Firmware` as temporary file `V1.1.bin`.
- Repository was rechecked before publication:
  - `V1.0` official binary was present as `JEXFYZ-V1.0.bin`.
  - New user-uploaded binary was present as `V1.1.bin`.
  - `V1.1.bin` repository blob SHA: `a2ec2e4504527a159be8498b682e7f1e22abb5a0`.
  - Size: **1,456,272 bytes**.
- Publication action:
  - Removed old public `JEXFYZ-V1.0.bin`.
  - Promoted the user's exact `V1.1.bin` blob to official path `JEXFYZ-V1.1.bin`.
  - Removed temporary `V1.1.bin`.
  - Updated `manifest.json` from V1.0 to V1.1 and pointed it to the exact V1.1 raw URL.
- Public firmware repository verification after the commit:
  - Root contains only `JEXFYZ-V1.1.bin` and `manifest.json`.
  - `JEXFYZ-V1.1.bin` has blob SHA `a2ec2e4504527a159be8498b682e7f1e22abb5a0`.
  - Manifest reports `version: V1.1` and the matching raw URL.
- Publication commit: `b013d87a88ac33b8f4210618e17599a1817ada5a`.
- This is a test candidate based on the user's V1.1 heap-fix binary; it is **not yet an OTA Gold Master or final production firmware** until physical Online OTA validation passes.
- Important test consequence: the existing device running the older V1.0 code labeled V1.5 can now target public V1.1 in the App as a different version. However, because the App's Online OTA credentials/URL are provided at runtime from the manifest flow, the next physical test should use the current V1.1 binary as the online target.
- Chat handoff status: **EXECUTION COMPLETE — PUBLIC V1.1 TEST BINARY PUBLISHED; PHYSICAL ONLINE OTA VALIDATION PENDING**.

## 2026-09-27 — PHYSICAL RESULT: V1.1 HEAP FIX DID NOT SOLVE ONLINE OTA

- User tested the V1.1 heap-fix candidate after applying it through the working Local OTA path.
- Controlled Local OTA results:
  - test-labeled V1.5 (V1.0 code) → V1.1: **PASS**
  - V1.1 → test-labeled V1.99 (V1.1 code): **PASS**
- Therefore the V1.1 image is bootable and the Local OTA path remains functional with the current candidate.
- Online OTA result:
  - test-labeled V1.99 (V1.1 code) → public V1.1: **FAIL**
- This physically falsifies the previous narrow hypothesis that only `BLEDevice::deinit(true)` / BTDM memory release was the direct cause. The Online OTA path still fails after changing the live Online OTA handoff to `stopBleRadio(false)`.
- Current diagnosis should therefore move from a single teardown call to the **overall custom Online OTA mechanism**.
- User proposed simplifying Online OTA to an Arduino-standard implementation. This is technically appropriate and should be treated as the next design direction, not yet as executed code.
- Recommended standard flow for the next candidate:
  1. App sends existing metadata/credentials through the unchanged P1 protocol.
  2. Firmware exits BLE cleanly and starts Wi-Fi STA.
  3. Wait for `WL_CONNECTED` with a bounded timeout.
  4. Perform time synchronization as required for HTTPS certificate validation.
  5. Open the GitHub raw URL once through `WiFiClientSecure + HTTPClient`, following GitHub redirects.
  6. Require a normal `HTTP 200 OK` response and a valid `Content-Length`.
  7. Check `ESP.getFreeSketchSpace()`.
  8. Use the standard Arduino `Update.begin(contentLength)` → `Update.writeStream(http.getStream())` → `Update.end(true)` lifecycle.
  9. On success, restart; on failure, report exact stage/error and recover to BLE where possible.
- The custom Range probe/chunk/retry/resume stream should be removed from Online OTA in this candidate because it is not necessary for a normal GitHub raw firmware download and makes the failure surface considerably larger.
- Local OTA must remain untouched.
- App OTA metadata/version gate must remain unchanged.
- Before executing this redesign, refresh the OTA Gold Master protection boundary so the intended new Online OTA block is deliberately approved and then re-run the guard.
- No source code was changed in this discussion.
- Chat handoff status: **DISCUSSION — STANDARD ARDUINO ONLINE OTA REDESIGN PROPOSED; NOT YET EXECUTED**.
## 2026-09-27 — DISCUSSION DECISION: REPLACE CUSTOM ONLINE OTA ENGINE WITH ARDUINO HTTPUpdate FLOW

- User's latest physical matrix:
  - Local OTA: test V1.5 (V1.0 code) -> V1.1 PASS
  - Local OTA: V1.1 -> test V1.99 (V1.1 code) PASS
  - Online OTA: V1.99 (V1.1 code) -> public V1.1 FAIL
- This physically confirms that the BLEDevice::deinit(false) candidate did not solve Online OTA. The failure is therefore no longer treated as a single BLE memory-release issue.
- User requested a simpler Online OTA mechanism based on the standard Arduino path.
- Proposed next architecture (discussion only; not executed):
  1. Keep the App version gate and P1 OTA metadata commands unchanged.
  2. Apply OTA safe outputs.
  3. Stop BLE for the single-radio handoff.
  4. Start Wi-Fi STA using Arduino WiFi.mode(WIFI_STA) + WiFi.begin(), bounded by the existing timeout.
  5. Perform time synchronization required for HTTPS certificate validation.
  6. Use the standard Arduino HTTPUpdate library with WiFiClientSecure/HTTPClient and follow redirects.
  7. Let the library perform the normal update lifecycle using the official Update.begin() / Update.writeStream() / Update.end() path internally.
  8. Do not pass the current firmware version into HTTPUpdate.update(); the App has already enforced the project rule that any different valid version is eligible, including downgrade. Passing a version to the helper could introduce a second, conflicting version policy.
  9. Preserve exact stage/error reporting at the application boundary and recover to BLE on failure; success restarts into the new firmware.
  10. Remove the custom Range probe/chunk/retry/resume streaming code from Online OTA because the next candidate's goal is a minimal standard-Arduino transport path.
- Official Arduino-ESP32 library inspection confirms HTTPUpdate exposes the high-level firmware update API, redirect configuration, start/end/error/progress callbacks, and uses Update.writeStream() internally.
- Local OTA remains untouched.
- Online OTA public manifest/binary remains V1.1 during this test cycle; no release change was executed by this discussion.
- Before implementation, the OTA Gold Master candidate must be deliberately refreshed for the new Online OTA block and re-audited. No automatic Secretary repair should invent this new block.
- Chat handoff status: DISCUSSION — STANDARD ARDUINO HTTPUPDATE REDESIGN APPROVED AS NEXT IMPLEMENTATION DIRECTION; NOT YET EXECUTED.

## 2026-09-27 — DISCUSSION: SIMPLIFY ONLINE OTA TO OFFICIAL ARDUINO HTTPUpdate

- User requested that Online OTA be redesigned to a simpler Arduino Standard mechanism after the V1.1 BLE-memory handoff candidate still failed physically.
- Current physical matrix:
  - Local OTA test-label V1.5 (V1.0 code) -> V1.1: PASS
  - V1.1 -> test-label V1.99 (V1.1 code): PASS
  - Online OTA test-label V1.99 (V1.1 code) -> public V1.1: FAIL
- The failure therefore remains isolated to the custom Online OTA path; Local OTA is currently functioning and must remain untouched.
- Official Arduino-ESP32 Core 3.3.7 HTTPUpdate was inspected. It provides the high-level HTTPUpdate.update(NetworkClient&, url, currentVersion) API, redirect control, start/end/error/progress callbacks, free-space check, HTTP 200 + Content-Length validation, image magic-byte validation, and the official Update.begin() / Update.writeStream() / Update.end() lifecycle internally.
- Proposed next Online OTA architecture:
  1. Keep the existing P1 metadata/version-gate/App flow unchanged.
  2. Apply OTA safe outputs.
  3. Stop BLE only for the radio handoff; keep the current explicit single-radio sequence.
  4. Start Wi-Fi in STA and wait for WL_CONNECTED with the existing bounded timeout.
  5. Run configTime(...) and wait for valid time for HTTPS verification.
  6. Use one WiFiClientSecure + HTTPUpdate transaction against the GitHub raw URL, with forced redirect following.
  7. Set HTTPUpdate.rebootOnUpdate(false) so the firmware retains control of diagnostics/recovery rather than letting the library restart immediately.
  8. Map HTTPUpdate callbacks/result/error into the existing OTA diagnostic stages and App Notify messages.
  9. On success, schedule the existing controlled restart; on failure, report exact HTTPUpdate.getLastError() / error-string information and recover to BLE where possible.
- Intentionally remove from the Online OTA engine:
  - Range probe (bytes=0-0)
  - manual Content-Range parser
  - 64 KiB chunk loop
  - custom resumable retry logic
  - custom OtaHttpFlashStream
  - manual Update.begin/write/end orchestration for Online OTA
  - duplicated HTTPClient/cloudClient lifecycle
- Rationale: the official Arduino HTTPUpdate implementation already performs the required firmware download/update lifecycle and considerably reduces the number of custom failure surfaces.
- HTTPS remains secured with the pinned GitHub CA; no insecure TLS mode is proposed.
- Online version policy remains owned by the App/firmware command flow: any different valid version is allowed, including downgrade; do not pass the device version to HTTPUpdate.update() as an update gate.
- No code execution or source modification was performed by this discussion update.
- Before implementation, the OTA Gold Master candidate must be deliberately refreshed for the new Online OTA block and SATPAM re-run. Local OTA protected content remains unchanged.
- Chat handoff status: DISCUSSION — STANDARD ARDUINO HTTPUPDATE REDESIGN IS THE NEXT EXECUTION CANDIDATE; NOT YET EXECUTED.
## 2026-09-27 — DISCUSSION APPROVAL: STANDARD ARDUINO HTTPUpdate REDESIGN

- User approved replacing the custom Online OTA transport with the official Arduino-ESP32 HTTPUpdate approach, with the explicit requirement that the resulting mechanism must be physically validated and not assumed successful.
- Approval is for the design only; no production source modification or build was executed in this discussion.
- Required acceptance path remains:
  - BLE single-radio handoff -> Wi-Fi STA -> bounded Wi-Fi connection
  - HTTPS time readiness as required
  - one official HTTPUpdate transaction to the GitHub raw firmware URL
  - HTTPUpdate-managed Update.begin/writeStream/end lifecycle
  - exact failure-stage reporting and BLE recovery on failure
  - controlled restart only after a successful update
  - Local OTA unchanged.
- The standard-library design is selected specifically to reduce custom transport state and failure surfaces. It is not considered proven until a physical Online OTA test succeeds.
- Chat handoff status: DISCUSSION — DESIGN APPROVED; READY FOR `Eksekusi Full`.

## 2026-09-27 — EXECUTION: V1.2 ONLINE OTA REBUILT ON ARDUINO HTTPUpdate

- User explicitly authorized `Eksekusi Code dan Firmware Full` for the approved standard-Arduino Online OTA redesign.
- Authoritative firmware source `firmware/JEXFYZ.ino` advanced to **V1.2** because the executable Online OTA implementation changed.
- Online OTA transport was replaced with the official Arduino-ESP32 `HTTPUpdate` flow:
  - `WiFiClientSecure` keeps the pinned GitHub CA.
  - `HTTPUpdate` uses the configured 60 s HTTP timeout and forced redirect following.
  - Version eligibility remains owned by the existing JE X FYZ P1/App policy; the device `FW_VERSION` is intentionally NOT passed as the HTTPUpdate `currentVersion` argument.
  - Official update lifecycle is delegated to HTTPUpdate internally (`Update.begin` / `Update.writeStream` / `Update.end`).
  - `rebootOnUpdate(false)` retains control of final diagnostics/restart.
  - Existing OTA diagnostic callbacks now report HTTPUpdate start/progress/error/end.
  - Failed transactions call `Update.abort()` before radio recovery.
  - Successful transactions set the existing boot-partition/success result and use the existing controlled restart delay.
- Removed the custom Online OTA transport implementation:
  - Range probe and Content-Range parsing
  - 64 KiB chunk streaming
  - manual resumable retry/resume loop
  - custom `OtaHttpFlashStream`
  - duplicated HTTPClient transaction handling
  - manual Online OTA `Update.begin/write/end` orchestration
- BLE handoff remains explicit and single-radio:
  - Online OTA uses `stopBleRadio(false)`, preserving BT controller memory during the live handoff.
  - Boot/local OTA continues to use `stopBleRadio(true)`.
- Local OTA engine and application features were not intentionally changed.
- 🛡️ SATPAM static verification after the final V1.2 source + lock update: **PASS**.
- OTA lock candidate was refreshed to exactly match the V1.2 protected source and now explicitly requires the HTTPUpdate path while forbidding the removed custom Range transport markers.
- Final firmware source commit: `b29aafdbcb7f8b7c46bc70ca9a958cc3c8a2a442`.
- Final OTA lock synchronization commit: `8ea80a7ee08e5e5f38969e08d4a4801c745d4604`.
- Final current source blob SHA: `72eea61ec02d1ab1956b2d64e784040c2fa57a37`.
- A local ArduinoDroid-ready source file was prepared as `JEXFYZ-V1.2-HTTPUpdate.ino`, size **97,727 bytes**, SHA-256 `10eef9e58ec69054a760b8f26915344ec06e9d8cc1692098ca6b67f13ac79cf4`. Static marker/brace/parenthesis checks: PASS.
- Automated firmware compilation was not executed because the current `main` branch has no `.github/workflows/firmware-build.yml`, and no Arduino CLI/toolchain is available in the container. No replacement CI workflow was invented.
- Public firmware distribution remains intentionally at **V1.1** until a V1.2 BIN compiled by the user's ArduinoDroid environment is supplied/uploaded. No public manifest change was made by this execution.
- Next physical boundary: compile `JEXFYZ-V1.2-HTTPUpdate.ino` using the locked ArduinoDroid/Core 3.3.7 profile, obtain the V1.2 BIN, then test Local OTA into V1.2 before testing Online OTA against the current public V1.1 target.
- Acceptance criterion for Online OTA: survive BLE→Wi-Fi transition, reach Wi-Fi/time sync, execute standard HTTPUpdate, install V1.1 successfully, recover/restart normally, and report a terminal OTA result.
- Chat handoff status: **EXECUTION COMPLETE — V1.2 SOURCE READY; PHYSICAL BUILD/OTA TEST PENDING**.

## 2026-09-28 — EXECUTION: USER V1.2 BIN PROMOTED TO OFFICIAL PATH

- User reported that the compiled V1.2 BIN had been uploaded to `TenzoNkz/JEXFYZ-Firmware`.
- Repository inspection found the new upload as `JEXFYZ.cpp.bin` alongside the previous public `JEXFYZ-V1.1.bin`.
- New uploaded blob:
  - temporary path: `JEXFYZ.cpp.bin`
  - blob SHA: `9534ea090d14bbc982f983d28b581a39f705e557`
  - size: **1,460,688 bytes**
- Publication action completed:
  - promoted the exact uploaded blob to `JEXFYZ-V1.2.bin`
  - removed previous public `JEXFYZ-V1.1.bin`
  - removed temporary `JEXFYZ.cpp.bin`
  - updated `manifest.json` to V1.2 and the matching V1.2 raw URL
- Post-action repository root contains only:
  - `JEXFYZ-V1.2.bin`
  - `manifest.json`
- Manifest verification:
  `version = V1.2`
  `url = https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.2.bin`
- Publication commit: `3d76f2b6407316125e0a45ae29eec4a321665041`.
- The binary connector can verify repository blob metadata but cannot decode the binary contents in this environment; version identity is therefore recorded from the user's declared V1.2 upload and the controlled release path.
- This V1.2 binary is a **physical test candidate**, not an OTA Gold Master/final production release until the Online OTA test passes.
- Next physical test: use the current device running the V1.1 image (or a test label such as V1.99) and test Online OTA to public V1.2, then capture the exact terminal status/stage.
## 2026-09-28 — RUNTIME RESULT: V1.2 STANDARD HTTPUPDATE TEST REACHES BLUE INDICATOR THEN RECOVERS BLE

- User reported that after pressing Online OTA on the V1.2 firmware, the LED turns blue continuously for a short period, then turns off, and Bluetooth reconnects.
- App remains visually stuck at OTA in progress / ONLINE / Wi-Fi connect / 0%.
- In the current V1.2 source, the blue indicator is explicitly triggered when WiFi.status() == WL_CONNECTED is observed at the Online OTA state-machine boundary, ONLINE_WIFI_CONNECTED.
- Therefore the observed blue phase is evidence that the firmware likely reached Wi-Fi connected at least briefly; it is not sufficient evidence of a Wi-Fi-connect failure.
- After that point, the firmware performs NTP time synchronization and then enters the standard HTTPUpdate transaction. A later failure calls failOnlineOta() and restarts BLE.
- The App display can remain at the last BLE-published stage, ONLINE_WIFI_CONNECT, 0%, because BLE is stopped during Online OTA; later stages are not necessarily visible until reconnect/full sync.
- LED behavior discrepancy confirmed from source: triggerOtaIndicator(0x0000FF) sets blue for only OTA_FAILURE_INDICATOR_MS = 1000 ms. After the 1-second indicator, while the OTA state remains active, processLeds() forces LEDs OFF. Failure red indication is likewise only 1000 ms.
- Therefore the user's short blue then off observation is consistent with the current implementation and does not by itself identify the failed network stage.
- Engineering conclusion: Online OTA is still failing, but the latest evidence suggests the failure may be after Wi-Fi connection, potentially time sync or the HTTPUpdate/HTTPS transaction. The exact failure stage is not yet proven from the current App screenshot.
- Recommended next source improvement before another physical test: make OTA LED states persistent/meaningful for the complete active stage, and publish/store the terminal OTA result so the App can display the exact ONLINE stage, error code, and error string after BLE reconnect. Preserve the Arduino-standard HTTPUpdate transport unchanged while improving observability.
- No code modification was made by this discussion update.
- Chat handoff status: DISCUSSION — NEW EVIDENCE CLASSIFIED; NEXT EXECUTION SHOULD IMPROVE OTA STAGE/LED OBSERVABILITY BEFORE CHANGING THE HTTPUPDATE TRANSPORT.
## 2026-09-28 — DISCUSSION: OTA LED RESULT-ONLY NON-BLOCKING INDICATOR

- User clarified the required Online OTA LED behavior precisely.
- LED must NOT be active as a continuous blue indicator while Wi-Fi is attempting to connect.
- When the Wi-Fi mechanism reaches a terminal result (connected OR failed/timeout), the firmware must stop the Wi-Fi stage progression and execute a fixed blue result indicator using `millis()` only:
  - blue ON 500 ms
  - OFF 500 ms
  - blue ON 500 ms
  - OFF 500 ms
  - total indicator window: 2,000 ms
- After the second OFF, continue the next code path:
  - Wi-Fi success -> continue to time sync / Online HTTPUpdate
  - Wi-Fi failure -> continue the existing failure/recovery path.
- No `delay()` is allowed for this indicator. The LED timing must be implemented as a small non-blocking state machine driven by `millis()`.
- The LED must only be written by this result-indicator state after the Wi-Fi result is known. The current `triggerOtaIndicator()` behavior (immediate blue + 1-second timeout while OTA remains active) does not satisfy this requirement and should be replaced for the Wi-Fi result boundary.
- The actual success/failure outcome must remain represented by the OTA diagnostic stage/error and App Notify; the blue sequence is a Wi-Fi-stage completion marker, not a live 'connecting' animation.
- Local OTA LED behavior and engine remain unchanged.
- No code modification was executed in this discussion.
- Chat handoff status: DISCUSSION — LED BEHAVIOR SPECIFICATION LOCKED; READY FOR TARGETED EXECUTION.
## 2026-09-28 — DISCUSSION: OTA LED COLOR MAPPING CONFIRMED

- User confirmed that OTA LED colors must follow the previously agreed project mapping:
  - Wi-Fi connection success -> BLUE blink
  - Wi-Fi connection failure -> RED blink
  - Online/local OTA update success -> GREEN blink, then controlled restart
  - OTA update failure -> RED blink, then BLE recovery without restart
- The Wi-Fi result indicator timing remains the newly specified non-blocking 500 ms ON / 500 ms OFF / 500 ms ON / 500 ms OFF sequence using `millis()`.
- Therefore color is determined by the terminal Wi-Fi result: success uses BLUE; failure uses RED. The 500 ms x2 blink pattern is not a permanent connecting indicator.
- No code modification was executed by this discussion clarification.
- Chat handoff status: DISCUSSION — LED COLOR + TIMING SPECIFICATION LOCKED; READY FOR TARGETED EXECUTION.
## 2026-09-28 — DISCUSSION: FINAL ONLINE OTA LED STAGE COLOR FLOW

- User finalized the Online OTA LED color semantics:
  1. Wi-Fi connection result: SUCCESS = BLUE; FAILED = RED.
  2. GitHub connection / ability to reach GitHub for firmware download: initial stage indication = GREEN; FAILED = RED.
  3. Firmware download completion/result: SUCCESS/COMPLETE = BLUE; FAILED = RED.
  4. New firmware flash/install result: SUCCESS = BLUE, then controlled restart; FAILED = RED.
- The LED is a stage-result indicator, not a continuous 'work in progress' animation. The code/mechanism should complete the underlying operation first, then execute the corresponding LED indication without using delay().
- Existing agreed non-blocking timing remains: 500 ms ON / 500 ms OFF / 500 ms ON / 500 ms OFF, driven by millis(), for result indicators unless a later explicit instruction changes the timing.
- This color mapping supersedes the earlier generic 'download = blue blink / success = green' interpretation for Online OTA. For the Online OTA flow, GREEN is specifically reserved for the initial successful GitHub connection/download-access indication; BLUE is used for successful Wi-Fi connection, completed download, and successful flash before restart. RED is used for every failed stage.
- Local OTA behavior is unchanged by this clarification.
- No code modification was executed in this discussion.
- Chat handoff status: DISCUSSION — ONLINE OTA LED COLOR/STAGE SPECIFICATION LOCKED; READY FOR TARGETED LED EXECUTION.
## 2026-09-28 — DISCUSSION: ONLINE OTA FLASH SUCCESS COLOR CHANGED TO GREEN

- User changed the final Online OTA flash/install success indicator color from BLUE to GREEN.
- Final Online OTA LED mapping is now:
  - Wi-Fi connected successfully -> BLUE
  - Wi-Fi connection failed -> RED
  - GitHub connection / ready to download -> GREEN
  - GitHub connection/download access failed -> RED
  - Firmware download completed successfully -> BLUE
  - Firmware download failed -> RED
  - Firmware flash/install succeeded -> GREEN, then controlled restart
  - Firmware flash/install failed -> RED
- The final flash-success GREEN indicator occurs before the controlled restart and uses the same non-blocking result-indicator timing already specified: 500 ms ON / 500 ms OFF / 500 ms ON / 500 ms OFF, driven by millis().
- No code modification was executed by this clarification.
- Chat handoff status: DISCUSSION — FINAL ONLINE OTA LED COLOR MAPPING UPDATED; READY FOR TARGETED EXECUTION.

## 2026-09-28 — DISCUSSION: ONLINE OTA REPAIR PLAN + FINAL LED FLOW

- User confirmed the requested Online OTA LED behavior and asked to repair the Online OTA path.
- This is discussion/preparation only; no executable firmware source or build was changed in this step.
- Final Online OTA indicator mapping:
  - Wi-Fi connected successfully -> BLUE.
  - Wi-Fi connection failed -> RED.
  - GitHub connection / download availability confirmed -> GREEN, as the initial download-stage indication.
  - GitHub/download connection failed -> RED.
  - Firmware download/stream completed -> BLUE.
  - Firmware download/stream failed -> RED.
  - Firmware flash/install completed successfully -> GREEN, then controlled restart.
  - Firmware flash/install failed -> RED.
- Every result indicator uses the locked non-blocking sequence 500 ms ON / 500 ms OFF / 500 ms ON / 500 ms OFF, driven by millis(). No delay().
- Required behavioral correction: LEDs must not continuously animate during Wi-Fi connection or firmware transfer. They are off while the mechanism is running and only execute the requested result indication when that stage has a known success/failure result.
- Current authoritative source inspection found the existing V1.2 source still has two LED-flow defects:
  1. onlineHttpUpdateProgress() calls renderBlink(0x0000FF), causing a continuous blue animation during the HTTP update instead of a result-only indicator.
  2. triggerOtaIndicator() is currently only a 1-second immediate effect and does not gate the state machine between completed OTA stages.
- Current Online OTA transport remains the official Arduino HTTPUpdate.update() path; it should remain the transport baseline rather than reverting to the older custom Range/chunk implementation.
- Current physical evidence already recorded for V1.2: Wi-Fi success is apparently reached (BLUE was observed), then the LED goes off and BLE returns while the App remains at ONLINE_WIFI_CONNECT 0%. This makes the next repair/diagnostic boundary the post-Wi-Fi stage transition (time synchronization / HTTPS update entry) and the correctness of the LED/result-state reporting; no single root cause is declared yet.
- Repair design for the next explicit Eksekusi Full:
  - introduce a dedicated non-blocking OTA result-indicator state/phase;
  - let each stage finish before starting its result LED;
  - keep the next stage from starting until the 500/500 x2 indicator has completed;
  - remove progress-time blue blinking;
  - make GitHub-ready/download-start, download completion, and flash completion explicit diagnostics;
  - preserve Arduino-ESP32 Core 3.3.7 standard HTTPUpdate/Update lifecycle and existing safety output shutdown;
  - preserve BLE-off-before-Wi-Fi behavior on the ESP32-C3 single-radio constraint;
  - preserve exact OTA error stage reporting so the App can identify where the failure occurred after BLE recovery.
- Important repository consistency finding: the living notes contain newer V1.3 handoff text, but the actual current firmware/JEXFYZ.ino fetched from the default branch is V1.2 (72eea61ec02d1ab1956b2d64e784040c2fa57a37). The actual source/repository state must be reconciled with the notes before the next firmware execution; do not invent a V1.3 source from notes alone.
- Next boundary: Eksekusi Full to implement the Online OTA repair against the actual current source, then build/validate and physically retest the exact stage markers.

## 2026-09-28 — EXECUTION FULL: V1.3 ONLINE OTA REPAIR

- User explicitly authorized `Eksekusi Code dan Firmware Full`.
- User clarified the public/current upload state before this execution: firmware distribution remained **V1.2**; V1.3 had not yet been uploaded as a BIN. The source was therefore advanced to V1.3 only after the Online OTA repair, exactly as requested.
- Authoritative source changed: `firmware/JEXFYZ.ino` from V1.2 to **V1.3**.
- Firmware source implementation commit: `6d067febcc0318b64c86706876a43670bfe9f38c`.
- Follow-up source cleanup removed one duplicate OTA prototype; final source cleanup commit: `7cb2caae177c79bc6774b48362cf36b3bfc8865a`.
- Final source blob after cleanup: `709dc27d2ef1c54289100516b15d98c66146b1c0`.

### Online OTA implementation now used by V1.3
- Replaced the failing/simplified HTTPUpdate execution layer with the official Arduino-ESP32 `HTTPClient` + `Update` lifecycle so the stage boundaries can be controlled explicitly without firmware-sized RAM buffering.
- Online firmware is streamed directly into the inactive OTA partition with `Update.writeStream()`.
- No Range/chunk/retry transport remains in the Online OTA path.
- GitHub connection stage performs a real HTTPS GET/header/body-stream readiness check before the GREEN indication.
- Firmware transfer is not started until the GREEN GitHub-success result indication finishes.
- After the full stream reaches the inactive OTA partition, the required BLUE download-complete indication runs before `Update.end()` finalization.
- Final GREEN flash-success indication runs only after `Update.end()` succeeds; only after that indicator completes is the controlled restart scheduled.
- Any Online OTA failure uses the RED result indication and only then returns control to BLE recovery.

### Locked Online OTA LED mapping
- Wi-Fi success -> BLUE.
- Wi-Fi failure -> RED.
- GitHub connection/download-ready success -> GREEN.
- GitHub connection/download-ready failure -> RED.
- Firmware download/stream complete -> BLUE.
- Firmware download failure -> RED.
- Firmware flash/install success -> GREEN, then restart.
- Firmware flash/install failure -> RED.
- Result timing: 500 ms ON / 500 ms OFF / 500 ms ON / 500 ms OFF, non-blocking via millis().
- No result-color animation runs continuously during Wi-Fi connection, GitHub connection, download, or flash finalization.

### Diagnostics
- New/explicit stages include `ONLINE_WIFI_CONNECTED`, `ONLINE_GITHUB_CONNECT`, `ONLINE_GITHUB_CONNECTED`, `ONLINE_DOWNLOAD`, `ONLINE_DOWNLOAD_COMPLETE`, `ONLINE_FLASH_PREPARE`, `ONLINE_FLASH_FINALIZE`, and `ONLINE_FLASH_SUCCESS`.
- App stage translation was updated in `lib/main.dart` so these exact firmware stage names have human-readable Home NOTIFY labels.
- App source commit: `7c7f7a53ad30435378c90145d8dd13b44deb60dc`.
- No App Build was triggered automatically; the project still uses the separate `Build App` action boundary for APK CI.

### OTA safety lock
- `firmware/OTA_GOLD_MASTER_LOCK.json` was refreshed to V1.3 and regenerated from the exact current protected firmware segments.
- Lock refresh commit: `7f76e81f7877aa5ae24a54338cd89b83cb73a724`.
- Static lock verification: PASS — all protected segment contents match the current source exactly; no required critical marker is missing and no forbidden transport/API text is present.
- Lock status remains `CANDIDATE_NOT_PHYSICALLY_VERIFIED` because V1.3 has not yet been physically flashed/tested.

### Static validation
- Firmware source version: V1.3.
- Balanced braces: 445 / 445.
- Online OTA engine contains no `delay()` call.
- No `HTTPUpdate` or stale Online OTA indicator symbols remain.
- No Range/chunk/resume identifiers remain in the Online OTA engine.
- Official Arduino `HTTPClient` + `Update.begin` + `Update.writeStream` + `Update.end` lifecycle markers are present.
- Required Online OTA stage markers are present.
- App stage mappings are present.
- No local firmware binary was published in this execution. Public firmware distribution remains V1.2 until the user supplies the V1.3 BIN produced by ArduinoDroid.

### ArduinoDroid handoff
- The exact V1.3 source is delivered to the chat as `JEXFYZ-V1.3.ino` for manual compilation/flash.
- Pinned ArduinoDroid target remains ESP32C3 Dev Module / Arduino-ESP32 Core 3.3.7 with the project-locked settings from the living notes.
- Build/compile evidence is not claimed here because `arduino-cli` is unavailable in the working container and no current firmware-build workflow exists in the authoritative repository.
- Next boundary: manually compile/flash V1.3 in ArduinoDroid, then perform the controlled Online OTA test and preserve the complete Serial/App diagnostic evidence.

## 2026-09-28 — EXECUTION HANDOFF: V1.3 INO DELIVERED

- Exact V1.3 source artifact was exported from the authoritative GitHub source and delivered to the chat as `JEXFYZ-V1.3.ino`.
- Exactness verification: local Git blob hash is `709dc27d2ef1c54289100516b15d98c66146b1c0`, matching the authoritative `firmware/JEXFYZ.ino` blob SHA `709dc27d2ef1c54289100516b15d98c66146b1c0`.
- Local artifact size: 104,433 bytes; line count: 3,702.
- A temporary GitHub Actions export helper was used only to obtain the exact source artifact, then removed from the repository. Both `.github/workflows/export-v13-source.yml` and `.github/FIRMWARE_SOURCE_EXPORT_TRIGGER` are confirmed absent after cleanup.
- No V1.3 BIN was generated or published. The public firmware distribution remains V1.2, pending the user's ArduinoDroid compilation/flash validation of V1.3.
- Physical validation remains pending; OTA lock status remains `CANDIDATE_NOT_PHYSICALLY_VERIFIED`.
- Next boundary: compile/flash the delivered V1.3 `.ino` in the pinned ArduinoDroid environment, then test Online OTA with exact LED/stage diagnostics and preserve the complete evidence.

## 2026-09-28 — DELIVERY FIX: V1.3 INO DOWNLOAD FILE

- User reported a download/file-not-found error when attempting to obtain `JEXFYZ-V1.3.ino`.
- Root cause of the chat delivery issue: the prior final link referenced `/mnt/data/JEXFYZ-V1.3.ino` before a real file existed at that exact runtime path.
- The exact V1.3 source artifact was re-materialized from the verified GitHub Actions source-export artifact, extracted, and written to `/mnt/data/JEXFYZ-V1.3.ino`.
- Delivery file verification: SHA-256 `94650f80091faf45ddd7c1185b12f57f997cb24c4c13bc185ab16b2c5e8b3824`; 3,702 lines; imports match the authoritative source; firmware version remains V1.3.
- No firmware source code was changed by this delivery fix. Public firmware distribution remains V1.2 and no V1.3 BIN was published.


## 2026-09-28 — EXECUTION FULL: V1.4 ONLINE OTA LED START BEHAVIOR

- User clarified the required Online OTA LED sequence: when the App's Update command is pressed, the LED must be OFF while Wi-Fi is connecting. No blue static indication is allowed during the Wi-Fi connection attempt.
- Only after the Wi-Fi connection result is known may the result indicator run: BLUE blink for successful Wi-Fi connection or RED blink for failed Wi-Fi connection.
- The existing boot-time Local OTA AP behavior is intentionally unchanged: boot can show BLUE static while the Wi-Fi AP owns the radio, then the LED turns off when BLE takes over.
- V1.4 firmware source changes:
  - Firmware version advanced from V1.3 to V1.4.
  - Online OTA start now explicitly clears the user LED output immediately after applying safe outputs, before STA Wi-Fi connection begins.
  - Online OTA result-indicator startup no longer writes the result color immediately; it starts from LED OFF and lets the non-blocking 500/500 x2 indicator state render on the next processing cycle. This prevents a false static-color flash at the stage boundary.
  - The established 500 ms ON / 500 ms OFF / 500 ms ON / 500 ms OFF result timing remains unchanged.
- No Online OTA transport/lifecycle change was made in this execution. The existing V1.3 post-Wi-Fi diagnostic boundary remains available for the next controlled OTA failure investigation.
- V1.4 source commit: 7fee78ad24712f0e5d620a4b53054cccdb662137.
- OTA Gold Master Lock metadata refreshed to V1.4: 666188600d7fd349c131fd88cb27a52766b620a0.
- Public firmware distribution remains V1.3. No V1.4 BIN was generated or published in this execution; V1.4 is the source revision for the next ArduinoDroid manual compile/test.
- Physical validation remains pending. Do not claim Online OTA success until the V1.4 source has been compiled/flashed and the controlled Wi-Fi-result LED + OTA test passes physically.

## 2026-09-28 — EXECUTION FULL: V1.5 OTA + RUNTIME HARDENING CANDIDATE

- Firmware source advanced from V1.4 to V1.5.
- Online OTA transport was hardened by replacing blocking `Update.writeStream()` with a fixed 1024-byte read buffer and repeated `stream->read(...)` + `Update.write(...)` operations.
- Online OTA download now checks stream availability, uses a 10-second idle-data timeout, yields between iterations, validates each flash write, and preserves the existing HTTPS/content-length/magic-byte/`Update.begin()`/`Update.end()` lifecycle.
- No firmware-sized RAM buffer and no resumable HTTP Range transport were introduced.
- Online OTA LED behavior remains locked: Update trigger -> LED OFF during Wi-Fi connection; Wi-Fi success -> BLUE blink; Wi-Fi failure -> RED blink. Boot-time Local OTA AP behavior remains BLUE STATIC until AP ownership ends, then BLE handoff turns user LED output off.
- BLE RX hardening: RX command buffer is 512 bytes; queued RX payloads use fixed-size character storage instead of a queue of heap-owning `String` objects; queue operations are serialized with a standard C++ atomic flag. No `portMUX`, FreeRTOS critical-section API, or ESP-IDF OTA API was introduced.
- LED mode parser now accepts the complete firmware mode range 1..8, matching the existing App LED mode contract where mode 8 is Twinkle.
- Peltier PWM output now tracks `lastPeltierDuty` so unchanged duty values are not written repeatedly.
- Adaptive battery zoning now uses a 0.8 C hysteresis helper to reduce boundary chattering; manual voltage control behavior is unchanged.
- NTC validation was hardened with an upper fault threshold of 3290 mV, input sanitization/clamp at 3.28 V before resistance calculation, and finite/positive validation of resistance and calculated temperature.
- Boot Wi-Fi AP now has a 60-second hard limit in addition to the normal 10-second no-client timeout. The hard limit yields to an active local OTA transaction so an actual upload is not interrupted.
- Hardware initialization was consolidated into `initializeRuntimeFeatures()`; setup no longer duplicates the hardware initialization sequence. GPIO authority remains GPIO5 = PELTIER and GPIO6 = FAN.
- Gemini V1.4's callback-allocation finding was audited but intentionally not forced into this revision. The current Arduino-ESP32 BLE ownership/destruction path was not sufficiently established from the available Core 3.3.7 evidence to justify replacing the existing callback allocation pattern blindly.
- App source/protocol was not changed in this execution because the App already defines LED modes 1..8 and does not require a new protocol for these firmware hardening changes.
- Source commits in this execution: `d7f438a37e74c33b07b3e00295412bf1ce842731`, `210571960117f459d22f632f16fab76228b10ca6`, `13361994b0d69facf61ea88895e378edf6f71fd4`.
- OTA Gold Master Lock was refreshed for V1.5: `f2ad197ee2c8149ad52cc7edb8c0b4f3107bdc3`.
- Final authoritative firmware source blob SHA: `040f38fb8113ddc7a0900a618bb58cc6452a1907`.
- Static source audit: PASS for V1.5 version marker, GPIO mapping, absence of `Update.writeStream()`, chunked stream writes, 512-byte RX buffer, atomic RX queue serialization, absence of forbidden `portMUX`/FreeRTOS critical APIs, Twinkle range 1..8, Peltier duty tracking, battery hysteresis, NTC sanitization, Boot AP hard limit, protected OTA markers/order, balanced braces, and Online OTA diagnostic/result markers.
- Callback audit remains OPEN: the source still contains one `new ServerCallbacks()` construction. This is intentionally documented as an unresolved review item rather than falsely claiming it has been fixed.
- No firmware BIN was generated or published in this execution. Public firmware distribution remains V1.3 until a V1.5 BIN is compiled from this source in the locked ArduinoDroid environment and physically validated.
- Build/compile proof is not claimed: the working environment does not provide a verified ArduinoDroid/Core 3.3.7 compiler toolchain.
- Physical validation remains required. V1.5 status is CANDIDATE_NOT_PHYSICALLY_VERIFIED.
- Next handoff: compile/flash V1.5 manually in ArduinoDroid, perform controlled Online OTA + LED + BLE + safety tests, and provide the exact V1.5 artifact to Gemini for the independent second audit.



## 2026-09-28 — DISCUSSION: V1.5 GEMINI FOLLOW-UP #2

- User requested that living project notes must be updated continuously, including discussion-only turns.
- Current discussion source of truth: authoritative `firmware/JEXFYZ.ino` V1.5, final source blob previously verified as `040f38fb8113ddc7a0900a618bb58cc6452a1907` (verify against the repository again before any future mutation).
- Gemini V1.5 follow-up #2 independently re-confirmed ISSUE #001 as **CONFIRMED**: the `std::atomic_flag` spin-lock around the BLE RX queue can deadlock/starve on ESP32-C3 single-core when a higher-priority BLE callback preempts the lower-priority Arduino `loop()` while holding the lock.
- Gemini's proposed direction for ISSUE #001 is an SPSC ring buffer: producer owns/writes `tail`, consumer owns/writes `head`, no spin-lock, and no `bleRxCount`. Gemini specifically proposed checking the full condition before writing and publishing the new tail only after the payload copy is complete.
- Important integration caution: the SPSC direction is accepted, but the exact memory-visibility/ordering design for ESP32-C3 + Arduino-ESP32 Core 3.3.7 is **not yet finalized**. Do not blindly replace the queue with plain non-atomic indices until this point is independently verified.
- Gemini V1.5 follow-up #2 re-confirmed ISSUE #002 as **CONFIRMED LEAK** for `new ServerCallbacks()` and `new RxCallbacks()`; Gemini recommends static callback instances and passing their addresses to `setCallbacks()`.
- Gemini classified the existing `new BLE2902()` descriptor allocation as **INVALID as a leak** and explicitly recommends leaving that allocation pattern unchanged.
- Gemini's 60-second Boot AP hard limit remains a **possible UX concern**, not a confirmed defect; no patch is planned from that finding alone.
- Current intended patch scope for the next firmware revision is deliberately narrow: ISSUE #001 BLE RX synchronization and ISSUE #002 callback object lifetime only. Do not mix OTA transport, LED mapping, safety, GPIO, NTC, Adaptive, or other feature changes into the same patch.
- No firmware source was modified by this discussion. No build was executed. No V1.6 source is approved yet.
- Before execution, Gemini will be asked one more targeted verification: whether `size_t` head/tail are safe as plain variables versus `std::atomic<size_t>`, what memory ordering is required, and how `clearBleRxQueue()` can safely reset state across connect/disconnect without racing the BLE producer.
- Chat handoff status: **DISCUSSION — WAITING FOR FINAL SPSC MEMORY-ORDERING VERIFICATION BEFORE PATCH.**


## 2026-09-28 — DISCUSSION: V1.5 GEMINI FOLLOW-UP #3 — FINAL SPSC MEMORY-ORDERING REVIEW

- Gemini follow-up #3 classifies plain/volatile `size_t` RX queue indices as **INVALID** for the proposed cross-task queue and `std::atomic<size_t>` head/tail as **CONFIRMED**. Gemini's stated reason is memory-ordering/visibility between the BLE callback producer and Arduino loop consumer.
- Gemini proposes lock-free SPSC indices with C++11 acquire/release semantics and no `portMUX`, mutex, semaphore, or FreeRTOS critical-section API.
- Gemini's architectural definition: `bleRxCount` and `bleRxQueueLock` are removed; `bleRxHead` and `bleRxTail` become `std::atomic<size_t>`.
- Gemini's producer publishes the new tail with `memory_order_release` only after the payload has been copied into the queue slot; consumer observes tail with `memory_order_acquire` before reading the slot.
- Gemini's reset model is consumer-owned: `clearBleRxQueue()` must not write tail; it loads the latest tail and stores that value into head, thereby discarding queued commands without mutating producer state.
- Important integration review: Gemini's explanatory text says producer-side head load may use `memory_order_relaxed`, but a stricter C++ happens-before design for slot reuse may require an acquire load of the consumer-published head before producer overwrites a previously consumed slot. This specific point is NOT yet accepted as final without one more targeted verification. Do not patch based on the ambiguous wording alone.
- The current source's connect/disconnect behavior includes `bleQueueResetPending` handled from `loop()`; any final implementation must preserve session-reset semantics while preventing producer/consumer corruption.
- Issue #002 remains unchanged: static `ServerCallbacks` and `RxCallbacks` are the intended minimal callback-lifetime fix; `BLE2902` remains unchanged.
- No firmware source was modified and no build was executed in this discussion.
- Chat handoff status: **DISCUSSION — SPSC CORE DESIGN ACCEPTED, ONE MEMORY-ORDERING DETAIL STILL REQUIRES FINAL VERIFICATION BEFORE EXECUTION.**


## 2026-09-28 — DISCUSSION: GEMINI RESPONSE FORMAT / SOURCE PRESENTATION

- User clarified that Gemini's audit response is originally presented as a rich formatted message (Markdown-style headings, nested bullets, code blocks, and emphasis) and was copied/exported into a plain-text .txt file only for transfer into this chat.
- The uploaded screenshots preserve the original visual formatting. The .txt representation should therefore be treated as the same audit content in plain-text form, while screenshots may be used to confirm structure/formatting when needed.
- No technical conclusion from the Gemini audit is changed by this formatting clarification.
- No firmware source was modified and no build was executed in this discussion.
- Chat handoff status: **DISCUSSION — GEMINI AUDIT CONTENT ACCEPTED; FORMATTING CLARIFICATION RECORDED.**


## 2026-09-28 — DISCUSSION: GEMINI ↔ CHATGPT TRANSFER WORKFLOW

- User defined the permanent cross-AI handoff format for JE X FYZ:
  - **ChatGPT → Gemini:** user copies ChatGPT's prompt/message directly into Gemini without conversion.
  - **Gemini → ChatGPT:** user copies Gemini's response and converts/pastes it into a plain-text `.txt` file before uploading it here.
- Therefore every future prompt sent from ChatGPT to Gemini must be written so that it remains unambiguous after direct copy/paste, and every prompt should explicitly tell Gemini that its response will return to ChatGPT as a `.txt` representation of the original formatted response.
- When requesting an audit from Gemini, ChatGPT must include enough context, exact scope, and a clear output structure so Markdown/code formatting lost during TXT conversion does not change the technical meaning.
- Screenshots of Gemini remain useful as presentation-format evidence; TXT remains the primary machine-readable transfer of Gemini's response content unless a discrepancy requires visual confirmation.
- No firmware source was modified and no build was executed in this discussion.
- Chat handoff status: **DISCUSSION — CROSS-AI HANDOFF FORMAT LOCKED; READY FOR THE NEXT GEMINI VERIFICATION PROMPT.**


## 2026-09-28 — DISCUSSION: SAME-VERSION GEMINI SOURCE HANDOFF RULE

- User confirmed the intended cross-AI workflow: when the authoritative firmware source and notes remain at the same revision/version (for example V1.5) and the Gemini review continues in the same Gemini conversation/context, the user does **not** need to resend the V1.5 `.ino` and `.md` on every follow-up question.
- ChatGPT should instead send a focused follow-up prompt that references the already supplied V1.5 source/context and asks only for the next verification point.
- Resend the `.ino` and relevant `.md` when the firmware revision/version changes, the source is materially updated, Gemini starts a new/independent context that no longer has the files, or a file-specific verification requires an exact refreshed artifact.
- Gemini → ChatGPT transfer remains: Gemini response is copied into a `.txt` file; ChatGPT should treat the TXT as the transferred response content and use screenshots only when formatting/structure needs confirmation.
- No firmware source was modified and no build was executed in this discussion.
- Chat handoff status: **DISCUSSION — SAME-VERSION FILE RESEND RULE LOCKED.**


## 2026-09-28 — DISCUSSION: GEMINI V1.5 #4 — FINAL SPSC MEMORY ORDERING

- Gemini V1.5 #4 returns **CONFIRMED** and gives a final SPSC memory-ordering recommendation: `bleRxHead.load = ACQUIRE`, `bleRxTail.load = ACQUIRE`, `bleRxTail.store = RELEASE`, `bleRxHead.store = RELEASE`; self-owned index loads may use RELAXED.
- Slot-reuse reasoning accepted as the target design: consumer reads a slot, then publishes `head` with RELEASE; producer observes `head` with ACQUIRE before reusing/overwriting that slot.
- Producer publishes `tail` with RELEASE only after payload copy is complete; consumer reads `tail` with ACQUIRE before reading the published payload.
- Gemini's final minimal queue removes `bleRxCount` and `bleRxQueueLock`, uses `std::atomic<size_t>` head/tail, producer writes only tail, consumer writes only head, and keeps `bleRxQueue` as the fixed char 2D array.
- Reset design remains consumer-owned: load tail with ACQUIRE, then store that value to head with RELEASE; consumer never writes tail. The intended semantics are to discard queued/stale commands without directly resetting producer state.
- Integration caution retained: Gemini states `std::atomic<size_t>` is 100% lock-free on ESP32-C3. This should be treated as a strong implementation claim but not as a separately verified build/runtime fact until the actual Core 3.3.7 toolchain/compiler property is checked. No code is being changed merely from that assertion.
- Integration caution retained for reset semantics: the safety argument relies on the producer callback not being concurrently executed by the Arduino loop on the same single-core CPU. Even where the reset is safe from slot corruption, commands arriving around the reset boundary may be intentionally discarded or retained depending on the exact interleaving; the implementation must preserve the project goal of clearing stale session commands without corrupting the ring buffer.
- No firmware source was modified and no build was executed in this discussion.
- Chat handoff status: **DISCUSSION — SPSC MEMORY ORDERING DESIGN IS ACCEPTED AS THE PATCH BASELINE; READY FOR FINAL CROSS-CHECK BEFORE EXECUTION.**


## 2026-09-28 — DISCUSSION: V1.5 CROSS-CHECK AGAINST ARDUINO-ESP32 CORE 3.3.7

- Cross-check performed against the authoritative V1.5 source and the official Arduino-ESP32 Core 3.3.7 BLE/Arduino runtime sources before any patch decision.
- Official Core 3.3.7 `BLEServer::setCallbacks()` only assigns the callback pointer (`m_pServerCallbacks = pCallbacks`); the source contains no `delete m_pServerCallbacks` path found in `BLEServer.cpp`. Official Core 3.3.7 `BLECharacteristic::setCallbacks()` likewise assigns `m_pCallbacks` and the characteristic destructor does not delete the callback. This strengthens Gemini's ISSUE #002 conclusion that the two callback objects should not be repeatedly allocated with `new`.
- Official Core 3.3.7 Arduino `loopTask()` is created with priority `1` and calls `loop()` in its task body. This supports the project-specific producer/consumer task distinction used in the SPSC analysis; the ESP32-C3 target remains single-core for this discussion.
- The current V1.5 source still uses `new ServerCallbacks()` and `new RxCallbacks()` inside `startBle()`. A minimal lifetime fix should avoid moving large sections of the file unnecessarily; a function-local/static accessor can be considered so callback class definitions do not need a broad relocation. No implementation has been executed yet.
- SPSC design remains the accepted patch baseline: atomic head/tail, producer-owned tail, consumer-owned head, acquire/release publication, no spin-lock, no `bleRxCount`.
- New integration nuance identified during cross-check: `bleQueueResetPending` is set on both `onConnect()` and `onDisconnect()` and is consumed in `loop()` before `processBleRxQueue()`. Therefore a BLE command that arrives between the connection callback and the pending-reset service can be intentionally discarded by the reset. The existing source already has this ordering; the SPSC patch must preserve queue safety without accidentally changing the intended session synchronization semantics. This is not currently classified as a V1.5 SPSC corruption bug, but it must be checked during the patch review.
- No firmware source was modified and no build was executed in this discussion.
- Chat handoff status: **DISCUSSION — CORE 3.3.7 CROSS-CHECK COMPLETE; PATCH DESIGN READY, BUT IMPLEMENTATION MUST PRESERVE CURRENT SESSION-RESET SEMANTICS.**


## 2026-09-28 — EXECUTION FULL: V1.6 BLE RX SPSC + CALLBACK LIFETIME

- User explicitly authorized `Eksekusi Code dan Firmware Full`.
- Authoritative firmware source advanced from V1.5 to **V1.6**.
- Scope was intentionally limited to the two confirmed Gemini findings: BLE RX queue synchronization (ISSUE #001) and BLE callback object lifetime (ISSUE #002). No OTA transport, LED, NTC, Peltier, Fan, GPIO, Adaptive, or protocol redesign was performed.
- ISSUE #001 implementation: removed `std::atomic_flag` spin-lock, `bleRxQueueLock`, `bleRxCount`, `lockBleRxQueue()`, and `unlockBleRxQueue()`; converted `bleRxHead` and `bleRxTail` to `std::atomic<size_t>`; applied SPSC ownership with producer-owned tail, consumer-owned head, acquire/release publication, and consumer-owned reset (`head = tail`) without resetting producer tail.
- Final queue ordering implemented: producer `head.load(acquire)` + `tail.load(relaxed)` + payload copy + `tail.store(release)`; consumer `head.load(relaxed)` + `tail.load(acquire)` + payload read + `head.store(release)`; reset `tail.load(acquire)` + `head.store(release)`.
- ISSUE #002 implementation: replaced heap allocation of `ServerCallbacks` and `RxCallbacks` with static-lifetime instances and passed their addresses to `setCallbacks()`. `BLE2902` remains allocated by `new BLE2902()` as before and was not changed.
- Cross-check against official Arduino-ESP32 Core 3.3.7 source confirmed `BLEServer::setCallbacks()` and `BLECharacteristic::setCallbacks()` assign callback pointers rather than deleting them; the corresponding destructors do not delete these callbacks. This supports the static callback lifetime change.
- Firmware source commit: `aa6ed27e4404e1fa02fc3fb9440ebeda8c90acc3`.
- Final source blob SHA from the repository update: `a9c07df96de82ba58a403dc30f0fd23ef3bd69a7`.
- Final source size after V1.6 patch: 107,529 bytes; 3,797 lines.
- OTA Gold Master Lock refreshed to V1.6: commit `53001e388a2752220a9d77c0ba6469b82fd97638`; lock blob `f799b4e838e1ba40727810b9619cf33137720d79`.
- Static OTA lock audit at execution time: PASS. Protected OTA segments matched exactly; required ordering markers were present; balanced braces were `460/460`; V1.6 version marker present; old BLE spin-lock/count/callback-allocation patterns were absent; protected OTA transport and safety paths were not modified.
- A pinned firmware CI workflow was restored as `.github/workflows/firmware-build.yml` in commit `54f3b5e2e28e3e84501bb5f2eb764fb2f22776cd`. It installs Arduino-ESP32 Core 3.3.7, Adafruit NeoPixel 1.15.5, OneButton 2.6.2, runs the OTA guard, compiles the ESP32-C3 target using the `no_fs` partition table, verifies V1.6 metadata, and uploads the firmware BIN artifact.
- CI/runtime build result is **NOT CLAIMED YET**: the available GitHub connector did not expose a runnable workflow status for the push in this execution, and the local container has no Arduino CLI/toolchain. Therefore no successful compile or BIN generation is being falsely claimed from static analysis alone.
- Public firmware distribution remains unchanged; no V1.6 BIN has been manually supplied by the user and no new public BIN was promoted in this execution.
- Physical validation remains pending. The V1.6 source must be compiled/flashed by the user in the locked ArduinoDroid/Core 3.3.7 environment before runtime success is declared.
- Next handoff: obtain the V1.6 build artifact/compile evidence, then perform the controlled BLE reconnect/command stress test and OTA regression test. Any further code change must start from the exact V1.6 source currently recorded here.


## 2026-09-28 — EXECUTION FULL: V1.6 FIRMWARE BUILD FIX #1

- First GitHub Actions Firmware Build run: `36362526125` (run #80) completed with **FAILURE** at the compile step. The pinned Core install, library install, OTA guard, and board verification all passed before compilation.
- Exact compile failure: Arduino CLI was invoked with `firmware/JEXFYZ.ino`, and Arduino CLI interpreted the `firmware/` directory as the sketch name, then reported `main file missing from sketch: .../firmware/firmware.ino`.
- This was a CI invocation/path error, not yet a C++ compiler error in V1.6 source.
- Build workflow fix: copy the authoritative source to a named sketch directory `build/sketch/JEXFYZ.ino`, compile that directory, and then copy the generated `JEXFYZ*.bin` to `build/JEXFYZ-V1.6.bin` for artifact upload.
- The workflow now also uses the exact board options verified by the official Arduino-ESP32 3.3.7 board details for the user-locked target: ESP32C3 Dev Module, UploadSpeed=921600, CDCOnBoot=cdc, CPUFreq=160, FlashFreq=80, FlashMode=dio, FlashSize=4M, PartitionScheme=no_fs, DebugLevel=none, EraseFlash=none, JTAGAdapter=default, ZigbeeMode=default.
- Workflow fix commit: `00b7bbc23d0edaf30b0415d582704642e1950983`.
- No firmware source change was made for this build failure. V1.6 source remains `aa6ed27e4404e1fa02fc3fb9440ebeda8c90acc3`.
- Next boundary: allow the corrected workflow to run again; classify the next result as compile error, link/size error, or successful binary generation. Do not patch V1.6 source unless the compiler reports an actual source/toolchain defect.


## 2026-09-28 — DISCUSSION: FIRMWARE BUILD OWNERSHIP / ARDUINODROID

- User clarified the standing project rule: **firmware is compiled by the user in ArduinoDroid**, using the locked production environment. ChatGPT must not treat a GitHub Actions firmware build as the production build path and must not claim firmware compilation success on the user's behalf.
- ChatGPT's temporary `.github/workflows/firmware-build.yml` addition during the V1.6 execution was unnecessary for the project's intended workflow. Its failed run is not a firmware-build result for the user's ArduinoDroid environment and must not be used as evidence about V1.6 runtime/build validity.
- The authoritative V1.6 `.ino` source remains the firmware artifact to be compiled by the user. Any future firmware build validation in project reporting must be based on the user's ArduinoDroid compile output or a specifically requested independent CI check, not assumed automatically.
- Repository cleanup item: remove the temporary firmware GitHub Actions workflow and remove/adjust any note text that treats that workflow as the normal firmware build path. This cleanup should occur before the next clean firmware handoff.
- No additional firmware source changes were made in this discussion after the V1.6 patch.
- Chat handoff status: **DISCUSSION — USER OWNS FIRMWARE COMPILE/FLASH VIA ARDUINODROID; REPO CLEANUP OF TEMPORARY CI IS THE NEXT ACTION.**


## 2026-09-28 — HANDOFF: V1.6 TO NEW SUBCHAT

- Current conversation reached the maximum length; project work must continue in a new subchat.
- New-subchat opening prompt must instruct ChatGPT to read the authoritative repository source and notes first, not start from zero, and preserve the current V1.6 state.
- Exact current authoritative firmware source: `firmware/JEXFYZ.ino`, repository content SHA `a9c07df96de82ba58a403dc30f0fd23ef3bd69a7`, version V1.6, source commit `aa6ed27e4404e1fa02fc3fb9440ebeda8c90acc3`.
- Exact current OTA lock: `firmware/OTA_GOLD_MASTER_LOCK.json`, content SHA `f799b4e838e1ba40727810b9619cf33137720d79`, refreshed for V1.6 in commit `53001e388a2752220a9d77c0ba6469b82fd97638`.
- Current standing build rule: user compiles/flashes firmware manually in ArduinoDroid using the locked ESP32-C3/Core 3.3.7 environment. GitHub Actions is not the production firmware build path.
- Temporary firmware CI workflow currently exists at `.github/workflows/firmware-build.yml`; it was added during V1.6 execution and has already exposed a path/invocation failure. It is cleanup-only and must not be treated as production build validation. The corrected workflow must be removed from the repository in the new subchat before clean handoff, unless the user explicitly requests an independent CI build.
- No V1.6 firmware source change is planned after the BLE hardening patch; next repository operation is cleanup of the temporary firmware CI workflow and cleanup of related notes, then deliver the exact full V1.6 `.ino` to the user for ArduinoDroid compilation.
- New subchat should use the established ChatGPT↔Gemini workflow: ChatGPT→Gemini prompt copied directly; Gemini→ChatGPT response returned as user-converted TXT. Same-version V1.6 `.ino`/`.md` need not be resent to Gemini on every follow-up unless source/version/context changes.

## 2026-09-28 — REPOSITORY CLEANUP: REMOVE TEMPORARY FIRMWARE CI

- Removed the temporary GitHub Actions firmware workflow `.github/workflows/firmware-build.yml` from the production App repository.
- The workflow was diagnostic/temporary only and is not part of the JE X FYZ production firmware build process.
- Production firmware source remains exclusively `firmware/JEXFYZ.ino` at V1.6; its repository source content was not modified by this cleanup.
- Production firmware compilation/build ownership is locked to the user: compile and flash the firmware manually in ArduinoDroid using the pinned ESP32-C3 Dev Module / Arduino-ESP32 Core 3.3.7 production profile.
- GitHub Actions must not be treated as evidence of ArduinoDroid compilation success and must not be used as the production firmware BIN source unless the user explicitly requests an independent CI test.
- No firmware BIN is generated by this repository cleanup. The App repository stores the authoritative `.ino` source; the user-generated ArduinoDroid `.bin` is the physical production artifact and is handled separately from this source cleanup.
- Historical CI/build notes are retained as project history; they are not current production validation.
- Cleanup commit: `191374c57bcba99f3d4486924f8c3f6baa51bb08`.
- Current handoff after cleanup: V1.6 source unchanged, OTA Gold Master remains protected, physical validation pending, ArduinoDroid compile pending user.

## 2026-09-28 — HANDOFF: JEXFYZ-V1.6 FOR ARDUINODROID BUILD

- Delivered the exact authoritative V1.6 firmware source from firmware/JEXFYZ.ino for the user's manual ArduinoDroid compile/flash step.
- Working/output naming convention is now fixed as JEXFYZ-V1.6, using the current firmware version only; no descriptive suffix is added.
- The repository authoritative source path remains unchanged: firmware/JEXFYZ.ino.
- Source content SHA remains a9c07df96de82ba58a403dc30f0fd23ef3bd69a7; no firmware source changes were made during this handoff.
- The .bin is intentionally not generated by this environment. User production workflow: compile the exact source in ArduinoDroid with the locked ESP32-C3 / Arduino-ESP32 Core 3.3.7 profile, then flash and report the actual compile/runtime result.
- Do not claim V1.6 compile success, physical validation, or production BIN status until user evidence is supplied.
- OTA Gold Master remains protected and exact-match.

## 2026-09-28 — EXECUTION: VERSIONED FIRMWARE SOURCE PATH

- Authoritative V1.6 source was renamed from `firmware/JEXFYZ.ino` to **`firmware/JEXFYZ-V1.6.ino`**.
- The firmware source content itself is unchanged; the source blob SHA remains `a9c07df96de82ba58a403dc30f0fd23ef3bd69a7`.
- `firmware/OTA_GOLD_MASTER_LOCK.json` and `.github/scripts/ota_guard.py` were updated only to point at the versioned V1.6 source path.
- The production source naming convention is now **`JEXFYZ-V<version>.ino`**, with no descriptive suffix. Current file: **`JEXFYZ-V1.6.ino`**.
- Historical notes may retain the former `firmware/JEXFYZ.ino` path when describing older repository states; those references are historical and are not the current authoritative path.
- Firmware production compilation remains user-owned through ArduinoDroid / Arduino-ESP32 Core 3.3.7. No firmware BIN is generated by this repository rename.

## 2026-09-28 — FIX: ARDUINODROID V1.6 min() TYPE MISMATCH

- User's ArduinoDroid compile reported `no matching function for call to 'min'` at the BLE RX enqueue path.
- Confirmed root cause: `payload.length()` and `BLE_RX_BUFFER_SIZE - 1` resolve to different integer types for the templated Arduino/C++ `min()` call.
- Applied a minimal source-only compatibility fix in `firmware/JEXFYZ-V1.6.ino`: replaced that one `min()` expression with an explicit size_t comparison/selection.
- BLE RX SPSC design, callback lifetime, OTA protected blocks, GPIO assignments, and all other firmware logic were left unchanged.
- Source remains V1.6. Production compile remains user-owned in ArduinoDroid/Core 3.3.7; no compile success is claimed here.
- New source size: 107,643 bytes.
- Previous source blob SHA: `a9c07df96de82ba58a403dc30f0fd23ef3bd69a7`.
- This patch is the ArduinoDroid compile-fix revision of V1.6; the version marker remains `V1.6`.

## 2026-09-28 — V1.6 BIN PROMOTED FROM USER ARDUINODROID ARTIFACT

- User supplied the compiled V1.6 firmware binary in the public firmware repository as the temporary path `JEXFYZ.cpp.bin` and requested promotion by rename.
- The exact existing binary blob SHA was preserved: `817497eff65ede9a9ce27bd7bbd466484ac5752c`.
- The binary is now published as **`JEXFYZ-V1.6.bin`** in `TenzoNkz/JEXFYZ-Firmware`; public file size is 1,454,064 bytes.
- The previous public `JEXFYZ-V1.3.bin` artifact and temporary `JEXFYZ.cpp.bin` path were removed in the same Git tree update.
- `manifest.json` now declares version `V1.6` and points to the new `JEXFYZ-V1.6.bin` URL.
- Firmware promotion commit: `b5721df0b22b9f481122a5a17a037ec09275d117`.
- The production binary is the user's ArduinoDroid-generated artifact. Compilation was not reproduced independently in this environment; source/production validation remains based on the user's ArduinoDroid result and subsequent physical testing.
- Current release state: V1.6 source and V1.6 public BIN are aligned by version/path; physical runtime validation remains pending unless separately evidenced by the user.

## 2026-09-28 — PHYSICAL TEST: V1.6 / V6.6 OTA VERSION CHAIN + LED ISSUE

- User created a second test firmware from the same V1.6 firmware content, changing only the embedded firmware version to **V6.6**. `V6.6` is a test-only version and must not be treated as the production/public release.
- Confirmed user OTA test chain: **V1.3 → V1.6 succeeded** and **V1.6 → V6.6 succeeded**.
- During the V1.6/V6.6 physical OTA tests, the WS2812B status LED did not show any visible color indicator for Local OTA or Online OTA, so the user could not identify OTA stage/result from the LED.
- This is now a separate diagnostic item from the previously fixed BLE RX synchronization and callback lifetime issues.
- Repository production release remains **V1.6**; the V6.6 test artifact is not a public release and must not be promoted to the production manifest without an explicit user instruction.
- Current discussion evidence from the V1.6 source: Local OTA enters `OtaState::LOCAL_UPLOAD` while `otaActive=true`, and the normal `processLeds()` path explicitly clears the LEDs for that state. Local OTA success transitions directly to `OtaState::SUCCESS` and schedules restart without a dedicated green result indicator. Online OTA has an explicit result-indicator state machine, so the absence of online LED output requires separate isolation of the LED hardware/output path versus indicator-state execution before any patch is made.
- No firmware source patch was made from this physical-test observation.

## 2026-09-28 — PHYSICAL TEST: ONLINE OTA COMPLETES, BLUE INDICATOR APPEARS STATIC

- User retested Online OTA with the RGB LED enabled.
- Observed sequence: press Update -> LED illuminated **blue**, but user observed it as **static rather than blinking** -> LED turned off -> device restarted -> BLE became available again and reconnected to the App.
- App notification during the test showed Online OTA in progress at Wi-Fi connect / 0%.
- This confirms that, in this test, the Online OTA flow did not remain stuck permanently: the device reached restart/recovery and BLE returned.
- Current issue is narrowed to the **Online OTA LED indicator behavior/visibility**. The source already contains a non-blocking result-indicator state machine intended to blink the requested color for approximately two seconds; physical observation did not match the intended blink pattern.
- No firmware source patch was made from this observation. OTA protected blocks remain unchanged pending root-cause isolation.


## V1.6 HEAP DIAGNOSTIC BRANCH

- Diagnostic branch: `diagnostic/v1.6-heap-check`.
- Diagnostic source remains version marker `V1.6`; this branch is NOT a production firmware release.
- Added official ESP-IDF heap integrity instrumentation using `heap_caps_check_integrity_all(true)` from `esp_heap_caps.h`.
- Checkpoints cover WebServer stop, Wi-Fi radio shutdown, BLE init/object creation, BLE2902 allocation, service start, advertising, then delayed checks at 1 s and 30 s after advertising.
- No BLE UUID/protocol, SPSC queue, OTA flow, LED behavior, GPIO, or application control logic was intentionally changed.
- Purpose: identify the first observable heap corruption point on the ESP32-C3 first BLE startup after the boot Wi-Fi AP timeout.
- Production `main` branch remains unchanged by this diagnostic instrumentation.


### Diagnostic branch verification — 2026-09-28 08:40 WIB

- Diagnostic source verified at blob SHA `f2d841828982fc22542ccdf2c9436ecce494fc61`.
- Diagnostic branch contains heap integrity checkpoints only; no production behavior change is approved.
- ArduinoDroid compile/flash result: **not yet available**; do not treat the diagnostic source as compiled/validated until the user reports the result.


## 2026-09-28 — EXECUTION FULL: V1.7 ONLINE OTA RADIO-HANDOFF HARDENING

- User requested a full firmware analysis and direct repair with the primary goal of making Online OTA reliable.
- Authoritative base inspected: `firmware/JEXFYZ-V1.6.ino` on `main`, source blob `f2d841828982fc22542ccdf2c9436ecce494fc61`, 3868 source lines.
- Full-source static inspection focused on the complete execution path, with special attention to Online OTA, Wi-Fi/BLE handoff, OTA Update lifecycle, BLE callbacks/queues, and existing diagnostic instrumentation.
- Confirmed one concrete, minimal lifecycle issue in the Online OTA path: after the active BLE session is torn down, Online OTA redundantly called `WiFi.disconnect(true, false)` and `WiFi.softAPdisconnect(true)` before `WiFi.mode(WIFI_STA)`. The same firmware also redundantly repeated Wi-Fi shutdown inside `startBle()` after callers had already completed the Wi-Fi-off boundary.
- Applied controlled V1.7 change:
  - advanced firmware marker from V1.6 to **V1.7**;
  - in `startBle()`, removed the repeated `WiFi.disconnect()`, `WiFi.softAPdisconnect()`, and `WiFi.mode(WIFI_OFF)` sequence; the caller remains responsible for the Wi-Fi-off boundary and `startBle()` only yields before BLE initialization;
  - in `startOnlineOta()`, removed the second Wi-Fi teardown and now enters the official Arduino `WiFi.mode(WIFI_STA)` lifecycle directly, followed by hostname/sleep/autoreconnect configuration and `WiFi.begin()`;
  - existing Online OTA transport (HTTPClient + WiFiClientSecure + Update) was otherwise left unchanged;
  - Local OTA logic, GPIO mapping, BLE UUID/protocol, SPSC queue, and safety behavior were not intentionally redesigned.
- New authoritative source: `firmware/JEXFYZ-V1.7.ino`, blob SHA `de6a60b88c91d0858a3b41aa097dc7a6cb842232`, 110,275 bytes, 3,867 lines.
- OTA Gold Master Lock refreshed for V1.7: `firmware/OTA_GOLD_MASTER_LOCK.json`, blob SHA `4d0de518ab9db29fc198ecad7fdb70f3ea775135`.
- Repository commits:
  - V1.7 source: `dc7346f42ff2d21f65cf0216f3e65a3f66881c46`
  - OTA lock refresh: `ecccef272dc7cf6dc1a110e630c5efd2c159216c`
- Static post-change verification still required before physical compile. No ArduinoDroid compile or hardware result is claimed by this execution.
- Important unresolved issue: Online OTA success is still not proven from this source change alone. The current download/flash transport has not been physically revalidated on V1.7, and the existing heap diagnostic remains present for the V1.7 candidate.
- Next boundary: send the exact V1.7 source to Gemini for full review of the two radio-lifecycle changes and the complete Online OTA path; do not compile until ChatGPT and Gemini agree.

## 2026-09-28 — EXECUTION: V1.7 ARDUINODROID PROTOTYPE VISIBILITY FIX

- ArduinoDroid compile output was reviewed from the user's actual build log.
- The selected toolchain is confirmed as ESP32-C3 with Arduino-ESP32 Core **3.3.7** and the bundled ESP-IDF v5.5 libraries.
- Compile stopped during Arduino sketch prototype generation because ArduinoDroid generated function prototypes before the sketch-scoped enum definitions for `Voltage`, `LedMode`, and `VoltageRequestSource`.
- The resulting errors (`Voltage was not declared in this scope`, enum type errors, and subsequent redeclaration errors) are treated as one preprocessing/prototype-visibility root cause, not as separate firmware logic failures.
- Minimal repair applied directly to `main`: added forward declarations for the three enum classes immediately after the includes, before the firmware body:
  - `enum class Voltage : uint8_t;`
  - `enum class LedMode : uint8_t;`
  - `enum class VoltageRequestSource : uint8_t;`
- No Online OTA state-machine logic, radio lifecycle logic, BLE protocol, GPIO mapping, safety logic, or Update transport was changed by this repair.
- Repository commit: `b3ba7856c8db4e95f29b0dca5a2f0470c17d2238`.
- New V1.7 source blob SHA: `67aa36df79f2bcedd865a16b120ff6db72650ee9`.
- Physical ArduinoDroid recompilation after this repair is **not yet verified**; do not claim compile success until the user provides the new final build result.

### ArduinoDroid compile retry — second prototype-generation failure

- The user's next ArduinoDroid compile reached the generated source as `JEXFYZ.cpp` and failed with a single reported prototype-generation error: `JEXFYZ.ino:76:68: error: 'OnlineOtaIndicatorNext' has not been declared`. fileciteturn265file0L10489-L10491
- The previous forward-declaration repair covered `Voltage`, `LedMode`, and `VoltageRequestSource`, but it did not cover the three OTA state enums because they are declared later in the sketch.
- Minimal repair applied on `main`: added forward declarations for `OtaState`, `OnlineOtaFlow`, and `OnlineOtaIndicatorNext` alongside the existing enum forward declarations immediately after the includes.
- No OTA engine/state-machine behavior, radio lifecycle behavior, BLE protocol, GPIO mapping, safety behavior, or Update transport was changed.
- Repository commit: `d7568c581d6ce3a0437a39c08ede72874a781a1b`.
- New V1.7 source blob SHA: `7b16727475aa4bc8486ba69b2db63c19ad749ee9`.
- Gold Master protected segments were rechecked after the change and remain exact-match.
- ArduinoDroid recompilation after this second repair is **not yet verified**.

### 2026-09-28 — V1.7 BIN PROMOTED FROM USER ARDUINODROID ARTIFACT

- User supplied the newly compiled ArduinoDroid application BIN and requested the existing temporary upload to be renamed/promoted.
- The temporary public firmware file was `JEXFYZ.cpp.bin`, size **1,456,064 bytes**, blob SHA `e8acabf6484490ba9713a1dc44b06c67252c53b8`.
- The binary blob identity was preserved; no binary re-encoding or recompilation was performed.
- Official public filename is now **`JEXFYZ-V1.7.bin`** in `TenzoNkz/JEXFYZ-Firmware`.
- Previous public `JEXFYZ-V1.6.bin` and temporary `JEXFYZ.cpp.bin` paths were removed from the public firmware repository.
- `manifest.json` now declares **V1.7** and points to:
  `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.7.bin`
- Firmware publication commit: `a05b07cc86f8462a4907d5efebe7359dac55c1f1`.
- Publication verification: repository root contains exactly `JEXFYZ-V1.7.bin` and `manifest.json`; manifest version and URL match V1.7.
- This publication records the user's ArduinoDroid binary artifact. Physical V1.7 runtime/Online OTA success is **not** implied by the rename/publication alone.
## 2026-09-28 — FIREBASE METADATA ACCESS NOTE

- Online OTA release metadata is supplied to the firmware by the App; the firmware itself does not query Firebase.
- Firebase RTDB node is `/firmware_update`; GitHub hosts only `JEXFYZ.cpp.bin`.
- App-side Firebase REST reads now attach an App Check token when available and report permission failures explicitly.


## 2026-09-28 — ONLINE OTA WIFI RETRY HARDENING

- Physical test evidence from the user showed Online OTA reached `ONLINE_WIFI_CONNECT` but did not advance.
- Review of the V1.0 source found that STA auto-reconnect was explicitly disabled before the first `WiFi.begin()`.
- The Online OTA Wi-Fi phase is now hardened with:
  - `WiFi.setAutoReconnect(true)` before each connection attempt;
  - official `WiFi.begin()` return status handling using `wl_status_t` / `WL_CONNECT_FAILED`;
  - up to **3 bounded connection attempts**, each with the existing 15-second timeout;
  - non-blocking retry via the existing OTA state machine;
  - immediate retry scheduling when the official `WiFi.begin()` call reports `WL_CONNECT_FAILED`.
- This does not assert that wrong credentials or an unsupported Wi-Fi band can be bypassed; it only removes the single-attempt/transient-association failure mode.
- Official Arduino-ESP32 Core 3.3.7 source was checked for `WiFi.begin()`, `WiFi.disconnect()`, `WiFi.setAutoReconnect()`, and `WL_CONNECT_FAILED`; the APIs used by this hardening are present in that pinned core.
- No Local OTA, BLE UUID/protocol, GPIO, safety, adaptive, or flash-write mechanism was changed.
- ArduinoDroid compile and physical retest are still pending.
## 2026-09-28 — LED BOOT/ONLINE OTA OFF FIX

- User reported a static blue LED during the initial 10-second Wi-Fi AP window and again during the early Online OTA handoff; both were unintended.
- Root cause 1: `initializeRuntimeFeatures()` explicitly called `showAll(0x0000FF, 80)`, creating the static blue boot indicator before the AP started.
- Root cause 2: after `CLOUDOTA` was accepted, the firmware waited for the BLE TX queue to settle (up to the OTA start guard window) before `startOnlineOta()`. During that gap, normal LED rendering could resume and leave the configured LED effect visible.
- Fix:
  - boot/AP startup now forces a known **LED OFF** frame;
  - `CLOUDOTA` takes LED ownership immediately and forces **LED OFF** before the BLE-to-Wi-Fi handoff;
  - `processLeds()` keeps the LED OFF while `onlineOtaStartPending` is true;
  - the existing Online OTA stage indicators after successful Wi-Fi connection remain otherwise unchanged.
- No Local OTA flash lifecycle, BLE protocol/UUID, GPIO, safety, adaptive, or Wi-Fi transport mechanism was intentionally changed by this LED-only fix.
- Static sanity validation of the edited source: braces 476/476, parentheses 1901/1901.
- ArduinoDroid/Core 3.3.7 compile and physical retest are pending.


## 2026-09-28 — V1.2 EVENT-DRIVEN LED OTA PATCH

- Applied the approved functional patch from V1.1 to **V1.2**.
- The superseded V1.1 source file `firmware/JEXFYZ-V1.1-FINAL.ino` was removed from the repository after V1.2 was archived.
- The retained patched source is `firmware/JEXFYZ-V1.2.ino`.
- Functional change is intentionally limited to the LED renderer ownership inside `processLeds()` plus the firmware version constant.
- Added a function-local `static bool ledsForcedOff` latch so repeated OTA/RGB-OFF branches do not call `stopUserLedOutput()` or `showAll(0x000000, 0)` on every main-loop iteration.
- The latch is cleared when Local/Online result indicators, protection blink, voltage indication, or normal user LED rendering needs to regain LED ownership.
- Existing Local OTA and Online OTA result-indicator state machines were not rewritten; their existing phase-gated rendering remains intact.
- No BLE UUID/protocol, GPIO mapping, safety logic, flash Update lifecycle, GitHub URL validation, Wi-Fi retry policy, or Firebase/App behavior was intentionally changed by this patch.
- Static validation performed on the patched source: V1.2 marker present; exactly one `ledsForcedOff` declaration; gated OFF rendering present for OTA/pending/RGB-OFF branches; source structure remains balanced for braces/parentheses; no duplicate V1.2 version declaration.
- The repeated LED-rendering condition is a **confirmed source-code condition**. Any claim that it is the sole cause of Wi-Fi association failure remains unproven until physical testing.
- ArduinoDroid / Arduino-ESP32 Core 3.3.7 compilation and physical V1.2 validation remain pending; repository storage of the source must not be treated as runtime validation.

## 2026-09-28 — V1.3 GEMINI OTA/RECOVERY PATCH APPLIED

- V1.2 source was **renamed/promoted** to `firmware/JEXFYZ-V1.3.ino`; no separate V1.2 active source is retained.
- The V1.3 code change is the Gemini patch applied without additional code modifications:
  1. `FW_VERSION`: V1.2 → V1.3.
  2. `waitForWiFiOff()`: replace 16 `yield()` iterations with `delay(10)` per iteration.
  3. `startOnlineOta()`: change the Online OTA BLE teardown call from `stopBleRadio(true)` to `stopBleRadio(false)`.
  4. Online Wi-Fi retry: replace the retry-boundary `yield()` with `delay(50)`.
  5. `performOnlineOtaDownload()`: when `stream->read()` returns <= 0, check connection loss and stream idle timeout before continuing; use `delay(10)`.
  6. Online OTA recovery indicator: set `bleLedResumePending` to true with release ordering before `startBle()`.
- No additional TLS hardening, NTP bypass, NTC calibration change, BLE queue redesign, GPIO change, BLE UUID/protocol change, Local OTA lifecycle change, App/Firebase change, or ESP-IDF OTA API was added in this Gemini-derived V1.3 patch.
- Static patch validation: all six intended replacements applied exactly once; reconstructed patched source matches the intended six-replacement transformation; V1.3 version marker is present; no V1.2 version marker remains in the patched source.
- This repository update is **source storage only**. ArduinoDroid / Arduino-ESP32 Core 3.3.7 compilation and physical V1.3 validation are pending and must not be inferred from the commit.

## 2026-09-28 — V1.3 GEMINI PATCH SYNC

- Synchronized `firmware/JEXFYZ-V1.3.ino` with the latest Gemini-provided V1.3 patch text.
- No new firmware version was created; this remains V1.3 and is still pre-physical-validation.
- The only delta from the previously stored V1.3 was the missing exact Gemini change inside `startOnlineOta()`: its direct `WIFI_OFF` settle loop now uses `delay(10)` for each `RADIO_OFF_SETTLE_YIELDS` iteration, matching Gemini's latest full-function patch.
- No independent optimization, API substitution, TLS change, NTP bypass, NTC change, BLE queue redesign, GPIO change, or additional behavioral patch was added.

## 2026-09-28 — V1.3 GEMINI SOURCE STATUS / CURRENT BASELINE

- Current firmware source baseline in this App repository is **V1.3** at `firmware/JEXFYZ-V1.3.ino`.
- The previous `firmware/JEXFYZ-V1.2.ino` source was removed during the V1.2 → V1.3 promotion; the firmware directory is intended to contain only the current active source.
- V1.3 is the **Gemini-derived patch applied without additional code changes**. The six requested code changes are:
  1. `FW_VERSION`: V1.2 → V1.3.
  2. `waitForWiFiOff()`: 16 iterations of `yield()` → `delay(10)` per iteration.
  3. Online OTA BLE teardown: `stopBleRadio(true)` → `stopBleRadio(false)` in `startOnlineOta()`.
  4. Online Wi-Fi retry boundary: `yield()` → `delay(50)`.
  5. `performOnlineOtaDownload()`: `bytesRead <= 0` now checks connection loss and the existing stream-idle timeout before continuing, with `delay(10)`.
  6. Online OTA RECOVER: `bleLedResumePending.store(false, ...)` → `store(true, std::memory_order_release)`.
- Gemini's **source-confirmed** finding retained as rationale: the previous download path could repeatedly `continue` after `stream->read()` returned <= 0 without reaching the existing idle-timeout check when `available() > 0`.
- Gemini's other root-cause claim that `stopBleRadio(true)` necessarily causes ESP32-C3 heap corruption is **not independently runtime-proven**. It is recorded as the Gemini hypothesis behind patch #3, not as established fact.
- TLS verification remains enabled; `setInsecure()` was not adopted.
- NTP logic remains enabled; no NTP bypass was adopted.
- NTC thresholds/calibration remain unchanged.
- BLE queue/protocol, BLE UUIDs, GPIO mapping, safety/adaptive logic, Local OTA flash lifecycle, and App/Firebase architecture were not intentionally changed by this V1.3 patch.
- Important scope note: changing `waitForWiFiOff()` affects every caller of that helper, including Wi-Fi shutdown used by Local OTA. Therefore the V1.3 patch must not be described as having zero effect on Local OTA; its `Update.h` flash lifecycle itself was left unchanged.
- Static source storage/inspection is complete. **ArduinoDroid + Arduino-ESP32 Core 3.3.7 compilation and physical V1.3 validation are still pending.**
- Do not treat the presence of V1.3 in the repository as evidence of successful runtime behavior.
- When the next functional firmware change is made, rename the existing V1.3 source to the next version and patch that same active file; do not create a second active firmware source file.


## 2026-09-28 — V1.4 OTA LED INDICATOR ISOLATED FIX

- Active firmware source is now **V1.4** at `firmware/JEXFYZ-V1.4.ino`.
- The previous active `firmware/JEXFYZ-V1.3.ino` was renamed/replaced by V1.4 and removed, preserving the single-active-source rule.
- V1.4 is intentionally an **isolated LED-indicator revision**. The radio/BLE lifecycle changes proposed in the latest Gemini answer were **not** applied.
- V1.4 functional changes:
  1. `FW_VERSION`: V1.3 → V1.4.
  2. `ONLINE_OTA_RESULT_INDICATOR_MS`: 1800 ms → 2000 ms.
  3. Online OTA result indicator phases: 500 ms ON / 500 ms OFF / 500 ms ON / 500 ms OFF.
  4. Existing event-driven phase-change rendering is preserved; the LED is rendered only when the phase changes.
  5. `bleLedResumePending` recovery remains `true`.
- No changes were made in V1.4 to:
  - `BLEDevice::deinit(false)` lifecycle behavior;
  - BLE server/characteristic pointer lifetime;
  - Wi-Fi radio handoff;
  - Wi-Fi retry state machine;
  - HTTP stream guard;
  - Local OTA flash lifecycle;
  - thermal/safety logic;
  - BLE protocol/UUIDs or queue architecture.
- Rationale for scope isolation: the latest Gemini proposal replaces BLE deinitialization with `stopAdvertising()` and retains BLE pointers after deinitialization. Those lifecycle assumptions are not independently verified and are therefore excluded from this revision.
- The requested LED behavior is now deterministic by source: **2 seconds total, ON-OFF-ON-OFF at 500 ms boundaries**.
- Important terminology: V1.4 is **not** a complete “zero-delay/full-millis” radio rewrite. No new blocking radio-loop conversion was applied in this isolated revision.
- V1.4 still requires **ArduinoDroid + Arduino-ESP32 Core 3.3.7 compilation and physical validation**.
- App source was not changed and no App Build was triggered by this firmware-only revision.

## 2026-09-28 — V1.4 PHYSICAL TEST: ONLINE OTA STILL FAILS

- User physically tested firmware **V1.4** and reports that **Online OTA still fails / cannot proceed**.
- No exact OTA stage, LED pattern, Wi-Fi association result, or reset/crash log was supplied with this report.
- Therefore **no new root cause is declared from this result alone**.
- The V1.4 LED timing change does not by itself prove or disprove the underlying Online OTA radio/network failure; the next diagnostic must identify the last observable OTA stage before changing radio code again.
- Current source remains V1.4 and no additional firmware patch is applied from this test report.


## 2026-09-28 — V1.4 LATEST PHYSICAL EVIDENCE / ONLINE OTA STALL

- User supplied a physical App screenshot after attempting Online OTA with V1.4.
- Visible App status at the captured moment: **`OTA in progress • ONLINE • Wi-Fi connect • 0%`**.
- Normal telemetry values remained visible in the UI; the header Bluetooth control was still rendered in its connected state at capture time.
- Important source-order finding: V1.4 sets `ONLINE_WIFI_CONNECT` **before** `stopBleRadio(false)`, Wi-Fi shutdown/settle, and `WiFi.begin()`. Therefore the screenshot proves only the last status published to the App; it does **not** prove that `WiFi.begin()` was reached successfully.
- The official Arduino-ESP32 Core 3.3.7 `BLEDevice::deinit(bool release_memory)` implementation was independently checked. It:
  - stops advertising/scanning;
  - deletes BLE advertising/scan/server/client objects;
  - clears the connected-client map;
  - disables and deinitializes the BLE host/controller;
  - releases BTDM memory only when `release_memory=true`.
- Consequently, the current V1.4 use of `BLEDevice::deinit(false)` is a real BLE-stack/controller teardown, not merely `stopAdvertising()`. The previous Gemini wording that `deinit(false)` leaves BLE objects/pointers available for reuse is inconsistent with the official 3.3.7 source.
- This materially changes the diagnostic focus: before changing BLE teardown again, isolate whether V1.4 stalls/crashes during BLE deinit, Wi-Fi shutdown/settling, or the actual `WiFi.begin()` call.
- No firmware source change was made from this screenshot alone.


## 2026-09-28 — V1.5 ONLINE OTA HANDOFF PATCH APPLIED

- Active firmware source is now **V1.5** at `firmware/JEXFYZ-V1.5.ino`; V1.4 was renamed/promoted and removed so the firmware directory retains one active source.
- Applied the user's supplied Gemini V1.5 patch to the existing V1.4 source. No additional firmware behavior was added beyond that patch.
- V1.5 changes:
  1. `FW_VERSION`: V1.4 → V1.5.
  2. `OnlineOtaFlow`: added `RADIO_TEARDOWN`.
  3. `stopBleRadio(false)`: uses official `BLEDevice::stopAdvertising()` plus a 50 ms millis/while settle loop; pointer nulling remains guarded by `releaseBluetoothMemory`.
  4. `waitForWiFiOff()`: uses a 160 ms millis/while settle loop with `yield()`.
  5. `startOnlineOta()`: removes the direct blocking Wi-Fi STA start and hands radio transition to `RADIO_TEARDOWN`.
  6. `RADIO_TEARDOWN`: after 160 ms enters STA, disables Wi-Fi auto-reconnect, calls `WiFi.begin()`, then transitions to `WIFI_CONNECTING`.
  7. `WIFI_CONNECTING`: detects `WL_CONNECT_FAILED`, `WL_NO_SSID_AVAIL`, or timeout; retries through a fresh `RADIO_TEARDOWN`; after the bounded retry count calls `failOnlineOta()`.
  8. Existing HTTP stream guard from V1.3/V1.4 remains.
  9. Existing 2-second / 500 ms OTA result LED indicator remains.
  10. Existing `bleLedResumePending=true` recovery remains.
- Important verification note: official Arduino-ESP32 Core 3.3.7 source confirms that `BLEDevice::stopAdvertising()` stops advertising only, while `BLEDevice::deinit(false)` performs full BLE host/controller teardown without releasing BTDM memory. Therefore the V1.5 `stopAdvertising()` change is recorded as the **user-requested Gemini patch**, not as a proven equivalent to full BLE teardown.
- Official Core 3.3.7 source also confirms `WiFi.begin()`, `WiFi.disconnect()`, `WiFi.setAutoReconnect()`, and `WL_CONNECT_FAILED` are available APIs.
- V1.5 must therefore be treated as a **diagnostic/experimental firmware revision**, not as a proven final fix.
- No App source change and no App Build were made.
- Firebase firmware metadata was not promoted to V1.5; no V1.5 BIN publication is implied.
- ArduinoDroid + Arduino-ESP32 Core 3.3.7 compilation and physical validation are pending.


## 2026-09-28 — V1.5 GEMINI FULL FILE APPLIED

- User explicitly instructed: **apply the complete firmware file supplied by Gemini**.
- The uploaded source `Gemini V1.5.txt` was applied as the complete replacement content for `firmware/JEXFYZ-V1.5.ino`.
- This action intentionally did **not** perform selective reconciliation, optimization, correction, or substitution against the previous repository V1.5 source.
- The repository V1.5 source now contains **4081 source lines** after applying the uploaded Gemini file through the file-retrieval path.
- Active firmware directory remains single-source: `firmware/JEXFYZ-V1.5.ino`.
- No App/Dart source was changed and no App Build was triggered.
- Firebase firmware metadata was not changed or promoted.
- This is the authoritative V1.5 source supplied by Gemini for the next ArduinoDroid/Core 3.3.7 compile and physical test.
- Any technical concerns discovered during analysis are recorded as discussion notes only and are **not silently patched** unless the user explicitly provides a new patch or requests a change.


## 2026-09-28 — V1.6 GEMINI HTTPS GITHUB PATCH APPLIED

- User explicitly instructed execution of the Gemini V1.6 patch.
- Active source is now `firmware/JEXFYZ-V1.6.ino`; V1.5 was promoted/removed in accordance with the single-active-source rule.
- Applied exactly the requested three functional changes to the full V1.5 source:
  1. `FW_VERSION`: V1.5 → V1.6.
  2. Replaced the existing `GITHUB_ROOT_CA` PEM bundle with the complete certificate block supplied in the Gemini instruction.
  3. Removed `onlineHttpClient.useHTTP10(true);` so HTTPClient uses its default HTTP/1.1 behavior.
- No App/Dart source, BLE P1 protocol/UUID, Firebase metadata, Local OTA, safety, thermal, or HTTP stream guard changes were made.
- The V1.6 source currently contains no `useHTTP10(true)` call and contains the supplied additional root-certificate block.
- This is the user's requested Gemini patch applied directly; no selective correction or reinterpretation was made.
- **Important status:** this source-level patch has not yet been compiled or physically validated. Do not treat the new certificate block or HTTP/1.1 change as proven to fix GitHub connection failures until the ArduinoDroid/Core 3.3.7 physical test.
- Firebase firmware metadata remains unchanged and must not be promoted to V1.6 without a deliberately compiled/published V1.6 BIN.


## 2026-09-28 — GEMINI V1.7 ONLINE OTA TLS SIMPLIFICATION APPLIED

- User explicitly instructed: **"Eksekusi Gemini"** using the attached full Gemini V1.7 source.
- The Gemini source was applied as the active firmware source **without selectively reconciling or silently changing its implementation**.
- Active source path is now:
  `firmware/JEXFYZ-V1.7.ino`
- Superseded active source `firmware/JEXFYZ-V1.6.ino` was removed so the firmware directory does not retain multiple active versioned `.ino` sources.
- Functional change delivered by Gemini V1.7:
  - removed the GitHub Root CA bundle from the Online OTA source;
  - removed the Online OTA `TIME_SYNC` state and `cloudTimeSyncStarted` state variable;
  - Online OTA proceeds from successful Wi-Fi connection directly to download preparation;
  - GitHub HTTPS client uses `cloudClient.setInsecure()`;
  - `onlineHttpClient.useHTTP10(true)` remains absent;
  - existing streamed `Update.h` download path and OTA result indicators are retained.
- Fixed GitHub binary URL remains:
  `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin`
- The App, BLE P1 contract/UUIDs, GPIO mapping, Local OTA, thermal/safety logic, adaptive control, and PWM logic were not intentionally changed by this Gemini source.
- Static source checks on the applied Gemini V1.7 file:
  - source lines: 3981;
  - `GITHUB_ROOT_CA`: absent;
  - `cloudClient.setCACert`: absent;
  - `TIME_SYNC`: absent;
  - `useHTTP10(true)`: absent;
  - `esp_ota_*`: absent;
  - `cloudClient.setInsecure()`: present;
  - delimiter sanity check: parentheses 1924/1924, braces 491/491, brackets 57/57.
- GitHub source commit sequence:
  - complete V1.7 source applied: `5fbce565f6796824f771f267ba557ff69755077c`;
  - superseded V1.6 source removed: `8e49a070ab0519dbccccfcd9037074ed58792b43`.
- Validation boundary:
  - repository source application: **completed**;
  - static inspection of the attached Gemini source: **completed**;
  - ArduinoDroid/Core 3.3.7 compilation: **not performed here**;
  - physical V1.7 Online OTA test: **not performed yet**;
  - therefore V1.7 is a test/source revision, not a physically validated release.
- Firebase firmware metadata is **not promoted to V1.7** merely because the source version changed. Promotion remains a deliberate step after a compiled/public BIN exists.


## 2026-09-28 — OTA PHYSICAL VALIDATION COMPLETE / OTA FROZEN

- User confirmed by physical hardware test that **Local OTA and Online OTA both succeed**.
- Online OTA physical test path completed successfully:
  **App → BLE OTA commands → Wi-Fi handoff → GitHub HTTPS → firmware download → flash → success → BLE/runtime recovery**.
- The Online OTA test intentionally used firmware version **V6.4** as a repeated-update test value. The displayed V6.4 is therefore a test/version value and is **not** evidence that the active source file version changed from V1.7.
- Current source remains **firmware/JEXFYZ-V1.7.ino** with the simplified HTTPS client using **cloudClient.setInsecure()**.
- Local OTA success was also physically confirmed with the intended **green result indication**.
- **OTA FREEZE:** do not modify the OTA transport, radio handoff, GitHub URL/path, HTTP download logic, Update.h flash lifecycle, OTA result indicators, or BLE OTA command sequence unless the user explicitly requests an OTA change.
- Future firmware feature changes must preserve the currently validated OTA path and must not use the successful OTA test as a reason to redesign OTA.
- No Firebase promotion is implied by this validation. Firebase version metadata remains a separate deliberate release-promotion step.
- This entry supersedes earlier notes that described V1.7 Online OTA as pending physical validation.


## 2026-09-28 — V1.8 OTA RESULT LED SPEED UPDATE

- User explicitly requested the successful Local OTA and Online OTA result indicators be accelerated.
- Functional firmware revision bumped from V1.7 to V1.8.
- Active source path is now: firmware/JEXFYZ-V1.8.ino
- Superseded firmware/JEXFYZ-V1.7.ino was removed so the firmware directory keeps a single active versioned source.
- OTA mechanics were not changed. Only the post-result LED timing was changed:
  - Online OTA result indicator: 1000 ms total.
  - Local OTA result indicator: 1000 ms total.
  - Four phases: 250 ms ON -> 250 ms OFF -> 250 ms ON -> 250 ms OFF.
- Wi-Fi/BLE handoff, GitHub transport, WiFiClientSecure.setInsecure(), HTTP download, Update.h flash lifecycle, OTA recovery, and OTA command/telemetry contracts remain unchanged.
- Static validation of V1.8:
  - parentheses: 1924/1924;
  - braces: 491/491;
  - brackets: 57/57;
  - elapsed / 250U: 2 occurrences;
  - old elapsed / 500U: 0;
  - old elapsed < 2000U: 0.
- ArduinoDroid/Core 3.3.7 compile and physical V1.8 validation are still pending.
- OTA remains frozen in architecture; this revision is limited to the user-requested result-indicator timing change.
- Firebase metadata is not promoted to V1.8 from the source version change alone.


## 2026-09-28 — V1.8 OTA RESULT LED SPEED ADJUSTMENT

- User explicitly requested the Local OTA and Online OTA result LED indicators to be faster.
- Functional firmware revision bumped from **V1.7 → V1.8**.
- Only the OTA **result-indicator timing** was changed:
  - Online OTA result indicator: **2 seconds → 1 second**.
  - Local OTA result indicator: **2 seconds → 1 second**.
  - Each phase is now **250 ms**: ON 250 ms → OFF 250 ms → ON 250 ms → OFF 250 ms.
- The actual OTA transport and flash path were not changed.
- Preserved:
  - BLE/Wi-Fi radio handoff;
  - Wi-Fi connection flow;
  - GitHub HTTPS download using `cloudClient.setInsecure()`;
  - HTTP/stream guard;
  - `Update.h` flashing;
  - OTA success/failure recovery;
  - BLE OTA command sequence;
  - Local OTA behavior apart from the result LED timing.
- This is an explicit exception to the previous OTA timing freeze: **only the requested result LED timing was changed**. The underlying OTA mechanism remains frozen.
- Static validation of repository source `firmware/JEXFYZ-V1.8.ino`:
  - 3981 source lines;
  - `ONLINE_OTA_RESULT_INDICATOR_MS = 1000`;
  - two `elapsed / 250U` phase calculations (Online + Local);
  - Local result window `elapsed < 1000U`;
  - no remaining `elapsed / 500U`;
  - no remaining 2-second Online indicator constant;
  - `cloudClient.setInsecure()` present;
  - `GITHUB_ROOT_CA` absent;
  - `TIME_SYNC` absent;
  - `useHTTP10(true)` absent;
  - delimiter balance: braces 491/491, parentheses 1924/1924, brackets 57/57.
- Physical OTA functionality remains the previously validated baseline. **V1.8 LED timing itself has not yet been physically revalidated**.
- Firebase metadata is not promoted merely because the source version changed.


## 2026-09-28 — V2.1 LED LAYOUT + MODE CLEANUP

- Functional firmware revision bumped from **V2.0 → V2.1**.
- Firmware source is stored in the dedicated firmware repository:
  **`TenzoNkz/JEXFYZ-Firmware/JEXFYZ-V2.1.ino`**.
- Physical 8-LED path:
  - **RIGHT TOP = LED 0**;
  - **0 → 1 → 2 → 3** down to RIGHT BOTTOM;
  - **3 → 4** across to LEFT BOTTOM;
  - **4 → 5 → 6 → 7** upward to LEFT TOP.
  - Firmware mapping: `RIGHT_PIXELS = {0, 1, 2, 3}`, `LEFT_PIXELS = {7, 6, 5, 4}`.
- LED modes are reduced from **8 → 7**. **TWINKLE is removed completely** from the enum, runtime state, renderer, persisted mode range, and BLE MODE validation.
- A persisted mode value of 8 is normalized to **mode 7 (RAINBOW)** on settings load.
- **RAINBOW** now displays the same color on all 8 LEDs and smoothly shifts through the hue wheel; one full cycle is **30 seconds**.
- OTA, BLE P1 UUID/protocol, GPIO Fan/Peltier mapping, PWM, thermal safety, adaptive logic, Wi-Fi/BLE handoff, and OTA result timing are unchanged.
- Static source checks completed; ArduinoDroid / Arduino-ESP32 Core 3.3.7 compilation and physical V2.1 validation remain pending.
- The published `JEXFYZ.cpp.bin` was deliberately left unchanged; no Firebase/OTA binary promotion was performed.


## 2026-09-28 — FIRMWARE SOURCE REPOSITORY STRUCTURE

- Authoritative firmware `.ino` source belongs in the **JE X FYZ App repository** under `firmware/`.
- The dedicated **JEXFYZ-Firmware repository is binary-only** and must contain only the published `JEXFYZ.cpp.bin` OTA artifact (plus repository metadata/files that are not firmware source).
- V2.1 source was moved from `TenzoNkz/JEXFYZ-Firmware/JEXFYZ-V2.1.ino` to `TenzoNkz/JEXFYZ-App/firmware/JEXFYZ-V2.1.ino` without source-content changes.
- The published `JEXFYZ.cpp.bin` was not changed.


## 2026-09-30 — V2.3 CONTROL TELEMETRY RECONCILIATION

- Firmware source remains **V2.3**; no firmware version bump was made for this synchronization fix.
- Control-command responses now publish the authoritative current state even when the requested value is already equal to the current value. This specifically fixes the stale-App case where firmware was already `FAN:ON` or `PELTIER:ON`, the App sent the same ON command, received only an ACK, and the App toggle remained OFF.
- FAN commands now explicitly publish `FAN:<ON|OFF>` plus the current `PELTIER:<ON|OFF>` state before their ACK. PELTIER commands do the same. This keeps the paired safety relationship visible to the App.
- Equivalent command-response reconciliation was extended to RGB state, LED mode/brightness/color, Adaptive state/profile, fan speed, temperature limits, reset values, and related configuration telemetry. Runtime delta behavior outside command reconciliation remains unchanged, so this does not introduce a periodic telemetry flood.
- Existing firmware safety authority is preserved: Peltier cannot remain ON without a valid NTC, acceptable hotside temperature, an active fan, and non-OTA conditions.
- GPIO mapping is unchanged and authoritative: GPIO5 = FAN, GPIO6 = PELTIER.
- BLE P1 UUIDs/protocol and OTA architecture remain unchanged.
- App-side confirmation now waits for matching authoritative telemetry after an accepted ACK; this firmware note records the firmware half of that contract.
- Static/source review was performed against `firmware/JEXFYZ-V2.3.ino`. ArduinoDroid + Arduino-ESP32 Core 3.3.7 compilation and physical hardware validation remain pending.


## 2026-10-01 — VERIFIED CONTROL OUTPUT CORRECTION

- Bench behavior confirmed: pressing the App FAN control was physically activating the Peltier output, while the App PELTIER control was correspondingly reversed at the hardware output.
- The App protocol commands remain correct and were not swapped: `FAN:ON/OFF` remains FAN and `PELTIER:ON/OFF` remains PELTIER.
- Root cause for the observed physical inversion is corrected at the firmware output mapping layer: `PIN_FAN = 6`, `PIN_PELTIER = 5` so the logical FAN/PELTIER commands drive the observed physical outputs correctly.
- Existing safety relationship is preserved: Peltier still requires logical Fan ON, valid NTC, acceptable hotside temperature, and non-OTA conditions.
- Important: this is a firmware-source correction. The binary-only `TenzoNkz/JEXFYZ-Firmware` repository still requires a newly compiled/flashed BIN before the physical device changes.
- Do not compensate by swapping App BLE command tokens; doing so would corrupt the logical safety/telemetry contract.

## 2026-10-04 — HARDWARE TEST / 9V TO 12V RESET — SOFT-START HYPOTHESIS

- [TESTED] Hardware observation received: 5 V → 9 V passes; 9 V → 12 V causes immediate restart.
- [USER REQUIREMENT] User proposed Peltier soft-start as a possible cause and requested a Gemini second opinion.
- [CONFIRMED] `completeVoltageTransition()` commits the physical selector first, then for an upward transition while Peltier is ON calls `beginPeltierSoftStart()`.
- [CONFIRMED] `beginPeltierSoftStart()` starts from 0% duty; `processPeltierSoftStart()` increases duty cooperatively to 100% over 5000 ms.
- [HYPOTHESIS] The soft-start may still participate electrically because the Peltier control state changes immediately after the 12 V selector becomes active, but the source does not show an immediate 100% Peltier command.
- [OPEN QUESTION] Whether the actual reset is caused by the selector/power-stage transient or by the Peltier PWM/load interaction remains unresolved without controlled hardware isolation and reset evidence.
- [BLOCKED] No Gemini connector/tool is available in the current session; no external Gemini conclusion was obtained.
- No functional firmware change is authorized from this discussion alone.

## 2026-10-04 — V3.7 HARDWARE FAULT / GEMINI SECOND OPINION

- [TESTED] Hardware result received: 5V → 9V passes; 9V → 12V restarts the MCU.
- [CONFIRMED] Gemini's relay answer was compared with the actual V3.7 source.
- [CONFIRMED] Current `requestVoltage()` disables both 9V and 12V selector outputs but leaves the Peltier PWM at its prior duty during the 200ms deadtime.
- [CONFIRMED] Current `completeVoltageTransition()` then enables the target selector and invokes `beginPeltierSoftStart()` only after the target selector is already active.
- [ACCEPTED] The ordering creates a real risk window: if Peltier PWM is still high when 12V becomes active, the load sees the new 12V rail before the intended soft-start reset is applied.
- [ACCEPTED] Recommended architecture: **Peltier PWM pre-clear → 200ms selector deadtime → target selector ON → rail stabilization timer → restart 5s Peltier soft-start**.
- [REJECTED] Extending the 200ms selector deadtime alone is not considered a sufficient fix because the load can remain active during the deadtime and the underlying ordering hazard remains.
- [REJECTED] The 5s soft-start duration is not currently considered the root problem; retain it unless controlled testing proves otherwise.
- [HYPOTHESIS] The immediate MCU reset is most consistent with an electrical transient/load event such as supply droop or EMI, but the exact mechanism remains unverified.
- [OPEN QUESTION] Need controlled comparison with Peltier OFF/ON and reset-reason/rail evidence before declaring brownout as root cause.

## 2026-10-04 — DISCUSSION / SOFT-START ONLY ON PELTIER ON

- [USER REQUIREMENT] User wants the 5s Peltier soft-start to activate only when Peltier transitions from OFF → ON.
- [CONFIRMED] Current V3.7 additionally restarts the soft-start on every upward voltage transition while Peltier is ON.
- [DECISION CANDIDATE] Remove the upward-voltage soft-start trigger while retaining the OFF → ON soft-start in `applyCoolingOutputs()`.
- [PRESERVE] Keep Peltier PWM frequency/resolution, 5s ramp duration, safety interlocks, and logical BLE FAN/PELTIER commands unchanged.
- [IMPORTANT] A voltage transition must not artificially create a Peltier OFF → ON edge merely to obtain soft-start; normal voltage switching should preserve the current Peltier state.
- [UNVERIFIED] This is a functional change proposal only. No firmware source has been modified in this discussion and no new binary/device test exists yet.



## 2026-10-04 — FIRMWARE V3.8 / SOFT-START SCOPE FIX

- [IMPLEMENTED] Firmware advanced V3.7 → V3.8.
- [IMPLEMENTED] `beginPeltierSoftStart()` is now reached from the genuine Peltier OFF → ON path in `applyCoolingOutputs()` only.
- [IMPLEMENTED] The V3.7 upward-voltage restart path was removed from `completeVoltageTransition()`.
- [PRESERVE] Voltage transitions preserve the current Peltier PWM state; 5 s soft-start remains unchanged for Peltier turn-on.
- [PRESERVE] BLE/P1, GPIO mapping, PWM frequencies, NTC/safety, Adaptive, OTA, and non-blocking timing architecture are unchanged.
- [VALIDATION] Static source audit completed after implementation. ArduinoDroid/Core 3.3.7 compile, BIN publication, Firebase promotion, and physical validation remain pending.

## 2026-10-04 — V3.8 IMPLEMENTATION / AUDIT CHECKPOINT

- [COMMITTED] Active source: `firmware/JEXFYZ-V3.8.ino`; source blob `2fbff3656bc037846124806fb390022f85146845`.
- [COMMITTED] Repository HEAD: `dbe9ac209ad0b9ca1f68ae50d65f8e7838245d22`.
- [VERIFIED] Voltage changes no longer call `beginPeltierSoftStart()`; the only runtime trigger is the genuine Peltier OFF → ON path in `applyCoolingOutputs()`.
- [VERIFIED] Peltier soft-start remains 20 kHz / 8-bit over 5 s.
- [VERIFIED] Active source has balanced braces/parentheses (549/549 and 2039/2039) and no executable `delay()` or timing-wait `while()`.
- [UNVERIFIED] ArduinoDroid/Core 3.3.7 compile, BIN generation/publication, Firebase promotion, and physical device behavior remain pending.

## 2026-10-04 — FINAL V3.8 EXECUTION PERSISTENCE

- [COMMITTED] Final repository HEAD: `88e7a281bf9d35c62f3e8774b73ecaf84e92993f`.
- [COMMITTED] Active firmware source: `firmware/JEXFYZ-V3.8.ino`; source blob: `2fbff3656bc037846124806fb390022f85146845`.
- [VERIFIED] V3.8 soft-start trigger is limited to Peltier OFF → ON; no voltage-rise soft-start trigger remains.
- [VERIFIED] V3.8 preserves 20 kHz / 8-bit Peltier PWM and 5 s soft-start duration.
- [VERIFIED] App functional source and App build workflows remain unchanged; App Build #50 remains the latest verified App artifact.
- [NO BUILD] No App Build or firmware compile/BIN/Firebase promotion was performed.
- [UNVERIFIED] Physical V3.8 hardware behavior remains to be retested, especially 9V → 12V with Peltier ON.

## 2026-10-04 — V3.8 ONLINE OTA STALL / ROOT CAUSE FOUND

- [TESTED] User-observed Online OTA sequence is BLUE → GREEN → prolonged stall with no LED.
- [VERIFIED] BLUE is the Wi-Fi-connected result indicator; its next action is `PREPARE_DOWNLOAD`.
- [VERIFIED] GREEN is the GitHub-connected result indicator; its next action is `DOWNLOAD`.
- [VERIFIED] In `processOnlineOta()`, the DOWNLOAD state is currently guarded by `if (!onlineUpdateStarted)`.
- [VERIFIED] `performOnlineOtaDownload()` sets `onlineUpdateStarted = true` immediately after `Update.begin()`. On the next cooperative loop pass, the DOWNLOAD state therefore stops calling the function, even when the firmware stream is far from complete.
- [VERIFIED] Download progress indicators are only generated when `onlineUpdateProgress()` reaches the 20/40/60/80/100% milestones. A stalled first chunk below 20% therefore leaves the LED OFF.
- [ACCEPTED] This is a deterministic source-level state-machine bug and explains the exact BLUE → GREEN → no-indicator symptom.
- [DECISION] Preserve the non-blocking bounded-chunk architecture and fix the DOWNLOAD state to service the active download repeatedly until completion/failure.
- [PRESERVE] OTA validation, image magic check, Update.write(), Update.end(), failure recovery, and LED ownership architecture should remain intact.
- [NO APP BUILD] No App source change is involved.

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

[DISCUSSION ONLY] Gemini's raw independent V3.8 audit was compared against current source blob `2fbff3656bc037846124806fb390022f85146845`.

[CONFIRMED]
- Online OTA DOWNLOAD dispatcher starvation.
- NTC deadtime validity race before selector activation.
- Peltier ON can interleave with active voltage transition.
- Wi-Fi retry can skip radio-off settle.
- ADAPTIVE:OFF ACK can report success after safe-5V force failure.
- Battery Adaptive has no hysteresis.
- Rapid Hotside dT/dt protection required by the project is absent.
- Online OTA uses synchronous HTTP GET.
- Online OTA TLS verification is disabled by `setInsecure()`.
- OTA version check is syntax-only; no anti-rollback.
- BLE control channel has no cryptographic authentication.

[CONFIRMED SAFETY GAP / NOT PROVEN ROOT CAUSE]
- Voltage transition does not explicitly clear Peltier PWM before selector handoff. This is a real sequencing hazard and remains a leading hypothesis for the 9V->12V restart, but brownout/LDO/EMI/current causality is not source-proven.

[CORRECTED SEVERITY]
- BLE disconnect callback advertising restart is P2 callback-context/reentrancy risk unless exact Core 3.3.7 behavior proves otherwise.
- BLE/Wi-Fi handoff is a confirmed project-contract violation because OTA calls `stopBleRadio(false)`; physical restart causality remains unverified.
- Reset-reason implementation remains a validation item: upstream Arduino-ESP32 exposes `esp_reset_reason()` in examples, but the user's exact ArduinoDroid/Core 3.3.7 build must be compile-verified before source changes.

[FROZEN CONTRACT]
- Peltier 5s soft-start remains **ONLY logical OFF -> ON**.
- Voltage changes must **NOT** restart the 5s soft-start.
- Any electrical hardening around voltage switching must preserve that contract and may introduce a separate transient-suppression mechanism only if its semantics are explicitly defined.

[NEXT SOURCE WORK]
A full hardening pass must address the confirmed sequencing/OTA/safety items before hardware validation.

## 2026-10-04 — V3.9 FULL HARDENING EXECUTION
- Active source: `firmware/JEXFYZ-V3.9.ino` blob `bf85b50e0a8cab22e5d66ef09ee84d6692cee009`.
- Implemented: OTA stream continuation, full BLE teardown for Online OTA, Wi-Fi retry settle, physical Peltier PWM suppression across selector deadtime, manual Peltier transition interlock, final NTC gate, rapid Hotside rise latch, Battery hysteresis, ADAPTIVE:OFF ACK correction, main-loop BLE advertising recovery, numeric anti-rollback, reset reason telemetry, Local OTA magic byte validation, TX overflow counter.
- Preserved: GPIO5=Peltier, GPIO6=Fan; 200 ms selector deadtime; 1 s voltage guard; OFF -> ON-only soft-start semantics; no executable delay/wait loops.
- Remaining open: CA/server verification instead of `setInsecure()`; BLE cryptographic auth; strict non-blocking HTTP transport; post-boot rollback health.
- Validation boundary: source/static audit only; no ArduinoDroid/Core 3.3.7 compile, BIN, Firebase, or hardware validation yet.


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


## 2026-10-04 — DISCUSSION / V3.9 UPDATE READINESS CHECK

- [VERIFIED] Current V3.9 source remains unready for firmware update/flash.
- [P0] `completeVoltageTransition()` still commits the 9V/12V selector and then calls `applyCoolingOutputs()` without a dedicated post-selector rail-settling state. Logical Peltier ON can therefore transition back to full physical duty immediately after selector activation.
- [P1] `prepareOnlineOtaDownload()` still uses `cloudClient.setInsecure()`; production Online OTA server authentication remains unresolved.
- [CONFIRMED] The previous assistant + user-mediated Gemini dual audit remains NOT SAFE TO FLASH for this candidate.
- [DECISION] Keep the update/flash gate CLOSED until P0/P1 are fixed and the same two-party audit passes.
- [NO SOURCE CHANGE] Discussion-only event; no firmware/App/build/release change performed.
