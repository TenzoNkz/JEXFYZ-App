# JE X FYZ / JE Cooler — Current Project State

Last reconciled: 2026-11-28 (Asia/Jakarta). Authority: MASTER_PROMPT.md.

## Language policy

- **Language policy (owner decision 2026-11-28):** ChatGPT-facing explanations and reports in all three workspaces use clear standard Bahasa Indonesia, with English technical terms where precise. All explanatory and narrative text authored or revised in GitHub uses English only. Preserve required Indonesian App localization, protocol strings and verbatim evidence. See MASTER_PROMPT.md Section 2B.

## Code workstream — WP9 BLOCKED / VISUAL NOT VERIFIED

- Owner cadence: each fresh `@Thinking Eksekusi Code!` command authorizes exactly one WP. WP8 Floating Monitor boundary is COMPLETED. WP9 Flutter regression updates are verified, but actual Android/OEM visual acceptance remains blocked. WP10 has not started.
- **App implementation baseline:** `048c22ba4722848b962dc58d5b3e9dc7fe994961`. The latest Build App source `478bdfdc5ee18379e07baad5e4dfd8ab598dc2db` is later; the 50-commit comparison from the WP9 validation SHA shows no production App source file among the changed paths.
- **Validated WP9 source/test SHA:** `1488577fcb97099bc32a069560cfb373760c2e41`. Validation Only #329 / run 46116428334 / job 140891199755 terminal SUCCESS: locked dependencies PASS; formatter 63 Dart files / 0 changed; analyzer 159 info / 0 warnings / 0 errors; full Flutter suite 360/360 PASS. Added `test/settings_pages_accessibility_test.dart`, blob `607c82158b78b0c6978f0edaa09a66bd57b028c9`, covering Settings root and About, Language, Appearance, Notifications and Bluetooth subpages across 350/420 dp × EN/ID × Light/Dark.
- **Latest Build App package:** Build #173 terminal SUCCESS on source SHA `478bdfdc5ee18379e07baad5e4dfd8ab598dc2db`; Validation Only #334 passed 361/361 Flutter tests and all build/release gates. Release `jexfyz-latest` contains the signed APK and matching source archive. Build success does not establish installation, screenshot provenance, BLE operation or physical-device acceptance.
- **Owner screenshot evidence received 2026-11-28:** five captures, each 691 × 1536 px: Home EN/Dark, Settings root EN/Dark, Connection sheet EN/Dark (Bluetooth OFF, Location ON, no discovered devices and Scan disabled), Home ID/Dark, and Home EN/Light. Initial visual review shows no obvious major clipping in the supplied views; labels, Settings grouping and Connection error state are legible.
- **Screenshot provenance remains unverified:** the captures do not include source/APK SHA, device model, Android version, logical dp viewport, display density, text scale or reduced-motion setting. The owner has not yet confirmed that they were captured from Build #173's APK.
- **Owner UI decision:** remove the `Connect` CTA from the locked submenu card. Retain the dedicated Bluetooth icon/button at the Home top-left as the single Home entry point to the existing Connection flow. Keep the lock card informational and preserve its lock state/pointer blocking. Do not remove the Connection sheet, Settings > Bluetooth or existing BLE/connection implementation. This supersedes the earlier presentation choice to display a Connect action inside the card. Implementation is pending a fresh explicit Code command in the dedicated Code workspace.
- **WP9 evidence still incomplete:** the five captures cover only Home variants, Settings root and Connection sheet in disconnected conditions. Still required are all five Dashboard tabs, Settings subpages, Usage Statistics, applicable dialogs/sheets, Floating Monitor settings and the separate native Floating Monitor overlay; applicable 350/420-dp and constrained/narrow viewport, locale/theme/device-state, enlarged-text and reduced-motion coverage; and complete capture metadata.
- **Workspace boundary:** this Diskusi review made documentation-only updates. No executable source, test, config, workflow, Actions, build, release, native code, BLE/P1, Firmware/BIN, Firebase, OTA, signing, flashing or device operation was performed in Diskusi.

## Next action — BLOCKED

Confirm whether the supplied screenshots were captured from Build #173's exact APK and provide the missing device/Android, dp/density and accessibility metadata; complete the outstanding WP9 capture matrix, including the native overlay. Resume WP9 only with a fresh explicit `@Thinking Eksekusi Code!` command. Incorporate the locked-card CTA removal within that authorized WP scope. Do not start WP10 before WP9 visual acceptance.


Wait for the current-SHA Android screenshot matrix and metadata. Do not start WP10 before WP9 is accepted. Resume only with a fresh explicit `@Thinking Eksekusi Code!` command after evidence is available.
