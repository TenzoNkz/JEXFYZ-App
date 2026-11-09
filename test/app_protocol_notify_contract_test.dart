// AI-MEMORY / TEST CONTRACT
// Covers pure P1 protocol-token validation and deterministic Home NOTIFY helpers.
// These tests do not exercise a live BLE radio, physical device state, or OTA transport.

import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/main.dart';

void main() {
  test('P1 protocol validation accepts only P1', () {
    expect(isSupportedP1Protocol('P1'), isTrue);
    expect(isSupportedP1Protocol('p1'), isTrue);
    expect(isSupportedP1Protocol('P2'), isFalse);
  });

  test('stale Peltier re-arm notice clears after healthy safety telemetry', () {
    expect(shouldClearStaleNotifyError(
      connected: true,
      safety: 'OK',
      safetyReason: 'NONE',
      liveTelemetryReceived: true,
      notice: 'Peltier is locked. Hotside must cool to <= 43°C before restart.',
    ), isTrue);
    expect(shouldClearStaleNotifyError(
      connected: true,
      safety: 'LOCKED',
      safetyReason: 'PELTIER_SAFETY_LATCH',
      liveTelemetryReceived: true,
      notice: 'Peltier is locked.',
    ), isFalse);
  });
}
