# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 (Asia/Jakarta) after Build #65. The FPS TimeStats sampling/parser patch and native JUnit gate are now built and CI-tested; actual Shizuku binding, OEM TimeStats visibility, foreground FPS and overlay rendering remain unverified on the target phone.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / `main`. Latest successful App Build: [#65 / run 38851040144](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38851040144); trigger [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Exact source/release target: `f301c1fbbafa3d6c17803d9a2f50bae390dc1343`.
- Build #65 includes TimeStats FPS sampling/parser patch `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620`, four native parser JUnit cases, widget test-contract correction `14347cd731b2c471fea9937f796ca21f8defc261`, and Gradle heap `-Xmx4096M`.
- All release gates passed: App audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, obfuscated release APK, V1/V2/V3 signing and production certificate, matching source ZIP, release publication and re-downloaded asset hash/signature/source-marker checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `646151731`, `54,636,716` bytes, SHA-256 `6823d87dbe25ded3ee5fd399ff231423078f9a33e814d7a80aed8ed1fe1b5b87`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `646151729`, `2,874,038` bytes, SHA-256 `df96a3cf43c860370d776995bff2ef4861ccf9f5e84744b49adb0cdab79d13cc`.
- Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Built and downloaded APK both passed V1/V2/V3 verification with one signer.
- Build #63 had one stale widget assertion (87 passed, 1 failed); Build #64 passed Flutter tests but native JUnit hit `Java heap space` with a 2 GiB Gradle heap. Assertion repair plus 4 GiB heap change are recorded in `APP_BUILD_REPORT.md`. Build #65 passed the full pipeline without removing tests or weakening gates. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Open issue — physical Shizuku FPS still unverified

- User previously reported Shizuku access granted while overlay metric F displayed `F:--`. That screenshot does not prove the exact runtime cause.
- Build #65 includes attempt-scoped tagged Shizuku UserService binding/latch cleanup and TimeStats FPS sampling: bounded `SurfaceFlinger --timestats -dump -clear -maxlayers 64` interval samples every 500 ms, per-layer `averageFPS`, packageName-aware matching, exact layer package fallback and SurfaceView/BLAST preference.
- CI passed Dart analysis, **88/88 Flutter tests**, native parser JUnit tests, Android release compilation/signing, and release asset checks. CI cannot prove the target OEM's UserService binding or TimeStats layer availability.
- Next action: install the Build #65 APK and test floating F as foreground changes between JE Cooler, Settings/launcher, another app and a real game. Capture the Settings sampler-status line and filtered `JexFpsDiag` logs if F remains `--`. Do not infer FPS from panel refresh rate.

## Current Floating Monitor UX

- Position remains freely draggable; horizontal metric groups are centered, vertical rows share the same left edge. Size is 0.30×–1.00× in 0.05× increments (default 0.60×). Background opacity is 0–100% in 5% increments with endpoint labels only; no 50% midpoint. Background color/foreground contrast behavior remains.
- Build #65 passed Dart analysis, 88/88 Flutter tests, native parser JUnit, Android release compilation/signing and release artifact checks. Physical overlay appearance, animation quality, service runtime and live FPS still require device validation.


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
3. Keep Build #65 success plus Build #63/#64 failure/repair records in `APP_BUILD_REPORT.md`. Physical-device FPS/visual validation is the immediate open check; CI does not replace on-device diagnostics.
