# JE X FYZ / JE Cooler — Live Chat Checkpoint

Checkpoint refreshed: 2026-10-23 (Asia/Jakarta). This is the rolling continuation state, not a transcript. Prompt 1 in `CHAT_TRANSFER_PROMPTS.md` starts with `Diskusi!`; for explicitly authorized execution/recovery, replace only its first line with `Eksekusi Full!` or `Chat Stuck!`. Prompt 2 starts with `Eksekusi Build App!`. Paste one complete prompt and do not add a duplicate command line.

## Product and release baseline

- **Latest independently verified App release:** [Build #129 / Actions run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), source commit `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`. All 21 workflow steps succeeded; run ended `success` at `2026-10-23T08:35:39Z`.
- **APK:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `668498025`, 54,751,323 bytes, SHA-256 `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`.
- **Corresponding source ZIP:** [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `668498026`, 2,878,916 bytes, SHA-256 `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- Release ID `403010611` and live `refs/tags/jexfyz-latest` both target the tested source SHA. Workflow step 21 verified exactly one APK plus one matching ZIP, downloaded digests/source marker, and APK V1/V2/V3/certificate.
- **QC:** 122 Flutter tests passed; Dart analyzer exited 0 with 25 informational diagnostics; configured Android Gradle gate reported `BUILD SUCCESSFUL in 1m 27s`. Native Android JUnit tasks were `NO-SOURCE`, so no native JUnit test cases executed.
- **Field-device status (USER-REPORTED):** the owner previously reported installing/overwriting Build #128. The exact installed APK identity was not independently read; do not assume Build #129 is installed. Firmware V7.1 compile/Online OTA is also USER-REPORTED. CI is not physical-device, Firmware/BIN, OTA, BLE, cooling or safety proof.

## Active recovered execution result — compact Settings and Bluetooth Connection UI — 2026-10-23

- **Authorization/scope:** owner invoked `@Thinking Eksekusi Full!` for the compact visual pass. Only App source, targeted regression/source-contract tests, and canonical project-memory docs were changed. No App Build/release, Firmware/BIN/Firebase, OTA, flashing or physical-device operation was authorized or performed.
- **Owner observation:** Home-equivalent DPI-fixed behavior is correct on the supplied 420-dp and 350-dp displays, but Settings and Bluetooth Connection still looked oversized. The 360-dp canvas and its uncapped `width / 360` transform are kept unchanged; compactness is achieved only through base typography, icons, visual density and spacing.
- **Implemented source commits:** [`5ab14e258a9e21bfec486e3c6a3d81d6705c6d0f`](https://github.com/TenzoNkz/JEXFYZ-App/commit/5ab14e258a9e21bfec486e3c6a3d81d6705c6d0f) adds `buildJexCompactUiTheme` and opt-in `compactUi`; [`bfdcafd1ad044974935b4e473d68f2096a297fbf`](https://github.com/TenzoNkz/JEXFYZ-App/commit/bfdcafd1ad044974935b4e473d68f2096a297fbf) tightens Floating Settings/Connection values; [`415d240db3cd9b3e2bca3ef760c4ba667459c604`](https://github.com/TenzoNkz/JEXFYZ-App/commit/415d240db3cd9b3e2bca3ef760c4ba667459c604) pins per-role assertions in the source-contract test.
- **Settings compact targets:** AppBar title 20→18; row title 13 dp, summary 12→11; section label 10→9; glyph/caret 21→19 / 18→16; row padding 14/13→12/10 and smaller gaps. Settings root and Language/Appearance/Notifications/Bluetooth/Floating subpages opt into the compact theme. Floating Settings group captions now 11 dp; its smaller captions/value labels are 10 dp.
- **Connection compact targets:** header 66→60 dp, heading 18→16, close glyph 25→22 while preserving its 42-dp tap area; pill labels 10.5→9.5, pill glyphs 19→18, pill height remains 42; Devices heading 14→13 and refresh target 38→40; empty-state glyph 36→32, text 13→12 and nearby gaps reduced. BLE states, permissions, scanning/connect callbacks, colors, localization and controls remain unchanged.
- **Static verification:** fetched live source/test after commit and confirmed compact theme opt-in on only the intended routes/sheet, target sizes, preserved DPI formula, per-role labels, and fixed-canvas density test still present. These checks verify source text/contracts only.
- **Validation blocker:** attempts to run `flutter test test/floating_monitor_layout_contract_test.dart` and `dart format --output=none lib/app_settings.dart lib/floating_monitor.dart lib/main.dart test/floating_monitor_layout_contract_test.dart` failed to start: both executables are absent (`command not found`, exit 127). Analyzer, full Flutter suite, and physical-device/OEM visual QA are NOT RUN. Do not claim the new compact pass runtime-validated.
- **Release boundary:** Build #129 / run `39925045446`, packaged source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`, remains the latest verified release. The compact source pass is on `main` but not in the released APK/source ZIP. After validation, a separate explicit `@Thinking Eksekusi Build App!` is required if the owner wants an installable compact UI.
- **Protected behavior:** Home/DPI canvas, status colors, localization, BLE logic and all Firmware/BIN/Firebase/OTA/flash/device contracts were left untouched.


## Canonical release-memory refresh — Build #129

After the verified Build #129 release, all current-state/design/handover index notes were refreshed and re-read from `main` to remove stale Build #128 / “validation pending” statuses:

- `APP_BUILD_REPORT.md`: successful Build #129 gate/artifact ledger — [`71880ce0a72289decb74a05e61e9381c9d8a0748`](https://github.com/TenzoNkz/JEXFYZ-App/commit/71880ce0a72289decb74a05e61e9381c9d8a0748).
- `BUILD_NOTES.md`: [`cdc898f25f87f3697b3059a53d2c9c999167898f`](https://github.com/TenzoNkz/JEXFYZ-App/commit/cdc898f25f87f3697b3059a53d2c9c999167898f).
- `PROJECT_STATE.md`: [`0867f4df83fb8e49c57024288d4dcc706c8c3069`](https://github.com/TenzoNkz/JEXFYZ-App/commit/0867f4df83fb8e49c57024288d4dcc706c8c3069).
- `APP_NOTES.md`: [`c3e94c292e2aceb8d029140f6a2a0abbe1dcaae7`](https://github.com/TenzoNkz/JEXFYZ-App/commit/c3e94c292e2aceb8d029140f6a2a0abbe1dcaae7).
- `DESIGN_NOTES.md`: [`e798ae0c09dfa6bcdf42ce1645a5f2fa7e04870b`](https://github.com/TenzoNkz/JEXFYZ-App/commit/e798ae0c09dfa6bcdf42ce1645a5f2fa7e04870b).
- `HANDOVER.md`: [`203ab66417dae65b153856b7c96c063d7792b660`](https://github.com/TenzoNkz/JEXFYZ-App/commit/203ab66417dae65b153856b7c96c063d7792b660).
- `MEMORY_INDEX.md`: [`787773ec5be482acf78b77176df3a5b81a553b85`](https://github.com/TenzoNkz/JEXFYZ-App/commit/787773ec5be482acf78b77176df3a5b81a553b85).
- `README.md`: [`6485cb7344d4d7800bb7180a7112c766abfd2b09`](https://github.com/TenzoNkz/JEXFYZ-App/commit/6485cb7344d4d7800bb7180a7112c766abfd2b09).
- `CHANGELOG.md`: [`f403feec7f4664c43ebbf12c0413272f90429c3c`](https://github.com/TenzoNkz/JEXFYZ-App/commit/f403feec7f4664c43ebbf12c0413272f90429c3c).

All these writes were verified by re-fetching their resulting file contents. The release remains bound to tested/package source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`; subsequent commits are documentation-only and do not change the tested artifact.

---

## Latest App Build result — SUCCESS — Build #129 — 2026-10-23

- [GitHub Actions run #129](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), job `120319250463`, runner `1000002428` (`ubuntu-24.04`). Exact tested/package source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`.
- **Validated source change:** Home-equivalent DPI compensation for Settings root/subpages, Bluetooth Connection sheet and selected modal surfaces. `lib/floating_monitor.dart` uses uncapped `constraints.maxWidth / 360.0`, a fixed 360-dp logical child, MediaQuery insets converted to canvas units, an outer `OverflowBox` before the single uniform transform, then viewport clipping. The corresponding density regression test holds physical viewport at 1080×2400 and exercises logical widths 420 dp and 320 dp, expecting scales 420/360 and 320/360 and logical canvas 360×800.
- The hosted CI analyzer, the full Flutter test suite including the new regression test, configured Android gate, obfuscated release APK build, V1/V2/V3 and production certificate checks, corresponding ZIP, guarded Release/tag parity and final downloaded-asset identity/hash/source-marker/signature checks all passed.
- Expected production certificate SHA-256: `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Preserve Android Gradle `versionName "Telegram @horizontalzzz"`.
- Analyzer's 25 findings are info-level deprecation/unnecessary-import diagnostics. The Android unit-test Gradle task succeeded but its app JUnit tasks were `NO-SOURCE`. A post-job Pub cache save was denied by token cache-scope permissions; cleanup and run still succeeded.
- Complete evidence and historical attempts #125–#129 remain in `APP_BUILD_REPORT.md`. Final Build #129 ledger commit: [`71880ce0a72289decb74a05e61e9381c9d8a0748`](https://github.com/TenzoNkz/JEXFYZ-App/commit/71880ce0a72289decb74a05e61e9381c9d8a0748).

## Current execution status

- The explicitly authorized Build App operation is **complete**. At the last verified post-run check there were zero `in_progress`, `queued` or `waiting` workflow runs. Do not retrigger a build for the same source without a new explicit request.
- Latest Release/tag/asset checks and all required steps were independently re-fetched after #129. The workflow guard is still blob `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`, issue-only `opened/reopened`, with the existing owner/title/body token guard; no push/PR trigger route was added.
- Local Flutter/Dart tools were absent during source development. The successful hosted run is the actual validation evidence; a separate physical-device layout check remains outstanding.
- No Firmware compilation, BIN/Firebase mutation, OTA, flashing or device operation was run in this Build App workstream.

## Durable checkpoint / recovery rules

- GitHub does not automatically store the ChatGPT transcript. A state is durable only after the relevant file update is committed to `main` and the resulting content re-read and verified.
- Before ending any substantive project chat, review new decisions, findings, results, blockers and next steps since the last checkpoint. Save new durable details without waiting for a separate request; avoid empty commits when there is no change.
- During Build App, update `APP_BUILD_REPORT.md` for every attempt, result, failure, repair, test result, artifact and checksum. Update this file at each logical gate/milestone and at success/blockage.
- If interrupted before a commit finishes, recover only the last verified checkpoint and fresh live repository/Actions/Release state. Do not invent unsaved details, repeat side effects blindly or assume an active run completed.
- After a new boot, fetch live `main` HEAD and recursive tree, read `CHAT_RULES.md`, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `HANDOVER.md`, `BUILD_NOTES.md`, the entire workflow and the latest `APP_BUILD_REPORT.md`, then inspect live Actions and Release/tag/assets before acting.

## Latest App UI contract

- Home notice heading follows App language: `Notification` in English and `Notifikasi` in Indonesian.
- Generic device identity uses Device / Perangkat, not JE X FYZ as a generic noun. Preserve bilingual notifications and the user-facing strings validated in Build #128/#129.
- Floating Monitor remains hidden when synchronized BLE telemetry says disconnected. It reattaches only when saved enable intent, overlay permission and the full connected BLE/P1 session gate are satisfied; disconnect must not erase saved enable intent.
- Alert notification IDs 2101–2104, persistent BLE foreground ID 2110 and Floating Monitor ID 2301 remain distinct; existing channel IDs are preserved. Channel labels/descriptions follow the selected App language.
- Build #129 verifies App-side density math and widget regression on the hosted runner, not real Android rendering across OEM display settings, overlay attachment or connected-device behavior.

## Permanent technical boundaries

- Adaptive Fan targets remain relative to Hotside limit: delta ≤2°C→100%; 3–4→90%; 5–6→80%; 7–8→70%; 9–10→60%; ≥11→50%. At/above Hotside limit, Fan 100% and Peltier OFF. PWM rises 10 points/second and falls 10 points/10 seconds; Adaptive 5 V/9 V remains Fan 100%.
- Rapid Hotside-rise/slope shutdown plus manual re-arm is NOT IMPLEMENTED in Firmware V7.1; do not conflate it with existing Adaptive Fan tiers or raw-decimal limit protection.
- Preserve one calibrated NTC reading/second, cooperative millis() timing, Touch/P1, telemetry authority, BLE single-radio ownership, selector/Peltier timing, safe outputs and Local/Online OTA recovery.
- Current Online OTA code uses `cloudClient.setInsecure()`: transport is encrypted but server certificate identity is not authenticated. Preserve the GitHub BIN allowlist, redirect blocking, response/status/length/image checks and version+link contract.
- Exclusive App identity authorization remains BLOCKED / NOT IMPLEMENTED until trusted backend enrollment/signing and Firmware verification exist.
- Firmware source-to-BIN identity, physical OTA, reboot behavior, BLE recovery and thermal/electrical behavior remain unverified by App CI.

## Canonical notes / prompt use

- Rules and authorization: `CHAT_RULES.md`. Index/retention policy: `MEMORY_INDEX.md`.
- Current-only project state: `PROJECT_STATE.md`; immediate handover: `HANDOVER.md`.
- App behavior: `APP_NOTES.md`; approved visual contract: `DESIGN_NOTES.md`.
- Hardware/Firmware: `FIRMWARE_NOTES.md` and `firmware/FIRMWARE_TECHNICAL_REFERENCE.md`.
- OTA: `OTA_PROTECTION.md` and `OTA_REGRESSION_MEMORY.md`. Voltage/Peltier: `VOLTAGE_TRANSITION_MEMORY.md`.
- App build process: `BUILD_NOTES.md`; detailed attempt ledger: `APP_BUILD_REPORT.md`; timeline: `CHANGELOG.md`; keep `archive/*.md` immutable.
- General discussion/execution handoff is Prompt 1 of `CHAT_TRANSFER_PROMPTS.md`; guarded App Build is Prompt 2. The copy-ready command names intentionally omit `@Thinking`.
