# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-14 (Asia/Jakarta). Re-fetch live `main` and source hashes before acting; this handover is a guide, not proof of current repository state.

## Current state

- Active Firmware source: `firmware/JEXFYZ-V6.6.ino`; `FW_VERSION = "V6.6"`; blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`.
- **User acceptance:** the user considers Firmware V6.6 final/correct and reports successful compile plus two successful Online OTA updates using the same V6.6 version. Do not reopen Firmware work without explicit request/authorization.
- Active App source: `lib/main.dart`, blob `3d756a5a38c76b252dc93c6151a3b864ebbbbb94`; latest widget test `test/widget_test.dart`, blob `99648e4c145b122949099b74581d47e6c472d9b9`; package `com.horizontalzzz.jexfyz`; pubspec `1.0.0+3`; preserve Gradle `versionName "Telegram @horizontalzzz"`.
- Latest successful Build App run: `38560939271` on pre-icon-change commit `2aa77113950ac462bd27fa6f1ca416371eaa7ad8` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38560939271). Tests/analyze passed for that earlier source; V1/V2/V3 were verified true for built APK and downloaded asset using minSdk 23 verification. Release digest is `95e8c9460b69b8c58d183c2bb80102590cf6208c9a48008ba4dc3bf74e5fbd38`.
- **Latest UI changes not yet built/tested:** Fan OFF eases to a full-colour resting pose; Peltier is a free-standing crystal without the box/bolts and stays visible/frozen when OFF; Fan Speed needle wobbles subtly while ON and eases to zero over 520 ms when OFF. Static source consistency checks passed, but Flutter test/analyze and device rendering were not run after these changes.
- **Signature note:** run `38560939271` logs V1/V2/V3=true, but also warns `META-INF/services/b1` is not protected by the JAR/V1 signature. The MT Manager label from the earlier screenshot has not been independently rechecked on the latest release.
- No open PRs at the last live check. Work directly on `main`; artifact repo `TenzoNkz/JEXFYZ-Firmware` must contain only `JEXFYZ.cpp.bin`.
- Preserve app constraints: one-second Android battery heartbeat, five-second Firmware freshness TTL, no standalone Battery Protection Guard UI, and one-App/one-cooler exclusive pairing as an unverified design intent.

## First steps in the next session

1. Read `CHAT_TRANSFER.md` in full and then `MEMORY_INDEX.md`, `CHAT_RULES.md`, `PROJECT_STATE.md`.
2. Fetch current main HEAD/tree, current source blobs, tests, workflow, open PR state and artifact repo root. Do not quote the hashes above as current without rechecking.
3. Read the relevant canonical memory before changing code: `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md` for OTA; `VOLTAGE_TRANSITION_MEMORY.md` for rail/Peltier timing; `APP_NOTES.md` for App behavior; `FIRMWARE_NOTES.md` + `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` for firmware; `BUILD_NOTES.md` for build.
4. Respect the command protocol and authorization boundaries from `CHAT_RULES.md`.
5. Preserve these battery UI and pairing requirements in `APP_NOTES.md`; do not ask the user to repeat them. If exclusive pairing-lock work is requested, audit the exact BLE security/provisioning code first and report implementation versus intent.

## Exact next QC actions (only when authorized)

1. Only after explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`, build the current UI/test source and record real analyze/test outcomes plus V1/V2/V3 verification and the new release asset SHA.
2. Install that APK and recheck MT Manager. Run `38560939271` verified all three schemes but logs warn `META-INF/services/b1` is not protected by JAR/V1; the exact reason for the earlier UI label remains unverified.
3. Device-check the full-colour Fan coast-down; box-free, non-fading Peltier crystal at OFF; Speed needle wobble while ON and smooth far-left/0 return OFF; notification icon and dialog sizing.
4. Flutter tests/analyze for source/test changes after commit `2aa77113950ac462bd27fa6f1ca416371eaa7ad8` have not run yet.
5. Firmware V6.6 is accepted as final by the user after two same-version Online OTA updates. Don't modify/recompile/reflash without an explicit reopened request.

## Known uncertainty

- MT Manager's exact reason for `Signature: Verified failed` is not independently identified. Live workflow logs show V1=false, V2/V3=true on the latest release; the updated workflow now requires V1 and has not yet been run.
- Screenshot app metadata last-update time is 17:11 local, while latest release build completed at 18:36 local. The installed APK shown is older than the release build; a new build plus install is needed to validate the signature change end-to-end.
- V6.6 compile/Online OTA success twice is user-reported and accepted as final by the user. It does not alone establish the hosted BIN's source provenance. Do not run another Firmware operation unless separately asked.
- The known historical request for rapid Hotside-rise shutdown/manual re-arm remains absent from the V6.6 source contract; do not implement proactively after user acceptance. The previous restart/Adaptive-OFF LED symptoms remain historical observations unless the user reopens them.
## Reference routing

Use `MEMORY_INDEX.md` to find canonical notes. Use `CHANGELOG.md` for history only. Never copy old V5.x/V6.1/V6.2 status blocks forward as current truth. The complete cross-chat startup and memory-reconciliation procedure is in `CHAT_TRANSFER_PROMPTS.md`.

 
## Latest UI and signature change-set boundary (2026-10-14)

- Latest App UI source blob: `3d756a5a38c76b252dc93c6151a3b864ebbbbb94`; widget regression tests blob: `99648e4c145b122949099b74581d47e6c472d9b9`.
- Fan OFF uses ease-out coast-down over up to 0.16 turn and retains the final pose with full-colour blades/hub. Peltier renders a free-standing six-branch crystal only—no square frame, center box or corner bolts—and freezes at OFF without fading. Fan Speed needle has a small ON wobble, stable telemetry percentage and 520 ms ease to far-left/0 when OFF.
- Static source consistency checks passed. Flutter tests/analyze and device rendering have NOT run after these latest source/test edits. Latest successful run `38560939271` covers the older source commit `2aa77113950ac462bd27fa6f1ca416371eaa7ad8`, not these edits.
- That run verified V1/V2/V3=true, though its log warns `META-INF/services/b1` is not protected by JAR/V1. MT Manager's exact displayed failure remains unverified.
- No App Build was started as part of this icon/animation execution, and no Firmware source/compile/BIN/Firebase/OTA/flash operation occurred.

