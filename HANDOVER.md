# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 Asia/Jakarta after Build #62. The Shizuku UserService lifecycle/source-test checkpoint is now included in the successful APK; physical FPS, service binding on the target phone and overlay visuals remain unverified.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / `main`. Live reconciliation verified five branches and zero open PRs. Latest successful App Build: [#62 / run 38841458441](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38841458441); trigger [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Exact source/release target: `42a72d863b10adfb5d6a0ee332a2f879a78173a4`, including Shizuku binding lifecycle checkpoint `225cc9ae4c67b3fbb76426db3b2503ef6934aaae` and test-only contract repair. Changes after this source SHA are documentation-only.
- All release gates passed: App audit, dependency resolution, Dart analysis, **88/88 Flutter tests**, obfuscated release APK, V1/V2/V3 and production certificate verification, matching source ZIP, Release publication and re-downloaded asset identity/hash/signature checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `645909183`, `54,636,716` bytes, SHA-256 `f71a971aad4face7df78f9cdc1ee82f8d47c4700d9d05692fc77a24deaca6b37`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `645909184`, `2,871,177` bytes, SHA-256 `61a22a8a7319a1be8b9cc8a7d2c39ab485ffa5c462946e23d745e333d76ab087`.
- Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. V1/V2/V3 and downloaded APK signatures verified.
- Build #61 exposed one stale widget-test assertion (87 passed, 1 failed); Build #62 includes the source-contract correction, then passed the full 88-test suite and all release gates. No test was deleted or weakened. Full attempt history lives in `APP_BUILD_REPORT.md`. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Open issue — physical Shizuku FPS still unverified

- User previously reported Shizuku permission granted while overlay metric F displayed `F:--`. This still does not prove the precise runtime cause.
- Build #62 includes attempt-scoped tagged Shizuku UserService binding, a connection/latch per attempt, late-callback-safe cleanup, explicit bind/timeout/dead-Binder/remote-call failures, filtered lifecycle/command/foreground/layer/sample logs, and cleanup protection against starting a new bind only to disable capture after Binder failure.
- Current release source was analyzed, **88/88 Flutter tests passed**, Android-built and production-signed. Release target is `42a72d863b10adfb5d6a0ee332a2f879a78173a4`. The actual target device/OEM is not available to CI; successful build is not proof that Shizuku binds or SurfaceFlinger exposes usable layer statistics.
- Next action: install the Build #62 APK and test the floating F metric as foreground changes among JE Cooler, Settings/launcher, other apps and a real game. Capture the Settings sampler-status line and filtered `JexFpsDiag` logs if F remains `--`. Do not substitute panel refresh rate for foreground FPS.

## Current Floating Monitor UX

- Position remains freely draggable; horizontal metric groups are centered, vertical rows share the same left edge. Size is 0.30×–1.00× in 0.05× increments (default 0.60×). Background opacity is 0–100% in 5% increments with endpoint labels only; no 50% midpoint. Background color/foreground contrast behavior remains.
- Build #62 passed Dart analysis, all 88 Flutter tests, Android release compilation/signing and release artifact checks, including the Shizuku lifecycle patch. Physical overlay appearance, animation quality, service runtime and live FPS still require device validation.


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
3. Keep Build #62 success and Build #61 failure/repair records in `APP_BUILD_REPORT.md`. Physical-device FPS/visual validation is the immediate open check; CI does not replace on-device diagnostics.
