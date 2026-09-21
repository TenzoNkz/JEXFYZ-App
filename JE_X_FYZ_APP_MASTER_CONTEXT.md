# JE X FYZ — APP MASTER CONTEXT

> **SCOPE:** This file is the living context for the **Flutter/Android application only**. Firmware implementation details belong in `JE_X_FYZ_FIRMWARE_MASTER_CONTEXT.md` inside the firmware repository.
>
> **READ RULE:** Read this document completely enough to understand the current app state before changing app code. Re-read relevant sections after each important UI, BLE, OTA-client, build, or security instruction.
>
> **CHANGE RULE:** This is a living specification. The user's newest explicit instruction overrides older notes. Do not silently resurrect rejected UI, transport, or architecture concepts.
>
> **SOURCE-OF-TRUTH ORDER:** newest user instruction → newest identified app source/GitHub state → this app context → older chat history.
>
> **SEPARATION RULE:** Do not place firmware implementation notes, GPIO ownership, safety algorithms, timing state machines, or firmware command-handler internals in this app file. Use the firmware context for those details.

---

## 1. APP IDENTITY

- Project: **JE X FYZ**
- App display name: **JE Cooler**
- In-app header: **JE X FYZ**
- Header subtitle: **DEVELOPED BY HORIZON**
- Main UI/architecture reference: **Horizon Cooler App**
- App repository: `https://github.com/TenzoNkz/JEXFYZ-App`
- Firmware counterpart: `https://github.com/TenzoNkz/JEXFYZ-Firmware`
- BLE/device contract counterpart: `JE_X_FYZ_FIRMWARE_MASTER_CONTEXT.md`

### Boundary
The app owns presentation, user interaction, BLE client behavior, local settings, Firebase firmware metadata consumption, OTA initiation, integrity/security checks, testing, and release packaging. The firmware owns actual hardware state, safety interlocks, sensor interpretation, output timing, and BLE server/state authority.

---

## 2. VERIFIED APP REPOSITORY / CI STATE

### Repository
`TenzoNkz/JEXFYZ-App`

- Default branch: `main`
- Last verified commit recorded here: `488d937225853162ce6601598f6468298cf5539e`
- Previous verified successful-build commit: `1140a65647a1cd851656b1e3de01f588051709c5`

### Investigated workflow
Workflow: **JE X FYZ Cooler Build**

- Run #49: `35568844932` → **failure**
- Run URL: `https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/35568844932`
- Run #48: `35564348050` → **success**

### Root cause recorded for run #49
The workflow passed toolchain setup, signing preparation, security/architecture audit, `flutter pub get`, and `flutter analyze`. The failure occurred in `flutter test` because the redesigned Home overflowed the compact default widget-test surface by 15 pixels.

### CI policy
- Do not disable tests merely to obtain a green build.
- Do not hide RenderFlex overflow/errors.
- Use a representative portrait test surface for the portrait-oriented Home.
- Do not call an APK verified until a fresh successful GitHub Actions run produces it.

---

## 3. APP STACK / ARCHITECTURE

- Flutter / Dart application.
- Android wrapper.
- BLE client: `flutter_blue_plus`.
- Icon system: `phosphor_icons`.
- Firebase is used for firmware metadata / OTA information.
- Firebase firmware metadata access is intended to remain read-only.
- Firmware metadata uses version + URL; **do not add SHA firmware-linking unless explicitly changed by the user**.
- Android integrity/security layer and official-build check remain part of the release architecture.
- Release build uses obfuscation plus split debug info.
- R8/minification and resource shrinking remain enabled.
- Primary deliverable is one normal APK, not a Play Store bundle.

---

## 4. APP BLE CLIENT CONTRACT

BLE UUIDs used by the app:

