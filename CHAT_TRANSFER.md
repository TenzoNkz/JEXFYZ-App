## 2026-10-04 — GEMINI PATCH-ONLY WORKFLOW UPDATE

- [CURRENT] Active firmware: V4.0; current source blob after compile-arity fix remains `415346ece09f4af33f907b2077140ccfc45c357b`.
- [CURRENT ISSUE] Online OTA indicator does not visibly blink in hardware testing.
- [USER RULE] Local OTA is frozen/protected because it has been verified working.
- [USER RULE] Gemini receives the .ino directly from the user and must provide only minimal `OLD` → `NEW` patches, never a full file.
- [USER RULE] The following `@Thinking Eksekusi Full!` belongs to the assistant: match OLD blocks to repository source, apply NEW blocks, full affected audit, memory sync, commit.
- [WORKFLOW DOC] Full copy-ready Gemini prompt is stored in `GEMINI_PROMPT_ONLINE_OTA.md`.
- [NO FUNCTIONAL CHANGE] This workflow update is documentation/process-only.

# JE X FYZ — CHAT TRANSFER SNAPSHOT

> Repository transfer boundary for the 2026-10-04 context-limit event.
> This snapshot records the current chat state after the V3.9 dual-audit reconciliation.
> Transfer evidence is persistent; current source and current workflow remain authoritative.
> Older transfer snapshots remain recoverable from Git history.

## 1. TRANSFER METADATA

- Project: JE X FYZ / JE Cooler.
- App repository: TenzoNkz/JEXFYZ-App.
- Branch: main.
- Firmware distribution repository: TenzoNkz/JEXFYZ-Firmware; binary-only distribution boundary.
- Current repository HEAD observed before this transfer: 940f7e7952c49b31e88fb540e1bff3848e5e17e4.
- Active firmware source: firmware/JEXFYZ-V3.9.ino.
- Active firmware source blob: bf85b50e0a8cab22e5d66ef09ee84d6692cee009.
- Firmware version literal: V3.9.
- App Build baseline: Build #50.
- This event is documentation/process only; no functional source change, release, Build App, compile, BIN, Firebase promotion, or flash is authorized by the transfer prompt.

## 2. CURRENT TASK

- Determine whether V3.9 is safe to update/flash onto the real JE X FYZ hardware.
- User requirement, exact wording: "saya akan kirimkan firmware V3.9 juga, jadi kamu dan gemini harus sama sama setuju sebelum saya update!"
- Decision: the firmware update gate is closed until both this assistant and Gemini agree on the exact V3.9 candidate.
- Gemini independent audit was received in-chat.
- This assistant independently re-checked Gemini's material findings against the active V3.9 source.
- Both reviews converge on NOT SAFE TO FLASH.
- Next technical action: patch P0 rail stabilization and P1 OTA certificate validation, then repeat the same two-party gate before any firmware update.

## 3. CURRENT WORKFLOW

- @Thinking Diskusi! = discussion/reconciliation only.
- @Thinking Eksekusi! = implement approved scope, synchronize memory, commit.
- @Thinking Eksekusi Full! = implement + full affected audit + synchronize memory + commit.
- @Thinking Tanya Gemini! = independent third-party review and reconciliation.
- @Thinking Build App! = explicit App build only.
- Current command is CHAT-LIMIT RECAP — SAVE TO REPOSITORY, therefore documentation only.
- Build App remains issue-trigger-only:
  - Issue title: JE X FYZ — BUILD APP TRIGGER
  - Body token: JEXFYZ_BUILD_TRIGGER_V1
- Normal push/PR must not create a release APK.
- No App Build is implied by firmware changes.
- Every meaningful project event must persist conclusions into repository memory.
- Future chats must perform the full memory preflight and current source/workflow inspection before analysis or action.

## 4. USER REQUIREMENTS

