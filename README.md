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

- **Canonical App repo:** `TenzoNkz/JEXFYZ-App`, branch `main`. Current source includes the Color Picker staged Select/Cancel flow, Floating Monitor foreground SurfaceFlinger FPS/telemetry replay, notification-driven Wireless ADB pairing, and the latest seven Home-icon animations with CONNECTED/DISCONNECTED Notify labels. Preserve Gradle `versionName "Telegram @horizontalzzz"`.
- **Latest completed build:** [Build #39 / run `38705765370`](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38705765370) passed audit, dependency installation, Dart analysis and all 80 Flutter tests on its own commit `b9102695de25f61f0b985cab4cd384b4cda12534`, but APK assembly failed because Gradle could not find `com.github.Flyfish233:spake2-java:1.0.5`. No APK was published by #39; the latest released APK remains the older Build #36 and does not include all current source changes.
- **Source repair:** `android/build.gradle` adds a JitPack Maven repository filtered to the exact module `com.github.Flyfish233:spake2-java`. The repair has not yet passed a new Gradle resolution/build run.
- **Build/release source and license path:** the current workflow is being extended to include a full GPL-3.0 notice asset in the APK and a `JEXFYZ-corresponding-source.zip` with the exact App source commit plus upstream Kadb 1.3.0 and SPAKE2-Java 1.0.5 sources and licenses. The private Release will contain exactly one APK plus one corresponding-source ZIP, and both downloaded SHA-256 values will be compared against the generated files. See [Third-party notices](third_party/THIRD_PARTY_NOTICES.md).
- **Physical behavior remains separate from CI:** FPS accuracy and the development-only `android.permission.DUMP` grant, native Wireless ADB pairing, UI/overlay rendering on a phone, BLE/cooling, Firmware compilation, and physical OTA/flash are not proven by CI. Firmware V6.6 is outside this App build and remains unchanged.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking #Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `#Diskusi!` in the same command. Use `@Thinking #Eksekusi Full!` for approved full execution, `@Thinking #Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired `#Eksekusi!` and `#Eksekusi & Build App!` commands are not valid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
