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

## 2026-09-28 — BUILD ATTEMPT #14 / AUDIT FIX 2

- App Build run #14 reached the App-only security/architecture audit but failed before dependency analysis.
- Exact failure: the audit treated the valid current Firebase RTDB endpoint token `firmware_update` as a legacy firmware metadata reference.
- The current App intentionally uses `firmwareMetadataUrl` ending in `/firmware_update.json`; this is the approved Firebase OTA control-plane endpoint.
- Legacy Firebase implementation markers remain forbidden: `FirebaseDatabase.instanceFor` and `firebase_database`.
- Corrected `.github/workflows/app-build.yml` by removing only the stale `firmware_update` forbidden-token check.
- A new App Build is triggered by this workflow fix and must pass audit, analyze, tests, release packaging, and production signature verification before APK delivery.

## 2026-09-28 — BUILD ATTEMPT #15 / DART ANALYZE FIX

- App Build run #15 passed the App-only security/architecture audit and dependency installation.
- Exact Dart analysis failure: `Undefined name 'ScrollCacheExtent'` at `lib/main.dart:2477:32`.
- Root cause: `ScrollCacheExtent.pixels(...)` is not a valid Flutter API type for the pinned App toolchain.
- Minimal source fix: replaced `scrollCacheExtent: const ScrollCacheExtent.pixels(480)` with the supported `cacheExtent: 480.0` ListView property.
- No BLE, OTA, protocol, or UI behavior was intentionally changed beyond preserving the requested 480px scroll cache.
- A new App Build must now pass analyze, Flutter tests, release APK packaging, production signature verification, and artifact upload.

## 2026-09-28 — BUILD ATTEMPT #16 / DART API CORRECTION

- App Build run #16 passed the security/architecture audit and dependency installation but failed at `flutter analyze`.
- Exact diagnostic: `cacheExtent` is deprecated in the pinned Flutter 3.47.2 toolchain; analyzer explicitly reported `Use scrollCacheExtent instead` at `lib/main.dart:2477:7`.
- Corrected the previous minimal fix to the actual supported API: `scrollCacheExtent: 480.0`.
- The original `ScrollCacheExtent.pixels(480)` form was invalid because the named type does not exist; the property itself accepts the numeric extent.
- No intended UI behavior change: the scroll cache remains 480 logical pixels.
- A new App Build is required to validate analyze, tests, release APK packaging, signing, and artifact upload.

## 2026-09-28 — BUILD ATTEMPT #19 / OFFICIAL FLUTTER API VERIFICATION

- App Build run #19 passed the security/architecture audit and dependency installation but failed at `flutter analyze`.
- Exact diagnostic: `The argument type 'double' can't be assigned to the parameter type 'ScrollCacheExtent?'` at `lib/main.dart:2477:26`.
- Official Flutter source verification confirmed `ScrollCacheExtent` is declared in `package:flutter/rendering.dart` and provides the factory `ScrollCacheExtent.pixels(double)`.
- Corrected the source to use the official form `scrollCacheExtent: const ScrollCacheExtent.pixels(480)` and restored the required `package:flutter/rendering.dart` import.
- This preserves the intended 480 logical-pixel cache extent without using deprecated `cacheExtent`.
- A fresh Build App validation is required after this exact API correction.

## 2026-09-28 — BUILD ATTEMPT #20 / SCROLL CACHE TYPE FIX

- App Build run #20 passed the security/architecture audit but failed at `flutter analyze`.
- Exact diagnostics: `scrollCacheExtent: 480.0` had type mismatch because the parameter type is `ScrollCacheExtent?`; analyzer also reported the explicit rendering import as unnecessary because `material.dart` already exports the used type.
- Official Flutter source confirms the intended constructor is `const ScrollCacheExtent.pixels(480)`.
- Corrected `lib/main.dart` to `scrollCacheExtent: const ScrollCacheExtent.pixels(480)` and removed the redundant `flutter/rendering.dart` import.
- The intended 480 logical-pixel cache behavior is preserved.
- A fresh Build App validation is required to continue through analyze, tests, release packaging, signature verification, and APK artifact upload.

## 2026-09-28 — BUILD ATTEMPT #23 / IMPORT CORRECTION

