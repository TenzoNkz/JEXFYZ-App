# 🚨 CURRENT AUTHORITATIVE HANDOFF — 2026-09-27

> **This section is the current-state override for the next sub-chat.** Historical entries below remain as chronology. When a historical entry conflicts with this handoff, use this current handoff plus the newest user instruction and newest real source state.

## 1. MANDATORY OPERATING RULES

### Before EVERY project conversation or action
1. Read the relevant living note/context first.

2. For firmware work, read the current firmware notes and firmware master context.
3. For app work, read the current app notes and app master context.
4. For cross-layer work, read both sides and the combined master context.
5. After reading, inspect the newest actual GitHub/source state.
6. Resolve conflicts by: newest user instruction → newest actual source/repository state → exact pinned official upstream source/docs → living notes → old history.


### Passive living-notes rule

The living notes are passive, continuously evolving project memory. Every discussion and every execution must update the relevant notes when there is a new decision, verified finding, contradiction, runtime result, or boundary; discussion-only updates do not authorize executable code changes or builds.

### Execution lock

Executable source/repository changes and build execution require the explicit user command `Eksekusi Full`. Discussion may analyze and prepare only.

### After EVERY material action
Immediately update the relevant notes with:
- exact action performed
- reason
- affected file/repository
- actual result
- commit/run/version when available
- unresolved issue
- next diagnostic or implementation boundary

Material actions include source edits, official-source investigations, hardware/pin decisions, protocol changes, safety/timing changes, OTA/radio changes, version changes, CI results, manual-flash results, runtime panics/errors, packaging, publishing, and workflow changes.

**Do not postpone documentation until the end of a release.**

## 2. OFFICIAL-SOURCE-FIRST RULE

For platform/library/API behavior, inspect the exact pinned upstream source/documentation first.

Current firmware platform:
- **Arduino-ESP32 Core 3.3.7**
- Official repository: https://github.com/espressif/arduino-esp32

Official references verified on 2026-09-27:
- AP example:
  https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/examples/WiFiAccessPoint/WiFiAccessPoint.ino
- WiFiAP wrapper:
  https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/WiFiAP.cpp
- AP implementation:
  https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/AP.cpp
- Wi-Fi generic/mode:
  https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/WiFiGeneric.cpp
- STA implementation:
  https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/STA.cpp

**Do not invent a custom lifecycle/API wrapper when the exact upstream implementation already provides the needed behavior.** Custom JE X FYZ logic may wrap upstream APIs only where the product specification requires it and the upstream call path has been understood.

## 3. NO SPECULATIVE PATCH STACKING

When a runtime fault is reproducible:
1. preserve the exact failure
2. inspect the exact pinned upstream implementation
3. compare project call path with upstream call path
4. isolate the smallest failing boundary
5. change one root cause at a time
6. build/validate
7. record the actual result immediately

Do not keep adding unverified radio/lifecycle patches.

## 4. ACTIVE FIRMWARE BASELINE

- Active version: **V1.0**
- Prior V3.x/V4.x/V5.x versions are historical only unless the user explicitly reactivates them.
- Source of truth: `firmware/JEXFYZ.ino`
- BLE: `JE X FYZ`
- Protocol: `P1`
- Target: ESP32-C3 Super Mini
- Core: Arduino-ESP32 3.3.7

Current source GPIO authority:
- GPIO0 = NTC
- GPIO1 = TTP223
- GPIO3 = 12V selector
- GPIO4 = 9V selector
- GPIO5 = FAN
- GPIO6 = PELTIER
- GPIO7 = WS2812B, 8 LEDs

**Critical:** GPIO5 = FAN and GPIO6 = PELTIER. Never silently swap.

## 5. V1.0 BUILD EVIDENCE

Firmware GitHub Actions:
- Run #66
- Run ID: `36264460597`
- URL: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/36264460597
- Result: **SUCCESS**
- ArduinoDroid/Core 3.3.7 validation: PASS
- ESP32-C3 release compile: PASS
- OTA source audit: PASS
- Artifact upload: PASS
- Public firmware publication: PASS

Public binary:
https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.0.bin

Manifest:
https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/manifest.json

**Important evidence boundary:** CI success proves compilation/automation/artifact publication. It does NOT prove physical boot/runtime correctness.

## 6. V1.0 MANUAL-FLASH RESULT

The user manually flashed V1.0 and reported:

**The device still PANICS during boot.**

Therefore:
- V1.0 is **NOT physically validated**.
- Do not describe V1.0 as hardware-working.
- Do not treat the green CI result as proof of runtime stability.
- Do not create another production firmware release from an unproven radio hypothesis.

The exact V1.0 Guru Meditation register dump is **not yet recorded** in the notes. The next test must preserve the complete Serial Monitor output.

## 7. OFFICIAL ARDUINO-ESP32 3.3.7 SOURCE FINDING

The exact upstream source was inspected after the V1.0 panic.

The official AP example uses:

`WiFi.softAP(ssid, password)`

The official implementation chain is:

`WiFi.softAP()`
→ `AP.begin()` + `AP.create()`
→ `WiFi.enableAP(true)`
→ official `WiFiGenericClass::mode()`
→ Wi-Fi initialization/start
→ AP startup synchronization.

`AP.begin()` waits for `ESP_NETIF_STARTED_BIT` before reporting AP startup success.

The current V1.0 firmware instead performs a custom sequence before AP creation:

`WiFi.disconnect(true, false)`
→ `WiFi.setHostname("JE-X-FYZ")`
→ `WiFi.setAutoReconnect(false)`
→ `WiFi.mode(WIFI_AP)`
→ `WiFi.softAPConfig(...)`
→ `WiFi.softAP(...)`
→ HTTP server.

Because V1.0 still panics, this custom pre-sequence is now:

**STATUS: SUSPECT / UNDER INVESTIGATION**

It is **NOT proven to be the root cause** yet.

## 8. PREVIOUS PANIC HISTORY

Historical physical/runtime observations:
- V4.13: Core 0 Load access fault during Wi-Fi AP startup.
- V5.0: Core 0 Load access fault around `WiFi.mode(WIFI_AP)`.
- V1.0: physical manual-flash panic repeated.

This pattern means the problem must be isolated experimentally rather than patched repeatedly.

## 9. NEXT DIAGNOSTIC BOUNDARY

The next experiment is a **temporary diagnostic firmware**, not a production release:

1. Read this handoff first.
2. Read exact Arduino-ESP32 Core 3.3.7 AP source.
3. Use the official high-level AP path as the baseline.
4. Keep the test minimal.
5. No BLE.
6. No custom radio teardown.
7. No custom retry state machine.
8. Print a log before and after each relevant upstream call.
9. Record the exact last successful call before any panic.
10. Only after the boundary is proven should JE X FYZ feature layers be reintroduced one at a time.

Do not confuse the diagnostic firmware with the required production feature firmware.

## 10. PRODUCTION FEATURE CONTRACT — PRESERVE

The eventual production firmware must still preserve:
- NTC 10K, GPIO0, 1 Hz sampling, fault handling.
- Hotside limit 40–50°C; current default 45°C.
- NTC fault: Fan 100%, Peltier OFF, Adaptive OFF, voltage toward 5V.
- Fan/Peltier interlock.
- Fan GPIO5, 25 kHz, 8-bit, 50–100%, 10% steps.
- Peltier GPIO6, 20 kHz, 8-bit, 5 s non-blocking soft-start.
- Voltage 5V/9V/12V.
- Manual voltage guard 1 s.
- Optocoupler break-before-make 200 ms.
- Adaptive upward delay 5 s.
- Adaptive hotside cooling window 10 s.
- App battery heartbeat `PHONE:BT=<temperature>` at 1 Hz.
- Battery validity TTL 5 s.
- BLE session gate: `SYNC` → snapshot → `SYNC_READY`.
- Existing BLE UUIDs.
- Hotside telemetry every 1 s.
- Other values delta-driven.
- Preferences debounce about 10 s.
- Single-radio Wi-Fi/BLE ownership.
- Boot local AP window about 10 s.
- HTTPS for online OTA.
- OTA failure recovery back to BLE where supported.
- No SHA-based Firebase firmware-link requirement.
- Firmware remains authoritative for safety/state.
- No normal runtime `delay()`; bounded OTA/network scheduler servicing may use `yield()`.
- Do not resurrect rejected legacy command formats without explicit redesign.

## 11. VERIFIED ARDUINODROID MANUAL-UPLOAD CONFIGURATION

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
- Erase All Flash Before Sketch Upload: Disabled
- Zigbee Mode: Disabled

## 12. DOCUMENTATION HANDOFF

The next sub-chat must start from the facts above, not from older V4/V5 reasoning.

Required first actions in the next sub-chat:
- read the latest notes
- inspect the latest firmware source
- read the exact Core 3.3.7 upstream AP implementation
- preserve the V1.0 panic status
- do not change unrelated production features
- record every action/result immediately in the notes

## 13. LATEST PROJECT ACTIONS — 2026-09-27

- V1.0 source created/rebased as a clean active baseline.
- V1.0 firmware build Run #66 succeeded.
- V1.0 public binary published.
- User manually flashed V1.0.
- User reported the same panic.
- Official Arduino-ESP32 3.3.7 AP source was inspected.
- Determined that the official example uses the high-level `WiFi.softAP()` path.
- Determined that the active custom pre-sequence is a suspect boundary, not yet a proven root cause.
- Documentation governance was strengthened: read-before-action + update-after-action + official-source-first + no speculative patch stacking.


---

# JE X FYZ APP — PROJECT MEMORY / ENGINEERING NOTES

> **Purpose:** Persistent project memory for the **JE X FYZ / JE Cooler Flutter application only**.
>
> This document is intentionally detailed. It exists so future work can continue from the verified project history without repeatedly asking the user to explain the same architecture, UI rules, BLE behavior, CI history, known bugs, and design decisions.
>
> **IMPORTANT:** This document is an app-only note. Firmware implementation details are intentionally kept out of this file. Only app-side BLE/API contracts that the app must consume are recorded where necessary.

---

> Current firmware handoff (2026-09-26): The firmware source is V4.2 and the firmware CI baseline is stable Arduino-ESP32 Core 3.3.12. Firmware V4.1 was published by Run #25 as the controlled OTA target; the user then reported that local/manual OTA from the installed V3.9 device failed and the device remained on V3.9. Firmware V4.2 contains the local-OTA hardening and was verified by Firmware Build Run #26. The App BLE P1 contract remains unchanged.

## 0. HOW THIS FILE MUST BE USED

This file is part of the project and should be treated as a **living engineering memory**.

### Mandatory rule

### Cross-sub-chat continuity rule

**This file is mandatory project context for every new JE X FYZ app sub-chat.** Before discussing, reviewing, debugging, modifying, or validating the app, the latest `APP_NOTES.md` from `main` must be read first — even when the previous sub-chat has reached its limit or a brand-new sub-chat is opened.

The purpose is to prevent repeated explanations and regression from missing historical context. The user should not need to re-explain the architecture, approved behavior, known bugs, constraints, or previous fixes when that information is already recorded here.

If this file is not yet loaded in the current sub-chat, retrieve the latest version before proceeding with app work. Do not rely on memory from an earlier sub-chat as a substitute for reading the current notes.

### Two-sub-chat workflow separation

The JE X FYZ app work is intentionally split across two sub-chat roles so the project can continue without exhausting one chat too quickly:

**1. Code-change sub-chat (this role):**
- Used for project discussion, source-code/config changes, debugging logic, UI work, and implementing fixes.
- Code changes are executed here after the user approves the discussed change.
- This role does **not** trigger a build automatically after each change.
- Do not introduce a push-to-build workflow merely because files changed.

**2. Build / CI sub-chat:**
- Used specifically for the **App Build** workflow: trigger the app build, inspect build/test/analyze failures, inspect CI logs, and obtain/download the built APK artifact.
- A build is triggered only when the user explicitly says **`Build App`** in that sub-chat.
- This sub-chat never triggers the Firmware Build workflow.
- When CI reports a code/configuration/build error, diagnose it in the Build / CI sub-chat. The Action sub-chat may directly fix the source/configuration when the fix is required to make the build pass, then rerun the workflow and record exactly what it changed. The resulting change must be handed back through `APP_NOTES.md` so the Code sub-chat sees what was wrong and what Action changed.
- This separation is intentional and must be preserved to keep the two chat contexts focused and reduce unnecessary context usage.

### Sub-chat naming convention

Use the following naming scheme consistently for JE X FYZ project continuity:

- **Code-change sub-chats:** `JE X FYZ Code #1`, `JE X FYZ Code #2`, `JE X FYZ Code #3`, and so on.
- When a code-change sub-chat reaches its context limit, rename the completed chat by appending `Limit`: `JE X FYZ Code #1Limit`, then start the next code-change sub-chat as `JE X FYZ Code #2`.
- **Build / CI sub-chats:** `JE X FYZ Action #1`, `JE X FYZ Action #2`, `JE X FYZ Action #3`, and so on.
- When a Build / CI sub-chat reaches its context limit, rename the completed chat by appending `Limit`: `JE X FYZ Action #1Limit`, then start the next Build / CI sub-chat as `JE X FYZ Action #2`.
- Numbering of code-change chats and Build / CI chats is independent.
- The naming is a human/UI organization convention; do not infer the active chat title from system context. When a new sub-chat is opened, read the latest `APP_NOTES.md` regardless of its title.

### Shared-memory bidirectional handoff protocol

### Mandatory memory update for BOTH Code and Action

### Mandatory shared-memory preflight before execution

**Both sub-chats must read the latest `APP_NOTES.md` from `main` before executing any project action.** This is mandatory for both `JE X FYZ Code #N` and `JE X FYZ Action #N`.

The pre-execution order is:

`Read latest shared memory → understand current state/handoff → execute the requested work → update shared memory with the new state`.

This means neither Code nor Action may begin an execution based only on its own chat history. Both must synchronize against the same latest project memory first. If the Notes have changed since the last read, use the newest verified Notes state as the starting point.

**Every time either sub-chat makes a project change, the shared memory must be updated. This rule applies equally to `JE X FYZ Code #N` and `JE X FYZ Action #N`.**

- **Code sub-chat:** whenever source code, Android configuration, dependencies, assets, workflow configuration, or another project-controlled file is changed, record the change in `APP_NOTES.md` in the same project update.
- **Action sub-chat:** whenever build/CI configuration, source/configuration used to fix a build failure, packaging/output naming, or another project-controlled file is changed, record the change in `APP_NOTES.md` as part of the same update.
- Record the actual change, reason, affected files, resulting state, test/build result, and any handoff information needed by the other sub-chat.
- A change made by Action is not considered fully handed back to Code until the shared memory records what Action changed and why.
- A change made by Code is not considered fully handed to Action until the shared memory records what Action should validate/build when applicable.
- The two sub-chats therefore maintain one continuously evolving project memory; neither chat has a separate private project history that supersedes the Notes.

The two sub-chats share **one project memory** but have different primary responsibilities. The latest `APP_NOTES.md` is the source of truth for the current engineering state and must be used for handoff in both directions. **No change may be left undocumented in the shared memory.**

**Code → Action:** after a code/config change, record the current HEAD/commit when known, changed files, purpose, intended behavior, what must be tested, and whether a build is requested/pending. The Action sub-chat reads this state before building.

**Action → Code:** after every build/CI attempt, record the run number/ID when available, head SHA when available, result, failed step/error when applicable, and artifact result. If Action directly changes source/config to fix a build failure, record the exact files and a concise description of the fix before/with the successful result. This allows the Code sub-chat to know what was wrong and what Action changed without reconstructing the history from chat messages.

