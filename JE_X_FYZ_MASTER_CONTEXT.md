# JE X FYZ — MASTER PROJECT CONTEXT

> **PURPOSE:** This document is the persistent project memory for the JE X FYZ / JE Cooler app and firmware. It is designed to survive chat/sub-chat limits.
>
> **READ RULE:** Before analyzing, editing, generating, or replacing project files, read this document **repeatedly and completely enough to understand the current state**. Re-read the relevant sections again after every important user instruction, file update, firmware update, UI redesign, or build failure.
>
> **CHANGE RULE:** This document is a **living specification**. It must evolve with the project. Never treat an older statement as permanently authoritative when the user gives a newer instruction. A newer explicit user instruction overrides an older note. When concepts change, update this file instead of preserving obsolete behavior as an active requirement.
>
> **SOURCE-OF-TRUTH ORDER:**
> 1. The user's newest explicit instruction.
> 2. The newest uploaded/source file the user identifies as the base.
> 3. The current GitHub repository state, especially the latest relevant commit.
> 4. This master context.
> 5. Older chat discussion only when it is still consistent with the items above.
>
> **DO NOT GUESS:** When two sources conflict, inspect the latest file/repository state and ask the user when the conflict cannot be resolved from evidence. Never silently resurrect an old design or protocol.

---

## 1. PROJECT IDENTITY

- Project name: **JE X FYZ**
- App display name: **JE Cooler**
- In-app header branding: **JE X FYZ**
- Secondary header text: **DEVELOPED BY HORIZON**
- Main UI/architecture reference: **Horizon Cooler App**
- App repository: `https://github.com/TenzoNkz/JEXFYZ-App`
- Firmware repository: `https://github.com/TenzoNkz/JEXFYZ-Firmware`
- Primary firmware base currently identified by the user: uploaded `JEXFYZ.ino`
- Latest uploaded firmware file in this project context: `JEXFYZ.ino` (file identified by the user as the current base; its header states **JE X FYZ Firmware V3.0**)
- Important: the user has also previously referred to a manually updated firmware version 3.2. Never assume the version from memory; inspect the current firmware file/repository before making version-specific changes.

---

## 2. CURRENT GITHUB STATE AT THE LAST VERIFIED CHECK

### App repository
`TenzoNkz/JEXFYZ-App`

- Default branch: `main`
- Latest verified commit at the time this document was created: `488d937225853162ce6601598f6468298cf5539e`
- Previous verified successful build commit: `1140a65647a1cd851656b1e3de01f588051709c5`

### Latest workflow status investigated
Workflow: **JE X FYZ Cooler Build**

- Run #49: `35568844932`
- Commit: `488d937225853162ce6601598f6468298cf5539e`
- Result: **failure**
- Run URL: `https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/35568844932`

### Previous workflow status
- Run #48: `35564348050`
- Commit: `1140a65647a1cd851656b1e3de01f588051709c5`
- Result: **success**
- Run URL: `https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/35564348050`

### Verified root cause of run #49 failure
The current workflow did **not** fail in Flutter setup, signing, dependency installation, or `flutter analyze`.

The failure occurred in:

```text
Run Flutter tests
```

The failing test was:

```text
JE Cooler dashboard renders
```

The concrete error was:

```text
A RenderFlex overflowed by 15 pixels on the bottom.
```

The failure happened in the widget test's compact default test viewport. The latest Home redesign deliberately made the Home canvas/cards taller. The production UI is intended for a portrait phone viewport, while the default Flutter test surface is much smaller. The correct fix is to make the smoke test use a representative portrait surface rather than disabling tests or weakening the production UI.

### Build policy
- Do not disable `flutter test` just to make CI green.
- Do not hide RenderFlex overflow errors.
- Prefer fixing the test viewport when the production layout is intentionally portrait-oriented.
- After this test fix is manually applied, run the workflow again. Only after a fresh successful workflow should an APK be considered the latest verified build.

---

## 3. APP STACK / ARCHITECTURE

- Flutter / Dart app.
- Android wrapper.
- BLE library: `flutter_blue_plus`.
- Premium icon system: `phosphor_icons`.
- Firebase is used for firmware metadata / OTA update information.
- Firebase runtime access should remain read-only for firmware metadata unless the user explicitly changes this design.
- Firmware metadata uses version + URL; the user explicitly does **not** want SHA firmware-linking.
- Android app has a security/integrity layer and an official-build check.
- Release build uses obfuscation and split debug info.
- R8/resource shrinking is intended to remain enabled.
- The user wants a normal APK build, not a Play Store bundle as the primary deliverable.

---

## 4. BLE / DEVICE COMMUNICATION RULES

BLE UUIDs currently present in the app:

- Service: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`
- RX: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`
- TX: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`

Important behavior:

- BLE should remain available continuously after the Wi-Fi OTA window is finished.
- ESP32-C3 Super Mini has a single radio/antenna constraint in this project context, so Wi-Fi OTA and BLE must not be treated as simultaneously active.
- Wi-Fi OTA gets priority immediately after device power-up for the configured startup window.
- During Wi-Fi OTA connection/update, Peltier/Fan/LED should be forced off and OTA should be the priority task.
- When Wi-Fi OTA ends, BLE should become active again without requiring a reboot for normal failure cases.
- BLE reconnect/disconnect handling must not leave the app in a permanently broken state.
- UI must not pretend a command succeeded permanently; firmware telemetry/state remains the source of truth.
- Current app logic uses background/latest-state command reconciliation so the UI can respond immediately without the old blocking PROCESSING overlay.
- Do not reintroduce blocking PROCESSING overlays unless the user explicitly requests them.

---

## 5. OTA RULES

Desired startup behavior:

1. Device powers on.
2. Wi-Fi OTA mode is active for the startup OTA window.
3. During OTA startup/failure handling, cooling outputs are off.
4. On successful OTA metadata/download/update, use the desired status LED sequence and restart as required by firmware.
5. When OTA fails, BLE must become usable again without a forced restart whenever firmware design permits.

Status LED concept previously specified:

- Wi-Fi failed: red blink → BLE alive again
- Wi-Fi success: blue blink → download/update OTA
- OTA success: green blink → restart
- OTA failed: red blink → BLE alive again

The exact implementation must follow the newest firmware file rather than an older chat memory.

---

## 6. HARDWARE / PIN MAP

Latest project memory of the final pin correction:

- GPIO0: NTC sensor
- GPIO1: touch sensor
- GPIO3: 12V optocoupler
- GPIO4: 9V optocoupler
- GPIO5: **Peltier**
- GPIO6: **Fan**
- GPIO7: WS2812B

This GPIO5/GPIO6 mapping is important because it was previously swapped and explicitly corrected.

Hardware notes:

- ESP32-C3 Super Mini.
- NTC10K with 10K resistor is the default temperature sensing arrangement unless the current firmware says otherwise.
- One touch sensor is used; no separate Wi-Fi/BLE toggle input is assumed.
- Optocoupler switching includes a safety break-before-make timing requirement. Earlier design discussion mentioned increasing the transition pause to 200 ms; verify the latest firmware before changing it.

---

## 7. TEMPERATURE / SAFETY BEHAVIOR

Temperature behavior discussed across the project:

- Hotside temperature is the primary cooling safety reference.
- Hotside telemetry should be sent approximately every second.
- Battery temperature should be sampled/synchronized approximately every second.
- Other changed settings should be sent only when changed to reduce BLE/firmware spam.
- Preferences should be saved after about 10 seconds with no further changes.
- Hotside limit is configurable in the app in the 40°C–50°C range.
- Earlier defaults discussed were 45°C and 50°C in different phases; **the current firmware/app source is authoritative** for the current default.
- When hotside protection reaches its limit, Peltier should be temporarily disabled to allow fan cooling and then resume according to the latest firmware safety state.
- Rapid temperature rise protection is distinct from Adaptive Mode and can require manual recovery.
- Battery protection is a system-security function and should not be displayed as a separate user-facing guard unless the user explicitly requests it.

---

## 8. VOLTAGE / CONTROL RULES

Manual voltage levels:

- 5V
- 9V
- 12V

Rules discussed:

- Manual voltage selector is disabled/locked while Adaptive Mode is active.
- Entering or leaving Adaptive Mode should return the selector to 5V according to firmware policy.
- Manual voltage switching historically used a 1-second safety guard; do not remove firmware safety timing. The current app transport may be asynchronous/latest-state driven, but firmware remains authoritative.
- PWM fan-speed control is intended for manual 12V mode.
- Fan speed range: 50%–100%.
- Preferred increments: 10% (50/60/70/80/90/100), unless the latest design changes this.
- Peltier/Fan safety interlocks must remain firmware-enforced.

---

## 9. LED RULES

Default manual voltage-to-color mapping:

- 5V → red
- 9V → green
- 12V → blue

User wants:

- Manual voltage colors to be customizable.
- A separate reset button for voltage colors.
- RGB mode does not need a reset button.
- LED brightness control similar to Horizon Cooler.
- Settings should be stored and synchronized without unnecessary BLE spam.

---

## 10. HOME UI — CURRENT APPROVED DESIGN DIRECTION

### Global structure
The application is being redesigned into separate spaces/canvases:

1. **HOME CANVAS**
2. **SUB MENU CANVAS**
3. **DISPLAY MENU CANVAS**

Each must have its own visual space and should not feel like one long combined settings page.

### Home header
Header contains only:

- Bluetooth icon
- centered `JE X FYZ`
- `DEVELOPED BY HORIZON`
- Settings/gear icon

Bluetooth and Settings are **header actions, not indicators**.

Important visual rule:

- Bluetooth icon: **NO surrounding box**
- Settings icon: **NO surrounding box**
- Both should be vertically centered with the JE X FYZ title and placed symmetrically left/right.

### Home indicators
Indicators are a consistent stack of rounded horizontal cards.

Current desired indicators:

- Battery Temperature
- Hotside Temperature
- Voltage Indicator
- Adaptive Mode
- Peltier
- Fan
- Fan Speed

### Indicator card structure
Every indicator should have:

- outer dark rounded card
- icon box inside the card
- icon centered in the icon box
- color identity per indicator
- label above/value below
- consistent alignment and spacing
- no status dot on the far right

Reference style supplied by the user: dark rounded card with a colored rounded icon box, matching accent color, large value, small label.

### Current indicator color direction

- Battery Temperature → orange
- Hotside Temperature → cyan
- Voltage → blue
- Adaptive → white/neutral
- Peltier → cyan/blue family
- Fan → green
- Fan Speed → purple

These colors are a design direction and can be changed by newer user instructions.

### Cooler image
- Large cooler image on the right side of the Home canvas.
- It may be enlarged because the Home is treated as a full canvas.
- It must not collide with indicator text.
- It should not be unnecessarily clipped.
- The image is a main visual element, not a small widget.

### Notify / status
- Notify/status belongs at the bottom of the Home indicator area.
- It remains a long status card.
- It should visually fit with the indicator stack.
- It can show online/offline and safety/notification text.
- Do not replace it with scattered status dots.

### Processing overlay
- The user explicitly disliked the old PROCESSING notification because it felt slow/delayed.
- The blocking PROCESSING overlay has been removed.
- Keep asynchronous command synchronization without visually blocking the UI.

---

## 11. SUB MENU — CURRENT APPROVED DIRECTION

Current sub-menu categories:

- VOLTAGE
- CONTROL
- ADAPTIVE
- LED
- TEMPERATURE

The user wants the Sub Menu canvas to begin **close under the Home Notify card**, with no large vertical gap.

Desired layout:

- white rounded top canvas
- category navigation at the top
- consistent tab/button sizes
- active category clearly visible
- content area below
- clean spacing
- no unnecessary vertical empty area between Notify and the Sub Menu canvas

The current visual reference still uses the Horizon-style white rounded settings area and horizontal category controls.

Do not convert to a sidebar unless the user explicitly requests that change later. The user's most recent actual screenshot is the horizontal category navigation, so this is currently safer than the earlier sidebar proposal.

---

## 12. DISPLAY MENU — CURRENT STATE

Display Menu is intended to be a separate canvas dedicated to app appearance/display behavior.

Important distinction:

- **Sub Menu** = device/cooler configuration.
- **Display Menu** = app presentation/display configuration.

The exact controls inside Display Menu are intentionally not fully fixed yet. Do not invent a large set of display settings. Design them only when the user specifies what should be configurable.

---

## 13. FILE / PATCH DELIVERY RULE

This is an explicit workflow requirement from the user:

> Whenever a project file is changed, provide the **complete replacement file**, not only a snippet.

Also provide a ZIP package containing the changed files using their **real repository-relative paths**.

Example ZIP layout:

```text
JE_X_FYZ_UPDATE/
├── lib/
│   └── main.dart
├── test/
│   └── widget_test.dart
├── .github/
│   └── workflows/
│       └── build.yml
├── JE_X_FYZ_MASTER_CONTEXT.md
└── PATCH_MANIFEST.md
```

The ZIP should preserve paths so the user can extract/copy the files into the repository.

Do not give only a diff when the user asks for the full file.

Also provide the updated Master Context file whenever project requirements/state materially changes.

---

## 14. GITHUB / BUILD WORKFLOW RULES

Current workflow path:

```text
.github/workflows/build.yml
```

Current intended stages:

1. Checkout
2. Java 17
3. Flutter
4. Gradle
5. Toolchain audit
6. Flutter local.properties
7. Production signing
8. Restore Gradle wrapper if needed
9. JE X FYZ architecture/security audit
10. `flutter pub get`
11. `flutter analyze`
12. `flutter test`
13. Release APK build with obfuscation
14. APK signature verification
15. Clean APK filename
16. Upload only the latest APK artifact
17. Upload Dart symbols

The user wants **one final APK artifact**, not two application APK outputs.

Desired artifact filename:

```text
JE-X-FYZ-Latest.apk
```

Artifact name:

```text
JE-X-FYZ-Latest-App
```

The Dart symbols artifact can remain separate.

### CI troubleshooting rule
When a workflow fails:

1. Inspect the actual failing job/step.
2. Read the job logs before changing code.
3. Identify whether the problem is source code, widget test layout, Gradle, signing, dependencies, or workflow YAML.
4. Fix the smallest real root cause.
5. Never disable a test merely to make CI green.
6. After a source/workflow fix, check the newest workflow run again.
7. Only call an APK “verified latest” after a successful workflow produces it.

---

## 15. CURRENT CI FIX — ACTION ALREADY PREPARED

The latest verified failure is a widget-test RenderFlex overflow caused by the compact default test surface after the Home card redesign.

The replacement file prepared for manual update is:

```text
test/widget_test.dart
```

The test is changed to use a representative portrait surface:

```dart
tester.view.physicalSize = const Size(1080, 2400);
tester.view.devicePixelRatio = 1.0;
```

and resets the test view afterward.

It also explicitly checks:

```dart
expect(tester.takeException(), isNull);
```

This keeps `flutter test` enabled and catches actual rendering exceptions.

No production UI reduction is required solely to satisfy the CI test surface.

---

## 16. SECURITY / SIGNING RULES

- Firebase firmware metadata is read-only.
- Do not write firmware metadata from the app.
- Wi-Fi credentials should use Android secure storage.
- Production signing secrets remain GitHub Actions secrets.
- Do not hardcode passwords/keystore secrets into source.
- Keep R8/minification/resource shrinking enabled for release.
- Keep official-build/signing identity checks unless the user explicitly changes this security design.
- Never include real secret values in this master context file.
- Never place GitHub secrets or keystore passwords in patches or ZIP files.

---

## 17. PROJECT COMMUNICATION RULES

- The user prefers Indonesian for normal project discussion.
- Do not execute code or modify project files when the user explicitly says “design discussion first”.
- Once the user says “execute”, implementation may proceed.
- When uncertain about a design instruction, ask a concise clarification rather than guessing.
- After a user changes a concept, update this document and use the new concept from then on.
- Never silently reintroduce a previously rejected architecture/design.
- Prefer clean, direct, production-oriented code.
- Avoid unnecessary complexity.
- Preserve working BLE/OTA/safety behavior while redesigning UI.

---

## 18. CURRENT TASK STATE

### Just completed / active context
- Home UI was redesigned toward colored indicator cards with icon boxes.
- Bluetooth and Settings were explicitly moved/kept as header icons without boxes.
- Sub Menu spacing was tightened toward the Home Notify card.
- User wants a living master `.md` file for continuity across sub-chats.
- User wants complete replacement files packaged as ZIPs with repository paths whenever files change.
- User wants build workflow failures fixed rather than ignored.

### Current immediate fix
Replace:

```text
test/widget_test.dart
```

with the portrait-viewport-safe version supplied with this update.

Then manually run the GitHub Actions workflow again.

### Next validation target
The workflow should pass:

- security/architecture audit
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build apk --release --obfuscate --split-debug-info=build/symbols`
- APK signature verification
- final APK artifact upload

