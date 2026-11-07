---
name: ble-p1-protocol-audit
description: Use for Bluetooth Low Energy, GATT, P1 framing, session readiness, reconnect, telemetry parsing, command acknowledgements, Touch synchronization, or state-machine race analysis in JE Cooler.
---

# BLE P1 Protocol and Telemetry Audit

## Objective
Audit the App/Firmware BLE contract as a distributed state machine with one authoritative physical-state source.

## Procedure
1. Read APP_NOTES.md, FIRMWARE_NOTES.md, BLE_APP_AUTH.md and current App/Firmware source before making protocol claims.
2. Map Service/RX/TX UUIDs, P1 framing, message ownership, parser behavior, write properties, encryption/bonding and notification subscriptions.
3. Draw the session lifecycle: permission/prerequisite checks → scan/discovery → connect → service discovery → security/bonding → P1 sync/readiness → normal command/telemetry → disconnect/recovery.
4. For every command identify: intent, transport write, ACK semantics, authoritative telemetry/event that confirms physical state, timeout and rollback behavior.
5. Analyze ordering/races: delayed ACK vs newer telemetry, duplicate messages, partial frames, stale samples, queue backpressure, disconnect during sync, reconnect with old values, app lifecycle pause/resume and permission loss.
6. Confirm unknown values remain unknown while disconnected or unsynchronized. Never infer output ON/OFF from command intent or an ACK alone.
7. Audit Touch-originated changes to ensure the App and Floating Monitor receive authoritative state updates.
8. Treat bonded Just Works + SYNC_READY as encrypted session readiness, not proof of official App identity. The BLE App-only authorization design remains blocked until trusted enrollment/signing and Firmware verification.
9. Propose a state transition table and targeted regression tests before implementation.

## Required output
- State diagram or lifecycle sequence.
- Message/ACK/telemetry table.
- Race and stale-state risks ranked by severity.
- Exact source/test evidence and gaps.
- Targeted acceptance-test matrix.

## Guardrails
Do not casually change UUIDs, protocol identifiers, retry cadence, session gates or persistence. No BLE device operation in Diskusi. App Build, Firmware compile, OTA and flashing are separately authorized operations.