**Action self-fix rule:** Build / CI may directly make narrowly-scoped source/config changes required to resolve a build, analysis, test, packaging, or CI failure. It should not silently introduce unrelated feature/UI changes. Every such change is a real project change and must be recorded in the shared memory and carried forward to the next handoff.

**Latest state wins:** when the two sub-chats disagree with older chat context, use the newest verified repository state and the latest relevant memory entry. A new sub-chat must not rely on an older sub-chat transcript when the current notes contain a newer state.

**No automatic build from ordinary code changes:** normal Code or Action edits do not themselves imply a new build. Builds remain controlled from the dedicated Build / CI workflow unless the user explicitly requests otherwise.

### Project memory capture rule

Treat `APP_NOTES.md` as the project's **persistent memory**.

After every app/config/workflow change, update this file in the same change so the repository itself records the latest engineering state. The memory entry should preserve, where applicable:

- what changed;
- why it changed;
- affected files;
- intended final behavior;
- behavior that must remain unchanged;
- test/build/CI result;
- known errors, regressions, or unresolved items;
- important decisions that future sub-chats must not forget.

This rule is specifically intended to prevent loss of context when a sub-chat reaches its limit and work continues in a new sub-chat. The next sub-chat must read the latest notes and continue from that recorded state rather than asking the user to reconstruct the history.

**Note-only changes do not trigger a build and do not require a recursive note entry about the note-only change itself.**

**MANDATORY MEMORY RULE: Every time any app code, configuration, workflow, CI/build behavior, or other project behavior is changed, `APP_NOTES.md` must be updated in the same change. No project change is considered complete until its relevant memory/state has been recorded.**

That means:

1. Record what changed.
2. Record why it changed.
3. Record which files were touched.
4. Record any behavior that must remain unchanged.
5. Record test/build status.
6. Record known regressions or unresolved problems.
7. Record the final intended behavior.
8. Update the changelog at the bottom.

### Never do these things

- Do not assume a previous chat message is still available.
- Do not re-derive project requirements from memory when this document already records them.
- Do not rewrite unrelated logic while fixing one issue.
- Do not remove BLE/session/synchronization logic just because a UI issue is being fixed.
- Do not claim GitHub/CI is fixed until a real GitHub Actions run proves it.
- Do not claim a repository commit/push happened unless the repository actually contains the change.
- Do not silently change established UI behavior.
- Do not substitute a “responsive redesign” when the user asked for a fixed design canvas.
- Do not split the visual scaling system into separate Home/Menu scaling systems.
- Do not introduce a global settings reset when the user requested per-feature reset controls.
- Do not change firmware behavior from the app unless explicitly requested.
- Do not touch firmware project notes from this app document.

### Change discipline

The user strongly prefers:

- Change **only what was requested**.
- Preserve unrelated logic.
- Prefer full original filenames when delivering changed files.
- No filename suffixes such as `_new`, `_fixed`, `_v2` when the actual file is meant to replace the original.
- When a file is changed, provide the complete file rather than a fragment whenever an artifact is being delivered.
- Keep the repository clean.

---


## ACTION → CODE HANDOFF — Run #94

- Run #93 failed at `flutter analyze` because `mapPinSlash` was not defined by `phosphor_icons ^3.0.1` in `lib/main.dart`.
- Action fix: replaced the unavailable `PhosphorIconsRegular.mapPinSlash` reference with the available `PhosphorIconsRegular.mapPin` fallback for the Location indicator OFF state.
- The fix was limited to the build-blocking icon reference; no unrelated UI or control logic was changed.
- Run #94 then passed analyze, tests, release build, production APK signature verification, packaging, and artifact upload.
- Built head SHA: `f20626b9433762741e6592eda8b06005de4f7ab6`.
## Build artifact naming convention

- Every downloaded/shared application artifact must use the GitHub Actions run number in the filename.
- APK format: `JE X FYZ Build #N.apk`.
- ZIP format, when provided: `JE X FYZ Build #N.zip`.
- The `#N` value must match the actual GitHub Actions workflow run number that produced the artifact; never guess or use a chat number.
- Example: Run #94 -> `JE X FYZ Build #94.apk`.
## CURRENT ACTION / CI STATE

**Latest verified successful build:** GitHub Actions **Run #3** for workflow `App Build`.

- Run ID: `36212599091`
- Result: **SUCCESS**
- Head SHA built: `1a52f502e78291c0dea1d181fc5c5a3307a07f84`
- Analyze: **SUCCESS**
- Tests: **SUCCESS**
- Release APK build: **SUCCESS**
- Production APK signature verification: **SUCCESS**
- APK artifact: `JEXFYZ#3.apk`
- Artifact ID: `10896531044`
- Artifact size: `53,134,806 bytes`
- Artifact expired: **No** at verification time
- Dart symbols artifact: `JE-X-FYZ-Dart-Symbols` (ID `10896446475`)
- User-facing delivered filename: `JE X FYZ Build #3.apk`
- The artifact is a direct APK; the current App Build workflow no longer packages ZIP output.

### Build failure recovery recorded

- Run #1 (`36212348012`) failed at `flutter analyze`: V3.3/V3.4 LED sync assigned `clamp(1, 8)` directly to `int rgbMode`. Action fixed it with `.toInt()`.
- Run #2 (`36212485388`) failed at `flutter analyze`: Firmware dialog Retry button still called removed `_checkFirebase`; analyzer also reported one unnecessary cast. Action changed Retry to `_checkGitHub` and removed the redundant cast.
- Run #3 (`36212599091`) then passed the complete App Build pipeline.

### Current code-side handoff

- Native Android Foreground Service support is included in the current source to keep the BLE session backed while the Flutter UI is backgrounded; the service does not create a second BLE client.
- Real-device validation of background BLE continuity is still required. Build success does not equal runtime device validation.
- The latest successful build used the current V3.4 app/protocol synchronization state and the latest foreground-service implementation present on `main` at build time.

### Workflow state

- App Build is triggered only by `.github/APP_BUILD_TRIGGER` in the current workflow.
- The Action sub-chat triggers it only after the explicit user command `Build App`.
- Action never triggers Firmware Build.

### Handoff to Code-change sub-chat

- Run #3 required no further source fix after the `_checkGitHub` correction.
- The latest build is suitable for user testing; report any device/runtime regression back through `APP_NOTES.md`.


# 1. PROJECT IDENTITY

## Project

**JE X FYZ / JE Cooler**

## Primary app repository

`https://github.com/TenzoNkz/JEXFYZ-App`

Primary branch used throughout this project:

`main`

## Reference application / architecture

Horizon Cooler App:

`https://github.com/TenzoNkz/Horizon-Cooler-App`

The JE X FYZ app was intentionally based on the Horizon Cooler App architecture and UI philosophy, then customized for JE X FYZ hardware/features.

### Main technology stack

- Flutter / Dart
- Android wrapper
- `flutter_blue_plus` for BLE
- Firebase for firmware metadata/read-only update information
- `flutter_secure_storage` for sensitive local data
- `permission_handler`
- Phosphor icon library / Phosphor icons
- Firebase App Check
- Android Play Integrity provider
- release obfuscation with R8/shrink resources
- production-signed release APK

---

# 2. CORE DESIGN PHILOSOPHY

The most important current visual architecture decision is:

> **The application should behave like ONE visual canvas/image.**

The Home area and the Display/Submenu area are **not separate responsive layouts**.

They must be treated as one coherent design system.

## What the user means by “360 dp”

The user repeatedly used a device test matrix such as:

- 360 dp
- 410 dp
- 460 dp

The intent is **NOT**:

> “At 460 dp, make the UI physically larger because the logical width is larger.”

The intent is also **NOT**:

> “Lock the UI to 360 logical dp and simply leave a large empty border.”

The desired behavior is:

> **The same visual design should look physically the same when the Android logical/smallest-width DP changes on the same physical display.**

The best analogy supplied by the user:

> **“Anggap ini layar HP, jadi ukurannya tetap tetapi bisa scaling sesuai dp layar.”**

And later:

> **“Anggap saja 2 gambar ini dipakai di 2 dp ukuran beda. 1 dp 360, 2 dp 460, tetapi ukurannya tetap sama!”**

The two reference screenshots demonstrated that the UI content should preserve the same visual/physical size even though the logical DP value has changed.

## Therefore the correct architecture is

### One master design

Use a fixed reference design coordinate system (historically 360 dp wide).

### One scaling transform

If scaling is required to compensate for the Android logical-density/DP change, it must be applied **ONCE to the entire application canvas**.

Conceptually:

```text
DEVICE / VIEWPORT
        |
        v
+---------------------------+
| OUTER VIEWPORT             |
|                            |
|   ONE JE X FYZ CANVAS      |
|   +--------------------+   |
|   | Header             |   |
|   | Home indicators    |   |
|   | Cooler image       |   |
|   | Notify             |   |
|   | Display tabs       |   |
|   | Display cards      |   |
|   +--------------------+   |
|                            |
+----------------------------+
```

### Never do separate scaling

Do NOT do:

```text
Home -> one scale
Display menu -> another scale
Cards -> responsive scale
Text -> independent scale
```

That was the root concept behind the earlier display-menu shrinking problem.

### Important physical-size compensation concept

When testing the **same physical display** with different Android logical DP/smallest-width values, raw logical dimensions cannot be treated as physical dimensions.

If the logical DP changes from 360 to 460 on the same physical screen, the coordinate-space conversion must compensate so the visual result remains the same physical size.

Therefore:

- The **design/reference canvas** remains constant.
- The **single root scale factor** is responsible for adapting that canvas to the current logical display configuration.
- The scale must be applied to the **whole canvas**, not individual sections.
- The scale must not be derived separately for Home and Display Menu.

### Current implementation goal

The exact final scaling implementation still needs to be validated by a real device matrix / CI test.

**Do not declare the scaling problem solved solely because a local artifact was produced.**

---

# 3. UI REFERENCE / HOME LAYOUT

The main UI visual reference is Horizon Cooler.

Overall visual style:

- dark black/near-black upper Home area
- white rounded Display/Menu panel beneath it
- compact premium industrial appearance
- Phosphor-style line icons
- cooler image prominently displayed on the right side
- indicators stacked vertically on the left
- Notify as a full-width long row beneath the seven indicators
- rounded control cards in the white submenu panel

## Header

Header text:

`JE X FYZ`

Subheader:

`DEVELOPED BY HORIZON`

Header controls:

- Bluetooth icon on the left
- Settings gear on the right
- both centered vertically and kept compact
- Bluetooth icon changes to connected-state icon when connected

The user explicitly wanted:

- Bluetooth and Settings centered left/right
- slightly smaller than early oversized versions
- connected Bluetooth visual state

## Home indicator labels

Exact labels:

1. `BATTERY TEMPERATURE`
2. `HOTSIDE TEMPERATURE`
3. `VOLTAGE INDICATOR`
4. `ADAPTIVE MODE`
5. `PELTIER SWITCH`
6. `FAN SWITCH`
7. `FAN SPEED`
8. `NOTIFY` (full-width warning/status row)

## Home indicators

### Battery temperature

- Phosphor battery icon
- default disconnected value:
  `--`
- connected value should show temperature

### Hotside temperature

- Phosphor thermometer icon
- default disconnected:
  `--`

### Voltage

- Phosphor lightning/voltage icon
- default disconnected:
  `--`
- valid app values:
  - `5V`
  - `9V`
  - `12V`

### Adaptive mode

- Phosphor sparkles/adaptive-style icon
- disconnected:
  `--`
- connected:
  `ON` / `OFF`

### Peltier switch

- MUST use a Phosphor-style thermoelectric/cooling icon
- disconnected:
  `--`
- connected:
  `ON` / `OFF`

### Fan switch

- MUST use the actual Phosphor fan icon:
  `PhosphorIconsRegular.fan`
- disconnected:
  `--`
- connected:
  `ON` / `OFF`

### Fan speed

- disconnected:
  `--`
- connected at 5V or 9V:
  `100%`
- connected at manual 12V:
  show actual `fanSpeed%`
- PWM adjustment is intended only for manual 12V mode
- default adjustment increments discussed:
  multiples of 5 or 10, e.g.
  `50, 55, 60, 65, ... 100`
  or
  `50, 60, 70, 80, 90, 100`

## Home Notify row

The Notify area is intentionally a HOME element, not a hidden submenu element.

Requirements:

- full-width long row
- no awkward boxed icon container
- visually integrated with the indicator list
- Phosphor shield/check/warning-style icon
- state text and warning text centralized
- online/offline badge on right
- should show important notifications/warnings in one place

Examples seen during testing:

Disconnected:

`NOTIFY · WARNING`

`Temperature sensors: validating...`

badge:

`OFFLINE`

Connected example:

`NOTIFY`

`OK • System ready • Device state synchro...`

badge:

`ONLINE`

### Important UI correction

The earlier Notify icon box was considered visually awkward and was intentionally removed/simplified.

---

# 4. COOLER IMAGE

Asset:

`assets/jexfyzcooler.png`

Android/app branding also uses:

`assets/jexfyzicon.png`

The cooler image is one of the most important visual anchors.

Requirements from the user:

- use the provided cooler image
- do not redraw the cooler
- preserve original product geometry
- preserve fan blades
- preserve screws
- preserve vents
- preserve logos / typography
- preserve orange LED lighting and reflections inside the product
- cooler should be large and visually prominent
- cooler should be positioned on the right side of the Home area
- cooler should feel centered vertically relative to the indicator stack
- do not accidentally shrink the cooler independently when DP changes

The user previously requested premium/technical visual treatment but the production UI should preserve the approved product asset.

---

# 5. DISPLAY / SUBMENU

The white rounded submenu panel contains:

1. `VOLTAGE`
2. `CONTROL`
3. `ADAPTIVE`
4. `LED`
5. `TEMPERATURE`

The tabs are horizontal.

The user specifically wants the submenu to retain its visual proportions under DP changes.

## Critical scaling rule

The entire Display/Menu section must scale with the Home **as part of one root canvas**, not using its own responsive width rules.

This avoids the earlier bug where the Home looked correct but the Display Menu became unexpectedly smaller at another DP size.

## Voltage screen

Title:

`Voltage Control`

Subtitle:

`5V / 9V / 12V manual selector.`

Cards:

- `5V` — `5V Manual`
- `9V` — `9V Manual`
- `12V` — `12V Manual`

Each row has a radio/check indicator on the right.

Selected row uses the approved dark/selected treatment and blue selected indicator.

When disconnected, the bottom status card communicates:

`Connect to control voltage.`

The bottom status text may become firmware/runtime state text when connected, e.g. a 12V state indicator.

---

# 6. VOLTAGE / CONTROL RULES

Supported voltage commands:

- `5V`
- `9V`
- `12V`

Helper test:

```dart
isVoltageCommand('5V') == true
isVoltageCommand('9v') == true
isVoltageCommand('12V') == true
isVoltageCommand('13V') == false
isVoltageCommand('BR:128') == false
```

## Manual voltage behavior

- manual voltage selection uses the three supported values
- earlier user requirement: voltage switching should have approximately a 1-second transition delay similar to Horizon Cooler
- do not create unnecessary full device power-off unless required by safety/firmware behavior
- switching voltages manually should not automatically turn Peltier/Fan off unless the system is explicitly forced off

## Adaptive interaction

User requirements:

