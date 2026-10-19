# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after Home STATUS / NOTIFY bilingual copy, OTA summary sanitization and centered responsive-card source changes on 2026-10-19 (Asia/Jakarta). This is the canonical boot snapshot. The pre-transfer HEAD/tree below describes live main immediately before this final transfer write. This file is written last and does not self-reference its future commit/blob; fetch final HEAD/tree/blob after committing.

## 1. Authority, repository roles and command protocol

- Canonical editable repository: TenzoNkz/JEXFYZ-App, branch main. Continue directly on main; do not create branches/PRs unless explicitly requested.
- Pre-transfer HEAD: `f861f172461cf44da125b00fc85473c34151dd09`. Parent: `a5d6eed6b23891f6c9a3a4dbb036e4c771f15cb2`. Tree: `ba98ef4158cf4cbf29210114247adba76d428106`.
- Artifact-only repository: TenzoNkz/JEXFYZ-Firmware must contain exactly JEXFYZ.cpp.bin. Last inspected blob dca6a1267762152519f6d2889e4f0adf46fd8803, 1,457,008 bytes. Only tree metadata was inspected; the payload was not read and source-to-BIN provenance is UNVERIFIED.
- Commands: @Thinking Diskusi! is read-only; @Thinking Eksekusi Full! permits scoped App source/tests/docs/audit/commit but not App Build/Firmware/device actions; @Thinking Eksekusi Build App! alone authorizes the official App build/QC/release pipeline; @Thinking Chat Stuck! recovers the authorized task without widening scope. Retired aliases: @Thinking Build App!, @Thinking Eksekusi & Build App!, and standalone @Thinking Eksekusi!.
- Build workflow remains .github/workflows/jexfyz-app-build-trigger.yml, blob 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12. It is guarded to issues.opened/reopened with repository owner/title/body token only. No push/PR/manual bypass.
- Preserve Android Gradle versionName "Telegram @horizontalzzz". User compiles Firmware. No firmware, BIN, Firebase, OTA, flash, or physical-device operations are authorized under Eksekusi Full.
- Current approved scope is Home STATUS / NOTIFY bilingual copy polish and card layout: remove the separate connection badge; retain `NOTIFY • category`; center the heading/body; support natural one/two-line body text at readable size; localize known safety/command/OTA outcomes; and prevent raw reason/OTA diagnostic tokens from reaching the card. Source/tests are committed after Build #100. Flutter/Dart tests and analyzer are NOT RUN because the execution environment has no Flutter/Dart executables. No Build App is authorized by `Eksekusi Full`; Build #100 remains the latest successful release.

## 2. Latest verified App release

- Latest successful released artifact: Build #100 / Actions run 39237262140, exact packaged source commit 51bea70b2ca17f285bf35c3e547dc44c70f26d59.
- All 21 workflow steps passed. Analyzer exited 0 with 25 info-level findings and no errors/warnings. Flutter test result: 103/103 passed. APK signature/certificate, corresponding source ZIP, downloaded asset digests, and Release/tag/source equality passed. Native JUnit tasks were NO-SOURCE.
- APK asset 655957943, 54,718,555 bytes, SHA-256 a59c0a37b2025ad2b250bd4354b887379d96658e9f7757692691fa23b7b4d0a2.
- Corresponding source ZIP asset 655957946, 2,862,476 bytes, SHA-256 e60c4705097009d843b624bf8f0f989770a76aba6fdfbdd8d2159d77f98890f1.
- Release jexfyz-latest and Release metadata match Build #100 source 51bea70b2ca17f285bf35c3e547dc44c70f26d59. Do not manually move the tag.

## 3. Current post-Build-#100 STATUS / NOTIFY copy and centered two-line card — NOT RUN / NOT RELEASED

- Current source: `lib/main.dart` blob `5282fb226c818b8f4601ec89953c0c47ff4861e9`.
- Localization table: `lib/app_settings.dart` blob `562e42c4dc1ee2ac0c15b3f7211e55fa7b11bac6`.
- Regression tests: `test/widget_test.dart` blob `0ebbf0cd03f041a44afa314d66b77278e26c646e`.
- The prior raw `PELTIER_SAFETY_LATCH` suffix is mapped to localized safety guidance. Unknown reason codes fall back to generic English/Indonesian copy; internal identifiers remain diagnostic-only.
- The separate CONNECTED/DISCONNECTED badge is removed. The card keeps a `NOTIFY • category` heading, centers heading/body, grows with content, and wraps long body text to at most two lines without shrinking the font. Short messages remain one line.
- Common unconfirmed-command, connection, and OTA messages use concise bilingual copy. Raw OTA envelopes and legacy result identifiers reach the dedicated localized OTA formatter before generic normalization; raw ERROR/CODE/event identifiers are not user-facing.
- Regression assertions cover bilingual safety/command copy, OTA summaries, removal of the badge/FittedBox, centered two-line layout, and OTA-formatting order. Flutter/Dart tests and analyzer have NOT RUN because this environment has no Flutter/Dart executable.
- These changes are newer than Build #100, are NOT RELEASED, and are not present in the current APK. No App Build/release, Firmware/BIN, Firebase production metadata, physical OTA, flashing, or device action occurred.

## Historical: icon-state redraw included in Build #100

