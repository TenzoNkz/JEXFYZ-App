# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-16 23:18:07 (Asia/Jakarta).

## Current state — BUILD #165 ACTIVE / BLUETOOTH FIX BEING PACKAGED

- Root cause: the Connection sheet deliberately replaced the real BLE local name `JE X FYZ` with localized generic `Perangkat`. Firmware V7.2 source already contains `BLE_NAME = "JE X FYZ"` and `BLEDevice::init(BLE_NAME)`.
- App fix: Connection row now prefers current advertisement name, falls back to platform name, and uses `Device` / `Perangkat` only when both are empty. No Firmware, BLE UUID, P1 framing, scanner ownership or connection logic changed.
- Regression coverage: four pure name-mapping cases plus Connection/Firmware source-contract test.
- Validation Only #44 / run `43899329198` / job `133411358928` — **SUCCESS** on input `4a875b3d63beea6e7d469c27f0c8930ab9b7cd09`: formatter final PASS, analyzer 107 infos / 0 warnings/errors, Flutter **205/205 PASS**; format-only commit `0a2b3c03af433a17d82afa1d4db60beb7b1bd023`.
- Latest published APK remains Build #164 / run `43863417641` / Release `403010611` / tag `jexfyz-latest`, source `a41baaf3bc53a02d72e12a4f3840f0c84c493497`. It predates the Bluetooth fix, so the fix is not yet in the published APK.

## Current Build #165 progress

- One fresh Issue #42 produced exactly one run `43905426531` / job `133432846684`, attempt 1, immutable source `cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d`.
- Steps 1–13 SUCCESS. Step 14 Android Gradle gate IN_PROGRESS; steps 15–21 pending. Full logs are unavailable while active, so do not invent analyzer/test counts or Gradle timings.
- Continue only this run/job. At terminal, verify APK obfuscation, V1/V2/V3 pinned cert, source ZIP, Release/tag/source parity, exactly two assets and downloaded asset identity. Stop on any failed required gate.
- Bluetooth fix still needs owner installation/physical BLE verification after package delivery. No Firmware/BIN/Firebase/OTA/flash/device operation.
- After owner installation, verify the real cooler Bluetooth advertisement and App scan row show `JE X FYZ`. Physical BLE/OEM visual, Firmware/BIN, Firebase, OTA/flash, thermal/electrical and long-session evidence remain separate and unverified. No such operation is authorized here.