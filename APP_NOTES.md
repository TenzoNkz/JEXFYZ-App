# JE X FYZ App — Master Notes

> **Document purpose:** permanent maintenance memory for the JE X FYZ App.
> This file describes the App repository, the App↔firmware integration contract, the Android/runtime boundary, build rules, validation rules, and change history.
> **Reviewed:** 2026-09-28.

## 1. CURRENT STATE — AUTHORITATIVE

### 1.1 Repository ownership

- Repository: `TenzoNkz/JEXFYZ-App`
- Product/App name: **JE Cooler**
- In-app brand/header: **JE X FYZ**
- Platform: Flutter + Android
- Primary UI/architecture reference: **Horizon Cooler App**
- Repository scope: **App-only**
- Firmware implementation source (.ino), firmware production BIN, firmware CI/build output, and firmware working files are maintained outside this repository by the user.
- **FIRMWARE_NOTES.md is intentionally kept in this repository as documentation only.**
- The App may keep the Firebase firmware metadata URL because it is an App OTA integration dependency, not firmware source storage.

### 1.2 Repository boundary — do not break this rule

The App repository may contain:
- Flutter/Dart App source
- Android wrapper/native bridge
- App assets
- App build/test configuration
- App CI workflow
- App notes
- Firmware documentation/notes needed for project continuity

The App repository must not contain:
- `firmware/` source directory
- production firmware `.ino` implementation
- production firmware `.bin` artifact
- firmware build output
- firmware production CI/build workflow

A future App cleanup must not remove `FIRMWARE_NOTES.md` merely because firmware source is external.

## 2. APP ARCHITECTURE

### 2.1 Flutter layer

The main App implementation is concentrated in:
- `lib/main.dart`
- `pubspec.yaml`
- `test/widget_test.dart`

The App follows the established Horizon Cooler architecture/style and adds JE X FYZ-specific:
- BLE device discovery and session handling
- P1 command/telemetry protocol
- cooler controls
- adaptive mode UI
- voltage UI
- fan-speed UI
- temperature UI
- LED/RGB configuration UI
- firmware-update dialog
- Android integration/security bridges

### 2.2 Android layer

