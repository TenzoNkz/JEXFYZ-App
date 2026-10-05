# JE X FYZ — CURRENT HANDOVER

## CURRENT TRUTH
- Firmware: V4.9
- Active source: firmware/JEXFYZ-V4.9.ino
- Firmware blob: 888ae9740446081b2a2bcb1769e0471f065dce41
- Firmware source change commit: 3f9a215f2d5532e291c9d26c77897e3ae8ffe15d
- App: 1.0.0+3
- App package: com.horizontalzzz.jexfyz
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Latest verified App Build: workflow run 37245703677 / GitHub Release jexfyz-latest
- Current App source has no fixed 2-second Fan precharge; Firmware 5-second Peltier soft-start is authoritative.

## CURRENT PHASE
> **V4.9 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED**

## IMPLEMENTED / FROZEN
- Hardware single tap: 5V → 9V → 12V → 9V → 5V → ...
- Hardware cooling ON: Fan 100%.
- Peltier OFF → ON: 5-second soft-start, then 100%.
- BOOT_AP_HARD_LIMIT_MS: 60 seconds.
- Rapid Hotside-rise protection removed.
- Normal Hotside temperature-limit protection preserved.
- Local OTA Golden Path preserved.
- BLE/P1/UUIDs, Adaptive, RGB, telemetry, and App CI workflow preserved; V4.9 adds the Adaptive Hotside LED stage indication while preserving the realtime cooling telemetry fix.
- App CONTROL: FAN:ON is confirmed before PELTIER:ON; Firmware owns the 5-second Peltier soft-start.
- App realtime fix: unsolicited FAN/PELTIER/FAN_SPEED telemetry updates Control; stale Notify errors reconcile against healthy live state.

## QC RULE
Functional source is frozen during QC. Only a demonstrated QC failure with a clear root cause justifies a targeted source change.

## QC NEXT
1. Compile V4.9.
2. Generate BIN.
3. Flash / OTA V4.9.
4. Hardware-only QC.
5. Safety QC.
6. Local OTA.
7. Online OTA/BLE recovery.
8. Build App separately and run App ↔ Firmware integration QC, including the V4.8 HOTSIDE safety sequence.
9. Release Gate.

## VALIDATION
- [VERIFIED] Source/static audit.
- [USER-CONFIRMED] V4.6 firmware compilation, Online OTA, and hardware test succeeded before the V4.8 telemetry fix.
- [UNVERIFIED] V4.8 compile/BIN/flash/OTA and App ↔ V4.8 integration after the fix.
- [NOT RELEASED] V4.8.

## V4.9 HOTSIDE EXECUTION — 2026-10-05
- 12V Hotside limit: Fan ON, Peltier OFF, 10s dwell, then 9V.
- 9V Hotside limit: Fan OFF, Peltier OFF, 10s dwell, then 5V.
- 5V Hotside limit: terminal safety state; Adaptive exits and manual Peltier restart is required.
- Manual-mode Hotside preserves selected voltage.
- Rapid Hotside-rise protection remains absent.
- App fixed 2-second precharge removed; Firmware 5-second Peltier soft-start remains authoritative.
- App Build intentionally not executed here.
