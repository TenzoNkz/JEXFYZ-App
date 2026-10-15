## 2026-10-15 — Redesign animated Home status indicators and Notify connection labels

- Reworked the seven dashboard indicators with custom-painted, simplified geometry: segmented Battery Temperature, isolated Hotside thermometer, moving voltage charge sweep, Adaptive ring/orbit/core, reduced six-arm Peltier crystal, rotor blades with natural coast-down, and smooth telemetry-driven Fan Speed gauge.
- Removed the decorative heat waves running alongside/across the Hotside tube; liquid level now follows the Hotside reading. Battery and Hotside icon levels are mapped from valid Celsius text and eased over 520 ms rather than snapping on each telemetry refresh.
- Adaptive icon motion now follows the actual Adaptive ON state. Fan speed and voltage-dependent rotor timing remain intact.
- Home Notify connection badge now reads CONNECTED/DISCONNECTED (TERHUBUNG/TERPUTUS in Indonesian). Existing explicit error, connecting/syncing badges and detailed Notify body remain unchanged.
- Added widget tests for sensor-level parsing/clamping and both-language Notify badge labels, including the normal `Bluetooth Disconnected` notice staying DISCONNECTED rather than ERROR. Corrected the Celsius regex to parse digits/decimals in a raw Dart regular expression. Tests/analyze and APK build remain NOT RUN pending the separate @Thinking #Build App! authorization. No Firmware/BIN/Firebase/OTA/device operation was performed.

## 2026-10-15 — Recover and harden notification-driven Wireless ADB pairing

- Recovered the authorized App execution from live main rather than duplicating the existing feature commit. Existing source commit 4ad5d99bcea96e865978e3003482661b1e26101f introduced the native notification flow, and 89855b59c8d6ee40151847e6633a07cb75aff6b0 repaired the mDNS-listener closure and identity temporary-file naming.
- Hardened local mDNS discovery: declare ACCESS_NETWORK_STATE, ACCESS_WIFI_STATE and CHANGE_WIFI_MULTICAST_STATE; acquire a short-lived WifiManager.MulticastLock only while discovery is active; release it on stop/failure/destroy. Fixed the permission confirmation loop to stop once Android confirms android.permission.DUMP.
- When Android 13+ notification permission is missing, the Activity now requests it and requires the user to retry before starting the pairing notification. Pairing remains user-started; the native service only accepts a fresh six-digit code through RemoteInput, uses local loopback ADB, runs one fixed pm grant com.horizontalzzz.jexfyz android.permission.DUMP, and independently verifies permission state.
- Enhanced test/adb_pairing_contract_test.dart with assertions for discovery permissions, multicast-lock lifecycle and notification-permission request. Static authoring checks passed in this recovery run; Flutter/Dart tests, Dart analysis and Android/Kotlin compilation were NOT RUN.
- Updated current App notes, state, handover and index; CHAT_TRANSFER.md is updated separately after the resulting parent commit is verified last. Build #36 (run 38689044316, source 893393388b99fc6d9e59c420070a159a29e45e9) remains the latest successful APK, but it predates all Wireless ADB pairing changes. The pairing feature remains NOT BUILT and device behavior UNVERIFIED.
- No App Build workflow, Release update, Firmware source/BIN, Firebase, OTA, physical flash/device operation or hardware was touched.

## 2026-10-15 — Chat Stuck recovery and transfer checkpoint reconciliation

- Resumed the authorized chat-limit reconciliation from live `main` after inspecting the prior recovery checkpoint; stopped repetitive fingerprint-only updates and used an evidence-first, grouped documentation update.
- Rechecked the full recursive App repository tree: 66 entries, 48 tracked files, including 20 Markdown files and four Dart tests; tree response was not truncated. Active Firmware inventory remains exactly `firmware/JEXFYZ-V6.6.ino` with `FW_VERSION = "V6.6"`. The artifact repository contains only `JEXFYZ.cpp.bin`.
- Reconfirmed five App branches and zero open pull requests at the checkpoint. The only authorized workflow remains the manual issue-triggered App workflow; no App Build or Firmware/device operation was triggered.
- Corrected a stale Floating Monitor hash in `PROJECT_STATE.md`, expanded `MEMORY_INDEX.md` routing for the ADB/SurfaceFlinger FPS and telemetry work, and fixed duplicate list numbering in Prompt C. `CHAT_TRANSFER.md` is refreshed separately and last after the resulting parent commit and document fingerprints are verified.
- Current Color Picker and Floating Monitor/ADB FPS code remains SOURCE IMPLEMENTED / NOT RUN / NOT BUILT. Flutter/Dart analysis/tests and Android/Kotlin build were not run in this environment; device-side permission granting and dynamic foreground game FPS remain UNVERIFIED. Build #35 remains valid only for its older source commit.
- No Firmware source, BIN, Firebase metadata, protected OTA code, build workflow, release, physical device or hardware was changed or operated.
# JE X FYZ / JE Cooler — Changelog

Chronological record of durable App/Firmware decisions and prior approaches. Live source defines current implementation; older version entries are always historical.

## 2026-10-15 — Floating Monitor foreground FPS, telemetry recovery and Chat Stuck