- when Adaptive Mode is ON, manual voltage touch control is locked
- entering/exiting Adaptive Mode should return voltage to 5V
- PWM fan control is not used in Adaptive mode
- manual voltage control is for manual mode

---

# 7. LED / RGB UI REQUIREMENTS

LED settings were designed to follow Horizon Cooler behavior but adapted to JE X FYZ.

## Voltage-to-color defaults

Default mapping:

- 5V → red
- 9V → green
- 12V → blue

The mapping can be customized.

There must be:

- per-voltage LED color customization
- a reset button specifically for **voltage colors**
- do NOT use a global “reset everything” button

## General RGB controls

- RGB mode does not need the voltage-color reset button
- LED brightness remains configurable
- save grouped LED settings
- avoid redundant writes / command spam

---

# 8. TEMPERATURE SETTINGS

Temperature settings cover:

- Hotside
- Battery

Known user requirements:

- hotside safety limit should be configurable in app within approximately:
  `40°C – 50°C`
- earlier discussion referenced:
  - critical hotside = 50°C
  - another default mentioned = 45°C
- this must be resolved against the currently approved firmware/app default before changing implementation
- battery temperature is read/synced every second
- hotside temperature is also sent/read every second
- other changed settings should only be sent when changed

## Save-to-preferences behavior

Preferences should be saved after:

**10 seconds of no change**

Do not write preferences continuously on every minor UI update.

---

# 9. APP-SIDE BLE BEHAVIOR / CONTRACT

Firmware is a separate project. This file only records what the app expects.

BLE uses:

`flutter_blue_plus`

The app previously had a major BLE handshake issue where the device could connect but the session-ready event could be missed because it arrived during the pre-dashboard receive buffer.

This was fixed by processing `BLE_SESSION=READY` during the initial/pre-dashboard buffer.

The user explicitly confirmed:

> “Okey sudah bisa konek!”

### DO NOT casually modify BLE

BLE is considered stable unless a new issue is demonstrated.

Any BLE code change must:

1. identify the exact regression,
2. preserve handshake/session behavior,
3. preserve reconnect behavior,
4. preserve command synchronization,
5. preserve runtime sync.

## App-observed session behavior

Known app-side synchronization logic includes:

- handshake/session-ready processing
- command ACK waiting
- runtime sync after accepted commands
- scheduled sync approximately 90 ms after accepted command
- `adaptiveTransitioning` reset in `finally`
- control commands routed through `_sendAndConfirm()`

The runtime synchronization pattern is intentionally non-blocking.

### Important

Do not remove `_scheduleRuntimeSync()` or `_sendAndConfirm()` behavior merely to simplify UI code.

---

# 10. COMMAND / SYNC SPAM RULES

The user explicitly wants communication to be efficient.

## Temperature

Hotside temperature:

- send/read every second

Battery temperature:

- read every second so it remains synchronized with hotside data

## Other settings

Only send changed values.

Do NOT continuously send unchanged values.

## Preferences

Persist after:

- 10 seconds with no change

This reduces preference-write spam.

---

# 11. FIRMWARE UPDATE / OTA UI FROM THE APP SIDE

Firmware metadata is retrieved from Firebase.

Firebase is intended to be:

**READ-ONLY for firmware metadata.**

Do NOT create runtime Firebase write paths.

User explicitly rejected SHA-based firmware linking.

Use:

- firmware version
- firmware link

as the update metadata contract.

GitHub and Firebase are used similarly to Horizon Cooler.

## App-side update behavior

The app should support the firmware version/link flow without adding unnecessary complexity.

Known numeric firmware parsing rules:

```dart
parseFirmwareVersion('V1.7') -> [1, 7]
parseFirmwareVersion('v3') -> [3, 0]
parseFirmwareVersion('V1.7.1') -> null
```

Comparison:

```dart
isNewerFirmwareVersion('V1.8', 'V1.7') == true
isNewerFirmwareVersion('V1.7', 'V1.8') == false
```

## Firmware update UI

The existing codebase previously referenced:

`FirmwareUpdateDialog`

This was accidentally lost in a malformed `main.dart` revision and caused analyzer errors. The complete source artifact was later restored.

Therefore:

**Do not delete or partially delete the FirmwareUpdateDialog implementation.**

---

# 12. SECURITY / ARCHITECTURE REQUIREMENTS FROM CI AUDIT

The repository’s security/architecture audit checks for the following app-side items.

Required UUID strings present in source:

- `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`
- `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`
- `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`

These are part of the app/firmware communication contract.

Other required audit tokens / architecture markers include:

- `PHONE:BT=`
- `CLOUDOTA`
- `FirebaseDatabase.instanceFor`
- `firmware_update`
- `flutter_secure_storage`
- `assets/jexfyzcooler.png`
- `assets/jexfyzicon.png`
- `firebase_app_check`
- `providerAndroid: const AndroidPlayIntegrityProvider()`
- `TamperScreen`
- `je_x_fyz/security`

## Legacy architecture checks

The audit rejects:

- `assets/hzcooler.png`
- `assets/hzicon.png`
- `@drawable/hzicon`

and requires:

`@drawable/jexfyzicon`

## Forbidden legacy command patterns

The audit rejects legacy commands if found in source:

- `CFG:`
- `ADAPT:`
- `RGBTOGGLE`
- `RGBPREV`
- `RGBNEXT`
- `BR:`
- `AIM:`

Do not reintroduce those legacy commands.

## Firebase security

The audit rejects Firebase runtime write paths against the firmware metadata object.

Do not introduce:

- `.set(...)`
- `.update(...)`
- `.push(...)`
- `.removeValue(...)`

on the firmware metadata path.

## Credential storage

Wi-Fi passwords must remain in secure storage.

Do not store Wi-Fi passwords through ordinary shared preferences such as:

```dart
setString('saved_pass', ...)
```

## Android release security

The release build must keep:

- R8 minification enabled
- resource shrinking enabled
- official signing identity embedded/verified
- production signing
- obfuscation
- split debug symbols

---

# 13. APP ICON / BRANDING

Use JE X FYZ assets, not Horizon legacy assets.

Expected assets:

- `assets/jexfyzicon.png`
- `assets/jexfyzcooler.png`
- Android drawable-nodpi:
  `android/app/src/main/res/drawable-nodpi/jexfyzicon.png`

Legacy Horizon assets must not return.

The app display name was changed to:

**JE Cooler**

Header brand:

**JE X FYZ**

Subheader:

**DEVELOPED BY HORIZON**

---

# 14. CI / GITHUB ACTIONS BUILD SYSTEM

Primary workflow:

`.github/workflows/app-build.yml`

Workflow name:

`JE X FYZ Cooler Build`

Manual trigger:

`workflow_dispatch`

Toolchain history currently specified in the workflow:

- Java 17
- Flutter 3.47.2 stable
- Gradle 9.3.1
- Ubuntu 24.04 runner

## Build steps

The workflow performs:

1. Checkout
2. Java setup
3. Flutter setup
4. Gradle setup
5. toolchain verification
6. local.properties setup
7. production signing preparation
8. gradle wrapper fallback if missing
9. JE X FYZ security/architecture audit
10. Flutter dependency install
11. Dart analyze
12. Flutter tests
13. release APK build
14. APK signature verification
15. clean APK filename creation
16. artifact upload
17. Dart symbols upload

## Release build

Current intended build command:

```bash
flutter build apk --release --obfuscate --split-debug-info=build/symbols
```

## Signature verification

The workflow verifies:

- APK exists
- `apksigner` exists
- APK signing scheme exists
- expected signing certificate DN
- expected signing certificate SHA-256

The expected certificate SHA-256 recorded in the workflow:

`dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`

Expected DN:

`CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`

Do not bypass production signing.

---

# 15. APK ARTIFACT DELIVERY REQUIREMENT

The user requested that the downloadable application artifact be changed from raw APK to ZIP so the download is convenient.

The intended output:

```text
JE-X-FYZ-Latest.apk
        ↓
JE-X-FYZ-Latest.zip
```

The intended ZIP creation step uses maximum ZIP compression:

```bash
zip -9 -j \
  build/app/outputs/flutter-apk/JE-X-FYZ-Latest.zip \
  build/app/outputs/flutter-apk/JE-X-FYZ-Latest.apk
```

The intended artifact upload:

- artifact name:
  `JE-X-FYZ-Latest-App`
- uploaded file:
  `JE-X-FYZ-Latest.zip`
- APK should not be the user-facing artifact

### Important status

A `build.yml` replacement implementing ZIP output was prepared locally during the conversation.

However, at the time this note was written, the GitHub connector previously returned:

`403 Resource not accessible by integration`

for repository writes.

Therefore:

**Do not claim the ZIP workflow is live in GitHub until the repository file itself and a new Actions run confirm it.**

---

# 16. TEST FILE / WIDGET TEST HISTORY

Widget test file:

`test/widget_test.dart`

Current known test configuration:

```dart
tester.view.physicalSize = const Size(1080, 3200);
tester.view.devicePixelRatio = 1.0;
```

This was increased from 2600 after an overflow issue.

The widget test verifies the presence of:

- `JE X FYZ`
- `BATTERY TEMPERATURE`
- `HOTSIDE TEMPERATURE`
- `VOLTAGE INDICATOR`
- `VOLTAGE`
- `ADAPTIVE MODE`
- `PELTIER SWITCH`
- `FAN SWITCH`
- `FAN SPEED`
- `TEMPERATURE`
- NOTIFY text beginning with `NOTIFY`

It also checks:

- no widget exception
- supported voltage commands
- firmware version parsing/comparison
- six-digit hex color validation

## Hex helper expectations

```dart
isValidHexColor('#FFFFFF') == true
isValidHexColor('#00ff7a') == true
isValidHexColor('FFFFFF') == false
isValidHexColor('#FFF') == false
```

---

# 17. GITHUB ACTIONS FAILURE HISTORY

This section is important to prevent repeating old mistakes.

## Run #81

Known issue:

- Flutter widget test failed with approximately **14 px bottom overflow**
- the test viewport was too short for the fixed Home layout + production submenu

## Run #82

Same issue:

- approximately 14 px bottom overflow
- analyze passed
- tests failed
- build did not proceed

## Run #83

Run ID:

`35681651698`

Commit SHA:

`cd300a3bbf63f3df8384505ef29d11fe39e15259`

Changes included:

- widget test viewport raised to `1080 x 3200`

However, the committed `main.dart` still contained the earlier 400 dp Home height.

Therefore the overflow could still occur.

## Run #84

Run ID:

`35682430877`

Commit SHA:

`b059ed96f13ce1119284fe3931464a3d3f2572a7`

Workflow:

`https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/35682430877`

This run failed during:

`Analyze Dart code`

The problem was NOT the viewport at that point.

The committed `lib/main.dart` was malformed/truncated.

Known analyzer errors included:

```text
Missing concrete implementation of 'State.build'. ... lib/main.dart:250:7
The method 'FirmwareUpdateDialog' isn't defined ... lib/main.dart:1577:23
body_might_complete_normally ... lib/main.dart:1943:10
Expected to find ';' ... lib/main.dart:1947:25
Unterminated string literal ... lib/main.dart:1947:34
Expected an identifier ... lib/main.dart:1947:35
Expected to find ')' ... lib/main.dart:1947:35
Expected to find '}' ... lib/main.dart:1947:35
31 issues found.
```

The exact malformed source area was around:

```dart
String _notifyStateLabel() {
  final custom = notice.trim().toUpperCase();
  if (custom.contains('FAILED') ||
      custom.contains('ERROR') ||
      custom.contains('NOT FOUND
```

This caused a cascade of analyzer failures.

## Recovery source

A complete `main.dart` was restored from the saved Library artifact.

The restored complete source was:

- 3,222 lines
- approximately 113,773 bytes
- included `FirmwareUpdateDialog`
- included runtime sync logic
- included BLE handshake/session logic
- included Notify UI
- included Phosphor icons
- had `homeDesignHeight = 420.0`

A later artifact was also produced for the fixed-canvas/scaling work, but it has not yet been verified by a fresh CI run.

### Critical lesson

**Never patch a large `main.dart` from a truncated or partial copy.**

When changing `main.dart`:

- start from the known complete version
- preserve all sections
- verify the closing braces/functions
- run analyzer
- do not deliver a partial file as if it were complete

---

# 18. HOME HEIGHT / OVERFLOW HISTORY

The Home fixed design historically used:

```dart
const homeDesignWidth = 360.0;
const homeDesignHeight = 420.0;
```

The earlier `420 dp` value was selected because:

- seven metric rows were roughly 44 dp each
- total metric row space was about 308 dp
- header/top/bottom spacing plus Notify needed additional room
- the earlier 400 dp version produced a 14 px bottom overflow in widget tests

Therefore:

**Do not blindly reduce Home height below 420 dp without measuring the complete Home layout again.**

---

# 19. IMPORTANT CURRENT CANVAS/SCALING ISSUE

This is the latest major UI workstream.

The user tested:

- 360 dp
- 410 dp
- 460 dp

The requirement is that changing Android DP should **NOT change the physical-looking size of the UI**.

The user described this as:

> “anggap ini layar HP, jadi ukurannya tetap tetapi bisa scaling sesuai dp layar”

and:

> “1 dp 360, 2 dp 460 tetapi ukurannya tetap sama”

### Correct mental model

Treat the app like one image/canvas.

The device viewport is the frame.

The whole JE X FYZ UI is one design surface inside that frame.

When the logical DP configuration changes, the **whole design surface must be transformed as one unit** so it retains the same physical visual size.

### What caused previous bugs

#### Attempt A — independent responsive sizing

This caused:

- Home okay
- Display/Menu became smaller
- elements inside submenu changed proportions
- behavior differed at 360 / 410 / 460

#### Attempt B — separate FittedBox scaling for Home

This caused:

- Home could appear visually stable
- Display Menu was not part of the same transform
- menu/card layout became inconsistent

#### Attempt C — “fixed 360 logical dp and leave extra space”

This was not what the user meant.

It produced the wrong interpretation:

- 360 content
- 410/460 gets empty margin
- the user instead wants compensation for different logical DP so the **same physical visual size** is maintained

### Current target

Use:

**ONE root canvas**

with:

**ONE root scaling factor**

for:

- Home
- Notify
- tabs
- all submenu content
- all typography
- all icons
- cooler image
- cards
- spacing

Never scale sections independently.

### Validation matrix

At minimum, validate screenshots on:

- 360 dp
- 410 dp
- 460 dp

Expected visual result:

- same cooler physical size
- same icon physical size
- same text physical size
- same spacing
- same card dimensions
- same overall visual composition
- same relationship between Home and Display Menu

Only the available viewport/frame around the canvas changes.

---

# 20. IMPORTANT UI CONSISTENCY RULES

When fixing or editing the app:

## Do

- preserve the Horizon-inspired design
- keep the cooler image prominent
- maintain premium dark/light contrast
- use Phosphor icons consistently
- preserve the current approved icon mapping
- preserve the full-width Notify row
- keep Home and Display Menu visually synchronized

## Do not

- redesign the entire UI without request
- introduce Material default controls that visually clash with the custom design
- make cards significantly wider/narrower at different DP values
- use independent `Expanded`/`Flexible` sizing to solve a problem caused by canvas scaling
- let Flutter text scaling change the visual design
- enlarge the cooler only
- shrink the display menu only
- move Notify into a separate submenu
- add global reset buttons where per-feature reset was requested

---

# 21. TEXT / MEDIA QUERY RULE

