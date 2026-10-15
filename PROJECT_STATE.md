# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-10-15 (Asia/Jakarta). Live source is authoritative; this header reflects the Shizuku FPS migration recovery.

## Latest published App Build/QC — SUCCESS for older source; current source NOT BUILT
- **Last successful App Build:** [Build #49 / run 38739077916](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38739077916), built from `2b2d2886abb66481b7134e5036824f625ab5659d`. All 80 Flutter tests and APK/release/signature/source/download gates passed for that older revision.
- **Current implementation checkpoint:** `b4e4ec7e8d6c00f43e5378dcb7e2e4b7731adf4b` plus docs-only follow-ups. This is the thermal/Home UI plus Shizuku-gated FPS source; current source is **NOT RUN / NOT BUILT / NOT RELEASED**.
- **Current source hashes:** main.dart `3eeb4dff7b7fbb52a44022e5e2b130bc1826da23`; Floating UI `232fde06efda5bfaa2221825a04c0106ad5feb33`; app settings `6f99911bc59451473823aea91efe5377a0b6d0d1`; widget test `520399fcdc6be4fd69cb48f50aa8961f5d9183c5`; Shizuku FPS contract `bd27d2c7adc20ab76bab504378a2353d01ab473b`.
- **FPS gate:** metric F requires Shizuku Binder/API availability and explicit user approval. FPS reads use a fixed-operation AIDL UserService; the normal app process does not run dumpsys and the manifest no longer declares `android.permission.DUMP`. Wireless ADB pairing/Kadb/SPAKE2/identity/grant-revoke paths are removed.
- **Validation status:** current widget/contract tests, Dart analysis and Android/Kotlin compilation have NOT run. Shizuku startup, permission dialog, UserService binding and actual in-game FPS remain unverified.
- **Published Release:** `jexfyz-latest` still contains Build #49's APK (asset `643896939`, SHA-256 `d365a99812470986de08be4df1bd54254fe1eb1ea1e3739806d03a6503e3c52a`) and matching source ZIP (asset `643896917`, SHA-256 `51783b82eae47fc69ab08dd90521e5acdeed0988600042dd1bc3b94f5483dbc8`). Neither includes current source.
- **Build workflow:** `.github/workflows/jexfyz-app-build-trigger.yml`, blob `585d190324e522fc08e66cc95bd7ee80c5f37664`. Issue-open/reopen + owner/title/token gate is unchanged; updated Shizuku/MIT audit and source packaging have not run in CI.
- **Firmware boundary:** `firmware/JEXFYZ-V6.6.ino` blob `f51ba6db5d0e91318f63fea4014bb87f7bf76222`. V6.6 remains user-accepted final; no Firmware/BIN/Firebase/OTA/flash/device changes are authorized by this task.

## Current V6.6 Firmware behavior

### Rail transition / Peltier ramp
- If Peltier is logically OFF, rail changes must not turn it ON.
- Adaptive ON/OFF still returns the selector to safe 5 V, but does not force Peltier OFF solely for the handoff. The existing voltage handler pauses only an active soft-start; a completed ramp remains at 100%. Explicit OFF and Hotside/NTC/OTA safety still override.
- During a normal Manual Volt or Adaptive transition accepted while the 5-second soft-start is active, pause GPIO5 PWM at 0% before selector outputs change; preserve 200 ms break-before-make; remain paused during the existing 1-second settle; then start a fresh full 5-second ramp.
- When the 5-second ramp is complete, keep Peltier PWM at 100% continuously through the transition; do not force 0% or add another ramp just because voltage changes.
- Fan stays ON/forced 100% during the handoff. Peltier-OFF, Hotside/NTC safety and OTA safe-output cancel pending ramp resume.
- User reported a restart when changing 5 V→12 V with Peltier/Fan ON during active soft-start. Supply transient/brownout is unconfirmed; collect BOOT: RESET_REASON=... if reproduced.
- A separate earlier user report described a restart when enabling Adaptive at 12 V with Peltier/Fan already ON; exact reset reason and any shared root cause are unknown. Do not merge the two reports into one confirmed cause.

### LED mode and App/firmware synchronization
- Firmware V6.6 supports Static (1), Breath (2), Comet (4), Dual Chase (5), Left/Right (6), and Rainbow (7). ID 3 is retired; persisted ID 3/invalid values migrate to Static, and new mode-3 commands are rejected.
- Firmware publishes one `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` tuple calculated at BLE notify time; App interpolates monotonically between snapshots and corrects drift without restarting the animation for every update.
- LED preview uses a compact row: left arrow, four left pixels, centered localized mode name only (no numeric index), four right pixels and right arrow. Static/Rainbow cores remain full-colour independently of hardware Brightness. Comet/Dual Chase use pale neutral pixels where the animation has no active LED; selected colour and glow follow the animation phase. The 36-preset localized Color Picker remains a separate menu but opens in the display-menu region instead of screen center; hue ordering, aliases and no-HEX presentation remain unchanged.
- The full Flutter test suite and Dart analyze passed in App Build run `38556896542` on pre-signing-fix commit `67c5d26723c433b4af856c7759a967a3425bf67a`, including the existing `test/v6_6_qc_contract_test.dart`; this does not prove physical runtime behavior. User reports Firmware V6.6 compiled successfully and Online OTA was flashed/updated twice with the same V6.6 version and considers Firmware final. Source-to-artifact BIN provenance remains unverified; do not initiate new Firmware operations unless requested.

### Thermal / Adaptive safety
- Hotside limit: 40–50°C, default 45°C; NTC is authoritative.
- One calibrated ADC sample per second. No median/trimmed/multi-sample filter.
- Manual Peltier re-arm needs Hotside <= hotLimit - 1°C for 5 continuous seconds.
- Adaptive protection: 30-second stage at 12 V/9 V/5 V, Peltier OFF and Fan 100%; five stable seconds at/below hotLimit - 1°C before deadline cancels stage; otherwise step down one rail at 12/9 V or enter terminal manual-restart lock at unrecovered 5 V.
- After thermal step-down, one-step upward restoration needs 60 continuous seconds at/below hotLimit - 1°C, capped by the saved pre-downshift ceiling.
- V6.6 does not implement rapid Hotside rise/slope protection. A previous user request for immediate Peltier shutdown/manual re-arm on very rapid temperature rise is preserved as an unimplemented requirement, not current functionality.
- HOTSIDE is startup default; HOTSIDE_BATTERY is runtime-only. Battery loss falls back to HOTSIDE behavior without silently changing profile.

### OTA
- V6.3-origin correction remains in V6.6: Online OTA uses cloudClient.setInsecure(); embedded CA validation and OTA-only NTP/TIME_SYNCING gate are absent.
- Blue feedback after Wi-Fi connection leads into GitHub GET. Raw GitHub BIN URL allowlist, redirect blocking, status/length/size/image checks, safe outputs, update lifecycle and failure recovery are protected.
- Boot Local OTA SoftAP currently owns the single radio with a 10-second no-client timeout and 60-second hard limit after interaction; Wi-Fi shuts down and settles 160 ms before BLE owns the radio. This is a source-derived timing contract and must not be retuned during unrelated changes.
- setInsecure() bypasses server certificate identity validation; this is a known security trade-off.
- User reported the prior V6.3 source compiled and GitHub connection recovered. Full download/apply, restart and installed-version confirmation remain unverified.
- Read both OTA memory documents before any related edit.

## Phone Battery input / App display requirements

- [SOURCE VERIFIED] App reads Android Battery temperature through `je_x_fyz/battery_temp` and sends `PHONE:BT=<Celsius>` at a one-second heartbeat while BLE is ready; pending heartbeat messages are coalesced.
- [SOURCE VERIFIED] Firmware Battery input has a 5-second freshness TTL and 0.5°C Battery-zone hysteresis. Current configured zone defaults are 5 V = 25°C and 12 V = 35°C. If Battery data becomes stale, HOTSIDE_BATTERY runtime control falls back to HOTSIDE without silently changing the selected profile.
- [USER REQUIREMENT] Do not display a standalone Battery Protection Guard badge/status in App UI. Do not weaken thermal safety or suppress independently actionable, localized safety/Notify messages.
- [USER DESIGN REQUIREMENT / ENFORCEMENT UNVERIFIED] Pairing intent is one authorized App identity/key-lock relationship per cooler firmware. Current source proves encrypted/bonded writes but exclusive one-App provisioning/lock and physical pairing behavior are not established here.

## Current App contracts
- Firmware telemetry owns physical state; ACK alone is not proof of hardware state.
- Voltage completion requires matching VOLTAGE telemetry.
- Home/dashboard and Floating Monitor telemetry show unknown values (`--`) while BLE is disconnected. CONTROL/ADAPTIVE/LED menu switch rows instead show a disabled OFF-looking fallback toggle positioned left; this is presentation only and must not be interpreted as physical output telemetry.
- Auto Connect/reconnect respects preference, known cooler identity, Bluetooth/permission/location prerequisites and syncing state.
- Ambiguous OTA ACK timeout/disconnect preserves recovery state until reconnect/result; only definite rejection while BLE remains connected permits rollback.
- User-facing text is localized; internal protocol tokens are not exposed.
- Android notifications now use `R.drawable.ic_notification`, a bold white JE vector monogram on transparent background, as the sole small icon; no large icon is set. Event/status remains the localized body beneath the JE X FYZ title, tap opens the App, and BLE/Floating Monitor foreground notifications retain meaningful non-empty descriptions. Android 13+ asks for permission at the first actual notification attempt.
- Touch Adaptive-OFF publishes authoritative Adaptive/ceiling/Fan/Peltier/Fan-speed state deltas before acknowledgement.

## Current App implementation and validation boundary

- Current `main` retains seven Home indicators and thermal/color animations, staged Color Picker, Floating Monitor orientation/telemetry replay, and Shizuku-gated FPS access.
- Metric F cannot be selected unless Shizuku is running, Binder/API supports UserService, and the user explicitly approves JE X FYZ in Shizuku. Native `FloatingMonitorService` independently checks access and relays only fixed FPS operation IDs through `IFpsShizukuUserService`; `FpsShizukuUserService` maps those IDs to fixed Activity/SurfaceFlinger reads.
- Wireless ADB pairing/identity-store source, Kadb/SPAKE2 dependencies/licenses, manifest DUMP permission, manual ADB grant/revoke UI and old ADB pairing test are removed.
- Official workflow audits the Shizuku provider/request-permission/UserService/AIDL contract and packages the Shizuku API/provider 13.1.5 MIT notice. It has not run on current source.
- Current source checkpoint `b4e4ec7e8d6c00f43e5378dcb7e2e4b7731adf4b` is NOT RUN / NOT BUILT / NOT RELEASED. Build #49 validates older source only. `@Thinking Chat Stuck!` did not trigger a build.
- Physical Shizuku startup/permission/Binder/UserService behavior, actual in-game FPS, overlay lifecycle, BLE/cooling/safety and installed-device state remain unverified. No Firmware/BIN/Firebase/OTA/flash/device operation occurred.

## App Build and Thinking command protocol
- Canonical commands: `@Thinking Diskusi!`; Gemini subcommands only as `@Thinking Diskusi! Tanya Gemini!` or `@Thinking Diskusi! Jawaban Gemini!`; full execution `@Thinking Eksekusi Full!`; end-to-end App build `@Thinking Eksekusi Build App!`; emergency recovery `@Thinking Chat Stuck!`.
- Standalone `Eksekusi!` and `Eksekusi & Build App!` are retired. A Gemini subcommand without `Diskusi!` in the same command is invalid and its substantive request must not be answered.
- Current build-report register: `APP_BUILD_REPORT.md`. Build attempts, repairs, run links, validation, APK checksum and remaining blockers must be written there for cross-chat continuity.
- Build App context-limit continuity: use Prompt D in `CHAT_TRANSFER_PROMPTS.md` once as the first message in the replacement Build App chat. It LOADs live state and continues the existing work; no separate recap chat/prompt. Prompt A is only for broad project-memory reconciliation.
- Build #49 verified source commit `2b2d2886abb66481b7134e5036824f625ab5659d`. Thermal-animation source commit `8b58c7033a5462864b52cb921ca25c714bca902f` followed after that release and has not been built; documentation-only commits do not trigger App Build.
- Only active workflow: `.github/workflows/jexfyz-app-build-trigger.yml`; explicit owner/title/token issue trigger only.
- Latest successful run is still Build #49, with all 80 Flutter tests and release gates passed for source commit `2b2d2886abb66481b7134e5036824f625ab5659d`. Current source commit `8b58c7033a5462864b52cb921ca25c714bca902f` contains thermal animations and has not been tested or built; Build #36 remains historical.
- Keep one obfuscated, production-signed ordinary APK named `JEXFYZ-release.apk` on release tag `jexfyz-latest`; no Play Store bundle or Actions artifact.
- Trigger title: `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`; body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`.
- Toolchain: Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- The `@Thinking Eksekusi Build App!` operation must inspect and follow the active manual issue-trigger workflow, repair/retry App-scope failures, verify the final release asset and record every attempt in `APP_BUILD_REPORT.md`. It must report BLOCKED rather than claim success if required external access or separate authorization is unavailable.
- Firmware remains out of scope. The user accepts Firmware V6.6 as final; do not compile Firmware, generate/replace BIN, edit Firebase, flash hardware or run physical OTA without separate explicit authorization.

## Exact validation gates still open
1. After a new, separately authorized current-source Build App passes, install its release APK and recheck MT Manager's signature display. Build #36 predates the current Home UI and Wireless ADB changes and must not be treated as their validation.
2. On device, verify Fan OFF ease-out/full colour; box-free full-colour Peltier OFF; Fan Speed interpolation through repeated changes including a mid-transition retarget, ON wobble seam and OFF-to-zero; voltage sheen and Bluetooth ripple loop boundaries.
3. Verify Color Picker staged selection/Select/Cancel/outside/back behavior; Floating Monitor orientation/telemetry replay; Shizuku startup, explicit permission approval, UserService binding, Binder loss/revocation and foreground-game FPS across OEMs; no stale telemetry when starting overlay, changing apps or losing BLE. Source-contract assertions exist but have not run.
4. Preserve no-standalone Battery Protection Guard UI, one-second phone Battery heartbeat/five-second Firmware freshness TTL, and exclusive one-App/one-cooler pairing as unverified enforcement.
5. Firmware V6.6 is user-accepted as final after two reported same-version successful Online OTA updates. Do not edit/compile Firmware or operate BIN/Firebase/OTA/flash unless the user explicitly reopens that work and separately authorizes it.

## Repository split / operation boundary
- All source and memories live in TenzoNkz/JEXFYZ-App.
- TenzoNkz/JEXFYZ-Firmware must contain JEXFYZ.cpp.bin only; its notes were removed during this cleanup and the BIN was not touched. The last observed artifact root contains only the BIN; verify its live path/blob before any future publication.
- Latest source changes include staged Color Picker selection, the seven-icon Home animation / Notify-label redesign, Floating Monitor foreground SurfaceFlinger FPS/telemetry recovery, notification-driven Wireless ADB pairing for FPS DUMP setup, Android Keystore-encrypted per-install ADB identity storage, and updated contract assertions. Build #36 (`893393388b99fc6d9e59c420070a159a29e45e9a`) succeeds for earlier source only; Wireless ADB and Home UI updates remain NOT BUILT and tests NOT RUN.