- App Build run #23 still failed at `flutter analyze` with `Undefined name 'ScrollCacheExtent'` at `lib/main.dart:2477:32`.
- The source used the official `ScrollCacheExtent.pixels(480)` constructor, but the defining class was not imported in that revision.
- Corrected `lib/main.dart` by explicitly importing `package:flutter/rendering.dart` while retaining `scrollCacheExtent: const ScrollCacheExtent.pixels(480)`.
- This is the minimal import correction required by the official Flutter declaration already verified in `rendering/viewport.dart`.
- A fresh Build App validation is required; no APK has been delivered until all release checks pass.

## 2026-09-28 — BUILD APP FINAL SUCCESS

- **Build App completed successfully on run #24**: GitHub Actions run `36375464018`.
- Validation passed end-to-end: App-only security/architecture audit, Flutter dependency installation, `flutter analyze`, Flutter tests, release APK build, production APK signature verification, APK filename preparation, APK artifact upload, and Dart symbol upload.
- Canonical APK artifact: `JEXFYZ#24.apk`.
- Artifact size: 52,835,604 bytes.
- Artifact SHA-256: `e0843c329f37a4b5771ac3ff19474026339afb0f6b2fe1c180f064f841c4f02c`.
- The release APK was successfully downloaded from the Actions artifact for delivery in the conversation.
- The temporary push-trigger mechanism used only to execute the explicitly requested Build App was removed afterward.
- App Build workflow is restored to **manual-only `workflow_dispatch`**.
- This run proves the App release build/signature pipeline, not physical BLE/firmware/hardware runtime behavior.

## 2026-09-28 — FIREBASE METADATA ACCESS

- The App firmware metadata endpoint is `https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json`.
- The installed APK must be rebuilt after source changes; an existing older APK does not inherit the new Firebase endpoint.
- Firebase RTDB must allow read access to `/firmware_update` for the direct REST metadata request used by the App.
- Recommended rule: `firmware_update/.read = true`, `firmware_update/.write = false`.
## 2026-09-28 — FIREBASE RTDB READ FIX

- App Online OTA metadata reader remains REST-based at `/firmware_update.json`.
- The REST request now explicitly attaches a fresh Firebase App Check token through the official `FirebaseAppCheck.getToken(true)` API when available, using the `X-Firebase-AppCheck` header.
- HTTP 401/403 responses are now surfaced as a Firebase read-permission/App Check rejection internally instead of being collapsed into an unexplained generic failure.
- The expected RTDB data remains exactly:
  - `firmware_update.version = V1.0`
  - `firmware_update.url = https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin`
- No App Build was run for this source fix.


## 2026-09-28 — RTDB METADATA READ INDEPENDENT OF APP CHECK

- Firebase Realtime Database firmware metadata is intentionally public-read at `/firmware_update` and contains only the current version plus a public GitHub BIN URL.
- Removed the explicit `X-Firebase-AppCheck` header requirement from this metadata REST request.
- Reason: the production APK is distributed outside Google Play, so making this public metadata read depend on Play Integrity/App Check can block OTA discovery even when RTDB rules allow `.read = true`.
- Firebase App Check remains initialized for the App's Firebase security layer; it is no longer a prerequisite for reading the public firmware metadata endpoint.
- No App Build was run for this source fix.

## 2026-09-28 — BLE DISCONNECT REDISCOVERY FIX

- App BLE lifecycle fix applied without changing the BLE UUID/P1 protocol or firmware advertising contract.
- Root cause found in App behavior: after a normal BLE disconnect, the App cleared the connected/session UI state but did not automatically start a new BLE scan. The firmware already restarts BLE advertising on disconnect.
- Added a bounded **disconnect rediscovery burst**: after a normal disconnect, the App starts BLE discovery immediately and retries every 3 seconds for up to 10 attempts (approximately 30 seconds).
- Each discovery attempt uses the existing FlutterBluePlus scan path and the existing JE X FYZ name/service matching.
- The rediscovery burst is cancelled when a new connection starts.
- The rediscovery burst is intentionally suppressed while the existing Online OTA reconnect monitor is active, preventing two independent scanners from competing during OTA recovery.
- No App UI redesign, BLE UUID/protocol change, firmware change, Firebase change, OTA transport change, or release build was performed.
- Validation completed here: source inspection and static structure review of the changed lifecycle paths. A fresh App Build remains required for compile/analyze/release verification because App Build is manual-only.

