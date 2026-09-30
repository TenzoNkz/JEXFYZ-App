import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'app_settings.dart';

enum FloatingDisplayStyle { letters, icons }

class FloatingConfig {
  final bool enabled;
  final FloatingDisplayStyle style;
  final List<String> order;
  final Set<String> selected;
  final double size;
  final double opacity;
  final bool horizontal;

  const FloatingConfig({
    this.enabled = false,
    this.style = FloatingDisplayStyle.letters,
    this.order = const <String>['F', 'B', 'H', 'V', 'A', 'P', 'S'],
    this.selected = const <String>{'F', 'B', 'H', 'V', 'A', 'P', 'S'},
    this.size = 1.0,
    this.opacity = 0.9,
    this.horizontal = true,
  });

  FloatingConfig copyWith({
    bool? enabled,
    FloatingDisplayStyle? style,
    List<String>? order,
    Set<String>? selected,
    double? size,
    double? opacity,
    bool? horizontal,
  }) {
    return FloatingConfig(
      enabled: enabled ?? this.enabled,
      style: style ?? this.style,
      order: order ?? List<String>.from(this.order),
      selected: selected ?? Set<String>.from(this.selected),
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
      horizontal: horizontal ?? this.horizontal,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'enabled': enabled,
        'style': style.name,
        'order': order,
        'selected': selected.toList(),
        'size': size,
        'opacity': opacity,
        'horizontal': horizontal,
      };

  String toJson() => jsonEncode(toMap());

  static FloatingConfig fromJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return const FloatingConfig();
      var style = FloatingDisplayStyle.letters;
      try {
        style = FloatingDisplayStyle.values.byName(decoded['style']?.toString() ?? '');
      } catch (_) {}
      final rawOrder = decoded['order'];
      final rawSelected = decoded['selected'];
      final order = rawOrder is List
          ? rawOrder.map((e) => e.toString()).where(FloatingMetric.isValid).toList()
          : <String>['F', 'B', 'H', 'V', 'A', 'P', 'S'];
      final selected = rawSelected is List
          ? rawSelected.map((e) => e.toString()).where(FloatingMetric.isValid).toSet()
          : <String>{'F', 'B', 'H', 'V', 'A', 'P', 'S'};
      if (order.length != 7) {
        for (final metric in FloatingMetric.defaultOrder) {
          if (!order.contains(metric)) order.add(metric);
        }
      }
      return FloatingConfig(
        enabled: decoded['enabled'] is bool ? decoded['enabled'] as bool : false,
        style: style,
        order: order,
        selected: selected,
        size: ((decoded['size'] as num?)?.toDouble() ?? 1.0).clamp(0.65, 1.8).toDouble(),
        opacity: ((decoded['opacity'] as num?)?.toDouble() ?? 0.9).clamp(0.35, 1.0).toDouble(),
        horizontal: decoded['horizontal'] is bool ? decoded['horizontal'] as bool : true,
      );
    } catch (_) {
      return const FloatingConfig();
    }
  }
}

class FloatingMetric {
  static const List<String> defaultOrder = <String>['F', 'B', 'H', 'V', 'A', 'P', 'S'];
  static bool isValid(String value) => defaultOrder.contains(value);
}

class FloatingTelemetry {
  final String fps;
  final String battery;
  final String hotside;
  final String voltage;
  final bool fanOn;
  final int speed;
  final bool adaptiveOn;
  final bool peltierOn;
  final bool connected;

  const FloatingTelemetry({
    this.fps = '--',
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
        'fps': fps,
        'battery': battery,
        'hotside': hotside,
        'voltage': voltage,
        'fanOn': fanOn,
        'speed': speed,
        'adaptiveOn': adaptiveOn,
        'peltierOn': peltierOn,
        'connected': connected,
      };
}

final ValueNotifier<FloatingConfig> floatingConfigNotifier =
    ValueNotifier<FloatingConfig>(const FloatingConfig());
final ValueNotifier<FloatingTelemetry> floatingTelemetryNotifier =
    ValueNotifier<FloatingTelemetry>(const FloatingTelemetry());

class FloatingStore {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _key = 'jexfyz_floating_v1';

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

