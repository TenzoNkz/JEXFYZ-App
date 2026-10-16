# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 (Asia/Jakarta) after Build #66. The Shizuku binding-timeout repair is now included in the latest verified APK; actual UserService binding on the phone, OEM TimeStats visibility, foreground FPS and overlay rendering remain unverified.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / `main`. Latest successful App Build: [#66 / run 38859288444](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38859288444); trigger [issue #33](https://github.com/TenzoNkz/JEXFYZ-App/issues/33). Exact release source: `a2b19d4708f3075730132ac16f375f2a352aa50a`, includes timeout fix `34880ba490bfbd0d38c4b10ab69a683ca7b4a29d`.
- Build #66 includes the 35-second native UserService bind deadline and 50.4-second Settings status wait, plus the TimeStats FPS sampling/parser patch `f527b5ec82b7a3e4f563eb28f4ac50438ed6b620`, four native parser JUnit cases and Gradle heap `-Xmx4096M`.
- All release gates passed: App audit, dependencies, Dart analysis, **88/88 Flutter tests**, native `:app:testDebugUnitTest`, obfuscated release APK, V1/V2/V3 signing and production certificate, matching source ZIP, release publication and re-downloaded asset hash/signature/source-marker checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `646344237`, `54,636,716` bytes, SHA-256 `cae0364670324511551742295a40fc4208399a5de4330b5a18d5d43ca5d488cf`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `646344244`, `2,874,306` bytes, SHA-256 `9a3a008e377fa6bdcc7d4add2fecbce9167df88b2b0ce924512ca703e5eeac69`.
- Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. Built and downloaded APK passed V1/V2/V3 verification with one signer.
- Build #63/#64 Flutter/JUnit failures and evidence-based repairs are recorded in `APP_BUILD_REPORT.md`; Build #66 passes every gate without removing tests or weakening gates. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## Open issue — physical Shizuku FPS still unverified

- User previously reported Shizuku access granted while overlay metric F displayed `F:--` and later `shizuku_userservice_timeout`. These screenshots do not prove the precise runtime cause.
- Build #66 includes attempt-scoped tagged Shizuku binding, TimeStats sampling, and the timeout repair: `FPS_USER_SERVICE_BIND_TIMEOUT_MS = 35_000L`, with Settings polling for 50.4 seconds. Flutter tests, four native parser JUnit cases, Android release compilation/signing and downloaded release asset checks passed.
- The 35-second deadline aligns with Shizuku's 30-second startup allowance plus callback grace, but successful build/CI does not prove that the target phone's UserService binds or that its OEM exposes usable TimeStats layer data.
- Next action: install [Build #66 APK](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) and test foreground F across JE Cooler, Settings/launcher, another app and a real game. If F remains `--`, capture the Settings sampler status and filtered `JexFpsDiag` logs, especially `bind_requested`, `bind_timeout`, `user_service_started` and `bind_connected`. Do not infer FPS from panel refresh rate.

## Current Floating Monitor UX

- Position remains freely draggable; horizontal metric groups are centered, vertical rows share the same left edge. Size is 0.30×–1.00× in 0.05× increments (default 0.60×). Background opacity is 0–100% in 5% increments with endpoint labels only; no 50% midpoint. Background color/foreground contrast behavior remains.
- Build #66 passed Dart analysis, 88/88 Flutter tests, native parser JUnit, Android release compilation/signing and release artifact checks. Physical overlay appearance, animation quality, service runtime and live FPS still require device validation.


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
3. Keep Build #66 success plus Build #63/#64 failure/repair records in `APP_BUILD_REPORT.md`. Physical-device FPS/visual validation is the immediate open check; CI does not replace on-device diagnostics.
