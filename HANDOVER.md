# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 Asia/Jakarta after Build #55. This report separates verified repository/CI state from runtime unknowns.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / main. Build #55 used source commit `3ba172b3f35f4ec01732d5848a7ffc807663e710`; functional source/test checkpoint is `311a18934a3cbe86a2a4718442c92541f081183f`. Commits between are documentation-only.
- Latest successful App Build: [#55 / run 38783100421](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38783100421); [trigger issue #28](https://github.com/TenzoNkz/JEXFYZ-App/issues/28). All required workflow gates passed, including 86/86 Flutter tests, Dart analysis, obfuscated release APK, V1/V2/V3 and production certificate verification, matching source ZIP, Release publication and re-downloaded asset identity/hash checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset 644735661, 54,538,412 bytes, SHA-256 `1ae3ef476c170ab0a9d78a77264c5281d60341a931db102c7b8645e4b0dadd19`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset 644735668, 2,860,630 bytes, SHA-256 `112b14a95f4b21fa04cdd5684e4a0124ee4b50cb17636bcef149e71a20481dce`.
- Live source fingerprints: `lib/main.dart` `69eef38d26282b94ad1bea297d812dfd8b9e91e3`; `lib/floating_monitor.dart` `f3ba1518e9f5158cd7f7a1fccac8df0fbac3b2fb`; `lib/app_settings.dart` `4c89bcb3c04142ce49440a11b92054365c26f7a6`; `test/widget_test.dart` `2426eecea66a357d63ce10214a2d331224c81e37`; floating layout test `7f861d449e518af68fc4ece7278241aa3ce8691b`; Shizuku FPS test `798633a24907fd8aca567e70a6376dc59c6e41c9`; native service `dd10ff0b2c23941badaa33949967fc373f98aeb9`.
- Non-blocking analyzer deprecation, dependency, Gradle/Kotlin, DWARF and JAR metadata/signing warnings are in `APP_BUILD_REPORT.md`. Device rendering, actual Shizuku service behavior and OEM screen-FPS availability remain unverified; CI alone does not settle the earlier `F:--` report.


## Open issue — Shizuku is granted, but F displays --

- USER-REPORTED screenshot showed Shizuku permission granted while metric F showed `--` with JE Cooler settings foreground; no device status dump/logcat has been captured.
- Build #55 now includes a focused-window sampler for JE Cooler, foreground apps, launcher, Settings and Android system UI when matching SurfaceFlinger layers are exposed. A present layer with no new presented-frame delta can report 0 after its baseline; `--` remains possible when identity/layer/access is unavailable.
- Run #55 built and test-verified the source, but does not prove Shizuku UserService binds/runs on the target phone or that this OEM exposes the expected SurfaceFlinger layer. Next device check: keep Floating Monitor enabled, switch through JE Cooler, Settings/launcher, another app and an actual game; if F stays `--`, capture `fps_monitor_status` and native logs. Do not substitute panel refresh rate for measured FPS.


## Current Floating Monitor UX

- Position remains freely draggable; horizontal metric groups are centered, vertical rows share the same left edge. Size is 0.30×–1.00× in 0.05× increments (default 0.60×). Background opacity is 0–100% in 5% increments with endpoint labels only; no 50% midpoint. Background color/foreground contrast behavior remains.
- Current source passed Build #55 analysis, 86 Flutter tests, Android compilation/signing and release artifact checks. Physical overlay appearance, drag gestures, service lifecycle and FPS values still require device validation.


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
3. Keep the successful Build #55 record and failed #50–#53 history. Physical-device FPS/visual validation is now the immediate open check; a future build/release requires the explicit Build App command.
