# JE X FYZ / JE Cooler — Current Handover

Last reconciled: 2026-11-27 (Asia/Jakarta). Authority: `MASTER_PROMPT.md`.

## Active handover — CODE_FULL, then REPO_FULL

- **Owner scope:** finish App-only WP0–WP10 and evidence-backed build-ready handoff; then run the approved REPO_FULL cleanup cycle. Build App remains separate.
- **Repository policy:** direct commits to `main` only. Prior live check found only branch `main` and an empty rulesets response. No branch/PR workflow.
- **Verified current source:** `4c5feb51c8777b0576d0ac11f3fafb921db91b38`; root tree `a7474fc394c6b070de0195e82b53127a63e0bf38`; recursive 150 entries / 104 blobs / 46 trees; `truncated=false`. The register is being updated to 104 unique paths.
- **WP2 source:** bootstrap ordering isolated in `lib/app_bootstrap.dart`; Settings navigation and preference pages in `lib/settings_pages.dart` as a part of `floating_monitor.dart`. BLE/GATT/P1 state remains exclusively in Dashboard.
- **Latest validation:** #116 passed locked dependencies, analyzer and 239/239 Flutter tests but failed read-only formatter. Current exact-SHA revalidation is #118 / run `45919092056` / job `140245350553`; terminal result pending on `4c5feb51c8777b0576d0ac11f3fafb921db91b38`.
- **Protected contracts:** P1 UUID/framing/commands/SYNC_READY, single GATT owner, scan serialization/generation, telemetry truth, Usage Statistics v2/v1→v2/30-day/1-Hz/HOT/null-gaps/64+8+1, Android identity, OTA/Firebase/signing and Firmware safeguards remain protected.
- **Latest package:** Build #167 only; current source is not released. No Build App/APK/sign/release, Firmware/BIN, OTA, Firebase production, flashing or device operation.
- **Evidence blockers:** Flutter/Dart/Gradle/ADB absent locally. Android/Kotlin compile, screenshot/device/OEM review, SQLite migration fixture and long-session profile remain NOT RUN. Overall visual acceptance is **VISUAL NOT VERIFIED**.

## Next action

Confirm Validation Only #118 against its exact SHA, then continue the App-root/shared-core boundary and WP3 device-session characterization. REPO_FULL follows only after CODE_FULL closes. Do not invoke Build App in this workspace.
