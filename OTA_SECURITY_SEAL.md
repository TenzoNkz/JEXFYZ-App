# JE X FYZ — OTA SECURITY SEAL

## Status

**SEALED / V5.7 OTA BASELINE**

This seal protects the OTA path that was successfully used to update the physical device to V5.7. It is an engineering integrity guard against accidental OTA drift. It is **not** a cryptographic signature or a replacement for physical OTA testing.

## Frozen policy

- Anti-downgrade is **OFF**.
- Any valid firmware version different from the device version may be installed.
- The App continues to use the exact raw GitHub BIN URL:
  \`https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin\`.
- OTA remains single-radio: Wi-Fi owns the radio only after BLE/GATT shutdown and Wi-Fi-off settlement.
- OTA safe outputs and the existing Local/Online OTA state machines remain protected.
- No executable \`delay()\` or timing \`while\` may be introduced.

## What the CI seal checks

The workflow \`.github/workflows/ota-security-seal.yml\` runs on normal push/PR validation and never publishes an APK. It verifies the locked Git-blob fingerprints of the critical Firmware OTA runtime, OTA priority path, BLE radio handoff, App version policy, and Firebase OTA metadata validation.

It also checks the fixed OTA anchors, the single active versioned firmware source, filename/version alignment, the ESP32 OTA magic byte check, the 60-second Local OTA hard limit, the bounded Online OTA settings, and the removal of the retired \`RAPID_HOTSIDE_RISE\` identifier.

## Intentional OTA-seal changes

A deliberate OTA modification must include **[OTA-SEAL-RENEW]** in the current PR title/body or pushed commit message, and the seal manifest/lock must be updated so the new source still passes all protected checks.

An OTA change without that explicit marker is rejected by CI. A marker by itself is not enough: stale fingerprints still fail.

## Validation boundary

The seal proves repository integrity against accidental drift. It does **not** prove that a new firmware image compiles, that a BIN was generated, that OTA succeeded on hardware, or that runtime hardware behavior is correct. Those remain separate QC gates.
