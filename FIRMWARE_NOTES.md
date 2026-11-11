# JE X FYZ / JE Cooler — Firmware & Hardware Contract

Durable hardware/user requirements live here. The source-level architecture and implementation reference is firmware/FIRMWARE_TECHNICAL_REFERENCE.md. Protected OTA details are in OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md; voltage incidents/transition sequencing live in VOLTAGE_TRANSITION_MEMORY.md.

## Production baseline and evidence

- Owner reports the sold/shipped unit uses App Build #124 and Firmware V7.1, compiled and updated through Online OTA. This is USER-REPORTED.
- The App package is independently evidenced by Actions run 39386733061, packaged source 7d4e7262c6a3474eefa8ccb58b08f070df3ac15a. This does not independently verify Firmware compilation, source-to-BIN identity, installed version, physical OTA/reboot, BLE recovery or electrical/thermal behavior.
- Active editable Firmware source: firmware/JEXFYZ-V7.1.ino; FW_VERSION="V7.1"; current blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- The unit is not available for routine physical repair. Avoid discretionary release/update risk.

## BLE authorization — BLOCKED / NOT IMPLEMENTED

- Desired daily UX: power on cooler → open JE Cooler → Connect BLE → use it. No QR, no extra Touch gesture; preserve existing gestures.
- RX writes are encrypted/bonded, but pairing uses Just Works and SYNC_READY opens the command gate. This does not prove official App identity or block nRF Connect/manual command writing.
- Do not accept a key from any first-connected client. A trusted backend, device-bound enrollment grant, per-install App signing key, firmware-pinned trust anchor and fresh nonce/signature session verification are required. See BLE_APP_AUTH.md.
- OTA and hardware safety remain independent of App authorization.

## Hardware and pinout

- MCU: ESP32-C3 Super Mini / ESP32-C3 Dev Module; assume a 3.3 V logic/ADC reference.
- GPIO 0: Hotside NTC ADC. GPIO 1: TTP223 Touch. GPIO 3: 12 V selector. GPIO 4: 9 V selector. GPIO 5: Peltier MOSFET PWM. GPIO 6: Fan MOSFET PWM. GPIO 7: WS2812 LED.
- NTC model: nominal 10 kΩ at 25°C, 10 kΩ fixed divider and Beta 3950. Use calibrated analogReadMilliVolts(PIN_NTC), one reading per second.
- The owner explicitly rejected median, trimmed-mean and multi-sample NTC filtering. Do not add them without explicit approval.
- Invalid NTC/sensor state follows the existing fail-safe: Peltier OFF, Fan 100%, Adaptive OFF and safe 5 V.
- Wiring note: GPIO → R100 → MOSFET gate; 100 kΩ gate-source pull-down. Fan positive is supply-side (called "Decoy" in the wiring note); Fan negative goes to MOSFET drain. Verify physical wiring before diagnosing unexpected voltage/current.

## Output and timing invariants

- Peltier PWM: 20 kHz, 8-bit; normal OFF→ON ramp is 5 seconds.
- Fan PWM: 25 kHz, 8-bit; Manual Fan target 50–100%; cooling/safety may force 100%.
- Selector break-before-make: 200 ms. Shared voltage settle/guard: 1 second.
- Adaptive upward voltage steps use a 5-second non-blocking dwell after each completed increase. Downward steps are immediate unless the active safety transition says otherwise.
- Use cooperative millis() timing. No executable delay() or timing while() loops.
- Every functional Firmware change increments FW_VERSION and renames the active sketch to match. Exactly one active versioned .ino may exist.
- Settings use a shared 10-second quiet-period debounce; write only changed persisted values. Adaptive Profile is runtime-only.

## Hotside / Adaptive safety

