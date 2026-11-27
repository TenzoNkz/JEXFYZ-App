// AI-MEMORY / DESIGN SYSTEM CONTRACT
// Shared source of approved App geometry and semantic Material roles.
// Values here centralize existing visual decisions; changing them changes multiple screens
// and therefore requires the same design review and regression matrix as a direct widget edit.

import 'package:flutter/material.dart';

/// Existing layout dimensions shared by the 360-dp App canvas and compact controls.
abstract final class JexLayoutTokens {
  static const double masterCanvasWidth = 360.0;
  static const double homeCanvasHeight = 420.0;
  static const double homeMetricRowHeight = 45.0;
  static const double homeTabPillHeight = 38.0;
  static const double minimumTouchTarget = 48.0;
  static const double homeTabTouchHeight = 48.0;
  static const double submenuRowMinHeight = 62.0;
  static const double submenuToggleWidth = 54.0;
  static const double submenuToggleHeight = 32.0;
}

/// Semantic Material roles mapped from the active app ColorScheme.
///
/// No palette is defined here: Light/Dark values remain owned by buildJexTheme and
/// buildJexCompactUiTheme in app_settings.dart.
class JexSemanticColors {
  const JexSemanticColors({
    required this.canvas,
    required this.surface,
    required this.elevatedSurface,
    required this.foreground,
    required this.mutedForeground,
    required this.outline,
    required this.accent,
    required this.error,
    required this.onError,
  });

  final Color canvas;
  final Color surface;
  final Color elevatedSurface;
  final Color foreground;
  final Color mutedForeground;
  final Color outline;
  final Color accent;
  final Color error;
  final Color onError;

  factory JexSemanticColors.from(ColorScheme scheme) => JexSemanticColors(
    canvas: scheme.surface,
    surface: scheme.surface,
    elevatedSurface: scheme.surfaceContainerHighest,
    foreground: scheme.onSurface,
    mutedForeground: scheme.onSurfaceVariant,
    outline: scheme.outlineVariant,
    accent: scheme.primary,
    error: scheme.error,
    onError: scheme.onError,
  );
}

/// Typography sizes already used by the App's established Light/Dark themes.
abstract final class JexTypographyTokens {
  static const double appBarTitle = 20.0;
  static const double compactAppBarTitle = 18.0;
  static const double compactAppBarIcon = 22.0;
  static const double compactTitleLarge = 18.0;
  static const double compactTitleMedium = 13.0;
  static const double compactTitleSmall = 12.0;
  static const double compactBodyLarge = 13.0;
  static const double compactBodyMedium = 12.0;
  static const double compactBodySmall = 11.0;
  static const double compactLabelLarge = 12.0;
  static const double compactLabelMedium = 11.0;
  static const double compactLabelSmall = 10.0;
  static const double compactListTileTitle = 13.0;
  static const double compactListTileSubtitle = 11.0;
}

/// Shape and focus metrics retained from the existing App theme.
abstract final class JexShapeTokens {
  static const double inputBorderRadius = 14.0;
  static const double focusedInputBorderWidth = 1.5;
}
