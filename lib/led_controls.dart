// AI-MEMORY / FILE CONTRACT
// Owns Flutter LED controls, color selection, preview rendering and firmware-aligned phase projection.
// This is presentation/model code only: it does not own BLE/GATT, commands, or device session state.
// Firmware IDs and LED_SYNC phase values are mirrored for display; P1 transport remains in main.dart.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'app_settings.dart' show AppLanguage, JexText, appLanguageNotifier;
import 'jex_animated_glyph.dart';

String normalizeLedColor(String value) {
  final normalized = value.trim().toUpperCase();
  return normalized.startsWith('#') ? normalized.substring(1) : normalized;
}

class LedColorPreset {
  final String hex;
  final String nameKey;
  const LedColorPreset(this.hex, this.nameKey);
}

const List<LedColorPreset> ledColorPresets = <LedColorPreset>[
  LedColorPreset('#800000', 'ledColorMaroon'),
  LedColorPreset('#8B0000', 'ledColorDarkRed'),
  LedColorPreset('#B22222', 'ledColorFirebrick'),
  LedColorPreset('#DC143C', 'ledColorCrimson'),
  LedColorPreset('#FF1744', 'ledColorCandyRed'),
  LedColorPreset('#FF0000', 'ledColorRed'),
  LedColorPreset('#FF2400', 'ledColorScarlet'),
  LedColorPreset('#FF4500', 'ledColorOrangeRed'),
  LedColorPreset('#FF6347', 'ledColorTomato'),
  LedColorPreset('#FA8072', 'ledColorSalmon'),
  LedColorPreset('#FFB38A', 'ledColorPeach'),
  LedColorPreset('#FFA500', 'ledColorOrange'),
  LedColorPreset('#FF8C00', 'ledColorDarkOrange'),
  LedColorPreset('#C68642', 'ledColorCaramel'),
  LedColorPreset('#F4A460', 'ledColorSandyBrown'),
  LedColorPreset('#A85D32', 'ledColorCinnamon'),
  LedColorPreset('#FFBF00', 'ledColorAmber'),
  LedColorPreset('#FFD700', 'ledColorGold'),
  LedColorPreset('#DAA520', 'ledColorGoldenrod'),
  LedColorPreset('#F0E68C', 'ledColorKhaki'),
  LedColorPreset('#EFFF00', 'ledColorLemon'),
  LedColorPreset('#BFFF00', 'ledColorSpringLime'),
  LedColorPreset('#7FFF00', 'ledColorChartreuse'),
  LedColorPreset('#39FF14', 'ledColorNeonGreen'),
  LedColorPreset('#006400', 'ledColorDarkGreen'),
  LedColorPreset('#228B22', 'ledColorForestGreen'),
  LedColorPreset('#00C957', 'ledColorEmerald'),
  LedColorPreset('#00E676', 'ledColorMint'),
  LedColorPreset('#00A86B', 'ledColorJade'),
  LedColorPreset('#808000', 'ledColorOlive'),
  LedColorPreset('#98FB98', 'ledColorPaleGreen'),
  LedColorPreset('#008080', 'ledColorTeal'),
  LedColorPreset('#40E0D0', 'ledColorTurquoiseStandard'),
  LedColorPreset('#7FFFD4', 'ledColorAquamarine'),
  LedColorPreset('#00CBB6', 'ledColorCaribbeanTeal'),
  LedColorPreset('#00FFFF', 'ledColorCyan'),
  LedColorPreset('#29B6F6', 'ledColorSkyBlue'),
  LedColorPreset('#00BFFF', 'ledColorDeepSkyBlue'),
  LedColorPreset('#168CFF', 'ledColorVividAzure'),
  LedColorPreset('#147DFF', 'ledColorElectricBlue'),
  LedColorPreset('#1E90FF', 'ledColorDodgerBlue'),
  LedColorPreset('#2455FF', 'ledColorRoyalBlue'),
  LedColorPreset('#191970', 'ledColorMidnightBlue'),
  LedColorPreset('#000080', 'ledColorNavy'),
  LedColorPreset('#4B0082', 'ledColorIndigo'),
  LedColorPreset('#5E35B1', 'ledColorAmethyst'),
  LedColorPreset('#7F00FF', 'ledColorElectricViolet'),
  LedColorPreset('#663399', 'ledColorRebeccaPurple'),
  LedColorPreset('#9C27B0', 'ledColorPurple'),
  LedColorPreset('#BF00FF', 'ledColorNeonPurple'),
  LedColorPreset('#9370DB', 'ledColorMediumPurple'),
  LedColorPreset('#DA70D6', 'ledColorOrchid'),
  LedColorPreset('#E6E6FA', 'ledColorLavender'),
  LedColorPreset('#DDA0DD', 'ledColorPlum'),
  LedColorPreset('#FF00FF', 'ledColorMagenta'),
  LedColorPreset('#FF1493', 'ledColorDeepPink'),
  LedColorPreset('#FF4081', 'ledColorNeonPink'),
  LedColorPreset('#FF69B4', 'ledColorHotPinkStandard'),
  LedColorPreset('#FF557A', 'ledColorRosePink'),
  LedColorPreset('#FFFFFF', 'ledColorWhite'),
];

