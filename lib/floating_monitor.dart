// AI-MEMORY / FILE CONTRACT
// File: floating_monitor.dart
// Owns: Flutter Floating Monitor permission/lifecycle controller and configuration reconciliation.
// The stateless settings renderer, models, store, bridge and value projections are separate modules.
// Native ownership: MainActivity opens Android Settings; FloatingMonitorService owns
// WindowManager and the actual overlay window. This file never owns BLE/GATT.
// Localization: read the shared AppLanguage notifier. English status = ON/OFF;
// Indonesia status = HIDUP/MATI. Language selector labels are English / Indonesia.
// Fan Speed uses floating metric F; Fan OFF is presented as OFF/MATI.
// Selected metric presentation is owned by the native overlay; Settings contains no overlay preview.
// Protocol identifiers are not translated.
// Floating metric contract: F (Fan Speed) is the only fan-related metric; no separate Fan toggle exists.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'app_settings.dart';
import 'jex_animated_glyph.dart';
import 'usage_statistics.dart';

import 'floating_monitor_models.dart';
import 'floating_monitor_state.dart';
import 'floating_monitor_store.dart';
import 'floating_monitor_bridge.dart';
import 'floating_monitor_settings_view.dart';

export 'floating_monitor_models.dart';
export 'floating_monitor_state.dart';
export 'floating_monitor_store.dart';
export 'floating_monitor_bridge.dart';
export 'floating_monitor_settings_view.dart';
import 'jex_design_tokens.dart';

part 'settings_pages.dart';

// Firmware-owned Lock Voltage state. This notifier is presentation-only; it never persists device settings.
class VoltageLockSettingsState {
  final bool sessionReady;
  final bool known;
  final bool active;
  final bool saved;
  final bool busy;

  const VoltageLockSettingsState({
    this.sessionReady = false,
    this.known = false,
    this.active = false,
    this.saved = false,
    this.busy = false,
  });
}

