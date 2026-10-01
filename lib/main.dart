/*
  AI-MEMORY / FILE CONTRACT
  File: main.dart
  Owns: JE Cooler Flutter application entry point, Dashboard UI, BLE/P1 session state,
        firmware telemetry mapping, command confirmation, OTA coordination, and UI presentation.
  State authority: firmware telemetry is authoritative for physical Fan/Peltier/Adaptive/LED state.
  Localization: every user-facing string must use JexText or JexText.phrase().
  English UI uses ON/OFF; Indonesia UI uses HIDUP/MATI.
  Language names are displayed as English / Indonesia.
  BLE protocol tokens such as FAN:ON, FAN:OFF, PELTIER:ON, ADAPTIVE:ON, RGB:OFF
  are machine protocol values and must never be translated.
  Floating Monitor receives the same live telemetry; it does not own a second BLE connection.
  Build/runtime rule: source edits here do not imply a build; Build App is explicit.
*/

/*
  AI MAINTENANCE MEMORY
  ---------------------
  Scope: Flutter/Android App only. Firmware source and BIN are external.

  Integration invariants:
  - BLE identity/protocol/UUIDs below are part of the JE X FYZ contract.
  - Firmware telemetry is authoritative for physical state and safety.
  - A BLE write is not proof that hardware changed permanently.
  - State-changing commands require the BLE sync/session gate.
  - Phone battery heartbeat and hotside telemetry remain 1 Hz.
  - Online OTA release metadata is read from Firebase Realtime Database; GitHub is binary-only.
  - Wi-Fi credentials stay in flutter_secure_storage.
  - Current OTA availability accepts any valid DIFFERENT firmware version.
  - Do not reintroduce legacy commands or blocking PROCESSING UI.

  Maintenance:
  - Prefer minimal, evidence-based fixes.
  - Check exact official APIs before replacing lifecycle/transport behavior.
  - Preserve these comments as project memory when refactoring.
*/

/*
  JE X FYZ / JE COOLER
  Horizon Cooler UI base + JE X FYZ / P1 protocol

  Core rules:
  - Horizon Cooler remains the visual/layout and Android foundation.
  - JE X FYZ uses firmware-owned state and an atomic P1 BLE sync/ready handshake.
  - Firebase App Check / Play Integrity remains enabled for app security. Firmware release metadata comes from Firebase Realtime Database; GitHub hosts only the firmware .bin.
  - Phone battery temperature is sent every 1 second while BLE is connected.
  - Manual voltage commands use a 1-second app guard matching firmware.
  - Adaptive ON/OFF always relies on firmware to return the selector to 5V.
  - BLE connection never replays local runtime state into the device.
  - Auto Connect is passive: it never requests BLE permission or turns Bluetooth on; it requires a known cooler identity and Bluetooth already enabled.
  - UI never pretends a command succeeded until device telemetry confirms it.
*/

// --- IMPORT BOUNDARY: Dart/Flutter and JE X FYZ plugin dependencies ---
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' show FrameTiming;

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'app_settings.dart';
import 'floating_monitor.dart';


// Premium icon system: Phosphor Icons (Regular/Bold).
// Material Icons are intentionally not used by JE X FYZ UI controls.
// --- PRODUCT/INTEGRATION CONSTANTS: identity, BLE UUIDs, OTA endpoint, UI limits ---
const String appName = 'JE Cooler';
const String headerName = 'JE X FYZ';
const String serviceUuid = '6f1c0001-7f35-4d0f-9b9a-7e9b2f5c1001';
const String rxUuid = '6f1c0002-7f35-4d0f-9b9a-7e9b2f5c1001';
const String txUuid = '6f1c0003-7f35-4d0f-9b9a-7e9b2f5c1001';
// AI-MEMORY: Firebase Realtime Database is the firmware release metadata/control plane. GitHub is binary-only.
// Keep the GitHub repository allowlist below unchanged unless the release source intentionally changes.
const String firmwareMetadataUrl =
    'https://je-x-fyz-default-rtdb.asia-southeast1.firebasedatabase.app/firmware_update.json';
const Duration voltageGuardDuration = Duration(seconds: 1);
const int fanSpeedMin = 50;
const int fanSpeedMax = 100;

// JE X FYZ LED palette: 24 curated RGB presets.
// White is included; black and dark/light variants are intentionally excluded because
// brightness is the single intensity control.
const List<String> ledColorPalette = <String>[
  '#FF0000', '#FF4000', '#FF8000', '#FFC000', '#FFFF00', '#BFFF00',
  '#80FF00', '#00FF00', '#00FF80', '#00FFFF', '#00BFFF', '#0080FF',
  '#0040FF', '#0000FF', '#4000FF', '#8000FF', '#BF00FF', '#FF00FF',
  '#FF0080', '#FF4080', '#FF0040', '#FF8040', '#FFB6C1', '#FFFFFF',
];

Color ledPaletteColor(String hex) {
  final rgb = int.parse(hex.substring(1), radix: 16);
  return Color(0xFF000000 | rgb);
}

/// Returns the normalized per-pixel intensity for the horizontal eight-LED preview.
/// The physical 4-left/4-right strip is deliberately flattened into one App row.
List<double> ledPreviewLevels({
  required int mode,
  required int elapsedMs,
}) {
  final levels = List<double>.filled(8, 0);
  final t = elapsedMs < 0 ? 0 : elapsedMs;

  void setPair(int pair, double level) {
    final clamped = level.clamp(0.0, 1.0).toDouble();
    levels[3 - pair] = clamped;
    levels[4 + pair] = clamped;
  }

  switch (mode.clamp(1, 7)) {
    case 1:
      levels.fillRange(0, 8, 1);
    case 2:
      final phase = (t % 2200) / 2200.0;
      final level = .12 + .88 * (.5 + .5 * math.sin(phase * math.pi * 2));
      levels.fillRange(0, 8, level);
    case 3:
      final progress = (t % 1600) / 400.0;
      for (var pair = 0; pair < 4; pair++) {
        final distance = pair.toDouble();
        final level = progress >= distance
            ? 1.0
            : progress > distance - 1.0
                ? progress - distance + 1.0
                : 0.0;
        setPair(pair, level);
      }
    case 4:
      final progress = (t % 1600) / 400.0;
      for (var pair = 0; pair < 4; pair++) {
        final distance = pair.toDouble();
        final level = progress >= distance
            ? 1.0
            : progress > distance - 1.0
                ? progress - distance + 1.0
                : 0.0;
        setPair(3 - pair, level);
      }
    case 5:
      const sequence = <int>[0, 1, 2, 3, 2, 1];
      setPair(sequence[(t ~/ 150) % sequence.length], 1.0);
    case 6:
      final phase = (t % 1800) / 1800.0;
      final wave = .5 + .5 * math.sin(phase * math.pi * 2);
      final leftLevel = .10 + .90 * wave;
      final rightLevel = .10 + .90 * (1.0 - wave);
      for (var i = 0; i < 4; i++) {
        levels[i] = leftLevel;
        levels[4 + i] = rightLevel;
      }
    case 7:
      levels.fillRange(0, 8, 1);
  }
  return levels;
}

/// Returns the per-pixel RGB colors for the horizontal eight-LED preview.
/// Firmware maps 1..100% brightness to hardware intensity; the preview follows the same
/// base-brightness relationship before the animation level is applied by the painter.
List<Color> ledPreviewColors({
  required int mode,
  required int elapsedMs,
  required String baseColor,
  required int brightness,
}) {
  final safeBrightness = brightness.clamp(1, 100).toDouble() / 100.0;
  if (mode.clamp(1, 7) != 7) {
    final rgb = ledPaletteColor(baseColor);
    final scaled = Color.fromARGB(
      255,
      (rgb.red * safeBrightness).round().clamp(0, 255),
      (rgb.green * safeBrightness).round().clamp(0, 255),
      (rgb.blue * safeBrightness).round().clamp(0, 255),
    );
    return List<Color>.filled(8, scaled);
  }

  const cycleMs = 30000;
  final hue = ((elapsedMs % cycleMs) / cycleMs) * 360.0;
  final rainbow = HSVColor.fromAHSV(1, hue, 1, safeBrightness).toColor();
  return List<Color>.filled(8, rainbow);
}

class JexLedStripPreview extends StatefulWidget {
  final int mode;
  final String colorHex;
  final int brightness;
  final bool active;

  const JexLedStripPreview({
    super.key,
    required this.mode,
    required this.colorHex,
    required this.brightness,
    required this.active,
  });

  @override
  State<JexLedStripPreview> createState() => _JexLedStripPreviewState();
}

class _JexLedStripPreviewState extends State<JexLedStripPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 30000),
    );
    if (widget.active) controller.repeat();
  }

  @override
  void didUpdateWidget(covariant JexLedStripPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !controller.isAnimating) {
      controller.repeat();
    } else if (!widget.active && controller.isAnimating) {
      controller.stop();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final elapsedMs = (controller.value * 30000).round();
          return SizedBox(
            width: double.infinity,
            height: 72,
            child: CustomPaint(
              painter: _JexLedStripPainter(
              levels: ledPreviewLevels(
                mode: widget.mode,
                elapsedMs: elapsedMs,
              ),
              colors: ledPreviewColors(
                mode: widget.mode,
                elapsedMs: elapsedMs,
                baseColor: widget.colorHex,
                brightness: widget.brightness,
              ),
              active: widget.active,
                background: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF20232A)
                    : const Color(0xFFF5F6F8),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _JexLedStripPainter extends CustomPainter {
  final List<double> levels;
  final List<Color> colors;
  final bool active;
  final Color background;

  const _JexLedStripPainter({
    required this.levels,
    required this.colors,
    required this.active,
    required this.background,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final left = 18.0;
    final usable = math.max(1.0, size.width - 36.0);
    final gap = usable / 7;
    final radius = math.min(14.0, math.max(9.0, size.height * .19));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, centerY - 19, math.max(0, size.width - 20), 38),
        const Radius.circular(19),
      ),
      Paint()..color = background,
    );

    for (var i = 0; i < 8; i++) {
      final center = Offset(left + gap * i, centerY);
      final level = active ? levels[i] : .10;
      final color = colors[i];
      if (active && level > .02) {
        canvas.drawCircle(
          center,
          radius + 3,
          Paint()
            ..color = color.withValues(alpha: .14 * level)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 7),
        );
      }
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withValues(alpha: active ? level.clamp(.08, 1) : .14),
      );
      canvas.drawCircle(
        center.translate(-radius * .22, -radius * .22),
        radius * .20,
        Paint()
          ..color = Colors.white.withValues(
            alpha: active ? (.12 + .22 * level) : .05,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _JexLedStripPainter oldDelegate) =>
      oldDelegate.levels != levels ||
      oldDelegate.colors != colors ||
      oldDelegate.active != active ||
      oldDelegate.background != background;
}

class _JexColorPickerCard extends StatelessWidget {
  final List<String> colors;
  final String selected;
  final ValueChanged<String> onSelected;

  const _JexColorPickerCard({
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      elevation: 18,
      shadowColor: Colors.black.withValues(alpha: .22),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              JexText.of('color', appLanguageNotifier.value),
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: colors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                mainAxisExtent: 38,
              ),
              itemBuilder: (_, index) {
                final value = colors[index];
                final isSelected = selected == value;
                final isWhite = value == '#FFFFFF';
                return InkWell(
                  borderRadius: BorderRadius.circular(11),
                  onTap: () => onSelected(value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                      color: ledPaletteColor(value),
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: isSelected
                            ? scheme.onSurface
                            : (isWhite ? scheme.outline : Colors.transparent),
                        width: isSelected ? 2.5 : 1,
                      ),
                    ),
                    child: isSelected
                        ? JexAnimatedIcon.glyph(
                            icon: PhosphorIconsBold.check,
                            color: isWhite ? Colors.black : Colors.white,
                            size: 18,
                            active: true,
                          )
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
// Global JE X FYZ indicator motion gate.
// Device/status animation is legal only when BLE is connected and the indicator state is active.
bool jexIndicatorAnimationActive({
  required bool connected,
  required bool stateActive,
}) =>
    connected && stateActive;

Duration jexIconAnimationDuration(JexAnimatedIconKind kind) {
  return switch (kind) {
    JexAnimatedIconKind.battery => const Duration(milliseconds: 1500),
    JexAnimatedIconKind.hotside => const Duration(milliseconds: 1800),
    JexAnimatedIconKind.voltage => const Duration(milliseconds: 1050),
    JexAnimatedIconKind.adaptive => const Duration(milliseconds: 2400),
    JexAnimatedIconKind.peltier => const Duration(milliseconds: 1600),
    JexAnimatedIconKind.fan => const Duration(milliseconds: 1050),
    JexAnimatedIconKind.speed => const Duration(milliseconds: 1300),
    JexAnimatedIconKind.led => const Duration(milliseconds: 1250),
    JexAnimatedIconKind.bluetooth => const Duration(milliseconds: 1800),
    JexAnimatedIconKind.generic => const Duration(milliseconds: 2000),
  };
}

class JexAnimatedIcon extends StatefulWidget {
  final JexAnimatedIconKind kind;
  final IconData? glyph;
  final Color color;
  final double size;
  final bool active;
  final double level;
  final bool warning;

  const JexAnimatedIcon({
    super.key,
    required this.kind,
    this.glyph,
    required this.color,
    this.size = 24,
    this.active = false,
    this.level = 1,
    this.warning = false,
  });

  const JexAnimatedIcon.glyph({
    super.key,
    required IconData icon,
    required this.color,
    this.size = 24,
    this.active = false,
    this.warning = false,
  })  : kind = JexAnimatedIconKind.generic,
        glyph = icon,
        level = 1;

  @override
  State<JexAnimatedIcon> createState() => _JexAnimatedIconState();
}

class _JexAnimatedIconState extends State<JexAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  void _syncAnimation() {
    if (widget.kind == JexAnimatedIconKind.generic || !widget.active) {
      controller.stop();
      controller.value = 0;
      return;
    }
    if (!controller.isAnimating) {
      controller.repeat();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: jexIconAnimationDuration(widget.kind),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant JexAnimatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.kind != oldWidget.kind) {
      controller.duration = jexIconAnimationDuration(widget.kind);
      controller.reset();
    }
    // Transitioning OFF always freezes the painter at its canonical static pose.
    // Transitioning ON starts a fresh motion cycle from phase zero.
    if (widget.active != oldWidget.active) {
      controller.reset();
    }
    _syncAnimation();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Generic/action glyphs are intentionally static. Full custom motion is reserved
    // for JE X FYZ status/indicator kinds.
    if (widget.glyph != null) {
      return RepaintBoundary(
        child: Icon(
          widget.glyph!,
          size: widget.size,
          color: widget.color,
        ),
      );
    }

    final level = widget.level.clamp(0.0, 1.0).toDouble();
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) => CustomPaint(
          size: Size.square(widget.size),
          painter: _JexIconPainter(
            kind: widget.kind,
            color: widget.color,
            progress: controller.value,
            active: widget.active,
            level: level,
            warning: widget.warning,
          ),
        ),
      ),
    );
  }
}

class _JexIconPainter extends CustomPainter {
  final JexAnimatedIconKind kind;
  final Color color;
  final double progress;
  final bool active;
  final double level;
  final bool warning;

  const _JexIconPainter({
    required this.kind,
    required this.color,
    required this.progress,
    required this.active,
    required this.level,
    required this.warning,
  });

  Paint stroke(
    double width, [
    Color? c,
  ]) {
    return Paint()
      ..color = c ?? color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  Paint fill([Color? c]) {
    return Paint()
      ..color = c ?? color
      ..style = PaintingStyle.fill;
  }

  Path _bolt(double s) {
    return Path()
      ..moveTo(s * .56, s * .08)
      ..lineTo(s * .28, s * .51)
      ..lineTo(s * .49, s * .51)
      ..lineTo(s * .39, s * .92)
      ..lineTo(s * .73, s * .37)
      ..lineTo(s * .53, s * .37)
      ..close();
  }

  void _drawHeatWave(
    Canvas canvas,
    Size size,
    double phase,
    double alpha,
  ) {
    final s = size.shortestSide;
    final cx = size.width / 2;
    final offset = (phase % 1.0) * s * .13;
    final waves = <double>[
      -.16 + offset / s,
      0.02 + offset / s,
      .20 + offset / s,
    ];
    for (final xFactor in waves) {
      final x = cx + xFactor * s;
      final path = Path()
        ..moveTo(x, s * .23)
        ..cubicTo(
          x - s * .05,
          s * .30,
          x + s * .05,
          s * .36,
          x,
          s * .43,
        )
        ..cubicTo(
          x - s * .05,
          s * .50,
          x + s * .05,
          s * .56,
          x,
          s * .63,
        );
      canvas.drawPath(
        path,
        stroke(s * .028, color.withValues(alpha: alpha)),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final p = active ? progress : 0.0;
    final pulse = active
        ? .5 + .5 * math.sin(p * math.pi * 2)
        : 0.0;

    canvas.save();

    switch (kind) {
      case JexAnimatedIconKind.battery:
        final body = RRect.fromRectAndRadius(
          Rect.fromLTWH(s * .12, s * .24, s * .68, s * .52),
          Radius.circular(s * .10),
        );
        canvas.drawRRect(
          body,
          stroke(s * .065, color),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(s * .22, s * .34, s * .48, s * .32),
            Radius.circular(s * .055),
          ),
          stroke(s * .035, color.withValues(alpha: .30)),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              s * .24,
              s * .36,
              s * .44 * (active ? .62 + .18 * pulse : .62),
              s * .28,
            ),
            Radius.circular(s * .045),
          ),
          fill(color.withValues(alpha: active ? .38 + .24 * pulse : .18)),
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(s * .80, s * .40, s * .09, s * .20),
            Radius.circular(s * .035),
          ),
          fill(color),
        );
        if (active) {
          final flowX = s * (.25 + .36 * ((p * 1.4) % 1.0));
          canvas.drawLine(
            Offset(flowX, s * .43),
            Offset(flowX + s * .08, s * .43),
            stroke(s * .032, color.withValues(alpha: .82)),
          );
        }
        break;

      case JexAnimatedIconKind.hotside:
        canvas.drawLine(
          Offset(cx, s * .17),
          Offset(cx, s * .67),
          stroke(s * .065, color),
        );
        canvas.drawCircle(
          Offset(cx, s * .75),
          s * .13,
          stroke(s * .058, color),
        );
        canvas.drawLine(
          Offset(cx, s * .75),
          Offset(cx, s * .75),
          stroke(s * .058, color),
        );
        _drawHeatWave(
          canvas,
          size,
          active ? p : 0,
          active ? .34 + .22 * pulse : .12,
        );
        if (warning && active) {
          canvas.drawCircle(
            Offset(cx, cy),
            s * (.43 + .035 * pulse),
            stroke(s * .028, color.withValues(alpha: .55 + .15 * pulse)),
          );
        }
        break;

      case JexAnimatedIconKind.voltage:
        final bolt = _bolt(s);
        canvas.drawPath(
          bolt,
          fill(color.withValues(alpha: active ? 1 : .72)),
        );
        if (active) {
          final t = (p * 1.6) % 1.0;
          final points = <Offset>[
            Offset(s * .52, s * (.18 + .16 * t)),
            Offset(s * (.41 + .18 * t), s * (.51 - .08 * t)),
            Offset(s * (.53 - .08 * t), s * (.72 + .05 * t)),
          ];
          for (var i = 0; i < points.length; i++) {
            final spark = points[i];
            final a = .28 + .62 * (1 - ((t + i * .27) % 1.0));
            canvas.drawCircle(
              spark,
              s * .028,
              fill(Colors.white.withValues(alpha: a)),
            );
          }
          canvas.drawPath(
            bolt,
            stroke(
              s * .025,
              Colors.white.withValues(alpha: .16 + .08 * pulse),
            ),
          );
        }
        break;

      case JexAnimatedIconKind.adaptive:
        final ringRect = Rect.fromCircle(
          center: Offset(cx, cy),
          radius: s * .34,
        );
        canvas.drawCircle(
          Offset(cx, cy),
          s * .25,
          stroke(s * .055, color.withValues(alpha: active ? .34 : .24)),
        );
        canvas.drawArc(
          Rect.fromCircle(
            center: Offset(cx, cy),
            radius: s * .39,
          ),
          -math.pi / 2,
          active ? math.pi * 1.62 : math.pi * 1.45,
          false,
          stroke(s * .065, color.withValues(alpha: active ? .82 : .40)),
        );
        if (active) {
          final angle = -math.pi / 2 + p * math.pi * 2;
          final orb = Offset(
            cx + math.cos(angle) * s * .39,
            cy + math.sin(angle) * s * .39,
          );
          canvas.drawCircle(
            orb,
            s * (.055 + .015 * pulse),
            fill(color),
          );
          canvas.drawCircle(
            orb,
            s * (.11 + .02 * pulse),
            stroke(s * .018, color.withValues(alpha: .20)),
          );
          canvas.drawArc(
            ringRect,
            angle - .55,
            .55,
            false,
            stroke(s * .025, color.withValues(alpha: .40)),
          );
        }
        break;

      case JexAnimatedIconKind.peltier:
        final core = Offset(cx, cy);
        final arms = <double>[0, math.pi / 3, 2 * math.pi / 3];
        for (final a in arms) {
          final dx = math.cos(a) * s * .31;
          final dy = math.sin(a) * s * .31;
          canvas.drawLine(
            Offset(cx - dx, cy - dy),
            Offset(cx + dx, cy + dy),
            stroke(s * .048, color.withValues(alpha: active ? .88 : .52)),
          );
        }
        canvas.drawCircle(
          core,
          s * .055,
          fill(color),
        );
        if (active) {
          for (var i = 0; i < 6; i++) {
            final angle = p * math.pi * 2 + i * math.pi / 3;
            final radial = i.isEven
                ? s * (.10 + .10 * ((p + i * .09) % 1))
                : s * (.30 - .10 * ((p + i * .11) % 1));
            final pt = Offset(
              cx + math.cos(angle) * radial,
              cy + math.sin(angle) * radial,
            );
            canvas.drawCircle(
              pt,
              s * (.018 + .010 * pulse),
              fill(color.withValues(alpha: .25 + .60 * pulse)),
            );
          }
          canvas.drawCircle(
            core,
            s * (.11 + .04 * pulse),
            stroke(s * .022, color.withValues(alpha: .22)),
          );
        }
        break;

      case JexAnimatedIconKind.fan:
        final speed = .55 + 2.15 * level.clamp(.0, 1.0);
        final rotation = p * math.pi * 2 * speed;
        final bladePaint = stroke(s * .05, color.withValues(alpha: active ? .95 : .52));
        for (var i = 0; i < 3; i++) {
          final a = rotation + i * math.pi * 2 / 3;
          final tip = Offset(
            cx + math.cos(a) * s * .34,
            cy + math.sin(a) * s * .34,
          );
          final control = Offset(
            cx + math.cos(a + .72) * s * .20,
            cy + math.sin(a + .72) * s * .20,
          );
          final path = Path()
            ..moveTo(cx, cy)
            ..quadraticBezierTo(
              control.dx,
              control.dy,
              tip.dx,
              tip.dy,
            )
            ..quadraticBezierTo(
              cx + math.cos(a - .20) * s * .17,
              cy + math.sin(a - .20) * s * .17,
              cx,
              cy,
            );
          canvas.drawPath(path, bladePaint);
        }
        canvas.drawCircle(
          Offset(cx, cy),
          s * (.065 + (active ? .008 * pulse : 0)),
          fill(color),
        );
        if (active) {
          for (var i = 0; i < 3; i++) {
            final a = rotation + i * math.pi * 2 / 3 + .35;
            final trail = Offset(
              cx + math.cos(a) * s * .40,
              cy + math.sin(a) * s * .40,
            );
            canvas.drawCircle(
              trail,
              s * .018,
              fill(color.withValues(alpha: .18 + .26 * pulse)),
            );
          }
        }
        break;

      case JexAnimatedIconKind.speed:
        final gauge = Rect.fromCircle(
          center: Offset(cx, cy),
          radius: s * .34,
        );
        canvas.drawArc(
          gauge,
          math.pi * .18,
          math.pi * .64,
          false,
          stroke(s * .055, color.withValues(alpha: .18)),
        );
        final actual = level.clamp(0.0, 1.0);
        canvas.drawArc(
          gauge,
          math.pi * .18,
          math.pi * .64 * actual,
          false,
          stroke(s * .065, color.withValues(alpha: active ? 1 : .38)),
        );
        final needleBase =
            math.pi * .18 + math.pi * .64 * actual;
        final needleSweep = active
            ? math.sin(p * math.pi * 2) * .035
            : 0.0;
        final angle = needleBase + needleSweep;
        canvas.drawLine(
          Offset(cx, cy),
          Offset(
            cx + math.cos(angle) * s * .28,
            cy + math.sin(angle) * s * .28,
          ),
          stroke(s * .040, color.withValues(alpha: active ? 1 : .45)),
        );
        canvas.drawCircle(
          Offset(cx, cy),
          s * .055,
          fill(color.withValues(alpha: active ? 1 : .45)),
        );
        break;

      case JexAnimatedIconKind.led:
        for (var i = 0; i < 8; i++) {
          final phase = active
              ? (p * 1.15 + i / 8) % 1.0
              : 0.0;
          final level = active
              ? .30 + .65 * (.5 + .5 * math.sin(phase * math.pi * 2))
              : .25;
          canvas.drawCircle(
            Offset(
              s * (.11 + i * .112),
              cy,
            ),
            s * .052,
            fill(color.withValues(alpha: level)),
          );
          if (active && level > .65) {
            canvas.drawCircle(
              Offset(
                s * (.11 + i * .112),
                cy,
              ),
              s * .085,
              stroke(s * .018, color.withValues(alpha: .14)),
            );
          }
        }
        break;

      case JexAnimatedIconKind.bluetooth:
        final bt = Path()
          ..moveTo(cx, s * .10)
          ..lineTo(s * .70, s * .29)
          ..lineTo(cx, s * .50)
          ..lineTo(s * .70, s * .71)
          ..lineTo(cx, s * .90)
          ..lineTo(cx, s * .10)
          ..moveTo(s * .18, s * .29)
          ..lineTo(s * .70, s * .71)
          ..moveTo(s * .18, s * .71)
          ..lineTo(s * .70, s * .29);
        canvas.drawPath(
          bt,
          stroke(s * .052, color.withValues(alpha: active ? 1 : .62)),
        );
        if (active) {
          for (var i = 0; i < 2; i++) {
            final waveP = (p + i * .5) % 1.0;
            final radius = s * (.23 + waveP * .24);
            canvas.drawArc(
              Rect.fromCircle(
                center: Offset(cx, cy),
                radius: radius,
              ),
              -math.pi * .50,
              math.pi,
              false,
              stroke(
                s * .026,
                color.withValues(alpha: .42 * (1 - waveP)),
              ),
            );
          }
        }
        break;

      case JexAnimatedIconKind.generic:
        // Action/navigation glyphs remain intentionally static.
        canvas.drawCircle(
          Offset(cx, cy),
          0,
          fill(Colors.transparent),
        );
        break;
    }

    if (warning) {
      final warningAlpha = active
          ? .42 + .26 * pulse
          : .28;
      canvas.drawCircle(
        Offset(cx, cy),
        s * (.45 + (active ? .025 * pulse : 0)),
        stroke(s * .022, color.withValues(alpha: warningAlpha)),
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _JexIconPainter oldDelegate) =>
      oldDelegate.kind != kind ||
      oldDelegate.color != color ||
      oldDelegate.progress != progress ||
      oldDelegate.active != active ||
      oldDelegate.level != level ||
      oldDelegate.warning != warning;
}


const MethodChannel securityChannel = MethodChannel('je_x_fyz/security');

// AI-METHOD: _isOfficialBuild — Production signing-integrity gate; debug builds are intentionally allowed.
Future<bool> _isOfficialBuild() async {
  if (!Platform.isAndroid) return true;
  try {
    final result = await securityChannel.invokeMethod<bool>('isOfficialBuild');
    return result == true;
  } catch (e) {
    debugPrint('Security check: $e');
    return false;
  }
}

// AI-METHOD: isVoltageCommand — Accept only 5V, 9V, or 12V.
bool isVoltageCommand(String value) {
  final v = value.trim().toUpperCase();
  return v == '5V' || v == '9V' || v == '12V';
}

// AI-METHOD: isTransientOtaResultEvent — Accept only fresh OTA success/failure envelopes for Home NOTIFY.
bool isTransientOtaResultEvent(String value) {
  final upper = value.trim().toUpperCase();
  return upper.startsWith('OTA_SUCCESS|') || upper.startsWith('OTA_FAILED|');
}

// AI-METHOD: parseFirmwareVersion — Parse supported V<major>.<minor> labels only.
List<int>? parseFirmwareVersion(String version) {
  final match = RegExp(r'^V(\d+)(?:\.(\d+))?$')
      .firstMatch(version.trim().toUpperCase());
  if (match == null) return null;
  final major = int.tryParse(match.group(1)!);
  final minor = int.tryParse(match.group(2) ?? '0');
  if (major == null || minor == null) return null;
  return <int>[major, minor];
}

// AI-METHOD: isNewerFirmwareVersion — Compatibility/test helper; current OTA policy uses different-version comparison.
bool isNewerFirmwareVersion(String latest, String current) {
  final a = parseFirmwareVersion(latest);
  final b = parseFirmwareVersion(current);
  if (a == null || b == null) return false;
  if (a[0] != b[0]) return a[0] > b[0];
  return a[1] > b[1];
}

// AI-METHOD: isDifferentFirmwareVersion — Current OTA availability rule: any valid version different from device version is an OTA target.
bool isDifferentFirmwareVersion(String latest, String current) {
  final a = parseFirmwareVersion(latest);
  final b = parseFirmwareVersion(current);
  if (a == null || b == null) return false;
  return a[0] != b[0] || a[1] != b[1];
}


// AI-METHOD: canAutoConnect — Pure policy gate for passive Auto Connect.
// It must never prompt for permissions, enable Bluetooth, or connect without a known cooler.
bool canAutoConnect({
  required bool autoConnectEnabled,
  required String? knownRemoteId,
  required bool bluetoothScanGranted,
  required bool bluetoothConnectGranted,
  required bool bluetoothAdapterOn,
  required bool legacyLocationReady,
}) {
  return autoConnectEnabled &&
      knownRemoteId != null &&
      knownRemoteId.trim().isNotEmpty &&
      bluetoothScanGranted &&
      bluetoothConnectGranted &&
      bluetoothAdapterOn &&
      legacyLocationReady;
}

// AI-METHOD: main — Flutter entry point; initialize security/Firebase then mount production UI.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final officialBuild = await _isOfficialBuild();
  if (!officialBuild) {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);
    runApp(const TamperApp());
    return;
  }

  await AppSettingsStore.load();
  await KnownCoolerStore.load();
  await FloatingStore.load();

  try {
    await Firebase.initializeApp();
    try {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: const AndroidPlayIntegrityProvider(),
      );
    } catch (e) {
      // App Check can be rolled out from monitoring to enforcement in Firebase
      // without breaking the official UI when the backend is not yet enforced.
      debugPrint('Firebase App Check init: $e');
    }
  } catch (e) {
    debugPrint('Firebase init: $e');
  }

  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
  runApp(const JeCoolerApp());
}

