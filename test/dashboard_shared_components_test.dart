import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jexfyz_cooler/dashboard_shared_components.dart';
import 'package:jexfyz_cooler/jex_design_tokens.dart';

void main() {
  testWidgets(
    'Dashboard card uses shared surface, spacing and shape roles',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: JexDashboardCard(child: Text('Card content')),
          ),
        ),
      );

      final card = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Card content'),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = card.decoration! as BoxDecoration;
      expect(
        card.margin,
        const EdgeInsets.symmetric(
          vertical: JexSpacingTokens.dashboardCardVerticalMargin,
        ),
      );
      expect(
        card.padding,
        const EdgeInsets.all(JexSpacingTokens.dashboardCardDefaultPadding),
      );
      expect(
        decoration.borderRadius,
        const BorderRadius.all(
          Radius.circular(JexShapeTokens.dashboardCardBorderRadius),
        ),
      );
      expect(decoration.color, ThemeData.light().colorScheme.surface);
    },
  );

  testWidgets(
    'Dashboard card preserves a consumer-specific padding override',
    (tester) async {
      const override = EdgeInsets.symmetric(horizontal: 10, vertical: 6);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JexDashboardCard(
              padding: override,
              child: const Text('Custom card content'),
            ),
          ),
        ),
      );

      final card = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('Custom card content'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(card.padding, override);
    },
  );

  testWidgets(
    'Dashboard section title uses the shared typography and spacing roles',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: JexDashboardSectionTitle(
              'Cooling',
              subtitle: 'Current state',
            ),
          ),
        ),
      );

      final title = tester.widget<Text>(find.text('COOLING'));
      final subtitle = tester.widget<Text>(find.text('Current state'));
      final padding = tester.widget<Padding>(
        find
            .ancestor(
              of: find.text('COOLING'),
              matching: find.byType(Padding),
            )
            .first,
      );
      final subtitleGap = tester.widget<SizedBox>(find.byType(SizedBox));

      expect(
        title.style?.fontSize,
        JexTypographyTokens.dashboardSectionTitle,
      );
      expect(
        subtitle.style?.fontSize,
        JexTypographyTokens.dashboardSectionSubtitle,
      );
      expect(
        padding.padding,
        const EdgeInsets.fromLTRB(
          JexSpacingTokens.dashboardSectionTitleHorizontalInset,
          JexSpacingTokens.dashboardSectionTitleTopInset,
          JexSpacingTokens.dashboardSectionTitleHorizontalInset,
          JexSpacingTokens.dashboardSectionTitleBottomInset,
        ),
      );
      expect(
        subtitleGap.height,
        JexSpacingTokens.dashboardSectionSubtitleGap,
      );
    },
  );
}
