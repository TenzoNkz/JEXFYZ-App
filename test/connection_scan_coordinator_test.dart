import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import '../lib/connection_scan_coordinator.dart';

void main() {
  group('ConnectionScanCoordinator', () {
    test('opening the manual sheet invalidates a passive attempt suspended in prerequisites', () async {
      final coordinator = ConnectionScanCoordinator();
      final prerequisites = Completer<void>();
      var scannerStarted = false;

      final attempt = coordinator.beginPassiveAttempt()!;
      final suspendedAttempt = () async {
        await prerequisites.future;
        if (coordinator.isPassiveAttemptCurrent(attempt)) {
          scannerStarted = true;
        }
        coordinator.finishPassiveAttempt(attempt);
      }();

      expect(coordinator.openManualSheet(), isTrue);
      prerequisites.complete();
      await suspendedAttempt;

      expect(scannerStarted, isFalse);
      expect(coordinator.isManualSheetOpen, isTrue);
      expect(coordinator.beginPassiveAttempt(), isNull);
    });

    test('manual ownership blocks passive attempts until neutral close', () {
      final coordinator = ConnectionScanCoordinator();
      expect(coordinator.openManualSheet(), isTrue);
      expect(coordinator.beginPassiveAttempt(), isNull);
      expect(coordinator.closeManualSheet(), isTrue);
      expect(coordinator.isManualSheetOpen, isFalse);

      final resumed = coordinator.beginPassiveAttempt()!;
      coordinator.finishPassiveAttempt(resumed);
    });

    test('selected-device dismissal does not authorize passive reconnect resumption', () {
      final coordinator = ConnectionScanCoordinator();
      expect(coordinator.openManualSheet(), isTrue);
      coordinator.markManualDeviceSelected();

      expect(coordinator.manualDeviceSelected, isTrue);
      expect(coordinator.closeManualSheet(), isFalse);
      expect(coordinator.isManualSheetOpen, isFalse);
    });

    test('invalidating an old attempt does not clear a newer generation', () {
      final coordinator = ConnectionScanCoordinator();
      final oldAttempt = coordinator.beginPassiveAttempt()!;
      coordinator.invalidatePassiveAttempts();

      final newAttempt = coordinator.beginPassiveAttempt()!;
      expect(coordinator.isPassiveAttemptCurrent(newAttempt), isTrue);

      coordinator.finishPassiveAttempt(oldAttempt);
      expect(coordinator.isPassiveAttemptCurrent(newAttempt), isTrue);

      coordinator.finishPassiveAttempt(newAttempt);
      final finalAttempt = coordinator.beginPassiveAttempt()!;
      coordinator.finishPassiveAttempt(finalAttempt);
    });

    test('passive and manual scanner commands are serialized in FIFO order', () async {
      final coordinator = ConnectionScanCoordinator();
      final events = <String>[];
      final firstStarted = Completer<void>();
      final releaseFirst = Completer<void>();

      final passive = coordinator.runSerialized(() async {
        events.add('passive-start');
        firstStarted.complete();
        await releaseFirst.future;
        events.add('passive-finish');
      });
      await firstStarted.future;

      final manual = coordinator.runSerialized(() async {
        events.add('manual-stop');
        events.add('manual-start');
      });

      expect(events, <String>['passive-start']);
      releaseFirst.complete();
      await Future.wait<void>(<Future<void>>[passive, manual]);

      expect(
        events,
        <String>['passive-start', 'passive-finish', 'manual-stop', 'manual-start'],
      );
    });

    test('a failed scanner command does not poison later queued work', () async {
      final coordinator = ConnectionScanCoordinator();
      var laterCommandRan = false;

      await expectLater(
        coordinator.runSerialized(() async {
          throw StateError('simulated scan failure');
        }),
        throwsA(isA<StateError>()),
      );

      await coordinator.runSerialized(() async {
        laterCommandRan = true;
      });
      expect(laterCommandRan, isTrue);
    });
  });
}