class TamperApp extends StatelessWidget {
  const TamperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF111113),
        fontFamily: 'Roboto',
      ),
      home: const TamperScreen(),
    );
  }
}

class TamperScreen extends StatelessWidget {
  const TamperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0x18FF453A),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0x40FF453A)),
                  ),
                  child: JexAnimatedIcon.glyph(
                    icon: PhosphorIconsBold.warning,
                    color: Colors.redAccent,
                    size: 44,
                    active: true,
                    warning: true,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  headerName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  JexText.phrase('OFFICIAL BUILD\nINTEGRITY CHECK FAILED', 'BUILD RESMI\nPEMERIKSAAN INTEGRITAS GAGAL', appLanguageNotifier.value),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 25,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  JexText.of('officialBuildFailed', appLanguageNotifier.value),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () => SystemNavigator.pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2B31),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(160, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    JexText.of('exit', appLanguageNotifier.value).toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class JeCoolerApp extends StatelessWidget {
  const JeCoolerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2<AppThemePreset, AppLanguage>(
      first: appThemeNotifier,
      second: appLanguageNotifier,
      builder: (context, preset, language) {
        return MaterialApp(
          title: appName,
          debugShowCheckedModeBanner: false,
          theme: buildJexTheme(preset),
          home: Theme(
            data: buildJexTheme(
              preset == AppThemePreset.defaultTheme
                  ? AppThemePreset.light
                  : preset,
            ),
            child: const DashboardScreen(),
          ),
        );
      },
    );
  }
}

/// Backwards-compatible alias for simple widget tests.
typedef MyApp = JeCoolerApp;

