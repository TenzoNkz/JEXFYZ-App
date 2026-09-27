# 🚨 CURRENT AUTHORITATIVE HANDOFF — 2026-09-27

## 2026-09-27 — V1.3 FULL ARDUINO STANDARD REFACTOR

- User execution authorization: Eksekusi Full granted.
- Standing implementation mandate: from this point forward, every firmware change, large or small, must follow Arduino Standard for the pinned Arduino-ESP32 Core 3.3.7.
- Authoritative firmware source: firmware/JEXFYZ.ino.
- Current firmware version: V1.3.
- Source update commit: e520a086f5d86b28970e0eef9685facd939a397a.
- Previous V1.2 source blob: d19d8b3bf7d8637e11148bb63568164107ae0ae1.
- CI workflow audit update: 34347a1001c8817ae01ce9b21b9cfce384c54788.

### Arduino Standard changes

- Local OTA no longer uses direct ESP-IDF OTA lifecycle calls.
- Online OTA no longer uses direct ESP-IDF OTA lifecycle calls.
- Added the official Arduino Update.h lifecycle:
  - Update.begin(...)
  - Update.write(...)
  - Update.end(true)
  - Update.abort()
  - Update.printError(Serial)
- Firmware-size precheck uses the Arduino ESP.getFreeSketchSpace() API.
- Reset-reason reporting uses the Arduino ESP.getResetReason() API.
- Removed direct OTA/ESP-IDF implementation dependencies from the firmware source:
  - esp_ota_*
  - esp_err_t
  - esp_err_to_name
  - ESP_ERR_*
  - raw FreeRTOS portMUX queue locking
  - Bluedroid/NimBLE-specific callback overload blocks
- BLE queues now use the project's single-producer/single-consumer application flow instead of the removed raw portMUX layer.
- Cleaned the fan-PWM indentation defect, removed an empty no-op BLE block, and corrected the boot banner to print the actual FW_VERSION.

### Behavior deliberately preserved

- JE X FYZ BLE service/name/UUID contract remains unchanged.
- GPIO authority remains:
  - GPIO0 NTC
  - GPIO1 touch
  - GPIO3 12V selector
  - GPIO4 9V selector
  - GPIO5 Fan
  - GPIO6 Peltier
  - GPIO7 WS2812B
- Boot Local OTA AP remains deferred from setup() into the first loop() iteration to preserve the controlled Horizon-style runtime boundary.
- Boot AP timeout remains 10 seconds.
- BLE remains the post-Wi-Fi handoff radio.
- OTA safety output shutdown, NTC safety, voltage guards, adaptive logic, PWM, RGB, BLE protocol, settings persistence, and online Range/Retry policy were not intentionally redesigned.
- Online OTA continues to use HTTPS with the pinned GitHub CA certificate and Range probing/chunks/retry logic.
- No SHA-based firmware manifest mechanism was introduced.

### Validation status

- Static source audit before commit: PASS.
- No raw esp_ota_*, esp_err_*, ESP_ERR_*, portMUX, or configuration-specific BLE callback blocks remain in the V1.3 source.
- The CI workflow now explicitly fails if those non-Arduino implementation paths reappear.
- V1.3 CI build has not yet been triggered after this source/CI change.
- Public firmware repository is still on V1.2 until the next successful V1.3 build-and-publish run.
- Next execution boundary: trigger the Firmware Build, verify ArduinoDroid/Core 3.3.7 compile, verify Arduino Standard + OTA audit, verify ESP32-C3 binary generation, then physically flash V1.3 and capture Serial boot/OTA evidence.

## 2026-09-27 — CI AUDIT ALIGNMENT AFTER V1.1 DIAGNOSTIC

- Action: removed only the obsolete hardcoded V1.0 assertion from `.github/workflows/firmware-build.yml`.
- Reason: the source diagnostic revision is V1.1 by project version policy; the workflow already has a separate `Extract firmware version` step that validates the `Vx.y` format, so a fixed V1.0 assertion would reject the intended diagnostic source before compile.
- CI platform remains pinned to Arduino-ESP32 Core 3.3.7 with OneButton 2.6.1 and Adafruit NeoPixel 1.12.5.
- Repository commit: `3b046b7d8084dbad0059577925bccc23d07ed001`.
- Static validation after this CI-only edit: PASS. Verified V1.1 source token, all OTA protected-source audit requirements present, OTA supervisor precedes feature processing, no `delay()` inside the locked OTA engine, Core 3.3.7 pin remains, and the V1.0 hardcoded audit assertion is gone.
- Build status: still not run; no `arduino-cli` is available in the current container, and the project keeps CI firmware compilation behind the explicit `Eksekusi Firmware` action.
- Runtime/root-cause status: unchanged — the V1.1 radio diagnostic has not yet been physically tested, so no root cause is declared.
- Next boundary: run the dedicated Firmware Build for V1.1, then physically test the boot Serial markers. Do not add another runtime patch until the last successful radio-start boundary is known.



## 2026-09-27 — V1.1 RADIO DIAGNOSTIC SOURCE STEP

- Action: replaced only the initial boot-AP startup boundary in `firmware/JEXFYZ.ino`.
- Reason: Core 3.3.7 official source shows `WiFi.softAP()` already performs `AP.begin()` and `AP.create()`; therefore the previous pre-sequence `WiFi.disconnect(true, false)` -> `WiFi.setHostname()` -> `WiFi.setAutoReconnect(false)` -> `WiFi.mode(WIFI_AP)` was not part of the official high-level AP startup path.
- Official source verified at Arduino-ESP32 Core 3.3.7:
  - `libraries/WiFi/src/WiFiAP.cpp`: `softAP(...)` returns `AP.begin() && AP.create(...)`.
  - `libraries/WiFi/src/AP.cpp`: `AP.begin()` calls `WiFi.enableAP(true)` and waits for `ESP_NETIF_STARTED_BIT`.
  - `libraries/WiFi/src/WiFiGeneric.cpp`: `enableAP(true)` calls `mode(currentMode | WIFI_MODE_AP)`; `getMode()` returns `WIFI_MODE_NULL` before low-level Wi-Fi initialization.
  - `libraries/WiFi/src/STA.cpp`: `STA.disconnect()` directly calls `esp_wifi_disconnect()`; the startup diagnostic therefore removes that pre-init teardown call rather than relying on it.
  - Official `WiFiAccessPoint.ino` uses the high-level `WiFi.softAP(ssid, password)` path directly.
- Source change: `startLocalOtaAp()` now starts with official `WiFi.softAP(AP_SSID, AP_PASSWORD)`, then retains the JE X FYZ fixed `WiFi.softAPConfig(...)` and HTTP server setup. BLE, OTA engine, safety logic, PWM, NTC, and feature state were not intentionally changed.
- Firmware version in source advanced from V1.0 to V1.1 because executable firmware behavior changed. V1.1 is a controlled diagnostic source revision, not a production release.
- Repository commit: `379bf1fce91d0df84ab905e23a9820de2d20a9cb`.
- Static source validation after the edit: PASS. Verified V1.1 marker, direct official `WiFi.softAP()`, no initial `WiFi.disconnect(true, false)`, no direct `WiFi.mode(WIFI_AP)` in the initial AP function, `softAPConfig` after SoftAP, and HTTP start after AP bring-up.
- Build status: not run in this step. The active execution rule keeps firmware CI behind the explicit `Eksekusi Firmware` command, and this container has no `arduino-cli` toolchain installed for a local Core 3.3.7 compile.
- Runtime/root-cause status: **still unproven**. The physical panic dump has not been captured; V1.1 must be tested from Serial boot markers to identify the exact last successful boundary.
- Next boundary: compile V1.1 only through the explicit firmware-build action, then physically flash/test and preserve the exact Serial/Guru Meditation output. Do not add BLE or unrelated recovery changes before the radio boundary is proven.

## 2026-09-27 — PASSIVE LIVING-NOTES GOVERNANCE

- Discussion result: project notes are now treated as passive, continuously evolving memory.
- Rule: every JE X FYZ discussion and every execution must leave the relevant notes more current than before, even when no code change occurs.
- Discussion-only updates may record decisions, verified official-source findings, contradictions, diagnostics, runtime evidence, and next boundaries.
- Code/repository modification and build execution still require the explicit user command `Eksekusi Full`.
- Current source/state consistency correction: the actual `firmware/JEXFYZ.ino` is V1.1 diagnostic source; the previous V1.0 physical-panic baseline remains historical/unvalidated.
- No executable source or build was changed by this governance update.
- Unresolved issue: physical V1.1 radio-boundary test and exact Guru Meditation/Serial evidence are still pending.

## 2026-09-27 — DISCUSSION: ISOLATED WIFI OTA TEST PLAN

- User decision: create a separate minimal firmware whose only purpose is to test whether Wi-Fi OTA itself works on the ESP32-C3; the user will compile/flash it manually with ArduinoDroid.
- This is a discussion-stage plan only. No .ino test file was created, no production source was changed, and no build was executed.
- Diagnostic principle: completely isolate the production JE X FYZ firmware. Do not include BLE, NTC, Fan/Peltier control, touch, RGB, Preferences, Adaptive logic, online OTA, or custom radio handoff.
- Official Core 3.3.7 OTA reference verified: libraries/WebServer/examples/WebUpdate/WebUpdate.ino uses WiFi.h, NetworkClient.h, WebServer.h, and Update.h; it starts Wi-Fi, serves /, accepts firmware at /update, uses the official Update.begin() / Update.write() / Update.end(true) lifecycle, and then restarts.
- Official Core 3.3.7 AP reference remains WiFi.softAP(ssid, password).
- Diagnostic goal: first prove the board can run a minimal official-style SoftAP + WebServer OTA path under the user's exact ArduinoDroid/Core 3.3.7 environment. A successful test isolates the earlier panic to interaction with JE X FYZ runtime layers; a failed test points investigation back toward board/toolchain/standalone Wi-Fi OTA behavior.
- The standalone test should use explicit Serial markers around boot, SoftAP start/result, server start, OTA upload start/write/end, OTA error, and restart so the exact failure boundary is visible.
- Versioning: use a diagnostic/test label separate from the production V1.x sequence unless the user explicitly chooses otherwise.
- Execution lock: the actual .ino generation is reserved for the explicit Eksekusi Full command under the current project governance.
- Next boundary: user may issue Eksekusi Full to generate only the standalone .ino, intended for manual ArduinoDroid compilation/flash and physical OTA testing.
## 2026-09-27 — EXECUTION: STANDALONE WIFI OTA TEST FILE