- Removed the live preview pill from the center of Floating Monitor settings. Orientation is now selected explicitly using Horizontal / Vertical controls.
- Removed Flutter app-window frame counting as the FPS source. The native overlay now uses SurfaceFlinger `--timestats` frame-count deltas, resolved to Android's resumed/focused foreground package and matching layer names; it does not substitute the phone's refresh-rate setting or a busy background app's layer. Sample values are updated about once per second while the overlay is attached and FPS metric F is selected.
- Added a user-controlled ADB setup/check flow for Android development-only `android.permission.DUMP`, with fixed grant/revoke commands, Developer Options shortcut and localized status text. Android documents DUMP as a powerful development permission not intended for third-party apps; JE Cooler must disclose this, never grant it to itself, execute only fixed Activity/SurfaceFlinger dumps, and show unavailable status when OEM/API output is blocked. No Shizuku integration is included in this revision.
- Corrected the likely overlay-start data race: if live telemetry was published before the native overlay service existed, the bridge dropped that update. The latest authoritative telemetry snapshot is now resent after the service starts/restores, and native HUD requests layout as well as redraw when values change. Native status values remain unknown (`--`) when BLE is disconnected; OFF is shown only with a valid connected snapshot.
- Added source-contract regression assertions for preview removal/orientation selection, ADB bridge and grant/revoke commands, focused-package FPS filtering, no Flutter frame counter, telemetry replay, and disconnected status. Dart/Flutter tests and analysis were NOT RUN because those SDKs are unavailable in this execution environment; the changes are NOT BUILT, physical ADB permission/FPS behavior is UNVERIFIED, and no App Build was triggered.
- Added `@Thinking Chat Stuck!` as a standalone recovery command: stop blind retries, inspect live logs/repository/workflow/checkpoint, continue only the most recent valid authorization, avoid duplicate commits/builds, and report `RECOVERED`, `BLOCKED` or `FAILED`. It never implies Build App or Firmware/device authorization.
- Updated `lib/floating_monitor.dart`, `lib/app_settings.dart`, `lib/main.dart`, `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/FloatingMonitorService.kt`, `android/app/src/main/kotlin/com/horizontalzzz/jexfyz/MainActivity.kt`, `android/app/src/main/AndroidManifest.xml`, `test/widget_test.dart`, and canonical notes/rules. Firmware V6.6, firmware BIN, Firebase, workflow trigger and physical device were not changed or operated.

## 2026-10-15 — Color Picker staged selection and explicit dismissal

- Changed `_JexColorPickerCard` to retain a local draft. Tapping any of the 36 palette swatches now updates only the checkmark/preview/name; it does not send BLE `COLOR` or close the modal.
- Added localized top-right Select (`Select` / `Pilih`) and retained localized top-left Cancel (`Cancel` / `Batal`). Select applies the selected draft through the existing confirmed COLOR command and closes only when confirmed; selecting the already-active color closes without sending a redundant command. Failed/unconfirmed changes leave the modal open and the previous applied RGB state unchanged. Cancel discards the draft.
- Set `barrierDismissible: false` and wrapped the modal content in `PopScope<void>(canPop: false)` so outside taps and system Back do not close it; Cancel/Select pop programmatically. Kept the six-column 36-color palette, bottom anchor, no-HEX names, swatch sizing and animation style.
- Added Widget test source-contract assertions for staged selection, Select callback, localized label and blocked dismissal. **Tests/Dart analysis were NOT RUN**: the available execution environment has no Flutter or Dart SDK. No App Build/APK was triggered; physical UI behavior remains unverified. Next authorized build command is `@Thinking #Build App!`.
- Files: `lib/main.dart`, `lib/app_settings.dart`, `test/widget_test.dart`, `APP_NOTES.md`, `PROJECT_STATE.md`, `HANDOVER.md`, `MEMORY_INDEX.md` and `CHAT_TRANSFER.md`. Firmware/workflow/Firebase/BIN/OTA/device state unchanged.

## 2026-10-15 — One-shot Build App chat-limit handoff

- Clarified that a Build App chat reaching the context limit uses Prompt D from `CHAT_TRANSFER_PROMPTS.md` exactly once as the first message in the replacement Build App chat. The prompt loads live repository/build evidence and continues the existing work; there is no separate recap chat or recap prompt. Prompt A remains for broad project-memory reconciliation and is not the Build App handoff.
- Aligned `CHAT_RULES.md`, `BUILD_NOTES.md`, `APP_BUILD_REPORT.md`, `HANDOVER.md`, `MEMORY_INDEX.md`, `PROJECT_STATE.md`, `README.md` and the refreshed `CHAT_TRANSFER.md` with this single-load handoff model. Documentation-only; no App/Firmware source or workflow changed, and no App Build was run.

## 2026-10-15 — Thinking protocol replacement and App Build report

