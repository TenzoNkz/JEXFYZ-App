// AI-MEMORY / FILE CONTRACT
// Owns self-contained status-indicator presentation: policy/value helpers, lifecycle-safe
// animation controllers, fan phase simulation and CustomPainter glyph rendering.
// Inputs are presentation values supplied by the App; this module never reads device state.
//
// Dashboard remains authoritative for connection, command/ACK and telemetry-confirmed state.
// No BLE/GATT transport, P1 parsing, persistence, platform channel or safety authority belongs here.
// Preserve phase continuity, confirmed-state gating, reduced-motion behavior and controller disposal.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

enum JexAnimatedIconKind {
  battery,
  hotside,
  voltage,
  adaptive,
  peltier,
  fan,
  speed,
  led,
  bluetooth,
  generic,
}

// JE X FYZ custom motion: every status icon has its own rhythm. Generic action
// glyphs intentionally stay static; only device/status indicators animate.
// Shared active-state gate; the kind-aware policy below handles continuous sensors.
// Battery, Hotside and Voltage loop while connected; outputs require an active known state.
bool jexIndicatorAnimationActive({
  required bool connected,
  required bool stateActive,
}) => connected && stateActive;

/// Controls autonomous phase loops, not event-driven transitions.
/// Battery, Hotside and Voltage loop while BLE is online; output icons otherwise
/// loop only while active. Fan Speed is retargeted by its separate PWM controller.
bool jexIconAnimationPermitted({
  required bool connected,
  required JexAnimatedIconKind kind,
  required bool stateActive,
  bool reduceMotion = false,
  bool continuousLoop = true,
}) {
  if (!continuousLoop ||
      !connected ||
      reduceMotion ||
      kind == JexAnimatedIconKind.generic ||
      kind == JexAnimatedIconKind.bluetooth) {
    return false;
  }
  if (kind == JexAnimatedIconKind.battery ||
      kind == JexAnimatedIconKind.hotside ||
      kind == JexAnimatedIconKind.voltage) {
    return stateActive;
  }
  // Fan Speed interpolates actual BLE PWM updates; it must not run a decorative cycle.
  if (kind == JexAnimatedIconKind.speed) return false;
  return stateActive;
}

enum DisplayMenuLockReason {
  none,
  bluetoothDisconnected,
  adaptiveActive,
  voltageLocked,
}

/// Applies one centered lock overlay to the selected submenu.
/// Disconnection has highest priority, followed by the existing Adaptive gate.
DisplayMenuLockReason displayMenuLockReason({
  required bool connected,
  required bool adaptiveActive,
  required bool adaptiveTransitioning,
  required int tabIndex,
  bool voltageLockKnown = false,
  bool voltageLockActive = false,
}) {
  if (!connected) return DisplayMenuLockReason.bluetoothDisconnected;
  final adaptiveLocksTab = tabIndex == 0 || tabIndex == 1 || tabIndex == 4;
  if ((adaptiveActive || adaptiveTransitioning) && adaptiveLocksTab) {
    return DisplayMenuLockReason.adaptiveActive;
  }
  final voltageLockLocksTab = tabIndex == 0 || tabIndex == 2;
  if (voltageLockKnown && voltageLockActive && voltageLockLocksTab) {
    return DisplayMenuLockReason.voltageLocked;
  }
  return DisplayMenuLockReason.none;
}

int jexVoltageAnimationLevel(String voltage) {
  return switch (voltage.trim().toUpperCase()) {
    '5V' => 5,
    '9V' => 9,
    '12V' => 12,
    _ => 5,
  };
}

/// Visual intensity only; this does not estimate actual surface temperature or ice.
double jexPeltierFrostIntensity(int voltageLevel) {
  return switch (voltageLevel) {
    5 => .25,
    9 => .50,
    12 => 1.0,
    _ => .24,
  };
}

int jexPeltierFrostParticleCount(int voltageLevel) {
  return switch (voltageLevel) {
    5 => 3,
    9 => 6,
    12 => 14,
    _ => 2,
  };
}

Duration jexIconAnimationDuration(
  JexAnimatedIconKind kind, {
  int voltageLevel = 5,
  double fanSpeedLevel = 1.0,
}) {
  if (kind == JexAnimatedIconKind.fan) {
    final baseMilliseconds = switch (voltageLevel) {
      9 => 1250,
      12 => 620,
      _ => 2600,
    };
    // Voltage sets the base rotor class; at 12V, live PWM adjusts angular speed.
    final pwmFactor = voltageLevel == 12
        ? fanSpeedLevel.clamp(.35, 1.0).toDouble()
        : 1.0;
    return Duration(milliseconds: (baseMilliseconds / pwmFactor).round());
  }
  return switch (kind) {
    JexAnimatedIconKind.battery => const Duration(milliseconds: 1500),
    JexAnimatedIconKind.hotside => const Duration(milliseconds: 1650),
    JexAnimatedIconKind.voltage => const Duration(milliseconds: 1000),
    JexAnimatedIconKind.adaptive => const Duration(milliseconds: 2300),
    JexAnimatedIconKind.peltier => const Duration(milliseconds: 2100),
    JexAnimatedIconKind.fan => const Duration(milliseconds: 2600),
    JexAnimatedIconKind.speed => const Duration(milliseconds: 1800),
    JexAnimatedIconKind.led => const Duration(milliseconds: 3000),
    JexAnimatedIconKind.bluetooth => const Duration(milliseconds: 2800),
    JexAnimatedIconKind.generic => const Duration(milliseconds: 2000),
  };
}

/// Smoothstep used for particle entry/exit and angular-rate retargeting.
double jexMotionSmoothStep(double value) {
  final t = value.clamp(0.0, 1.0).toDouble();
  return t * t * (3.0 - 2.0 * t);
}

/// Zero at the cycle edges and one through the fully visible middle. It conceals
/// periodic phase wraps so particles do not teleport while visibly opaque.
double jexParticleBoundaryFade(
  double phase, {
  double fadeIn = .18,
  double fadeOut = .22,
}) {
  if (!phase.isFinite) return 0.0;
  final p = phase.clamp(0.0, 1.0).toDouble();
  final enter = fadeIn <= 0
      ? 1.0
      : jexMotionSmoothStep((p / fadeIn).clamp(0.0, 1.0).toDouble());
  final leave = fadeOut <= 0
      ? 1.0
      : jexMotionSmoothStep(((1.0 - p) / fadeOut).clamp(0.0, 1.0).toDouble());
  return math.min(enter, leave).toDouble();
}

/// The rotor's target rate comes from the existing voltage/PWM cycle policy.
double jexFanRotationCyclesPerSecond({
  int voltageLevel = 5,
  double fanSpeedLevel = 1.0,
}) {
  final cycleMicros = jexIconAnimationDuration(
    JexAnimatedIconKind.fan,
    voltageLevel: voltageLevel,
    fanSpeedLevel: fanSpeedLevel,
  ).inMicroseconds;
  if (cycleMicros <= 0) return 0.0;
  return 1000000.0 / cycleMicros;
}

/// Integrated rotations during a smoothstep angular-rate transition. Position and
/// velocity join continuously at the end of the ramp.
double jexIntegratedFanCycles({
  required double fromCyclesPerSecond,
  required double toCyclesPerSecond,
  required double elapsedSeconds,
  required double transitionSeconds,
}) {
  final elapsed = math.max(0.0, elapsedSeconds).toDouble();
  final transition = math.max(0.0, transitionSeconds).toDouble();
  if (transition <= 0.0) return toCyclesPerSecond * elapsed;

  final transitionTime = math.min(elapsed, transition).toDouble();
  final u = (transitionTime / transition).clamp(0.0, 1.0).toDouble();
  // Integral(3u² - 2u³) = u³ - 0.5u⁴.
  final easedIntegral = transition * (u * u * u - .5 * u * u * u * u);
  final transitionedCycles =
      fromCyclesPerSecond * transitionTime +
      (toCyclesPerSecond - fromCyclesPerSecond) * easedIntegral;
  if (elapsed <= transition) return transitionedCycles;
  return transitionedCycles + toCyclesPerSecond * (elapsed - transition);
}

double jexFanRotationCyclesPerSecondAt({
  required double fromCyclesPerSecond,
  required double toCyclesPerSecond,
  required double elapsedSeconds,
  required double transitionSeconds,
}) {
  final transition = math.max(0.0, transitionSeconds).toDouble();
  if (transition <= 0.0) return toCyclesPerSecond;
  final t = (math.max(0.0, elapsedSeconds).toDouble() / transition)
      .clamp(0.0, 1.0)
      .toDouble();
  return fromCyclesPerSecond +
      (toCyclesPerSecond - fromCyclesPerSecond) * jexMotionSmoothStep(t);
}

/// Converts unbounded accumulated radians to the painter's normalized turn.
double jexNormalizedFanProgress(double phaseRadians) {
  const fullTurn = math.pi * 2.0;
  final wrapped = phaseRadians % fullTurn;
  return (wrapped < 0.0 ? wrapped + fullTurn : wrapped) / fullTurn;
}

/// Smoothly retargets the Fan Speed arc/needle without snapping when BLE reports
/// another speed before the previous visual transition has completed.
double jexSmoothFanSpeedLevel({
  required double from,
  required double to,
  required double progress,
}) {
  final t = progress.clamp(0.0, 1.0).toDouble();
  // Symmetric cubic smoothstep: exact midpoint and zero velocity at both ends.
  final eased = t * t * (3.0 - 2.0 * t);
  return from + (to - from) * eased;
}

/// Maps a real Celsius reading into a visual indicator level without inventing a reading.
/// Missing/invalid telemetry uses a quiet fallback; callers still gate motion on BLE.
double jexTemperatureIndicatorLevel(
  String value, {
  double minC = 0,
  double maxC = 60,
  double fallback = .35,
}) {
  final safeFallback = fallback.clamp(0.0, 1.0).toDouble();
  if (!minC.isFinite || !maxC.isFinite || maxC <= minC) return safeFallback;
  final match = RegExp(r'-?\d+(?:[.,]\d+)?').firstMatch(value.trim());
  final raw = match?.group(0)?.replaceAll(',', '.');
  final temperature = raw == null ? null : double.tryParse(raw);
  if (temperature == null || !temperature.isFinite) return safeFallback;
  return ((temperature - minC) / (maxC - minC)).clamp(0.0, 1.0).toDouble();
}