- User explicitly requested `Eksekusi Full` to generate a standalone .ino for manual ArduinoDroid testing.
- Generated file: `JEXFYZ-WiFi-OTA-Test.ino` in the conversation workspace. It is intentionally separate from the production repository firmware source.
- Scope: Wi-Fi SoftAP + WebServer + official Update OTA only. No BLE, NTC, Fan/Peltier control, touch, RGB, Preferences, Adaptive, cloud OTA, or JE X FYZ radio handoff logic.
- Official Core 3.3.7 APIs verified before/while generating: `WiFi.softAP()`, `WebServer`, `server.upload()`, `Update.begin()`, `Update.write()`, `Update.end(true)`, `Update.abort()`, and `UPLOAD_FILE_ABORTED`.
- Diagnostic Serial markers cover boot, SoftAP result, AP IP, HTTP readiness, OTA upload start/write/end, abort, errors, success, and restart.
- Static validation: PASS. Required include/API/lifecycle markers are present.
- Local compile validation: not performed because `arduino-cli` is not installed in the current container. The intended compile target is the user's manual ArduinoDroid environment using Arduino-ESP32 Core 3.3.7.
- Production `firmware/JEXFYZ.ino` was not modified by this standalone test-file generation.
- Runtime/root-cause status: still unproven. The standalone physical test is now the next diagnostic boundary.
- Next boundary: compile/flash this standalone .ino manually in ArduinoDroid, connect to the `JE X FYZ OTA TEST` SoftAP, open `http://192.168.4.1/`, and test a known-good ESP32 firmware .bin upload. Preserve the Serial output exactly.
## 2026-09-27 — RUNTIME RESULT: STANDALONE WIFI OTA TEST SSID NOT VISIBLE

- User physical-test result: after manually compiling/flashing the standalone `JEXFYZ-WiFi-OTA-Test.ino`, the configured Wi-Fi SSID was not visible.
- The standalone file was inspected locally: it calls `WiFi.softAP(AP_SSID, AP_PASSWORD)` directly before WebServer setup, with no BLE or JE X FYZ production runtime layers.
- Official Core 3.3.7 reference remains the same: `WiFiAccessPoint.ino` starts AP directly with `WiFi.softAP(ssid, password)`; the WebUpdate example adds WebServer/Update only after Wi-Fi connection/startup.
- Current diagnostic conclusion: the failure boundary is still unknown. We do not yet know whether the board panics/stops inside `WiFi.softAP()`, returns `false`, starts AP but fails visibility, or is being compiled/flashed with a different ArduinoDroid/Core/board configuration.
- Important isolation decision: do not modify OTA logic yet. The next diagnostic should remove WebServer and Update entirely and use the smallest official-style SoftAP-only sketch, with Serial markers immediately before and after `WiFi.softAP()` and an AP IP print.
- Exact Serial output is now the key evidence. Preserve every line from reset through failure/reboot; especially capture whether `WIFI: STEP 1 SOFTAP` is followed by `SOFTAP RESULT=OK` or a panic/reset.
- No production JE X FYZ source was changed in this discussion.
- No new executable test file was generated in this discussion.
- Next boundary: an `Eksekusi Full` step may generate the SoftAP-only diagnostic file. Do not add OTA/WebServer back until the SoftAP-only boundary is proven.

## 2026-09-27 — EXECUTION: SOFTAP-ONLY DIAGNOSTIC FILE

- User explicitly requested `Eksekusi Full` after the standalone Wi-Fi OTA test failed to expose an SSID.
- Generated file: `JEXFYZ-SoftAP-Only-Test.ino` in the conversation workspace.
- Scope is intentionally reduced to the smallest AP boundary: `#include <WiFi.h>`, `WiFi.softAP(ssid, password)`, and `WiFi.softAPIP()` with Serial markers. No WebServer, Update OTA, BLE, NTC, cooling, RGB, touch, Preferences, or other project libraries.
- The AP call follows the verified Arduino-ESP32 Core 3.3.7 official `WiFiAccessPoint.ino` pattern.
- SSID for this diagnostic: `JE X FYZ SOFTAP TEST`; password: `0987654321`.
- Serial boundary markers explicitly identify: before `WiFi.softAP()`, its returned result, SSID, AP IP, and final AP-ready state.
- Static validation: PASS. Required WiFi APIs/markers are present and the forbidden application/OTA/BLE libraries are absent.
- Compile/flash validation: not performed here; intended manual compile target remains ArduinoDroid with Arduino-ESP32 Core 3.3.7.
- Production `firmware/JEXFYZ.ino` was not changed by this diagnostic.
- Runtime/root-cause status: remains unproven until the SoftAP-only sketch is physically tested.
- Next boundary: flash this sketch and preserve the exact Serial output. The critical evidence is whether `STEP 2: WiFi.softAP() RESULT = OK` appears and whether `RESULT: SOFTAP READY` is reached.

## 2026-09-27 — EXECUTION: WIFI MODE AP-ONLY DIAGNOSTIC

- User supplied physical Serial evidence from the previous SoftAP-only test. The device prints STEP 1: BEFORE WiFi.softAP() and then immediately reports Guru Meditation Error: Core 0 panic'ed (Load access fault); WiFi.softAP() never returns.
- This rules out WebServer and OTA Update as the immediate failure boundary for that test, but WiFi.softAP() internally contains multiple official Wi-Fi/AP lifecycle steps, so the exact internal boundary was still unresolved.
- Official Arduino-ESP32 Core 3.3.7 source verified again:
  - WiFi.softAP() in WiFiAP.cpp calls AP.begin() and AP.create().
  - AP.begin() calls WiFi.enableAP(true) and waits for ESP_NETIF_STARTED_BIT.
  - WiFiGenericClass::enableAP(true) calls the official mode(currentMode | WIFI_MODE_AP) path.
  - WiFiGenericClass::getMode() returns WIFI_MODE_NULL before Wi-Fi low-level initialization.
  - ESP.getCoreVersion() is the official Core-version reporting API and returns ESP_ARDUINO_VERSION_STR.
- User explicitly requested Eksekusi Full. Generated standalone diagnostic file: JEXFYZ-WiFi-Mode-AP-Test.ino.
- Scope: Arduino.h + WiFi.h only; it prints the actual compiled Arduino-ESP32 Core version, chip model/revision, calls WiFi.getMode(), then calls only WiFi.mode(WIFI_AP) and verifies the returned mode. It does not call WiFi.softAP(), WebServer, Update, BLE, or any JE X FYZ feature library.
- Static validation: PASS.
- Build/flash validation: not performed here; user will compile/flash manually in ArduinoDroid.
- Production firmware/JEXFYZ.ino was not modified.
- Current root-cause status: still unproven. The purpose of this test is to distinguish an AP-mode failure from a later AP.create() failure inside the official WiFi.softAP() implementation.
- Next boundary: flash the new test and preserve the entire Serial output. The most important lines are the actual Arduino-ESP32 Core value, STEP 3, and whether STEP 4 is reached or the device panics.

## 2026-09-27 — RUNTIME RESULT: WIFI MODE AP PANICS

- User physical-test result from `JEXFYZ-WiFi-Mode-AP-Test.ino`: actual compiled Arduino-ESP32 Core reported by the official `ESP.getCoreVersion()` API is `3.3.7`.
- Hardware runtime reported by the sketch: Chip = ESP32-C3, Chip revision = 4.
- `WiFi.getMode()` before initialization returned `0`, matching the official Core 3.3.7 `getMode()` path's `WIFI_MODE_NULL` result before low-level Wi-Fi initialization.
- The sketch printed `STEP 3: BEFORE WiFi.mode(WIFI_AP)` and then immediately panicked with `Guru Meditation Error: Core 0 panic'ed (Load access fault)`; `STEP 4: WiFi.mode(WIFI_AP) RESULT` was never reached.
- This narrows the failure boundary from the public `WiFi.softAP()` call to the official `WiFi.mode(WIFI_AP)` path itself or an internal function it invokes.
- Official Core 3.3.7 source reviewed for this boundary: `WiFiGenericClass::mode()` first checks `getMode()`; when Wi-Fi is not initialized and a non-zero mode is requested, it calls the internal official `wifiLowLevelInit(_persistent)`; that path calls `Network.begin()`, then `esp_wifi_init(&cfg)`, registers Wi-Fi events, creates default AP/STA network interfaces, and posts the Wi-Fi ready event.
- Official Network Manager source/docs verified: public global `Network.begin()` initializes the ESP-IDF network interface system through `esp_netif_init()` and initializes network events; the official Network API documentation explicitly presents `Network.begin()` as the initialization entry point.
- Diagnostic conclusion: OTA, WebServer, `WiFi.softAP()` credential/configuration, and JE X FYZ production feature layers are no longer part of this immediate failure boundary. The exact failing internal step is still not proven.
- User explicitly requested `Eksekusi Full`. Generated `JEXFYZ-Network-Begin-Test.ino` containing only `Arduino.h` + official `Network.h`, the actual Core/chip reporting APIs, and `Network.begin()`.
- Static validation: PASS. No Wi-Fi mode/AP, WebServer, Update, BLE, Preferences, NeoPixel, or OneButton calls are present.
- Build/flash validation: not performed here; manual ArduinoDroid test is the next step.
- Production `firmware/JEXFYZ.ino` was not modified.
- Next boundary: flash the Network.begin-only diagnostic and preserve the complete Serial output. The key result is whether `STEP 2: Network.begin() RESULT = OK` is reached or the board panics inside `Network.begin()`.

## 2026-09-27 — RUNTIME RESULT: NETWORK BEGIN TEST ALSO NO SSID

- User reports that the new `JEXFYZ-Network-Begin-Test.ino` also does not result in a visible Wi-Fi SSID.
- No Serial screenshot/output for the Network.begin-only sketch was provided yet, so the exact failure boundary remains unclassified.
- Official Core 3.3.7 source inspection reached `NetworkManager::begin()`: it calls `esp_netif_init()` once and then `initNetworkEvents()`; `initNetworkEvents()` creates the Arduino event group/queue, calls `esp_event_loop_create_default()`, and creates the Arduino network-event task.
- This means the next evidence needed is not another higher-level Wi-Fi sketch. We need to know whether `Network.begin()` itself returns, returns false, or panics inside `esp_netif_init()` / event initialization.
- Diagnostic rule: do not infer hardware failure or change the production firmware from the absence of an SSID alone.
- The previous test already proved the actual Arduino-ESP32 Core is 3.3.7 and the target reports ESP32-C3 revision 4.
- No executable source was changed in this discussion and no build was executed.
- Next boundary: obtain the complete Serial output from `JEXFYZ-Network-Begin-Test.ino`, especially whether `STEP 2: Network.begin() RESULT = OK` appears. Based on that evidence, choose exactly one lower-level diagnostic boundary.

## 2026-09-27 — CORRECTION: NETWORK-BEGIN TEST HAS NO AP BY DESIGN