- Replaced the permanent command model: `#Diskusi!` is full read-only analysis; `#Tanya Gemini!` and `#Jawaban Gemini!` are valid only when paired with `#Diskusi!` in the same command; `#Eksekusi Full!` is the sole full-execution command; `#Build App!` owns end-to-end App Build, App-scope repairs/retries, release-artifact verification and durable reporting.
- Retired standalone `#Eksekusi!` and combined `#Eksekusi & Build App!`. A missing-parent Gemini command must be rejected without answering its substantive content.
- Added `APP_BUILD_REPORT.md` as the shared build evidence ledger for source commit, trigger/run IDs, failure analysis/fixes, test/analyze results, APK identity/checksum/signing, warnings, blockers and device-side unknowns.
- Updated `CHAT_RULES.md`, `BUILD_NOTES.md`, `HANDOVER.md`, `README.md`, `PROJECT_STATE.md`, `MEMORY_INDEX.md` and `CHAT_TRANSFER_PROMPTS.md`. This documentation-only change does not start App Build or modify app/Firmware source, the build workflow, BIN, Firebase, OTA or hardware.
- Previous App Build #35 / run `38669526891` remains the last known successful run in these records until a new live run is explicitly triggered and verified. Physical-device rendering and MT Manager verification remain separate open gates.


## 2026-10-15 — Chat-limit reconciliation after Build #35

- Reconciled the current App/UI checkpoint against live `main`, recursive tree, source/tests, active build workflow, Actions run, Release asset, branch/open-PR state and artifact-repository root. Build #35 targets code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`; this documentation reconciliation does not change that code or run another build.
- Corrected stale “tests not run/latest build #33” statements in README, Memory Index, App Reference and Handover. Removed the duplicate current-state section from Handover, corrected the easing reference, clarified Build #34's failed midpoint assertion versus the symmetric cubic fix, and separated CI validation from device validation.
- Updated Firmware technical/OTA/voltage references so the Build #35 Flutter/source-contract run is acknowledged without implying Firmware compilation or physical OTA verification.
- Build #35 evidence: Dart analyze and all 74 Flutter tests passed; one `JEXFYZ-release.apk` (54,521,947 bytes) was built, V1/V2/V3 verified, published and re-downloaded; SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`. JAR/V1 META-INF warnings remain documented.
- Firmware V6.6 source/BIN, workflow, Firebase metadata, physical hardware and OTA were not changed or operated. The user's V6.6 compile/two Online OTA successes remain user-reported; source-to-BIN provenance and device-side rendering/MT Manager verification remain unverified.




## 2026-10-15 — Fan Speed midpoint correction and App Build #35

- Build #34 correctly stopped before APK compilation: 73 Flutter tests passed and one failed in `Fan Speed level retargeting eases between values without abrupt jumps`. The test expected the easing curve to return exactly 0.5 at progress 0.5, while `Curves.easeInOutCubic` returned 0.510125.
- Corrected `jexSmoothFanSpeedLevel` in `lib/main.dart` to use symmetric cubic smoothstep `t * t * (3.0 - 2.0 * t)`, preserving eased motion with zero velocity at the endpoints and an exact midpoint. This fixes the intended UI interpolation contract rather than weakening the test.
- App Build #35 passed on code commit `d25ca28af9f2c04ff77ea710daac3edf3a44f3c8`: security/architecture audit, dependency installation, Dart analyze, all 74 Flutter tests, APK compilation, V1/V2/V3 verification, release publication and re-downloaded asset verification.
- Published one `JEXFYZ-release.apk` at `jexfyz-latest` (54,521,947 bytes), SHA-256 `77e57ece6c194ec97ce9f4e72d379f848173cd2cf905f66a74e6b037ad82e5c1`. Production certificate SHA-256 matched `dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0`; V1/V2/V3 verified true for both built APK and downloaded release asset.
- JAR/V1 verification still reports dependency `META-INF` entries not protected by the JAR signature, including `META-INF/services/a1` and `META-INF/services/b1`. Record this as a warning; it does not negate the separate successful V2/V3 results.
- This was App-only work. No Firmware compile, BIN change/publication, Firebase edit, OTA/flash or physical hardware validation occurred; device-side animation and MT Manager inspection remain open.

## HISTORICAL / SUPERSEDED — 2026-10-15 — Smooth Fan Speed retargeting and seamless indicator loops

- Added `jexSmoothFanSpeedLevel`, with a dedicated retargetable `AnimationController` for the Fan Speed gauge. Each new active speed target interpolates from the currently displayed value over 420 ms; another target arriving mid-transition starts from the current interpolated position rather than jumping back. Fan OFF smoothly retargets the gauge to zero over 520 ms; the telemetry percentage remains authoritative.
- Replaced the Fan Speed needle's non-integer wobble harmonic with integer harmonics so both position and slope match across the loop's 0/1 boundary.
- Changed the voltage-bolt highlight from a one-way linear sweep with a snap-back to a sinusoidal back-and-forth movement.
- Changed Bluetooth connection ripple opacity to a squared-sine envelope, transparent with zero slope at cycle edges, avoiding a visible ring flash when the radius wraps.
- Added regression contracts for interpolation endpoints/easing, wobble boundary continuity, and voltage/Bluetooth loop effects. Static source/readback checks passed; Flutter tests/analyze and device rendering have not run for these edits.
- No App Build, Firmware compile, BIN/Firebase update, OTA/flash, or release operation was performed for this animation task.



## HISTORICAL / SUPERSEDED — 2026-10-15 — Smooth status animation loops and retargetable Fan Speed gauge