- Configurable Hotside limit is 40–50°C, default 45°C. At or above the limit, the current safety supervisor immediately forces Fan 100% and shuts Peltier OFF.
- Manual Peltier safety latch re-arms only after Hotside remains at or below hotLimit − 1°C for five continuous seconds. One low sample must not bypass this condition.
- Adaptive thermal handling allows a 30-second recovery stage at each rail (12 V, 9 V, 5 V), Peltier OFF and Fan 100%. Five continuous seconds at/below hotLimit − 1°C before timeout cancels the stage where allowed; otherwise 12 V/9 V step down a rail, and unrecovered 5 V enters terminal lock requiring manual restart.
- After an Adaptive thermal downshift, recovery raises one rail at a time only after 60 seconds continuously at/below hotLimit − 1°C and never above the saved pre-downshift ceiling.
- HOTSIDE is the Adaptive startup default. HOTSIDE_BATTERY is runtime selectable, not persisted. If phone Battery data is stale/missing, control falls back to HOTSIDE without rewriting the selected profile.
- Adaptive Fan targets at 12 V use floored whole-degree temperature categories relative to the configured limit: delta ≤2°C→100%; 3–4°C→90%; 5–6°C→80%; 7–8°C→70%; 9–10°C→60%; ≥11°C→50%. At 40°C: 40/39/38→100%, 37/36→90%, 35/34→80%, 33/32→70%, 31/30→60%, ≤29→50%. Bands move with the configured limit.
- PWM moves in 10-point increments: up every 1 second and down every 10 seconds. Direction changes start a fresh clock. Adaptive 5 V/9 V remain at Fan 100%. Raw-decimal safety is independent of these target bands.
- RAPID HOTSIDE RISE / RATE-OF-RISE SHUTDOWN + MANUAL RE-ARM is a USER REQUIREMENT, still NOT IMPLEMENTED in V7.1. Do not imply Adaptive Fan trends or ordinary limit protection satisfy it. Any future implementation must be separately scoped, version-bumped and safety-tested.

## Touch, LEDs and durable indicator decisions

- TTP223 timings recorded by QC: about 1,000 ms startup grace, 30 ms qualification, valid raw HIGH tap 60–500 ms, double-tap window 800 ms and long press 5,000 ms. Verify live source before changing.
- Adaptive ON indication: three orange blinks; OFF indication: three white blinks, deferred until safe 5 V handoff completes when needed. The white OFF blink reportedly appeared missing immediately after restart; this remains USER-REPORTED / PHYSICALLY UNVERIFIED.
- Voltage LED defaults: 5 V red, 9 V green, 12 V blue; colors configurable.
- Decorative RGB IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7. ID 3 / Mirror Pulse is retired; invalid stored values migrate to Static and new MODE:3 commands are rejected.
- Firmware emits LED_SYNC:<mode>,<phase_ms>,<cycle_ms> atomically at BLE notification time. Safety/OTA indications outrank decorative animation.

### Owner-requested Touch Voltage cycle — pending implementation (2026-11-09)

**Owner requirement:** change the physical TTP223 **single-tap** Voltage selection from the current ping-pong sequence to a repeating one-way cycle:

`5V → 9V → 12V → 5V → 9V → 12V → ...`