- Build #100 validated the icon redraw using `lib/main.dart` blob `6a008c5c3e5ba7118e948e0b1f36277c01e73529` and `test/widget_test.dart` blob `94dad7a7506fbcbeea63f300ea25b7f32299d471`; its test result was 103/103 Flutter tests passed.
- Battery's unknown pose has a recessed window without fabricated fill; Hotside has a recessed tube/graduations/bulb bezel; Voltage has an inset bolt; Adaptive has reinforced arrows/orbit; Peltier has the faceted crystal and no frozen flakes while inactive; Fan has three blades and three airflow ribbons; Fan Speed has 11 ticks and hides its needle when PWM is unknown.
- The current Notify changes are separate from that released icon redraw. Their new source/tests have NOT RUN / NOT RELEASED and do not appear in Build #100.

## 4. Icon motion and static-state source validated by Build #100

- Build #99 validated the smoothness source: phase-periodic falling particles and boundary fades, 26 dp Home glyph, Peltier crystal motion decoupled from snowfall, and Fan angular velocity with integrated smoothstep and accumulated-phase preservation.
- Build #100 validated the static/unknown-state icon redraw against source main.dart blob 6a008c5c3e5ba7118e948e0b1f36277c01e73529 and test/widget_test.dart blob 94dad7a7506fbcbeea63f300ea25b7f32299d471 with 103/103 Flutter tests.
- Seven static icon poses have stronger definition for OFF/unknown data; Fan retains exactly three blades and three fixed airflow ribbons; Fan Speed needle remains hidden for unknown PWM. This note does not claim real-device animation smoothness.
- The current Notify copy follow-up is separate from those releases; it has not been tested or packaged.
- Real-device appearance, frame timing, BLE/PWM runtime and physical cooling/safety remain UNVERIFIED.

## 5. Source and canonical documentation hashes immediately before this transfer write

- `lib/main.dart`: `5282fb226c818b8f4601ec89953c0c47ff4861e9`
- `lib/app_settings.dart`: `562e42c4dc1ee2ac0c15b3f7211e55fa7b11bac6`
- `test/widget_test.dart`: `0ebbf0cd03f041a44afa314d66b77278e26c646e`
- `DESIGN_NOTES.md`: `45d527c8e38dfa4a0302a753ed6aa85936275f36`
- `APP_NOTES.md`: `9e087872abace197a6d1bbfb338e341a3719f93c`
- `PROJECT_STATE.md`: `24c94493248fe81a025428fdc0f1f853e4d0b1d9`
- `MEMORY_INDEX.md`: `378e9d9fe7eaa081093004aa77677a7e16b097d7`
- `HANDOVER.md`: `6b740a352b659f24114eff90eda6937f88f8e5c2`
- `BUILD_NOTES.md`: `0635faeb83aade3adf37e2a8643c0b8141718d08`
- `APP_BUILD_REPORT.md`: `5197d35a3a4986c6af277c33b091b69aaf69b042`
- `CHANGELOG.md`: `c540d5a903d032bf181dfc73578ffe471af1e091`
- `README.md`: `a68b24c4cda137901193644b7f6ff1173ac15f4d`
- `CHAT_RULES.md`: `58f48fc129fe89e4c563709d04febda451da7de3`
- Build workflow: `9dc1e61ba49f19cad4edbb99a832d5333d9f0f12`
- This transfer blob intentionally is not listed because its future blob SHA cannot be self-referenced.

## 6. Exact next actions and validation gates

1. Re-fetch live main HEAD/tree and source/test/document hashes before the next action.
2. The current STATUS/NOTIFY copy, layout and OTA-formatting changes are committed but NOT RUN / NOT RELEASED. Flutter tests and analyzer still require actual execution.
3. Build #100 remains the latest successful release, source commit `51bea70b2ca17f285bf35c3e547dc44c70f26d59`; it does not contain the current Notify changes.
4. Only after separate @Thinking Eksekusi Build App! authorization, run the official guarded workflow against intended main source and verify tests, analyzer, Android/APK/signature/source-ZIP/download checks and Release/tag/source equality.
5. Do not start App Build under Eksekusi Full. Keep Firmware/BIN/Firebase/OTA/flash/device untouched unless separately authorized.

## 7. Audit / operations not performed

- Inspected live source, localization table, current tests, canonical App/design/state/handover notes, workflow, and latest Build #100 report before editing.
- Committed Home NOTIFY card cleanup (remove connected/disconnected badge, retain `NOTIFY • category`, horizontally centered one/two-line body, content-driven height), bilingual copy refinements, dedicated OTA envelope formatting, and regression source-contract assertions directly to `main`.
- Flutter/Dart tests and analyzer were NOT RUN because no Flutter/Dart executable is installed in this environment. Static GitHub content checks confirmed badge removal, absence of `FittedBox` in `_homeNotify`, two-line/center properties, updated test expectations, and OTA formatting order; this is not test-pass evidence.
- No App Build/release, APK build, release-tag movement, Firmware edit/compile, BIN payload read/write, Firebase metadata change, OTA, flash or device operation occurred.
- Build #100 remains the latest successful artifact and does not contain these notification source/layout changes. Actual Flutter layout, language switching, visible OTA messages, and command classification remain unverified until tests are executed and the new APK is reviewed on-device.
