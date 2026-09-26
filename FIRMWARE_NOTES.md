# 🚨 CURRENT AUTHORITATIVE HANDOFF — 2026-09-27

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
