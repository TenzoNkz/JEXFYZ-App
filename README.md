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
13. `archive/` contains immutable, verbatim legacy snapshots for forensic recovery only. Any old `CURRENT` status inside an archive is not live truth. Some root-relative links retained from the original documents do not resolve when the snapshot is viewed inside `archive/`; this is intentional to preserve the snapshots byte-for-byte. Use the canonical root-level files linked above for navigation.

## Current source validation boundary — 2026-10-16

- Latest verified release is [Build #66](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38859288444), exact source `a2b19d4708f3075730132ac16f375f2a352aa50a`. It passed audit, dependencies, Dart analysis, **88/88 Flutter tests**, native FPS parser JUnit tests, obfuscated Android release build, V1/V2/V3 signing, publication and re-downloaded asset verification. It includes the 35-second Shizuku bind timeout and 50.4-second Settings polling fix.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) has one APK (asset `646344237`, `54,636,716` bytes; SHA-256 `cae0364670324511551742295a40fc4208399a5de4330b5a18d5d43ca5d488cf`) and one matching source ZIP (asset `646344244`, `2,874,306` bytes; SHA-256 `9a3a008e377fa6bdcc7d4add2fecbce9167df88b2b0ce924512ca703e5eeac69`). Both were re-downloaded and verified against the exact Build #66 source marker.
- Build #63 / run `38850417086` failed one stale widget assertion (87 passed, 1 failed). Build #64 / run `38850654562` passed Flutter tests but the native JUnit gate hit `Java heap space` using the former 2 GiB Gradle heap. The widget assertion and heap configuration were repaired; Build #65 passed the native gate and Build #66 passed all release gates without removing tests or weakening gates.
- **Current release / CI-tested:** Build #66 includes source fix `34880ba490bfbd0d38c4b10ab69a683ca7b4a29d`, which raises the UserService client bind timeout to 35s (matching Shizuku's 30s service-start window plus callback grace) and Settings status polling to 50.4s. The target phone's actual service binding and FPS remain **NOT DEVICE-VERIFIED**.
- Gradle heap is now `-Xmx4096M`. The release includes bounded 500 ms TimeStats sampling and the native parser/JUnit gate; **physical Shizuku binding, OEM TimeStats visibility, actual foreground FPS and overlay rendering remain NOT DEVICE-VERIFIED**. No Firmware/BIN, Firebase, OTA, BLE hardware-control or thermal-safety code was changed.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. Do not add README, note, source, or memory files there.
- The active editable firmware source is `firmware/JEXFYZ-V6.6.ino`. Its embedded `FW_VERSION`, filename and the single active versioned `.ino` must always match.
- The user considers Firmware V6.6 correct/final and reports successful compilation plus two successful Online OTA updates with the same V6.6 version. Do not modify/recompile/reflash it unless the user reopens Firmware work and separately authorizes the operation. Source-to-BIN provenance remains independently unverified; do not infer it from the user report.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #66 verified current App source through audit, dependencies, Dart analysis, **88/88 Flutter tests**, native parser JUnit, obfuscated APK compilation, production V1/V2/V3 signing, certificate checks, matching source archive, publication and re-downloaded asset verification. Full details appear above and in `APP_BUILD_REPORT.md`.
- Physical verification is still required for Shizuku UserService binding/lifecycle on the target phone, OEM SurfaceFlinger layer visibility, foreground FPS, and overlay/icon rendering. The current-main timeout repair `34880ba490bfbd0d38c4b10ab69a683ca7b4a29d` must first pass the authorized Build App workflow; the release pipeline cannot verify device behavior.
- Firmware V6.6 is USER-ACCEPTED FINAL according to the user's report. Its compile log and source-to-BIN provenance remain unverified independently. App CI does not imply Firmware compile, BIN provenance, Firebase, OTA, flash, BLE hardware or thermal-safety validation.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
