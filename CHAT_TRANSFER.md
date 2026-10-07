# JE X FYZ — CHAT TRANSFER / NEW CHAT BOOT PROTOCOL

> Transfer Protocol v3 — current V5.9 integrated QC snapshot reconciled from main.

## 0. READ FIRST / MANDATORY BOOT

- [VERIFIED] Current repository: TenzoNkz/JEXFYZ-App.
- [VERIFIED] Branch: main.
- [VERIFIED] Current main HEAD at the start of this functional execution: 414cc6959d9fd5d89968da19b9473b317b0cbba7; firmware execution commit: d13883f075c075672fb0c8c906877cba8402b7b4.
- [VERIFIED] Current active Firmware: V5.9 at firmware/JEXFYZ-V5.9.ino.
- [VERIFIED] Current App: 1.0.0+3; package com.horizontalzzz.jexfyz.
- [VERIFIED] Current phase: V5.9 — DEVELOPMENT + QC / PRE-RELEASE → NOT RELEASED.
- [POLICY] Read this file first, then reconcile current source/configuration before acting.
- [POLICY] Current source and workflow always outrank this transfer snapshot when they conflict.
- [POLICY] Do not ask the user to repeat project facts already documented here or in the authoritative repository files.
- [POLICY] Transfer/save does not authorize functional source changes, App Build, Firmware release, BIN publishing, or unverified runtime claims.

## 1. PROJECT IDENTITY

- [CURRENT TRUTH] Project: JE X FYZ.
- [CURRENT TRUTH] App name: JE Cooler.
- [CURRENT TRUTH] Header/branding: JE X FYZ.
- [CURRENT TRUTH] Hardware: ESP32-C3 Super Mini / ESP32-C3 Dev Module.
- [CURRENT TRUTH] Firmware source authority: firmware/ inside JEXFYZ-App.
- [CURRENT TRUTH] Firmware publishing repository: TenzoNkz/JEXFYZ-Firmware.
- [CURRENT TRUTH] Active Firmware: V5.9.
- [CURRENT TRUTH] App version: 1.0.0+3.
- [CURRENT TRUTH] Package: com.horizontalzzz.jexfyz.
- [CURRENT TRUTH] Release status: NOT RELEASED.

## 2. AUTHORITY HIERARCHY

1. Current source/configuration and current workflow.
2. PROJECT_STATE.md.
3. Authoritative current engineering notes.
4. HANDOVER.md / CHAT_RULES.md / CHANGELOG.md.
5. CHAT_TRANSFER.md.
6. Current chat statements.
7. Old chat/history.

- [POLICY] Historical statements are evidence of history, not current implementation permission.
- [POLICY] When documentation conflicts with source, record the discrepancy rather than guessing.

## 3. USER COMMAND PROTOCOL

- [USER REQUIREMENT] @Thinking Diskusi! = discussion/review only.
- [USER REQUIREMENT] @Thinking Tanya Gemini! = diagnosis/OLD → NEW patch request; do not silently execute.
- [USER REQUIREMENT] @Thinking Eksekusi! = implement approved scope + affected audit + docs/memory sync + commit; no App Build unless separately commanded.
- [USER REQUIREMENT] @Thinking Eksekusi Full! = full implementation + broad affected audit + docs/memory sync + commit; App Build is not implied.
- [USER REQUIREMENT] @Thinking Build App! = explicit App Build operation.
- [USER REQUIREMENT] @Thinking Eksekusi & Build App! = implement → audit → docs → commit → App Build.
- [POLICY] Chat-limit transfer/save itself is documentation-only.

## 4. CURRENT PROJECT MODE

- [CURRENT TRUTH] QC / PRE-RELEASE.
- [CURRENT TRUTH] Functional source is frozen except for a demonstrated QC defect with clear root cause and approved scope.
- [CURRENT TRUTH] V5.9 is NOT RELEASED.
- [POLICY] Static audit, compile, BIN generation, flash, physical QC, OTA regression, App integration, and App Build are separate gates.

## 5. HARDWARE CONTRACT

| Function | GPIO |
| --- | ---: |
| NTC Hotside | 0 |
| TTP223 Touch | 1 |
| 12V selector | 3 |
| 9V selector | 4 |
| Peltier | 5 |
| Fan | 6 |
| WS2812 | 7 |

- [FROZEN] ESP32-C3 single-radio rule: Wi-Fi and BLE must never own the radio concurrently.
- [FROZEN] Fan PWM: 25 kHz, 8-bit, 50–100%.
- [FROZEN] Peltier PWM: 20 kHz; OFF→ON soft-start 5 seconds, cooperative.
- [FROZEN] Selector deadtime: 200 ms break-before-make.
- [FROZEN] Voltage guard: 1 second after completed transition.
- [FROZEN] NTC model: 10K NTC + 10K fixed resistor + Beta 3950 + 3.3 V reference design.
- [FROZEN] V5.9 NTC cadence: exactly one calibrated ADC reading every 1 second.
- [FROZEN] Hotside limit: 40–50°C, default 45°C.