### Continuity and process
- Repository-first continuity is mandatory.
- Current source/current workflow > PROJECT_STATE.md > authoritative engineering notes > transfer/history.
- Never promote a hypothesis, old snippet, third-party suggestion, or successful compile into proof of hardware safety.
- Chat-limit Prompt 1 must save directly to CHAT_TRANSFER.md and verify the save.
- Prompt 2 in the new chat must rebuild context from the repository, not from stale remembered chat state.
- Do not perform functional source edits merely because a chat-limit transfer is requested.

### App/UI
- Product/app name: JE Cooler; in-app brand/header: JE X FYZ.
- Horizon Cooler App is the UI/architecture reference.
- Flutter/Dart with Android wrapper.
- Dashboard style: dark header plus white rounded content panel; cooler image on the right.
- Main areas: VOLTAGE, CONTROL, ADAPTIVE, LED, TEMPERATURE.
- Home: Hotside temperature, Battery temperature, Voltage, Adaptive, Peltier/Fan, Fan Speed, Notify Reason.
- App text should be Indonesian where applicable; source code remains English.
- Manual voltage mapping defaults: 5V red, 9V green, 12V blue; voltage color reset is separate.
- LED color/brightness follows Horizon-style controls; RGB mode needs no reset button.
- Fan speed is for the 12V manual mode, range 50–100%.
- Adaptive ON must return voltage to 5V first and lock manual voltage control while active.
- Separate reset controls by function; no global reset.
- Save settings after 10 seconds of no change and send only changed settings.
- User explicitly rejected the visual shadow treatment: "buang aja shadownya malah jadi jelek!"
- OTA result notification should be one-shot/nonpersistent rather than surviving power removal or cable/session end.
- Floating Monitor has an open Android permission/runtime investigation; no patch was made in this chat.

### Firmware hardware
- Target: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- Arduino Standard + official Arduino-ESP32 Core 3.3.7 target.
- GPIO0 NTC; GPIO1 Touch; GPIO3 12V selector; GPIO4 9V selector; GPIO5 Peltier; GPIO6 Fan; GPIO7 WS2812.
- Physical mapping is locked as GPIO5=Peltier and GPIO6=Fan. App logical tokens remain FAN:* and PELTIER:*.
- Fan PWM 25 kHz, 8-bit, 50–100%.
- Peltier PWM 20 kHz, 8-bit, 5-second soft-start.
- NTC 10k/10k, beta 3950, 12-bit ADC, 11 dB, 1-second sample.
- Selector deadtime 200 ms; shared voltage guard 1 s.
- No executable delay() and no timing while() wait loops.
- User raised optocoupler safety timing to 200 ms.
- Voltage switching must be break-before-make and must not overlap 9V/12V rails.

### Peltier / thermal / Adaptive
- In V3.9, true logical Peltier OFF -> ON is the soft-start trigger.
- Voltage changes must not restart soft-start.
- During selector deadtime, physical Peltier PWM must be 0 while logical Peltier state is preserved.
- New Peltier ON commands are blocked during an active voltage transition.
- Hotside is the universal thermal authority.
- Rapid Hotside rise must latch Peltier safety OFF and require manual restart.
- Invalid NTC must prevent non-5V selector activation.
- Battery protection is system safety, not an App-visible guard.
- Phone Battery Temperature is a remote BLE input, not an independent physical sensor.
- Battery Adaptive uses hysteresis.
- Adaptive start/stop returns the selector to 5V first.
- Fan remains available for cooling during thermal protection.

### BLE / radio
- P1 BLE protocol and command vocabulary are frozen.
- Known P1 UUIDs:
  - 6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001
  - 6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001
  - 6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001
- BLE ACK means command acceptance, while authoritative physical state comes from firmware telemetry.
- Runtime sync is delta based; no periodic full-sync spam.
- ESP32-C3 one-radio rule: Wi-Fi and BLE are not intentionally concurrent.
- BLE starts only after Wi-Fi is actually shut down and settled.

