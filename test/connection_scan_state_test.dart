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

  group('Bluetooth connection device name', () {
    test('shows the JE X FYZ name from the current BLE advertisement', () {
      expect(
        connectionDeviceDisplayName(
          advertisedName: 'JE X FYZ',
          platformName: '',
          fallback: 'Perangkat',
        ),
        'JE X FYZ',
      );
    });

    test('prefers the current advertised name over a stale platform name', () {
      expect(
        connectionDeviceDisplayName(
          advertisedName: 'JE X FYZ',
          platformName: 'Perangkat',
          fallback: 'Device',
        ),
        'JE X FYZ',
      );
    });

    test('uses the platform name when the advertisement has no local name', () {
      expect(
        connectionDeviceDisplayName(
          advertisedName: '  ',
          platformName: 'JE X FYZ',
          fallback: 'Perangkat',
        ),
        'JE X FYZ',
      );
    });

    test(
      'uses the localized fallback only when both Bluetooth names are empty',
      () {
        expect(
          connectionDeviceDisplayName(
            advertisedName: '  ',
            platformName: '',
            fallback: 'Perangkat',
          ),
          'Perangkat',
        );
      },
    );
  });
}