- Added a dedicated Fan Speed value-transition controller, separate from the cyclic wobble controller. Each active speed change retargets from the currently rendered gauge level to the latest target over 420 ms; if another target arrives mid-transition, it continues from the current interpolation. OFF animates to 0 over 520 ms and later OFF telemetry changes no longer restart that transition.
- Replaced the non-integer needle wobble harmonic with integer harmonics so position and slope repeat cleanly at the animation loop boundary.
- Changed voltage-bolt sheen from a one-way linear sweep that snapped at the repeat boundary to a sinusoidal back-and-forth sweep.
- Changed Bluetooth ripple opacity to a squared-sine envelope that reaches transparency with zero slope at both ends of each loop, avoiding a flash on ring reset.
- Added deterministic regression tests for eased interpolation endpoints/midpoints, loop-seamless needle wobble, the voltage sheen, and Bluetooth ripple envelope. Updated the prior Speed source-contract test.
- Static source/readback checks passed. Flutter tests/analyze and device rendering were NOT run after these edits; no APK contains this source yet. No Build App, Firmware compile, BIN, Firebase, OTA, flash, or hardware action occurred.



## HISTORICAL / SUPERSEDED — 2026-10-14 — Fan coast-down, static Peltier crystal, natural Fan Speed gauge

- Fan now eases through a short period-dependent coast-down when turned OFF, then holds its final rotor pose. Blade and hub colours are unchanged by OFF; the animation stops without dimming the icon.
- Removed the square Peltier module frame, center box and corner bolts. The six-branched frost crystal and particles remain visible at full icon colour while OFF; its animation is frozen rather than faded out. Voltage-class intensity/particle interpolation remains active only as applicable while Peltier is ON.
- Fan Speed keeps the reported percentage stable while ON and adds a subtle two-frequency needle wobble. On OFF, the pointer smoothly returns to zero over 520 ms, then rests without wobble; gauge, pointer and hub stay fully coloured.
- Updated `test/widget_test.dart` source-contracts for phase-preserving Fan changes/coast-down, no-box/no-fade Peltier artwork, full-colour Fan blade/hub and Speed needle wobble/stop. Static source consistency checks passed; Flutter tests/analyze and device rendering were NOT run after these edits.
- App-only presentation change. No Firmware source, BLE protocol, safety logic, BIN/Firebase, App Build, OTA, flash or release operation changed.



## HISTORICAL / SUPERSEDED — 2026-10-14 — APK signature verification hardening / Firmware V6.6 user acceptance

- Investigated the user's MT Manager screenshot showing `Signature: Verified failed`. The latest successful App Build before this fix was run `38556896542` on commit `67c5d26723c433b4af856c7759a967a3425bf67a`; its log reported V1=false, V2=true and V3=true while the workflow accepted the build because it relied on `jarsigner`'s `jar verified.` text and did not require `apksigner` V1=true.
- Hardened `.github/workflows/jexfyz-app-build-trigger.yml` to sign with `--min-sdk-version 23`, run `apksigner verify --min-sdk-version 23`, and fail unless V1/V2/V3 all verify on both the built APK and the re-downloaded release asset. Android manifest minSdk remains 24. The workflow change was subsequently exercised in Actions run `38560939271` on commit `2aa77113950ac462bd27fa6f1ca416371eaa7ad8`: V1/V2/V3 all verified true on the produced APK and re-downloaded release asset. The run passed tests/analyze for that earlier source, not the current Fan/Peltier/Speed edits. Its log warns `META-INF/services/b1` is not protected by JAR/V1. No device-side recheck of MT Manager's label has yet confirmed the cause.
- The screenshot's installed-app metadata says last update 17:11 Asia/Jakarta, earlier than the latest successful run completing at 18:36, so the shown installed copy predates that release. The precise reason MT Manager shows failure remains unverified until a new APK is built, installed and checked.
- User confirms Firmware V6.6 is final/correct and reports successful compilation plus two successful Online OTA flashes/updates on the same V6.6 version. Do not change/recompile/reflash Firmware unless the user explicitly reopens the task and separately authorizes the operation. Source-to-BIN provenance remains a separate unverified fact, not a reason to initiate another Firmware operation.
- No App Build, Firmware compile, BIN update, Firebase change, physical OTA/flash or release operation was performed in this execution.


## HISTORICAL / SUPERSEDED — 2026-10-14 — Chat-limit reconciliation after App UI execution

- Re-read the prior transfer snapshot and canonical App/Firmware/OTA/build/design memories; refreshed current source/test hashes, current App build boundary, repository branch/PR and BIN-only artifact evidence in the transfer snapshot.
- Corrected stale active-App and build wording in current status/handover, refreshed memory routing, removed the duplicate newest UI entry, and explicitly marked older logo/large-icon descriptions as superseded by the transparent JE notification monogram.
- Current source remains App-only UI work: phase-continuous Fan motion, geometric Peltier crystal with 360 ms ON fade / 420 ms voltage interpolation / 520 ms OFF fade, larger dialogs, and JE notification small icon. Firmware stays V6.6.
- Flutter/Dart SDK is unavailable in this execution environment, so current-source Flutter tests/analyze were NOT run. Latest verified successful App Build is run `38545637192` on older source commit `9e790765f6683d342025317ce6594cc8519026de`; it does not contain the current changes.
- No App Build, Firmware compile, BIN replacement/publication, Firebase update, OTA, flash/device operation or release was performed.