- Discussion correction: the prior interpretation of the user's statement "SSID tetap tidak muncul" for the Network-begin diagnostic was incorrect.
- The Network-begin diagnostic intentionally contains only Network.begin() and does not call WiFi.mode() or WiFi.softAP(). Therefore it is expected that no Wi-Fi SSID is broadcast by this sketch.
- The test's valid success/failure evidence is its Serial boundary: whether STEP 2: Network.begin() RESULT = OK is printed, whether it prints RESULT: NETWORK BEGIN FAILED, or whether the MCU panics/resets before returning from Network.begin().
- No claim can currently be made about the result of Network.begin() because the corresponding Serial output has not been supplied.
- Important reasoning correction: absence of an SSID must only be evaluated by a test whose purpose includes AP creation. This distinction is now part of the diagnostic boundary.
- No executable source was changed and no build was executed in this discussion.
- Next boundary: interpret the existing Network-begin test strictly from its Serial output; if it completes successfully, proceed to isolate the next official initialization step. Do not infer failure from SSID visibility for this sketch.
## 2026-09-27 — EXECUTION: WIFI LOW-LEVEL INIT DIAGNOSTIC

- User explicitly requested `Eksekusi Full` after the `WiFi.mode(WIFI_AP)` panic evidence.
- Created standalone diagnostic file `JEXFYZ-WiFi-LowLevel-Init-Test.ino` for manual ArduinoDroid testing.
- Diagnostic sequence follows the verified Arduino-ESP32 Core 3.3.7 `wifiLowLevelInit()` ordering only through the `esp_wifi_init()` boundary: report actual Core/chip -> `Network.begin()` -> `WIFI_INIT_CONFIG_DEFAULT()` -> apply the exact non-static-buffer configuration used by Core 3.3.7 -> `esp_wifi_init(&cfg)`.
- The test intentionally does not call AP mode, SoftAP, WebServer, Update OTA, BLE, or any JE X FYZ feature.
- Official source basis verified: Core 3.3.7 `WiFiGeneric.cpp` calls `Network.begin()` before `esp_wifi_init(&cfg)`, and uses `WIFI_INIT_CONFIG_DEFAULT()` with static_tx_buf_num=0, dynamic_tx_buf_num=32, tx_buf_type=1, cache_tx_buf_num=4, static_rx_buf_num=4, dynamic_rx_buf_num=32 when static buffers are disabled.
- Static isolation/API validation: PASS. The generated file contains the required official APIs and no executable AP/WebServer/OTA/BLE/application calls.
- Build/flash validation: not performed here; manual ArduinoDroid testing is required.
- Production `firmware/JEXFYZ.ino` was not modified by this diagnostic.
- Runtime/root-cause status: unresolved. This test is designed to distinguish `Network.begin()` failure from `esp_wifi_init()` failure using separate Serial boundaries.
- Important correction from prior discussion: absence of an SSID is irrelevant for this low-level diagnostic because AP creation is intentionally not attempted.
- Next boundary: flash the low-level diagnostic and preserve the complete Serial output, especially STEP 1 through STEP 7.
## 2026-09-27 — DISCUSSION: HARDWARE TARGET CONFIRMED

- User reconfirmed the physical hardware target: **ESP32-C3 Super Mini**.
- This is consistent with the physical diagnostic output: Chip = ESP32-C3, Chip revision = 4, and the actual compiled Arduino-ESP32 Core = 3.3.7.
- Manual ArduinoDroid board target remains the project reference: **ESP32C3 Dev Module**.
- The current low-level Wi-Fi diagnostic files are intended for this ESP32-C3 hardware and Core 3.3.7 environment.
- No executable source was changed and no build was executed by this discussion; this is a hardware-target clarification only.
- Next boundary remains the existing low-level Wi-Fi initialization diagnostic; interpret results from Serial rather than SSID visibility when the sketch does not create an AP.
## 2026-09-27 — DISCUSSION: STOP SPECULATIVE TEST GENERATION / VERIFY TOOLCHAIN PATH

- User reported that the low-level diagnostic still does not appear to work. Correction: lack of an SSID is not evidence for `JEXFYZ-Network-Begin-Test.ino` because that sketch intentionally does not create an AP.
- Current confirmed runtime boundary from the preceding test is still `WiFi.mode(WIFI_AP)`: actual Arduino-ESP32 Core reported `3.3.7`, chip `ESP32-C3` revision `4`, `WiFi.getMode()` returned `0`, and `WiFi.mode(WIFI_AP)` was followed by a Core 0 Load access fault before returning.
- The result of `Network.begin()` itself is still unverified because its Serial output has not been provided.
- Discussion decision: stop generating speculative diagnostic sketches until the previous boundary is verified. The next evidence required is the complete Serial output from `JEXFYZ-Network-Begin-Test.ino` and/or the ArduinoDroid compile log showing the actual selected WiFi library/core paths.
- Toolchain/library selection must be checked because `ESP.getCoreVersion()` proves the Arduino core version but does not by itself prove that no conflicting external `WiFi.h` library was selected by the build environment.
- No executable source was changed and no build was executed in this discussion.
- Next boundary: inspect the ArduinoDroid compile log and the actual Network-begin Serial result before choosing another test. The official Core 3.3.7 source remains the authority; do not add more custom Wi-Fi lifecycle code until the selected library and current failure boundary are established.
> Current-state override for the next JE X FYZ firmware sub-chat. Historical sections below are retained for chronology.

## 1. Mandatory workflow
Before every firmware conversation or action, read this note and the firmware master context, then inspect the newest `firmware/JEXFYZ.ino`. For cross-layer work, read the app context as well.
The living notes are passive project memory and must continue to grow during both discussion and execution. A discussion may update notes to record decisions, verified findings, contradictions, open questions, and next boundaries without changing executable source.
After every material discussion or action, immediately record the discussion/action, reason, affected file/repository when applicable, actual result or current finding, commit/run/version when available, unresolved issue, and next boundary.
Code edits and build execution remain locked until the user explicitly commands `Eksekusi Full`.

## 2. Official-source-first
Pinned platform: Arduino-ESP32 Core 3.3.7.
Official source repository:
https://github.com/espressif/arduino-esp32
Verified references:
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/examples/WiFiAccessPoint/WiFiAccessPoint.ino
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/WiFiAP.cpp
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/AP.cpp
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/WiFiGeneric.cpp
- https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/src/STA.cpp

Official AP path verified:
`WiFi.softAP(ssid, password)` → `AP.begin()` + `AP.create()` → `WiFi.enableAP(true)` → official `WiFiGenericClass::mode()` path.
`AP.begin()` waits for `ESP_NETIF_STARTED_BIT`.

Rule: do not invent a custom radio lifecycle when the pinned upstream implementation already provides the required behavior.

## 3. Active firmware state
- Active source diagnostic version: V1.1
- V1.0 remains the prior physically unvalidated baseline.
- Source: `firmware/JEXFYZ.ino`
- BLE name: JE X FYZ
- Protocol: P1
- Target: ESP32-C3 Super Mini
- Current authoritative pins: GPIO0 NTC, GPIO1 touch, GPIO3 12V, GPIO4 9V, GPIO5 Fan, GPIO6 Peltier, GPIO7 WS2812B.
- GPIO5/GPIO6 must never be silently swapped.

## 4. V1.0 build evidence
Firmware GitHub Actions Run #66:
- ID 36264460597
- SUCCESS
- Core 3.3.7/ArduinoDroid validation PASS
- ESP32-C3 release compile PASS
- OTA source audit PASS
- artifacts PASS
- public publish PASS

Public binary:
https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.0.bin

Manifest:
https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/manifest.json

CI success is compile/publish evidence only.

## 5. V1.0 physical validation
The user manually flashed V1.0 and reported that the ESP32-C3 **still panics during boot**.
Therefore V1.0 is **NOT physically validated**.
The exact V1.0 Guru Meditation register dump is not yet captured in the notes and must be preserved at the next test.

## 6. Official-source finding and current suspect
The active V1.0 source currently performs:
`WiFi.disconnect(true, false)` → `WiFi.setHostname("JE-X-FYZ")` → `WiFi.setAutoReconnect(false)` → `WiFi.mode(WIFI_AP)` → `WiFi.softAPConfig(...)` → `WiFi.softAP(...)`.

The official Core 3.3.7 example does not require this custom pre-sequence. Because V1.0 still panics, the custom pre-sequence is now **suspect / under investigation**, but it is **not proven** to be the root cause.

## 7. Previous runtime evidence
- V4.13: Core 0 Load access fault during Wi-Fi AP startup.
- V5.0: Core 0 Load access fault around `WiFi.mode(WIFI_AP)`.
- V1.0: physical panic repeated after manual flash.

This repeated pattern requires boundary isolation, not more speculative patch stacking.

## 8. Next diagnostic

## 2026-09-27 — RAW ESP-IDF WIFI BOUNDARY TEST GENERATED
- A standalone diagnostic sketch was generated outside the production firmware:
  `/mnt/data/JEXFYZ-Raw-ESP-IDF-WiFi-Boundary-Test.ino`
- Purpose: isolate the Wi-Fi fault below the Arduino `WiFi.h` wrapper without creating a SoftAP and without adding a custom production radio lifecycle.
- The sketch uses the exact public ESP-IDF calls observed in Arduino-ESP32 Core 3.3.7's `wifiLowLevelInit()` path: `esp_netif_init()`, `esp_event_loop_create_default()`, `WIFI_INIT_CONFIG_DEFAULT()` with the Core 3.3.7 non-static buffer values, `esp_wifi_init()`, `esp_wifi_set_storage(WIFI_STORAGE_RAM)`, `esp_wifi_set_mode(WIFI_MODE_AP)`, `esp_wifi_start()`, and `esp_wifi_get_mode()`.
- The sketch prints a numbered marker before and after every boundary and stops on an unexpected ESP-IDF error.
- It intentionally does **not** call `WiFi.softAP()`, create an AP SSID, or initialize BLE.
- This is diagnostic-only; no production source was changed.
- Validation status: file generation confirmed in the workspace; physical execution result is **NOT YET VERIFIED**.
- Important interpretation: because this test does not create a SoftAP, no SSID is expected. Its purpose is to identify the first failing low-level Wi-Fi call.
- Next evidence boundary: ArduinoDroid compile output and the Serial marker/result from this exact file.


## 2026-09-27 — RAW ESP-IDF TEST FIXED
- The first raw ESP-IDF diagnostic file failed to compile in ArduinoDroid with `redefinition of default argument` because `printResult(..., bool allowAlreadyInit = false)` conflicted with Arduino's generated function prototype.
- A corrected diagnostic file was generated:
  `/mnt/data/JEXFYZ-Raw-ESP-IDF-WiFi-Boundary-Test-FIXED.ino`
- The corrected `printResult()` declaration has **no default argument**; every call supplies the third parameter explicitly.
- Static check: PASS for removal of the default argument.
- Production firmware source was not modified.
- Physical execution and hardware result remain unverified.

