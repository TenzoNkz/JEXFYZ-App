# JEXFYZ Security Red-Team Audit — 2026-10

## Scope

Authorized defensive assessment of the JE Cooler / JE X FYZ stack in this repository. Review covered:

- Android APK integrity and release configuration
- Flutter BLE discovery/session handling
- ESP32-C3 BLE authorization and command boundary
- Local Wi-Fi OTA
- Online OTA version policy and transport security
- Firebase firmware metadata handling
- Safety enforcement for fan/Peltier controls
- Replay/flood/crash surfaces visible from source
- Release/rollback governance

This pass is source-based. No physical ESP32-C3 radio session, Android release APK decompilation, live BLE MITM, live Firebase write test, or physical-flash test was executed in this environment.

## Confirmed Findings

### [HIGH] BLE control channel was unauthenticated

The firmware accepted a BLE connection and allowed a client to progress from `SYNC` to `SYNC_READY` without cryptographic authentication. The Flutter-side `_bleSessionReady` flag was only an application state flag and could not protect the device from a custom BLE client.

Impact: a nearby client that knew the public service/characteristic UUIDs could reach the firmware command handler directly.

### [FIXED] BLE encrypted command channel + single-peer authorization

The hardened firmware now:

1. Enables BLE bonding + Secure Connections on the ESP32-C3.
2. Marks the RX command characteristic as encrypted-write protected.
3. Stores one authorized bonded peer identity in NVS.
4. Rejects authenticated peers that are not the stored identity.
5. Requires a physical 5-second long-press commissioning gesture before the first peer can be stored.

The commissioning gesture also arms the local OTA window.

Residual limitation: the commissioning design currently uses Secure Connections without MITM because the cooler has no display/input path for a passkey. A more advanced commissioning design could add an out-of-band code or other authenticated pairing mechanism.

### [HIGH] Online OTA TLS verification was disabled

The firmware used `cloudClient.setInsecure()`, which disables certificate-chain verification.

### [FIXED] Online OTA now validates TLS

The firmware now uses the Arduino-ESP32 built-in CA bundle through `useBuiltinCACertBundle()`.

### [HIGH] OTA source validation accepted arbitrary .bin files inside the release repository

The firmware URL validator previously accepted any HTTPS raw GitHub .bin path under the JEXFYZ-Firmware repository.

### [FIXED] OTA URL is exact-match pinned

Firmware now accepts only:

`https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin`

The existing app-side validation already pinned the same exact URL.

### [MEDIUM/HIGH] Online OTA allowed firmware rollback

The OTA flow rejected only the exact current version. Any other valid version, including an older version, could be selected.

### [FIXED] Monotonic OTA version policy

- App only offers a strictly newer firmware version.
- Firmware independently rejects a version that is not newer than its running version.
- Rejected versions do not proceed to Wi-Fi connection or flashing.

### [HIGH] Local OTA required only the static AP credential

The local OTA service used a fixed password present in source. That password alone was therefore not a meaningful authorization boundary.

### [FIXED] Local OTA upload now requires physical presence

A 5-second physical long-press during the boot AP window arms a 30-second local OTA authorization window. Uploads without that physical authorization are rejected before `Update.begin()`.

Additionally, an arbitrary Wi-Fi client no longer forces the firmware into cooling-off / BLE shutdown safe mode. Only a physically authorized client can claim that OTA-safe session.

Residual limitation: an attacker with physical access to the button/device can authorize local OTA. Physical possession of the ESP32 also permits lower-level flashing attacks outside the software OTA boundary.

## Positive Security Controls Already Present

- Release Android builds are production-signed and R8/minified.
- Android release integrity checks compare the installed APK signing certificate against the configured production signing identity.
- Wi-Fi credentials for online OTA are stored through Flutter Secure Storage.
- Firmware-side Peltier safety checks remain authoritative; App state does not directly bypass NTC/hotside/fan safety.
- OTA forces cooling outputs off while an OTA session owns the device.
- Firmware binary size is bounded before `Update.begin()`.
- Local OTA validates the upload extension and declared/received size.
- BLE command processing has a pre-session gate and serialized RX/TX queues.
- OTA Wi-Fi/BLE radio transitions remain single-radio and state-machine based for ESP32-C3.

## Not Yet Verifiable Without Live Infrastructure

### Firebase RTDB write rules

No Firebase security-rules file was present in this repository, and live Firebase access was not available in this execution environment.

The app intentionally treats firmware metadata as public-read data and pins the firmware URL. The remaining question is whether unauthorized clients can WRITE or replace the `firmware_update` object.

Required live test:
- anonymous GET
- anonymous PUT/PATCH
- authenticated-but-unprivileged PUT/PATCH
- malformed version/url injection
- confirm release path is write-protected

### Release APK reverse-engineering

The source contains an Android signing-integrity gate, but an actual built release APK was not available for decompilation in this execution environment.

Required live test:
- decompile release APK
- search for secrets/tokens
- patch/replace integrity branch
- verify the modified APK cannot obtain a usable device session because the firmware now enforces BLE authorization independently

### BLE adversarial testing

The firmware changes need real ESP32-C3 + Android validation for:
- first-pair commissioning
- Android bonding behavior on encrypted RX writes
- reconnect of the authorized phone
- rejection of a second phone
- behavior after Android forgets/recreates the bond
- reboot persistence of the authorized peer
- repeated unauthorized connection attempts

## Release Note

The hardened firmware source is now marked **V2.4**. The separate JEXFYZ-Firmware binary repository was not modified because a new release binary cannot be safely generated here without the user's Arduino build environment / signing process.

The app build number was bumped from **1.0.0+3** to **1.0.0+4**.

## Build Policy

No App build workflow was manually dispatched in this security pass, preserving the project's explicit rule that App builds should run only when the user requests **Build App**.

## Recommended Next Security Layer

For a higher-assurance product release, add cryptographic firmware-image signing plus verified boot / secure boot and flash-encryption configuration appropriate for the ESP32-C3 production hardware. URL pinning and TLS authenticate the transport endpoint, but they do not cryptographically prove that the firmware image itself is an authorized JE X FYZ image if the release repository is compromised.

## Current Hardening Status

| Area | Status |
|---|---|
| BLE unauthorized control | FIXED in source |
| BLE single-peer binding | FIXED in source |
| BLE encrypted command writes | FIXED in source |
| Local OTA unauthorized upload | FIXED in source |
| Local OTA client-triggered DoS path | FIXED in source |
| Online OTA TLS validation | FIXED in source |
| OTA URL allowlist | FIXED in source |
| OTA downgrade | FIXED in app + firmware source |
| Android release signing/integrity | Existing defense retained |
| Firmware image cryptographic authenticity | NOT IMPLEMENTED |
| Firebase write-rule audit | REQUIRES LIVE TEST |
| Physical flash attack resistance | REQUIRES SECURE-BOOT / FLASH-ENCRYPTION PLAN |
| Live BLE/Android regression | REQUIRES HARDWARE TEST |
