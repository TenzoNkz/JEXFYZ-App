import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/main.dart';

void main() {
  testWidgets(
    'Temperature controls expose English semantics and 48 dp hitboxes',
    (tester) async {
      _resetViewAfterTest(tester);
      final previousLanguage = appLanguageNotifier.value;
      addTearDown(() => appLanguageNotifier.value = previousLanguage);

      await _pumpTemperatureTab(
        tester,
        language: AppLanguage.english,
        brightness: Brightness.dark,
      );

      final semantics = tester.ensureSemantics();
      try {
        for (final label in [
          'Decrease Hotside Limit',
          'Increase Hotside Limit',
          'Decrease 5 V Battery Temperature Ceiling',
          'Increase 5 V Battery Temperature Ceiling',
          'Decrease 12 V Battery Temperature Floor',
          'Increase 12 V Battery Temperature Floor',
        ]) {
          _expectTemperatureAction(tester, label, enabled: true);
        }
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets('Temperature control action labels are localized in Indonesian', (
    tester,
  ) async {
    _resetViewAfterTest(tester);
    final previousLanguage = appLanguageNotifier.value;
    addTearDown(() => appLanguageNotifier.value = previousLanguage);

    await _pumpTemperatureTab(
      tester,
      language: AppLanguage.indonesia,
      brightness: Brightness.light,
      logicalWidth: 420,
    );

    final semantics = tester.ensureSemantics();
    try {
      for (final label in [
        'Kurangi Batas Suhu Sisi Panas',
        'Tambah Batas Suhu Sisi Panas',
        'Kurangi Batas atas suhu baterai pada 5 V',
        'Tambah Batas atas suhu baterai pada 5 V',
        'Kurangi Batas bawah suhu baterai pada 12 V',
        'Tambah Batas bawah suhu baterai pada 12 V',
      ]) {
        _expectTemperatureAction(tester, label, enabled: true);
      }
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets(
    'Temperature actions disable at range endpoints and the 2 degree zone gap',
    (tester) async {
      _resetViewAfterTest(tester);
      final previousLanguage = appLanguageNotifier.value;
      addTearDown(() => appLanguageNotifier.value = previousLanguage);

      final dynamic dashboardState = await _pumpTemperatureTab(
        tester,
        language: AppLanguage.english,
        brightness: Brightness.dark,
      );
      final semantics = tester.ensureSemantics();
      try {
        dashboardState.setState(() {
          dashboardState.hotLimitDraft = 40;
          dashboardState.battery5Limit = 20;
          dashboardState.battery5Draft = 20;
          dashboardState.battery12Limit = 30;
          dashboardState.battery12Draft = 30;
        });
        await tester.pump(const Duration(milliseconds: 200));

        for (final label in [
          'Decrease Hotside Limit',
          'Decrease 5 V Battery Temperature Ceiling',
          'Decrease 12 V Battery Temperature Floor',
        ]) {
          _expectTemperatureAction(tester, label, enabled: false);
        }
        for (final label in [
          'Increase Hotside Limit',
          'Increase 5 V Battery Temperature Ceiling',
          'Increase 12 V Battery Temperature Floor',
        ]) {
          _expectTemperatureAction(tester, label, enabled: true);
        }

        dashboardState.setState(() {
          dashboardState.hotLimitDraft = 50;
          dashboardState.battery5Limit = 30;
          dashboardState.battery5Draft = 30;
          dashboardState.battery12Limit = 40;
          dashboardState.battery12Draft = 40;
        });
        await tester.pump(const Duration(milliseconds: 200));

        for (final label in [
          'Increase Hotside Limit',
          'Increase 5 V Battery Temperature Ceiling',
          'Increase 12 V Battery Temperature Floor',
        ]) {
          _expectTemperatureAction(tester, label, enabled: false);
        }
        for (final label in [
          'Decrease Hotside Limit',
          'Decrease 5 V Battery Temperature Ceiling',
          'Decrease 12 V Battery Temperature Floor',
        ]) {
          _expectTemperatureAction(tester, label, enabled: true);
        }

        dashboardState.setState(() {
          dashboardState.battery5Limit = 29;
          dashboardState.battery5Draft = 29;
          dashboardState.battery12Limit = 31;
          dashboardState.battery12Draft = 31;
        });
        await tester.pump(const Duration(milliseconds: 200));

        _expectTemperatureAction(
          tester,
          'Increase 5 V Battery Temperature Ceiling',
          enabled: false,
        );
        _expectTemperatureAction(
          tester,
          'Decrease 12 V Battery Temperature Floor',
          enabled: false,
        );
        _expectTemperatureAction(
          tester,
          'Decrease 5 V Battery Temperature Ceiling',
          enabled: true,
        );
        _expectTemperatureAction(
          tester,
          'Increase 12 V Battery Temperature Floor',
          enabled: true,
        );
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );
}

void _resetViewAfterTest(WidgetTester tester) {
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<dynamic> _pumpTemperatureTab(
  WidgetTester tester, {
  required AppLanguage language,
  required Brightness brightness,
  double logicalWidth = 360,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  appLanguageNotifier.value = AppLanguage.english;

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: brightness, useMaterial3: true),
      home: const DashboardScreen(),
    ),
  );
  await tester.pump();

  final dynamic dashboardState = tester.state(find.byType(DashboardScreen));
  dashboardState.setState(() {
    dashboardState.connected = true;
    dashboardState.tabIndex = 4;
  });
  tester.view.physicalSize = Size(logicalWidth * 3, 2400);
  appLanguageNotifier.value = language;
  await tester.pump(const Duration(milliseconds: 200));
  return dashboardState;
}

void _expectTemperatureAction(
  WidgetTester tester,
  String label, {
  required bool enabled,
}) {
  final finder = find.bySemanticsLabel(label);
  expect(finder, findsOneWidget, reason: 'Missing Temperature action: $label');

  final data = tester.getSemantics(finder).getSemanticsData();
  expect(
    data.hasFlag(SemanticsFlag.isEnabled),
    enabled,
    reason: 'Unexpected enabled state for Temperature action: $label',
  );
  expect(
    data.hasAction(SemanticsAction.tap),
    enabled,
    reason: 'Unexpected tap action for Temperature control: $label',
  );
  expect(
    tester.getSize(finder),
    const Size(48, 48),
    reason: 'Temperature action must retain its 48 × 48 dp hitbox: $label',
  );
}
