// AI-MEMORY / MODULE CONTRACT
// Owns only per-item ACK waiter registration, FIFO completion and cleanup.
// Dashboard remains responsible for ACK parsing, command transactions, GATT writes,
// SYNC/SYNC_READY, reconnect and authoritative physical telemetry.
import 'dart:async';

final class P1AckWaiter {
  P1AckWaiter._(this.item);

  final String item;
  final Completer<String> _completer = Completer<String>();

  Future<String> get future => _completer.future;

  bool _complete(String reason) {
    if (_completer.isCompleted) return false;
    _completer.complete(reason);
    return true;
  }
}

class P1AckWaiterCoordinator {
  final Map<String, List<P1AckWaiter>> _queues = <String, List<P1AckWaiter>>{};

  /// Registers before GATT write, preserving FIFO for concurrent commands of the same item.
  P1AckWaiter register(String item) {
    final waiter = P1AckWaiter._(item);
    (_queues[item] ??= <P1AckWaiter>[]).add(waiter);
    return waiter;
  }

  /// Keeps the established TIMEOUT result and removes only the timed-out token.
  Future<String> waitFor(
    P1AckWaiter waiter, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    try {
      return await waiter.future.timeout(timeout);
    } catch (_) {
      cancel(waiter, reason: 'TIMEOUT');
      return 'TIMEOUT';
    }
  }

  /// Removes and resolves the exact waiter affected by a failed write or timeout.
  bool cancel(P1AckWaiter waiter, {String reason = 'CANCELLED'}) {
    final queue = _queues[waiter.item];
    if (queue == null) return false;

    final removed = queue.remove(waiter);
    if (!removed) return false;

    if (queue.isEmpty) _queues.remove(waiter.item);
    waiter._complete(reason);
    return true;
  }

  /// Completes the oldest waiter for an ACK item without consuming another item.
  bool completeNext(String item, String reason) {
    final queue = _queues[item];
    if (queue == null || queue.isEmpty) return false;

    final waiter = queue.removeAt(0);
    if (queue.isEmpty) _queues.remove(item);
    return waiter._complete(reason);
  }

  /// Resolves all outstanding waiters with the lifecycle reason supplied by Dashboard.
  int completeAll(String reason) {
    final pending = _queues.values
        .expand((queue) => List<P1AckWaiter>.of(queue))
        .toList(growable: false);
    _queues.clear();

    var completed = 0;
    for (final waiter in pending) {
      if (waiter._complete(reason)) completed++;
    }
    return completed;
  }
}