## HISTORICAL / SUPERSEDED — 2026-10-14 — Smooth motion, crystal Peltier, JE notification and dialog sizing

- Fan voltage changes now update rotation duration without resetting angular phase; the controller travels smoothly to an equivalent full-turn boundary before continuing at the new speed, and Fan OFF coasts forward to a retained pose. Peltier frost intensity/particle count interpolate over 420 ms across voltage classes, fade in over 360 ms on ON and out over 520 ms on OFF; crystal branches, particles and center fade fully, periodic drift avoids loop-boundary jumps, while the thermoelectric frame remains visible.
- Replaced the flower-like Peltier icon with a framed thermoelectric module and six-branched geometric frost crystal. The Color Picker remains bottom-pinned with localized top-left Cancel that dismisses without sending RGB; all 36 curated presets and the existing color command path are retained.
- Increased Color Picker title/selected-color/Cancel text and swatch height; increased Peltier Safety title/body/action typography, spacing and minimum touch targets. Palette colors and mandatory Fan-before-Peltier safety gate are unchanged.
- Android notifications now use a bold white `JE` vector monogram with transparent background as the sole small icon; no large icon is set, and the full-color app icon remains unchanged.
- Added widget contracts for phase continuity/coast-down, Peltier crystal geometry/interpolation, dialog sizing, and JE icon path. Static readback checks passed. Flutter tests/analyze and App Build were NOT run for these current commits (Flutter/Dart SDK unavailable); device rendering is unverified. No Firmware, BIN, Firebase, OTA, flash or release operation occurred.

## HISTORICAL / SUPERSEDED — 2026-10-14 — Voltage-aware Fan/Peltier icons and bottom-pinned Color Picker

- Fan dashboard motion now uses distinct continuous rotation durations from authoritative BLE-reported voltage: 5V slow (2600 ms), 9V medium (1250 ms), and 12V fast (620 ms). Peltier frost icon increases glow and crystal density across the same voltage classes and fades its frost overlay over 520 ms when switched OFF. These are illustrative visuals, not RPM or temperature/ice measurements; no firmware, BLE command, safety or physical LED behavior changed.
- Pinned the LED Color Picker to the bottom safe area and removed the outer scroll view/top-offset positioning, preventing the panel from being dragged vertically. Added localized Cancel at the top-left; Cancel closes without sending a new colour, while swatch selection preserves the prior RGB command path.
- Added widget contracts for voltage mapping, comparative fan timing, frost density/intensity, bottom anchoring and Cancel dismissal.
- Static source transformation and live file readback checks passed. Flutter test/analyze and an APK build were NOT run; device rendering and physical appearance remain unverified. Firmware V6.6 was untouched by this App-only execution; the user's earlier compile/Online OTA report was not independently re-verified here.

## 2026-10-14 — HISTORICAL / SUPERSEDED: notification logo, LED contrast, anchored menus and status-icon motion

- Switched notification small-icon branding to the existing transparent JE X FYZ logo PNG (`R.drawable.jexfyzicon`) so Android uses the actual logo alpha shape, and removed `setLargeIcon`; only one logo appears at the left. The legacy X vector remains unused; title/body, tap intent and service messages remain unchanged.
- Updated LED preview so Static/Rainbow remain fully vivid independently of hardware Brightness, while truly inactive Comet/Dual Chase pixels use a pale neutral baseline. Animation phase and physical firmware commands are unchanged.
- Kept Color Picker and Peltier Safety as separate dismissible menus but anchored each below the dashboard/display-tab region. Localized Cancel / Turn On Fan and the mandatory Fan-before-Peltier safety gate remain.
- Replaced the dashboard indicator painter with per-kind filled forms, soft layered glows, smooth orbit/rotor motion and slower distinct cycles for Battery, Hotside, Voltage, Adaptive, Peltier, Fan and Fan Speed. This is App-only presentation.
- Added/updated widget contracts for preview colour behaviour, menu anchoring, indicator timing and single-logo notifications.
- Static source transformation checks passed. Flutter test/analyze and APK build were not run (Flutter/Dart SDK unavailable here); Android OEM rendering, current-source installation and physical UI appearance remain unverified. No firmware/BIN/Firebase/OTA/device/release operation occurred.

## HISTORICAL / SUPERSEDED — 2026-10-14 — Chat-limit reconciliation and test-contract cleanup

- Audited the latest non-truncated main tree and canonical notes; preserved the current source-only V6.6/NOT RELEASED boundary and the artifact repository BIN-only rule.
- Corrected the stale widget-test palette expectation from 24 colors/old first color to 36 curated presets/current first color `#FF1744`, and removed the accidentally duplicated native notification source-contract test.
- Corrected stale Build Notes: the latest observed successful App Build run is `38520146994` on `1024eb8e145429913aacb52f4cf352e087885d44`; it predates the LED UI/notification source changes and does not validate current source. Failures `38519913851` and `38519669369` also predate that work.
- Reconciled current test SHA references in App/voltage/OTA memory and normalized the handover QC numbering. Current test files exist but tests/analyze were NOT RUN for this reconciliation.
- No functional Firmware source change/version bump, App Build, Firmware compile, BIN, Firebase, OTA/flash/device operation or release was performed.
- This entry records a documentation/test-contract correction, not a test pass.

