// AI-MEMORY / CONNECTION-SCAN-STATE
// Pure presentation mapping for the Connection sheet; this does not own BLE protocol state.
String connectionScanEmptyStateMessageKey({
  required bool permissionRequired,
  required bool bluetoothUnavailable,
  required bool scanning,
  String? errorKey,
}) {
  if (permissionRequired) return 'connectionAccessRequired';
  if (bluetoothUnavailable) return 'connectionUnavailable';
  if (errorKey != null) return errorKey;
  if (scanning) return 'scanning';
  return 'deviceNotFound';
}

// Prefer the current BLE advertisement name, which represents the peripheral's
// Bluetooth identity for this scan. Android's platformName is a fallback for
// stacks that omit the local name from the advertisement/scan response.
String connectionDeviceDisplayName({
  required String advertisedName,
  required String platformName,
  required String fallback,
}) {
  final advertised = advertisedName.trim();
  if (advertised.isNotEmpty) return advertised;

  final platform = platformName.trim();
  if (platform.isNotEmpty) return platform;

  return fallback;
}