Important Android files:
- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`
- `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/JeForegroundService.kt`
- `android/app/proguard-rules.pro`
- `android/build.gradle`
- `android/settings.gradle`
- `android/gradle.properties`

Android package/application ID:
`com.horizontalzzz.jexfyz`

The native layer exists only to provide services Flutter cannot/should not own directly, including:
- battery-temperature bridge
- Android settings intents
- Android SDK information
- Bluetooth settings opening
- foreground-service lifecycle
- release-build signing/integrity check

### 2.3 Native foreground-service rule

`JeForegroundService.kt` is **not** a second BLE implementation.

It exists to keep the required Android foreground-service lifecycle/notification alive for an already-established App session. Future changes must not accidentally introduce another BLE client, scanner, notification-owned connection, or duplicated session state inside the service.

## 3. APP ↔ FIRMWARE BLE CONTRACT

### 3.1 Device identity

- BLE device name: **JE X FYZ**
- Protocol generation: **P1**

### 3.2 UUID contract

Service:
`6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001`

RX:
`6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001`

TX:
`6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001`

These UUIDs are an integration contract. Do not change them casually.

### 3.3 State authority

The firmware remains the authority for:
- physical voltage state
- peltier state
- fan state
- safety state
- temperature protection
- adaptive control
- physical LED state

The App must not interpret a successful BLE write as proof that the physical device accepted/performed the operation.

The correct model is:

1. App sends an intended state/command.
2. Firmware processes it.
3. Firmware returns telemetry/ACK/state evidence.
4. App updates the displayed state from evidence.

This avoids UI drift after rejected, delayed, safety-limited, or interrupted commands.

## 4. APP RUNTIME BEHAVIOR

### 4.1 Home/UI rules

Current established UI direction:
- dark header
- white rounded content panel
- compact status/control presentation inspired by Horizon Cooler
- Bluetooth and Settings actions remain simple header actions
- no notification icon box
- Phosphor Icons are used for JE X FYZ controls
- Material `Icons.*` are not used for the JE X FYZ control UI
- cooler image is intentionally prominent
- voltage indicator, adaptive mode, peltier/fan controls, fan speed, and notification/reason state remain part of the core Home experience

### 4.2 Fan-speed contract

- App display/control uses percentage values.
- App-side control range: **50%–100%**.
- PWM behavior is a firmware responsibility.
- The App must not claim PWM changes are effective until firmware telemetry/state confirms the physical mode/value.

### 4.3 Session gate

Normal state-changing BLE writes must pass through the current active-session gate.

Do not add direct ad-hoc writes around the central session model without first checking:
- connection state
- service discovery
- RX/TX characteristics
- command serialization
- pending command/ACK handling
- reconnect behavior

### 4.4 Telemetry expectations

Integration documentation currently defines:
- hotside temperature: approximately **1 Hz**
- phone/device battery telemetry: approximately **1 Hz** where supported by the integration layer
- other state: sent/processed when changed rather than continuously retransmitted

The exact final telemetry semantics are governed by the firmware P1 implementation and must be checked against the current firmware notes before changing App assumptions.

## 5. ONLINE FIRMWARE OTA INTEGRATION

### 5.1 Firmware metadata source

Firebase Realtime Database is now the firmware release metadata/control plane:

Current node: `/firmware_update`

`https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`

Expected document shape:
```json
{
  "version": "V1.0",
  "url": "https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.0.bin"
}
```

The App validates the version and restricts the returned binary URL to the JE X FYZ firmware repository on `raw.githubusercontent.com`.

GitHub is now binary-only for this OTA path; the GitHub `manifest.json` is no longer part of the App update-discovery path.

Firmware source is **not** embedded in the App repository.

### 5.2 Firmware metadata validation

The App validates:
- firmware version shape: `V<major>.<minor>`
- Firebase metadata response is JSON/object-shaped
- HTTPS transport for the returned BIN URL
- `raw.githubusercontent.com` host
- repository path under `/TenzoNkz/JEXFYZ-Firmware/`
- returned file is a `.bin`
- Firebase metadata URL must resolve to an approved GitHub `.bin` path; GitHub `manifest.json` is not accepted


The App accepts any valid **different** firmware version as an OTA target, including a rollback/downgrade for controlled testing.

The App does **not** use a SHA-only firmware-version selection mechanism.

### 5.3 OTA network behavior

Firmware-manifest fetching uses bounded HTTP timeouts so a stalled network request does not leave the firmware-update dialog waiting indefinitely.

Future changes must keep network failures explicit:
- timeout
- DNS/connection failure
- invalid manifest
- invalid version
- invalid host/path
- unavailable BIN
- firmware-side OTA failure

Do not collapse all OTA failures into a generic silent state.

### 5.4 Wi-Fi/BLE boundary

The firmware owns the actual single-antenna radio handoff.

The App responsibility is to:
- request/update firmware through the documented OTA integration
- display progress/state
- tolerate the expected BLE disconnect/reconnect during OTA
- rediscover/reconnect after firmware restart
- not invent a simultaneous Wi-Fi + BLE capability that the hardware does not provide

## 6. SECURITY / RELEASE

### 6.1 Release package

- Android package: `com.horizontalzzz.jexfyz`
- Release build: R8/minification enabled
- Resource shrinking: enabled
- Production signing: required
- App integrity is checked by the native release-signing certificate logic

Expected production signing identity currently documented:
- CN: `JE X FYZ`
- OU: `JE X FYZ`
- O: `JE X FYZ`
- L: `Indonesia`
- ST: `Central Java`
- C: `ID`

Expected certificate SHA-256 documented by the build workflow:
`dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`

### 6.2 Firebase/App Check boundary

Firebase App Check / Play Integrity remains an **App security layer**.

It is not the firmware source or production firmware distribution mechanism.

### 6.3 Secret handling

Wi-Fi credentials used by the App are stored through:
`flutter_secure_storage`

Do not move Wi-Fi credentials into plain-text preferences or log output.

## 7. DEPENDENCY CONTRACT

Current important Flutter dependencies:
- `flutter_blue_plus ^2.3.12`
- `firebase_core ^4.15.0`
- `firebase_app_check ^0.4.8`
- `flutter_secure_storage ^11.0.0`
- `permission_handler ^13.0.2`
- `phosphor_icons ^3.0.1`

`shared_preferences` was intentionally removed as unused during the App-only cleanup.

Dependency changes should be justified against actual source usage and compatibility rather than added speculatively.

## 8. BUILD WORKFLOW

Workflow:
`.github/workflows/app-build.yml`

Purpose:
1. establish the fixed Flutter/Java/Gradle environment
2. audit App-only repository boundaries
3. obtain dependencies
4. run static analysis
5. run Flutter tests
6. build a release APK
7. obfuscate release Dart code
8. verify the release APK signing certificate
9. upload the canonical APK artifact
10. upload Dart symbol files

Current pinned build environment documented in the workflow:
- Java 17
- Flutter 3.47.2
- Gradle 9.3.1
- Android compile SDK 37
- target SDK 36
- minimum SDK 24
- Java/Kotlin JVM 17
- Android Gradle Plugin 9.1.1
- Kotlin 2.2.20
- Google Services plugin 4.4.4

Canonical artifact naming:
`JEXFYZ#<GitHub Actions run number>.apk`

