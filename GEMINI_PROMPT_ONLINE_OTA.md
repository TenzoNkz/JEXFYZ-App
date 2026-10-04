# JE X FYZ — GEMINI REVIEW PROTOCOL / ONLINE OTA PATCH-ONLY

## Purpose

This document is the official prompt/template for `@Thinking Tanya Gemini!` when the user wants an independent Gemini diagnosis or fix.

The current priority is the **Online OTA indicator/runtime issue**. The user has explicitly confirmed that **Local OTA works on hardware and must be frozen/protected**.

## Current firmware baseline

- Repository: `TenzoNkz/JEXFYZ-App`
- Current branch: `main`
- Current firmware source: `firmware/JEXFYZ-V4.0.ino`
- Current functional source blob at the time of this protocol update: `415346ece09f4af33f907b2077140ccfc45c357b`
- Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module
- Arduino Standard + official Arduino-ESP32 Core 3.3.7

## User priorities

1. Online OTA must be **simple and reliable**.
2. Primary success criterion:
   - Wi-Fi connects;
   - GitHub JE X FYZ firmware URL connects;
   - `.bin` downloads;
   - OTA partition is written;
   - update finalizes;
   - success indicator is visible;
   - device restarts into the new firmware.
3. Online OTA does **not** need CA-bundle/custom-CA/certificate-pinning complexity.
4. `WiFiClientSecure + setInsecure()` is acceptable for Online OTA because the user explicitly prioritizes reliable GitHub connectivity over TLS certificate security.
5. The OTA binary URL must remain restricted to the user's JE X FYZ firmware repository.
6. Existing useful checks should remain when they do not make the flow unnecessarily complex: firmware version/anti-rollback, ESP32 image magic `0xE9`, OTA safe outputs, BLE-off-before-Wi-Fi handoff.
7. **LOCAL OTA MUST NOT BE CHANGED.**

## Current reported bug

During a physical Online OTA test, the expected Online OTA LED indicator did not visibly blink at all.

The firmware source already contains Online OTA indicator/state-machine functions, so diagnose the actual control-flow conflict instead of assuming the functions are missing.

Relevant Online OTA functions to inspect:

- `startOnlineOta()`
- `processOnlineOta()`
- `prepareOnlineOtaDownload()`
- `performOnlineOtaDownload()`
- `finalizeOnlineOtaFlash()`
- `failOnlineOta()`
- `processOnlineOtaResultIndicator()`
- `processOnlineOtaProgressIndicator()`
- `startOnlineOtaResultIndicator()`
- `serviceOtaPriority()`
- `processLeds()`
- Online OTA state enums/flags
- BLE → Wi-Fi radio handoff
- Online OTA LED state ownership

## Gemini task

The user will upload the current `.ino` file directly because Gemini cannot access the repository.

Use the uploaded `.ino` as the source of truth.

Perform an independent adversarial diagnosis of the Online OTA problem and propose the smallest correct fix.

### Required scope

- **ONLINE OTA ONLY**
- Do not refactor unrelated code.
- Do not modify normal cooling logic.
- Do not modify Adaptive.
- Do not modify NTC/thermal protection.
- Do not modify GPIO mapping.
- Do not modify App source.
- Do not modify CI/build workflow.

### HARD PROTECTION — LOCAL OTA

Do not change any of these unless the user later reports a separate, reproducible Local OTA defect and explicitly authorizes it:

- `LOCAL_OTA_PAGE`
- `localOtaUploadHandler()`
- `failLocalOta()`
- `abortLocalOtaTransaction()`
- Local OTA endpoint/handler routing
- Local OTA state transitions
- Local OTA image validation
- Local OTA success/failure indicator
- Local OTA SoftAP recovery
- Local OTA upload sequencing

The fact that Local OTA has been proven working on hardware is treated as a frozen baseline.

## ONLINE OTA implementation target

Keep the design simple:

```
BLE OFF
  ↓
Wi-Fi ON
  ↓
Wi-Fi connected
  ↓
BLUE BLINK
  ↓
GitHub firmware URL
  ↓
download .bin
  ↓
OTA write
  ↓
Update.end()
  ↓
GREEN BLINK
  ↓
restart
```

Failure:

```
failure
  ↓
RED BLINK
  ↓
stop/abort safely
  ↓
BLE recovery
```

The Online OTA URL should remain limited to:

```
https://raw.githubusercontent.com/TenzoNkz/JEXFYZ-Firmware/
```

Do not introduce a generic arbitrary-download URL.

## IMPORTANT: PATCH-ONLY OUTPUT

**DO NOT return the full `.ino` file.**

Every functional fix must be returned as a small explicit patch in this format:

### PATCH 1 — <short description>

OLD:
```cpp
<exact existing source block>
```

NEW:
```cpp
<replacement source block>
```

Repeat with PATCH 2, PATCH 3, etc. only when genuinely required.

Rules:

- Include only the lines/blocks that actually change.
- Keep OLD text exact enough that the repository source can be matched unambiguously.
- NEW text must be the complete replacement block.
- Do not include unrelated formatting cleanup.
- Do not rewrite the whole function if only a few lines need changing.
- Do not return a full file.
- If no source change is needed, explicitly say: `NO PATCH REQUIRED`.
- If you find multiple possible fixes, choose one recommended fix and keep alternatives separate as optional notes, not mixed into the patch.

## REQUIRED GEMINI RESPONSE STRUCTURE

1. **VERDICT**
   - `ONLINE OTA FIX REQUIRED`
   - or `NO PATCH REQUIRED`

2. **ROOT CAUSE**
   - Explain the actual source-level control-flow/state conflict causing the indicator failure.
   - Separate FACT from INFERENCE.

3. **PATCHES**
   - Provide only OLD → NEW patch blocks.
   - No full `.ino`.

4. **LOCAL OTA PROTECTION**
   - Explicitly state that Local OTA is unchanged.
   - List any Local OTA functions inspected only for regression context.

5. **REGRESSION CHECK**
   Confirm that the proposed patch does not alter:
   - Local OTA behavior;
   - GPIO mapping;
   - Peltier/fan behavior;
   - Adaptive logic;
   - NTC/thermal safety;
   - BLE/Wi-Fi single-radio rule.

6. **ONLINE OTA FLOW CHECK**
   Confirm the patched flow:
   - Wi-Fi connect → blue blink;
   - GitHub download → visible indicator;
   - successful finalization → green blink;
   - failure → red blink;
   - BLE recovery after failure.

7. **SOURCE CONSISTENCY CHECK**
   - Check braces/parentheses around touched areas.
   - Check symbol/enum names.
   - Check state transitions.
   - Check that the patch is compatible with Arduino-ESP32 Core 3.3.7.
   - Check there is no blocking `delay()` introduced.
   - Check there is no timing `while()` introduced.

8. **NO FULL FILE**
   - Do not output the entire `.ino`.

## NEXT STEP AFTER GEMINI

The Gemini response is **not** applied automatically.

The user will bring the Gemini patch back into the JE X FYZ chat.

Then the next command:

`@Thinking Eksekusi Full!`

means:

1. Compare Gemini's OLD block against the exact current repository source.
2. Apply the NEW block(s) only if they match the exact current source and are within the approved Online OTA scope.
3. Do not silently modify the patch to expand its scope.
4. Keep Local OTA untouched.
5. Run a full affected-source audit.
6. Synchronize repository memory.
7. Commit the functional source change.
8. Do not Build App unless separately requested.
9. Do not flash firmware merely because the patch was applied.
10. Because any functional source change creates a new firmware blob, repeat the required Gemini + Assistant exact-source review before reopening the flash gate.

## COPY-READY COMMAND

Use:

`@Thinking Tanya Gemini!`

Then send the following to Gemini together with the current `.ino` file:

> Audit and fix ONLY the Online OTA indicator/runtime problem in the attached JE X FYZ V4.0 .ino.
>
> Keep Online OTA SIMPLE: Wi-Fi → GitHub JE X FYZ firmware repository → download .bin → OTA write → Update.end() → green blink → restart. For failure use red blink and BLE recovery. `WiFiClientSecure + setInsecure()` is acceptable; do not introduce CA bundle, custom CA, or certificate-pinning complexity.
>
> **DO NOT CHANGE LOCAL OTA.** Local OTA has been proven working on hardware and is frozen/protected.
>
> Return **PATCHES ONLY**, not the full .ino. For every actual fix use:
>
> OLD:
> ```cpp
> exact current source block
> ```
>
> NEW:
> ```cpp
> replacement source block
> ```
>
> Diagnose why the Online OTA LED does not visibly blink and inspect the interaction between the Online OTA indicator state machine, `serviceOtaPriority()`, `processOnlineOta()`, `processLeds()`, `startOnlineOtaResultIndicator()`, `processOnlineOtaResultIndicator()`, `processOnlineOtaProgressIndicator()`, and the Wi-Fi/BLE handoff.
>
> Keep the change minimal, Online-OTA-only, non-blocking, Core 3.3.7 compatible, and do not modify Local OTA, normal cooling, Adaptive, NTC, GPIO, App, or CI.
>
> Final response must include: verdict, root cause, OLD→NEW patches, explicit Local OTA unchanged statement, regression check, Online OTA flow check, and source consistency check. Never output the full .ino.



# 2026-10-04 — FULL PRE-FLASH FORENSIC AUDIT REQUEST

## COPY THIS ENTIRE SECTION TO GEMINI

Saya akan melakukan **flash Firmware V4.0 melalui Local OTA** sebagai jalur update/testing karena **Online OTA sebelumnya masih gagal**. Sebelum saya flash Local OTA, lakukan **FULL FORENSIC CODE AUDIT** terhadap file `firmware/JEXFYZ-V4.0.ino` yang saya kirim bersama prompt ini.

### CURRENT SOURCE
- Firmware: **V4.0**
- Repository: `TenzoNkz/JEXFYZ-App`
- Current source blob: `0566105383a889912e5e756b0b9f265e5fcf0264`
- Target hardware: **ESP32-C3 Super Mini / ESP32-C3 Dev Module**
- Arduino platform: **Arduino Standard + official Arduino-ESP32 Core 3.3.7**

### USER PRIORITY
Prioritas utama sekarang bukan kosmetik, tetapi menemukan **semua kemungkinan bug, error, failure path, compile problem, watchdog/reset risk, state-machine deadlock, radio handoff failure, OTA failure, memory issue, race/reentrancy issue, dan hardware-safety issue** sebelum Firmware di-flash.

Online OTA sebelumnya **masih gagal**. Jangan menganggap patch Gemini sebelumnya sudah menyelesaikan masalah hanya karena source berubah. Cari root cause baru maupun root cause yang masih tersisa.

### HARD RULE — LOCAL OTA
**Local OTA adalah jalur flash/testing dan harus dianggap golden/protected.**
- Jangan mengusulkan perubahan Local OTA hanya karena ada bug Online OTA.
- Namun audit seluruh source harus memastikan perubahan V4.0 tidak secara tidak langsung merusak Local OTA, boot SoftAP, upload handler, Update.begin/Write/end, validation, recovery, atau restart flow.
- Jangan menyebut Local OTA aman hanya karena source terlihat benar; identifikasi semua kondisi yang secara realistis dapat membuat flashing Local OTA gagal.

### ONLINE OTA — AUDIT WAJIB SANGAT DETAIL
Analisa end-to-end:
1. BLE teardown → Wi-Fi ownership → Wi-Fi OFF settle → Wi-Fi STA connect.
2. ESP32-C3 single-radio constraint: pastikan BLE benar-benar inactive sebelum Wi-Fi.
3. Wi-Fi retry/failure/recovery dan kemungkinan state machine macet.
4. GitHub raw URL validation dan redirect handling.
5. `WiFiClientSecure + setInsecure()` compatibility pada Arduino-ESP32 Core 3.3.7.
6. Apakah synchronous `HTTPClient::GET()` dapat menyebabkan blocking, watchdog reset, starvation, timeout, atau membuat LED/state machine tampak mati.
7. HTTP response/status/content-length handling.
8. Stream availability/read behavior; premature close; timeout; partial reads.
9. ESP32 image magic byte `0xE9` validation.
10. `Update.begin()`, `Update.write()`, ukuran firmware, free sketch space, dan `Update.end()`.
11. Apakah download progress dapat kehilangan milestone 20/40/60/80/100.
12. Apakah indikator LED dapat tidak terlihat karena ownership, early return, state priority, atau transition overlap.
13. Apakah Online OTA bisa gagal tanpa LED feedback.
14. Failure path → Wi-Fi shutdown → BLE recovery.
15. Success path → green → restart.
16. Credential/url cleanup dan OTA state cleanup setelah success/failure.
17. Version parsing, anti-rollback, dan mismatch antara metadata Firebase/GitHub BIN.
18. Heap/stack pressure, large local buffers, String fragmentation, callback lifetime, atomic flags, and reentrancy.
19. BLE callback safety and main-loop API ownership.
20. Peltier/Fan/selector safety while OTA is active.