### OTA / Firebase / security
- Wi-Fi OTA is intended for the initial boot window, then Wi-Fi shuts down and BLE takes over.
- During OTA handoff/operation, cooling outputs are forced safe/off and selector is at 5V.
- Desired indicators: Wi-Fi fail red blink -> BLE recovery; Wi-Fi success blue blink -> update; OTA success green blink -> restart; OTA failure red blink -> BLE recovery.
- Firmware metadata is distributed using Firebase/GitHub like Horizon.
- Firebase selection uses firmware version plus raw URL; SHA is not the firmware-link selection contract.
- Approved online firmware source is the JE X FYZ raw GitHub BIN.
- Online OTA must authenticate the server using a validated CA/trust mechanism before production use.

### CI/build
- App build = exactly one normal production-signed, obfuscated APK; no Play Store bundle.
- Java 17, Flutter 3.47.2 stable, Gradle 9.3.1, ubuntu-24.04.
- Dependabot remains enabled.
- Signing identity is frozen and verified by CI.
- Build #50 remains the current App artifact baseline.

## 5. FROZEN / ACCEPTED DECISIONS

- GPIO5 = Peltier; GPIO6 = Fan.
- 200 ms selector deadtime.
- 1 s shared voltage guard.
- 5 s Peltier soft-start only on true logical OFF -> ON for V3.9.
- Voltage changes do not restart soft-start.
- Physical Peltier PWM is suppressed during selector deadtime while logical state remains ON.
- OTA supervisor has priority over normal application processing.
- Wi-Fi/BLE single-radio handoff.
- BLE advertising restart is deferred from callback context to the main loop.
- V3.9 is the active firmware source/version.
- Rapid-rise latch, final NTC gate, battery hysteresis, numeric anti-rollback, Local OTA magic-byte validation, Wi-Fi retry settle, full BLE teardown, OTA dispatcher fix, ADAPTIVE:OFF ACK correction, and reset-reason telemetry remain accepted hardening.
- Firmware source remains in the App repository; the dedicated firmware repository is binary-only.
- Dual-party approval is required before a V3.9 update.

## 6. REJECTED / OBSOLETE DECISIONS

- V3.7 and V3.8 are not the current firmware baseline; V3.9 supersedes them.
- firmware/JEXFYZ-V3.8.ino is retired.
- A source-level switching hazard must not be mislabeled as proof of a specific brownout root cause.
- Gemini's proposed 300–500 ms stabilization interval is a candidate engineering range, not universal proof.
- Firebase firmware linking by SHA is rejected.
- Restarting the 5 s soft-start merely because voltage changed is obsolete for V3.9.
- Direct BLE startAdvertising() from disconnect callback is rejected as the recovery design.
- Concurrent Wi-Fi/BLE handoff is rejected.
- Build App solely because firmware changed is rejected.

## 7. APP STATE

- App functional source/configuration was not changed by V3.9 hardening or by this transfer.
- Build #50 is the verified current App baseline.
- Build #50 Run: 36996987220.
- Build #50 source commit: bf01595253eb5a1912471c4aee57c4eed4421f0f.
- APK artifact ID: 11222007634.
- APK size: 54,245,456 bytes.
- APK SHA256: 82a2320d8e3663800d6884f4cb0d009ff1b31b5b19cc64420f9ee5c6b01d01b0.
- Symbols artifact ID: 11222132522.
- Symbols size: 8,308,848 bytes.
- Symbols SHA256: a87a3181bada92e2293c1f79d9a59339d7669c11b32ac1d8c219ae435c9062.
- Production signing certificate SHA256: dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0.
- Build #50 validates App build gates only, not V3.9 firmware.
- Floating Monitor remains an App-side open investigation based on user video evidence: OEM overlay permission can show Always allow while the current permission/runtime checks still fail to establish actual overlay health.

## 8. FIRMWARE STATE

### Active source
- V3.9 source: firmware/JEXFYZ-V3.9.ino.
- Blob: bf85b50e0a8cab22e5d66ef09ee84d6692cee009.
- 5305 source lines.
- Old V3.8 source retired.
- No V3.9 compile.
- No V3.9 BIN generation.
- No V3.9 Firebase promotion.
- No V3.9 flash.
- No physical V3.9 validation.