- The existing V7.1 implementation currently ping-pongs `5V → 9V → 12V → 9V → 5V → ...` using `touchVoltageAscending`; this is verified in `firmware/JEXFYZ-V7.1.ino` at `executeTouchSingle()` and its global state declaration.
- Recommended implementation: calculate the next rail from authoritative `currentVoltage` only: `V5 → V9`, `V9 → V12`, `V12 → V5`. Remove the separate direction-memory variable when implementing so the next tap cannot retain a stale ascending/descending direction after another voltage-selection path.
- Derive every next step from actual current rail. If App/manual or another permitted path changes the actual rail, the next physical single tap continues from that rail rather than from an independent sequence index.
- A rejected/blocked voltage request must not advance an independent cycle state. Keep `requestVoltage()` as the sole request gate and preserve its OTA/transition/manual-source/1-second voltage guard/NTC/Hotside/adaptive-ceiling validations. Preserve the existing `TOUCH_VOLTAGE` ACK semantics.
- Scope is limited to a valid physical single tap while Adaptive is OFF. Touch single tap remains rejected while Adaptive is active. Double tap continues to toggle RGB; long press and its existing Adaptive-OFF/cooling behavior remain unchanged. Preserve startup grace, raw qualification, tap/double-tap/long-press timing and startup-held-touch suppression.
- Preserve the existing selector sequence and safety: 200 ms break-before-make, 1,000 ms settle/guard, Peltier active-soft-start pause/resume contract, completed-ramp continuity, Fan 100% handoff, NTC/Hotside/explicit-OFF/OTA override priority, and cooperative `millis()` timing. No executable `delay()` or timing `while()` loops.
- **Regression matrix:** from 5V expect 9V, then 12V, then 5V, then repeat; from 9V expect 12V; from 12V expect 5V; repeat after an App/manual Voltage change; rejected request leaves the actual-state-derived next target consistent; verify 12V→5V selector handoff; verify double tap and long press are unchanged; verify Adaptive/OTA/safety gates remain authoritative.
- **Combined V7.2 plan:** implement this Touch cycle together with the separately recorded persistent Lock Voltage 5V feature below, subject to a fresh live-version/source recheck at execution. Functional Firmware changes increment FW_VERSION and rename the single active sketch to firmware/JEXFYZ-V7.2.ino; set FW_VERSION="V7.2". Keep exactly one active versioned .ino.
- **Current status:** REQUEST RECORDED / NOT IMPLEMENTED. `firmware/JEXFYZ-V7.1.ino` remains current source (`FW_VERSION="V7.1"`). This Diskusi made documentation-only updates; no Firmware source/test edit, compilation, BIN, Firebase, OTA, flash or device operation occurred. Owner must issue a separate `Eksekusi Full!` for source/test implementation. Owner-side compilation remains separate with the approved Arduino-ESP32 Core 3.3.7 unless explicitly authorized otherwise.


### Owner-requested Lock Voltage 5V — persistent Firmware/App control (2026-11-11)

**Owner requirement:** add a Settings control named **Lock Voltage** that locks the cooler to the 5 V rail. While enabled, the App Voltage controls and Adaptive controls must visibly appear locked, and the physical Touch single-tap voltage selector must not raise the rail. The lock must survive cable/power removal and remain active until explicitly switched OFF from the App.

