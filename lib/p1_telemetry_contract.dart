// Pure parsing for one already-decoded P1 telemetry row.
// Frame boundaries and ACK routing remain with P1FrameDecoder and Dashboard;
// this contract only preserves the existing first-colon key/value split.
final class P1TelemetryEntry {
  const P1TelemetryEntry({required this.key, required this.value});

  final String key;
  final String value;
}

abstract final class P1TelemetryContract {
  /// Parses one telemetry line without normalizing protocol token case.
  ///
  /// Whitespace is trimmed only at the key/value boundaries, and any additional
  /// colons remain part of the value. ACK envelopes are routed separately.
  static P1TelemetryEntry? parseLine(String line) {
    if (line.isEmpty || line.startsWith('ACK:')) return null;

    final separator = line.indexOf(':');
    if (separator <= 0) return null;

    final key = line.substring(0, separator).trim();
    if (key.isEmpty) return null;

    return P1TelemetryEntry(
      key: key,
      value: line.substring(separator + 1).trim(),
    );
  }
}
