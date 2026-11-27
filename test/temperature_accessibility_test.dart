import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/main.dart';

void main() {
  testWidgets(
    'Temperature limit controls expose localized action semantics and 48 dp hitboxes',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;

      final previousLanguage = appLanguageNotifier.value;
      addTearDown(() => appLanguageNotifier.value = previousLanguage);
      appLanguageNotifier.value = AppLanguage.english;

      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(useMaterial3: true),
            home: const DashboardScreen(),
          ),
        );
        await tester.pump();

        final dynamic dashboardState = tester.state(
          find.byType(DashboardScreen),
        );
        dashboardState.setState(() {
          dashboardState.connected = true;
          dashboardState.tabIndex = 4;
        });
        await tester.pump(const Duration(milliseconds: 200));

        final decrease = find.bySemanticsLabel('Decrease Hotside Limit');
        final increase = find.bySemanticsLabel('Increase Hotside Limit');
        expect(decrease, findsOneWidget);
        expect(increase, findsOneWidget);

        for (final finder in [decrease, increase]) {
          final node = tester.getSemantics(finder);
          final data = node.getSemanticsData();
          expect(data.label, isNotEmpty);
          expect(data.hasAction(SemanticsAction.tap), isTrue);
          expect(tester.getSize(finder), const Size(48, 48));
        }
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );
}