## 2026-10-14 — HISTORICAL / SUPERSEDED: LED preview/picker, disconnected menu fallback and Android notifications

- Compactened the LED preview row, removed the numeric mode index, narrowed its center card, and darkened left/right LED column backgrounds for contrast.
- Decoupled LED preview core opacity/glow from the hardware Brightness setting so colors stay visible at low hardware brightness; Firmware brightness/protocol behavior is unchanged.
- Replaced the code-only palette with 36 curated hue-ordered colors, localized names, and a centered responsive dialog. HEX values remain internal to the RGB command and are not displayed. Common colors stored by prior palette versions retain localized aliases; legacy Cyan #00FFFF and classic Red are still selectable without adding dark/light brightness variants.
- CONTROL/ADAPTIVE/LED menu switch rows show an OFF-looking disabled fallback with the toggle at left while BLE is disconnected. Home/dashboard and Floating Monitor remain unknown (`--`) when physical telemetry is unavailable.
- Added monochrome Android notification icon plus the full-color branded large icon, fixed BLE event title/body order, added app-open tap intents and meaningful localized foreground service bodies, and requests Android 13+ notification permission at the first actual notification attempt.
- Updated UI/source-contract tests and canonical memory. Tests/analyze are NOT RUN; Android OEM notification rendering, narrow-screen layout and hardware LED appearance remain UNVERIFIED.
- No Firmware source/protocol, BIN, Firebase, OTA, flashing, release, App Build or Firmware compile operation was performed.

## HISTORICAL / SUPERSEDED — 2026-10-14 — V6.6 LED mode removal, brightness preview and phase synchronization

- Bumped active Firmware source to `firmware/JEXFYZ-V6.6.ino`, `FW_VERSION = "V6.6"`; exactly one active versioned `.ino` remains.
- Retired Mirror Pulse ID 3 in Firmware and App without renumbering supported protocol IDs: Static 1, Breath 2, Comet 4, Dual Chase 5, Left/Right 6, Rainbow 7. Persisted ID 3/invalid values migrate to Static; new MODE:3 commands are rejected.
- Replaced separate queued `LED_PHASE` and `LED_CYCLE_MS` updates with a single `LED_SYNC:<mode>,<phase_ms>,<cycle_ms>` tuple. The marker is resolved at the BLE notify boundary, so phase does not become stale while waiting in the queue. BLE UUID/P1 transport is unchanged.
- App parses the tuple atomically and interpolates on a monotonic clock. New snapshots correct drift without restarting the animation controller on every phase update; separate legacy phase/cycle parsing remains for older firmware.
- Reworked LED UI into one row: left arrow, four left pixels, centered mode number/name, four right pixels, right arrow; removed the old MODE header and duplicate caption. Unsupported ID 3 from older firmware is labelled Unsupported until the user selects a supported mode.
- Fixed low-brightness preview by preserving RGB chroma and applying brightness through pixel alpha/glow rather than scaling all RGB channels toward black. Firmware brightness commands/hardware rendering are unchanged.
- Added App tests for supported IDs, atomic snapshot parsing and low-brightness chroma; added firmware contract tests for retirement/migration of ID 3 and snapshot creation at notification time. Tests/analyze have NOT been run; static inspection is not runtime verification.
- Firmware compile, BIN generation/provenance, physical LED verification, App Build/APK, Firebase, OTA, flash and release were NOT performed. V6.6 remains source-only DEVELOPMENT + QC / PRE-RELEASE; NOT RELEASED.

## HISTORICAL / SUPERSEDED — 2026-10-14 — V6.5 Adaptive Peltier transition continuity

- Bumped the active Firmware source to `firmware/JEXFYZ-V6.5.ino` and `FW_VERSION = "V6.5"`; retained exactly one active versioned `.ino`.
- Adaptive ON/OFF still returns the selector to safe 5 V but no longer toggles the logical Peltier state OFF solely for that handoff. Both paths use the existing output reconciliation and voltage-transition pause helper.
- An active five-second soft-start is paused by `requestVoltage()`, then restarted after selector deadtime and the existing one-second settle. The settle timestamp is set before Adaptive activation reconciles output state, so an old timestamp cannot shorten the wait. If the ramp has completed, PWM remains at 100%. A Peltier already OFF stays OFF.
- Explicit user Peltier-OFF cancels deferred Adaptive-stop restoration; Hotside/NTC safety and OTA safe-output also remain higher priority. The change does not weaken thermal/OTA protections.
- Renamed the active static contract to `test/v6_5_qc_contract_test.dart` and added a regression assertion that Adaptive ON/OFF handoff code does not introduce its own `peltierOn = false` cycle.
- Static source/diff inspection only. Flutter tests/analyze, ArduinoDroid compile, BIN provenance, physical hardware tests, OTA, App Build and release were NOT run; V6.5 remains source-only and NOT RELEASED.

## HISTORICAL / SUPERSEDED — 2026-10-14 — Memory-system cleanup / V6.4 checkpoint