### V3.9 hardening already implemented
- Fixed Online OTA stream dispatcher starvation.
- Full BLE deinit for Online OTA Wi-Fi handoff.
- Wi-Fi retry re-arms Wi-Fi off and settle state.
- BLE disconnect recovery uses an atomic pending flag and main-loop advertising restart.
- Numeric semantic firmware version comparison.
- Final NTC selector gate.
- Physical Peltier PWM suppression during selector deadtime without changing logical state or soft-start timeline.
- Reject Peltier ON during active voltage transition.
- Battery Adaptive hysteresis.
- Rapid Hotside rise detection and safety latch.
- ADAPTIVE:OFF ACK correctness.
- esp_reset_reason() diagnostics.
- Local OTA first byte 0xE9 validation.
- BLE TX overflow diagnostics.

### V3.9 static evidence
- 574/574 braces.
- 2112/2112 parentheses.
- 0 executable delay().
- 0 timing while().
- 0 stopBleRadio(false).
- 137 DOC-CONTRACT blocks.
- setInsecure() remains present.
- esp_reset_reason() present.
- Numeric anti-rollback comparator present.
- Rapid-rise state/latch present.
- Battery hysteresis present.
- Local OTA magic validation present.

## 9. ANDROID / BLE / OTA / FIREBASE / CI

### Android
- Flutter + Android wrapper.
- Production signing identity is frozen.
- Release uses R8/minification and resource shrinking.
- Build #50-era user-visible Android versionName is Telegram @horizontalzzz.

### BLE
- P1 UUID/command contracts are frozen.
- BLE cryptographic authentication remains an open security item requiring App + Firmware protocol work.
- TX uses a finite FIFO.

### OTA
- Local OTA image magic validation is implemented.
- Online OTA prior starvation and incomplete BLE teardown were fixed.
- Online OTA still has synchronous HTTPClient GET() preparation.
- Online OTA still uses setInsecure().
- Post-boot health/rollback is absent.

### Firebase
- Version + raw URL distribution contract.
- V3.9 is not promoted to production Firebase metadata.

### CI
- app-build.yml is reusable and does not trigger on push.
- app-build-trigger.yml is issue-based and checks exact title/token.
- Release toolchain: ubuntu-24.04, Java 17, Flutter 3.47.2 stable, Gradle 9.3.1.
- Build #50 remains current.

## 10. SOURCE CHANGES

### V3.8 -> V3.9 functional lineage
- d3d78f010222f5b2dca12fc297fb7d2e1ec0f1b5 — harden V3.8 safety and OTA state machines.
- cbcfea379f7b897f142191d0b5783a90afa8da7e — tighten firmware version/local OTA validation.
- fac8a579e8c6b5af7c27cd01423d4ab04d753122
- 70498fc15a75e17721166766080f7538abf7b529
- 3a4c0ceedd5729fc0f9d62d5ec9be1f2d63cc59a
- e3673ad71c0fa2d10d8e80cd433bcb34ac4c5a08 — stale V3.8 version comment corrected.
- Final active V3.9 blob: bf85b50e0a8cab22e5d66ef09ee84d6692cee009.
- Functional source changes are Firmware-only; App functional source was unchanged.

### Documentation/process lineage
- 7e33bf97bc4a27be3b55f9ef55d1555b1376e229 — README V3.9 current-state record.
- fb8739e0549b55e9cb0415f76a1bb26b545bda2f — PROJECT_STATE V3.9 record.
- a2400f68ff5aa329460b8079746c9e52ab708452 — FIRMWARE_NOTES V3.9 record.
- bd948c4f53d814cd432eac26d906f6187b6eb7f5 — Firmware analysis V3.9 record.
- b45ded30a079199cedcb082d80fff79e5c746e89 — CHANGELOG V3.9 record.
- eb7f4e2e9c7804c9c9ffed5f777447126a39f032 — HANDOVER V3.9 record.
- a6f9453d955d0ab221778469ef7c401f0d8fd48d — APP_NOTES V3.9 impact.
- 187bf0e4a049bc7b5adb8d94797eb2b6e6f6b0c9 — Build boundary record.
- 534e2552e0908781762106a569e601598b319e89 — V3.9 execution completion memory record.
- Later dual-audit documentation commits observed before this transfer:
  - 0a4e0bf0dc0f726438143254083fb456241226f1
  - 347bafd9cbcc2a63f8cadf11c2fdac6b14a447c8
  - 02c2a5e0396d840761fe802abc123037e6fa2e57
  - 77fd3a62dc86ba2938eb03e94d629b9b03297df1
  - a9a100abfdf3ee54b376e3c0e9e96855b23bc6dd
  - eb8651b55de166f204870a703acc3fc7dc1801f3
  - 940f7e7952c49b31e88fb540e1bff3848e5e17e4
