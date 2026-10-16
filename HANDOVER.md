# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 Asia/Jakarta after Build #67. The sampler exception-isolation/watchdog checkpoint is included in the successful APK and passed the Flutter and native JUnit gates. Physical FPS, target-phone Shizuku binding and overlay visuals remain unverified.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / main. Latest successful App Build: [#67 / run 38890997565](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38890997565); trigger [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Exact source/release target: `8efbfebe1b12e162dccddbdf68b8627d8723f756`, including sampler watchdog checkpoint `946171c8f8f4db0899cd0cb1ec8bb0fcc53aad46` and prior Shizuku binding/timeout fixes.
- All release gates passed: App audit, dependency resolution, Dart analysis, **88/88 Flutter tests**, native TimeStats parser and watchdog-policy JUnit tests, obfuscated release APK, V1/V2/V3 and production certificate verification, matching source ZIP, Release publication and re-downloaded asset identity/hash/signature checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `647067767`, `54,636,716` bytes, SHA-256 `40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `647067768`, `2,877,328` bytes, SHA-256 `4b5403d27d74167cd2c15ca6c5eb780d9622b5be0924c42c04256e240d9545cd`.
- Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. V1/V2/V3 and downloaded APK signatures verified.
- Build #66/#65 history plus Build #63/#64 failures/repairs remains in `APP_BUILD_REPORT.md`. Build #67 passed the same full gates after adding the watchdog and updated source contracts; no test/gate was removed or weakened. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Open issue — physical Shizuku FPS still unverified

- User previously reported Shizuku permission granted while overlay metric F displayed `F:--`, and a prior status was `shizuku_userservice_timeout`. These are runtime symptoms, not proof of the exact cause.
- Current release contains attempt-scoped tagged Shizuku UserService binding, 35-second client deadline, 50.4-second Settings poll wait, TimeStats sampler exception isolation and a main-handler watchdog. The watchdog reports startup stall at 60 seconds and polling stall at 30 seconds and has five unit tests.
- Build #67 source was analyzed, **88/88 Flutter tests passed**, four TimeStats parser JUnit and five watchdog policy JUnit cases passed, and Android release compilation/signing + downloaded asset verification succeeded. CI cannot prove target phone/OEM binding or usable TimeStats access.
- Next action: install Build #67 APK and test the floating F metric across JE Cooler, Settings/launcher, other apps and a real game. If F remains `--`, capture the exact Settings sampler-status line and filtered `JexFpsDiag` logs, including `sampler_exception`, `sampler_watchdog_timeout`, `bind_requested`, `bind_connected`, `layer_match` and `frame_sample`. Do not infer FPS from panel refresh rate.

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
3. Keep Build #67 success and Build #63–#66 failure/repair records in `APP_BUILD_REPORT.md`. Physical-device FPS/visual validation is the immediate open check; CI does not replace on-device diagnostics.
