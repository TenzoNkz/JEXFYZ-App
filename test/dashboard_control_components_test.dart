import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/main.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

void main() {
  testWidgets(
    'Dashboard switch keeps unknown telemetry disabled and untoggled',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final attemptedValues = <bool>[];

      try {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: Center(
                child: JexDashboardSwitchRow(
                  title: 'Fan',
                  subtitle: 'Cooling output',
                  icon: PhosphorIconsRegular.fan,
                  // A stale ON value is deliberately supplied to prove that the
                  // state-known gate, not the cached value, controls semantics.
                  value: true,
                  enabled: false,
                  stateKnown: false,
                  connected: false,
                  language: AppLanguage.english,
                  onChanged: (next) async => attemptedValues.add(next),
                ),
              ),
            ),
          ),
        );

        final target = find.bySemanticsLabel('Fan, Cooling output');
        expect(target, findsOneWidget);
        final data = tester.getSemantics(target).getSemanticsData();
        expect(data.flagsCollection.isToggled, ui.Tristate.none);
        expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);
        expect(data.hasAction(ui.SemanticsAction.tap), isFalse);
        expect(find.text('OFF'), findsOneWidget);

        await tester.tap(target);
        await tester.pump();
        expect(attemptedValues, isEmpty);
      expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'Adaptive profile semantics retain selection without enabling locked choice',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var lockedCalls = 0;
      var enabledCalls = 0;

      try {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: Column(
                children: [
                  JexAdaptiveProfileChoice(
                    title: 'Hotside',
                    icon: Icons.thermostat,
                    selected: true,
                    locked: true,
                    enabled: false,
                    onTap: () => lockedCalls++,
                  ),
                  JexAdaptiveProfileChoice(
                    title: 'Hotside + Battery',
                    icon: Icons.battery_full,
                    selected: false,
                    locked: false,
                    enabled: true,
                    onTap: () => enabledCalls++,
                  ),
                ],
              ),
            ),
          ),
        );

        final locked = find.bySemanticsLabel('Hotside');
        expect(locked, findsOneWidget);
        final lockedData = tester.getSemantics(locked).getSemanticsData();
        expect(lockedData.hasFlag(ui.SemanticsFlag.isButton), isTrue);
        expect(lockedData.hasFlag(ui.SemanticsFlag.isSelected), isTrue);
        expect(lockedData.hasFlag(ui.SemanticsFlag.isEnabled), isFalse);
        expect(lockedData.hasAction(ui.SemanticsAction.tap), isFalse);

        final enabled = find.bySemanticsLabel('Hotside + Battery');
        expect(enabled, findsOneWidget);
        final enabledData = tester.getSemantics(enabled).getSemanticsData();
        expect(enabledData.hasFlag(ui.SemanticsFlag.isButton), isTrue);
        expect(enabledData.hasFlag(ui.SemanticsFlag.isSelected), isFalse);
        expect(enabledData.hasFlag(ui.SemanticsFlag.isEnabled), isTrue);
        expect(enabledData.hasAction(ui.SemanticsAction.tap), isTrue);

        await tester.tap(locked);
        await tester.pump();
        await tester.tap(enabled);
        await tester.pump();
        expect(lockedCalls, 0);
        expect(enabledCalls, 1);
      expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );

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
