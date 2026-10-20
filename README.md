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

## Current release and source validation boundary — 2026-10-20

- Latest successful release is Build #110 / https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39300262741, packaged source `b5adcffb2c9724a07cdba4cd8521c1307f1e6566`. The release/tag and assets were verified against that source commit. APK asset ID `657047529`, SHA-256 `258211ec9313c555aaac6cd797d1bf6abc6c62c3c2781cd37baa0a8c849bfb84`; source ZIP asset ID `657047524`, SHA-256 `13d1cad6cf4fbb9b2560da7406f4c6bf875fe4ebc2ed5483e6f0001a3b24aa23`.
- Source changes newer than Build #110 are not yet validated or released: falling fire embers in Battery/Hotside, taller Hotside inner tube, clipped Voltage inner core, compact dynamic-height NOTIFY (44 dp minimum, expands for two-line copy), and removal of the About section/page from Settings. Firmware V6.9 now paces Adaptive PWM down 10 points per 10 seconds and up 10 points per 1 second, resetting timers through voltage/thermal transitions. Those changes have NOT RUN / NOT RELEASED and V6.9 is NOT COMPILED / NOT INSTALLED.
- Current blobs: `lib/main.dart` `08592a9d861a11ecdb8de1aa289f8ce06bf2e20`; `lib/app_settings.dart` `f8e465648946a25eae44f3fad6a5a3bfaca8b050`; `lib/floating_monitor.dart` `e7c74bf749698a8331f2b0b31a847b2627ac3e4b`; `test/widget_test.dart` `10de861b593c7b4955deaa160ab1d0c3be519f58`; `test/firmware_qc_contract_test.dart` `1b35feeb1e411efec44261ec130eec4535004454`; `test/firmware_touch_adaptive_sync_test.dart` `3a86dd118cd1d1332dbafa3883ab9e5ae2823ac8`.
- Source-level audits do not establish real-device layout/animation behavior, physical PWM response, root cause of hardware resets, or source-to-BIN identity. No Firmware compile, BIN generation/publication, Firebase change, OTA, flashing or device operation was performed.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. The live recursive tree currently has exactly one entry, blob `9fdd915c3d298cad4de720765dab7fb03f47024d`, 1,456,368 bytes. Only tree metadata was checked; do not read the payload or add README, note, source, or memory files there. Source-to-BIN provenance remains UNVERIFIED.
- The active editable Firmware source is `firmware/JEXFYZ-V6.9.ino` (`FW_VERSION="V6.9"`, blob `8e0f0ff5a65962ebdb44300b05fc161cf9349d96`). It retains Hotside-limit temperature tiers and adds 10-second downsteps/1-second upsteps with transition grace. V6.9 is source-only, not compiled/installed; source-to-BIN provenance remains UNVERIFIED.
- V6.6/V6.7 compile/OTA reports are historical user reports. V6.7 compilation and online update were user-reported, but no independent compile log, BIN identity, OTA evidence or current device version was inspected.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #110 / run 39300262741 is the latest successful App artifact, built from source `51f401c90085b0bef5599375f7819d0294375938`; its 107 Flutter tests and release/signing/source-archive checks passed. Build #110 includes the Home geometry restoration (44 dp metric rows and 56 dp badge-free NOTIFY Row); newer falling-fire, icon-geometry, Settings About removal and Firmware V6.9 ramp edits remain NOT RUN / NOT RELEASED. Do not start App Build from Eksekusi Full; only `@Thinking Eksekusi Build App!` authorizes the full App validation/build/release workflow.
- Next App verification step, after a separately authorized `@Thinking Eksekusi Build App!`, is to run the repaired workflow through its guarded issue trigger, confirm all required gates pass, and verify the Git tag, Release metadata, APK and source ZIP all reference the same source commit. Build #110 is the latest released App source; the current fire/geometry/Settings follow-up is unvalidated. Firmware V6.9 uses paced Adaptive Fan tiers but has not been compiled or installed. Physical UI, BLE/Fan telemetry, and firmware behavior remain unverified.
- App CI does not prove Firmware compilation, source-to-BIN provenance, Firebase, OTA, flash, BLE hardware, thermal/electrical safety or installed device version.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
