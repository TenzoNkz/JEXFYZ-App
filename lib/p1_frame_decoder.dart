// AI-MEMORY / MODULE CONTRACT
// Pure P1 byte-stream framing. It owns only the partial receive buffer and frame boundaries.
// Dashboard remains the sole BLE/GATT/P1 session owner and decides how decoded frames affect
// ACK waiters, SYNC_READY, firmware telemetry, physical-state confirmation and UI state.

sealed class P1FrameEvent {
  const P1FrameEvent();
}

/// One complete newline-delimited P1 line, trimmed exactly as the Dashboard previously did.
final class P1LineFrame extends P1FrameEvent {
  const P1LineFrame(this.line);

  final String line;

  @override
  bool operator ==(Object other) => other is P1LineFrame && other.line == line;

  @override
  int get hashCode => line.hashCode;
}

/// The raw payload between a complete <SYNC_START> / <SYNC_END> pair.
final class P1SyncFrame extends P1FrameEvent {
  const P1SyncFrame(this.payload);

  final String payload;

  @override
  bool operator ==(Object other) =>
      other is P1SyncFrame && other.payload == payload;

  @override
  int get hashCode => payload.hashCode;
}

class P1FrameDecoder {
  static const int maxBufferLength = 16000;
  static const String syncStart = '<SYNC_START>';
  static const String syncEnd = '<SYNC_END>';

  String _buffer = '';

  /// Number of characters retained for an unfinished line or SYNC frame.
  int get pendingCharacters => _buffer.length;

  /// Drops any partial input when Dashboard starts a new BLE connection session.
  void clear() => _buffer = '';

  /// Adds one decoded BLE notification chunk and emits complete frames in wire order.
  ///
  /// Overflow policy intentionally mirrors the prior Dashboard parser: retain only the
  /// newest SYNC_START frame candidate when present; otherwise discard the entire buffer.
  /// An incomplete SYNC frame blocks newline extraction until its matching end arrives.
  List<P1FrameEvent> addChunk(String chunk) {
    _buffer += chunk;
    if (_buffer.length > maxBufferLength) {
      final marker = _buffer.lastIndexOf(syncStart);
      _buffer = marker >= 0 ? _buffer.substring(marker) : '';
    }

    final events = <P1FrameEvent>[];
    while (true) {
      final start = _buffer.indexOf(syncStart);
      if (start < 0) break;
      final end = _buffer.indexOf(syncEnd, start);
      if (end < 0) break;

      final before = _buffer.substring(0, start);
      if (before.isNotEmpty) {
        for (final rawLine in before.split('\n')) {
          final line = rawLine.trim();
          if (line.isNotEmpty) events.add(P1LineFrame(line));
        }
      }

      final payload = _buffer.substring(start + syncStart.length, end);
      _buffer = _buffer.substring(end + syncEnd.length);
      events.add(P1SyncFrame(payload));
    }

    while (_buffer.contains('\n') && !_buffer.contains(syncStart)) {
      final newline = _buffer.indexOf('\n');
      final line = _buffer.substring(0, newline).trim();
      _buffer = _buffer.substring(newline + 1);
      if (line.isNotEmpty) events.add(P1LineFrame(line));
    }

    return events;
  }
}
