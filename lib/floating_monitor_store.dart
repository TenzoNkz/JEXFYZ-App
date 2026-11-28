// AI-MEMORY / FILE CONTRACT
// Owns secure persistence of Floating Monitor configuration only.
// Runtime telemetry, notifiers, native bridge state and BLE/GATT do not belong here.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'floating_monitor_models.dart';

class FloatingStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  // Keep the established key; the WP8 boundary extraction is not a data migration.
  static const String key = 'jexfyz_floating_v1';

  static Future<FloatingConfig> load() async {
    try {
      final raw = await _storage.read(key: key);
      return raw == null
          ? const FloatingConfig()
          : FloatingConfig.fromJson(raw);
    } catch (_) {
      return const FloatingConfig();
    }
  }

  // The store persists the supplied model and never mutates shared UI state.
  static Future<void> save(FloatingConfig config) async {
    try {
      await _storage.write(key: key, value: config.toJson());
    } catch (_) {
      // Preserve the existing best-effort storage contract; callers keep their
      // in-memory state and the native runtime remains a separate confirmation.
    }
  }
}
