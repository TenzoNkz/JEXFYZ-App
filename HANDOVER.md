# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.7
- Active source: firmware/JEXFYZ-V4.7.ino
- Firmware blob: d47b62edbf275032780ef05d6ac3be1df06e350b
- Firmware source change commit: 3f9a215f2d5532e291c9d26c77897e3ae8ffe15d
- App: 1.0.0+3
- App package: com.horizontalzzz.jexfyz
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Latest verified App Build: workflow run 37245703677 / GitHub Release jexfyz-latest
- Current App source includes the targeted 2-second Fan precharge before Peltier ON when Fan was initially OFF.

## CURRENT PHASE
> **V4.7 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## IMPLEMENTED / FROZEN
- Hardware single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON: Fan 100%.
- Peltier OFF → ON: 5-second soft-start, then 100%.
- BOOT_AP_HARD_LIMIT_MS: 60 seconds.
- Rapid Hotside-rise protection removed.
- Normal Hotside temperature-limit protection preserved.
- Local OTA Golden Path preserved.
- BLE/P1/UUIDs, Adaptive, RGB, telemetry, and App CI workflow preserved; V4.7 adds the targeted realtime cooling telemetry fix.
- App CONTROL change: confirmed FAN=ON -> 2-second precharge -> PELTIER:ON when Fan was initially OFF.
- App realtime fix: unsolicited FAN/PELTIER/FAN_SPEED telemetry updates Control; stale Notify errors reconcile against healthy live state.

## QC RULE
Functional source is frozen during QC. Only a demonstrated QC failure with a clear root cause justifies a targeted source change.

## QC NEXT
1. Compile V4.7.
2. Generate BIN.
3. Flash / OTA V4.7.
4. Hardware-only QC.
5. Safety QC.
6. Local OTA.
7. Online OTA/BLE recovery.
8. Build App and App ↔ Firmware integration QC, including CONTROL Fan -> 2 s -> Peltier behavior.
9. Release Gate.

## VALIDATION
- [VERIFIED] Source/static audit.
- [USER-CONFIRMED] V4.6 firmware compilation, Online OTA, and hardware test succeeded before the V4.7 telemetry fix.
- [UNVERIFIED] V4.7 compile/BIN/flash/OTA and App ↔ V4.7 integration after the fix.
- [NOT RELEASED] V4.7.
