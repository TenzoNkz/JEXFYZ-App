# JE X FYZ App — Project Notes

## Scope

This repository is **App-only**.

- App: Flutter/Android application **JE Cooler**
- In-app header: **JE X FYZ**
- Repository: `TenzoNkz/JEXFYZ-App`
- UI/architecture reference: Horizon Cooler App
- Firmware source, firmware `.ino`, firmware `.bin`, firmware CI, and firmware notes are **not stored in this repository**.
- Firmware is maintained separately by the user. The App only consumes the external firmware update manifest/BIN URL when Online OTA is used.

## App ↔ Firmware integration boundary

The App remains synchronized to the external device protocol at the BLE boundary:

- Device name: `JE X FYZ`
- Protocol: `P1`
- Service UUID: `6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`
- RX UUID: `6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`
- TX UUID: `6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`

The firmware remains the source of truth for physical state and safety. The App waits for telemetry/ACK evidence instead of treating a BLE write as permanent physical success.

## BLE / UI behavior

- Horizon Cooler remains the UI/Android foundation.
- Phosphor Icons are used for App controls; Material Icons are not used in the JE X FYZ UI.
- Home keeps the established compact indicator layout.
- Bluetooth and Settings remain header actions without icon boxes.
- Fan Speed remains percentage-only, with the App-side control range 50–100%.
- Normal runtime state is synchronized through the P1 session gate before state-changing commands are sent.
- Hotside and phone-battery telemetry behavior remains 1 Hz as defined by the integration contract.

## Firmware update integration

Online OTA metadata is read from:

`https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/manifest.json`

The App validates:

- version format `V<major>.<minor>`
- HTTPS transport
- `raw.githubusercontent.com` host
- firmware repository path under `/TenzoNkz/JEXFYZ-Firmware/`

The App accepts any valid **different** version as an OTA target, including rollback/downgrade for controlled testing.

Wi-Fi credentials are stored only through `flutter_secure_storage`.

## Android / security

- Android package: `com.horizontalzzz.jexfyz`
- Production release is signed with the configured JE X FYZ signing identity.
- Release builds use R8/minification and resource shrinking.
- Production App integrity checking is implemented through the native signing-certificate check.
- Firebase App Check / Play Integrity remains an App security layer; it is not the firmware distribution source.
- The App does not store firmware implementation files locally in this repository.

## Build workflow

App-only workflow:

`.github/workflows/app-build.yml`

The workflow is intended to validate:

1. Flutter/Java/Gradle toolchain
2. production signing setup
3. App-only architecture/security audit
4. `flutter pub get`
5. `flutter analyze`
6. `flutter test`
7. release APK build with obfuscation
8. APK signature verification
9. canonical APK artifact `JEXFYZ#<run-number>.apk`
10. Dart symbols artifact

The workflow must only be triggered by the dedicated App Build action/trigger when the user explicitly requests **Build App**.

## Current repository cleanup — 2026-09-28

- Removed `FIRMWARE_NOTES.md` from the App repository.
- Confirmed there is no `firmware/` directory in the current App repository.
- Restored the App Build workflow without any dependency on local firmware source.
- Removed unused Dart dependency `shared_preferences`.
- Removed unused `flutter/rendering.dart` import.
- Removed the unused native `enableLocation` MethodChannel case.
- Added bounded network timeouts to the firmware manifest fetch so the Firmware dialog cannot wait indefinitely on a stalled connection.
- Kept the external firmware repository URL because it is an App OTA integration dependency, not firmware source storage.

## Validation boundary

Static/source inspection was completed against the current `main` branch before this cleanup.

This cleanup has **not** been declared a successful APK build. A fresh App Build must run `flutter analyze`, `flutter test`, release packaging, and signing verification before the resulting APK is considered verified.

Physical BLE/OTA/hardware behavior also remains a separate runtime validation step.

## Change-control rule

For future App work:

- Read the current App notes/context before modifying App files.
- Inspect the current GitHub source before changing code.
- Keep firmware implementation out of this repository.
- Do not guess at BLE/OTA behavior when the current integration contract can be checked.
- Document every material App change in this file.


## 2026-09-28 — APP/FIRMWARE DOCUMENTATION BOUNDARY CORRECTION

- User clarified that **firmware documentation must remain in the App repository** for project continuity.
- `FIRMWARE_NOTES.md` is therefore retained as documentation only.
- Firmware implementation source files (`.ino`), firmware BIN artifacts, firmware CI/build files, and firmware production build outputs remain outside the App repository and are maintained separately by the user.
- The App Build workflow was corrected so `FIRMWARE_NOTES.md` is allowed, while a local `firmware/` source directory remains forbidden.
- No App BLE/UI/API behavior was changed by this documentation-boundary correction.
