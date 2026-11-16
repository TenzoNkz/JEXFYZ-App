# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-16 23:16:44 (Asia/Jakarta).

## Current state — BUILD #165 ACTIVE / BLUETOOTH FIX BEING PACKAGED

- Root cause: the Connection sheet deliberately replaced the real BLE local name `JE X FYZ` with localized generic `Perangkat`. Firmware V7.2 source already contains `BLE_NAME = "JE X FYZ"` and `BLEDevice::init(BLE_NAME)`.
- App fix: Connection row now prefers current advertisement name, falls back to platform name, and uses `Device` / `Perangkat` only when both are empty. No Firmware, BLE UUID, P1 framing, scanner ownership or connection logic changed.
- Regression coverage: four pure name-mapping cases plus Connection/Firmware source-contract test.
- Validation Only #44 / run `43899329198` / job `133411358928` — **SUCCESS** on input `4a875b3d63beea6e7d469c27f0c8930ab9b7cd09`: formatter final PASS, analyzer 107 infos / 0 warnings/errors, Flutter **205/205 PASS**; format-only commit `0a2b3c03af433a17d82afa1d4db60beb7b1bd023`.
- Latest published APK remains Build #164 / run `43863417641` / Release `403010611` / tag `jexfyz-latest`, source `a41baaf3bc53a02d72e12a4f3840f0c84c493497`. It predates the Bluetooth fix, so the fix is not yet in the published APK.

## Next action and boundaries

- Exactly one new owner-authored Issue #42 created the guarded Build #165 run `43905426531` / job `133432846684`, attempt 1, immutable source `cbe8a8df5dfac7427dafca9b372beb3c3fa81b0d`.
- Current state: runner allocated; steps 1–3 SUCCESS; step 4 Set up Flutter IN_PROGRESS; steps 5–21 pending. Continue only this run/job; no duplicate trigger or rerun.
- Verify analyzer/tests, Android Gradle, obfuscated APK, V1/V2/V3 pinned cert, source ZIP, Release/tag/source parity and downloaded APK/source ZIP identity. Stop at the first failed gate; no blind retry.
- After owner installation, verify the real cooler Bluetooth advertisement and App scan row show `JE X FYZ`. Physical BLE/OEM visual, Firmware/BIN, Firebase, OTA/flash, thermal/electrical and long-session evidence remain separate and unverified. No such operation is authorized here.