# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-10-14 (Asia/Jakarta). This file is current-only; refresh the live repository before relying on it. History belongs in CHANGELOG.md; exact pre-cleanup copies are in archive and must not be treated as current.

## Current release phase
- **Phase:** DEVELOPMENT + QC / PRE-RELEASE.
- **Release state:** NOT RELEASED.
- **Active Firmware source:** firmware/JEXFYZ-V6.6.ino.
- **Firmware constant:** FW_VERSION = "V6.6".
- **Firmware source blob last observed:** f51ba6db5d0e91318f63fea4014bb87f7bf76222.
- **Active App source:** `lib/main.dart`, current blob `2005f4c163d466f9015a564d5418af1e86e09b41`.
- **Package/version:** com.horizontalzzz.jexfyz, pubspec 1.0.0+3.
- **Android identity:** Gradle versionName "Telegram @horizontalzzz"; intentional, preserve exactly.
- **QC contracts:** test/v6_6_qc_contract_test.dart, test/firmware_touch_adaptive_sync_test.dart, test/app_protocol_notify_contract_test.dart, test/widget_test.dart. Test execution must be checked independently.
- **Current App/UI hashes:** `lib/main.dart` = 2005f4c163d466f9015a564d5418af1e86e09b41; `lib/app_settings.dart` = 232a7575460e5417f7b760f24b5057687a47ee1a; `test/widget_test.dart` = 3af190d4520a7b753f3f9fc963f788f4aa247f5c; `test/v6_6_qc_contract_test.dart` = 2bee4d960d014f0765422dcb5ed1c9870ba6ee3a; `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt` = 6c17a7e38c3a5b3f3f8fc6b3e5b38a99fd83081e; `JeForegroundService.kt` = 9ea4dce7001bcd5cc10f9c1c7ad62f34ec54b03e; `FloatingMonitorService.kt` = 55972b64329a2e1cc91e29a172d0a97a118d8ac1; `JexNotificationUtils.kt` = aecfc87121f2195ef6724613c612d674ed95ae55; `drawable/ic_notification.xml` = cda9e8404d14a62a61157ec59fae2e491c19f5f7.
- **Workflow:** .github/workflows/jexfyz-app-build-trigger.yml; explicit title/token trigger only.
- **User-confirmed Firmware acceptance (2026-10-14):** user considers V6.6 correct/final and reports successful compilation plus two successful Online OTA flashes/updates using the same V6.6 version. Do not change/recompile/reflash Firmware unless the user explicitly reopens Firmware work and separately authorizes the operation. Source-to-artifact BIN provenance remains independently unverified, but is not an active work item by itself.
- Do not infer that the existing artifact BIN matches current V6.6 source; source/BIN provenance remains unverified.
- Latest checked open-PR search returned zero results. Fetch live state before acting.

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

## Current UI execution status
- Current App source includes phase-continuous Fan animation, geometric Peltier frost crystal/fades, resized dialogs, and the transparent JE notification icon.
- Build App run `38556896542` on pre-signing-fix commit `67c5d26723c433b4af856c7759a967a3425bf67a` passed Dart analyze and Flutter tests for that App source, plus release download verification. Device appearance remains unverified.
- Signing log reported V1=false, V2=true, V3=true. The workflow was hardened at commit `90d48ec3c97318b5aff4e147151eee96e41b5b25` to force/check V1 plus V2/V3; this workflow change has NOT been build-verified. Existing release has not yet been replaced with an APK built under the updated gate.

## App Build
- Only active workflow: `.github/workflows/jexfyz-app-build-trigger.yml`.
- Latest successful App Build before signing-workflow hardening: run `38556896542` on commit `67c5d26723c433b4af856c7759a967a3425bf67a` (https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38556896542). Security/architecture audit, dependency install, Dart analyze, Flutter tests, APK build, signing, release publication and downloaded-asset verification passed. Release `jexfyz-latest` targets that commit with one `JEXFYZ-release.apk` (54,521,947 bytes; SHA-256 `95e8c9460b69b8c58d183c2bb80102590cf6208c9a48008ba4dc3bf74e5fbd38`). However, its `apksigner` output reported V1=false, V2=true and V3=true. The new V1 gate in workflow blob `0e400cbdedfd54506ae3ac3255da41580c86d750` is not yet tested; no APK built under that fix exists.
- Trigger title: JE X FYZ — BUILD APP TRIGGER; body token JEXFYZ_BUILD_TRIGGER_V1.
- Toolchain: Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- Intended output: one obfuscated, production-signed ordinary APK `JEXFYZ-release.apk`, uploaded to GitHub Release `jexfyz-latest`; no Play Store bundle or Actions artifact.
- Do not trigger except explicit `@Thinking Build App!` or `@Thinking Eksekusi & Build App!`.

## Exact validation gates still open
1. After explicit `@Thinking Build App!` authorization, run the updated manual App Build workflow and require `apksigner` V1, V2 and V3=true for both the built APK and re-downloaded release asset; verify the expected certificate digest and release SHA.
2. Install that newly built APK and check its signature in MT Manager. The screenshot's installed-package `Last update` is 17:11 on 2026-10-14, before run `38556896542` finished at 18:36 Asia/Jakarta, so the shown installed copy predates the latest release.
3. Physically inspect Fan phase transitions/coast-down, geometric Peltier frost fade, notification icon, and dialog sizing after installing the current APK.
4. Firmware V6.6 is user-accepted as final after reported successful compilation and two same-version Online OTA updates; no further Firmware edit/compile is planned unless the user reports a new issue or explicitly reopens Firmware work.

## Repository split / operation boundary
## Repository split / operation boundary
- All source and memories live in TenzoNkz/JEXFYZ-App.
- TenzoNkz/JEXFYZ-Firmware must contain JEXFYZ.cpp.bin only; its notes were removed during this cleanup and the BIN was not touched. The last observed artifact root contains only the BIN; verify its live path/blob before any future publication.
- This execution changed the App Build signing-validation workflow and reconciled project notes. No App Build was run after the workflow change; no Firmware compile, BIN generation/replacement, Firebase update, physical OTA/flash, or release publication was performed here.
