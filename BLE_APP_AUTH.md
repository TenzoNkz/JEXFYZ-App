# JE X FYZ / JE Cooler — BLE App Authorization Design

**Status: BLOCKED — secure App-only command authorization is not implemented.**  
Checkpoint date: 2026-10-20 (Asia/Jakarta). Baseline source parent: `14e90e7e26b8eb4400bd01ec8d0eab5ed4195f1c`.

## Required user experience and invariants

- Daily workflow remains: power on cooler → open JE Cooler → Connect BLE → use the cooler.
- No QR, no new Touch gesture, no additional daily pairing/enrollment screen. Existing single tap, double tap, 5-second long press, and multi-tap cancellation must remain unchanged.
- nRF Connect and other third-party/manual BLE clients must not gain control merely by knowing the GATT UUIDs and command strings.
- Hardware Touch, NTC/Hotside thermal protection, sensor-fault fail-safe and OTA-safe outputs are Firmware-owned and must not depend on App authorization.
- **OTA is explicitly frozen.** Do not modify either OTA state machine, Wi-Fi/BLE handoff, TLS trade-off, URL allowlist, redirects, status/length/size/image checks, streaming, timeout/retry, safe-output order, result/recovery/restart, or App OTA disconnect/reconnect lifecycle.

## Live source findings

Firmware source: `firmware/JEXFYZ-V7.0.ino`, blob `823f6f31176695a3ff3a923995b1b3cd5f42c683`.

- RX writes are configured as encrypted and bonded, but pairing uses Just Works and does not provide MITM identity assurance.
- `dispatchBleLine()` gates normal commands on `bleCommandGateOpen`; `SYNC_READY` itself opens that gate.
- Current P1 BLE protocol has no per-install App signing key, firmware-anchored trusted App public key, cryptographic challenge-response, or authenticated owner enrollment.
- Therefore encrypted/bonded BLE plus `SYNC_READY` does not prove the connected client is the official JE Cooler App. The present source does **not** establish that nRF Connect/manual command writing is blocked by App identity.

## Intended architecture (not implemented)

1. The App creates a per-install ECDSA P-256 key pair in Android Keystore. Its private key is not embedded as a shared secret in the APK and is not exported to Firmware.
2. At initial trust establishment, a backend validates a genuine App/device integrity assertion and applies an explicit cooler-claim policy. App Check/Play Integrity by itself does not establish who owns the cooler.
3. A trusted backend stores the authorized public-key/device association and issues a signed, device-bound, narrowly scoped enrollment grant. The backend signing private key must remain in managed server-side secret storage and must never be committed to this repository.
4. Firmware validates the signed grant, binds it to its own identity, and stores the authorized public key in NVS. An arbitrary first BLE client cannot claim the cooler by simply submitting its own public key.
5. Every connection uses a fresh cryptographically random nonce/challenge bound to device identity and the session. The App signs the challenge with its Keystore private key. Firmware verifies it, enforces expiration and replay rejection, and clears session authorization on disconnect.
6. All command paths—including `SYNC_READY`, controls/settings, `SSID`, `PASS`, `URL`, `VERSION`, `CLOUDOTA`, and `PHONE:BT=`—must be protected before application handlers run. Telemetry-read access should be assessed separately.
7. The migration must be versioned and staged with the App protocol. New Firmware must fail closed for unauthorized commands; it must not contain a fallback that accepts the old unauthenticated command path. A tested owner recovery / phone replacement policy is required to avoid accidental permanent lockout.

## Blocking dependency and authorization boundary

No trusted backend enrollment/signing endpoint, owner-claim store, deployable server-side code, or server signing-key provisioning flow was found in the live repository tree. Current App Check initialization is best-effort client-side initialization and does not constitute an enforced server-side enrollment trust anchor.

Secure automatic first enrollment therefore needs backend source, managed signing secrets, an owner-claim/recovery policy, database access rules, configuration/deployment, and end-to-end validation. `@Thinking Eksekusi Full!` authorizes source/tests/docs/commit but does not authorize production Firebase configuration changes or deployment. Implementing key acceptance from any first connected BLE peer would let an attacker claim the cooler and create false security, so this execution deliberately does not add an incomplete Firmware authentication gate.

## Required acceptance evidence

- A bonded, untrusted client such as nRF Connect cannot open the command gate using `SYNC_READY`.
- Manual controls, settings, Wi-Fi credentials, `PHONE:BT=` and Online OTA command writes are rejected before handlers run.
- Invalid signature, expired challenge, replayed challenge, wrong device binding, unregistered key and session reuse fail closed.
- The trusted App authenticates automatically with no additional routine user interaction.
- New phone / reinstall recovery cannot replace an owner key without an authorized recovery action.
- All Touch gestures and thermal/fault fail-safe behavior remain unchanged; OTA invariants have a no-diff audit.
- Static contract tests are not sufficient security proof: run protocol tests, compile Firmware with the approved toolchain and separately validate the real device once separately authorized.

## Execution checkpoint — 2026-10-20

- Completed: localized Wi-Fi password visibility toggle in Firmware Update dialog; existing secure storage and OTA order retained.
- Not completed: BLE App authorization, because the trusted enrollment/signing backend is missing and production deployment is outside this command's permission.
- Not run: Flutter/Dart tests, analyzer, Android build, Arduino compile, BLE device test, Firebase production deployment, BIN publication, OTA or device operation.
