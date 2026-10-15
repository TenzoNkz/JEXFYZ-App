# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 Asia/Jakarta after Build #60. The FPS diagnostic source is now built and CI-tested; physical FPS and visual behavior remain unverified.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / main. Latest successful App Build: [#60 / run 38817543342](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38817543342); trigger [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Exact source/release target: `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3`, including FPS diagnostic patch `6e9b4c73db12c51f4452717d8cf102f49d325dcf` and test-contract fix `7a576e60f0938cec94fcddb96340cd5376fa15de`.
- All release gates passed: security/architecture/license audit, dependency resolution, Dart analysis, **88/88 Flutter tests**, obfuscated release APK, V1/V2/V3 and production certificate verification, matching source ZIP, Release publication and re-downloaded asset identity/hash/signature checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `645381550`, `54,636,716` bytes, SHA-256 `47892215de179c8cb2975ad5c99b8b3b1398559873352411ed74d001aa001274`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `645381553`, `2,866,092` bytes, SHA-256 `dd9bdc1f8082c70ab2ff73892f5434057d36cedc870fd92184b8ed579e2b538a`.
- Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. V1/V2/V3 and downloaded asset signatures verified.
- Build #59 exposed one outdated FPS source-contract assertion; test-only correction was committed before Build #60. No test or gate was removed or weakened. Warnings and exact attempt history are in `APP_BUILD_REPORT.md`. No Firmware, BIN, Firebase, OTA, flashing or device operation was performed.

## Open issue — Shizuku is granted, but F displays --

- USER-REPORTED screenshot showed Shizuku permission granted and metric F selected while the overlay displayed `F:--`. This proves the overlay and selection are visible, but does not identify whether service, foreground detection or layer sampling failed.
- Build #58 had the earlier focused-window sampler and guarded frame-delta logic; the user still observed `F:--` on that release.
- Build #60 source `b5f00a1b3690d62c11772a91bd3a6732bb0d4bf3` includes diagnostic checkpoint `6e9b4c73db12c51f4452717d8cf102f49d325dcf`: full `dumpsys window` fallback when `dumpsys window displays` yields no focus, `starting` until valid sample, `0 FPS` after two matching layer snapshots with valid zero delta, counter-reset diagnostics, stale poll cancellation on retry and native status feedback in Settings. Dart analysis, 88/88 Flutter tests, Android release build and signing/release verification passed. Actual FPS/runtime remains unverified.
- Next step is on-device validation of Build #60. Install the resulting APK and share the status line plus `F:` outcome while switching through JE Cooler, Settings/launcher, another app and an actual game. Do not substitute panel refresh rate for measured FPS; Shizuku permission alone does not establish frame-statistics access.


## Current Floating Monitor UX

- Position remains freely draggable; horizontal metric groups are centered, vertical rows share the same left edge. Size is 0.30×–1.00× in 0.05× increments (default 0.60×). Background opacity is 0–100% in 5% increments with endpoint labels only; no 50% midpoint. Background color/foreground contrast behavior remains.
- Build #60 passed Dart analysis, all 88 Flutter tests, Android release compilation/signing and release artifact checks. Physical overlay appearance, animation quality, service lifecycle, Shizuku runtime and live FPS still require device validation.


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
3. Keep Build #60 success plus Build #59 test failure and repair records in `APP_BUILD_REPORT.md`. Physical-device FPS/visual validation is the immediate open check; CI does not replace on-device diagnostics.