final List<String> ledColorPalette = List<String>.unmodifiable(
  ledColorPresets.map((preset) => preset.hex),
);

// Retain readable names for colors already stored by earlier app versions.
// Aliases only affect presentation; RGB protocol values remain unchanged.
const Map<String, String> legacyLedColorNameKeys = <String, String>{
  '#DC143C': 'ledColorCrimson',
  '#FF4000': 'ledColorOrangeRed',
  '#FF8000': 'ledColorOrange',
  '#FFC000': 'ledColorGoldenOrange',
  '#FFFF00': 'ledColorYellow',
  '#80FF00': 'ledColorSpringLime',
  '#00FF00': 'ledColorGreen',
  '#00FF80': 'ledColorSpringGreen',
  '#00BFFF': 'ledColorDeepSkyBlue',
  '#0080FF': 'ledColorAzure',
  '#0040FF': 'ledColorBlue',
  '#0000FF': 'ledColorBlue',
  '#4000FF': 'ledColorIndigo',
  '#8000FF': 'ledColorViolet',
  '#BF00FF': 'ledColorNeonPurple',
  '#FF0080': 'ledColorFuchsia',
  '#FF4080': 'ledColorRosePink',
  '#FF0040': 'ledColorScarlet',
  '#FF8040': 'ledColorCoral',
  '#FFB6C1': 'ledColorPink',
};

String ledColorDisplayName(String hex, [AppLanguage? language]) {
  final raw = hex.trim().toUpperCase();
  final normalized = raw.startsWith('#') ? raw : '#$raw';
  for (final preset in ledColorPresets) {
    if (preset.hex == normalized) return JexText.of(preset.nameKey, language);
  }
  final legacyNameKey = legacyLedColorNameKeys[normalized];
  if (legacyNameKey != null) return JexText.of(legacyNameKey, language);
  return JexText.of('customColor', language);
}

Color ledPaletteColor(String hex) {
  final rgb = int.parse(hex.substring(1), radix: 16);
  return Color(0xFF000000 | rgb);
}

// Firmware IDs remain stable when a mode is retired.
const List<int> supportedLedModeIds = <int>[1, 2, 4, 5, 6, 7];

bool isSupportedLedModeId(int mode) => supportedLedModeIds.contains(mode);

int ledModeDisplayIndex(int firmwareMode) =>
    supportedLedModeIds.indexOf(firmwareMode);

int ledFirmwareModeForDisplayIndex(int index) =>
    supportedLedModeIds[index.clamp(0, supportedLedModeIds.length - 1).toInt()];

class LedSyncSnapshot {
  final int mode;
  final int phaseMs;
  final int cycleMs;

  const LedSyncSnapshot({
    required this.mode,
    required this.phaseMs,
    required this.cycleMs,
  });

  static LedSyncSnapshot? parse(String raw) {
    final parts = raw.split(',');
    if (parts.length != 3) return null;
    final mode = int.tryParse(parts[0].trim());
    final phase = int.tryParse(parts[1].trim());
    final cycle = int.tryParse(parts[2].trim());
    if (mode == null ||
        mode < 1 ||
        mode > 7 ||
        phase == null ||
        phase < 0 ||
        cycle == null ||
        cycle < 1 ||
        cycle > 30000) {
      return null;
    }
    return LedSyncSnapshot(mode: mode, phaseMs: phase % cycle, cycleMs: cycle);
  }
}