## 2026-09-28 — BUILD APP #26 FINAL SUCCESS

- Explicit **Build App** completed successfully on GitHub Actions run #26 (`36376406770`).
- Source revision built: `c56d4d52210faf68fe379b46db358ed3152e913e`, containing the latest Firebase public RTDB metadata read fixes documented immediately before the build.
- Full pipeline passed: security/architecture audit, dependency installation, `flutter analyze`, Flutter tests, release APK build, production APK signature verification, APK naming, APK artifact upload, and Dart symbol upload.
- Canonical APK artifact: `JEXFYZ#26.apk`.
- Artifact size: 52,835,604 bytes.
- Artifact SHA-256: `1a2282f0e9e6acf13cbb29f2d3403554ea53a3c4d33adb0b187bd553ddca8da1`.
- The APK artifact was downloaded and verified as an Android APK before conversation delivery.
- The temporary push trigger used only for this explicit Build App request was removed afterward.
- App Build workflow is restored to **manual-only `workflow_dispatch`**.
- This CI result validates the App release pipeline and production signing; it does not validate physical BLE/firmware/hardware runtime.

## 2026-09-28 — FIRMWARE V1.3 CURRENT BASELINE

- Firmware source currently stored with the App project is **V1.3**:
  - `firmware/JEXFYZ-V1.3.ino`
- `firmware/JEXFYZ-V1.2.ino` has been removed; the firmware folder is maintained as a single-current-source archive.
- V1.3 is the Gemini-derived firmware patch and is **not yet compile- or hardware-validated**.
- App OTA architecture remains unchanged:
  - Firebase RTDB = metadata/control plane.
  - GitHub = firmware BIN host.
  - Firmware itself does not query Firebase.
  - Public RTDB metadata remains the approved App-side integration point.
- Do **not** promote Firebase firmware metadata to V1.3 merely because the source version is V1.3. Promotion requires a deliberately published, compiled V1.3 BIN and the corresponding release/update decision.
- No App Build is implied by the firmware source update. The existing App build workflow remains manual-only.
- No App BLE protocol/UUID or App OTA transport change is required by the V1.3 firmware patch unless physical testing later demonstrates a protocol/lifecycle mismatch.
- Firmware runtime debugging continues to prioritize source inspection, ArduinoDroid compiler output, static validation, and physical symptoms/screenshots; Serial Monitor is not a prerequisite.


## 2026-09-28 — V1.4 FIRMWARE-ONLY REVISION

- Firmware source tracked by the App repo is now `firmware/JEXFYZ-V1.4.ino`; V1.3 was removed after rename.
- This revision changes only the Online OTA LED result-indicator timing and firmware version label.
- No Dart/Flutter, BLE UUID/protocol, Firebase OTA metadata, Android, or App build workflow changes were made.
- Existing App behavior remains the same: it initiates OTA through P1 commands, reads firmware OTA telemetry, and runs its bounded BLE reconnect monitor.
- Firebase firmware metadata remains unchanged; source version V1.4 is not sufficient reason to publish a V1.4 BIN.
- App Build is not implied by firmware revisions and remains manual-only.


## 2026-09-28 — LATEST ONLINE OTA SCREENSHOT EVIDENCE

- User supplied a physical screenshot showing: **`OTA in progress • ONLINE • Wi-Fi connect • 0%`**.
- The App source displays OTA stage values received from firmware and maintains a separate BLE `connected` state. Therefore a visible OTA stage does not itself prove that the ESP32 has already reached the Wi-Fi connection call.
- Current App OTA command sequencing remains unchanged and no App source change is indicated by this evidence.
- The latest diagnostic conclusion is that the next investigation should isolate the firmware radio-handoff boundary rather than modify Flutter UI/OTA transport speculatively.


## 2026-09-28 — V1.5 FIRMWARE-ONLY DIAGNOSTIC REVISION

