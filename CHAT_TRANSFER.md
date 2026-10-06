# JE X FYZ — CHAT TRANSFER / NEW CHAT BOOT PROTOCOL

> **Transfer Protocol v2 — authoritative handover procedure for continuing the JE X FYZ / JE Cooler project across chats.**

## 0. READ FIRST — MANDATORY BOOT RULE

### CURRENT QC SNAPSHOT — 2026-10-06

- **Active Firmware:** V5.8 (`firmware/JEXFYZ-V5.8.ino`)
- **V5.7 physical evidence:** user-confirmed compile + hardware update success.
- **V5.8 status:** source fix implemented; compile/BIN/flash/physical regression is still unverified.
- **Open QC findings addressed:** Peltier lock did not release after Hotside cooldown; locked Peltier ON feedback was not observable; NTC was sampling 16 values instead of one value per second.
- **Exact fix:** effective lock releases at `hotLimit - 2°C`; blocked attempts keep red feedback; first successful post-safety ON keeps green feedback; NTC is one calibrated ADC read every 1 second.


This file exists so a new chat can continue the project **without making the user repeat established context**.

A new chat MUST:

1. Read this file before planning work.
2. Read the current repository state before trusting cached transfer facts.
3. Reconcile the transfer snapshot against the current `main` branch.
4. Treat current source/configuration as authoritative over historical notes.
5. Treat historical sections as history only; never reuse an obsolete version or behavior as current.
6. Never ask the user to restate information already available here or in the authoritative repository files.
7. Never perform a functional source change merely because a chat was transferred.
8. Never run App Build merely because a chat was transferred.
9. Never claim compile, flash, runtime, OTA, or release PASS without matching evidence.
10. Continue from the current QC gate and user command, not from an old development snapshot.

### Anti-repetition rule

Before asking the user a clarification question, the new chat MUST first check:

- this file;
- PROJECT_STATE.md;
- HANDOVER.md;
- the relevant authoritative notes;
- the current source/configuration in the repository.

Ask only when the information is genuinely missing, contradictory, or requires a new decision.

---

## 1. PROJECT IDENTITY

### PERSISTENT

- Project: **JE X FYZ**
- App name: **JE Cooler**
- App header/branding: **JE X FYZ**
- App repository: **TenzoNkz/JEXFYZ-App**
- Branch: **main**
- Hardware target: **ESP32-C3 Super Mini / ESP32-C3 Dev Module**
- Firmware source authority: `firmware/` inside JEXFYZ-App
- Firmware binary/publishing repository: **TenzoNkz/JEXFYZ-Firmware**
- Current Firmware: **V5.8**
- Current App version: **1.0.0+3**
- Android package: **com.horizontalzzz.jexfyz**
- Current phase: **V5.8 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**
- Release status: **NOT RELEASED**

### Current repository evidence at this transfer

- main HEAD at transfer pre-write: `c7faf134742fc6fdbebc3f66469c8aa5dd9980c6`
- Active Firmware source: `firmware/JEXFYZ-V5.8.ino`
- Active Firmware source blob: `a7729d92fb4adf382c492ab82034ff1ec9b8386b`
- App main source blob: `48406cda017be1ce939ff682497324bf3680a7f3`
- App settings source blob: `f11235bab559b291928550e06984532581ddad6a`
- App regression-test source blob: `1951964af7542324b2ae27b1bd94f84e1c853060`
- Active App Build workflow: `.github/workflows/jexfyz-app-build-trigger.yml`
- App Build workflow blob: `51a6c4d35580228ae24f859058ae5b08665d94a0`

### Firmware published-output evidence

- Firmware publishing repository: **TenzoNkz/JEXFYZ-Firmware**
- Published file: `JEXFYZ.cpp.bin`
- Current BIN blob: `668aa6bcdec3cca72c4893bc82745598c7e71e5a`
- Current BIN size: **1,452,496 bytes**
- Current publishing-repo commit: `25e9fd02d0d949d753b6b5560f8dd543d5197f2a`
- Approved raw OTA URL:
  `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin`
