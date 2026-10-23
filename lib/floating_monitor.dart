// AI-MEMORY / FILE CONTRACT
// File: floating_monitor.dart
// Owns: Flutter Floating Monitor configuration UI, overlay permission flow,
//       runtime reconciliation and live telemetry forwarding.
// Native ownership: MainActivity opens Android Settings; FloatingMonitorService owns
// WindowManager and the actual overlay window. This file never owns BLE/GATT.
// Localization: read the shared AppLanguage notifier. English status = ON/OFF;
// Indonesia status = HIDUP/MATI. Language selector labels are English / Indonesia.
// Fan Speed uses floating metric F; Fan OFF is presented as OFF/MATI.
// Selected metric presentation is owned by the native overlay; Settings contains no overlay preview.
// Protocol identifiers are not translated.
// Floating metric contract: F (Fan Speed) is the only fan-related metric; no separate Fan toggle exists.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'app_settings.dart';
import 'jex_animated_glyph.dart';

enum FloatingDisplayStyle { letters, icons }
enum FloatingBackgroundColor { black, white }

// Size is persisted in 0.05x increments for a predictable native overlay scale.
double _normalizeFloatingSize(double value) {
  final safe = value.isFinite ? value.clamp(0.30, 1.00).toDouble() : 0.60;
  return (0.30 + ((safe - 0.30) / 0.05).round() * 0.05)
      .clamp(0.30, 1.00)
      .toDouble();
}

double _normalizeFloatingOpacity(double value) {
  final safe = value.isFinite ? value.clamp(0.0, 1.0).toDouble() : 0.9;
  return ((safe * 20).round() / 20).clamp(0.0, 1.0).toDouble();
}

// AI-MEMORY / CONFIG MODEL
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

  // AI-METHOD / CONFIG-COPY-CONTRACT
  // Clone configuration with only the supplied presentation fields changed.
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
      size: _normalizeFloatingSize(size ?? this.size),
      opacity: _normalizeFloatingOpacity(opacity ?? this.opacity),
      backgroundColor: backgroundColor ?? this.backgroundColor,
      horizontal: horizontal ?? this.horizontal,
    );
  }

  // AI-METHOD / CONFIG-SERIALIZATION-CONTRACT
  // Serialize only native overlay configuration fields; no device state is persisted.
  // AI-METHOD / TELEMETRY-SERIALIZATION-CONTRACT
  // Serialize live telemetry plus the App-selected language for native rendering.
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

  // AI-METHOD / CONFIG-DESERIALIZATION-CONTRACT
  // Normalize legacy/invalid persisted values into the supported Floating Monitor model.
  static FloatingConfig fromJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const FloatingConfig();
      final storedSchema = (decoded['metricSchemaVersion'] as num?)?.toInt() ?? 1;
      final legacyMetrics = storedSchema < FloatingMetric.schemaVersion;
      final rawOrder = decoded['order'];
      final rawSelected = decoded['selected'];
      final order = rawOrder is List
          ? rawOrder
              .map((e) => FloatingMetric.fromStored(e.toString(), legacy: legacyMetrics))
              .whereType<String>()
              .toSet()
              .toList()
          : List<String>.from(FloatingMetric.defaultOrder);
      final selected = rawSelected is List
          ? rawSelected
              .map((e) => FloatingMetric.fromStored(e.toString(), legacy: legacyMetrics))
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
        enabled: decoded['enabled'] is bool ? decoded['enabled'] as bool : false,
        style: FloatingDisplayStyle.letters,
        order: order,
        selected: selected,
        size: _normalizeFloatingSize((decoded['size'] as num?)?.toDouble() ?? 0.6),
        opacity: _normalizeFloatingOpacity((decoded['opacity'] as num?)?.toDouble() ?? 0.9),
        backgroundColor: backgroundColor,
        horizontal: decoded['horizontal'] is bool ? decoded['horizontal'] as bool : true,
      );
    } catch (_) {
      return const FloatingConfig();
    }
  }
}

class FloatingMetric {
  static const int schemaVersion = 2;
  static const List<String> defaultOrder = <String>['B', 'H', 'V', 'A', 'P', 'F'];

  // Legacy schema v1 used F for FPS and S for Fan Speed. Drop old FPS
  // selections and migrate the old Speed identifier to the new F identifier.
  static String? fromStored(String value, {required bool legacy}) {
    if (legacy) {
      if (value == 'F') return null;
      if (value == 'S') return 'F';
    }
    return isValid(value) ? value : null;
  }

  // Accept only the six supported floating metric identifiers.
  static bool isValid(String value) => defaultOrder.contains(value);
}