- Reconciled current source version to `firmware/JEXFYZ-V6.4.ino`, `FW_VERSION = "V6.4"`; one active versioned source file.
- Replaced stale, duplicated “current status” blocks in the current-state, handover, App, Firmware, build and rules documents with canonical focused references.
- Added `MEMORY_INDEX.md`, `CHAT_TRANSFER_PROMPTS.md`, and `DESIGN_NOTES.md`; established `README.md` as the project index and transfer prompts as a separate file.
- Consolidated V6.4 Peltier transition logic into `VOLTAGE_TRANSITION_MEMORY.md`; preserved Online OTA incident and evidence boundary in `OTA_REGRESSION_MEMORY.md`.
- Set documented repo boundary: all code source and memory under `TenzoNkz/JEXFYZ-App`; `TenzoNkz/JEXFYZ-Firmware` is intended to contain only `JEXFYZ.cpp.bin`.
- Added verbatim archives of the legacy state/reference docs and transfer/rules/history snapshots before replacing them, plus an archive of the removed artifact-repository notes. Archives are for recovery only; old CURRENT/version statements inside them are stale.
- Renamed the old `test/v5_9_contract_test.dart` to `test/app_protocol_notify_contract_test.dart` to reflect what it tests; test content is unchanged and has not been executed here.
- Enforced the user-requested artifact repository split: removed README and duplicated note files from `TenzoNkz/JEXFYZ-Firmware`; verified the BIN itself was not modified.
- Expanded transfer prompt templates with a mandatory memory-category checklist and an archive-recovery policy.
- Documentation/test-path cleanup only; no functional App/Firmware behavior was intentionally changed, no tests were run, and no Build App, Firmware compile, BIN replacement, Firebase, device or release operation was performed.
- Full chat-limit memory reconciliation refreshed the canonical memory map and handover/prompts, and made two durable requirements explicit in `APP_NOTES.md`: do not display a standalone Battery Protection Guard; preserve the 1 Hz Android Battery heartbeat/5-second Firmware freshness TTL. The one-App/one-cooler pairing-lock intent is preserved as a user requirement while exclusive enforcement remains unverified.
- Rechecked current Local OTA boot SoftAP/radio lifecycle from active source: 10-second no-client timeout, 60-second hard cap after interaction, and 160 ms Wi-Fi-off settle before BLE starts. Documented in Firmware technical/OTA references without changing protected code.
- Transfer prompt now requires full-tree audit, local-link/path/hash checks, source-versus-test-versus-runtime evidence separation, archive handling, and replacement of `CHAT_TRANSFER.md` last. No functional source changed and no tests/build/compile/BIN/OTA/Firebase/flash/release operation was performed.
- Preserved two separate user-reported restart incidents in current memory: (1) Manual 5 V→12 V during active Peltier soft-start and (2) enabling Adaptive from 12 V with Peltier/Fan ON. Reset reason is unknown in both reports; brownout remains a hypothesis, and they must not be conflated.
- Preserved the prior user request for rapid Hotside-rise shutdown/manual re-arm as NOT IMPLEMENTED in V6.4, and the historical report that the Adaptive-OFF white three-blink indicator was missing immediately after restart. Transition/boot LED code and physical status still require direct verification; no source behavior was changed in this docs task.

## HISTORICAL / SUPERSEDED — 2026-10-13 — V6.4 voltage-transition source contract

- A voltage transition pauses GPIO5 Peltier PWM at 0% only if the existing 5-second soft-start is active when a normal Manual Volt/Adaptive transition is accepted.
- Interrupted soft-start stays paused through selector handoff and the existing 1-second settle, then starts a fresh full 5-second ramp.
- Completed soft-start stays at 100% continuously through selector transition; no forced 0%, needless re-ramp or Peltier auto-enable when OFF.
- Preserve selector break-before-make of 200 ms; Fan stays ON/100% during the handoff; explicit OFF, Hotside/NTC safety and OTA safe-output cancel pending resume.
- Reason: user reported a hardware restart during 5 V→12 V with Peltier/Fan ON during active ramp. Supply transient/brownout remains unconfirmed. Reset diagnostics must be captured if reproduced.
- Test contract: `test/v6_4_qc_contract_test.dart`. Test is present but unrun. V6.4 compile and physical checks remain pending.

## HISTORICAL / SUPERSEDED — 2026-10-13 — V6.3-origin Online OTA connection restoration

- User-reported failure: Wi-Fi showed connection/blue feedback, then failure/red feedback at the GitHub connection stage after adding an embedded ISRG Root X1 CA validation path and OTA-only NTP/time-sync gate.
- Restored `cloudClient.setInsecure()`; removed embedded CA, `setCACert()`, `configTime()`, `TIME_SYNCING`, epoch-validity and the 20-second NTP gate. On Wi-Fi connection, blue feedback proceeds to the GitHub GET attempt.
- Kept the raw GitHub BIN URL allowlist, redirect blocking, HTTP/length/size/image checks, safe outputs, streaming update lifecycle and failure recovery.
- User reported this V6.3 revision compiled and GitHub connection succeeded. The CA and NTP changes were removed together; evidence does not isolate which alone caused the prior failure. This is not evidence that the later V6.4 source compiled or that full BIN apply/reboot succeeded.
- Known trade-off: `setInsecure()` bypasses server certificate identity validation. Do not silently change this baseline; require explicit discussion and one-variable-at-a-time evidence.