## 2026-09-27 — RUNTIME RESULT: RAW ESP-IDF WIFI TEST PANICS AT CONFIG MACRO
- User physically ran `JEXFYZ-Raw-ESP-IDF-WiFi-Boundary-Test-FIXED.ino` in ArduinoDroid and supplied the complete Serial boundary screenshot.
- Confirmed runtime environment: Arduino-ESP32 Core `3.3.7`, chip `ESP32-C3`, revision `4`.
- `esp_netif_init()` returned `ESP_OK` (0x0).
- `esp_event_loop_create_default()` returned `ESP_OK` (0x0).
- The sketch printed `STEP 5: BUILD OFFICIAL CORE 3.3.7 WIFI CONFIG`, then immediately produced `Guru Meditation Error: Core 0 panic'ed (Load access fault)`.
- `STEP 6: WIFI CONFIG READY` was never reached. Therefore this test did **not** reach `esp_wifi_init()`, `esp_wifi_set_mode()`, `esp_wifi_start()`, or AP creation.
- Official ESP-IDF v5.5 source was inspected because Arduino-ESP32 Core 3.3.7 declares its bundled `esp32-arduino-libs` package as `idf-release_v5.5-87912cd2-v3`.
- In the official ESP-IDF v5.5 `esp_wifi.h`, `WIFI_INIT_CONFIG_DEFAULT()` is a designated initializer for `wifi_init_config_t`. It reads the exported `g_wifi_default_wpa_crypto_funcs` object into the local configuration and takes the address of `g_wifi_osi_funcs`; it is not itself a Wi-Fi start/AP call.
- Current diagnostic conclusion: the failure boundary is now **below the Arduino WiFi wrapper and before the `esp_wifi_init()` API call**. A likely class of causes is an invalid/incompatible access while materializing the official Wi-Fi init configuration (for example a header/binary/toolchain/library mismatch), but this is **not yet proven** from the available evidence.
- Important: do not claim that the ESP32 Wi-Fi driver itself is proven faulty. The exact PC-to-symbol mapping is not available because the standalone ArduinoDroid test ELF/map was not captured.
- Required next evidence before another production change or another speculative test: the ArduinoDroid compile output/library-selection information for this exact sketch, including any `Multiple libraries were found` lines and the selected ESP32 core/library paths. This is needed to establish whether the header and linked Wi-Fi binary come from the expected Core 3.3.7 / IDF 5.5 package.
- Production `firmware/JEXFYZ.ino` was not modified by this runtime test.

## 2026-09-27 — DISCUSSION: HORIZON COOLER WIFI PATH COMPARISON
- User supplied the full `HorizonCooler.ino` source for direct comparison with the current JE X FYZ firmware.
- Horizon uses the same public Arduino Wi-Fi operations that JE X FYZ ultimately relies on:
  - `WiFi.mode(WIFI_AP)`
  - `WiFi.softAP("Horizon Cooler")`
  - `server.begin()`
- Horizon does **not** call `WIFI_INIT_CONFIG_DEFAULT()`, `esp_wifi_init()`, `esp_wifi_set_mode()`, or other raw `esp_wifi_*()` APIs. Its Wi-Fi startup is delegated entirely to Arduino's `WiFi.h` implementation.
- Horizon's Wi-Fi AP is **not started during `setup()`**. Normal boot initializes hardware, Preferences, RGB, OTA routes, and then starts BLE through `enableBleSignal()`. The Wi-Fi AP is later entered from the main loop after the user holds the left button for 5 seconds.
- The Horizon Wi-Fi path is:
  `disableAllRadios()` → `WiFi.mode(WIFI_AP)` → `WiFi.softAP("Horizon Cooler")` → `server.begin()`.
- In `disableAllRadios()`, Wi-Fi is only stopped when `isWifiActive == true`; on a normal BLE-only boot this is false, so there is no pre-existing Wi-Fi session that Horizon depends on. BLE advertising is suspended immediately before AP startup.
- Therefore the strongest code-level difference is **runtime/startup timing and radio state**, not the high-level Wi-Fi API itself: Horizon lets the complete boot/BLE initialization finish and only starts AP later from `loop()`; current JE X FYZ starts the AP inside `setup()`.
- A second important difference is diagnostic scope: the recent raw ESP-IDF test directly included `esp_wifi.h` and invoked `WIFI_INIT_CONFIG_DEFAULT()`. Horizon never exercises that macro from sketch code. The raw test's crash at the macro therefore must not be interpreted as proof that Horizon's working Arduino Wi-Fi driver is broken.
- Official Arduino-ESP32 Core 3.3.7 remains authoritative: the Arduino `WiFi.mode()` implementation owns the low-level initialization internally. The Horizon source supports keeping production code at the public Arduino Wi-Fi layer rather than reproducing internal driver initialization.
- Current working hypothesis ranking is therefore:
  1. a boot-time/runtime-state difference between Horizon and JE X FYZ;
  2. an ArduinoDroid/library-selection or binary/header mismatch affecting the JE X FYZ build;
  3. an application-specific interaction that corrupts state before the Wi-Fi call.
  No item is declared proven from source comparison alone.
- Next diagnostic principle: reproduce **Horizon's exact public Wi-Fi sequence**, with no raw `esp_wifi.h` / `WIFI_INIT_CONFIG_DEFAULT()`, but invoke it only after boot has completed and from the main loop. Compare the result with the current immediate-`setup()` failure. This is a diagnostic boundary only; no production feature change has been made.
- Production `firmware/JEXFYZ.ino` was not modified by this discussion.

## 2026-09-27 — EXECUTION: HORIZON-STYLE DEFERRED WIFI AP (V1.2)
- User explicitly authorized `Eksekusi Full`.
- Inspected current production source SHA before editing: `d2e9b210e3c059bbbac62ca0197895a3a8409b3d`.
- Applied one controlled runtime change based on the direct HorizonCooler.ino comparison:
  - active firmware marker advanced from V1.1 to **V1.2** because executable behavior changed;
  - `bootApActive` now starts false;
  - added `bootApPending`;
  - removed the direct `startLocalOtaAp()` call from `setup()`;
  - `setup()` now only marks the boot AP as pending;
  - the first `loop()` iteration consumes `bootApPending` and calls `startLocalOtaAp()`.
- No raw `esp_wifi_*` APIs, `WIFI_INIT_CONFIG_DEFAULT()`, BLE implementation, OTA engine, safety logic, GPIO mapping, NTC logic, PWM logic, or application protocol was changed.
- Purpose: isolate the Horizon-vs-JE difference of **Wi-Fi AP invocation from setup() versus loop()** while retaining the existing official Arduino `WiFi.softAP()` path.
- Source static checks: PASS. Verified V1.2 marker, deferred-start marker, loop-start marker, `bootApActive=false`, and removal of the previous direct setup() AP call.
- Repository commit: `bb4b271c2ef6c21bb779b65008ab24c6f98cd080`.
- Build status at this exact action: not yet executed; the workflow is intentionally triggered separately by its dedicated trigger file.
- Hardware result: not yet verified.
- Diagnostic interpretation: this is a controlled test of startup context/timing, not a claim that Horizon's behavior proves the root cause.
- Next boundary: trigger the existing firmware CI, inspect compile/build result, then physically flash V1.2 and compare the Serial boot boundary.

## 2026-09-27 — EXECUTION: TRIGGER V1.2 FIRMWARE CI
- Updated the dedicated `.github/FIRMWARE_BUILD_TRIGGER` file to start the existing firmware workflow for the V1.2 source.
- Trigger commit: `d7f5110668d64c32d87e08f367c54369474f4306`.
- The workflow remains pinned to Arduino-ESP32 Core 3.3.7, OneButton 2.6.1, and Adafruit NeoPixel 1.12.5.
- No firmware logic changed in this action.
- Next boundary: inspect the newly triggered Firmware Build run for compile result, OTA safety audit, artifact generation, and publication result.

## 2026-09-27 — EXECUTION STATUS: V1.2 FIRMWARE BUILD RUN #67
- Firmware Build Run #67 was triggered successfully from commit `d7f5110668d64c32d87e08f367c54369474f4306`.
- Run ID: `36272350341`.
- Head source/trigger commit: `d7f5110668d64c32d87e08f367c54369474f4306`.
- Current status at this checkpoint: **in_progress**.
- The `validate-arduinodroid` job has started; the later compile step has not yet completed at the time of this note.
- No build success/failure is claimed yet.
- Next boundary: inspect Run #67 completion and its compile/audit/artifact results before declaring V1.2 build status.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 TOOLCHAIN INSTALL
- Run #67 remains `in_progress`.
- Job `validate-arduinodroid` is currently installing the pinned ESP32 Arduino Core `3.3.7`; library installation and compilation have not started yet.
- No compile result is available at this checkpoint.
- No hardware conclusion is implied.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 COMPILATION
- Run #67 toolchain installation completed successfully: Arduino-ESP32 Core 3.3.7 and the pinned firmware libraries installed successfully.
- The ArduinoDroid temporary source preparation also completed successfully.
- The `Compile ArduinoDroid temporary source` step is currently `in_progress`.
- No final compile conclusion is claimed yet.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 ARDUINODROID COMPILE ACTIVE
- The pinned Core 3.3.7/toolchain/library setup is complete and the ArduinoDroid temporary source preparation passed.
- The actual ArduinoDroid compile step is still active; no compile success/failure is claimed yet.
- The source under test remains commit `bb4b271c2ef6c21bb779b65008ab24c6f98cd080` with only the Horizon-style setup→loop Wi-Fi deferral change.

## 2026-09-27 — EXECUTION RESULT: RUN #67 ARDUINODROID COMPILE PASS
- Run #67 job `validate-arduinodroid` completed with **success**.
- ESP32 Arduino Core 3.3.7 installation: PASS.
- OneButton 2.6.1 and Adafruit NeoPixel 1.12.5 installation: PASS.
- ArduinoDroid temporary source preparation: PASS.
- ArduinoDroid temporary source compile for ESP32-C3: **PASS**.
- The second job `build-and-publish` is currently queued; release compile/publication results are not yet available.
- This confirms the V1.2 source compiles under the workflow's pinned ArduinoDroid/Core 3.3.7 toolchain. It does **not** prove physical runtime.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 BUILD/PUBLISH ACTIVE
- The ArduinoDroid validation job passed.
- The dependent `build-and-publish` job has started and is currently preparing the Arduino package index.
- Release compile, OTA protected-source audit, artifact upload, and public firmware publication are still pending.
- No public V1.2 binary is claimed yet.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 CORE INSTALL ACTIVE
- `validate-arduinodroid` remains successful.
- `build-and-publish` is now installing the ESP32-C3 Core 3.3.7 in its release-build job.
- Release firmware compilation and publication remain pending.

## 2026-09-27 — EXECUTION STATUS UPDATE: RUN #67 RELEASE COMPILE ACTIVE
- Release job completed Core/library setup and source/audit/version steps.
- The `Compile ESP32-C3 firmware` step is currently `in_progress`.
- No release artifact or public V1.2 firmware is claimed until this compile and subsequent publication steps complete.

## 2026-09-27 — EXECUTION DIAGNOSTIC: BUILD LOG ENDPOINT NOT AVAILABLE THROUGH CONNECTOR
- Attempted to read the active Run #67 job log directly through the GitHub connector's fetch action.
- The connector rejected the job-log endpoint as an unsupported URL for this action; therefore no compile-log interpretation was made from that attempt.
- Run #67 remains the authoritative CI source; continue using its job/step status and final artifacts.