- The published BIN record alone does **not** independently prove the embedded firmware version; the hardware V5.7 state is user-confirmed.

---

## 2. AUTHORITY HIERARCHY

When information conflicts, use this order:

1. **Current Firmware/App source and current workflow/configuration**
2. **PROJECT_STATE.md**
3. **Authoritative current engineering notes**
4. **CHAT_RULES.md / current HANDOVER.md / CHANGELOG.md**
5. **CHAT_TRANSFER.md**
6. **Current chat statements**
7. **Old chat/history**

Important:

- Current repository state wins over stale documentation.
- A historical version number must never override the active source filename/version.
- `CHAT_TRANSFER.md` is a transfer protocol/snapshot, **not the final source of truth**.
- Historical material is evidence of what happened, not permission to restore old behavior.
- When a conflict is found, record the discrepancy instead of silently guessing.

---

## 3. USER COMMAND PROTOCOL

The user uses these commands as project control modes.

### `@Thinking Diskusi!`
Discussion/review only.

Allowed:
- analyze architecture;
- compare alternatives;
- identify risks;
- propose changes;
- audit logic conceptually.

Not allowed:
- functional source edits;
- commits/releases;
- App Build;
- silently changing repository state.

### `@Thinking Tanya Gemini!`
Diagnosis/patch-request mode.

Expected:
- identify the suspected root cause;
- provide exact **OLD → NEW** patches;
- keep the scope tightly limited;
- do not silently execute the patch.

### `@Thinking Eksekusi!`
Implement the **approved scope**.

Required:
- implement only the approved change;
- audit affected behavior;
- synchronize persistent project memory/docs when appropriate;
- commit the result;
- do not trigger App Build unless separately commanded.

### `@Thinking Eksekusi Full!`
Full engineering execution for the approved scope.

Required:
- implement;
- perform broad affected-scope audit;
- verify no unrelated behavior was changed;
- synchronize persistent documentation/state;
- commit;
- clearly separate verified / unverified results.

**App Build is NOT implied.**

### `@Thinking Build App!`
Explicit App Build operation.

Required:
- use the existing manual issue-trigger workflow;
- no firmware implementation is implied;
- produce the configured production APK pipeline result;
- report actual run/release evidence.

### `@Thinking Eksekusi & Build App!`
Combined sequence:

**implement → audit → documentation sync → commit → explicit App Build**

No step should be assumed skipped.

---

## 4. CURRENT PROJECT MODE: QC / PRE-RELEASE

The project is **not in unrestricted feature-development mode**.

### QC source-freeze policy

Functional source is treated as **FROZEN** during QC.

A functional change is justified only when:

- the QC failure is real/reproducible or clearly proven from source;
- the root cause is identified;
- the defect is relevant to the current release gate;
- the fix is narrowly scoped;
- the affected behavior is re-audited.

Do NOT:
- add unrelated features;
- refactor stable paths without necessity;
- redesign the App Build workflow;
- redesign BLE without a demonstrated defect;
- alter OTA merely for cleanup/optimization;
- convert a hypothesis into a fact.

---

## 5. HARDWARE CONTRACT — FROZEN

### Target
- ESP32-C3 Super Mini.
- Single-radio limitation: Wi-Fi and BLE must not own the radio concurrently.

### GPIO mapping

| Function | GPIO |
|---|---:|
| NTC Hotside | 0 |
| TTP223 Touch | 1 |
| 12V selector | 3 |
| 9V selector | 4 |
| Peltier | 5 |
| Fan | 6 |
| WS2812 | 7 |

### Touch hardware behavior

- TTP223 is direct Active-High.
- Single tap: `5V → 9V → 12V → 9V → 5V → ...`
- Double tap: RGB control.
- Long press: 5 seconds.
- Hardware cooling ON forces Fan to 100%.

### Power/output timing