- The firmware source paired with the App repository is now `firmware/JEXFYZ-V1.5.ino`.
- V1.5 is a firmware-only revision implementing the supplied Gemini handoff/retry patch.
- No Flutter/Dart, Android, BLE P1 UUID/protocol, Firebase metadata, or App workflow changes were made.
- The existing App Online OTA flow remains: send `OTAENTER`, SSID, PASS, URL, VERSION, then `CLOUDOTA`; read OTA telemetry and retry BLE discovery after the OTA session disconnects.
- The visible App stage `ONLINE_WIFI_CONNECT` remains a firmware telemetry state and does not by itself prove that `WiFi.begin()` has executed.
- Firebase metadata remains unchanged; V1.5 source presence is not a release-publish signal.
- App Build remains manual-only and was not triggered by this firmware change.


## 2026-09-28 — GEMINI V1.5 FULL SOURCE REPLACEMENT

- The user-provided full Gemini V1.5 firmware file is now the source of truth for `firmware/JEXFYZ-V1.5.ino`.
- The full file was applied directly as requested; no selective edits were introduced during this replacement.
- App source and App build configuration were not changed.
- Firebase OTA metadata remains unchanged.
- Physical firmware validation remains pending.


## 2026-09-28 — V1.6 FIRMWARE-ONLY HTTPS PATCH

- Firmware source tracked by the App repo is now `firmware/JEXFYZ-V1.6.ino`.
- V1.6 contains the user-directed Gemini HTTPS/GitHub OTA patch only.
- No Flutter/Dart, Android, BLE protocol/UUID, or Firebase source changes were made.
- App OTA metadata and GitHub binary URL remain unchanged.
- App Build was not triggered; App Build remains manual-only.
- Physical V1.6 validation is pending.


## 2026-09-28 — OTA END-TO-END PHYSICAL VALIDATION / FREEZE

- User confirmed that **Local OTA and Online OTA both work successfully on the physical device**.
- The supplied physical App screenshot showed **OTA successful • ONLINE • Flash success • V6.4**.
- V6.4 was intentionally used as a test firmware version so Online OTA could be exercised repeatedly; it should be treated as a test value, not as a source-version promotion.
- The validated Online OTA architecture remains:
  Firebase metadata/control plane → App validation → BLE P1 OTA command sequence → firmware Wi-Fi handoff → GitHub JEXFYZ.cpp.bin download → Update.h flash → success/restart → BLE recovery.
- **OTA FREEZE:** the App OTA protocol, Firebase metadata endpoint, GitHub BIN URL, BLE OTA command sequence, and OTA status/telemetry contract are frozen unless the user explicitly requests an OTA change.
- Firmware-side physical success does not require an App Build. No App Build was triggered by this validation.


## 2026-09-28 — LED 7-MODE / PHYSICAL LAYOUT UPDATE

- App LED mode selector is aligned with firmware V2.1: **7 modes**.
- Removed **Twinkle** from the LED mode list.
- App mode parsing/display and outbound MODE command range are now **1–7**.
- Previous mode 8 values are normalized to **mode 7 / Rainbow** by the App clamp.
- Mode navigation stops at mode 1 and mode 7 instead of sending unsupported values.
- No BLE UUID/protocol, OTA transport, reconnect monitor, Firebase metadata, Android lifecycle, or App build workflow changes.
- **App Build was not triggered**; the App workflow remains manual-only.


## 2026-09-28 — APP BUILD #28 SUCCESS / APP-ONLY REPOSITORY BOUNDARY RESTORED

- User explicitly requested **Build App**.
- Temporary `push` trigger was added only to start the manual-requested validation run; the App Build workflow was restored to **manual-only (`workflow_dispatch`)** after completion.
- Run **#27** (`36399794582`) stopped at the App security/architecture audit because the repository still contained `firmware/JEXFYZ-V2.0.ino`.
- The audit failure was valid under the App-only repository boundary: firmware source/BIN/build artifacts must remain external to the App repository.
- The superseded in-repo firmware source file `firmware/JEXFYZ-V2.0.ino` was removed. No Flutter/Dart/Android/App OTA runtime code was changed for this cleanup.
- Run **#28** (`36399990035`) was then executed from source revision `5d62b5ac6288004902481f83bc37497a93a43451` and passed the complete pipeline:
  - App security/architecture audit ✅
  - dependency installation ✅
  - `flutter analyze` ✅
  - Flutter tests ✅
  - obfuscated release APK build ✅
  - production APK signature verification ✅
  - APK artifact preparation/upload ✅
  - Dart symbols upload ✅