The app has intentionally used no text scaling behavior to avoid system font-size changes altering the approved UI.

The intended pattern is:

```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaler: TextScaler.noScaling,
  ),
  child: ...
)
```

Do not remove this without explicit design approval.

---

# 22. FILES / IMPORTANT PATHS

## Main app code

`lib/main.dart`

## Widget test

`test/widget_test.dart`

## Build workflow

`.github/workflows/app-build.yml`

## Main cooler asset

`assets/jexfyzcooler.png`

## App icon asset

`assets/jexfyzicon.png`

## Android icon

`android/app/src/main/res/drawable-nodpi/jexfyzicon.png`

## Main Android activity

`android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`

## Android Gradle

`android/app/build.gradle`

---

# 23. FULL CURRENT FUNCTIONAL EXPECTATIONS

## Connection

When device is disconnected:

- Home runtime values show `--`
- Notify communicates offline/validating status
- Bluetooth icon shows disconnected state

When device connects successfully:

- Bluetooth icon changes state
- runtime values synchronize
- Notify changes to online/ready state
- state synchronization should be stable

## Fan

- `GPIO5` is the firmware pin, but app-side rule is simply that Fan state/speed displays correctly
- 5V/9V -> app displays 100%
- manual 12V -> app displays actual selected PWM
- PWM UI should not be active in Adaptive mode

## Peltier

- display ON/OFF
- use correct Phosphor icon
- no unrelated UI changes

## Voltage

- only 5V/9V/12V
- selected row highlighted
- disconnected state handled
- Adaptive mode locks manual voltage controls

## Adaptive

- ON/OFF display
- entering/exiting returns voltage to 5V according to established behavior
- do not break manual voltage control outside Adaptive

## Temperature

- Hotside and Battery values update/sync
- no artificial global display of hidden battery protection logic
- temperature settings remain separate

---

# 24. APP-ONLY SAFETY / DO-NOT-TOUCH AREAS

Unless the user specifically asks:

- do not modify firmware repository logic
- do not rewrite BLE protocol
- do not change service/characteristic UUIDs
- do not change Firebase schema
- do not change production signing identity
- do not remove Firebase App Check
- do not remove Play Integrity provider
- do not disable obfuscation
- do not remove R8
- do not remove secure storage
- do not remove TamperScreen/security checks
- do not remove legacy-command audit protections

---

# 25. RELEASE QUALITY CHECKLIST

Before declaring a change complete:

## Source integrity

- [ ] `main.dart` is complete, not truncated
- [ ] all State classes have `build`
- [ ] `FirmwareUpdateDialog` exists if referenced
- [ ] no unterminated strings
- [ ] braces/parentheses close correctly
- [ ] no partial pasted source

## UI

- [ ] 360 reference visual remains correct
- [ ] 410 test remains consistent
- [ ] 460 test remains consistent
- [ ] Home and Display Menu use one scaling system
- [ ] no menu shrink regression
- [ ] no cooler-size regression
- [ ] no font-size regression
- [ ] no icon-size regression

## BLE

- [ ] connection still works
- [ ] session-ready handshake still works
- [ ] ACK logic still works
- [ ] runtime sync still works
- [ ] reconnect behavior preserved

## Tests

- [ ] `flutter analyze`
- [ ] `flutter test`

## Build

- [ ] production signing works
- [ ] APK signature verified
- [ ] release APK produced
- [ ] desired ZIP artifact produced if that workflow version is active

## Repository

- [ ] only requested files changed
- [ ] this notes file updated
- [ ] changelog updated
- [ ] no accidental backup files committed
- [ ] no unnecessary `.md`/`.txt` junk created

---

# 26. KNOWN FAILURE PREVENTION RULES

These are recurring failure modes and the prevention strategy.

## Failure: `main.dart` becomes truncated

Prevention:

- always start from the complete file
- do not generate partial file output and assume the rest survived
- after edit, inspect end-of-file
- run `flutter analyze`

## Failure: widget overflow

Prevention:

- maintain enough vertical Home canvas height
- current historical stable value: `420 dp`
- keep widget test viewport sufficiently tall

## Failure: Display Menu shrinks at larger DP

Prevention:

- do not scale Home and menu separately
- do not allow submenu content to calculate its own responsive scale
- one root canvas / one transform

## Failure: BLE disconnect/regression after UI change

Prevention:

- do not touch BLE code for UI-only tasks
- preserve `_sendAndConfirm()`
- preserve `_scheduleRuntimeSync()`
- preserve session handshake logic

## Failure: build produces multiple APKs

Prevention:

- upload only the intended production artifact
- if requested, package only `JE-X-FYZ-Latest.apk` into `JE-X-FYZ-Latest.zip`
- do not upload extra debug APKs

## Failure: CI says “green” based on local assumption

Prevention:

- only state CI status based on actual GitHub Actions evidence

---

# 27. CHANGE MANAGEMENT RULE

Every implementation change must answer these questions:

### What was changed?

Exact filename(s), exact area.

### Why?

User requirement / bug.

### What must not change?

List unrelated systems preserved.

### How was it verified?

- local syntax check
- `flutter analyze`
- `flutter test`
- GitHub Actions run
- screenshot/device test

### What is still unknown?

Any part not verified.

### What note update was made?

Update this document.

---

# 28. CURRENT PROJECT STATE SNAPSHOT

## Stable / approved

- JE X FYZ app branding
- Horizon-based UI direction
- Phosphor icon direction
- Home indicator structure
- Notify full-width Home row
- cooler image usage
- BLE connection/handshake behavior previously confirmed working
- Firebase read-only firmware metadata intent
- production signing / security architecture
- obfuscation + split debug symbols
- widget test coverage for basic UI/helpers

## Needs continued validation

- final single-canvas scaling behavior across 360 / 410 / 460 dp
- exact final implementation of the root scale transform
- final CI verification after latest canvas changes
- final GitHub workflow state for ZIP-only artifact

## Do not assume

The latest local `main.dart` artifact is correct just because it was produced.

A real GitHub Actions run is required before calling the latest change stable.

---

# 29. RECENT CONVERSATION DECISIONS

## Decision A — UI scaling

Final user intent:

> **The entire app behaves like one image/canvas.**

Changing Android logical DP must not make the UI unexpectedly smaller or larger physically.

## Decision B — Home + Menu are one visual system

Home and Display Menu must share the same master coordinate system and root scaling.

## Decision C — No split scaling

Do not let Home and Display Menu use separate FittedBox/scale logic.

## Decision D — Preserve existing functionality

UI changes must not modify:

- BLE synchronization
- firmware update logic
- Firebase metadata logic
- security checks
- production signing
- preferences behavior

## Decision E — Documentation is mandatory

This file must be updated with every project change.

---

# 30. CHANGELOG

## 2026-09-22 — Project memory document created

Initial persistent app-only memory document created.

Captured:

- project identity
- repository
- Horizon reference architecture
- UI requirements
- Home indicators
- Notify requirements
- cooler asset rules
- Display Menu requirements
- voltage/control rules
- LED requirements
- temperature requirements
- BLE/app-side synchronization rules
- firmware update metadata contract
- security/architecture audit requirements
- CI workflow
- APK/ZIP artifact direction
- widget test behavior
- GitHub Actions failure history
- major canvas scaling issue
- change-management requirements

## 2026-09-22 — UI canvas/scaling requirement clarified

User clarified that the desired behavior is NOT:

- simple fixed 360 logical dp with empty margins
- independent Home scaling
- independent Display Menu scaling

The desired behavior is:

- one visual canvas
- one master coordinate system
- one root scaling transform
- same physical-looking UI size across Android DP/smallest-width changes such as 360 → 410 → 460

## 2026-09-22 — Build artifact requirement clarified

User requested release download output to be a ZIP rather than exposing the raw APK artifact.

Intended artifact:

`JE-X-FYZ-Latest.zip`

containing:

`JE-X-FYZ-Latest.apk`

Status of workflow deployment must be verified in GitHub before treating it as active.

---

# 31. FUTURE CHANGE LOG TEMPLATE

When making any future change, append an entry using this format:

```md
## YYYY-MM-DD — <Short change title>

### User request
<exact requirement in concise form>

### Files changed
- `path/to/file`
- `path/to/file`

### Implementation
<what was changed>

### Preserved
- <unrelated system 1>
- <unrelated system 2>

### Verification
- `flutter analyze`: PASS / FAIL / NOT RUN
- `flutter test`: PASS / FAIL / NOT RUN
- GitHub Actions: <run ID / URL / NOT RUN>
- Device test: <details>

### Result
<what is now working>

### Known limitations / follow-up
<any unresolved items>
```

---

# 32. ABSOLUTE PROJECT MEMORY RULE

**When a future chat starts and this repository note is available, read this file first before modifying the app.**

The purpose is specifically to prevent:

- repeated explanations from the user
- forgotten constraints
- accidental regression of BLE
- broken UI scaling
- lost dialog classes
- malformed `main.dart`
- repeated CI failures
- repeated artifact mistakes
- accidental changes to unrelated systems

The latest approved user direction always takes precedence over old assumptions, but old implementation history must be read so that known regressions are not recreated.

---

# 33. APP-ONLY SCOPE NOTICE

This document intentionally does **NOT** attempt to become the firmware project memory.

Firmware-specific implementation details such as:

- GPIO pin implementation
- MOSFET wiring
- NTC electrical calculations
- ESP32 C3 Super Mini radio behavior
- OTA LED sequences
- thermal firmware state machine
- firmware-side safety timing
- firmware-side hardware control

belong in a separate firmware documentation file.

The app notes may record the **app contract** with firmware, but should not be expanded into a firmware design document.

---


## 2026-09-23 — Notify latest-event refinement

### User request
- Keep Notify text on one line.
- Long Notify text must fit instead of being clipped.
- Use professional, simple, minimal wording while preserving meaning.
- Route meaningful changes, confirmations, errors, and device/app events into Notify.
- Show only the latest event; do not build a history/log list.

### Files changed
- `lib/main.dart`
- `APP_NOTES.md`

### Implementation
- Added `_compactNotifyMessage()` to normalize common Notify/status messages into short professional English.
- Reduced the base Notify message font from `11.5` to `10.5`.
- Wrapped Notify state/message text in `FittedBox(fit: BoxFit.scaleDown)` with `maxLines: 1` and `softWrap: false`, so long messages remain one line and scale down to fit the available Notify width.
- Added `_notifyCommandAccepted()` and connected it to successful `_sendAndConfirm()` operations so accepted voltage, Fan, Peltier, Adaptive, LED, Fan Speed, limit, color, and reset changes become the latest Notify message.
- Added Notify failure messages for voltage and temperature/battery-limit operations that previously only reverted the draft value without a visible status message.
- Routed existing `_showSnackBar()` events through the same compact Notify normalization.
- Kept only the latest message in the existing `notice` field; no event history was introduced.
- Periodic telemetry is intentionally not converted into per-second Notify events because that would continuously overwrite the latest status and create spam.

### Preserved
- BLE handshake/session processing
- `_sendAndConfirm()` ACK flow
- 90 ms runtime synchronization scheduling
- BLE reconnect/disconnect behavior
- Firebase read-only firmware metadata
- security/signing architecture
- canvas/scaling architecture
- all unrelated control logic

### Verification
- `flutter analyze`: NOT RUN — Flutter/Dart SDK is not available in this environment.
- `flutter test`: NOT RUN — Flutter/Dart SDK is not available in this environment.
- GitHub Actions: NOT RUN.
- GitHub repository write: ATTEMPTED; GitHub connector returned HTTP 403 `Resource not accessible by integration`.
- Local source integrity: file length changed from the current GitHub source's 114,606 bytes to 118,455 bytes; line count changed from 3,229 to 3,350. The modified file was generated from the exact current GitHub `main` blob before editing.

### Result
The Notify area now uses a compact professional latest-event model and keeps long messages on one line by scaling the text down instead of clipping it.

### Known limitations / follow-up
A real device screenshot test and a fresh GitHub Actions run are still required before declaring this change fully stable. The prepared `main.dart` has been saved locally, but the repository could not be updated automatically because the GitHub integration currently lacks write permission.

## 2026-09-25 — Canvas physical-size compensation + Notify label height fix

### User request
- The outer canvas must fit the phone screen instead of becoming visibly tiny at lower logical widths such as 320 dp.
- Changing Android logical DP/smallest-width (for example 320 -> 420) must not independently change the physical-looking size of the UI content.
- Notify green state label (`NOTIFY • WARNING`, etc.) must retain the earlier normal height; only the main message text should scale down to keep a long message on one line.
- Project rule reaffirmed: discuss first; execute only after the user explicitly approves.

### Files changed
- `lib/main.dart`
- `APP_NOTES.md`

### Implementation
- Replaced root canvas scaling based on `constraints.maxWidth / 360` with physical-width/density compensation.
- The outer Scaffold/background continues to fill the current screen.
- The single JE X FYZ canvas uses the current `devicePixelRatio` to compensate logical-DP changes.
- The reference physical width is 1080 px, matching the provided 1080-pixel screenshots; the design is capped at that physical width and only scales down when the physical viewport is narrower.
- Home and Display Menu remain under the same single root canvas transform.
- Restored the Notify state label to its previous plain one-line `Text` treatment so its vertical height is not altered.
- Kept `FittedBox(BoxFit.scaleDown)` only on the main Notify message, preserving the one-line long-text requirement.

### Preserved
- BLE handshake/session behavior
- `_sendAndConfirm()` ACK flow
- 90 ms runtime synchronization
- BLE reconnect/disconnect behavior
- Firebase read-only firmware metadata
- security/signing architecture
- control command set
- existing Home and Display Menu visual structure
- latest-event Notify model

### Verification
- `flutter analyze`: NOT RUN — Flutter/Dart SDK is unavailable in this environment.
- `flutter test`: NOT RUN — Flutter/Dart SDK is unavailable in this environment.
- GitHub Actions: NOT RUN after this change.
- Static source check: completed; file remains structurally complete.
- GitHub repository write: not available through the current integration (previous 403 permission error).

### Result
The root canvas no longer derives its scale directly from logical viewport width. Physical display width and density are used so changing Android DP does not make the UI unexpectedly tiny/large on the same physical display. The Notify green state label is restored to normal height while long message text remains one-line and can scale down to fit.

### Known limitations / follow-up
The 320/420/430/460/500 dp matrix still needs real-device screenshot validation after building the updated source. The 1080 physical-pixel reference is derived from the provided screenshots and should be confirmed against the actual target device resolution before treating the scaling implementation as final.

## 2026-09-25 — Final canvas behavior clarified and root scaling corrected

### User request
The app must behave like one fixed visual canvas. For the same physical display, changing Android Smallest Width / DP (for example 320, 360, 420, 430, 460, 500) must not make the UI smaller, larger, or reposition individual elements. When the physical screen itself is different, the complete canvas may scale uniformly to fit the new physical screen.

### Files changed
- `lib/main.dart`
- `APP_NOTES.md`

### Implementation
- Removed the hard cap on the canvas at a fixed 1080 physical-pixel width.
- The root dashboard now uses one scale factor derived from the current logical viewport width relative to the 360 dp master design width: `scale = constraints.maxWidth / designWidth`.
- Because Flutter logical width changes inversely with Android density on the same physical display, the rendered physical size remains stable when Smallest Width/DP changes on that same display.
- The entire Home + Notify + Display Menu remains inside one root transform/canvas, so all elements scale together rather than independently.
- The vertical size of the canvas is derived from the available viewport height after the single width scale. The fixed Home section stays fixed in the master design, while a physically/vertically longer viewport gives additional space to the Display Menu below instead of stretching the Home elements.
- Existing Notify behavior is preserved: the green state label stays at normal fixed design sizing; only the message line can scale down to remain on one line.

