# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.5
- Active source: firmware/JEXFYZ-V4.5.ino
- Firmware blob: daef871d910f3f1bc4f2d1bdc44e0d19f6e292dc
- App: 1.0.0+3
- App main blob: 8ebd878b116d7ef093b6df54894a7db876eb0f02
- Latest verified App Build: #50 (older App source)
- V4.4 OTA: user-confirmed PASS.
- V4.5 source/static audit: PASS.

## CURRENT OBJECTIVE
Physically validate the V4.5 firmware and the synchronized App OTA recovery contract.

Expected Online OTA:
Update Firmware → active GATT disconnect → live App telemetry stops → Online OTA continues → restart → BLE reconnect → P1 sync → OTA result is shown.

## FROZEN
- Local OTA Golden Path
- BLE UUID/P1 contract
- App package identity
- Manual App Build workflow
- V3.2-style Online OTA transport/retry/result-indicator path
- Cooperative timing rules
- Firmware version/file alignment

## VALIDATION
- V4.4 physical OTA was confirmed successful before V4.5 promotion.
- V4.5 compile/BIN/flash/physical OTA remains pending.
- Current App source is not validated by Build #50.

## BUILD
- App Build remains explicit and manual.
- No App Build was triggered by this execution.
