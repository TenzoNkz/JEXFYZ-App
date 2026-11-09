import 'package:flutter_test/flutter_test.dart';

import '../lib/connection_scan_state.dart';

void main() {
  group('Connection scan empty-state messaging', () {
    test('permission denial takes priority over other states', () {
      expect(
        connectionScanEmptyStateMessageKey(
          permissionRequired: true,
          bluetoothUnavailable: true,
          scanning: true,
        ),
        'connectionAccessRequired',
      );
    });

    test('Bluetooth or legacy location service unavailability is explicit', () {
      expect(
        connectionScanEmptyStateMessageKey(
          permissionRequired: false,
          bluetoothUnavailable: true,
          scanning: false,
        ),
        'connectionUnavailable',
      );
    });

    test('scan errors are shown instead of a perpetual scanning message', () {
      expect(
        connectionScanEmptyStateMessageKey(
          permissionRequired: false,
          bluetoothUnavailable: false,
          scanning: false,
          errorKey: 'scanFailed',
        ),
        'scanFailed',
      );
    });

    test('an active scan is labelled as scanning', () {
      expect(
        connectionScanEmptyStateMessageKey(
          permissionRequired: false,
          bluetoothUnavailable: false,
          scanning: true,
        ),
        'scanning',
      );
    });

    test('a completed scan with no matching cooler is labelled not found', () {
      expect(
        connectionScanEmptyStateMessageKey(
          permissionRequired: false,
          bluetoothUnavailable: false,
          scanning: false,
        ),
        'deviceNotFound',
      );
    });
  });
}