### Preserved
- BLE handshake/session behavior
- `_sendAndConfirm()` ACK flow
- 90 ms runtime synchronization scheduling
- BLE reconnect/disconnect behavior
- Firebase read-only firmware metadata
- security/signing architecture
- Notify latest-event model
- all unrelated control logic

### Verification
- `flutter analyze`: NOT RUN in this environment
- `flutter test`: NOT RUN in this environment
- GitHub Actions: NOT RUN after this local change
- Local source integrity: scaling block replaced from the current project artifact; source remains a complete `main.dart` with `FirmwareUpdateDialog` present.

### Result
The root canvas no longer has a 1080 physical-pixel cap. A same-device DP/density change should keep the visual UI size stable while still filling the screen, and a genuinely different physical screen can receive one uniform canvas scale.

### Known limitations / follow-up
Real-device validation is required on the requested matrix (same physical device at 320/360/420/430/460/500 DP where available, plus at least one physically different phone) before declaring this fully stable.

## 2026-09-25 — Notify vertical text centering + offline validation-state fix

### User request
- The Notify card position itself was already correct; the problem was the green Notify state label sitting too close to the top edge of the card.
- Center the two-line Notify text group more naturally inside the existing Notify card, matching the provided reference screenshot.
- Keep the card height/position, icon, and OFFLINE badge unchanged.
- Also prevent an offline dashboard from showing the sensor-validation message as `NOTIFY • WARNING` when no device is connected.

### Files changed
- `lib/main.dart`
- `APP_NOTES.md`

### Implementation
- Reworked the Notify text column to use `mainAxisSize: MainAxisSize.min` with vertical centering, so `NOTIFY • ...` and the latest message are centered as one compact group instead of the message `Expanded` child consuming the remaining vertical space and pulling the state label upward.
- Kept the green Notify state label at its normal design size; no `FittedBox` was added around the label.
- Kept one-line message behavior by putting only the message in a fixed-height `FittedBox`/`LayoutBuilder` area, allowing the message to scale down horizontally without affecting the label position.
- Updated `_professionalNotice()` so stale `WAITING_FOR_NTC` / `WAITING_FOR_SENSOR_VALIDATION` text is not displayed while the dashboard is offline. Offline now falls back to `Bluetooth disconnected.` unless there is another explicit latest event such as a connection failure or device-not-found message.
- Updated `_notifyStateLabel()` so `WAITING_*` safety state is not promoted to `NOTIFY • WARNING` while disconnected. Safety warning labeling is now gated by `connected == true` and excludes the normal sensor-validation states.

### Preserved
- Existing 44 px Notify card height and card placement in Home
- Notify icon and status badge layout
- One-master-canvas scaling architecture
- BLE handshake/session and reconnect behavior
- `_sendAndConfirm()` ACK flow and runtime sync
- Firebase read-only firmware metadata
- security/signing architecture
- latest-event Notify model
- all unrelated control/safety/temperature logic

### Verification
- `flutter analyze`: NOT RUN — Flutter/Dart SDK is unavailable in this environment.
- `flutter test`: NOT RUN — Flutter/Dart SDK is unavailable in this environment.
- GitHub Actions: NOT RUN after this local change.
- Local source integrity: updated from the complete local `main.dart`; file ends with the expected closing class braces.
- GitHub repository write: not available through the current integration (previous 403 permission error).

### Result
The Notify text group is now vertically centered inside the existing card while only the message line can scale down. Offline startup/disconnect states no longer masquerade as a sensor-validation warning.

### Known limitations / follow-up
A real-device screenshot/build test is still required to visually confirm the exact vertical offset against the provided reference image.

## 2026-09-26 — Connection sheet + lazy Bluetooth/Location access + realtime indicators + minimalist copy pass

### User request
- Do not request or enable Bluetooth/Location automatically when JE Cooler starts.
- Trigger the permission/activation flow only after the Home Bluetooth icon is tapped.
- Keep Location as a compatibility requirement only where the Android platform still requires it for BLE scanning.
- Replace the long Bluetooth sheet with a compact bottom sheet aligned to the same top position/width and top-corner geometry as the Display Menu, using the existing modal bottom-up animation.
- Rename the sheet title to `Connection`.
- Add live Bluetooth and Location indicators with changing Phosphor icons and status colors. Tapping an indicator must open the relevant Android Settings/recovery path after a permission denial or system-off state.
- Apply the agreed minimalist wording across user-facing UI text without changing BLE command/telemetry tokens.

### Files changed locally
- `main.dart`
- `MainActivity.kt`
- `APP_NOTES.md`

### Implementation
- Removed `_requestPermissions()` from `DashboardScreen.initState()`. App launch no longer opens Bluetooth/Location permission prompts and no longer attempts to turn Bluetooth on.
- `_requestPermissions()` now returns a readiness result. Bluetooth Scan + Connect remain the primary BLE access requirements.
- Location permission is requested only on Android SDK <= 30. On newer Android versions it is not used as a BLE prerequisite.
- Existing `FlutterBluePlus.turnOn()` behavior is preserved, but is reachable only from the explicit Bluetooth/scan interaction.
- Added Android SDK lookup and Bluetooth Settings intent support through the existing `je_x_fyz/battery_temp` MethodChannel.
- Replaced the old 67%-screen Bluetooth sheet with one compact sheet whose top position is derived from the same 360 dp master design and 420 dp Home height used by the Display Menu. It uses the same 34 px top radius.
- Added realtime indicators while the Connection sheet is open. Status refresh runs every 650 ms and reads the actual Bluetooth adapter state, Bluetooth permissions, Location service state, and legacy Location permission state.
- Status colors/icons:
  - Bluetooth/Location ON: Mint `#63E6BE`
  - System OFF: Amber `#FFB74D`
  - Required permission denied: Red `#FF6B7A`
  - OFF icons use `BluetoothSlash` / `MapPinSlash`
- Indicator tap behavior:
  - Bluetooth permission denied -> Android app settings for permission recovery.
  - Bluetooth allowed but adapter OFF -> Bluetooth system settings.
  - Legacy required Location permission denied -> Android app settings.
  - Location permission available but service OFF -> Location system settings.
- Scan is blocked cleanly when required access is missing instead of proceeding into a known-invalid BLE scan state.
- Simplified user-facing copy in the main screens, firmware dialog, Notify event text, and status messaging while preserving technical/internal protocol strings.

### Preserved
- JE X FYZ BLE UUID contract
- SYNC -> SYNC_READY handshake and bonding recovery
- runtime sync and phone battery telemetry
- Firebase firmware metadata read-only behavior
- production security/signing/App Check architecture
- one-master-canvas scaling
- latest-event Notify model and the previously approved centered Notify layout
- Home/Display Menu structure and unrelated cooling control logic

### Verification
- Before editing, the authoritative GitHub `main` branch and latest `APP_NOTES.md` were fetched and inspected, per the project mandatory rule.
- GitHub source SHA read before edit: `lib/main.dart` `74ff0dcf9cbfe81021773283059b1c42ab191004`.
- GitHub `APP_NOTES.md` SHA read before edit: `3dfd6e3c52f51572b05aafdf68cc7922dbd6bca5`.
- GitHub direct write was attempted for the requested change but the current integration returned HTTP 403 `Resource not accessible by integration`; therefore no GitHub commit is claimed for this change.
- Local changed sources were written to `/mnt/data/main.dart`, `/mnt/data/MainActivity.kt`, and `/mnt/data/APP_NOTES.md`.
- `flutter analyze`: NOT RUN — Flutter/Dart SDK is unavailable in this environment.
- `flutter test`: NOT RUN — Flutter/Dart SDK is unavailable in this environment.
- GitHub Actions: NOT RUN. The available GitHub integration does not expose workflow dispatch.

### Known follow-up / risks
- Real-device validation is still required for Android <= 30 Location behavior, Android permission-denial recovery, returning from system Settings, exact sheet top alignment against Display Menu, and availability of `BluetoothSlash` / `MapPinSlash` in the pinned `phosphor_icons` package.

### Result
- Startup is quiet.
- Bluetooth access/activation is interaction-driven.
- Connection sheet is compact and aligned to the Display Menu geometry.
- Bluetooth/Location status is live while the sheet is open and offers recovery actions.
- UI wording is shorter and more consistent without changing the BLE protocol contract.


## 2026-09-26 — GitHub write access recheck + current repository baseline

### User request
- Re-check whether ChatGPT can now write to the JE X FYZ repository.
- Update this project memory only if the GitHub write actually succeeds.
- Keep GitHub Actions execution manual by the user; ChatGPT can read runs/artifacts after the user starts them.

### Current repository state checked before this note update
- Repository: `TenzoNkz/JEXFYZ-App`
- Branch: `main`
- Current `lib/main.dart` blob SHA: `d18db65ebc30f1f92e0d40e564096c14569aebaa`
- Current `APP_NOTES.md` blob SHA before this update: `230a7eb0197f52816865be6335881cc1001458da`
- Latest observed GitHub Actions run: **#92**, run ID `36090775126`
- Run #92 status: **success**
- Run #92 head SHA: `98d275ef50a9445e9412ebeda80d3fb639a7ad54`
- Run #92 produced `JE-X-FYZ-Latest.zip` and the artifact was not expired at the time of inspection.
- The current `main` HEAD is newer than the commit used by Run #92, so that APK is not automatically considered a build of the current HEAD.

### GitHub write verification
- An update to this exact `APP_NOTES.md` file is being attempted now using its current blob SHA.
- The result of this update must be treated as the authoritative test of current GitHub write access.
- Do not claim GitHub write access is available unless this update returns a successful commit/content SHA.
- Do not claim GitHub Actions can be dispatched from the available integration; workflow run creation remains a separate capability from repository file writing.

### Project workflow rule reaffirmed
For every future app change:
1. Read the latest `APP_NOTES.md`.
2. Read the current GitHub `main` source/files that are relevant to the change.
3. Discuss the requested change first.
4. Execute only after explicit user approval.
5. Update the living project notes in the same change.
6. Verify GitHub state after any successful repository write.
7. Keep Actions execution manual unless a future integration explicitly exposes workflow dispatch.

### Verification status
- This note entry records the current baseline and the write-access test.
- Flutter analyze/test status remains dependent on a real GitHub Actions run or an environment with Flutter/Dart SDK.
- Real-device validation remains required for BLE permission/settings flow and the compact Connection sheet.


## Build App execution protocol

- User command `Build App` means execute the build flow immediately; do not ask for extra confirmation.
- Normal path: Build the latest verified `main` source with GitHub Actions → verify completion/artifact → download the built app into the conversation.
- Failure path: Build → inspect the failing CI/analyze/test/build step and logs → make only the narrowly-scoped code/config fix required for the failure → update `APP_NOTES.md` with the fix → rebuild → when successful, download the final app into the conversation.
- Do not introduce unrelated feature/UI changes while fixing a build failure.
- Every completed build must be shared using the artifact filename convention `JE X FYZ Build #N.apk`, where `#N` is the actual GitHub Actions run number that produced the APK.
- Keep a ZIP only when it is useful or specifically requested; the default delivery after `Build App` is the APK itself.
- After every meaningful code/config/build change, update the persistent project memory so the next Code/Action sub-chat has the latest state.
- The user should be able to issue only `Build App` and receive the resulting working APK in the conversation when the build succeeds.

## Persistent project-memory rule

- Treat `APP_NOTES.md` as the living memory of JE X FYZ.
- After every meaningful project change, update the notes with the new state, files changed, purpose/behavior, verification status, and any follow-up or risk.
- Record build/CI results and artifact information using the real GitHub Actions run number.
- Keep Code and Action sub-chats synchronized through this file; the latest verified repository state and latest relevant note entry take precedence over older chat context.
- Do not silently discard prior decisions, fixes, constraints, or known limitations when starting a new sub-chat.
- This memory is continuously expanded and corrected as the project evolves.

## 2026-09-26 — GitHub firmware source + public OTA distribution

### User-approved implementation
- The authoritative firmware source is stored under `firmware/JEXFYZ.ino` in the private app repository.
- The app no longer reads firmware release metadata from Firebase Realtime Database.
- Firmware release metadata is consumed from the public GitHub manifest over HTTPS.
- Firebase remains enabled for App Check / Play Integrity security. Daily usage telemetry is only a future idea and is not implemented here.
- Existing BLE OTA commands remain unchanged.

### App files changed
- `lib/main.dart`
- `pubspec.yaml`
- `.github/workflows/app-build.yml`
- `firmware/JEXFYZ.ino`
- `.github/workflows/firmware-build.yml`
- `FIRMWARE_NOTES.md`

### Build / handoff
- The firmware workflow auto-runs when `firmware/JEXFYZ.ino` changes and also supports manual dispatch.
- It compiles ESP32-C3 firmware, uploads an artifact, then publishes the `.bin` and manifest to public `TenzoNkz/JEXFYZ-Firmware`.
- Required GitHub Actions secret: `FIRMWARE_REPO_TOKEN` with Contents write access to the public firmware repository. Secret creation is not exposed through this integration.
- A V3.2 baseline manifest has been created in the public repository using the existing binary endpoint; the automated workflow will replace that manifest after its first successful build.
- No Flutter build was run as part of this code execution.


## 2026-09-26 — Unified build execution trigger architecture

### User-approved execution model
- Removed manual `workflow_dispatch` triggers from both `App Build` and `Firmware Build`.
- `App Build` now starts only when `.github/APP_BUILD_TRIGGER` changes.
- The Action / Build sub-chat will update the app trigger file only when the user explicitly says to build the app.
- `Firmware Build` starts automatically when `firmware/JEXFYZ.ino` changes, even when the same commit also contains unrelated files.
- The Code sub-chat can also explicitly execute the firmware pipeline by updating `.github/FIRMWARE_BUILD_TRIGGER`, without changing firmware source or version.
- No workflow itself is included in the push-path trigger list, so editing workflow configuration does not recursively start a build.

### Workflow files
- Renamed the App workflow file from `.github/workflows/app-build.yml` to `.github/workflows/app-build.yml`; workflow display name remains `App Build`.
- `.github/workflows/app-build.yml`: push-only trigger on `.github/APP_BUILD_TRIGGER`; no manual dispatch.
- `.github/workflows/firmware-build.yml`: push-only triggers on `firmware/JEXFYZ.ino` and `.github/FIRMWARE_BUILD_TRIGGER`; no manual dispatch.
- Added `.github/APP_BUILD_TRIGGER`.
- Kept `.github/FIRMWARE_BUILD_TRIGGER`.

### Firmware distribution layout
- Public firmware repository: `TenzoNkz/JEXFYZ-Firmware`.
- Release binary is now intended at the public repository root as `JEXFYZ-Vx.x.bin`.
- The publish workflow removes legacy `JEXFYZ.cpp.bin` and old root `JEXFYZ-V*.bin` files, then writes the current versioned binary to the root.
- `manifest.json` now points to the root raw URL:
  `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-Vx.x.bin`.
- The `releases/` directory is no longer part of the distribution workflow.

