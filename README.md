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

## Current release and source validation boundary — 2026-10-19

- Latest successful released artifact is Build #99 / [Actions run 39230380636](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39230380636), packaged from source bc1498d5b3db7621ee18f5ca6f021e6013c73b09. All 21 workflow steps passed; analyzer exited 0 with 25 info-level findings/no errors or warnings; 102/102 Flutter tests passed; APK signature/certificate, matching source ZIP, asset integrity and Release/tag/source equality passed. Native JUnit tasks were NO-SOURCE.
- APK asset 655835412 SHA-256 06a3e4edc7ff911c66cda8b152d4f2acbc11f41b2ccd2f009aa966510aa89096; source ZIP asset 655835414 SHA-256 490ef913574a38fd47644422aa52b11f09c2d47895ba4f3e21db466e47aa8229.
- Build #99 includes the animation-smoothness implementation: periodic particle paths/fades, 26 dp Home glyphs, decoupled Peltier crystal motion and accumulated-phase Fan retarget. Current static/unknown-state redraw is after Build #99: lib/main.dart 6a008c5c3e5ba7118e948e0b1f36277c01e73529; test/widget_test.dart 94dad7a7506fbcbeea63f300ea25b7f32299d471. NOT RUN / NOT RELEASED until validated by a separately authorized Build App flow.
- Static redraw gives Battery a semantic low-intensity thermal emblem instead of fabricated fill when unknown; Hotside a recessed tube/graduations/bulb bezel; Voltage an inset bolt; Adaptive stronger dual arrows; Peltier a faceted six-branch crystal without frozen flakes when inactive; Fan a bearing ring and three blade highlights; Speedometer an 11-tick bezel while keeping needle hidden for unknown PWM.
- Physical-phone visuals, profile-mode frame time, live BLE/PWM, cooling/safety and device operation remain UNVERIFIED. No Build App, Firmware/BIN, Firebase, OTA, flash or device operation occurred during this source execution.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. The live recursive tree currently has exactly one entry, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was checked; do not read the payload or add README, note, source, or memory files there. Source-to-BIN provenance remains UNVERIFIED.
- The active editable Firmware source is `firmware/JEXFYZ-V6.7.ino` (`FW_VERSION="V6.7"`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`). The user reports successful compilation and online update; this is USER-REPORTED and not independently verified. Source-to-BIN provenance remains UNVERIFIED.
- V6.6 compile/two-same-version OTA statements are historical user reports. V6.7 has a separate user-reported compile/online-update success; no independent compile log, BIN identity, OTA evidence or current device version was inspected.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #99 / run 39230380636 is the latest successful artifact, built from source bc1498d5b3db7621ee18f5ca6f021e6013c73b09; its 102/102 Flutter tests and guarded release/tag gates passed. The static/unknown-state icon redraw is newer than Build #99 and remains NOT RUN / NOT RELEASED. Do not start a build from Eksekusi Full; only the separate @Thinking Eksekusi Build App! authorizes the full validation/build/release workflow.
- Next verification step, after a separately authorized `@Thinking Eksekusi Build App!`, is to run the repaired workflow through its guarded issue trigger, confirm all required gates pass, and verify the Git tag, Release metadata, APK and source ZIP all reference the same source commit. Then verify indicator rendering and BLE/Fan telemetry on a real phone. Build #83 already contains the current painter source; physical validation remains pending.
- App CI does not prove Firmware compilation, source-to-BIN provenance, Firebase, OTA, flash, BLE hardware, thermal/electrical safety or installed device version.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
