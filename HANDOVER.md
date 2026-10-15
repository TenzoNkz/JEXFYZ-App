# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-10-16 Asia/Jakarta after Build #58 and post-release FPS diagnostics. The latest diagnostic follow-up is not built; this report separates verified release facts from unbuilt source and runtime unknowns.

## Current App source/release

- Canonical repo/branch: TenzoNkz/JEXFYZ-App / main. Latest successful App Build: [#58 / run 38793790061](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38793790061); trigger [issue #31](https://github.com/TenzoNkz/JEXFYZ-App/issues/31). Exact source/release target: `db11df355780174b1da7dcea4d5947bfa7ba7ca5`, including production repair checkpoint `98cfe7ba4d0e9d569b84498d261ad1b67f66eee7` and test-contract fix `432c30ec538ff7de6c7e77f0c68bac313f4f8015`.
- All required gates passed: security/architecture/license audit, dependency resolution, Dart analysis, **87/87 Flutter tests**, obfuscated release APK, V1/V2/V3 and production certificate verification, matching source ZIP, Release publication and re-downloaded asset identity/hash/signature checks.
- Release [`jexfyz-latest`](https://github.com/TenzoNkz/JEXFYZ-App/releases/tag/jexfyz-latest) contains exactly:
  - [`JEXFYZ-release.apk`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk) — asset `644929744`, `54,636,716` bytes, SHA-256 `88ee4aeadbba20279f36601dcf05e253746ba8189cefb125787db22a1553b2bd`.
  - [`JEXFYZ-corresponding-source.zip`](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip) — asset `644929745`, `2,864,393` bytes, SHA-256 `c331bc2912999dee148922b90018a151a4a355cacc064c0d87653633fe5c4094`.
- Certificate DN `CN=JE X FYZ, OU=JE X FYZ, O=JE X FYZ, L=Indonesia, ST=Central Java, C=ID`; SHA-256 `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`. V1/V2/V3 and downloaded asset signatures verified. Warnings and exact attempt history are preserved in `APP_BUILD_REPORT.md`.
- Build #57 had five stale source-contract assertions; test-only correction preceded Build #58, and no tests/gates were removed or weakened. Build #58 remains the current successful release. Post-release FPS diagnostic changes are in source only and are not in its APK. No Firmware, BIN, Firebase, OTA, flashing or device operation was performed.

## Open issue — Shizuku is granted, but F displays --

- USER-REPORTED screenshot showed Shizuku permission granted and metric F selected while the overlay displayed `F:--`. This proves the overlay and selection are visible, but does not identify whether service, foreground detection or layer sampling failed.
- Build #58 (release source `db11df355780174b1da7dcea4d5947bfa7ba7ca5`) includes the earlier focused-window sampler and guarded frame-delta logic. The user still observed `F:--` on that release.
- Current post-release source checkpoint `becd7f20517fbdaa4bb9922501f28fbed2282223` adds a full `dumpsys window` fallback when `dumpsys window displays` yields no focus, does not report sampler `active` before a valid sample, and shows native statuses such as `foreground_unknown` and `no_layer_data` in Settings. **This checkpoint has not been analyzed, test-run, Kotlin-compiled, or built.**
- Next step after this authorized source execution is the separate `@Thinking Eksekusi Build App!` command. Install the resulting APK and share the status line plus `F:--` outcome. Do not substitute panel refresh rate for measured FPS; Shizuku permission alone does not establish frame-statistics access.


## Current Floating Monitor UX

- Position remains freely draggable; horizontal metric groups are centered, vertical rows share the same left edge. Size is 0.30×–1.00× in 0.05× increments (default 0.60×). Background opacity is 0–100% in 5% increments with endpoint labels only; no 50% midpoint. Background color/foreground contrast behavior remains.
- Build #58 passed Dart analysis, all 87 Flutter tests, Android release compilation/signing and release artifact checks. The post-release diagnostic follow-up is not included in that APK and has not been validated. Physical overlay appearance, animation quality, service lifecycle and live FPS require build/device verification.


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
3. Keep the Build #58 success and Build #57 failure records alongside earlier attempts in `APP_BUILD_REPORT.md`. Physical-device FPS/visual validation is now the immediate open check; CI does not replace on-device diagnostics.