- Fan PWM: **25 kHz, 8-bit, 50–100%**.
- Peltier PWM: **20 kHz, 8-bit**.
- Peltier OFF → ON: **5-second cooperative soft-start**, then 100%.
- Selector deadtime: **200 ms break-before-make**.
- Voltage guard: **1 second after completed transition**.
- Voltage transitions preserve the existing Peltier PWM/logical state; normal selector changes do not arbitrarily force Peltier OFF.
- Fan is forced to 100% during voltage transition and outside the editable 12V manual condition.

### NTC hardware model

- Nominal NTC: **10K**.
- Fixed resistor: **10K**.
- Beta: **3950**.
- GPIO0.
- 12-bit ADC.
- 11 dB attenuation.
- Existing design uses the 3.3 V reference calculation.
- Hotside sample cadence: **1 second**.
- Current filter: **16 calibrated ADC samples**, sort, discard **4 lowest + 4 highest**, average the remaining **8**.
- No EMA/Kalman filter.
- No speculative VREF change.
- No voltage clamp.
- No offset calibration.

---

## 6. FIRMWARE V5.7 CONTRACT — FROZEN

### Core/runtime

- Arduino Standard.
- Arduino-ESP32 Core **3.3.7**.
- Main loop is cooperative.
- Timed work uses `millis()`.
- **No executable `delay()`.**
- **No timing `while()` loops.**

### Thermal authority

Hotside NTC is the universal thermal safety input.

- Hotside limit range: **40–50°C**.
- Default limit: **45°C**.
- Firmware remains the physical-state and safety authority.
- App telemetry reconciles to firmware; App does not own physical truth.

### Hotside safety

Adaptive Hotside safety sequence:

- At 12V limit:
  - Fan remains ON at 100%;
  - Peltier OFF;
  - hold **10 seconds**;
  - then step to 9V.
- At 9V limit:
  - Fan remains ON at 100%;
  - Peltier OFF;
  - hold **10 seconds**;
  - then step to 5V.
- At 5V:
  - terminal protection state;
  - Peltier remains OFF;
  - Adaptive exits;
  - manual Peltier restart is required after thermal re-arm.
- During every 10-second Hotside dwell:
  - **9 seconds red blink**;
  - **final 1 second green blink**.
- After a HOTSTEP, Fan remains ON at 100% while Hotside protection is still active.
- Manual-mode Hotside protection preserves the selected voltage rather than forcing an unrelated voltage change.

### Adaptive profiles

Both profiles are protected by the same timing contract:

- `HOTSIDE`
- `HOTSIDE_BATTERY`

For both:
- upward voltage changes wait **5 seconds after each completed upward voltage step**;
- Adaptive startup from the mandatory safe 5V state also begins the same 5-second upward dwell before increasing;
- downward changes remain immediate;
- failed upward requests re-arm the wait;
- Hotside fallback uses the cooperative upward-rise timing.

This is a **Firmware scheduling/state-machine rule**, not an App UI delay.

### Peltier safety latch

- Hotside safety-forced Peltier OFF activates the existing safety latch.
- Re-arm requires Hotside **≤ `hotLimit - 2°C`**.
- Normal Peltier ON/OFF does **not** use green/red feedback.
- While the safety latch is active:
  - blocked ON attempt → **red blink 1 second**;
  - successful re-arm ON → **green blink 1 second**, then latch clears.
- Adaptive start cannot bypass an active safety latch.
- Hotside dwell LED keeps priority over the short Peltier re-arm indicator.

### NTC fault

If NTC fault is detected:
- Fan 100%;
- Peltier OFF;
- Adaptive OFF;
- safe 5V.

### Rapid rise protection

`RAPID_HOTSIDE_RISE` and rapid Hotside slope protection are **obsolete and absent**.

Do not reintroduce them without a separately approved new requirement.

---

## 7. V5.7 TTP223 TOUCH FSM — FROZEN

Current parameters:

- `STARTUP_GRACE_MS = 1000`
- `QUALIFICATION_MS = 30`
- `MIN_TAP_PRESS_MS = 60`
- `TAP_MAX_PRESS_MS = 500`
- `DOUBLE_TAP_WINDOW_MS = 800`
- `LONG_PRESS_MS = 5000`

