import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/floating_monitor.dart';

void main() {
  testWidgets(
    'Floating Monitor sliders expose localized names and formatted values',
    (tester) async {
      final previousLanguage = appLanguageNotifier.value;
      final previousConfig = floatingConfigNotifier.value;
      final previousTelemetry = floatingTelemetryNotifier.value;
      addTearDown(() {
        appLanguageNotifier.value = previousLanguage;
        floatingConfigNotifier.value = previousConfig;
        floatingTelemetryNotifier.value = previousTelemetry;
        FlutterSecureStorage.setMockInitialValues(<String, String>{});
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      for (final width in [350.0, 420.0]) {
        for (final language in [AppLanguage.english, AppLanguage.indonesia]) {
          for (final brightness in [Brightness.light, Brightness.dark]) {
            appLanguageNotifier.value = language;
            floatingTelemetryNotifier.value = const FloatingTelemetry();
            FlutterSecureStorage.setMockInitialValues(<String, String>{});
            // Load a disabled preference so no native runtime call can be made.
            // Expose the controls through widget state only after loading completes.
            await FloatingStore.save(const FloatingConfig());

            tester.view.physicalSize = Size(width * 3, 2400);
            tester.view.devicePixelRatio = 3;
            await tester.pumpWidget(
              MaterialApp(
                theme: ThemeData(brightness: brightness, useMaterial3: true),
                home: const FloatingSettingsPage(),
              ),
            );
            // Advance bounded frames: the settings route is not required to settle.
            for (var frame = 0; frame < 6; frame++) {
              await tester.pump(const Duration(milliseconds: 100));
            }
            expect(find.byType(CircularProgressIndicator), findsNothing);

            final dynamic settingsState = tester.state(
              find.byType(FloatingSettingsPage),
            );
            settingsState.setState(() {
              settingsState.config = settingsState.config.copyWith(
                enabled: true,
              );
            });
            await tester.pump();

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