/// Firmware-owned LED animation timing helpers. Mode IDs stay aligned with firmware.
int ledAnimationCycleMs(int mode) {
  switch (mode) {
    case 1:
      return 1000;
    case 2:
      return 2200;
    case 4:
      return 1600;
    case 5:
      return 900;
    case 6:
      return 1800;
    case 7:
      return 30000;
  }
  return 1000;
}

/// Returns normalized per-pixel intensity in the firmware's physical pixel order.
/// Hardware order is RIGHT TOP->BOTTOM (0..3), then LEFT BOTTOM->TOP (4..7).
List<double> ledPreviewLevels({required int mode, required int phaseMs}) {
  final levels = List<double>.filled(8, 0);
  final safeMode = mode.clamp(1, 7).toInt();
  final cycle = ledAnimationCycleMs(safeMode);
  final phase = phaseMs < 0 ? 0 : phaseMs % cycle;

  final activeMode = isSupportedLedModeId(safeMode) ? safeMode : 1;
  switch (activeMode) {
    case 1:
      levels.fillRange(0, 8, 1);
    case 2:
      final breathingPhase = phase / 2200.0;
      final level =
          .12 + .88 * (.5 + .5 * math.sin(breathingPhase * math.pi * 2));
      levels.fillRange(0, 8, level);
    case 4:
      final head = phase / 200.0;
      for (var pixel = 0; pixel < 8; pixel++) {
        final distance = (head - pixel + 8.0) % 8.0;
        var level = 0.0;
        if (distance < 1.0) {
          level = 1.0 - distance;
        } else if (distance < 2.0) {
          level = .55 * (2.0 - distance);
        } else if (distance < 3.0) {
          level = .25 * (3.0 - distance);
        }
        levels[pixel] = level;
      }
    case 5:
      const sequence = <int>[0, 1, 2, 3, 2, 1];
      final pair = sequence[(phase ~/ 150) % sequence.length];
      levels[pair] = 1.0;
      levels[7 - pair] = 1.0;
    case 6:
      final wavePhase = phase / 1800.0;
      final wave = .5 + .5 * math.sin(wavePhase * math.pi * 2);
      final leftLevel = .10 + .90 * wave;
      final rightLevel = .10 + .90 * (1.0 - wave);
      for (var i = 0; i < 4; i++) {
        levels[4 + i] = leftLevel;
        levels[i] = rightLevel;
      }
    case 7:
      levels.fillRange(0, 8, 1);
  }
  return levels;
}

/// Returns per-pixel RGB colors using the same base brightness and Rainbow phase as firmware.
List<Color> ledPreviewColors({
  required int mode,
  required int phaseMs,
  required String baseColor,
}) {
  // Keep full chroma here. Brightness belongs in painter alpha/glow, not RGB
  // multiplication, which makes low-brightness colors collapse toward black.
  if (mode != 7) {
    final hex = normalizeLedColor(baseColor);
    final normalizedHex = hex.length == 6 ? '#$hex' : baseColor;
    final rgb = ledPaletteColor(normalizedHex);
    return List<Color>.filled(8, rgb);
  }

  const cycleMs = 30000;
  final hue = ((phaseMs.clamp(0, cycleMs - 1)) / cycleMs) * 360.0;
  final rainbow = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  return List<Color>.filled(8, rainbow);
}

// Preview colours describe the animation, never the hardware Brightness slider.
// Static and Rainbow stay saturated; true OFF pixels in Comet/Dual Chase use a pale neutral baseline.
Color ledPreviewPixelColor({
  required int mode,
  required double level,
  required Color animatedColor,
  required bool active,
  required bool darkTheme,
}) {
  final pixelLevel = level.clamp(0.0, 1.0).toDouble();
  final inactiveColor = darkTheme
      ? const Color(0xFFCDD4DF)
      : const Color(0xFFADB5C2);
  if (!active || ((mode == 4 || mode == 5) && pixelLevel <= 0.02)) {
    return inactiveColor;
  }
  return animatedColor;
}

double ledPreviewPixelOpacity({
  required int mode,
  required double level,
  required bool active,
}) {
  if (!active) return .88;
  final pixelLevel = level.clamp(0.0, 1.0).toDouble();
  // Hardware brightness must never dim Static/Rainbow preview colours.
  if (mode == 1 || mode == 7 || mode == 5) return 1.0;
  if (mode == 4) return pixelLevel <= 0.02 ? 1.0 : (.58 + .42 * pixelLevel);
  if (mode == 2 || mode == 6) return .38 + .62 * pixelLevel;
  return 1.0;
}