- These are documentation/audit-gate records, not new functional App/Firmware changes.

## 11. COMMITS / SHAs

### Current HEAD
- 940f7e7952c49b31e88fb540e1bff3848e5e17e4
- Message: docs: record V3.9 dual-audit flash gate

### Firmware hardening
- d3d78f010222f5b2dca12fc297fb7d2e1ec0f1b5
- cbcfea379f7b897f142191d0b5783a90afa8da7e
- fac8a579e8c6b5af7c27cd01423d4ab04d753122
- 70498fc15a75e17721166766080f7538abf7b529
- 3a4c0ceedd5729fc0f9d62d5ec9be1f2d63cc59a
- e3673ad71c0fa2d10d8e80cd433bcb34ac4c5a08

### Memory/audit documentation known from this context
- 7e33bf97bc4a27be3b55f9ef55d1555b1376e229
- fb8739e0549b55e9cb0415f76a1bb26b545bda2f
- a2400f68ff5aa329460b8079746c9e52ab708452
- bd948c4f53d814cd432eac26d906f6187b6eb7f5
- b45ded30a079199cedcb082d80fff79e5c746e89
- eb7f4e2e9c7804c9c9ffed5f777447126a39f032
- a6f9453d955d0ab221778469ef7c401f0d8fd48d
- 187bf0e4a049bc7b5adb8d94797eb2b6e6f6b0c9
- 534e2552e0908781762106a569e601598b319e89
- 0a4e0bf0dc0f726438143254083fb456241226f1
- 347bafd9cbcc2a63f8cadf11c2fdac6b14a447c8
- 02c2a5e0396d840761fe802abc123037e6fa2e57
- 77fd3a62dc86ba2938eb03e94d629b9b03297df1
- a9a100abfdf3ee54b376e3c0e9e96855b23bc6dd
- eb8651b55de166f204870a703acc3fc7dc1801f3
- 940f7e7952c49b31e88fb540e1bff3848e5e17e4

## 12. BUILD STATE

### Build #50
- [BUILT] Run 36996987220.
- [BUILT] Source commit bf01595253eb5a1912471c4aee57c4eed4421f0f.
- [BUILT] APK artifact ID 11222007634.
- [BUILT] Size 54,245,456 bytes.
- [BUILT] SHA256 82a2320d8e3663800d6884f4cb0d009ff1b31b5b19cc64420f9ee5c6b01d01b0.
- [BUILT] Symbols artifact ID 11222132522.
- [BUILT] Symbols size 8,308,848 bytes.
- [BUILT] Symbols SHA256 a87a3181bada92e2293c1f79d9a59339d7669c11b32ac1d8c219ae435c9062.
- [VERIFIED] Production signing certificate dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0.

### Build #41 historical
- Run 36800153829.
- Source 6deff1af4cb74310a00ee4ee0f3ed1584225c351.
- Artifact ID 11135950331.
- Size 54,245,456 bytes.
- APK SHA256 0470a30268b455cb55e564a3ce34ef05ac5b5a744f364b3765cd2ad29d14109e.
- Symbols artifact ID 11135985299.
- Symbols SHA256 4890c4baa223e687a356488d969b900f9c03b0f784d557a24cf38abda0fb80c2.
- Build #32 exists in history but exact artifact details are not present in this transfer context.

