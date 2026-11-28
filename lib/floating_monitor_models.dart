// AI-MEMORY / FILE CONTRACT
// Owns immutable Floating Monitor configuration, telemetry and native runtime value models.
// Contains no Flutter channel, secure storage, global notifier or BLE/GATT state owner.

import 'dart:convert';

double normalizeFloatingSize(double value) {
  final safe = value.isFinite ? value.clamp(0.30, 1.00).toDouble() : 0.60;
  return (0.30 + ((safe - 0.30) / 0.05).round() * 0.05)
      .clamp(0.30, 1.00)
      .toDouble();
}

double normalizeFloatingOpacity(double value) {
  final safe = value.isFinite ? value.clamp(0.0, 1.0).toDouble() : 0.9;
  return ((safe * 20).round() / 20).clamp(0.0, 1.0).toDouble();
}

enum FloatingDisplayStyle { letters, icons }

enum FloatingBackgroundColor { black, white }

// Persisted overlay presentation/settings only. Device state never belongs in this model.
class FloatingConfig {
  final bool enabled;
  final FloatingDisplayStyle style;
  final List<String> order;
  final Set<String> selected;
  final double size;
  final double opacity;
  final FloatingBackgroundColor backgroundColor;
  final bool horizontal;

  const FloatingConfig({
    this.enabled = false,
    this.style = FloatingDisplayStyle.letters,
    this.order = const <String>['B', 'H', 'V', 'A', 'P', 'F'],
    this.selected = const <String>{'B', 'H', 'V', 'A', 'P', 'F'},
    this.size = 0.6,
    this.opacity = 0.9,
    this.backgroundColor = FloatingBackgroundColor.black,
    this.horizontal = true,
  });

  // Keep the existing UI contract: legacy saved icon-style requests normalize to letters.
  FloatingConfig copyWith({
    bool? enabled,
    List<String>? order,
    Set<String>? selected,
    double? size,
    double? opacity,
    FloatingBackgroundColor? backgroundColor,
    bool? horizontal,
  }) {
    return FloatingConfig(
      enabled: enabled ?? this.enabled,
      style: FloatingDisplayStyle.letters,
      order: order ?? List<String>.from(this.order),
      selected: selected ?? Set<String>.from(this.selected),
      size: normalizeFloatingSize(size ?? this.size),
      opacity: normalizeFloatingOpacity(opacity ?? this.opacity),
      backgroundColor: backgroundColor ?? this.backgroundColor,
      horizontal: horizontal ?? this.horizontal,
    );
  }

  // Serialize only native overlay configuration fields; no device state is persisted.
  Map<String, dynamic> toMap() => <String, dynamic>{
    'enabled': enabled,
    'style': style.name,
    'metricSchemaVersion': FloatingMetric.schemaVersion,
    'order': order,
    'selected': selected.toList(),
    'size': size,
    'opacity': opacity,
    'backgroundColor': backgroundColor.name,
    'horizontal': horizontal,
  };

  String toJson() => jsonEncode(toMap());

  // Normalize legacy/invalid persisted values while retaining the schema-v1 migration.
  static FloatingConfig fromJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const FloatingConfig();
      final storedSchema =
          (decoded['metricSchemaVersion'] as num?)?.toInt() ?? 1;
      final legacyMetrics = storedSchema < FloatingMetric.schemaVersion;
      final rawOrder = decoded['order'];
      final rawSelected = decoded['selected'];
      final order = rawOrder is List
          ? rawOrder
                .map(
                  (entry) => FloatingMetric.fromStored(
                    entry.toString(),
                    legacy: legacyMetrics,
                  ),
                )
                .whereType<String>()
                .toSet()
                .toList()
          : List<String>.from(FloatingMetric.defaultOrder);
      final selected = rawSelected is List
          ? rawSelected
                .map(
                  (entry) => FloatingMetric.fromStored(
                    entry.toString(),
                    legacy: legacyMetrics,
                  ),
                )
                .whereType<String>()
                .toSet()
          : FloatingMetric.defaultOrder.toSet();
      for (final metric in FloatingMetric.defaultOrder) {
        if (!order.contains(metric)) order.add(metric);
      }
      final backgroundColor = decoded['backgroundColor']?.toString() == 'white'
          ? FloatingBackgroundColor.white
          : FloatingBackgroundColor.black;
      return FloatingConfig(
        enabled: decoded['enabled'] is bool
            ? decoded['enabled'] as bool
            : false,
        style: FloatingDisplayStyle.letters,
        order: order,
        selected: selected,
        size: normalizeFloatingSize(
          (decoded['size'] as num?)?.toDouble() ?? 0.6,
        ),
        opacity: normalizeFloatingOpacity(
          (decoded['opacity'] as num?)?.toDouble() ?? 0.9,
        ),
        backgroundColor: backgroundColor,
        horizontal: decoded['horizontal'] is bool
            ? decoded['horizontal'] as bool
            : true,
      );
    } catch (_) {
      return const FloatingConfig();
    }
  }
}