## 2026-09-27 — EXECUTION STATUS CHECKPOINT: RUN #67 RELEASE COMPILE STILL ACTIVE
- ArduinoDroid validation remains **PASS**.
- Release `build-and-publish` job remains `in_progress`.
- `Compile ESP32-C3 firmware` remains `in_progress`; artifact upload and public publication have not started yet.
- No release success/failure is claimed at this checkpoint.

## 2026-09-27 — DISCUSSION: REVIEW OF EXTERNAL GEMINI WIFI-OTA CLAIM
- User supplied screenshots containing an external analysis claiming that the Wi-Fi OTA failure is caused by the project using only a low-level ESP-IDF driver test and lacking active networking/OTA implementation.
- The claim is inconsistent with the actual JE X FYZ source and the diagnostic history:
  - The raw ESP-IDF sketch was explicitly a **diagnostic-only boundary test**, not the production firmware and not the intended OTA implementation.
  - Separate diagnostic sketches already tested the higher-level `WiFi.softAP()` path; the physical `WiFi.softAP()` test reached the call boundary and panicked before returning.
  - The production `firmware/JEXFYZ.ino` contains active local OTA networking: `WebServer webServer(80)`, `WiFi.softAP()`, `webServer.on("/", ...)`, `webServer.on("/update", HTTP_POST, ...)`, `webServer.begin()`, and native `esp_ota_begin/write/end/set_boot_partition`.
  - The production source also contains active online OTA networking through `WiFi.begin()`, `HTTPClient`, `WiFiClientSecure`, HTTPS configuration, and the online OTA state machine.
- Therefore the screenshot's statement that the project "only" uses a low-level ESP-IDF driver test and has no active networking/OTA implementation is **factually incorrect** for the current repository.
- The screenshot nevertheless points at a useful distinction: a raw driver test cannot itself demonstrate functional OTA. That is true, but it does not explain the earlier observed production/SoftAP panic because those were separate tests with higher-level Arduino Wi-Fi APIs.
- Current diagnostic fact remains: the most precise standalone boundary recorded so far is `wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();` in the raw ESP-IDF diagnostic, while the higher-level Arduino boundary previously recorded is `WiFi.mode(WIFI_AP)` / `WiFi.softAP()`. These observations should not be conflated.
- V1.2 has already been created to test one concrete difference found in the working HorizonCooler source: deferring the initial AP invocation from `setup()` into the first `loop()` iteration while keeping the official Arduino Wi-Fi APIs. Run #67 ArduinoDroid/Core 3.3.7 compile validation passed; physical runtime remains pending.
- No production change is made by this discussion.

## 2026-09-27 — USER MANDATE: ARDUINO STANDARD ONLY FOR NEXT FIRMWARE WORK
- User explicitly requires the next firmware implementation/test work to use the **Arduino-standard API/examples**, not custom/invented low-level code.
- For Wi-Fi/OTA, prefer the exact official Arduino-ESP32 Core 3.3.7 public APIs and official examples already verified (for example `WiFi.mode()`, `WiFi.softAP()`, `WebServer`, `Update` where appropriate), following the official lifecycle rather than reproducing internal ESP-IDF initialization.
- Do **not** create homemade wrappers, replacement lifecycle functions, guessed API names, or raw `WIFI_INIT_CONFIG_DEFAULT()` / `esp_wifi_*` startup code for the next production/test path unless the user explicitly requests a low-level diagnostic.
- "Arduino Standard" means: use the implementation style demonstrated by the official Arduino-ESP32 examples/source for the exact pinned Core version; project-specific code may orchestrate those official APIs only where the JE X FYZ requirements require it.
- This mandate supersedes the recent raw ESP-IDF diagnostic approach for the next implementation step. The raw diagnostic remains historical evidence only.
- No executable source changed in this discussion.

## 2026-09-27 — DISCUSSION: OFFICIAL ARDUINO-STANDARD STUDY — CORE 3.3.7
- User requested a full study of the Arduino Standard approach from the official source, with future implementation prohibited from using invented/custom low-level replacements.
- Reviewed the official Espressif Arduino-ESP32 Core 3.3.7 repository documentation and source/examples for the areas directly relevant to JE X FYZ:
  - Wi-Fi API: `docs/en/api/wifi.rst`, official `WiFiAccessPoint.ino`, and the WiFi AP/STA classes.
  - Web OTA: `docs/en/ota_web_update.rst` and official `libraries/WebServer/examples/WebUpdate/WebUpdate.ino`.
  - Network API: `docs/en/api/network.rst`.
  - Arduino OTA: `libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino`.
  - HTTP update: `libraries/HTTPUpdate/examples/httpUpdate/httpUpdate.ino`.
  - Web OTA server: `libraries/HTTPUpdateServer/examples/WebUpdater/WebUpdater.ino`.
  - BLE server: `libraries/BLE/examples/Server/Server.ino`.
  - LEDC/PWM: official ESP32 LEDC examples and 3.x API behavior.
  - ADC/GPIO/timer documentation and examples.
  - 2.x→3.x migration guide for API changes.
- Key official Wi-Fi rule confirmed: the public Arduino path is the intended sketch-level API. The official AP example calls `WiFi.softAP(ssid, password)`; the Arduino core internally owns Wi-Fi initialization/startup. Sketch code should not recreate `WIFI_INIT_CONFIG_DEFAULT()` or `esp_wifi_init()` for ordinary Wi-Fi startup.
- Key official Web OTA rule confirmed: the official `WebUpdate.ino` uses `WiFi.h`, `NetworkClient.h`, `WebServer.h`, and `Update.h`; upload handling uses the Arduino `Update.begin()/write()/end(true)` lifecycle and `server.handleClient()` in `loop()`.
- Key official Arduino OTA rule confirmed: `ArduinoOTA.begin()` is paired with `ArduinoOTA.handle()` from `loop()`; Wi-Fi connection is established first.
- Key official network architecture rule confirmed: Core 3.x exposes a unified `Network` layer and `NetworkClient`/server classes; Wi-Fi implementations sit on that layer.
- Key official 3.x GPIO/PWM/timer direction confirmed: use the current Arduino APIs/examples for the target Core; for LEDC the Core 3.3.7 examples use pin-centric APIs such as `ledcAttach()`, `ledcWrite()`, `ledcChangeFrequency()`, and `ledcDetach()`.
- Important implementation discipline for JE X FYZ:
  1. Prefer official Arduino public API/example patterns over reproducing internal driver code.
  2. Do not invent wrapper functions that duplicate official lifecycle behavior.
  3. Use the exact Core 3.3.7 signatures verified in source/docs; do not rely on older 2.x signatures.
  4. For callbacks/events, respect the official thread/task-safety warnings.
  5. Keep project-specific state machines only where they implement JE X FYZ product requirements, not as replacements for framework initialization.
- Official source links retained as authoritative:
  - https://github.com/espressif/arduino-esp32/tree/3.3.7
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WiFi/examples/WiFiAccessPoint/WiFiAccessPoint.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/WebServer/examples/WebUpdate/WebUpdate.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/ArduinoOTA/examples/BasicOTA/BasicOTA.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/HTTPUpdate/examples/httpUpdate/httpUpdate.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/libraries/HTTPUpdateServer/examples/WebUpdater/WebUpdater.ino
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/docs/en/api/wifi.rst
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/docs/en/ota_web_update.rst
  - https://github.com/espressif/arduino-esp32/blob/3.3.7/docs/en/migration_guides/2.x_to_3.0.rst
- This was a discussion/source-study action only. No executable project source was changed by this study.
- Next implementation boundary: when the user authorizes the next firmware execution, build from the official Arduino Standard examples/APIs for Core 3.3.7 rather than from the recent raw ESP-IDF diagnostic sketches.

## 2026-09-27 — USER MANDATE CONFIRMED: ARDUINO STANDARD IS THE IMPLEMENTATION BASELINE
- User explicitly confirmed that, from this point onward, JE X FYZ firmware implementation must follow **Arduino Standard** for the pinned Arduino-ESP32 Core 3.3.7.
- This is now a standing implementation rule, not merely a preference for the current Wi-Fi investigation.
- For platform functionality, use official Arduino-ESP32 public APIs and official examples/source for Core 3.3.7 first.
- Do not replace official Arduino abstractions with handwritten ESP-IDF startup/lifecycle code when an official Arduino API already provides the required operation.
- Project-specific state machines, safety logic, OTA policy, BLE protocol, and hardware behavior remain allowed only as application logic around the official Arduino APIs; they must not impersonate or replace framework internals.
- Any future API/signature must be verified against the exact Core 3.3.7 official source before use.
- The recent raw ESP-IDF diagnostic files remain diagnostic evidence only and are not the implementation template.
- No executable source was changed by this confirmation.


## 2026-09-27 — V1.3 ARDUINO STANDARD SOURCE AUDIT / MINIMAL AP ORDER FIX
- Audited the current firmware/JEXFYZ.ino V1.3 source on main against the official Arduino-ESP32 Core 3.3.7 public source and examples.
- Confirmed the current source contains zero occurrences of the previously prohibited low-level ESP-IDF implementation markers: esp_ota_*, esp_err_t, esp_err_to_name, ESP_ERR_*, esp_err.h, esp_ota_ops.h, FreeRTOS/portMUX lifecycle includes, and BLE configuration macros CONFIG_BLUEDROID_ENABLED / CONFIG_NIMBLE_ENABLED.
- Confirmed the Arduino Update lifecycle is the official Core 3.3.7 API: Update.begin(), Update.write(), Update.end(true), Update.abort(), and Update.printError(Serial).
- Confirmed Core 3.3.7 LEDC usage is pin-centric through ledcAttach() / ledcWrite(); no legacy ledcSetup() / ledcAttachPin() remains.
- Confirmed ADC/GPIO, Preferences, WebServer, HTTPClient, WiFiClientSecure, OneButton 2.6.1, and Adafruit NeoPixel 1.12.5 calls used by the source match public APIs verified against the pinned versions.
- Confirmed BLE lifecycle calls used by the source (BLEDevice::init, getInitialized, createServer, setMTU, startAdvertising, deinit, service/characteristic creation) exist in the official Core 3.3.7 BLE headers/examples.
- Confirmed Wi-Fi startup/handoff uses Arduino APIs only and BLE is not started while the boot AP owns the radio.
- Found one concrete source-level alignment issue: the V1.3 Local AP startup called WiFi.softAP() before WiFi.softAPConfig(). Core 3.3.7 official APOTA source uses the opposite order (softAPConfig() then softAP()); the production source was minimally reordered to match that official Arduino pattern.
- No BLE UUID, command vocabulary, safety logic, GPIO mapping, OTA diagnostics, or firmware feature behavior was intentionally changed by the audit.
- GPIO contract remains GPIO5 = FAN and GPIO6 = PELTIER.
- V1.3 remains a release candidate only. CI Core 3.3.7 compile and publish are still required before calling it final/public.