### Firmware build/testing
- [UNVERIFIED] V3.9 ArduinoDroid/Core 3.3.7 compile.
- [UNVERIFIED] V3.9 BIN.
- [UNVERIFIED] V3.9 Firebase.
- [UNVERIFIED] V3.9 firmware publication/signing.
- [UNVERIFIED] V3.9 flash.
- [UNVERIFIED] physical electrical, thermal, BLE, OTA validation.
- No V3.9 build troubleshooting was performed because compile was not attempted.

## 13. BUGS / SYMPTOMS

### Historical hardware/runtime
- 9V -> 12V caused immediate MCU restart; perceived switching gap about 2 s.
- 5V -> 9V had been reported safe.
- Fan/Peltier physical GPIO mapping had previously been swapped; corrected to GPIO5=Peltier, GPIO6=Fan.
- NTC readings had previously been inaccurate.
- Adaptive previously reset voltage to 5V without applying the intended Adaptive behavior.
- OTA notifications had previously persisted/reappeared after flashing or power cycling.
- Floating Monitor permission flow showed OEM "Always allow" but JE Cooler still treated overlay permission/runtime as unavailable.

### V3.9 current audit findings
- P0: zero-settle post-selector load reapplication.
- P1: Online OTA TLS trust disabled by setInsecure().
- P2: BLE TX queue can drop newest messages when full.

## 14. VERIFIED ROOT CAUSES

- [VERIFIED SOURCE] V3.9 preserves logical Peltier ON across selector deadtime, then completeVoltageTransition() can re-enable the rail and dependent cooling logic can restore duty 255 without an explicit post-selector rail-stabilization state.
- [VERIFIED SOURCE] Online OTA explicitly invokes cloudClient.setInsecure(), so certificate/server authentication is disabled for that connection.
- [VERIFIED SOURCE] BLE TX is a finite FIFO and drops newest messages on full; overflow is counted but ACK/OTA-state traffic has no reserved priority lane.

Important non-causality:
- [NOT PROVEN] The exact physical mechanism behind the historical 9V -> 12V reset. It may be brownout, LDO collapse, EMI, PSU transient, MOSFET/gate behavior, or another mechanism; source alone does not prove which.

## 15. HYPOTHESES / LIKELY CAUSES

- [HYPOTHESIS] Immediate reapplication of a full Peltier load after rail activation can exceed transient rail capability and reproduce the MCU reset.
- [HYPOTHESIS] A millisecond-scale rail settling period is electrically appropriate, but the exact value must be measured.
- [HYPOTHESIS] MOSFET gate charge/discharge may contribute to transient switching stress.
- [HYPOTHESIS] NTC ADC noise under PWM EMI may cause abrupt readings without appropriate hardware filtering.
- [HYPOTHESIS] Gemini's 300–500 ms recommendation is a candidate design range, not a universal constant.
- [HYPOTHESIS] BLE queue pressure can desynchronize App state if a critical ACK/OTA-state message is dropped.

## 16. VALIDATION EVIDENCE

### Repository/source/static
- [VERIFIED] V3.9 source blob bf85b50e0a8cab22e5d66ef09ee84d6692cee009.
- [VERIFIED] 5305 source lines.
- [VERIFIED] 574/574 braces.
- [VERIFIED] 2112/2112 parentheses.
- [VERIFIED] 0 executable delay().
- [VERIFIED] 0 timing while().
- [VERIFIED] 0 stopBleRadio(false).
- [VERIFIED] 137 DOC-CONTRACT blocks.
- [VERIFIED] esp_reset_reason() present.
- [VERIFIED] numeric version comparison present.
- [VERIFIED] rapid-rise state/latch present.
- [VERIFIED] battery hysteresis present.
- [VERIFIED] Local OTA magic byte validation present.
- [VERIFIED] setInsecure() present.

### Upstream/toolchain evidence
- Arduino-ESP32 3.3.7 upstream was previously checked for esp_reset_reason() and NetworkClientSecure CA APIs.
- Exact ArduinoDroid/Core 3.3.7 local compile/link remains unverified.

