# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-16 22:48:56 (Asia/Jakarta).

## Current state — BLUETOOTH NAME FIX VALIDATED / NOT RELEASED

- Root cause: the Connection sheet deliberately replaced the real BLE local name `JE X FYZ` with localized generic `Perangkat`. Firmware V7.2 source already contains `BLE_NAME = "JE X FYZ"` and `BLEDevice::init(BLE_NAME)`.
- App fix: Connection row now prefers current advertisement name, falls back to platform name, and uses `Device` / `Perangkat` only when both are empty. No Firmware, BLE UUID, P1 framing, scanner ownership or connection logic changed.
- Regression coverage: four pure name-mapping cases plus Connection/Firmware source-contract test.
- Validation Only #44 / run `43899329198` / job `133411358928` — **SUCCESS** on input `4a875b3d63beea6e7d469c27f0c8930ab9b7cd09`: formatter final PASS, analyzer 107 infos / 0 warnings/errors, Flutter **205/205 PASS**; format-only commit `0a2b3c03af433a17d82afa1d4db60beb7b1bd023`.
- Latest published APK remains Build #164 / run `43863417641` / Release `403010611` / tag `jexfyz-latest`, source `a41baaf3bc53a02d72e12a4f3840f0c84c493497`. It predates the Bluetooth fix, so the fix is not yet in the published APK.

## Next action and boundaries

- To package the fix, send a separate `Eksekusi Build App!` command. Then create one fresh owner-authored guarded issue using the exact title/token. Issue #41 has already triggered Build #164; do not reuse/reopen it.
- After installing the new APK, verify the Bluetooth scan row shows `JE X FYZ` on the real phone/cooler. Physical advertisement/display remains NOT VERIFIED until then.
- No Firmware/BIN/Firebase/OTA/flash/device or App Build/Release operation was performed in this Eksekusi Full interaction. Visual/OEM, BLE field, thermal/electrical and long-session evidence remain separate.