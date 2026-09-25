# JE X FYZ APP — PROJECT MEMORY / ENGINEERING NOTES

> **Purpose:** Persistent project memory for the **JE X FYZ / JE Cooler Flutter application only**.
>
> This document is intentionally detailed. It exists so future work can continue from the verified project history without repeatedly asking the user to explain the same architecture, UI rules, BLE behavior, CI history, known bugs, and design decisions.
>
> **IMPORTANT:** This document is an app-only note. Firmware implementation details are intentionally kept out of this file. Only app-side BLE/API contracts that the app must consume are recorded where necessary.

---

## 0. HOW THIS FILE MUST BE USED

This file is part of the project and should be treated as a **living engineering memory**.

### Mandatory rule

### Cross-sub-chat continuity rule

**This file is mandatory project context for every new JE X FYZ app sub-chat.** Before discussing, reviewing, debugging, modifying, or validating the app, the latest `APP_PROJECT_NOTES.md` from `main` must be read first — even when the previous sub-chat has reached its limit or a brand-new sub-chat is opened.

The purpose is to prevent repeated explanations and regression from missing historical context. The user should not need to re-explain the architecture, approved behavior, known bugs, constraints, or previous fixes when that information is already recorded here.

If this file is not yet loaded in the current sub-chat, retrieve the latest version before proceeding with app work. Do not rely on memory from an earlier sub-chat as a substitute for reading the current notes.

**Every time a code/config/workflow change is made, this file must be updated in the same change.**

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

`.github/workflows/build.yml`

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

`.github/workflows/build.yml`

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
- `APP_PROJECT_NOTES.md`

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
- `APP_PROJECT_NOTES.md`

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
- `APP_PROJECT_NOTES.md`

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
- `APP_PROJECT_NOTES.md`

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
- `APP_PROJECT_NOTES.md`

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
- Before editing, the authoritative GitHub `main` branch and latest `APP_PROJECT_NOTES.md` were fetched and inspected, per the project mandatory rule.
- GitHub source SHA read before edit: `lib/main.dart` `74ff0dcf9cbfe81021773283059b1c42ab191004`.
- GitHub `APP_PROJECT_NOTES.md` SHA read before edit: `3dfd6e3c52f51572b05aafdf68cc7922dbd6bca5`.
- GitHub direct write was attempted for the requested change but the current integration returned HTTP 403 `Resource not accessible by integration`; therefore no GitHub commit is claimed for this change.
- Local changed sources were written to `/mnt/data/main.dart`, `/mnt/data/MainActivity.kt`, and `/mnt/data/APP_PROJECT_NOTES.md`.
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
- Current `APP_PROJECT_NOTES.md` blob SHA before this update: `230a7eb0197f52816865be6335881cc1001458da`
- Latest observed GitHub Actions run: **#92**, run ID `36090775126`
- Run #92 status: **success**
- Run #92 head SHA: `98d275ef50a9445e9412ebeda80d3fb639a7ad54`
- Run #92 produced `JE-X-FYZ-Latest.zip` and the artifact was not expired at the time of inspection.
- The current `main` HEAD is newer than the commit used by Run #92, so that APK is not automatically considered a build of the current HEAD.

### GitHub write verification
- An update to this exact `APP_PROJECT_NOTES.md` file is being attempted now using its current blob SHA.
- The result of this update must be treated as the authoritative test of current GitHub write access.
- Do not claim GitHub write access is available unless this update returns a successful commit/content SHA.
- Do not claim GitHub Actions can be dispatched from the available integration; workflow run creation remains a separate capability from repository file writing.

### Project workflow rule reaffirmed
For every future app change:
1. Read the latest `APP_PROJECT_NOTES.md`.
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


# END OF APP PROJECT MEMORY

## CHANGELOG

### 2026-09-26 — Mandatory notes continuity across sub-chats

- Added an explicit rule that the latest `APP_PROJECT_NOTES.md` on `main` must be read before any JE X FYZ app discussion, review, debugging, modification, or validation.
- The rule applies to every new sub-chat, including when a previous sub-chat reaches its context limit.
- The purpose is to preserve project continuity so the user does not need to re-explain established architecture, decisions, constraints, bugs, or fixes.
- Memory from an earlier sub-chat is not a substitute for retrieving the current notes.
