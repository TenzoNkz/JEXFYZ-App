# JE X FYZ FIRMWARE — PROJECT MEMORY / ENGINEERING NOTES

> Firmware-specific memory is kept separate from APP_NOTES.md.

## Current source
- Authoritative source: firmware/JEXFYZ.ino
- Current source version: V3.2
- Target: ESP32-C3 Super Mini
- The current source uses WS2812FX 1.4.7 and lists Adafruit NeoPixel as an external dependency.
- The current source does not include OneButton; the build workflow does not invent an unused dependency.

## Distribution architecture
- Source stays inside the private JEXFYZ-App repository under firmware/.
- GitHub Actions compiles automatically when firmware/JEXFYZ.ino changes and also supports manual dispatch.
- Compiled release binaries are published to public repository TenzoNkz/JEXFYZ-Firmware.
- Public distribution uses manifest.json plus releases/JEXFYZ-Vx.x.bin.
- The App consumes the public manifest over HTTPS.
- Firebase is not used for firmware release metadata.

## Build environment
- Arduino CLI via arduino/setup-arduino-cli@v2.
- ESP32 Arduino core pinned to 3.2.1.
- WS2812FX pinned to 1.4.7.
- Adafruit NeoPixel pinned to 1.12.5.

## Publishing secret
- GitHub Actions secret required in JEXFYZ-App: FIRMWARE_REPO_TOKEN.
- The token must have Contents: Read and write access to TenzoNkz/JEXFYZ-Firmware.
- The token must never be embedded in firmware, APK, or manifest.

## OTA contract
- App supplies the existing BLE OTA commands: OTAENTER, SSID, PASS, URL, VERSION, CLOUDOTA.
- Release URLs are HTTPS raw GitHub URLs.
- No SHA/hash field is used in the firmware update metadata contract.

## Repository notes layout
- App notes: APP_NOTES.md
- Firmware notes: FIRMWARE_NOTES.md
- This firmware notes file is intentionally kept at the repository root.

## Validation status
- Workflow configuration is added in the private repository.
- GitHub Actions firmware Run #2 failed because Arduino CLI requires the sketch directory name and main .ino filename to match; workflow is now corrected to stage as build/JEXFYZ/JEXFYZ.ino. The user has configured FIRMWARE_REPO_TOKEN; publish validation remains pending.
- The public repository retains its existing JEXFYZ.cpp.bin as the initial baseline; the workflow removes that legacy filename after the first automated release.


## 2026-09-26 — Firmware build execution ownership

- Firmware Build is the automatic CI path for firmware source updates.
- A change to `firmware/JEXFYZ.ino` automatically starts Firmware Build.
- The active Code sub-chat making the firmware change owns the firmware CI follow-through: inspect the run, fix only build-blocking issues when needed, and repeat until the firmware build/publish pipeline succeeds.
- App Build remains separate and is manually triggered from the JE X FYZ Action sub-chat.
- Manual `workflow_dispatch` remains available for Firmware Build as an explicit fallback/test path.


## 2026-09-26 — Firmware manual trigger path

- Added `.github/FIRMWARE_BUILD_TRIGGER` as a dedicated manual execution hook.
- Updating this trigger file starts the same Firmware Build workflow used for real firmware updates.
- A trigger-only run does not require changing `FW_VERSION`; firmware source/version remains unchanged.
- Real changes to `firmware/JEXFYZ.ino` continue to auto-trigger Firmware Build.


## 2026-09-26 — Build compatibility fix from Run #6

- Firmware Build Run #6 failed at ESP32-C3 compile with Arduino ESP32 core 3.2.1 due to three API mismatches in `firmware/JEXFYZ.ino`.
- Applied narrow compatibility fixes:
  - Use `ESP_LE_AUTH_REQ_SC_BOND` with `BLESecurity::setAuthenticationMode()`.
  - Remove unavailable `BLEServer::advertiseOnDisconnect()`; existing disconnect callback restarts advertising.
  - Use `ESP_GATT_PERM_WRITE_ENCRYPTED` for the encrypted RX permission.
- Commit: `3affa13a97d63eac1777ec2c6315fed9f8720a48`.
- Version remains V3.2 for this build-fix cycle.
- A new Firmware Build run should auto-trigger from the firmware source update and is pending verification through publish success.


## 2026-09-26 — Run #7 firmware size / partition fix

- Run #7 failed at link stage because the firmware image was 1,826,576 bytes (139%) and exceeded the default 1,310,720-byte app partition.
- Updated `.github/workflows/firmware-build.yml` to compile `esp32:esp32:esp32c3:PartitionScheme=min_spiffs`.
- The `min_spiffs` partition keeps two OTA app slots and gives each slot 0x1E0000 bytes, sufficient for the current image while preserving OTA.
- No firmware source logic was changed for this fix.
- New Firmware Build run is expected automatically from the workflow update and must be followed until the full publish pipeline succeeds.


## 2026-09-26 — Firmware Build Run #8 result

- Run #8 compiled V3.2 successfully using `PartitionScheme=min_spiffs`.
- Image size: 1,826,608 bytes; app slot maximum: 1,966,080 bytes (92% used).
- Artifact upload succeeded; public repository publish was not reached because `FIRMWARE_REPO_TOKEN` was empty/unavailable in the Actions environment.
- This is now the only blocking item for the complete automated publish pipeline; no firmware source build error remains in this run.


## 2026-09-26 — Unified build execution trigger architecture

### Trigger behavior
- Removed manual `workflow_dispatch` from Firmware Build.
- Firmware Build runs on push when `firmware/JEXFYZ.ino` changes or when `.github/FIRMWARE_BUILD_TRIGGER` is updated for an explicit Code-sub-chat execution.
- A commit may contain firmware plus other files; a firmware change still starts the same workflow.
- App Build is separate and uses its own `.github/APP_BUILD_TRIGGER` path, with no manual dispatch.

### Public binary layout
- Firmware release binary is now published at the root of `TenzoNkz/JEXFYZ-Firmware`.
- Filename format: `JEXFYZ-Vx.x.bin`, where the version is extracted from `FW_VERSION[]` in `firmware/JEXFYZ.ino`.
- The workflow no longer uses `releases/`.
- The manifest URL is generated as:
  `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-Vx.x.bin`.
- Legacy `JEXFYZ.cpp.bin` and older root `JEXFYZ-V*.bin` files are removed during a successful publish.

### Verification / pending state
- The updated workflow was committed and verified on `main`.
- The trigger-file setup started Firmware Build Run #9; at note update time it was still in progress.
- Previous Run #8 compiled V3.2 successfully but could not publish because `FIRMWARE_REPO_TOKEN` was unavailable. This secret is still required for Actions to push into the separate public repository.
