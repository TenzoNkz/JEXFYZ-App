import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jexfyz_cooler/floating_monitor.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('je_x_fyz/floating');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    floatingConfigNotifier.value = const FloatingConfig();
    floatingTelemetryNotifier.value = const FloatingTelemetry();
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('hasPermission returns the native overlay permission state', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'hasOverlayPermission');
      return true;
    });

    expect(await FloatingBridge.hasPermission(), isTrue);
  });

  test('hasPermission fails closed on null and platform errors', () async {
    messenger.setMockMethodCallHandler(channel, (call) async => null);
    expect(await FloatingBridge.hasPermission(), isFalse);

    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'permission_unavailable');
    });
    expect(await FloatingBridge.hasPermission(), isFalse);
  });

  test('openPermissionSettings returns the native launch result', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'openOverlaySettings');
      return true;
    });

    expect(await FloatingBridge.openPermissionSettings(), isTrue);

    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'settings_unavailable');
    });
    expect(await FloatingBridge.openPermissionSettings(), isFalse);
  });

  test(
    'start forwards config and the latest localized telemetry snapshot',
    () async {
      const config = FloatingConfig(
        enabled: true,
        order: <String>['F', 'B', 'H', 'V', 'A', 'P'],
        selected: <String>{'F', 'B'},
        size: 0.75,
        opacity: 0.65,
        horizontal: false,
      );
      const telemetry = FloatingTelemetry(
        battery: '45.8',
        hotside: '52.0',
        voltage: '12.0',
        fanOn: true,
        speed: 80,
        adaptiveOn: true,
        peltierOn: true,
        connected: true,
        language: 'indonesia',
      );
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'startFloatingMonitor');
        final payload = jsonDecode(call.arguments as String) as Map;
        expect(payload['enabled'], isTrue);
        expect(payload['metricSchemaVersion'], FloatingMetric.schemaVersion);
        expect(payload['order'], config.order);
        expect((payload['selected'] as List).toSet(), config.selected);
        expect(payload['size'], 0.75);
        expect(payload['opacity'], 0.65);
        expect(payload['horizontal'], isFalse);
        expect(payload['battery'], '45.8');
        expect(payload['hotside'], '52.0');
        expect(payload['voltage'], '12.0');
        expect(payload['fanOn'], isTrue);
        expect(payload['speed'], 80);
        expect(payload['adaptiveOn'], isTrue);
        expect(payload['peltierOn'], isTrue);
        expect(payload['connected'], isTrue);
        expect(payload['language'], 'indonesia');
        return true;
      });

      expect(await FloatingBridge.start(config, telemetry: telemetry), isTrue);
    },
  );

  test('start reports false when the native method channel fails', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'service_start_failed');
    });

    expect(await FloatingBridge.start(const FloatingConfig()), isFalse);
  });

  test(
    'stop invokes the native service stop command and contains errors',
    () async {
      var calls = 0;
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'stopFloatingMonitor');
        calls++;
        if (calls == 2) throw PlatformException(code: 'stop_failed');
        return true;
      });

      await expectLater(FloatingBridge.stop(), completes);
      await expectLater(FloatingBridge.stop(), completes);
      expect(calls, 2);
    },
  );

  test(
    'updateConfig forwards the versioned presentation configuration',
    () async {
      const config = FloatingConfig(
        enabled: true,
        selected: <String>{'B', 'F'},
        size: 0.85,
        backgroundColor: FloatingBackgroundColor.white,
      );
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'updateFloatingConfig');
        final payload = jsonDecode(call.arguments as String) as Map;
        expect(payload['metricSchemaVersion'], FloatingMetric.schemaVersion);
        expect(payload['enabled'], isTrue);
        expect(payload['size'], 0.85);
        expect(payload['backgroundColor'], 'white');
        expect((payload['selected'] as List).toSet(), config.selected);
        return null;
      });

      await expectLater(FloatingBridge.updateConfig(config), completes);
    },
  );

  test(
    'updateData forwards the latest telemetry and selected app language',
    () async {
      const telemetry = FloatingTelemetry(
        battery: '40.2',
        hotside: '51.4',
        voltage: '9.0',
        fanOn: false,
        speed: 0,
        connected: true,
        language: 'indonesia',
      );
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'updateFloatingData');
        final payload = jsonDecode(call.arguments as String) as Map;
        expect(payload['battery'], '40.2');
        expect(payload['hotside'], '51.4');
        expect(payload['voltage'], '9.0');
        expect(payload['fanOn'], isFalse);
        expect(payload['speed'], 0);
        expect(payload['connected'], isTrue);
        expect(payload['language'], 'indonesia');
        return null;
      });

      await expectLater(FloatingBridge.updateData(telemetry), completes);
    },
  );

  test('updateConfig and updateData contain native channel failures', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'bridge_unavailable');
    });

    await expectLater(
      FloatingBridge.updateConfig(const FloatingConfig()),
      completes,
    );
    await expectLater(
      FloatingBridge.updateData(const FloatingTelemetry()),
      completes,
    );
  });

  test(
    'runtimeState returns diagnostics and fails closed for invalid results',
    () async {
      const state = <String, dynamic>{
        'service_running': true,
        'view_attached_to_window': true,
        'horizontal': false,
        'size': 0.8,
      };
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'getFloatingRuntimeState');
        return state;
      });

      final runtime = await FloatingBridge.runtimeState();
      expect(runtime?.running, isTrue);
      expect(runtime?.serviceRunning, isTrue);
      expect(runtime?.overlay, isTrue);
      expect(runtime?.viewAttachedToWindow, isTrue);
      expect(runtime?.horizontal, isFalse);
      expect(runtime?.size, 0.8);
      expect(runtime?.x, 16);
      expect(runtime?.y, 120);

      messenger.setMockMethodCallHandler(channel, (call) async {
        return const <String, dynamic>{
          'running': true,
          'overlay': true,
          'horizontal': true,
          'size': 0.7,
        };
      });
      final legacyRuntime = await FloatingBridge.runtimeState();
      expect(legacyRuntime?.serviceRunning, isTrue);
      expect(legacyRuntime?.viewAttachedToWindow, isTrue);
      expect(legacyRuntime?.size, 0.7);

      messenger.setMockMethodCallHandler(channel, (call) async => 'not-a-map');
      expect(await FloatingBridge.runtimeState(), isNull);

      messenger.setMockMethodCallHandler(channel, (call) async {
        throw PlatformException(code: 'runtime_state_unavailable');
      });
      expect(await FloatingBridge.runtimeState(), isNull);
    },
  );
}
