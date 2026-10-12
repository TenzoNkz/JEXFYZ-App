## CURRENT APP / V6.1 INTEGRATION STATUS — 2026-10-12

- [CURRENT TRUTH] App source remains version `1.0.0+3`, package `com.horizontalzzz.jexfyz`; no App source change is part of the V6.1 firmware fix.
- [UNVERIFIED] App ↔ V6.1 integration and UI behavior on the physical device are not yet validated. No App Build was executed for V6.1.
- [POLICY] The V5.9 integration/localization records below are historical records, not the current firmware target.

## CURRENT V5.9 APP LOCALIZATION + NOTIFY CLEANUP — 2026-10-07

- [IMPLEMENTED] English is the master/reference language for user-facing copy.
- [IMPLEMENTED] Indonesian wording is synchronized to the English meaning, context, tone, and severity.
- [IMPLEMENTED] Home NOTIFY no longer exposes reset/debug text such as `Reset: POWER_ON`; user-facing reset messages are localized and concise.
- [IMPLEMENTED] Known safety, command, connection, and OTA status messages use professional, minimal wording without firmware protocol tokens or underscore-formatted reasons.
- [IMPLEMENTED] Error-state classification is language-aware for English and Indonesian.
- [IMPLEMENTED] Home NOTIFY message and status text explicitly disable text decoration to prevent accidental underline rendering.
- [IMPLEMENTED] Core Hotside terminology is standardized as “Hotside” / “Suhu Hotside”; “Sakelar” is used for Indonesian switch labels.
- [IMPLEMENTED] Localization regression coverage was updated for Hotside terminology, Notify error detection, Peltier re-arm copy, and POWER_ON reset handling.
- [NOT BUILT HERE] Flutter analyze/test execution and App Build remain pending.

## CURRENT V5.9 INTEGRATED QC BATCH — 2026-10-06

- Firmware source: `firmware/JEXFYZ-V5.9.ino`.
- App: 1.0.0+3.
- Status: DEVELOPMENT + QC / PRE-RELEASE — NOT RELEASED.
- App + Firmware are one integrated contract.
- Peltier safety re-arm: effective Hotside lock + one-shot post-safety feedback; Touch/BLE/Adaptive use the same effective safety gate.
- App: P1 required for session readiness; stale Peltier re-arm notice clears on healthy safety telemetry; safety-sensitive paired startup is serialized; PHONE:BT is coalesced; ONLINE_IMAGE_VALIDATE is mapped.
- Android notification preference is not saved ON unless runtime permission is granted.
- Foreground BLE-support service is NOT_STICKY.
- OTA Local, OTA Online, Wi-Fi↔BLE handoff, OTA state/recovery, image validation, URL/path contract, and BLE/P1/SYNC architecture remain FROZEN.
- `versionName "Telegram @horizontalzzz"` is intentional and unchanged.
- App Build was NOT requested by this execution.
- V5.9 compile/flash/physical regression and final release gate remain pending.

## FIRMWARE V5.3 SYNC — 2026-10-05
- [IMPLEMENTED IN FIRMWARE] Both Adaptive profiles now enforce a 5-second dwell after each completed upward voltage step.
- [PRESERVED] Downward Adaptive voltage changes remain immediate.
- [PRESERVED] App version remains 1.0.0+3; no App source change was required for this firmware-only behavior.
- [NOT BUILT HERE] App Build was not executed.

## APP PELTIER SAFETY NOTIFY — 2026-10-05
- [IMPLEMENTED] Peltier restart failures now explain the Hotside re-arm requirement, using the configured hotLimit minus 2°C.
- [IMPLEMENTED] The retired RAPID_HOTSIDE_RISE notification mapping was removed.
- [IMPLEMENTED] ACK handling treats ON/OFF as valid outcomes and shows unsolicited Touch cooling success in NOTIFY instead of flagging it as an error.
- [IMPLEMENTED] Peltier failure notices avoid duplicating a firmware-supplied safety reason.
- [NOT BUILT HERE] App Build was not executed.

## APP SAFETY NOTIFY / REARM — 2026-10-05
- Peltier restart lock notification states that Hotside must cool to `hotLimit - 2°C` before restart.
- Touch-generated ON/OFF ACK outcomes are classified correctly and surfaced as clean NOTIFY messages.
- Peltier failure notices prefer the firmware safety reason and avoid a duplicate generic warning.
- Retired RAPID_HOTSIDE_RISE presentation was removed.
- App Build was not executed.

