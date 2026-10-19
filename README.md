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

- Latest successful App artifact build is Build #83 / [Actions run 39192430789](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39192430789), source commit `dfc7e6633298498bb6eac21182c9306d5e3cac1d`. All 21 steps passed including **96/96 Flutter tests**, analysis, Android configured gate, obfuscated APK, V1/V2/V3 signing/certificate and re-downloaded APK/source ZIP. Overall Release handoff is BLOCKED because `refs/tags/jexfyz-latest` remains at `9136f11799143d91eb58e947ea10e9e576bb579f`, not the artifact source commit.
- APK asset 654626935, 54,620,251 bytes, SHA-256 `b403ccd3813f1974b82703730fce2c60bab972b067bc7ac4875d51d0e55558c6`. Matching source ZIP asset 654626933, 2,852,944 bytes, SHA-256 `bae47230267438073c9fd2bdf9ee58bfd768a5fcdfedf7102983c05dc23bf0cc`. `jexfyz-latest` targets the exact Build #80 source commit. Details are in `APP_BUILD_REPORT.md`.
- Build #83 packaged the current App source/test blobs (`lib/main.dart` `99bdf225b990fbe8a4ff92c224b4fccc4ae4624a`; `test/widget_test.dart` `9fffea531bdb19315c01aaf0e253ebdfacd7a1ed`), including the current indicator refinements. CI passed 96/96 Flutter tests but does not prove physical phone UI, BLE telemetry or cooling/safety. The remaining unverified condition is the Release tag ref and execution of the repaired workflow.
- Active Firmware sketch is `firmware/JEXFYZ-V6.7.ino`, embedded `FW_VERSION="V6.7"`, matching filename, exactly one active versioned sketch. The user reports V6.7 compiled successfully and was updated online; this is USER-REPORTED and not independently verified. Exact source-to-BIN provenance and current installed version remain UNVERIFIED.
- Physical phone visuals, BLE/Fan telemetry, Firmware compilation, OTA, reboot and thermal/electrical behavior remain outside the verified App CI evidence.

## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. Do not add README, note, source, or memory files there.
- The active editable Firmware source is `firmware/JEXFYZ-V6.7.ino` (`FW_VERSION="V6.7"`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`). The user reports successful compilation and online update; this is USER-REPORTED and not independently verified. Source-to-BIN provenance remains UNVERIFIED.
- V6.6 compile/two-same-version OTA statements are historical user reports. V6.7 has a separate user-reported compile/online-update success; no independent compile log, BIN identity, OTA evidence or current device version was inspected.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #83 is the latest successful artifact run and its App source matches current main. The workflow YAML syntax fix is newer and has not yet been exercised; tag/ref consistency remains blocked. After a separately authorized `@Thinking Eksekusi Build App!`, verify all gates and `refs/tags/jexfyz-latest == run.head_sha`, then check the published APK/source ZIP digests.
- Next verification step, after a separately authorized `@Thinking Eksekusi Build App!`, is to run the repaired workflow through its guarded issue trigger, confirm all required gates pass, and verify the Git tag, Release metadata, APK and source ZIP all reference the same source commit. Then verify indicator rendering and BLE/Fan telemetry on a real phone. Build #83 already contains the current painter source; physical validation remains pending.
- App CI does not prove Firmware compilation, source-to-BIN provenance, Firebase, OTA, flash, BLE hardware, thermal/electrical safety or installed device version.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