class FloatingMetric {
  static const int schemaVersion = 2;
  static const List<String> defaultOrder = <String>[
    'B',
    'H',
    'V',
    'A',
    'P',
    'F',
  ];

  // Legacy schema v1 used F for FPS and S for Fan Speed.
  // Old FPS selections are discarded and the old Speed identifier maps to F.
  static String? fromStored(String value, {required bool legacy}) {
    if (legacy) {
      if (value == 'F') return null;
      if (value == 'S') return 'F';
    }
    return isValid(value) ? value : null;
  }

  static bool isValid(String value) => defaultOrder.contains(value);
}

// Immutable projection from Dashboard-owned authoritative telemetry.
// Language is captured by the caller so this model has no global AppSettings dependency.
class FloatingTelemetry {
  final String battery;
  final String hotside;
  final String voltage;
  final bool fanOn;
  final int speed;
  final bool adaptiveOn;
  final bool peltierOn;
  final bool connected;
  final String language;

  const FloatingTelemetry({
    this.battery = '--',
    this.hotside = '--',
    this.voltage = '--',
    this.fanOn = false,
    this.speed = 100,
    this.adaptiveOn = false,
    this.peltierOn = false,
    this.connected = false,
    this.language = 'english',
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'battery': battery,
    'hotside': hotside,
    'voltage': voltage,
    'fanOn': fanOn,
    'speed': speed,
    'adaptiveOn': adaptiveOn,
    'peltierOn': peltierOn,
    'connected': connected,
    'language': language,
  };
}

bool floatingMetricVisible(String metric, FloatingTelemetry telemetry) =>
    FloatingMetric.isValid(metric);

// Typed projection of the native diagnostic map. Both current and historical key names
// are accepted at the boundary so callers do not need to know the native JSON shape.
class FloatingRuntimeState {
  final bool running;
  final bool serviceRunning;
  final bool overlay;
  final bool viewAttachedToWindow;
  final bool publicOverlayGranted;
  final bool windowAddAttempted;
  final bool windowAddSucceeded;
  final String? windowAddError;
  final bool horizontal;
  final double size;
  final int x;
  final int y;

  const FloatingRuntimeState({
    required this.running,
    required this.serviceRunning,
    required this.overlay,
    required this.viewAttachedToWindow,
    required this.publicOverlayGranted,
    required this.windowAddAttempted,
    required this.windowAddSucceeded,
    required this.windowAddError,
    required this.horizontal,
    required this.size,
    required this.x,
    required this.y,
  });

  factory FloatingRuntimeState.fromMap(Map<String, dynamic> map) {
    bool readBool(Object? value, {bool fallback = false}) =>
        value is bool ? value : fallback;
    int readInt(Object? value, {required int fallback}) =>
        value is num ? value.toInt() : fallback;
    double readDouble(Object? value, {required double fallback}) =>
        value is num ? value.toDouble() : fallback;

    final serviceRunning = readBool(
      map['service_running'],
      fallback: readBool(map['running']),
    );
    final attached = readBool(
      map['view_attached_to_window'],
      fallback: readBool(map['overlay']),
    );
    return FloatingRuntimeState(
      running: readBool(map['running'], fallback: serviceRunning),
      serviceRunning: serviceRunning,
      overlay: readBool(map['overlay'], fallback: attached),
      viewAttachedToWindow: attached,
      publicOverlayGranted: readBool(map['public_overlay_granted']),
      windowAddAttempted: readBool(map['window_add_attempted']),
      windowAddSucceeded: readBool(map['window_add_succeeded']),
      windowAddError: map['window_add_error']?.toString(),
      horizontal: readBool(map['horizontal'], fallback: true),
      size: readDouble(map['size'], fallback: 0.6),
      x: readInt(map['x'], fallback: 16),
      y: readInt(map['y'], fallback: 120),
    );
  }
}
