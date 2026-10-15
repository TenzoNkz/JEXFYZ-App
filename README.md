# JE X FYZ / JE Cooler App

Flutter Android companion app for the JE X FYZ thermoelectric cooler, paired with the ESP32-C3 firmware.

## Start here

1. [Memory Index](MEMORY_INDEX.md) — authoritative map of all project knowledge and where to write new decisions.
2. [Chat Rules](CHAT_RULES.md) — commands, authorization boundaries, source/version rules, and memory protocol.
3. [Current Project State](PROJECT_STATE.md) — live development status only; check GitHub before relying on it.
4. [Chat Transfer Snapshot](CHAT_TRANSFER.md) — boot protocol and last-reconciled handover. Always refresh it against live `main`.
5. [App Reference](APP_NOTES.md) — UI, controls, BLE, telemetry, and localization contracts.
6. [Firmware Reference](FIRMWARE_NOTES.md) and [Firmware Technical Reference](firmware/FIRMWARE_TECHNICAL_REFERENCE.md) — hardware, control, sensor, safety, and implementation contracts.
7. [OTA Protection](OTA_PROTECTION.md), [OTA Regression Memory](OTA_REGRESSION_MEMORY.md), and [Voltage Transition Memory](VOLTAGE_TRANSITION_MEMORY.md) — protected code paths and known regressions.
8. [Build and Release](BUILD_NOTES.md) — explicit APK build procedure and validation boundaries.
9. [App Build Report](APP_BUILD_REPORT.md) — attempts, fixes, test/signing evidence and final build status; the next Build App chat loads it through Prompt D.
10. [Changelog](CHANGELOG.md) — historical changes; history never overrides current code.
11. [Design Notes](DESIGN_NOTES.md) — approved grille, icon, and brand design constraints.
12. [Transfer Prompt Templates](CHAT_TRANSFER_PROMPTS.md) — copy-ready prompts for saving context and starting a new chat.
13. `archive/` contains verbatim legacy snapshots for forensic recovery only. Any old `CURRENT` status inside an archive is not live truth.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. Do not add README, note, source, or memory files there.
- The active editable firmware source is `firmware/JEXFYZ-V6.6.ino`. Its embedded `FW_VERSION`, filename and the single active versioned `.ino` must always match.
- The user considers Firmware V6.6 correct/final and reports successful compilation plus two successful Online OTA updates with the same V6.6 version. Do not modify/recompile/reflash it unless the user reopens Firmware work and separately authorizes the operation. Source-to-BIN provenance remains independently unverified; do not infer it from the user report.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Current validation boundary

- Current App/UI source hashes: `lib/main.dart` `c697497e16c94b8fe4fe8fd9bd1f9bc93598545f`; `lib/floating_monitor.dart` `af7bad48579f6c998761120e4f8233564fa06e6f`; `lib/app_settings.dart` `6483031e239d71e0a0784c529e2f45a94fb5404b`; `test/widget_test.dart` `2a87292d5c4bc468ee6aad6810b249d284a28bae`; native `FloatingMonitorService.kt` `90e2f10f91fc60c64843e14f556b720fbc9f7030`.
- **New source changes NOT BUILT / tests NOT RUN:** Color Picker draft + Select/Cancel flow; Floating Monitor center preview removal and explicit orientation selector; native SurfaceFlinger FPS filtered to the Android resumed/focused package; ADB DUMP permission guide; telemetry snapshot replay after overlay startup and native layout refresh. Flutter/Dart SDKs are unavailable in this environment; no App Build was triggered.
- FPS access uses a user-run ADB `pm grant` for Android's powerful development-only `android.permission.DUMP`, not a self-grant. The UI explains scope and provides revoke command. This may be blocked by an OEM ROM; true game FPS and foreground layer detection remain physically UNVERIFIED until a Build App and device test.
- Fan Speed retargets to the newest telemetry target over 420 ms, including mid-transition changes, and returns to zero over 520 ms when Fan turns OFF. Symmetric cubic smoothstep has an exact midpoint; needle wobble wraps seamlessly. Fan coast-down/full-colour blades and the box-free full-colour Peltier crystal OFF pose remain. Voltage sheen and Bluetooth ripple opacity transition continuously at loop boundaries.
- **Latest verified App Build:** [Build #35 / run `38669526891`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38669526891), code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`. Security/architecture audit, dependency install, Dart analyze, **74 Flutter tests**, APK build, V1/V2/V3 signing, GitHub Release publication and re-downloaded asset verification passed.
- Release `jexfyz-latest` has exactly one `JEXFYZ-release.apk` (54,521,947 bytes). SHA-256: `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`. Expected production certificate SHA-256 matched. JAR/V1 diagnostics still warn that dependency `META-INF` entries are not protected by that scheme; this is recorded separately from successful V1/V2/V3 verification.
- **Not proven by CI:** physical install/rendering, MT Manager's signature interpretation, BLE with the cooler, cooling/safety behavior and physical OTA. Firmware V6.6 compile/Online OTA success is user-reported; source-to-BIN provenance remains unverified. No new Firmware operation is authorized by this docs checkpoint.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking #Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `#Diskusi!` in the same command. Use `@Thinking #Eksekusi Full!` for approved full execution, `@Thinking #Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired `#Eksekusi!` and `#Eksekusi & Build App!` commands are not valid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