const Color jexThermalIceBlue = Color(0xFF65DDFB);
const Color jexThermalCyan = Color(0xFF42DDD6);
const Color jexThermalGreen = Color(0xFF70E68D);
const Color jexThermalAmber = Color(0xFFFFD166);
const Color jexThermalOrange = Color(0xFFFF913F);
const Color jexThermalRed = Color(0xFFFF464F);

double? jexParseTemperatureC(String value) {
  final match = RegExp(r'-?\d+(?:[.,]\d+)?').firstMatch(value.trim());
  final raw = match?.group(0)?.replaceAll(',', '.');
  final temperature = raw == null ? null : double.tryParse(raw);
  return temperature != null && temperature.isFinite ? temperature : null;
}

Color _jexInterpolatePalette(
  double value,
  List<double> stops,
  List<Color> colors,
) {
  if (stops.length != colors.length || stops.isEmpty) {
    return jexThermalIceBlue;
  }
  final clamped = value.clamp(stops.first, stops.last).toDouble();
  for (var i = 0; i < stops.length - 1; i++) {
    if (clamped <= stops[i + 1]) {
      final span = stops[i + 1] - stops[i];
      final t = span <= 0
          ? 1.0
          : ((clamped - stops[i]) / span).clamp(0.0, 1.0).toDouble();
      return Color.lerp(colors[i], colors[i + 1], t)!;
    }
  }
  return colors.last;
}

/// Battery temperature uses the same clear visual bounds: ice blue through 30°C,
/// transitioning smoothly through cyan/amber/orange to burning red at 40°C and above.
/// Invalid telemetry uses an ice-blue resting accent, never a fabricated live reading.
Color jexThermalBatteryColor(String value) {
  final temperature = jexParseTemperatureC(value);
  if (temperature == null || temperature <= 30) return jexThermalIceBlue;
  if (temperature >= 40) return jexThermalRed;
  final progress = ((temperature - 30) / 10).clamp(0.0, 1.0).toDouble();
  return _jexInterpolatePalette(
    progress,
    const <double>[0, .25, .55, .80, 1],
    const <Color>[
      jexThermalIceBlue,
      jexThermalCyan,
      jexThermalAmber,
      jexThermalOrange,
      jexThermalRed,
    ],
  );
}

/// Battery shell segments represent the 30–40°C thermal colour band.
/// The fill is not phone battery capacity.
double jexThermalBatteryLevel(String value) =>
    jexTemperatureIndicatorLevel(value, minC: 30, maxC: 40, fallback: 0);

/// Fire overlays are controlled by exact live temperature thresholds, not eased visual fill.
bool jexThermalBatteryFireActive(String value) {
  final temperature = jexParseTemperatureC(value);
  return temperature != null && temperature >= 40;
}

bool jexHotsideFireActive(String value, {required double hotLimit}) {
  final temperature = jexParseTemperatureC(value);
  return temperature != null && hotLimit.isFinite && temperature >= hotLimit;
}

/// Hotside stays ice blue through 30°C and reaches burning red at the configured Hotside limit.
/// Visual color never replaces or changes firmware-owned thermal protection.
Color jexHotsideTemperatureColor(String value, {required double hotLimit}) {
  final temperature = jexParseTemperatureC(value);
  if (temperature == null || temperature <= 30) return jexThermalIceBlue;
  final limit = hotLimit.isFinite && hotLimit > 0 ? hotLimit : 45.0;
  final redAt = limit;
  if (redAt <= 30 || temperature >= redAt) return jexThermalRed;
  final progress = ((temperature - 30) / (redAt - 30))
      .clamp(0.0, 1.0)
      .toDouble();
  return _jexInterpolatePalette(
    progress,
    const <double>[0, .28, .56, .80, 1],
    const <Color>[
      jexThermalIceBlue,
      jexThermalCyan,
      jexThermalAmber,
      jexThermalOrange,
      jexThermalRed,
    ],
  );
}

/// Voltage colors and energy have one source of truth for Home and submenu glyphs.
Color jexVoltageIndicatorColor(String voltage) {
  return switch (voltage.trim().toUpperCase()) {
    '5V' => const Color(0xFFFF4D5A),
    '9V' => const Color(0xFF52E6A2),
    '12V' => const Color(0xFF4D8CFF),
    // Unknown/disconnected voltage falls back to the lowest manual-voltage accent.
    _ => const Color(0xFFFF4D5A),
  };
}

double jexVoltageEnergyLevel(String voltage) {
  return switch (voltage.trim().toUpperCase()) {
    '5V' => .25,
    '9V' => .50,
    '12V' => 1.0,
    _ => 0.0,
  };
}

class JexAnimatedIcon extends StatefulWidget {
  final JexAnimatedIconKind kind;
  final Color color;
  final bool connected;
  final double size;
  final bool active;
  final bool continuousLoop;
  final double level;
  final int voltageLevel;
  final bool warning;
  final bool valueKnown;
  final bool lightTheme;
  final Color lightSurfaceColor;
  final Color lightOutlineColor;

  const JexAnimatedIcon({
    super.key,
    required this.kind,
    required this.color,
    this.size = 24,
    this.connected = false,
    this.active = false,
    this.continuousLoop = true,
    this.level = 1,
    this.voltageLevel = 5,
    this.warning = false,
    this.valueKnown = true,
    this.lightTheme = false,
    this.lightSurfaceColor = Colors.white,
    this.lightOutlineColor = const Color(0xFF3F444D),
  });

  @override
  State<JexAnimatedIcon> createState() => _JexAnimatedIconState();
}

class _JexFanRotationSimulation extends Simulation {
  _JexFanRotationSimulation({
    required this.startPhaseRadians,
    required this.fromCyclesPerSecond,
    required this.toCyclesPerSecond,
    required this.transitionSeconds,
    required this.stopAtTarget,
  });

  final double startPhaseRadians;
  final double fromCyclesPerSecond;
  final double toCyclesPerSecond;
  final double transitionSeconds;
  final bool stopAtTarget;

  double cyclesPerSecondAt(double timeSeconds) =>
      jexFanRotationCyclesPerSecondAt(
        fromCyclesPerSecond: fromCyclesPerSecond,
        toCyclesPerSecond: toCyclesPerSecond,
        elapsedSeconds: timeSeconds,
        transitionSeconds: transitionSeconds,
      );

  @override
  double x(double time) =>
      startPhaseRadians +
      math.pi *
          2.0 *
          jexIntegratedFanCycles(
            fromCyclesPerSecond: fromCyclesPerSecond,
            toCyclesPerSecond: toCyclesPerSecond,
            elapsedSeconds: time,
            transitionSeconds: transitionSeconds,
          );

  @override
  double dx(double time) => math.pi * 2.0 * cyclesPerSecondAt(time);

  @override
  bool isDone(double time) => stopAtTarget && time >= transitionSeconds;
}

