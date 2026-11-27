import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/main.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

void main() {
  testWidgets(
    'Dashboard switch row preserves rendered geometry, typography and semantics',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final changedValues = <bool>[];
      const rowKey = ValueKey<String>('dashboard-switch-row-test');

      try {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: Center(
                child: UnconstrainedBox(
                  child: SizedBox(
                    width: 340,
                    child: JexDashboardSwitchRow(
                      key: rowKey,
                      title: 'Fan',
                      subtitle: 'Cooling output',
                      icon: PhosphorIconsRegular.fan,
                      value: true,
                      enabled: true,
                      stateKnown: true,
                      connected: true,
                      language: AppLanguage.english,
                      onChanged: (next) async {
                        changedValues.add(next);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final row = find.byKey(rowKey);
        expect(row, findsOneWidget);
        final animated = find.descendant(
          of: row,
          matching: find.byType(AnimatedContainer),
        );
        expect(animated, findsNWidgets(3));

        final outer = tester.widget<AnimatedContainer>(animated.at(0));
        expect(tester.getSize(animated.at(0)).height, 64.0);
        expect(
          outer.padding,
          const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        );
        expect(outer.constraints?.minHeight, 62.0);
        final outerDecoration = outer.decoration! as BoxDecoration;
        expect(
          outerDecoration.borderRadius,
          const BorderRadius.all(Radius.circular(18)),
        );

        final icon = tester.widget<AnimatedContainer>(animated.at(1));
        expect(tester.getSize(animated.at(1)), const Size(42, 42));
        final iconDecoration = icon.decoration! as BoxDecoration;
        expect(
          iconDecoration.borderRadius,
          const BorderRadius.all(Radius.circular(14)),
        );

        expect(tester.widget<Text>(find.text('FAN')).style?.fontSize, 13.0);
        expect(
          tester.widget<Text>(find.text('Cooling output')).style?.fontSize,
          10.5,
        );
        expect(tester.widget<Text>(find.text('ON')).style?.fontSize, 10.0);

        final target = find.bySemanticsLabel('Fan, Cooling output');
        expect(target, findsOneWidget);
        final data = tester.getSemantics(target).getSemanticsData();
        expect(data.flagsCollection.isToggled, isNot(ui.Tristate.none));
        expect(data.flagsCollection.isToggled, ui.Tristate.isTrue);
        expect(data.flagsCollection.isEnabled, ui.Tristate.isTrue);
        expect(data.hasAction(ui.SemanticsAction.tap), isTrue);

        await tester.tap(target);
        await tester.pump();
        expect(changedValues, <bool>[false]);
      } finally {
        semantics.dispose();
      }
    },
  );
}