Do not declare success until the new workflow run confirms it.

---

## 19. LIVING CHANGE LOG

### 2026-09-21 — Master Context initialized
- Consolidated project architecture, hardware, BLE, OTA, safety, UI, and delivery rules.
- Added explicit rule that the document must be re-read repeatedly and evolve with new user instructions.
- Recorded latest verified CI failure: run #49, RenderFlex overflow inside the Home widget smoke test.
- Prepared `test/widget_test.dart` replacement using a representative portrait test viewport.
- Confirmed the production workflow reaches `flutter analyze` successfully before failing only in `flutter test`.

### Earlier project history already reflected above
- Horizon Cooler selected as the principal UI/architecture reference.
- GPIO5/GPIO6 Peltier/Fan mapping was corrected.
- Wi-Fi OTA and BLE single-radio sequencing requirements established.
- Blocking PROCESSING overlay removed.
- Home indicator dot/status treatment removed.
- Home indicator cards/icon-box design established.
- Home header Bluetooth/Settings kept without boxes.

---

## 20. FINAL RULE FOR FUTURE SUB-CHATS

When starting a new JE X FYZ sub-chat, treat the following as the first actions conceptually:

1. Read this `JE_X_FYZ_MASTER_CONTEXT.md` completely.
2. Re-read the sections relevant to the requested task.
3. Inspect the newest user-provided base file and/or latest GitHub commit.
4. Compare any apparent conflicts against the user's newest instruction.
5. Continue from the newest state, not from an older chat snapshot.
6. After a material change, update this document so the next sub-chat can continue without losing the project's state.

**This file is not a frozen historical record. It is a living project specification and continuity document.**
