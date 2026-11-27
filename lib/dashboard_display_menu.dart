// AI-MEMORY / FILE CONTRACT
// Owns the Dashboard submenu lock policy and its presentation-only overlay.
// Dashboard supplies synchronized device facts and the existing Connect action;
// this module never owns BLE/GATT, P1, session state, commands or persistence.

import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:phosphor_icons/phosphor_icons.dart';

import 'app_settings.dart';
import 'jex_design_tokens.dart';

enum DisplayMenuLockReason {
  none,
  bluetoothDisconnected,
  adaptiveActive,
  voltageLocked,
}

/// Applies one lock reason to the selected Dashboard submenu.
/// Disconnection has highest priority, followed by the existing Adaptive gate.
DisplayMenuLockReason displayMenuLockReason({
  required bool connected,
  required bool adaptiveActive,
  required bool adaptiveTransitioning,
  required int tabIndex,
  bool voltageLockKnown = false,
  bool voltageLockActive = false,
}) {
  if (!connected) return DisplayMenuLockReason.bluetoothDisconnected;
  final adaptiveLocksTab = tabIndex == 0 || tabIndex == 1 || tabIndex == 4;
  if ((adaptiveActive || adaptiveTransitioning) && adaptiveLocksTab) {
    return DisplayMenuLockReason.adaptiveActive;
  }
  final voltageLockLocksTab = tabIndex == 0 || tabIndex == 2;
  if (voltageLockKnown && voltageLockActive && voltageLockLocksTab) {
    return DisplayMenuLockReason.voltageLocked;
  }
  return DisplayMenuLockReason.none;
}

/// Renders a non-interactive submenu beneath the existing state-derived lock panel.
///
/// Dashboard passes its content and guarded Connect callback. This widget does not
/// initiate BLE operations and the covered submenu never receives pointer input.
class JexDashboardLockedMenu extends StatelessWidget {
  const JexDashboardLockedMenu({
    super.key,
    required this.content,
    required this.reason,
    required this.tabIndex,
    required this.voltage,
    required this.language,
    required this.onConnect,
  });

  final Widget content;
  final DisplayMenuLockReason reason;
  final int tabIndex;
  final String voltage;
  final AppLanguage language;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final disconnected = reason == DisplayMenuLockReason.bluetoothDisconnected;
    final adaptiveLocked = reason == DisplayMenuLockReason.adaptiveActive;
    final voltageConfirmedAtFive = voltage == '5V';
    final scheme = Theme.of(context).colorScheme;
    final title = disconnected
        ? JexText.phrase(
            'CONNECT YOUR DEVICE FIRST',
            'HUBUNGKAN PERANGKAT TERLEBIH DAHULU',
            language,
          )
        : adaptiveLocked
        ? JexText.phrase(
            'LOCKED BY ADAPTIVE MODE',
            'TERKUNCI OLEH MODE ADAPTIF',
            language,
          )
        : tabIndex == 0
        ? (voltageConfirmedAtFive
              ? JexText.phrase(
                  'VOLTAGE LOCKED AT 5V',
                  'TEGANGAN TERKUNCI DI 5V',
                  language,
                )
              : JexText.phrase(
                  'RETURNING TO 5V',
                  'SEDANG KEMBALI KE 5V',
                  language,
                ))
        : JexText.phrase(
            'ADAPTIVE MODE DISABLED',
            'MODE ADAPTIF DINONAKTIFKAN',
            language,
          );
    final detail = disconnected
        ? JexText.phrase(
            'Connect your device to use this menu.',
            'Hubungkan perangkat untuk menggunakan menu ini.',
            language,
          )
        : adaptiveLocked
        ? JexText.phrase(
            'Turn Adaptive Mode off to edit these settings.',
            'Matikan Mode Adaptif untuk mengubah pengaturan ini.',
            language,
          )
        : tabIndex == 0
        ? (voltageConfirmedAtFive
              ? JexText.phrase(
                  'The device confirms the 5V rail. Higher voltage selections are locked.',
                  'Perangkat mengonfirmasi tegangan 5V. Pilihan tegangan yang lebih tinggi dikunci.',
                  language,
                )
              : JexText.phrase(
                  voltage == '--'
                      ? 'Waiting for confirmed 5V telemetry. The voltage lock remains active.'
                      : 'The voltage lock is active. The device is safely returning from $voltage to 5V.',
                  voltage == '--'
                      ? 'Menunggu telemetri 5V yang terkonfirmasi. Kunci tegangan tetap aktif.'
                      : 'Kunci tegangan aktif. Perangkat sedang kembali dengan aman dari $voltage ke 5V.',
                  language,
                ))
        : JexText.phrase(
            'Adaptive Mode is forced OFF while Lock Voltage is active.',
            'Mode Adaptif dipaksa MATI selama Kunci Tegangan aktif.',
            language,
          );
    final accent = disconnected
        ? const Color(0xFF4D8CFF)
        : adaptiveLocked
        ? const Color(0xFFC05BFF)
        : const Color(0xFFD69A38);

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4.8, sigmaY: 4.8),
            // The submenu is visible as a blurred background only. Remove it
            // from screen-reader navigation while the lock panel is active.
            child: ExcludeSemantics(
              child: IgnorePointer(child: content),
            ),
          ),
          Positioned.fill(
            child: ColoredBox(color: scheme.jexSurface.withValues(alpha: .46)),
          ),
          Positioned.fill(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 270),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                  decoration: BoxDecoration(
                    color: scheme.jexSurface.withValues(alpha: .96),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: scheme.jexOutline.withValues(alpha: .92),
                      width: 1.1,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .12),
                        blurRadius: 20,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(PhosphorIconsBold.lock, size: 38, color: accent),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.jexForeground,
                          fontSize: 14,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .25,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        detail,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.jexMutedForeground,
                          fontSize: 11.5,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (disconnected) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            // Dashboard retains the actual Bluetooth connection flow.
                            onPressed: onConnect,
                            icon: const Icon(
                              PhosphorIconsRegular.bluetooth,
                              size: 18,
                            ),
                            label: Text(
                              JexText.phrase('Connect', 'Hubungkan', language),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              foregroundColor: accent,
                              backgroundColor: accent.withValues(alpha: .10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