Dart symbols artifact:
`JE-X-FYZ-Dart-Symbols`

### Build trigger policy

**Build is manual-only.**

- The App Build workflow uses **only** `workflow_dispatch`.
- Repository pushes, source edits, notes edits, asset changes, dependency changes, or workflow changes must **never** start an App Build automatically.
- A build is to be started only after the user explicitly instructs ChatGPT to **“Build App”**.
- A workflow file existing or being healthy is not the same as a verified APK; the actual run result must still be checked.

## 9. VALIDATION RULES

Every meaningful App change should separate these validation layers:

### Static validation
- source inspection
- import/dependency consistency
- repository-boundary check
- manifest/build-config consistency
- no accidental firmware source reintroduction

### Automated App validation
- `flutter analyze`
- `flutter test`
- release packaging
- APK signature verification

### Runtime validation
- real Android installation
- BLE scan/connect
- characteristic discovery
- command/ACK/state synchronization
- reconnect behavior
- OTA dialog behavior

### Hardware/firmware validation
Owned by the firmware workflow and physical device testing. App source inspection cannot prove firmware hardware behavior.

## 10. SOURCE COMMENT / AI MAINTENANCE RULE

All maintainable source/configuration files were given persistent comments explaining important architecture and constraints.

The comments are intended as maintenance memory:
- why a boundary exists
- what must not be duplicated
- which layer owns a responsibility
- which external contract must remain stable
- what a future maintainer must verify before changing the code

Comments must remain factual. They must not replace verification.

The 2026-09-28 comment pass reported:
- `lib/main.dart`: 77 method-level AI maintenance markers, all attached to declarations
- no suspicious AI-METHOD insertions inside expressions
- Android/Kotlin/Gradle/manifest/ProGuard/pubspec/test/CI files documented
- `google-services.json` intentionally unchanged because JSON does not support comments
- PNG assets intentionally unchanged because they are binary assets

## 11. FILE ROLE MAP

| Path | Role |
|---|---|
| `lib/main.dart` | Main Flutter App, UI, BLE/P1 integration, OTA dialog and app state |
| `pubspec.yaml` | Flutter package/dependency contract |
| `test/widget_test.dart` | App/widget-level automated test boundary |
| `android/app/src/main/kotlin/.../MainActivity.kt` | Native Flutter↔Android bridge |
| `android/app/src/main/kotlin/.../JeForegroundService.kt` | Android foreground-service lifecycle support |
| `android/app/src/main/AndroidManifest.xml` | Android permissions/components/service declarations |
| `android/app/build.gradle` | App Android build/signing/R8 configuration |
| `android/app/proguard-rules.pro` | Release shrinker/keep rules |
| `.github/workflows/app-build.yml` | App-only CI/release build |
| `APP_NOTES.md` | App master maintenance memory |
| `FIRMWARE_NOTES.md` | Firmware master documentation/history; documentation only |
| `assets/jexfyzcooler.png` | Cooler UI asset |
| `assets/jexfyzicon.png` | App/icon asset |
| `android/app/google-services.json` | Firebase Android configuration; do not add comments |

## 12. DOCUMENTATION REORGANIZATION — 2026-09-28