- Service: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`
- RX: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`
- TX: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`

Client rules:

- BLE is the normal connection path after the firmware's Wi-Fi OTA startup window is finished.
- Do not assume Wi-Fi OTA and BLE are concurrently usable on the target ESP32-C3 radio.
- Handle disconnect/reconnect without leaving the app permanently stuck.
- Treat firmware telemetry/state as the source of truth.
- Use asynchronous/latest-state command reconciliation; do not reintroduce the blocking `PROCESSING` overlay unless explicitly requested.
- Respect the firmware session sync gate and never blindly replay stale app state on connect.
- Commands/telemetry must match the current firmware protocol document.
- Hotside and battery telemetry are expected at about one-second cadence according to the firmware contract.
- Other settings should be sent only when changed.
- Preference writes use about 10 seconds of no-change debounce where applicable.

---

## 5. APP OTA / FIRMWARE UPDATE CLIENT

The app participates in firmware OTA, while firmware owns physical radio safety and OTA execution.

- Firebase OTA metadata is read-only.
- Metadata should contain firmware version and download URL.
- Do not introduce SHA-based firmware-link verification unless the user explicitly changes the requirement.
- The app reflects actual OTA/device state rather than declaring local success prematurely.
- OTA failure must be able to return to BLE operation without the app assuming a restart.
- Wi-Fi credentials use Android secure storage.

Definitive OTA timing, radio ownership, LED sequencing, HTTPS, and recovery implementation belong to the firmware context.

---

## 6. CURRENT UI ARCHITECTURE

Three separate visual canvases:

1. **HOME CANVAS** — dashboard and quick status/control.
2. **SUB MENU CANVAS** — cooler/device configuration.
3. **DISPLAY MENU CANVAS** — app appearance/display configuration.

Do not collapse them into one long settings page unless explicitly requested.

---

## 7. HOME UI — CURRENT APPROVED DIRECTION

### Header
- Bluetooth icon left.
- Centered `JE X FYZ`.
- `DEVELOPED BY HORIZON` beneath the title.
- Settings/gear icon right.
- Bluetooth and Settings are actions, not indicators.
- Neither has a surrounding box.
- Keep both sides visually balanced around the title.

### Indicators
Current indicators:

- Battery Temperature
- Hotside Temperature
- Voltage Indicator
- Adaptive Mode
- Peltier
- Fan
- Fan Speed

Every indicator uses a compact open row: only the rounded colored icon area is boxed. The label/value area is NOT inside a large outer card. There is no large rounded background around the full text row and no far-right status dot.

Current visual color direction:
- Battery Temperature → orange
- Hotside Temperature → cyan
- Voltage → blue
- Adaptive → white/neutral
- Peltier → cyan/blue family
- Fan → green
- Fan Speed → purple

### Cooler image
- Large cooler image on the right side of Home.
- Must not collide with indicator text.
- Avoid unnecessary clipping.

### Indicator sizing / hierarchy
- The full indicator row must remain visually lightweight.
- The colored rounded icon box is the primary visual container.
- Do not wrap label/value text in a second outer rounded card.
- The Home should feel less bulky while preserving the existing icon sizes and typography.

### Notify/status
- Long horizontal card below indicators.
- Shows online/offline and safety/notification text.
- Do not replace it with scattered status dots.

### Processing overlay
The blocking `PROCESSING` overlay is removed because it felt slow/delayed. Keep synchronization asynchronous without blocking the UI.

---

## 8. SUB MENU — CURRENT DIRECTION

Categories:
- VOLTAGE
- CONTROL
- ADAPTIVE
- LED
- TEMPERATURE

Visual direction:
- white rounded top canvas
- canvas starts close under the Home Notify card
- horizontal category navigation
- consistent category spacing
- clear active state
- clean content spacing

Do not convert to a sidebar unless explicitly requested.

---

## 9. DISPLAY MENU

Display Menu is a separate canvas for app appearance/display behavior only.

- Keep it distinct from device/cooler configuration.
- Do not invent a large collection of display settings before the user specifies them.

---

## 10. APP SETTINGS / COMMAND UX

- Keep UI responsive without a blocking processing overlay.
- Firmware telemetry remains authoritative.
- Send changed settings only when needed.
- Keep separate reset actions separate where requested.
- Manual voltage UI must obey firmware authorization/safety; app must never bypass firmware protection.
- Fan-speed controls are for the intended manual 12V workflow; firmware remains authoritative.
- Adaptive UI must represent firmware state, not only optimistic state.

---

## 11. SECURITY / DATA HANDLING

- Firebase firmware metadata: read-only.
- Wi-Fi passwords: Android secure storage only.
- No secrets/passwords/keystore values in source, context, patches, or ZIPs.
- Keep R8/minification and resource shrinking enabled.
- Keep official-build/signing checks unless explicitly changed.
- App must not write firmware metadata into Firebase.

---

## 12. RELEASE / BUILD WORKFLOW

Workflow path:
` .github/workflows/build.yml`

Intended stages:
1. Checkout
2. Java 17
3. Flutter
4. Gradle
5. Toolchain audit
6. Flutter local.properties
7. Production signing
8. Restore Gradle wrapper if needed
9. JE X FYZ security/architecture audit
10. `flutter pub get`
11. `flutter analyze`
12. `flutter test`
13. Release APK build with obfuscation
14. APK signature verification
15. Clean APK filename
16. Upload one latest APK artifact
17. Upload Dart symbols

Expected APK filename: `JE-X-FYZ-Latest.apk`
Expected artifact name: `JE-X-FYZ-Latest-App`

Prepared test fix:
```dart
tester.view.physicalSize = const Size(1080, 2400);
tester.view.devicePixelRatio = 1.0;
```
The test should reset the view afterward and check for rendering exceptions.

---

## 13. FILE DELIVERY RULE

Whenever an app file changes:
- provide the complete replacement file
- provide the exact repository-relative path
- provide a ZIP preserving that path
- update this app context when project state materially changes
- include a patch manifest when multiple files are involved

---

## 14. PROJECT COMMUNICATION RULES

- Normal project discussion in Indonesian.
- Do not modify files while the user explicitly requests design discussion first.
- Once the user says execute, implementation may proceed.
- Inspect the newest app source/repository state instead of guessing.
- Never silently reintroduce rejected UI or transport architecture.
- Preserve working BLE integration while redesigning presentation.

---

## 15. APP CHANGE LOG

### 2026-09-21
- Home UI moved toward colored indicator cards with icon boxes.
- **Latest UI correction:** the large outer indicator cards were removed. Only each indicator's icon area remains boxed; label/value text is now on the open Home background. Fan Speed follows the same icon-only-box treatment.
- **Fan Speed display correction:** Home `FAN SPEED` now shows the numeric percentage only (for example `50%` / `100%`) with no horizontal progress bar. The underlying fan-speed range remains 50–100%.
- **Home cooler image sizing correction:** the cooler image area was enlarged so the hardware illustration is more prominent while keeping the indicator labels readable. The Home layout now gives the cooler more horizontal space (`flex: 13`) and reduces the inter-column gap.
- Bluetooth and Settings retained as header actions without boxes.
- Sub Menu spacing tightened toward the Home Notify card.
- Blocking `PROCESSING` UI removed from the intended interaction model.
- CI run #49 diagnosed as widget-test RenderFlex overflow.
- Portrait test viewport adjustment prepared as the intended fix.
- **Documentation split requested:** app and firmware contexts are now separate files so their contents cannot become mixed.

### Future rule
For app changes, update this file only with app-specific information. For hardware, firmware protocol, safety, timing, or firmware OTA implementation changes, update the firmware context.

---

## 16. FIRMWARE COUNTERPART

```text
JEXFYZ-Firmware/JE_X_FYZ_FIRMWARE_MASTER_CONTEXT.md
```

The two documents cross-reference each other only at the integration boundary. Do not duplicate full firmware implementation details here.
