import 'dart:async';
import 'dart:io';
import 'support/source_contract_helpers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_settings.dart';
import 'package:jexfyz_cooler/floating_monitor.dart';
import 'package:jexfyz_cooler/usage_statistics.dart';

class _FakeUsageRepository implements UsageStatisticsRepository {
  UsageStatsSnapshot snapshot;
  int clearCalls = 0;

  _FakeUsageRepository(this.snapshot);

  @override
  Future<List<UsageStatsSession>> loadSessions({
    required String coolerId,
    int? nowMs,
  }) async => snapshot.sessions
      .where((session) => session.coolerId == coolerId)
      .toList(growable: false);

  @override
  Future<UsageStatsSnapshot> loadSessionSnapshot({
    required String coolerId,
    required int sessionId,
    int? nowMs,
  }) async {
    final selected = snapshot.sessions.any(
      (session) => session.id == sessionId && session.coolerId == coolerId,
    );
    return selected
        ? snapshot
        : UsageStatsSnapshot.empty(fromMs: 0, toMs: nowMs ?? 0);
  }

  @override
  Future<void> clearCooler(String coolerId) async {
    clearCalls++;
    snapshot = UsageStatsSnapshot.empty(
      fromMs: snapshot.fromMs,
      toMs: snapshot.toMs,
    );
  }
}

UsageStatsSnapshot _sampleSnapshot() {
  const session = UsageStatsSession(
    id: 1,
    coolerId: 'AA:BB:CC',
    startedAtMs: 0,
    endedAtMs: 10000,
    lastSeenAtMs: 10000,
    lastHotsideSeenAtMs: 10000,
    lastBatterySeenAtMs: 10000,
  );

  const events = <UsageStatsEvent>[
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 0,
      metric: 'battery',
      numberValue: 20,
      textValue: null,
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 5000,
      metric: 'battery',
      numberValue: 30,
      textValue: null,
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 8000,
      metric: 'battery',
      numberValue: null,
      textValue: null,
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 9000,
      metric: 'battery',
      numberValue: 40,
      textValue: null,
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 0,
      metric: 'hotside',
      numberValue: 30,
      textValue: null,
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 5000,
      metric: 'hotside',
      numberValue: 35,
      textValue: null,
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 0,
      metric: 'voltage',
      numberValue: null,
      textValue: '5V',
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 4000,
      metric: 'voltage',
      numberValue: null,
      textValue: '9V',
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 7000,
      metric: 'voltage',
      numberValue: null,
      textValue: '12V',
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 0,
      metric: 'adaptive',
      numberValue: null,
      textValue: 'OFF',
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 3000,
      metric: 'adaptive',
      numberValue: null,
      textValue: 'ON',
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 8000,
      metric: 'adaptive',
      numberValue: null,
      textValue: 'OFF',
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 0,
      metric: 'peltier',
      numberValue: null,
      textValue: 'OFF',
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 6000,
      metric: 'peltier',
      numberValue: null,
      textValue: 'ON',
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 0,
      metric: 'fan_speed',
      numberValue: 60,
      textValue: null,
    ),
    UsageStatsEvent(
      sessionId: 1,
      timestampMs: 5000,
      metric: 'fan_speed',
      numberValue: 100,
      textValue: null,
    ),
  ];

  return const UsageStatsSnapshot(
    fromMs: 0,
    toMs: 10000,
    sessions: [session],
    events: events,
  );
}