### Execution verification
- Repository workflow configuration was verified after commit.
- Setup of the new trigger files inherently started App Build Run #96 and Firmware Build Run #9; these runs were not a source-code feature build request.
- Run #96: in progress at the time of this note update.
- Run #9: in progress at the time of this note update.
- Firmware publishing remains dependent on the existing `FIRMWARE_REPO_TOKEN` Actions secret; the previous Run #8 failed only at that publish step because the secret was unavailable.
## CHANGELOG
### 2026-09-26 — GitHub firmware source + public OTA distribution
- Added private firmware source and automated firmware build/publish pipeline.
- App firmware metadata moved from Firebase Realtime Database to the public GitHub manifest.
- Firebase App Check / Play Integrity remains enabled; daily usage telemetry is not implemented.
- First automated firmware publish requires the FIRMWARE_REPO_TOKEN secret.

### 2026-09-26 — Native foreground service for background BLE continuity

- Added `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt`.
- Updated `MainActivity.kt` with native start/stop methods through the existing MethodChannel.
- Updated `lib/main.dart` to start the foreground service after successful BLE synchronization and stop it when BLE disconnects.
- Updated `AndroidManifest.xml` with foreground-service permissions and a `connectedDevice` service declaration.
- The service does not create a second BLE client; Flutter remains the single owner of the BLE/session protocol.
- Updated shared memory with the exact implementation and Build / CI handoff. Fresh build and physical-device validation are pending.

### 2026-09-26 — Direct JEXFYZ#RUN APK output

- Updated `.github/workflows/app-build.yml` so the release APK is copied to `JEXFYZ#${{ github.run_number }}.apk`.
- Removed ZIP packaging and the ZIP-only artifact upload path.
- The workflow now uploads the direct APK with `archive: false` and a matching artifact name.
- Recorded the Run #95 filename problem and the expected next validation in the shared CI state.
- No application Dart/UI/BLE logic was changed.

### 2026-09-26 — Mandatory shared-memory preflight before every execution

- Added the requirement that both Code and Action read the latest `APP_NOTES.md` from `main` before executing any project action.
- Defined the common preflight order: read memory, understand current state/handoff, execute, then write the new state back to shared memory.
- Clarified that neither sub-chat may rely only on its own chat history when the shared Notes provide a newer verified state.


### 2026-09-26 — Mandatory shared-memory update for every Code and Action change

- Explicitly required both `JE X FYZ Code #N` and `JE X FYZ Action #N` to update `APP_NOTES.md` whenever they make a project-controlled change.
- Required each side to record the actual change, reason, affected files, resulting state, validation/build result, and handoff information needed by the other side.
- Clarified that Action-originated fixes must be written back to shared memory so Code can see exactly what was changed.


### 2026-09-26 — Reinforced mandatory memory update on every project change

- Reinforced that every app code, configuration, workflow, CI/build behavior, or other project behavior change must update `APP_NOTES.md` in the same change.
- Established that a project change is not considered complete until its relevant state/memory has been recorded for both Code and Action sub-chats.

### 2026-09-26 — Finalized bidirectional shared-memory protocol

- Both Code and Build / CI sub-chats now explicitly share one persistent project memory and must read/write the latest state for handoff.
- Code records changes and build handoff requirements; Action records build/CI results and artifact state.
- Build / CI is allowed to directly fix narrowly-scoped source/configuration problems required to resolve build, analyze, test, packaging, or CI failures, then rerun and document the exact fix.
- The Code sub-chat must be able to learn from Notes what Action found wrong and what Action changed.
- Ordinary code changes do not automatically trigger builds; build execution remains a separate Build / CI responsibility.

### 2026-09-26 — Recorded latest successful Action Run #94

- Verified GitHub Actions Run #94 (`36197719113`) completed successfully.
- Recorded the built head SHA, successful build job, ZIP artifact ID/size, and symbol artifact ID for the Build / CI sub-chat.
- Recorded that there is no unresolved CI error from Run #94.
- Added a dedicated CURRENT ACTION / CI STATE section so the Build / CI sub-chat can immediately read the latest handoff state.

### 2026-09-26 — JE X FYZ sub-chat naming convention

- Updated the code-change sub-chat naming format from `JE X FYZ #N` to `JE X FYZ Code #N`.
- The limit suffix remains `JE X FYZ Code #NLimit` before starting the next numbered code-change sub-chat.

- Recorded the numbering convention for code-change chats: `JE X FYZ #1`, `#2`, `#3`, etc.
- Recorded the limit suffix convention: rename the exhausted chat to `#NLimit` before starting `#N+1`.
- Recorded the independent Build / CI naming convention: `JE X FYZ Action #1`, `#2`, `#3`, etc., with the same `Limit` suffix when a chat reaches its limit.
- Clarified that chat titles are a human/UI convention and the latest project notes remain mandatory context regardless of title.

### 2026-09-26 — Two-sub-chat workflow + persistent memory rules

- Defined the code-change sub-chat as the place for app discussion, source/config changes, debugging, and implementation.
- Defined a separate build/CI sub-chat for manual workflow triggering, build/analyze/test error inspection, CI diagnosis, and artifact download.
- Build must not automatically trigger from every code change; build requests are intentionally separated from code-change work.
- Added a persistent-memory rule requiring `APP_NOTES.md` to be updated alongside every app/config/workflow change so important project state is not lost across sub-chat limits.
- Clarified that note-only changes do not trigger builds and do not recursively require another note entry.


### 2026-09-26 — Mandatory notes continuity across sub-chats

- Added an explicit rule that the latest `APP_NOTES.md` on `main` must be read before any JE X FYZ app discussion, review, debugging, modification, or validation.
- The rule applies to every new sub-chat, including when a previous sub-chat reaches its context limit.
- The purpose is to preserve project continuity so the user does not need to re-explain established architecture, decisions, constraints, bugs, or fixes.
- Memory from an earlier sub-chat is not a substitute for retrieving the current notes.


## 2026-09-26 — Repository notes/workflow naming cleanup

### User request
- Rename the GitHub Actions display names to `App Build` and `Firmware Build`.
- Move the firmware notes file from `firmware/` to the repository root.
- Rename the notes files to `APP_NOTES.md` and `FIRMWARE_NOTES.md`.
- Remove the Dependabot Updates entry from the GitHub Actions view.

### Changes
- Renamed the workflow display name in `.github/workflows/app-build.yml` from `JE X FYZ Cooler Build` to `App Build`.
- Renamed the workflow display name in `.github/workflows/firmware-build.yml` from `JE X FYZ Firmware Build` to `Firmware Build`.
- Moved and renamed the app notes from `APP_PROJECT_NOTES.md` to `APP_NOTES.md`.
- Moved and renamed the firmware notes from `firmware/FIRMWARE_PROJECT_NOTES.md` to `FIRMWARE_NOTES.md`.
- Updated note references to use the new filenames and root-level firmware-notes location.

### Dependabot
- No repository file for a Dependabot workflow/configuration is present under `.github`; the GitHub Actions page's `Dependabot Updates` entry is platform-managed and is not removable through the repository file changes exposed by the current GitHub integration.
- No unrelated Dependabot configuration was changed.

### Verification
- Workflow display names remain `App Build` and `Firmware Build`.
- Current trigger policy is file-based explicit execution only.


## 2026-09-26 — Build trigger ownership / execution split

### User-approved workflow
- **App Build** does not auto-trigger from ordinary repository/app changes.
- **App Build** starts only from the dedicated **JE X FYZ Action** sub-chat after `Build App`.
- **Firmware Build** does not auto-trigger from `firmware/JEXFYZ.ino` changes.
- Firmware Build starts only after the separate explicit `Eksekusi Firmware` command.
- The two workflows remain independently named **App Build** and **Firmware Build**.

### Current repository behavior
- `.github/workflows/app-build.yml` already uses `workflow_dispatch` for App Build.
- `.github/workflows/firmware-build.yml` already has a push trigger for `firmware/JEXFYZ.ino` and also retains manual dispatch support.
- No application build is triggered merely because app source files change.


## 2026-09-26 — Firmware manual trigger added for Code sub-chat execution

- Added `.github/FIRMWARE_BUILD_TRIGGER` as a dedicated CI trigger file.
- Firmware Build now auto-runs on changes to `firmware/JEXFYZ.ino` or the dedicated trigger file.
- This gives the Code sub-chat a safe way to execute the existing firmware pipeline without modifying firmware source/version solely to start CI.
- The actual firmware source and firmware version remain unchanged by a trigger-only execution.
- App Build remains manual and belongs to the JE X FYZ Action sub-chat.


## 2026-09-26 — Firmware Build Run #6 compatibility fixes

- Firmware Build execution reached the ESP32-C3 compile step and failed against Arduino ESP32 core 3.2.1 because three BLE APIs used by the V3.2 source no longer match the pinned core API.
- Narrow source fixes were applied in `firmware/JEXFYZ.ino` only:
  - `setAuthenticationMode(true, false, true)` → `setAuthenticationMode(ESP_LE_AUTH_REQ_SC_BOND)`.
  - Removed unavailable `BLEServer::advertiseOnDisconnect(true)`; the existing `ServerCallbacks::onDisconnect()` already restarts advertising.
  - `ESP_GATT_PERM_WRITE_ENC` → `ESP_GATT_PERM_WRITE_ENCRYPTED`.
- Firmware behavior/architecture was otherwise left unchanged.
- The firmware version remains V3.2; this is a compatibility build fix, not a feature/version release decision.
- Commit: `3affa13a97d63eac1777ec2c6315fed9f8720a48`.
- Run #6 must be revalidated after this fix; do not claim firmware publish success until the complete Build → artifact → public repository publish pipeline succeeds.


## 2026-09-26 — Firmware Build Run #7 size fix

- Run #7 passed the BLE API compatibility stage and reached compilation, then failed because the generated firmware was 1,826,576 bytes (139%) while the default ESP32-C3 app partition is 1,310,720 bytes.
- The workflow was changed to compile with the OTA-capable `min_spiffs` partition scheme, which provides larger dual OTA app slots while retaining OTA functionality.
- Only `.github/workflows/firmware-build.yml` was changed for this build fix; firmware source behavior remains unchanged.
- Next Firmware Build run must verify compile, artifact upload, and public repository publish.


## 2026-09-26 — Firmware Build Run #8 result

- Run #8 used the new firmware execution trigger and successfully compiled the V3.2 firmware with the OTA-capable min_spiffs partition.
- Compile result: 1,826,608 bytes (92% of 1,966,080-byte app slot).
- Firmware artifact uploaded successfully: artifact ID 10894158538 from the preceding successful compile attempt, containing `JEXFYZ-V3.2.bin`.
- Final publish step failed because the `FIRMWARE_REPO_TOKEN` Actions secret was empty/unavailable to the workflow.
- No publish-success claim is made until the secret is available and a full run reaches the public repository push.


## 2026-09-26 — Final build trigger policy correction

- App Build and Firmware Build both use file-based explicit execution triggers.
- Neither workflow uses `workflow_dispatch`.
- Neither workflow should start from ordinary source changes.
- App: only `.github/APP_BUILD_TRIGGER` starts App Build, and Action sub-chat updates it only after the user says `Build App`.
- Firmware: only `.github/FIRMWARE_BUILD_TRIGGER` starts Firmware Build, and Code sub-chat updates it only after the user says `Eksekusi`.
- Firmware source changes alone must not start CI.
- The explicit firmware execution may cover a firmware-only change or a commit containing firmware together with unrelated/other project files.

## 2026-09-26 — Final separation of Code editing vs Firmware build vs Action build

### JE X FYZ Code sub-chat
- Discussion comes first. No repository execution/build is started merely because we are discussing or preparing changes.
- After the user explicitly says `Eksekusi`, apply all agreed source/configuration/documentation changes across the App repository as discussed.
- Plain `Eksekusi` in Code means **apply the agreed repository changes only**.
- Plain `Eksekusi` in Code does **NOT** update `.github/FIRMWARE_BUILD_TRIGGER` and does **NOT** start Firmware Build or produce a firmware `.bin`.
- Firmware build is a separate explicit action controlled by the user.

### Firmware `.bin` execution
- The Firmware Build workflow is deliberately decoupled from firmware source changes.
- Changing `firmware/JEXFYZ.ino`, app files, notes, or other repository files does not start the Firmware Build.
- Only an explicit firmware-build command may update `.github/FIRMWARE_BUILD_TRIGGER` and start Firmware Build.
- The intended command distinction is: `Eksekusi` = apply Code changes; `Eksekusi Firmware` = build firmware `.bin`.
- Firmware CI must then be monitored through completion; build failures are fixed narrowly and the workflow is rerun until the requested firmware execution is verified.

### JE X FYZ Action sub-chat
- Action sub-chat is dedicated to App Build only.
- When the user says `Build App`, trigger App Build through `.github/APP_BUILD_TRIGGER`.
- Monitor App Build, fix build/analyze/test/package failures narrowly, rerun as required, and only after success provide the resulting APK artifact to the chat.
- Action sub-chat must not trigger Firmware Build.

### Workflow trigger rule
- Both workflows use file-based explicit triggers only; neither uses `workflow_dispatch`.
- App Build trigger file: `.github/APP_BUILD_TRIGGER`.
- Firmware Build trigger file: `.github/FIRMWARE_BUILD_TRIGGER`.
- Ordinary source changes must never be treated as build commands.


## 2026-09-26 — AUTHORITATIVE DISCUSSION → EXECUTION RULE

The project process is now explicitly two-phase:

### Phase 1 — Discussion first
- Every requested change is discussed/reviewed first.
- During discussion, no repository execution and no build is started.
- Proposed changes, affected files, expected behavior, preserved behavior, and risks are resolved before execution.

### Phase 2 — Explicit user command
- The exact command determines the action:
  - **`Eksekusi`** = apply all code/configuration/documentation fixes agreed during the discussion to the repository. This means make the discussed code correct across the relevant project files. It does **not** build App APK and does **not** build/publish firmware `.bin`.
  - **`Eksekusi Firmware`** = take the latest already-applied firmware source and build the newest firmware `.bin`, then publish it to the public `TenzoNkz/JEXFYZ-Firmware` repository using the configured Firmware Build pipeline. It is a separate action from applying source changes.
  - **`Build App`** in the Action sub-chat = trigger and complete the App Build workflow, repair build/CI failures narrowly when required, and deliver the verified APK artifact to chat.

### Strict separation
- Plain `Eksekusi` must never trigger `.github/APP_BUILD_TRIGGER` or `.github/FIRMWARE_BUILD_TRIGGER`.
- Plain `Eksekusi` must never compile or publish the firmware.
- `Eksekusi Firmware` is the only command in the Code workflow that intentionally updates `.github/FIRMWARE_BUILD_TRIGGER`.
- App Build remains exclusive to the Action sub-chat.
- Ordinary source changes never trigger either build workflow automatically.

## 2026-09-26 — Code #2 execution: documentation/state synchronization

### Command
- User command: `Eksekusi Code`.

### Result
- Reviewed the latest repository memory and reconciled the active execution policy.
- No additional source-code change was required from the immediately preceding discussion; that discussion established the workflow/execution rules rather than a new application feature or code modification.
- The repository remains build-free after this Code execution. No App Build trigger and no Firmware Build trigger was updated.

### Authoritative current workflow
- Discussion always happens before execution.
- `Eksekusi` in Code means apply all code/configuration/documentation changes that were agreed during the discussion.
- `Eksekusi` does not build the APK and does not build/publish firmware.
- `Eksekusi Firmware` is a separate command for the latest firmware `.bin` build and public firmware publication.
- `Build App` belongs only to the Action sub-chat.
- Ordinary source changes never trigger either build workflow automatically.

