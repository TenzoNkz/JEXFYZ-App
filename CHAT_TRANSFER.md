# JE X FYZ — LATEST CHAT TRANSFER

## TRANSFER METADATA
- Repository: TenzoNkz/JEXFYZ-App
- HEAD: b612626861cee4f5f8b4d20e6ef0d88c5f0ca550
- Branch: main
- This file is the latest replace-style transfer snapshot.
- Superseded transfer snapshots remain in Git history only.

## CURRENT TASK
Verify the V4.4 firmware change that explicitly closes the active BLE GATT session when Online OTA starts.

## CURRENT WORKFLOW
- Diskusi = review only.
- Tanya Gemini = diagnosis/patch-only.
- Eksekusi = implement + affected audit + sync + commit.
- Eksekusi Full = implement + full audit + sync + commit.
- Build App = explicit App build.
- Eksekusi & Build App = implement + audit + sync + commit + App Build.

## CURRENT PROJECT TRUTH
- App: JE Cooler / JE X FYZ
- App version: 1.0.0+3
- Package: com.horizontalzzz.jexfyz
- Firmware: V4.4
- Firmware source: firmware/JEXFYZ-V4.4.ino
- Firmware blob: acbd376b4b5a1f536e83c35b24600e85462de579
- Latest App Build: #50
- Build source SHA: bf01595253eb5a1912471c4aee57c4eed4421f0f

## REQUIREMENTS / FROZEN DECISIONS
- Local OTA is protected.
- Online OTA stays simple and V3.2-style.
- No yellow Online OTA progress layer.
- BLE and Wi-Fi are mutually exclusive.
- Functional Firmware changes increment version.
- No executable delay() and no timing while() loops.
- App Build remains manual and independent from Firmware.

## VERIFIED RUNTIME HISTORY
- V4.3 Local OTA: PASS — user confirmed.
- V4.3 Online OTA: PASS — user confirmed.
- V4.4 GATT disconnect: pending.

## V4.4 CHANGE
V4.3 stopped BLE advertising but left the active GATT session open.
V4.4 adds explicit BLEServer disconnect using the connection ID.

## STATIC VALIDATION
- 5223 lines.
- braces/parentheses/brackets balanced.
- executable delay() = 0.
- timing while() = 0.
- yellow 0xFFFF00 refs = 0.
- stale Online OTA progress refs = 0.
- explicit GATT disconnect = 1.
- one active versioned .ino remains.

## RISKS / UNVERIFIED
- V4.4 has not yet been physically flashed/tested.
- Core 3.3.7 compile/BIN and Firebase promotion are still separate gates.
- The new GATT disconnect boundary must be validated on Android + ESP32-C3.

## EXACT NEXT ACTION
Compile/flash V4.4. Test BLE disconnect at Online OTA start, verify telemetry stops, verify OTA succeeds, then verify reboot/reconnect/sync.

## REQUIRED FIRST ACTION IN NEW CHAT
Read the full mandatory memory stack and exact current source/workflow, reconcile this transfer, and continue the exact next action.

## RECONCILIATION NOTE
Current source/workflow outrank this transfer. Old V4.1/V4.2/V4.3 current-state claims are historical and must not be treated as current.