void main() {
  group('Usage Statistics analytics', () {
    test('temperature axes label every degree and scale to observed data', () {
      final ticks = usageTemperatureAxisTicks(minimum: 31.5, maximum: 31.6);

      expect(ticks, <double>[33, 32, 31, 30]);
      expect(
        ticks.map((value) => formatUsageAxisTick(value, 1)).toList(),
        <String>['33', '32', '31', '30'],
      );
      expect(usageTemperatureChartHeight(minimum: 31.5, maximum: 31.6), 160);

      final wideRange = usageTemperatureAxisTicks(minimum: 20, maximum: 40);
      expect(wideRange.first - wideRange.last, 22);
      expect(
        usageTemperatureChartHeight(minimum: 20, maximum: 40),
        greaterThan(160),
      );
      expect(formatUsageAxisTick(0.234, 0.01), '0.23');
    });

    test(
      'active state follows authoritative physical outputs, not connection or Adaptive',
      () {
        expect(usageCoolerIsActive(fanOn: false, peltierOn: false), isFalse);
        expect(usageCoolerIsActive(fanOn: true, peltierOn: false), isTrue);
        expect(usageCoolerIsActive(fanOn: false, peltierOn: true), isTrue);
        expect(usageCoolerIsActive(fanOn: true, peltierOn: true), isTrue);
      },
    );

    test(
      'elapsed time labels use the selected cooling run, not wall-clock periods',
      () {
        expect(formatUsageElapsed(0), '00:00');
        expect(formatUsageElapsed(1000), '00:01');
        expect(formatUsageElapsed(12 * 60 * 1000 + 35000), '12:35');
        expect(formatUsageElapsed(60 * 60 * 1000 + 2000), '1:00:02');
        expect(UsageStatisticsStore.retentionDays, 30);
      },
    );

    test('live coverage is bounded by the latest P1 HOT heartbeat', () {
      const session = UsageStatsSession(
        id: 1,
        coolerId: 'AA:BB:CC',
        startedAtMs: 0,
        endedAtMs: null,
        lastSeenAtMs: 1000,
        lastHotsideSeenAtMs: 1000,
        lastBatterySeenAtMs: 4000,
      );
      expect(
        usageSessionCoverageEndMs(session: session, publishedAtMs: 5000),
        2500,
      );
      const ended = UsageStatsSession(
        id: 2,
        coolerId: 'AA:BB:CC',
        startedAtMs: 0,
        endedAtMs: 2200,
        lastSeenAtMs: 1000,
        lastHotsideSeenAtMs: 1000,
        lastBatterySeenAtMs: 4000,
      );
      expect(
        usageSessionCoverageEndMs(session: ended, publishedAtMs: 5000),
        2200,
      );
    });

    test(
      'display interpolation is frame-safe and never overshoots observed values',
      () {
        expect(usageInterpolate(20, 40, 0), 20);
        expect(usageInterpolate(20, 40, .5), 30);
        expect(usageInterpolate(20, 40, 1), 40);
        expect(usageInterpolate(20, 40, -1), 20);
        expect(usageInterpolate(20, 40, 2), 40);
        expect(usageInterpolate(null, 37, .5), 37);
      },
    );

    test('temperature cursor stops at the sensor freshness endpoint', () {
      const points = <UsageChartPoint>[
        UsageChartPoint(
          timestampMs: 1000,
          value: 35,
          sessionId: 1,
          breakBefore: true,
        ),
        UsageChartPoint(timestampMs: 2500, value: 35, sessionId: 1),
      ];
      expect(UsageStatsAnalytics.temperatureAt(points, 2500), 35);
      expect(UsageStatsAnalytics.temperatureAt(points, 2501), isNull);
    });

    test('render decimation preserves extrema and invalid-data boundaries', () {
      final points = List<UsageChartPoint>.generate(2400, (index) {
        final double? value = index == 900
            ? null
            : index == 711
            ? -20
            : index == 1531
            ? 120
            : (index % 100).toDouble();
        return UsageChartPoint(
          timestampMs: index * 1000,
          value: value,
          sessionId: 1,
          breakBefore: index == 1531,
        );
      });
      final rendered = UsageStatsAnalytics.decimatePoints(points);
      expect(rendered.length, lessThan(points.length));
      expect(rendered.length, lessThanOrEqualTo(1600));
      expect(rendered, contains(points[711]));
      expect(rendered, contains(points[900]));
      expect(rendered, contains(points[1531]));
      expect(
        rendered.any((point) => point.value == 120 && point.breakBefore),
        isTrue,
      );
    });

    test(
      'gap-heavy decimation has a hard cap and never bridges discarded gaps',
      () {
        const count = 24000;
        final points = List<UsageChartPoint>.generate(count, (index) {
          final double? value = index.isOdd ? null : (index % 83).toDouble();
          return UsageChartPoint(
            timestampMs: index,
            value: value,
            sessionId: index < count ~/ 2 ? 1 : 2,
            breakBefore: index == count ~/ 2 || index % 211 == 0,
          );
        });
        final gapPrefix = List<int>.filled(points.length + 1, 0);
        for (var index = 0; index < points.length; index++) {
          final point = points[index];
          gapPrefix[index + 1] =
              gapPrefix[index] +
              (point.value == null || point.breakBefore ? 1 : 0);
        }

        for (final budget in [1, 2, 3, 7, 8, 1599, 1600]) {
          final rendered = UsageStatsAnalytics.decimatePoints(
            points,
            maxPoints: budget,
          );
          expect(rendered.length, lessThanOrEqualTo(budget));
          for (var index = 1; index < rendered.length; index++) {
            final previous = rendered[index - 1].timestampMs;
            final current = rendered[index].timestampMs;
            final crossedGap =
                gapPrefix[current + 1] - gapPrefix[previous + 1] > 0;
            if (crossedGap && rendered[index].value != null) {
              expect(rendered[index].breakBefore, isTrue);
            }
          }
        }
        expect(
          UsageStatsAnalytics.decimatePoints(points, maxPoints: 0),
          isEmpty,
        );
      },
    );

    test(
      'temperature uses a duration-weighted average and preserves invalid gaps',
      () {
        final summary = UsageStatsAnalytics.summarize(_sampleSnapshot());

        expect(summary.battery.minimum, 20);
        expect(summary.battery.maximum, 40);
        expect(summary.battery.average, closeTo(230000 / 9000, 0.0001));
        expect(summary.battery.observedMs, 9000);
        expect(
          summary.battery.points.any((point) => point.value == null),
          isTrue,
        );
        expect(
          summary.battery.points.any(
            (point) =>
                point.value == 40 &&
                point.timestampMs == 9000 &&
                point.breakBefore,
          ),
          isTrue,
        );
      },
    );

    test(
      'voltage duration, Adaptive ON duration and Fan Speed are time-based',
      () {
        final summary = UsageStatsAnalytics.summarize(_sampleSnapshot());

        expect(summary.voltageDurationMs['5V'], 4000);
        expect(summary.voltageDurationMs['9V'], 3000);
        expect(summary.voltageDurationMs['12V'], 3000);
        expect(summary.adaptiveOnDurationMs, 5000);
        expect(summary.peltierOnDurationMs, 4000);
        expect(
          UsageStatsAnalytics.stateAt(summary.peltierSegments, 6000)?.textValue,
          'ON',
        );
        expect(
          UsageStatsAnalytics.stateAt(summary.peltierSegments, 8000)?.textValue,
          'ON',
        );
        expect(summary.fanSpeedAverage, 80);
        expect(summary.fanSpeedMaximum, 100);
      },
    );

    test(
      'Hotside trend computes valid time-weighted temperature statistics',
      () {
        final summary = UsageStatsAnalytics.summarize(_sampleSnapshot());

        expect(summary.hotside.minimum, 30);
        expect(summary.hotside.maximum, 35);
        expect(summary.hotside.average, 32.5);
        expect(summary.hotside.observedMs, 10000);
      },
    );

    test('separate sessions cannot be joined into one temperature line', () {
      const firstSession = UsageStatsSession(
        id: 1,
        coolerId: 'AA:BB:CC',
        startedAtMs: 0,
        endedAtMs: 3000,
        lastSeenAtMs: 3000,
        lastHotsideSeenAtMs: null,
        lastBatterySeenAtMs: 3000,
      );
      const secondSession = UsageStatsSession(
        id: 2,
        coolerId: 'AA:BB:CC',
        startedAtMs: 7000,
        endedAtMs: 10000,
        lastSeenAtMs: 10000,
        lastHotsideSeenAtMs: null,
        lastBatterySeenAtMs: 10000,
      );
      const events = [
        UsageStatsEvent(
          sessionId: 1,
          timestampMs: 0,
          metric: 'battery',
          numberValue: 25,
          textValue: null,
        ),
        UsageStatsEvent(
          sessionId: 2,
          timestampMs: 7000,
          metric: 'battery',
          numberValue: 35,
          textValue: null,
        ),
      ];
      const snapshot = UsageStatsSnapshot(
        fromMs: 0,
        toMs: 10000,
        sessions: [firstSession, secondSession],
        events: events,
      );

      final summary = UsageStatsAnalytics.summarize(snapshot);
      expect(
        summary.battery.points.where((point) => point.value != null).length,
        4,
      );
      expect(
        summary.battery.points
            .where((point) => point.value != null && point.breakBefore)
            .length,
        2,
      );
      expect(summary.battery.observedMs, 6000);
    });
  });

  test(
    'cooling run recording is gated by synchronized authoritative FAN/PELTIER telemetry',
    () {
      final main = File('lib/main.dart').readAsStringSync();
      final finalSync = main.indexOf(
        'if (!fullSyncReceived)',
        main.indexOf('finalSyncDeadline'),
      );
      final connected = main.indexOf('connected = true;', finalSync);
      final start = main.indexOf('_startUsageStatisticsSession();', connected);
      final recorderMethod = main.indexOf('void _recordUsageTelemetry(');
      final commitMethod = main.indexOf('void _commitTelemetry(');
      final telemetryHook = main.indexOf(
        '_recordUsageTelemetry(values);',
        commitMethod,
      );
      final disconnect = main.indexOf(
        "reason: expectedOtaDisconnect ? 'ota_handoff' : 'disconnected'",
      );

      expect(finalSync, isNonNegative);
      expect(connected, greaterThan(finalSync));
      expect(start, greaterThan(connected));
      expect(recorderMethod, isNonNegative);
      expect(telemetryHook, greaterThan(commitMethod));
      expect(disconnect, isNonNegative);
      expect(main, contains('runtimeOutputsKnown'));
      expect(
        main,
        contains('usageCoolerIsActive(fanOn: fanOn, peltierOn: peltierOn)'),
      );
      expect(main, contains("if (outputStateReported && coolerActive)"));
      expect(main, contains("if (outputStateReported && !coolerActive)"));
      expect(main, contains("if (values.containsKey('PELTIER'))"));
      expect(main, contains("metric: 'peltier'"));
      expect(main, contains("peltier: peltierOn ? 'ON' : 'OFF'"));
      expect(main, contains('device?.remoteId.toString()'));
      expect(main, contains("metric: \'battery\'"));
    },
  );

  test(
    'Statistics diagrams refresh once per second without throttling data capture',
    () {
      final usage = File('lib/usage_statistics.dart').readAsStringSync();

      expect(usageStatisticsDiagramRefreshInterval, const Duration(seconds: 1));
      expect(
        usage,
        contains(
          'Timer(\n      usageStatisticsDiagramRefreshInterval,\n      _flushLiveUpdates,',
        ),
      );
      expect(usage, contains('recordTemperatureSample('));
      expect(usage, contains('reservedControlOperations = 8'));
      expect(usage, contains('criticalControlOperations = 1'));
      expect(usage, contains('maxTotalPendingOperations'));
      expect(usage, contains('hasCriticalCapacity'));
      expect(usage, contains('allowCriticalCapacity: true'));
      expect(usage, contains('rejectedWriteCount'));
      expect(usage, contains('bool failOnReject = false'));
      expect(
        usage,
        contains(
          'failOnReject ? Future<void>.error(error) : Future<void>.value()',
        ),
      );
      expect(
        containsDartFragment(
          usage,
          'allowReservedCapacity: true, failOnReject: true',
        ),
        isTrue,
      );
      expect(usage, contains('final p1ReceiptGap ='));
      expect(usage, contains('final sampleGap ='));
      expect(usage, contains("allowReservedCapacity: metric != 'fan_speed'"));
      expect(usage, contains('final eventsBySession ='));
      expect(usage, contains('var isChronological = true;'));
      expect(usage, contains('if (!isChronological)'));
      expect(usage, contains('_mergeSortedUsageStatsEvents('));
      expect(
        usage,
        contains('_summary = UsageStatsAnalytics.summarize(workingSnapshot);'),
      );
      expect(usage, contains('var workingEventKeys = _snapshotEventKeys;'));
      expect(usage, isNot(contains('Set<String>.from(_snapshotEventKeys)')));
      expect(usage, contains('final chartHeight = hasData'));
      expect(usage, contains('usageTemperatureChartHeight('));
      expect(usage, contains('height: chartHeight,'));
      expect(usage, contains(': 160.0;'));
      expect(usage, contains('fontSize: 10);'));
      expect(usage, isNot(contains('height: 170,')));
      expect(usage, isNot(contains('mergedEvents.any(')));
      expect(usage, isNot(contains('Duration(milliseconds: 16)')));
    },
  );

  test(
    'late HOT after a stale gap leaves P1 closure to the receipt watchdog',
    () {
      final usage = File('lib/usage_statistics.dart').readAsStringSync();
      final recorderMethod = usage.indexOf('Future<void> recordTemperature({');
      final staleReceiptGuard = usage.indexOf(
        'if (p1ReceiptGap) {',
        recorderMethod,
      );
      final guardReturn = usage.indexOf(
        'return Future<void>.value();',
        staleReceiptGuard,
      );
      final receiptUpdate = usage.indexOf(
        '_lastP1ReceiptAtMs = receivedAtMs;',
        recorderMethod,
      );
      final enqueue = usage.indexOf(
        'return _enqueue(() async {',
        recorderMethod,
      );

      expect(recorderMethod, isNonNegative);
      expect(staleReceiptGuard, greaterThan(recorderMethod));
      expect(guardReturn, greaterThan(staleReceiptGuard));
      expect(receiptUpdate, greaterThan(guardReturn));
      expect(enqueue, greaterThan(receiptUpdate));
      expect(usage, contains('_writeQueue.hasCriticalCapacity'));
    },
  );

  test(
    'usage history queue bounds fire-and-forget producers and reserves control capacity',
    () async {
      final queue = UsageStatsWriteQueue(
        maxPendingOperations: 4,
        reservedControlOperations: 2,
        criticalControlOperations: 1,
      );
      final releaseFirst = Completer<void>();
      final completed = <int>[];
      final errors = <Object>[];

      for (var index = 0; index < 4; index++) {
        final operationIndex = index;
        unawaited(
          queue.enqueue(() async {
            if (operationIndex == 0) await releaseFirst.future;
            completed.add(operationIndex);
          }, onError: errors.add),
        );
      }
      for (var index = 4; index < 12; index++) {
        unawaited(
          queue.enqueue(() async => completed.add(index), onError: errors.add),
        );
      }

      unawaited(
        queue.enqueue(
          () async => completed.add(20),
          onError: errors.add,
          allowReservedCapacity: true,
        ),
      );
      final lastControl = queue.enqueue(
        () async => completed.add(21),
        onError: errors.add,
        allowReservedCapacity: true,
      );
      final rejectedControl = queue.enqueue(
        () async => completed.add(22),
        onError: errors.add,
        allowReservedCapacity: true,
        failOnReject: true,
      );
      await expectLater(rejectedControl, throwsA(isA<StateError>()));

      final criticalClose = queue.enqueue(
        () async => completed.add(23),
        onError: errors.add,
        allowCriticalCapacity: true,
      );
      final rejectedCriticalClose = queue.enqueue(
        () async => completed.add(24),
        onError: errors.add,
        allowCriticalCapacity: true,
        failOnReject: true,
      );
      await expectLater(rejectedCriticalClose, throwsA(isA<StateError>()));

      await Future<void>.delayed(Duration.zero);
      expect(queue.pendingOperations, 7);
      expect(queue.maxTotalPendingOperations, 7);
      expect(queue.rejectedOperations, 10);
      expect(errors, hasLength(10));
      expect(completed, isEmpty);

      releaseFirst.complete();
      await Future.wait([lastControl, criticalClose]);

      expect(completed, [0, 1, 2, 3, 20, 21, 23]);
      expect(queue.pendingOperations, 0);
    },
  );

  test(
    'large Statistics snapshots preserve samples while rendering a bounded chart list',
    () {
      final start = DateTime(2026, 1, 1).millisecondsSinceEpoch;
      const count = 12000;
      final events = <UsageStatsEvent>[];
      for (var index = 0; index < count; index++) {
        final timestamp = start + index * 1000;
        events.add(
          UsageStatsEvent(
            sessionId: 9,
            timestampMs: timestamp,
            metric: 'battery',
            numberValue: 30 + (index % 9) * .1,
            textValue: null,
          ),
        );
        events.add(
          UsageStatsEvent(
            sessionId: 9,
            timestampMs: timestamp,
            metric: 'hotside',
            numberValue: 35 + (index % 7) * .1,
            textValue: null,
          ),
        );
      }
      final session = UsageStatsSession(
        id: 9,
        coolerId: 'AA:BB:CC',
        startedAtMs: start,
        endedAtMs: start + count * 1000,
        lastSeenAtMs: start + count * 1000,
        lastHotsideSeenAtMs: start + count * 1000,
        lastBatterySeenAtMs: start + count * 1000,
      );
      final snapshot = UsageStatsSnapshot(
        fromMs: start,
        toMs: start + count * 1000,
        sessions: [session],
        events: events,
      );

      final summary = UsageStatsAnalytics.summarize(snapshot);
      expect(snapshot.events.length, count * 2);
      expect(summary.battery.points.length, greaterThan(12000));
      expect(summary.hotside.points.length, greaterThan(12000));
      expect(summary.battery.chartPoints.length, lessThanOrEqualTo(1600));
      expect(summary.hotside.chartPoints.length, lessThanOrEqualTo(1600));
      expect(summary.battery.observedMs, greaterThan(0));
      expect(summary.hotside.observedMs, greaterThan(0));
    },
  );

  test(
    'statistics storage is local SQLite and is not added to Firmware or Firebase',
    () {
      final usage = File('lib/usage_statistics.dart').readAsStringSync();
      final pubspec = File('pubspec.yaml').readAsStringSync();

      expect(pubspec, contains('sqflite: 2.4.2'));
      expect(usage, contains('CREATE TABLE usage_sessions'));
      expect(usage, contains('CREATE TABLE usage_events'));
      expect(usage, contains('CREATE TABLE usage_samples'));
      expect(usage, contains('version: 2'));
      expect(usage, contains('onUpgrade: (database, oldVersion, newVersion)'));
      expect(usage, contains('recordTemperatureSample('));
      expect(usage, contains("insertBaseline('peltier', textValue: peltier)"));
      expect(usage, contains("metric: 'peltier'"));
      expect(usage, contains("case 'adaptive':\n        case 'peltier':"));
      expect(usage, contains('usageSessionCoverageEndMs('));
      expect(usage, contains('Stream<UsageStatsLiveUpdate> get liveUpdates'));
      // Diagram animation is frame-synchronized through Flutter tickers, not a fixed 16-ms timer.
      expect(usage, contains('with SingleTickerProviderStateMixin'));
      expect(usage, contains('vsync: this'));
      expect(usage, contains('AnimationController('));
      expect(usage, contains('Curves.easeOutCubic'));
      expect(usage, contains('Duration(milliseconds: 320)'));
      expect(usage, contains('Duration(milliseconds: 280)'));
      expect(usage, contains('decimatePoints('));
      expect(usage, isNot(contains('Duration(milliseconds: 450)')));
      expect(usage, contains('battery_seen'));
      expect(usage, contains('hotside_seen'));
      expect(usage, contains('loadSessionSnapshot('));
      expect(usage, isNot(contains('UsagePeriod')));
      expect(usage, isNot(contains('_periodSelector')));
      expect(usage, contains('ON DELETE CASCADE'));
      expect(usage, contains('last_hotside_seen_at_ms'));
      expect(usage, contains('end_reason'));
      expect(
        usage,
        contains(
          'Only the Firmware HOT heartbeat proves the P1 device session is fresh.',
        ),
      );
      expect(usage, contains('SELECT MAX(id) FROM usage_events'));
      expect(usage, contains('CREATE INDEX usage_events_timestamp'));
      expect(usage, contains('const Duration(hours: 24).inMilliseconds'));
      expect(usage, isNot(contains('FirebaseDatabase')));
    },
  );

  group('Usage Statistics page', () {
    testWidgets(
      'sampling and local-storage provenance remains available on demand',
      (tester) async {
        final previousLanguage = appLanguageNotifier.value;
        addTearDown(() => appLanguageNotifier.value = previousLanguage);
        appLanguageNotifier.value = AppLanguage.english;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(useMaterial3: true),
            home: UsageStatisticsPage(
              coolerId: 'AA:BB:CC',
              repository: _FakeUsageRepository(_sampleSnapshot()),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('sampled once per second'), findsNothing);
        await tester.tap(find.byTooltip('Statistics information'));
        await tester.pumpAndSettle();
        expect(find.text('About this history'), findsOneWidget);
        expect(find.textContaining('sampled once per second'), findsOneWidget);
        expect(
          find.textContaining('stored locally on this phone'),
          findsOneWidget,
        );
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'shows a localized empty state without inventing chart values',
      (tester) async {
        final previousLanguage = appLanguageNotifier.value;
        addTearDown(() => appLanguageNotifier.value = previousLanguage);
        appLanguageNotifier.value = AppLanguage.english;

        final repository = _FakeUsageRepository(
          const UsageStatsSnapshot.empty(fromMs: 0, toMs: 10000),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(useMaterial3: true),
            home: UsageStatisticsPage(
              coolerId: 'AA:BB:CC',
              repository: repository,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Usage Statistics'), findsOneWidget);
        expect(find.text('No cooling history yet.'), findsOneWidget);
        for (final obsolete in ['1H', '24H', '7D', '30D']) {
          expect(find.text(obsolete), findsNothing);
        }
        for (final key in <Key>[
          const ValueKey<String>('usage-temperature-chart-battery'),
          const ValueKey<String>('usage-temperature-chart-hotside'),
          const ValueKey<String>('usage-profile-timeline-voltage'),
          const ValueKey<String>('usage-profile-timeline-adaptive'),
          const ValueKey<String>('usage-profile-timeline-peltier'),
          const ValueKey<String>('usage-profile-timeline-fan_speed'),
        ]) {
          expect(find.byKey(key), findsNothing);
        }
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('surfaces a visible warning after local recorder writes fail', (
      tester,
    ) async {
      final recorder = UsageStatisticsRecorder.instance;
      final previousError = recorder.lastWriteError;
      recorder.lastWriteError = 'simulated write failure';
      addTearDown(() => recorder.lastWriteError = previousError);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: UsageStatisticsPage(
            coolerId: 'AA:BB:CC',
            repository: _FakeUsageRepository(
              const UsageStatsSnapshot.empty(fromMs: 0, toMs: 10000),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('History recording may be incomplete.'), findsOneWidget);
      expect(
        find.text(
          'The local history writer could not keep up with incoming readings or storage failed. Some history may be missing; check available phone storage.',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'renders active cooling run sections in the compact Home canvas',
      (tester) async {
        final previousLanguage = appLanguageNotifier.value;
        addTearDown(() => appLanguageNotifier.value = previousLanguage);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        appLanguageNotifier.value = AppLanguage.indonesia;

        final repository = _FakeUsageRepository(_sampleSnapshot());

        Future<void> pumpAtWidth(double width, ThemeData theme) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(width, 800);
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: JexFixedScalePage(
                compactUi: true,
                child: UsageStatisticsPage(
                  key: ValueKey<double>(width),
                  coolerId: 'AA:BB:CC',
                  repository: repository,
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }

        await pumpAtWidth(350, ThemeData.light(useMaterial3: true));
        expect(find.text('Suhu Baterai HP'), findsOneWidget);
        expect(find.text('Suhu Hotside'), findsOneWidget);
        expect(find.text('30D'), findsNothing);
        expect(find.text('1H'), findsNothing);
        expect(find.text('24H'), findsNothing);
        expect(find.text('7D'), findsNothing);
        expect(find.text('Selesai'), findsOneWidget);
        final elapsedHeader = tester.widget<Text>(
          find.byKey(const ValueKey<String>('usage-session-elapsed')),
        );
        expect(elapsedHeader.data, '00:10');
        for (final key in <Key>[
          const ValueKey<String>('usage-temperature-chart-battery'),
          const ValueKey<String>('usage-temperature-chart-hotside'),
        ]) {
          expect(find.byKey(key), findsOneWidget);
        }

        final profileHeadingLight = find.text('Aktivitas');
        await tester.scrollUntilVisible(
          profileHeadingLight,
          240,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(profileHeadingLight, findsOneWidget);
        expect(find.text('Rincian'), findsNothing);
        expect(find.text('More details'), findsNothing);
        expect(find.textContaining('Rata-rata kipas'), findsNothing);
        expect(find.textContaining('Touch any chart'), findsNothing);
        expect(find.text('Terpantau'), findsNothing);
        expect(find.textContaining('Sampel terakhir'), findsNothing);
        // The session header is a lazy ListView child and may unmount
        // after scrolling; its one elapsed timer was asserted before scrolling.
        for (final key in <Key>[
          const ValueKey<String>('usage-profile-timeline-voltage'),
          const ValueKey<String>('usage-profile-timeline-adaptive'),
          const ValueKey<String>('usage-profile-timeline-peltier'),
          const ValueKey<String>('usage-profile-timeline-fan_speed'),
        ]) {
          expect(find.byKey(key), findsOneWidget);
        }
        final peltierHitArea = find.byKey(
          const ValueKey<String>('usage-profile-timeline-hit-area-peltier'),
        );
        await tester.scrollUntilVisible(
          peltierHitArea,
          180,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.ensureVisible(peltierHitArea);
        await tester.pumpAndSettle();
        await tester.tap(peltierHitArea);
        await tester.pump();
        final selectedDock = find.byKey(
          const ValueKey<String>('usage-selected-time-dock'),
        );
        expect(selectedDock, findsOneWidget);
        expect(
          find.descendant(
            of: selectedDock,
            matching: find.text('Waktu dipilih'),
          ),
          findsOneWidget,
        );
        for (final label in [
          'Baterai HP',
          'Hotside',
          'Tegangan',
          'Adaptif',
          'Peltier',
          'Kecepatan Kipas',
        ]) {
          expect(
            find.descendant(of: selectedDock, matching: find.text(label)),
            findsOneWidget,
          );
        }
        expect(tester.getSize(selectedDock).height, lessThanOrEqualTo(200));
        final clearCursor = find.byTooltip('Hapus waktu pilihan');
        expect(clearCursor, findsOneWidget);
        final clearCursorSize = tester.getSize(clearCursor);
        expect(clearCursorSize.width, greaterThanOrEqualTo(48));
        expect(clearCursorSize.height, greaterThanOrEqualTo(48));
        await tester.tap(clearCursor);
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey<String>('usage-selected-time-dock')),
          findsNothing,
        );
        expect(tester.takeException(), isNull);

        await pumpAtWidth(420, ThemeData.dark(useMaterial3: true));
        expect(find.text('Suhu Baterai HP'), findsOneWidget);
        expect(find.text('Suhu Hotside'), findsOneWidget);
        expect(find.text('30D'), findsNothing);
        expect(find.text('1H'), findsNothing);
        expect(find.text('24H'), findsNothing);
        expect(find.text('7D'), findsNothing);
        expect(find.text('Selesai'), findsOneWidget);
        final profileHeadingDark = find.text('Aktivitas');
        await tester.scrollUntilVisible(
          profileHeadingDark,
          240,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(profileHeadingDark, findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'session selector and dashboard expose only one elapsed timer',
      (tester) async {
        final previousLanguage = appLanguageNotifier.value;
        addTearDown(() => appLanguageNotifier.value = previousLanguage);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(420, 1000);
        appLanguageNotifier.value = AppLanguage.english;

        final base = _sampleSnapshot();
        final secondSession = UsageStatsSession(
          id: 2,
          coolerId: 'AA:BB:CC',
          startedAtMs: 20000,
          endedAtMs: 30000,
          lastSeenAtMs: 30000,
          lastHotsideSeenAtMs: 30000,
          lastBatterySeenAtMs: 30000,
        );
        final snapshot = UsageStatsSnapshot(
          fromMs: base.fromMs,
          toMs: base.toMs,
          sessions: [...base.sessions, secondSession],
          events: base.events,
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(useMaterial3: true),
            home: UsageStatisticsPage(
              coolerId: 'AA:BB:CC',
              repository: _FakeUsageRepository(snapshot),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final sessionSelector = find.byKey(
          const ValueKey<String>('usage-session-selector'),
        );
        expect(sessionSelector, findsOneWidget);
        expect(
          tester.getSize(sessionSelector).height,
          greaterThanOrEqualTo(48),
        );
        expect(
          find.byKey(const ValueKey<String>('usage-session-elapsed')),
          findsOneWidget,
        );
        expect(find.textContaining('Last sample'), findsNothing);
        expect(find.text('More details'), findsNothing);
        expect(find.text('Observed'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('clear action delegates to the injected local repository', (
      tester,
    ) async {
      final repository = _FakeUsageRepository(_sampleSnapshot());
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(useMaterial3: true),
          home: UsageStatisticsPage(
            coolerId: 'AA:BB:CC',
            repository: repository,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Clear statistics'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear').last);
      await tester.pumpAndSettle();

      expect(repository.clearCalls, 1);
      expect(find.text('No cooling history yet.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
