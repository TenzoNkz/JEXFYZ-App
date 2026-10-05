# JE X FYZ — LATEST CHAT TRANSFER

## 1. CURRENT STATE
- Repository: TenzoNkz/JEXFYZ-App
- Branch: main
- Firmware: V4.6
- Active firmware source: firmware/JEXFYZ-V4.6.ino
- Firmware blob: cd2ebd7395343f64b824e74c1370b04cea6835ab
- App: 1.0.0+3
- App package: com.horizontalzzz.jexfyz
- Current App Build workflow: .github/workflows/jexfyz-app-build-trigger.yml
- Workflow blob: 51a6c4d35580228ae24f859058ae5b08665d94a0
- Latest verified App Build: workflow run 37245703677 / GitHub Release jexfyz-latest
- Current App Build was not run for V4.6.

## 2. V4.6 APPROVED/IMPLEMENTED CHANGES
- [IMPLEMENTED] Preserve the 60-second BOOT_AP_HARD_LIMIT.
- [IMPLEMENTED] Hardware single tap cycles 5V → 9V → 12V → 9V → 5V → ...
- [IMPLEMENTED] Hardware cooling ON forces Fan PWM to 100%.
- [IMPLEMENTED] Peltier OFF → ON keeps the 5-second soft-start.
- [IMPLEMENTED] Rapid Hotside-rise protection is removed.
- [PRESERVED] Normal Hotside temperature-limit protection.

## 3. FROZEN CONTRACTS
- Local OTA Golden/Protected.
- Wi-Fi/BLE single-radio ownership.
- BLE Service/RX/TX UUIDs.
- P1 synchronization contract.
- App package identity and production signing identity.
- Manual issue-triggered App Build; normal push/PR does not build an APK.

## 4. VALIDATION BOUNDARY
- V4.6 source/static audit: PASS.
- No executable delay() and no timing while() loops.
- Exactly one active versioned .ino remains under firmware/.
- Firmware compile/BIN/flash/physical validation: UNVERIFIED.
- No App Build was executed by this firmware-only change.
- Latest verified App APK predates V4.6 and is evidence only for the unchanged App source.

## 5. NEXT ACTION
- Compile/flash V4.6 on ESP32-C3 and perform physical touch voltage bounce, Fan 100%, Peltier 5-second soft-start, Hotside-limit, Local OTA, and Online OTA/BLE recovery validation.
