## 2026-10-04 — BUILD APP #52 FAILED / SIGNATURE CHECK PIPEFAIL

- Build #52 run `37196349621` compiled the release APK successfully, but the workflow correctly stopped during production signing verification.
- CI confirmed the APK used the required production certificate:
  - DN: `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - SHA-256: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
  - V2 signature: `true`
- Root cause was a workflow-shell issue, not a signing identity mismatch: with `set -o pipefail`, the signature-output `grep` pipeline exited after matching and the upstream producer received SIGPIPE, causing `printf: write error: Broken pipe` and exit code 1.
- Fixed only the signature verification shell block to use here-strings and Bash lowercase expansion instead of the failing pipelines.
- Build #52 produced no release artifact because filename preparation and artifact upload were correctly skipped after signature verification failed.
- Source/App behavior was not changed by this fix; no BLE/P1, OTA, Firebase, firmware, GPIO, safety, or signing identity changes were made.

# JE X FYZ — CURRENT APP NOTES

## IDENTITY
- App name: JE Cooler
- Header: JE X FYZ
- Package: com.horizontalzzz.jexfyz
- Version: 1.0.0+3
- Main source blob: 8ebd878b116d7ef093b6df54894a7db876eb0f02
- Settings blob: f11235bab559b291928550e06984532581ddad6a

## BLE / SESSION
- flutter_blue_plus is the BLE transport.
- JE X FYZ service/RX/TX UUIDs are frozen.
- P1 SYNC/SYNC_READY remains the usable-session gate.
- Firmware telemetry remains authoritative for hardware and safety state.
- Passive Auto Connect remains permission-free and preference-controlled.
- Online OTA recovery is explicit and does not depend on passive Auto Connect.

## OTA
- Firmware update flow remains OTAENTER, SSID, PASS, URL, VERSION, CLOUDOTA.
- Firmware performs flashing; App coordinates metadata, commands, disconnect handling, and reconnection.
- Expected Online OTA GATT disconnect is no longer shown as a normal Bluetooth error.
- After OTA reconnect, the App completes normal P1 sync and surfaces the one-shot OTA result.
- OTA_UP_TO_DATE is recognized as a one-shot result.
- Firebase supplies release metadata; GitHub hosts the fixed firmware BIN URL.
- Wi-Fi credentials remain in flutter_secure_storage.

## UI / CONTRACT SYNC
- Adaptive Ceiling is displayed from firmware telemetry.
- Battery thresholds match firmware: 5V 20–30°C and 12V 30–40°C.
- Safety display follows SAFETY OK/LOCKED and SAFETY_REASON.
- OTA stage presentation follows the current Firmware stage tokens.
- Wi-Fi password input is masked.

## BUILD
- Latest verified App Build: #50.
- Build #50 does not validate the current V4.5-synchronized App source.
- No new App Build was triggered during this execution.