**Ownership and persistence**
- Firmware is the source of truth. Persist the boolean in the ESP32-C3 Preferences NVS namespace already opened as "jexfyz", using a short key such as "vLock5V" (within Preferences' 15-character key limit). Do not rely on Android SharedPreferences as the hardware lock.
- This setting must use immediate write-through, not the existing shared 10-second settings debounce. On an App toggle, call prefs.putBool("vLock5V", value) and verify success before acknowledging the persisted change. Preferences writes commit to NVS; NVS retains values over restarts and power loss. Reference: https://docs.espressif.com/projects/arduino-esp32/en/latest/api/preferences.html
- On boot, load the key before normal Touch/BLE command handling. Missing key on an upgraded V7.1 device defaults to false (unlocked), so the new feature does not unexpectedly lock existing units. If stored true, boot must remain at safe 5 V and never briefly expose a 9/12 V path before the lock is enforced.
- If an NVS write fails, do not report a persisted success. On failed OFF, keep the runtime lock ON (fail closed). On failed ON, report the persistence error explicitly and do not claim the lock survived reboot; the App must not silently display a successfully persisted lock. The implementation must define a safe current-session response and make retry possible.

**Lock behavior**
- ON means a hard 5 V rail ceiling, not merely a disabled App button. Enforce it centrally in Firmware's voltage request gate so every source—App/manual, physical Touch, Adaptive/Battery/other automatic rail request—cannot request 9 V or 12 V while locked. Safety and OTA paths retain priority and may still force/hold safe outputs; no existing safety override is weakened.
- Enabling while currently at 9 V or 12 V must disable Adaptive and request a safe handoff to 5 V through the existing selector transition pipeline. Do not switch GPIO selector pins directly. Preserve 200 ms break-before-make, 1 s settle/guard semantics, Fan 100% handoff, active Peltier soft-start pause/resume, completed-ramp continuity and all NTC/Hotside/OTA overrides.
- If Lock is enabled during an in-flight voltage transition, do not allow its pending 9/12 V target to complete. Revalidate/retarget the pending transition to 5 V at the existing safe transition boundary; do not abort the 200 ms deadtime or create overlapping transitions.
- Adaptive must be OFF while the lock is active. Reject every new ADAPTIVE:ON request with a lock-specific reason. When enabling the lock while Adaptive is already ON, exit Adaptive through its existing safe-5V handoff; wait for authoritative telemetry before the App presents completion.
- With Lock ON, a valid physical single tap is rejected and leaves the rail at 5 V. The earlier one-way cycle 5V → 9V → 12V → 5V applies only while Lock Voltage is OFF. Double tap RGB and long-press cooling behavior remain unchanged.
- When the App switches Lock OFF, persist false immediately and remove the rail ceiling. Do not automatically restore the previous 9/12 V rail or turn Adaptive ON. Stay at 5 V; the user must explicitly choose another rail or enable Adaptive afterward.
- Lock remains active after BLE disconnect, App close, charger/cooler unplug and reboot. Only an explicit App OFF command clears the stored flag; Touch gestures, BLE disconnect, restart and ordinary voltage commands cannot clear it.

**Proposed P1 contract (additive; preserve UUIDs/framing/session rules)**
- App command: VOLTAGE_LOCK:ON / VOLTAGE_LOCK:OFF.
- Firmware full sync and state updates: VOLTAGE_LOCK:ON|OFF (or equivalent explicit boolean key) so the App learns the persisted hardware state after reconnect/reboot. Include it in the initial full P1 sync; publish again after a successful change.
- A lock ON acknowledgement confirms the NVS setting was committed; rail completion remains a separate authoritative VOLTAGE:5V telemetry milestone. If the transition is pending, the UI shows "locking to 5 V" rather than falsely claiming the actual rail already changed.
- App UI adds a localized Settings toggle named Lock Voltage / Kunci Tegangan with clear "5 V only" persistence copy. It is interactive only after BLE/P1 session readiness and a known synchronized lock state. No local Android preference is authoritative.
- While confirmed ON, Voltage 9 V/12 V controls and all Adaptive controls (switch and profile selector) are disabled with a visible lock marker. The Home Voltage/Adaptive metrics continue to reflect real Firmware telemetry; add a lock indication without faking values. Peltier/Fan controls are not part of this lock and retain their existing safety rules.
- Before the first full sync or while disconnected, do not infer lock OFF from an App default/stale value. Keep relevant controls unavailable or mark state unknown until Firmware reports VOLTAGE_LOCK.
- Existing older App versions may still display 9/12 V buttons, but Firmware must reject the commands while locked. The updated App is needed for the correct lock presentation.

**LED rejection feedback**
- Every valid physical single Touch tap that Firmware refuses (Lock ON, Adaptive gate, active voltage transition or 1-second guard/busy rejection) should produce exactly two red flashes. A manual App voltage request specifically rejected by Lock ON should trigger the same feedback.
- Use a cooperative millis()-driven one-shot indicator; no delay() or timing while() loops. It must be independent of decorative RGB ON/OFF and respect master hardware brightness.
- LED arbitration must not overwrite OTA or Hotside/NTC safety indications. The red double-flash takes priority over ordinary decorative RGB and normal voltage-color indication. Repeated rejected taps must not corrupt the pattern state.
- The lock-specific command/Touch ACK reason must be explicit (for example VOLTAGE_LOCKED); do not represent a rejected command as a successful voltage change.

**Security and acceptance**
- Current BLE App-only identity is still BLOCKED / NOT IMPLEMENTED: bonded Just Works plus SYNC_READY does not prove that a command came from the official JE Cooler App. The normal App UI can own the intended unlock action, but strict cryptographic "only the official App can unlock" is not guaranteed until the separate BLE_APP_AUTH.md design is implemented. Do not claim otherwise.
- Regression matrix: NVS default OFF on V7.1→V7.2 upgrade; ON and OFF writes survive immediate unplug/reboot; NVS write failure behavior; reboot with lock ON starts/holds 5 V; enable from 9 V and 12 V with Peltier OFF, active soft-start and completed ramp; enable while Adaptive is ON; lock during a pending 9/12 V selector transition; reject App 9/12 V and Adaptive ON; reject Touch single tap with exactly two red flashes; allow Touch one-way cycle when unlocked; unlock from App only and remain at 5 V; preserve double tap, long press, Peltier/Fan, NTC/Hotside/OTA and BLE full-sync/reconnect behavior.
- **Version/scope:** combine this feature with the pending one-way Touch Voltage sequence in Firmware V7.2. The App Settings toggle, Voltage/Adaptive locked presentation and P1 parsing/synchronization are part of the same cross-layer feature scope. Source/tests are not implemented yet; V7.1 remains current. Arduino compile, BIN publication, Firebase, OTA, flashing and physical tests remain separate authorizations/evidence gates.


### Standalone Firmware timer — deferred by owner (2026-11-09)

- Owner initially asked about a Firmware timer, then explicitly said a separate timer is not needed for now and proposed an App **Usage Statistics / Statistik Penggunaan** page instead.
- Do not implement a standalone Firmware timer or add a Firmware timer telemetry protocol for this request. The current direction is App-only collection from existing phone Battery readings and Firmware Hotside / Voltage / Adaptive / Fan Speed telemetry.
- See `APP_NOTES.md` and `DESIGN_NOTES.md` for the Usage Statistics data model, chart hierarchy, local SQLite proposal, retention, gaps and acceptance criteria.
- The App can collect only when it receives valid telemetry in a synchronized BLE/P1 session. Disconnected/App-stopped periods must be shown as data gaps rather than inferred runtime.
- This deferral does not remove or modify the earlier independent Touch one-way Voltage cycle request. That remains pending and requires its own implementation scope.

## Telemetry and phone Battery

- Hotside telemetry is sent every second; other state should send only when changed.
- App physical state must follow authoritative Firmware telemetry, including hardware Touch actions. Do not treat command ACK alone as a confirmed physical state.
- App sends PHONE:BT=<Celsius> once per second while the BLE session is ready and coalesces pending heartbeats. Firmware considers phone Battery input stale after 5 seconds.
- Battery zone defaults: 5 V threshold 25°C, 12 V threshold 35°C, 0.5°C hysteresis. When data expires, HOTSIDE_BATTERY falls back to HOTSIDE behavior without silently changing the selected runtime profile.

## OTA boundary

- OTA is protected/frozen except for a demonstrated defect and explicit prior authorization. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before related source changes.
- ESP32-C3 has one radio path. Wi-Fi must be fully shut down and allowed to settle before BLE becomes active.
- Local OTA uses a 10-second no-client SoftAP window and a 60-second hard limit after interaction, with existing 160 ms radio-settle delay before BLE starts. Preserve exact source semantics and inspect live source before any authorized adjustment.
- Online OTA currently uses cloudClient.setInsecure(); TLS encrypts transport but does not authenticate server certificate identity. Preserve the raw GitHub BIN allowlist, redirect blocking, HTTP status/length/size/image checks, streaming Update lifecycle, safe outputs, recovery and restart contract.
- Firebase OTA metadata is version + link. Do not add custom Firmware hash/signature fields without explicit user approval.

## Evidence and incident routing

- The owner-reported compile/OTA result must remain distinct from independent BIN/device evidence.
- Two restart incidents were reported: (1) Manual 5 V→12 V while Peltier/Fan were ON and the 5-second ramp was active; (2) enabling Adaptive after 12 V + Peltier/Fan ON. Keep them separate; reset cause is not established, and brownout remains a hypothesis. See VOLTAGE_TRANSITION_MEMORY.md.
- Static test presence does not prove execution. The V7.1 contract tests are not independently run by this docs rework; there was no Firmware compile, BIN generation/publication, Firebase update, physical OTA, flash or device operation.
