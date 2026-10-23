# JE X FYZ / JE Cooler — Current Project State

Last refreshed: 2026-10-23 (Asia/Jakarta), after successful Build #128 release verification. This is current-only state, not history; fetch live HEAD and tree on every new task.

## Product baseline and evidence

- **Latest owner-reported field update:** the owner says Build #128 was installed/overwrote the previously installed App and supplied screenshots/video from that UI. The exact installed APK identity was not independently read from the device. Firmware V7.1 compile/Online OTA remains owner-reported, and the device is not available for routine physical repair.
- **Latest independently verified App release:** [Build #128 / Actions run 39908023440](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39908023440), exact packaged source `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`. Release ID `403010611`; live Release metadata and `refs/tags/jexfyz-latest` target this exact source.
- **APK:** [JEXFYZ-release.apk](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-release.apk), asset ID `668133495`, 54,751,323 bytes, SHA-256 `2f5fdf4ffab0eccac3db886855b34f8c2c6c83afb54d7088fd2f8b578d322c5b`.
- **Corresponding source ZIP:** [JEXFYZ-corresponding-source.zip](https://github.com/TenzoNkz/JEXFYZ-App/releases/download/jexfyz-latest/JEXFYZ-corresponding-source.zip), asset ID `668133492`, 2,877,957 bytes, SHA-256 `9b740671f7e8d3b9d4cfc1b1e5f3200af905ba207d4a6c8a6b27114f39ec32f4`.
- Build #128 passed all 21 workflow gates, **121 Flutter tests**, analyzer (25 informational diagnostics), and the configured Android Gradle gate. Native Android JUnit tasks were NO-SOURCE. APK V1/V2/V3 signing with the expected production certificate, corresponding-source ZIP marker, exactly-one-APK-plus-one-ZIP count, Release/tag parity and downloaded APK/ZIP checksum/source-marker/signature checks passed.
- Build #128 is the latest GitHub App release; the fielded unit remains owner-reported at Build #124 + Firmware V7.1. App CI does not prove Firmware compilation, BIN/source identity, physical OTA apply/reboot, BLE recovery, or thermal/electrical behavior. Preserve remote recovery/safety.

## Durable project-memory / recovery policy

- `TenzoNkz/JEXFYZ-App/main` is the shared project-memory source, but chat transcripts are not automatically synchronized to GitHub. A state is saved only after the relevant document update is committed and verified.
- The two transfer prompts are in `CHAT_TRANSFER_PROMPTS.md`: Prompt 1 for Discussion/general engineering, specifically authorized Eksekusi Full, or recovery of an already-authorized operation; Prompt 2 only for guarded Build App/QC.
- Checkpoint each durable decision, meaningful finding, logical milestone, test result, or blocker. At substantive task completion, update `CHAT_TRANSFER.md` and the relevant canonical note. While Build App progresses, append actual attempts to `APP_BUILD_REPORT.md` and checkpoint the current run in `CHAT_TRANSFER.md`.
- On recovery, load the latest committed checkpoint and current repository/Actions evidence. If interruption happened before a write was committed, treat the unsaved conversation tail as potentially lost; never invent its content or repeat side effects blindly.

## Historical pre-Build repository check — 2026-10-23 (before Builds #125–#128)

- Canonical repository: TenzoNkz/JEXFYZ-App, branch main. At the start of this pre-build audit, live main HEAD was `3234cecd7903f66622e5bf1b14fdb1dfc86fcb82`, commit "docs: checkpoint Home notice localization decision". Its recursive tree contained 69 entries and was not truncated; the live query returned no open pull requests. Documentation-only corrections made during this audit move main beyond that SHA; always fetch the final live HEAD before any future build.
- Active Firmware: firmware/JEXFYZ-V7.1.ino, FW_VERSION="V7.1", source blob c44e076b2c1ee2d0b66b4fcd308d0febc69976e9.
- At this pre-build snapshot, Build #125 / run 39905665853 had failed before runner steps (`runner_id=0`, no runner name, steps/logs/artifacts absent). This was later superseded by Builds #126–#128; the #125 failure remains in APP_BUILD_REPORT.md as historical evidence.
- The owner reported the Actions issue fixed; subsequent live evidence confirmed runner recovery in #126 and a successful complete guarded App release in #128. The guarded issue-only workflow remains unchanged; each future authorized release must still preflight live Actions and verify its exact `head_sha`.
- At that historical checkpoint, Build #124 was the newest verified release and Build #125 produced no package. Current verified release is Build #128 / run 39908023440, source `e4dcbe0e813c2bdc6094814d23d6b1752eafd2d3`; see the current product baseline above and the detailed APP_BUILD_REPORT.md entry.

## Latest App source implementation — validated and released in Build #128

The latest source-only App implementation on main covers:
- Home-matched 360-dp Settings/sub-settings and modal design canvas, with system text scaling disabled.
- Device / Perangkat terminology for user-facing device labels, locked-menu copy, BLE discovery/errors and service notifications.
- Floating Monitor detaches while disconnected and only attaches when the saved enable preference and synchronized connected telemetry permit it. Saved intent survives disconnect or missing overlay permission.
- Alert IDs 2101–2104, persistent BLE foreground ID 2110 and Floating Monitor ID 2301 are distinct; channel IDs remain stable. Channel labels/descriptions synchronize to the selected App language on startup and language change.
- OTA-result messages are formatted using the language selected when displayed. OTA protocol/transport was not edited in that UI change.

Build #128 validated this implementation with 121 passing Flutter tests, Dart analyze exit 0 (25 informational diagnostics), and the configured Android Gradle gate passing. The release package was obfuscated, signed and verified with production V1/V2/V3 checks, and independently matched to the published Release/tag and re-downloaded APK/source ZIP hashes. The fielded unit's Build #124 + Firmware V7.1 status remains USER-REPORTED; CI does not prove installation on the physical unit.

## Open design/validation items

- **New owner UI feedback (2026-10-23; pending source fix):** Settings page and Bluetooth Connection sheet look oversized/zoomed in screenshots/video after Build #128. Source review points to `JexFixedScalePage` in `lib/floating_monitor.dart`: its `constraints.maxWidth / 360.0` scale upscales the entire content above 360 logical dp. Planned fix is a capped 1.0 maximum scale while keeping actual available width at native 1× on wider devices and proportional downscaling only on narrower devices. No source/test/build change has been made for this request; use `Eksekusi Full!` for scoped source/tests, and `Eksekusi Build App!` separately if a new release is desired.
- Home notice heading contract is resolved by owner decision (2026-10-23): use `Notification` in English and `Notifikasi` in Indonesian, following the selected App language. Documentation only; no executable source change or build was authorized.
- Rapid Hotside-rise/slope shutdown plus manual re-arm remains an unimplemented Firmware requirement. Do not imply it is covered by Adaptive Fan tiers or raw-decimal limit safety.
- BLE App-only authorization is BLOCKED / NOT IMPLEMENTED until a trusted backend, device-bound enrollment grant and per-session signature verification are designed/deployed.
- Exact field BIN-to-source identity, installed-version evidence, physical reboot/BLE recovery and thermal/electrical behavior remain independently unverified despite the owner's report.
- Historical reports of resets during a voltage transition and during Adaptive entry have no captured reset reason; brownout remains a hypothesis. Keep the two incidents separate.

## Protected baseline

- Firmware Hotside limit 40–50°C (default 45°C); at or above limit, existing safety forces Fan 100% and Peltier OFF.
- Adaptive Fan tiers relative to limit: delta ≤2°C→100%; 3–4→90%; 5–6→80%; 7–8→70%; 9–10→60%; ≥11→50%. Ramp +10 points/second, −10 points/10 seconds; Adaptive 5 V/9 V remains 100%.
- Preserve NTC one-sample-per-second path, cooperative millis() timing, Touch/P1, voltage/Peltier sequencing, radio ownership and Local/Online OTA recovery.
- Online OTA intentionally uses cloudClient.setInsecure(); server certificate identity is not authenticated. Keep the GitHub BIN allowlist, redirect blocking, response/image/size checks and version+link metadata contract.
- Preserve Android Gradle versionName "Telegram @horizontalzzz".
- No App Build/release, Firmware compile, BIN/Firebase mutation, OTA, flash or device operation was authorized or performed by this documentation rework.