  static Future<void> save(FloatingConfig config) async {
    floatingConfigNotifier.value = config;
    try {
      await _storage.write(key: _key, value: config.toJson());
    } catch (_) {}
  }
}

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

  static Future<bool> start(FloatingConfig config) async {
    try {
      return await _channel.invokeMethod<bool>('startFloatingMonitor', config.toJson()) ?? false;
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
      await _channel.invokeMethod<void>('updateFloatingConfig', config.toJson());
    } catch (_) {}
  }

  static Future<void> updateData(FloatingTelemetry telemetry) async {
    try {
      await _channel.invokeMethod<void>('updateFloatingData', jsonEncode(telemetry.toMap()));
    } catch (_) {}
  }

  static Future<Map<String, dynamic>?> runtimeState() async {
    try {
      final value =
          await _channel.invokeMethod<dynamic>('getFloatingRuntimeState');
      if (value is Map) return Map<String, dynamic>.from(value);
    } catch (_) {}
    return null;
  }
}

class FloatingSettingsPage extends StatefulWidget {
  const FloatingSettingsPage({super.key});

  @override
  State<FloatingSettingsPage> createState() => _FloatingSettingsPageState();
}

class _FloatingSettingsPageState extends State<FloatingSettingsPage> with WidgetsBindingObserver {
  late FloatingConfig config;
  bool loading = true;
  bool _waitingForOverlayPermission = false;
  Timer? runtimeTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    config = floatingConfigNotifier.value;
    _load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _waitingForOverlayPermission) {
      unawaited(_finishOverlayPermissionFlow());
    }
  }

  Future<void> _finishOverlayPermissionFlow() async {
    if (!_waitingForOverlayPermission) return;
    final granted = await FloatingBridge.hasPermission();
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
  }

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
            size: nativeSize.toDouble().clamp(0.65, 1.8).toDouble(),
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
      if (!await FloatingBridge.hasPermission()) {
        config = config.copyWith(enabled: false);
        await FloatingStore.save(config);
      } else {
        final started = await FloatingBridge.start(config);
        final running = started && await _waitForRuntimeReady();
        if (!running) {
          config = config.copyWith(enabled: false);
          await FloatingStore.save(config);
        } else {
          await FloatingBridge.updateConfig(config);
          _startRuntimeSync();
        }
      }
    }
  }

  Future<void> _apply(FloatingConfig next) async {
    config = next;
    await FloatingStore.save(config);
    if (config.enabled) await FloatingBridge.updateConfig(config);
    if (config.enabled && runtimeTimer == null) _startRuntimeSync();
    if (mounted) setState(() {});
  }

  Future<bool> _waitForRuntimeReady({Duration timeout = const Duration(seconds: 3)}) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      final state = await FloatingBridge.runtimeState();
      if (state?['running'] == true && state?['overlay'] == true) return true;
      await Future<void>.delayed(const Duration(milliseconds: 120));
    }
    return false;
  }

  Future<FloatingConfig> _normalizeSelection(FloatingConfig value) async {
    if (value.selected.isNotEmpty) return value;
    final normalized = value.copyWith(
      selected: FloatingMetric.defaultOrder.toSet(),
    );
    await FloatingStore.save(normalized);
    return normalized;
  }

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

    if (!await FloatingBridge.hasPermission()) {
      final proceed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(JexText.of('floatingPermissionTitle', appLanguageNotifier.value)),
            content: Text(JexText.of('floatingPermissionMessage', appLanguageNotifier.value)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(JexText.of('cancel', appLanguageNotifier.value)),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(JexText.phrase('Allow', 'Izinkan', appLanguageNotifier.value)),
              ),
            ],
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
    final started = await FloatingBridge.start(next);
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
    _startRuntimeSync();
    if (mounted) setState(() => config = next);
  }

  void _startRuntimeSync() {
    runtimeTimer?.cancel();
    runtimeTimer = Timer.periodic(
      const Duration(milliseconds: 300),
      (_) => unawaited(_syncRuntimeState()),
    );
  }

  Future<void> _syncRuntimeState() async {
    if (!mounted || !config.enabled) return;
    final state = await FloatingBridge.runtimeState();
    if (!mounted || state == null) return;
    final horizontal = state['horizontal'];
    final size = state['size'];
    var next = config;
    if (horizontal is bool && horizontal != config.horizontal) {
      next = next.copyWith(horizontal: horizontal);
    }
    if (size is num && (size.toDouble() - config.size).abs() > 0.005) {
      next = next.copyWith(size: size.toDouble().clamp(0.65, 1.8).toDouble());
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

  void _toggleMetric(String metric, bool value) {
    final next = Set<String>.from(config.selected);
    if (value) {
      next.add(metric);
    } else {
      next.remove(metric);
    }
    _apply(config.copyWith(selected: next));
  }

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
          final speedAvailable = telemetry.fanOn;
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
                        JexText.of('displayStyle', lang),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 7),
                      SegmentedButton<FloatingDisplayStyle>(
                        segments: [
                          ButtonSegment(
                            value: FloatingDisplayStyle.letters,
                            label: Text(JexText.of('letters', lang)),
                            icon: const Icon(PhosphorIconsRegular.textAa),
                          ),
                          ButtonSegment(
                            value: FloatingDisplayStyle.icons,
                            label: Text(JexText.of('icons', lang)),
                            icon: const Icon(PhosphorIconsRegular.stack),
                          ),
                        ],
                        selected: <FloatingDisplayStyle>{config.style},
                        onSelectionChanged: (value) {
                          if (value.isNotEmpty) _apply(config.copyWith(style: value.first));
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        JexText.of('functions', lang),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      _livePreview(telemetry),
                      const SizedBox(height: 8),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: config.order.length,
                        onReorder: _reorder,
                        itemBuilder: (context, index) {
                          final metric = config.order[index];
                          final enabled = metric == 'S' ? speedAvailable : true;
                          final checked = config.selected.contains(metric) && enabled;
                          return KeyedSubtree(
                            key: ValueKey<String>('floating-$metric'),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(PhosphorIconsRegular.dotsSixVertical, size: 20),
                              title: Text(_metricLabel(metric, lang), style: const TextStyle(fontWeight: FontWeight.w800)),
                              trailing: Checkbox(
                                value: checked,
                                onChanged: enabled ? (value) => _toggleMetric(metric, value == true) : null,
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
                        min: 0.65,
                        max: 1.8,
                        onChanged: (value) => _apply(config.copyWith(size: value)),
                      ),
                      _sliderRow(
                        label: JexText.of('opacity', lang),
                        value: config.opacity,
                        min: 0.35,
                        max: 1.0,
                        onChanged: (value) => _apply(config.copyWith(opacity: value)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        config.horizontal ? JexText.of('horizontal', lang) : JexText.of('vertical', lang),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
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

  Widget _livePreview(FloatingTelemetry telemetry) {
    final visible = config.order.where((metric) {
      if (!config.selected.contains(metric)) return false;
      if (metric == 'S' && !telemetry.fanOn) return false;
      return true;
    }).toList();

    return Center(
      child: GestureDetector(
        onTap: config.enabled
            ? () => _apply(config.copyWith(horizontal: !config.horizontal))
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: 12 * config.size,
            vertical: 8 * config.size,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: (config.opacity * 0.86).clamp(0.0, 1.0)),
            borderRadius: BorderRadius.circular(18 * config.size),
            boxShadow: const [
              BoxShadow(blurRadius: 12, offset: Offset(0, 5), color: Colors.black26),
            ],
          ),
          child: Flex(
            direction: config.horizontal ? Axis.horizontal : Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < visible.length; i++) ...[
                if (i > 0)
                  config.horizontal
                      ? SizedBox(width: 8 * config.size)
                      : SizedBox(height: 5 * config.size),
                _previewItem(visible[i], telemetry, config.style, config.size),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _previewItem(String metric, FloatingTelemetry telemetry, FloatingDisplayStyle style, double size) {
    final value = switch (metric) {
      'F' => telemetry.fps,
      'B' => telemetry.battery == '--' ? '--' : telemetry.battery + '°',
      'H' => telemetry.hotside == '--' ? '--' : telemetry.hotside + '°',
      'V' => telemetry.voltage,
      'A' => telemetry.fanOn && telemetry.adaptiveOn ? 'ON' : 'OFF',
      'P' => telemetry.fanOn && telemetry.peltierOn ? 'ON' : 'OFF',
      'S' => telemetry.fanOn ? telemetry.speed.toString() : 'OFF',
      _ => '--',
    };

    if (style == FloatingDisplayStyle.icons) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_metricIcon(metric), size: 17 * size, color: Colors.white),
          SizedBox(width: 4 * size),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.5 * size,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      );
    }

    return Text(
      metric + ':' + value,
      style: TextStyle(color: Colors.white, fontSize: 11.5 * size, fontWeight: FontWeight.w800),
    );
  }

  String _metricLabel(String metric, AppLanguage lang) {
    switch (metric) {
      case 'F':
        return JexText.of('fps', lang);
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
      case 'S':
        return JexText.of('speed', lang);
      default:
        return metric;
    }
  }

  IconData _metricIcon(String metric) {
    switch (metric) {
      case 'F':
        return PhosphorIconsRegular.gauge;
      case 'B':
        return PhosphorIconsRegular.batteryHigh;
      case 'H':
        return PhosphorIconsRegular.thermometer;
      case 'V':
        return PhosphorIconsRegular.lightning;
      case 'A':
        return PhosphorIconsRegular.sparkle;
      case 'P':
        return PhosphorIconsRegular.snowflake;
      case 'S':
        return PhosphorIconsRegular.fan;
      default:
        return PhosphorIconsRegular.circle;
    }
  }

  Widget _sliderRow({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(width: 66, child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800))),
        Expanded(child: Slider(min: min, max: max, value: value, onChanged: onChanged)),
      ],
    );
  }
}

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
                          builder: (_) => const LanguageSettingsPage(),
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
                      builder: (_) => const AppearanceSettingsPage(),
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
                      builder: (_) => const NotificationsSettingsPage(),
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
                      builder: (_) => const BluetoothSettingsPage(),
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
                      builder: (_) => const FloatingSettingsPage(),
                    ),
                  ),
                ),
              ]),
              _section(context, JexText.of('firmwareSection', language), [
                _item(context, PhosphorIconsRegular.uploadSimple, JexText.of('firmwareUpdate', language),
                    currentFirmwareVersion, () => unawaited(onOpenFirmwareUpdate())),
              ]),
              _section(context, JexText.of('aboutSection', language), [
                _item(
                context,
                PhosphorIconsRegular.info,
                JexText.of('about', language),
                appName,
                () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AboutSettingsPage(),
                  ),
                ),
              ),
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
              Icon(icon, size: 21, color: scheme.onSurfaceVariant),
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
              Icon(
                PhosphorIconsRegular.caretRight,
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

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  Future<void> _set(String key, bool value) async {
    if (value) {
      try {
        await const MethodChannel('je_x_fyz/notifications').invokeMethod<bool>('requestNotificationPermission');
      } catch (_) {}
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
                    title: Text(JexText.of('bluetoothConnected', language)),
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

class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) => Scaffold(
        appBar: AppBar(title: Text(JexText.of('about', language))),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          children: [
            Center(child: Image.asset('assets/jexfyzicon.png', width: 88, height: 88)),
            const SizedBox(height: 16),
            const Center(child: Text('JE X FYZ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900))),
            const SizedBox(height: 4),
            const Center(child: Text('JE Cooler', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
            const SizedBox(height: 24),
            const _AboutRow(label: 'App Version', value: '1.0.0'),
            const _AboutRow(label: 'Bluetooth', value: 'P1'),
            const SizedBox(height: 14),
            Center(child: Text('© JE X FYZ', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))),
          ],
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final String label;
  final String value;

  const _AboutRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
          Text(value),
        ],
      ),
    );
  }
}

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
