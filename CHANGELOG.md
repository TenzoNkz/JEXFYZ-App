# JE X FYZ / JE Cooler — Changelog

Chronological record of durable App/Firmware decisions and prior approaches. Live source defines current implementation; older version entries are always historical.

## 2026-10-14 — Memory-system cleanup / V6.4 checkpoint

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

## 2026-10-13 — V6.4 voltage-transition source contract

- A voltage transition pauses GPIO5 Peltier PWM at 0% only if the existing 5-second soft-start is active when a normal Manual Volt/Adaptive transition is accepted.
- Interrupted soft-start stays paused through selector handoff and the existing 1-second settle, then starts a fresh full 5-second ramp.
- Completed soft-start stays at 100% continuously through selector transition; no forced 0%, needless re-ramp or Peltier auto-enable when OFF.
- Preserve selector break-before-make of 200 ms; Fan stays ON/100% during the handoff; explicit OFF, Hotside/NTC safety and OTA safe-output cancel pending resume.
- Reason: user reported a hardware restart during 5 V→12 V with Peltier/Fan ON during active ramp. Supply transient/brownout remains unconfirmed. Reset diagnostics must be captured if reproduced.
- Test contract: `test/v6_4_qc_contract_test.dart`. Test is present but unrun. V6.4 compile and physical checks remain pending.

## 2026-10-13 — V6.3-origin Online OTA connection restoration

- User-reported failure: Wi-Fi showed connection/blue feedback, then failure/red feedback at the GitHub connection stage after adding an embedded ISRG Root X1 CA validation path and OTA-only NTP/time-sync gate.
- Restored `cloudClient.setInsecure()`; removed embedded CA, `setCACert()`, `configTime()`, `TIME_SYNCING`, epoch-validity and the 20-second NTP gate. On Wi-Fi connection, blue feedback proceeds to the GitHub GET attempt.
- Kept the raw GitHub BIN URL allowlist, redirect blocking, HTTP/length/size/image checks, safe outputs, streaming update lifecycle and failure recovery.
- User reported this V6.3 revision compiled and GitHub connection succeeded. The CA and NTP changes were removed together; evidence does not isolate which alone caused the prior failure. This is not evidence that the later V6.4 source compiled or that full BIN apply/reboot succeeded.
- Known trade-off: `setInsecure()` bypasses server certificate identity validation. Do not silently change this baseline; require explicit discussion and one-variable-at-a-time evidence.

## 2026-10-13 — App BLE rediscovery and OTA ACK handling

- BLE rediscovery avoids starting if Auto Connect is disabled or paired cooler identity is unknown; cancels polling if Bluetooth/permission/location prerequisites fail; suppresses scanning while syncing.
- `CLOUDOTA` ACK `TIMEOUT`/`DISCONNECTED` is treated as ambiguous rather than rejection; preserve OTA recovery state until reconnect/result. Definite rejection only rolls back while the BLE session remains connected.
- Static test contracts updated; the test run itself remains unverified.

## 2026-10-13 — Touch Adaptive-OFF telemetry and safety latch

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

- HOTSIDE adaptive safety historically used 10-second step-down dwell with fan/LED rules; subsequent versions changed thermal dwell, re-arm behavior and recovery. Do not apply this old 10-second policy to the active V6.4 contract without an explicitly approved change.
- Adaptive upward voltage dwell became 5 seconds after every completed increase in both profiles.
- Historical GPIO mapping: NTC0, Touch1, 12V3, 9V4, Peltier5, Fan6, WS2812 7; 200 ms selector deadtime and 5-second Peltier OFF→ON ramp were retained across later versions.

## 2026-10-04–2026-10-05 — App build/release workflow history (historical)

- Build workflow was restored to a single manual issue/title/token-gated obfuscated release APK.
- Output became one `JEXFYZ-release.apk` asset on GitHub Release `jexfyz-latest`; normal pushes and PRs must not publish the APK.
- Exact previous build runs/assets are historical; verify live Release/Actions state before use.

## Pre-V5 history

Detailed V4.x/V5.0–V5.3 changes are retained in earlier commit history and the previous changelog entries. When investigating an old regression, inspect the relevant commits and source diff, but never treat an old baseline as current implementation.