// AI-MEMORY / TELEMETRY MODEL
// Snapshot of Dashboard telemetry forwarded to the native overlay.
// The language field is intentionally derived at serialization time so native overlay
// presentation follows the App-selected language rather than the phone locale.
class FloatingTelemetry {
  final String battery;
  final String hotside;
  final String voltage;
  final bool fanOn;
  final int speed;
  final bool adaptiveOn;
  final bool peltierOn;
  final bool connected;

  const FloatingTelemetry({
    this.battery = '--',
    this.hotside = '--',
    this.voltage = '--',
    this.fanOn = false,
    this.speed = 100,
    this.adaptiveOn = false,
    this.peltierOn = false,
    this.connected = false,
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
        'language': appLanguageNotifier.value.name,
      };
}

// AI-METHOD / METRIC-VISIBILITY-CONTRACT
// Preserve the stable metric visibility policy for the native HUD and regression tests.
// This pure helper is not a settings-page live preview; the middle preview UI was removed.
bool floatingMetricVisible(String metric, FloatingTelemetry telemetry) {
  return FloatingMetric.isValid(metric);
}

// AI-METHOD / METRIC-STATUS-CONTRACT
// Adaptive and Peltier are independent firmware-backed states; only Speed is gated by Fan.
String floatingMetricStatus(String metric, FloatingTelemetry telemetry, AppLanguage language) {
  // Output flags are authoritative only while the shared BLE session is connected.
  if (!telemetry.connected) return '--';
  return switch (metric) {
    'A' => JexText.of(telemetry.adaptiveOn ? 'on' : 'off', language),
    'P' => JexText.of(telemetry.peltierOn ? 'on' : 'off', language),
    'F' => telemetry.fanOn ? telemetry.speed.toString() : JexText.of('off', language),
    _ => '--',
  };
}

final ValueNotifier<FloatingConfig> floatingConfigNotifier =
    ValueNotifier<FloatingConfig>(const FloatingConfig());
final ValueNotifier<FloatingTelemetry> floatingTelemetryNotifier =
    ValueNotifier<FloatingTelemetry>(const FloatingTelemetry());

// AI-MEMORY / STORE CONTRACT
// Securely persists only Floating Monitor configuration. Runtime telemetry is never stored here.
class FloatingStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _key = 'jexfyz_floating_v1';

  // AI-METHOD / LOAD CONTRACT
  // Load persisted Floating Monitor configuration and publish it to the shared notifier.
  static Future<FloatingConfig> load() async {
    try {
      final raw = await _storage.read(key: _key);
      final value = raw == null ? const FloatingConfig() : FloatingConfig.fromJson(raw);
      floatingConfigNotifier.value = value;
      return value;
    } catch (_) {
      const value = FloatingConfig();
      floatingConfigNotifier.value = value;
      return value;
    }
  }

  // AI-METHOD / SAVE CONTRACT
  // Publish configuration immediately and persist the same normalized model securely.
  static Future<void> save(FloatingConfig config) async {
    floatingConfigNotifier.value = config;
    try {
      await _storage.write(key: _key, value: config.toJson());
    } catch (_) {}
  }
}

// AI-MEMORY / NATIVE BRIDGE CONTRACT
// MethodChannel names and method names are native contracts. Keep them synchronized with
// MainActivity.kt and FloatingMonitorService.kt; do not introduce a second overlay channel.
class FloatingBridge {
  static const MethodChannel _channel = MethodChannel('je_x_fyz/floating');

  // AI-METHOD / PERMISSION CONTRACT
  // Read the public Android SYSTEM_ALERT_WINDOW state through MainActivity.
  static Future<bool> hasPermission() async {
    try {
      return await _channel.invokeMethod<bool>('hasOverlayPermission') ?? false;
    } catch (_) {
      return false;
    }
  }

  // AI-METHOD / SETTINGS CONTRACT
  // Ask MainActivity to open the public overlay-permission fallback ladder.
  static Future<bool> openPermissionSettings() async {
    try {
      return await _channel.invokeMethod<bool>('openOverlaySettings') ?? false;
    } catch (_) {
      return false;
    }
  }

  // AI-METHOD / START CONTRACT
  // Start the native service only after the Android permission gate is satisfied.
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

