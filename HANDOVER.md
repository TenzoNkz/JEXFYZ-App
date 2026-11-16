# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-16 23:13:02 (Asia/Jakarta).

## Current state — BLUETOOTH NAME FIX VALIDATED / NOT RELEASED

- Root cause: the Connection sheet deliberately replaced the real BLE local name `JE X FYZ` with localized generic `Perangkat`. Firmware V7.2 source already contains `BLE_NAME = "JE X FYZ"` and `BLEDevice::init(BLE_NAME)`.
- App fix: Connection row now prefers current advertisement name, falls back to platform name, and uses `Device` / `Perangkat` only when both are empty. No Firmware, BLE UUID, P1 framing, scanner ownership or connection logic changed.
- Regression coverage: four pure name-mapping cases plus Connection/Firmware source-contract test.
- Validation Only #44 / run `43899329198` / job `133411358928` — **SUCCESS** on input `4a875b3d63beea6e7d469c27f0c8930ab9b7cd09`: formatter final PASS, analyzer 107 infos / 0 warnings/errors, Flutter **205/205 PASS**; format-only commit `0a2b3c03af433a17d82afa1d4db60beb7b1bd023`.
- Latest published APK remains Build #164 / run `43863417641` / Release `403010611` / tag `jexfyz-latest`, source `a41baaf3bc53a02d72e12a4f3840f0c84c493497`. It predates the Bluetooth fix, so the fix is not yet in the published APK.

## Next action and boundaries

- The current owner message explicitly authorizes `Eksekusi Build App!`. Pre-trigger live checks confirm Build #164 terminal SUCCESS and no queued/in-progress/waiting/requested Build App run.
- Create exactly one fresh owner-authored issue with exact title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER` and body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`. Issue #41 already triggered Build #164; do not reuse/reopen it or any older trigger issue.
- Verify exactly one resulting run; record its actual source SHA/run/job and monitor all required workflow gates, Release/tag parity and re-downloaded asset digests. Stop on any failed required gate; do not retry blindly.
- After owner installation, verify the real cooler Bluetooth advertisement and App scan row show `JE X FYZ`. Physical BLE/OEM visual, Firmware/BIN, Firebase, OTA/flash, thermal/electrical and long-session evidence remain separate and unverified. No such operation is authorized here.