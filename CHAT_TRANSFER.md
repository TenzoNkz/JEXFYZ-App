# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after the Home STATUS / NOTIFY localization source follow-up on 2026-10-19 (Asia/Jakarta). This is the canonical boot snapshot. The pre-transfer HEAD/tree below describes live main immediately before this final transfer write. This file is written last and does not self-reference its future commit/blob; fetch final HEAD/tree/blob after committing.

## 1. Authority, repository roles and command protocol

- Canonical editable repository: TenzoNkz/JEXFYZ-App, branch main. Continue directly on main; do not create branches/PRs unless explicitly requested.
- Pre-transfer HEAD: e7c8248fcf8892e9cfab8c095771ad60123c1437. Parent: 29467546690c3d78bb12d2a24c154331c47ebbd1. Tree: d4d9f2c8cc16165cfdf4448d5a48dffa3e373cf2.
- Artifact-only repository: TenzoNkz/JEXFYZ-Firmware must contain exactly JEXFYZ.cpp.bin. Last inspected blob dca6a1267762152519f6d2889e4f0adf46fd8803, 1,457,008 bytes. Only tree metadata was inspected; the payload was not read and source-to-BIN provenance is UNVERIFIED.
- Commands: @Thinking Diskusi! is read-only; @Thinking Eksekusi Full! permits scoped App source/tests/docs/audit/commit but not App Build/Firmware/device actions; @Thinking Eksekusi Build App! alone authorizes the official App build/QC/release pipeline; @Thinking Chat Stuck! recovers the authorized task without widening scope. Retired aliases: @Thinking Build App!, @Thinking Eksekusi & Build App!, and standalone @Thinking Eksekusi!.
- Build workflow remains .github/workflows/jexfyz-app-build-trigger.yml, blob 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12. It is guarded to issues.opened/reopened with repository owner/title/body token only. No push/PR/manual bypass.
- Preserve Android Gradle versionName "Telegram @horizontalzzz". User compiles Firmware. No firmware, BIN, Firebase, OTA, flash, or physical-device operations are authorized under Eksekusi Full.
- Current task scope is Home STATUS / NOTIFY wording/localization. Code and tests are committed after Build #100; tests/analyzer/build are NOT RUN for this follow-up. Build #100 remains the latest successful release.

## 2. Latest verified App release

- Latest successful released artifact: Build #100 / Actions run 39237262140, exact packaged source commit 51bea70b2ca17f285bf35c3e547dc44c70f26d59.
- All 21 workflow steps passed. Analyzer exited 0 with 25 info-level findings and no errors/warnings. Flutter test result: 103/103 passed. APK signature/certificate, corresponding source ZIP, downloaded asset digests, and Release/tag/source equality passed. Native JUnit tasks were NO-SOURCE.
- APK asset 655957943, 54,718,555 bytes, SHA-256 a59c0a37b2025ad2b250bd4354b887379d96658e9f7757692691fa23b7b4d0a2.
- Corresponding source ZIP asset 655957946, 2,862,476 bytes, SHA-256 e60c4705097009d843b624bf8f0f989770a76aba6fdfbdd8d2159d77f98890f1.
- Release jexfyz-latest and Release metadata match Build #100 source 51bea70b2ca17f285bf35c3e547dc44c70f26d59. Do not manually move the tag.

## 3. Current post-Build-#100 notification text/localization follow-up — NOT RUN / NOT RELEASED

- Current source: lib/main.dart blob 931b7e2d074b1006622b0f83cc6db3f8ce43a400.
- Localization table: lib/app_settings.dart blob e91ecd2a00eafdec3f681daabb74fd49fcd25bf2.
- Regression tests: test/widget_test.dart blob ff419072b6eca1f3dc2c932b6290e3d664f75c17.
- The screenshot's raw message “The device did not confirm the Peltier change. PELTIER_SAFETY_LATCH” is addressed by central localized reason mapping and removal of raw code concatenation. Known safety tokens map to clear English/Indonesian instructions; unknown underscore tokens use generic localized copy or are removed. Raw tokens remain diagnostic-only.
- Peltier safety re-arm wording now explains the threshold/action in concise localized text without changing the existing threshold formula or firmware predicate.
- Home category labels are short: STATUS / STATUS, CONNECTION / KONEKSI, SYNC / SINKRONISASI, WARNING / PERINGATAN, ERROR / ERROR.
- Common unconfirmed-command/failure text is normalized by action and language. The error badge also recognizes unconfirmed outcomes in English and Indonesian.
- New regression assertions cover Peltier latch text in both languages, voltage-failure copy, known and unknown reason tokens, concise localized labels and command-confirmation error classification.
- This source/test update is newer than Build #100. Tests and analyzer are NOT RUN; the new text behavior is NOT RELEASED/NOT in the APK. Existing Build #100 remains the latest successful artifact.

## 3. Current post-Build-#99 icon-state redraw — NOT RUN / NOT RELEASED

