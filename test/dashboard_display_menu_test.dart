import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/dashboard_display_menu.dart';

void main() {
  Widget host(JexDashboardLockedMenu child, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? ThemeData.light(),
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
  }) {
    return JexDashboardLockedMenu(
      content: content,
      reason: reason,
      tabIndex: tabIndex,
      voltage: voltage,
      language: language,
    );
  }

  testWidgets(
    'Disconnected lock keeps its card informational and blocks submenu input',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var contentTapCalls = 0;

      try {
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
        expect(find.text('Submenu content'), findsOneWidget);
        expect(find.bySemanticsLabel('Submenu content'), findsNothing);
        expect(
          find.bySemanticsLabel('CONNECT YOUR DEVICE FIRST'),
          findsOneWidget,
        );
        expect(find.text('Connect'), findsNothing);
        expect(find.text('Hubungkan'), findsNothing);
        expect(find.byType(TextButton), findsNothing);
        expect(find.byType(IconButton), findsNothing);

        final blockingAncestors = find
            .ancestor(
              of: find.text('Submenu content'),
              matching: find.byType(IgnorePointer),
            )
            .evaluate()
            .where((element) => (element.widget as IgnorePointer).ignoring)
            .toList();
        expect(blockingAncestors, hasLength(1));

        await tester.tap(find.text('Submenu content'), warnIfMissed: false);
        await tester.pump();
        expect(contentTapCalls, 0);
      } finally {
        semantics.dispose();
      }
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

  testWidgets('Lock Voltage on Adaptive tab uses logical inactive copy', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        menu(
          reason: DisplayMenuLockReason.voltageLocked,
          tabIndex: 2,
          voltage: '5V',
          language: AppLanguage.english,
        ),
      ),
    );

    expect(find.text('ADAPTIVE MODE DISABLED'), findsOneWidget);
    expect(
      find.text(
        'Adaptive Mode is forced inactive while Lock Voltage is active.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Mode Adaptif dipaksa nonaktif selama Kunci Tegangan aktif.'),
      findsNothing,
    );

    await tester.pumpWidget(
      host(
        menu(
          reason: DisplayMenuLockReason.voltageLocked,
          tabIndex: 2,
          voltage: '5V',
          language: AppLanguage.indonesia,
        ),
      ),
    );

    expect(find.text('MODE ADAPTIF DINONAKTIFKAN'), findsOneWidget);
    expect(
      find.text('Mode Adaptif dipaksa nonaktif selama Kunci Tegangan aktif.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Adaptive Mode is forced inactive while Lock Voltage is active.',
      ),
      findsNothing,
    );
    expect(find.byType(TextButton), findsNothing);
  });

  testWidgets(
    'Disconnected lock remains action-free across width, locale and theme',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final semantics = tester.ensureSemantics();

      try {
        for (final width in [350.0, 420.0]) {
          for (final language in AppLanguage.values) {
            for (final preset in [AppThemePreset.light, AppThemePreset.dark]) {
              tester.view.physicalSize = Size(width * 3, 2400);
              tester.view.devicePixelRatio = 3;

              await tester.pumpWidget(
                host(
                  menu(
                    reason: DisplayMenuLockReason.bluetoothDisconnected,
                    language: language,
                  ),
                  theme: buildJexTheme(preset),
                ),
              );
              await tester.pumpAndSettle();

              final title = language == AppLanguage.english
                  ? 'CONNECT YOUR DEVICE FIRST'
                  : 'HUBUNGKAN PERANGKAT TERLEBIH DAHULU';
              final detail = language == AppLanguage.english
                  ? 'Connect your device to use this menu.'
                  : 'Hubungkan perangkat untuk menggunakan menu ini.';
              final contextLabel = '$width dp / $language / $preset';

              expect(find.text(title), findsOneWidget, reason: contextLabel);
              expect(find.text(detail), findsOneWidget, reason: contextLabel);
              expect(find.bySemanticsLabel(title), findsOneWidget);
              expect(
                find.bySemanticsLabel('Submenu content'),
                findsNothing,
                reason: contextLabel,
              );
              expect(find.text('Connect'), findsNothing, reason: contextLabel);
              expect(
                find.text('Hubungkan'),
                findsNothing,
                reason: contextLabel,
              );
              expect(find.byType(TextButton), findsNothing);
              expect(find.byType(IconButton), findsNothing);

              final titleRect = tester.getRect(find.text(title));
              final detailRect = tester.getRect(find.text(detail));
              expect(titleRect.left, greaterThanOrEqualTo(0));
              expect(titleRect.right, lessThanOrEqualTo(width));
              expect(detailRect.left, greaterThanOrEqualTo(0));
              expect(detailRect.right, lessThanOrEqualTo(width));
              expect(titleRect.bottom, lessThan(detailRect.top));
              expect(detailRect.bottom, lessThanOrEqualTo(800));
              expect(tester.takeException(), isNull, reason: contextLabel);
            }
          }
        }
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets('Disconnected lock remains informational in Indonesian', (
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
    expect(find.text('Hubungkan'), findsNothing);
    expect(find.text('Connect'), findsNothing);
    expect(find.byType(TextButton), findsNothing);
    expect(find.byType(IconButton), findsNothing);
  });
}