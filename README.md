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

## Current release and source validation boundary — 2026-10-17

- Latest verified App release is Build #71 (run 39008259484), exact source/release commit `d9e026f70ec62455763de05048cba1557edfaf23`. It includes FPS/Shizuku retirement plus the refined dashboard-indicator motion and manual-voltage-toggle styling.
- All 21 active workflow steps passed. Dart analysis completed with 23 info-level deprecation findings; **88/88 Flutter tests passed**. Android production compilation and configured `:app:testDebugUnitTest` gate succeeded; native test tasks were NO-SOURCE, so no native JUnit cases ran.
- APK: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk; asset 649710440, 54,603,867 bytes, SHA-256 `fdffa5d61ad403153c544cd3a62ea130e810844930f9de96fdd28343f6d041ca`. Matching source ZIP: https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip; asset 649710439, 2,847,410 bytes, SHA-256 `3d7dc30fa99d3bfb86bee069e4a9b60292942f215c11c27e519f0b51ca8a24b0`. Both were re-downloaded and verified.
- Release tag `jexfyz-latest` targets `d9e026f70ec62455763de05048cba1557edfaf23`. Full run, signing, warnings, and source-marker evidence are in `APP_BUILD_REPORT.md`.
- Physical Floating Monitor layout, indicator animation smoothness, manual-voltage-toggle appearance, live BLE metrics/Fan Speed and all firmware/cooling/OTA behavior remain **NOT DEVICE-VERIFIED**. Build #71 is App CI/release evidence, not firmware compile or hardware proof.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. Do not add README, note, source, or memory files there.
- The active editable Firmware source is `firmware/JEXFYZ-V6.7.ino` (`FW_VERSION="V6.7"`, blob `1d0fa0d5e308b9789fd1c32211ce0a127d497f6a`). V6.7 is source-only/uncompiled; filename, embedded version and exactly-one-active-sketch must match.
- V6.6 compile/two-same-version OTA statements are historical user reports. The user reopened source work and authorized a V6.7 Adaptive Fan PWM change; V6.7 was not compiled, published, OTA-applied or installed. Source-to-BIN provenance remains unverified.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #71 is the latest verified release for source `d9e026f70ec62455763de05048cba1557edfaf23`. Full audit/test/build/signing/source archive/Release/download verification evidence is in `APP_BUILD_REPORT.md`.
- Next step is device-side validation of Build #71 indicator motion/toggle styling, six-metric overlay and live telemetry. FPS removal has already been built and release-verified; CI alone does not prove device behavior.
- Build #71 remains the latest verified APK; the current source-only UI/Firmware V6.7 changes are not built or device-verified. Its compile log and source-to-BIN provenance remain independently unverified. App CI does not imply Firmware compilation, BIN provenance, Firebase, OTA, flash, BLE hardware or thermal-safety validation.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
