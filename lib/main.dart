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
import 'dart:ui' show ImageFilter;

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

String otaStageLocalizationKey(String stage) {
  const special = <String, String>{
    'ONLINE_IMAGE_VALIDATE': 'otaStageOnlineImageValidate',
  };
  return special[stage.trim().toUpperCase()] ?? '';
}

bool isSupportedP1Protocol(String value) =>
    value.trim().toUpperCase() == 'P1';

int peltierRearmTarget(int hotLimit) => hotLimit - 1;

String normalizeLedColor(String value) {
  final normalized = value.trim().toUpperCase();
  return normalized.startsWith('#') ? normalized.substring(1) : normalized;
}

String peltierRearmNotice(int hotLimit, AppLanguage language) {
  final target = peltierRearmTarget(hotLimit);
  return JexText.phrase(
    'Peltier is locked. Cool the Hotside to ≤ ' + target.toString() + '°C before restarting.',
    'Peltier terkunci. Dinginkan Hotside hingga ≤ ' + target.toString() + '°C sebelum menyalakan kembali.',
    language,
  );
}

/// Returns true when a live, healthy firmware update can clear a stale Home NOTIFY error.
/// Computes the Home Fan Speed presentation from authoritative runtime state.
String homeFanSpeedDisplay({
  required bool connected,
  required bool fanOn,
  required String voltage,
  required bool adaptiveOn,
  required int fanSpeed,
  required String offLabel,
}) {
  if (!connected) return '--';
  if (!fanOn) return offLabel;
  if (voltage == '5V' || voltage == '9V') return '100%';
  // At 12 V, show authoritative live PWM in both Manual and Adaptive.
  if (voltage == '12V') return '$fanSpeed%';
  return '--';
}

String homeNotifyConnectionLabel({
  required String notice,
  required bool isConnecting,
  required bool isSyncing,
  required bool connected,
  required AppLanguage language,
}) {
  final custom = notice.trim().toUpperCase();
  if (custom.contains('FAILED') ||
      custom.contains('ERROR') ||
      custom.contains('NOT FOUND') ||
      custom.contains('SERVICE DISCOVERY')) {
    return JexText.of('error', language);
  }
  if (isConnecting) return JexText.of('connecting', language);
  if (isSyncing) return JexText.of('syncing', language);
  return JexText.of(connected ? 'connected' : 'disconnected', language);
}

bool shouldClearStaleNotifyError({
  required bool connected,
  required String safety,
  required String safetyReason,
  required bool liveTelemetryReceived,
  required String notice,
}) {
  if (!connected || !liveTelemetryReceived) return false;

  final safe = safety.trim().toUpperCase() == 'OK' &&
      safetyReason.trim().toUpperCase() == 'NONE';
  if (!safe) return false;

  final upper = notice.trim().toUpperCase();
  if (upper.isEmpty ||
      upper.contains('OTA') ||
      upper.contains('FIRMWARE')) {
    return false;
  }

  return upper.contains('PELTIER IS LOCKED') ||
      upper.contains('PELTIER TERKUNCI') ||
      upper.contains('NOT CONFIRMED') ||
      upper.contains('COMMAND FAILED') ||
      upper.contains('FAILED') ||
      upper.contains('ERROR') ||
      upper.contains('TIDAK DIKONFIRMASI') ||
      upper.contains('GAGAL') ||
      upper.contains('KESALAHAN');
}

// AI-UI-GEOMETRY: Shared submenu dimensions keep VOLTAGE, CONTROL, ADAPTIVE, and LED aligned.
const double jexSubmenuRowMinHeight = 62.0;
const double jexSubmenuToggleWidth = 54.0;
const double jexSubmenuToggleHeight = 32.0;

// Curated hue-first presets; the Brightness slider remains the only intensity control.
class LedColorPreset {
  final String hex;
  final String nameKey;
  const LedColorPreset(this.hex, this.nameKey);
}

const List<LedColorPreset> ledColorPresets = <LedColorPreset>[
  LedColorPreset('#FF1744', 'ledColorCandyRed'),
  LedColorPreset('#FF0000', 'ledColorRed'),
  LedColorPreset('#FF2400', 'ledColorScarlet'),
  LedColorPreset('#FF4500', 'ledColorVermilion'),
  LedColorPreset('#FF6347', 'ledColorCoral'),
  LedColorPreset('#FA8072', 'ledColorSalmon'),
  LedColorPreset('#FF8C00', 'ledColorTangerine'),
  LedColorPreset('#FFB38A', 'ledColorPeach'),
  LedColorPreset('#C68642', 'ledColorCaramel'),
  LedColorPreset('#A85D32', 'ledColorChocolate'),
  LedColorPreset('#FFBF00', 'ledColorAmber'),
  LedColorPreset('#FFD700', 'ledColorGoldenYellow'),
  LedColorPreset('#EFFF00', 'ledColorLemon'),
  LedColorPreset('#BFFF00', 'ledColorChartreuse'),
  LedColorPreset('#7FFF00', 'ledColorLime'),
  LedColorPreset('#39FF14', 'ledColorNeonGreen'),
  LedColorPreset('#00C957', 'ledColorEmerald'),
  LedColorPreset('#00E676', 'ledColorMint'),
  LedColorPreset('#00A86B', 'ledColorJade'),
  LedColorPreset('#00CBB6', 'ledColorTurquoise'),
  LedColorPreset('#00FFFF', 'ledColorCyan'),
  LedColorPreset('#29B6F6', 'ledColorSkyBlue'),
  LedColorPreset('#168CFF', 'ledColorAzure'),
  LedColorPreset('#147DFF', 'ledColorElectricBlue'),
  LedColorPreset('#2455FF', 'ledColorRoyalBlue'),
  LedColorPreset('#4B0082', 'ledColorIndigo'),
  LedColorPreset('#5E35B1', 'ledColorBlueViolet'),
  LedColorPreset('#7F00FF', 'ledColorViolet'),
  LedColorPreset('#9C27B0', 'ledColorPurple'),
  LedColorPreset('#BF00FF', 'ledColorNeonPurple'),
  LedColorPreset('#DA70D6', 'ledColorOrchid'),
  LedColorPreset('#FF00FF', 'ledColorMagenta'),
  LedColorPreset('#FF1493', 'ledColorFuchsia'),
  LedColorPreset('#FF4081', 'ledColorHotPink'),
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
    if (mode == null || mode < 1 || mode > 7 ||
        phase == null || phase < 0 ||
        cycle == null || cycle < 1 || cycle > 30000) {
      return null;
    }
    return LedSyncSnapshot(
      mode: mode,
      phaseMs: phase % cycle,
      cycleMs: cycle,
    );
  }
}

/// Firmware-owned LED animation timing helpers. Mode IDs stay aligned with firmware.
int ledAnimationCycleMs(int mode) {
  switch (mode) {
    case 1: return 1000;
    case 2: return 2200;
    case 4: return 1600;
    case 5: return 900;
    case 6: return 1800;
    case 7: return 30000;
  }
  return 1000;
}

/// Returns normalized per-pixel intensity in the firmware's physical pixel order.
/// Hardware order is RIGHT TOP->BOTTOM (0..3), then LEFT BOTTOM->TOP (4..7).
List<double> ledPreviewLevels({
  required int mode,
  required int phaseMs,
}) {
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
      final level = .12 + .88 * (.5 + .5 * math.sin(breathingPhase * math.pi * 2));
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
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Stopwatch _phaseClock;
  int _phaseAnchorMs = 0;
  int _phaseAnchorElapsedMs = 0;

  int _safeCycle(int value) => math.max(1, value);

  @override
  void initState() {
    super.initState();
    _phaseClock = Stopwatch()..start();
    _phaseAnchorMs = widget.ledPhaseMs % _safeCycle(widget.ledCycleMs);
    _phaseAnchorElapsedMs = _phaseClock.elapsedMilliseconds;
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _safeCycle(widget.ledCycleMs)),
    );
    if (widget.active) controller.repeat();
  }

  @override
  void didUpdateWidget(covariant JexLedStripPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.ledCycleMs != oldWidget.ledCycleMs) {
      controller.duration = Duration(milliseconds: _safeCycle(widget.ledCycleMs));
      if (widget.active) controller.repeat();
    }

    if (widget.ledSyncRevision != oldWidget.ledSyncRevision) {
      _phaseAnchorMs = widget.ledPhaseMs % _safeCycle(widget.ledCycleMs);
      _phaseAnchorElapsedMs = _phaseClock.elapsedMilliseconds;
    }

    if (widget.active != oldWidget.active) {
      if (widget.active) {
        controller.repeat();
      } else {
        controller.stop();
        controller.value = 0;
      }
    } else if (widget.active && !controller.isAnimating) {
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _modeArrow(BuildContext context, {required bool left, required bool enabled}) {
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
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final elapsed = math.max(
            0,
            _phaseClock.elapsedMilliseconds - _phaseAnchorElapsedMs,
          ).toInt();
          final syncedPhase = ((_phaseAnchorMs + elapsed) % cycle).toInt();
          final levels = ledPreviewLevels(mode: widget.mode, phaseMs: syncedPhase);
          final colors = ledPreviewColors(
            mode: widget.mode,
            phaseMs: syncedPhase,
            baseColor: widget.colorHex,
          );
          final background = Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2B2F37)
              : const Color(0xFFDDE1E7);
          final scheme = Theme.of(context).colorScheme;

          return SizedBox(
            height: 58,
            child: Row(
              children: [
                _modeArrow(context, left: true, enabled: widget.previousEnabled),
                const SizedBox(width: 4),
                _ledColumn(
                  leftSide: true,
                  mode: widget.mode,
                  levels: levels,
                  colors: colors,
                  active: widget.active,
                  background: background,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Center(
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
                  ),
                ),
                const SizedBox(width: 4),
                _ledColumn(
                  leftSide: false,
                  mode: widget.mode,
                  levels: levels,
                  colors: colors,
                  active: widget.active,
                  background: background,
                ),
                const SizedBox(width: 4),
                _modeArrow(context, left: false, enabled: widget.nextEnabled),
              ],
            ),
          );
        },
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
        Paint()..color = Colors.white.withValues(
          alpha: active ? (.12 + .16 * level) : .12,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _JexLedStripPainter oldDelegate) =>
      oldDelegate.levels != levels ||
      oldDelegate.colors != colors ||
      oldDelegate.active != active ||
      oldDelegate.leftSide != leftSide ||
      oldDelegate.background != background;
}

class _JexColorPickerCard extends StatefulWidget {
  final List<LedColorPreset> colors;
  final String selected;
  final Future<bool> Function(String) onSelect;
  final VoidCallback onCancel;

  const _JexColorPickerCard({
    required this.colors,
    required this.selected,
    required this.onSelect,
    required this.onCancel,
  });

  @override
  State<_JexColorPickerCard> createState() => _JexColorPickerCardState();
}

