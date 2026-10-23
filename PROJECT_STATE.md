# JE X FYZ / JE Cooler — Current Project State

Last refreshed: 2026-10-23 (Asia/Jakarta), after successful Build #129 release verification. This is current-only state, not history; fetch live HEAD/tree on every new task.

## Product baseline and evidence

- **Latest owner-reported field update:** the owner previously reported installing/overwriting Build #128 and supplied screenshots/video. The exact installed APK identity was not independently read; Build #129 has not been confirmed installed on the physical unit. Firmware V7.1 compile/Online OTA remains USER-REPORTED.
- **Latest independently verified App release:** [Build #129 / Actions run 39925045446](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39925045446), exact packaged source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`. Release ID `403010611`; Release metadata and live `refs/tags/jexfyz-latest` target this exact SHA.
- **APK:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `668498025`, 54,751,323 bytes, SHA-256 `f59c511786d49add8e0596fd3d658248746c008b7eaff94bb6215d314aa0426e`.
- **Corresponding source ZIP:** [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `668498026`, 2,878,916 bytes, SHA-256 `c74e6800dadf80a5223dedcce3144b12f6365506a8b9821bb7abf1817df8cfff`.
- Build #129 passed all 21 workflow gates, **122 Flutter tests**, analyzer (25 informational diagnostics), and the configured Android Gradle gate. Native Android JUnit tasks were `NO-SOURCE`. The APK was obfuscated, signed and verified using V1/V2/V3 with the expected production certificate; matching source ZIP, source marker, exact Release/tag parity and downloaded asset digest/signature checks passed.
- **Validated and released in Build #129:** the Home-equivalent uncapped 360-dp DPI-compensating canvas for Settings root/subpages, Bluetooth Connection and selected modals. Its fixed-physical-viewport regression test passed in hosted CI.
- App CI does not prove physical installation on the shipped unit, real OEM display rendering, BLE/overlay/cooling behavior, Firmware compilation, BIN/source identity, physical OTA or thermal/electrical safety. Preserve remote recovery and safety.

## Durable project-memory / recovery policy

- `TenzoNkz/JEXFYZ-App/main` is the shared project-memory source, but chat transcripts are not automatically synchronized to GitHub. A state is saved only after the relevant document update is committed and verified.
- The two transfer prompts are in `CHAT_TRANSFER_PROMPTS.md`: Prompt 1 for Discussion/general engineering, specifically authorized Eksekusi Full, or recovery of an already-authorized operation; Prompt 2 only for guarded Build App/QC.
- Checkpoint each durable decision, meaningful finding, logical milestone, test result, or blocker. At substantive task completion, update `CHAT_TRANSFER.md` and the relevant canonical note. While Build App progresses, append actual attempts to `APP_BUILD_REPORT.md` and checkpoint the current run in `CHAT_TRANSFER.md`.
- On recovery, load the latest committed checkpoint and current repository/Actions evidence. If interruption happened before a write was committed, treat the unsaved conversation tail as potentially lost; never invent its content or repeat side effects blindly.

## Historical pre-Build repository check — 2026-10-23 (before Builds #125–#129)

- Canonical repository: TenzoNkz/JEXFYZ-App, branch main. At the start of this pre-build audit, live main HEAD was `3234cecd7903f66622e5bf1b14fdb1dfc86fcb82`, commit "docs: checkpoint Home notice localization decision". Its recursive tree contained 69 entries and was not truncated; the live query returned no open pull requests. Documentation-only corrections made during this audit move main beyond that SHA; always fetch the final live HEAD before any future build.
- Active Firmware: firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1", source blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- At this pre-build snapshot, Build #125 / run 39905665853 had failed before runner steps (`runner_id=0`, no runner name, steps/logs/artifacts absent). This was later superseded by Builds #126–#129; the #125 failure remains in APP_BUILD_REPORT.md as historical evidence.
- The owner reported the Actions issue fixed; subsequent live evidence confirmed runner recovery in #126 and successful complete guarded App releases in #128 and #129. The guarded issue-only workflow remains unchanged; each future authorized release must still preflight live Actions and verify its exact `head_sha`.
- At that historical checkpoint, Build #124 was the newest verified release and Build #125 produced no package. At that historical checkpoint the latest release was Build #128; it has since been superseded by Build #129 / run `39925045446`, source `f9ffac6a92917afd73d8d30ab0c5653ed9b67cb4`.

## Build #129 validated App baseline

The latest Build #129 package contains and validates the current App UI contracts:

- Home-matched 360-dp Settings/sub-settings and modal canvas; Home notice heading localized as `Notification` / `Notifikasi`.
- Generic Device / Perangkat copy across lock prompts, BLE discovery/errors and Android service notifications.
- Floating Monitor detaches while disconnected and only attaches when saved enable intent, overlay permission and synchronized BLE/P1 connected telemetry allow it; disconnect does not erase saved enable intent.
- Alert notification IDs 2101–2104, persistent BLE foreground ID 2110 and Floating Monitor ID 2301 are distinct; existing channel IDs remain stable and labels/descriptions follow App language.
- OTA result messages are localized at display time; OTA transport/protocol remains unchanged.

### Home-equivalent DPI canvas — validated/released

- Settings root/subpages, Bluetooth Connection sheet and selected modals use `JexFixedScalePage` with uncapped `constraints.maxWidth / 360.0`, fixed 360-dp logical child, scale-adjusted design height/media insets, an outer `OverflowBox` before one `Transform.scale`, then viewport clipping.
- Relevant commits: source `d0f87b09c96a89063dc3b6f8c23e763bd11dc66e`, density regression test `f680837ad61653fbda071bb8f451ccd4113acfaf`, contract comment `cf0b66d6c5cf131d55aa99783fa3518274275d57`.
- Build #129's full Flutter suite passed 122/122 tests, including the test that holds physical viewport 1080×2400 constant while simulating 420-dp and 320-dp logical widths, with expected 360×800 logical canvas and scale factors 420/360 and 320/360.
- Dart analyzer exited 0 with 25 info-level diagnostics. The configured Android Gradle gate passed; native Android JUnit tasks were `NO-SOURCE`. APK obfuscation, V1/V2/V3 production certificate, corresponding ZIP/source marker, Release/tag parity and downloaded assets were verified.
- **Not validated by CI:** local `dart format` was not run because Flutter/Dart are absent locally; physical-device/OEM density rendering, BLE/overlay behavior and hardware/OTA performance are not proven by widget tests or App CI. Build #129's field installation is not independently confirmed.

## Open design/validation items

- **Physical Settings/Connection layout:** hosted DPI regression widget test passed in Build #129; real-device/OEM rendering across display size/density remains untested.
- **New compact visual sizing request (2026-10-23; Discussion only):** owner confirms the Home-equivalent fixed-DPI canvas is correct at 420-dp and 350-dp logical widths, but Settings and the Bluetooth Connection UI still look too large. Next authorized UI source task should keep the master scale unchanged and reduce base typography/spacing/icons about 10%: Settings AppBar 20→18, row labels ~13 dp, summaries 12→11, icons 21→19, vertical padding 13→10; Connection header 18→16 and 66→60 high, status text 10.5→9.5, Devices 14→13, message 13→12. Retain full-width cards, theme/language/BLE behavior and ≥40-dp interactive targets. No source/test/build change has been made for this new request.
- Home notice heading contract is settled: use `Notification` in English and `Notifikasi` in Indonesian, following selected App language.
- Rapid Hotside-rise/slope shutdown plus manual re-arm remains an unimplemented Firmware requirement; it is not covered by existing Adaptive Fan tiers or raw-decimal limit safety.
- BLE App-only authorization remains BLOCKED / NOT IMPLEMENTED until trusted backend enrollment/signing and Firmware verification exist.
- Exact field BIN-to-source identity, whether Build #129 is installed on the sold unit, physical reboot/BLE recovery, and thermal/electrical behavior remain independently unverified.

## Protected baseline

- Firmware Hotside limit 40–50°C (default 45°C); at or above limit, existing safety forces Fan 100% and Peltier OFF.
- Adaptive Fan tiers relative to limit: delta ≤2°C→100%; 3–4→90%; 5–6→80%; 7–8→70%; 9–10→60%; ≥11→50%. Ramp +10 points/second, −10 points/10 seconds; Adaptive 5 V/9 V remains 100%.
- Preserve NTC one-sample-per-second path, cooperative millis() timing, Touch/P1, voltage/Peltier sequencing, radio ownership and Local/Online OTA recovery.
- Online OTA intentionally uses cloudClient.setInsecure(); server certificate identity is not authenticated. Keep the GitHub BIN allowlist, redirect blocking, response/image/size checks and version+link metadata contract.
- Preserve Android Gradle versionName "Telegram @horizontalzzz".
- Build #129 App Build/release validated and packaged this source/test change. No Firmware compile, BIN/Firebase mutation, OTA, flash or device operation occurred.
