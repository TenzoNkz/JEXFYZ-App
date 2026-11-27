// AI-MEMORY / FILE CONTRACT
// App root shell only. It owns top-level theme composition and receives the already-built
// Dashboard widget from main.dart so it does not import or own device/BLE session state.
// Theme and locale listenables remain owned by app_settings.dart.

import 'package:flutter/material.dart';

import 'app_settings.dart';

const String appName = 'JE Cooler';

/// Composes the verified App shell around the Dashboard supplied by the entry point.
///
/// Dashboard construction stays at the App composition boundary; this module has no BLE,
/// GATT, P1, persistence, OTA or platform-channel responsibilities.
class JeCoolerApp extends StatelessWidget {
  final Widget dashboard;

  const JeCoolerApp({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemePreset>(
      valueListenable: appThemeNotifier,
      builder: (context, preset, _) => ValueListenableBuilder<AppLanguage>(
        valueListenable: appLanguageNotifier,
        builder: (context, _, __) => MaterialApp(
          title: appName,
          debugShowCheckedModeBanner: false,
          theme: buildJexTheme(preset),
          home: Theme(
            data: buildJexTheme(
              preset == AppThemePreset.defaultTheme
                  ? AppThemePreset.light
                  : preset,
            ),
            child: dashboard,
          ),
        ),
      ),
    );
  }
}
