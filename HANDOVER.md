# JE X FYZ / JE Cooler — Immediate Handover

Updated: 2026-11-12 (Asia/Jakarta).

## Active source candidate — Firmware V7.2 + App Lock Voltage

- Repository: TenzoNkz/JEXFYZ-App, branch main.
- Implemented source scope: one-way Touch cycle based on actual rail (5V→9V→12V→5V); persistent 5V Lock Voltage in ESP32 Preferences key vLock5V; central 5V rail ceiling; Adaptive forced OFF / no reactivation while locked; safe handoff preserving existing 200ms break-before-make and 1s settle guard; NVS fail-closed semantics and retry; additive P1 command/state; Settings toggle and locked Voltage/Adaptive UI; nonblocking two-red-pulse refusal feedback with OTA/NTC/Hotside priority; source regression contracts.
- Source files: firmware/JEXFYZ-V7.2.ino, lib/main.dart, lib/floating_monitor.dart, test/firmware_qc_contract_test.dart, test/firmware_touch_adaptive_sync_test.dart. The prior V7.1 sketch is removed by the versioned rename. Initial implementation commit 876ff6527c973d963df49fff1e37242cc302667b; current Firmware blob 140e758e7101cadc3ccc58cc5c52e49534b0032c. App main blob eb70fcb9fdf6c13105fef6b64a0b402c8fac8eb3. Settings UI blob 5a1e8b3118fc46f3b9a0cb470aaefc11779a70e7. QC contract blob 485c2dc79cdd537f8f523db5bc4c722a3a68ebaf. Touch contract blob f177d0c724b0275849e126d3edc349eaf4a05471.
- Lock persistence contract: ON activates the runtime ceiling before NVS I/O and handoff; NVS putBool length + readback are required for saved=ON. Failed ON stays locked for the session and can retry; failed OFF remains locked. An already-persisted same-state command does not cause another NVS write. Unlock does not restore a previous rail or restart Adaptive.
- BLE: VOLTAGE_LOCK:ON|OFF; VOLTAGE_LOCK and VOLTAGE_LOCK_SAVED telemetry. Actual VOLTAGE:5V completion is separate from Lock ACK.
- Security caveat remains: Just Works + SYNC_READY is not official-App identity. Another bonded BLE client may still send unlock; BLE App authorization remains a separate blocked project.

## Release and validation boundaries

- Latest published App remains Build #149 / Actions run 42967289995. It does not contain this new App source.
- Flutter/Dart formatting, focused/full tests, analyzer and hosted CI were NOT RUN for this change. Static source contract tests were updated only.
- Firmware V7.2 compilation, BIN, Firebase, OTA, flash, device/NVS/rail/LED testing were NOT RUN.
- No new App Build/APK/Release was triggered. No hardware/device action was taken.

## Next direction

Review the new commit/source readback first. Then obtain a separate owner Eksekusi Build App! for hosted App QC/package. Firmware compilation and hardware/NVS/rail acceptance must be separately performed/authorized.