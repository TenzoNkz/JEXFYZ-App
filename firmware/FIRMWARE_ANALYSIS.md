# JE X FYZ — Firmware Analysis / V3.7

## Current source

Active file: firmware/JEXFYZ-V3.7.ino
Functional version: V3.7
Source blob: 4a7e08a6ea0de57f4e3d3a742ad88cbd25a05e01
Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module
Framework: Arduino Standard + official Arduino-ESP32 Core 3.3.7

## Hardware contract

| Function | GPIO | Contract |
|---|---:|---|
| NTC Hotside | 0 | 12-bit ADC, 11 dB attenuation, sampled every 1 s |
| Touch | 1 | Deterministic touch state machine |
| 12 V selector | 3 | Physical selector output |
| 9 V selector | 4 | Physical selector output |
| Peltier | 5 | 20 kHz, 8-bit PWM |
| Fan | 6 | 25 kHz, 8-bit PWM |
| WS2812 | 7 | 8 LEDs |

## Authority order

1. OTA supervisor owns the runtime before normal application processing.
2. NTC validity and Hotside safety override normal cooling requests.
3. Adaptive chooses voltage only within the current safety ceiling.
4. Manual controls are accepted only when Adaptive/safety locks allow them.
5. LEDs, telemetry, and persistence report the resulting state; they do not become safety authorities.

## Voltage path

requestVoltage(): validates OTA lock, in-flight transition lock, voltage guard, NTC validity, manual Hotside restriction, and Adaptive ceiling; then turns both selector outputs OFF and records the request source.

completeVoltageTransition(): waits for the 200 ms deadtime, revalidates Hotside immediately before selector activation, applies Battery-only deadtime revalidation for Battery-originated transitions, commits one physical voltage step, arms the shared 1 s guard, and finally applies cooling/PWM consequences.

### Peltier V3.7 rule

| Transition | Peltier state | Result |
|---|---|---|
| 5 V -> 9 V | ON | Restart 5 s soft-start |
| 9 V -> 12 V | ON | Restart 5 s soft-start |
| 12 V -> 9 V | ON | Do not restart |
| 9 V -> 5 V | ON | Do not restart |
| Any OFF -> ON | OFF | Start 5 s soft-start |

The upward restart is evaluated only after the selector transition physically completes. Safety still has higher authority and can prevent Peltier operation.

## Universal Hotside safety

### Manual
- Hotside at/above limit: Peltier OFF, Fan ON at 100%, manual Peltier safety latch set, voltage forced toward 5 V.
- Normal manual voltage above 5 V is blocked while hot.
- Peltier remains OFF after recovery until an explicit safe manual ON command releases the latch.

### Adaptive HOTSIDE
- Hot event immediately requests one lower voltage level with no pre-down delay.
- The just-rejected voltage is removed from the session Adaptive ceiling.
- After the physical down-step, Peltier remains OFF for 5 s and may resume only after Hotside is safe.
- If 5 V is still hot, Adaptive turns OFF and Fan remains ON.

### HOTSIDE_BATTERY
- Hotside is the hard safety ceiling.
- Phone Battery temperature chooses the desired voltage inside that ceiling.
- Battery invalid/disconnected: effective runtime control falls back to HOTSIDE while preserving the configured profile.

## Battery Adaptive

Battery validity TTL is 5 s. Fresh PHONE:BT restores validity; BLE disconnect/link-loss invalidates the source immediately.

Direct mapping: below BATT5 -> 5 V; BATT5 through below BATT12 -> 9 V; at/above BATT12 -> 12 V.
Movement is one step at a time. Battery target is re-evaluated at the end of the 200 ms deadtime only for Battery-originated transitions, then the shared 1 s voltage guard applies.

## Adaptive startup / shutdown

Adaptive start is a staged handoff: request accepted -> physical voltage returns to 5 V -> Adaptive becomes active. Adaptive OFF uses the same safe 5 V boundary and resets the temporary Hotside ceiling to 12 V.

While Adaptive is active, Voltage/Control/Temperature user requests are locked. Fan and Peltier are firmware-owned except when safety explicitly forces Peltier OFF.

## Radio / BLE

The firmware treats ESP32-C3 as a single-radio target. BLE starts only after Wi-Fi is OFF and the configured settle window has expired.
BLE callbacks only enqueue data; command execution is performed in the main loop. TX notifications are paced at 15 ms.
BLE disconnect re-advertises without a full MCU restart.

## OTA

Local OTA uses the boot SoftAP. Online OTA uses the approved JE X FYZ firmware GitHub binary repository.
Online OTA validates the HTTPS URL, HTTP response, content size, ESP32 image magic byte (0xE9), streaming write results, and final Update.end() result.
Download uses a bounded 1024-byte buffer and one cooperative stream step per loop pass. Progress flashes yellow at 20/40/60/80/100%.
OTA failure records diagnostics and recovers to BLE; OTA success shows the final green indicator and then restarts.

## LED ownership

Higher-priority firmware indicators can temporarily own the LEDs over normal user RGB effects. Hotside protection, OTA, and voltage-indicator states therefore do not share output ownership with normal rendering during their active windows.

## Persistence

Settings are marked dirty when changed and written only after 10 s without a new change. This is a deliberate debounce against excessive flash writes.

## Non-blocking timing

No executable delay() calls and no timing while() waits are present in the current source. Timed operations use timestamps and cooperative state machines.

## Critical function map

- applyCoolingOutputs(): source line 987
- requestVoltage(): source line 1641
- completeVoltageTransition(): source line 1681
- forceSafeFiveVolt(): source line 1863
- enforceSafety(): source line 1909
- processAdaptiveHotTimer(): source line 2029
- processAdaptiveHotsideFallback(): source line 2130
- evaluateAdaptiveBattery(): source line 2185
- beginPeltierSoftStart(): source line 906
- processPeltierSoftStart(): source line 920
- sampleNtcIfDue(): source line 1819
- stopBleRadio(): source line 2628
- startBle(): source line 2701
- startOnlineOta(): source line 3371
- prepareOnlineOtaDownload(): source line 3092
- performOnlineOtaDownload(): source line 3184
- finalizeOnlineOtaFlash(): source line 3321
- serviceOtaPriority(): source line 4819
- initializeRuntimeFeatures(): source line 4927
- setup(): source line 4990
- loop(): source line 5021

## Static audit snapshot

- Source lines: 5107.
- Source comments: 779 lines.
- Function contract blocks: 136.
- C++-aware brace balance: 535/535.
- C++-aware parenthesis balance: 2002/2002.
- Executable delay(): 0.
- Timing while(): 0.
- Stale V3.5/V3.6/V1.0 baseline references: 0.
- Mixed-language source comments found in the cleanup audit: 0.
- Functional firmware version change in this documentation pass: none; remains V3.7.

## Validation boundary

This repository pass proves source/documentation consistency only. ArduinoDroid compilation with official Arduino-ESP32 Core 3.3.7, BIN generation/publication, and physical electrical/thermal/BLE/OTA validation remain unperformed.

## Documentation standard

- Every detected firmware function has a [DOC-CONTRACT] comment immediately adjacent to its definition.
- Safety-critical state changes also have statement-level intent comments.
- Comments explain contract/intent and authority, not merely syntax.
- Source comments remain English to match the codebase standard.
