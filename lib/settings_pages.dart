// AI-MEMORY / FILE CONTRACT
// App Settings navigation and preference subpages.
// This library part shares the existing Settings/Floating UI dependencies and private helpers;
// it does not own BLE/GATT, native overlay state, or persisted storage identity.

part of 'floating_monitor.dart';

// AI-MEMORY / SETTINGS-CONTAINER-CONTRACT
// Hosts the Settings navigation hierarchy and delegates persisted preferences to AppSettingsStore.
class SettingsPage extends StatelessWidget {
  final String currentFirmwareVersion;
  final String? coolerId;
  final int hotLimit;
  final Future<void> Function() onOpenFirmwareUpdate;
  final Future<void> Function(bool enabled) onVoltageLockChanged;

  const SettingsPage({
    super.key,
    required this.currentFirmwareVersion,
    this.coolerId,
    this.hotLimit = 45,
    required this.onOpenFirmwareUpdate,
    required this.onVoltageLockChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) {
        final preset = appThemeNotifier.value;
        return Theme(
          data: buildJexCompactUiTheme(preset),
          child: Scaffold(
            appBar: AppBar(title: Text(JexText.of('settings', language))),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 28),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ValueListenableBuilder<VoltageLockSettingsState>(
                    valueListenable: voltageLockSettingsNotifier,
                    builder: (context, state, _) =>
                        _voltageLockSettingRow(context, language, state),
                  ),
                ),
                _section(context, JexText.of('general', language), [
                  _item(
                    context,
                    PhosphorIconsRegular.translate,
                    JexText.of('language', language),
                    language == AppLanguage.english
                        ? JexText.of('languageEnglish', language)
                        : JexText.of('languageIndonesia', language),
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const JexFixedScalePage(
                          compactUi: true,
                          child: LanguageSettingsPage(),
                        ),
                      ),
                    ),
                  ),
                  _item(
                    context,
                    PhosphorIconsRegular.sun,
                    JexText.of('appearance', language),
                    JexText.of(switch (appThemeNotifier.value) {
                      AppThemePreset.defaultTheme => 'default',
                      AppThemePreset.light => 'light',
                      AppThemePreset.dark => 'dark',
                    }, language),
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const JexFixedScalePage(
                          compactUi: true,
                          child: AppearanceSettingsPage(),
                        ),
                      ),
                    ),
                  ),
                  _item(
                    context,
                    PhosphorIconsRegular.bell,
                    JexText.of('notifications', language),
                    '',
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const JexFixedScalePage(
                          compactUi: true,
                          child: NotificationsSettingsPage(),
                        ),
                      ),
                    ),
                  ),
                ]),
                _section(context, JexText.of('device', language), [
                  _item(
                    context,
                    PhosphorIconsRegular.bluetooth,
                    JexText.of('bluetooth', language),
                    appAutoConnectNotifier.value
                        ? JexText.of('auto', language)
                        : JexText.of('manual', language),
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const JexFixedScalePage(
                          compactUi: true,
                          child: BluetoothSettingsPage(),
                        ),
                      ),
                    ),
                  ),
                  _item(
                    context,
                    PhosphorIconsRegular.stack,
                    JexText.of('floatingMonitor', language),
                    floatingConfigNotifier.value.enabled
                        ? JexText.of('on', language)
                        : JexText.of('off', language),
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const JexFixedScalePage(
                          compactUi: true,
                          child: FloatingSettingsPage(),
                        ),
                      ),
                    ),
                  ),
                ]),
                _section(
                  context,
                  JexText.phrase('Statistics', 'Statistik', language),
                  [
                    _item(
                      context,
                      PhosphorIconsRegular.chartLineUp,
                      JexText.phrase(
                        'Usage Statistics',
                        'Statistik Penggunaan',
                        language,
                      ),
                      '',
                      () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => JexFixedScalePage(
                            compactUi: true,
                            child: UsageStatisticsPage(
                              coolerId: coolerId,
                              hotLimit: hotLimit,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _section(context, JexText.of('firmwareSection', language), [
                  _item(
                    context,
                    PhosphorIconsRegular.uploadSimple,
                    JexText.of('firmwareUpdate', language),
                    currentFirmwareVersion.trim().isEmpty ||
                            currentFirmwareVersion.trim() == 'V?'
                        ? ''
                        : currentFirmwareVersion.trim(),
                    () => unawaited(onOpenFirmwareUpdate()),
                  ),
                ]),
                Card(
                  margin: const EdgeInsets.only(top: 8),
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: _item(
                    context,
                    PhosphorIconsRegular.info,
                    JexText.of('about', language),
                    '',
                    () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const JexFixedScalePage(
                          compactUi: true,
                          child: AboutSettingsPage(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _voltageLockSettingRow(
    BuildContext context,
    AppLanguage language,
    VoltageLockSettingsState state,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = JexSemanticColors.from(scheme);
    final unavailableMessage = !state.sessionReady
        ? JexText.phrase('Not synchronized', 'Belum tersinkron', language)
        : JexText.phrase(
            'Firmware V7.2+ required',
            'Perlu Firmware V7.2+',
            language,
          );

    Widget trailing;
    if (!state.known) {
      trailing = Tooltip(
        message: unavailableMessage,
        child: Icon(
          state.sessionReady
              ? PhosphorIconsRegular.info
              : PhosphorIconsRegular.bluetooth,
          size: 19,
          color: semantic.mutedForeground,
        ),
      );
    } else {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch.adaptive(
            value: state.active,
            onChanged: state.sessionReady && !state.busy
                ? (value) => unawaited(onVoltageLockChanged(value))
                : null,
          ),
          if (state.active && !state.saved)
            IconButton(
              tooltip: JexText.phrase(
                'Retry saving Lock Voltage',
                'Coba simpan Kunci Tegangan lagi',
                language,
              ),
              onPressed: state.sessionReady && !state.busy
                  ? () => unawaited(onVoltageLockChanged(true))
                  : null,
              icon: const Icon(PhosphorIconsRegular.arrowClockwise, size: 19),
            ),
        ],
      );
    }

    return Container(
      key: const ValueKey<String>('voltage-lock-card'),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: semantic.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: semantic.outline.withValues(alpha: .82)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: .72),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              PhosphorIconsRegular.lock,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              JexText.phrase('Lock Voltage', 'Kunci Tegangan', language),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: semantic.foreground,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 4),
          trailing,
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.9,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  const Divider(height: 1, indent: 52),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String summary,
    VoidCallback onTap,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = JexSemanticColors.from(scheme);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                JexAnimatedGlyph(
                  icon: icon,
                  size: 19,
                  color: semantic.mutedForeground,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: semantic.foreground,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (summary.trim().isNotEmpty) ...[
                  const SizedBox(width: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 88),
                    child: Text(
                      summary,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                JexAnimatedGlyph(
                  icon: PhosphorIconsRegular.caretRight,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// About page with concise contributor credits.
class AboutSettingsPage extends StatelessWidget {
  const AboutSettingsPage({super.key});

  Widget _credit(
    BuildContext context, {
    required String role,
    required String name,
    required String handle,
    required bool last,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final semantic = JexSemanticColors.from(scheme);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role,
            style: TextStyle(
              color: semantic.mutedForeground,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            name,
            style: TextStyle(
              color: semantic.foreground,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            handle,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!last) ...[
            const SizedBox(height: 9),
            Divider(height: 1, color: scheme.outlineVariant),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) {
        final scheme = Theme.of(context).colorScheme;
        final semantic = JexSemanticColors.from(scheme);
        return Scaffold(
          appBar: AppBar(title: Text(JexText.of('about', language))),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Text(
                JexText.phrase(
                  'Special Thanks',
                  'Ucapan Terima Kasih',
                  language,
                ),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: semantic.foreground,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.2,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _credit(
                      context,
                      role: JexText.phrase(
                        'App Developer & Builder',
                        'Pengembang Aplikasi & Perakit',
                        language,
                      ),
                      name: 'Horizon',
                      handle: '@horizontalzzz',
                      last: false,
                    ),
                    _credit(
                      context,
                      role: JexText.phrase(
                        'Design Inspiration',
                        'Inspirasi Desain',
                        language,
                      ),
                      name: 'FYZ',
                      handle: '@FYZ737',
                      last: false,
                    ),
                    _credit(
                      context,
                      role: JexText.phrase(
                        '3D Design & Printing',
                        'Desain & Pencetakan 3D',
                        language,
                      ),
                      name: 'Logos',
                      handle: '@Logos3dMichael',
                      last: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// AI-MEMORY / LANGUAGE-PAGE-CONTRACT
// Changes only the AppLanguage preference; display strings must remain centralized in JexText.
class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  Future<void> _select(BuildContext context, AppLanguage value) async {
    final current = AppSettings(
      language: appLanguageNotifier.value,
      theme: appThemeNotifier.value,
      notifySafety: appNotifySafetyNotifier.value,
      notifyFirmware: appNotifyFirmwareNotifier.value,
      notifyBluetooth: appNotifyBluetoothNotifier.value,
      autoConnect: appAutoConnectNotifier.value,
    );
    await AppSettingsStore.save(current.copyWith(language: value));
    try {
      await const MethodChannel('je_x_fyz/notifications').invokeMethod<bool>(
        'updateNotificationChannelLanguage',
        <String, dynamic>{'language': value.name},
      );
    } catch (_) {}
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) => Scaffold(
        appBar: AppBar(title: Text(JexText.of('language', language))),
        body: Column(
          children: [
            RadioListTile<AppLanguage>(
              title: Text(JexText.of('languageEnglish', language)),
              value: AppLanguage.english,
              groupValue: language,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
            RadioListTile<AppLanguage>(
              title: Text(JexText.of('languageIndonesia', language)),
              value: AppLanguage.indonesia,
              groupValue: language,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// AI-MEMORY / APPEARANCE-PAGE-CONTRACT
// Changes only the visual theme preset; Dashboard-specific theme handling remains in main.dart.
class AppearanceSettingsPage extends StatelessWidget {
  const AppearanceSettingsPage({super.key});

  Future<void> _select(BuildContext context, AppThemePreset value) async {
    final current = AppSettings(
      language: appLanguageNotifier.value,
      theme: appThemeNotifier.value,
      notifySafety: appNotifySafetyNotifier.value,
      notifyFirmware: appNotifyFirmwareNotifier.value,
      notifyBluetooth: appNotifyBluetoothNotifier.value,
      autoConnect: appAutoConnectNotifier.value,
    );
    await AppSettingsStore.save(current.copyWith(theme: value));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2<AppThemePreset, AppLanguage>(
      first: appThemeNotifier,
      second: appLanguageNotifier,
      builder: (context, theme, language) => Scaffold(
        appBar: AppBar(title: Text(JexText.of('appearance', language))),
        body: Column(
          children: [
            RadioListTile<AppThemePreset>(
              title: Text(JexText.of('default', language)),
              value: AppThemePreset.defaultTheme,
              groupValue: theme,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
            RadioListTile<AppThemePreset>(
              title: Text(JexText.of('light', language)),
              value: AppThemePreset.light,
              groupValue: theme,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
            RadioListTile<AppThemePreset>(
              title: Text(JexText.of('dark', language)),
              value: AppThemePreset.dark,
              groupValue: theme,
              onChanged: (value) {
                if (value != null) _select(context, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// AI-MEMORY / NOTIFICATION-PAGE-CONTRACT
// Persists notification preferences; Android runtime notification permission remains native.
class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  Future<void> _set(String key, bool value) async {
    if (value) {
      try {
        final granted =
            await const MethodChannel('je_x_fyz/notifications')
                .invokeMethod<bool>(
                  'requestNotificationPermission',
                  <String, dynamic>{'language': appLanguageNotifier.value.name},
                ) ??
            false;
        if (!granted) return;
      } catch (_) {
        return;
      }
    }
    final current = AppSettings(
      language: appLanguageNotifier.value,
      theme: appThemeNotifier.value,
      notifySafety: appNotifySafetyNotifier.value,
      notifyFirmware: appNotifyFirmwareNotifier.value,
      notifyBluetooth: appNotifyBluetoothNotifier.value,
      autoConnect: appAutoConnectNotifier.value,
    );
    final next = switch (key) {
      'safety' => current.copyWith(notifySafety: value),
      'firmware' => current.copyWith(notifyFirmware: value),
      'bluetooth' => current.copyWith(notifyBluetooth: value),
      _ => current,
    };
    await AppSettingsStore.save(next);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) => ValueListenableBuilder<bool>(
        valueListenable: appNotifySafetyNotifier,
        builder: (context, _, __) => ValueListenableBuilder<bool>(
          valueListenable: appNotifyFirmwareNotifier,
          builder: (context, _, __) => ValueListenableBuilder<bool>(
            valueListenable: appNotifyBluetoothNotifier,
            builder: (context, _, __) => Scaffold(
              appBar: AppBar(
                title: Text(JexText.of('notifications', language)),
              ),
              body: ListView(
                children: [
                  SwitchListTile(
                    title: Text(JexText.of('safetyAlert', language)),
                    subtitle: Text(
                      JexText.of('notificationSafetyDescription', language),
                    ),
                    value: appNotifySafetyNotifier.value,
                    onChanged: (value) => _set('safety', value),
                  ),
                  SwitchListTile(
                    title: Text(JexText.of('firmwareUpdate', language)),
                    subtitle: Text(
                      JexText.of('notificationFirmwareDescription', language),
                    ),
                    value: appNotifyFirmwareNotifier.value,
                    onChanged: (value) => _set('firmware', value),
                  ),
                  SwitchListTile(
                    title: Text(
                      JexText.of('deviceConnectionNotifications', language),
                    ),
                    subtitle: Text(
                      JexText.of('notificationBluetoothDescription', language),
                    ),
                    value: appNotifyBluetoothNotifier.value,
                    onChanged: (value) => _set('bluetooth', value),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// AI-MEMORY / BLUETOOTH-PAGE-CONTRACT
// Presents Bluetooth-related preferences; BLE/GATT ownership stays in main.dart/flutter_blue_plus.
class BluetoothSettingsPage extends StatelessWidget {
  const BluetoothSettingsPage({super.key});

  Future<void> _setAutoConnect(bool value) async {
    final current = AppSettings(
      language: appLanguageNotifier.value,
      theme: appThemeNotifier.value,
      notifySafety: appNotifySafetyNotifier.value,
      notifyFirmware: appNotifyFirmwareNotifier.value,
      notifyBluetooth: appNotifyBluetoothNotifier.value,
      autoConnect: appAutoConnectNotifier.value,
    );
    await AppSettingsStore.save(current.copyWith(autoConnect: value));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder2<bool, AppLanguage>(
      first: appAutoConnectNotifier,
      second: appLanguageNotifier,
      builder: (context, autoConnect, language) => Scaffold(
        appBar: AppBar(title: Text(JexText.of('bluetooth', language))),
        body: ListView(
          children: [
            SwitchListTile(
              title: Text(JexText.of('autoConnect', language)),
              subtitle: Text(JexText.of('autoConnectDescription', language)),
              value: autoConnect,
              onChanged: _setAutoConnect,
            ),
          ],
        ),
      ),
    );
  }
}