### Documentation hygiene
- This note's end marker is kept at the actual end of the document so appended changelog entries remain part of the active memory file.

## 2026-09-26 — App Build Run #2 analyzer fix

- Run #2 (`36212485388`) reached `flutter analyze` and failed on `lib/main.dart:3733` because the Firmware dialog Retry button still referenced the removed `_checkFirebase` method.
- Analyzer also reported an unnecessary cast at `lib/main.dart:3659`; this was a warning, not the build-stopping error.
- Action fixed `lib/main.dart` narrowly: Retry now calls `_checkGitHub`, and the redundant `decoded as Map` cast was removed.
- Fix commit: `9ee79ab5041a5cdd8e00aaa01fcb0430b65c2801`.
- No unrelated UI, BLE, foreground-service, or firmware behavior was changed.
- A new App Build is required to validate analyze/test/release/signing/artifact after this fix.

## 2026-09-26 — V3.5 OTA PANIC TEST HANDOFF

- User manually flashed V3.4 after the previous online OTA attempt caused a firmware panic.
- Firmware source is now intentionally versioned as V3.5 so a running V3.4 device will see the public test package as a newer firmware release.
- `lib/main.dart` source documentation was synchronized from V3.4 to V3.5; OTA version comparison remains dynamic and was not otherwise changed.
- No App Build was triggered by this Code execution.
- `Eksekusi Firmware` is the separate firmware build/publish action for the V3.5 test package. Physical OTA runtime behavior still requires user device testing; a successful CI build does not prove the panic is fixed.

## 2026-09-26 — V3.5 OTA TEST PACKAGE READY

- Firmware Build Run #14 (`36214058400`) completed successfully for source head `511a84f9608da73f09452e1af5e0e09201f9f444`.
- The V3.5 firmware artifact was created and published to `TenzoNkz/JEXFYZ-Firmware`; the public manifest now advertises V3.5.
- No App Build was triggered by this work. The latest successful App Build remains Run #3.
- Physical runtime validation is now the remaining step: test the V3.4 device's online OTA flow against the public V3.5 package and capture any panic/backtrace if the device still fails.

## 2026-09-26 — V3.6 EXECUTION: OTA + BLE PAIRING FIX

- `lib/main.dart` no longer maintains BLE bond state or invokes Android `createBond()`; the connection flow relies on the firmware's unencrypted BLE link plus the existing `SYNC -> SYNC_READY` session gate.
- Firmware source references are now synchronized to V3.6.
- Firmware-side OTA handoff was hardened by fully releasing BLE before Wi-Fi/TLS startup; OTA apply also verifies the received byte count before finalizing the update.
- No App Build was triggered; App Build remains exclusive to the Action sub-chat and requires the explicit `Build App` command.
- This execution is intended to validate the observed blue-then-red online OTA failure and the unwanted Android pairing prompt on the next physical test.

## 2026-09-26 — V3.6 FULL EXECUTION VERIFIED

- App source was updated to remove Android BLE bond creation/recovery and retain the existing `SYNC -> SYNC_READY` session gate.
- Firmware V3.6 was built and published successfully in Firmware Build Run #15 (`36214972250`).
- Firmware source verification confirms no `BLESecurity`, `SC_BOND`, or encrypted RX permission remains.
- Online OTA handoff now releases BLE with `BLEDevice::deinit(true)` before Wi-Fi/TLS and validates received image size before finalizing.
- No App Build was started in Code; the source-side pairing fix will require the dedicated Action sub-chat `Build App` flow to produce the updated APK.
- Physical test remains: update the manually flashed V3.4 device to V3.6 and verify no Android pairing prompt and successful online OTA completion.

## 2026-09-26 — V4.0 FIRMWARE BUILD HANDOFF

- Firmware source is V4.0 and the CI baseline is stable Arduino-ESP32 Core 3.3.12.
- Firmware Build #23 (run 36224197399) completed successfully and published JEXFYZ-V4.0.bin to TenzoNkz/JEXFYZ-Firmware.
- Artifact ID: 10899993135; artifact digest: sha256:f22ab1657d18d51a2e2de8e9bf737c02241442ed076ee2cf163829f7206637aa.
- Public V4.0 binary size: 1,573,264 bytes. Manifest verified at the public firmware repository and points to the V4.0 raw firmware URL.
- Firmware BLE P1 command/telemetry contract used by lib/main.dart remains unchanged, so no Flutter protocol rewrite was required.
- lib/main.dart only received a stale-version documentation cleanup during this firmware refactor; the installed App Build #4 remains unchanged.
- Physical validation pending: flash/boot V4.0 on the device, then test online OTA behavior and local OTA regression.


## 2026-09-26 — Firmware V4.0 physical local OTA failure and V4.2 handoff

### Physical test result
- User tested the published V4.0 firmware through the local/manual OTA page while the device was running V3.9.
- The OTA failed and the device remained on V3.9.
- No exact OTA page error string was supplied, so the root cause is not asserted from the physical result alone.

### Code #3 execution
- Firmware source advanced V4.1 -> V4.2.
- Local OTA finalization now uses `Update.end(true)` after the existing exact received-byte validation.
- Local OTA failure responses now expose the persisted `LAST_OTA_RESULT` value to the browser.
- No BLE P1 command/telemetry contract or app-side protocol rewrite was required.
- No App Build was triggered by this firmware-only execution.

### Firmware Build handoff
- Firmware Build Run #26 compiled and published V4.2 successfully.
- Public firmware metadata is now V4.2.
- Required physical validation: V3.9 device -> local boot AP OTA -> V4.2.
- If physical OTA fails again, record the exact OTA page response before the next code change.

## 2026-09-26 — V4.3 OTA DIAGNOSTIC NOTIFY SYNC

- App source now consumes OTA_STAGE, OTA_PROGRESS, OTA_ERROR_CODE, and OTA_ERROR telemetry.
- Structured LAST_OTA_RESULT values are rendered in Home NOTIFY with OTA mode, exact failing stage, error text, progress, and numeric code.
- Persisted OTA failure/success is prioritized over a stale generic notice after reconnect.
- BLE/P1 command names remain unchanged.
- No App Build was triggered in this Code/Firmware execution; APK build remains separately controlled in the Action sub-chat.


## 2026-09-26 — V4.3 BUILD / OTA DIAGNOSTIC HANDOFF

- Firmware V4.3 was compiled and published successfully by Firmware Build Run #27.
- The App source is synchronized to the new OTA diagnostic telemetry/result format, but no APK build was triggered in this Code/Firmware execution.
- The user should manually flash V4.3 using the dedicated ArduinoDroid temporary .ino artifact before physical OTA retesting.
- Expected diagnostic Home NOTIFY output after a failed update includes mode, exact stage, error text, progress, and numeric error code.
- Required next physical tests: V4.3 Local OTA and V4.3 Online OTA; preserve the exact Home NOTIFY result for diagnosis.

## 2026-09-26 — V4.4 ONLINE OTA STREAM TIMEOUT HANDOFF

- Firmware V4.4 targets the observed physical Online OTA failure at 77% with UPDATE_ERROR_STREAM (code 6).
- The normal release firmware increases Online OTA HTTP/socket timeout from 12 seconds to 60 seconds.
- OTA diagnostic Notify remains unchanged in protocol and continues to show MODE, STAGE, ERROR, PROGRESS, and numeric CODE.
- No App protocol, BLE P1 command, or UI behavior was intentionally changed in this firmware-only fix.
- Firmware Build Run #29 is the active validation run for V4.4 and its ArduinoDroid temporary source.
- Required physical test after build publication: flash V4.4 manually using the Core 3.3.7-compatible temporary source, then test Online OTA again.

## 2026-09-26 — V4.5 ONLINE OTA HANDOFF

- Firmware V4.5 changes only the Online OTA transport to chunked HTTP Range requests with reconnect/resume using esp_ota_resume().
- App OTA stage translation now includes range probe/request/response/write/retry/resume.
- Existing BLE/P1 transport and persisted OTA result format remain unchanged.
- Physical validation target: manual flash V4.5 ArduinoDroid temporary source, then Online OTA using public V4.5 binary.
- No App Build was triggered by this firmware-focused execution.

## 2026-09-26 — V4.5 ARDUINODROID TEMPORARY COMPATIBILITY HANDOFF

- Manual V4.5 source is generated with JEXFYZ_LEGACY_OTA for ArduinoDroid/Core 3.3.7.
- Public V4.5 remains the Core 3.3.12 release with true offset resume.

## 2026-09-26 — V4.5 BUILD #31 VERIFIED

- Firmware Build Run #31 completed successfully and published V4.5.
- App source contains the OTA diagnostic stage translations for range probe/request/response/write/retry/resume.
- No App Build was triggered in this Firmware-focused execution.
- Physical test target is the V4.5 ArduinoDroid temporary source followed by Online OTA using the public V4.5 binary.

## 2026-09-26 — V4.5 PHYSICAL OTA SUCCESS / CURRENT BASELINE

- Physical validation of firmware V4.5 succeeded on the target device.
- The V4.5 code was first manually flashed through ArduinoDroid with FW_VERSION temporarily labeled V3.8, then the device used Online OTA to install the public V4.5 firmware.
- Observed success sequence: blue OTA indication during transfer -> green success indication -> restart -> App shows Current V4.5 and Latest V4.5 / Up to date.
- This confirms the App firmware-version check/Update dialog, BLE handoff, persisted OTA result path, and post-restart synchronization all worked with the public V4.5 release.
- The App Home NOTIFY diagnostic system successfully displayed OTA mode/stage/error/progress data during the preceding failure tests and remains synchronized with V4.5 firmware telemetry.
- Earlier Online OTA Stream Read Timeout failures (code 6) are considered resolved by the V4.5 firmware-side Range/reconnect/resume implementation.
- Local OTA remains a separate firmware-side issue: prior physical testing produced LOCAL_FLASH_READBACK, code 3 / Flash Read Failed at 100%.
- No App command names, BLE/P1 transport, device UUIDs, or core UI feature behavior were changed as part of the V4.5 Online OTA fix.
- Current project state: public firmware V4.5 is the active release; installed test device is running V4.5; App source remains aligned to the OTA diagnostic protocol.
- The user's currently installed APK remains the existing App Build; no new APK build was triggered by the V4.5 firmware execution.
## 2026-09-26 — V4.6 OTA SAFETY BASELINE

- Firmware V4.6 introduces a top OTA Safety Lock, first-in-loop OTA Priority Supervisor, early OTA/AP startup, protected OTA code fences, and a CI OTA invariant audit.
- App BLE/P1 transport and OTA diagnostic key names remain unchanged.
- No App Build was triggered by this firmware maintenance execution.
- Physical validation target after build: manual V4.6 ArduinoDroid temporary flash followed by Online OTA to public V4.6.
- Local OTA remains separately tracked for the prior Flash Readback/code 3 issue.
## 2026-09-26 — EXECUTION COMPLETION RULE

- For full Code/Firmware execution, continue through final build and publication verification instead of stopping after Actions is triggered.
- Inspect and fix build failures, rerun the pipeline, and continue until the requested final firmware pipeline succeeds.
- Do not treat an intermediate or failed Actions run as completion.
## 2026-09-26 — V4.6 RELEASE / FULL EXECUTION VERIFIED

- Firmware Build Run #36 completed successfully and published V4.6.
- The full execution gate was satisfied: source audit -> OTA safety audit -> compile -> artifact -> ArduinoDroid temporary source -> publication -> public manifest verification.
- Run #35's audit-only failure was automatically repaired before Run #36; it did not indicate a firmware compile or OTA implementation failure.
- App OTA diagnostic protocol remains aligned with firmware V4.6; no App Build was triggered by this firmware-only execution.
- Physical next step is manual flashing/testing of the V4.6 ArduinoDroid temporary source, followed by hardware OTA validation if desired.
## 2026-09-26 — V4.7 EXECUTION HANDOFF

- V4.7 changes Online OTA body decoding to HTTPClient::writeToStream() with an OTA flash sink; Range/reconnect/resume architecture is retained.
- Existing App OTA diagnostic stage translation remains compatible.
- No App Build was triggered by this firmware-focused execution.

## 2026-09-26 — V4.8 FIRMWARE HANDOFF / FULL HARDENING

- Firmware V4.8 addresses the remaining physical V4.7 problems: missing/unstable Wi-Fi/BLE handoff and Local OTA code-3 Flash Readback.
- Local OTA is now native `esp_ota_*`; V4.7 Online OTA Range/reconnect/resume stays preserved.
- No App Build triggered; App OTA diagnostics remain compatible.
- Physical validation: V4.8 temporary manual flash -> AP for first 10s -> BLE recovery/advertising -> Local OTA -> Online OTA.

# END OF APP PROJECT MEMORY

## 2026-09-26 — Code #2: firmware source cleanup + App BLE contract synchronization

### User request
- Clean and organize the firmware source.
- Keep the firmware source compact and avoid accidental code bloat.
- Synchronize the App and firmware so their BLE connection/protocol remain aligned.
- Update the project memory whenever a project file changes.

### Files changed
- `firmware/JEXFYZ.ino`
- `lib/main.dart`
- `FIRMWARE_NOTES.md`
- `APP_NOTES.md`

### Firmware source cleanup
- The comment-free firmware source was structurally cleaned by removing excessive blank-line runs and trailing whitespace.
- No executable firmware logic was intentionally changed.
- Source size reduced from 80,236 to 79,451 characters and from 3,198 to 2,945 lines.
- This reduction is formatting/whitespace only; no required OTA certificate, protocol handler, safety state, or hardware function was removed.

### App ↔ firmware synchronization
- App BLE identity matches firmware:
  - device name: `JE X FYZ`
  - service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`
  - RX UUID: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`
  - TX UUID: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`
  - protocol: `P1`
- Verified command compatibility between App and firmware for session/SYNC, OTA metadata, RGB, LED mode/brightness/colors, hotside and battery settings, voltage, Fan, Peltier, Adaptive, Fan Speed, reset groups, and `PHONE:BT=`.
- Verified the App consumes the telemetry keys emitted by the firmware full-sync/delta path.
- Updated the stale App source documentation from V2.8 to current `V3.2 / P1`.

### Execution separation
- This was a plain Code `Eksekusi`.
- No App Build was triggered.
- No Firmware Build was triggered.
- `.github/APP_BUILD_TRIGGER` and `.github/FIRMWARE_BUILD_TRIGGER` were not modified.
- A separate `Eksekusi Firmware` remains required to compile/publish the firmware `.bin`.

## 2026-09-26 — App Build Run #4 verified

- User explicitly requested `Build App` in the Action sub-chat.
- App Build was triggered only through `.github/APP_BUILD_TRIGGER`; no Firmware Build was started.
- Trigger commit: `4c233e24bfda1e288f1a05502c17424b1d54e32b`.
- GitHub Actions App Build Run #4 (`36215250344`) completed successfully.
- Built head SHA: `4c233e24bfda1e288f1a05502c17424b1d54e32b`.
- Analyze: SUCCESS.
- Tests: SUCCESS.
- Release APK build: SUCCESS.
- Production APK signature verification: SUCCESS.
- APK artifact: `JEXFYZ#4.apk`, artifact ID `10896819732`, size `53,069,270 bytes`, not expired at verification time.
- Dart symbols artifact: `JE-X-FYZ-Dart-Symbols`, artifact ID `10897875098`.
- APK was downloaded as `JE-X-FYZ-Build-4.apk` and verified as a genuine Android package (APK), not a wrapper ZIP.
- No source-code feature change was made for this build; the trigger commit only advanced the dedicated App Build trigger file.
- Real-device BLE/background-service validation remains pending from the earlier handoff.

