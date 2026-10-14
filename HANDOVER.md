# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-14 (Asia/Jakarta). Re-fetch live `main` and source hashes before acting; this handover is a guide, not proof of current repository state.

## Current state

- Active Firmware source: `firmware/JEXFYZ-V6.6.ino`; `FW_VERSION = "V6.6"`; blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`.
- **User acceptance:** user considers Firmware V6.6 final/correct and reports successful compile plus two successful Online OTA flashes/updates using the same version V6.6. Do not modify/recompile/reflash unless the user explicitly reopens Firmware work and separately authorizes it. Artifact source/BIN provenance remains unverified separately.
- Active App source: `lib/main.dart`, blob `2005f4c163d466f9015a564d5418af1e86e09b41`; package `com.horizontalzzz.jexfyz`; pubspec `1.0.0+3`; preserve Gradle `versionName "Telegram @horizontalzzz"`.
- Latest successful Build App before signing-workflow fix: run `38556896542` on commit `67c5d26723c433b4af856c7759a967a3425bf67a` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38556896542). Dart analyze and Flutter tests passed for the current App source, and the release asset passed V2/V3 verification and downloaded-asset digest check. APK SHA-256 `95e8c9460b69b8c58d183c2bb80102590cf6208c9a48008ba4dc3bf74e5fbd38`.
- **Signature issue:** the successful run logged V1=false, V2=true, V3=true. Workflow commit `90d48ec3c97318b5aff4e147151eee96e41b5b25` now signs/verifies using API 23 for V1 compatibility and requires V1/V2/V3=true. This fix is not yet built or verified on device. The screenshot's installed app metadata says last updated 17:11, earlier than latest release completion at 18:36 Asia/Jakarta.
- No open PRs were found at last live check. Work directly on `main` by default. Artifact repo `TenzoNkz/JEXFYZ-Firmware` must contain only `JEXFYZ.cpp.bin`.
- Preserve existing App design and protocol requirements: 1 Hz Android battery-temperature heartbeat, five-second Firmware freshness TTL, no standalone Battery Protection Guard UI, and one-App/one-cooler exclusive pairing as an unverified design intent.
## First steps in the next session

1. Read `CHAT_TRANSFER.md` in full and then `MEMORY_INDEX.md`, `CHAT_RULES.md`, `PROJECT_STATE.md`.
2. Fetch current main HEAD/tree, current source blobs, tests, workflow, open PR state and artifact repo root. Do not quote the hashes above as current without rechecking.
3. Read the relevant canonical memory before changing code: `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md` for OTA; `VOLTAGE_TRANSITION_MEMORY.md` for rail/Peltier timing; `APP_NOTES.md` for App behavior; `FIRMWARE_NOTES.md` + `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` for firmware; `BUILD_NOTES.md` for build.
4. Respect the command protocol and authorization boundaries from `CHAT_RULES.md`.
5. Preserve these battery UI and pairing requirements in `APP_NOTES.md`; do not ask the user to repeat them. If exclusive pairing-lock work is requested, audit the exact BLE security/provisioning code first and report implementation versus intent.

## Exact next QC actions (only when authorized)

1. Only after explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`, run the manual App Build workflow. Require `apksigner` V1/V2/V3 all true for both build output and the re-downloaded asset; verify the official certificate SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0` and release digest.
2. Install that APK and recheck MT Manager's signature display; exact cause of the prior failure remains unverified.
3. Check on device: (a) Fan remains full colour and eases to a resting pose after OFF, (b) Peltier is a visible six-arm crystal without the square module/bolts and does not fade when OFF, (c) Speed needle gently wobbles only while ON and eases to far-left/0 after OFF while the percentage text stays stable during ON.
4. Verify notification JE icon/tap and the already-enlarged Color Picker/Peltier Safety dialogs.
5. Flutter tests/analyze for the latest source/test edits have not run yet. The full suite passed in run `38556896542` only on pre-change commit `67c5d26723c433b4af856c7759a967a3425bf67a`.
6. Firmware V6.6 is user-accepted as final after two reported successful same-version Online OTA updates. Do not modify/recompile/reflash unless the user explicitly reopens Firmware work and separately authorizes the operation.

## Known uncertainty

- MT Manager's exact reason for `Signature: Verified failed` is not independently identified. Live workflow logs show V1=false, V2/V3=true on the latest release; the updated workflow now requires V1 and has not yet been run.
- Screenshot app metadata last-update time is 17:11 local, while latest release build completed at 18:36 local. The installed APK shown is older than the release build; a new build plus install is needed to validate the signature change end-to-end.
- V6.6 compile/Online OTA success twice is user-reported and accepted as final by the user. It does not alone establish the hosted BIN's source provenance. Do not run another Firmware operation unless separately asked.
- The known historical request for rapid Hotside-rise shutdown/manual re-arm remains absent from the V6.6 source contract; do not implement proactively after user acceptance. The previous restart/Adaptive-OFF LED symptoms remain historical observations unless the user reopens them.
## Reference routing

Use `MEMORY_INDEX.md` to find canonical notes. Use `CHANGELOG.md` for history only. Never copy old V5.x/V6.1/V6.2 status blocks forward as current truth. The complete cross-chat startup and memory-reconciliation procedure is in `CHAT_TRANSFER_PROMPTS.md`.

 
## Latest UI and signature change-set boundary (2026-10-14)

- Latest App UI source blob: `3d756a5a38c76b252dc93c6151a3b864ebbbbb94`; widget regression tests blob: `99648e4c145b122949099b74581d47e6c472d9b9`.
- Fan OFF now uses ease-out coast-down over a short period-dependent travel and retains the resting pose; the blades and hub remain fully coloured. Peltier now renders a free-standing six-branch crystal only—no square module frame, inner box or corner bolts—and freezes at OFF with no fade. Fan Speed's gauge needle has a small organic wobble while ON; telemetry percentage remains stable, and OFF eases the needle to far-left/0 over 520 ms.
- Regression tests were updated for these contracts, but **have not been run after the edits**. Last successful Flutter analyze/test run remains pre-change Build App run `38556896542`.
- Separately, signing workflow fix blob `0e400cbdedfd54506ae3ac3255da41580c86d750` now requires V1/V2/V3 and has not yet been build-verified. No App Build was run in this execution.
- No Firmware source/compile/BIN/Firebase/OTA/flash operation was performed.

