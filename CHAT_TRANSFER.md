# JE X FYZ / JE Cooler — CHAT TRANSFER SNAPSHOT

Refreshed after the post-Build-#99 static/unknown-state icon redraw on 2026-10-19 (Asia/Jakarta). This is the canonical boot snapshot. Pre-transfer main HEAD/tree below describes live main immediately before this file was replaced. This file is written last and does not self-reference its future commit/blob; fetch final HEAD/tree/blob after committing.

## 1. Authority, repository roles and command protocol

- Canonical editable repository: TenzoNkz/JEXFYZ-App, branch main. Continue directly on main; do not create branches/PRs unless explicitly requested.
- Pre-transfer HEAD: f199e5ec849c435489f1ec9bbcaeb677ba267fb4. Parent: 091ca4451358d3e4cdd99850de07ac93ea89716a. Tree: ecb5c86098dbcd13fd2bb2758f413e800476f299.
- Artifact-only repository: TenzoNkz/JEXFYZ-Firmware must contain exactly JEXFYZ.cpp.bin. Last inspected blob dca6a1267762152519f6d2889e4f0adf46fd8803, 1,457,008 bytes. Only tree metadata was inspected; the payload was not read and source-to-BIN provenance is UNVERIFIED.
- Commands: @Thinking Diskusi! is read-only; @Thinking Eksekusi Full! permits scoped App source/tests/docs/audit/commit but not App Build/Firmware/device actions; @Thinking Eksekusi Build App! alone authorizes the complete official App build/QC/release pipeline; @Thinking Chat Stuck! recovers the existing authorized task without widening scope. Retired aliases are @Thinking Build App!, @Thinking Eksekusi & Build App!, and standalone @Thinking Eksekusi!.
- Build workflow remains .github/workflows/jexfyz-app-build-trigger.yml, blob 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12. It is issue-owner/title/body-token guarded for issues.opened/reopened only. No push/PR/manual bypass.
- Preserve Android Gradle versionName "Telegram @horizontalzzz". User compiles Firmware. No firmware, BIN, Firebase, OTA, flash, or physical-device operations are authorized by Eksekusi Full.

## 2. Latest verified App release

- Latest successful released artifact: Build #99 / Actions run 39230380636, exact packaged source commit bc1498d5b3db7621ee18f5ca6f021e6013c73b09.
- All 21 workflow steps passed. Analyzer exited 0 with 25 info-level findings and no errors/warnings. Flutter test result: 102/102 passed. APK signature/certificate, corresponding source ZIP, asset digests, and Release/tag/source equality passed. Native JUnit tasks were NO-SOURCE, so no native JUnit cases ran.
- APK asset 655835412, 54,702,171 bytes, SHA-256 06a3e4edc7ff911c66cda8b152d4f2acbc11f41b2ccd2f009aa966510aa89096.
- Corresponding source ZIP asset 655835414, 2,860,973 bytes, SHA-256 490ef913574a38fd47644422aa52b11f09c2d47895ba4f3e21db466e47aa8229.
- Release jexfyz-latest and Release metadata match Build #99 source bc1498d5b3db7621ee18f5ca6f021e6013c73b09. Do not manually move the tag.

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

## 4. Smoothness implementation already validated by Build #99

- Build #99 source blob: lib/main.dart 30d864c2f03c40fd4d0b6926a9958153f2a3b236; test blob: test/widget_test.dart 711a44b00eadee2e2bcd24e48383128f0d70ccc9.
- Cycle targets in that release are Battery 1500 ms, Hotside 1650 ms, Voltage 1000 ms, Adaptive 2300 ms, and Peltier 2100 ms. Ember/snow particles use larger geometry, deterministic periodic motion and boundary fades. Whole-icon breathing is removed. Peltier crystal rocking is decoupled from snowfall. Home glyph is 26 dp in the unchanged 38×38 dp tile. Fan rate uses integrated phase with smoothstep retargeting to avoid phase resets.
- These smoothness test results apply to Build #99's exact source. They do not validate the newer static-state redraw above.
- Real-device appearance, real frame timing/profile-mode jank, BLE/PWM runtime, physical cooling/safety and installed device behavior remain UNVERIFIED until inspected on device.

## 5. Source and canonical documentation hashes immediately before this transfer write

- lib/main.dart: 6a008c5c3e5ba7118e948e0b1f36277c01e73529
- test/widget_test.dart: 94dad7a7506fbcbeea63f300ea25b7f32299d471
- lib/jex_animated_glyph.dart: b37fc4e0807c874b2f01db00c7f606810cb5deca
- DESIGN_NOTES.md: 843323637eba2fe60285103dcaffd0a48d5dee8f
- CHANGELOG.md: 89c17be876cb07f263176b8215ebdb758f8bde9d
- APP_NOTES.md: 61da38d8df35ac09d1ce3469f37fb1640191f83d
- PROJECT_STATE.md: 8e36afcc430c87ecb013be6ddc46745484a6d5ea
- MEMORY_INDEX.md: 6b8b05a3b2037f47c256d7a295b6961c4bc4e9bd
- HANDOVER.md: 0198d3d7b1a47164386125364e1fa1e00ccad41d
- BUILD_NOTES.md: 730e70418ceeef139b198afe45beb43c4da4310d
- APP_BUILD_REPORT.md: cec070f40703d797e7d3b49f64d295a9d5f39ba6
- README.md: aad640dd812f7aeddf8d46d3312c54f5da266fa7
- CHAT_RULES.md: 58f48fc129fe89e4c563709d04febda451da7de3
- Build workflow: 9dc1e61ba49f19cad4edbb99a832d5333d9f0f12
- This transfer blob intentionally is not listed because its future blob SHA cannot be self-referenced.

## 6. Exact next actions and validation gates

1. Re-fetch live main HEAD/tree and the current source/test/doc hashes before any further operation.
2. New source/test changes after Build #99 need the separate @Thinking Eksekusi Build App! command to run official analysis, Flutter tests, Android/APK/signing/source-ZIP/release gates and final Release/tag/source equality checks. Do not start that pipeline under Eksekusi Full.
3. Once a later authorized build is verified, update APP_BUILD_REPORT.md and the current-state docs. Do not claim the current redraw has passed tests until that actual run says so.
4. After validation/release, inspect the seven static and animated indicators at real phone size and, when possible, measure profile-mode frame timing. CI does not prove physical smoothness.
5. Keep the firmware repo BIN-only. Do not read or replace BIN, compile/edit Firmware, change Firebase/OTA, flash, or operate devices without separate explicit authorization.

## 7. Audit / operations not performed

- Source and existing Build #99 evidence were inspected live. The seven-icon static/unknown-state source redraw and its regression-test contract are committed to main; related design/current-state/build memory has been reconciled.
- No Flutter/Dart tests or analyzer were run for the newest redraw. Do not claim they passed.
- No new App Build/release, APK build, release-tag movement, Firmware edit/compile, BIN payload read/write, Firebase production metadata change, OTA, flash or device operation occurred.
- Build #99 remains the latest successful artifact and is verified for its exact historical source. This newer source redraw is not in that artifact. Real-device visuals and smoothness remain UNVERIFIED.
