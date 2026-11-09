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