/// Positions separate modal menus below Home and the display-tab region.
/// On short screens the menu remains scrollable and the offset is clamped.
double displayMenuOverlayTop({
  required double screenWidth,
  required double availableHeight,
}) {
  final scale = (screenWidth / 360.0).clamp(.85, 1.4).toDouble();
  final desired = 492.0 * scale;
  return math.min(desired, math.max(12.0, availableHeight * .64)).toDouble();
}

/// Resolve the firmware-anchored LED phase in milliseconds.
///
/// The elapsed clock is monotonic; a new firmware sync snapshot replaces the
/// anchor, while reduced motion only pauses frame scheduling.
int jexSynchronizedLedPhaseMs({
  required int phaseAnchorMs,
  required int elapsedSinceAnchorMs,
  required int cycleMs,
}) {
  final cycle = math.max(1, cycleMs).toInt();
  final anchor = phaseAnchorMs % cycle;
  final elapsed = math.max(0, elapsedSinceAnchorMs).toInt();
  return (anchor + elapsed) % cycle;
}

class JexLedStripPreview extends StatefulWidget {
  final int mode;
  final String colorHex;
  final bool active;
  final int ledPhaseMs;
  final int ledCycleMs;
  final int ledSyncRevision;
  final String modeName;
  final bool previousEnabled;
  final bool nextEnabled;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const JexLedStripPreview({
    super.key,
    required this.mode,
    required this.colorHex,
    required this.active,
    required this.ledPhaseMs,
    required this.ledCycleMs,
    required this.ledSyncRevision,
    required this.modeName,
    required this.previousEnabled,
    required this.nextEnabled,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  State<JexLedStripPreview> createState() => _JexLedStripPreviewState();
}

class _JexLedStripPreviewState extends State<JexLedStripPreview>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController controller;
  late final Stopwatch _phaseClock;
  int _phaseAnchorMs = 0;
  int _phaseAnchorElapsedMs = 0;
  bool _mediaQueryDisableAnimations = false;
  bool _systemReduceMotion = false;
  bool _hasMotionPreference = false;

  bool get _reduceMotion => _mediaQueryDisableAnimations || _systemReduceMotion;

  int _safeCycle(int value) => math.max(1, value);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _systemReduceMotion = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .reduceMotion;
    _phaseClock = Stopwatch()..start();
    _phaseAnchorMs = widget.ledPhaseMs % _safeCycle(widget.ledCycleMs);
    _phaseAnchorElapsedMs = _phaseClock.elapsedMilliseconds;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _safeCycle(widget.ledCycleMs)),
    );
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

  void _applyMotionPreference() {
    if (!_hasMotionPreference) return;
    if (_reduceMotion) {
      // Keep the phase clock monotonic; only stop continuous frame scheduling.
      controller.stop();
    } else if (widget.active && !controller.isAnimating) {
      controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant JexLedStripPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ledCycleMs != oldWidget.ledCycleMs) {
      controller.duration = Duration(
        milliseconds: _safeCycle(widget.ledCycleMs),
      );
      if (widget.active && !_reduceMotion) {
        controller.repeat();
      } else if (_reduceMotion) {
        controller.stop();
      }
    }

    if (widget.ledSyncRevision != oldWidget.ledSyncRevision) {
      // A full firmware snapshot is a new time origin; keep elapsed time relative
      // to that snapshot instead of snapping the preview back to local phase zero.
      _phaseAnchorMs = widget.ledPhaseMs % _safeCycle(widget.ledCycleMs);
      _phaseAnchorElapsedMs = _phaseClock.elapsedMilliseconds;
    }

    if (widget.active != oldWidget.active) {
      if (widget.active) {
        if (!_reduceMotion) controller.repeat();
      } else {
        controller.stop();
        controller.value = 0;
      }
    } else if (widget.active && !_reduceMotion && !controller.isAnimating) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  Widget _modeArrow(
    BuildContext context, {
    required bool left,
    required bool enabled,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: enabled ? (left ? widget.onPrevious : widget.onNext) : null,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: 29,
        height: 34,
        decoration: BoxDecoration(
          color: enabled
              ? scheme.surface
              : scheme.surfaceContainerHighest.withValues(alpha: .45),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Icon(
          left ? PhosphorIconsBold.caretLeft : PhosphorIconsBold.caretRight,
          size: 18,
          color: enabled
              ? scheme.onSurface
              : scheme.onSurfaceVariant.withValues(alpha: .30),
        ),
      ),
    );
  }

  Widget _ledColumn({
    required bool leftSide,
    required int mode,
    required List<double> levels,
    required List<Color> colors,
    required bool active,
    required Color background,
  }) {
    return SizedBox(
      width: 23,
      height: 58,
      child: CustomPaint(
        painter: _JexLedStripPainter(
          mode: mode,
          levels: levels,
          colors: colors,
          active: active,
          leftSide: leftSide,
          background: background,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cycle = _safeCycle(widget.ledCycleMs);
    final background = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2B2F37)
        : const Color(0xFFDDE1E7);
    final scheme = Theme.of(context).colorScheme;

    // These controls and the mode label do not depend on LED phase. Keep them
    // outside the ticker-driven builder so each LED frame only rebuilds paint.
    final modeLabel = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 148),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Text(
            widget.modeName.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 11.5,
              height: 1.0,
              fontWeight: FontWeight.w900,
              letterSpacing: .25,
            ),
          ),
        ),
      ),
    );

    return RepaintBoundary(
      child: SizedBox(
        height: 58,
        child: Row(
          children: [
            _modeArrow(context, left: true, enabled: widget.previousEnabled),
            const SizedBox(width: 4),
            Expanded(
              child: AnimatedBuilder(
                animation: controller,
                child: modeLabel,
                builder: (_, staticModeLabel) {
                  final elapsed = math
                      .max(
                        0,
                        _phaseClock.elapsedMilliseconds - _phaseAnchorElapsedMs,
                      )
                      .toInt();
                  final syncedPhase = jexSynchronizedLedPhaseMs(
                    phaseAnchorMs: _phaseAnchorMs,
                    elapsedSinceAnchorMs: elapsed,
                    cycleMs: cycle,
                  );
                  final levels = ledPreviewLevels(
                    mode: widget.mode,
                    phaseMs: syncedPhase,
                  );
                  final colors = ledPreviewColors(
                    mode: widget.mode,
                    phaseMs: syncedPhase,
                    baseColor: widget.colorHex,
                  );

                  return Row(
                    children: [
                      _ledColumn(
                        leftSide: true,
                        mode: widget.mode,
                        levels: levels,
                        colors: colors,
                        active: widget.active,
                        background: background,
                      ),
                      const SizedBox(width: 4),
                      Expanded(child: staticModeLabel!),
                      const SizedBox(width: 4),
                      _ledColumn(
                        leftSide: false,
                        mode: widget.mode,
                        levels: levels,
                        colors: colors,
                        active: widget.active,
                        background: background,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 4),
            _modeArrow(context, left: false, enabled: widget.nextEnabled),
          ],
        ),
      ),
    );
  }
}

class _JexLedStripPainter extends CustomPainter {
  final int mode;
  final List<double> levels;
  final List<Color> colors;
  final bool active;
  final bool leftSide;
  final Color background;

  const _JexLedStripPainter({
    required this.mode,
    required this.levels,
    required this.colors,
    required this.active,
    required this.leftSide,
    required this.background,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const radius = 5.3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(1, centerY - 23, math.max(0, size.width - 2), 46),
        const Radius.circular(10),
      ),
      Paint()..color = background,
    );

    final top = centerY - 17;
    const verticalGap = 11.3;
    const leftIndices = <int>[7, 6, 5, 4];
    const rightIndices = <int>[0, 1, 2, 3];
    final indices = leftSide ? leftIndices : rightIndices;
    for (var row = 0; row < 4; row++) {
      final index = indices[row];
      final level = active ? levels[index] : 0.0;
      final animatedColor = colors[index];
      final pixelColor = ledPreviewPixelColor(
        mode: mode,
        level: level,
        animatedColor: animatedColor,
        active: active,
        darkTheme: background.computeLuminance() < .5,
      );
      final center = Offset(centerX, top + verticalGap * row);
      final pixelOpacity = ledPreviewPixelOpacity(
        mode: mode,
        level: level,
        active: active,
      );
      final glowOpacity = active && level > .02
          ? ((mode == 1 || mode == 7) ? .10 : .20 * level)
          : 0.0;

      if (glowOpacity > .002) {
        canvas.drawCircle(
          center,
          radius + ((mode == 1 || mode == 7) ? 2.0 : 2.8),
          Paint()
            ..color = pixelColor.withValues(alpha: glowOpacity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
      }
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = pixelColor.withValues(alpha: pixelOpacity),
      );
      canvas.drawCircle(
        center.translate(-radius * .22, -radius * .22),
        radius * .20,
        Paint()
          ..color = Colors.white.withValues(
            alpha: active ? (.12 + .16 * level) : .12,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _JexLedStripPainter oldDelegate) =>
      oldDelegate.mode != mode ||
      oldDelegate.levels != levels ||
      oldDelegate.colors != colors ||
      oldDelegate.active != active ||
      oldDelegate.leftSide != leftSide ||
      oldDelegate.background != background;
}

double jexLedColorPickerMaxHeight(double availableHeight) {
  if (!availableHeight.isFinite || availableHeight <= 0) return 0;
  return math.min(308.0, availableHeight * .82).roundToDouble();
}

class JexColorPickerCard extends StatefulWidget {
  final List<LedColorPreset> colors;
  final String selected;
  final Future<bool> Function(String) onSelect;
  final VoidCallback onCancel;

  const JexColorPickerCard({
    required this.colors,
    required this.selected,
    required this.onSelect,
    required this.onCancel,
  });

  @override
  State<JexColorPickerCard> createState() => _JexColorPickerCardState();
}

class _JexColorPickerCardState extends State<JexColorPickerCard> {
  late String _draftSelected;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    _draftSelected = widget.selected.trim().toUpperCase();
  }

  @override
  void didUpdateWidget(covariant JexColorPickerCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isApplying && oldWidget.selected != widget.selected) {
      _draftSelected = widget.selected.trim().toUpperCase();
    }
  }

  Future<void> _applySelection() async {
    if (_isApplying) return;

    setState(() => _isApplying = true);
    try {
      final applied = await widget.onSelect(_draftSelected);
      if (applied && mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lang = appLanguageNotifier.value;
    final selectedName = ledColorDisplayName(_draftSelected, lang);
    final normalizedSelected = _draftSelected.trim().toUpperCase();
    final selectedColor =
        normalizedSelected.startsWith('#') && normalizedSelected.length == 7
        ? ledPaletteColor(normalizedSelected)
        : scheme.surfaceContainerHighest;

    return Material(
      color: scheme.surface,
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: .24),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(7, 8, 7, 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    JexText.of('color', lang),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _isApplying ? null : widget.onCancel,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        minimumSize: const Size(72, 48),
                        tapTargetSize: MaterialTapTargetSize.padded,
                      ),
                      child: Text(
                        JexText.of('cancel', lang),
                        style: TextStyle(
                          color: scheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isApplying ? null : _applySelection,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        minimumSize: const Size(72, 48),
                        tapTargetSize: MaterialTapTargetSize.padded,
                      ),
                      child: Text(
                        JexText.of('select', lang),
                        style: TextStyle(
                          color: scheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    selectedName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 3,
                radius: const Radius.circular(4),
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 2),
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.colors.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 48,
                  ),
                  itemBuilder: (_, index) {
                    final preset = widget.colors[index];
                    final value = preset.hex;
                    final isSelected = normalizedSelected == value;
                    final isWhite = value == '#FFFFFF';
                    final name = JexText.of(preset.nameKey, lang);
                    return Tooltip(
                      message: name,
                      child: Semantics(
                        label: name,
                        button: true,
                        selected: isSelected,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(9),
                          onTap: _isApplying
                              ? null
                              : () {
                                  if (_draftSelected == value) return;
                                  setState(() => _draftSelected = value);
                                },
                          child: SizedBox.expand(
                            child: Center(
                              child: AnimatedContainer(
                                width: 32,
                                height: 32,
                                duration: const Duration(milliseconds: 120),
                                decoration: BoxDecoration(
                                  color: ledPaletteColor(value),
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                    color: isSelected
                                        ? scheme.onSurface
                                        : (isWhite
                                              ? scheme.outline
                                              : Colors.transparent),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: scheme.primary.withValues(
                                              alpha: .22,
                                            ),
                                            blurRadius: 4,
                                            spreadRadius: .5,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: isSelected
                                    ? JexAnimatedGlyph(
                                        icon: PhosphorIconsBold.check,
                                        color: isWhite
                                            ? Colors.black
                                            : Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
