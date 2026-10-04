# JE X FYZ — CURRENT APP NOTES

## IDENTITY
- App name: JE Cooler
- Header: JE X FYZ
- Package: com.horizontalzzz.jexfyz
- Version: 1.0.0+3
- Source: lib/main.dart
- Source blob: 7a0003ff7aa9691468139714ec18d364e5896b38

## BLE / SESSION
- flutter_blue_plus is the BLE transport.
- JE X FYZ service/RX/TX UUIDs are frozen.
- P1 SYNC/SYNC_READY gates a usable session.
- The App has a centralized BLE disconnect handler that clears session and live telemetry state.
- Auto Connect is passive and requires the known cooler identity.

## OTA
- Firmware update flow sends OTAENTER, SSID, PASS, URL, VERSION, then CLOUDOTA.
- Firmware performs the actual flashing.
- The App does not need a code change for the V4.4 GATT disconnect fix.
- When firmware closes the active GATT connection, the existing App disconnect handler should clear live data.
- Firebase supplies firmware release metadata; GitHub hosts the firmware BIN.
- Wi-Fi credentials use flutter_secure_storage.

## BUILD
- Latest verified Build #50.
- Run: 36996987220
- Source: bf01595253eb5a1912471c4aee57c4eed4421f0f
- APK artifact: 11222007634
- APK SHA256: 82a2320d8e3663800d6884f4cb0d009ff1b31b5b19cc64420f9ee5c6b01d01b0
- V4.4 is Firmware-only; no App Build required.
