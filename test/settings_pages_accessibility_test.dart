import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/floating_monitor.dart';

void main() {
  testWidgets(
    'Settings root and preference pages remain legible across width, locale and theme',
    (tester) async {
      final previousLanguage = appLanguageNotifier.value;
      final previousTheme = appThemeNotifier.value;
      final previousAutoConnect = appAutoConnectNotifier.value;
      final previousNotifySafety = appNotifySafetyNotifier.value;
      final previousNotifyFirmware = appNotifyFirmwareNotifier.value;
      final previousNotifyBluetooth = appNotifyBluetoothNotifier.value;
      final previousVoltageLock = voltageLockSettingsNotifier.value;
      final previousFloatingConfig = floatingConfigNotifier.value;

      addTearDown(() {
        appLanguageNotifier.value = previousLanguage;
        appThemeNotifier.value = previousTheme;
        appAutoConnectNotifier.value = previousAutoConnect;
        appNotifySafetyNotifier.value = previousNotifySafety;
        appNotifyFirmwareNotifier.value = previousNotifyFirmware;
        appNotifyBluetoothNotifier.value = previousNotifyBluetooth;
        voltageLockSettingsNotifier.value = previousVoltageLock;
        floatingConfigNotifier.value = previousFloatingConfig;
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      for (final width in [350.0, 420.0]) {
        for (final language in AppLanguage.values) {
          for (final preset in [
            AppThemePreset.light,
            AppThemePreset.dark,
          ]) {
            tester.view.physicalSize = Size(width * 3, 2400);
            tester.view.devicePixelRatio = 3;
            appLanguageNotifier.value = language;
            appThemeNotifier.value = preset;
            appAutoConnectNotifier.value = false;
            appNotifySafetyNotifier.value = true;
            appNotifyFirmwareNotifier.value = true;
            appNotifyBluetoothNotifier.value = true;
            voltageLockSettingsNotifier.value =
                const VoltageLockSettingsState();
            floatingConfigNotifier.value = const FloatingConfig();

            Future<void> pumpSettingsPage(Widget page) async {
              await tester.pumpWidget(
                MaterialApp(
                  theme: buildJexTheme(preset),
                  home: JexFixedScalePage(
                    compactUi: true,
                    child: page,
                  ),
                ),
              );
              await tester.pumpAndSettle();
            }

            await pumpSettingsPage(
              SettingsPage(
                currentFirmwareVersion: 'V7.2',
                coolerId: 'AA:BB:CC',
                onOpenFirmwareUpdate: () async {},
                onVoltageLockChanged: (_) async {},
              ),
            );

            final rootLabels = <String>[
              JexText.of('settings', language),
              JexText.of('language', language),
              JexText.of('appearance', language),
              JexText.of('notifications', language),
              JexText.of('bluetooth', language),
              JexText.of('floatingMonitor', language),
              JexText.phrase(
                'Usage Statistics',
                'Statistik Penggunaan',
                language,
              ),
              JexText.of('firmwareUpdate', language),
              JexText.of('about', language),
            ];
            for (final label in rootLabels) {
              expect(
                find.text(label),
                findsOneWidget,
                reason:
                    'Missing Settings content at $width dp / $language / $preset.',
              );
            }

            for (final label in rootLabels.skip(1)) {
              final row = find
                  .ancestor(
                    of: find.text(label),
                    matching: find.byType(InkWell),
                  )
                  .first;
              expect(
                tester.getSize(row).height,
                greaterThanOrEqualTo(48),
                reason:
                    'Settings action target is too short at $width dp / $language / $preset: $label.',
              );
            }
            expect(
              tester.takeException(),
              isNull,
              reason:
                  'Settings root layout failed at $width dp / $language / $preset.',
            );

            await pumpSettingsPage(const AboutSettingsPage());
            expect(
              find.text(JexText.of('about', language)),
              findsOneWidget,
            );
            expect(
              find.text(
                JexText.phrase(
                  'Special Thanks',
                  'Ucapan Terima Kasih',
                  language,
                ),
              ),
              findsOneWidget,
            );
            expect(find.text('Horizon'), findsOneWidget);
            expect(find.text('FYZ'), findsOneWidget);
            expect(find.text('Logos'), findsOneWidget);

            await pumpSettingsPage(const LanguageSettingsPage());
            expect(
              find.text(JexText.of('language', language)),
              findsOneWidget,
            );
            expect(
              find.text(JexText.of('languageEnglish', language)),
              findsOneWidget,
            );
            expect(
              find.text(JexText.of('languageIndonesia', language)),
              findsOneWidget,
            );

            await pumpSettingsPage(const AppearanceSettingsPage());
            expect(
              find.text(JexText.of('appearance', language)),
              findsOneWidget,
            );
            for (final key in ['default', 'light', 'dark']) {
              expect(find.text(JexText.of(key, language)), findsOneWidget);
            }

            await pumpSettingsPage(const NotificationsSettingsPage());
            expect(
              find.text(JexText.of('notifications', language)),
              findsOneWidget,
            );
            for (final key in [
              'safetyAlert',
              'firmwareUpdate',
              'deviceConnectionNotifications',
            ]) {
              expect(find.text(JexText.of(key, language)), findsOneWidget);
            }
            expect(find.byType(SwitchListTile), findsNWidgets(3));

            await pumpSettingsPage(const BluetoothSettingsPage());
            expect(
              find.text(JexText.of('bluetooth', language)),
              findsOneWidget,
            );
            expect(
              find.text(JexText.of('autoConnect', language)),
              findsOneWidget,
            );
            expect(find.byType(SwitchListTile), findsOneWidget);
            expect(
              tester.takeException(),
              isNull,
              reason:
                  'Settings subpage layout failed at $width dp / $language / $preset.',
            );
          }
        }
      }
    },
  );
}