- Artifact: **`JEXFYZ#28.apk`**
- Artifact size: **52,851,988 bytes**
- Artifact SHA-256: **`18222aed26555a003fe6fe4dcb7e3d1706a0a71386226a5c30fa468b0b8b6e83`**
- CI signature verification confirmed:
  - APK Signature Scheme v2 = true
  - Certificate DN = `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - Certificate SHA-256 = `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
- The downloaded artifact was independently identified as a valid Android APK and its SHA-256 matched the GitHub artifact digest exactly.
- Workflow restore commit: `5f9efac3e34bf029f80598b57c6151cf67ea3b90`.
- **Current App Build workflow state: manual-only (`workflow_dispatch`); no automatic push trigger left enabled.**
- Build validation proves the App release pipeline and signing identity; it does not prove BLE, OTA, or physical hardware runtime.


## 2026-09-28 — APP BUILD #31 SUCCESS / LATEST SOURCE DELIVERY

- **Run #31** (`36400379692`) is the latest successful App Build and supersedes Build #28 as the delivery build because later App repository changes were committed after Run #28 started.
- Run #31 built source revision `15e90fb9ff27da01dd4a21b9cb67b00e482d56ed`, which includes the latest App LED 7-mode alignment work present in the repository at that time.
- Complete validation passed:
  - App security/architecture audit ✅
  - dependency installation ✅
  - `flutter analyze` ✅
  - Flutter tests ✅
  - obfuscated release APK build ✅
  - production APK signature verification ✅
  - APK artifact preparation/upload ✅
  - Dart symbols upload ✅
- Artifact: **`JEXFYZ#31.apk`**
- Artifact size: **52,851,988 bytes**
- Artifact SHA-256: **`78e83ea92e76ab480ec2b6b633f17fe76b1b04dfb202c529b33cfeb19e3ebebb`**
- The downloaded file was independently identified as an Android APK and its SHA-256 matched the GitHub artifact digest exactly.
- CI signature verification confirmed APK Signature Scheme v2 and the official production certificate:
  - DN = `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - SHA-256 = `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
- During the requested Build App window, consecutive repository commits caused residual push-triggered runs #29 and #30 to be cancelled while run #31 validated the latest source. The workflow has since been restored to manual-only.
- **Current App Build workflow state: manual-only (`workflow_dispatch`) with no automatic push trigger.**
- CI validation proves the App build/signing pipeline; it does not prove BLE, OTA, or physical hardware runtime.


## 2026-09-28 — LED PALETTE + BRIGHTNESS UI UPDATE

- App LED color selection is now a **48-color touch palette (8 × 6)**.
- Manual HEX color entry was removed from the App.
- Voltage color selectors for **5V / 9V / 12V** were removed from the App.
- **Reset Colors** was removed from the App.
- Firmware-owned voltage indicator colors remain unchanged.
- Palette selection applies only to LED modes that use the user RGB color. **Rainbow (Mode 7) keeps its own firmware hue cycle and disables the palette.**
- Brightness UI is now **1–100%** with **99 divisions**, allowing every 1% step.
- LED Power OFF remains the true OFF control; brightness UI no longer exposes 0%.
- Brightness uses the existing firmware BRIGHTNESS 1–100 interface; the firmware maps that user percentage to its hardware 0–255 scale.
- BLE protocol/UUIDs, OTA, reconnect rediscovery, and firmware source were not changed.
- App Build was **not triggered**; workflow remains manual-only.


## 2026-09-28 — APP BUILD TRIGGER SPLIT

- `app-build.yml` is now a **reusable workflow engine** triggered only through `workflow_call`; it has no `push` or direct manual trigger.
- Added `.github/workflows/app-build-trigger.yml` named **Build App** as the single manual entry point.
- One manual **Build App** trigger starts the reusable build engine once; normal repository commits do not create App Build runs.
- Historical extra runs caused by the temporary `push` trigger remain visible in GitHub Actions history; they are not new triggers after this change.
- App CI audit now permits the authoritative firmware `.ino` source under `firmware/` while still rejecting App-code dependencies on firmware source paths.
