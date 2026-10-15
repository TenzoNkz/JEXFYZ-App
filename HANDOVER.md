# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 00:04 Asia/Jakarta against live main. This report separates verified repository/CI state from runtime unknowns.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / main. Parent HEAD before this documentation reconciliation: 329fd18e3c6ced8f43a7dbfaf7bf02206c17d42a, recursive tree 80 entries, not truncated. Five branches; zero open PRs; one active workflow.
- Latest successful App Build #54, run 38767611593, source commit 437e7730dbcaf9666ae4828e546a45343bb4890c. All 86 Flutter tests passed, Dart analysis passed, obfuscated APK compiled, V1/V2/V3 and certificate gates passed, source ZIP validated, Release published and both downloaded assets hash-verified.
- Release tag jexfyz-latest contains exactly:
  - JEXFYZ-release.apk, asset 644438898, 54,636,716 bytes, SHA-256 cdf8a7f94424b9cb60be6e04489a9f0f0d8ddad43ab76c33c2e2c6333fa61327.
  - JEXFYZ-corresponding-source.zip, asset 644438897, 2,862,590 bytes, SHA-256 3b208c987def59a7c1857ed0fcc9ca5d74d591767e5658dfab04c9c1be85450f.
- Source hashes: main.dart 72c450d9b1e8783e4b82b8e37a5f39e2d49b6289; floating_monitor.dart 05a61e5670ec09c9c46cf60466a1dd301dfe5352; app_settings.dart 46cc838f43a06c325af6f6832e200a4e1ed4f75d; widget test 520399fcdc6be4fd69cb48f50aa8961f5d9183c5; floating layout contract 31d9aabf4ac0839855308b6bd2a0708fa399a3a9; Shizuku FPS contract 798633a24907fd8aca567e70a6376dc59c6e41c9.
- Build failures #50–#53 and their repairs remain in APP_BUILD_REPORT.md; Build #54 is the first complete pass after them. CI success is not a physical-device test.

## Open issue — Shizuku is granted, but F displays --

- USER-REPORTED screenshot: Shizuku status reads “Shizuku permission granted”; floating metrics show F:-- while B:41.5°, H:31.3°, V:12V, A:OFF, P:OFF, S:100.
- The screenshot displays the JE Cooler Floating Monitor settings screen in the foreground. In live code, pollSurfaceFlinger() explicitly stops reporting a candidate FPS value when the foreground package equals JE Cooler's own package and sets no_game_foreground. That is a plausible explanation consistent with the screenshot, not a proven cause.
- “Permission granted” confirms the Shizuku permission layer only; it doesn't prove UserService binding/execution, focused-activity parsing, SurfaceFlinger access, or a matching game layer. No device status dump/logcat has been supplied.
- Next device diagnostic: leave Floating Monitor enabled and launch an actual game so the game, not JE Cooler's settings page, is foreground. If F remains --, capture native fps_monitor_status and logs for shizuku_userservice_unavailable/disconnected/error, surfaceflinger_blocked, dumpsys_timeout, foreground_unknown, no_game_foreground, no_layer_data or waiting_for_frames. Do not substitute refresh-rate for Game FPS.
- No functional source fix or new build was part of this Chat Stuck/docs-reconciliation authorization. Shizuku UserService binding and actual in-game FPS remain device/OEM-unverified. No Gemini was consulted; connector discovery did not find a Gemini app.

## Current Floating Monitor UX

- Position remains freely draggable; text group/rows are centered inside the box. Size 0.30×–0.80× with numbers/default 0.60×; background Opacity 0–100% with 0/50/100 marks; persisted Black/White background; contrasting text/icons; compact gaps and radius.
- These source contracts are included in Build #54, but actual installed-device rendering, drag gestures, service lifecycle and FPS remain separate from CI.

## Firmware/hardware boundary

- Active source: firmware/JEXFYZ-V6.6.ino; blob f51ba6db5d0e91318f63fea4014bb87f7bf76222; FW_VERSION="V6.6"; exactly one versioned active .ino.
- User accepts V6.6 as final and reports compiling it plus two same-version Online OTA updates. Those events are USER-REPORTED, not assistant-witnessed; source-to-BIN provenance remains UNVERIFIED. No Firmware edit/compile, BIN generation/publication, Firebase metadata change, physical OTA/flash or device operation is authorized/performed here.
- Pin map: GPIO0 NTC; GPIO1 TTP223; GPIO3 12V selector; GPIO4 9V selector; GPIO5 Peltier MOSFET PWM; GPIO6 Fan MOSFET PWM; GPIO7 WS2812. NTC nominal 10k with 10k divider and Beta3950; calibrated ADC reading, one sample/sec. Full safety/timing memory lives in FIRMWARE_NOTES.md and VOLTAGE_TRANSITION_MEMORY.md.

## OTA, command, and repository rules

- OTA remains protected. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier changes. Online OTA's setInsecure bypasses server-certificate identity checks; CA and NTP gates were removed together after a user report, but the single cause was not isolated. Never infer a precise HTTP/TLS error from red/blue LED feedback.
- Artifact repo live tree verified to contain only JEXFYZ.cpp.bin, blob 68167e65d26137eeb1ce4d6d4ba798dc282454e6, size 1,455,936 bytes.
- App repo owns source and all notes/memory. Preserve Android Gradle versionName "Telegram @horizontalzzz". Use main directly; no branch/PR unless requested.
- @Thinking Diskusi! is read-only. @Thinking Eksekusi Full! does not imply App Build. @Thinking Eksekusi Build App! is the only App Build command; Chat Stuck does not broaden authorization. No Firmware build, BIN/Firebase/OTA/flash/device action without separate explicit permission.

## Canonical next actions

1. First, test FPS with an actual game in the foreground while Floating Monitor remains enabled.
2. If F stays --, capture exact fps_monitor_status plus native logs before proposing a source fix. Do not immediately rebuild without diagnostic evidence.
3. Keep the successful Build #54 record and failed #50–#53 history. A new full build/release requires the explicit Build App command.