class _JexAnimatedIconState extends State<JexAnimatedIcon>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController controller;
  late final AnimationController fanPhaseController;
  late final AnimationController activityTransitionController;
  late final AnimationController frostTransitionController;
  late final AnimationController speedLevelTransitionController;
  late final AnimationController indicatorLevelTransitionController;
  late final AnimationController warningTransitionController;
  double _warningFromLevel = 0.0;
  double _warningTargetLevel = 0.0;
  double _frostFromIntensity = .24;
  double _frostFromParticleCount = 2;
  double _speedFromLevel = 0;
  double _speedTargetLevel = 0;
  double _indicatorLevelFrom = 0;
  double _indicatorLevelTarget = 0;
  bool _fanCoasting = false;
  _JexFanRotationSimulation? _fanRotationSimulation;
  double _fanTargetCyclesPerSecond = 0.0;
  bool _mediaQueryDisableAnimations = false;
  bool _systemReduceMotion = false;
  bool _hasMotionPreference = false;

  bool get _reduceMotion => _mediaQueryDisableAnimations || _systemReduceMotion;

  double _currentSpeedLevel() => jexSmoothFanSpeedLevel(
    from: _speedFromLevel,
    to: _speedTargetLevel,
    progress: speedLevelTransitionController.value,
  );

  double _currentIndicatorLevel() {
    final t = Curves.easeInOutCubic.transform(
      indicatorLevelTransitionController.value,
    );
    return _indicatorLevelFrom +
        (_indicatorLevelTarget - _indicatorLevelFrom) * t;
  }

  double _currentWarningLevel() {
    final t = Curves.easeInOutCubic.transform(
      warningTransitionController.value,
    );
    return _warningFromLevel + (_warningTargetLevel - _warningFromLevel) * t;
  }

  void _retargetWarningLevel(bool warning) {
    _warningTargetLevel = warning ? 1.0 : 0.0;
    if (_reduceMotion) {
      _warningFromLevel = _warningTargetLevel;
      warningTransitionController.stop();
      warningTransitionController.value = 1;
      return;
    }
    _warningFromLevel = _currentWarningLevel();
    warningTransitionController.duration = const Duration(milliseconds: 280);
    warningTransitionController.forward(from: 0);
  }

  void _retargetIndicatorLevel(double target) {
    _indicatorLevelTarget = target.clamp(0.0, 1.0).toDouble();
    if (_reduceMotion) {
      _indicatorLevelFrom = _indicatorLevelTarget;
      indicatorLevelTransitionController.stop();
      indicatorLevelTransitionController.value = 1;
      return;
    }
    _indicatorLevelFrom = _currentIndicatorLevel();
    indicatorLevelTransitionController.duration = const Duration(
      milliseconds: 520,
    );
    indicatorLevelTransitionController.forward(from: 0);
  }

  void _retargetSpeedLevel(double target, {required Duration duration}) {
    // Capture the in-flight interpolation before changing its target, so rapid
    // PWM updates retarget from the currently rendered needle position.
    final current = _currentSpeedLevel();
    _speedTargetLevel = target.clamp(0.0, 1.0).toDouble();
    if (_reduceMotion) {
      _speedFromLevel = _speedTargetLevel;
      speedLevelTransitionController.stop();
      speedLevelTransitionController.value = 1;
      return;
    }
    _speedFromLevel = current;
    speedLevelTransitionController.duration = duration;
    speedLevelTransitionController.forward(from: 0);
  }

  double _currentFanCyclesPerSecond() {
    final simulation = _fanRotationSimulation;
    if (!fanPhaseController.isAnimating || simulation == null) {
      return _fanTargetCyclesPerSecond;
    }
    final elapsedMicros =
        fanPhaseController.lastElapsedDuration?.inMicroseconds ?? 0;
    return simulation.cyclesPerSecondAt(elapsedMicros / 1000000.0);
  }

  TickerFuture _retargetFanRotation(
    double targetCyclesPerSecond, {
    required Duration transition,
    bool stopAtTarget = false,
  }) {
    final fromCyclesPerSecond = _currentFanCyclesPerSecond();
    final target = targetCyclesPerSecond.isFinite
        ? math.max(0.0, targetCyclesPerSecond).toDouble()
        : 0.0;
    final simulation = _JexFanRotationSimulation(
      startPhaseRadians: fanPhaseController.value,
      fromCyclesPerSecond: fromCyclesPerSecond,
      toCyclesPerSecond: target,
      transitionSeconds: transition.inMicroseconds / 1000000.0,
      stopAtTarget: stopAtTarget,
    );
    _fanRotationSimulation = simulation;
    _fanTargetCyclesPerSecond = target;
    // Re-target from the accumulated phase; integrate angular velocity rather than
    // changing the repeating controller duration mid-cycle.
    return fanPhaseController.animateWith(simulation);
  }

  void _launchFanRotationRetarget(
    double targetCyclesPerSecond, {
    required Duration transition,
  }) {
    if (_reduceMotion) return;
    unawaited(
      _retargetFanRotation(
        targetCyclesPerSecond,
        transition: transition,
      ).orCancel.catchError((Object error) {
        if (error is! TickerCanceled) {
          debugPrint('Fan rotation transition failed: $error');
        }
      }),
    );
  }

  void _resetFanRotation() {
    _fanCoasting = false;
    fanPhaseController.stop();
    fanPhaseController.value = 0.0;
    _fanRotationSimulation = null;
    _fanTargetCyclesPerSecond = 0.0;
  }

  Future<void> _coastFanToStop() async {
    if (!mounted ||
        !widget.connected ||
        widget.kind != JexAnimatedIconKind.fan ||
        widget.active) {
      return;
    }
    if (_reduceMotion) {
      _applyReducedMotionState();
      return;
    }

    _fanCoasting = true;
    unawaited(_animateActivityTransition(false));
    final coast = _retargetFanRotation(
      0.0,
      transition: const Duration(milliseconds: 420),
      stopAtTarget: true,
    );
    try {
      await coast.orCancel;
    } on TickerCanceled {
      // A newer Fan ON/OFF, PWM, voltage, or disconnect transition superseded the coast.
    } finally {
      if (mounted && widget.kind == JexAnimatedIconKind.fan && !widget.active) {
        _fanCoasting = false;
        _fanRotationSimulation = null;
        _fanTargetCyclesPerSecond = 0.0;
        fanPhaseController.stop();
        activityTransitionController.stop();
        activityTransitionController.value = 0.0;
        if (!widget.connected) fanPhaseController.value = 0.0;
      }
    }
  }

  Future<void> _animateActivityTransition(bool active) async {
    if (_reduceMotion) {
      activityTransitionController.stop();
      activityTransitionController.value = active ? 1 : 0;
      return;
    }
    try {
      await activityTransitionController
          .animateTo(
            active ? 1.0 : 0.0,
            duration: Duration(milliseconds: active ? 360 : 440),
            curve: Curves.easeInOutCubic,
          )
          .orCancel;
      if (!mounted || widget.active != active || !widget.connected) return;
      // This transition affects in-shape highlights only, never base glyph opacity.
    } on TickerCanceled {
      // A newer state transition retargeted this activity fade.
    }
  }

  void _resumeCycleWithoutPhaseSnap() {
    if (!mounted ||
        _reduceMotion ||
        !widget.connected ||
        !widget.continuousLoop ||
        !widget.active ||
        widget.kind == JexAnimatedIconKind.generic ||
        widget.kind == JexAnimatedIconKind.bluetooth ||
        widget.kind == JexAnimatedIconKind.fan ||
        controller.isAnimating) {
      return;
    }
    final cycleMs = jexIconAnimationDuration(
      widget.kind,
      voltageLevel: widget.voltageLevel,
      fanSpeedLevel: widget.level,
    ).inMilliseconds;
    final remaining = (1.0 - controller.value).clamp(0.0, 1.0).toDouble();
    if (remaining <= 0.0001) {
      controller.repeat();
      return;
    }
    final durationMs = (cycleMs * remaining).round().clamp(16, cycleMs).toInt();
    unawaited(_finishIconCycleBoundary(durationMs));
  }

  Future<void> _finishIconCycleBoundary(int durationMs) async {
    try {
      await controller
          .animateTo(
            1.0,
            duration: Duration(milliseconds: durationMs),
            curve: Curves.linear,
          )
          .orCancel;
      if (mounted &&
          jexIconAnimationPermitted(
            connected: widget.connected,
            kind: widget.kind,
            stateActive: widget.active,
            reduceMotion: _reduceMotion,
            continuousLoop: widget.continuousLoop,
          )) {
        controller.repeat();
      }
    } on TickerCanceled {
      // A newer activation or disconnect superseded this phase travel.
    }
  }

  void _stopAnimationsForDisconnect() {
    _resetFanRotation();
    controller.stop();
    activityTransitionController.stop();
    frostTransitionController.stop();
    speedLevelTransitionController.stop();
    indicatorLevelTransitionController.stop();
    warningTransitionController.stop();
    controller.value = 0;
    activityTransitionController.value = 0;
    frostTransitionController.value = 0;
    _speedFromLevel = 0;
    _speedTargetLevel = 0;
    speedLevelTransitionController.value = 1;
    _indicatorLevelFrom = widget.level.clamp(0.0, 1.0).toDouble();
    _indicatorLevelTarget = _indicatorLevelFrom;
    indicatorLevelTransitionController.value = 1;
    _warningFromLevel = 0.0;
    _warningTargetLevel = 0.0;
    warningTransitionController.value = 1;
  }

  void _applyReducedMotionState() {
    controller.stop();
    controller.value = 0;
    fanPhaseController.stop();
    _fanRotationSimulation = null;
    _fanTargetCyclesPerSecond = 0.0;
    _fanCoasting = false;

    activityTransitionController.stop();
    activityTransitionController.value = widget.active ? 1 : 0;

    frostTransitionController.stop();
    if (widget.kind == JexAnimatedIconKind.peltier && widget.active) {
      _frostFromIntensity = jexPeltierFrostIntensity(widget.voltageLevel);
      _frostFromParticleCount = jexPeltierFrostParticleCount(
        widget.voltageLevel,
      ).toDouble();
      frostTransitionController.value = 1;
    }

    final speedTarget = widget.active && widget.valueKnown
        ? widget.level.clamp(0.0, 1.0).toDouble()
        : 0.0;
    _speedFromLevel = speedTarget;
    _speedTargetLevel = speedTarget;
    speedLevelTransitionController.stop();
    speedLevelTransitionController.value = 1;

    final indicatorTarget = widget.level.clamp(0.0, 1.0).toDouble();
    _indicatorLevelFrom = indicatorTarget;
    _indicatorLevelTarget = indicatorTarget;
    indicatorLevelTransitionController.stop();
    indicatorLevelTransitionController.value = 1;

    _warningFromLevel = widget.warning ? 1.0 : 0.0;
    _warningTargetLevel = _warningFromLevel;
    warningTransitionController.stop();
    warningTransitionController.value = 1;
  }

  void _applyMotionPreference() {
    if (!_hasMotionPreference) return;
    if (!widget.connected) {
      _stopAnimationsForDisconnect();
    } else if (_reduceMotion) {
      _applyReducedMotionState();
    } else {
      _syncAnimation();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    if (!_hasMotionPreference ||
        disableAnimations != _mediaQueryDisableAnimations) {
      _mediaQueryDisableAnimations = disableAnimations;
      _hasMotionPreference = true;
      _applyMotionPreference();
    }
  }

  @override
  void didChangeAccessibilityFeatures() {
    final reduceMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .reduceMotion;
    if (reduceMotion == _systemReduceMotion) return;
    _systemReduceMotion = reduceMotion;
    _applyMotionPreference();
  }

  void _syncAnimation() {
    if (!widget.connected) {
      _stopAnimationsForDisconnect();
      return;
    }
    if (_reduceMotion) {
      _applyReducedMotionState();
      return;
    }
    if (widget.kind == JexAnimatedIconKind.peltier &&
        widget.active &&
        !frostTransitionController.isAnimating &&
        frostTransitionController.value == 0) {
      frostTransitionController.forward(from: 0);
    }

    if (widget.kind == JexAnimatedIconKind.fan) {
      // Fan rotation has its own unbounded phase simulation; the normalized cycle
      // controller must not compete with or reset the mechanical rotation phase.
      controller.stop();
      if (widget.active) {
        if (!fanPhaseController.isAnimating) {
          _fanCoasting = false;
          _launchFanRotationRetarget(
            jexFanRotationCyclesPerSecond(
              voltageLevel: widget.voltageLevel,
              fanSpeedLevel: widget.level,
            ),
            transition: const Duration(milliseconds: 360),
          );
        }
      } else if (!_fanCoasting) {
        fanPhaseController.stop();
        _fanRotationSimulation = null;
        _fanTargetCyclesPerSecond = 0.0;
      }
      return;
    }

    final animationPermitted = jexIconAnimationPermitted(
      connected: widget.connected,
      kind: widget.kind,
      stateActive: widget.active,
      continuousLoop: widget.continuousLoop,
    );
    if (!animationPermitted) {
      controller.stop();
      controller.value = 0;
      activityTransitionController.stop();
      activityTransitionController.value = 0;
      return;
    }
    if (!controller.isAnimating) _resumeCycleWithoutPhaseSnap();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _systemReduceMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .reduceMotion;
    controller = AnimationController(
      vsync: this,
      duration: jexIconAnimationDuration(
        widget.kind,
        voltageLevel: widget.voltageLevel,
        fanSpeedLevel: widget.level,
      ),
    );
    fanPhaseController = AnimationController.unbounded(vsync: this, value: 0.0);
    activityTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
      value: widget.active ? 1 : 0,
    );
    _frostFromIntensity = jexPeltierFrostIntensity(widget.voltageLevel);
    _frostFromParticleCount = jexPeltierFrostParticleCount(widget.voltageLevel)
        .toDouble();
    frostTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..value = widget.kind == JexAnimatedIconKind.peltier ? 0 : 1;
    final initialSpeedLevel =
        widget.kind == JexAnimatedIconKind.speed && widget.active
        ? widget.level.clamp(0.0, 1.0).toDouble()
        : 0.0;
    _speedFromLevel = initialSpeedLevel;
    _speedTargetLevel = initialSpeedLevel;
    _indicatorLevelFrom = widget.level.clamp(0.0, 1.0).toDouble();
    _indicatorLevelTarget = _indicatorLevelFrom;
    indicatorLevelTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..value = 1;
    _warningFromLevel = widget.warning ? 1.0 : 0.0;
    _warningTargetLevel = _warningFromLevel;
    warningTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..value = 1;
    speedLevelTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..value = 1;
  }

  @override
  void didUpdateWidget(covariant JexAnimatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.connected) {
      _stopAnimationsForDisconnect();
      return;
    }
    if (widget.warning != oldWidget.warning ||
        widget.connected != oldWidget.connected) {
      _retargetWarningLevel(widget.connected && widget.warning);
    }
    if (widget.active != oldWidget.active) {
      if (widget.active) {
        _fanCoasting = false;
        unawaited(_animateActivityTransition(true));
      } else if (widget.kind != JexAnimatedIconKind.fan) {
        // Non-mechanical outputs settle to their stable OFF pose immediately.
        activityTransitionController.stop();
        activityTransitionController.value = 0;
      }
      // The connected Fan takes the separate phase-continuous coast path below.
    }
    if (widget.kind != oldWidget.kind) {
      indicatorLevelTransitionController.stop();
      _indicatorLevelFrom = widget.level.clamp(0.0, 1.0).toDouble();
      _indicatorLevelTarget = _indicatorLevelFrom;
      indicatorLevelTransitionController.value = 1;
    } else if (widget.kind != JexAnimatedIconKind.speed &&
        widget.kind != JexAnimatedIconKind.generic &&
        widget.level != oldWidget.level) {
      _retargetIndicatorLevel(widget.level);
    }
    final voltageChanged = widget.voltageLevel != oldWidget.voltageLevel;
    final fanVoltageChanged =
        widget.kind == JexAnimatedIconKind.fan && voltageChanged;
    final fanSpeedChanged =
        widget.kind == JexAnimatedIconKind.fan &&
        widget.level != oldWidget.level;
    final peltierVisualChanged =
        widget.kind == JexAnimatedIconKind.peltier &&
        (voltageChanged || widget.active != oldWidget.active);
    final speedVisualChanged =
        widget.kind == JexAnimatedIconKind.speed &&
        (oldWidget.kind != JexAnimatedIconKind.speed ||
            widget.active != oldWidget.active ||
            widget.valueKnown != oldWidget.valueKnown ||
            (widget.active && widget.level != oldWidget.level));

    if (speedVisualChanged) {
      _retargetSpeedLevel(
        widget.active && widget.valueKnown ? widget.level : 0.0,
        duration: widget.active
            ? const Duration(milliseconds: 420)
            : const Duration(milliseconds: 520),
      );
    } else if (oldWidget.kind == JexAnimatedIconKind.speed &&
        widget.kind != JexAnimatedIconKind.speed) {
      speedLevelTransitionController.stop();
    }

    if (widget.kind != oldWidget.kind) {
      if (widget.kind == JexAnimatedIconKind.fan) {
        controller.stop();
        controller.value = 0.0;
      } else {
        controller.duration = jexIconAnimationDuration(
          widget.kind,
          voltageLevel: widget.voltageLevel,
          fanSpeedLevel: widget.level,
        );
        controller.reset();
      }
    }

    if (oldWidget.kind == JexAnimatedIconKind.fan &&
        widget.kind != JexAnimatedIconKind.fan) {
      _resetFanRotation();
    }

    final fanActivationChanged =
        widget.kind == JexAnimatedIconKind.fan &&
        widget.active != oldWidget.active;
    if (widget.kind == JexAnimatedIconKind.fan &&
        widget.active &&
        (widget.kind != oldWidget.kind ||
            fanVoltageChanged ||
            fanSpeedChanged ||
            fanActivationChanged)) {
      _fanCoasting = false;
      _launchFanRotationRetarget(
        jexFanRotationCyclesPerSecond(
          voltageLevel: widget.voltageLevel,
          fanSpeedLevel: widget.level,
        ),
        transition: const Duration(milliseconds: 420),
      );
    }

    if (peltierVisualChanged) {
      // Retarget from the currently displayed frost state on voltage or ON/OFF changes.
      // If another change arrives mid-transition, continue from the interpolated value.
      final previousT = Curves.easeInOutCubic.transform(
        frostTransitionController.value,
      );
      final previousIntensity = jexPeltierFrostIntensity(
        oldWidget.voltageLevel,
      );
      final previousCount = jexPeltierFrostParticleCount(oldWidget.voltageLevel)
          .toDouble();
      _frostFromIntensity +=
          (previousIntensity - _frostFromIntensity) * previousT;
      _frostFromParticleCount +=
          (previousCount - _frostFromParticleCount) * previousT;
      if (widget.active) {
        // Voltage classes interpolate smoothly, but OFF itself never fades the
        // crystal. When OFF, freeze the currently displayed crystal appearance.
        frostTransitionController.duration = const Duration(milliseconds: 420);
        frostTransitionController.forward(from: 0);
      } else {
        frostTransitionController.stop();
        frostTransitionController.value = 0;
      }
    }

    if (widget.kind == JexAnimatedIconKind.fan &&
        oldWidget.active &&
        !widget.active) {
      unawaited(_coastFanToStop());
    }
    _syncAnimation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    fanPhaseController.dispose();
    activityTransitionController.dispose();
    frostTransitionController.dispose();
    speedLevelTransitionController.dispose();
    indicatorLevelTransitionController.dispose();
    warningTransitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[
          controller,
          fanPhaseController,
          activityTransitionController,
          frostTransitionController,
          speedLevelTransitionController,
          indicatorLevelTransitionController,
          warningTransitionController,
        ]),
        builder: (_, __) {
          final frostT = Curves.easeInOutCubic.transform(
            frostTransitionController.value,
          );
          final frostTargetIntensity = jexPeltierFrostIntensity(
            widget.voltageLevel,
          );
          final frostTargetCount = jexPeltierFrostParticleCount(
            widget.voltageLevel,
          ).toDouble();
          final frostIntensity =
              _frostFromIntensity +
              (frostTargetIntensity - _frostFromIntensity) * frostT;
          final frostParticleCount =
              _frostFromParticleCount +
              (frostTargetCount - _frostFromParticleCount) * frostT;
          final displayedLevel = widget.kind == JexAnimatedIconKind.speed
              ? _currentSpeedLevel()
              : _currentIndicatorLevel();
          return CustomPaint(
            size: Size.square(widget.size),
            painter: _JexIconPainter(
              kind: widget.kind,
              color: widget.color,
              progress: widget.kind == JexAnimatedIconKind.fan
                  ? jexNormalizedFanProgress(fanPhaseController.value)
                  : controller.value,
              active: widget.active,
              activity: activityTransitionController.value,
              level: displayedLevel,
              voltageLevel: widget.voltageLevel,
              frostIntensityOverride: frostIntensity,
              frostParticleCountOverride: frostParticleCount,
              warningStrength: _currentWarningLevel(),
              valueKnown: widget.valueKnown,
              fanCoasting: _fanCoasting,
              lightTheme: widget.lightTheme,
              lightSurfaceColor: widget.lightSurfaceColor,
              lightOutlineColor: widget.lightOutlineColor,
            ),
          );
        },
      ),
    );
  }
}