## 2026-09-27 — V1.3 POST-PATCH STATIC AUDIT PASS
- Re-read the updated firmware/JEXFYZ.ino after the minimal SoftAP order change.
- V1.3 identity is intact.
- Forbidden ESP-IDF lifecycle markers remain at zero.
- Legacy LEDC APIs ledcSetup()/ledcAttachPin() remain absent.
- Local AP order is now verified as WiFi.softAPConfig() before WiFi.softAP().
- Required Arduino Update lifecycle calls remain present: begin/write/end(true)/abort/printError.
- GPIO mapping remains GPIO5 = FAN and GPIO6 = PELTIER.
- This static check does not replace the required Core 3.3.7 CI compile.

## 2026-09-27 — RUN #68 COMPILE ROOT CAUSE / V1.3 CORE 3.3.7 FIX
- CI Run #68 reached the pinned Arduino-ESP32 Core 3.3.7 toolchain and failed only in the ArduinoDroid temporary-source compile before the release job.
- Compiler root cause #1: Core 3.3.7 EspClass has no getResetReason() member. Official Core 3.3.7 search/source verification found no Arduino ESP.getResetReason()/getResetInfo() wrapper. The production sync field RESET_REASON is therefore retained but now reports the explicit non-fabricated value UNAVAILABLE_CORE_3_3_7 instead of calling a nonexistent API.
- Compiler root cause #2: stale bleConnectionId = BLE_INVALID_CONN_ID remained after the callback/low-level cleanup, but neither symbol is declared or required by the current Arduino BLE implementation. The unused assignment was removed; BLE UUIDs/protocol and callback behavior were not changed.
- Compiler root cause #3: the official Core 3.3.7 Update.write() signature requires uint8_t*, while the Stream adapter receives const uint8_t*. The adapter now uses const_cast<uint8_t*> only at the official API boundary; official Update.cpp was verified to copy/read the supplied bytes and not modify the input buffer.
- No raw ESP-IDF Wi-Fi/OTA lifecycle was reintroduced. The fixes stay at Arduino/application boundaries and preserve the existing OTA state machine, diagnostics, safety, and radio handoff.
- GPIO mapping remains GPIO5 = FAN and GPIO6 = PELTIER.
- V1.3 is still not release-final/public. A new Core 3.3.7 CI run is required after this fix.

## 2026-09-27 — RUN #69 FINAL CI / ARTIFACT / PUBLIC V1.3 VERIFIED
- Run #69 (`36274477621`) completed successfully on the pinned Arduino-ESP32 Core 3.3.7 toolchain.
- `validate-arduinodroid`: PASS, including the real ArduinoDroid temporary-source compile.
- `build-and-publish`: PASS, including source identity audit, OTA protected-source audit, ESP32-C3 release compile, firmware artifact upload, ArduinoDroid source artifact upload, and public firmware publication.
- Release firmware artifact: `JEXFYZ-V1.3`, 1,465,728 bytes, not expired at verification time.
- ArduinoDroid source artifact: `JEXFYZ-V1.3-ArduinoDroid-Source`, 104,150 bytes, not expired at verification time.
- Final ArduinoDroid `.ino` extracted from the CI source artifact was verified to contain FW_VERSION V1.3, the Core 3.3.7 reset-reason compatibility value `UNAVAILABLE_CORE_3_3_7`, the official Update.write() mutable-buffer adapter, the official SoftAP config-before-start order, and no audited legacy/raw lifecycle markers.
- Public repository `TenzoNkz/JEXFYZ-Firmware` was verified to contain `JEXFYZ-V1.3.bin` and a manifest pointing to `https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.3.bin`.
- This is the first verified V1.3 CI/public-release completion after the Core 3.3.7 compile fixes. Physical ESP32-C3 flashing/runtime validation is still a separate hardware step and has not been claimed here.

## 2026-09-27 — EXECUTION: WIFI STA-MODE BOUNDARY DIAGNOSTIC
- Current repository source remains the verified V1.3 Arduino-Standard firmware; no production firmware logic was changed.
- Because standalone Core 3.3.7 testing previously showed a panic at the public `WiFi.mode(WIFI_AP)` boundary, the next diagnostic isolates the sibling public STA-mode initialization path.
- Added diagnostic file: `firmware/diagnostics/JEXFYZ-WiFi-STA-Mode-Test.ino`.
- Scope is intentionally minimal: `Arduino.h`, `WiFi.h`, official `ESP.getCoreVersion()`, `ESP.getChipModel()`, `ESP.getChipRevision()`, `WiFi.getMode()`, `WiFi.mode(WIFI_STA)`, and `WiFi.status()`.
- The sketch contains explicit Serial markers immediately before and after `WiFi.mode(WIFI_STA)`; it does not use WebServer, Update, BLE, Preferences, NTC, PWM, RGB, raw ESP-IDF Wi-Fi lifecycle, or project-specific startup code.
- Diagnostic commit: `e8185cb24acb7475a533a859208156b43ecd4c03`.
- Interpretation boundary: if STEP 3 is reached, generic Arduino Wi-Fi initialization can complete in STA mode and the remaining fault is AP-specific; if the board panics between STEP 2 and STEP 3, the failure is below the AP-specific path and production OTA/AP changes should not be attempted blindly.
- Next boundary: compile/flash this diagnostic under the same ArduinoDroid + Arduino-ESP32 Core 3.3.7 setup and preserve the complete Serial output.

## 2026-09-27 — EXECUTION: PURE ARDUINO RUNTIME BOUNDARY DIAGNOSTIC
- User explicitly authorized execution.
- Added diagnostic file: `firmware/diagnostics/JEXFYZ-Pure-Arduino-Runtime-Test.ino`.
- Scope is the smallest Arduino-layer test currently needed: `Arduino.h`, `Serial`, `millis()`, and official Arduino ESP APIs for Core version/chip information.
- No `WiFi.h`, WebServer, Update, BLE, Preferences, NTC, PWM, RGB, or ESP-IDF API is used.
- Serial markers identify entry into `setup()`, the installed Arduino-ESP32 Core version, chip model/revision, successful setup completion, and a 1-second loop heartbeat.
- Diagnostic commit: `9c64bb01e2a22beada7d56116cdd879736a76af1`.
- Purpose: establish whether the board reaches and remains in the Arduino sketch runtime before any Wi-Fi initialization is involved.
- Build/flash was not executed in the current environment; manual ArduinoDroid + Arduino-ESP32 Core 3.3.7 testing remains the next boundary.
- Production `firmware/JEXFYZ.ino` remains unchanged.
- Required evidence: capture output from the first diagnostic line through at least several `HEARTBEAT: LOOP OK` lines, or the complete panic if it resets before/after `setup()`.

## 2026-09-27 — EXECUTION: MINIMAL ARDUINO WIFI + OTA TEST
- User requested a simpler firmware test instead of layered diagnostics.
- Added `firmware/diagnostics/JEXFYZ-Simple-WiFi-OTA-Test.ino`.
- Arduino-Standard scope only: `Arduino.h`, `WiFi.h`, `WebServer.h`, and `Update.h`.
- Wi-Fi uses the direct official `WiFi.softAP(ssid, password)` path with no custom `softAPConfig()`, no manual Wi-Fi mode calls, and no project-specific startup logic.
- OTA uses the standard WebServer upload route with `Update.begin(UPDATE_SIZE_UNKNOWN)`, `Update.write()`, `Update.end(true)`, `Update.abort()`, and `Update.printError(Serial)`.
- No BLE, NTC, Fan/Peltier, RGB, Preferences, Adaptive, raw ESP-IDF lifecycle, or custom radio wrapper is included.
- Diagnostic commit: `f30263cb756877dc883d2eeae5cb924b95160b39`.
- Production `firmware/JEXFYZ.ino` remains unchanged.
- Build/flash execution remains on the user's ArduinoDroid + Core 3.3.7 environment.
- Expected baseline: SSID `JE X FYZ OTA`, password `0987654321`, AP address normally reported by `WiFi.softAPIP()`.


# CURRENT STATE — 2026-09-27 06:00 WIB

## VERIFIED RUNTIME BASELINE: MINIMAL ARDUINO WIFI AP WORKS
- Physical test result from the user's ESP32-C3: diagnostic firmware `JEXFYZ-Simple-WiFi-OTA-Test.ino` successfully exposed the Wi-Fi SSID `JE X FYZ OTA`.
- The phone's Wi-Fi scan visibly showed `JE X FYZ OTA` under Available networks.
- Therefore the board's basic Wi-Fi SoftAP function works with Arduino-ESP32 Core 3.3.7 when using the simple official Arduino path:
  ```
  WiFi.softAP(ssid, password);
  ```
- This directly corrects the earlier unproven assumption that the board/runtime Wi-Fi subsystem itself was necessarily the root cause.
- The successful simple test did not include BLE, NTC, Fan/Peltier, RGB, Preferences, Adaptive logic, custom radio supervisors, manual Wi-Fi mode setup, `softAPConfig()`, or raw ESP-IDF lifecycle code.
- Current conclusion: do not add custom Wi-Fi initialization layers merely to start the AP.

## PERMANENT IMPLEMENTATION RULE — ARDUINO STANDARD + SIMPLE
- Use the public Arduino-ESP32 Core 3.3.7 APIs and the official Arduino example/lifecycle pattern for the required function.
- Prefer the smallest official implementation that satisfies the JE X FYZ requirement.
- Do not invent API names, wrappers, compatibility shims, low-level lifecycle replacements, or guessed ESP/Arduino functions.
- Do not recreate work already owned by the Arduino framework.
- Do not introduce `WiFi.mode()`, `WiFi.disconnect()`, `WiFi.setHostname()`, `WiFi.setSleep()`, `WiFi.setAutoReconnect()`, `softAPConfig()`, or similar startup operations into the production AP path unless a verified Core 3.3.7 requirement proves they are necessary.
- For OTA, use the official Arduino Update lifecycle: `Update.begin()`, `Update.write()`, `Update.end(true)`, `Update.abort()`, and `Update.printError(Serial)`.
- When a platform API is uncertain, stop and verify against the exact pinned Core 3.3.7 source before using it.
- Every production change must compile in the project's pinned Core 3.3.7 CI before being treated as valid.

## PRODUCTION FIRMWARE SAFETY
- Authoritative production source remains `firmware/JEXFYZ.ino` V1.3.
- The production source is not replaced by any diagnostic sketch.
- Diagnostic sketches under `firmware/diagnostics/` are isolated tests only.
- The verified V1.3 release remains the last known-good CI/public build baseline.
- Do not claim physical V1.3 production runtime success merely from CI success; physical production validation remains separate.
- GPIO contract remains GPIO5 = FAN and GPIO6 = PELTIER.

