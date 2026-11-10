import 'dart:io';

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
  }) async =>
      snapshot.sessions
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
    test('active state follows authoritative physical outputs, not connection or Adaptive', () {
      expect(usageCoolerIsActive(fanOn: false, peltierOn: false), isFalse);
      expect(usageCoolerIsActive(fanOn: true, peltierOn: false), isTrue);
      expect(usageCoolerIsActive(fanOn: false, peltierOn: true), isTrue);
      expect(usageCoolerIsActive(fanOn: true, peltierOn: true), isTrue);
    });

    test('elapsed time labels use the selected cooling run, not wall-clock periods', () {
      expect(formatUsageElapsed(0), '00:00');
      expect(formatUsageElapsed(1000), '00:01');
      expect(formatUsageElapsed(12 * 60 * 1000 + 35000), '12:35');
      expect(formatUsageElapsed(60 * 60 * 1000 + 2000), '1:00:02');
      expect(UsageStatisticsStore.retentionDays, 30);
    });

    test('temperature uses a duration-weighted average and preserves invalid gaps', () {
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
    });

    test('voltage duration, Adaptive ON duration and Fan Speed are time-based', () {
      final summary = UsageStatsAnalytics.summarize(_sampleSnapshot());

      expect(summary.voltageDurationMs['5V'], 4000);
      expect(summary.voltageDurationMs['9V'], 3000);
      expect(summary.voltageDurationMs['12V'], 3000);
      expect(summary.adaptiveOnDurationMs, 5000);
      expect(summary.fanSpeedAverage, 80);
      expect(summary.fanSpeedMaximum, 100);
    });

    test('Hotside trend computes valid time-weighted temperature statistics', () {
      final summary = UsageStatsAnalytics.summarize(_sampleSnapshot());

      expect(summary.hotside.minimum, 30);
      expect(summary.hotside.maximum, 35);
      expect(summary.hotside.average, 32.5);
      expect(summary.hotside.observedMs, 10000);
    });

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

  test('cooling run recording is gated by synchronized authoritative FAN/PELTIER telemetry', () {
    final main = File('lib/main.dart').readAsStringSync();
    final finalSync = main.indexOf('if (!fullSyncReceived)', main.indexOf('finalSyncDeadline'));
    final connected = main.indexOf('connected = true;', finalSync);
    final start = main.indexOf('_startUsageStatisticsSession();', connected);
    final recorderMethod = main.indexOf('void _recordUsageTelemetry(');
    final commitMethod = main.indexOf('void _commitTelemetry(');
    final telemetryHook = main.indexOf('_recordUsageTelemetry(values);', commitMethod);
    final disconnect = main.indexOf("reason: expectedOtaDisconnect ? 'ota_handoff' : 'disconnected'");

    expect(finalSync, isNonNegative);
    expect(connected, greaterThan(finalSync));
    expect(start, greaterThan(connected));
    expect(recorderMethod, isNonNegative);
    expect(telemetryHook, greaterThan(commitMethod));
    expect(disconnect, isNonNegative);
    expect(main, contains('runtimeOutputsKnown'));
    expect(main, contains('usageCoolerIsActive(fanOn: fanOn, peltierOn: peltierOn)'));
    expect(main, contains("if (outputStateReported && coolerActive)"));
    expect(main, contains("if (outputStateReported && !coolerActive)"));
    expect(main, contains('device?.remoteId.toString()'));
    expect(main, contains("metric: \'battery\'"));
  });

  test('statistics storage is local SQLite and is not added to Firmware or Firebase', () {
    final usage = File('lib/usage_statistics.dart').readAsStringSync();
    final pubspec = File('pubspec.yaml').readAsStringSync();

    expect(pubspec, contains('sqflite: 2.4.2'));
    expect(usage, contains('CREATE TABLE usage_sessions'));
    expect(usage, contains('CREATE TABLE usage_events'));
    expect(usage, contains('CREATE TABLE usage_samples'));
    expect(usage, contains('version: 2'));
    expect(usage, contains('onUpgrade: (database, oldVersion, newVersion)'));
    expect(usage, contains('recordTemperatureSample('));
    expect(usage, contains('battery_seen'));
    expect(usage, contains('hotside_seen'));
    expect(usage, contains('loadSessionSnapshot('));
    expect(usage, isNot(contains('UsagePeriod')));
    expect(usage, isNot(contains('_periodSelector')));
    expect(usage, contains('ON DELETE CASCADE'));
    expect(usage, contains('last_hotside_seen_at_ms'));
    expect(usage, contains('end_reason'));
    expect(usage, contains('Only the Firmware HOT heartbeat proves the P1 device session is fresh.'));
    expect(usage, contains('SELECT MAX(id) FROM usage_events'));
    expect(usage, contains('CREATE INDEX usage_events_timestamp'));
    expect(usage, contains('const Duration(hours: 24).inMilliseconds'));
    expect(usage, isNot(contains('FirebaseDatabase')));
  });

  group('Usage Statistics page', () {
    testWidgets('shows a localized empty state without inventing chart values', (tester) async {
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
        const ValueKey<String>('usage-profile-timeline-fan_speed'),
      ]) {
        expect(find.byKey(key), findsNothing);
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('surfaces a visible warning after local recorder writes fail', (tester) async {
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
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders active cooling run sections in the compact Home canvas', (tester) async {
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
      expect(find.text('Completed cooling run'), findsOneWidget);
      expect(find.text('00:10'), findsOneWidget);
      for (final key in <Key>[
        const ValueKey<String>('usage-temperature-chart-battery'),
        const ValueKey<String>('usage-temperature-chart-hotside'),
      ]) {
        expect(find.byKey(key), findsOneWidget);
      }

      final profileHeadingLight = find.text('Riwayat Operasi');
      await tester.scrollUntilVisible(
        profileHeadingLight,
        240,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(profileHeadingLight, findsOneWidget);
      for (final key in <Key>[
        const ValueKey<String>('usage-profile-timeline-voltage'),
        const ValueKey<String>('usage-profile-timeline-adaptive'),
        const ValueKey<String>('usage-profile-timeline-fan_speed'),
      ]) {
        expect(find.byKey(key), findsOneWidget);
      }

      await pumpAtWidth(420, ThemeData.dark(useMaterial3: true));
      expect(find.text('Suhu Baterai HP'), findsOneWidget);
      expect(find.text('Suhu Hotside'), findsOneWidget);
      expect(find.text('30D'), findsNothing);
      expect(find.text('1H'), findsNothing);
      expect(find.text('24H'), findsNothing);
      expect(find.text('7D'), findsNothing);
      expect(find.text('Completed cooling run'), findsOneWidget);
      final profileHeadingDark = find.text('Riwayat Operasi');
      await tester.scrollUntilVisible(
        profileHeadingDark,
        240,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(profileHeadingDark, findsOneWidget);
      expect(tester.takeException(), isNull);

    });

    testWidgets(
      'last valid sample uses the latest persisted temperature sample',
      (tester) async {
        final previousLanguage = appLanguageNotifier.value;
        addTearDown(() => appLanguageNotifier.value = previousLanguage);
        appLanguageNotifier.value = AppLanguage.english;

        final startMs = DateTime(2026, 1, 1, 8).millisecondsSinceEpoch;
        final hotsideSampleMs =
            startMs + const Duration(minutes: 2).inMilliseconds;
        final latestSampleMs =
            startMs + const Duration(minutes: 4).inMilliseconds;
        final endMs = startMs + const Duration(minutes: 10).inMilliseconds;
        final snapshot = UsageStatsSnapshot(
          fromMs: startMs,
          toMs: endMs,
          sessions: [
            UsageStatsSession(
              id: 7,
              coolerId: 'AA:BB:CC',
              startedAtMs: startMs,
              endedAtMs: endMs,
              lastSeenAtMs: endMs,
              lastHotsideSeenAtMs: endMs,
              lastBatterySeenAtMs: endMs,
            ),
          ],
          events: [
            UsageStatsEvent(
              sessionId: 7,
              timestampMs: startMs,
              metric: 'battery',
              numberValue: 20,
              textValue: null,
            ),
            UsageStatsEvent(
              sessionId: 7,
              timestampMs: hotsideSampleMs,
              metric: 'hotside',
              numberValue: 35,
              textValue: null,
            ),
            UsageStatsEvent(
              sessionId: 7,
              timestampMs: latestSampleMs,
              metric: 'battery',
              numberValue: 21,
              textValue: null,
            ),
          ],
        );
        expect(
          UsageStatsAnalytics.lastTemperatureSampleAtMs(snapshot),
          latestSampleMs,
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

        final lastValidSample = find.textContaining(
          'Stored locally on this phone. Last valid sample: 04:00',
        );
        await tester.scrollUntilVisible(
          lastValidSample,
          240,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        expect(lastValidSample, findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('clear action delegates to the injected local repository', (tester) async {
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