class _JexIconPainter extends CustomPainter {
  final JexAnimatedIconKind kind;
  final Color color;
  final double progress;
  final bool active;
  final double activity;
  final double level;
  final int voltageLevel;
  final double? frostIntensityOverride;
  final double? frostParticleCountOverride;
  final double warningStrength;
  final bool valueKnown;
  final bool fanCoasting;
  final bool lightTheme;
  final Color lightSurfaceColor;
  final Color lightOutlineColor;

  const _JexIconPainter({
    required this.kind,
    required this.color,
    required this.progress,
    required this.active,
    required this.activity,
    required this.level,
    required this.voltageLevel,
    required this.frostIntensityOverride,
    required this.frostParticleCountOverride,
    required this.warningStrength,
    required this.valueKnown,
    required this.fanCoasting,
    required this.lightTheme,
    required this.lightSurfaceColor,
    required this.lightOutlineColor,
  });

  Color _depthPaintColor(
    Color darkColor, {
    required double darkAlpha,
    required double lightAlpha,
  }) => lightTheme
      ? lightOutlineColor.withValues(alpha: lightAlpha)
      : darkColor.withValues(alpha: darkAlpha);

  Color _cavityPaintColor(Color darkColor, {required double darkAlpha}) =>
      lightTheme ? lightSurfaceColor : darkColor.withValues(alpha: darkAlpha);

  Paint _stroke(double width, Color paintColor) => Paint()
    ..color = paintColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint _fill(Color paintColor) => Paint()
    ..color = paintColor
    ..style = PaintingStyle.fill;