final ValueNotifier<VoltageLockSettingsState> voltageLockSettingsNotifier =
    ValueNotifier<VoltageLockSettingsState>(const VoltageLockSettingsState());

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
class _FloatingSettingsPageState extends State<FloatingSettingsPage>
    with WidgetsBindingObserver {
  late FloatingConfig config;
  bool loading = true;
  bool _waitingForOverlayPermission = false;
  bool _permissionResumeCheckRunning = false;
  bool _runtimeSyncInFlight = false;
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
      if (_waitingForOverlayPermission) {
        unawaited(_finishOverlayPermissionFlow());
      } else if (config.enabled && floatingTelemetryNotifier.value.connected) {
        _startRuntimeSync();
        unawaited(_syncRuntimeState());
      }
    } else {
      runtimeTimer?.cancel();
      runtimeTimer = null;
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
            content: Text(
              JexText.of('overlayPermissionDenied', appLanguageNotifier.value),
            ),
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
    floatingConfigNotifier.value = config;
    if (config.enabled) {
      final nativeState = await FloatingBridge.runtimeState();
      if (nativeState != null) {
        var next = config.copyWith(horizontal: nativeState.horizontal);
        next = next.copyWith(size: nativeState.size);
        if (next.horizontal != config.horizontal || next.size != config.size) {
          config = next;
          floatingConfigNotifier.value = config;
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
      final started = await FloatingBridge.start(
        config,
        telemetry: floatingTelemetryNotifier.value,
      );
      final running = started && await _waitForRuntimeReady();
      if (!running) {
        await FloatingBridge.stop();
        if (!floatingTelemetryNotifier.value.connected ||
            !await FloatingBridge.hasPermission())
          return;
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
    floatingConfigNotifier.value = config;
    await FloatingStore.save(config);
    if (config.enabled) await FloatingBridge.updateConfig(config);
    if (config.enabled && runtimeTimer == null) _startRuntimeSync();
    if (mounted) setState(() {});
  }

  // AI-METHOD / STARTUP-VERIFY CONTRACT
  // Wait for the native service plus actual attached overlay state; hudView existence alone
  // is intentionally insufficient.
  Future<bool> _waitForRuntimeReady({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      final state = await FloatingBridge.runtimeState();
      if (state?.running == true && state?.overlay == true) return true;
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
    floatingConfigNotifier.value = normalized;
    await FloatingStore.save(normalized);
    return normalized;
  }

  // AI-METHOD / ENABLE-CONTRACT
  // User-facing master toggle. Start and verify the native overlay before persisting enabled=true.
  Future<void> _toggleEnabled(bool value) async {
    if (!value) {
      config = config.copyWith(enabled: false);
      floatingConfigNotifier.value = config;
      runtimeTimer?.cancel();
      runtimeTimer = null;
      await FloatingStore.save(config);
      await FloatingBridge.stop();
      if (mounted) setState(() {});
      return;
    }

    if (!floatingTelemetryNotifier.value.connected) {
      config = config.copyWith(enabled: true);
      floatingConfigNotifier.value = config;
      await FloatingStore.save(config);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              JexText.of(
                'floatingPendingConnection',
                appLanguageNotifier.value,
              ),
            ),
          ),
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
              title: Text(
                JexText.of(
                  'floatingPermissionTitle',
                  appLanguageNotifier.value,
                ),
              ),
              content: Text(
                JexText.of(
                  'floatingPermissionMessage',
                  appLanguageNotifier.value,
                ),
              ),
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
            content: Text(
              JexText.of('overlaySettingsFailed', appLanguageNotifier.value),
            ),
          ),
        );
      }
      return;
    }

    config = await _normalizeSelection(config);
    final next = config.copyWith(enabled: true);
    final started = await FloatingBridge.start(
      next,
      telemetry: floatingTelemetryNotifier.value,
    );
    final running = started && await _waitForRuntimeReady();
    if (!running) {
      await FloatingBridge.stop();
      config = config.copyWith(enabled: false);
      floatingConfigNotifier.value = config;
      await FloatingStore.save(config);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              JexText.of('floatingStartFailed', appLanguageNotifier.value),
            ),
          ),
        );
        setState(() {});
      }
      return;
    }
    floatingConfigNotifier.value = next;
    await FloatingStore.save(next);
    // A snapshot may have been published before the service was attached and therefore
    // dropped by the native bridge. Always seed newly-started overlay with live state.
    await FloatingBridge.updateData(floatingTelemetryNotifier.value);
    _startRuntimeSync();
    if (mounted) setState(() => config = next);
  }

  // AI-METHOD / RUNTIME-SYNC-CONTRACT
  // Bounded reconciliation for native overlay attachment and size/orientation changes.
  void _startRuntimeSync() {
    // Permission and service futures can complete after this route is disposed.
    // Do not recreate a periodic timer after dispose has cancelled the existing one.
    if (!mounted) return;
    runtimeTimer?.cancel();
    runtimeTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => unawaited(_syncRuntimeState()),
    );
  }

  // AI-METHOD / RUNTIME-HEALTH-CONTRACT
  // Single-flight native reconciliation prevents slow MethodChannel calls from overlapping.
  Future<void> _syncRuntimeState() async {
    if (_runtimeSyncInFlight ||
        !mounted ||
        !config.enabled ||
        !floatingTelemetryNotifier.value.connected) {
      return;
    }
    _runtimeSyncInFlight = true;
    try {
      if (!await FloatingBridge.hasPermission()) return;
      final state = await FloatingBridge.runtimeState();
      if (!mounted ||
          state == null ||
          !floatingTelemetryNotifier.value.connected)
        return;

      if (!state.serviceRunning || !state.viewAttachedToWindow) {
        runtimeTimer?.cancel();
        runtimeTimer = null;
        config = config.copyWith(enabled: false);
        await FloatingStore.save(config);
        if (mounted) setState(() {});
        return;
      }

      final horizontal = state.horizontal;
      final size = state.size;
      var next = config;
      if (horizontal != config.horizontal) {
        next = next.copyWith(horizontal: horizontal);
      }
      if ((size - config.size).abs() > 0.005) {
        next = next.copyWith(size: size);
      }
      if (next.horizontal != config.horizontal || next.size != config.size) {
        config = next;
        floatingConfigNotifier.value = next;
        await FloatingStore.save(next);
        if (mounted) setState(() {});
      }
    } catch (error) {
      debugPrint('Floating Monitor runtime sync: $error');
    } finally {
      _runtimeSyncInFlight = false;
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
  Widget build(BuildContext context) => FloatingSettingsView(
    config: config,
    language: appLanguageNotifier.value,
    loading: loading,
    onEnabledChanged: _toggleEnabled,
    onMetricChanged: _toggleMetric,
    onReorder: _reorder,
    onSizeChanged: (value) => _apply(config.copyWith(size: value)),
    onOpacityChanged: (value) => _apply(config.copyWith(opacity: value)),
    onBackgroundColorChanged: (value) =>
        _apply(config.copyWith(backgroundColor: value)),
    onOrientationChanged: (value) =>
        _apply(config.copyWith(horizontal: value)),
  );
}

class JexFixedScalePage extends StatelessWidget {
  final Widget child;
  final bool compactUi;

  const JexFixedScalePage({
    super.key,
    required this.child,
    this.compactUi = false,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.noScaling),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const designWidth = JexLayoutTokens.masterCanvasWidth;
          if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0)
            return child;

          // Match Home's master canvas: keep the logical width fixed and
          // compensate for density/Smallest Width changes with one uniform scale.
          final scale = constraints.maxWidth / designWidth;
          final designHeight = constraints.maxHeight / scale;
          final scaledMedia = media.copyWith(
            textScaler: TextScaler.noScaling,
            size: Size(designWidth, designHeight),
            padding: EdgeInsets.fromLTRB(
              media.padding.left / scale,
              media.padding.top / scale,
              media.padding.right / scale,
              media.padding.bottom / scale,
            ),
            viewPadding: EdgeInsets.fromLTRB(
              media.viewPadding.left / scale,
              media.viewPadding.top / scale,
              media.viewPadding.right / scale,
              media.viewPadding.bottom / scale,
            ),
            viewInsets: EdgeInsets.fromLTRB(
              media.viewInsets.left / scale,
              media.viewInsets.top / scale,
              media.viewInsets.right / scale,
              media.viewInsets.bottom / scale,
            ),
          );
          final logicalCanvas = MediaQuery(
            data: scaledMedia,
            child: SizedBox(
              width: designWidth,
              height: designHeight,
              child: child,
            ),
          );
          final canvasChild = compactUi
              ? Theme(
                  data: buildJexCompactUiTheme(
                    appThemeNotifier.value,
                    baseTheme: Theme.of(context),
                  ),
                  child: logicalCanvas,
                )
              : logicalCanvas;

          return ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                minWidth: designWidth,
                maxWidth: designWidth,
                minHeight: designHeight,
                maxHeight: designHeight,
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: canvasChild,
                ),
              ),
            ),
          );
        },
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
        builder: (context, secondValue, __) =>
            builder(context, firstValue, secondValue),
      ),
    );
  }
}