### FIRMWARE-WIDE AUDIT WAJIB
Jangan berhenti di OTA. Periksa juga:
- GPIO contract: GPIO0 NTC, GPIO1 touch, GPIO3 12V selector, GPIO4 9V selector, GPIO5 Peltier, GPIO6 Fan, GPIO7 WS2812.
- Peltier 20 kHz / 8-bit / 5 s OFF→ON soft-start.
- Voltage selector 200 ms deadtime.
- 300 ms post-selector rail stabilization.
- Hotside universal thermal authority.
- Rapid Hotside rise safety latch.
- NTC validity gate.
- Adaptive start/stop and 5V recovery.
- Battery validity/fallback/hysteresis.
- Fan PWM 25 kHz / 50–100%.
- No executable `delay()` and no timing `while()` loops.
- Preferences debounce/save behavior.
- LED ownership conflicts among normal RGB, voltage indicator, Hotside protection, and OTA.
- Any hidden path that can leave Peltier ON, Fan OFF, selector in an invalid state, or outputs active during OTA.

### PARTICULARLY LOOK FOR REAL FAILURE CONDITIONS
Cari bug dengan mindset **“bagaimana hardware benar-benar bisa gagal?”**, bukan hanya style review.

Untuk setiap temuan, jelaskan:
- exact function/state;
- trigger/sequence needed;
- what the device will do;
- why it can fail on real ESP32-C3;
- whether it can produce reset/hang/no LED/no OTA/no BLE recovery;
- severity: **P0 / P1 / P2 / P3**;
- whether it is proven from source or only a hypothesis.

### IMPORTANT DISTINCTION
Pisahkan:
- **PROVEN SOURCE BUG**
- **HIGH-CONFIDENCE RISK**
- **HYPOTHESIS REQUIRING HARDWARE TEST**
- **NOT A BUG**

Jangan mengarang hasil compile atau hardware test.

### FINAL VERDICT — REQUIRED
Akhiri dengan salah satu:
**SAFE TO FLASH LOCAL OTA**
atau
**NOT SAFE TO FLASH LOCAL OTA**

SAFE hanya boleh diberikan jika tidak ada P0/P1 yang dapat reasonably menyebabkan update/boot/runtime failure pada hardware.

### PATCH OUTPUT RULE
Bila menemukan bug yang benar-benar perlu diperbaiki sebelum flash:
- Jangan kirim full `.ino`.
- Kirim hanya patch yang diperlukan dalam format **OLD → NEW**.
- OLD harus exact text dari source yang saya kirim.
- NEW harus replacement lengkap.
- Jelaskan setiap patch dan mengapa patch tersebut diperlukan.
- Jangan mengubah Local OTA kecuali ada defect Local OTA yang benar-benar terbukti dari source dan secara langsung dapat menggagalkan flash/testing.

### RESPONSE STRUCTURE
1. FINAL VERDICT
2. P0 BLOCKERS
3. P1 CRITICAL RISKS
4. P2/P3 FINDINGS
5. ONLINE OTA END-TO-END FAILURE ANALYSIS
6. LOCAL OTA PRE-FLASH AUDIT
7. FIRMWARE-WIDE SAFETY AUDIT
8. COMPILE/CORE 3.3.7 RISKS
9. EXACT REQUIRED PATCHES (ONLY IF NEEDED, OLD → NEW)
10. WHAT IS STILL UNVERIFIED ON REAL HARDWARE

**Jangan bias terhadap patch sebelumnya. Audit source dari nol dan coba secara agresif menemukan cara firmware ini gagal.**
