import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/p1_ack_waiters.dart';

void main() {
  group('P1AckWaiterCoordinator', () {
    test('completes FIFO per item without consuming another item', () async {
      final coordinator = P1AckWaiterCoordinator();
      final firstFan = coordinator.register('FAN');
      final secondFan = coordinator.register('FAN');
      final syncReady = coordinator.register('SYNC_READY');

      expect(coordinator.completeNext('UNKNOWN', 'OK'), isFalse);
      expect(coordinator.completeNext('FAN', 'ON'), isTrue);
      expect(await firstFan.future, 'ON');
      expect(coordinator.completeNext('SYNC_READY', 'READY'), isTrue);
      expect(await syncReady.future, 'READY');
      expect(coordinator.completeNext('FAN', 'OFF'), isTrue);
      expect(await secondFan.future, 'OFF');
      expect(coordinator.completeNext('FAN', 'LATE'), isFalse);
    });

    test(
      'cancels the exact failed-write waiter and preserves peer order',
      () async {
        final coordinator = P1AckWaiterCoordinator();
        final first = coordinator.register('VOLTAGE');
        final failedWrite = coordinator.register('VOLTAGE');
        final third = coordinator.register('VOLTAGE');
        final failedFuture = coordinator.waitFor(failedWrite);

        expect(coordinator.cancel(failedWrite, reason: 'WRITE_FAILED'), isTrue);
        expect(
          coordinator.cancel(failedWrite, reason: 'WRITE_FAILED'),
          isFalse,
        );
        expect(await failedFuture, 'WRITE_FAILED');

        expect(coordinator.completeNext('VOLTAGE', '9V'), isTrue);
        expect(await first.future, '9V');
        expect(coordinator.completeNext('VOLTAGE', '12V'), isTrue);
        expect(await third.future, '12V');
        expect(coordinator.completeNext('VOLTAGE', 'LATE'), isFalse);
      },
    );

    test(
      'timeout removes only its waiter and preserves the next FIFO token',
      () async {
        final coordinator = P1AckWaiterCoordinator();
        final timedOut = coordinator.register('PELTIER');
        final next = coordinator.register('PELTIER');

        expect(
          await coordinator.waitFor(timedOut, timeout: Duration.zero),
          'TIMEOUT',
        );
        expect(await timedOut.future, 'TIMEOUT');
        expect(coordinator.completeNext('PELTIER', 'OFF'), isTrue);
        expect(await next.future, 'OFF');
        expect(coordinator.completeNext('PELTIER', 'LATE'), isFalse);
      },
    );

    test(
      'disconnect resolves all outstanding items with DISCONNECTED',
      () async {
        final coordinator = P1AckWaiterCoordinator();
        final waiters = <P1AckWaiter>[
          coordinator.register('FAN'),
          coordinator.register('PELTIER'),
          coordinator.register('FAN'),
        ];

        expect(coordinator.completeAll('DISCONNECTED'), 3);
        expect(
          await Future.wait(waiters.map((waiter) => waiter.future)),
          <String>['DISCONNECTED', 'DISCONNECTED', 'DISCONNECTED'],
        );
        expect(coordinator.completeAll('DISCONNECTED'), 0);
      },
    );

    test('dispose resolves remaining waiters with CANCELLED', () async {
      final coordinator = P1AckWaiterCoordinator();
      final first = coordinator.register('SYNC_READY');
      final second = coordinator.register('FAN');

      expect(coordinator.completeAll('CANCELLED'), 2);
      expect(await first.future, 'CANCELLED');
      expect(await second.future, 'CANCELLED');
      expect(coordinator.completeAll('CANCELLED'), 0);
    });
  });
}
