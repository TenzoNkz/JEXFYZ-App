# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 Asia/Jakarta after Build #69 and recovery of the latest App Build command. Build #69 verified the current functionally unchanged App source through the full release gates. Physical foreground FPS, target-phone Shizuku binding and overlay visuals remain unverified.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / main. Latest successful App Build: [#69 / run 38896502185](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38896502185); trigger [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Exact source/release target: `01212c32a802ca0e67f559307fe4e19a667489c6`. This is a documentation-only advancement over functional App source from Build #67 `8efbfebe1b12e162dccddbdf68b8627d8723f756`.
- All 21 release gates passed: App audit, dependency resolution, Dart analysis, **88/88 Flutter tests**, native TimeStats parser/watchdog-policy JUnit tests, obfuscated APK, V1/V2/V3 and production certificate verification, matching source ZIP, Release publication and re-downloaded asset hash/signature checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `647189019`, `54,636,716` bytes, SHA-256 `40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `647189016`, `2,877,171` bytes, SHA-256 `1ab19e552c128d09773794738a6a4340abfa82086fa83f2d7e883ed62f60a699`.
- Expected certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Built and downloaded APKs passed V1/V2/V3 and one-signer checks.
- Build #69 re-ran the functionally unchanged source from Build #68; four TimeStats parser JUnit tests, five watchdog-policy JUnit tests and all 88 Flutter tests passed. Build #63/#64 failures and repairs remain in `APP_BUILD_REPORT.md`. No tests or gates were removed/weakened; no Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Open issue — physical Shizuku FPS still unverified

- User previously reported Shizuku permission granted while overlay metric F displayed `F:--`, and an earlier status was `shizuku_userservice_timeout`. These symptoms do not establish the runtime cause.
- Current release includes attempt-scoped Shizuku UserService binding, 35-second client deadline, 50.4-second Settings polling, TimeStats parsing, exception-isolated sampling and startup/polling-progress watchdogs. Startup watchdog is 60 seconds; polling-stall watchdog is 30 seconds. Source/tests are built and CI-tested, but CI cannot prove service binding or layer visibility on the target OEM.
- Next action: install Build #69, then test the floating F metric while switching foreground among JE Cooler, Settings/launcher, other apps and a real game. If F remains `--`, capture Settings sampler status and filtered `JexFpsDiag` logs, including `sampler_exception`, `sampler_watchdog_timeout`, bind/layer/frame events. Do not substitute panel refresh rate for measured foreground FPS.

## Current Floating Monitor UX

- Position remains freely draggable; horizontal metric groups are centered, vertical rows share the same left edge. Size is 0.30×–1.00× in 0.05× increments (default 0.60×). Background opacity is 0–100% in 5% increments with endpoint labels only; no 50% midpoint.
- Build #69 passed Dart analysis, all 88 Flutter tests, native parser/watchdog JUnit tests, Android release compilation/signing and release artifact verification. Phone-side rendering, animation quality, service lifecycle and live FPS remain NOT DEVICE-VERIFIED.

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
3. Keep Build #69 success and Build #63/#64 failure/repair records in `APP_BUILD_REPORT.md`. Physical-device FPS/visual validation is the immediate open check; CI does not replace on-device diagnostics.
