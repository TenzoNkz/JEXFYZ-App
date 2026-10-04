# JE X FYZ — CHANGELOG

## V4.4 — 2026-10-04
- Explicitly closes an active BLE GATT session before Online OTA Wi-Fi handoff.
- Preserves the V3.2-style Online OTA transport/retry/result-indicator behavior.
- Local OTA remains protected.
- Static audit passed; physical V4.4 validation pending.

## V4.3 — 2026-10-04
- Restored Online OTA to the pre-yellow V3.2-style path.
- Removed yellow progress indicators and V4.2 cumulative passive Wi-Fi retry.
- User confirmed Local OTA and Online OTA success.

## V4.2 — 2026-10-04
- Introduced cumulative Online OTA Wi-Fi connection handling.
- Superseded by V4.3 rollback.

## V4.1 — 2026-10-04
- Simplified Online OTA Wi-Fi retry architecture.
- Superseded by V4.3 rollback.

## V4.0 — 2026-10-04
- Firmware hardening baseline before the V4.1–V4.3 OTA iterations.

## PRE-V4
- V3.3 introduced the yellow Online OTA progress layer.
- V3.2 is the exact pre-yellow Online OTA baseline.
- Detailed historical investigation remains available in Git history.
