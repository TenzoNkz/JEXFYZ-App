// AI-MEMORY / FILE CONTRACT
// Owns stateless Floating Monitor Settings presentation and localized metric labels.
// All values and actions are supplied by the controller; no storage, MethodChannel,
// lifecycle observer, telemetry notifier or BLE/GATT ownership lives in this widget.

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'app_settings.dart';
import 'floating_monitor_models.dart';
import 'jex_animated_glyph.dart';
import 'jex_design_tokens.dart';

String floatingMetricStatus(
  String metric,
  FloatingTelemetry telemetry,
  AppLanguage language,
) {
  // Physical output/mode state is meaningful only while the shared P1 session is connected.
  if (!telemetry.connected) return '--';
  return switch (metric) {
    'A' => JexText.phrase(
      telemetry.adaptiveOn ? 'ACTIVE' : 'INACTIVE',
      telemetry.adaptiveOn ? 'AKTIF' : 'NONAKTIF',
      language,
    ),
    'P' => JexText.of(telemetry.peltierOn ? 'on' : 'off', language),
    'F' =>
      telemetry.fanOn
          ? telemetry.speed.toString()
          : JexText.of('off', language),
    _ => '--',
  };
}

// Stateless, value-in/callback-out renderer. Native overlay attachment and permission
// feedback stay in FloatingSettingsPage; this widget only describes user configuration.
class FloatingSettingsView extends StatelessWidget {
  final FloatingConfig config;
  final AppLanguage language;
  final bool loading;
  final ValueChanged<bool> onEnabledChanged;
  final void Function(String metric, bool selected) onMetricChanged;
  final ReorderCallback onReorder;
  final ValueChanged<double> onSizeChanged;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<FloatingBackgroundColor> onBackgroundColorChanged;
  final ValueChanged<bool> onOrientationChanged;

  const FloatingSettingsView({
    super.key,
    required this.config,
    required this.language,
    this.loading = false,
    required this.onEnabledChanged,
    required this.onMetricChanged,
    required this.onReorder,
    required this.onSizeChanged,
    required this.onOpacityChanged,
    required this.onBackgroundColorChanged,
    required this.onOrientationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = language;
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text(JexText.of('floatingMonitor', lang))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(JexText.of('floatingMonitor', lang))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(JexText.of('floatingMonitor', lang)),
            value: config.enabled,
            onChanged: onEnabledChanged,
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
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: config.order.length,
                    onReorder: onReorder,
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
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            size: 20,
                          ),
                          title: Text(
                            _metricLabel(metric, lang),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          trailing: Checkbox(
                            value: checked,
                            onChanged: (value) =>
                                onMetricChanged(metric, value == true),
                          ),
                          dense: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _sliderRow(
                    context,
                    label: JexText.of('size', lang),
                    value: config.size,
                    valueLabel:
                        '${JexText.formatNumber(config.size, lang, decimalDigits: 2, groupThousands: false)}×',
                    min: 0.30,
                    max: 1.00,
                    divisions: 14,
                    minLabel:
                        '${JexText.formatNumber(0.30, lang, decimalDigits: 2, groupThousands: false)}×',
                    maxLabel:
                        '${JexText.formatNumber(1.00, lang, decimalDigits: 2, groupThousands: false)}×',
                    onChanged: onSizeChanged,
                  ),
                  _sliderRow(
                    context,
                    label: JexText.of('opacity', lang),
                    value: config.opacity,
                    valueLabel: '${(config.opacity * 100).round()}%',
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    minLabel: '0%',
                    maxLabel: '100%',
                    onChanged: onOpacityChanged,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    JexText.of('backgroundColor', lang),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  SegmentedButton<FloatingBackgroundColor>(
                    segments: [
                      ButtonSegment<FloatingBackgroundColor>(
                        value: FloatingBackgroundColor.black,
                        label: Text(JexText.of('black', lang)),
                        icon: const Icon(PhosphorIconsRegular.moon),
                      ),
                      ButtonSegment<FloatingBackgroundColor>(
                        value: FloatingBackgroundColor.white,
                        label: Text(JexText.of('white', lang)),
                        icon: const Icon(PhosphorIconsRegular.sun),
                      ),
                    ],
                    selected: <FloatingBackgroundColor>{config.backgroundColor},
                    onSelectionChanged: (value) {
                      if (value.isNotEmpty)
                        onBackgroundColorChanged(value.first);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    JexText.of('orientation', lang),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
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
                      if (value.isNotEmpty) onOrientationChanged(value.first);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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

  // Keep the visible numeric readout and slider scale geometry identical to the
  // former Stateful page renderer; only the callback is now supplied by its owner.
  Widget _sliderRow(
    BuildContext context, {
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
      Text(
        minLabel,
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).colorScheme.jexMutedForeground,
        ),
      ),
      if (midLabel != null)
        Text(
          midLabel,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.jexMutedForeground,
          ),
        ),
      Text(
        maxLabel,
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).colorScheme.jexMutedForeground,
        ),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.jexElevatedSurface,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: ExcludeSemantics(
                    child: Text(
                      valueLabel,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Merge the visible field label with the Slider's adjustment actions
          // so assistive technology announces one named, localized control.
          MergeSemantics(
            child: Semantics(
              label: label,
              child: Slider(
                min: min,
                max: max,
                divisions: divisions,
                value: value.clamp(min, max).toDouble(),
                semanticFormatterCallback: (_) => valueLabel,
                onChanged: onChanged,
              ),
            ),
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
