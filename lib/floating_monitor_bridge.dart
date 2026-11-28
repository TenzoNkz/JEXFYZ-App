// AI-MEMORY / FILE CONTRACT
// Owns the stable Dart MethodChannel contract to MainActivity and native overlay service.
// Payload keys, method names and the channel are deployed compatibility contracts.
// This bridge only transfers values; it never owns BLE/GATT, session state or persistence.

import 'dart:convert';

import 'package:flutter/services.dart';

import 'floating_monitor_models.dart';

class FloatingBridge {
  static const MethodChannel _channel = MethodChannel('je_x_fyz/floating');

  static Future<bool> hasPermission() async {
    try {
      return await _channel.invokeMethod<bool>('hasOverlayPermission') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> openPermissionSettings() async {
    try {
      return await _channel.invokeMethod<bool>('openOverlaySettings') ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> start(
    FloatingConfig config, {
    FloatingTelemetry? telemetry,
  }) async {
    try {
      final payload = <String, dynamic>{
        ...config.toMap(),
        if (telemetry != null) ...telemetry.toMap(),
      };
      return await _channel.invokeMethod<bool>(
            'startFloatingMonitor',
            jsonEncode(payload),
          ) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stopFloatingMonitor');
    } catch (_) {}
  }

  static Future<void> updateConfig(FloatingConfig config) async {
    try {
      await _channel.invokeMethod<void>(
        'updateFloatingConfig',
        config.toJson(),
      );
    } catch (_) {}
  }

  static Future<void> updateData(FloatingTelemetry telemetry) async {
    try {
      await _channel.invokeMethod<void>(
        'updateFloatingData',
        jsonEncode(telemetry.toMap()),
      );
    } catch (_) {}
  }

  static Future<FloatingRuntimeState?> runtimeState() async {
    try {
      final value = await _channel.invokeMethod<dynamic>(
        'getFloatingRuntimeState',
      );
      if (value is Map) {
        return FloatingRuntimeState.fromMap(Map<String, dynamic>.from(value));
      }
    } catch (_) {}
    return null;
  }
}
