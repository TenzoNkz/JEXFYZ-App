# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-10-15 (Asia/Jakarta). This file is current-only; refresh the live repository before relying on it. History belongs in CHANGELOG.md; exact pre-cleanup copies are in archive and must not be treated as current.

## Current App Build/QC blocker
- **Latest release-trigger attempt:** Build #48 / [run 38735820460](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38735820460), source commit `608a394f1b764ad8759ce240eafc90b6b9dd2c59`, triggered by issue [#21](https://github.com/TenzoNkz/JEXFYZ-App/issues/21). Job `116424719108` failed in ~4 seconds; steps endpoint returned `[]` and logs returned `BlobNotFound`. No test, analysis, APK build/signing or release step ran.
- **Same runner-start symptom:** Builds #41–#45 and new Build #48 failed before any workflow step. Earlier jobs explicitly reported `runner_id=0`; #48 has the same empty-step/no-log pattern, although its runner ID was not exposed by the connected job reader. #46/`38722953908` and #47/`38723038530` were skipped by the guard, not build attempts. Diagnostic probes #1/#2 on Ubuntu 24.04/22.04 also failed pre-step; their workflow has been deleted. Root cause remains unconfirmed.
- **Last run to execute steps:** Build #40 / [run 38713854518](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/38713854518) passed the audit, dependencies, Dart analysis, **80 Flutter tests**, obfuscated APK build, V1/V2/V3 signing and production certificate validation, then failed on the old SPAKE2 source path assertion. The active workflow blob `5c5af03075f87297a31f5ee26f0e42025f05977b` checks the corrected path; no post-fix run has reached steps.
- **Release remains NOT RELEASED for current source:** tag `jexfyz-latest` still contains only Build #36's older APK (source commit `893393388b99fc6d9e59c420070a159a29e45e9a`); it excludes current Wireless ADB pairing and Home UI changes. Release publication and downloaded APK/source SHA validation have not passed for current main.
- **Source/license route:** retain Kadb 1.3.0 and Wireless ADB; the official workflow includes the GPL-3.0 notice in APK assets and packages the matching App + third-party source ZIP beside exactly one APK. This route has not passed the complete release gates; see `APP_BUILD_REPORT.md` for run IDs and evidence.
- **Next action:** Build #48 was the one isolated trigger test using the renamed workflow/title/token, and it still failed before steps without a log. Do not trigger again without new evidence. Inspect Actions usage/spending cap, repository Actions permissions/allowed actions, and account security/verification restrictions. If normal, escalate runs #41–#45 and #48 (job `116424719108`) to GitHub Support. Reattempt only after runner dispatch is demonstrably restored or new account-specific evidence supports one isolated attempt.
## Current release phase
- **Phase:** DEVELOPMENT + QC / PRE-RELEASE.
- **Release state:** NOT RELEASED.
- **Active Firmware source:** firmware/JEXFYZ-V6.6.ino.
- **Firmware constant:** FW_VERSION = "V6.6".
- **Firmware source blob last observed:** f51ba6db5d0e91318f63fea4014bb87f7bf76222.
- **Active App source:** `lib/main.dart`, current blob `74b6bcc47d69ccf114f710ed73dfcefe93037111`.
- **Package/version:** com.horizontalzzz.jexfyz, pubspec 1.0.0+3.
- **Android identity:** Gradle versionName "Telegram @horizontalzzz"; intentional, preserve exactly.
- **QC contracts:** test/v6_6_qc_contract_test.dart, test/firmware_touch_adaptive_sync_test.dart, test/app_protocol_notify_contract_test.dart, test/widget_test.dart. Test execution must be checked independently.
- **Current App/UI hashes:** `lib/main.dart` `74b6bcc47d69ccf114f710ed73dfcefe93037111`; `lib/floating_monitor.dart` `bd230aee16fa77a0d8d2afb9f1a0c2d80cdcac86`; `lib/app_settings.dart` `c513cd4381ee960cd43612c4ac01e7954f651f62`; `test/widget_test.dart` `98c0c11d1c39b48cb5fc6657c3a0ca7d677b2d1b`; `test/adb_pairing_contract_test.dart` `03609184edc5b2df09f40e62ffe99959ea337bad`; `MainActivity.kt` `f7340e82a12cece063e310546dcba893e6a5a09f`; `WirelessAdbPairingService.kt` `7f2099cac0c78008d395ec0bb83e32e5f6d55384`; `WirelessAdbIdentityStore.kt` `394eab93a17c563caf7db0511d4d36040c1c59ec`; `AndroidManifest.xml` `2124dcd969347d2c7bb1bd99374a398cf50d2387`.
- **Workflow:** .github/workflows/jexfyz-app-build-trigger.yml; current workflow blob `5c5af03075f87297a31f5ee26f0e42025f05977b`; title `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`, body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`; manual issue opened/reopened only, guarded by repository owner/title/token.
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

## Current App implementation and validation boundary
- Source implemented on current `main`: staged Color Picker draft with explicit Select/Cancel, seven Home indicator animations and CONNECTED/DISCONNECTED Notify labels, Floating Monitor explicit orientation and live-telemetry replay, native SurfaceFlinger foreground FPS sampling, and notification-driven Wireless ADB pairing with encrypted identity and fixed DUMP grant flow.
- **CI evidence:** Builds #39 and #40 each ran Dart analysis and all 80 Flutter tests successfully. Build #40 additionally compiled the obfuscated APK and passed V1/V2/V3 signing plus official production-certificate validation. It did not publish because a source-archive path assertion failed; the assertion is corrected in current workflow.
- **Current release boundary:** Builds #41–#45 and diagnostic probes #1/#2 then failed before the first workflow step with `runner_id=0`; no logs identify the exact root cause. The diagnostic workflow used during those probes was deleted from current main and is not an available workflow. Build #46/#47 were skipped by the release guard. Current source has no verified release APK.
- **Physical validation still UNVERIFIED:** Home/Color Picker rendering on a phone; overlay permission and service lifecycle; FPS accuracy on an actual game/OEM; Wireless ADB/mDNS/RemoteInput, DUMP grant/revocation and encrypted identity behavior; BLE/cooling, safety, installed-device signature display and OTA/flash. CI passes do not prove those behaviors.
- Historical source-only claims that said these tests/APK had never run are superseded by #39/#40 evidence. Do not infer that a later source change or a test file implies a passing run unless the exact current commit is covered by a completed workflow.

## App Build and Thinking command protocol
- Canonical commands: `@Thinking Diskusi!`; Gemini subcommands only as `@Thinking Diskusi! Tanya Gemini!` or `@Thinking Diskusi! Jawaban Gemini!`; full execution `@Thinking Eksekusi Full!`; end-to-end App build `@Thinking Eksekusi Build App!`; emergency recovery `@Thinking Chat Stuck!`.
- Standalone `Eksekusi!` and `Eksekusi & Build App!` are retired. A Gemini subcommand without `Diskusi!` in the same command is invalid and its substantive request must not be answered.
- Current build-report register: `APP_BUILD_REPORT.md`. Build attempts, repairs, run links, validation, APK checksum and remaining blockers must be written there for cross-chat continuity.
- Build App context-limit continuity: use Prompt D in `CHAT_TRANSFER_PROMPTS.md` once as the first message in the replacement Build App chat. It LOADs live state and continues the existing work; no separate recap chat/prompt. Prompt A is only for broad project-memory reconciliation.
- These source/documentation updates did not trigger App Build; Build #36 is the latest observed successful run, and its APK predates the current Wireless ADB and seven-icon Home animation updates.
- Only active workflow: `.github/workflows/jexfyz-app-build-trigger.yml`; explicit owner/title/token issue trigger only.
- Latest successful run is Build #36 above; Build #36 passed 77 Flutter tests and release gates for source commit `893393388b99fc6d9e59c420070a159a29e45e9a` only.
- Keep one obfuscated, production-signed ordinary APK named `JEXFYZ-release.apk` on release tag `jexfyz-latest`; no Play Store bundle or Actions artifact.
- Trigger title: `JE X FYZ — EKSEKUSI BUILD APP TRIGGER`; body token `JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1`.
- Toolchain: Ubuntu 24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- The `@Thinking Eksekusi Build App!` operation must inspect and follow the active manual issue-trigger workflow, repair/retry App-scope failures, verify the final release asset and record every attempt in `APP_BUILD_REPORT.md`. It must report BLOCKED rather than claim success if required external access or separate authorization is unavailable.
- Firmware remains out of scope. The user accepts Firmware V6.6 as final; do not compile Firmware, generate/replace BIN, edit Firebase, flash hardware or run physical OTA without separate explicit authorization.

## Exact validation gates still open
1. After a new, separately authorized current-source Build App passes, install its release APK and recheck MT Manager's signature display. Build #36 predates the current Home UI and Wireless ADB changes and must not be treated as their validation.
2. On device, verify Fan OFF ease-out/full colour; box-free full-colour Peltier OFF; Fan Speed interpolation through repeated changes including a mid-transition retarget, ON wobble seam and OFF-to-zero; voltage sheen and Bluetooth ripple loop boundaries.
3. Verify Color Picker staged selection/Select/Cancel/outside/back behavior; Floating Monitor orientation, foreground FPS and telemetry replay; Wireless ADB pairing discovery + six-digit RemoteInput + ADB TLS grant path + identity persistence + notification permission/mDNS lifecycle; ADB `DUMP` grant/revoke; foreground package/layer parser and variable live FPS during a game; no false OFF or stale telemetry when starting overlay, changing apps or losing BLE. Source-contract assertions exist but have not run.
4. Preserve no-standalone Battery Protection Guard UI, one-second phone Battery heartbeat/five-second Firmware freshness TTL, and exclusive one-App/one-cooler pairing as unverified enforcement.
5. Firmware V6.6 is user-accepted as final after two reported same-version successful Online OTA updates. Do not edit/compile Firmware or operate BIN/Firebase/OTA/flash unless the user explicitly reopens that work and separately authorizes it.

## Repository split / operation boundary
- All source and memories live in TenzoNkz/JEXFYZ-App.
- TenzoNkz/JEXFYZ-Firmware must contain JEXFYZ.cpp.bin only; its notes were removed during this cleanup and the BIN was not touched. The last observed artifact root contains only the BIN; verify its live path/blob before any future publication.
- Latest source changes include staged Color Picker selection, the seven-icon Home animation / Notify-label redesign, Floating Monitor foreground SurfaceFlinger FPS/telemetry recovery, notification-driven Wireless ADB pairing for FPS DUMP setup, Android Keystore-encrypted per-install ADB identity storage, and updated contract assertions. Build #36 (`893393388b99fc6d9e59c420070a159a29e45e9a`) succeeds for earlier source only; Wireless ADB and Home UI updates remain NOT BUILT and tests NOT RUN.
