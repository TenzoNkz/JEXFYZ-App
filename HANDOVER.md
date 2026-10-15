# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-15 (Asia/Jakarta). Re-fetch live `main` and source hashes before acting; this handover is a guide, not proof of current repository state.

## Current state

- Active Firmware source: `firmware/JEXFYZ-V6.6.ino`; `FW_VERSION = "V6.6"`; blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`.
- **User acceptance:** Firmware V6.6 is final/correct by user report after successful compilation and two successful Online OTA updates using the same V6.6 version. Do not reopen Firmware work without explicit request/authorization.
- Active App source: `lib/main.dart`, blob `f4ee1e9b9e74f103e0f362db813dea642f285470`; latest widget test `test/widget_test.dart`, blob `4b7bf68f3c73d6ffe80509ccb75ce6e08607b020`; package `com.horizontalzzz.jexfyz`; pubspec `1.0.0+3`; preserve Gradle `versionName "Telegram @horizontalzzz"`.
- Latest successful Build App: run `38669526891` (Build #35) on code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`; Dart analyze and all 74 Flutter tests passed, APK build/publication and downloaded-asset verification passed, and V1/V2/V3 all verified true. Release SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`. JAR/V1 logs still warn that various META-INF entries (including services/a1 and services/b1) are not protected; physical install/MT Manager validation remains open.
- Latest animation changes: smooth Fan Speed retarget from the current visual level to each new target (420 ms), symmetric cubic smoothstep interpolation with exact 0.5 midpoint, smooth OFF-to-zero (520 ms), loop-seamless wobble, sinusoidal voltage sheen and Bluetooth ripples with squared-sine fade at repeat boundaries. Existing Fan coast-down and Peltier no-box/full-colour OFF behavior retained. Build #35 passed Dart analyze and all 74 Flutter tests; device rendering has not been verified.
- No open PRs at last live check. Work directly on `main`; artifact repository `TenzoNkz/JEXFYZ-Firmware` must contain only `JEXFYZ.cpp.bin`.
- Preserve App constraints: one-second Android battery heartbeat, five-second Firmware freshness TTL, no standalone Battery Protection Guard UI, and one-App/one-cooler exclusive pairing as an unverified design intent.

## First steps in the next session

1. Read `CHAT_TRANSFER.md` in full and then `MEMORY_INDEX.md`, `CHAT_RULES.md`, `PROJECT_STATE.md`.
2. Fetch current main HEAD/tree, current source blobs, tests, workflow, open PR state and artifact repo root. Do not quote the hashes above as current without rechecking.
3. Read the relevant canonical memory before changing code: `OTA_PROTECTION.md` + `OTA_REGRESSION_MEMORY.md` for OTA; `VOLTAGE_TRANSITION_MEMORY.md` for rail/Peltier timing; `APP_NOTES.md` for App behavior; `FIRMWARE_NOTES.md` + `firmware/FIRMWARE_TECHNICAL_REFERENCE.md` for firmware; `BUILD_NOTES.md` for build.
4. Respect the command protocol and authorization boundaries from `CHAT_RULES.md`.
5. Preserve these battery UI and pairing requirements in `APP_NOTES.md`; do not ask the user to repeat them. If exclusive pairing-lock work is requested, audit the exact BLE security/provisioning code first and report implementation versus intent.

## Exact next QC actions (only when authorized)

1. Latest authorized Build #35 is complete; next validation is device-side install/rendering and signature display. Only trigger another App Build after an explicit new `@Thinking Build App!` or `@Thinking Eksekusi & Build App!` command.
2. Install the new APK and inspect the signature in MT Manager. Previous CI verified V1/V2/V3 but warned `META-INF/services/b1` is not protected by JAR/V1; earlier MT Manager result is still unverified.
3. Check Fan coast-down/full colour; Peltier box-free/no-fade OFF; Fan Speed interpolation through several target changes including a second change mid-transition; ON wobble seam; OFF smoothly to 0; and voltage/Bluetooth loop boundaries.
4. Flutter tests/analyze and device rendering after source blob `a1818d281fdbea900bf9cde5b83c40d09d61dcc3` and test blob `4b7bf68f3c73d6ffe80509ccb75ce6e08607b020` have not been run yet.
5. Firmware V6.6 is accepted as final by the user. Do not modify/recompile/reflash unless the user explicitly reopens Firmware work.

## Known uncertainty

- MT Manager's exact reason for `Signature: Verified failed` is not independently identified. Live workflow logs show V1=false, V2/V3=true on the latest release; the updated workflow now requires V1 and has not yet been run.
- Screenshot app metadata last-update time is 17:11 local, while latest release build completed at 18:36 local. The installed APK shown is older than the release build; a new build plus install is needed to validate the signature change end-to-end.
- V6.6 compile/Online OTA success twice is user-reported and accepted as final by the user. It does not alone establish the hosted BIN's source provenance. Do not run another Firmware operation unless separately asked.
- The known historical request for rapid Hotside-rise shutdown/manual re-arm remains absent from the V6.6 source contract; do not implement proactively after user acceptance. The previous restart/Adaptive-OFF LED symptoms remain historical observations unless the user reopens them.
## Reference routing

Use `MEMORY_INDEX.md` to find canonical notes. Use `CHANGELOG.md` for history only. Never copy old V5.x/V6.1/V6.2 status blocks forward as current truth. The complete cross-chat startup and memory-reconciliation procedure is in `CHAT_TRANSFER_PROMPTS.md`.

 
## Latest UI and signature change-set boundary (2026-10-15)

- Current App source blob: `f4ee1e9b9e74f103e0f362db813dea642f285470`; widget regression test blob: `4b7bf68f3c73d6ffe80509ccb75ce6e08607b020`.
- Fan OFF coast-down, Peltier crystal/no box and Speed OFF→0 remain in place. Fan Speed visual value now has its own retargetable controller: new values interpolate from the current displayed level over 420 ms, including when another value arrives mid-transition. OFF targets 0 over 520 ms; its ON needle wobble uses integer harmonics for a seamless loop.
- Voltage sheen now sweeps back-and-forth sinusoidally; Bluetooth ring opacity uses a squared-sine envelope that fades to zero with zero slope at loop boundaries. Those changes target visible repeat-loop resets.
- Added deterministic regression tests for value interpolation/easing, wobble endpoint continuity and voltage/Bluetooth loop contracts, and updated the prior Speed source-contract test. Static checks passed, but Flutter tests/analyze and device rendering have NOT run for these changes.
- Latest successful Build App is run `38669526891` / Build #35 on code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`. All 74 Flutter tests/analyze passed; built and re-downloaded APK passed V1/V2/V3 and matched release SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`. JAR/V1 warnings for META-INF entries remain; MT Manager's on-device label still needs checking.
- App Build #35 was completed. No Firmware compile, BIN replacement, Firebase update, OTA/flash or physical hardware operation was performed.

