# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 Asia/Jakarta during FPS-removal execution. Build #69 remains the latest verified release, but active main source is being simplified beyond that release and is not yet built.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / main. Latest successful App Build: [#69 / run 38896502185](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38896502185); trigger [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Exact source/release target: `01212c32a802ca0e67f559307fe4e19a667489c6`. This is a documentation-only advancement over functional App source from Build #67 `8efbfebe1b12e162dccddbdf68b8627d8723f756`.
- All 21 release gates passed: App audit, dependency resolution, Dart analysis, **88/88 Flutter tests**, native TimeStats parser/watchdog-policy JUnit tests, obfuscated APK, V1/V2/V3 and production certificate verification, matching source ZIP, Release publication and re-downloaded asset hash/signature checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `647189019`, `54,636,716` bytes, SHA-256 `40e2f3233d94cb8f624a3ffc50677f058840057800b8b1a172ba0eaf2881a102`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `647189016`, `2,877,171` bytes, SHA-256 `1ab19e552c128d09773794738a6a4340abfa82086fa83f2d7e883ed62f60a699`.
- Expected certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Built and downloaded APKs passed V1/V2/V3 and one-signer checks.
- Build #69 re-ran the functionally unchanged source from Build #68; four TimeStats parser JUnit tests, five watchdog-policy JUnit tests and all 88 Flutter tests passed. Build #63/#64 failures and repairs remain in `APP_BUILD_REPORT.md`. No tests or gates were removed/weakened; no Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Current App source change — FPS retired

- The user decided to remove FPS instead of continuing device-specific sampler diagnosis after repeated F:-- failures. The current source targets six Floating Monitor metrics: B/H/V/A/P/F; F is Fan Speed. The Shizuku card, SurfaceFlinger sampler, permission bridge, provider/dependency, AIDL/UserService, FPS-specific tests and Shizuku-only license files are removed from current source.
- Legacy persisted schema v1 mapped F to FPS and S to Fan Speed. Schema v2 discards old FPS F and migrates old S to Fan Speed F, so an old FPS selection cannot be displayed as a fan-speed reading.
- Source edits, regression tests, workflow audit and current-state documentation have been committed, but have not yet been verified by Flutter/Dart/native CI or an APK build. Build #69 is earlier and its APK still contains FPS.
- Next release action, when separately authorized: @Thinking Eksekusi Build App! The existing guarded issue-trigger workflow must verify the native Kotlin compile gate, Dart analysis/tests, security audit, source archive, signing and Release assets. No Firmware/BIN/Firebase/OTA/flash/device operation is part of this source-change task.

## Current Floating Monitor UX

- Six metrics only: B/H/V/A/P/F, with F for Fan Speed. FPS has been removed from active source.
- Position remains freely draggable; horizontal metric groups are centered, vertical rows share the same left edge. Size is 0.30×–1.00× in 0.05× increments (default 0.60×). Background opacity is 0–100% in 5% increments with endpoint labels only; no 50% midpoint.
- Current six-metric source has NOT BEEN BUILT or device-verified. Build #69 evidence applies to earlier source.

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

1. Complete the FPS-removal source commit and static cross-file audit; verify main contains no active FPS/Shizuku components and no stale seven-metric contract.
2. Run App Build only after the separate @Thinking Eksekusi Build App! command. Use the existing guarded issue-trigger workflow; do not introduce push/PR release triggers.
3. Keep Firmware V6.6, the BIN-only artifact repo, Firebase metadata, OTA and physical hardware untouched.