## NEXT FULL EXECUTION BOUNDARY
- The next production execution is ready to be scoped around the verified simple Arduino Wi-Fi/OTA pattern.
- Do not redesign the whole firmware or add another diagnostic layer.
- Preserve JE X FYZ application behavior, BLE UUID/protocol, safety logic, NTC, PWM, RGB, Adaptive logic, settings persistence, and GPIO mapping unless a specific verified issue requires a change.
- Simplify only the production Wi-Fi/OTA startup path where the current implementation is more complex than the proven Arduino Standard baseline.
- After the source change: run the pinned Core 3.3.7 compile/audit, then produce the firmware artifact, and only after that perform the physical test.
- If a new production firmware behavior is created, version it according to the project's existing V1.x sequence rather than silently replacing V1.3.

## LATEST DIAGNOSTIC ARTIFACTS
- `firmware/diagnostics/JEXFYZ-Simple-WiFi-OTA-Test.ino` — commit `f30263cb756877dc883d2eeae5cb924b95160b39`; physical Wi-Fi SSID visibility: PASS.
- `firmware/diagnostics/JEXFYZ-WiFi-STA-Mode-Test.ino` — commit `e8185cb24acb7475a533a859208156b43ecd4c03`; earlier physical output did not expose the sketch banner, so its STA boundary remains non-diagnostic.
- `firmware/diagnostics/JEXFYZ-Pure-Arduino-Runtime-Test.ino` — commit `9c64bb01e2a22beada7d56116cdd879736a76af1`; physical test did not produce visible sketch output in the reported Monitor session.
- The successful Simple Wi-Fi + OTA baseline supersedes the need to continue stacking lower-level Wi-Fi diagnostics unless the simple production pattern itself fails.

## NOTE GOVERNANCE
- This block is the current authoritative operational state and supersedes conflicting earlier hypotheses in the historical log.
- Historical diagnostics are retained for traceability and must not be treated as the current implementation recipe.

## 2026-09-27 — EXECUTION: PRODUCTION V1.4 SIMPLE ARDUINO WIFI BASELINE
- User explicitly authorized full code + firmware execution and requested a manual OTA-ready `.bin`.
- Production source `firmware/JEXFYZ.ino` changed from V1.3 to **V1.4**.
- Production Local SoftAP startup was minimally simplified to the exact path proven physically on the user's ESP32-C3:
  `WiFi.softAP(AP_SSID, AP_PASSWORD)`.
- Removed only the extra Local AP configuration/startup calls from that production boundary: `WiFi.softAPConfig()` and its associated AP configuration result handling.
- No BLE, NTC, Fan/Peltier, RGB, Adaptive, GPIO, settings persistence, BLE UUID/protocol, or online OTA behavior was intentionally redesigned in this execution.
- The production source continues to use the Arduino `Update.h` lifecycle for local/online OTA and the existing OTA safety supervisor/diagnostic policy.
- Source commit: `bf923ba37bdaee96b9f870318401c0d04061e8ff`.
- Pre-CI static sanity check: V1.4 marker present; Local AP contains direct `WiFi.softAP(AP_SSID, AP_PASSWORD)`; `WiFi.softAPConfig()` is absent from production source; GPIO5=Fan and GPIO6=Peltier remain intact; legacy LEDC and audited raw lifecycle markers remain absent.
- Required validation boundary: pinned Arduino-ESP32 Core 3.3.7 ArduinoDroid compile, release compile, OTA protected-source audit, artifact upload, and publication must all pass before the V1.4 binary is presented as verified.
- Physical runtime of V1.4 is not claimed until the user manually flashes the resulting binary.

## 2026-09-27 — RUN #70 COMPILE ERROR / IMMEDIATE FIX
- Run #70 failed only at the ArduinoDroid/Core 3.3.7 compile boundary.
- Exact compiler error: `const apOk = WiFi.softAP(AP_SSID, AP_PASSWORD);` is invalid C++ because the local variable type was omitted.
- No platform/API error was reported; the failure was a source typo introduced during the V1.4 simplification.
- Corrected exactly one line to `const bool apOk = WiFi.softAP(AP_SSID, AP_PASSWORD);`.
- Corrective source commit: `af86fe1db68987acd5d8da01f4f2e0e6a6fe26ce`.
- No other production logic was changed by this correction.
- Run #70 release job was correctly skipped because the validation compile failed.
- Next boundary: rerun the same pinned Core 3.3.7 ArduinoDroid validation and then the release build/publish. No binary from Run #70 is valid for OTA.

## 2026-09-27 — RUN #71 FINAL V1.4 BUILD / ARTIFACT / PUBLICATION PASS
- Run #71 (`36278510756`) completed successfully.
- `validate-arduinodroid`: PASS, including Arduino-ESP32 Core 3.3.7 installation, pinned library installation, ArduinoDroid temporary-source preparation, and ESP32-C3 compile.
- `build-and-publish`: PASS, including firmware source identity audit, version extraction, OTA protected-source audit, ESP32-C3 release compile, artifact upload, ArduinoDroid source artifact upload, and publication to `TenzoNkz/JEXFYZ-Firmware`.
- Production firmware source commit: `af86fe1db68987acd5d8da01f4f2e0e6a6fe26ce`.
- Final firmware version: **V1.4**.
- Final release binary: `JEXFYZ-V1.4.bin`, **1,465,280 bytes**.
- Final artifact ZIP was downloaded and extracted locally; the binary file was present and non-empty.
- Public firmware repository was verified to contain `JEXFYZ-V1.4.bin` at 1,465,280 bytes.
- Public manifest was verified as:
  ```
  {
    "version": "V1.4",
    "url": "https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ-V1.4.bin"
  }
  ```
- CI validation is therefore PASS; this does not yet constitute physical V1.4 runtime validation on the user's board.

# OTA POLICY — AUTHORITATIVE CORRECTION / SAFETY RULES — 2026-09-27

## FINAL USER-DEFINED VERSION POLICY
- **Local OTA:** version policy is completely bypassed. A valid compatible `.bin` may be flashed regardless of whether its version is older, equal, or newer than the installed firmware. This explicitly supports downgrade, same-version reflashing, recovery, and repeated OTA testing.
- **Online OTA:** a version update is allowed whenever the remote firmware version is **different** from the currently installed `FW_VERSION`.
- **Online same-version behavior:** when the remote manifest version equals the currently installed firmware version exactly, the device/app must report **Up to date** and must not perform an OTA flash.
- **Online does NOT require the remote version to be newer.** Example: installed V1.4 may receive remote V1.3 or V1.5; installed V1.4 receiving remote V1.4 is Up to date.
- Version comparison is therefore an **equal-vs-different gate**, not a greater-than upgrade-only gate.
- These rules are product policy and must not be silently changed by future implementation work.

## OTA LIFE-SAFETY / RELEASE-GATE RULE
- User explicitly states that OTA integrity is a critical survival requirement for the project: **OTA must not be knowingly broken or released with an unresolved OTA error**.
- Treat OTA as a protected/core subsystem. Do not trade OTA reliability for unrelated feature changes.
- A firmware binary must **never** be presented to the user as OTA-ready merely because the source compiles.
- Before delivering a production OTA `.bin`, require at minimum:
  1. pinned Arduino-ESP32 Core 3.3.7 compile PASS;
  2. ArduinoDroid temporary-source compile PASS;
  3. OTA protected-source audit PASS;
  4. release artifact exists and is non-empty;
  5. artifact contents match the intended firmware version/source revision;
  6. public firmware manifest/link is verified when publication is part of the build;
  7. any known OTA runtime failure remains explicitly marked as unresolved and is not declared fixed without evidence.
- If any release-gate check fails, stop the release and fix the failure before presenting a production binary.
- Never conceal or work around an OTA failure merely to make the upload appear successful.
- Keep Local OTA and Online OTA policy separate so that a version-gate change cannot accidentally alter image validation or flash-writing safety.
- Local OTA must still reject invalid/corrupt/incompatible images through the normal Arduino Update validation path; "no version restriction" does **not** mean "accept arbitrary bytes".
- Online OTA must retain the same image/space/flash validation safety in addition to the equal-vs-different version gate.

## CURRENT DEBUG LESSON — LOCAL OTA CODE 8
- The user's physical V1.4 Local OTA test reached 100% upload and then reported:
  `LOCAL_IMAGE_VERIFY | UPDATE_END_FAILED | code 8`.
- This is an **image verification/end-of-update failure**, not evidence that a same-version file should be blocked by version policy.
- Do not solve this failure by adding a version check.
- The local same-version/downgrade requirement must be implemented independently from the `Update.end(true)` image-validation path.

## HISTORY / NO-REPEAT RULE
- The notes are the project's technical life-history and are to be expanded after every meaningful discussion and execution.
- Historical failed approaches remain recorded for traceability, but current implementation must follow the latest authoritative policy block.
- Do not resurrect superseded hypotheses simply because they appear earlier in the file.
- Do not repeat a diagnostic test when the same boundary has already been conclusively established.
- Prefer a small, evidence-driven change over a large refactor.

## CURRENT AUTHORITATIVE PRODUCTION STATE
- Production source: `firmware/JEXFYZ.ino`
- Current production version: **V1.4**
- V1.4 simple Arduino Wi-Fi baseline: physically verified SSID visibility.
- V1.4 CI Run #71: compile, audit, artifact, and publication PASS.
- Physical V1.4 Local OTA test: **FAILED at `Update.end(true)` with code 8**. Therefore local OTA runtime is **not yet considered fixed** despite CI PASS.
- Physical V1.4 BLE + main application visibility/function: user reported BLE appears and application features work after V1.4 was flashed.
- This means the next OTA work must focus specifically on the Local OTA verification failure while preserving the working Wi-Fi/BLE/application baseline.

## NEXT OTA IMPLEMENTATION BOUNDARY
- Implement the version policy exactly as defined above:
  - Local = no version equality/newer/older restriction.
  - Online = different version allowed; same version => Up to date/no flash.
- Separately investigate and fix the physical Local OTA `UPDATE_END_FAILED` code 8 using the official Arduino-ESP32 Core 3.3.7 Update path.
- Do not redesign BLE, NTC, cooling, RGB, Adaptive, GPIO, or unrelated application features while fixing this OTA issue.
- Every OTA code modification requires a fresh pinned Core 3.3.7 validation before another physical flash test.

