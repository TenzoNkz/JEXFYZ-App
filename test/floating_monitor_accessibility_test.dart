import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/floating_monitor.dart';

void main() {
  testWidgets(
    'stateless Floating Monitor sliders expose localized values across viewport and theme',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final width in [350.0, 420.0]) {
        for (final language in [AppLanguage.english, AppLanguage.indonesia]) {
          for (final brightness in [Brightness.light, Brightness.dark]) {
            tester.view.physicalSize = Size(width * 3, 2400);
            tester.view.devicePixelRatio = 3;
            await tester.pumpWidget(
              MaterialApp(
                theme: ThemeData(brightness: brightness, useMaterial3: true),
                home: FloatingSettingsView(
                  config: const FloatingConfig(enabled: true),
                  language: language,
                  onEnabledChanged: (_) {},
                  onMetricChanged: (_, _) {},
                  onReorder: (_, _) {},
                  onSizeChanged: (_) {},
                  onOpacityChanged: (_) {},
                  onBackgroundColorChanged: (_) {},
                  onOrientationChanged: (_) {},
                ),
              ),
            );

            final semantics = tester.ensureSemantics();
            try {
              final sizeLabel = language == AppLanguage.english
                  ? 'Size'
                  : 'Ukuran';
              final opacityLabel = language == AppLanguage.english
                  ? 'Opacity'
                  : 'Transparansi';
              final formattedSizeValue = JexText.formatNumber(
                0.6,
                language,
                decimalDigits: 2,
                groupThousands: false,
              );
              final sizeValue = '$formattedSizeValue×';

              final sizeFinder = find.bySemanticsLabel(sizeLabel);
              final opacityFinder = find.bySemanticsLabel(opacityLabel);
              expect(sizeFinder, findsOneWidget);
              expect(opacityFinder, findsOneWidget);

              final sizeData = tester
                  .getSemantics(sizeFinder)
                  .getSemanticsData();
              final opacityData = tester
                  .getSemantics(opacityFinder)
                  .getSemanticsData();
              for (final data in [sizeData, opacityData]) {
                expect(data.hasFlag(SemanticsFlag.isSlider), isTrue);
                expect(data.hasFlag(SemanticsFlag.isEnabled), isTrue);
                expect(data.hasAction(SemanticsAction.increase), isTrue);
                expect(data.hasAction(SemanticsAction.decrease), isTrue);
              }
              expect(sizeData.value, sizeValue);
              expect(opacityData.value, '90%');
              expect(
                tester.getSize(sizeFinder).height,
                greaterThanOrEqualTo(48),
              );
              expect(
                tester.getSize(opacityFinder).height,
                greaterThanOrEqualTo(48),
              );
              expect(
                tester.takeException(),
                isNull,
                reason: 'Slider layout failed at $width dp',
              );
            } finally {
              semantics.dispose();
            }

            await tester.pumpWidget(const SizedBox.shrink());
          }
        }
      }
    },
  );
}
