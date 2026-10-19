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

- Latest successful verified App artifact is **Build #91** / [Actions run 39207456720](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39207456720), source commit `e9f6d8ca3ea936a1c4c05b2fbbd228dda5e2cdd1`. All 21 workflow steps passed; **97/97 Flutter tests passed**, analyzer exited 0 with 23 informational deprecation findings, the configured Android gate, obfuscated APK, required V1/V2/V3 signing/certificate, matching source ZIP and downloaded-asset verification all passed. Native JUnit tasks were NO-SOURCE.
- Build #91 APK asset `655397774` SHA-256 `8a111df269a5093dd3b7de9e086ab0c2fddda4bc5f1c71a1cf237daa7542863c`; source ZIP asset `655397777` SHA-256 `78ccbbdeaf3dfd9353f652c09e4e6ddcf2aa83ce77b771ad1822078a5a541ed6`. Release metadata and `refs/tags/jexfyz-latest` matched source commit `e9f6d8ca3ea936a1c4c05b2fbbd228dda5e2cdd1` at Build #91.
- The current source follow-up after Build #91 makes generic navigation/settings/action glyphs static rather than unconditionally animated and adds a source-contract regression. It is **NOT RUN / NOT RELEASED** until the separately authorized `@Thinking Eksekusi Build App!` pipeline validates it. Build #91 remains the latest successful artifact for its source and does not include this follow-up.
- Dashboard indicators use the approved Industrial Premium / Precise design: temperature lava warning transitions, voltage branch strikes, Adaptive halo, faceted Peltier crystal, Fan's five-blade rotor with fixed airflow and an event-driven half-circle Fan Speed gauge. Physical screen motion, BLE/PWM runtime, cooling/safety behavior and device operation are not proven by CI.
- Active Firmware sketch is `firmware/JEXFYZ-V6.7.ino` with `FW_VERSION="V6.7"`; user-reported compilation/online update remains unverified. No Firmware/BIN/Firebase/OTA/device operation occurred during the source follow-up.



## Repository boundaries

- `TenzoNkz/JEXFYZ-App` is the canonical editable App + Firmware source repository and the sole home for project documentation/memories.
- `TenzoNkz/JEXFYZ-Firmware` is intended to contain only the production OTA artifact `JEXFYZ.cpp.bin`. The live recursive tree currently has exactly one entry, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was checked; do not read the payload or add README, note, source, or memory files there. Source-to-BIN provenance remains UNVERIFIED.
- The active editable Firmware source is `firmware/JEXFYZ-V6.7.ino` (`FW_VERSION="V6.7"`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`). The user reports successful compilation and online update; this is USER-REPORTED and not independently verified. Source-to-BIN provenance remains UNVERIFIED.
- V6.6 compile/two-same-version OTA statements are historical user reports. V6.7 has a separate user-reported compile/online-update success; no independent compile log, BIN identity, OTA evidence or current device version was inspected.
- App Gradle `versionName "Telegram @horizontalzzz"` is an intentional identity string; do not change it.

## Remaining validation outside CI

- Build #83 is the latest successful artifact run and its App source matches current main. Runs #84–#87 were push-event failures with no jobs; issue #34 did not create a newer issue-event run. The workflow YAML syntax fix is newer and has not yet been exercised; tag/ref consistency remains blocked. Do not start a build from `Eksekusi Full`. After a separately authorized `@Thinking Eksekusi Build App!`, verify all gates and `refs/tags/jexfyz-latest == run.head_sha`, then check the published APK/source ZIP digests.
- Next verification step, after a separately authorized `@Thinking Eksekusi Build App!`, is to run the repaired workflow through its guarded issue trigger, confirm all required gates pass, and verify the Git tag, Release metadata, APK and source ZIP all reference the same source commit. Then verify indicator rendering and BLE/Fan telemetry on a real phone. Build #83 already contains the current painter source; physical validation remains pending.
- App CI does not prove Firmware compilation, source-to-BIN provenance, Firebase, OTA, flash, BLE hardware, thermal/electrical safety or installed device version.

## Non-negotiable workflow

Read [CHAT_RULES.md](CHAT_RULES.md) before making changes. Discussion is read-only. Changes go directly to `main` unless the user explicitly requests another workflow. The user compiles firmware themselves. Use `@Thinking Diskusi!` for full read-only discussion; Gemini prompt/answer modes require `Diskusi!` in the same command. Use `@Thinking Eksekusi Full!` for approved full execution, `@Thinking Eksekusi Build App!` for the entire App Build/retry/verification cycle, and standalone `@Thinking Chat Stuck!` to recover a stalled/errored authorized operation from the last verified checkpoint. The sole App Build report is `APP_BUILD_REPORT.md`; the retired aliases `@Thinking Build App!`, `@Thinking Eksekusi & Build App!`, and standalone `@Thinking Eksekusi!` are invalid. A documentation edit never authorizes source changes, builds, release operations, Firebase changes, flash, or OTA. At a general/Discussion chat limit, use Prompt A only when full project-memory reconciliation is needed. At a Build App chat limit, use Prompt D once as the replacement Build App chat's opening message; it loads and continues from live evidence without a recap stage.
