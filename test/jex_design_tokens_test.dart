import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/jex_design_tokens.dart';

void main() {
  group('JEX semantic ColorScheme roles', () {
    final scheme = const ColorScheme.dark().copyWith(
      primary: const Color(0xFF102030),
      onPrimary: const Color(0xFF203040),
      surface: const Color(0xFF304050),
      onSurface: const Color(0xFF405060),
      onSurfaceVariant: const Color(0xFF506070),
      surfaceContainerHighest: const Color(0xFF607080),
      surfaceContainerHigh: const Color(0xFF708090),
      outlineVariant: const Color(0xFF8090A0),
      error: const Color(0xFF90A0B0),
      onError: const Color(0xFFA0B0C0),
    );

    test('aliases retain the exact Material ColorScheme source roles', () {
      expect(scheme.jexCanvas, scheme.surface);
      expect(scheme.jexSurface, scheme.surface);
      expect(scheme.jexElevatedSurface, scheme.surfaceContainerHighest);
      expect(scheme.jexRaisedSurface, scheme.surfaceContainerHigh);
      expect(scheme.jexForeground, scheme.onSurface);
      expect(scheme.jexMutedForeground, scheme.onSurfaceVariant);
      expect(scheme.jexOutline, scheme.outlineVariant);
      expect(scheme.jexAccent, scheme.primary);
      expect(scheme.jexAccentForeground, scheme.onPrimary);
      expect(scheme.jexError, scheme.error);
      expect(scheme.jexErrorForeground, scheme.onError);
    });

    test('semantic color value object preserves every role', () {
      final semantic = JexSemanticColors.from(scheme);

      expect(semantic.canvas, scheme.surface);
      expect(semantic.surface, scheme.surface);
      expect(semantic.elevatedSurface, scheme.surfaceContainerHighest);
      expect(semantic.raisedSurface, scheme.surfaceContainerHigh);
      expect(semantic.foreground, scheme.onSurface);
      expect(semantic.mutedForeground, scheme.onSurfaceVariant);
      expect(semantic.outline, scheme.outlineVariant);
      expect(semantic.accent, scheme.primary);
      expect(semantic.accentForeground, scheme.onPrimary);
      expect(semantic.error, scheme.error);
      expect(semantic.onError, scheme.onError);
    });
  });

  group('JEX geometry and typography tokens', () {
    test('fixed Dashboard canvas and touch dimensions retain their contract', () {
      expect(JexLayoutTokens.masterCanvasWidth, 360.0);
      expect(JexLayoutTokens.homeCanvasHeight, 420.0);
      expect(JexLayoutTokens.homeMetricRowHeight, 45.0);
      expect(JexLayoutTokens.homeTabPillHeight, 38.0);
      expect(JexLayoutTokens.minimumTouchTarget, 48.0);
      expect(JexLayoutTokens.homeTabTouchHeight, 48.0);
      expect(JexLayoutTokens.submenuRowMinHeight, 62.0);
      expect(JexLayoutTokens.submenuToggleWidth, 54.0);
      expect(JexLayoutTokens.submenuToggleHeight, 32.0);
    });

    test('type, chart-axis and shape values remain explicit tokens', () {
      expect(JexTypographyTokens.appBarTitle, 20.0);
      expect(JexTypographyTokens.compactAppBarTitle, 18.0);
      expect(JexTypographyTokens.compactBodyMedium, 12.0);
      expect(JexStatisticsTypographyTokens.axisLabel, 10.0);
      expect(JexShapeTokens.inputBorderRadius, 14.0);
      expect(JexShapeTokens.compactControlRadius, 11.0);
      expect(JexShapeTokens.focusedInputBorderWidth, 1.5);
    });
  });
}
