# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.6
- Active source: firmware/JEXFYZ-V4.6.ino
- Firmware blob: cd2ebd7395343f64b824e74c1370b04cea6835ab
- Firmware source change commit: 3f9a215f2d5532e291c9d26c77897e3ae8ffe15d
- App: 1.0.0+3
- App package: com.horizontalzzz.jexfyz
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Latest verified App Build: workflow run 37245703677 / GitHub Release jexfyz-latest
- Current App source includes the targeted 2-second Fan precharge before Peltier ON when Fan was initially OFF.

## CURRENT PHASE
> **V4.6 — CODE COMPLETE → QC / PRE-RELEASE → NOT RELEASED**

## IMPLEMENTED / FROZEN
- Hardware single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON: Fan 100%.
- Peltier OFF → ON: 5-second soft-start, then 100%.
- BOOT_AP_HARD_LIMIT_MS: 60 seconds.
- Rapid Hotside-rise protection removed.
- Normal Hotside temperature-limit protection preserved.
- Local OTA Golden Path preserved.
- BLE/P1/UUIDs, Adaptive, RGB, telemetry, and App CI workflow preserved.
- App CONTROL change: confirmed FAN=ON -> 2-second precharge -> PELTIER:ON when Fan was initially OFF.

## QC RULE
Functional source is frozen during QC. Only a demonstrated QC failure with a clear root cause justifies a targeted source change.

## QC NEXT
1. Compile V4.6.
2. Generate BIN.
3. Flash ESP32-C3.
4. Hardware-only QC.
5. Safety QC.
6. Local OTA.
7. Online OTA/BLE recovery.
8. Build App and App ↔ Firmware integration QC, including CONTROL Fan -> 2 s -> Peltier behavior.
9. Release Gate.

## VALIDATION
- [VERIFIED] Source/static audit.
- [USER-CONFIRMED] V4.6 Firmware compilation and Online OTA update succeeded in the user's environment.
- [UNVERIFIED] App Build after the latest CONTROL change and App ↔ Firmware physical integration.
- [NOT RELEASED] V4.6.