### Runtime/physical
- No V3.9 compile, BIN, Firebase, flash, oscilloscope, current, rail, thermal, BLE, or OTA hardware validation.

## 17. GEMINI RESULTS

### Audit question
- Perform an independent, adversarial, full-source firmware V3.9 audit and return SAFE TO FLASH / NOT SAFE TO FLASH / CONDITIONALLY SAFE.

### Gemini verdict
- [USER-MEDIATED / CONFIRMED] NOT SAFE TO FLASH.

### Gemini P0
- completeVoltageTransition() activates the selected 9V/12V rail after 200 ms deadtime, then dependent cooling logic can immediately restore an already-logically-ON Peltier to duty 255.
- Gemini considers this a zero-microsecond rail stabilization/load-slamming risk.
- Recommended a cooperative 300–500 ms post-selector stabilization period with Peltier physical PWM held at 0.

### Gemini P1
- Online OTA calls setInsecure().
- This removes server certificate validation and creates an OTA MITM/security risk.
- Gemini recommends trusted CA validation using setCACert()/CA bundle.

### Gemini P2
- BLE TX queue is finite FIFO and can drop new messages when full.
- Gemini recommends priority/eviction behavior so ACK and OTA-state messages are protected.

### Gemini PASS/FIXED
- OTA dispatcher starvation fixed.
- Full BLE radio teardown for online OTA fixed.
- BLE advertising recovery moved to main-loop context.
- Numeric anti-rollback fixed.
- Wi-Fi retry settle fixed.
- Rapid-rise protection fixed.
- NTC final gate fixed.
- Battery hysteresis fixed.
- Local OTA magic validation fixed.
- Static delay()/timing while() invariants clean.
- Reset diagnostics present.

### Reconciliation
- [CONFIRMED] Assistant rechecked Gemini's P0/P1/P2 claims against the active source.
- [DECISION] Both parties agree on NOT SAFE TO FLASH.
- [DECISION] Flash/update gate is CLOSED.
- [DECISION] 300–500 ms is not treated as a universal requirement.
- [DECISION] Historical reset is not promoted to a proven brownout cause without hardware evidence.

## 18. FAILED APPROACHES / DEAD ENDS

- Successful compile alone is not hardware-safety proof.
- Source-level switching hazard is not proof of the exact electrical root cause.
- setInsecure() is not acceptable for production Online OTA.
- Direct callback-context BLE advertising restart is rejected.
- Voltage-change-triggered soft-start restart is obsolete for V3.9.
- Executable timing delay()/while() wait loops are rejected.
- App Build solely because firmware changes is rejected.
- Stale PROJECT_STATE history cannot override current source/workflow.

## 19. KNOWN RISKS

- [P0] Post-selector rail/load stabilization state is missing from V3.9.
- [P1] Online OTA server authenticity is missing.
- [P2] BLE ACK/OTA-state priority is not protected.
- [OPEN] BLE cryptographic authentication.
- [OPEN] Synchronous Online OTA HTTP preparation.
- [OPEN] OTA post-boot health/rollback.
- [OPEN] Exact electrical mechanism of the historical 9V -> 12V reset.
- [OPEN] Exact ArduinoDroid/Core 3.3.7 compile/link.
- [OPEN] V3.9 BIN/Firebase/device evidence.
- [OPEN] NTC hardware EMI/noise characterization.

## 20. UNRESOLVED QUESTIONS

- What rail stabilization interval is actually required by the real PSU/regulator/MOSFET/load?
- Does the historical 9V -> 12V reset reproduce after the P0 sequencing fix?
- Can trusted GitHub CA validation compile in the exact ArduinoDroid/Core 3.3.7 environment?
- Should BLE use a priority queue, reserved ACK lane, or telemetry eviction?
- What is the safe App/Firmware authentication design for BLE commands?
- How should synchronous Online OTA preparation be redesigned?
- What OTA post-boot rollback/health policy is required?
- Which oscilloscope/current/rail measurements will close the electrical safety gate?
- What exact validated BIN SHA and Firebase record will be approved for V3.9?