Behavior:

- raw GPIO is qualified for stable PRESS/RELEASE before gesture processing;
- valid tap duration uses raw HIGH duration;
- first valid tap starts the double-tap decision window at release;
- second tap that starts before the deadline is allowed to release slightly after it;
- 3+ taps in one sequence cancel the sequence without Voltage/RGB execution;
- boot-time touch is ignored during startup grace;
- a touch held at boot must be released before a new gesture is accepted;
- existing 1x Voltage, 2x RGB, 5s long press semantics remain unchanged.

Latest V5.7 Touch FSM correction commit:
- `77591d7406aa8613a3dc9beb33828af5a592d8d5`

V5.7 promotion commit:
- `d2ec5d56383f25a105835b10698f62cf19cbf5df`

---

## 8. APP CONTRACT — FROZEN

### Identity

- App: JE Cooler.
- Header: JE X FYZ.
- Package: `com.horizontalzzz.jexfyz`.
- Version: `1.0.0+3`.

### Control contracts

- Manual voltage values: **5V / 9V / 12V**.
- Fan Speed editable only in **Manual + 12V**.
- Fan Speed range: **50–100%**, current UI increments in configured discrete steps.
- Adaptive Fan Speed control is locked.
- Adaptive + 12V Home Fan Speed displays **100%**.
- Manual + 12V displays firmware-reported configured speed.
- App Safety popup queues:
  - `FAN:ON`
  - `PELTIER:ON`
  back-to-back; there is no App-side confirmation wait between them.
- Firmware owns the actual 5-second Peltier soft-start.

### Temperature settings

- Hotside limit: **40–50°C**, default **45°C**.
- Battery 5V target range: **20–30°C**.
- Battery 12V target range: **30–40°C**.
- Firmware remains the authoritative runtime state.

### Notify / safety presentation

- Re-arm temperature shown as dynamic `hotLimit - 2°C`.
- Touch ON/OFF ACKs are treated as valid outcomes.
- Retired `RAPID_HOTSIDE_RISE` presentation is removed.
- Duplicate generic Peltier failures are suppressed when firmware provides the safety reason.
- App must not treat a BLE write as proof that hardware has physically changed.

### Persistence

- Settings are persisted after the established no-change interval.
- Changed settings are not unnecessarily spammed.
- User requested separate reset controls for separate functions rather than a global reset.

---

## 9. BLE / P1 CONTRACT — FROZEN

BLE stack currently uses Arduino BLE:

- `BLEDevice.h`
- `BLEServer.h`
- `BLEUtils.h`
- `BLE2902.h`

Device name:
- **JE X FYZ**

UUIDs:

- Service: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`
- RX: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`
- TX: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`

Current protocol/transport facts:

- MTU target: 247.
- TX queue: 48 String entries.
- RX ring: 8 × 512 buffers.
- TX notify pacing: 15 ms.
- BLE retry: every 750 ms, max 8 attempts.
- Sync gate uses `SYNC` / `SYNC_READY`.
- Full sync includes state/version/protocol/session, cooling state, voltage, temperatures, adaptive state, RGB, fan speed, safety, OTA state/progress/errors, BLE diagnostics, reset reason, and temperature configuration.
- App uses flutter_blue_plus.
- Floating Monitor does not create a second BLE client.
- One GATT session is the intended App architecture.

BLE policy:

- Do not migrate to NimBLE merely for cleanup.
- Do not redesign BLE without a demonstrated defect.
- A disconnect must allow normal BLE recovery without requiring a manual firmware restart.
- Wi-Fi and BLE cannot concurrently own the ESP32-C3 single radio.

Known non-blocking future improvement ideas are not current tasks:
- TX priority/coalescing;
- RX drop diagnostics;
- indefinite recovery retry rather than finite retry window.

---

## 10. OTA CONTRACT — PROTECTED / FROZEN

Read **OTA_PROTECTION.md** before touching OTA.

Protected areas:

- Local OTA;
- Online OTA;
- OTA state machine;
- OTA priority/lifecycle;
- Wi-Fi ↔ BLE radio handoff;
- OTA recovery;
- OTA safety output;
- timeout/retry logic;
- image validation;
- firmware OTA URL/path contract;
- App OTA version-selection contract.

Rules:

1. Do not refactor/optimize OTA while working on unrelated functionality.
2. Change OTA only when a real OTA bug is demonstrated.
3. Root cause must be clear.
4. Change must be explicitly discussed/approved.
5. After an OTA change, perform a full OTA re-audit.

### Version policy

**ANTI-DOWNGRADE = OFF.**

Any valid firmware version that is **different** from the device version may be installed.

Examples:
- V5.7 → V5.8 ✅
- V5.7 → V5.6 ✅
- V5.7 → V6.0 ✅
- V5.7 → V5.7 ❌ unnecessary update

Do not add downgrade blocking.

### Radio ownership

- Wi-Fi OTA gets radio ownership.
- BLE must not remain active concurrently.
- Online OTA explicitly tears down GATT/BLE before Wi-Fi ownership.
- After OTA failure/recovery, BLE must be restored as designed.

### OTA current evidence

- OTA protection reminder file: `OTA_PROTECTION.md`
- Documentation-only; it is **not cryptographic signing** and **not CI enforcement**.
- User-confirmed: V5.7 OTA successfully reached the physical hardware and the device is running V5.7.
- Full V5.7 OTA regression is still a QC gate.

---

## 11. FIREBASE / OTA METADATA CONTRACT

Firmware metadata uses:

- firmware version;
- firmware URL.

**SHA is intentionally NOT required for Firebase firmware linking.**

Firebase metadata endpoint currently documented:
`https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`

Approved BIN host/path:
- raw GitHub;
- repository: `TenzoNkz/JEXFYZ-Firmware`;
- endpoint must be a `.bin`.

The App uses its established OTA version-selection contract:
- any valid **different** firmware version may be selected;
- same version does not require an update;
- anti-downgrade is OFF.

---

## 12. ANDROID / SECURITY / APP BUILD CONTRACT

### Android host

- compileSdk: **37**
- targetSdk: **36**
- minSdk: **24**
- package: `com.horizontalzzz.jexfyz`

App security/storage references include:
- Firebase App Check / Android Play Integrity;
- flutter_secure_storage for protected Wi-Fi credentials.

### App Build workflow

Authoritative workflow:
`.github/workflows/jexfyz-app-build-trigger.yml`

Trigger:
- GitHub Issues;
- opened/reopened only;
- repository owner;
- exact title:
  **JE X FYZ — BUILD APP TRIGGER**
- required body token:
  **JEXFYZ_BUILD_TRIGGER_V1**

Build policy:
- manual-by-issue only;
- normal push/PR must NOT create a release APK;
- one normal APK, not a Play Store bundle;
- production signing required;
- obfuscation required;
- delivery through GitHub Release;
- no Actions artifact delivery;
- published asset name:
  **JEXFYZ-release.apk**

Toolchain configured by the workflow:
- ubuntu-24.04
- Java 17
- Flutter 3.47.2 stable
- Gradle 9.3.1

A Firmware-only execution does not automatically require App Build.

---

## 13. CURRENT SOURCE / COMMIT MAP

### Active Firmware

- Version: **V5.7**
- Path: `firmware/JEXFYZ-V5.7.ino`
- Blob: `652e54afdd9c7c347cd82072f573f1729c4b46de`
- V5.7 promotion: `d2ec5d56383f25a105835b10698f62cf19cbf5df`
- V5.7 Touch FSM correction: `77591d7406aa8613a3dc9beb33828af5a592d8d5`

### Active App

- Main: `lib/main.dart`
- Main blob: `48406cda017be1ce939ff682497324bf3680a7f3`
- Settings: `lib/app_settings.dart`
- Settings blob: `f11235bab559b291928550e06984532581ddad6a`
- Regression test source blob: `1951964af7542324b2ae27b1bd94f84e1c853060`

### Active App CI

- Workflow: `.github/workflows/jexfyz-app-build-trigger.yml`
- Blob: `51a6c4d35580228ae24f859058ae5b08665d94a0`

### Current main

- Pre-transfer HEAD: `c7faf134742fc6fdbebc3f66469c8aa5dd9980c6`
- The transfer write itself is documentation-only.

---

## 14. CURRENT QC STATUS

### VERIFIED

- Active source is V5.7.
- V5.7 source/static contract is present in the repository.
- V5.7 Touch FSM correction is committed.
- V5.7 OTA update reached the physical hardware.
- User-confirmed device state: hardware is running V5.7.
- OTA protection reminder exists and is documentation-only.
- App Build workflow is manual issue-triggered and separate.
- Current source/workflow were re-read against `main` during this transfer.

### UNVERIFIED / PENDING

- V5.7 Arduino compile in the intended Arduino-ESP32 3.3.7 environment.
- V5.7 BIN generation from the active source.
- Independent V5.7 flash validation.
- Full physical Touch regression.
- Full Hotside/NTC thermal regression.
- Both Adaptive profiles' 5-second upward dwell on physical hardware.
- 10-second Hotside dwell + Fan 100% + 9s red/1s green LED behavior on hardware.
- Peltier safety latch/re-arm runtime.
- Local OTA regression on the final V5.7 image.
- Online OTA + BLE recovery regression on the final V5.7 image.
- Full App ↔ V5.7 integration regression.
- Final Release Gate.

### Build evidence caveat

Repository documentation contains conflicting historical App Build records. Do **not** silently choose one as canonical.

Currently documented records include:
- PROJECT_STATE: run `37261171475`, release `jexfyz-latest`, APK SHA-256 `b8045d0b6fa6d05b421bd6b1c0318d4ee4529734d7b471534700f95676200888`;
- APP_NOTES / older records contain other run IDs/digests.

This transfer intentionally preserves that as an **unresolved evidence discrepancy** until a current Actions/Release verification is performed.

---

## 15. CURRENT RISKS

- V5.7 physical behavior is not yet fully regression-tested.
- Final compile/BIN/flash provenance for V5.7 is not yet independently recorded here.
- OTA final-image regression remains pending even though V5.7 successfully reached hardware once.
- App ↔ V5.7 physical integration remains pending.
- Historical App Build evidence is not fully reconciled.
- Documentation outside this transfer file may still contain historical statements; use the authority hierarchy and current source to reconcile them.
- Release must remain blocked until the QC gates are actually completed.

---

## 16. RESOLVED / OBSOLETE — DO NOT REUSE AS CURRENT

The following are historical only:

- V4.6, V4.7, V4.8, V4.9, V5.0, V5.1, V5.2, V5.3, V5.4, V5.5, V5.6 active-source states.
- App-side fixed 2-second Fan precharge before Peltier ON.
- Rapid Hotside-rise/slope protection.
- `RAPID_HOTSIDE_RISE` notification.
- Concurrent Wi-Fi + BLE radio ownership.
- Any rule that treats the 5-second Adaptive dwell as applying to only one profile.
- Any anti-downgrade implementation.
- Any App Build triggered automatically by push/PR.
- The temporary CI-based OTA Security Seal experiment and its removed files.

Historical commits remain useful for audit/history, but must not be treated as current implementation targets.

---

## 17. GEMINI EVIDENCE POLICY

Gemini findings must be kept separate from local reasoning.

Current retained state:

- No authoritative Gemini result text is currently stored as verified evidence for this transfer.
- Do not invent, paraphrase, or upgrade an unrecorded Gemini response into fact.
- When a future Gemini result is supplied, preserve the exact finding/context needed to distinguish:
  - Gemini evidence;
  - repository evidence;
  - local engineering inference.

---

## 18. FAILED APPROACHES / ENVIRONMENT LIMITATIONS

Previously encountered environment limitations include:

- local repository clone/network resolution failures;
- missing local Flutter/Dart/Arduino CLI/PlatformIO validation tools in prior environments;
- inability to treat cached GitHub documentation as equivalent to fresh runtime/physical evidence.

These are environment limitations, not proof that the project itself is defective.

Do not repeat a failed local strategy without first checking whether the environment/tooling has changed.

---

## 19. EXACT QC SEQUENCE

Unless the user explicitly changes project priority, the current release path is:

**1. Compile V5.7**
→ **2. Generate V5.7 BIN**
→ **3. Flash/verify V5.7 provenance**
→ **4. Hardware-only functional QC**
→ **5. Safety QC**
→ **6. Local OTA Golden Path**
→ **7. Online OTA + BLE recovery**
→ **8. App ↔ V5.7 integration QC**
→ **9. Separate explicit App Build**
→ **10. Final Release Gate**

Important:
- Build App is a separate operation.
- Firmware implementation does not imply App Build.
- Chat transfer does not imply App Build.
- No release claim before the actual gates pass.

---

## 20. NEW CHAT FIRST RESPONSE FORMAT

After preflight/reconciliation, the new chat should report:

### CURRENT PROJECT TRUTH
Current version, phase, active source, current main HEAD, and release status.

### REPOSITORY RECONCILIATION
What was verified against current `main`, and any discrepancies.

### VERIFIED
Only facts supported by current repository/evidence.

### UNVERIFIED
Only genuinely pending validation.

### KNOWN RISKS
Only active risks.

### NEXT EXACT GATE
One concrete next QC action.

Then wait for the user's command.

Do not re-explain the entire historical project unless a specific part is relevant to the current task.

---

## 21. TRANSFER SAVE / MEMORY RULES

When a future chat reaches context/transfer limits:

- do not append another giant duplicate snapshot;
- replace this file with one current transfer snapshot;
- keep current truth consolidated;
- keep history in CHANGELOG/Git history;
- preserve exact source paths, versions, blobs, commits, run IDs, checksums, and evidence where they materially matter;
- separate persistent facts from chat-only discussion;
- update PROJECT_STATE/HANDOVER only when the new state is persistent and materially useful;
- do not change functional source merely to perform memory synchronization.

Recommended transfer labels:

`[USER REQUIREMENT]`
`[CONFIRMED]`
`[VERIFIED]`
`[IMPLEMENTED]`
`[COMMITTED]`
`[BUILT]`
`[TESTED]`
`[UNVERIFIED]`
`[HYPOTHESIS]`
`[OBSOLETE]`
`[REJECTED]`
`[BLOCKED]`
`[OPEN QUESTION]`

Never promote `[HYPOTHESIS]` to `[VERIFIED]` without evidence.

---

## 22. CURRENT CHAT-ONLY STATE

- The user requested a more detailed transfer prompt so future chats do not repeatedly ask for established context.
- This execution is a **documentation/protocol improvement only**.
- No functional Firmware behavior is authorized to change by this transfer operation.
- No App source behavior is authorized to change by this transfer operation.
- No App Build is authorized by this transfer operation.

---

## 23. TRANSFER COMPLETION

At the start of this transfer write:

- Repository: `TenzoNkz/JEXFYZ-App`
- Branch: `main`
- Verified pre-write HEAD: `c7faf134742fc6fdbebc3f66469c8aa5dd9980c6`
- Active Firmware source/blob: `firmware/JEXFYZ-V5.7.ino` / `652e54afdd9c7c347cd82072f573f1729c4b46de`
- Active App Build workflow/blob: `.github/workflows/jexfyz-app-build-trigger.yml` / `51a6c4d35580228ae24f859058ae5b08665d94a0`

After the write:
- re-read this file;
- verify that its saved contents match the intended Transfer Protocol v2;
- verify the new main HEAD;
- verify the active Firmware source and workflow still match;
- verify no functional source/workflow changes were introduced by the transfer protocol update.

> **Purpose:** a new chat should be able to boot from this document, reconcile repository truth, and continue the project without forcing the user to restart the explanation from zero.