## 2026-09-27 — EXECUTION: LOCAL OTA CODE-8 ROOT-CAUSE CORRECTION / V1.5
- User provided physical V1.4 Local OTA evidence: upload reached 100%, then the UI reported `LOCAL_IMAGE_VERIFY | UPDATE_END_FAILED | code 8`.
- Verified the uploaded V1.4 binary itself is a valid ESP32 image: first byte is `0xE9` (ESP image magic), file size 1,465,280 bytes, SHA-256 `d0d1a83711774a13f58d61070d6ff37ffaf5b17c394c3188cbb9a767898c07b2`.
- Verified official Arduino-ESP32 Core 3.3.7 `Update.h` defines `UPDATE_ERROR_MAGIC_BYTE = 8`, but also exposes `getError()` and `errorString()`.
- Root-cause in JE X FYZ diagnostics: the Local OTA failure path was hardcoding `OTA_ERROR_MAGIC_BYTE` (code 8) whenever `Update.end(true)` returned false. Therefore the UI's code 8 did **not** identify the actual Update failure at that stage.
- Verified official Core 3.3.7 WebUpdate example uses the simple Arduino lifecycle `Update.begin()` -> `Update.write()` -> `Update.end(true)`.
- Production Local OTA was changed to use the official simple `Update.begin()` call instead of `Update.begin(localOtaExpectedBytes)`.
- Production Local OTA failure reporting now captures the real `Update.getError()` and `Update.errorString()` before calling the project failure handler, instead of inventing a magic-byte error code.
- Production firmware version advanced to **V1.5** because Local OTA runtime behavior changed.
- Source commit for version bump/final source: `a36c4fa7748b3e9369a92ab1c583f177a0b13705`.
- The change is intentionally limited to Local OTA begin/end error handling and uses the official Arduino Update API pattern. BLE, NTC, Fan/Peltier, RGB, Adaptive, GPIO, settings, online OTA protocol, and app behavior were not intentionally redesigned.
- **Important unresolved runtime status:** V1.4 failed Local OTA at `Update.end(true)`. The V1.5 source fix has not yet been physically tested. Therefore V1.5 must not be declared OTA-fixed until a physical Local OTA upload succeeds.
- Release gate: V1.5 must pass ArduinoDroid/Core 3.3.7 compile, release compile, OTA protected-source audit, artifact verification, and publication before any V1.5 binary is delivered for manual testing.

## 2026-09-27 — RUN #72 FINAL V1.5 LOCAL OTA FIX BUILD PASS
- Run #72 (`36279605827`) completed successfully.
- ArduinoDroid/Core 3.3.7 validation compile: PASS.
- Release ESP32-C3 compile: PASS.
- OTA protected-source audit: PASS.
- Firmware artifact upload: PASS.
- ArduinoDroid source artifact upload: PASS.
- Public firmware publication: PASS.
- Final production source commit: `a36c4fa7748b3e9369a92ab1c583f177a0b13705`.
- Final firmware version: **V1.5**.
- Final binary extracted from the CI artifact: `JEXFYZ-V1.5.bin`, **1,465,488 bytes**.
- Local binary integrity inspection: first byte is `0xE9` (ESP image magic); SHA-256 `c9baa2f8bf263ca51a0909a772300d8bd49e69b0c641b206e3bc3c1953c15eb8`.
- The binary is derived from Run #72's successful release artifact, not the previously failed Run #70.
- V1.5 is **not yet physically proven to complete Local OTA**. The purpose of this release is to test the corrected official Arduino Update flow on the actual device.
- Next required hardware test: upload V1.5 through the Local OTA page using the same device/AP that previously produced `UPDATE_END_FAILED`. Preserve the complete OTA result message and, when available, Serial output.

## 2026-09-27 — WORKFLOW RULE: CODE EXECUTION VS NOTE EXECUTION
- **CODE/REPOSITORY EXECUTION RULE:** Never modify production firmware, diagnostic code, CI workflow, build trigger, release artifact, or other executable project files unless the user explicitly commands execution (for example: "Eksekusi", "Eksekusi Code", "Eksekusi Firmware", or an equivalent explicit command).
- Discussion, approval, planning, screenshots, or requests for analysis do not authorize executable-code changes.
- **NOTES AUTO-UPDATE RULE:** Project history/notes must be updated automatically whenever a meaningful decision, requirement, test result, error, correction, or workflow rule is established in discussion. No separate execution command is required for notes.
- Notes are the project's technical life-history and must record both successful and failed experiments, including the exact boundary, version, commit, error, and resulting decision when those facts are available.
- Current priority remains **Local OTA first**. Online OTA implementation changes are frozen until Local OTA has been physically verified working.
- Latest physical result recorded by user: device was still running V1.4; manual Local OTA to V1.5 failed; Online OTA to V1.5 also failed.
- Next code execution, when explicitly authorized, must focus only on making **Local OTA robust and repeatable** using the official Arduino-ESP32 Core 3.3.7 API/pattern. Do not modify Online OTA in that execution.

## 2026-09-27 — PHYSICAL TEST PLAN LOCKED
- User-defined physical validation sequence:
  1. Flash **V1.5 manually** first.
  2. Verify normal V1.5 startup and application operation.
  3. Manually flash different firmware versions upward/downward to establish that manual flashing behaves correctly.
  4. Test **Local OTA** on the running device, including version changes and the previously failing OTA path.
  5. Record the exact Local OTA result before making any further OTA changes.
  6. Only after Local OTA is physically verified working, resume discussion/implementation of **Online OTA**.
- **Online OTA is frozen during this validation sequence.**
- No production code, firmware source, build, or release changes are authorized merely by this discussion; explicit execution command is still required.
- Notes/history must continue to update automatically as physical test results are reported.

## 2026-09-27 — WORKFLOW VISIBILITY RULE
- User requested explicit progress explanations during every active work session, modeled on the visible GitHub Actions/workflow-style status shown in screenshots.
- For future repository/code/build/audit work, provide clear progress messages before and after meaningful tool operations.
- Progress messages should state, when applicable:
  - **Checking**: what file/API/workflow/source boundary is being inspected and why.
  - **Updating**: what is being changed and the narrow reason for the change.
  - **Verified**: the exact result of a check or build step.
  - **Waiting**: when a GitHub Actions job/build is still running.
  - **Error**: the exact verified error and its cause, without speculation.
  - **Next**: the next concrete step and what evidence is required.
- Keep these progress messages factual and concise enough to follow on a phone screen.
- Do not hide intermediate failures; report them and explain whether they were caused by source code, tool/build infrastructure, or unverified runtime behavior.
- This visibility rule does not authorize code execution. Production code/repository changes still require the user's explicit execution command.
- Notes/history remain auto-updated whenever meaningful project decisions, errors, test results, or rules are established.
## 2026-09-27 — PHYSICAL RESULT: MANUAL VERSION FLASHING PASS / ONLINE OTA V1.0->V1.5 FAIL
- User physically tested manual firmware flashing by changing the firmware version source and flashing:
  1. V1.5 -> V1.5: PASS
  2. V1.5 -> V1.0: PASS
  3. V1.0 -> V1.9: PASS
  4. V1.9 -> V1.5: PASS
  5. V1.5 -> V1.0: PASS
- Current physical firmware state after these tests: V1.0.
- User then tested Online OTA V1.0 -> V1.5: FAIL.
- This manual-flashing history establishes that the board can manually accept and boot the tested firmware versions; therefore the Online OTA failure should be isolated from basic firmware-image compatibility/partition boot behavior unless new evidence contradicts this.
- Current public firmware manifest is V1.5 and points to the public V1.5 binary.
- The current Online OTA implementation uses HTTPS, a range probe, strict 206 Partial Content + Content-Range validation, chunked range requests, Update.begin(totalSize), Update.write(), and Update.end(true).
- No code change is authorized by this discussion. The next execution, when explicitly requested, must focus only on Online OTA failure diagnosis/fix; no unrelated feature changes.
- Before proposing a production Online OTA patch, identify the exact failure stage from the existing OTA diagnostic reporting or Serial output.
- Do not modify BLE, NTC, cooling, RGB, Adaptive, GPIO, Local OTA, or application UI in the Online OTA execution unless a directly verified dependency requires it.
## 2026-09-27 — ONLINE OTA DIAGNOSTIC + LED STATE DESIGN (DISCUSSION / NO CODE EXECUTION)
- User explicitly instructed that Local OTA is considered done/stable and must not be broken during future Online OTA work. Treat Local OTA as a protected subsystem: no unrelated Online OTA change may modify Local OTA logic.
- Historical Local OTA failures remain retained for traceability; "protected/stable" is the current product baseline instruction and does not erase the earlier physical failure evidence.
- User requested complete, stage-by-stage diagnostics for Online OTA from start to finish so the exact failure boundary is visible.
- Online OTA diagnostic requirement: every meaningful stage must publish a clear stage/status message, and any failure must identify the exact stage and error returned by the underlying official API/network operation. Do not collapse multiple failure points into one generic OTA failed message.
- Proposed Online OTA stage flow:
  1. ONLINE_REQUEST — OTA request received / metadata present.
  2. ONLINE_VERSION_CHECK — compare manifest version with current version.
  3. If equal: ONLINE_UP_TO_DATE — show Up to date; do not flash.
  4. If different: ONLINE_WIFI_START — begin Wi-Fi connection process.
  5. ONLINE_WIFI_CONNECTED — Wi-Fi connection succeeded.
  6. ONLINE_WIFI_FAILED — Wi-Fi connection failed.
  7. ONLINE_GITHUB_CONNECT — establish HTTPS connection to GitHub/raw firmware URL.
  8. ONLINE_GITHUB_READY — GitHub connection/HTTP response is valid for firmware download.
  9. ONLINE_GITHUB_FAILED — GitHub connection/download setup failed.
  10. ONLINE_DOWNLOAD_START — firmware download begins.
  11. ONLINE_DOWNLOAD_PROGRESS — firmware download progress reporting.
  12. ONLINE_DOWNLOAD_SUCCESS — complete firmware image downloaded/written to OTA staging.
  13. ONLINE_DOWNLOAD_FAILED — network/stream/range/download failure with exact error detail.
  14. ONLINE_IMAGE_VERIFY — finalize Update.end(true) and verify image.
  15. ONLINE_INSTALL_SUCCESS — firmware accepted and boot partition activation succeeded.
  16. ONLINE_INSTALL_FAILED — image verification/activation failure with exact official Update error.
  17. ONLINE_RESTART — green indication, then controlled restart.
- User-defined Online OTA LED behavior:
  - Wi-Fi connection succeeds: BLUE blink for 1 second, then LED off.
  - Wi-Fi connection fails: RED blink for 1 second, then LED off.
  - Wi-Fi succeeds + GitHub connection/download endpoint succeeds: GREEN blink, then continue.
  - Wi-Fi succeeds + GitHub connection fails: RED blink for 1 second, then LED off / failure state.
  - Firmware download succeeds: BLUE blink, then continue.
  - Firmware download fails: RED blink for 1 second, then LED off / failure state.
  - Firmware installation/verification succeeds: GREEN blink for 1 second, then restart.
  - Firmware installation fails: RED blink for 1 second, then LED off; no restart.
- LED indication must be tied to discrete stage completion/failure, not used as a substitute for textual diagnostics.
- Online same-version policy remains: same remote version as current means Up to date and no flash; different remote version is allowed regardless of whether remote is older or newer.
- Local vs Online policy remains explicitly separated:
  - Local OTA: no version restriction; preserve the working Local OTA path.
  - Online OTA: equal version means Up to date; different version is allowed.
- No code/build/release execution is authorized by this discussion. The next code execution requires an explicit user command and must focus only on the Online OTA diagnostic/LED implementation while preserving Local OTA.