class _JexColorPickerCardState extends State<_JexColorPickerCard> {
  late String _draftSelected;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    _draftSelected = widget.selected.trim().toUpperCase();
  }

  @override
  void didUpdateWidget(covariant _JexColorPickerCard oldWidget) {
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
      elevation: 20,
      shadowColor: Colors.black.withValues(alpha: .28),
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 46,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    JexText.of('color', lang),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: _isApplying ? null : widget.onCancel,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(64, 44),
                        tapTargetSize: MaterialTapTargetSize.padded,
                      ),
                      child: Text(
                        JexText.of('cancel', lang),
                        style: TextStyle(
                          color: scheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isApplying ? null : _applySelection,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(64, 44),
                        tapTargetSize: MaterialTapTargetSize.padded,
                      ),
                      child: Text(
                        JexText.of('select', lang),
                        style: TextStyle(
                          color: scheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: selectedColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  selectedName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.colors.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                mainAxisExtent: 42,
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
                      borderRadius: BorderRadius.circular(11),
                      onTap: _isApplying
                          ? null
                          : () {
                              if (_draftSelected == value) return;
                              setState(() => _draftSelected = value);
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 120),
                        decoration: BoxDecoration(
                          color: ledPaletteColor(value),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: isSelected
                                ? scheme.onSurface
                                : (isWhite ? scheme.outline : Colors.transparent),
                            width: isSelected ? 2.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: scheme.primary.withValues(alpha: .28),
                                    blurRadius: 7,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
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
                    ),
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
// Shared active-state gate; the kind-aware policy below handles continuous sensors.
// Battery, Hotside and Voltage loop while connected; outputs require an active known state.
bool jexIndicatorAnimationActive({
  required bool connected,
  required bool stateActive,
}) =>
    connected && stateActive;

/// Battery, Hotside and Voltage are continuous indicators while BLE is online.
/// Output indicators only animate while their authoritative state is active.
bool jexIconAnimationPermitted({
  required bool connected,
  required JexAnimatedIconKind kind,
  required bool stateActive,
}) {
  if (!connected ||
      kind == JexAnimatedIconKind.generic ||
      kind == JexAnimatedIconKind.bluetooth) {
    return false;
  }
  if (kind == JexAnimatedIconKind.battery ||
      kind == JexAnimatedIconKind.hotside ||
      kind == JexAnimatedIconKind.voltage) {
    return true;
  }
  // Fan Speed interpolates actual BLE PWM updates; it must not run a decorative cycle.
  if (kind == JexAnimatedIconKind.speed) return false;
  return stateActive;
}

enum DisplayMenuLockReason { none, bluetoothDisconnected, adaptiveActive }

/// Applies a single lock overlay to the selected submenu; Bluetooth has priority.
DisplayMenuLockReason displayMenuLockReason({
  required bool connected,
  required bool adaptiveActive,
  required bool adaptiveTransitioning,
  required int tabIndex,
}) {
  if (!connected) return DisplayMenuLockReason.bluetoothDisconnected;
  final adaptiveLocksTab = tabIndex == 0 || tabIndex == 1 || tabIndex == 4;
  if ((adaptiveActive || adaptiveTransitioning) && adaptiveLocksTab) {
    return DisplayMenuLockReason.adaptiveActive;
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
    JexAnimatedIconKind.battery => const Duration(milliseconds: 4200),
    JexAnimatedIconKind.hotside => const Duration(milliseconds: 4400),
    JexAnimatedIconKind.voltage => const Duration(milliseconds: 3000),
    JexAnimatedIconKind.adaptive => const Duration(milliseconds: 6400),
    JexAnimatedIconKind.peltier => const Duration(milliseconds: 5200),
    JexAnimatedIconKind.fan => const Duration(milliseconds: 2600),
    JexAnimatedIconKind.speed => const Duration(milliseconds: 1800),
    JexAnimatedIconKind.led => const Duration(milliseconds: 3000),
    JexAnimatedIconKind.bluetooth => const Duration(milliseconds: 2800),
    JexAnimatedIconKind.generic => const Duration(milliseconds: 2000),
  };
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
  return temperature != null &&
      hotLimit.isFinite &&
      temperature >= hotLimit;
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
  final IconData? glyph;
  final Color color;
  final bool connected;
  final double size;
  final bool active;
  final double level;
  final int voltageLevel;
  final bool warning;

  const JexAnimatedIcon({
    super.key,
    required this.kind,
    this.glyph,
    required this.color,
    this.size = 24,
    this.connected = false,
    this.active = false,
    this.level = 1,
    this.voltageLevel = 5,
    this.warning = false,
  });

  const JexAnimatedIcon.glyph({
    super.key,
    required IconData icon,
    required this.color,
    this.size = 24,
    this.active = false,
    this.warning = false,
  })  : connected = false,
        kind = JexAnimatedIconKind.generic,
        glyph = icon,
        level = 1,
        voltageLevel = 5;

  @override
  State<JexAnimatedIcon> createState() => _JexAnimatedIconState();
}

class _JexAnimatedIconState extends State<JexAnimatedIcon>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final AnimationController activityTransitionController;
  late final AnimationController frostTransitionController;
  late final AnimationController speedLevelTransitionController;
  late final AnimationController indicatorLevelTransitionController;
  double _frostFromIntensity = .24;
  double _frostFromParticleCount = 2;
  double _speedFromLevel = 0;
  double _speedTargetLevel = 0;
  double _indicatorLevelFrom = 0;
  double _indicatorLevelTarget = 0;
  bool _fanCoasting = false;

  double _currentSpeedLevel() => jexSmoothFanSpeedLevel(
        from: _speedFromLevel,
        to: _speedTargetLevel,
        progress: speedLevelTransitionController.value,
      );

  double _currentIndicatorLevel() {
    final t = Curves.easeInOutCubic.transform(indicatorLevelTransitionController.value);
    return _indicatorLevelFrom + (_indicatorLevelTarget - _indicatorLevelFrom) * t;
  }

  void _retargetIndicatorLevel(double target) {
    _indicatorLevelFrom = _currentIndicatorLevel();
    _indicatorLevelTarget = target.clamp(0.0, 1.0).toDouble();
    indicatorLevelTransitionController.duration = const Duration(milliseconds: 520);
    indicatorLevelTransitionController.forward(from: 0);
  }

  void _retargetSpeedLevel(double target, {required Duration duration}) {
    final current = _currentSpeedLevel();
    _speedFromLevel = current;
    _speedTargetLevel = target.clamp(0.0, 1.0).toDouble();
    speedLevelTransitionController.duration = duration;
    speedLevelTransitionController.forward(from: 0);
  }

  void _animateFanToCycleBoundary() {
    if (!mounted ||
        !widget.connected ||
        widget.kind != JexAnimatedIconKind.fan ||
        !widget.active) {
      return;
    }
    final cycleMs = jexIconAnimationDuration(
      JexAnimatedIconKind.fan,
      voltageLevel: widget.voltageLevel,
      fanSpeedLevel: widget.level,
    ).inMilliseconds;
    final remaining = (1.0 - controller.value).clamp(0.0, 1.0).toDouble();
    final durationMs = (cycleMs * remaining).round().clamp(16, cycleMs).toInt();
    unawaited(_finishFanCycleBoundary(durationMs));
  }

  Future<void> _finishFanCycleBoundary(int durationMs) async {
    try {
      await controller.animateTo(
        1.0,
        duration: Duration(milliseconds: durationMs),
        curve: Curves.linear,
      ).orCancel;
      if (mounted && widget.connected && widget.kind == JexAnimatedIconKind.fan && widget.active) {
        controller.repeat();
      }
    } on TickerCanceled {
      // A newer voltage/PWM, connection or ON/OFF transition superseded this travel.
    }
  }

  Future<void> _coastFanToStop() async {
    if (!mounted ||
        !widget.connected ||
        widget.kind != JexAnimatedIconKind.fan ||
        widget.active) {
      return;
    }
    final cycleMs = jexIconAnimationDuration(
      JexAnimatedIconKind.fan,
      voltageLevel: widget.voltageLevel,
      fanSpeedLevel: widget.level,
    ).inMilliseconds;
    const coastCycles = .16;
    final remaining = (1.0 - controller.value).clamp(0.0, 1.0).toDouble();
    final travel = math.min(coastCycles, remaining);
    if (travel <= 0) {
      controller.stop();
      _fanCoasting = false;
      return;
    }
    _fanCoasting = true;
    final durationMs = (cycleMs * travel * 3).round().clamp(60, cycleMs * 3).toInt();
    final target = (controller.value + travel).clamp(0.0, 1.0).toDouble();
    try {
      await controller.animateTo(
        target,
        duration: Duration(milliseconds: durationMs),
        curve: Curves.easeOutCubic,
      ).orCancel;
    } on TickerCanceled {
      // A newer Fan ON/OFF or connection transition superseded the coast-down.
    } finally {
      _fanCoasting = false;
      if (mounted && !widget.active) {
        controller.stop();
        activityTransitionController.stop();
        activityTransitionController.value = 0;
        if (!widget.connected) controller.value = 0;
      }
    }
  }

  Future<void> _animateActivityTransition(bool active) async {
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
        !widget.connected ||
        !widget.active ||
        widget.kind == JexAnimatedIconKind.generic ||
        widget.kind == JexAnimatedIconKind.bluetooth ||
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
          )) {
        controller.repeat();
      }
    } on TickerCanceled {
      // A newer activation or disconnect superseded this phase travel.
    }
  }

  void _stopAnimationsForDisconnect() {
    _fanCoasting = false;
    controller.stop();
    activityTransitionController.stop();
    frostTransitionController.stop();
    speedLevelTransitionController.stop();
    indicatorLevelTransitionController.stop();
    controller.value = 0;
    activityTransitionController.value = 0;
    frostTransitionController.value = 0;
    _speedFromLevel = 0;
    _speedTargetLevel = 0;
    speedLevelTransitionController.value = 1;
    _indicatorLevelFrom = widget.level.clamp(0.0, 1.0).toDouble();
    _indicatorLevelTarget = _indicatorLevelFrom;
    indicatorLevelTransitionController.value = 1;
  }

  void _syncAnimation() {
    final animationPermitted = jexIconAnimationPermitted(
      connected: widget.connected,
      kind: widget.kind,
      stateActive: widget.active,
    );
    if (!animationPermitted) {
      if (widget.kind == JexAnimatedIconKind.fan &&
          _fanCoasting &&
          widget.connected) {
        return;
      }
      controller.stop();
      if (widget.kind != JexAnimatedIconKind.fan || !widget.connected) {
        controller.value = 0;
      }
      activityTransitionController.stop();
      activityTransitionController.value = 0;
      return;
    }
    if (!controller.isAnimating) {
      if (widget.kind == JexAnimatedIconKind.fan) {
        _animateFanToCycleBoundary();
      } else {
        _resumeCycleWithoutPhaseSnap();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: jexIconAnimationDuration(
        widget.kind,
        voltageLevel: widget.voltageLevel,
        fanSpeedLevel: widget.level,
      ),
    );
    activityTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
      value: widget.active ? 1 : 0,
    );
    _frostFromIntensity = jexPeltierFrostIntensity(widget.voltageLevel);
    _frostFromParticleCount = jexPeltierFrostParticleCount(widget.voltageLevel).toDouble();
    frostTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..value = widget.kind == JexAnimatedIconKind.peltier ? 0 : 1;
    if (widget.kind == JexAnimatedIconKind.peltier && widget.active) {
      frostTransitionController.forward(from: 0);
    }
    final initialSpeedLevel = widget.kind == JexAnimatedIconKind.speed && widget.active
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
    speedLevelTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..value = 1;
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant JexAnimatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.connected) {
      _stopAnimationsForDisconnect();
      return;
    }
    if (widget.active != oldWidget.active) {
      if (widget.active) {
        unawaited(_animateActivityTransition(true));
      } else {
        // OFF icons become static immediately; only connected Fan has a one-shot coast.
        activityTransitionController.stop();
        activityTransitionController.value = 0;
      }
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
    final fanVoltageChanged = widget.kind == JexAnimatedIconKind.fan && voltageChanged;
    final fanSpeedChanged = widget.kind == JexAnimatedIconKind.fan &&
        widget.level != oldWidget.level;
    final peltierVisualChanged = widget.kind == JexAnimatedIconKind.peltier &&
        (voltageChanged || widget.active != oldWidget.active);
    final speedVisualChanged = widget.kind == JexAnimatedIconKind.speed &&
        (oldWidget.kind != JexAnimatedIconKind.speed ||
            widget.active != oldWidget.active ||
            (widget.active && widget.level != oldWidget.level));

    if (speedVisualChanged) {
      _retargetSpeedLevel(
        widget.active ? widget.level : 0.0,
        duration: widget.active
            ? const Duration(milliseconds: 420)
            : const Duration(milliseconds: 520),
      );
    } else if (oldWidget.kind == JexAnimatedIconKind.speed &&
        widget.kind != JexAnimatedIconKind.speed) {
      speedLevelTransitionController.stop();
    }

    if (widget.kind != oldWidget.kind || fanVoltageChanged || fanSpeedChanged) {
      controller.duration = jexIconAnimationDuration(
        widget.kind,
        voltageLevel: widget.voltageLevel,
        fanSpeedLevel: widget.level,
      );
      if (widget.kind != oldWidget.kind) {
        controller.reset();
      } else if ((fanVoltageChanged || fanSpeedChanged) && widget.active) {
        // Travel to an equivalent full-turn boundary at the new voltage/PWM speed.
        _animateFanToCycleBoundary();
      }
    }

    if (peltierVisualChanged) {
      // Retarget from the currently displayed frost state on voltage or ON/OFF changes.
      // If another change arrives mid-transition, continue from the interpolated value.
      final previousT = Curves.easeInOutCubic.transform(frostTransitionController.value);
      final previousIntensity = jexPeltierFrostIntensity(oldWidget.voltageLevel);
      final previousCount = jexPeltierFrostParticleCount(oldWidget.voltageLevel).toDouble();
      _frostFromIntensity += (previousIntensity - _frostFromIntensity) * previousT;
      _frostFromParticleCount += (previousCount - _frostFromParticleCount) * previousT;
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

    if (widget.active != oldWidget.active &&
        widget.kind == JexAnimatedIconKind.fan) {
      if (oldWidget.active && !widget.active) {
        unawaited(_coastFanToStop());
      } else if (!oldWidget.active && widget.active) {
        if (!fanVoltageChanged && !fanSpeedChanged) _animateFanToCycleBoundary();
      }
    }
    _syncAnimation();
  }

  @override
  void dispose() {
    controller.dispose();
    activityTransitionController.dispose();
    frostTransitionController.dispose();
    speedLevelTransitionController.dispose();
    indicatorLevelTransitionController.dispose();
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

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge(
          <Listenable>[
            controller,
            activityTransitionController,
            frostTransitionController,
            speedLevelTransitionController,
            indicatorLevelTransitionController,
          ],
        ),
        builder: (_, __) {
          final frostT = Curves.easeInOutCubic.transform(frostTransitionController.value);
          final frostTargetIntensity = jexPeltierFrostIntensity(widget.voltageLevel);
          final frostTargetCount =
              jexPeltierFrostParticleCount(widget.voltageLevel).toDouble();
          final frostIntensity = _frostFromIntensity +
              (frostTargetIntensity - _frostFromIntensity) * frostT;
          final frostParticleCount = _frostFromParticleCount +
              (frostTargetCount - _frostFromParticleCount) * frostT;
          final displayedLevel = widget.kind == JexAnimatedIconKind.speed
              ? _currentSpeedLevel()
              : _currentIndicatorLevel();
          return CustomPaint(
            size: Size.square(widget.size),
            painter: _JexIconPainter(
              kind: widget.kind,
              color: widget.color,
              progress: controller.value,
              active: widget.active,
              activity: activityTransitionController.value,
              level: displayedLevel,
              voltageLevel: widget.voltageLevel,
              frostIntensityOverride: frostIntensity,
              frostParticleCountOverride: frostParticleCount,
              warning: widget.warning,
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
  final bool warning;

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
    required this.warning,
  });

  Paint _stroke(double width, Color paintColor) => Paint()
    ..color = paintColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Paint _fill(Color paintColor) => Paint()
    ..color = paintColor
    ..style = PaintingStyle.fill;

  Path _batterySilhouette(double s) => Path()
    ..addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(s * .12, s * .26, s * .70, s * .48),
      Radius.circular(s * .085),
    ))
    ..addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(s * .82, s * .405, s * .075, s * .19),
      Radius.circular(s * .025),
    ));

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

  void _drawAdaptiveArrowHead(Canvas canvas, Offset tip, double direction, double length, Color color) {
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
  void _drawAdaptiveFlow(Canvas canvas, double s, double phase, Color color, double strength) {
    final center = Offset(s / 2, s / 2);
    final radius = s * .29;
    final orbit = Rect.fromCircle(center: center, radius: radius);
    final wave = (math.sin(phase * 2) + 1) / 2;
    canvas.drawCircle(center, radius, _stroke(s * .035, color.withValues(alpha: .22)));
    for (var i = 0; i < 2; i++) {
      final start = phase + i * math.pi;
      const sweep = 2.28;
      final tint = color.withValues(
        alpha: .76 + .18 * math.sin(phase + i * math.pi).abs(),
      );
      canvas.drawArc(orbit, start, sweep, false, _stroke(s * .065, tint));
      final end = start + sweep;
      final tip = Offset(center.dx + math.cos(end) * radius,
          center.dy + math.sin(end) * radius);
      _drawAdaptiveArrowHead(canvas, tip, end + math.pi / 2,
          s * (.105 + .018 * wave), tint);
    }
  }

  Path _crystalSilhouette(double s) {
    final cx = s / 2;
    final cy = s / 2;
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final a = -math.pi / 2 + i * math.pi / 3;
      final outer = Offset(cx + math.cos(a) * s * .34, cy + math.sin(a) * s * .34);
      final branchA = Offset(cx + math.cos(a - .24) * s * .22, cy + math.sin(a - .24) * s * .22);
      final branchB = Offset(cx + math.cos(a + .24) * s * .22, cy + math.sin(a + .24) * s * .22);
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
      Offset(cx + x * math.cos(angle) - y * math.sin(angle),
          cy + x * math.sin(angle) + y * math.cos(angle));

  Path _fanSilhouette(double s, double angle) {
    final cx = s / 2;
    final cy = s / 2;
    final path = Path();
    for (var i = 0; i < 3; i++) {
      final a = angle + i * math.pi * 2 / 3;
      final p0 = _fanPoint(-s * .025, s * .03, a, cx, cy);
      final p1 = _fanPoint(-s * .12, -s * .06, a, cx, cy);
      final p2 = _fanPoint(-s * .235, -s * .24, a, cx, cy);
      final p3 = _fanPoint(-s * .12, -s * .365, a, cx, cy);
      final p4 = _fanPoint(-s * .025, -s * .43, a, cx, cy);
      final p5 = _fanPoint(s * .095, -s * .395, a, cx, cy);
      final p6 = _fanPoint(s * .105, -s * .285, a, cx, cy);
      final p7 = _fanPoint(s * .09, -s * .16, a, cx, cy);
      final p8 = _fanPoint(s * .035, -s * .025, a, cx, cy);
      path
        ..moveTo(p0.dx, p0.dy)
        ..cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy)
        ..cubicTo(p4.dx, p4.dy, p5.dx, p5.dy, p6.dx, p6.dy)
        ..cubicTo(p7.dx, p7.dy, p8.dx, p8.dy, p0.dx, p0.dy)
        ..close();
    }
    path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: s * .078));
    return path;
  }

  Path _flameTonguePath(
    double centerX,
    double baseline,
    double height,
    double halfWidth,
  ) {
    final tipY = baseline - height;
    return Path()
      ..moveTo(centerX - halfWidth, baseline)
      ..cubicTo(
        centerX - halfWidth * 1.05,
        baseline - height * .24,
        centerX - halfWidth * .24,
        tipY + height * .24,
        centerX,
        tipY,
      )
      ..cubicTo(
        centerX + halfWidth * .22,
        tipY + height * .25,
        centerX + halfWidth * 1.05,
        baseline - height * .24,
        centerX + halfWidth,
        baseline,
      )
      ..close();
  }

  void _drawThermalFlames(
    Canvas canvas,
    double s,
    double phase,
    Color hotColor,
    double intensity,
  ) {
    final strength = intensity.clamp(0.0, 1.0).toDouble();
    if (strength <= 0) return;

    const flameLanes = <double>[-.27, -.145, -.02, .115, .25];
    final baseline = s * .92;
    for (var i = 0; i < flameLanes.length; i++) {
      final flicker = (.5 + .5 * math.sin(phase + i * 1.31)) *
          (.82 + .18 * math.sin(phase * 2 + i * .77).abs());
      final height = s * (.25 + .22 * flicker) * strength;
      final width = s * (.052 + (i % 3) * .008) * strength;
      final x = s * (.5 + flameLanes[i]);

      final outer = _flameTonguePath(x, baseline, height, width);
      final middle = _flameTonguePath(
        x,
        baseline,
        height * .72,
        width * .59,
      );
      final core = _flameTonguePath(
        x,
        baseline,
        height * .43,
        width * .29,
      );
      final outerColor = Color.lerp(
        hotColor,
        const Color(0xFFFF641E),
        flicker,
      )!;
      canvas.drawPath(
        outer,
        _fill(outerColor.withValues(alpha: .92 * strength)),
      );
      canvas.drawPath(
        middle,
        _fill(const Color(0xFFFF8A24).withValues(alpha: .96 * strength)),
      );
      canvas.drawPath(
        core,
        _fill(const Color(0xFFFFE18A).withValues(alpha: .88 * strength)),
      );
    }
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
          final branchEnd = branchBase +
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
    final count = particleCount.round().clamp(3, 7).toInt();
    final cx = s / 2;
    final strength = intensity.clamp(0.0, 1.0).toDouble();
    final cycle = moving ? (phase / (math.pi * 2)) % 1.0 : 0.0;
    const lanes = <double>[-.31, -.20, -.08, .08, .20, .31, 0.0];

    // Snowflakes enter above the clipped canvas and leave below it. The loop
    // therefore wraps off-screen rather than jumping between visible positions.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, s, s));
    for (var i = 0; i < count; i++) {
      final seed = i * 2.399963229728653;
      final fall = moving
          ? (cycle + i / count) % 1.0
          : .16 + (i / count) * .66;
      final x = cx +
          s * lanes[i % lanes.length] +
          (moving ? math.sin(phase + seed) * s * .026 : 0.0);
      final y = s * (-.12 + fall * 1.24);
      final radius = s * (.050 + .008 * strength) *
          (.82 + .08 * (i % 3));
      final rotation = moving
          ? phase * (i.isEven ? 1.0 : -1.0) + seed
          : seed * .25;
      final alpha = (.52 + .42 * strength) *
          (.88 + .12 * ((i % 3) / 2));
      final snowColor = i % 4 == 0 ? Colors.white : frostColor;
      _drawSnowflake(
        canvas,
        Offset(x, y),
        radius,
        rotation,
        snowColor,
        alpha,
      );
    }
    canvas.restore();
  }

  void _drawFanAirflow(
    Canvas canvas,
    double s,
    double phase,
    Color airColor,
    int voltageClass,
    double pwmLevel,
  ) {
    final voltagePower = switch (voltageClass) {
      9 => .50,
      12 => 1.0,
      _ => .25,
    };
    final pwmFactor = voltageClass == 12
        ? pwmLevel.clamp(0.0, 1.0).toDouble()
        : 1.0;
    final airflowPower = voltagePower * pwmFactor;
    if (airflowPower <= 0) return;

    final streakCount = (airflowPower * 3).ceil().clamp(1, 3).toInt();
    final center = Offset(s / 2, s / 2);
    Offset point(double angle, double radius) => Offset(
          center.dx + math.cos(angle) * radius,
          center.dy + math.sin(angle) * radius,
        );

    // These streamlines orbit inside the rotor footprint and are painted first,
    // so the fan blades naturally remain in front of the moving air.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(s * .10, s * .10, s * .80, s * .80));
    for (var i = 0; i < streakCount; i++) {
      final radius = s * (.27 + i * .045);
      final startAngle = phase + i * (math.pi * 2 / streakCount);
      final sweep = 1.20 + .18 * airflowPower;
      final endAngle = startAngle + sweep;
      final start = point(startAngle, radius);
      final end = point(endAngle, radius);
      final tangentScale = radius * sweep * .38;
      final control1 = start +
          Offset(-math.sin(startAngle), math.cos(startAngle)) * tangentScale;
      final control2 = end -
          Offset(-math.sin(endAngle), math.cos(endAngle)) * tangentScale;
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
        _stroke(
          s * (.042 + .018 * airflowPower),
          airColor.withValues(alpha: .20 + .22 * airflowPower),
        ),
      );
      canvas.drawPath(
        path,
        _stroke(
          s * (.014 + .009 * airflowPower),
          airColor.withValues(alpha: .48 + .34 * airflowPower),
        ),
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
    final pulse = math.sin(angle);
    final safeLevel = level.clamp(0.0, 1.0).toDouble();
    final warningBlend = warning && active ? (.12 + .06 * (pulse + 1) / 2) : 0.0;
    final mainColor = Color.lerp(color, const Color(0xFFFF5B55), warningBlend)!;
    // The semantic glyph colour and opacity never depend on ON/OFF state.
    const opacity = 1.0;
    final breath = active ? 1.0 + .014 * pulse * strength : 1.0;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(breath);
    canvas.translate(-cx, -cy);

    switch (kind) {
      case JexAnimatedIconKind.battery:
        final shell = _batterySilhouette(s);
        canvas.drawPath(shell, _fill(mainColor.withValues(alpha: .10)));
        canvas.drawPath(shell, _stroke(s * .045, mainColor.withValues(alpha: opacity)));
        final inner = RRect.fromRectAndRadius(
          Rect.fromLTWH(s * .17, s * .31, s * .60, s * .38),
          Radius.circular(s * .055),
        );
        canvas.save();
        canvas.clipRRect(inner);
        final fluidHeight = inner.height * safeLevel;
        if (fluidHeight > 0) {
          canvas.drawRect(
            Rect.fromLTWH(inner.left, inner.bottom - fluidHeight, inner.width, fluidHeight),
            _fill(mainColor.withValues(alpha: .86)),
          );
          final sheenWidth = inner.width * .18;
          final sheenRect = Rect.fromLTWH(
            inner.left + (inner.width - sheenWidth) * p,
            inner.bottom - fluidHeight,
            sheenWidth,
            fluidHeight,
          );
          canvas.drawRect(
            sheenRect,
            Paint()
              ..shader = LinearGradient(
                colors: <Color>[
                  Colors.transparent,
                  mainColor.withValues(alpha: .36),
                  Colors.transparent,
                ],
              ).createShader(sheenRect),
          );
        } else {
          final idleGlintX = inner.left + inner.width * p;
          canvas.drawLine(
            Offset(idleGlintX, inner.top + s * .035),
            Offset(idleGlintX, inner.bottom - s * .035),
            _stroke(s * .018, mainColor.withValues(alpha: .30 + .12 * (pulse + 1) / 2)),
          );
        }
        canvas.restore();
        if (warning && active) {
          _drawThermalFlames(canvas, s, angle, jexThermalRed, 1.0);
        }
        break;

      case JexAnimatedIconKind.hotside:
        final shell = _hotsideSilhouette(s);
        canvas.drawPath(shell, _fill(mainColor.withValues(alpha: .10)));
        canvas.drawPath(shell, _stroke(s * .045, mainColor.withValues(alpha: opacity)));
        final tubeInner = RRect.fromRectAndRadius(
          Rect.fromLTWH(s * .455, s * .17, s * .09, s * .45),
          Radius.circular(s * .045),
        );
        canvas.save();
        canvas.clipPath(shell);
        canvas.save();
        canvas.clipRRect(tubeInner);
        final fluidHeight = tubeInner.height * safeLevel;
        if (fluidHeight > 0) {
          canvas.drawRect(
            Rect.fromLTWH(tubeInner.left, tubeInner.bottom - fluidHeight, tubeInner.width, fluidHeight),
            _fill(mainColor.withValues(alpha: .90)),
          );
          final sheenRect = Rect.fromLTWH(
            tubeInner.left + tubeInner.width * .18,
            tubeInner.bottom - fluidHeight,
            tubeInner.width * .34,
            fluidHeight,
          );
          canvas.drawRect(sheenRect, _fill(Colors.white.withValues(alpha: .28)));
        }
        canvas.restore();
        final bulbRadius = s * (.035 + .048 * safeLevel);
        canvas.drawCircle(
          Offset(cx, s * .775), bulbRadius,
          _fill(mainColor.withValues(alpha: .72 + .12 * (pulse + 1) / 2)),
        );
        canvas.drawCircle(
          Offset(cx - s * .018, s * .758),
          s * .021,
          _fill(Colors.white.withValues(alpha: .40)),
        );
        canvas.restore();
        if (warning && active) {
          _drawThermalFlames(canvas, s, angle, jexThermalRed, 1.0);
        }
        break;

      case JexAnimatedIconKind.voltage:
        final bolt = _bolt(s);
        canvas.drawPath(
          bolt,
          _fill(mainColor.withValues(alpha: .58 + .36 * safeLevel)),
        );
        canvas.drawPath(
          bolt,
          _stroke(s * .018, mainColor.withValues(alpha: opacity)),
        );
        if (active) {
          final electricalSpine = Path()
            ..moveTo(s * .535, s * .135)
            ..lineTo(s * .425, s * .445)
            ..lineTo(s * .515, s * .445)
            ..lineTo(s * .455, s * .695)
            ..lineTo(s * .645, s * .405)
            ..lineTo(s * .535, s * .405)
            ..lineTo(s * .595, s * .255);

          canvas.save();
          canvas.clipPath(bolt);
          canvas.drawPath(
            electricalSpine,
            _stroke(
              s * .054,
              Colors.white.withValues(alpha: .12 + .14 * safeLevel),
            ),
          );
          final metric = electricalSpine.computeMetrics().first;
          final segmentLength = metric.length * (.22 + .06 * safeLevel);
          final head = (p * metric.length) % metric.length;
          final tail = head - segmentLength;
          final currentPaint = _stroke(
            s * (.026 + .012 * safeLevel),
            Colors.white.withValues(
              alpha: .66 + .26 * (math.sin(angle) + 1) / 2,
            ),
          );
          final corePaint = _stroke(
            s * .012,
            mainColor.withValues(alpha: .94),
          );
          if (tail < 0) {
            final endSegment = metric.extractPath(
              metric.length + tail,
              metric.length,
            );
            final startSegment = metric.extractPath(0, head);
            canvas.drawPath(endSegment, currentPaint);
            canvas.drawPath(startSegment, currentPaint);
            canvas.drawPath(endSegment, corePaint);
            canvas.drawPath(startSegment, corePaint);
          } else {
            final segment = metric.extractPath(tail, head);
            canvas.drawPath(segment, currentPaint);
            canvas.drawPath(segment, corePaint);
          }
          canvas.restore();
        }
        break;

      case JexAnimatedIconKind.adaptive:
        _drawAdaptiveFlow(canvas, s, active ? angle : 0.0, mainColor, strength);
        break;

      case JexAnimatedIconKind.peltier:
        final crystal = _crystalSilhouette(s);
        final frostPower =
            (frostIntensityOverride ?? .5).clamp(0.0, 1.0).toDouble();
        final crystalWidth = s * (.042 + .006 * frostPower);
        final frostAngle = active ? angle : 0.0;

        _drawFrostParticles(
          canvas,
          s,
          frostAngle,
          mainColor,
          intensity: frostPower,
          particleCount: frostParticleCountOverride ?? 3,
          moving: active,
        );

        canvas.save();
        if (active) {
          canvas.translate(cx, cy);
          canvas.rotate(frostAngle);
          canvas.translate(-cx, -cy);
        }
        canvas.drawPath(
          crystal,
          _stroke(crystalWidth, mainColor.withValues(alpha: opacity)),
        );
        for (var i = 0; i < 6; i++) {
          final a = -math.pi / 2 + i * math.pi / 3;
          final branchPulse = (math.sin(frostAngle * 2 - i * math.pi / 3) + 1) / 2;
          final outer = Offset(cx + math.cos(a) * s * .34, cy + math.sin(a) * s * .34);
          final inner = Offset(cx + math.cos(a) * s * .13, cy + math.sin(a) * s * .13);
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
        canvas.restore();
        break;

      case JexAnimatedIconKind.fan:
        if (active) {
          _drawFanAirflow(canvas, s, angle, mainColor, voltageLevel, safeLevel);
        }
        final rotor = _fanSilhouette(s, angle);
        canvas.drawPath(rotor, _fill(mainColor.withValues(alpha: .96)));
        canvas.drawPath(rotor, _stroke(s * .012, mainColor.withValues(alpha: .88)));
        break;

      case JexAnimatedIconKind.speed:
        final gauge = Rect.fromCircle(center: Offset(cx, cy), radius: s * .34);
        const start = math.pi * .79;
        const sweep = math.pi * 1.42;
        canvas.drawArc(
          gauge,
          start,
          sweep,
          false,
          _stroke(s * .045, mainColor.withValues(alpha: .62)),
        );
        const tickCount = 9;
        for (var i = 0; i < tickCount; i++) {
          final t = i / (tickCount - 1);
          final tickAngle = start + sweep * t;
          final inner = Offset(
            cx + math.cos(tickAngle) * s * .285,
            cy + math.sin(tickAngle) * s * .285,
          );
          final outer = Offset(
            cx + math.cos(tickAngle) * s * .325,
            cy + math.sin(tickAngle) * s * .325,
          );
          canvas.drawLine(
            inner,
            outer,
            _stroke(s * .018, mainColor.withValues(alpha: .60 + .30 * (t <= safeLevel ? 1 : 0))),
          );
        }
        if (active && safeLevel > 0) {
          canvas.drawArc(
            gauge,
            start,
            sweep * safeLevel,
            false,
            _stroke(s * .052, mainColor.withValues(alpha: .92)),
          );
        }
        final needleAngle = start + sweep * safeLevel;
        final tip = Offset(
          cx + math.cos(needleAngle) * s * .265,
          cy + math.sin(needleAngle) * s * .265,
        );
        final needle = Path()..moveTo(cx, cy)..lineTo(tip.dx, tip.dy);
        canvas.drawPath(
          needle,
          _stroke(s * .055, mainColor.withValues(alpha: opacity)),
        );
        canvas.drawCircle(
          Offset(cx, cy),
          s * .045,
          _fill(mainColor.withValues(alpha: opacity)),
        );
        break;

      case JexAnimatedIconKind.led:
        final ledAngle = active ? angle : 0.0;
        final wave = Path();
        for (var i = 0; i <= 24; i++) {
          final x = s * (.12 + .76 * i / 24);
          final y = cy + math.sin(ledAngle - i * math.pi / 8) * s * (.10 + .045 * strength);
          if (i == 0) wave.moveTo(x, y); else wave.lineTo(x, y);
        }
        canvas.drawPath(wave, _stroke(s * .058, mainColor.withValues(alpha: opacity)));
        final dotX = s * (.12 + .76 * (active ? p : 0.0));
        final dotY = cy + math.sin(ledAngle - ((dotX / s - .12) / .76) * math.pi * 3) *
            s * (.10 + .045 * strength);
        canvas.drawCircle(Offset(dotX, dotY), s * .045,
            _fill(mainColor.withValues(alpha: .82 + .14 * strength)));
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
        canvas.drawPath(glyph, _stroke(s * .06, mainColor.withValues(alpha: 1.0)));
        break;

      case JexAnimatedIconKind.generic:
        break;
    }

    canvas.restore();
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
      oldDelegate.warning != warning ||
      oldDelegate.frostIntensityOverride != frostIntensityOverride ||
      oldDelegate.frostParticleCountOverride != frostParticleCountOverride;
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

bool isUserVisibleResetReason(String value) {
  final normalized = value.trim().toUpperCase();
  return normalized.isNotEmpty &&
      normalized != 'POWERON' &&
      normalized != 'POWER_ON' &&
      normalized != 'UNKNOWN' &&
      normalized != 'UNAVAILABLE_CORE_3_3_7';
}

bool isNotifyErrorMessage(String value) {
  final normalized = value.trim().toUpperCase();
  if (normalized.isEmpty) return false;
  const markers = <String>[
    'FAILED',
    'ERROR',
    'NOT FOUND',
    'DISCONNECTED',
    'SERVICE DISCOVERY',
    'GAGAL',
    'KESALAHAN',
    'TIDAK DITEMUKAN',
    'TERPUTUS',
  ];
  return markers.any(normalized.contains);
}

// AI-THEME: lightThemeAccentText — Generate a darker semantic accent for text on bright surfaces.
Color lightThemeAccentText(Color color) {
  final hsl = HSLColor.fromColor(color);
  final lightness = hsl.lightness.clamp(0.22, 0.48).toDouble();
  final saturation = hsl.saturation.clamp(0.58, 1.0).toDouble();
  return hsl.withLightness(lightness).withSaturation(saturation).toColor();
}

// AI-METHOD: isTransientOtaResultEvent — Accept only fresh OTA success/failure envelopes for Home NOTIFY.
bool isTransientOtaResultEvent(String value) {
  final upper = value.trim().toUpperCase();
  return upper.startsWith('OTA_SUCCESS|') ||
      upper.startsWith('OTA_FAILED|') ||
      upper.startsWith('OTA_UP_TO_DATE|');
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

  Future<void> _contactDeveloper() async {
    try {
      await securityChannel.invokeMethod<bool>('openDeveloperContact');
    } catch (error) {
      // Keep the screen intentionally opaque if the external launch cannot be completed.
      debugPrint('Developer contact launch failed: $error');
    }
  }

  Widget _insult(
    String text, {
    Color color = Colors.white,
    double size = 14,
    FontWeight weight = FontWeight.w800,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF101014),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF30252A), width: 1),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          softWrap: true,
          style: TextStyle(
            color: color,
            fontSize: size,
            height: 1.18,
            fontWeight: weight,
            letterSpacing: 0.18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF09090B);
    const hotRed = Color(0xFFFF4654);
    final compact = MediaQuery.sizeOf(context).width < 370;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight > 18
                          ? constraints.maxHeight - 18
                          : 0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 4),
                        Center(
                          child: Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: const Color(0x223A0B10),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0x8870232A)),
                            ),
                            child: Icon(
                              PhosphorIconsBold.warning,
                              color: hotRed,
                              size: 32,
                            ),
                          ),
                        ),
                        const Text(
                          headerName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        _insult(
                          'WOI, KONTOL!!!',
                          color: hotRed,
                          size: compact ? 24 : 27,
                        ),
                        _insult(
                          'ANJING! BANGSAT! BAJINGAN! BRENGSEK! KEPARAT! KAMPRET! JANCOK! ASU!',
                          color: Colors.white,
                          size: compact ? 13 : 15,
                        ),
                        _insult(
                          'KONTOL! MEMEK! BABI! MONYET! GOBLOK! TOLOL! BEGO! DONGO! SINTING! TAI!',
                          color: hotRed,
                          size: compact ? 14 : 16,
                        ),
                        _insult(
                          'MUKA LO KAYA TAI, KELAKUAN KAYA MONYET! BACOT LO GEDE BANGET, OTAK LO DI MANA, HAH?!',
                          size: compact ? 13 : 15,
                        ),
                        _insult(
                          'DASAR BABI GOBLOK! TOLOL MAKSIMAL! BEGO KEBANGETAN! BANGSAT NGGAK KETULUNGAN! SOK JAGO, SOK KERAS, SOK PALING PINTER!',
                          color: const Color(0xFFFF737D),
                          size: compact ? 13 : 15,
                        ),
                        _insult(
                          'ANJING LO! KONTOL LO! MEMEK LO! MONYET LO! BABI LO! BRENGSEK! KAMPRET! BAJINGAN!',
                          size: compact ? 14 : 16,
                        ),
                        _insult(
                          'NGACA DULU, WOI! BACOT KAYA DEWA, OTAK KAYA KOSONG! DASAR KEPARAT! TAI! JANCOK! ASU!',
                          color: hotRed,
                          size: compact ? 13 : 15,
                        ),
                        _insult(
                          'WOI, BAJINGAN! BANGSAT! SETAN KEPARAT! DONGO! GOBLOK! TOLOL! BEGO! KELEWAT BEGO!',
                          size: compact ? 13 : 15,
                        ),
                        _insult(
                          'ANJING! KONTOL! MEMEK! TAI! BABI! MONYET! KAMPRET! BRENGSEK! KEPARAT! JANCOK! ASU!',
                          color: const Color(0xFFFF737D),
                          size: compact ? 14 : 16,
                        ),
                        _insult(
                          'SOK JAGO BANGET, PADAHAL BEGO KEBANGETAN! DASAR BANGSAT, OTAK KOSONG, BACOT DOANG!',
                          size: compact ? 13 : 15,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _contactDeveloper,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFB42332),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.35,
                    ),
                  ),
                  child: const Text('HUBUNGI DEVELOPER'),
                ),
              ),
            ),
          ],
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
  bool hotAlertArmed = true;

  bool _bleReady = false;
  bool _bleSessionReady = false;
  bool protocolValid = false;
  bool _syncReadyAck = false;
  bool connected = false;
  bool runtimeOutputsKnown = false;
  bool syncing = false;
  bool fullSyncReceived = false;
  bool voltageGuardActive = false;
  bool adaptiveTransitioning = false;
  bool batteryReadBusy = false;
  bool dashboardReady = false;
  bool _bleConnecting = false;
  bool otaExpectedDisconnect = false;
  bool otaRecoveryActive = false;
  bool otaRecoveryScanInProgress = false;
  final Map<String, List<Completer<String>>> _ackWaiters = {};
  final Map<String, String> _syncSnapshot = {};
  String _lastCommandAckReason = '';
  String _lastPeltierAckFailureReason = '';
  Future<void> _commandTransactionQueue = Future<void>.value();
  String? _pendingPhoneBatteryCommand;
  bool _phoneBatteryHeartbeatQueued = false;
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
  String adaptiveProfile = 'HOTSIDE';
  bool rgbOn = false;
  int rgbMode = 1;
  int brightness = 100;
  String rgbColor = '#FFFFFF';
  int ledPhaseMs = 0;
  int ledCycleMs = 1000;
  int ledSyncRevision = 0;
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


  @override  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appAutoConnectNotifier.addListener(_handleAutoConnectPreferenceChanged);
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
    } else if (!connected && !otaRecoveryActive && !otaExpectedDisconnect) {
      _startDisconnectRediscovery();
    } else {
      unawaited(_tryAutoConnect());
    }
  }

  // AI-METHOD / AUTO-CONNECT-PREFERENCE-CONTRACT
  // Enabling Auto Connect reevaluates the passive prerequisites immediately. Disabling it
  // cancels pending automatic reconnect work. This callback never requests permissions or
  // changes Bluetooth power state.
  void _handleAutoConnectPreferenceChanged() {
    if (appAutoConnectNotifier.value) {
      if (!connected && !otaRecoveryActive && !otaExpectedDisconnect) {
        _startDisconnectRediscovery();
      } else {
        unawaited(_tryAutoConnect());
      }
    } else if (!otaRecoveryActive && !otaExpectedDisconnect) {
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
      // Publish the current authoritative telemetry for the six-metric Floating Monitor.
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
        enabled
            ? <String, dynamic>{'language': appLanguageNotifier.value.name}
            : null,
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
  Future<void> _scanAndConnect({
    bool automatic = false,
    bool otaRecovery = false,
  }) async {
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
        autoConnectEnabled: otaRecovery || appAutoConnectNotifier.value,
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
    protocolValid = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    _lastPeltierAckFailureReason = '';
    incomingBuffer = '';
    _syncSnapshot.clear();
    _pendingTelemetry.clear();

    if (mounted) {
      setState(() {
        syncing = true;
        connected = false;
        runtimeOutputsKnown = false;
        dashboardReady = false;
        voltage = '--';
        hotsideTemp = '--';
        phoneBatteryTemp = '--';
        phoneBatteryValid = false;
        fanOn = false;
        peltierOn = false;
        adaptiveOn = false;
        rgbOn = false;
        ledPhaseMs = 0;
        ledCycleMs = 1000;
        ledSyncRevision++;
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
        protocolValid = false;
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
    if (!mounted || connected || syncing || _bleConnecting) return;
    if (!appAutoConnectNotifier.value ||
        knownCoolerRemoteIdNotifier.value == null) {
      _cancelDisconnectRediscovery();
      return;
    }
    if (reconnectTimer?.isActive ?? false) return;

    _cancelDisconnectRediscovery();
    var attempts = 0;

    Future<void> scanOnce() async {
      if (!mounted ||
          connected ||
          syncing ||
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
        _cancelDisconnectRediscovery();
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
    final expectedOtaDisconnect =
        otaExpectedDisconnect || otaRecoveryActive;

    unawaited(_setBackgroundService(false));
    notificationSub?.cancel();
    notificationSub = null;
    _bleReady = false;
    _bleSessionReady = false;
    protocolValid = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    dashboardReady = false;
    _pendingTelemetry.clear();
    _lastPeltierAckFailureReason = '';
    if (!expectedOtaDisconnect) {
      pendingOtaNotice = '';
    }
    batteryTimer?.cancel();

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
      runtimeOutputsKnown = false;
      syncing = false;
      dashboardReady = false;
      voltage = '--';
      fanOn = false;
      peltierOn = false;
      adaptiveOn = false;
      rgbOn = false;
      hotsideTemp = '--';
      phoneBatteryTemp = '--';
      phoneBatteryValid = false;
      safety = 'LOCKED';
      safetyReason = 'DISCONNECTED';
      firmwareVersion = 'V?';
      resetReason = 'UNKNOWN';
      notice = expectedOtaDisconnect
          ? JexText.of('otaInProgress', appLanguageNotifier.value)
          : JexText.of('bluetoothDisconnected', appLanguageNotifier.value);
    });
    _publishFloatingTelemetry();

    // Start reconnect only after connected=false has been committed.
    if (expectedOtaDisconnect) {
      _cancelDisconnectRediscovery();
      if (!(reconnectTimer?.isActive ?? false)) {
        _startOtaReconnectMonitor();
      }
    } else {
      _startDisconnectRediscovery();
    }

    if (!expectedOtaDisconnect && appNotifyBluetoothNotifier.value) {
      unawaited(_postNotification(
        'JE X FYZ',
        JexText.of('bluetoothDisconnected', appLanguageNotifier.value),
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
    protocolValid = false;
    _syncReadyAck = false;
    fullSyncReceived = false;
    final readyAccepted = await sendCommand('SYNC_READY', showError: false);
    if (!readyAccepted) {
      throw StateError(JexText.of('bleHandshakeWriteFailed', appLanguageNotifier.value));
    }

    final readyDeadline = DateTime.now().add(const Duration(milliseconds: 3500));
    while (mounted &&
        !(_syncReadyAck &&
          fullSyncReceived &&
          _bleSessionReady &&
          protocolValid) &&
        DateTime.now().isBefore(readyDeadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }

    if (!_syncReadyAck ||
        !fullSyncReceived ||
        !_bleSessionReady ||
        !protocolValid) {
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

    final wasOtaRecovery = otaRecoveryActive || otaExpectedDisconnect;
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
      runtimeOutputsKnown = true;
      syncing = false;
      dashboardReady = true;
      notice = syncedOtaNotice.isNotEmpty
          ? syncedOtaNotice
          : JexText.of('systemReady', appLanguageNotifier.value);
    });
    _publishFloatingTelemetry();

    if (wasOtaRecovery) {
      reconnectTimer?.cancel();
      reconnectTimer = null;
      otaRecoveryActive = false;
      otaExpectedDisconnect = false;
      otaRecoveryScanInProgress = false;
      if (appNotifyBluetoothNotifier.value && syncedOtaNotice.isNotEmpty) {
        unawaited(_postNotification(
          'JE X FYZ',
          syncedOtaNotice,
          2102,
        ));
      }
    } else if (appNotifyBluetoothNotifier.value) {
      unawaited(_postNotification(
        'JE X FYZ',
        JexText.of('bluetoothConnected', appLanguageNotifier.value),
        2102,
      ));
    }
    // AI-METHOD: _startBatteryTelemetry — Start the 1 Hz phone-battery heartbeat.
    _startBatteryTelemetry();
    unawaited(_setBackgroundService(true));

    if (isUserVisibleResetReason(resetReason)) {
      _showSnackBar(
        _friendlyReset(resetReason),
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
  Future<bool> _sendAndWaitAckInternal(
    String command, {
    bool showError = true,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    _lastCommandAckReason = '';
    final item = _ackItemForCommand(command);
    if (item == 'PELTIER') {
      _lastPeltierAckFailureReason = '';
    }
    if (item == null) return sendCommand(command, showError: showError);
    final ackFuture = _waitForAck(item, timeout: timeout);
    final sent = await sendCommand(command, showError: showError);
    if (!sent) {
      _lastCommandAckReason = 'WRITE_FAILED';
      final waiters = _ackWaiters[item];
      if (waiters != null && waiters.isNotEmpty) {
        waiters.removeLast();
        if (waiters.isEmpty) _ackWaiters.remove(item);
      }
      return false;
    }
    final reason = await ackFuture;
    _lastCommandAckReason = reason;
    final accepted = _isAckSuccessReason(reason);
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

  Future<bool> _sendAndWaitAck(
    String command, {
    bool showError = true,
    Duration timeout = const Duration(seconds: 3),
  }) {
    final next = _commandTransactionQueue.then<bool>(
      (_) => _sendAndWaitAckInternal(
        command,
        showError: showError,
        timeout: timeout,
      ),
    );
    _commandTransactionQueue = next.then<void>(
      (_) {},
      onError: (_) {},
    );
    return next;
  }

  MapEntry<String, String>? _expectedTelemetryForCommand(String command) {    final c = command.trim().toUpperCase();
    if (c == 'FAN:ON') return const MapEntry('FAN', 'ON');
    if (c == 'FAN:OFF') return const MapEntry('FAN', 'OFF');
    if (c == 'PELTIER:ON') return const MapEntry('PELTIER', 'ON');
    if (c == 'PELTIER:OFF') return const MapEntry('PELTIER', 'OFF');
    if (c == 'ADAPTIVE:ON') return const MapEntry('ADAPTIVE', 'ON');
    if (c == 'ADAPTIVE:OFF') return const MapEntry('ADAPTIVE', 'OFF');
    if (c.startsWith('VOLTAGE:')) return MapEntry('VOLTAGE', c.substring(8));
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
      case 'VOLTAGE':
        return voltage.toUpperCase() == expected.toUpperCase();
      case 'RGB':
        return rgbOn == (expected == 'ON');
      case 'MODE':
        return rgbMode == (int.tryParse(expected) ?? -1);
      case 'BRIGHTNESS':
        return brightness == (int.tryParse(expected) ?? -1);
      case 'RGB_COLOR':
        return normalizeLedColor(rgbColor) == normalizeLedColor(expected);
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

    bool _isAckSuccessReason(String reason) {
    return reason == 'OK' || reason == 'ACCEPTED' || reason == 'READY' || reason == 'STARTING' || reason == 'ON' || reason == 'OFF';
  }

  String? _friendlyAckSuccess(String item, String reason) {
    if (item == 'TOUCH_COOLING') {
      return reason == 'ON'
          ? JexText.phrase('Cooling started.', 'Pendinginan dimulai.')
          : reason == 'OFF'
              ? JexText.phrase('Cooling stopped.', 'Pendinginan dihentikan.')
              : null;
    }
    if (item == 'TOUCH_ADAPTIVE' && reason == 'OFF') {
      return JexText.phrase('Adaptive Mode turned OFF.', 'Mode Adaptif dimatikan.');
    }
    return null;
  }

void _handleAckLine(String line) {
    final parts = line.substring(4).split(';');
    final item = parts.isNotEmpty ? parts[0].split('=').first.trim().toUpperCase() : '';
    final rawReason = parts.length > 1 && parts[1].startsWith('REASON=')
        ? parts[1].substring(7)
        : 'UNKNOWN';
    final reason = rawReason.trim().toUpperCase();

    final waiters = _ackWaiters[item];
    final hadWaiter = waiters != null && waiters.isNotEmpty;
    if (hadWaiter) {
      final waiter = waiters.removeAt(0);
      if (!waiter.isCompleted) waiter.complete(reason);
      if (waiters.isEmpty) _ackWaiters.remove(item);
    }

    if (item == 'SYNC_READY' && _isAckSuccessReason(reason)) {
      _syncReadyAck = true;
      return;
    }

    if (!_isAckSuccessReason(reason)) {
      if (item == 'PELTIER') {
        _lastPeltierAckFailureReason = reason;
      }
      if (!hadWaiter) {
        _showSnackBar(_friendlyReason(reason), color: Colors.orangeAccent);
      }
      return;
    }

    if (!hadWaiter) {
      final successMessage = _friendlyAckSuccess(item, reason);
      if (successMessage != null) _showSnackBar(successMessage);
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
      final protocol = values['PROTOCOL'];
      if (protocol != null) {
        protocolValid = isSupportedP1Protocol(protocol);
      }
      final otaResult = values['LAST_OTA_RESULT'];
      if (otaResult != null && isTransientOtaResultEvent(otaResult)) {
        pendingOtaNotice = _friendlyOtaResult(otaResult);
      }
      _pendingTelemetry.addAll(values);
      return;
    }

    if (!mounted) return;
    final liveCoolingTelemetryReceived =
        values.containsKey('FAN') ||
        values.containsKey('PELTIER') ||
        values.containsKey('ADAPTIVE') ||
        values.containsKey('VOLTAGE') ||
        values.containsKey('FAN_SPEED') ||
        values.containsKey('SAFETY') ||
        values.containsKey('SAFETY_REASON');

    setState(() {
      for (final entry in values.entries) {
        // AI-METHOD: _applyTelemetryValue — Map firmware telemetry keys into typed Flutter state.
        _applyTelemetryValue(entry.key, entry.value);
      }

      if (shouldClearStaleNotifyError(
        connected: connected,
        safety: safety,
        safetyReason: safetyReason,
        liveTelemetryReceived: liveCoolingTelemetryReceived,
        notice: notice,
      )) {
        notice = JexText.of('systemReady', appLanguageNotifier.value);
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
        protocolValid = isSupportedP1Protocol(value);
        break;
      case 'STATE_SEQ':
        stateSequence = int.tryParse(value) ?? stateSequence;
        break;
      case 'BLE_SESSION':
        _bleSessionReady = value == 'READY';
        break;
      case 'VOLTAGE':
        voltage = value;
        // 5V is the safe handoff milestone; wait for ADAPTIVE=ON for completion.
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
        adaptiveTransitioning = false;
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
        // V6.6+ treats LED_SYNC as the atomic owner of mode/phase/cycle.
        // Older firmware sends only MODE plus separate phase fields.
        final activeFirmware = parseFirmwareVersion(firmwareVersion);
        final atomicLedSync = activeFirmware != null &&
            (activeFirmware[0] > 6 ||
                (activeFirmware[0] == 6 && activeFirmware[1] >= 6));
        if (!atomicLedSync) {
          rgbMode = (int.tryParse(value) ?? rgbMode).clamp(1, 7).toInt();
        }
        break;
      case 'LED_SYNC':
        final snapshot = LedSyncSnapshot.parse(value);
        if (snapshot != null) {
          rgbMode = snapshot.mode;
          ledPhaseMs = snapshot.phaseMs;
          ledCycleMs = snapshot.cycleMs;
          ledSyncRevision++;
        }
        break;
      // Backward compatibility for older firmware that emitted two separate fields.
      case 'LED_PHASE':
        ledPhaseMs = math.max(0, int.tryParse(value) ?? ledPhaseMs);
        break;
      case 'LED_CYCLE_MS':
        ledCycleMs = math.max(1, int.tryParse(value) ?? ledCycleMs);
        ledPhaseMs %= ledCycleMs;
        ledSyncRevision++;
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
          if (value.trim().toUpperCase().startsWith('OTA_UP_TO_DATE|')) {
            otaExpectedDisconnect = false;
            otaRecoveryActive = false;
            otaRecoveryScanInProgress = false;
            reconnectTimer?.cancel();
            reconnectTimer = null;
          }
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
        battery5Limit = (int.tryParse(value) ?? battery5Limit).clamp(20, 30).toInt();
        battery5Draft = battery5Limit;
        break;
      case 'BATT_12':
        battery12Limit = (int.tryParse(value) ?? battery12Limit).clamp(30, 40).toInt();
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
      _readBatteryTemperatureOnce();
    });
  }

  // AI-METHOD / PHONE-BATTERY-HEARTBEAT-CONTRACT
  // Coalesce 1 Hz values so only the newest heartbeat is retained.
  void _queuePhoneBatteryHeartbeat(String command) {
    _pendingPhoneBatteryCommand = command;
    if (_phoneBatteryHeartbeatQueued) return;
    _phoneBatteryHeartbeatQueued = true;
    _writeQueue = _writeQueue.then((_) async {
      final pending = _pendingPhoneBatteryCommand;
      _pendingPhoneBatteryCommand = null;
      try {
        if (pending == null || !_bleReady || rx == null) return;
        final payload = utf8.encode('$pending\n');
        final canNoResponse = rx!.properties.writeWithoutResponse;
        await rx!.write(
          payload,
          withoutResponse: canNoResponse,
        ).timeout(const Duration(seconds: 4));
      } catch (e) {
        debugPrint('BLE heartbeat $pending: $e');
      } finally {
        _phoneBatteryHeartbeatQueued = false;
        if (_pendingPhoneBatteryCommand != null && _bleReady) {
          _queuePhoneBatteryHeartbeat(_pendingPhoneBatteryCommand!);
        }
      }
    }).catchError((_) {
      _phoneBatteryHeartbeatQueued = false;
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
        _queuePhoneBatteryHeartbeat(
          valid ? 'PHONE:BT=' + temp.toStringAsFixed(1) : 'PHONE:BT=-1.0',
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
          _showSnackBar(JexText.phrase('The device did not confirm the voltage change.','Perangkat belum mengonfirmasi perubahan tegangan.'));
        }
      }
    } catch (e) {
      debugPrint('Voltage command: $e');
      voltageGuardTimer?.cancel();
      if (mounted) {
        setState(() => voltageGuardActive = false);
        _showSnackBar(JexText.phrase('Voltage change failed.','Perintah perubahan tegangan gagal.'));
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
        _showSnackBar(JexText.phrase('The device did not confirm the Fan change.','Perangkat belum mengonfirmasi perubahan kipas.'), color: Colors.orangeAccent);
      }
    } catch (e) {
      debugPrint('Fan command: $e');
      if (mounted) _showSnackBar(JexText.phrase('Fan command failed.','Perintah kipas gagal dijalankan.'), color: Colors.orangeAccent);
    }
  }

  // AI-METHOD / PELTIER-COMMAND-CONTRACT
  // When the popup approves Peltier startup from Fan-OFF, queue FAN:ON and PELTIER:ON
  // together before awaiting either confirmation. The BLE write queue preserves ordering,
  // but there is no UI-side confirmation delay between the two commands.
  Future<void> _togglePeltier(bool enabled) async {
    if (!connected || adaptiveOn) return;
    try {
      if (enabled && !fanOn) {
        final approved = await showGeneralDialog<bool>(
          context: context,
          barrierDismissible: true,
          barrierLabel: JexText.of('peltierSafety', appLanguageNotifier.value),
          barrierColor: Colors.black.withValues(alpha: .54),
          transitionDuration: const Duration(milliseconds: 190),
          pageBuilder: (dialogContext, _, __) {
            return SafeArea(
              child: LayoutBuilder(
                builder: (dialogContext, constraints) {
                  final top = displayMenuOverlayTop(
                    screenWidth: MediaQuery.sizeOf(dialogContext).width,
                    availableHeight: constraints.maxHeight,
                  );
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16, top, 16, 16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: AlertDialog(
                          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          titlePadding: const EdgeInsets.fromLTRB(26, 24, 26, 12),
                          contentPadding: const EdgeInsets.fromLTRB(26, 0, 26, 8),
                          actionsPadding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                          actionsOverflowButtonSpacing: 10,
                          title: Text(
                            JexText.of('peltierSafety', appLanguageNotifier.value),
                            style: const TextStyle(
                              fontSize: 24,
                              height: 1.12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          content: Text(
                            JexText.of('fanRequiredPeltier', appLanguageNotifier.value),
                            style: const TextStyle(fontSize: 17, height: 1.35),
                          ),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: const Size(86, 48),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () => Navigator.pop(dialogContext, false),
                              child: Text(JexText.of('cancel', appLanguageNotifier.value)),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(142, 50),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: () => Navigator.pop(dialogContext, true),
                              child: Text(JexText.of('turnOnFan', appLanguageNotifier.value)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          transitionBuilder: (_, animation, __, child) {
            final offset = Tween<Offset>(
              begin: const Offset(0, -.035),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offset, child: child),
            );
          },
        );
        if (approved != true) return;

        // Safety-sensitive paired startup is serialized as one high-level transaction.
        // No generic Fan success is surfaced before the Peltier result is resolved.
        final fanOk = await _sendAndWaitAck('FAN:ON');
        if (!fanOk || !mounted) {
          if (mounted) {
            _showSnackBar(
              JexText.phrase(
                'Fan start was not confirmed.',
                'Kipas tidak terkonfirmasi menyala.',
              ),
              color: Colors.orangeAccent,
            );
          }
          return;
        }

        final peltierOk = await _sendAndWaitAck(
          'PELTIER:ON',
          timeout: const Duration(seconds: 6),
        );
        if (!peltierOk && mounted) {
          final reason =
              (_lastPeltierAckFailureReason.isNotEmpty
                      ? _lastPeltierAckFailureReason
                      : safetyReason)
                  .trim()
                  .toUpperCase();
          if (reason == 'PELTIER_SAFETY_LATCH' ||
              reason == 'HOTSIDE_PROTECTION') {
            _showSnackBar(
              peltierRearmNotice(hotLimit, appLanguageNotifier.value),
              color: Colors.redAccent,
            );
          } else {
            _showSnackBar(
              JexText.phrase(
                'Peltier change was not confirmed.',
                'Perubahan Peltier tidak terkonfirmasi.',
              ),
              color: Colors.orangeAccent,
            );
          }
        }
        return;
      }

      final ok = await _sendAndConfirm(
        enabled ? 'PELTIER:ON' : 'PELTIER:OFF',
        timeout: const Duration(seconds: 6),
      );
      if (!ok && mounted) {
        _showSnackBar(JexText.phrase('The device did not confirm the Peltier change. ${safetyReason == 'NONE' ? '' : safetyReason}','Perangkat belum mengonfirmasi perubahan Peltier. ${safetyReason == 'NONE' ? '' : safetyReason}'), color: Colors.orangeAccent);
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
        _showSnackBar(JexText.phrase('The device did not confirm the Adaptive Mode change.','Perangkat belum mengonfirmasi perubahan Mode Adaptif.'), color: Colors.orangeAccent);
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
        _showSnackBar(JexText.phrase('The device did not confirm the RGB power change.','Perangkat belum mengonfirmasi perubahan daya RGB.'));
      }
    } catch (e) {
      debugPrint('LED power command: $e');
      if (mounted) _showSnackBar(JexText.phrase('LED power command failed.','Perintah daya LED gagal.'));
    }
  }

  // AI-METHOD: _setMode — UI index maps to the stable firmware LED mode ID.
  Future<void> _setMode(int displayIndex) async {
    if (!connected) return;
    try {
      final next = ledFirmwareModeForDisplayIndex(displayIndex);
      final ok = await _sendAndConfirm('MODE:$next');
      if (!ok && mounted) {
        _showSnackBar(JexText.phrase('LED mode change was not confirmed.','Perubahan mode LED tidak terkonfirmasi.'));
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
        _showSnackBar(JexText.phrase('The device did not confirm the brightness change.','Perangkat belum mengonfirmasi perubahan kecerahan.'));
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
  Future<bool> _setRgbColor(String hex) async {
    if (!connected || rgbMode == 7) return false;
    final value = hex.trim().toUpperCase();
    if (!ledColorPalette.contains(value)) return false;
    if (value == rgbColor.toUpperCase()) return true;

    try {
      final ok = await _sendAndConfirm('COLOR:' + value.substring(1));
      if (!ok) {
        if (mounted) {
          _showSnackBar(JexText.phrase('Color change was not confirmed.','Perubahan warna tidak terkonfirmasi.'));
        }
        return false;
      }

      if (mounted) {
        setState(() => rgbColor = value);
      }
      return true;
    } catch (e) {
      debugPrint('LED color command: $e');
      if (mounted) _showSnackBar(JexText.phrase('LED color command failed.','Perintah warna LED gagal.'));
      return false;
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
        _showSnackBar(JexText.phrase('The device did not confirm the fan-speed change.','Perangkat belum mengonfirmasi perubahan kecepatan kipas.'));
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
      final next = value.clamp(20, 30).toInt();
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
      final next = value.clamp(30, 40).toInt();
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
      if (!ok && mounted) _showSnackBar(JexText.phrase('The device did not confirm the temperature settings.','Perangkat belum mengonfirmasi pengaturan suhu.'));
    } catch (e) {
      debugPrint('Temperature reset: $e');
      if (mounted) _showSnackBar(JexText.phrase('Temperature settings failed.','Pengaturan suhu gagal.'));
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
        JexText.phrase('The device did not confirm the Adaptive profile change.','Perangkat belum mengonfirmasi perubahan profil Adaptive.'),
        color: Colors.orangeAccent,
      );
    }
  }

  Future<void> _showLedColorPicker() async {
    if (!connected || rgbMode == 7) return;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: JexText.of('color', appLanguageNotifier.value),
      barrierColor: Colors.black.withValues(alpha: .48),
      transitionDuration: const Duration(milliseconds: 210),
      pageBuilder: (dialogContext, _, __) {
        return PopScope<void>(
          canPop: false,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (dialogContext, constraints) {
                // Pin the palette to the bottom safe area. The panel itself does not
                // scroll/drag; swatch taps stage a preview, and only Cancel or Select closes it.
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: _JexColorPickerCard(
                        colors: ledColorPresets,
                        selected: rgbColor.toUpperCase(),
                        onCancel: () {
                          if (dialogContext.mounted) Navigator.pop(dialogContext);
                        },
                        onSelect: _setRgbColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        final scale = Tween<double>(begin: .97, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: scale,
            alignment: Alignment.bottomCenter,
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
      if (command == 'CLOUDOTA') {
        otaExpectedDisconnect = true;
        otaRecoveryActive = true;
        otaRecoveryScanInProgress = false;
      }

      final ok = await _sendAndWaitAck(
        command,
        showError: false,
        timeout: const Duration(seconds: 4),
      );
      if (!ok) {
        final ambiguousCloudOtaStart = command == 'CLOUDOTA' &&
            (_lastCommandAckReason == 'TIMEOUT' ||
                _lastCommandAckReason == 'DISCONNECTED');
        if (ambiguousCloudOtaStart) {
          // Missing ACK is not proof of rejection: firmware may already have
          // accepted CLOUDOTA and started its single-radio Wi-Fi handoff.
          // Preserve OTA recovery flags so a disconnect/reconnect or OTA result
          // can resolve the final state instead of showing a false rejection.
          _showSnackBar(
            JexText.phrase(
              'OTA start was not confirmed. Waiting for device reconnection or OTA result.',
              'Konfirmasi awal OTA belum diterima. Menunggu perangkat tersambung kembali atau hasil OTA.',
              appLanguageNotifier.value,
            ),
            color: Colors.orangeAccent,
          );
          return;
        }

        // Roll back only a definite rejection while the BLE session is still up.
        if (command == 'CLOUDOTA' && connected) {
          otaExpectedDisconnect = false;
          otaRecoveryActive = false;
          otaRecoveryScanInProgress = false;
          reconnectTimer?.cancel();
          reconnectTimer = null;
        }
        _showSnackBar(
          JexText.of('otaStartRejected', appLanguageNotifier.value),
          color: Colors.redAccent,
        );
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }

    _showSnackBar(
      JexText.of('otaInProgress', appLanguageNotifier.value),
      color: Colors.purpleAccent,
    );
  }

  // AI-METHOD: _startOtaReconnectMonitor — Retry BLE discovery after OTA disconnect/restart.
  void _startOtaReconnectMonitor() {
    reconnectTimer?.cancel();
    int attempts = 0;
    otaRecoveryActive = true;
    otaRecoveryScanInProgress = false;
    reconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted || (!otaExpectedDisconnect && !otaRecoveryActive)) {
        timer.cancel();
        reconnectTimer = null;
        otaRecoveryScanInProgress = false;
        return;
      }

      if (connected || syncing || _bleConnecting) return;

      if (attempts >= 12) {
        timer.cancel();
        reconnectTimer = null;
        otaRecoveryActive = false;
        otaExpectedDisconnect = false;
        otaRecoveryScanInProgress = false;
        if (mounted) {
          setState(() {
            notice = JexText.of('otaReconnectFailed', appLanguageNotifier.value);
          });
        }
        return;
      }

      if (otaRecoveryScanInProgress) return;
      otaRecoveryScanInProgress = true;
      attempts++;

      try {
        await _scanAndConnect(
          automatic: true,
          otaRecovery: true,
        );
      } catch (e) {
        debugPrint('OTA BLE recovery: $e');
      } finally {
        otaRecoveryScanInProgress = false;
      }

      if (connected) {
        timer.cancel();
        reconnectTimer = null;
      }
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
    final specialKey = otaStageLocalizationKey(stage);
    if (specialKey.isNotEmpty) {
      return JexText.of(specialKey, appLanguageNotifier.value);
    }
    const keyByStage = <String, String>{
      'LOCAL_FILE_CHECK': 'otaStageLocalFileCheck',
      'LOCAL_SIZE_CHECK': 'otaStageLocalSizeCheck',
      'LOCAL_UPDATE_BEGIN': 'otaStageLocalUpdateBegin',
      'LOCAL_RECEIVE': 'otaStageLocalReceive',
      'LOCAL_FLASH_WRITE': 'otaStageLocalFlashWrite',
      'LOCAL_SIZE_VERIFY': 'otaStageLocalSizeVerify',
      'LOCAL_IMAGE_VERIFY': 'otaStageLocalImageVerify',
      'LOCAL_BOOT_PARTITION': 'otaStageLocalBootPartition',
      'ONLINE_REQUEST': 'otaStageOnlineRequest',
      'ONLINE_VERSION_CHECK': 'otaStageOnlineVersionCheck',
      'ONLINE_UP_TO_DATE': 'otaStageOnlineUpToDate',
      'ONLINE_WIFI_CONNECT': 'otaStageOnlineWifiConnect',
      'ONLINE_WIFI_CONNECTED': 'otaStageOnlineWifiConnected',
      'ONLINE_WIFI_RETRY_2': 'otaStageOnlineWifiRetry2',
      'ONLINE_WIFI_RETRY_3': 'otaStageOnlineWifiRetry3',
      'ONLINE_WIFI_FAILED': 'otaStageOnlineWifiFailed',
      'ONLINE_GITHUB_CONNECT': 'otaStageOnlineGithubConnect',
      'ONLINE_GITHUB_CONNECTED': 'otaStageOnlineGithubConnected',
      'ONLINE_DOWNLOAD': 'otaStageOnlineDownload',
      'ONLINE_DOWNLOAD_COMPLETE': 'otaStageOnlineDownloadComplete',
      'ONLINE_IMAGE_VALIDATE': 'otaStageOnlineImageValidate',
      'ONLINE_FLASH_PREPARE': 'otaStageOnlineFlashPrepare',
      'ONLINE_FLASH_FINALIZE': 'otaStageOnlineFlashFinalize',
      'ONLINE_FLASH_SUCCESS': 'otaStageOnlineFlashSuccess',
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

    if (upper.startsWith('OTA_UP_TO_DATE|')) {
      final fields = _otaDiagnosticFields(raw);
      final mode = _friendlyOtaMode(fields['MODE'] ?? 'OTA');
      final stage = _friendlyOtaStage(fields['STAGE'] ?? 'UNKNOWN');
      final version = fields['VERSION'] ?? '';
      return JexText.of('otaUpToDate', appLanguageNotifier.value) +
          ' • ' + mode + ' • ' + stage +
          (version.isEmpty ? '' : ' • ' + version);
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
    return raw.contains('_')
        ? JexText.of('deviceStatusUpdate', appLanguageNotifier.value)
        : raw;
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
      case 'POWER_ON':
      case 'POWERON':
        return JexText.of('resetPowerOn', appLanguageNotifier.value);
      default:
        return JexText.of('deviceStatusUpdate', appLanguageNotifier.value);
    }
  }

  String _friendlyReason(String reason) {
    switch (reason) {
      case 'NTC_ERROR':
        return JexText.phrase('Temperature sensor error. Peltier is locked.', 'Sensor suhu bermasalah. Peltier dikunci untuk keselamatan.');
      case 'HOTSIDE_PROTECTION':
        return peltierRearmNotice(hotLimit, appLanguageNotifier.value);
      case 'PELTIER_SAFETY_LATCH':
        return peltierRearmNotice(hotLimit, appLanguageNotifier.value);
      case 'VOLTAGE_STEP_FAILED':
        return JexText.phrase('Adaptive voltage step failed.', 'Perpindahan tegangan Adaptive gagal.');
      case 'VOLTAGE_FORCE_FAILED':
        return JexText.phrase('Safety could not switch to the required 5V state.', 'Sistem keselamatan tidak dapat mengalihkan tegangan ke 5V.');
      case 'ADAPTIVE_RISE_WAIT':
        return JexText.phrase('Adaptive is waiting before raising the voltage.', 'Adaptive menunggu sebelum menaikkan tegangan.');
      case 'ADAPTIVE_STARTING':
        return JexText.phrase('Adaptive Mode is starting.', 'Mode Adaptif sedang dimulai.');
      case 'FAN_REQUIRED':
        return JexText.phrase('Turn on the Fan before starting the Peltier.', 'Nyalakan kipas sebelum menyalakan Peltier.');
      case 'PELTIER_ON':
        return JexText.phrase('Fan control is locked while the Peltier is on.', 'Kontrol kipas terkunci saat Peltier menyala.');
      case 'ADAPTIVE_ACTIVE':
        return JexText.phrase('Manual cooling controls are locked while Adaptive Mode is active.', 'Kontrol pendinginan manual terkunci saat Mode Adaptif aktif.');
      case 'MANUAL_12V_ONLY':
        return JexText.phrase('Fan speed can only be adjusted at 12V in Manual Mode.', 'Kecepatan kipas hanya dapat diatur pada 12V dalam Mode Manual.');
      case 'VOLTAGE_TRANSITION':
        return JexText.phrase('Voltage change is in progress. Please wait.', 'Perubahan tegangan sedang berlangsung. Tunggu sebentar.');
      case 'VOLTAGE_GUARD_OR_BUSY':
        return JexText.phrase('Voltage command is still being processed.', 'Perintah tegangan masih diproses.');
      case 'SYNC_REQUIRED':
        return JexText.phrase('Device sync is still in progress.', 'Sinkronisasi perangkat masih berlangsung.');
      case 'RATE_LIMIT':
        return JexText.phrase('Command was sent too quickly. Please wait and try again.', 'Perintah terlalu cepat. Tunggu sebentar, lalu coba lagi.');
      case 'RANGE_50_100_STEP_10':
        return JexText.phrase('Fan speed must be between 50% and 100% in 10% steps.', 'Kecepatan kipas harus antara 50% dan 100% dengan kelipatan 10%.');
      case 'MUST_BE_BELOW_BATT12':
        return JexText.phrase('5V battery limit must stay below the 12V battery limit.', 'Batas baterai 5V harus di bawah batas baterai 12V.');
      case 'MUST_BE_ABOVE_BATT5':
        return JexText.phrase('12V battery limit must stay above the 5V battery limit.', 'Batas baterai 12V harus di atas batas baterai 5V.');
      case 'UNKNOWN_GROUP':
        return JexText.phrase('Reset request is not supported.', 'Permintaan reset tidak didukung.');
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
    int voltageLevel = 5,
  }) {
    final display = value == '--' ? '--' : value + unit;
    final active = value != '--';
    final animationIsActive = jexIndicatorAnimationActive(
      connected: connected,
      stateActive: animationActive ?? active,
    );
    final homeDark = appThemeNotifier.value != AppThemePreset.light;
    // AI-THEME / DASHBOARD-LIGHT-CONTRAST-CONTRACT
    // Light mode stays colorful while separating surface, outline, and glyph contrast.
    // The accent identifies the metric without becoming a harsh solid block.
    final mutedText = homeDark ? const Color(0xFFD4D7E0) : const Color(0xFF25282E);
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: color),
      duration: const Duration(milliseconds: 560),
      curve: Curves.easeInOutCubic,
      builder: (context, animatedColor, child) {
        final indicatorColor = animatedColor ?? color;
        final lightAccentOpacity = active ? .12 : .09;
        final lightOutlineOpacity = active ? .50 : .36;
        final lightTextAccent = indicatorColor;
        final indicatorFill = homeDark
            ? indicatorColor.withValues(alpha: .12)
            : indicatorColor.withValues(alpha: lightAccentOpacity);
        final indicatorBorder = homeDark
            ? indicatorColor.withValues(alpha: .52)
            : indicatorColor.withValues(alpha: lightOutlineOpacity);

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
                      color: indicatorFill,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: indicatorBorder,
                        width: homeDark ? 1.1 : 1.25,
                      ),
                    ),
                    child: animatedKind == null
                        ? JexAnimatedIcon.glyph(
                            icon: icon,
                            size: 22,
                            color: indicatorColor,
                            active: animationIsActive,
                            warning: warning,
                          )
                        : JexAnimatedIcon(
                            kind: animatedKind,
                            size: 22,
                            color: indicatorColor,
                            connected: connected,
                            active: jexIconAnimationPermitted(
                              connected: connected,
                              kind: animatedKind,
                              stateActive: animationActive ?? active,
                            ),
                            level: level,
                            voltageLevel: voltageLevel,
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
                        // Preserve semantic accents while disconnected; unavailable data is --.
                        color: active
                            ? lightTextAccent
                            : indicatorColor.withValues(alpha: .82),
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
      },
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
      stateActive: runtimeOutputsKnown && value,
    ),
    level: runtimeOutputsKnown && fanOn ? fanSpeed / 100 : 0,
      voltageLevel: jexVoltageAnimationLevel(voltage),
    );
  }

  // AI-METHOD / HOME-FAN-SPEED CONTRACT
  // Speed remains visible at all times. Fan OFF is presented as OFF/MATI instead
  // of reusing the last PWM value; disconnected telemetry remains "--".
  Widget _homeFanSpeed() {
    final lang = appLanguageNotifier.value;
    final displaySpeed = homeFanSpeedDisplay(
      connected: connected,
      fanOn: fanOn,
      voltage: voltage,
      adaptiveOn: adaptiveOn,
      fanSpeed: fanSpeed,
      offLabel: JexText.of('off', lang),
    );
    return _homeMetric(
      JexText.of('fanSpeedLabel'),
      displaySpeed,
      '',
      color: const Color(0xFFFFCD38),
      icon: PhosphorIconsRegular.gauge,
      animatedKind: JexAnimatedIconKind.speed,
      animationActive: jexIndicatorAnimationActive(
      connected: connected,
      stateActive: runtimeOutputsKnown && fanOn,
    ),
    level: connected && runtimeOutputsKnown && fanOn ? fanSpeed / 100 : 0.0,
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
    }    if (lower == 'device disconnected.') {
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
    if (lower.startsWith('reset:')) {
      final reset = raw.substring(raw.indexOf(':') + 1).trim();
      return _friendlyReset(reset);
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
      case 'PELTIER_SAFETY_LATCH':
        return peltierRearmNotice(hotLimit, appLanguageNotifier.value);
      case 'FAN_REQUIRED':
        return JexText.phrase('Fan required before Peltier.','Kipas harus aktif sebelum Peltier.');
      case 'PELTIER_ON':
        return JexText.phrase('Fan control is locked while Peltier is on.','Kendali kipas terkunci saat Peltier aktif.');
      case 'ADAPTIVE_ACTIVE':
        return JexText.phrase('Manual cooling controls are locked.','Kendali pendinginan manual terkunci.');
      case 'ADAPTIVE_STARTING':
        return JexText.phrase('Adaptive Mode is starting.','Mode Adaptif sedang dimulai.');
      case 'MANUAL_12V_ONLY':
        return JexText.phrase('Only available at 12V in Manual Mode.','Hanya tersedia pada 12V dalam Mode Manual.');
      case 'VOLTAGE_GUARD_OR_BUSY':
        return JexText.phrase('Voltage command is still processing.','Perintah tegangan sedang diproses.');
      case 'RATE_LIMIT':
        return JexText.phrase('Too many commands. Please wait before trying again.','Terlalu banyak perintah. Tunggu sebentar sebelum mencoba lagi.');
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
      message = JexText.of('hotsideTemperature', lang) + ': ' + c.substring(9) + '°C.';
    } else if (c.startsWith('BATT5:')) {
      message = JexText.of('fiveVCeiling', lang) + ' ' + JexText.phrase('updated.', 'Diperbarui.', lang);
    } else if (c.startsWith('BATT12:')) {
      message = JexText.of('twelveVFloor', lang) + ' ' + JexText.phrase('updated.', 'Diperbarui.', lang);
    } else if (c == 'RESET:TEMPERATURE') {
      message = JexText.of('temperatureReset', lang);
    }
    if (message != null) setState(() => notice = message!);
  }

  String _notifyStateLabel() {
    final custom = notice.trim().toUpperCase();
    if (_bleConnecting) return JexText.of('notifyBluetooth', appLanguageNotifier.value);
    if (syncing && !dashboardReady) return JexText.of('notifySync', appLanguageNotifier.value);

    final hasError = isNotifyErrorMessage(custom);
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

  String _notifyStatusLabel() => homeNotifyConnectionLabel(
        notice: notice,
        isConnecting: _bleConnecting,
        isSyncing: syncing && !dashboardReady,
        connected: connected,
        language: appLanguageNotifier.value,
      );

  // AI-METHOD: _homeNotify — Render the Home NOTIFY card.
  Widget _homeNotify() {
    final headerDark = appThemeNotifier.value != AppThemePreset.light;
    final noticeTextColor = headerDark ? const Color(0xFFF4F6FA) : const Color(0xFF16181D);
    final offlineStatusColor = headerDark ? Colors.white38 : const Color(0xFF5C626B);
    final custom = notice.trim().toUpperCase();
    final hasError = isNotifyErrorMessage(custom);
    final warning = connected &&
        safetyReason != 'NONE' &&
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
    final lightStatusTextColor = lightThemeAccentText(color);
    final noticeChipFill = headerDark
        ? const Color(0x12FFFFFF)
        : color.withValues(alpha: hasError ? .11 : .08);
    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: headerDark
            ? color.withValues(alpha: hasError ? .12 : .07)
            : color.withValues(alpha: hasError ? .11 : .08),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: headerDark
              ? color.withValues(alpha: .25)
              : color.withValues(alpha: .30),
        ),
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
                            decoration: TextDecoration.none,
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
              border: Border.all(
                color: headerDark
                    ? color.withValues(alpha: .16)
                    : lightStatusTextColor.withValues(alpha: .24),
              ),
            ),
            child: Text(
              _notifyStatusLabel(),
              style: TextStyle(
                decoration: TextDecoration.none,
                color: hasError
                    ? (headerDark
                        ? const Color(0xFFFF8A98)
                        : lightThemeAccentText(const Color(0xFFFF5164)))
                    : connected
                        ? (headerDark ? Colors.cyanAccent : lightStatusTextColor)
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
    bool stateKnown = true,
    JexAnimatedIconKind? animatedKind,
    int voltageLevel = 5,
    double animationLevel = 1.0,
    Color? animationColor,
    bool showStateLabel = true,
    bool showCheck = true,
    bool neutralRow = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final lang = appLanguageNotifier.value;
    final lightTheme = Theme.of(context).brightness == Brightness.light;
    final rowFill = lightTheme
        ? const Color(0xFFF5F6F8)
        : (neutralRow
            ? scheme.surfaceContainerHighest.withValues(alpha: .26)
            : (value ? accent.withValues(alpha: .075) : scheme.surfaceContainerHighest.withValues(alpha: .34)));
    final rowBorder = lightTheme
        ? const Color(0xFFDDE1E7)
        : (neutralRow
            ? scheme.outlineVariant.withValues(alpha: .68)
            : (value ? accent.withValues(alpha: .28) : scheme.outlineVariant.withValues(alpha: .72)));
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: jexSubmenuRowMinHeight),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: rowFill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: rowBorder),
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: lightTheme
                  ? const Color(0xFFE9EBEF)
                  : (neutralRow
                      ? scheme.surfaceContainerHighest.withValues(alpha: .72)
                      : (value ? accent.withValues(alpha: .12) : scheme.surfaceContainerHighest.withValues(alpha: .72))),
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
                      color: animationColor ?? accent,
                      connected: connected,
                      active: jexIconAnimationPermitted(
                        connected: connected,
                        kind: animatedKind,
                        stateActive: stateKnown && value,
                      ),
                      level: animationLevel,
                      voltageLevel: voltageLevel,
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
          if (showStateLabel) ...[
            const SizedBox(width: 8),
            Text(
              stateKnown ? JexText.of(value ? 'on' : 'off', lang) : JexText.of('off', lang),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: value ? accent : scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
          ],
          _jexToggle(
            value: value,
            enabled: enabled,
            stateKnown: stateKnown,
            accent: accent,
            showCheck: showCheck,
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
    bool stateKnown = true,
    bool showCheck = true,
  }) {
    final scheme = Theme.of(context).colorScheme;
    // Offline fallback is a visual default only, not confirmed hardware telemetry.
    final displayedValue = stateKnown && value;
    return GestureDetector(
      onTap: enabled && stateKnown ? () => unawaited(onChanged(!displayedValue)) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: jexSubmenuToggleWidth,
        height: jexSubmenuToggleHeight,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: displayedValue
              ? accent.withValues(alpha: .24)
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: displayedValue ? accent.withValues(alpha: .52) : scheme.outlineVariant,
            width: 1.2,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: displayedValue ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: displayedValue
                  ? accent
                  : (enabled
                      ? scheme.onSurfaceVariant
                      : scheme.onSurfaceVariant.withValues(alpha: .32)),
              shape: BoxShape.circle,
              boxShadow: [
                if (displayedValue)
                  BoxShadow(
                    color: accent.withValues(alpha: .20),
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: displayedValue && showCheck
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
                const SizedBox(height: 8),
                _voltageChoiceCustom('9V', JexText.of('midMode', lang), locked),
                const SizedBox(height: 8),
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
    return InkWell(
      onTap: locked ? null : () => _requestVoltage(target),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        constraints: const BoxConstraints(minHeight: jexSubmenuRowMinHeight),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          // Geometry intentionally mirrors CONTROL/_switchRow. The row stays neutral;
          // selection is represented only by the shared toggle on the right.
          color: scheme.surfaceContainerHighest.withValues(alpha: .26),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: .68)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: .72),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                target,
                style: TextStyle(
                  color: jexVoltageIndicatorColor(target),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mode,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _jexToggle(
              value: active,
              enabled: !locked,
              accent: scheme.primary,
              showCheck: false,
              onChanged: (_) async => _requestVoltage(target),
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
                  showStateLabel: false,
                  showCheck: false,
                  neutralRow: true,
                  subtitle: '',
                  icon: PhosphorIconsRegular.snowflake,
                  animatedKind: JexAnimatedIconKind.peltier,
                  animationColor: const Color(0xFF18DFFF),
                  animationLevel: peltierOn ? 1.0 : 0.0,
                  voltageLevel: jexVoltageAnimationLevel(voltage),
                  value: peltierOn,
                  enabled: connected && runtimeOutputsKnown && !adaptiveOn,
                  stateKnown: runtimeOutputsKnown,
                  onChanged: _togglePeltier,
                ),
                const SizedBox(height: 8),
                _switchRow(
                  title: JexText.of('fan', lang),
                  showStateLabel: false,
                  showCheck: false,
                  neutralRow: true,
                  subtitle: '',
                  icon: PhosphorIconsRegular.fan,
                  animatedKind: JexAnimatedIconKind.fan,
                  animationColor: const Color(0xFF38E3AD),
                  animationLevel: fanSpeed / 100,
                  voltageLevel: jexVoltageAnimationLevel(voltage),
                  value: fanOn,
                  enabled: connected && runtimeOutputsKnown && !adaptiveOn && !peltierOn,
                  stateKnown: runtimeOutputsKnown,
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
                            color: const Color(0xFFFFCD38),
                            connected: connected,
                            active: jexIconAnimationPermitted(
                              connected: connected,
                              kind: JexAnimatedIconKind.speed,
                              stateActive: runtimeOutputsKnown && fanOn,
                            ),
                            level: runtimeOutputsKnown && fanOn ? fanSpeed / 100 : 0.0,
                            voltageLevel: jexVoltageAnimationLevel(voltage),
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
                            !connected || !runtimeOutputsKnown || !fanOn
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
    final locked = adaptiveOn || adaptiveTransitioning;
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
              showStateLabel: false,
              showCheck: false,
              neutralRow: true,
              subtitle: '',
              icon: PhosphorIconsRegular.sparkle,
              animatedKind: JexAnimatedIconKind.adaptive,
              animationColor: const Color(0xFFC05BFF),
              animationLevel: adaptiveOn ? 1.0 : 0.0,
              voltageLevel: jexVoltageAnimationLevel(voltage),
              value: adaptiveOn,
              enabled: connected && runtimeOutputsKnown,
              stateKnown: runtimeOutputsKnown,
              onChanged: _toggleAdaptive,
            ),
          ),
          _card(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                JexAnimatedIcon.glyph(
                  icon: PhosphorIconsRegular.sparkle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                  active: connected,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    JexText.of('adaptiveCeiling', lang),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  connected ? adaptiveCeiling : '--',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
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
  // Custom LED control surface. The preview mirrors the physical 4-left/4-right strip and follows firmware phase telemetry.
  Widget _buildLedTab({Key? key}) {
    final lang = appLanguageNotifier.value;
    final modeNames = <String>[
      JexText.of('ledModeStatic', lang),
      JexText.of('ledModeBreath', lang),
      JexText.of('ledModeComet', lang),
      JexText.of('ledModeDualChase', lang),
      JexText.of('leftRight', lang),
      JexText.of('ledModeRainbow', lang),
    ];
    final modeIndex = ledModeDisplayIndex(rgbMode);
    final supportedMode = modeIndex >= 0;
    final previewMode = supportedMode ? rgbMode : 1;
    final modeName = supportedMode
        ? modeNames[modeIndex]
        : JexText.of('ledModeUnsupported', lang);
    final colorEnabled = connected && supportedMode && rgbMode != 7;
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
                  showStateLabel: false,
                  showCheck: false,
                  neutralRow: true,
                  subtitle: '',
                  icon: PhosphorIconsBold.lightbulb,
                  animatedKind: JexAnimatedIconKind.led,
                  value: rgbOn,
                  enabled: connected && runtimeOutputsKnown,
                  stateKnown: runtimeOutputsKnown,
                  onChanged: _setRgb,
                ),
                const SizedBox(height: 9),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: .22),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: .68)),
                  ),
                  child: Column(
                    children: [
                      JexLedStripPreview(
                        mode: previewMode,
                        colorHex: rgbColor.toUpperCase(),
                                        active: rgbOn && connected && supportedMode,
                        ledPhaseMs: ledPhaseMs,
                        ledCycleMs: ledCycleMs,
                        ledSyncRevision: ledSyncRevision,
                        modeName: modeName,
                        previousEnabled: connected && (modeIndex < 0 || modeIndex > 0),
                        nextEnabled: connected && (modeIndex < 0 || modeIndex < supportedLedModeIds.length - 1),
                        onPrevious: () => _setMode(modeIndex < 0 ? 1 : modeIndex - 1),
                        onNext: () => _setMode(modeIndex < 0 ? 2 : modeIndex + 1),
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
                              ledColorDisplayName(rgbColor, lang),
                              style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
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

  // AI-METHOD / TEMPERATURE-UI-CONTRACT
  // Compact thermal controls with consistent custom +/- buttons and no long dividers.
  Widget _buildTemperatureTab({Key? key}) {
    final locked = adaptiveOn || adaptiveTransitioning;
    final midLow = battery5Limit;
    final midHigh = battery12Limit;
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
                  max: 30,
                  enabled: connected && !locked && battery5Draft < battery12Limit,
                  onChanged: (v) {
                    if (v < battery12Limit) _setBattery5(v);
                  },
                ),
                const SizedBox(height: 8),
                _lockedZoneRow(
                  title: JexText.of('zone9v', lang),
                  value: midLow.toString() + '°C → 9V → ' + midHigh.toString() + '°C',
                ),
                const SizedBox(height: 8),
                _temperatureAdjuster(
                  title: JexText.of('twelveVFloor'),
                  value: battery12Draft,
                  min: 30,
                  max: 40,
                  enabled: connected && !locked && battery12Draft > battery5Limit,
                  onChanged: (v) {
                    if (v > battery5Limit) _setBattery12(v);
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
    final content = switch (tabIndex) {
      0 => _buildVoltageTab(key: const ValueKey('voltage-tab')),
      1 => _buildControlTab(key: const ValueKey('control-tab')),
      2 => _buildAdaptiveTab(key: const ValueKey('adaptive-tab')),
      3 => _buildLedTab(key: const ValueKey('led-tab')),
      4 => _buildTemperatureTab(key: const ValueKey('temperature-tab')),
      _ => const SizedBox.shrink(),
    };
    final lockReason = displayMenuLockReason(
      connected: connected,
      adaptiveActive: adaptiveOn,
      adaptiveTransitioning: adaptiveTransitioning,
      tabIndex: tabIndex,
    );
    return lockReason == DisplayMenuLockReason.none
        ? content
        : _lockedDisplayMenu(content, lockReason);
  }

  /// Blurs the complete submenu, then centers one lock panel above all of its content.
  /// Navigation tabs and the Bluetooth Home control live outside this Stack and remain usable.
  Widget _lockedDisplayMenu(Widget content, DisplayMenuLockReason reason) {
    final disconnected = reason == DisplayMenuLockReason.bluetoothDisconnected;
    final scheme = Theme.of(context).colorScheme;
    final title = disconnected
        ? JexText.phrase('CONNECT TO JE X FYZ FIRST', 'HUBUNGKAN KE JE X FYZ TERLEBIH DAHULU')
        : JexText.phrase('LOCKED BY ADAPTIVE MODE', 'TERKUNCI OLEH MODE ADAPTIF');
    final detail = disconnected
        ? JexText.phrase('Connect your cooler to unlock this menu.', 'Hubungkan perangkat JE X FYZ untuk membuka menu ini.')
        : JexText.phrase('Turn Adaptive Mode off to edit these settings.', 'Matikan Mode Adaptif untuk mengubah pengaturan ini.');
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4.8, sigmaY: 4.8),
            child: IgnorePointer(child: content),
          ),
          Positioned.fill(
            child: ColoredBox(color: scheme.surface.withValues(alpha: .46)),
          ),
          Positioned.fill(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 270),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                  decoration: BoxDecoration(
                    color: scheme.surface.withValues(alpha: .96),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: .92), width: 1.1),
                    boxShadow: <BoxShadow>[
                      BoxShadow(color: Colors.black.withValues(alpha: .12), blurRadius: 20, offset: const Offset(0, 7)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIconsBold.lock,
                        size: 38,
                        color: disconnected ? const Color(0xFF4D8CFF) : const Color(0xFFC05BFF),
                      ),
                      const SizedBox(height: 12),
                      Text(title, textAlign: TextAlign.center, style: TextStyle(
                        color: scheme.onSurface, fontSize: 14, height: 1.2,
                        fontWeight: FontWeight.w900, letterSpacing: .25,
                      )),
                      const SizedBox(height: 7),
                      Text(detail, textAlign: TextAlign.center, style: TextStyle(
                        color: scheme.onSurfaceVariant, fontSize: 11.5, height: 1.3,
                        fontWeight: FontWeight.w600,
                      )),
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
                          connected: connected,
                          active: jexIconAnimationPermitted(
                            connected: connected,
                            kind: JexAnimatedIconKind.bluetooth,
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
                            color: jexThermalBatteryColor(batteryValue),
                            icon: PhosphorIconsRegular.batteryHigh,
                            animatedKind: JexAnimatedIconKind.battery,
                            level: jexThermalBatteryLevel(batteryValue),
                            warning: jexThermalBatteryFireActive(batteryValue),
                          ),
                          _homeMetric(
                            JexText.of('hotsideTemperature'),
                            hotValue,
                            hotValue == '--' ? '' : '°C',
                            color: jexHotsideTemperatureColor(
                              hotValue,
                              hotLimit: hotLimit.toDouble(),
                            ),
                            icon: PhosphorIconsRegular.thermometer,
                            animatedKind: JexAnimatedIconKind.hotside,
                            level: jexTemperatureIndicatorLevel(
                              hotValue,
                              minC: 30,
                              maxC: hotLimit.toDouble(),
                              fallback: 0,
                            ),
                            warning: connected && jexHotsideFireActive(
                              hotValue,
                              hotLimit: hotLimit.toDouble(),
                            ),
                          ),
                          _homeMetric(
                            JexText.of('voltageIndicator'),
                            voltageValue,
                            '',
                            color: jexVoltageIndicatorColor(voltageValue),
                            icon: PhosphorIconsRegular.lightning,
                            animatedKind: JexAnimatedIconKind.voltage,
                            level: jexVoltageEnergyLevel(voltageValue),
                            voltageLevel: jexVoltageAnimationLevel(voltageValue),
                          ),
                          _homeMetric(
                            JexText.of('adaptiveMode'),
                            adaptiveValue,
                            '',
                            color: const Color(0xFFC05BFF),
                            icon: PhosphorIconsRegular.sparkle,
                            animatedKind: JexAnimatedIconKind.adaptive,
                            animationActive: connected && runtimeOutputsKnown && adaptiveOn,
                            level: adaptiveOn ? 1.0 : 0.0,
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
                obscureText: true,
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
              final s = ssid.text.trim();              final p = password.text;
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