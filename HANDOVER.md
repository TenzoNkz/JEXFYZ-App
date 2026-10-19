# JE X FYZ / JE Cooler — Current Handover

Reconciled against live GitHub on 2026-10-19 (Asia/Jakarta). Latest successful release is Build #95 from `cd691b874ddb0e454ba69891a3e0da3001df892f`, with 99/99 Flutter tests passing and all guarded release checks verified. Current animation-smoothness changes are newer source, **NOT RUN / NOT RELEASED**. No analyzer/test/build was run in this source-only follow-up. Final post-write HEAD/tree and fingerprints are in `CHAT_TRANSFER.md`.

Refreshed against live `main` on 2026-10-19 (Asia/Jakarta). The newest verified artifact is Build #95 from `cd691b874ddb0e454ba69891a3e0da3001df892f`, with 99/99 Flutter tests passing and all guarded release checks verified. The current animation smoothness follow-up is newer source and is **NOT RUN / NOT RELEASED**. Exact final HEAD/tree/source/doc hashes are in `CHAT_TRANSFER.md`; no App Build or Firmware/device operation was performed by this source task.

## Latest successful build and current source boundary

- Latest successful verified artifact remains **Build #95** / [Actions run 39217718351](https://github.com/TenzoNkz/JEXFYZ-App/actions/runs/39217718351), packaged from `cd691b874ddb0e454ba69891a3e0da3001df892f`. **99/99 Flutter tests passed**; analyzer passed with 23 info-level deprecations; all 21 guarded release steps, APK signatures/certificate, source ZIP, asset integrity and Release/tag/source checks passed. Native JUnit tasks were NO-SOURCE.
- APK asset `655596091` SHA-256 `856718ada30c5ef5081b5bb28a5e00c3b9d234e00ebced58a211112cc381140d`; source ZIP `655596090` SHA-256 `262d552e564b7c0a1727048a2e2897777ff18fa7296381a77f2c10236784ce7e`.
- Current source follow-up after Build #95 is **NOT RUN / NOT RELEASED**. Source blob `lib/main.dart` `f0bc1375799e7b9e4466a3124ddb031d5f58e522`; test blob `test/widget_test.dart` `aaf911cdcf5e23a23b80c2ef47ca4e11d406f9cf`. Flutter/Dart CLI is unavailable, so analysis and tests were not run.
- Motion changes address slow icon cycles, tiny fire/snow particles, visible phase wrap, whole-glyph breathing, Peltier crystal rotation coupled to snowfall, and abrupt Fan angular-rate changes. Cycles are Battery 1500 ms, Hotside 1650 ms, Voltage 1000 ms, Adaptive 2300 ms, Peltier 2100 ms. Fire/snow gain smooth boundary fades and periodic drift; main Home glyph becomes 26 dp inside the same 38 dp tile; Fan speed is integrated from persistent phase and smoothly retargeted across voltage/PWM changes.
- Device/control invariants remain unchanged. No App Build/release, Firmware/BIN/Firebase/OTA/flash/device operation was performed. Physical-device smoothness remains UNVERIFIED.

## Current approved motion details

- Battery/Hotside: three larger falling ember teardrops; existing warning predicates/thresholds and 280 ms transition remain.
- Voltage: existing path-following bolt current, unchanged semantic 5V red / 9V green / 12V blue.
- Adaptive: two opposing circular arrows; active-only animation; stable OFF pose.
- Peltier: falling branched snow fades at boundaries; primary six-branch crystal stays anchored with a subtle rock.
- Fan: exactly three blades and three fixed airflow ribbons. Existing voltage/PWM target mapping remains; rotation integrates angular rate and preserves accumulated phase.
- Fan Speed: semicircular gauge and existing PWM mapping remain; unknown/disconnected values do not produce a needle.



## FPS retirement and current Floating Monitor

- User decided to retire FPS after repeated F:--/Shizuku UserService failures. FPS, SurfaceFlinger TimeStats sampling, Shizuku permission/status UI/API/provider/dependency, UserService/AIDL, FPS-only tests and Shizuku-only notice/license files were removed from active source.
- The HUD has exactly six metrics: B (Battery), H (Hotside), V (Voltage), A (Adaptive), P (Peltier), F (Fan/Kipas label; current value is live speed). Schema v2 drops old schema-v1 F (FPS) and maps old S (Speed) to F. Fan telemetry and firmware speed control are unchanged.
- Overlay remains Letters-only, freely draggable, with saved coordinates; horizontal metrics centered as a group, vertical rows left aligned; size 0.30×–1.00× by 0.05× (default 0.60×); background opacity 0–100% by 5%, current value and endpoint marks only, no midpoint. Physical layout and live BLE metric behavior remain UNVERIFIED on the phone.
- Build #95 is the latest successful artifact run and exercised the guarded release/tag verification; release metadata, source ZIP and `jexfyz-latest` matched the Build #95 source. The current animation-smoothness follow-up is newer and remains untested/unreleased pending separate validation.

## Firmware / OTA boundary

- Firmware source: `firmware/JEXFYZ-V6.7.ino`, blob `efe6eaa62c178ab536fb68c06a310e54826cbaf2`; `FW_VERSION="V6.7"`; exactly one active versioned sketch. The user reports V6.7 compiled successfully and was updated online, but no compile log, resulting BIN, OTA log, source-to-BIN provenance or current device version was inspected here. V6.6 compile/OTA reports remain historical user reports.
- Artifact repository TenzoNkz/JEXFYZ-Firmware currently has exactly one recursive-tree entry: `JEXFYZ.cpp.bin`, blob `dca6a1267762152519f6d2889e4f0adf46fd8803`, 1,457,008 bytes. Only tree metadata was inspected; do not read/change the BIN payload or add notes there. Source-to-BIN provenance remains UNVERIFIED.
- Do not compile Firmware, publish/replace BIN, edit Firebase metadata, flash/OTA hardware or perform device actions without separate explicit approval. User compiles Firmware. Preserve Android versionName "Telegram @horizontalzzz".
- OTA is protected/frozen. Read OTA_PROTECTION.md and OTA_REGRESSION_MEMORY.md before any OTA/TLS/recovery edit; read VOLTAGE_TRANSITION_MEMORY.md before rail/Peltier timing edits. setInsecure() bypasses server-certificate identity verification; CA and NTP gates were removed together after a user-reported failure, but one cause was not isolated. Do not infer HTTP/TLS errors from LEDs.

## Immediate next step and authorization

1. After a separate `@Thinking Eksekusi Build App!`, verify the repaired issue-trigger workflow starts, all gates pass, and `refs/tags/jexfyz-latest == run.head_sha`; only then consider the release handoff complete.
2. If visuals or telemetry differ from the contract, capture screenshots/video and relevant live state first; do not infer on-device behavior from CI test pass alone.
3. Firmware/BIN/Firebase/OTA/flash/device operations were not performed or authorized in this App build.
