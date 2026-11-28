import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/led_controls.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

void main() {
  testWidgets(
    'LED mode arrows expose localized 48 dp actions and preserve compact plates',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final previousLanguage = appLanguageNotifier.value;
      var previousCalls = 0;
      var nextCalls = 0;

      addTearDown(() {
        semantics.dispose();
        appLanguageNotifier.value = previousLanguage;
      });

      Widget host({
        required bool previousEnabled,
        required bool nextEnabled,
        required double width,
        required ThemeData theme,
      }) {
        return MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: width,
                child: JexLedStripPreview(
                  mode: 1,
                  colorHex: '#FFFFFF',
                  active: false,
                  ledPhaseMs: 0,
                  ledCycleMs: 1000,
                  ledSyncRevision: 0,
                  modeName: 'STATIC',
                  previousEnabled: previousEnabled,
                  nextEnabled: nextEnabled,
                  onPrevious: () => previousCalls++,
                  onNext: () => nextCalls++,
                ),
              ),
            ),
          ),
        );
      }

      appLanguageNotifier.value = AppLanguage.english;
      await tester.pumpWidget(
        host(
          previousEnabled: true,
          nextEnabled: true,
          width: 350,
          theme: ThemeData.light(),
        ),
      );

      final previous = find.bySemanticsLabel('Previous LED mode');
      final next = find.bySemanticsLabel('Next LED mode');
      expect(previous, findsOneWidget);
      expect(next, findsOneWidget);
      expect(
        tester.getSize(find.byType(JexLedStripPreview)),
        const Size(350, 58),
      );
      for (final target in [previous, next]) {
        expect(tester.getSize(target), const Size(48, 48));
        final data = tester.getSemantics(target).getSemanticsData();
        expect(data.hasFlag(ui.SemanticsFlag.isButton), isTrue);
        expect(data.hasFlag(ui.SemanticsFlag.isEnabled), isTrue);
        expect(data.hasAction(ui.SemanticsAction.tap), isTrue);
      }

      final previousPlate = find.ancestor(
        of: find.byIcon(PhosphorIconsBold.caretLeft),
        matching: find.byType(Container),
      ).first;
      final nextPlate = find.ancestor(
        of: find.byIcon(PhosphorIconsBold.caretRight),
        matching: find.byType(Container),
      ).first;
      expect(tester.getSize(previousPlate), const Size(29, 34));
      expect(tester.getSize(nextPlate), const Size(29, 34));

      final previousTooltip = find.ancestor(
        of: find.byIcon(PhosphorIconsBold.caretLeft),
        matching: find.byType(Tooltip),
      ).first;
      expect(
        tester.widget<Tooltip>(previousTooltip).message,
        'Previous LED mode',
      );

      await tester.tap(previous);
      await tester.pump();
      await tester.tap(next);
      await tester.pump();
      expect(previousCalls, 1);
      expect(nextCalls, 1);

      appLanguageNotifier.value = AppLanguage.indonesia;
      await tester.pumpWidget(
        host(
          previousEnabled: true,
          nextEnabled: true,
          width: 420,
          theme: ThemeData.dark(),
        ),
      );
      final previousIndonesian = find.bySemanticsLabel(
        'Mode LED sebelumnya',
      );
      final nextIndonesian = find.bySemanticsLabel('Mode LED berikutnya');
      expect(previousIndonesian, findsOneWidget);
      expect(nextIndonesian, findsOneWidget);
      expect(
        tester.getSize(find.byType(JexLedStripPreview)),
        const Size(420, 58),
      );

      await tester.pumpWidget(
        host(
          previousEnabled: false,
          nextEnabled: false,
          width: 420,
          theme: ThemeData.dark(),
        ),
      );
      final previousDisabled = find.bySemanticsLabel(
        'Mode LED sebelumnya',
      );
      final nextDisabled = find.bySemanticsLabel('Mode LED berikutnya');
      for (final target in [previousDisabled, nextDisabled]) {
        expect(target, findsOneWidget);
        expect(tester.getSize(target), const Size(48, 48));
        final data = tester.getSemantics(target).getSemanticsData();
        expect(data.hasFlag(ui.SemanticsFlag.isButton), isTrue);
        expect(data.hasFlag(ui.SemanticsFlag.isEnabled), isFalse);
        expect(data.hasAction(ui.SemanticsAction.tap), isFalse);
      }

      await tester.tap(previousDisabled, warnIfMissed: false);
      await tester.tap(nextDisabled, warnIfMissed: false);
      await tester.pump();
      expect(previousCalls, 1);
      expect(nextCalls, 1);
      expect(tester.takeException(), isNull);
    },
  );
}
