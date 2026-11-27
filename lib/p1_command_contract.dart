// AI-MEMORY / MODULE CONTRACT
// Pure classification for existing P1 commands. It maps unchanged command text to ACK items,
// expected telemetry and GATT write-response policy; it never sends commands or owns session state.
// Dashboard remains the sole owner of serialized writes, ACK waiters and telemetry confirmation.

abstract final class P1CommandContract {
  /// Maps command text to the ACK item emitted by the existing Firmware protocol.
  static String? ackItemForCommand(String command) {
    final c = command.trim().toUpperCase();
    if (c == 'SYNC_READY') return 'SYNC_READY';
    if (c == 'OTAENTER') return 'OTAENTER';
    if (c == 'CLOUDOTA') return 'CLOUDOTA';
    if (c == 'RGB:ON' || c == 'RGB:OFF') return 'RGB';
    if (c.startsWith('MODE:')) return 'MODE';
    if (c.startsWith('BRIGHTNESS:')) return 'BRIGHTNESS';
    if (c.startsWith('COLOR:')) return 'COLOR';
    if (c.startsWith('HOTLIMIT:')) return 'HOTLIMIT';
    if (c.startsWith('BATT5:')) return 'BATT5';
    if (c.startsWith('BATT12:')) return 'BATT12';
    if (c.startsWith('VOLTAGE_LOCK:')) return 'VOLTAGE_LOCK';
    if (c.startsWith('VOLTAGE:')) return 'VOLTAGE';
    if (c == 'FAN:ON' || c == 'FAN:OFF') return 'FAN';
    if (c == 'PELTIER:ON' || c == 'PELTIER:OFF') return 'PELTIER';
    if (c == 'ADAPTIVE:ON' || c == 'ADAPTIVE:OFF') return 'ADAPTIVE';
    if (c.startsWith('ADAPTIVE_PROFILE:')) return 'ADAPTIVE_PROFILE';
    if (c.startsWith('FANSPEED:')) return 'FANSPEED';
    if (c == 'RESET:TEMPERATURE') return 'RESET_TEMPERATURE';
    if (c.startsWith('SSID:')) return 'SSID';
    if (c.startsWith('PASS:')) return 'PASS';
    if (c.startsWith('URL:')) return 'URL';
    if (c.startsWith('VERSION:')) return 'VERSION';
    return null;
  }

  /// Describes the telemetry value required after an accepted output-control ACK.
  static MapEntry<String, String>? expectedTelemetryForCommand(String command) {
    final c = command.trim().toUpperCase();
    if (c == 'FAN:ON') return const MapEntry('FAN', 'ON');
    if (c == 'FAN:OFF') return const MapEntry('FAN', 'OFF');
    if (c == 'PELTIER:ON') return const MapEntry('PELTIER', 'ON');
    if (c == 'PELTIER:OFF') return const MapEntry('PELTIER', 'OFF');
    if (c == 'ADAPTIVE:ON') return const MapEntry('ADAPTIVE', 'ON');
    if (c == 'ADAPTIVE:OFF') return const MapEntry('ADAPTIVE', 'OFF');
    if (c.startsWith('VOLTAGE_LOCK:')) {
      return MapEntry('VOLTAGE_LOCK', c.substring(13));
    }
    if (c.startsWith('VOLTAGE:')) return MapEntry('VOLTAGE', c.substring(8));
    if (c == 'RGB:ON') return const MapEntry('RGB', 'ON');
    if (c == 'RGB:OFF') return const MapEntry('RGB', 'OFF');
    if (c.startsWith('MODE:')) return MapEntry('MODE', c.substring(5));
    if (c.startsWith('BRIGHTNESS:')) {
      return MapEntry('BRIGHTNESS', c.substring(11));
    }
    if (c.startsWith('COLOR:')) return MapEntry('RGB_COLOR', c.substring(6));
    if (c.startsWith('FANSPEED:')) return MapEntry('FAN_SPEED', c.substring(9));
    if (c.startsWith('HOTLIMIT:')) {
      return MapEntry('TEMP_HOT_LIMIT', c.substring(9));
    }
    if (c.startsWith('BATT5:')) return MapEntry('BATT_5', c.substring(6));
    if (c.startsWith('BATT12:')) return MapEntry('BATT_12', c.substring(7));
    if (c.startsWith('ADAPTIVE_PROFILE:')) {
      return MapEntry('ADAPTIVE_PROFILE', c.substring(17));
    }
    return null;
  }

  /// Identifies commands that must await the GATT write response.
  static bool requiresResponse(String command) {
    final c = command.trim().toUpperCase();
    return c == 'SYNC' ||
        c == 'SYNC_READY' ||
        c == 'CLOUDOTA' ||
        c == 'OTAENTER' ||
        c.startsWith('VOLTAGE_LOCK:') ||
        c.startsWith('VOLTAGE:') ||
        c.startsWith('SSID:') ||
        c.startsWith('PASS:') ||
        c.startsWith('URL:') ||
        c.startsWith('VERSION:') ||
        c.startsWith('FAN:') ||
        c.startsWith('PELTIER:') ||
        c.startsWith('ADAPTIVE_PROFILE:') ||
        c.startsWith('ADAPTIVE:') ||
        c.startsWith('FANSPEED:') ||
        c.startsWith('HOTLIMIT:') ||
        c.startsWith('BATT5:') ||
        c.startsWith('BATT12:') ||
        c.startsWith('RESET:') ||
        c.startsWith('PHONE:BT=');
  }

  /// Selects no-response writes only when the characteristic supports them
  /// and the existing command contract does not require a write response.
  static bool usesWriteWithoutResponse(
    String command, {
    required bool supportsWriteWithoutResponse,
  }) => supportsWriteWithoutResponse && !requiresResponse(command);

  /// Success vocabulary is compared against the normalized reason parsed by Dashboard.
  static bool isAckSuccessReason(String reason) =>
      reason == 'OK' ||
      reason == 'ACCEPTED' ||
      reason == 'READY' ||
      reason == 'STARTING' ||
      reason == 'ON' ||
      reason == 'OFF';
}
