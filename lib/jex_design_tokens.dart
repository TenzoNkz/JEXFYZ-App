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
  static const double dashboardSwitchRowIconSize = 42.0;
  static const double homeTabPillHeight = 38.0;
  static const double minimumTouchTarget = 48.0;
  static const double homeTabTouchHeight = 48.0;
  static const double submenuRowMinHeight = 62.0;
  static const double submenuToggleWidth = 54.0;
  static const double submenuToggleHeight = 32.0;
}

/// Dashboard state feedback timings shared by animated presentation components.
/// 210 ms follows the approved control/state motion range; 90 ms is the existing
/// reduced-motion fallback used by Dashboard tab transitions.
abstract final class JexMotionTokens {
  static const Duration dashboardStateTransition = Duration(
    milliseconds: 210,
  );
  static const Duration dashboardReducedMotionTransition = Duration(
    milliseconds: 90,
  );
}

/// Spacing roles for shared Dashboard primitives; not a global scale.
abstract final class JexSpacingTokens {
  static const double dashboardCardVerticalMargin = 4.0;
  static const double dashboardCardDefaultPadding = 14.0;
  static const double dashboardSectionTitleHorizontalInset = 4.0;
  static const double dashboardSectionTitleTopInset = 6.0;
  static const double dashboardSectionTitleBottomInset = 5.0;
  static const double dashboardSectionSubtitleGap = 3.0;
  static const double dashboardSwitchRowHorizontalInset = 12.0;
  static const double dashboardSwitchRowVerticalInset = 7.0;
  static const double dashboardSwitchRowIconLabelGap = 12.0;
  static const double dashboardSwitchRowSubtitleTopGap = 2.0;
  static const double dashboardSwitchRowStateGap = 8.0;
}

/// Semantic aliases for the existing Material ColorScheme roles.
///
/// These getters deliberately return the original ColorScheme values. No palette is
/// defined here: Light/Dark values remain owned by buildJexTheme and
/// buildJexCompactUiTheme in app_settings.dart.
extension JexColorSchemeSemanticRoles on ColorScheme {
  Color get jexSurface => surface;
  Color get jexElevatedSurface => surfaceContainerHighest;
  Color get jexRaisedSurface => surfaceContainerHigh;
  Color get jexForeground => onSurface;
  Color get jexMutedForeground => onSurfaceVariant;
  Color get jexOutline => outlineVariant;
  Color get jexAccent => primary;
  Color get jexAccentForeground => onPrimary;
  Color get jexError => error;
  Color get jexErrorForeground => onError;
}

/// Theme canvas remains distinct from content surfaces in the active App theme.
extension JexThemeSemanticRoles on ThemeData {
  Color get jexCanvas => scaffoldBackgroundColor;
}

/// Value object for widgets that need several semantic roles at once.
/// The canvas maps to ThemeData; all other roles map to its ColorScheme.
class JexSemanticColors {
  const JexSemanticColors({
    required this.canvas,
    required this.surface,
    required this.elevatedSurface,
    required this.raisedSurface,
    required this.foreground,
    required this.mutedForeground,
    required this.outline,
    required this.accent,
    required this.accentForeground,
    required this.error,
    required this.onError,
  });

  final Color canvas;
  final Color surface;
  final Color elevatedSurface;
  final Color raisedSurface;
  final Color foreground;
  final Color mutedForeground;
  final Color outline;
  final Color accent;
  final Color accentForeground;
  final Color error;
  final Color onError;

  factory JexSemanticColors.from(ThemeData theme) {
    final scheme = theme.colorScheme;
    return JexSemanticColors(
      canvas: theme.jexCanvas,
      surface: scheme.jexSurface,
      elevatedSurface: scheme.jexElevatedSurface,
      raisedSurface: scheme.jexRaisedSurface,
      foreground: scheme.jexForeground,
      mutedForeground: scheme.jexMutedForeground,
      outline: scheme.jexOutline,
      accent: scheme.jexAccent,
      accentForeground: scheme.jexAccentForeground,
      error: scheme.jexError,
      onError: scheme.jexErrorForeground,
    );
  }
}

/// Typography sizes already used by the App's established Light/Dark themes.
abstract final class JexTypographyTokens {
  static const double appBarTitle = 20.0;
  static const double dashboardSectionTitle = 16.0;
  static const double dashboardSectionSubtitle = 11.0;
  static const double dashboardSwitchRowTitle = 13.0;
  static const double dashboardSwitchRowSubtitle = 10.5;
  static const double dashboardSwitchRowState = 10.0;
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

/// Typography shared by the Usage Statistics chart axes.
abstract final class JexStatisticsTypographyTokens {
  static const double axisLabel = 10.0;
}

/// Shape and focus metrics retained from the existing App theme.
abstract final class JexShapeTokens {
  static const double inputBorderRadius = 14.0;
  static const double dashboardCardBorderRadius = 19.0;
  static const double dashboardSwitchRowRadius = 18.0;
  static const double dashboardSwitchRowIconRadius = 14.0;
  static const double compactControlRadius = 11.0;
  static const double focusedInputBorderWidth = 1.5;
}