- New source: lib/main.dart blob 6a008c5c3e5ba7118e948e0b1f36277c01e73529.
- New regression test source: test/widget_test.dart blob 94dad7a7506fbcbeea63f300ea25b7f32299d471.
- This source update reworks the static/idle/disconnected appearance of all seven indicators. It is newer than Build #99 and is not packaged in the current APK/source ZIP. Tests and analyzer have NOT RUN for these newer source/test blobs.
- Battery: recessed dark inner window with a small neutral thermal emblem when the value is unknown; never fabricate a live numeric fill. Valid reading and falling-fire behavior keep existing telemetry/warning gates.
- Hotside: complete tube/bulb silhouette, recessed tube, fixed graduations and bulb bezel in idle/unknown state; live temperature column only when data is valid.
- Voltage: shadowed/inset bolt face and static inner luminous core; travelling current and branch strikes remain state-gated; semantic colours remain 5V red, 9V green, 12V blue.
- Adaptive: stronger two-arrow circular mark with a recessed orbit track; arrows move only under the existing authoritative ON gate; no idle spinner.
- Peltier: stronger beveled six-arm snowflake/crystal with faceted centre; falling flakes are not drawn as frozen stray particles when the existing active-state gate is false.
- Fan: exactly three swept blades, three fixed airflow ribbons, recessed bearing ring, per-blade highlights and layered hub. Existing voltage/PWM policy and phase-continuous retargeting are preserved.
- Fan Speed: semicircle with recessed bezel, 11 graded scale ticks and layered pivot. Needle remains hidden when PWM/value is unknown, expired, or disconnected.
- The redesign does not change BLE protocol/telemetry, warning predicates, voltage/PWM mapping, Adaptive controls, RGB, safety behavior, Home card/tile layout, or Floating Monitor. Floating Monitor stays letters-only B/H/V/A/P/F, with F = Fan Speed. Unknown state must never be fabricated as zero/OFF/active.

## 4. Icon motion and static-state source validated by Build #100

- Build #99 validated the smoothness source: phase-periodic falling particles and boundary fades, 26 dp Home glyph, Peltier crystal motion decoupled from snowfall, and Fan angular velocity with integrated smoothstep and accumulated-phase preservation.
- Build #100 validated the static/unknown-state icon redraw against source main.dart blob 6a008c5c3e5ba7118e948e0b1f36277c01e73529 and test/widget_test.dart blob 94dad7a7506fbcbeea63f300ea25b7f32299d471 with 103/103 Flutter tests.
- Seven static icon poses have stronger definition for OFF/unknown data; Fan retains exactly three blades and three fixed airflow ribbons; Fan Speed needle remains hidden for unknown PWM. This note does not claim real-device animation smoothness.
- The current Notify copy follow-up is separate from those releases; it has not been tested or packaged.
- Real-device appearance, frame timing, BLE/PWM runtime and physical cooling/safety remain UNVERIFIED.

## 5. Source and canonical documentation hashes immediately before this transfer write

- lib/main.dart: 931b7e2d074b1006622b0f83cc6db3f8ce43a400
- lib/app_settings.dart: e91ecd2a00eafdec3f681daabb74fd49fcd25bf2
- test/widget_test.dart: ff419072b6eca1f3dc2c932b6290e3d664f75c17
- DESIGN_NOTES.md: 08ae374ea1215490c958ffef1f683993e2359485
- APP_NOTES.md: e54eb3a350b41eae1a5b3a41e1ba0041946b5f21
- PROJECT_STATE.md: 8e4a2b9f79e52478e18410dc5d1d3b597e366862
- MEMORY_INDEX.md: 5d496f0c1c0348dbab94dbe323d6559543462aca
- HANDOVER.md: c3f9be0d5458d914bc741ea3fa4258bb2df2b7fe
- BUILD_NOTES.md: f9e54f97b23bb7eba83591383bc61f02e9d28fb3
- APP_BUILD_REPORT.md: f4163a44824e20eafc209c9ae376fe1c8accee32
- CHANGELOG.md: 9808efafe69aaa334a4da8cf77d7829099b35efa
- README.md: 433b13352d633c8e96203fb9d0e7ba5710e81ed7
- CHAT_RULES.md: 58f48fc129fe89e4c563709d04febda451da7de3
- Build workflow: 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12
- This transfer blob intentionally is not listed because its future blob SHA cannot be self-referenced.

## 6. Exact next actions and validation gates

1. Re-fetch live main HEAD/tree and current source/test/doc hashes before the next operation.
2. The notification text/localization source update is committed but NOT RUN / NOT RELEASED. Its regression tests and analyzer still need actual execution.
3. After separate @Thinking Eksekusi Build App! authorization, run the official guarded workflow against the intended main source; verify all Flutter tests, analyzer, Android/APK/signature/source-ZIP/download checks and Release/tag/source equality.
4. Do not start App Build under Eksekusi Full. Do not claim the new notification fix passed tests until the authorized run reports it.
5. Keep Firmware/BIN/Firebase/OTA/flash/device untouched unless separately authorized.

## 7. Audit / operations not performed

- Inspected live source, localization table, existing tests and latest Build #100 report before editing.
- Committed notification normalization, known reason-code mapping, professional English/Indonesian failure copy, concise status headings and regression assertions to main.
- No Flutter/Dart tests or analyzer were run for the current notification follow-up. Do not claim them passed.
- No App Build/release, APK build, release-tag movement, Firmware edit/compile, BIN payload read/write, Firebase metadata change, OTA, flash or device operation occurred.
- Build #100 remains the latest successful artifact and does not contain these notification source changes. Real-device copy wrapping, language switching and displayed error classification remain unverified until tested on-device.