  // AI-METHOD / STOP CONTRACT
  // Request native overlay/service teardown; this never touches BLE.
  static Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stopFloatingMonitor');
    } catch (_) {}
  }

  // AI-METHOD / CONFIG CONTRACT
  // Forward the latest Flutter overlay configuration to the already-running native service.
  static Future<void> updateConfig(FloatingConfig config) async {
    try {
      await _channel.invokeMethod<void>('updateFloatingConfig', config.toJson());
    } catch (_) {}
  }

  // AI-METHOD / TELEMETRY CONTRACT
  // Forward live telemetry and the selected UI language to the native overlay.
  static Future<void> updateData(FloatingTelemetry telemetry) async {
    try {
      await _channel.invokeMethod<void>('updateFloatingData', jsonEncode(telemetry.toMap()));
    } catch (_) {}
  }

  // AI-METHOD / RUNTIME CONTRACT
  // Read native service/window diagnostics for startup confirmation and runtime reconciliation.
  static Future<Map<String, dynamic>?> runtimeState() async {
    try {
      final value =
          await _channel.invokeMethod<dynamic>('getFloatingRuntimeState');
      if (value is Map) return Map<String, dynamic>.from(value);
    } catch (_) {}
    return null;
  }


}



// AI-MEMORY / SETTINGS-PAGE-CONTRACT
// User configuration screen for Floating Monitor; native overlay execution stays outside Flutter.
class FloatingSettingsPage extends StatefulWidget {
  const FloatingSettingsPage({super.key});

  @override
  State<FloatingSettingsPage> createState() => _FloatingSettingsPageState();
}