- Rebuilt APP_NOTES.md as a structured master document instead of a loose accumulation of cleanup notes.
- Corrected the repository-boundary contradiction: App implementation stays external to firmware, while FIRMWARE_NOTES.md remains intentionally stored in this App repository.
- Added explicit sections for App architecture, BLE/P1 contract, OTA integration, security, dependency lock, build workflow, validation layers, source-comment policy, file roles, and change-control rules.
- Preserved the project rule that an unrun Build App workflow must not be described as a verified APK.
- Preserved the project rule that App validation cannot prove physical firmware/hardware behavior.
- This documentation-only reorganization does not intentionally change App runtime behavior.

## 12. BUILD TRIGGER POLICY CORRECTION — 2026-09-28

- Corrected the previous automatic-trigger experiment.
- App Build is now **manual-only** via `workflow_dispatch`.
- No push/path trigger remains in the App Build workflow.
- The earlier setup commit created App Build run **#11** (`36372793640`) before this correction; that run belongs to the superseded automatic-trigger configuration and is not evidence of a user-requested build.
- Future App source changes will not build automatically.
- The normal execution boundary is now: user says **Build App** → start the App Build workflow → inspect the complete result → only then deliver/report the APK.


## 12. CURRENT CHANGE / VALIDATION STATUS — 2026-09-28

Latest completed App cleanup work:
- App repository boundary corrected to App-only.
- `FIRMWARE_NOTES.md` restored and retained as documentation.
- Local `firmware/` implementation directory removed.
- Temporary firmware build workflow removed from the App repository.
- Unused `shared_preferences` dependency removed.
- Unused `flutter/rendering.dart` import removed.
- Unused native `enableLocation` MethodChannel case removed.
- Firmware manifest network fetch given bounded timeouts.
- Source/configuration comments expanded across the App.
- No firmware source or BIN was reintroduced.
- The 2026-09-28 comment pass itself was not intended to change App runtime/protocol behavior.

**Current verification status:** the App has **not** been declared a freshly verified release APK after this cleanup/comment pass. A fresh `Build App` is required before claiming release-build success.

## 13. CHANGE CONTROL

Before changing App code:
1. Read this file.
2. Read the relevant source file and its existing comments.
3. Check the current BLE/OTA integration contract.
4. Make the smallest justified change.
5. Run the appropriate validation.
6. Update this file with the reason, exact change, and validation result.

Never:
- guess a BLE UUID
- invent a firmware response/ACK
- assume a BLE write means physical success
- add firmware source back into the App repository
- remove `FIRMWARE_NOTES.md`
- treat an unrun build as a successful build
- treat App tests as proof of physical hardware behavior

## 2026-09-28 — FIREBASE OTA CONTROL PLANE

- Changed App OTA discovery from the GitHub `manifest.json` to Firebase Realtime Database.
- Firebase path: `/firmware_update` under project `je-x-fyz`.
- Firebase stores only release metadata: `version` and the approved GitHub `.bin` URL.
- GitHub is binary-only for the Online OTA path; no GitHub manifest is required by the App.
- No App Build was run; source-only change.

## 2026-09-28 — FINAL FIRMWARE UPDATE NODE

- Firebase RTDB node is now `/firmware_update`.
- REST endpoint used by the App: `https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`.
- Expected fields: `version` and `url`.
- GitHub binary filename is fixed to `JEXFYZ.cpp.bin` on the `main` branch.
- App URL validation now accepts only that exact GitHub raw BIN path.
- GitHub `manifest.json` is not part of the OTA discovery path.
- No App Build was run for this change.

## 2026-09-28 — DEBUGGING WORKFLOW PREFERENCE

- User does not want Serial Monitor to be a required debugging workflow.
- Future App/firmware diagnosis should prioritize source inspection, official API verification, build/compiler output, automated/static checks, and direct physical symptoms/screenshots supplied by the user.
- Do not make Serial Monitor capture a prerequisite for investigating OTA or runtime failures.


## 2026-09-28 — BUILD ATTEMPT / AUDIT FIX

- Requested **Build App** was executed using the App Build workflow.
- Run #13 initially failed during the App-only security/architecture audit before dependency analysis/build.
- Exact failure: audit required stale identifier `firmwareManifestUrl`.
- Current App OTA implementation uses `firmwareMetadataUrl` for the Firebase Realtime Database endpoint; GitHub is binary-only.
- Corrected `.github/workflows/app-build.yml` to require `firmwareMetadataUrl` instead of the obsolete `firmwareManifestUrl` token.
- A new App Build is triggered by the corrected workflow commit and must be validated through release packaging and production APK signature verification before delivery.
