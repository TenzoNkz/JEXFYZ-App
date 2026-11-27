import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/dashboard_display_menu.dart';

void main() {
  Widget host(JexDashboardLockedMenu child) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(body: child),
    );
  }

  JexDashboardLockedMenu menu({
    required DisplayMenuLockReason reason,
    int tabIndex = 0,
    String voltage = '--',
    AppLanguage language = AppLanguage.english,
    Widget content = const Align(
      alignment: Alignment.topLeft,
      child: Text('Submenu content'),
    ),
    VoidCallback onConnect = _noConnect,
  }) {
    return JexDashboardLockedMenu(
      content: content,
      reason: reason,
      tabIndex: tabIndex,
      voltage: voltage,
      language: language,
      onConnect: onConnect,
    );
  }

  testWidgets(
    'Disconnected lock blocks submenu input and uses the Dashboard Connect action',
    (tester) async {
      var connectCalls = 0;
      var contentTapCalls = 0;

      await tester.pumpWidget(
        host(
          menu(
            reason: DisplayMenuLockReason.bluetoothDisconnected,
            content: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => contentTapCalls++,
                child: const Text('Submenu content'),
              ),
            ),
            onConnect: () => connectCalls++,
          ),
        ),
      );

      expect(find.text('CONNECT YOUR DEVICE FIRST'), findsOneWidget);
      expect(
        find.text('Connect your device to use this menu.'),
        findsOneWidget,
      );
      expect(find.byType(ClipRect), findsOneWidget);
      expect(find.byType(ImageFiltered), findsOneWidget);
      final blockingAncestors = find
          .ancestor(
            of: find.text('Submenu content'),
            matching: find.byType(IgnorePointer),
          )
          .evaluate()
          .where((element) => (element.widget as IgnorePointer).ignoring)
          .toList();
      expect(blockingAncestors, hasLength(1));

      final connectButton = find.ancestor(
        of: find.text('Connect'),
        matching: find.byType(TextButton),
      );
      expect(connectButton, findsOneWidget);
      expect(tester.getSize(connectButton).height, greaterThanOrEqualTo(48));

      await tester.tap(find.text('Submenu content'));
      await tester.pump();
      expect(contentTapCalls, 0);

      await tester.tap(find.text('Connect'));
      await tester.pump();
      expect(connectCalls, 1);
    },
  );

  testWidgets(
    'Adaptive lock keeps its existing copy and has no Connect action',
    (tester) async {
      await tester.pumpWidget(
        host(menu(reason: DisplayMenuLockReason.adaptiveActive, tabIndex: 1)),
      );

      expect(find.text('LOCKED BY ADAPTIVE MODE'), findsOneWidget);
      expect(
        find.text('Turn Adaptive Mode off to edit these settings.'),
        findsOneWidget,
      );
      expect(find.byType(TextButton), findsNothing);
    },
  );

  testWidgets('Lock Voltage copy reports 5V only after matching telemetry', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        menu(
          reason: DisplayMenuLockReason.voltageLocked,
          tabIndex: 0,
          voltage: '5V',
        ),
      ),
    );

    expect(find.text('VOLTAGE LOCKED AT 5V'), findsOneWidget);
    expect(
      find.text(
        'The device confirms the 5V rail. Higher voltage selections are locked.',
      ),
      findsOneWidget,
    );

    await tester.pumpWidget(
      host(
        menu(
          reason: DisplayMenuLockReason.voltageLocked,
          tabIndex: 0,
          voltage: '9V',
        ),
      ),
    );

    expect(find.text('RETURNING TO 5V'), findsOneWidget);
    expect(
      find.text(
        'The voltage lock is active. The device is safely returning from 9V to 5V.',
      ),
      findsOneWidget,
    );
    expect(find.text('VOLTAGE LOCKED AT 5V'), findsNothing);
  });

  testWidgets('Lock Voltage on Adaptive tab keeps the Adaptive-disabled copy', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        menu(
          reason: DisplayMenuLockReason.voltageLocked,
          tabIndex: 2,
          voltage: '5V',
        ),
      ),
    );

    expect(find.text('ADAPTIVE MODE DISABLED'), findsOneWidget);
    expect(
      find.text('Adaptive Mode is forced OFF while Lock Voltage is active.'),
      findsOneWidget,
    );
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets('Disconnected lock copy and Connect action are Indonesian', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        menu(
          reason: DisplayMenuLockReason.bluetoothDisconnected,
          language: AppLanguage.indonesia,
        ),
      ),
    );

    expect(find.text('HUBUNGKAN PERANGKAT TERLEBIH DAHULU'), findsOneWidget);
    expect(
      find.text('Hubungkan perangkat untuk menggunakan menu ini.'),
      findsOneWidget,
    );
    expect(find.text('Hubungkan'), findsOneWidget);
    expect(find.text('Connect'), findsNothing);
  });
}

void _noConnect() {}