// --- DASHBOARD CONTROLLER: BLE lifecycle, telemetry, commands, OTA initiation, rendering ---
// AI-MEMORY / DASHBOARD OWNERSHIP
// DashboardScreen owns live UI state and BLE coordination for one JE X FYZ session.
// It may present firmware state but must never override firmware safety decisions.

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  static const MethodChannel batteryChannel =
      MethodChannel('je_x_fyz/battery_temp');

  BluetoothDevice? device;
  BluetoothCharacteristic? rx;
  BluetoothCharacteristic? tx;
  StreamSubscription<BluetoothConnectionState>? connectionSub;
  StreamSubscription<List<int>>? notificationSub;

  Future<void> _writeQueue = Future<void>.value();
  Timer? batteryTimer;
  Timer? voltageGuardTimer;
  Timer? reconnectTimer;
  Timer? disconnectRediscoveryTimer;
  StreamSubscription<List<ScanResult>>? disconnectRediscoverySub;
  bool disconnectRediscoveryScanInProgress = false;
  Timer? fpsTimer;
  final GlobalKey _ledColorAnchorKey = GlobalKey();
  int frameCount = 0;
  int currentFps = 0;
  bool hotAlertArmed = true;

  bool _bleReady = false;
  bool _bleSessionReady = false;
  bool _syncReadyAck = false;
  bool connected = false;
  bool syncing = false;
  bool fullSyncReceived = false;
  bool voltageGuardActive = false;
  bool adaptiveTransitioning = false;
  bool batteryReadBusy = false;
  bool dashboardReady = false;
  bool _bleConnecting = false;
  final Map<String, List<Completer<String>>> _ackWaiters = {};
  final Map<String, String> _syncSnapshot = {};
  final Map<String, String> _pendingTelemetry = {};

  int brightnessDraft = 100;
  int fanSpeedDraft = 100;
  int hotLimitDraft = 45;
  int battery5Draft = 25;
  int battery12Draft = 35;
  String incomingBuffer = '';
  String notice = '';
  String pendingOtaNotice = '';

  String voltage = '--';
  String hotsideTemp = '--';
  String phoneBatteryTemp = '--';
  bool phoneBatteryValid = false;
  bool fanOn = false;
  bool peltierOn = false;
  bool adaptiveOn = false;
  String adaptiveCeiling = '12V';
  String adaptiveProfile = 'HOTSIDE_BATTERY';
  bool rgbOn = false;
  int rgbMode = 1;
  int brightness = 100;
  String rgbColor = '#FFFFFF';
  int fanSpeed = 100;
  int hotLimit = 45;
  int battery5Limit = 25;
  int battery12Limit = 35;
  String safety = 'LOCKED';
  String safetyReason = 'WAITING_FOR_NTC';
  String firmwareVersion = 'V?';
  String resetReason = 'UNKNOWN';
  String otaState = 'IDLE';
  String otaStage = 'IDLE';
  int otaProgress = 0;
  int otaErrorCode = 0;
  String otaError = 'NONE';
  int stateSequence = 0;

  int tabIndex = 0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appAutoConnectNotifier.addListener(_handleAutoConnectPreferenceChanged);
    WidgetsBinding.instance.addTimingsCallback(_recordFrameTimings);
    fpsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      currentFps = frameCount;
      frameCount = 0;
      _publishFloatingTelemetry();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryAutoConnect());
    try {
      FlutterBluePlus.setOperationQueueMode(OperationQueueMode.perDevice);
    } catch (e) {
      debugPrint('BLE operation queue: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    appAutoConnectNotifier.removeListener(_handleAutoConnectPreferenceChanged);
    WidgetsBinding.instance.removeTimingsCallback(_recordFrameTimings);
    fpsTimer?.cancel();
    disconnectRediscoverySub?.cancel();
    connectionSub?.cancel();
    notificationSub?.cancel();
    batteryTimer?.cancel();
    voltageGuardTimer?.cancel();
    reconnectTimer?.cancel();
    disconnectRediscoveryTimer?.cancel();
    disconnectRediscoveryTimer = null;
    disconnectRediscoverySub?.cancel();
    disconnectRediscoverySub = null;
    disconnectRediscoveryScanInProgress = false;
    device?.disconnect();
    for (final waiters in _ackWaiters.values) {
      for (final waiter in waiters) {
        if (!waiter.isCompleted) waiter.complete('CANCELLED');
      }
    }
    _ackWaiters.clear();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (connected && _bleReady && _bleSessionReady) {
      unawaited(_requestFreshSync(timeout: const Duration(seconds: 4)));
    } else {
      _tryAutoConnect();
    }
  }

  void _recordFrameTimings(List<FrameTiming> timings) {
    frameCount += timings.length;
  }

  // AI-METHOD / AUTO-CONNECT-PREFERENCE-CONTRACT
  // Enabling Auto Connect reevaluates the passive prerequisites immediately. Disabling it
  // cancels pending automatic reconnect work. This callback never requests permissions or
  // changes Bluetooth power state.
  void _handleAutoConnectPreferenceChanged() {
    if (appAutoConnectNotifier.value) {
      unawaited(_tryAutoConnect());
    } else {
      reconnectTimer?.cancel();
      reconnectTimer = null;
      _cancelDisconnectRediscovery();
    }
  }

  // AI-METHOD / AUTO-CONNECT-CONTRACT
  // Auto Connect is passive: no BLE permission prompts, no Bluetooth power-on, and no
  // device scan until a previously successful cooler identity is known and all OS state
  // is already ready.
  Future<void> _tryAutoConnect() async {
    if (connected ||
        syncing ||
        _bleConnecting ||
        (reconnectTimer?.isActive ?? false) ||
        !appAutoConnectNotifier.value ||
        knownCoolerRemoteIdNotifier.value == null) {
      return;
    }

    final scanPermission = await Permission.bluetoothScan.status;
    final connectPermission = await Permission.bluetoothConnect.status;
    final adapter = await FlutterBluePlus.adapterState.first;
    final sdk = await _androidSdkInt();

    var locationReady = true;
    if (sdk > 0 && sdk <= 30) {
      final permission = await Permission.locationWhenInUse.status;
      var serviceEnabled = true;
      try {
        serviceEnabled = await batteryChannel.invokeMethod<bool>(
              'isLocationServiceEnabled',
            ) ??
            false;
      } catch (_) {
        serviceEnabled = false;
      }
      locationReady = permission.isGranted && serviceEnabled;
    }

    if (!canAutoConnect(
      autoConnectEnabled: appAutoConnectNotifier.value,
      knownRemoteId: knownCoolerRemoteIdNotifier.value,
      bluetoothScanGranted: scanPermission.isGranted,
      bluetoothConnectGranted: connectPermission.isGranted,
      bluetoothAdapterOn: adapter == BluetoothAdapterState.on,
      legacyLocationReady: locationReady,
    )) {
      return;
    }

    unawaited(_scanAndConnect(automatic: true));
  }

  Future<void> _postNotification(String title, String body, int id) async {
    try {
      await const MethodChannel('je_x_fyz/notifications').invokeMethod<void>(
        'showNotification',
        <String, dynamic>{
          'title': title,
          'body': body,
          'id': id,
        },
      );
    } catch (e) {
      debugPrint('Notification: $e');
    }
  }

  void _publishFloatingTelemetry() {
    final telemetry = FloatingTelemetry(
      fps: currentFps > 0 ? currentFps.toString() : '--',
      battery: connected && phoneBatteryValid ? phoneBatteryTemp : '--',
      hotside: connected ? hotsideTemp : '--',
      voltage: connected ? voltage : '--',
      fanOn: connected && fanOn,
      speed: fanSpeed,
      adaptiveOn: connected && adaptiveOn,
      peltierOn: connected && peltierOn,
      connected: connected,
    );
    floatingTelemetryNotifier.value = telemetry;
    unawaited(FloatingBridge.updateData(telemetry));
  }

  // AI-METHOD: _requestPermissions — Prepare Android BLE permissions, adapter state, and legacy location requirements.
  Future<bool> _requestPermissions({bool showResult = false}) async {
    if (!Platform.isAndroid) return true;
    try {
      final scan = await Permission.bluetoothScan.request();
      final connect = await Permission.bluetoothConnect.request();
      final sdk = await _androidSdkInt();

      PermissionStatus location = await Permission.locationWhenInUse.status;
      if (sdk > 0 && sdk <= 30) {
        location = await Permission.locationWhenInUse.request();
      }

      var adapter = await FlutterBluePlus.adapterState.first;
      if (adapter == BluetoothAdapterState.off) {
        try {
          await FlutterBluePlus.turnOn();
          adapter = await FlutterBluePlus.adapterState
              .where((state) => state == BluetoothAdapterState.on)
              .first
              .timeout(const Duration(seconds: 8));
        } catch (e) {
          debugPrint('Bluetooth turn on: $e');
        }
      }

      bool locationService = true;
      try {
        locationService = await batteryChannel.invokeMethod<bool>(
              'isLocationServiceEnabled',
            ) ??
            false;
      } catch (e) {
        debugPrint('Location service state: $e');
      }

      final bluetoothReady =
          scan.isGranted &&
          connect.isGranted &&
          adapter == BluetoothAdapterState.on;
      final locationReady =
          sdk > 30 || (location.isGranted && locationService);
      final ready = bluetoothReady && locationReady;

      if (showResult && mounted) {
        _showSnackBar(
          ready ? JexText.of('connectionReady', appLanguageNotifier.value) : JexText.of('connectionNeedsAccess', appLanguageNotifier.value),
          color: ready ? Colors.green : Colors.orangeAccent,
        );
      }
      return ready;
    } catch (e) {
      debugPrint('Permission setup: $e');
      return false;
    }
  }

  // AI-METHOD: _setBackgroundService — Bridge the active BLE session to the native foreground service.
  Future<void> _setBackgroundService(bool enabled) async {
    if (!Platform.isAndroid) return;
    try {
      await batteryChannel.invokeMethod<void>(
        enabled ? 'startBackgroundService' : 'stopBackgroundService',
      );
    } catch (e) {
      debugPrint('Background service ' +
          (enabled ? 'start' : 'stop') +
          ': $e');
    }
  }

  Future<int> _androidSdkInt() async {
    if (!Platform.isAndroid) return 0;
    try {
      return await batteryChannel.invokeMethod<int>('getAndroidSdkInt') ?? 0;
    } catch (e) {
      debugPrint('Android SDK check: $e');
      return 0;
    }
  }

  // AI-METHOD: _scanAndConnect — Perform bounded BLE discovery and pass the matching device to the connection routine.
  Future<void> _scanAndConnect({bool automatic = false}) async {
    if (syncing) return;
    if (automatic) {
      final scanPermission = await Permission.bluetoothScan.status;
      final connectPermission = await Permission.bluetoothConnect.status;
      final adapter = await FlutterBluePlus.adapterState.first;
      final sdk = await _androidSdkInt();
      var locationReady = true;
      if (sdk > 0 && sdk <= 30) {
        final permission = await Permission.locationWhenInUse.status;
        var serviceEnabled = true;
        try {
          serviceEnabled = await batteryChannel.invokeMethod<bool>(
                'isLocationServiceEnabled',
              ) ??
              false;
        } catch (_) {
          serviceEnabled = false;
        }
        locationReady = permission.isGranted && serviceEnabled;
      }
      if (!canAutoConnect(
        autoConnectEnabled: appAutoConnectNotifier.value,
        knownRemoteId: knownCoolerRemoteIdNotifier.value,
        bluetoothScanGranted: scanPermission.isGranted,
        bluetoothConnectGranted: connectPermission.isGranted,
        bluetoothAdapterOn: adapter == BluetoothAdapterState.on,
        legacyLocationReady: locationReady,
      )) {
        return;
      }
    } else {
      final accessReady = await _requestPermissions();
      if (!accessReady) {
        if (mounted) setState(() => notice = JexText.of('connectionAccessRequired', appLanguageNotifier.value));
        return;
      }
    }
    if (!mounted) return;

    setState(() {
      syncing = true;
      notice = JexText.of('scanning', appLanguageNotifier.value);
    });

    StreamSubscription<List<ScanResult>>? scanSub;
    BluetoothDevice? found;

    try {
      await FlutterBluePlus.stopScan();
      final completer = Completer<BluetoothDevice?>();

      scanSub = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          final serviceMatch = result.advertisementData.serviceUuids.any(
            (uuid) => uuid.toString().toLowerCase() == serviceUuid,
          );
          final name = result.advertisementData.advName.trim().toLowerCase();
          final platformName = result.device.platformName.trim().toLowerCase();
          final knownMatch = knownCoolerRemoteIdNotifier.value != null &&
              result.device.remoteId.toString() == knownCoolerRemoteIdNotifier.value;
          final matches = automatic
              ? (knownMatch && serviceMatch)
              : (serviceMatch || name == 'je x fyz' || platformName == 'je x fyz');
          if (matches) {
            if (!completer.isCompleted) completer.complete(result.device);
            break;
          }
        }
      });

      await FlutterBluePlus.startScan(
        withServices: <Guid>[Guid(serviceUuid)],
        timeout: const Duration(seconds: 10),
        androidCheckLocationServices: false,
        androidUsesFineLocation: false,
      );
      found = await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
      await FlutterBluePlus.stopScan();

      // Some ESP32-C3 advertising stacks omit the 128-bit service UUID from
      // the first scan packet. Fall back to a name-based scan instead of
      // declaring the device unavailable.
      if (found == null) {
        final fallback = Completer<BluetoothDevice?>();
        await scanSub.cancel();
        scanSub = FlutterBluePlus.scanResults.listen((results) {
          for (final result in results) {
            final name = result.advertisementData.advName.trim().toLowerCase();
            final platformName = result.device.platformName.trim().toLowerCase();
            final knownMatch = knownCoolerRemoteIdNotifier.value != null &&
                result.device.remoteId.toString() == knownCoolerRemoteIdNotifier.value;
            final matches = automatic
                ? knownMatch
                : (name == 'je x fyz' || platformName == 'je x fyz');
            if (matches) {
              if (!fallback.isCompleted) fallback.complete(result.device);
              break;
            }
          }
        });
        await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 6),
          androidCheckLocationServices: false,
          androidUsesFineLocation: false,
        );
        found = await fallback.future.timeout(
          const Duration(seconds: 6),
          onTimeout: () => null,
        );
        await FlutterBluePlus.stopScan();
      }

      if (found == null) {
        _showSnackBar(JexText.of('deviceNotFound'), color: Colors.orangeAccent);
        return;
      }

      // AI-METHOD: _connect — Create a clean GATT session, discover the contract, and complete P1 synchronization.
      await _connect(found);
    } catch (e) {
      debugPrint('BLE scan: $e');
      _showSnackBar(JexText.of('scanFailed'), color: Colors.redAccent);
    } finally {
      await scanSub?.cancel();
      if (mounted && !connected) {
        setState(() => syncing = false);
      }
    }
  }

  // AI-METHOD: _connect — Create a clean GATT session, discover the contract, and complete P1 synchronization.
  Future<void> _connect(BluetoothDevice target) async {
    _cancelDisconnectRediscovery();
    await FlutterBluePlus.stopScan();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await connectionSub?.cancel();
    await notificationSub?.cancel();
    batteryTimer?.cancel();
    voltageGuardTimer?.cancel();

    // Never let a previous failed/stalled GATT write block the next session.
    _writeQueue = Future<void>.value();

    try {
      if (device != null && device!.remoteId != target.remoteId) {
        await device!.disconnect();
      }
    } catch (_) {}
    device = target;
    _bleConnecting = true;
    rx = null;
    tx = null;
    _bleReady = false;
    _bleSessionReady = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    incomingBuffer = '';
    _syncSnapshot.clear();
    _pendingTelemetry.clear();

    if (mounted) {
      setState(() {
        syncing = true;
        connected = false;
        dashboardReady = false;
        voltage = '--';
        hotsideTemp = '--';
        phoneBatteryTemp = '--';
        phoneBatteryValid = false;
        fanOn = false;
        peltierOn = false;
        adaptiveOn = false;
        rgbOn = false;
        safety = 'LOCKED';
        safetyReason = 'WAITING_FOR_SENSOR_VALIDATION';
        firmwareVersion = 'V?';
        resetReason = 'UNKNOWN';
        notice = JexText.of('connectingDevice', appLanguageNotifier.value);
      });
      _publishFloatingTelemetry();
    }

    connectionSub = target.connectionState.listen((state) {
      if (state != BluetoothConnectionState.disconnected) return;
      // AI-METHOD: _handleBleDisconnected — Central BLE teardown path; clear stale timers, ACKs, session state, and UI telemetry.
      _handleBleDisconnected();
    });

    Object? lastError;
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        await target.connect(
          license: License.nonprofit,
          autoConnect: false,
          timeout: const Duration(seconds: 18),
          mtu: 247,
        );

        // FlutterBluePlus already performs the Android MTU request when `mtu`
        // is supplied to connect(). Avoid an immediate duplicate GATT operation
        // which can make some Android/ESP32 combinations unstable.
        await target.connectionState
            .where((state) => state == BluetoothConnectionState.connected)
            .first
            .timeout(const Duration(seconds: 4));

        // AI-METHOD: _discoverServices — Discover exact JE X FYZ service/RX/TX, enable notifications, and complete SYNC/SYNC_READY.
        await _discoverServices(target);
        // Reaching here means GATT discovery + SYNC + SYNC_READY succeeded; only now
        // is this cooler eligible for future passive Auto Connect.
        await KnownCoolerStore.save(target.remoteId.toString());
        lastError = null;
        break;
      } catch (e) {
        lastError = e;
        debugPrint('BLE connect/discovery attempt ${attempt + 1}: $e');
        await notificationSub?.cancel();
        notificationSub = null;
        _bleReady = false;
        _bleSessionReady = false;
        try {
          await target.disconnect();
        } catch (_) {}
        if (attempt == 0) {
          await Future<void>.delayed(const Duration(milliseconds: 700));
        }
      }
    }

    _bleConnecting = false;

    if (lastError != null) {
      final message = lastError is StateError
          ? lastError.message
          : 'Connection failed.';
      if (mounted) {
        setState(() {
          connected = false;
          syncing = false;
          notice = _compactNotifyMessage(message);
        });
      }
      throw lastError;
    }
  }

  // AI-METHOD: _handleBleDisconnected — Central BLE teardown path; clear stale timers, ACKs, session state, and UI telemetry.
  void _cancelDisconnectRediscovery() {
    disconnectRediscoveryTimer?.cancel();
    disconnectRediscoveryTimer = null;
    disconnectRediscoverySub?.cancel();
    disconnectRediscoverySub = null;
    disconnectRediscoveryScanInProgress = false;
  }

  void _startDisconnectRediscovery() {
    if (!mounted || connected || _bleConnecting) return;
    if (reconnectTimer?.isActive ?? false) return;

    _cancelDisconnectRediscovery();
    var attempts = 0;

    Future<void> scanOnce() async {
      if (!mounted ||
          connected ||
          _bleConnecting ||
          (reconnectTimer?.isActive ?? false) ||
          attempts >= 10) {
        _cancelDisconnectRediscovery();
        return;
      }
      if (disconnectRediscoveryScanInProgress) return;

      // Passive reconnect uses the same OS-state gate as Auto Connect.
      final scanPermission = await Permission.bluetoothScan.status;
      final connectPermission = await Permission.bluetoothConnect.status;
      final adapter = await FlutterBluePlus.adapterState.first;
      final sdk = await _androidSdkInt();
      var locationReady = true;
      if (sdk > 0 && sdk <= 30) {
        final permission = await Permission.locationWhenInUse.status;
        var serviceEnabled = true;
        try {
          serviceEnabled = await batteryChannel.invokeMethod<bool>(
                'isLocationServiceEnabled',
              ) ??
              false;
        } catch (_) {
          serviceEnabled = false;
        }
        locationReady = permission.isGranted && serviceEnabled;
      }
      if (!canAutoConnect(
        autoConnectEnabled: appAutoConnectNotifier.value,
        knownRemoteId: knownCoolerRemoteIdNotifier.value,
        bluetoothScanGranted: scanPermission.isGranted,
        bluetoothConnectGranted: connectPermission.isGranted,
        bluetoothAdapterOn: adapter == BluetoothAdapterState.on,
        legacyLocationReady: locationReady,
      )) {
        disconnectRediscoveryScanInProgress = false;
        return;
      }

      disconnectRediscoveryScanInProgress = true;
      attempts++;
      try {
        await FlutterBluePlus.stopScan();
        await disconnectRediscoverySub?.cancel();

        disconnectRediscoverySub =
            FlutterBluePlus.scanResults.listen((results) {
          if (!mounted || connected || _bleConnecting) return;
          for (final result in results) {
            final serviceMatch = result.advertisementData.serviceUuids.any(
              (uuid) => uuid.toString().toLowerCase() == serviceUuid,
            );
            final knownMatch = knownCoolerRemoteIdNotifier.value != null &&
                result.device.remoteId.toString() == knownCoolerRemoteIdNotifier.value;
            if (serviceMatch && knownMatch) {
              unawaited(FlutterBluePlus.stopScan());
              _cancelDisconnectRediscovery();
              unawaited(_connect(result.device));
              break;
            }
          }
        });

        await FlutterBluePlus.startScan(
          withServices: <Guid>[Guid(serviceUuid)],
          timeout: const Duration(seconds: 2),
          androidCheckLocationServices: false,
          androidUsesFineLocation: false,
        );
      } catch (e) {
        debugPrint('BLE disconnect rediscovery: $e');
      } finally {
        disconnectRediscoveryScanInProgress = false;
      }
    }

    unawaited(scanOnce());
    disconnectRediscoveryTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => unawaited(scanOnce()),
    );
  }

  void _handleBleDisconnected() {
    unawaited(_setBackgroundService(false));
    notificationSub?.cancel();
    notificationSub = null;
    _bleReady = false;
    _bleSessionReady = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    dashboardReady = false;
    _pendingTelemetry.clear();
    pendingOtaNotice = '';
    batteryTimer?.cancel();
    _startDisconnectRediscovery();
    for (final waiters in _ackWaiters.values) {
      for (final waiter in waiters) {
        if (!waiter.isCompleted) waiter.complete('DISCONNECTED');
      }
    }
    _ackWaiters.clear();
    if (_bleConnecting) return;
    if (!mounted) return;
    setState(() {
      connected = false;
      syncing = false;
      dashboardReady = false;
      voltage = '--';
      hotsideTemp = '--';
      phoneBatteryTemp = '--';
      phoneBatteryValid = false;
      safety = 'LOCKED';
      safetyReason = 'DISCONNECTED';
      firmwareVersion = 'V?';
      resetReason = 'UNKNOWN';
      notice = JexText.of('bluetoothDisconnected', appLanguageNotifier.value);
    });
    _publishFloatingTelemetry();
    if (appNotifyBluetoothNotifier.value) {
      unawaited(_postNotification(
        JexText.of('bluetoothDisconnected', appLanguageNotifier.value),
        'JE X FYZ',
        2103,
      ));
    }
  }

  // AI-METHOD: _discoverServices — Discover exact JE X FYZ service/RX/TX, enable notifications, and complete SYNC/SYNC_READY.
  Future<void> _discoverServices(BluetoothDevice target) async {
    BluetoothCharacteristic? discoveredRx;
    BluetoothCharacteristic? discoveredTx;

    for (var discoveryAttempt = 0; discoveryAttempt < 2; discoveryAttempt++) {
      final services = await target.discoverServices().timeout(const Duration(seconds: 8));
      discoveredRx = null;
      discoveredTx = null;

      for (final service in services) {
        final serviceId = service.uuid.toString().toLowerCase();
        if (serviceId != serviceUuid) continue;
        for (final characteristic in service.characteristics) {
          final id = characteristic.uuid.toString().toLowerCase();
          if (id == rxUuid) discoveredRx = characteristic;
          if (id == txUuid) discoveredTx = characteristic;
        }
      }

      if (discoveredRx != null && discoveredTx != null) break;

      if (Platform.isAndroid && discoveryAttempt == 0) {
        try {
          await target.clearGattCache();
        } catch (e) {
          debugPrint('BLE GATT cache clear: $e');
        }
        await Future<void>.delayed(const Duration(milliseconds: 350));
      }
    }

    if (discoveredRx == null || discoveredTx == null) {
      throw StateError(JexText.of('bleServiceDiscoveryFailed', appLanguageNotifier.value));
    }

    rx = discoveredRx;
    tx = discoveredTx;

    // Register the listener BEFORE enabling notifications. Also register the
    // subscription with FlutterBluePlus so it is cancelled automatically with
    // the device connection.
    await notificationSub?.cancel();
    notificationSub = discoveredTx.lastValueStream.listen((bytes) {
      if (bytes.isNotEmpty) {
        // AI-METHOD: _parseIncoming — Parse framed full-sync data and newline telemetry/ACK messages.
        _parseIncoming(utf8.decode(bytes, allowMalformed: true));
      }
    });
    target.cancelWhenDisconnected(notificationSub!);

    await discoveredTx.setNotifyValue(true).timeout(const Duration(seconds: 5));
    await Future<void>.delayed(const Duration(milliseconds: 220));

    _bleReady = true;

    // V3.2 keeps the V3.1 atomic SYNC -> SYNC_READY protocol. Give the device
    // several opportunities to drain its automatic connect-time sync and then
    // request a clean snapshot ourselves.
    for (var attempt = 0; attempt < 5 && !fullSyncReceived && mounted; attempt++) {
      // AI-METHOD: sendCommand — Serialize GATT writes and enforce the pre-session command gate.
      await sendCommand('SYNC', showError: false);
      final deadline = DateTime.now().add(const Duration(milliseconds: 1500));
      while (mounted && !fullSyncReceived && DateTime.now().isBefore(deadline)) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }
    }

    if (!fullSyncReceived) {
      // If the first GATT session did not deliver notifications, re-subscribe
      // once before failing. The service cache was already validated above.
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await discoveredTx.setNotifyValue(false);
      await discoveredTx.setNotifyValue(true);

      for (var attempt = 0; attempt < 3 && !fullSyncReceived && mounted; attempt++) {
        // AI-METHOD: sendCommand — Serialize GATT writes and enforce the pre-session command gate.
        await sendCommand('SYNC', showError: false);
        final deadline = DateTime.now().add(const Duration(milliseconds: 1000));
        while (mounted && !fullSyncReceived && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 35));
        }
      }
    }

    if (!fullSyncReceived) {
      throw StateError(JexText.of('bleSyncFailed', appLanguageNotifier.value));
    }

    // Phase 2: open the firmware command gate. No runtime state is written by
    // the App before the firmware confirms this handshake.
    _bleSessionReady = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    final readyAccepted = await sendCommand('SYNC_READY', showError: false);
    if (!readyAccepted) {
      throw StateError(JexText.of('bleHandshakeWriteFailed', appLanguageNotifier.value));
    }

    final readyDeadline = DateTime.now().add(const Duration(milliseconds: 3500));
    while (mounted &&
        !(_syncReadyAck && fullSyncReceived && _bleSessionReady) &&
        DateTime.now().isBefore(readyDeadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    if (!_syncReadyAck || !fullSyncReceived || !_bleSessionReady) {
      throw StateError(JexText.of('bleSessionNotReady', appLanguageNotifier.value));
    }

    // Final synchronized snapshot includes the phone battery temperature.
    // AI-METHOD: _readBatteryTemperatureOnce — Read phone battery temperature through Android.
    await _readBatteryTemperatureOnce(updateUi: false);
    fullSyncReceived = false;
    // AI-METHOD: sendCommand — Serialize GATT writes and enforce the pre-session command gate.
    await sendCommand('SYNC', showError: false);
    final finalSyncDeadline = DateTime.now().add(const Duration(milliseconds: 2500));
    while (mounted &&
        !fullSyncReceived &&
        DateTime.now().isBefore(finalSyncDeadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    if (!fullSyncReceived) {
      throw StateError(JexText.of('fullSyncFailed', appLanguageNotifier.value));
    }

    if (!mounted) return;

    final readySnapshot = Map<String, String>.from(_pendingTelemetry);
    _pendingTelemetry.clear();
    final syncedOtaResult = readySnapshot['LAST_OTA_RESULT'] ?? '';
    final syncedOtaNotice = pendingOtaNotice.isNotEmpty
        ? pendingOtaNotice
        : (isTransientOtaResultEvent(syncedOtaResult)
            ? _friendlyOtaResult(syncedOtaResult)
            : '');
    pendingOtaNotice = '';

    setState(() {
      for (final entry in readySnapshot.entries) {
        // AI-METHOD: _applyTelemetryValue — Map firmware telemetry keys into typed Flutter state.
        _applyTelemetryValue(entry.key, entry.value);
      }
      connected = true;
      syncing = false;
      dashboardReady = true;
      notice = syncedOtaNotice.isNotEmpty
          ? syncedOtaNotice
          : JexText.of('systemReady', appLanguageNotifier.value);
    });
    _publishFloatingTelemetry();
    if (appNotifyBluetoothNotifier.value) {
      unawaited(_postNotification(
        JexText.of('bluetoothConnected', appLanguageNotifier.value),
        'JE X FYZ',
        2102,
      ));
    }
    // AI-METHOD: _startBatteryTelemetry — Start the 1 Hz phone-battery heartbeat.
    _startBatteryTelemetry();
    unawaited(_setBackgroundService(true));

    if (resetReason != 'POWERON' && resetReason != 'UNKNOWN') {
      _showSnackBar(
        'Reset: ${_friendlyReset(resetReason)}',
        color: Colors.orangeAccent,
      );
    }
  }

  Future<void> _disconnect() async {
    try {
      await device?.disconnect();
    } catch (e) {
      debugPrint('disconnect: $e');
    }
  }

  // AI-METHOD: sendCommand — Serialize GATT writes and enforce the pre-session command gate.
  Future<bool> sendCommand(String command, {bool showError = true}) {
    final completer = Completer<bool>();
    _writeQueue = _writeQueue.then((_) async {
      if (!_bleReady || rx == null) {
        if (showError && mounted) {
          _showSnackBar(JexText.of('bluetoothNotReady'), color: Colors.orangeAccent);
        }
        if (!completer.isCompleted) completer.complete(false);
        return;
      }

      final normalized = command.trim().toUpperCase();
      if (!_bleSessionReady &&
          normalized != 'SYNC' &&
          normalized != 'SYNC_READY') {
        if (!completer.isCompleted) completer.complete(false);
        return;
      }

      final payload = utf8.encode('$command\n');
      final canNoResponse = rx!.properties.writeWithoutResponse;
      final requiresResponse = _requiresResponse(command);

      try {
        await rx!.write(
          payload,
          withoutResponse: !requiresResponse && canNoResponse,
        ).timeout(const Duration(seconds: 4));
        if (!completer.isCompleted) completer.complete(true);
      } catch (e) {
        debugPrint('BLE write $command: $e');

        if (!completer.isCompleted) completer.complete(false);
      }
    }).catchError((_) {
      if (!completer.isCompleted) completer.complete(false);
    });
    return completer.future;
  }

  String? _ackItemForCommand(String command) {
    final c = command.trim().toUpperCase();
    if (c == 'SYNC_READY') return 'SYNC_READY';
    if (c == 'OTAENTER') return 'OTAENTER';
    if (c == 'CLOUDOTA') return 'CLOUDOTA';
    if (c == 'RGB:ON' || c == 'RGB:OFF') return 'RGB';
    if (c.startsWith('MODE:')) return 'MODE';
    if (c.startsWith('BRIGHTNESS:')) return 'BRIGHTNESS';
    if (c.startsWith('COLOR:')) return 'COLOR';
    if (c.startsWith('HOTLIMIT:')) return 'HOTLIMIT';
    if (c.startsWith('BATT5:')) return 'BATT5';
    if (c.startsWith('BATT12:')) return 'BATT12';
    if (c.startsWith('VOLTAGE:')) return 'VOLTAGE';
    if (c == 'FAN:ON' || c == 'FAN:OFF') return 'FAN';
    if (c == 'PELTIER:ON' || c == 'PELTIER:OFF') return 'PELTIER';
    if (c == 'ADAPTIVE:ON' || c == 'ADAPTIVE:OFF') return 'ADAPTIVE';
    if (c.startsWith('ADAPTIVE_PROFILE:')) return 'ADAPTIVE_PROFILE';
    if (c.startsWith('FANSPEED:')) return 'FANSPEED';
    if (c == 'RESET:TEMPERATURE') return 'RESET_TEMPERATURE';
    if (c.startsWith('SSID:')) return 'SSID';
    if (c.startsWith('PASS:')) return 'PASS';
    if (c.startsWith('URL:')) return 'URL';
    if (c.startsWith('VERSION:')) return 'VERSION';
    return null;
  }

  Future<String> _waitForAck(String item, {Duration timeout = const Duration(seconds: 3)}) async {
    final completer = Completer<String>();
    (_ackWaiters[item] ??= <Completer<String>>[]).add(completer);
    try {
      return await completer.future.timeout(timeout);
    } catch (_) {
      final list = _ackWaiters[item];
      list?.remove(completer);
      if (list != null && list.isEmpty) _ackWaiters.remove(item);
      return 'TIMEOUT';
    }
  }

  // AI-METHOD: _sendAndWaitAck — Send a command and await its firmware acknowledgement.
  Future<bool> _sendAndWaitAck(
    String command, {
    bool showError = true,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final item = _ackItemForCommand(command);
    if (item == null) return sendCommand(command, showError: showError);
    final ackFuture = _waitForAck(item, timeout: timeout);
    final sent = await sendCommand(command, showError: showError);
    if (!sent) {
      final waiters = _ackWaiters[item];
      if (waiters != null && waiters.isNotEmpty) {
        waiters.removeLast();
        if (waiters.isEmpty) _ackWaiters.remove(item);
      }
      return false;
    }
    final reason = await ackFuture;
    final accepted = reason == 'OK' ||
        reason == 'ACCEPTED' ||
        reason == 'READY' ||
        reason == 'STARTING';
    if (!accepted) return false;

    final expected = _expectedTelemetryForCommand(command);
    if (expected == null) return true;
    final confirmed = await _waitUntil(
      () => _telemetryValueMatches(expected.key, expected.value),
      timeout: timeout,
    );
    if (confirmed) return true;

    // A delta can be lost during a transient BLE notification gap. Reconcile
    // once from the firmware snapshot rather than trusting stale local state.
    final reconciled = await _requestFreshSync(
      timeout: const Duration(seconds: 2),
    );
    return reconciled &&
        _telemetryValueMatches(expected.key, expected.value);
  }

  MapEntry<String, String>? _expectedTelemetryForCommand(String command) {
    final c = command.trim().toUpperCase();
    if (c == 'FAN:ON') return const MapEntry('FAN', 'ON');
    if (c == 'FAN:OFF') return const MapEntry('FAN', 'OFF');
    if (c == 'PELTIER:ON') return const MapEntry('PELTIER', 'ON');
    if (c == 'PELTIER:OFF') return const MapEntry('PELTIER', 'OFF');
    if (c == 'ADAPTIVE:ON') return const MapEntry('ADAPTIVE', 'ON');
    if (c == 'ADAPTIVE:OFF') return const MapEntry('ADAPTIVE', 'OFF');
    if (c == 'RGB:ON') return const MapEntry('RGB', 'ON');
    if (c == 'RGB:OFF') return const MapEntry('RGB', 'OFF');
    if (c.startsWith('MODE:')) return MapEntry('MODE', c.substring(5));
    if (c.startsWith('BRIGHTNESS:')) return MapEntry('BRIGHTNESS', c.substring(11));
    if (c.startsWith('COLOR:')) return MapEntry('RGB_COLOR', c.substring(6));
    if (c.startsWith('FANSPEED:')) return MapEntry('FAN_SPEED', c.substring(9));
    if (c.startsWith('HOTLIMIT:')) return MapEntry('TEMP_HOT_LIMIT', c.substring(9));
    if (c.startsWith('BATT5:')) return MapEntry('BATT_5', c.substring(6));
    if (c.startsWith('BATT12:')) return MapEntry('BATT_12', c.substring(7));
    if (c.startsWith('ADAPTIVE_PROFILE:')) {
      return MapEntry('ADAPTIVE_PROFILE', c.substring(17));
    }
    return null;
  }

  bool _telemetryValueMatches(String key, String expected) {
    switch (key) {
      case 'FAN':
        return fanOn == (expected == 'ON');
      case 'PELTIER':
        return peltierOn == (expected == 'ON');
      case 'ADAPTIVE':
        return adaptiveOn == (expected == 'ON');
      case 'RGB':
        return rgbOn == (expected == 'ON');
      case 'MODE':
        return rgbMode == (int.tryParse(expected) ?? -1);
      case 'BRIGHTNESS':
        return brightness == (int.tryParse(expected) ?? -1);
      case 'RGB_COLOR':
        return rgbColor.toUpperCase() == expected.toUpperCase();
      case 'FAN_SPEED':
        return fanSpeed == (int.tryParse(expected) ?? -1);
      case 'TEMP_HOT_LIMIT':
        return hotLimit == (int.tryParse(expected) ?? -1);
      case 'BATT_5':
        return battery5Limit == (int.tryParse(expected) ?? -1);
      case 'BATT_12':
        return battery12Limit == (int.tryParse(expected) ?? -1);
      case 'ADAPTIVE_PROFILE':
        return adaptiveProfile.toUpperCase() == expected.toUpperCase();
      default:
        return false;
    }
  }

  Future<bool> _waitUntil(bool Function() predicate, {Duration timeout = const Duration(seconds: 3)}) async {
    final deadline = DateTime.now().add(timeout);
    while (mounted && DateTime.now().isBefore(deadline)) {
      if (predicate()) return true;
      await Future<void>.delayed(const Duration(milliseconds: 35));
    }
    return predicate();
  }

  bool _requiresResponse(String command) {
    final c = command.trim().toUpperCase();
    return c == 'SYNC' ||
        c == 'SYNC_READY' ||
        c == 'CLOUDOTA' ||
        c == 'OTAENTER' ||
        c.startsWith('VOLTAGE:') ||
        c.startsWith('SSID:') ||
        c.startsWith('PASS:') ||
        c.startsWith('URL:') ||
        c.startsWith('VERSION:') ||
        c.startsWith('FAN:') ||
        c.startsWith('PELTIER:') ||
        c.startsWith('ADAPTIVE_PROFILE:') ||
        c.startsWith('ADAPTIVE:') ||
        c.startsWith('FANSPEED:') ||
        c.startsWith('HOTLIMIT:') ||
        c.startsWith('BATT5:') ||
        c.startsWith('BATT12:') ||
        c.startsWith('RESET:') ||
        c.startsWith('PHONE:BT=');
  }

  // AI-METHOD: _parseIncoming — Parse framed full-sync data and newline telemetry/ACK messages.
  void _parseIncoming(String incoming) {
    incomingBuffer += incoming;
    if (incomingBuffer.length > 16000) {
      final marker = incomingBuffer.lastIndexOf('<SYNC_START>');
      incomingBuffer = marker >= 0 ? incomingBuffer.substring(marker) : '';
    }

    while (true) {
      final start = incomingBuffer.indexOf('<SYNC_START>');
      if (start < 0) break;
      final end = incomingBuffer.indexOf('<SYNC_END>', start);
      if (end < 0) break;

      final before = incomingBuffer.substring(0, start);
      if (before.isNotEmpty) {
        for (final line in before.split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isNotEmpty) _applyLine(trimmed);
        }
      }

      final payload = incomingBuffer.substring(
        start + '<SYNC_START>'.length,
        end,
      );
      incomingBuffer = incomingBuffer.substring(end + '<SYNC_END>'.length);

      _syncSnapshot.clear();
      for (final rawLine in payload.split('\n')) {
        final line = rawLine.trim();
        if (line.isEmpty) continue;
        if (line.startsWith('ACK:')) {
          _handleAckLine(line);
          continue;
        }
        final separator = line.indexOf(':');
        if (separator <= 0) continue;
        final key = line.substring(0, separator).trim();
        final value = line.substring(separator + 1).trim();
        _syncSnapshot[key] = value;
      }
      // AI-METHOD: _commitTelemetry — Buffer setup telemetry until dashboard readiness; otherwise update UI state.
      _commitTelemetry(_syncSnapshot);
      fullSyncReceived = true;
    }

    while (incomingBuffer.contains('\n') && !incomingBuffer.contains('<SYNC_START>')) {
      final nl = incomingBuffer.indexOf('\n');
      final line = incomingBuffer.substring(0, nl).trim();
      incomingBuffer = incomingBuffer.substring(nl + 1);
      if (line.isNotEmpty) _applyLine(line);
    }
  }

  void _handleAckLine(String line) {
    final parts = line.substring(4).split(';');
    final item = parts.isNotEmpty ? parts[0].split('=').first.trim().toUpperCase() : '';
    final rawReason = parts.length > 1 && parts[1].startsWith('REASON=')
        ? parts[1].substring(7)
        : 'UNKNOWN';
    final reason = rawReason.trim().toUpperCase();

    final waiters = _ackWaiters[item];
    if (waiters != null && waiters.isNotEmpty) {
      final waiter = waiters.removeAt(0);
      if (!waiter.isCompleted) waiter.complete(reason);
      if (waiters.isEmpty) _ackWaiters.remove(item);
    }

    if (item == 'SYNC_READY' &&
        (reason == 'OK' || reason == 'READY' || reason == 'STARTING')) {
      _syncReadyAck = true;
      return;
    }

    if (reason != 'OK' &&
        reason != 'ACCEPTED' &&
        reason != 'READY' &&
        reason != 'STARTING') {
      _showSnackBar(_friendlyReason(reason), color: Colors.orangeAccent);
    }
  }

  void _applyLine(String line) {
    if (line.isEmpty) return;
    if (line.startsWith('ACK:')) {
      _handleAckLine(line);
      return;
    }
    final separator = line.indexOf(':');
    if (separator <= 0) return;
    final key = line.substring(0, separator).trim();
    final value = line.substring(separator + 1).trim();
    // AI-METHOD: _commitTelemetry — Buffer setup telemetry until dashboard readiness; otherwise update UI state.
    _commitTelemetry(<String, String>{key: value});
  }

  // AI-METHOD: _commitTelemetry — Buffer setup telemetry until dashboard readiness; otherwise update UI state.
  void _commitTelemetry(Map<String, String> values) {
    if (values.isEmpty) return;

    // The BLE session gate must be observable during the pre-dashboard
    // handshake. The firmware sends BLE_SESSION=READY inside the SYNC_READY
    // full snapshot, while all other telemetry remains buffered until the
    // final verified sync is complete.
    if (!dashboardReady) {
      final session = values['BLE_SESSION'];
      if (session != null) {
        _bleSessionReady = session.trim().toUpperCase() == 'READY';
      }
      final otaResult = values['LAST_OTA_RESULT'];
      if (otaResult != null && isTransientOtaResultEvent(otaResult)) {
        pendingOtaNotice = _friendlyOtaResult(otaResult);
      }
      _pendingTelemetry.addAll(values);
      return;
    }

    if (!mounted) return;
    setState(() {
      for (final entry in values.entries) {
        // AI-METHOD: _applyTelemetryValue — Map firmware telemetry keys into typed Flutter state.
        _applyTelemetryValue(entry.key, entry.value);
      }
    });

    final hotText = values['HOT'];
    final hot = hotText == null ? null : double.tryParse(hotText);
    if (hot != null && hot.isFinite) {
      if (hot < hotLimit) hotAlertArmed = true;
      if (hot >= hotLimit &&
          hotAlertArmed &&
          appNotifySafetyNotifier.value &&
          connected) {
        hotAlertArmed = false;
        unawaited(_postNotification(
          JexText.of('safetyAlert', appLanguageNotifier.value),
          JexText.of('hotsideLimit', appLanguageNotifier.value) + ' ' + hotLimit.toString() + '°C.',
          2101,
        ));
      }
    }
    _publishFloatingTelemetry();
  }

  // AI-METHOD: _applyTelemetryValue — Map firmware telemetry keys into typed Flutter state.
  void _applyTelemetryValue(String key, String value) {
    switch (key) {
      case 'VERSION':
        firmwareVersion = value;
        break;
      case 'PROTOCOL':
        break;
      case 'STATE_SEQ':
        stateSequence = int.tryParse(value) ?? stateSequence;
        break;
      case 'BLE_SESSION':
        _bleSessionReady = value == 'READY';
        break;
      case 'VOLTAGE':
        voltage = value;
        if (adaptiveTransitioning && value == '5V') {
          adaptiveTransitioning = false;
        }
        break;
      case 'FAN':
        fanOn = value == 'ON';
        break;
      case 'PELTIER':
        peltierOn = value == 'ON';
        break;
      case 'HOT':
        hotsideTemp = value == '--' ? '--' : value;
        break;
      case 'BATTERY':
        phoneBatteryTemp = value;
        break;
      case 'BATTERY_VALID':
        phoneBatteryValid = value == '1';
        if (!phoneBatteryValid) phoneBatteryTemp = '--';
        break;
      case 'ADAPTIVE':
        adaptiveOn = value == 'ON';
        if (!adaptiveOn) {
          adaptiveTransitioning = false;
        } else if (voltage != '5V') {
          adaptiveTransitioning = true;
        }
        break;
      case 'ADAPTIVE_CEILING':
        adaptiveCeiling = value;
        break;
      case 'ADAPTIVE_PROFILE':
        adaptiveProfile = value.toUpperCase();
        break;
      case 'RGB':
        rgbOn = value == 'ON';
        break;
      case 'MODE':
        rgbMode = (int.tryParse(value) ?? rgbMode).clamp(1, 7).toInt();
        break;
      case 'BRIGHTNESS':
        brightness = (int.tryParse(value) ?? brightness).clamp(1, 100).toInt();
        brightnessDraft = brightness;
        break;
      case 'RGB_COLOR':
        rgbColor = value;
        break;
      case 'FAN_SPEED':
        fanSpeed = int.tryParse(value) ?? fanSpeed;
        fanSpeedDraft = fanSpeed;
        break;
      case 'SAFETY':
        safety = value;
        break;
      case 'SAFETY_REASON':
        safetyReason = value;
        break;
      case 'OTA_STATE':
        otaState = value;
        break;
      case 'OTA_STAGE':
        otaStage = value;
        break;
      case 'OTA_PROGRESS':
        otaProgress = (int.tryParse(value) ?? otaProgress).clamp(0, 100).toInt();
        break;
      case 'OTA_ERROR_CODE':
        otaErrorCode = int.tryParse(value) ?? otaErrorCode;
        break;
      case 'OTA_ERROR':
        otaError = value;
        break;
      case 'LAST_OTA_RESULT':
        // LAST_OTA_RESULT is event-only. Baseline/history values never replace Home NOTIFY.
        if (isTransientOtaResultEvent(value)) {
          notice = _friendlyOtaResult(value);
        }
        break;
      case 'RESET_REASON':
        resetReason = value;
        break;
      case 'TEMP_HOT_LIMIT':
        hotLimit = (int.tryParse(value) ?? hotLimit).clamp(40, 50).toInt();
        hotLimitDraft = hotLimit;
        break;
      case 'BATT_5':
        battery5Limit = (int.tryParse(value) ?? battery5Limit).clamp(20, 48).toInt();
        battery5Draft = battery5Limit;
        break;
      case 'BATT_12':
        battery12Limit = (int.tryParse(value) ?? battery12Limit).clamp(22, 50).toInt();
        battery12Draft = battery12Limit;
        break;
      case 'NTC_MV':
        break;
    }
  }

  // AI-METHOD: _startBatteryTelemetry — Start the 1 Hz phone-battery heartbeat.
  void _startBatteryTelemetry() {
    batteryTimer?.cancel();
    batteryTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      // AI-METHOD: _readBatteryTemperatureOnce — Read phone battery temperature through Android.
      _readBatteryTemperatureOnce();
    });
  }

  // AI-METHOD: _readBatteryTemperatureOnce — Read phone battery temperature through Android.
  Future<void> _readBatteryTemperatureOnce({bool updateUi = true}) async {
    if (batteryReadBusy) return;
    batteryReadBusy = true;
    try {
      final value = await batteryChannel.invokeMethod<dynamic>('getBatteryTemperature');
      final temp = value is num ? value.toDouble() : -1.0;
      final valid = temp >= 0.0 && temp <= 100.0;

      if (updateUi && mounted) {
        setState(() {
          phoneBatteryValid = valid;
          phoneBatteryTemp = valid ? temp.toStringAsFixed(1) : '--';
        });
        _publishFloatingTelemetry();
      }

      if (_bleReady) {
        // AI-METHOD: sendCommand — Serialize GATT writes and enforce the pre-session command gate.
        await sendCommand(
          valid ? 'PHONE:BT=${temp.toStringAsFixed(1)}' : 'PHONE:BT=-1.0',
          showError: false,
        );
      }
    } catch (e) {
      debugPrint('Battery temp: $e');
      if (mounted) {
        setState(() {
          phoneBatteryValid = false;
          phoneBatteryTemp = '--';
        });
      }
    } finally {
      batteryReadBusy = false;
    }
  }

  // AI-METHOD: _sendAndConfirm — Wait for telemetry confirmation after a state-changing command.
  Future<bool> _sendAndConfirm(
    String command, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final accepted = await _sendAndWaitAck(
      command,
      showError: false,
      timeout: timeout,
    );
    if (accepted) {
      _notifyCommandAccepted(command);
    }
    return accepted;
  }

  // AI-METHOD: _requestVoltage — Apply the 1-second manual voltage guard.
  Future<void> _requestVoltage(String target) async {
    if (!connected ||
        adaptiveOn ||
        voltageGuardActive ||
        !isVoltageCommand(target)) {
      return;
    }
    if (target == voltage) return;

    try {
      if (mounted) setState(() => voltageGuardActive = true);
    voltageGuardTimer?.cancel();
    voltageGuardTimer = Timer(voltageGuardDuration, () {
      if (mounted) setState(() => voltageGuardActive = false);
    });

    final accepted = await _sendAndConfirm(
      'VOLTAGE:$target',
      timeout: const Duration(seconds: 3),
    );
      if (!accepted) {
        voltageGuardTimer?.cancel();
        if (mounted) {
          setState(() => voltageGuardActive = false);
          _showSnackBar(JexText.phrase('Voltage change not confirmed.','Perubahan tegangan tidak dikonfirmasi.'));
        }
      }
    } catch (e) {
      debugPrint('Voltage command: $e');
      voltageGuardTimer?.cancel();
      if (mounted) {
        setState(() => voltageGuardActive = false);
        _showSnackBar(JexText.phrase('Voltage change failed.','Perubahan tegangan gagal.'));
      }
    }
  }

  // AI-METHOD / FAN-COMMAND-CONTRACT
  // Send only the frozen FAN:ON/FAN:OFF protocol token. Firmware telemetry is authoritative;
  // this function never invents or localizes the protocol value. User-facing errors are localized.
  Future<void> _toggleFan(bool enabled) async {
    if (!connected || adaptiveOn) return;
    try {
      final ok = await _sendAndConfirm(
        enabled ? 'FAN:ON' : 'FAN:OFF',
      );
      if (!ok && mounted) {
        _showSnackBar(JexText.phrase('Fan change was not confirmed by the device.','Perubahan kipas tidak dikonfirmasi oleh perangkat.'), color: Colors.orangeAccent);
      }
    } catch (e) {
      debugPrint('Fan command: $e');
      if (mounted) _showSnackBar(JexText.phrase('Fan command failed.','Perintah kipas gagal.'), color: Colors.orangeAccent);
    }
  }

  // AI-METHOD / PELTIER-COMMAND-CONTRACT
  // Enforce the UI-side Fan prerequisite, then send the frozen PELTIER command and wait for
  // authoritative telemetry. Firmware remains the final safety authority.
  Future<void> _togglePeltier(bool enabled) async {
    if (!connected || adaptiveOn) return;
    try {
      if (enabled && !fanOn) {
        final approved = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(JexText.of('peltierSafety')),
            content: Text(JexText.of('fanRequiredPeltier')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(JexText.of('cancel')),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(JexText.of('turnOnFan')),
              ),
            ],
          ),
        );
        if (approved != true) return;
        final fanOk = await _sendAndConfirm('FAN:ON');
        if (!fanOk) {
          _showSnackBar(JexText.phrase('Fan activation was not confirmed by the device.','Pengaktifan kipas tidak dikonfirmasi oleh perangkat.'), color: Colors.orangeAccent);
          return;
        }
      }

      final ok = await _sendAndConfirm(
        enabled ? 'PELTIER:ON' : 'PELTIER:OFF',
        timeout: const Duration(seconds: 6),
      );
      if (!ok && mounted) {
        _showSnackBar(JexText.phrase('Peltier change was not confirmed by the device. ${safetyReason == 'NONE' ? '' : safetyReason}','Perubahan Peltier tidak dikonfirmasi oleh perangkat. ${safetyReason == 'NONE' ? '' : safetyReason}'), color: Colors.orangeAccent);
      }
    } catch (e) {
      debugPrint('Peltier command: $e');
      if (mounted) _showSnackBar(JexText.phrase('Peltier command failed.','Perintah Peltier gagal.'), color: Colors.orangeAccent);
    }
  }

  // AI-METHOD / ADAPTIVE-COMMAND-CONTRACT
  // Send the frozen ADAPTIVE command and wait for telemetry. Firmware determines resulting
  // voltage/safety behavior; Flutter only presents the confirmed state.
  Future<void> _toggleAdaptive(bool enabled) async {
    if (!connected) return;
    if (mounted) setState(() {
      adaptiveTransitioning = true;
    });
    try {
      final ok = await _sendAndConfirm(
        enabled ? 'ADAPTIVE:ON' : 'ADAPTIVE:OFF',
        timeout: const Duration(seconds: 4),
      );
      if (!ok && mounted) {
        _showSnackBar(JexText.phrase('Adaptive Mode change was not confirmed by the device.','Perubahan Mode Adaptif tidak dikonfirmasi oleh perangkat.'), color: Colors.orangeAccent);
      }
    } finally {
      if (mounted) {
        setState(() {
          adaptiveTransitioning = false;
        });
      }
    }
  }

  // AI-METHOD: _setRgb — Set master RGB ON/OFF.
  Future<void> _setRgb(bool enabled) async {
    if (!connected) return;
    try {
      final ok = await _sendAndConfirm(
        'RGB:' + (enabled ? 'ON' : 'OFF'),
      );
      if (!ok && mounted) {
        _showSnackBar(JexText.phrase('LED power change was not confirmed by the device.','Perubahan daya LED tidak dikonfirmasi oleh perangkat.'));
      }
    } catch (e) {
      debugPrint('LED power command: $e');
      if (mounted) _showSnackBar(JexText.phrase('LED power command failed.','Perintah daya LED gagal.'));
    }
  }

  // AI-METHOD: _setMode — Set LED animation mode within the supported range.
  Future<void> _setMode(int mode) async {
    if (!connected) return;
    try {
      final next = mode.clamp(1, 7).toInt();
      final ok = await _sendAndConfirm('MODE:$next');
      if (!ok && mounted) {
        _showSnackBar(JexText.phrase('LED mode change was not confirmed by the device.','Perubahan mode LED tidak dikonfirmasi oleh perangkat.'));
      }
    } catch (e) {
      debugPrint('LED mode command: $e');
      if (mounted) _showSnackBar(JexText.phrase('LED mode command failed.','Perintah mode LED gagal.'));
    }
  }

  // AI-METHOD: _setBrightness — Set LED brightness 1–100; firmware maps this to hardware 0–255.
  Future<void> _setBrightness(double value) async {
    if (!connected) return;
    final next = value.round().clamp(1, 100).toInt();
    final previous = brightnessDraft.clamp(1, 100).toInt();

    try {
      final ok = await _sendAndConfirm('BRIGHTNESS:' + next.toString());
      if (ok) {
        if (mounted) {
          setState(() {
            brightness = next;
            brightnessDraft = next;
          });
        }
        return;
      }

      if (mounted) {
        setState(() => brightness = previous);
        _showSnackBar(JexText.phrase('LED brightness change was not confirmed by the device.','Perubahan kecerahan LED tidak dikonfirmasi oleh perangkat.'));
      }
    } catch (e) {
      debugPrint('LED brightness command: $e');
      if (mounted) {
        setState(() => brightness = previous);
        _showSnackBar(JexText.phrase('LED brightness command failed.','Perintah kecerahan LED gagal.'));
      }
    }
  }

  // AI-METHOD: _setRgbColor — Apply one palette color to firmware RGB color.
  Future<void> _setRgbColor(String hex) async {
    if (!connected || rgbMode == 7) return;
    final value = hex.trim().toUpperCase();
    if (!ledColorPalette.contains(value)) return;

    try {
      final ok = await _sendAndConfirm('COLOR:' + value.substring(1));
      if (!ok) {
        if (mounted) {
          _showSnackBar(JexText.phrase('Color change was not confirmed by the device.','Perubahan warna tidak dikonfirmasi oleh perangkat.'));
        }
        return;
      }

      if (mounted) {
        setState(() => rgbColor = value);
      }
    } catch (e) {
      debugPrint('LED color command: $e');
      if (mounted) _showSnackBar(JexText.phrase('LED color command failed.','Perintah warna LED gagal.'));
    }
  }

  // AI-METHOD / FAN-SPEED-CONTRACT
  // Accept 50–100% in 10% steps. Control is valid only for connected, non-Adaptive 12V mode;
  // the UI hides this control entirely when Fan is OFF.
  Future<void> _setFanSpeed(double value) async {
    if (!connected || adaptiveOn || voltage != '12V') return;
    try {
      final next = ((value / 10).round() * 10)
          .clamp(fanSpeedMin, fanSpeedMax)
          .toInt();
      final ok = await _sendAndConfirm('FANSPEED:$next');
      if (!ok && mounted) {
        setState(() => fanSpeedDraft = fanSpeed);
        _showSnackBar(JexText.phrase('Fan speed change was not confirmed by the device.','Perubahan kecepatan kipas tidak dikonfirmasi oleh perangkat.'));
      }
    } catch (e) {
      debugPrint('Fan speed command: $e');
      if (mounted) _showSnackBar(JexText.phrase('Fan speed command failed.','Perintah kecepatan kipas gagal.'));
    }
  }

  // AI-METHOD: _setHotLimit — Set the hotside protection threshold.
  Future<void> _setHotLimit(int value) async {
    if (!connected || adaptiveOn) return;
    try {
      final next = value.clamp(40, 50).toInt();
      if (mounted) setState(() => hotLimitDraft = next);
      final ok = await _sendAndConfirm('HOTLIMIT:$next');
      if (!ok && mounted) {
        setState(() => hotLimitDraft = hotLimit);
        _showSnackBar(JexText.of('hotsideLimitNotConfirmed', appLanguageNotifier.value));
      }
    } catch (e) {
      debugPrint('Hotside limit command: $e');
      if (mounted) {
        setState(() => hotLimitDraft = hotLimit);
        _showSnackBar(JexText.of('hotsideLimitFailed', appLanguageNotifier.value));
      }
    }
  }

  // AI-METHOD: _setBattery5 — Set the 5V battery-temperature threshold.
  Future<void> _setBattery5(int value) async {
    if (!connected || adaptiveOn) return;
    try {
      final next = value.clamp(20, 48).toInt();
      if (next >= battery12Limit - 1) return;
      if (mounted) setState(() => battery5Draft = next);
      final ok = await _sendAndConfirm('BATT5:$next');
      if (!ok && mounted) {
        setState(() => battery5Draft = battery5Limit);
        _showSnackBar(JexText.of('battery5LimitNotConfirmed', appLanguageNotifier.value));
      }
    } catch (e) {
      debugPrint('Battery 5V command: $e');
      if (mounted) {
        setState(() => battery5Draft = battery5Limit);
        _showSnackBar(JexText.of('battery5LimitFailed', appLanguageNotifier.value));
      }
    }
  }

  // AI-METHOD: _setBattery12 — Set the 12V battery-temperature threshold.
  Future<void> _setBattery12(int value) async {
    if (!connected || adaptiveOn) return;
    try {
      final next = value.clamp(22, 50).toInt();
      if (next <= battery5Limit + 1) return;
      if (mounted) setState(() => battery12Draft = next);
      final ok = await _sendAndConfirm('BATT12:$next');
      if (!ok && mounted) {
        setState(() => battery12Draft = battery12Limit);
        _showSnackBar(JexText.of('battery12LimitNotConfirmed', appLanguageNotifier.value));
      }
    } catch (e) {
      debugPrint('Battery 12V command: $e');
      if (mounted) {
        setState(() => battery12Draft = battery12Limit);
        _showSnackBar(JexText.of('battery12LimitFailed', appLanguageNotifier.value));
      }
    }
  }


  Future<void> _resetTemperatureSettings() async {
    if (!connected || adaptiveOn) return;
    try {
      final ok = await _sendAndConfirm('RESET:TEMPERATURE');
      if (!ok && mounted) _showSnackBar(JexText.phrase('Temperature reset was not confirmed by the device.','Reset suhu tidak dikonfirmasi oleh perangkat.'));
    } catch (e) {
      debugPrint('Temperature reset: $e');
      if (mounted) _showSnackBar(JexText.phrase('Temperature reset failed.','Reset suhu gagal.'));
    }
  }


  // AI-METHOD: _requestFreshSync — Request a fresh firmware snapshot without replaying local state.
  Future<bool> _requestFreshSync({Duration timeout = const Duration(seconds: 3)}) async {
    fullSyncReceived = false;
    final sent = await sendCommand('SYNC', showError: false);
    if (!sent) return false;
    return _waitUntil(() => fullSyncReceived, timeout: timeout);
  }

  Future<void> _openSettings() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SettingsPage(
          currentFirmwareVersion: firmwareVersion,
          onOpenFirmwareUpdate: _openFirmwareSettings,
        ),
      ),
    );
  }

  Future<void> _setAdaptiveProfile(String profile) async {
    if (!connected || adaptiveOn) return;
    final ok = await _sendAndConfirm('ADAPTIVE_PROFILE:' + profile);
    if (!ok && mounted) {
      _showSnackBar(
        JexText.phrase('Adaptive profile change was not confirmed by the device.','Perubahan profil Adaptif tidak dikonfirmasi oleh perangkat.'),
        color: Colors.orangeAccent,
      );
    }
  }

  Future<void> _showLedColorPicker() async {
    if (!connected || rgbMode == 7) return;

    final renderObject = _ledColorAnchorKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;

    final anchor = renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final media = MediaQuery.of(context);
    final popupWidth = math.min(320.0, media.size.width - 20.0);
    const popupHeight = 246.0;
    const edge = 10.0;

    var left = anchor.right - popupWidth;
    left = left.clamp(edge, media.size.width - popupWidth - edge).toDouble();

    final spaceAbove = anchor.top - media.padding.top - edge;
    final spaceBelow = media.size.height - media.padding.bottom - anchor.bottom - edge;
    final openAbove = spaceAbove >= popupHeight || spaceAbove >= spaceBelow;
    final top = openAbove
        ? (anchor.top - popupHeight - 8).clamp(
            media.padding.top + edge,
            media.size.height - popupHeight - edge,
          )
        : (anchor.bottom + 8).clamp(
            media.padding.top + edge,
            media.size.height - popupHeight - edge,
          );

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: JexText.of('color', appLanguageNotifier.value),
      barrierColor: Colors.black.withValues(alpha: .08),
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (dialogContext, _, __) {
        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: popupWidth,
              child: Material(
                color: Colors.transparent,
                child: _JexColorPickerCard(
                  colors: ledColorPalette,
                  selected: rgbColor.toUpperCase(),
                  onSelected: (value) async {
                    await _setRgbColor(value);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  },
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, animation, __, child) {
        final scale = Tween<double>(begin: .96, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: scale,
            alignment: Alignment.topRight,
            child: child,
          ),
        );
      },
    );
  }

  

  // AI-METHOD: _openFirmwareSettings — Open the external firmware update dialog.
  Future<void> _openFirmwareSettings() async {
    if (!connected) {
      _showSnackBar(JexText.of('connectFirst'), color: Colors.orangeAccent);
      return;
    }
    // AI-METHOD: _requestFreshSync — Request a fresh firmware snapshot without replaying local state.
    await _requestFreshSync();
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => FirmwareUpdateDialog(
        currentVersion: firmwareVersion,
        onUpdate: _startCloudOta,
      ),
    );
  }

  // AI-METHOD: _startCloudOta — Send Online OTA metadata/credentials to firmware and monitor BLE recovery.
  Future<void> _startCloudOta(
    String ssid,
    String password,
    String url,
    String version,
  ) async {
    if (!connected || !url.startsWith('https://')) return;
    if (ssid.trim().isEmpty || password.isEmpty) return;

    final commands = <String>[
      'OTAENTER',
      'SSID:${ssid.trim()}',
      'PASS:$password',
      'URL:$url',
      'VERSION:$version',
      'CLOUDOTA',
    ];

    for (final command in commands) {
      final ok = await _sendAndWaitAck(command, showError: false, timeout: const Duration(seconds: 4));
      if (!ok) {
        _showSnackBar(
          'OTA could not start: command ${_ackItemForCommand(command) ?? command} was rejected by the device.',
          color: Colors.redAccent,
        );
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }

    _showSnackBar(
      'OTA in progress.',
      color: Colors.purpleAccent,
    );
    // AI-METHOD: _startOtaReconnectMonitor — Retry BLE discovery after OTA disconnect/restart.
    _startOtaReconnectMonitor();
  }

  // AI-METHOD: _startOtaReconnectMonitor — Retry BLE discovery after OTA disconnect/restart.
  void _startOtaReconnectMonitor() {
    reconnectTimer?.cancel();
    int attempts = 0;
    reconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (connected || attempts >= 12) {
        timer.cancel();
        return;
      }
      attempts++;
      // AI-METHOD: _scanAndConnect — Perform bounded BLE discovery and pass the matching device to the connection routine.
      await _tryAutoConnect();
      if (connected) timer.cancel();
    });
  }

  Map<String, String> _otaDiagnosticFields(String raw) {
    final fields = <String, String>{};
    for (final part in raw.split('|')) {
      final index = part.indexOf('=');
      if (index <= 0) continue;
      fields[part.substring(0, index).trim().toUpperCase()] =
          part.substring(index + 1).trim();
    }
    return fields;
  }

  // AI-METHOD: _friendlyOtaStage — Translate frozen OTA stage tokens into localized presentation text.
  String _friendlyOtaStage(String stage) {
    const keyByStage = <String, String>{
      'LOCAL_FILE_CHECK': 'otaStageLocalFileCheck',
      'LOCAL_SIZE_CHECK': 'otaStageLocalSizeCheck',
      'LOCAL_UPDATE_BEGIN': 'otaStageLocalUpdateBegin',
      'LOCAL_RECEIVE': 'otaStageLocalReceive',
      'LOCAL_FLASH_WRITE': 'otaStageLocalFlashWrite',
      'LOCAL_SIZE_VERIFY': 'otaStageLocalSizeVerify',
      'LOCAL_FINALIZE': 'otaStageLocalFinalize',
      'LOCAL_FLASH_READBACK': 'otaStageLocalFlashReadback',
      'LOCAL_FLASH_ERASE': 'otaStageLocalFlashErase',
      'LOCAL_BOOT_PARTITION': 'otaStageLocalBootPartition',
      'ONLINE_WIFI_CONNECT': 'otaStageOnlineWifiConnect',
      'ONLINE_WIFI_CONNECTED': 'otaStageOnlineWifiConnected',
      'ONLINE_WIFI_FAILED': 'otaStageOnlineWifiFailed',
      'ONLINE_WIFI_DROPPED': 'otaStageOnlineWifiDropped',
      'ONLINE_TIME_SYNC': 'otaStageOnlineTimeSync',
      'ONLINE_GITHUB_CONNECT': 'otaStageOnlineGithubConnect',
      'ONLINE_GITHUB_CONNECTED': 'otaStageOnlineGithubConnected',
      'ONLINE_HTTP_UPDATE': 'otaStageOnlineHttpUpdate',
      'ONLINE_UPDATE_BEGIN': 'otaStageOnlineUpdateBegin',
      'ONLINE_DOWNLOAD': 'otaStageOnlineDownload',
      'ONLINE_DOWNLOAD_COMPLETE': 'otaStageOnlineDownloadComplete',
      'ONLINE_FLASH_PREPARE': 'otaStageOnlineFlashPrepare',
      'ONLINE_FLASH_FINALIZE': 'otaStageOnlineFlashFinalize',
      'ONLINE_FLASH_SUCCESS': 'otaStageOnlineFlashSuccess',
      'ONLINE_RANGE_PROBE': 'otaStageOnlineRangeProbe',
      'ONLINE_RANGE_REQUEST': 'otaStageOnlineRangeRequest',
      'ONLINE_RANGE_RESPONSE': 'otaStageOnlineRangeResponse',
      'ONLINE_RANGE_WRITE': 'otaStageOnlineRangeWrite',
      'ONLINE_RANGE_RETRY': 'otaStageOnlineRangeRetry',
      'ONLINE_RANGE_RESUME': 'otaStageOnlineRangeResume',
      'ONLINE_FLASH_WRITE': 'otaStageOnlineFlashWrite',
      'ONLINE_FLASH_ERASE': 'otaStageOnlineFlashErase',
      'ONLINE_FLASH_READBACK': 'otaStageOnlineFlashReadback',
      'ONLINE_IMAGE_VALIDATE': 'otaStageOnlineImageValidate',
      'ONLINE_IMAGE_VERIFY': 'otaStageOnlineImageVerify',
      'ONLINE_BOOT_PARTITION': 'otaStageOnlineBootPartition',
      'ONLINE_HTTP_RESPONSE': 'otaStageOnlineHttpResponse',
    };
    final key = keyByStage[stage.trim().toUpperCase()] ?? 'unknownOtaStage';
    return JexText.of(key, appLanguageNotifier.value);
  }

  // AI-METHOD: _friendlyOtaResult — Translate one-shot OTA result events into Home NOTIFY text.
  String _friendlyOtaMode(String mode) {
    switch (mode.trim().toUpperCase()) {
      case 'LOCAL':
        return JexText.of('otaModeLocal', appLanguageNotifier.value);
      case 'ONLINE':
        return JexText.of('otaModeOnline', appLanguageNotifier.value);
      default:
        return mode.trim().isEmpty ? 'OTA' : mode.trim();
    }
  }

  // AI-METHOD: _friendlyOtaResult — Translate OTA result envelopes while preserving technical diagnostics.
  String _friendlyOtaResult(String value) {
    final raw = value.trim();
    if (raw.isEmpty || raw.toUpperCase() == 'NONE') return '';
    final upper = raw.toUpperCase();

    if (upper.startsWith('OTA_FAILED|')) {
      final fields = _otaDiagnosticFields(raw);
      final mode = _friendlyOtaMode(fields['MODE'] ?? 'OTA');
      final stage = _friendlyOtaStage(fields['STAGE'] ?? 'UNKNOWN');
      final error = fields['ERROR'] ?? JexText.of('unknownError', appLanguageNotifier.value);
      final progress = fields['PROGRESS'] ?? '--';
      final code = fields['CODE'] ?? '0';
      return JexText.of('otaFailed', appLanguageNotifier.value) + ' • $mode • $stage • $error [${progress}% / code $code]';
    }

    if (upper.startsWith('OTA_SUCCESS|')) {
      final fields = _otaDiagnosticFields(raw);
      final mode = _friendlyOtaMode(fields['MODE'] ?? 'OTA');
      final stage = _friendlyOtaStage(fields['STAGE'] ?? 'UNKNOWN');
      final version = fields['VERSION'] ?? '';
      return JexText.of('otaSuccessful', appLanguageNotifier.value) + ' • $mode • $stage${version.isEmpty ? '' : ' • $version'}';
    }

    if (upper.startsWith('IN_PROGRESS|')) {
      final fields = _otaDiagnosticFields(raw);
      final mode = _friendlyOtaMode(fields['MODE'] ?? 'OTA');
      final stage = _friendlyOtaStage(fields['STAGE'] ?? 'UNKNOWN');
      final progress = fields['PROGRESS'] ?? '0';
      return JexText.of('otaProgress', appLanguageNotifier.value) + '$mode • $stage • ${progress}%';
    }

    if (upper == 'IN_PROGRESS') return JexText.of('otaInProgress', appLanguageNotifier.value);
    if (upper == 'LOCAL_SUCCESS') return JexText.of('otaLocalSuccessful', appLanguageNotifier.value);
    if (upper.startsWith('SUCCESS_')) {
      return JexText.of('otaSuccessfulGeneric', appLanguageNotifier.value) + raw.substring(8) + '.';
    }
    if (upper.startsWith('UPLOAD_SIZE_MISMATCH_')) {
      final parts = raw.split('_');
      if (parts.length >= 5) {
        return JexText.of('otaUploaded', appLanguageNotifier.value) + parts[3] + ' / ' + parts[4] + JexText.of('otaBytes', appLanguageNotifier.value);
      }
      return JexText.of('otaSizeMismatch', appLanguageNotifier.value);
    }
    if (upper.startsWith('OTA_END_ERROR_')) {
      final parts = raw.split('_');
      if (parts.length >= 5) {
        return JexText.of('otaFailedGeneric', appLanguageNotifier.value) + parts.sublist(4).join(' ').toLowerCase() + '.';
      }
      return JexText.of('otaFinalizationError', appLanguageNotifier.value);
    }
    if (upper.contains('FAILED') || upper.contains('ERROR')) {
      return JexText.of('otaFailedGeneric', appLanguageNotifier.value) + raw.replaceAll('_', ' ').toLowerCase() + '.';
    }
    return raw.replaceAll('_', ' ');
  }

  String _friendlyReset(String value) {
    switch (value) {
      case 'BROWNOUT': return JexText.of('resetBrownout', appLanguageNotifier.value);
      case 'PANIC': return JexText.of('resetPanic', appLanguageNotifier.value);
      case 'SOFTWARE': return JexText.of('resetSoftware', appLanguageNotifier.value);
      case 'WDT':
      case 'INT_WDT':
      case 'TASK_WDT': return JexText.of('resetWatchdog', appLanguageNotifier.value);
      case 'EXTERNAL': return JexText.of('resetExternal', appLanguageNotifier.value);
      case 'DEEPSLEEP': return JexText.of('resetDeepSleep', appLanguageNotifier.value);
      case 'POWERON': return JexText.of('resetPowerOn', appLanguageNotifier.value);
      default: return value;
    }
  }

  String _friendlyReason(String reason) {
    switch (reason) {
      case 'NTC_ERROR':
        return JexText.phrase('Temperature sensor error.', 'Kesalahan sensor suhu.');
      case 'HOTSIDE_PROTECTION':
        return JexText.phrase('Hotside protection active.', 'Perlindungan suhu panas aktif.');
      case 'FAN_REQUIRED':
        return JexText.phrase('Fan required before Peltier.', 'Kipas harus hidup sebelum Peltier.');
      case 'PELTIER_ON':
        return JexText.phrase('Fan locked while Peltier is ON.', 'Kipas terkunci saat Peltier HIDUP.');
      case 'ADAPTIVE_ACTIVE':
        return JexText.phrase('Manual cooling controls locked.', 'Kontrol pendinginan manual terkunci.');
      case 'MANUAL_12V_ONLY':
        return JexText.phrase('Manual 12V only.', 'Manual hanya 12V.');
      case 'VOLTAGE_GUARD_OR_BUSY':
        return JexText.phrase('Voltage command pending.', 'Perintah tegangan sedang diproses.');
      case 'SYNC_REQUIRED':
        return JexText.phrase('Device sync in progress.', 'Sinkronisasi perangkat sedang berlangsung.');
      case 'RATE_LIMIT':
        return JexText.phrase('Command rate limited.', 'Perintah terlalu cepat.');
      case 'MUST_BE_BELOW_BATT12':
        return JexText.phrase('5V battery limit must stay below 12V.', 'Batas baterai 5V harus di bawah 12V.');
      case 'MUST_BE_ABOVE_BATT5':
        return JexText.phrase('12V battery limit must stay above 5V.', 'Batas baterai 12V harus di atas 5V.');
      default:
        return reason.replaceAll('_', ' ').toLowerCase();
    }
  }

  void _showSnackBar(String message, {Color color = Colors.blueAccent}) {
    if (!mounted || message.trim().isEmpty) return;
    setState(() => notice = _compactNotifyMessage(message));
  }

  Future<void> _openBluetoothSettings() async {
    try {
      await batteryChannel.invokeMethod('openBluetoothSettings');
    } catch (e) {
      debugPrint('Bluetooth settings: $e');
      await openAppSettings();
    }
  }

  Future<void> _openLocationSettings() async {
    try {
      await batteryChannel.invokeMethod('openLocationSettings');
    } catch (e) {
      debugPrint('Location settings: $e');
      await openAppSettings();
    }
  }

  void _showBluetoothMenu() {
    final media = MediaQuery.of(context);
    const designWidth = 360.0;
    const homeHeight = 420.0;
    final scale = media.size.width / designWidth;
    final top = media.padding.top + homeHeight * scale;
    final sheetHeight = (media.size.height - top).clamp(1.0, media.size.height).toDouble();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.70),
      isScrollControlled: true,
      useSafeArea: false,
      enableDrag: true,
      showDragHandle: false,
      builder: (_) {
        return SizedBox(
          width: media.size.width,
          height: sheetHeight,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
            child: _ConnectionSheetContent(
              onScan: _startScanFromSheet,
              onConnect: _connect,
              onOpenBluetoothSettings: _openBluetoothSettings,
              onOpenLocationSettings: _openLocationSettings,
            ),
          ),
        );
      },
    ).whenComplete(() => FlutterBluePlus.stopScan());

    _startScanFromSheet();
  }

  Future<void> _startScanFromSheet() async {
    final accessReady = await _requestPermissions();
    if (!accessReady) return;
    try {
      await FlutterBluePlus.stopScan();
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        androidCheckLocationServices: false,
        androidUsesFineLocation: false,
      );
    } catch (e) {
      debugPrint('start scan sheet: $e');
    }
  }

  Widget _homeMetric(
    String label,
    String value,
    String unit, {
    required Color color,
    required IconData icon,
    JexAnimatedIconKind? animatedKind,
    double level = 1,
    bool warning = false,
    bool? animationActive,
  }) {
    final display = value == '--' ? '--' : value + unit;
    final active = value != '--';
    final animationIsActive = jexIndicatorAnimationActive(
      connected: connected,
      stateActive: animationActive ?? active,
    );
    final homeDark = appThemeNotifier.value != AppThemePreset.light;
    // AI-THEME / DASHBOARD-LIGHT-CONTRAST-CONTRACT
    // Explicit Home metric text remains dark in Light mode; no pale muted text on light surfaces.
    final mutedText = homeDark ? const Color(0xFFD4D7E0) : const Color(0xFF16181D);

    return Padding(
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 41,
                height: 41,
                child: Center(
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: color.withValues(alpha: 0.52),
                        width: 1.1,
                      ),
                    ),
                    child: animatedKind == null
                        ? JexAnimatedIcon.glyph(
                            icon: icon,
                            size: 22,
                            color: color,
                            active: animationIsActive,
                            warning: warning,
                          )
                        : JexAnimatedIcon(
                            kind: animatedKind,
                            size: 22,
                            color: color,
                            active: animationIsActive,
                            level: level,
                            warning: warning,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 13,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          maxLines: 1,
                          style: TextStyle(
                            color: mutedText,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.45,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      display,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: active ? color : (homeDark ? const Color(0xFF7F8592) : const Color(0xFF16181D)),
                        fontSize: 18.5,
                        fontWeight: FontWeight.w900,
                        height: 0.95,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AI-METHOD / HOME-STATE CONTRACT
  // Render a localized ON/OFF state while preserving -- for disconnected telemetry.
  // The boolean remains the firmware-backed state; only its presentation is localized.
  Widget _homeStateChip({
    required String label,
    required bool value,
    required IconData icon,
    required Color color,
    JexAnimatedIconKind? animatedKind,
  }) {
    final lang = appLanguageNotifier.value;
    return _homeMetric(
      label,
      connected ? JexText.of(value ? 'on' : 'off', lang) : '--',
      '',
      color: color,
      icon: icon,
      animatedKind: animatedKind,
      animationActive: jexIndicatorAnimationActive(
        connected: connected,
        stateActive: value,
      ),
      level: fanOn ? fanSpeed / 100 : 0,
    );
  }

  // AI-METHOD / HOME-FAN-SPEED CONTRACT
  // Speed remains visible at all times. Fan OFF is presented as OFF/MATI instead
  // of reusing the last PWM value; disconnected telemetry remains "--".
  Widget _homeFanSpeed() {
    final lang = appLanguageNotifier.value;
    final displaySpeed = !connected
        ? '--'
        : !fanOn
            ? JexText.of('off', lang)
            : (voltage == '5V' || voltage == '9V')
                ? '100%'
                : (!adaptiveOn && voltage == '12V')
                    ? '$fanSpeed%'
                    : '--';
    return _homeMetric(
      JexText.of('fanSpeedLabel'),
      displaySpeed,
      '',
      color: const Color(0xFFFFCD38),
      icon: PhosphorIconsRegular.gauge,
      animatedKind: JexAnimatedIconKind.speed,
      animationActive: jexIndicatorAnimationActive(
        connected: connected,
        stateActive: fanOn,
      ),
      level: fanSpeed / 100,
    );
  }

  String _compactNotifyMessage(String message) {
    final raw = message.trim();
    if (raw.isEmpty) return '';

    final lower = raw.toLowerCase();
    if (lower == 'scanning for je x fyz...') {
      return JexText.of('scanning');
    }
    if (lower == 'connecting to je x fyz...') {
      return JexText.of('connectingDevice');
    }
    if (lower == 'device disconnected.') {
      return JexText.of('bluetoothDisconnected');
    }
    if (lower == 'je x fyz was not found.') {
      return JexText.of('deviceNotFound');
    }
    if (lower == 'bluetooth scan failed.') {
      return JexText.of('scanFailed');
    }
    if (lower == 'bluetooth is not ready.') {
      return JexText.of('bluetoothNotReady');
    }
    if (lower == 'connect to je x fyz first.') {
      return JexText.of('connectFirst');
    }
    if (lower.startsWith('ota could not start:')) {
      return JexText.of('otaStartRejected');
    }
    if (lower.contains('was not confirmed by the device')) {
      final prefix = raw.replaceFirst(
        RegExp(r'\s+was not confirmed by the device\.?[\s\S]*$', caseSensitive: false),
        '',
      ).trim();
      return prefix.isEmpty
          ? JexText.of('commandNotConfirmed', appLanguageNotifier.value)
          : prefix + ' ' + JexText.of('notConfirmedSuffix', appLanguageNotifier.value);
    }
    if (lower.contains('command failed.')) {
      final prefix = raw.replaceFirst(
        RegExp(r'\s+command failed\.?$', caseSensitive: false),
        '',
      ).trim();
      return prefix.isEmpty
          ? JexText.of('commandFailed', appLanguageNotifier.value)
          : prefix + ' ' + JexText.of('failedSuffix', appLanguageNotifier.value);
    }
    return raw;
  }

  // AI-METHOD: _professionalNotice — Normalize technical status into project UI wording.
  String _professionalNotice() {
    final custom = _compactNotifyMessage(notice);

    // Safety validation states are meaningful only after a device is connected.
    // Do not let a stale pre-connection WAITING_* state surface as a warning
    // while the Home dashboard is actually offline. Preserve other explicit
    // latest-event messages such as connection failures or device-not-found.
    if (!connected && !_bleConnecting) {
      final upper = custom.toUpperCase();
      final staleValidation = upper == 'VALIDATING TEMPERATURE...' ||
          upper == 'TEMPERATURE SENSORS: VALIDATING...' ||
          upper == 'VALIDATING TEMPERATURE SENSORS...';
      if (custom.isEmpty || staleValidation) {
        return JexText.of('bluetoothDisconnected', appLanguageNotifier.value);
      }
      return custom;
    }


    if (custom.isNotEmpty) return custom;

    if (_bleConnecting) return JexText.of('connectingDevice', appLanguageNotifier.value);
    if (syncing && !dashboardReady) return JexText.of('synchronizingDevice', appLanguageNotifier.value);

    switch (safetyReason) {
      case 'WAITING_FOR_NTC':
      case 'WAITING_FOR_SENSOR_VALIDATION':
        return JexText.of('validatingTemperature', appLanguageNotifier.value);
      case 'NTC_ERROR':
        return JexText.of('sensorErrorCoolingLocked', appLanguageNotifier.value);
      case 'HOTSIDE_PROTECTION':
        return JexText.of('hotsideProtectionActive', appLanguageNotifier.value);
      case 'FAN_REQUIRED':
        return JexText.phrase('Fan required before Peltier.','Kipas harus hidup sebelum Peltier.');
      case 'PELTIER_ON':
        return JexText.phrase('Fan locked while Peltier is ON.','Kipas terkunci saat Peltier HIDUP.');
      case 'ADAPTIVE_ACTIVE':
        return JexText.phrase('Manual cooling controls locked.','Kontrol pendinginan manual terkunci.');
      case 'MANUAL_12V_ONLY':
        return JexText.phrase('Manual 12V only.','Manual hanya 12V.');
      case 'VOLTAGE_GUARD_OR_BUSY':
        return JexText.phrase('Voltage command pending.','Perintah tegangan sedang diproses.');
      case 'RATE_LIMIT':
        return JexText.phrase('Command rate limited.','Perintah dibatasi frekuensinya.');
      case 'DISCONNECTED':
        return JexText.of('bluetoothDisconnected', appLanguageNotifier.value);
      case 'NONE':
        return JexText.of('systemReady', appLanguageNotifier.value);
      default:
        return _friendlyReason(safetyReason);
    }
  }

  void _notifyCommandAccepted(String command) {
    if (!mounted) return;
    final c = command.trim().toUpperCase();
    final lang = appLanguageNotifier.value;
    String? message;

    if (c.startsWith('VOLTAGE:')) {
      message = JexText.of('voltageSetTo', lang) + c.substring(8) + '.';
    } else if (c == 'FAN:ON') {
      message = JexText.of('fanOn', lang);
    } else if (c == 'FAN:OFF') {
      message = JexText.of('fanOff', lang);
    } else if (c == 'PELTIER:ON') {
      message = JexText.of('peltierOn', lang);
    } else if (c == 'PELTIER:OFF') {
      message = JexText.of('peltierOff', lang);
    } else if (c == 'ADAPTIVE:ON') {
      message = JexText.of('adaptiveOn', lang);
    } else if (c == 'ADAPTIVE:OFF') {
      message = JexText.of('adaptiveOff', lang);
    } else if (c.startsWith('FANSPEED:')) {
      message = JexText.of('fanSpeed', lang) + ' ' + c.substring(9) + '%.';
    } else if (c == 'RGB:ON') {
      message = JexText.of('ledOn', lang);
    } else if (c == 'RGB:OFF') {
      message = JexText.of('ledOff', lang);
    } else if (c.startsWith('MODE:')) {
      message = JexText.of('modeUpdated', lang);
    } else if (c.startsWith('BRIGHTNESS:')) {
      message = JexText.of('brightnessUpdated', lang);
    } else if (c.startsWith('COLOR:')) {
      message = JexText.of('colorUpdated', lang);
    } else if (c.startsWith('HOTLIMIT:')) {
      message = JexText.of('hotsideTemperature', lang) + ' ' + c.substring(9) + '°C.';
    } else if (c.startsWith('BATT5:')) {
      message = JexText.of('fiveVCeiling', lang) + ' ' + JexText.phrase('updated.', 'diperbarui.', lang);
    } else if (c.startsWith('BATT12:')) {
      message = JexText.of('twelveVFloor', lang) + ' ' + JexText.phrase('updated.', 'diperbarui.', lang);
    } else if (c == 'RESET:TEMPERATURE') {
      message = JexText.of('temperatureReset', lang);
    }
    if (message != null) setState(() => notice = message!);
  }

  String _notifyStateLabel() {
    final custom = notice.trim().toUpperCase();
    if (_bleConnecting) return JexText.of('notifyBluetooth', appLanguageNotifier.value);
    if (syncing && !dashboardReady) return JexText.of('notifySync', appLanguageNotifier.value);

    final hasError = custom.contains('FAILED') ||
        custom.contains('ERROR') ||
        custom.contains('NOT FOUND') ||
        custom.contains('SERVICE DISCOVERY');
    if (hasError) return JexText.of('notifyError', appLanguageNotifier.value);

    // WAITING_* is a startup/sensor-validation state and must not be shown as
    // a safety warning while the dashboard is offline.
    final warning = connected &&
        safety != 'OK' &&
        safetyReason != 'NONE' &&
        safetyReason != 'WAITING_FOR_NTC' &&
        safetyReason != 'WAITING_FOR_SENSOR_VALIDATION';
    if (warning) return JexText.of('notifyWarning', appLanguageNotifier.value);
    return JexText.of('notify', appLanguageNotifier.value);
  }

  String _notifyStatusLabel() {
    final custom = notice.trim().toUpperCase();
    if (custom.contains('FAILED') ||
        custom.contains('ERROR') ||
        custom.contains('NOT FOUND') ||
        custom.contains('DISCONNECTED') ||
        custom.contains('SERVICE DISCOVERY')) {
      return JexText.of('error');
    }
    if (_bleConnecting) return JexText.of('connecting');
    if (syncing && !dashboardReady) return JexText.of('syncing');
    return connected ? JexText.of('online') : JexText.of('offline');
  }

  // AI-METHOD: _homeNotify — Render the Home NOTIFY card.
  Widget _homeNotify() {
    final headerDark = appThemeNotifier.value != AppThemePreset.light;
    final noticeTextColor = headerDark ? const Color(0xFFF4F6FA) : const Color(0xFF16181D);
    final noticeChipFill = headerDark ? const Color(0x12FFFFFF) : const Color(0x12000000);
    final offlineStatusColor = headerDark ? Colors.white38 : const Color(0xFF6F747D);
    final custom = notice.trim().toUpperCase();
    final hasError = custom.contains('FAILED') ||
        custom.contains('ERROR') ||
        custom.contains('NOT FOUND') ||
        custom.contains('DISCONNECTED') ||
        custom.contains('SERVICE DISCOVERY');
    final warning = safetyReason != 'NONE' &&
        safetyReason != 'WAITING_FOR_NTC' &&
        safetyReason != 'WAITING_FOR_SENSOR_VALIDATION';
    final alert = hasError || warning;
    final icon = hasError
        ? PhosphorIconsBold.xCircle
        : alert
            ? PhosphorIconsBold.warning
            : PhosphorIconsRegular.shieldCheck;
    final color = hasError
        ? const Color(0xFFFF5164)
        : alert
            ? const Color(0xFFFFB72B)
            : const Color(0xFF4DE7B7);
    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: hasError ? 0.12 : 0.07),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 45,
            height: 43,
            child: Center(
              child: JexAnimatedIcon.glyph(icon: icon, size: 27, color: color, active: true),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _notifyStateLabel(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: 13,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          // AI-METHOD: _professionalNotice — Normalize technical status into project UI wording.
                          _professionalNotice(),
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            color: noticeTextColor,
                            fontSize: 10.5,
                            height: 1.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: noticeChipFill,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              _notifyStatusLabel(),
              style: TextStyle(
                color: hasError
                    ? const Color(0xFFFF8A98)
                    : connected
                        ? Colors.cyanAccent
                        : offlineStatusColor,
                fontSize: 7.3,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.75,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: .78)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? .24 : .07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, {String? subtitle}) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: .60,
              color: scheme.onSurface,
            ),
          ),
          if (subtitle != null && subtitle.trim().isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // AI-METHOD / SUBMENU-TOGGLE-CONTRACT
  // Full-custom switch row. No Material Switch/ListTile chrome is used here.
  Widget _switchRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required bool enabled,
    required Future<void> Function(bool) onChanged,
    JexAnimatedIconKind? animatedKind,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final lang = appLanguageNotifier.value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: value
            ? accent.withValues(alpha: .075)
            : scheme.surfaceContainerHighest.withValues(alpha: .34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value
              ? accent.withValues(alpha: .28)
              : scheme.outlineVariant.withValues(alpha: .72),
        ),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: value
                  ? accent.withValues(alpha: .12)
                  : scheme.surfaceContainerHighest.withValues(alpha: .72),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: animatedKind == null
                  ? Icon(
                      icon,
                      size: 21,
                      color: value ? accent : scheme.onSurfaceVariant,
                    )
                  : JexAnimatedIcon(
                      kind: animatedKind,
                      size: 22,
                      color: value ? accent : scheme.onSurfaceVariant,
                      active: jexIndicatorAnimationActive(
                        connected: connected,
                        stateActive: value,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    letterSpacing: .35,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                if (subtitle.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            JexText.of(value ? 'on' : 'off', lang),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: value ? accent : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          _jexToggle(
            value: value,
            enabled: enabled,
            accent: accent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _jexToggle({
    required bool value,
    required bool enabled,
    required Color accent,
    required Future<void> Function(bool) onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: enabled ? () => unawaited(onChanged(!value)) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 54,
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value
              ? accent.withValues(alpha: .24)
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: value ? accent.withValues(alpha: .52) : scheme.outlineVariant,
            width: 1.2,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value
                  ? accent
                  : (enabled
                      ? scheme.onSurfaceVariant
                      : scheme.onSurfaceVariant.withValues(alpha: .32)),
              shape: BoxShape.circle,
              boxShadow: [
                if (value)
                  BoxShadow(
                    color: accent.withValues(alpha: .20),
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: value
                ? const Icon(Icons.check, size: 15, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _smoothList({
    required List<Widget> children,
    required String storageKey,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(2, 2, 2, 20),
  }) {
    return ListView(
      key: PageStorageKey<String>(storageKey),
      physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      scrollCacheExtent: const ScrollCacheExtent.pixels(480),
      padding: padding,
      children: children,
    );
  }

  // AI-METHOD: _buildVoltageTab — Build the fixed three-level VOLTAGE selector.
  // The selector intentionally matches the physical voltage hierarchy:
  // 5V Low Mode -> 9V Mid Mode -> 12V High Mode.
  // AI-METHOD / VOLTAGE-UI-CONTRACT
  // Voltage stays vertical. Each row is a custom single-select toggle; only one can be active.
  Widget _buildVoltageTab({Key? key}) {
    final locked = !connected || adaptiveOn || voltageGuardActive;
    final lang = appLanguageNotifier.value;

    return KeyedSubtree(
      key: key,
      child: _smoothList(
        storageKey: 'voltage',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          _sectionTitle(JexText.of('voltage', lang)),
          _card(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                _voltageChoiceCustom('5V', JexText.of('lowMode', lang), locked),
                const SizedBox(height: 7),
                _voltageChoiceCustom('9V', JexText.of('midMode', lang), locked),
                const SizedBox(height: 7),
                _voltageChoiceCustom('12V', JexText.of('highMode', lang), locked),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _voltageChoiceCustom(String target, String mode, bool locked) {
    final active = voltage == target;
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final darkSurface = appThemeNotifier.value == AppThemePreset.dark;
    final activeBackground =
        darkSurface ? scheme.onSurface : const Color(0xFF17181C);
    final activeForeground =
        darkSurface ? const Color(0xFF111318) : Colors.white;
    return InkWell(
      onTap: locked ? null : () => _requestVoltage(target),
      borderRadius: BorderRadius.circular(17),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.fromLTRB(14, 11, 11, 11),
        decoration: BoxDecoration(
          color: active
              ? activeBackground
              : scheme.surfaceContainerHighest.withValues(alpha: .26),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: active
                ? accent.withValues(alpha: .28)
                : scheme.outlineVariant.withValues(alpha: .68),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 58,
              child: Text(
                target,
                style: TextStyle(
                  color: active ? activeForeground : scheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Text(
                mode,
                style: TextStyle(
                  color: active ? activeForeground.withValues(alpha: .72) : scheme.onSurfaceVariant,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 46,
              height: 28,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: active
                    ? accent.withValues(alpha: .18)
                    : scheme.surfaceContainerHighest.withValues(alpha: .72),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: active ? accent.withValues(alpha: .46) : scheme.outlineVariant,
                ),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                alignment: active ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: active
                        ? accent
                        : scheme.onSurfaceVariant.withValues(alpha: locked ? .18 : .30),
                    shape: BoxShape.circle,
                  ),
                  child: active
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // AI-METHOD / CONTROL-TAB CONTRACT
  // Render Peltier and Fan switches from authoritative telemetry.
  // Fan Speed is always presented. Its value becomes OFF/MATI when Fan is OFF,
  // while the editable slider remains gated by connected + manual + 12V + Fan ON.
  // AI-METHOD / CONTROL-UI-CONTRACT
  // Compact custom device controls; no long separators or default Material tiles.
  Widget _buildControlTab({Key? key}) {
    final speedEnabled = connected && !adaptiveOn && voltage == '12V' && fanOn;
    final lang = appLanguageNotifier.value;
    final scheme = Theme.of(context).colorScheme;

    return KeyedSubtree(
      key: key,
      child: _smoothList(
        storageKey: 'control',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          _sectionTitle(JexText.of('control', lang)),
          _card(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                _switchRow(
                  title: JexText.of('peltier', lang),
                  subtitle: '',
                  icon: PhosphorIconsRegular.snowflake,
                  animatedKind: JexAnimatedIconKind.peltier,
                  value: peltierOn,
                  enabled: connected && !adaptiveOn,
                  onChanged: _togglePeltier,
                ),
                const SizedBox(height: 8),
                _switchRow(
                  title: JexText.of('fan', lang),
                  subtitle: '',
                  icon: PhosphorIconsRegular.fan,
                  animatedKind: JexAnimatedIconKind.fan,
                  value: fanOn,
                  enabled: connected && !adaptiveOn && !peltierOn,
                  onChanged: _toggleFan,
                ),
                const SizedBox(height: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: .25),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: scheme.outlineVariant.withValues(alpha: .70),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          JexAnimatedIcon(
                            kind: JexAnimatedIconKind.speed,
                            size: 25,
                            color: fanOn ? scheme.primary : scheme.onSurfaceVariant,
                            active: jexIndicatorAnimationActive(
                              connected: connected,
                              stateActive: fanOn,
                            ),
                            level: fanSpeed / 100,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              JexText.of('speed', lang),
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Text(
                            !connected
                                ? '--'
                                : !fanOn
                                    ? JexText.of('off', lang)
                                    : '$fanSpeed%',
                            style: TextStyle(
                              color: fanOn ? scheme.primary : scheme.onSurfaceVariant,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      if (fanOn) ...[
                        const SizedBox(height: 3),
                        Slider(
                          min: 50,
                          max: 100,
                          divisions: 5,
                          value: fanSpeedDraft.clamp(50, 100).toDouble(),
                          activeColor: scheme.primary,
                          inactiveColor: scheme.onSurface.withValues(alpha: .10),
                          onChanged: speedEnabled
                              ? (v) => setState(
                                    () => fanSpeedDraft =
                                        ((v / 10).round() * 10).clamp(50, 100).toInt(),
                                  )
                              : null,
                          onChangeEnd: speedEnabled ? _setFanSpeed : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // AI-METHOD: _buildAdaptiveTab — Build ADAPTIVE submenu.
  // AI-METHOD / ADAPTIVE-UI-CONTRACT
  // Custom profile selection replaces Material RadioListTile while preserving commands/state.
  Widget _buildAdaptiveTab({Key? key}) {
    final lang = appLanguageNotifier.value;
    final locked = adaptiveOn;
    final group =
        adaptiveProfile == 'HOTSIDE_BATTERY' ? 'HOTSIDE_BATTERY' : 'HOTSIDE';

    return KeyedSubtree(
      key: key,
      child: _smoothList(
        storageKey: 'adaptive',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          _sectionTitle(JexText.of('adaptive', lang)),
          _card(
            padding: const EdgeInsets.all(9),
            child: _switchRow(
              title: JexText.of('adaptiveSwitch', lang),
              subtitle: '',
              icon: PhosphorIconsRegular.sparkle,
              animatedKind: JexAnimatedIconKind.adaptive,
              value: adaptiveOn,
              enabled: connected,
              onChanged: _toggleAdaptive,
            ),
          ),
          _sectionTitle(JexText.of('adaptiveProfile', lang)),
          _card(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                _adaptiveProfileRow(
                  value: 'HOTSIDE',
                  title: JexText.of('hotsideProtection', lang),
                  icon: PhosphorIconsRegular.thermometer,
                  selected: group == 'HOTSIDE',
                  locked: locked,
                ),
                const SizedBox(height: 8),
                _adaptiveProfileRow(
                  value: 'HOTSIDE_BATTERY',
                  title: JexText.of('hotsideBattery', lang),
                  icon: PhosphorIconsRegular.batteryHigh,
                  selected: group == 'HOTSIDE_BATTERY',
                  locked: locked,
                ),
              ],
            ),
          ),
          if (locked)
            _card(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 19,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      JexText.of('lockedAdaptive', lang),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _adaptiveProfileRow({
    required String value,
    required String title,
    required IconData icon,
    required bool selected,
    required bool locked,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    return InkWell(
      onTap: locked ? null : () => unawaited(_setAdaptiveProfile(value)),
      borderRadius: BorderRadius.circular(17),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: .07)
              : scheme.surfaceContainerHighest.withValues(alpha: .24),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected
                ? accent.withValues(alpha: .30)
                : scheme.outlineVariant.withValues(alpha: .68),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? accent.withValues(alpha: .11)
                    : scheme.surfaceContainerHighest.withValues(alpha: .62),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                icon,
                size: 21,
                color: locked
                    ? scheme.onSurfaceVariant.withValues(alpha: .35)
                    : (selected ? accent : scheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: locked
                      ? scheme.onSurfaceVariant.withValues(alpha: .45)
                      : scheme.onSurface,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? accent.withValues(alpha: .14)
                    : scheme.surfaceContainerHighest,
                border: Border.all(
                  color: selected ? accent : scheme.outlineVariant,
                  width: selected ? 2 : 1,
                ),
              ),
              child: selected
                  ? Icon(Icons.check, size: 17, color: accent)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // AI-METHOD: _buildLedTab — Build LED/RGB/brightness/color controls.
  // AI-METHOD / LED-UI-CONTRACT
  // Custom LED control surface. Hardware remains 4-left/4-right; App preview is 8 horizontal LEDs.
  Widget _buildLedTab({Key? key}) {
    final lang = appLanguageNotifier.value;
    final modeNames = <String>[
      JexText.of('ledModeStatic', lang),
      JexText.of('ledModeBreath', lang),
      JexText.of('ledModeCenterOut', lang),
      JexText.of('ledModeOuterIn', lang),
      JexText.of('ledModeDualChase', lang),
      JexText.of('leftRight', lang),
      JexText.of('ledModeRainbow', lang),
    ];
    final safeMode = rgbMode.clamp(1, 7);
    final modeName = modeNames[safeMode - 1];
    final colorEnabled = connected && rgbMode != 7;
    final scheme = Theme.of(context).colorScheme;

    return KeyedSubtree(
      key: key,
      child: _smoothList(
        storageKey: 'led',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          _sectionTitle(JexText.of('led', lang)),
          _card(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                _switchRow(
                  title: JexText.of('power', lang),
                  subtitle: '',
                  icon: PhosphorIconsBold.lightbulb,
                  animatedKind: JexAnimatedIconKind.led,
                  value: rgbOn,
                  enabled: connected,
                  onChanged: _setRgb,
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: .22),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: .68)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            JexText.of('mode', lang).toUpperCase(),
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .75,
                            ),
                          ),
                          const Spacer(),
                          _ledModeButton(
                            icon: PhosphorIconsBold.caretLeft,
                            enabled: connected && safeMode > 1,
                            onPressed: () => _setMode(safeMode - 1),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            constraints: const BoxConstraints(minWidth: 84),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: scheme.outlineVariant),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  safeMode.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: scheme.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  modeName.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: scheme.onSurface,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          _ledModeButton(
                            icon: PhosphorIconsBold.caretRight,
                            enabled: connected && safeMode < 7,
                            onPressed: () => _setMode(safeMode + 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      JexLedStripPreview(
                        mode: safeMode,
                        colorHex: rgbColor.toUpperCase(),
                        brightness: brightness,
                        active: rgbOn && connected,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        modeName.toUpperCase(),
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .55,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.fromLTRB(11, 8, 11, 7),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: .20),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: .60)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.wb_sunny_outlined, size: 19, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          min: 1,
                          max: 100,
                          divisions: 99,
                          value: brightness.clamp(1, 100).toDouble(),
                          activeColor: scheme.primary,
                          inactiveColor: scheme.onSurface.withValues(alpha: .10),
                          onChanged: connected
                              ? (v) => setState(() => brightness = v.round())
                              : null,
                          onChangeEnd: connected ? _setBrightness : null,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$brightness%',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Opacity(
            opacity: colorEnabled ? 1 : .45,
            child: InkWell(
              onTap: colorEnabled ? _showLedColorPicker : null,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                key: _ledColorAnchorKey,
                child: _card(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  child: Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: colorEnabled
                              ? ledPaletteColor(rgbColor.toUpperCase())
                              : scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: rgbColor.toUpperCase() == '#FFFFFF'
                                ? scheme.outline
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              JexText.of('color', lang),
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              rgbColor.toUpperCase(),
                              style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: .4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant, size: 22),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ledModeButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled
              ? scheme.surface
              : scheme.surfaceContainerHighest.withValues(alpha: .45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Icon(
          icon,
          size: 19,
          color: enabled
              ? scheme.onSurface
              : scheme.onSurfaceVariant.withValues(alpha: .30),
        ),
      ),
    );
  }

  // AI-METHOD / TEMPERATURE-UI-CONTRACT
  // Compact thermal controls with consistent custom +/- buttons and no long dividers.
  Widget _buildTemperatureTab({Key? key}) {
    final locked = adaptiveOn;
    final midLow = battery5Limit + 1;
    final midHigh = battery12Limit - 1;
    final lang = appLanguageNotifier.value;

    return KeyedSubtree(
      key: key,
      child: _smoothList(
        storageKey: 'temperature',
        padding: const EdgeInsets.fromLTRB(2, 0, 2, 18),
        children: [
          _sectionTitle(JexText.of('thermal', lang)),
          _card(
            padding: const EdgeInsets.all(11),
            child: _temperatureAdjuster(
              title: JexText.of('hotsideLimit'),
              value: hotLimitDraft,
              min: 40,
              max: 50,
              enabled: connected && !locked,
              onChanged: _setHotLimit,
            ),
          ),
          _sectionTitle(JexText.of('batteryZones', lang)),
          _card(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                _temperatureAdjuster(
                  title: JexText.of('fiveVCeiling'),
                  value: battery5Draft,
                  min: 20,
                  max: 48,
                  enabled: connected && !locked && battery5Draft < battery12Limit - 1,
                  onChanged: (v) {
                    if (v < battery12Limit - 1) _setBattery5(v);
                  },
                ),
                const SizedBox(height: 8),
                _lockedZoneRow(
                  title: JexText.of('zone9v', lang),
                  value: '≈ ' + midLow.toString() + '–' + midHigh.toString() + '°C',
                ),
                const SizedBox(height: 8),
                _temperatureAdjuster(
                  title: JexText.of('twelveVFloor'),
                  value: battery12Draft,
                  min: 22,
                  max: 50,
                  enabled: connected && !locked && battery12Draft > battery5Limit + 1,
                  onChanged: (v) {
                    if (v > battery5Limit + 1) _setBattery12(v);
                  },
                ),
              ],
            ),
          ),
          if (locked)
            _card(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 19,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      JexText.of('lockedAdaptive', lang),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: connected && !locked
                  ? _resetTemperatureSettings
                  : null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 38),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Text(JexText.of('resetTemperature', lang)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _temperatureAdjuster({
    required String title,
    required int value,
    required int min,
    required int max,
    required bool enabled,
    required ValueChanged<int> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: enabled ? 1 : .48,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .35,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  JexText.of('range', appLanguageNotifier.value) + ' ' + min.toString() + '–' + max.toString() + '°C',
                  style: TextStyle(
                    color: scheme.onSurfaceVariant,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _temperatureButton(
            icon: Icons.remove_rounded,
            enabled: enabled && value > min,
            onPressed: () => onChanged(value - 1),
          ),
          const SizedBox(width: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: .55),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Text(
              value.toString() + '°C',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: accent,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 5),
          _temperatureButton(
            icon: Icons.add_rounded,
            enabled: enabled && value < max,
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  Widget _temperatureButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: enabled
              ? scheme.surfaceContainerHighest
              : scheme.surfaceContainerHighest.withValues(alpha: .48),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Icon(
          icon,
          size: 19,
          color: enabled
              ? scheme.onSurfaceVariant
              : scheme.onSurfaceVariant.withValues(alpha: .28),
        ),
      ),
    );
  }

  Widget _lockedZoneRow({
    required String title,
    required String value,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: .24),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: .68)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 18,
            color: scheme.onSurfaceVariant.withValues(alpha: .55),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // AI-METHOD: _buildTabContent — Select submenu content by tab index.
  Widget _buildTabContent() {
    return switch (tabIndex) {
      0 => _buildVoltageTab(key: const ValueKey('voltage-tab')),
      1 => _buildControlTab(key: const ValueKey('control-tab')),
      2 => _buildAdaptiveTab(key: const ValueKey('adaptive-tab')),
      3 => _buildLedTab(key: const ValueKey('led-tab')),
      4 => _buildTemperatureTab(key: const ValueKey('temperature-tab')),
      _ => const SizedBox.shrink(),
    };
  }

  // AI-METHOD / HOME-CONTRACT
  // Build Home from live firmware/phone telemetry. Power states use JexText;
  // Fan Speed remains visible; its presentation reports OFF/MATI when Fan is OFF.
  // This function owns presentation only, not device-state authority.
  Widget _buildHomeArea(double height) {
    final batteryValue = connected && phoneBatteryValid ? phoneBatteryTemp : '--';
    final hotValue = connected ? hotsideTemp : '--';
    final voltageValue = connected && voltage != '--' ? voltage : '--';
    final adaptiveValue = connected
        ? JexText.of(adaptiveOn ? 'on' : 'off', appLanguageNotifier.value)
        : '--';
    final headerDark = appThemeNotifier.value != AppThemePreset.light;
    final headerForeground = headerDark ? const Color(0xFFF7F8FC) : const Color(0xFF16181D);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 8),
        child: Column(
          children: [
            SizedBox(
              height: 42,
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                        tooltip: connected ? JexText.of('disconnect', appLanguageNotifier.value) : JexText.of('bluetooth', appLanguageNotifier.value),
                        icon: JexAnimatedIcon(
                          kind: JexAnimatedIconKind.bluetooth,
                          color: connected ? const Color(0xFF4D8CFF) : headerForeground,
                          size: 25,
                          active: jexIndicatorAnimationActive(
                            connected: connected,
                            stateActive: true,
                          ),
                        ),
                        onPressed: connected ? _disconnect : _showBluetoothMenu,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          headerName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: headerForeground,
                            fontWeight: FontWeight.w900,
                            fontSize: 19,
                            letterSpacing: 0.2,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          JexText.of('developedByHorizon', appLanguageNotifier.value),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: headerDark ? const Color(0xFF737986) : const Color(0xFF40444D),
                            fontWeight: FontWeight.w700,
                            fontSize: 6.8,
                            letterSpacing: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                        tooltip: JexText.of('settings', appLanguageNotifier.value),
                        icon: JexAnimatedIcon.glyph(
                          icon: PhosphorIconsRegular.gear,
                          color: headerForeground,
                          size: 25,
                          active: true,
                        ),
                        onPressed: _openSettings,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 10,
                    child: FractionallySizedBox(
                      widthFactor: 0.96,
                      alignment: Alignment.centerLeft,
                      child: Transform.translate(
                        offset: const Offset(-3, 0),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2, right: 4),
                          child: Column(
                          children: [
                          _homeMetric(
                            JexText.of('batteryTemperature'),
                            batteryValue,
                            batteryValue == '--' ? '' : '°C',
                            color: const Color(0xFFFFB52E),
                            icon: PhosphorIconsRegular.batteryHigh,
                            animatedKind: JexAnimatedIconKind.battery,
                          ),
                          _homeMetric(
                            JexText.of('hotsideTemperature'),
                            hotValue,
                            hotValue == '--' ? '' : '°C',
                            color: safety == 'FAULT'
                                ? const Color(0xFFFF5164)
                                : const Color(0xFF22E6DE),
                            icon: PhosphorIconsRegular.thermometer,
                            animatedKind: JexAnimatedIconKind.hotside,
                            warning: safety == 'FAULT',
                          ),
                          _homeMetric(
                            JexText.of('voltageIndicator'),
                            voltageValue,
                            '',
                            color: const Color(0xFF4D8CFF),
                            icon: PhosphorIconsRegular.lightning,
                            animatedKind: JexAnimatedIconKind.voltage,
                          ),
                          _homeMetric(
                            JexText.of('adaptiveMode'),
                            adaptiveValue,
                            '',
                            color: const Color(0xFFC05BFF),
                            icon: PhosphorIconsRegular.sparkle,
                            animatedKind: JexAnimatedIconKind.adaptive,
                          ),
                          _homeStateChip(
                            label: JexText.of('peltierSwitch'),
                            value: peltierOn,
                            icon: PhosphorIconsRegular.snowflake,
                            color: const Color(0xFF18DFFF),
                            animatedKind: JexAnimatedIconKind.peltier,
                          ),
                          _homeStateChip(
                            label: JexText.of('fanSwitch'),
                            value: fanOn,
                            icon: PhosphorIconsRegular.fan,
                            color: const Color(0xFF38E3AD),
                            animatedKind: JexAnimatedIconKind.fan,
                          ),
                          _homeFanSpeed(),
                          ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 13,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final imageHeight =
                              (constraints.maxHeight * 0.99).clamp(240.0, 430.0).toDouble();
                          return Padding(
                            padding: const EdgeInsets.only(left: 2, right: 0),
                            child: Image.asset(
                              'assets/jexfyzcooler.png',
                              width: double.infinity,
                              height: imageHeight,
                              fit: BoxFit.contain,
                              alignment: Alignment.centerRight,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: _homeNotify(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String title, int index) {
    final selected = tabIndex == index;
    final dark = _dashboardDark;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => tabIndex = index),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 9),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF17181C)
                  : (dark ? const Color(0xFF22242A) : const Color(0xFFE4E7EC)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? const Color(0xFF17181C)
                    : (dark ? const Color(0xFF30323A) : const Color(0xFFD6DAE1)),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title.toUpperCase(),
                maxLines: 1,
                style: TextStyle(
                  color: selected ? Colors.white : (dark ? Colors.white70 : const Color(0xFF16181D)),
                  fontWeight: FontWeight.w900,
                  fontSize: 9,
                  letterSpacing: 0.05,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _dashboardTopColor() => switch (appThemeNotifier.value) {
        AppThemePreset.defaultTheme => const Color(0xFF111113),
        AppThemePreset.light => const Color(0xFFEEF0F4),
        AppThemePreset.dark => const Color(0xFF101114),
      };

  bool get _dashboardDark => appThemeNotifier.value == AppThemePreset.dark;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    const designWidth = 360.0;
    const homeHeight = 420.0;
    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        backgroundColor: _dashboardTopColor(),
        body: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // One master visual canvas. Its 360 dp design width is scaled once
              // to fill the current viewport. When Android Smallest Width/density
              // changes on the same physical display, logical width changes in the
              // opposite direction, so the rendered physical UI size stays stable.
              // A genuinely different physical display receives the same single
              // uniform scale across Home, Notify and Display Menu.
              final scale = constraints.maxWidth / designWidth;
              final designHeight = constraints.maxHeight / scale;

              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: designWidth,
                      height: designHeight,
                      child: Column(
                        children: [
                          SizedBox(
                            width: designWidth,
                            height: homeHeight,
                            child: _buildHomeArea(homeHeight),
                          ),
                          Expanded(
                            child: Container(
                              width: designWidth,
                              decoration: BoxDecoration(
                                color: appThemeNotifier.value == AppThemePreset.dark
                                    ? const Color(0xFF171A20)
                                    : Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(34),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 11),
                                  SizedBox(
                                    height: 42,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Row(
                                        children: [
                                          _tab(JexText.of('voltage', appLanguageNotifier.value), 0),
                                          _tab(JexText.of('control', appLanguageNotifier.value), 1),
                                          _tab(JexText.of('adaptive', appLanguageNotifier.value), 2),
                                          _tab(JexText.of('led', appLanguageNotifier.value), 3),
                                          _tab(JexText.of('temperature', appLanguageNotifier.value), 4),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 19),
                                    child: Divider(
                                      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: .75),
                                      thickness: 1,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: _buildTabContent(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// --- CONNECTION SHEET: UI only; BLE ownership remains in DashboardScreen ---
class _ConnectionSheetContent extends StatefulWidget {
  final Future<void> Function() onScan;
  final Future<void> Function(BluetoothDevice device) onConnect;
  final Future<void> Function() onOpenBluetoothSettings;
  final Future<void> Function() onOpenLocationSettings;

  const _ConnectionSheetContent({
    required this.onScan,
    required this.onConnect,
    required this.onOpenBluetoothSettings,
    required this.onOpenLocationSettings,
  });

  @override
  State<_ConnectionSheetContent> createState() => _ConnectionSheetContentState();
}

class _ConnectionSheetContentState extends State<_ConnectionSheetContent> {
  static const MethodChannel _channel = MethodChannel('je_x_fyz/battery_temp');

  Timer? _refreshTimer;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  PermissionStatus _scanPermission = PermissionStatus.denied;
  PermissionStatus _connectPermission = PermissionStatus.denied;
  PermissionStatus _locationPermission = PermissionStatus.denied;
  bool _locationServiceEnabled = false;
  int _androidSdk = 0;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
    _refreshTimer = Timer.periodic(
      const Duration(milliseconds: 650),
      (_) => _refreshStatus(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshStatus() async {
    if (!Platform.isAndroid) return;
    try {
      final adapter = await FlutterBluePlus.adapterState.first;
      final scan = await Permission.bluetoothScan.status;
      final connect = await Permission.bluetoothConnect.status;
      final location = await Permission.locationWhenInUse.status;
      final sdk = await _getAndroidSdkInt();

      bool locationService = false;
      try {
        locationService = await _channel.invokeMethod<bool>(
              'isLocationServiceEnabled',
            ) ??
            false;
      } catch (_) {}

      if (!mounted) return;
      setState(() {
        _adapterState = adapter;
        _scanPermission = scan;
        _connectPermission = connect;
        _locationPermission = location;
        _androidSdk = sdk;
        _locationServiceEnabled = locationService;
      });
    } catch (e) {
      debugPrint('Connection status: $e');
    }
  }

  Future<int> _getAndroidSdkInt() async {
    try {
      return await _channel.invokeMethod<int>('getAndroidSdkInt') ?? 0;
    } catch (e) {
      debugPrint('Android SDK check: $e');
      return 0;
    }
  }

  bool get _bluetoothDenied =>
      !_scanPermission.isGranted || !_connectPermission.isGranted;

  bool get _bluetoothOn =>
      !_bluetoothDenied && _adapterState == BluetoothAdapterState.on;

  bool get _locationDenied =>
      _androidSdk > 0 &&
      _androidSdk <= 30 &&
      !_locationPermission.isGranted;

  bool get _locationOn =>
      _locationServiceEnabled && !_locationDenied;

  Color _statusColor(bool on, bool denied) {
    if (denied) return const Color(0xFFFF6B7A);
    if (on) return const Color(0xFF63E6BE);
    return const Color(0xFFFFB74D);
  }

  Widget _indicator({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final indicatorBackground = dark ? const Color(0xFF191A22) : Colors.white;
    final indicatorForeground = dark ? Colors.white : const Color(0xFF16181D);
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: indicatorBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: color.withValues(alpha: 0.55),
                width: 1.1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                JexAnimatedIcon.glyph(icon: icon, size: 19, color: color, active: true),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: indicatorForeground,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _tapBluetooth() async {
    if (_bluetoothDenied) {
      // Explicit user action retries the Nearby Devices permission request.
      // Never redirect to App Settings merely because the previous request was denied.
      await widget.onScan();
    } else {
      // Bluetooth power remains a manual OS action when the adapter is off.
      await widget.onOpenBluetoothSettings();
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _refreshStatus();
  }

  Future<void> _tapLocation() async {
    if (_locationDenied) {
      await openAppSettings();
    } else {
      await widget.onOpenLocationSettings();
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    await _refreshStatus();
  }

  @override
  Widget build(BuildContext context) {
    final lang = appLanguageNotifier.value;
    final scheme = Theme.of(context).colorScheme;
    final btColor = _statusColor(_bluetoothOn, _bluetoothDenied);
    final locationColor = _statusColor(_locationOn, _locationDenied);
    final locationRequired = _androidSdk > 0 && _androidSdk <= 30;

    return Material(
      color: scheme.surface,
      child: Column(
        children: [
          Container(
            height: 66,
            padding: const EdgeInsets.fromLTRB(18, 7, 7, 5),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    JexText.of('connection', lang),
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.15,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 42, height: 42),
                  onPressed: () => Navigator.pop(context),
                  icon: JexAnimatedIcon.glyph(
                    icon: PhosphorIconsRegular.x,
                    color: scheme.onSurfaceVariant,
                    size: 25,
                    active: true,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 10),
            child: Row(
              children: [
                _indicator(
                  label: _bluetoothOn ? JexText.of('bluetoothOn', lang) : JexText.of('bluetoothOff', lang),
                  icon: _bluetoothOn
                      ? PhosphorIconsRegular.bluetooth
                      : PhosphorIconsRegular.bluetoothSlash,
                  color: btColor,
                  onTap: _tapBluetooth,
                ),
                const SizedBox(width: 8),
                _indicator(
                  label: _locationOn ? JexText.of('locationOn', lang) : JexText.of('locationOff', lang),
                  icon: _locationOn
                      ? PhosphorIconsRegular.mapPin
                      : PhosphorIconsRegular.mapPin,
                  color: locationColor,
                  onTap: _tapLocation,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 10, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    JexText.of('devices', lang),
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(width: 38, height: 38),
                  tooltip: JexText.of('scan', lang),
                  onPressed: widget.onScan,
                  icon: JexAnimatedIcon.glyph(
                    icon: PhosphorIconsRegular.arrowClockwise,
                    color: const Color(0xFF5C9DFF),
                    size: 25,
                    active: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ScanResult>>(
              stream: FlutterBluePlus.scanResults,
              initialData: const [],
              builder: (context, snapshot) {
                final filtered = (snapshot.data ?? const <ScanResult>[]).where((r) {
                  final serviceMatch = r.advertisementData.serviceUuids.any(
                    (uuid) => uuid.toString().toLowerCase() == serviceUuid,
                  );
                  final name = r.device.platformName.trim().toLowerCase();
                  final advName = r.advertisementData.advName.trim().toLowerCase();
                  return serviceMatch || name == 'je x fyz' || advName == 'je x fyz';
                }).toList();

                if (filtered.isEmpty) {
                  final unavailable =
                      _bluetoothDenied ||
                      _adapterState != BluetoothAdapterState.on ||
                      (locationRequired && !_locationOn);

                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        JexAnimatedIcon.glyph(
                          icon: unavailable
                              ? PhosphorIconsRegular.bluetoothSlash
                              : PhosphorIconsRegular.bluetooth,
                          color: unavailable
                              ? btColor
                              : const Color(0xFF5C9DFF),
                          size: 36,
                          active: !unavailable,
                          warning: unavailable,
                        ),
                        const SizedBox(height: 11),
                        Text(
                          unavailable ? JexText.of('connectionUnavailable', lang) : JexText.of('scanning', lang),
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 13),
                        FilledButton.icon(
                          onPressed: unavailable ? null : widget.onScan,
                          icon: JexAnimatedIcon.glyph(
                            icon: PhosphorIconsRegular.arrowClockwise,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 18,
                            active: true,
                          ),
                          label: Text(JexText.of('scan', lang)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: scheme.outlineVariant.withValues(alpha: .55), height: 1),
                  itemBuilder: (_, index) {
                    final result = filtered[index];
                    final name = result.device.platformName.isNotEmpty
                        ? result.device.platformName
                        : result.advertisementData.advName;
                    return ListTile(
                      dense: true,
                      leading: JexAnimatedIcon.glyph(
                        icon: PhosphorIconsRegular.bluetooth,
                        color: const Color(0xFF63E6BE),
                        size: 21,
                        active: true,
                      ),
                      title: Text(
                        name.isEmpty ? 'JE X FYZ' : name,
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      onTap: () async {
                        await FlutterBluePlus.stopScan();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        await widget.onConnect(result.device);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StaticSwitcher extends StatelessWidget {
  final Widget child;
  final Duration? duration;
  final Duration? reverseDuration;
  final Curve? switchInCurve;
  final Curve? switchOutCurve;
  final Widget Function(Widget, Animation<double>)? transitionBuilder;
  final Widget Function(Widget?, List<Widget>)? layoutBuilder;

  const StaticSwitcher({
    super.key,
    required this.child,
    this.duration,
    this.reverseDuration,
    this.switchInCurve,
    this.switchOutCurve,
    this.transitionBuilder,
    this.layoutBuilder,
  });

  @override
  Widget build(BuildContext context) => child;
}

class StaticScale extends StatelessWidget {
  final double scale;
  final Widget child;
  final Duration? duration;
  final Curve? curve;

  const StaticScale({
    super.key,
    required this.scale,
    required this.child,
    this.duration,
    this.curve,
  });

  @override
  Widget build(BuildContext context) => child;
}

// --- OTA UI: external firmware metadata/credentials; firmware performs flashing ---
class FirmwareUpdateDialog extends StatefulWidget {
  final String currentVersion;
  final Future<void> Function(String ssid, String password, String url, String version) onUpdate;

  const FirmwareUpdateDialog({
    super.key,
    required this.currentVersion,
    required this.onUpdate,
  });

  @override
  State<FirmwareUpdateDialog> createState() => _FirmwareUpdateDialogState();
}

class _FirmwareUpdateDialogState extends State<FirmwareUpdateDialog> {
  String latestVersion = '';
  String firmwareUrl = '';
  String status = 'CHECKING';
  bool updateAvailable = false;

  final ssid = TextEditingController();
  final password = TextEditingController();
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // AI-METHOD: _loadSavedCredentials — Load Wi-Fi credentials from secure storage only.
    _loadSavedCredentials();
    // AI-METHOD: _checkFirebase — Fetch and validate Firebase firmware release metadata.
    _checkFirebase();
  }

  @override
  void dispose() {
    ssid.dispose();
    password.dispose();
    super.dispose();
  }

  // AI-METHOD: _loadSavedCredentials — Load Wi-Fi credentials from secure storage only.
  Future<void> _loadSavedCredentials() async {
    try {
      final savedSsid = await storage.read(key: 'jexfyz_wifi_ssid') ?? '';
      final savedPass = await storage.read(key: 'jexfyz_wifi_pass') ?? '';
      if (mounted) {
        setState(() {
          ssid.text = savedSsid;
          password.text = savedPass;
        });
      }
    } catch (e) {
      debugPrint('secure storage: $e');
    }
  }

  // AI-METHOD: _checkFirebase — Read Firebase RTDB firmware metadata with optional App Check REST authorization.
  Future<void> _checkFirebase() async {
    if (!mounted) return;
    setState(() {
      status = 'CHECKING';
      latestVersion = '';
      firmwareUrl = '';
      updateAvailable = false;
    });

    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client.getUrl(Uri.parse(firmwareMetadataUrl));
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.set(HttpHeaders.userAgentHeader, 'JE-Cooler');
      request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
      request.headers.set('Pragma', 'no-cache');

      // Firmware metadata is intentionally public-read data (version + public BIN URL).
      // Keep this REST request independent from Play Integrity/App Check so the
      // sideloaded production APK can read the update metadata reliably.
      // App Check remains enabled for the rest of the application's Firebase layer.
      final response = await request.close().timeout(const Duration(seconds: 12));
      final body = await response.transform(utf8.decoder).join().timeout(
        const Duration(seconds: 12),
      );

      if (response.statusCode != HttpStatus.ok) {
        final detail = body.trim();
        final reason = response.statusCode == HttpStatus.unauthorized ||
                response.statusCode == HttpStatus.forbidden
            ? 'Firebase read permission/App Check rejected'
            : 'Firebase HTTP ' + response.statusCode.toString();
        throw StateError(
          reason + (detail.isEmpty ? '' : ': ' + detail),
        );
      }

      final decoded = jsonDecode(body);
      if (decoded is! Map) {
        throw StateError('Firebase firmware_update is not an object');
      }

      final data = Map<String, dynamic>.from(decoded);
      final version = data['version']?.toString().trim() ?? '';
      final url = data['url']?.toString().trim() ?? '';
      final parsedUrl = Uri.tryParse(url);
      final validUrl = parsedUrl != null &&
          parsedUrl.scheme == 'https' &&
          parsedUrl.host == 'raw.githubusercontent.com' &&
          parsedUrl.path ==
              '/TenzoNkz/JEXFYZ-Firmware/main/JEXFYZ.cpp.bin';

      if (parseFirmwareVersion(version) == null || !validUrl) {
        throw StateError(
          'Firebase firmware_update data invalid: expected version V<major>.<minor> and the fixed JEXFYZ.cpp.bin URL',
        );
      }

      if (!mounted) return;
      setState(() {
        latestVersion = version;
        firmwareUrl = url;
        updateAvailable = isDifferentFirmwareVersion(
          version,
          widget.currentVersion,
        );
        status = updateAvailable ? 'UPDATE' : 'UP_TO_DATE';
      });

      if (updateAvailable && appNotifyFirmwareNotifier.value) {
        final shouldNotify =
            await AppSettingsStore.shouldNotifyFirmware(version);
        if (shouldNotify) {
          try {
            await const MethodChannel('je_x_fyz/notifications').invokeMethod<void>(
              'showNotification',
              <String, dynamic>{
                'title': JexText.of('firmwareUpdate'),
                'body': version,
                'id': 2104,
              },
            );
            await AppSettingsStore.markFirmwareNotified(version);
          } catch (e) {
            debugPrint('Firmware notification: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Firebase OTA metadata: ' + e.toString());
      if (mounted) {
        setState(() {
          status = 'FAILED';
          latestVersion = '';
          firmwareUrl = '';
          updateAvailable = false;
        });
      }
    } finally {
      client.close(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(JexText.of('firmware', appLanguageNotifier.value), style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(JexText.of('currentVersion', appLanguageNotifier.value) + ': ' + widget.currentVersion),
            const SizedBox(height: 5),
            Text(JexText.of('latestVersion', appLanguageNotifier.value) + ': ' + (latestVersion.isEmpty ? '--' : latestVersion)),
            const SizedBox(height: 16),
            if (status == 'CHECKING')
              const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
            else if (status == 'FAILED')
              Text(
                JexText.of('firmwareMetadataCheckFailed', appLanguageNotifier.value),
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              )
            else if (!updateAvailable)
              Text(
                widget.currentVersion == 'V?'
                    ? JexText.of('waitingForDevice', appLanguageNotifier.value)
                    : JexText.of('upToDateSentence', appLanguageNotifier.value),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            else ...[
              Text(JexText.of('updateAvailableSentence', appLanguageNotifier.value), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: ssid,
                decoration: InputDecoration(
                  labelText: JexText.of('ssid', appLanguageNotifier.value),
                  prefixIcon: JexAnimatedIcon.glyph(
          icon: PhosphorIconsRegular.wifiHigh,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 20,
          active: true,
        ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: password,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: JexText.of('password', appLanguageNotifier.value),
                  prefixIcon: JexAnimatedIcon.glyph(
          icon: PhosphorIconsBold.lock,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 20,
          active: true,
        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(JexText.of('savedSecurelySentence', appLanguageNotifier.value), style: const TextStyle(fontSize: 9)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(JexText.of('close', appLanguageNotifier.value))),
        if (status == 'FAILED')
          FilledButton(onPressed: _checkFirebase, child: Text(JexText.of('retry', appLanguageNotifier.value))),
        if (updateAvailable)
          FilledButton(
            onPressed: () async {
              final s = ssid.text.trim();
              final p = password.text;
              if (s.isEmpty || p.isEmpty) return;
              await storage.write(key: 'jexfyz_wifi_ssid', value: s);
              await storage.write(key: 'jexfyz_wifi_pass', value: p);
              if (!context.mounted) return;
              Navigator.pop(context);
              await widget.onUpdate(s, p, firmwareUrl, latestVersion);
            },
            child: Text(JexText.of('updateAction', appLanguageNotifier.value)),
          ),
      ],
    );
  }
}