  void _drawGlow(
    Canvas canvas,
    Path path,
    Color glowColor,
    double strokeWidth,
    double blurRadius,
    double alpha,
  ) {
    if (alpha <= .005) return;
    final paint = _stroke(strokeWidth, glowColor.withValues(alpha: alpha));
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);
    canvas.drawPath(path, paint);
  }

  /// Draws an outline-following electric pulse around the closed bolt silhouette.
  /// Both pulses travel only on the outer contour; the lightning centre stays static.
  void _drawVoltageEdgePulse(
    Canvas canvas,
    Path outline,
    double s,
    double progress,
    Color edgeColor,
    double intensity,
  ) {
    final strength = intensity.clamp(0.0, 1.0).toDouble();
    if (strength <= .005) return;
    final metrics = outline.computeMetrics().toList();
    if (metrics.isEmpty || metrics.first.length <= 0) return;

    final metric = metrics.first;
    final length = metric.length;
    final segmentLength = length * (.12 + .025 * strength);
    for (var i = 0; i < 2; i++) {
      final head = (progress * length + i * length * .5) % length;
      final tail = head - segmentLength;
      final segment = Path();
      if (tail < 0) {
        segment.addPath(metric.extractPath(length + tail, length), Offset.zero);
        if (head > 0) {
          segment.addPath(metric.extractPath(0, head), Offset.zero);
        }
      } else if (head > tail) {
        segment.addPath(metric.extractPath(tail, head), Offset.zero);
      }
      if (segment.computeMetrics().isEmpty) continue;

      final pulseStrength = i == 0 ? 1.0 : .58;
      final alpha = pulseStrength * (.55 + .45 * strength);
      _drawGlow(canvas, segment, edgeColor, s * .105, s * .030, .34 * alpha);
      canvas.drawPath(
        segment,
        _stroke(s * .046, Colors.white.withValues(alpha: .62 * alpha)),
      );
      canvas.drawPath(
        segment,
        _stroke(s * .018, edgeColor.withValues(alpha: .96 * alpha)),
      );
    }
  }

  Path _batterySilhouette(double s) => Path()
    ..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * .12, s * .26, s * .70, s * .48),
        Radius.circular(s * .085),
      ),
    )
    ..addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * .82, s * .405, s * .075, s * .19),
        Radius.circular(s * .025),
      ),
    );

  // One continuous outer contour avoids a seam where the thermometer tube meets its bulb.
  Path _hotsideSilhouette(double s) => Path()
    ..moveTo(s * .425, s * .135)
    ..cubicTo(s * .425, s * .09, s * .455, s * .065, s * .50, s * .065)
    ..cubicTo(s * .545, s * .065, s * .575, s * .09, s * .575, s * .135)
    ..lineTo(s * .575, s * .605)
    ..cubicTo(s * .575, s * .645, s * .607, s * .67, s * .625, s * .705)
    ..cubicTo(s * .67, s * .785, s * .615, s * .875, s * .545, s * .90)
    ..cubicTo(s * .515, s * .91, s * .485, s * .91, s * .455, s * .90)
    ..cubicTo(s * .385, s * .875, s * .33, s * .785, s * .375, s * .705)
    ..cubicTo(s * .393, s * .67, s * .425, s * .645, s * .425, s * .605)
    ..close();

  Path _bolt(double s) => Path()
    ..moveTo(s * .57, s * .07)
    ..lineTo(s * .27, s * .52)
    ..lineTo(s * .475, s * .52)
    ..lineTo(s * .405, s * .925)
    ..lineTo(s * .755, s * .37)
    ..lineTo(s * .545, s * .37)
    ..close();

  // Every vertex is inset within the bolt; the drawing code also clips the core
  // to the outer silhouette to prevent any antialiased white pixels escaping.
  Path _boltInnerCore(double s) => Path()
    ..moveTo(s * .525, s * .165)
    ..lineTo(s * .365, s * .485)
    ..lineTo(s * .495, s * .485)
    ..lineTo(s * .445, s * .805)
    ..lineTo(s * .685, s * .405)
    ..lineTo(s * .555, s * .405)
    ..lineTo(s * .535, s * .285)
    ..close();

  void _drawAdaptiveArrowHead(
    Canvas canvas,
    Offset tip,
    double direction,
    double length,
    Color color,
  ) {
    final wingA = Offset(
      tip.dx - math.cos(direction - .72) * length,
      tip.dy - math.sin(direction - .72) * length,
    );
    final wingB = Offset(
      tip.dx - math.cos(direction + .72) * length,
      tip.dy - math.sin(direction + .72) * length,
    );
    final arrow = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(wingA.dx, wingA.dy)
      ..lineTo(wingB.dx, wingB.dy)
      ..close();
    canvas.drawPath(arrow, _fill(color));
  }

  // Two directional arcs travel around the cycle instead of morphing into an empty ring.
  // Active Adaptive uses directional arcs; its OFF glyph remains full-colour.
  void _drawAdaptiveFlow(
    Canvas canvas,
    double s,
    double phase,
    Color color,
    double strength,
  ) {
    final center = Offset(s / 2, s / 2);
    final radius = s * .29;
    final orbit = Rect.fromCircle(center: center, radius: radius);
    final wave = (math.sin(phase * 2) + 1) / 2;
    final flowStrength = strength.clamp(0.0, 1.0).toDouble();
    // Recessed track keeps the OFF/disconnected pose intentional rather than empty.
    canvas.drawCircle(
      center,
      radius,
      _stroke(
        s * .052,
        _depthPaintColor(
          const Color(0xFF090C12),
          darkAlpha: .76,
          lightAlpha: .42,
        ),
      ),
    );
    canvas.drawCircle(
      center,
      radius,
      _stroke(s * .028, color.withValues(alpha: .24 + .08 * flowStrength)),
    );
    for (var i = 0; i < 2; i++) {
      final start = phase + i * math.pi;
      const sweep = 2.28;
      final tint = color.withValues(
        alpha: .82 + .14 * math.sin(phase + i * math.pi).abs(),
      );
      // Each directional arrow has a soft luminous core, consistent with the thermal
      // and electrical glyphs without changing the rotating two-arrow silhouette.
      final arcPath = Path()..addArc(orbit, start, sweep);
      if (flowStrength > .01) {
        _drawGlow(canvas, arcPath, tint, s * .12, s * .035, .16 * flowStrength);
      }
      canvas.drawArc(
        orbit,
        start,
        sweep,
        false,
        _stroke(
          s * .115,
          _depthPaintColor(
            const Color(0xFF090C12),
            darkAlpha: .90,
            lightAlpha: .52,
          ),
        ),
      );
      canvas.drawArc(
        orbit,
        start,
        sweep,
        false,
        _stroke(s * .085, tint.withValues(alpha: .24 + .08 * flowStrength)),
      );
      canvas.drawArc(orbit, start, sweep, false, _stroke(s * .070, tint));
      canvas.drawArc(
        orbit,
        start,
        sweep,
        false,
        _stroke(
          s * .022,
          Colors.white.withValues(alpha: .22 + .26 * flowStrength),
        ),
      );
      final end = start + sweep;
      final tip = Offset(
        center.dx + math.cos(end) * radius,
        center.dy + math.sin(end) * radius,
      );
      _drawAdaptiveArrowHead(
        canvas,
        tip,
        end + math.pi / 2,
        s * (.135 + .010 * wave),
        tint,
      );
    }
  }

  Path _crystalSilhouette(double s) {
    final cx = s / 2;
    final cy = s / 2;
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final a = -math.pi / 2 + i * math.pi / 3;
      final outer = Offset(
        cx + math.cos(a) * s * .34,
        cy + math.sin(a) * s * .34,
      );
      final branchA = Offset(
        cx + math.cos(a - .24) * s * .22,
        cy + math.sin(a - .24) * s * .22,
      );
      final branchB = Offset(
        cx + math.cos(a + .24) * s * .22,
        cy + math.sin(a + .24) * s * .22,
      );
      path
        ..moveTo(cx, cy)
        ..lineTo(outer.dx, outer.dy)
        ..moveTo(branchA.dx, branchA.dy)
        ..lineTo(outer.dx, outer.dy)
        ..lineTo(branchB.dx, branchB.dy);
    }
    return path;
  }

  Offset _fanPoint(double x, double y, double angle, double cx, double cy) =>
      Offset(
        cx + x * math.cos(angle) - y * math.sin(angle),
        cy + x * math.sin(angle) + y * math.cos(angle),
      );

  Path _fanSilhouette(double s, double angle) {
    final cx = s / 2;
    final cy = s / 2;
    final path = Path();
    // Exactly three broad swept blades: a recognizable three-blade cooler fan.
    for (var i = 0; i < 3; i++) {
      final a = angle + i * math.pi * 2 / 3;
      final p0 = _fanPoint(-s * .018, s * .055, a, cx, cy);
      final p1 = _fanPoint(-s * .045, s * .012, a, cx, cy);
      final p2 = _fanPoint(-s * .150, -s * .060, a, cx, cy);
      final p3 = _fanPoint(-s * .155, -s * .205, a, cx, cy);
      final p4 = _fanPoint(-s * .075, -s * .365, a, cx, cy);
      final p5 = _fanPoint(s * .015, -s * .405, a, cx, cy);
      final p6 = _fanPoint(s * .090, -s * .335, a, cx, cy);
      final p7 = _fanPoint(s * .105, -s * .205, a, cx, cy);
      final p8 = _fanPoint(s * .065, -s * .075, a, cx, cy);
      path
        ..moveTo(p0.dx, p0.dy)
        ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy)
        ..cubicTo(p4.dx, p4.dy, p5.dx, p5.dy, p6.dx, p6.dy)
        ..cubicTo(p7.dx, p7.dy, p8.dx, p8.dy, p0.dx, p0.dy)
        ..close();
    }
    path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: s * .090));
    return path;
  }

  Path _fanBladeHighlightPath(double s, double angle, int bladeIndex) {
    final cx = s / 2;
    final cy = s / 2;
    final a = angle + bladeIndex * math.pi * 2 / 3;
    final p0 = _fanPoint(-s * .006, -s * .095, a, cx, cy);
    final p1 = _fanPoint(-s * .045, -s * .165, a, cx, cy);
    final p2 = _fanPoint(-s * .047, -s * .255, a, cx, cy);
    final p3 = _fanPoint(s * .012, -s * .335, a, cx, cy);
    return Path()
      ..moveTo(p0.dx, p0.dy)
      ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
  }

  Path _flameTonguePath(
    double centerX,
    double baseline,
    double height,
    double halfWidth, {
    double lean = 0.0,
  }) {
    final tipY = baseline - height;
    final tipX = centerX + lean;
    return Path()
      ..moveTo(centerX - halfWidth, baseline)
      ..cubicTo(
        centerX - halfWidth * 1.05,
        baseline - height * .24,
        tipX - halfWidth * .24,
        tipY + height * .24,
        tipX,
        tipY,
      )
      ..cubicTo(
        tipX + halfWidth * .22,
        tipY + height * .25,
        centerX + halfWidth * 1.05,
        baseline - height * .24,
        centerX + halfWidth,
        baseline,
      )
      ..close();
  }

  /// Draw refined falling flames in the background, outside the thermal silhouette.
  /// The rounded-frame clip prevents any ember from leaking through the tile corners.
  /// Deterministic phase lanes keep motion smooth and free from per-frame randomness.
  void _drawThermalBurstParticles(
    Canvas canvas,
    double s,
    double phase,
    Color hotColor,
    double intensity, {
    required Rect bounds,
    required bool thermometer,
    required Path foregroundSilhouette,
  }) {
    final strength = intensity.clamp(0.0, 1.0).toDouble();
    if (strength <= .005 || bounds.isEmpty) return;

    final cycle = (phase / (math.pi * 2)) % 1.0;
    final lanes = thermometer
        ? const <double>[-.72, -.24, .24, .72]
        : const <double>[-.82, -.50, -.18, .18, .50, .82];
    final emberColor = Color.lerp(hotColor, const Color(0xFFFF7828), .62)!;
    final roundedFrame = RRect.fromRectAndRadius(
      bounds,
      Radius.circular(s * .22),
    );
    final fireBackdrop = Path.combine(
      PathOperation.difference,
      Path()..addRRect(roundedFrame),
      foregroundSilhouette,
    );

    canvas.save();
    canvas.clipRRect(roundedFrame);
    canvas.clipPath(fireBackdrop);
    for (var i = 0; i < lanes.length; i++) {
      final fall = (cycle + i / lanes.length) % 1.0;
      final edgeFade = jexParticleBoundaryFade(fall, fadeIn: .18, fadeOut: .22);
      final alpha = edgeFade * strength;
      if (alpha <= .01) continue;

      final travel = jexMotionSmoothStep(fall);
      final lane = lanes[i];
      final laneOffset = lane * s * .43;
      final drift = math.sin(fall * math.pi * 2 + i * .73) * s * .018;
      final x = bounds.center.dx + laneOffset + drift;
      final fallDistance = bounds.height + s * .18;
      final y = bounds.top - s * .12 + travel * fallDistance;
      final sizePulse = .82 + .18 * math.sin(math.pi * fall);
      final radiusX =
          s * (thermometer ? .043 : .047) * sizePulse * (i.isEven ? 1.0 : .88);
      final radiusY = radiusX * (thermometer ? 1.65 : 1.58);
      final rotation =
          .24 * math.sin(fall * math.pi * 2 + i * .71) +
          (lane < 0 ? -.08 : .08);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final haloPaint = _fill(emberColor.withValues(alpha: .20 * alpha));
      haloPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, radiusX * 1.15);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, radiusY * .08),
          width: radiusX * 3.4,
          height: radiusY * 2.8,
        ),
        haloPaint,
      );

      // A compact flame silhouette reads as fire instead of a row of oval dots.
      final flameShape = Path()
        ..moveTo(0, -radiusY * 1.25)
        ..cubicTo(
          radiusX * 1.05,
          -radiusY * .68,
          radiusX * 1.12,
          radiusY * .28,
          radiusX * .28,
          radiusY * .84,
        )
        ..quadraticBezierTo(0, radiusY * 1.10, -radiusX * .26, radiusY * .82)
        ..cubicTo(
          -radiusX * 1.08,
          radiusY * .30,
          -radiusX * .72,
          -radiusY * .66,
          0,
          -radiusY * 1.25,
        )
        ..close();
      canvas.drawPath(
        flameShape,
        _fill(emberColor.withValues(alpha: .98 * alpha)),
      );

      final flameCore = Path()
        ..moveTo(0, -radiusY * .43)
        ..cubicTo(
          radiusX * .50,
          -radiusY * .04,
          radiusX * .32,
          radiusY * .43,
          0,
          radiusY * .61,
        )
        ..cubicTo(
          -radiusX * .31,
          radiusY * .38,
          -radiusX * .34,
          radiusY * .08,
          0,
          -radiusY * .43,
        )
        ..close();
      canvas.drawPath(
        flameCore,
        _fill(const Color(0xFFFFEDB5).withValues(alpha: .98 * alpha)),
      );

      final hotCore = Path()
        ..moveTo(-radiusX * .04, -radiusY * .05)
        ..quadraticBezierTo(radiusX * .19, radiusY * .22, 0, radiusY * .42)
        ..quadraticBezierTo(
          -radiusX * .14,
          radiusY * .22,
          -radiusX * .04,
          -radiusY * .05,
        )
        ..close();
      canvas.drawPath(
        hotCore,
        _fill(Colors.white.withValues(alpha: .88 * alpha)),
      );
      canvas.restore();
    }
    canvas.restore();
  }

  void _drawSnowflake(
    Canvas canvas,
    Offset center,
    double radius,
    double rotation,
    Color snowColor,
    double alpha,
  ) {
    final paint = _stroke(radius * .25, snowColor.withValues(alpha: alpha));
    for (var axis = 0; axis < 3; axis++) {
      final angle = rotation + axis * math.pi / 3;
      final direction = Offset(math.cos(angle), math.sin(angle));
      final a = center - direction * radius;
      final b = center + direction * radius;
      canvas.drawLine(a, b, paint);

      for (final sign in <double>[-1, 1]) {
        final branchBase = center + direction * (radius * .62 * sign);
        final outwardAngle = angle + (sign > 0 ? 0 : math.pi);
        for (final branchSide in <double>[-1, 1]) {
          final branchAngle = outwardAngle + branchSide * 2.20;
          final branchEnd =
              branchBase +
              Offset(math.cos(branchAngle), math.sin(branchAngle)) *
                  (radius * .34);
          canvas.drawLine(branchBase, branchEnd, paint);
        }
      }
    }
  }

  void _drawFrostParticles(
    Canvas canvas,
    double s,
    double phase,
    Color frostColor, {
    required double intensity,
    required double particleCount,
    required bool moving,
  }) {
    final strength = intensity.clamp(0.0, 1.0).toDouble();
    if (!moving || strength <= .005) return;
    final count = particleCount.round().clamp(3, 7).toInt();
    final cx = s / 2;
    final cycle = (phase / (math.pi * 2)) % 1.0;
    const lanes = <double>[-.31, -.20, -.08, .08, .20, .31, 0.0];

    // Particles start/end outside the clipping region; edge fades conceal the wrap.
    // Drift and rotation use each particle's own phase and integer harmonics.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, s, s));
    for (var i = 0; i < count; i++) {
      final seed = i * 2.399963229728653;
      final fall = moving ? (cycle + i / count) % 1.0 : .16 + (i / count) * .66;
      final particleAngle = fall * math.pi * 2 + seed;
      final drift =
          math.sin(particleAngle) * .035 + math.sin(particleAngle * 2) * .012;
      final x = cx + s * lanes[i % lanes.length] + (moving ? drift * s : 0.0);
      final y = s * (-.12 + fall * 1.24);
      final radius = s * (.080 + .012 * strength) * (.82 + .10 * (i % 3));
      final rotation = moving
          ? seed + fall * math.pi * .28 * (i.isEven ? 1.0 : -1.0)
          : seed * .25;
      final edgeFade = moving
          ? jexParticleBoundaryFade(fall, fadeIn: .18, fadeOut: .22)
          : 1.0;
      final alpha =
          (.52 + .42 * strength) * (.88 + .12 * ((i % 3) / 2)) * edgeFade;
      if (alpha <= .01) continue;
      final snowColor = i % 4 == 0 ? Colors.white : frostColor;
      _drawSnowflake(canvas, Offset(x, y), radius, rotation, snowColor, alpha);
    }
    canvas.restore();
  }

  void _drawFanAirflow(
    Canvas canvas,
    double s,
    Color airColor, {
    required double opacity,
  }) {
    final strength = opacity.clamp(0.0, 1.0).toDouble();
    if (strength <= .005) return;

    final center = Offset(s / 2, s / 2);
    Offset point(double angle, double radius) => Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );

    // Three fixed airflow ribbons stay behind the rotor. Their count, geometry,
    // stroke and colour do not respond to voltage/PWM; only the blades accelerate.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(s * .10, s * .10, s * .80, s * .80));
    const sweep = 1.10;
    for (var i = 0; i < 3; i++) {
      final radius = s * (.255 + i * .037);
      final startAngle = -math.pi * .83 + i * (math.pi * 2 / 3);
      final endAngle = startAngle + sweep;
      final start = point(startAngle, radius);
      final end = point(endAngle, radius);
      final tangentScale = radius * sweep * .38;
      final control1 =
          start +
          Offset(-math.sin(startAngle), math.cos(startAngle)) * tangentScale;
      final control2 =
          end - Offset(-math.sin(endAngle), math.cos(endAngle)) * tangentScale;
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(
          control1.dx,
          control1.dy,
          control2.dx,
          control2.dy,
          end.dx,
          end.dy,
        );
      canvas.drawPath(
        path,
        _stroke(s * .040, airColor.withValues(alpha: .22 * strength)),
      );
      canvas.drawPath(
        path,
        _stroke(s * .014, airColor.withValues(alpha: .66 * strength)),
      );
    }
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final strength = activity.clamp(0.0, 1.0).toDouble();
    final p = progress.clamp(0.0, 1.0).toDouble();
    final angle = p * math.pi * 2;
    final safeLevel = level.clamp(0.0, 1.0).toDouble();
    // Keep thermal tint steady; only the existing 280 ms warning transition eases in/out.
    final warningBlend = active ? .16 * warningStrength : 0.0;
    final mainColor = Color.lerp(color, const Color(0xFFFF5B55), warningBlend)!;
    // The semantic glyph colour and opacity never depend on ON/OFF state.
    const opacity = 1.0;

    switch (kind) {
      case JexAnimatedIconKind.battery:
        final shell = _batterySilhouette(s);
        if (active && warningStrength > .005) {
          _drawThermalBurstParticles(
            canvas,
            s,
            angle,
            jexThermalRed,
            warningStrength,
            bounds: Rect.fromLTWH(0, 0, s, s),
            thermometer: false,
            foregroundSilhouette: shell,
          );
        }
        canvas.drawPath(
          shell.shift(Offset(s * .014, s * .018)),
          _fill(
            _depthPaintColor(
              const Color(0xFF060A10),
              darkAlpha: .72,
              lightAlpha: .46,
            ),
          ),
        );
        canvas.drawPath(
          shell,
          _stroke(s * .092, Colors.white.withValues(alpha: .16)),
        );
        _drawGlow(
          canvas,
          shell,
          jexThermalRed,
          s * .10,
          s * .035,
          active ? .16 * warningStrength : 0.0,
        );
        canvas.drawPath(shell, _fill(mainColor.withValues(alpha: .16)));
        canvas.drawPath(
          shell,
          _stroke(s * .045, mainColor.withValues(alpha: opacity)),
        );
        final inner = RRect.fromRectAndRadius(
          Rect.fromLTWH(s * .17, s * .31, s * .60, s * .38),
          Radius.circular(s * .055),
        );
        canvas.drawRRect(
          inner,
          _fill(_cavityPaintColor(const Color(0xFF09121A), darkAlpha: .92)),
        );
        canvas.drawRRect(
          inner,
          _stroke(s * .022, mainColor.withValues(alpha: .74)),
        );
        canvas.save();
        canvas.clipRRect(inner);
        if (!valueKnown) {
          // A quiet thermal emblem completes the unknown-state battery without
          // showing a level or using warning red when no temperature is available.
          for (var i = 0; i < 3; i++) {
            final centerX = inner.left + inner.width * (.25 + i * .25);
            final flame = _flameTonguePath(
              centerX,
              inner.bottom - s * .018,
              s * (.125 + (i == 1 ? .025 : 0.0)),
              s * .038,
              lean: (i - 1) * s * .010,
            );
            canvas.drawPath(
              flame,
              _fill(mainColor.withValues(alpha: i == 1 ? .42 : .30)),
            );
            canvas.drawPath(
              flame,
              _stroke(s * .008, Colors.white.withValues(alpha: .28)),
            );
          }
        }
        final fluidHeight = inner.height * safeLevel;
        if (valueKnown && fluidHeight > 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              inner.left,
              inner.bottom - fluidHeight,
              inner.width,
              fluidHeight,
            ),
            _fill(mainColor.withValues(alpha: .86)),
          );
          // Static bevel highlight: the old moving shine/idle scanline is intentionally removed.
          final sheenRect = Rect.fromLTWH(
            inner.left + inner.width * .10,
            inner.bottom - fluidHeight,
            inner.width * .075,
            fluidHeight,
          );
          canvas.drawRect(
            sheenRect,
            _fill(Colors.white.withValues(alpha: .18)),
          );
        }
        canvas.restore();
        break;

      case JexAnimatedIconKind.hotside:
        final shell = _hotsideSilhouette(s);
        if (active && warningStrength > .005) {
          _drawThermalBurstParticles(
            canvas,
            s,
            angle,
            jexThermalRed,
            warningStrength,
            bounds: Rect.fromLTWH(0, 0, s, s),
            thermometer: true,
            foregroundSilhouette: shell,
          );
        }
        canvas.drawPath(
          shell.shift(Offset(s * .010, s * .012)),
          _fill(
            _depthPaintColor(
              const Color(0xFF060A10),
              darkAlpha: .72,
              lightAlpha: .46,
            ),
          ),
        );
        canvas.drawPath(
          shell,
          _stroke(s * .092, Colors.white.withValues(alpha: .16)),
        );
        _drawGlow(
          canvas,
          shell,
          jexThermalRed,
          s * .10,
          s * .035,
          active ? .16 * warningStrength : 0.0,
        );
        canvas.drawPath(shell, _fill(mainColor.withValues(alpha: .16)));
        canvas.drawPath(
          shell,
          _stroke(s * .045, mainColor.withValues(alpha: opacity)),
        );
        final tubeInner = RRect.fromRectAndRadius(
          Rect.fromLTWH(s * .455, s * .09, s * .09, s * .53),
          Radius.circular(s * .045),
        );
        canvas.save();
        canvas.clipPath(shell);
        canvas.drawRRect(
          tubeInner,
          _fill(_cavityPaintColor(const Color(0xFF09121A), darkAlpha: .94)),
        );
        canvas.drawRRect(
          tubeInner,
          _stroke(s * .020, mainColor.withValues(alpha: .74)),
        );
        // Fixed instrument graduations remain visible in ON, OFF and unknown poses.
        for (var i = 0; i < 3; i++) {
          final tickY = s * (.30 + i * .105);
          canvas.drawLine(
            Offset(s * .355, tickY),
            Offset(s * .405, tickY),
            _stroke(s * .025, mainColor.withValues(alpha: .72)),
          );
          canvas.drawLine(
            Offset(s * .365, tickY - s * .012),
            Offset(s * .397, tickY - s * .012),
            _stroke(s * .008, Colors.white.withValues(alpha: .32)),
          );
        }
        canvas.save();
        canvas.clipRRect(tubeInner);
        final fluidHeight = tubeInner.height * safeLevel;
        if (valueKnown && fluidHeight > 0) {
          canvas.drawRect(
            Rect.fromLTWH(
              tubeInner.left,
              tubeInner.bottom - fluidHeight,
              tubeInner.width,
              fluidHeight,
            ),
            _fill(mainColor.withValues(alpha: .90)),
          );
          final sheenRect = Rect.fromLTWH(
            tubeInner.left + tubeInner.width * .18,
            tubeInner.bottom - fluidHeight,
            tubeInner.width * .34,
            fluidHeight,
          );
          canvas.drawRect(
            sheenRect,
            _fill(Colors.white.withValues(alpha: .28)),
          );
        }
        canvas.restore();
        final bulbRadius = s * (valueKnown ? (.040 + .035 * safeLevel) : .055);
        canvas.drawCircle(
          Offset(cx, s * .775),
          s * .100,
          _stroke(s * .020, mainColor.withValues(alpha: .52)),
        );
        canvas.drawCircle(
          Offset(cx, s * .775),
          bulbRadius,
          _fill(mainColor.withValues(alpha: valueKnown ? .90 : .60)),
        );
        canvas.drawCircle(
          Offset(cx - s * .018, s * .758),
          s * .021,
          _fill(Colors.white.withValues(alpha: valueKnown ? .52 : .40)),
        );
        canvas.restore();
        break;

      case JexAnimatedIconKind.voltage:
        final bolt = _bolt(s);
        canvas.drawPath(
          bolt.shift(Offset(s * .020, s * .018)),
          _fill(
            _depthPaintColor(
              const Color(0xFF070B12),
              darkAlpha: .74,
              lightAlpha: .46,
            ),
          ),
        );
        canvas.drawPath(
          bolt,
          _fill(mainColor.withValues(alpha: .64 + .24 * safeLevel)),
        );
        canvas.drawPath(
          bolt,
          _stroke(s * .045, Colors.white.withValues(alpha: .18)),
        );
        canvas.drawPath(
          bolt,
          _stroke(s * .022, mainColor.withValues(alpha: opacity)),
        );
        final innerCore = _boltInnerCore(s);
        canvas.save();
        canvas.clipPath(bolt);
        canvas.drawPath(innerCore, _fill(Colors.white.withValues(alpha: .20)));
        canvas.drawPath(
          innerCore,
          _stroke(s * .012, mainColor.withValues(alpha: .74)),
        );
        canvas.restore();
        if (active) {
          _drawGlow(canvas, bolt, mainColor, s * .10, s * .035, .18);
          _drawVoltageEdgePulse(canvas, bolt, s, p, mainColor, safeLevel);
        }
        break;

      case JexAnimatedIconKind.adaptive:
        _drawAdaptiveFlow(canvas, s, active ? angle : 0.0, mainColor, strength);
        break;

      case JexAnimatedIconKind.peltier:
        final crystal = _crystalSilhouette(s);
        final frostPower = (frostIntensityOverride ?? .5)
            .clamp(0.0, 1.0)
            .toDouble();
        final crystalWidth = s * (.058 + .006 * frostPower);
        final snowPhase = active ? angle : 0.0;
        // Keep the primary snowflake anchored; a tiny periodic rock does not compete
        // with the more legible falling particles or turn into a fast spinning star.
        final crystalRotation = active ? math.sin(angle) * .035 : 0.0;

        _drawFrostParticles(
          canvas,
          s,
          snowPhase,
          mainColor,
          intensity: frostPower,
          particleCount: frostParticleCountOverride ?? 3,
          moving: active,
        );

        canvas.save();
        if (active) {
          canvas.translate(cx, cy);
          canvas.rotate(crystalRotation);
          canvas.translate(-cx, -cy);
        }
        _drawGlow(
          canvas,
          crystal,
          mainColor,
          crystalWidth * 1.7,
          s * .028,
          active ? .20 * frostPower : 0.0,
        );
        canvas.drawPath(
          crystal,
          _stroke(
            crystalWidth * 1.60,
            _depthPaintColor(
              const Color(0xFF071019),
              darkAlpha: .92,
              lightAlpha: .52,
            ),
          ),
        );
        canvas.drawPath(
          crystal,
          _stroke(crystalWidth, mainColor.withValues(alpha: .98)),
        );
        canvas.drawPath(
          crystal,
          _stroke(
            crystalWidth * .34,
            Colors.white.withValues(alpha: active ? .38 : .24),
          ),
        );
        for (var i = 0; i < 6; i++) {
          final a = -math.pi / 2 + i * math.pi / 3;
          final branchPulse = (math.sin(angle * 2 - i * math.pi / 3) + 1) / 2;
          final outer = Offset(
            cx + math.cos(a) * s * .34,
            cy + math.sin(a) * s * .34,
          );
          final inner = Offset(
            cx + math.cos(a) * s * .13,
            cy + math.sin(a) * s * .13,
          );
          canvas.drawLine(
            inner,
            outer,
            _stroke(
              crystalWidth * (.42 + .30 * branchPulse),
              mainColor.withValues(
                alpha: .18 + .55 * frostPower * (.55 + .45 * branchPulse),
              ),
            ),
          );
        }
        // A small faceted core adds depth without changing the six-branch crystal silhouette.
        final core = Path()
          ..moveTo(cx, cy - s * .052)
          ..lineTo(cx + s * .038, cy)
          ..lineTo(cx, cy + s * .052)
          ..lineTo(cx - s * .038, cy)
          ..close();
        final coreShade = lightTheme
            ? lightSurfaceColor
            : const Color(0xFF0C2633);
        canvas.drawPath(
          core,
          _fill(
            Color.lerp(
              mainColor,
              coreShade,
              .32,
            )!.withValues(alpha: active ? .86 : .72),
          ),
        );
        canvas.drawPath(
          core,
          _stroke(s * .020, Colors.white.withValues(alpha: .76)),
        );
        final coreFacet = Path()
          ..moveTo(cx, cy - s * .030)
          ..lineTo(cx + s * .020, cy - s * .004)
          ..lineTo(cx, cy + s * .020)
          ..lineTo(cx - s * .020, cy - s * .004)
          ..close();
        canvas.drawPath(coreFacet, _fill(Colors.white.withValues(alpha: .46)));
        canvas.restore();
        break;

      case JexAnimatedIconKind.fan:
        // Airflow fades with the coast transition while the independent rotor simulation
        // continuously decelerates to zero angular velocity.
        final airflowProgress = active
            ? strength
            : (fanCoasting ? strength : 0.0);
        if (airflowProgress > .005) {
          _drawFanAirflow(canvas, s, mainColor, opacity: airflowProgress);
        }
        canvas.drawCircle(
          Offset(cx, cy),
          s * .405,
          _stroke(
            s * .042,
            _depthPaintColor(
              const Color(0xFF070B12),
              darkAlpha: .92,
              lightAlpha: .52,
            ),
          ),
        );
        canvas.drawCircle(
          Offset(cx, cy),
          s * .392,
          _stroke(s * .020, mainColor.withValues(alpha: .46)),
        );
        final rotor = _fanSilhouette(s, angle);
        if (active || fanCoasting) {
          _drawGlow(
            canvas,
            rotor,
            mainColor,
            s * .075,
            s * .025,
            .18 * strength,
          );
        }
        canvas.drawPath(rotor, _fill(mainColor.withValues(alpha: .98)));
        canvas.drawPath(
          rotor,
          _stroke(
            s * .022,
            _depthPaintColor(
              const Color(0xFF071019),
              darkAlpha: .90,
              lightAlpha: .52,
            ),
          ),
        );
        canvas.drawPath(
          rotor,
          _stroke(s * .012, mainColor.withValues(alpha: .94)),
        );
        for (var blade = 0; blade < 3; blade++) {
          canvas.drawPath(
            _fanBladeHighlightPath(s, angle, blade),
            _stroke(
              s * .022,
              Colors.white.withValues(alpha: active ? .42 : .28),
            ),
          );
        }
        final hubShade = lightTheme
            ? lightSurfaceColor
            : const Color(0xFF101319);
        final hubColor = Color.lerp(mainColor, hubShade, .48)!;
        canvas.drawCircle(
          Offset(cx, cy),
          s * .096,
          _fill(_cavityPaintColor(const Color(0xFF070B12), darkAlpha: 1.0)),
        );
        canvas.drawCircle(Offset(cx, cy), s * .084, _fill(hubColor));
        canvas.drawCircle(
          Offset(cx, cy),
          s * .074,
          _stroke(s * .014, Colors.white.withValues(alpha: .60)),
        );
        canvas.drawCircle(
          Offset(cx, cy),
          s * .026,
          _fill(mainColor.withValues(alpha: .95)),
        );
        canvas.drawCircle(
          Offset(cx - s * .010, cy - s * .010),
          s * .008,
          _fill(Colors.white.withValues(alpha: .76)),
        );
        break;

      case JexAnimatedIconKind.speed:
        final gauge = Rect.fromCircle(center: Offset(cx, cy), radius: s * .34);
        // A true half-circle maps OFF to the far left and 100% to the far right.
        const start = math.pi;
        const sweep = math.pi;
        canvas.drawArc(
          gauge,
          start,
          sweep,
          false,
          _stroke(
            s * .090,
            _depthPaintColor(
              const Color(0xFF070B12),
              darkAlpha: .96,
              lightAlpha: .52,
            ),
          ),
        );
        canvas.drawArc(
          gauge,
          start,
          sweep,
          false,
          _stroke(s * .055, mainColor.withValues(alpha: .30)),
        );
        canvas.drawArc(
          gauge,
          start,
          sweep,
          false,
          _stroke(s * .022, Colors.white.withValues(alpha: .18)),
        );
        const tickCount = 11;
        for (var i = 0; i < tickCount; i++) {
          final t = i / (tickCount - 1);
          final tickAngle = start + sweep * t;
          final majorTick = i.isEven || i == tickCount - 1;
          final inner = Offset(
            cx + math.cos(tickAngle) * s * (majorTick ? .270 : .292),
            cy + math.sin(tickAngle) * s * (majorTick ? .270 : .292),
          );
          final outer = Offset(
            cx + math.cos(tickAngle) * s * .335,
            cy + math.sin(tickAngle) * s * .335,
          );
          canvas.drawLine(
            inner,
            outer,
            _stroke(
              s * (majorTick ? .028 : .018),
              mainColor.withValues(alpha: majorTick ? .92 : .62),
            ),
          );
          if (majorTick) {
            final tickHighlight = Offset.lerp(inner, outer, .48)!;
            canvas.drawCircle(
              tickHighlight,
              s * .008,
              _fill(Colors.white.withValues(alpha: .42)),
            );
          }
        }
        if (valueKnown) {
          if (active && safeLevel > 0) {
            final activeArc = Path()..addArc(gauge, start, sweep * safeLevel);
            _drawGlow(canvas, activeArc, mainColor, s * .11, s * .035, .30);
            canvas.drawArc(
              gauge,
              start,
              sweep * safeLevel,
              false,
              _stroke(s * .052, mainColor.withValues(alpha: .96)),
            );
          }
          final needleAngle = start + sweep * safeLevel;
          final tip = Offset(
            cx + math.cos(needleAngle) * s * .265,
            cy + math.sin(needleAngle) * s * .265,
          );
          final needle = Path()
            ..moveTo(cx, cy)
            ..lineTo(tip.dx, tip.dy);
          _drawGlow(canvas, needle, mainColor, s * .12, s * .035, .36);
          canvas.drawPath(
            needle,
            _stroke(s * .060, mainColor.withValues(alpha: opacity)),
          );
        }
        canvas.drawCircle(
          Offset(cx, cy),
          s * .062,
          _fill(_cavityPaintColor(const Color(0xFF070B12), darkAlpha: 1.0)),
        );
        canvas.drawCircle(
          Offset(cx, cy),
          s * .050,
          _stroke(s * .018, mainColor.withValues(alpha: .88)),
        );
        final speedHubShade = lightTheme
            ? lightOutlineColor
            : const Color(0xFF171A22);
        canvas.drawCircle(
          Offset(cx, cy),
          s * .034,
          _fill(Color.lerp(mainColor, speedHubShade, .20)!),
        );
        canvas.drawCircle(
          Offset(cx - s * .008, cy - s * .009),
          s * .013,
          _fill(Colors.white.withValues(alpha: valueKnown ? .74 : .36)),
        );
        canvas.drawCircle(
          Offset(cx, cy),
          s * .020,
          _fill(mainColor.withValues(alpha: valueKnown ? opacity : .62)),
        );
        break;

      case JexAnimatedIconKind.led:
        final ledAngle = active ? angle : 0.0;
        final wave = Path();
        for (var i = 0; i <= 24; i++) {
          final x = s * (.12 + .76 * i / 24);
          final y =
              cy +
              math.sin(ledAngle - i * math.pi / 8) *
                  s *
                  (.10 + .045 * strength);
          if (i == 0)
            wave.moveTo(x, y);
          else
            wave.lineTo(x, y);
        }
        canvas.drawPath(
          wave,
          _stroke(s * .058, mainColor.withValues(alpha: opacity)),
        );
        final dotX = active ? s * (-.06 + 1.12 * p) : s * .12;
        final dotY =
            cy +
            math.sin(ledAngle - ((dotX / s - .12) / .76) * math.pi * 3) *
                s *
                (.10 + .045 * strength);
        canvas.save();
        canvas.clipRect(Rect.fromLTWH(0, 0, s, s));
        canvas.drawCircle(
          Offset(dotX, dotY),
          s * .045,
          _fill(mainColor.withValues(alpha: .82 + .14 * strength)),
        );
        canvas.restore();
        break;

      case JexAnimatedIconKind.bluetooth:
        final glyph = Path()
          ..moveTo(cx, s * .12)
          ..lineTo(s * .70, s * .29)
          ..lineTo(cx, s * .50)
          ..lineTo(s * .70, s * .71)
          ..lineTo(cx, s * .88)
          ..lineTo(cx, s * .12)
          ..moveTo(s * .20, s * .29)
          ..lineTo(s * .68, s * .71)
          ..moveTo(s * .20, s * .71)
          ..lineTo(s * .68, s * .29);
        // Connection status is represented by colour, not Bluetooth-icon motion.
        canvas.drawPath(
          glyph,
          _stroke(s * .06, mainColor.withValues(alpha: 1.0)),
        );
        break;

      case JexAnimatedIconKind.generic:
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _JexIconPainter oldDelegate) =>
      oldDelegate.kind != kind ||
      oldDelegate.color != color ||
      oldDelegate.progress != progress ||
      oldDelegate.active != active ||
      oldDelegate.activity != activity ||
      oldDelegate.level != level ||
      oldDelegate.voltageLevel != voltageLevel ||
      oldDelegate.warningStrength != warningStrength ||
      oldDelegate.valueKnown != valueKnown ||
      oldDelegate.fanCoasting != fanCoasting ||
      oldDelegate.frostIntensityOverride != frostIntensityOverride ||
      oldDelegate.frostParticleCountOverride != frostParticleCountOverride ||
      oldDelegate.lightTheme != lightTheme ||
      oldDelegate.lightSurfaceColor != lightSurfaceColor ||
      oldDelegate.lightOutlineColor != lightOutlineColor;
}