## HISTORICAL / SUPERSEDED — 2026-10-13 — App BLE rediscovery and OTA ACK handling

- BLE rediscovery avoids starting if Auto Connect is disabled or paired cooler identity is unknown; cancels polling if Bluetooth/permission/location prerequisites fail; suppresses scanning while syncing.
- `CLOUDOTA` ACK `TIMEOUT`/`DISCONNECTED` is treated as ambiguous rather than rejection; preserve OTA recovery state until reconnect/result. Definite rejection only rolls back while the BLE session remains connected.
- Static test contracts updated; the test run itself remains unverified.

## HISTORICAL / SUPERSEDED — 2026-10-13 — Touch Adaptive-OFF telemetry and safety latch

- Touch long-press Adaptive-OFF must publish authoritative Adaptive state/ceiling, Fan, Peltier and Fan-speed telemetry before the Touch ACK so App/Floating Monitor doesn't retain stale state.
- Manual Peltier safety latch cannot be bypassed by a single low Hotside sample; require Hotside at/below `hotLimit - 1°C` for 5 continuous seconds.
- Tests/source assertions were added, but test execution was not implied.

## 2026-10-13 — V6.2 thermal safety history (superseded source)

- Adaptive thermal safety used a 30-second stage at 12 V, 9 V and 5 V; Peltier OFF, Fan 100%. Five stable seconds at/below `hotLimit - 1°C` before timeout cancelled a stage; failure stepped down at 12/9 V and terminal-locked at 5 V.
- Thermal restoration moved up one rail only after 60 continuous seconds stable, capped by the saved Adaptive ceiling.
- A temporary App quality workflow failed to push `pubspec.lock` non-fast-forward; tests/analyze were skipped and the temporary workflow removed. This is a historical CI incident, not current workflow status.

## 2026-10-12 — V6.1 source-only safety/LED baseline (historical)

- Adaptive entry/exit used safe-5V handoff; restore previously-running Peltier only through safety gates and the normal 5-second OFF→ON soft-start.
- Adaptive ON blinked orange three times; Adaptive OFF blinked white three times, deferred until safe handoff completed if mode was active.
- Serial `BOOT: RESET_REASON=...` diagnostic was retained. Version promotion did not include assistant-side compile/BIN/flash/release.

## 2026-10-08 — V6.0 behavior decisions (historical)

- Adaptive Profile is runtime-only; default HOTSIDE on boot, HOTSIDE_BATTERY remains optional and is not persisted.
- Persistent settings use a shared 10-second quiet-period debounce; only values differing from persisted shadow are written.
- Approved RGB modes: Static, Breath, Mirror Pulse, Comet, Dual Chase, Left/Right and Rainbow. Center Out/Outer In retired.
- Firmware publishes LED animation phase/cycle telemetry so App preview can track physical animation phase. Safety/OTA LED indication has priority.

## 2026-10-06 — V5.8 NTC single-sample and re-arm correction (historical)

- User rejected V5.6 multi-sample/trimmed-mean NTC filtering. V5.8 restored one calibrated ADC sample every second.
- NTC model: 10 kΩ fixed resistor, nominal 10 kΩ NTC, Beta 3950, 3.3 V divider assumption.
- Re-arm feedback history used a threshold variant of `hotLimit - 2°C`; this is superseded by the current V6.x `hotLimit - 1°C` / five-second stability contract.

## 2026-10-06 — V5.7 Touch gesture correction (historical)

- Raw GPIO qualification ~30 ms, startup grace ~1,000 ms, raw HIGH tap duration 60–500 ms, double-tap window 800 ms, long press 5,000 ms; no blocking wait introduced.

## 2026-10-05 — V5.4–V5.6 adaptive/safety history (historical)

- HOTSIDE adaptive safety historically used 10-second step-down dwell with fan/LED rules; subsequent versions changed thermal dwell, re-arm behavior and recovery. Do not apply this old 10-second policy to current V6.6 behavior; the current transition and timing contract lives in FIRMWARE_NOTES.md and VOLTAGE_TRANSITION_MEMORY.md.
- Adaptive upward voltage dwell became 5 seconds after every completed increase in both profiles.
- Historical GPIO mapping: NTC0, Touch1, 12V3, 9V4, Peltier5, Fan6, WS2812 7; 200 ms selector deadtime and 5-second Peltier OFF→ON ramp were retained across later versions.

## 2026-10-04–2026-10-05 — App build/release workflow history (historical)

- Build workflow was restored to a single manual issue/title/token-gated obfuscated release APK.
- Output became one `JEXFYZ-release.apk` asset on GitHub Release `jexfyz-latest`; normal pushes and PRs must not publish the APK.
- Exact previous build runs/assets are historical; verify live Release/Actions state before use.

## HISTORICAL / SUPERSEDED — Pre-V5 history

Detailed V4.x/V5.0–V5.3 changes are retained in earlier commit history and the previous changelog entries. When investigating an old regression, inspect the relevant commits and source diff, but never treat an old baseline as current implementation.