## APP HOME FAN SPEED DISPLAY QC — 2026-10-05
- Fixed Home Fan Speed presentation for Adaptive + 12V: Fan Speed now displays 100% instead of --.
- Manual + 12V continues to display the actual configured Fan Speed.
- Adaptive Fan Speed remains non-editable; this change is presentation only.
- Added regression tests for Adaptive 12V = 100%, Manual 12V = configured speed, and 9V = 100%.
- No App Build was executed for this source fix.

## 2026-10-05 — BUILD APP #9 SUCCESS / V4.8 HOTSIDE TERMINAL RE-ARM

- Build #9 run `37268139253` completed successfully from source commit `9d44514cf251416ba75d71b039750f4fd33ae5e2`.
- Passed all active release gates: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, JE X FYZ security/architecture audit, dependency installation, `flutter analyze --no-fatal-infos`, `flutter test`, obfuscated release APK compilation, production signing verification, filename preparation, and GitHub Release publication.
- Release APK was compiled successfully at `build/app/outputs/flutter-apk/app-release.apk` and published as `JEXFYZ-release.apk`.
- Production signing verification passed:
  - DN: `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`
  - Certificate SHA-256: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`
- GitHub Release `jexfyz-latest` contains exactly one APK asset: `JEXFYZ-release.apk`, asset ID `611619423`, size `54,327,520` bytes.
- Published APK SHA-256/digest: `64f9be08a28007e42a27dfd7b0459857a06d7146200113a405638ef8f0353058`.
- Release URL: https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest
- Build URL: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/37268139253
- Current delivery workflow intentionally avoids Actions artifact storage quota and publishes exactly one direct APK to the GitHub Release.
- Dart symbols were generated by `--split-debug-info=build/symbols`, but the current direct Release workflow does not publish symbols separately.
- App package metadata remains `1.0.0+3`; Android user-visible version label remains `Telegram @horizontalzzz`.
- Source contains the latest V4.8 Hotside terminal re-arm hardening state. CI validates App compilation/signing only; no physical ESP32 runtime test occurred during Build #9.

## 2026-10-05 — PELTIER POPUP START SEQUENCE
- [IMPLEMENTED] Removed the UI-side Fan confirmation wait when starting Peltier from Fan-OFF via the Safety popup.
- [IMPLEMENTED] After popup approval, App starts both confirmation flows immediately; the serialized GATT write queue sends FAN:ON followed directly by PELTIER:ON.
- [PRESERVED] Firmware remains the final safety authority and keeps the 5-second Peltier soft-start.
- [NOT BUILT HERE] No App Build was executed for this source change.

## 2026-10-05 — BUILD APP #8 SUCCESS / V5.0 FIRMWARE SOURCE

- Build #8 run `37261171475` completed successfully from source commit `eeeec79e729383c4c588719efac677373a62bfa9`.
- Passed all active release gates: Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, JE X FYZ security/architecture audit, dependency installation, `flutter analyze --no-fatal-infos`, `flutter test`, obfuscated release APK compilation, production signing verification, release filename preparation, and GitHub Release publication.
- Production signing verification passed with the required JE X FYZ certificate DN and SHA-256.
- GitHub Release `jexfyz-latest` contains exactly one APK asset: `JEXFYZ-release.apk`, asset ID `611422021`, size `54,327,520` bytes.
- Published APK SHA-256/digest: `b8045d0b6fa6d05b421bd6b1c0318d4ee4529734d7b471534700f95676200888`.
- Release URL: https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest
- Build URL: https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/37261171475
- The current delivery workflow intentionally avoids Actions artifact storage quota and publishes exactly one direct APK to the GitHub Release.
- Dart symbols were generated by `--split-debug-info=build/symbols`, but the current Release delivery workflow does not publish the symbols as a separate artifact.
- App package metadata remains `1.0.0+3`; Android user-visible version label remains `Telegram @horizontalzzz`.
- Build #8 remains App-only validation; it does not validate V5.0 ESP32 runtime behavior.

# JE X FYZ — CURRENT APP NOTES

- App CONTROL source change commit: b9f316e50770acb66770515395344de6c6e80ea6

## CURRENT IDENTITY
- App name: JE Cooler
- Header: JE X FYZ
- Package: com.horizontalzzz.jexfyz
- Version: 1.0.0+3
- Main source blob: df4a244723420f8057745275838d7e07c1e0c82a
- Settings blob: f11235bab559b291928550e06984532581ddad6a
- Tests blob: 2da4bff01d3eed749eeba873e9ec2e577c04def9

## CURRENT PHASE
- App remains in DEVELOPMENT + QC; current Firmware integration target is V5.9.
- App version remains 1.0.0+3.
- Android versionName remains intentionally Telegram @horizontalzzz.
- P1 is required before BLE dashboard/session readiness.
- Command confirmations are serialized at the high-level transaction layer.
- PHONE:BT heartbeat values are coalesced; no unbounded 1 Hz write backlog is allowed.
- Current source/runtime compile and device integration gates remain unverified.


## CONTROL
- Peltier ON from Fan-OFF state: after the safety popup is approved, the App queues FAN:ON and PELTIER:ON together; the BLE write queue preserves that order without waiting for Fan telemetry between commands.
- Fan already ON -> Peltier ON remains immediate.
- Firmware remains responsible for the 5-second Peltier soft-start.
- Realtime QC fix: unsolicited FAN/PELTIER/FAN_SPEED telemetry is applied immediately as firmware-authoritative Control state.
- Firmware remains the final safety authority; App does not add a fixed precharge timer.
- Peltier still uses the existing command-confirmation timeout, while the firmware remains responsible for the 5-second Peltier soft-start.
- Notify QC fix: stale command/connection errors clear only after healthy live cooling/safety telemetry; actual safety warnings remain visible.

## BLE / SESSION
- flutter_blue_plus is the BLE transport.
- JE X FYZ service/RX/TX UUIDs are frozen.
- P1 SYNC/SYNC_READY remains the usable-session gate.
- Firmware telemetry remains authoritative for hardware and safety state.
- Passive Auto Connect remains permission-free and preference-controlled.
- Online OTA recovery is explicit and does not depend on passive Auto Connect.
- Expected Online OTA GATT disconnect is treated as an OTA lifecycle event, not a normal Bluetooth error.
- After OTA reconnect, the App completes normal P1 sync and surfaces the one-shot OTA result.

## OTA PROTECTION
- OTA_PROTECTION.md is the repository reminder for the protected OTA path.
- OTA behavior is frozen during unrelated App work and should not be refactored or optimized casually.
- Any OTA change requires a demonstrated OTA defect, explicit discussion/approval, and full OTA re-audit.
- Anti-downgrade is OFF: any valid version different from the device version may be selected.

## OTA / FIRMWARE SYNC
- Firmware update flow remains OTAENTER, SSID, PASS, URL, VERSION, CLOUDOTA.
- OTA_UP_TO_DATE is recognized as a one-shot result.
- V5.7 OTA update to the physical hardware is user-confirmed successful.
- App uses firmware-reported Adaptive Ceiling and current SAFETY OK/LOCKED semantics.
- Battery thresholds remain 5V 20–30°C and 12V 30–40°C; current firmware source is V5.7.
- Current Firmware OTA stage tokens are mapped for presentation.
- Wi-Fi password input is masked.
- Firebase supplies release metadata; GitHub hosts the fixed firmware BIN URL.
- Wi-Fi credentials remain in flutter_secure_storage.
- V5.2 firmware preserves the P1 command contract and adds Peltier safety re-arm feedback; App control now starts Fan/Peltier back-to-back from the safety popup.

## BUILD / CI STATUS
- Latest verified downloadable App Build: workflow run 37245703677.
- Current release workflow: .github/workflows/jexfyz-app-build-trigger.yml.
- Active workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0.
- Workflow is a direct owner/title/token-gated issue-triggered Release build.
- Workflow publishes exactly one JEXFYZ-release.apk to GitHub Release jexfyz-latest.
- No Actions artifact is used by the current delivery path.

## V5.0 FIRMWARE CONTROL / SELECTOR
- GPIO3 = 12V Optocoupler/Decoy selector; GPIO4 = 9V Optocoupler/Decoy selector.
- Both selector outputs are OFF for 200 ms before the target output is enabled; they are never active together.
- GPIO5 Peltier MOSFET and GPIO6 Fan MOSFET remain physically active during selector voltage changes; Peltier PWM is not forcibly cleared.
- Fan is forced to 100% at the start of every voltage transition. Fan Speed is user-adjustable only at 12V.
- Returning to 12V does not restore a previous Fan Speed preference; Fan remains at 100% until manually changed.
- HOTSIDE LED red blink lasts 10 seconds during each HOTSIDE timing stage, including the 5V terminal stage.

## V4.8 HOTSIDE
- HOTSIDE safety dwell is non-blocking and uses 10 seconds before each lower-voltage step.
- 12V hot: Fan ON / Peltier OFF → 10s → 9V.
- 9V hot: Fan OFF / Peltier OFF → 10s → 5V.
- 5V hot: terminal Peltier OFF; Adaptive exits and manual restart remains latched until Hotside cools below the re-arm threshold.
- App no longer adds a fixed 2-second precharge before PELTIER:ON.
- App Build remains a separate operation.