## 2026-09-26 — App Build Run #5 verified

- User explicitly requested `Build App` in the Action sub-chat.
- App Build was triggered only through `.github/APP_BUILD_TRIGGER`; no Firmware Build was started.
- Trigger commit: `27c02ad58a15a46f744bf1e10165c32260137b3f`.
- GitHub Actions App Build Run #5 (`36230152301`) completed successfully.
- Built head SHA: `27c02ad58a15a46f744bf1e10165c32260137b3f`.
- Analyze: SUCCESS.
- Tests: SUCCESS.
- Release APK build: SUCCESS.
- Production APK signature verification: SUCCESS.
- APK artifact: `JEXFYZ#5.apk`, artifact ID `10902547544`, size `53,069,270 bytes`, not expired at verification time.
- Dart symbols artifact: `JE-X-FYZ-Dart-Symbols`, artifact ID `10902462961`.
- APK was downloaded as `JE-X-FYZ-Build-5.apk` and verified as a genuine Android package (APK), not a wrapper ZIP.
- No source-code feature change was made for this build; the trigger commit only advanced the dedicated App Build trigger file.
- Real-device BLE/background-service and V3.8 OTA runtime validation remain pending.

# END OF APP PROJECT MEMORY


## CODE #2 — FIRMWARE V3.3 LED / TOUCH SYNC

- Firmware moved from WS2812FX to a custom LED engine using Adafruit NeoPixel.
- Firmware LED protocol mode IDs are now 1..8: 1 Static, 2 Breath, 3 Center Out, 4 Outer In, 5 Dual Chase, 6 Left <-> Right, 7 Rainbow, 8 Twinkle.
- `lib/main.dart` was synchronized to clamp and display LED modes 1..8.
- The LED UI subtitle now reflects the physical layout: 4 LEDs left + 4 LEDs right.
- Firmware V3.3 uses OneButton for the TTP223 touch handler while preserving the existing gesture behavior and BLE acknowledgements.
- App and firmware command/telemetry names remain `MODE`, `RGB`, `BRIGHTNESS`, `RGB_COLOR`, `COLOR_5V`, `COLOR_9V`, and `COLOR_12V`.
- App BLE identity and P1 protocol remain unchanged.


## CODE #2 — V3.4 FIRMWARE PUBLISH SYNC

- App BLE/UI remains synchronized with firmware V3.4 and LED mode IDs 1..8.
- App header/source protocol documentation was updated from V3.2 to V3.4.
- Firmware CI publication secret was renamed to `TENZO_FULL_ACCESS`; this is a workflow credential reference only and no token value is stored in project files.


## CODE #2 — V3.4 FIRMWARE RELEASE VERIFIED

- Firmware V3.4 release completed successfully after the CI publish secret was corrected to `TENZO_FULL_ACCESS`.
- App BLE contract remains P1 with unchanged JE X FYZ service/RX/TX UUIDs.
- App LED mode synchronization remains 1..8 for the V3.4 custom LED engine.

## 2026-09-26 — V3.7 APP SOURCE EXECUTION: OTA RESULT VISIBILITY

- App source references were advanced from V3.6 to V3.7 for the next firmware release.
- `LAST_OTA_RESULT` is now translated into a user-visible Home NOTIFY message, including detailed OTA finalization errors and upload-size mismatch results.
- OTA failure/success results are also considered by the Home NOTIFY error/status state so a post-OTA reconnect does not hide the persisted firmware result behind a generic "System ready" message.
- No App Build was triggered by this Code execution; the next App Build remains separately controlled by the `Build App` command in the Action sub-chat.


## 2026-09-26 — V3.7 FIRMWARE BUILD HANDOFF

- Firmware V3.7 was successfully built and published from the Code/Firmware full execution.
- App source is already aligned to V3.7 and exposes persisted `LAST_OTA_RESULT` in Home NOTIFY, but App Build #4 remains the user's current installed APK; no App Build was triggered here.
- The intended physical test path is V3.4 device -> public V3.7 OTA, with no manual cable flashing and no hardware modification.
- After OTA testing, the persisted firmware result should appear in the Home NOTIFY card on BLE reconnect.


## 2026-09-26 — V3.8 SOURCE HANDOFF

- App source documentation is aligned to firmware V3.8/P1.
- No App Build was triggered by this execution; the user's installed App Build #4 remains the current test APK.
- V3.8 keeps the existing BLE protocol and telemetry keys, so Build #4 remains the immediate test client for the firmware OTA experiment.
- The V3.8 App source changes are documentation-only in this step; persisted OTA result visibility from the prior source update remains in place.


## 2026-09-26 — V3.8 FIRMWARE BUILD HANDOFF

- Firmware V3.8 was successfully compiled and published.
- App source is synchronized to V3.8 documentation and retains persisted `LAST_OTA_RESULT` visibility.
- The user's installed App Build #4 remains unchanged; no App Build was triggered by the Firmware execution.
- Intended physical test: V3.7 device -> online OTA -> V3.8 using App Build #4, with no hardware modification.


# MANDATORY PROJECT GOVERNANCE — ADDED 2026-09-27

## 1. Read-before-action rule
Before every app-related action—discussion based on project state, source inspection, editing, generating files, CI/build work, BLE/OTA client work, UI changes, packaging, or troubleshooting—the relevant app notes and master context must be read first. Cross-layer work also requires the current firmware context and latest firmware source.

## 2. Update-after-action rule
After every material action, immediately record the action, reason, actual result, affected files, commit/run/version when available, and unresolved follow-up. Never defer documentation to the end of a release.

## 3. Official-source-first rule
For Flutter/Android/plugin/platform APIs, inspect the official upstream documentation/source for the exact pinned version before designing custom behavior. For firmware integration, the pinned Arduino-ESP32 Core 3.3.7 source is the reference on the firmware side. Do not invent replacement transport/lifecycle behavior when the official implementation already defines it.

## 4. Evidence rule
A green CI build is build evidence only. It does not prove BLE connection, OTA success, firmware runtime, or physical hardware behavior.

## 5. Current cross-layer state — 2026-09-27
Firmware active baseline is V1.0. V1.0 passed firmware CI Run #66 but the user reports that the device still panics after manual flashing, so firmware is not physically validated. App changes that depend on firmware runtime must not treat V1.0 as hardware-proven until runtime evidence exists.

## 6. Official firmware-source reference
Verified Arduino-ESP32 Core 3.3.7 references:
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/examples/WiFiAccessPoint/WiFiAccessPoint.ino
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/WiFiAP.cpp
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/AP.cpp
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/WiFiGeneric.cpp

The official AP example uses the high-level `WiFi.softAP()` path. This is now the reference for the next firmware radio diagnostic.


## 2026-09-27 — ONLINE OTA VERSION POLICY APP SYNC
- App policy was updated so firmware manifest versions are considered update-capable whenever they are valid and DIFFERENT from the device version; this allows rollback/downgrade as well as upgrade.
- The existing isNewerFirmwareVersion helper was restored for test compatibility and retained as a separate helper; the OTA dialog uses isDifferentFirmwareVersion for availability.
- App Build #7 completed successfully, including Dart analysis and Flutter tests.


## 2026-09-27 — PROJECT BASELINE RESET / REPOSITORY CLEANUP

- Firmware development baseline has been restarted at V1.0 after a major project revision; the authoritative firmware source remains `firmware/JEXFYZ.ino`.
- The firmware code was kept unchanged for this reset; only the source version declaration was reset to V1.0.
- Obsolete firmware CI/diagnostic files were removed from the production repository. The App Build workflow remains the active automated APK build path.
- Firmware binaries are no longer compiled/published by the App repository CI workflow. The user compiles the firmware manually in ArduinoDroid and provides the application BIN to ChatGPT for validated GitHub publication.
- Existing Firebase firmware-metadata dependencies remain excluded from the firmware distribution workflow; GitHub is the firmware distribution source of truth.

## 2026-09-27 — RUNTIME RESULT: ONLINE OTA CHECK SHOWS UP TO DATE ON INSTALLED V1.5

- User physically confirmed Local OTA is working in both directions with the manually flashed firmware labels:
  - V1.0 → test-labeled V1.5: SUCCESS
  - V1.5 → V1.0: SUCCESS
  - V1.0 → V1.5: SUCCESS
- User is currently running a firmware image labeled **V1.5** for testing.
- In the App Firmware dialog, the runtime screen shows:
  - Current: V1.5
  - Latest: V1.0
  - Status: **Up to date.**
- The remote manifest is currently V1.0 and the current App source in `lib/main.dart` uses `isDifferentFirmwareVersion(latest, current)` for OTA availability. Under the documented product policy, V1.5 vs V1.0 must therefore be treated as an available Online OTA target.
- This runtime result strongly indicates that the APK currently installed on the phone is from an older App build whose online-OTA gate still behaves as a **newer-only** comparison, or otherwise does not contain the current `isDifferentFirmwareVersion` logic.
- This is an **App-side version-gating finding**, not evidence that the firmware's Online OTA transfer engine has failed; the dialog is reporting the update as unavailable before an Online OTA flash is offered.
- No App source code was changed in this discussion.
- No App build was triggered.
- Next boundary: use an APK built from the current `main` source, then repeat the same controlled test with installed V1.5 and manifest V1.0. Expected UI result is **Update available**, not **Up to date**. Only after that should the actual Online OTA download/flash path be evaluated.

## 2026-09-27 — APP BUILD RUN #8 EXECUTION LOG

- User explicitly requested `Build App` in the Build App sub-chat.
- Read the active app workflow and current project baseline before execution.
- App Build was triggered through `.github/APP_BUILD_TRIGGER`; no Firmware Build was triggered.
- Trigger commit: `5576ad28b50c814635b1d9c67ee05ac9eb66edb2`.
- GitHub Actions App Build Run #8: `36322022571`.
- Toolchain setup: SUCCESS.
- Production release signing preparation: SUCCESS.
- JE X FYZ security and architecture audit: SUCCESS.
- Flutter dependency installation: SUCCESS.
- Dart analysis: SUCCESS.
- Flutter tests: SUCCESS.
- Release APK build with obfuscation: SUCCESS.
- Production APK signature verification: SUCCESS.
- Release APK filename prepared as `JEXFYZ#8.apk`.
- APK artifact uploaded successfully; artifact ID: `10932409909`; size: `53,069,218 bytes`; digest: `sha256:33f9730546292fa51bdb13bfc4a7f41f85b67bd09715626d478b66816570cfd6`.
- Dart symbols artifact uploaded successfully; artifact ID: `10932604003`.
- APK artifact was downloaded into the working session and verified as a real Android APK package.
- No source-code repair was necessary because the initial build completed successfully.
- Unresolved runtime note remains unchanged: CI success is build evidence only and does not prove BLE/OTA/physical firmware runtime behavior.
- This entry is part of the mandatory update-after-action project governance: every material Build App execution must be recorded with trigger, result, artifact, and follow-up.

## 2026-09-27 — MEMORY GOVERNANCE CONFIRMATION
- Project notes are treated as the authoritative working memory for JE X FYZ App work.
- Before every App-related action, execution, build, troubleshooting step, or source change, re-read the relevant current notes/master context first.
- Do not rely only on conversational memory when the project notes can establish the current state.
- After every material action, update the notes immediately with the actual action, result, affected commit/run/version/artifact, and unresolved follow-up.

## 2026-09-27 — APK FILENAME DELIVERY FIX

- User reported the downloaded APK appearing as `JEXFYZ%238.apk` on Android instead of the required `JEXFYZ#<build-number>.apk`.
- Re-checked the active App Build workflow. The repository-side filename is already explicitly generated as `JEXFYZ#${{ github.run_number }}.apk`, and Run #8 artifact was uploaded under the canonical `JEXFYZ#8.apk) name.
- Verified the downloaded artifact bytes are an Android APK; the `.zip` suffix was only the connector's local artifact container filename, not the APK format.
- Root cause of the visible `%23` form is URL/file-transfer encoding of the `#` character during sandbox/chat delivery, not the GitHub Actions APK naming step.
- Operational fix: when delivering an APK to the chat, preserve/restore the canonical local filename `JEXFYZ#<build-number>.apk` before providing the download link.
- Future Build App executions must continue to generate the repository artifact as `JEXFYZ#<github run number>.apk` and the delivered APK must be normalized to that same canonical filename.
- No application source or build logic change was required for this issue.

## 2026-09-28 — CODE EXECUTION: ONLINE OTA DIAGNOSTIC LABEL SYNC FOR V1.3

- User explicitly authorized `Eksekusi Code dan Firmware Full`.
- `lib/main.dart` was updated only to add human-readable labels for the V1.3 Online OTA diagnostic stages emitted by firmware:
  - `ONLINE_WIFI_CONNECTED`
  - `ONLINE_WIFI_FAILED`
  - `ONLINE_WIFI_DROPPED`
  - `ONLINE_GITHUB_CONNECT`
  - `ONLINE_GITHUB_CONNECTED`
  - `ONLINE_DOWNLOAD_COMPLETE`
  - `ONLINE_FLASH_PREPARE`
  - `ONLINE_FLASH_FINALIZE`
  - `ONLINE_FLASH_SUCCESS`
- App source commit: `7c7f7a53ad30435378c90145d8dd13b44deb60dc`.
- No command name, BLE UUID, P1 protocol, UI architecture, or OTA availability rule was changed by this sync.
- No App Build was triggered here; the separate `Build App` workflow remains the APK-build boundary.
- The next App build should be performed only when requested with `Build App` in the build/action sub-chat.

## 2026-09-28 — APP BUILD RUN #9 EXECUTION LOG

- User explicitly requested `Build App`.
- Re-read current `APP_NOTES.md` and `.github/workflows/app-build.yml` before execution.
- Current source baseline included the latest Online OTA V1.3 staged diagnostic label sync.
- App Build was triggered through `.github/APP_BUILD_TRIGGER`; no Firmware Build was triggered.
- Trigger commit: `96d01b47bc1eb6b01ff960e1f33f312cd7034c10`.
- GitHub Actions App Build Run #9: `36356212663`.
- Toolchain setup: SUCCESS.
- Production release signing preparation: SUCCESS.
- JE X FYZ security and architecture audit: SUCCESS.
- Flutter dependency installation: SUCCESS.
- Dart analysis: SUCCESS.
- Flutter tests: SUCCESS.
- Release APK build with obfuscation: SUCCESS.
- Production APK signature verification: SUCCESS.
- Release APK filename prepared as `JEXFYZ#9.apk`.
- APK artifact uploaded successfully; artifact ID: `10943602784`; size: `53,134,754 bytes`; digest: `sha256:bbc7f08eeeddebb404e870f9aa7f85fdc87595b3c2e53f9623c3991dbc0ddcde`.
- Dart symbols artifact uploaded successfully; artifact ID: `10944056961`.
- Downloaded artifact was normalized from the connector's temporary `.zip` filename to the canonical local APK filename `JEXFYZ#9.apk`.
- Local verification reports the delivered file as an Android package (APK), size approximately 51 MiB, with SHA-256 `bbc7f08eeeddebb404e870f9aa7f85fdc87595b3c2e53f9623c3991dbc0ddcde`.
- No source-code repair was necessary because the initial build completed successfully.
- Runtime BLE/OTA/physical firmware behavior remains unproven by CI alone; Build #9 is the APK boundary for the next controlled device test.