// AI-MEMORY / SETTINGS STATE
// This page coordinates user intent with native permission/runtime state.
// It persists enabled=true only after native runtime confirmation.
class _FloatingSettingsPageState extends State<FloatingSettingsPage> with WidgetsBindingObserver {
  late FloatingConfig config;
  bool loading = true;
  bool _waitingForOverlayPermission = false;
  bool _permissionResumeCheckRunning = false;
  Timer? runtimeTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    config = floatingConfigNotifier.value;
    _load();
  }

  @override
  // AI-METHOD / LIFECYCLE CONTRACT
  // Returning from Android Settings starts a bounded permission reconciliation pass.
  // One immediate check is intentionally avoided because OEM Settings/AppOps updates
  // may not be observable at the exact first resumed callback.
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_waitingForOverlayPermission) unawaited(_finishOverlayPermissionFlow());
    }
  }

  // AI-METHOD / PERMISSION-RESUME CONTRACT
  // Retry the public permission state for a short bounded window, then either start the
  // overlay or report denial. Never assume the Settings UI selection itself is proof.
  Future<void> _finishOverlayPermissionFlow() async {
    if (!_waitingForOverlayPermission || _permissionResumeCheckRunning) return;

    _permissionResumeCheckRunning = true;
    try {
      final granted = await _waitForOverlayPermission();
      if (!mounted) return;

      _waitingForOverlayPermission = false;
      if (granted) {
        await _toggleEnabled(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(JexText.of('overlayPermissionDenied', appLanguageNotifier.value)),
          ),
        );
        setState(() {});
      }
    } finally {
      _permissionResumeCheckRunning = false;
    }
  }

  // AI-METHOD / PERMISSION-RETRY CONTRACT
  // Poll only during the permission return flow; this is not a permanent permission heartbeat.
  Future<bool> _waitForOverlayPermission({
    Duration timeout = const Duration(seconds: 2),
    Duration interval = const Duration(milliseconds: 300),
  }) async {
    final deadline = DateTime.now().add(timeout);

    while (true) {
      if (await FloatingBridge.hasPermission()) return true;
      if (!DateTime.now().isBefore(deadline)) return false;
      await Future<void>.delayed(interval);
    }
  }

  // AI-METHOD / INITIAL-LOAD CONTRACT
  // Load config, reconcile native size/orientation, and restore only when permission plus
  // runtime overlay attachment are both confirmed.
  Future<void> _load() async {
    config = await _normalizeSelection(await FloatingStore.load());
    if (config.enabled) {
      final nativeState = await FloatingBridge.runtimeState();
      if (nativeState != null) {
        final nativeHorizontal = nativeState['horizontal'];
        final nativeSize = nativeState['size'];
        var next = config;
        if (nativeHorizontal is bool) {
          next = next.copyWith(horizontal: nativeHorizontal);
        }
        if (nativeSize is num) {
          next = next.copyWith(
            size: nativeSize.toDouble().clamp(0.3, 1.0).toDouble(),
          );
        }
        if (next.horizontal != config.horizontal || next.size != config.size) {
          config = next;
          await FloatingStore.save(config);
        }
      }
    }
    if (!mounted) return;
    setState(() => loading = false);
    if (config.enabled) {
      // Keep enabled intent through BLE disconnect and overlay permission revocation.
      // Dashboard restores the overlay only after its full BLE/P1 sync gate opens.
      if (!floatingTelemetryNotifier.value.connected) return;
      if (!await FloatingBridge.hasPermission()) return;
      final started = await FloatingBridge.start(config, telemetry: floatingTelemetryNotifier.value);
      final running = started && await _waitForRuntimeReady();
      if (!running) {
        await FloatingBridge.stop();
        if (!floatingTelemetryNotifier.value.connected || !await FloatingBridge.hasPermission()) return;
        config = config.copyWith(enabled: false);
        await FloatingStore.save(config);
      } else {
        await FloatingBridge.updateConfig(config);
        await FloatingBridge.updateData(floatingTelemetryNotifier.value);
        _startRuntimeSync();
      }
    }
  }

  // AI-METHOD / CONFIG-APPLY CONTRACT
  // Persist a UI configuration change and forward it only when Floating Monitor is enabled.
  Future<void> _apply(FloatingConfig next) async {
    config = next;
    await FloatingStore.save(config);
    if (config.enabled) await FloatingBridge.updateConfig(config);
    if (config.enabled && runtimeTimer == null) _startRuntimeSync();
    if (mounted) setState(() {});
  }

  // AI-METHOD / STARTUP-VERIFY CONTRACT
  // Wait for the native service plus actual attached overlay state; hudView existence alone
  // is intentionally insufficient.
  Future<bool> _waitForRuntimeReady({Duration timeout = const Duration(seconds: 3)}) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      final state = await FloatingBridge.runtimeState();
      if (state?['running'] == true && state?['overlay'] == true) return true;
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
    return false;
  }

  // AI-METHOD / NORMALIZATION CONTRACT
  // Restore all six supported metrics if an old/empty selection would leave the overlay blank.
  Future<FloatingConfig> _normalizeSelection(FloatingConfig value) async {
    if (value.selected.isNotEmpty) return value;
    final normalized = value.copyWith(
      selected: FloatingMetric.defaultOrder.toSet(),
    );
    await FloatingStore.save(normalized);
    return normalized;
  }

  // AI-METHOD / ENABLE-CONTRACT
  // User-facing master toggle. Start and verify the native overlay before persisting enabled=true.
  Future<void> _toggleEnabled(bool value) async {
    if (!value) {
      config = config.copyWith(enabled: false);
      runtimeTimer?.cancel();
      runtimeTimer = null;
      await FloatingStore.save(config);
      await FloatingBridge.stop();
      if (mounted) setState(() {});
      return;
    }

    if (!floatingTelemetryNotifier.value.connected) {
      config = config.copyWith(enabled: true);
      await FloatingStore.save(config);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(JexText.of('floatingPendingConnection', appLanguageNotifier.value))),
        );
        setState(() {});
      }
      return;
    }

    if (!await FloatingBridge.hasPermission()) {
      final proceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return JexFixedScalePage(
            child: AlertDialog(
            title: Text(JexText.of('floatingPermissionTitle', appLanguageNotifier.value)),
            content: Text(JexText.of('floatingPermissionMessage', appLanguageNotifier.value)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(JexText.of('cancel', appLanguageNotifier.value)),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(JexText.of('allow', appLanguageNotifier.value)),
              ),
            ],
          ),
          );
        },
      );

      if (proceed != true || !mounted) return;

      _waitingForOverlayPermission = true;
      final opened = await FloatingBridge.openPermissionSettings();
      if (!opened && mounted) {
        _waitingForOverlayPermission = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(JexText.of('overlaySettingsFailed', appLanguageNotifier.value)),
          ),
        );
      }
      return;
    }

    config = await _normalizeSelection(config);
    final next = config.copyWith(enabled: true);
    final started = await FloatingBridge.start(next, telemetry: floatingTelemetryNotifier.value);
    final running = started && await _waitForRuntimeReady();
    if (!running) {
      await FloatingBridge.stop();
      config = config.copyWith(enabled: false);
      await FloatingStore.save(config);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(JexText.of('floatingStartFailed', appLanguageNotifier.value))),
        );
        setState(() {});
      }
      return;
    }
    await FloatingStore.save(next);
    // A snapshot may have been published before the service was attached and therefore
    // dropped by the native bridge. Always seed newly-started overlay with live state.
    await FloatingBridge.updateData(floatingTelemetryNotifier.value);
    _startRuntimeSync();
    if (mounted) setState(() => config = next);
  }

  // AI-METHOD / RUNTIME-SYNC-CONTRACT
  // Low-frequency reconciliation for overlay attachment and native size/orientation changes.
  void _startRuntimeSync() {
    runtimeTimer?.cancel();
    runtimeTimer = Timer.periodic(
      const Duration(milliseconds: 300),
      (_) => unawaited(_syncRuntimeState()),
    );
  }

  // AI-METHOD / RUNTIME-HEALTH-CONTRACT
  // Detect service/window loss and clear stale enabled state instead of silently showing
  // a broken Floating Monitor toggle.
  Future<void> _syncRuntimeState() async {
    if (!mounted || !config.enabled || !floatingTelemetryNotifier.value.connected) return;
    if (!await FloatingBridge.hasPermission()) return;
    final state = await FloatingBridge.runtimeState();
    if (!mounted || state == null || !floatingTelemetryNotifier.value.connected) return;

    final serviceRunning = state['service_running'] ?? state['running'];
    final overlayAttached = state['view_attached_to_window'] ?? state['overlay'];
    if (serviceRunning != true || overlayAttached != true) {
      runtimeTimer?.cancel();
      runtimeTimer = null;
      config = config.copyWith(enabled: false);
      await FloatingStore.save(config);
      if (mounted) setState(() {});
      return;
    }

    final horizontal = state['horizontal'];
    final size = state['size'];
    var next = config;
    if (horizontal is bool && horizontal != config.horizontal) {
      next = next.copyWith(horizontal: horizontal);
    }
    if (size is num && (size.toDouble() - config.size).abs() > 0.005) {
      next = next.copyWith(size: size.toDouble().clamp(0.3, 1.0).toDouble());
    }
    if (next.horizontal != config.horizontal || next.size != config.size) {
      config = next;
      await FloatingStore.save(next);
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    runtimeTimer?.cancel();
    super.dispose();
  }

  // AI-METHOD / METRIC-CONTRACT
  // Add/remove one supported floating metric; Fan Speed uses identifier F.
  Future<void> _toggleMetric(String metric, bool value) async {
    final next = Set<String>.from(config.selected);
    if (value) {
      next.add(metric);
    } else {
      next.remove(metric);
    }
    await _apply(config.copyWith(selected: next));
  }

  // AI-METHOD / ORDER-CONTRACT
  // Reorder the six supported floating metrics without changing their identifiers.
  void _reorder(int oldIndex, int newIndex) {
    final order = List<String>.from(config.order);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = order.removeAt(oldIndex);
    order.insert(newIndex, item);
    _apply(config.copyWith(order: order));
  }

  @override
  Widget build(BuildContext context) {
    final lang = appLanguageNotifier.value;
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text(JexText.of('floatingMonitor', lang))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(JexText.of('floatingMonitor', lang))),
      body: ValueListenableBuilder<FloatingTelemetry>(
        valueListenable: floatingTelemetryNotifier,
        builder: (context, telemetry, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(JexText.of('floatingMonitor', lang)),
                value: config.enabled,
                onChanged: _toggleEnabled,
              ),
              const SizedBox(height: 8),
              IgnorePointer(
                ignoring: !config.enabled,
                child: Opacity(
                  opacity: config.enabled ? 1 : 0.42,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        JexText.of('functions', lang),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: config.order.length,
                        onReorder: _reorder,
                        itemBuilder: (context, index) {
                          final metric = config.order[index];
                          // All six metrics remain selectable; Fan Speed uses F.
                          final checked = config.selected.contains(metric);
                          return KeyedSubtree(
                            key: ValueKey<String>('floating-$metric'),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: JexAnimatedGlyph(
                                icon: PhosphorIconsRegular.dotsSixVertical,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              title: Text(_metricLabel(metric, lang), style: const TextStyle(fontWeight: FontWeight.w800)),
                              trailing: Checkbox(
                                value: checked,
                                onChanged: (value) => _toggleMetric(metric, value == true),
                              ),
                              dense: true,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _sliderRow(
                        label: JexText.of('size', lang),
                        value: config.size,
                        valueLabel: '${config.size.toStringAsFixed(2)}×',
                        min: 0.30,
                        max: 1.00,
                        divisions: 14,
                        minLabel: '0.30×',
                        maxLabel: '1.00×',
                        onChanged: (value) => _apply(config.copyWith(size: value)),
                      ),
                      _sliderRow(
                        label: JexText.of('opacity', lang),
                        value: config.opacity,
                        valueLabel: '${(config.opacity * 100).round()}%',
                        min: 0.0,
                        max: 1.0,
                        divisions: 20,
                        minLabel: '0%',
                        maxLabel: '100%',
                        onChanged: (value) => _apply(config.copyWith(opacity: value)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        JexText.of('backgroundColor', lang),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 7),
                      SegmentedButton<FloatingBackgroundColor>(
                        segments: [
                          ButtonSegment<FloatingBackgroundColor>(
                            value: FloatingBackgroundColor.black,
                            label: Text(JexText.of('black', lang)),
                            icon: const Icon(Icons.dark_mode_outlined),
                          ),
                          ButtonSegment<FloatingBackgroundColor>(
                            value: FloatingBackgroundColor.white,
                            label: Text(JexText.of('white', lang)),
                            icon: const Icon(Icons.light_mode_outlined),
                          ),
                        ],
                        selected: <FloatingBackgroundColor>{config.backgroundColor},
                        onSelectionChanged: (value) {
                          if (value.isNotEmpty) {
                            _apply(config.copyWith(backgroundColor: value.first));
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        JexText.of('orientation', lang),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 7),
                      SegmentedButton<bool>(
                        segments: [
                          ButtonSegment<bool>(
                            value: true,
                            label: Text(JexText.of('horizontal', lang)),
                          ),
                          ButtonSegment<bool>(
                            value: false,
                            label: Text(JexText.of('vertical', lang)),
                          ),
                        ],
                        selected: <bool>{config.horizontal},
                        onSelectionChanged: (value) {
                          if (value.isNotEmpty) {
                            _apply(config.copyWith(horizontal: value.first));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // AI-METHOD / METRIC-LABEL-CONTRACT
  // Resolve user-facing metric names from the shared JexText localization table.
  String _metricLabel(String metric, AppLanguage lang) {
    switch (metric) {
      case 'F':
        return JexText.of('speed', lang);
      case 'B':
        return JexText.of('battery', lang);
      case 'H':
        return JexText.of('hotside', lang);
      case 'V':
        return JexText.of('volt', lang);
      case 'A':
        return JexText.of('adaptive', lang);
      case 'P':
        return JexText.of('peltier', lang);
      default:
        return metric;
    }
  }

  // AI-METHOD / SLIDER-CONTRACT
  // Display the active numeric value and stable scale marks above/below each presentation slider.
  Widget _sliderRow({
    required String label,
    required double value,
    required String valueLabel,
    required double min,
    required double max,
    required String minLabel,
    String? midLabel,
    required String maxLabel,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    final scaleLabels = <Widget>[
      Text(minLabel, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      if (midLabel != null)
        Text(midLabel, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      Text(maxLabel, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text(
                    valueLabel,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
          Slider(
            min: min,
            max: max,
            divisions: divisions,
            value: value.clamp(min, max).toDouble(),
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: scaleLabels,
          ),
        ],
      ),
    );
  }
}

// AI-MEMORY / FIXED-DPI-CANVAS-CONTRACT
// Matches Home's 360-dp design canvas and disables system font scaling for standalone routes/modal content.
class JexFixedScalePage extends StatelessWidget {
  final Widget child;
  const JexFixedScalePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.noScaling),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const designWidth = 360.0;
          if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) return child;
          final scale = constraints.maxWidth / designWidth;
          final designHeight = constraints.maxHeight / scale;
          final scaledMedia = media.copyWith(
            textScaler: TextScaler.noScaling,
            size: Size(designWidth, designHeight),
            padding: EdgeInsets.fromLTRB(media.padding.left / scale, media.padding.top / scale,
                media.padding.right / scale, media.padding.bottom / scale),
            viewPadding: EdgeInsets.fromLTRB(media.viewPadding.left / scale, media.viewPadding.top / scale,
                media.viewPadding.right / scale, media.viewPadding.bottom / scale),
            viewInsets: EdgeInsets.fromLTRB(media.viewInsets.left / scale, media.viewInsets.top / scale,
                media.viewInsets.right / scale, media.viewInsets.bottom / scale),
          );
          return ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: MediaQuery(
                  data: scaledMedia,
                  child: SizedBox(width: designWidth, height: designHeight, child: child),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// AI-MEMORY / SETTINGS-CONTAINER-CONTRACT
// Hosts the Settings navigation hierarchy and delegates persisted preferences to AppSettingsStore.
class SettingsPage extends StatelessWidget {
  final String currentFirmwareVersion;
  final Future<void> Function() onOpenFirmwareUpdate;

  const SettingsPage({
    super.key,
    required this.currentFirmwareVersion,
    required this.onOpenFirmwareUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) {
        final preset = appThemeNotifier.value;
        return Theme(
          data: buildJexTheme(preset),
          child: Scaffold(
          appBar: AppBar(title: Text(JexText.of('settings', language))),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
            children: [
              _section(context, JexText.of('general', language), [
                _item(context, PhosphorIconsRegular.translate, JexText.of('language', language),
                    language == AppLanguage.english
                        ? JexText.of('languageEnglish', language)
                        : JexText.of('languageIndonesia', language),
                    () => Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => const JexFixedScalePage(child: LanguageSettingsPage()),
                        ))),
                _item(
                  context,
                  PhosphorIconsRegular.sun,
                  JexText.of('appearance', language),
                  JexText.of(
                    switch (appThemeNotifier.value) {
                      AppThemePreset.defaultTheme => 'default',
                      AppThemePreset.light => 'light',
                      AppThemePreset.dark => 'dark',
                    },
                    language,
                  ),
                  () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const JexFixedScalePage(child: AppearanceSettingsPage()),
                    ),
                  ),
                ),
                _item(
                  context,
                  PhosphorIconsRegular.bell,
                  JexText.of('notifications', language),
                  '3',
                  () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const JexFixedScalePage(child: NotificationsSettingsPage()),
                    ),
                  ),
                ),
              ]),
              _section(context, JexText.of('device', language), [
                _item(
                  context,
                  PhosphorIconsRegular.bluetooth,
                  JexText.of('bluetooth', language),
                  appAutoConnectNotifier.value
                      ? JexText.of('auto', language)
                      : JexText.of('manual', language),
                  () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const JexFixedScalePage(child: BluetoothSettingsPage()),
                    ),
                  ),
                ),
                _item(
                  context,
                  PhosphorIconsRegular.stack,
                  JexText.of('floatingMonitor', language),
                  floatingConfigNotifier.value.enabled
                      ? JexText.of('on', language)
                      : JexText.of('off', language),
                  () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const JexFixedScalePage(child: FloatingSettingsPage()),
                    ),
                  ),
                ),
              ]),
              _section(context, JexText.of('firmwareSection', language), [
                _item(context, PhosphorIconsRegular.uploadSimple, JexText.of('firmwareUpdate', language),
                    currentFirmwareVersion, () => unawaited(onOpenFirmwareUpdate())),
              ]),

            ],
          ),
          ),
        );
      },
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 7),
          child: Text(title.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) const Divider(height: 1, indent: 52),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _item(BuildContext context, IconData icon, String title, String summary, VoidCallback onTap) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Row(
            children: [
              JexAnimatedGlyph(
                icon: icon,
                size: 21,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (summary.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        summary,
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              JexAnimatedGlyph(
                icon: PhosphorIconsRegular.caretRight,
                size: 18,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AI-MEMORY / LANGUAGE-PAGE-CONTRACT
// Changes only the AppLanguage preference; display strings must remain centralized in JexText.
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  Future<void> _select(BuildContext context, AppLanguage value) async {
    final current = AppSettings(
      language: appLanguageNotifier.value,
      theme: appThemeNotifier.value,
      notifySafety: appNotifySafetyNotifier.value,
      notifyFirmware: appNotifyFirmwareNotifier.value,
      notifyBluetooth: appNotifyBluetoothNotifier.value,
      autoConnect: appAutoConnectNotifier.value,
    );
    await AppSettingsStore.save(current.copyWith(language: value));
    try {
      await const MethodChannel('je_x_fyz/notifications').invokeMethod<bool>(
        'updateNotificationChannelLanguage',
        <String, dynamic>{'language': value.name},
      );
    } catch (_) {}
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) => Scaffold(
        appBar: AppBar(title: Text(JexText.of('language', language))),
        body: Column(
          children: [
            RadioListTile<AppLanguage>(
              title: Text(JexText.of('languageEnglish', language)),
              value: AppLanguage.english,
              groupValue: language,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
            RadioListTile<AppLanguage>(
              title: Text(JexText.of('languageIndonesia', language)),
              value: AppLanguage.indonesia,
              groupValue: language,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// AI-MEMORY / APPEARANCE-PAGE-CONTRACT
// Changes only the visual theme preset; Dashboard-specific theme handling remains in main.dart.
class AppearanceSettingsPage extends StatelessWidget {
  const AppearanceSettingsPage({super.key});

  Future<void> _select(BuildContext context, AppThemePreset value) async {
    final current = AppSettings(
      language: appLanguageNotifier.value,
      theme: appThemeNotifier.value,
      notifySafety: appNotifySafetyNotifier.value,
      notifyFirmware: appNotifyFirmwareNotifier.value,
      notifyBluetooth: appNotifyBluetoothNotifier.value,
      autoConnect: appAutoConnectNotifier.value,
    );
    await AppSettingsStore.save(current.copyWith(theme: value));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2<AppThemePreset, AppLanguage>(
      first: appThemeNotifier,
      second: appLanguageNotifier,
      builder: (context, theme, language) => Scaffold(
        appBar: AppBar(title: Text(JexText.of('appearance', language))),
        body: Column(
          children: [
            RadioListTile<AppThemePreset>(
              title: Text(JexText.of('default', language)),
              value: AppThemePreset.defaultTheme,
              groupValue: theme,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
            RadioListTile<AppThemePreset>(
              title: Text(JexText.of('light', language)),
              value: AppThemePreset.light,
              groupValue: theme,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
            RadioListTile<AppThemePreset>(
              title: Text(JexText.of('dark', language)),
              value: AppThemePreset.dark,
              groupValue: theme,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// AI-MEMORY / NOTIFICATION-PAGE-CONTRACT
// Persists notification preferences; Android runtime notification permission remains native.
class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  Future<void> _set(String key, bool value) async {
    if (value) {
      try {
        final granted = await const MethodChannel('je_x_fyz/notifications')
                .invokeMethod<bool>(
                  'requestNotificationPermission',
                  <String, dynamic>{'language': appLanguageNotifier.value.name},
                ) ??
            false;
        if (!granted) return;
      } catch (_) {
        return;
      }
    }
    final current = AppSettings(
      language: appLanguageNotifier.value,
      theme: appThemeNotifier.value,
      notifySafety: appNotifySafetyNotifier.value,
      notifyFirmware: appNotifyFirmwareNotifier.value,
      notifyBluetooth: appNotifyBluetoothNotifier.value,
      autoConnect: appAutoConnectNotifier.value,
    );
    final next = switch (key) {
      'safety' => current.copyWith(notifySafety: value),
      'firmware' => current.copyWith(notifyFirmware: value),
      'bluetooth' => current.copyWith(notifyBluetooth: value),
      _ => current,
    };
    await AppSettingsStore.save(next);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) => ValueListenableBuilder<bool>(
        valueListenable: appNotifySafetyNotifier,
        builder: (context, _, __) => ValueListenableBuilder<bool>(
          valueListenable: appNotifyFirmwareNotifier,
          builder: (context, _, __) => ValueListenableBuilder<bool>(
            valueListenable: appNotifyBluetoothNotifier,
            builder: (context, _, __) => Scaffold(
              appBar: AppBar(title: Text(JexText.of('notifications', language))),
              body: ListView(
                children: [
                  SwitchListTile(
                    title: Text(JexText.of('safetyAlert', language)),
                    subtitle: Text(JexText.of('notificationSafetyDescription', language)),
                    value: appNotifySafetyNotifier.value,
                    onChanged: (value) => _set('safety', value),
                  ),
                  SwitchListTile(
                    title: Text(JexText.of('firmwareUpdate', language)),
                    subtitle: Text(JexText.of('notificationFirmwareDescription', language)),
                    value: appNotifyFirmwareNotifier.value,
                    onChanged: (value) => _set('firmware', value),
                  ),
                  SwitchListTile(
                    title: Text(JexText.of('deviceConnectionNotifications', language)),
                    subtitle: Text(JexText.of('notificationBluetoothDescription', language)),
                    value: appNotifyBluetoothNotifier.value,
                    onChanged: (value) => _set('bluetooth', value),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// AI-MEMORY / BLUETOOTH-PAGE-CONTRACT
// Presents Bluetooth-related preferences; BLE/GATT ownership stays in main.dart/flutter_blue_plus.
class BluetoothSettingsPage extends StatelessWidget {
  const BluetoothSettingsPage({super.key});

  Future<void> _setAutoConnect(bool value) async {
    final current = AppSettings(
      language: appLanguageNotifier.value,
      theme: appThemeNotifier.value,
      notifySafety: appNotifySafetyNotifier.value,
      notifyFirmware: appNotifyFirmwareNotifier.value,
      notifyBluetooth: appNotifyBluetoothNotifier.value,
      autoConnect: appAutoConnectNotifier.value,
    );
    await AppSettingsStore.save(current.copyWith(autoConnect: value));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2<bool, AppLanguage>(
      first: appAutoConnectNotifier,
      second: appLanguageNotifier,
      builder: (context, autoConnect, language) => Scaffold(
        appBar: AppBar(title: Text(JexText.of('bluetooth', language))),
        body: ListView(
          children: [
            SwitchListTile(
              title: Text(JexText.of('autoConnect', language)),
              subtitle: Text(JexText.of('autoConnectDescription', language)),
              value: autoConnect,
              onChanged: _setAutoConnect,
            ),
          ],
        ),
      ),
    );
  }
}

// AI-MEMORY / NOTIFIER-BRIDGE-CONTRACT
// Generic two-notifier builder used by settings UI; it does not own persistence or device state.
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget Function(BuildContext context, A first, B second) builder;

  const ValueListenableBuilder2({
    super.key,
    required this.first,
    required this.second,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<A>(
      valueListenable: first,
      builder: (context, firstValue, _) => ValueListenableBuilder<B>(
        valueListenable: second,
        builder: (context, secondValue, __) => builder(context, firstValue, secondValue),
      ),
    );
  }
}