## 21. CHAT-ONLY INFORMATION

- Before this save, Gemini's full audit result existed in the chat and was supplied by the user.
- This transfer now persists the material Gemini result and the assistant/Gemini consensus in the repository.
- The explicit user requirement that both assistant and Gemini must agree before update is now persistent in CHAT_TRANSFER.md and current project notes.
- No functional source change was made by this transfer.

## 22. EXACT NEXT ACTION

- Do not flash V3.9.
- Do not release or build the App.
- When execution is authorized, implement a cooperative post-selector stabilization state that holds physical Peltier PWM at 0 after selector activation, without changing the logical Peltier state or restarting the V3.9 OFF->ON soft-start contract.
- Replace setInsecure() with validated server/CA authentication compatible with the exact Arduino-ESP32 Core 3.3.7 target; do not guess the certificate.
- Address the P2 BLE critical-message drop behavior if included in the approved hardening scope.
- Run a full affected-source/static audit.
- Submit the revised candidate to the same two-party Gemini + assistant flash gate.
- Only after both agree proceed to compile, BIN generation, Firebase promotion, staged hardware testing, and eventual update.

## 23. REQUIRED FIRST ACTION IN NEW CHAT

- Read README.md.
- Read CHAT_TRANSFER.md.
- Read PROJECT_STATE.md.
- Read CHAT_RULES.md.
- Read APP_NOTES.md.
- Read FIRMWARE_NOTES.md.
- Read BUILD_NOTES.md.
- Read CHANGELOG.md.
- Read HANDOVER.md.
- Read firmware/FIRMWARE_ANALYSIS.md.
- Inspect current firmware/JEXFYZ-V3.9.ino.
- Inspect .github/workflows/app-build.yml and .github/workflows/app-build-trigger.yml.
- Reconcile stale historical V3.7/V3.8 sections against current source/current workflow.
- Report V3.9 active, flash gate closed, P0/P1/P2 open, Build #50 baseline, and no compile/BIN/flash evidence.

## 24. AUTHORITY / RECONCILIATION NOTES

- Current source and current workflow are higher authority than historical memory sections.
- PROJECT_STATE.md contains historical V3.7/V3.8 sections; the newest current-state override must supersede them.
- FIRMWARE_NOTES.md and firmware/FIRMWARE_ANALYSIS.md already contain V3.9 dual-audit gate notes before this transfer.
- CHANGELOG.md and HANDOVER.md also contain the V3.9 dual-audit flash-gate decision.
- app-build.yml is reusable and not push-triggered.
- app-build-trigger.yml is the explicit issue proxy and checks the exact issue title/token.
- This transfer introduces no functional source/workflow delta.

## 25. TRANSFER COMPLETION

- Recap completed: YES.
- Repository write: SUCCESS.
- CHAT_TRANSFER snapshot write commit: 756d9a63bab828e67cf95fd575853dd2255c112d.
- CHAT_TRANSFER snapshot blob produced by that write: 1bc6a425b6af273fe0e9f4ae244e45763569c8b2.
- PROJECT_STATE synchronization commit: d41fb74ed9816d46bc706f6b62a2e3ade68e5191.
- CHAT_RULES synchronization commit: fe9e35b578bd7034899e629ca6d030854257ddf6.
- Current HEAD observed at the completed documentation synchronization checkpoint: fe9e35b578bd7034899e629ca6d030854257ddf6.
- Current source observed and preserved unchanged: V3.9 / bf85b50e0a8cab22e5d66ef09ee84d6692cee009.
- Current workflows observed and preserved unchanged:
  - app-build.yml blob 731f4a7a43bf58d01a382053457d1f67a4742c8a.
  - app-build-trigger.yml blob 89598aff0b006bb3db6819080a13965fc5a6247d.
- Functional source/workflow delta from this transfer: NONE.
- Exact next action recorded: patch P0 + P1, then repeat two-party audit; no flash until both agree.

