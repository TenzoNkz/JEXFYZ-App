// AI-MEMORY / FILE CONTRACT
// Owns App-local Usage Statistics persistence, telemetry recording, analytics and Settings page.
// P1 telemetry and Android battery readings are the only data sources; no inferred measurements.
// A session is bounded by a fully synchronized BLE/P1 session and cooler identity.
// Invalid readings, disconnects, process loss and sensor staleness remain explicit gaps.

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'app_settings.dart';

enum UsagePeriod { hour, day, week }

extension UsagePeriodContract on UsagePeriod {
  Duration get duration {
    switch (this) {
      case UsagePeriod.hour:
        return const Duration(hours: 1);
      case UsagePeriod.day:
        return const Duration(hours: 24);
      case UsagePeriod.week:
        return const Duration(days: 7);
    }
  }

  String get label {
    switch (this) {
      case UsagePeriod.hour:
        return '1H';
      case UsagePeriod.day:
        return '24H';
      case UsagePeriod.week:
        return '7D';
    }
  }
}

class UsageStatsSession {
  final int id;
  final String coolerId;
  final int startedAtMs;
  final int? endedAtMs;
  final int lastSeenAtMs;
  final int? lastHotsideSeenAtMs;
  final int? lastBatterySeenAtMs;

  const UsageStatsSession({
    required this.id,
    required this.coolerId,
    required this.startedAtMs,
    required this.endedAtMs,
    required this.lastSeenAtMs,
    required this.lastHotsideSeenAtMs,
    required this.lastBatterySeenAtMs,
  });

  factory UsageStatsSession.fromMap(Map<String, Object?> map) {
    int readInt(String key) => (map[key] as num).toInt();
    int? readNullableInt(String key) {
      final value = map[key];
      return value is num ? value.toInt() : null;
    }

    return UsageStatsSession(
      id: readInt('id'),
      coolerId: map['cooler_id'] as String,
      startedAtMs: readInt('started_at_ms'),
      endedAtMs: readNullableInt('ended_at_ms'),
      lastSeenAtMs: readInt('last_seen_at_ms'),
      lastHotsideSeenAtMs: readNullableInt('last_hotside_seen_at_ms'),
      lastBatterySeenAtMs: readNullableInt('last_battery_seen_at_ms'),
    );
  }

  int? lastSeenFor(String metric) {
    switch (metric) {
      case 'hotside':
        return lastHotsideSeenAtMs;
      case 'battery':
        return lastBatterySeenAtMs;
      default:
        return null;
    }
  }
}

class UsageStatsEvent {
  final int sessionId;
  final int timestampMs;
  final String metric;
  final double? numberValue;
  final String? textValue;

  const UsageStatsEvent({
    required this.sessionId,
    required this.timestampMs,
    required this.metric,
    required this.numberValue,
    required this.textValue,
  });

  factory UsageStatsEvent.fromMap(Map<String, Object?> map) {
    final rawNumber = map['value_num'];
    return UsageStatsEvent(
      sessionId: (map['session_id'] as num).toInt(),
      timestampMs: (map['timestamp_ms'] as num).toInt(),
      metric: map['metric'] as String,
      numberValue: rawNumber is num ? rawNumber.toDouble() : null,
      textValue: map['value_text'] as String?,
    );
  }
}

class UsageStatsSnapshot {
  final int fromMs;
  final int toMs;
  final List<UsageStatsSession> sessions;
  final List<UsageStatsEvent> events;

  const UsageStatsSnapshot({
    required this.fromMs,
    required this.toMs,
    required this.sessions,
    required this.events,
  });

  const UsageStatsSnapshot.empty({
    required this.fromMs,
    required this.toMs,
  })  : sessions = const [],
        events = const [];
}

class UsageChartPoint {
  final int timestampMs;
  final double? value;
  final int sessionId;
  final bool breakBefore;

  const UsageChartPoint({
    required this.timestampMs,
    required this.value,
    required this.sessionId,
    this.breakBefore = false,
  });
}

class UsageTemperatureSummary {
  final double? minimum;
  final double? maximum;
  final double? average;
  final int observedMs;
  final List<UsageChartPoint> points;

  const UsageTemperatureSummary({
    required this.minimum,
    required this.maximum,
    required this.average,
    required this.observedMs,
    required this.points,
  });

  bool get hasData => observedMs > 0 && minimum != null && maximum != null;
}

class UsageStateSegment {
  final int startMs;
  final int endMs;
  final int sessionId;
  final String metric;
  final String? textValue;
  final double? numberValue;

  const UsageStateSegment({
    required this.startMs,
    required this.endMs,
    required this.sessionId,
    required this.metric,
    required this.textValue,
    required this.numberValue,
  });

  int get durationMs => math.max(0, endMs - startMs).toInt();
}

class UsageStatsSummary {
  final UsageTemperatureSummary battery;
  final UsageTemperatureSummary hotside;
  final Map<String, int> voltageDurationMs;
  final int adaptiveOnDurationMs;
  final double? fanSpeedAverage;
  final double? fanSpeedMaximum;
  final List<UsageStateSegment> voltageSegments;
  final List<UsageStateSegment> adaptiveSegments;
  final List<UsageStateSegment> fanSpeedSegments;

  const UsageStatsSummary({
    required this.battery,
    required this.hotside,
    required this.voltageDurationMs,
    required this.adaptiveOnDurationMs,
    required this.fanSpeedAverage,
    required this.fanSpeedMaximum,
    required this.voltageSegments,
    required this.adaptiveSegments,
    required this.fanSpeedSegments,
  });

  bool get hasData =>
      battery.hasData ||
      hotside.hasData ||
      voltageSegments.isNotEmpty ||
      adaptiveSegments.isNotEmpty ||
      fanSpeedSegments.isNotEmpty;
}

abstract interface class UsageStatisticsRepository {
  Future<UsageStatsSnapshot> loadSnapshot({
    required String coolerId,
    required Duration period,
    int? nowMs,
  });

  Future<void> clearCooler(String coolerId);
}

class UsageStatsAnalytics {
  static UsageStatsSummary summarize(UsageStatsSnapshot snapshot) {
    final battery = _temperatureSummary(snapshot, 'battery');
    final hotside = _temperatureSummary(snapshot, 'hotside');
    final voltage = _stateSegments(snapshot, 'voltage');
    final adaptive = _stateSegments(snapshot, 'adaptive');
    final fan = _stateSegments(snapshot, 'fan_speed');

    final voltageTimes = <String, int>{'5V': 0, '9V': 0, '12V': 0};
    for (final segment in voltage) {
      final value = segment.textValue?.toUpperCase();
      if (value != null && voltageTimes.containsKey(value)) {
        voltageTimes[value] = voltageTimes[value]! + segment.durationMs;
      }
    }

    var adaptiveOnMs = 0;
    for (final segment in adaptive) {
      if (segment.textValue?.toUpperCase() == 'ON') {
        adaptiveOnMs += segment.durationMs;
      }
    }

    var fanWeighted = 0.0;
    var fanObservedMs = 0;
    double? fanMaximum;
    for (final segment in fan) {
      final value = segment.numberValue;
      if (value == null || segment.durationMs <= 0) continue;
      fanWeighted += value * segment.durationMs;
      fanObservedMs += segment.durationMs;
      fanMaximum = fanMaximum == null
          ? value
          : math.max(fanMaximum, value).toDouble();
    }

    return UsageStatsSummary(
      battery: battery,
      hotside: hotside,
      voltageDurationMs: voltageTimes,
      adaptiveOnDurationMs: adaptiveOnMs,
      fanSpeedAverage:
          fanObservedMs == 0 ? null : fanWeighted / fanObservedMs,
      fanSpeedMaximum: fanMaximum,
      voltageSegments: voltage,
      adaptiveSegments: adaptive,
      fanSpeedSegments: fan,
    );
  }

  static UsageTemperatureSummary _temperatureSummary(
    UsageStatsSnapshot snapshot,
    String metric,
  ) {
    double? minimum;
    double? maximum;
    var weightedSum = 0.0;
    var observedMs = 0;
    final points = <UsageChartPoint>[];

    for (final session in snapshot.sessions) {
      final lastSeen = session.lastSeenFor(metric);
      if (lastSeen == null) continue;

      final sessionStart = math.max(snapshot.fromMs, session.startedAtMs).toInt();
      final sessionEnd = math.min(
        snapshot.toMs,
        math.min(
          session.endedAtMs ?? snapshot.toMs,
          lastSeen + const Duration(milliseconds: 1500).inMilliseconds,
        ),
      ).toInt();
      if (sessionEnd <= sessionStart) continue;

      final events = snapshot.events
          .where((event) =>
              event.sessionId == session.id && event.metric == metric)
          .toList()
        ..sort((a, b) => a.timestampMs.compareTo(b.timestampMs));

      UsageStatsEvent? previous;
      for (final event in events) {
        if (event.timestampMs <= sessionStart) {
          previous = event;
        } else {
          break;
        }
      }

      double? currentValue = previous?.numberValue;
      var cursor = sessionStart;
      if (currentValue != null) {
        points.add(UsageChartPoint(
          timestampMs: sessionStart,
          value: currentValue,
          sessionId: session.id,
          breakBefore: true,
        ));
      }

      for (final event in events) {
        if (event.timestampMs <= sessionStart) continue;
        if (event.timestampMs > sessionEnd) break;

        final intervalMs = event.timestampMs - cursor;
        if (currentValue != null && intervalMs > 0) {
          weightedSum += currentValue * intervalMs;
          observedMs += intervalMs;
          minimum = minimum == null
              ? currentValue
              : math.min(minimum, currentValue).toDouble();
          maximum = maximum == null
              ? currentValue
              : math.max(maximum, currentValue).toDouble();
        }

        final previousWasValid = currentValue != null;
        cursor = event.timestampMs;
        currentValue = event.numberValue;
        points.add(UsageChartPoint(
          timestampMs: event.timestampMs,
          value: event.numberValue,
          sessionId: session.id,
          breakBefore: !previousWasValid || event.numberValue == null,
        ));
      }

      final trailingMs = sessionEnd - cursor;
      if (currentValue != null && trailingMs > 0) {
        weightedSum += currentValue * trailingMs;
        observedMs += trailingMs;
        minimum = minimum == null
            ? currentValue
            : math.min(minimum, currentValue).toDouble();
        maximum = maximum == null
            ? currentValue
            : math.max(maximum, currentValue).toDouble();
        points.add(UsageChartPoint(
          timestampMs: sessionEnd,
          value: currentValue,
          sessionId: session.id,
        ));
      }
    }

    points.sort((a, b) => a.timestampMs.compareTo(b.timestampMs));
    return UsageTemperatureSummary(
      minimum: minimum,
      maximum: maximum,
      average: observedMs == 0 ? null : weightedSum / observedMs,
      observedMs: observedMs,
      points: points,
    );
  }

  static List<UsageStateSegment> _stateSegments(
    UsageStatsSnapshot snapshot,
    String metric,
  ) {
    final result = <UsageStateSegment>[];

    for (final session in snapshot.sessions) {
      final sessionStart = math.max(snapshot.fromMs, session.startedAtMs).toInt();
      final sessionEnd = math.min(
        snapshot.toMs,
        math.min(
          session.endedAtMs ?? snapshot.toMs,
          session.lastSeenAtMs +
              const Duration(milliseconds: 1500).inMilliseconds,
        ),
      ).toInt();
      if (sessionEnd <= sessionStart) continue;

      final events = snapshot.events
          .where((event) =>
              event.sessionId == session.id && event.metric == metric)
          .toList()
        ..sort((a, b) => a.timestampMs.compareTo(b.timestampMs));

      UsageStatsEvent? previous;
      for (final event in events) {
        if (event.timestampMs <= sessionStart) {
          previous = event;
        } else {
          break;
        }
      }

      var cursor = sessionStart;
      String? currentText = previous?.textValue;
      double? currentNumber = previous?.numberValue;

      for (final event in events) {
        if (event.timestampMs <= sessionStart) continue;
        if (event.timestampMs > sessionEnd) break;

        if (event.timestampMs > cursor &&
            (currentText != null || currentNumber != null)) {
          result.add(UsageStateSegment(
            startMs: cursor,
            endMs: event.timestampMs,
            sessionId: session.id,
            metric: metric,
            textValue: currentText,
            numberValue: currentNumber,
          ));
        }

        cursor = event.timestampMs;
        currentText = event.textValue;
        currentNumber = event.numberValue;
      }

      if (sessionEnd > cursor &&
          (currentText != null || currentNumber != null)) {
        result.add(UsageStateSegment(
          startMs: cursor,
          endMs: sessionEnd,
          sessionId: session.id,
          metric: metric,
          textValue: currentText,
          numberValue: currentNumber,
        ));
      }
    }

    result.sort((a, b) => a.startMs.compareTo(b.startMs));
    return result;
  }
}

class UsageStatisticsStore implements UsageStatisticsRepository {
  UsageStatisticsStore._();

  static final UsageStatisticsStore instance = UsageStatisticsStore._();
  static const String _databaseName = 'jexfyz_usage_statistics.db';
  static const int retentionDays = 7;

  Future<Database>? _databaseFuture;
  int _lastPrunedAtMs = 0;

  Future<Database> get _database => _databaseFuture ??= _openDatabase();

  Future<void> _pruneIfDue(int timestampMs) async {
    if (_lastPrunedAtMs > 0 &&
        timestampMs - _lastPrunedAtMs <
            const Duration(hours: 24).inMilliseconds) {
      return;
    }

    final database = await _database;
    final cutoff =
        timestampMs - const Duration(days: retentionDays).inMilliseconds;
    await database.rawDelete(
      'DELETE FROM usage_events WHERE timestamp_ms < ? '
      'AND id NOT IN (SELECT MAX(id) FROM usage_events '
      'WHERE timestamp_ms < ? GROUP BY session_id, metric)',
      [cutoff, cutoff],
    );
    await database.delete(
      'usage_sessions',
      where: 'COALESCE(ended_at_ms, last_seen_at_ms) < ?',
      whereArgs: [cutoff],
    );
    _lastPrunedAtMs = timestampMs;
  }

  Future<Database> _openDatabase() async {
    final directory = await getDatabasesPath();
    final databasePath = p.join(directory, _databaseName);

    return openDatabase(
      databasePath,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE usage_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cooler_id TEXT NOT NULL,
            started_at_ms INTEGER NOT NULL,
            ended_at_ms INTEGER,
            last_seen_at_ms INTEGER NOT NULL,
            last_hotside_seen_at_ms INTEGER,
            last_battery_seen_at_ms INTEGER,
            end_reason TEXT
          )
        ''');
        await database.execute('''
          CREATE TABLE usage_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id INTEGER NOT NULL,
            timestamp_ms INTEGER NOT NULL,
            metric TEXT NOT NULL,
            value_num REAL,
            value_text TEXT,
            FOREIGN KEY(session_id) REFERENCES usage_sessions(id)
              ON DELETE CASCADE
          )
        ''');
        await database.execute(
          'CREATE INDEX usage_events_session_metric_time '
          'ON usage_events(session_id, metric, timestamp_ms)',
        );
        await database.execute(
          'CREATE INDEX usage_sessions_cooler_start '
          'ON usage_sessions(cooler_id, started_at_ms)',
        );
        await database.execute(
          'CREATE INDEX usage_events_timestamp ON usage_events(timestamp_ms)',
        );
      },
      onOpen: (database) async {
        // A process restart closes a session at its last real telemetry receipt.
        await database.rawUpdate(
          "UPDATE usage_sessions "
          "SET ended_at_ms = last_seen_at_ms, "
          "end_reason = 'process_interrupted' "
          'WHERE ended_at_ms IS NULL',
        );
        final now = DateTime.now().millisecondsSinceEpoch;
        final cutoff =
            now - const Duration(days: retentionDays).inMilliseconds;
        await database.rawDelete(
          'DELETE FROM usage_events WHERE timestamp_ms < ? '
          'AND id NOT IN (SELECT MAX(id) FROM usage_events '
          'WHERE timestamp_ms < ? GROUP BY session_id, metric)',
          [cutoff, cutoff],
        );
        await database.delete(
          'usage_sessions',
          where: 'COALESCE(ended_at_ms, last_seen_at_ms) < ?',
          whereArgs: [cutoff],
        );
        _lastPrunedAtMs = now;
      },
    );
  }

  Future<int> startSession({
    required String coolerId,
    required int timestampMs,
    double? batteryC,
    double? hotsideC,
    String? voltage,
    String? adaptive,
    int? fanSpeed,
  }) async {
    final database = await _database;
    return database.transaction((transaction) async {
      await transaction.rawUpdate(
        "UPDATE usage_sessions "
        "SET ended_at_ms = last_seen_at_ms, "
        "end_reason = 'superseded_session' "
        'WHERE ended_at_ms IS NULL',
      );

      final sessionId = await transaction.insert('usage_sessions', {
        'cooler_id': coolerId,
        'started_at_ms': timestampMs,
        'last_seen_at_ms': timestampMs,
        'last_hotside_seen_at_ms': hotsideC == null ? null : timestampMs,
        'last_battery_seen_at_ms': batteryC == null ? null : timestampMs,
      });

      Future<void> insertBaseline(
        String metric, {
        double? numberValue,
        String? textValue,
      }) async {
        if (numberValue == null && textValue == null) return;
        await transaction.insert('usage_events', {
          'session_id': sessionId,
          'timestamp_ms': timestampMs,
          'metric': metric,
          'value_num': numberValue,
          'value_text': textValue,
        });
      }

      await insertBaseline('battery', numberValue: batteryC);
      await insertBaseline('hotside', numberValue: hotsideC);
      await insertBaseline('voltage', textValue: voltage);
      await insertBaseline('adaptive', textValue: adaptive);
      await insertBaseline('fan_speed', numberValue: fanSpeed?.toDouble());
      return sessionId;
    });
  }

  Future<void> recordEvent({
    required int sessionId,
    required int timestampMs,
    required String metric,
    double? numberValue,
    String? textValue,
  }) async {
    final database = await _database;
    await database.insert('usage_events', {
      'session_id': sessionId,
      'timestamp_ms': timestampMs,
      'metric': metric,
      'value_num': numberValue,
      'value_text': textValue,
    });
  }

  Future<void> touchSensor({
    required int sessionId,
    required String metric,
    required int timestampMs,
  }) async {
    final database = await _database;
    await _pruneIfDue(timestampMs);
    if (metric == 'hotside') {
      // Only the Firmware HOT heartbeat proves the P1 device session is fresh.
      await database.update(
        'usage_sessions',
        {
          'last_seen_at_ms': timestampMs,
          'last_hotside_seen_at_ms': timestampMs,
        },
        where: 'id = ? AND ended_at_ms IS NULL',
        whereArgs: [sessionId],
      );
    } else {
      // Phone battery samples have their own freshness and cannot extend
      // Firmware state timelines when the cooler telemetry stream has stopped.
      await database.update(
        'usage_sessions',
        {'last_battery_seen_at_ms': timestampMs},
        where: 'id = ? AND ended_at_ms IS NULL',
        whereArgs: [sessionId],
      );
    }
  }

  Future<void> touchSession(int sessionId, int timestampMs) async {
    final database = await _database;
    await database.update(
      'usage_sessions',
      {'last_seen_at_ms': timestampMs},
      where: 'id = ? AND ended_at_ms IS NULL',
      whereArgs: [sessionId],
    );
  }

  Future<void> endSession({
    required int sessionId,
    required int timestampMs,
    required String reason,
  }) async {
    final database = await _database;
    await database.update(
      'usage_sessions',
      {
        'ended_at_ms': timestampMs,
        'end_reason': reason,
      },
      where: 'id = ? AND ended_at_ms IS NULL',
      whereArgs: [sessionId],
    );
  }

  @override
  Future<UsageStatsSnapshot> loadSnapshot({
    required String coolerId,
    required Duration period,
    int? nowMs,
  }) async {
    final end = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final start = end - period.inMilliseconds;
    final database = await _database;
    final sessionMaps = await database.query(
      'usage_sessions',
      where: 'cooler_id = ? AND started_at_ms <= ? '
          'AND COALESCE(ended_at_ms, last_seen_at_ms) >= ?',
      whereArgs: [coolerId, end, start],
      orderBy: 'started_at_ms ASC',
    );

    if (sessionMaps.isEmpty) {
      return UsageStatsSnapshot.empty(fromMs: start, toMs: end);
    }

    final sessions =
        sessionMaps.map(UsageStatsSession.fromMap).toList(growable: false);
    final ids = sessions.map((session) => session.id).toList(growable: false);
    final placeholders = List<String>.filled(ids.length, '?').join(',');
    final eventMaps = await database.rawQuery(
      'SELECT e.session_id, e.timestamp_ms, e.metric, e.value_num, e.value_text '
      'FROM usage_events e '
      'WHERE e.session_id IN (' +
          placeholders +
          ') AND e.timestamp_ms <= ? '
          'AND (e.timestamp_ms >= ? OR e.id = ('
          'SELECT prior.id FROM usage_events prior '
          'WHERE prior.session_id = e.session_id '
          'AND prior.metric = e.metric AND prior.timestamp_ms < ? '
          'ORDER BY prior.timestamp_ms DESC LIMIT 1)) '
          'ORDER BY e.session_id ASC, e.timestamp_ms ASC',
      [...ids, end, start, start],
    );

    return UsageStatsSnapshot(
      fromMs: start,
      toMs: end,
      sessions: sessions,
      events: eventMaps
          .map(UsageStatsEvent.fromMap)
          .toList(growable: false),
    );
  }

  @override
  Future<void> clearCooler(String coolerId) async {
    final database = await _database;
    await database.delete(
      'usage_sessions',
      where: 'cooler_id = ?',
      whereArgs: [coolerId],
    );
  }
}

class UsageStatisticsRecorder {
  UsageStatisticsRecorder._();

  static final UsageStatisticsRecorder instance =
      UsageStatisticsRecorder._();

  final UsageStatisticsStore _store = UsageStatisticsStore.instance;
  final ValueNotifier<int> revisionNotifier = ValueNotifier<int>(0);
  Future<void> _queue = Future<void>.value();
  int? _sessionId;
  String? _coolerId;
  final Map<String, double?> _temperatures = {};
  final Map<String, Object?> _states = {};
  final Map<String, int> _lastSensorSeenMs = {};

  Future<void> _enqueue(Future<void> Function() operation) {
    _queue = _queue.then((_) async {
      try {
        await operation();
      } catch (error) {
        debugPrint('Usage statistics write: ' + error.toString());
      }
    });
    return _queue;
  }

  void _notifyChanged() {
    revisionNotifier.value++;
  }

  Future<void> startSession({
    required String coolerId,
    double? batteryC,
    double? hotsideC,
    String? voltage,
    String? adaptive,
    int? fanSpeed,
  }) {
    final safeId = coolerId.trim();
    if (safeId.isEmpty) return Future<void>.value();

    return _enqueue(() async {
      final now = DateTime.now().millisecondsSinceEpoch;
      _sessionId = await _store.startSession(
        coolerId: safeId,
        timestampMs: now,
        batteryC: batteryC,
        hotsideC: hotsideC,
        voltage: voltage,
        adaptive: adaptive,
        fanSpeed: fanSpeed,
      );
      _coolerId = safeId;
      _temperatures
        ..clear()
        ..['battery'] = batteryC
        ..['hotside'] = hotsideC;
      _states
        ..clear()
        ..['voltage'] = voltage
        ..['adaptive'] = adaptive
        ..['fan_speed'] = fanSpeed;
      _lastSensorSeenMs.clear();
      if (batteryC != null) _lastSensorSeenMs['battery'] = now;
      if (hotsideC != null) _lastSensorSeenMs['hotside'] = now;
      _notifyChanged();
    });
  }

  Future<void> recordTemperature({
    required String metric,
    required double? value,
  }) {
    if (metric != 'battery' && metric != 'hotside') {
      return Future<void>.value();
    }

    final safeValue =
        value != null && value.isFinite && value >= 0 && value <= 100
            ? value
            : null;

    return _enqueue(() async {
      final sessionId = _sessionId;
      if (sessionId == null) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      final lastSeen = _lastSensorSeenMs[metric];
      var previous = _temperatures[metric];

      if (lastSeen != null &&
          now - lastSeen >
              const Duration(milliseconds: 2500).inMilliseconds &&
          previous != null) {
        await _store.recordEvent(
          sessionId: sessionId,
          timestampMs: lastSeen +
              const Duration(milliseconds: 1500).inMilliseconds,
          metric: metric,
        );
        previous = null;
      }

      final changed = previous == null
          ? safeValue != null
          : safeValue == null || (previous - safeValue).abs() >= 0.05;
      if (changed) {
        await _store.recordEvent(
          sessionId: sessionId,
          timestampMs: now,
          metric: metric,
          numberValue: safeValue,
        );
      }

      // The 1 Hz sensor receipt updates freshness even when the numeric value
      // has not changed, so the chart holds the last reading only while observed.
      await _store.touchSensor(
        sessionId: sessionId,
        metric: metric,
        timestampMs: now,
      );
      _temperatures[metric] = safeValue;
      _lastSensorSeenMs[metric] = now;
      _notifyChanged();
    });
  }

  Future<void> recordState({
    required String metric,
    required Object? value,
  }) {
    if (!const {'voltage', 'adaptive', 'fan_speed'}.contains(metric)) {
      return Future<void>.value();
    }

    Object? canonical;
    if (metric == 'voltage') {
      if (value is! String ||
          !const {'5V', '9V', '12V'}.contains(value.toUpperCase())) {
        return Future<void>.value();
      }
      canonical = value.toUpperCase();
    } else if (metric == 'adaptive') {
      if (value is! String ||
          !const {'ON', 'OFF'}.contains(value.toUpperCase())) {
        return Future<void>.value();
      }
      canonical = value.toUpperCase();
    } else {
      if (value is! num || !value.isFinite) return Future<void>.value();
      canonical = value.round().clamp(0, 100).toInt();
    }

    return _enqueue(() async {
      final sessionId = _sessionId;
      if (sessionId == null) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      final previous = _states[metric];
      if (previous == canonical) {
        await _store.touchSession(sessionId, now);
        _notifyChanged();
        return;
      }

      final numeric = canonical is num ? canonical.toDouble() : null;
      final text = canonical is String ? canonical : null;
      await _store.recordEvent(
        sessionId: sessionId,
        timestampMs: now,
        metric: metric,
        numberValue: numeric,
        textValue: text,
      );
      await _store.touchSession(sessionId, now);
      _states[metric] = canonical;
      _notifyChanged();
    });
  }

  Future<void> endSession({String reason = 'disconnected'}) {
    return _enqueue(() async {
      final id = _sessionId;
      if (id == null) return;

      await _store.endSession(
        sessionId: id,
        timestampMs: DateTime.now().millisecondsSinceEpoch,
        reason: reason,
      );
      _sessionId = null;
      _coolerId = null;
      _temperatures.clear();
      _states.clear();
      _lastSensorSeenMs.clear();
      _notifyChanged();
    });
  }

  Future<void> clearHistory(String coolerId) {
    final safeId = coolerId.trim();
    if (safeId.isEmpty) return Future<void>.value();

    return _enqueue(() async {
      final active = _coolerId == safeId;
      await _store.clearCooler(safeId);
      if (!active) {
        _notifyChanged();
        return;
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      _sessionId = await _store.startSession(
        coolerId: safeId,
        timestampMs: now,
        batteryC: _temperatures['battery'],
        hotsideC: _temperatures['hotside'],
        voltage: _states['voltage'] as String?,
        adaptive: _states['adaptive'] as String?,
        fanSpeed: (_states['fan_speed'] as num?)?.toInt(),
      );
      _lastSensorSeenMs
        ..clear()
        ..addAll({
          for (final entry in _temperatures.entries)
            if (entry.value != null) entry.key: now,
        });
      _notifyChanged();
    });
  }
}

class UsageStatisticsPage extends StatefulWidget {
  final String? coolerId;
  final int hotLimit;
  final UsageStatisticsRepository? repository;
  final Future<void> Function(String coolerId)? onClearHistory;

  const UsageStatisticsPage({
    super.key,
    required this.coolerId,
    this.hotLimit = 45,
    this.repository,
    this.onClearHistory,
  });

  @override
  State<UsageStatisticsPage> createState() => _UsageStatisticsPageState();
}

class _UsageStatisticsPageState extends State<UsageStatisticsPage>
    with WidgetsBindingObserver {
  UsagePeriod _period = UsagePeriod.day;
  UsageStatsSnapshot? _snapshot;
  UsageStatsSummary? _summary;
  bool _loading = true;
  bool _queryRunning = false;
  bool _reloadPending = false;
  Timer? _reloadTimer;
  String? _error;

  UsageStatisticsRepository get _repository =>
      widget.repository ?? UsageStatisticsStore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    UsageStatisticsRecorder.instance.revisionNotifier
        .addListener(_handleRecorderChange);
    _load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load(silent: true);
  }

  @override
  void dispose() {
    _reloadTimer?.cancel();
    UsageStatisticsRecorder.instance.revisionNotifier
        .removeListener(_handleRecorderChange);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleRecorderChange() {
    _reloadTimer?.cancel();
    _reloadTimer = Timer(const Duration(milliseconds: 450), () {
      _load(silent: true);
    });
  }

  Future<void> _load({bool silent = false}) async {
    if (_queryRunning) {
      _reloadPending = true;
      return;
    }

    final coolerId = widget.coolerId?.trim();
    if (coolerId == null || coolerId.isEmpty) {
      if (mounted) {
        setState(() {
          _snapshot = null;
          _summary = null;
          _loading = false;
          _error = null;
        });
      }
      return;
    }

    _queryRunning = true;
    if (!silent && mounted) setState(() => _loading = true);

    do {
      _reloadPending = false;
      try {
        final snapshot = await _repository.loadSnapshot(
          coolerId: coolerId,
          period: _period.duration,
        );
        final summary = UsageStatsAnalytics.summarize(snapshot);
        if (!mounted) break;
        setState(() {
          _snapshot = snapshot;
          _summary = summary;
          _loading = false;
          _error = null;
        });
      } catch (error) {
        if (!mounted) break;
        setState(() {
          _loading = false;
          _error = error.toString();
        });
      }
    } while (_reloadPending && mounted);

    _queryRunning = false;
  }

  Future<void> _clearHistory() async {
    final language = appLanguageNotifier.value;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(JexText.phrase(
          'Clear usage statistics?',
          'Hapus statistik penggunaan?',
          language,
        )),
        content: Text(JexText.phrase(
          'This removes the locally stored history for this cooler.',
          'Ini menghapus riwayat lokal untuk cooler ini.',
          language,
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(JexText.of('cancel', language)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(JexText.phrase('Clear', 'Hapus', language)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final coolerId = widget.coolerId?.trim();
    if (coolerId == null || coolerId.isEmpty) return;
    try {
      if (widget.onClearHistory != null) {
        await widget.onClearHistory!(coolerId);
      } else if (widget.repository != null) {
        await _repository.clearCooler(coolerId);
      } else {
        await UsageStatisticsRecorder.instance.clearHistory(coolerId);
      }
      await _load();
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: appLanguageNotifier,
      builder: (context, language, _) => _buildForLanguage(language),
    );
  }

  Widget _buildForLanguage(AppLanguage language) {
    final scheme = Theme.of(context).colorScheme;
    final summary = _summary;
    final coolerAvailable =
        widget.coolerId != null && widget.coolerId!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(JexText.phrase(
          'Usage Statistics',
          'Statistik Penggunaan',
          language,
        )),
        actions: [
          IconButton(
            tooltip: JexText.phrase(
              'Clear statistics',
              'Hapus statistik',
              language,
            ),
            onPressed: coolerAvailable ? _clearHistory : null,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 28),
          children: [
            _periodSelector(),
            const SizedBox(height: 16),
            if (_loading && summary == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 36),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _messageState(
                JexText.phrase(
                  'Statistics could not be loaded.',
                  'Statistik tidak dapat dimuat.',
                  language,
                ),
                JexText.phrase(
                  'Check local storage and try again.',
                  'Periksa penyimpanan lokal lalu coba lagi.',
                  language,
                ),
                scheme,
                action: TextButton(
                  onPressed: _load,
                  child: Text(JexText.phrase('Retry', 'Coba lagi', language)),
                ),
              )
            else if (!coolerAvailable)
              _messageState(
                JexText.phrase(
                  'No cooler selected.',
                  'Belum ada cooler yang dipilih.',
                  language,
                ),
                JexText.phrase(
                  'Connect your cooler once to start collecting its local history.',
                  'Hubungkan cooler setidaknya sekali untuk mulai merekam riwayat lokalnya.',
                  language,
                ),
                scheme,
              )
            else if (summary == null || !summary.hasData)
              _messageState(
                JexText.phrase(
                  'No usage data yet.',
                  'Belum ada data penggunaan.',
                  language,
                ),
                JexText.phrase(
                  'Connect your cooler with JE Cooler to start recording real readings and operating changes.',
                  'Hubungkan cooler dengan JE Cooler untuk mulai merekam suhu dan perubahan operasi yang sebenarnya.',
                  language,
                ),
                scheme,
              )
            else ...[
              _temperatureSection(
                title: JexText.phrase(
                  'Phone Battery Temperature',
                  'Suhu Baterai HP',
                  language,
                ),
                summary: summary.battery,
                color: scheme.primary,
                language: language,
              ),
              const SizedBox(height: 22),
              _temperatureSection(
                title: JexText.phrase(
                  'Hotside Temperature',
                  'Suhu Hotside',
                  language,
                ),
                summary: summary.hotside,
                color: scheme.tertiary,
                language: language,
                referenceValue: widget.hotLimit.toDouble(),
              ),
              const SizedBox(height: 22),
              _profileSection(summary, language, scheme),
              const SizedBox(height: 12),
              Text(
                JexText.phrase(
                  'History is recorded only while valid BLE/P1 telemetry is received. Missing, invalid or disconnected periods are shown as gaps.',
                  'Riwayat hanya direkam saat telemetry BLE/P1 yang valid diterima. Periode tanpa data, data tidak valid, atau terputus ditampilkan sebagai celah.',
                  language,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              Text(
                JexText.phrase(
                  'Stored locally on this phone. Last value change: ',
                  'Disimpan lokal di ponsel ini. Perubahan nilai terakhir: ',
                  language,
                ) +
                    _formatLastSample(summary, language),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
            if (_loading && summary != null) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _periodSelector() {
    return SegmentedButton<UsagePeriod>(
      segments: [
        for (final period in UsagePeriod.values)
          ButtonSegment<UsagePeriod>(
            value: period,
            label: Text(period.label),
          ),
      ],
      selected: {_period},
      onSelectionChanged: (selection) {
        if (selection.isEmpty || selection.first == _period) return;
        setState(() => _period = selection.first);
        _load();
      },
      showSelectedIcon: false,
    );
  }

  Widget _messageState(
    String title,
    String message,
    ColorScheme scheme, {
    Widget? action,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 42),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.query_stats, size: 36, color: scheme.onSurfaceVariant),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          if (action != null) ...[
            const SizedBox(height: 8),
            action,
          ],
        ],
      ),
    );
  }

  Widget _temperatureSection({
    required String title,
    required UsageTemperatureSummary summary,
    required Color color,
    required AppLanguage language,
    double? referenceValue,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final hasData = summary.hasData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (referenceValue != null) ...[
          const SizedBox(height: 2),
          Text(
            JexText.phrase('Current limit: ', 'Batas saat ini: ', language) +
                referenceValue.toStringAsFixed(0) +
                '°C',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
        const SizedBox(height: 8),
        SizedBox(
          height: 170,
          width: double.infinity,
          child: hasData
              ? CustomPaint(
                  painter: _UsageLinePainter(
                    points: summary.points,
                    fromMs: _snapshot!.fromMs,
                    toMs: _snapshot!.toMs,
                    color: color,
                    gridColor: scheme.outlineVariant,
                    labelColor: scheme.onSurfaceVariant,
                    referenceValue: referenceValue,
                  ),
                )
              : Center(
                  child: Text(
                    JexText.phrase(
                      'No valid readings in this period.',
                      'Tidak ada pembacaan valid pada periode ini.',
                      language,
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _summaryValue(
                JexText.phrase('Min', 'Min', language),
                _formatTemperature(summary.minimum),
              ),
            ),
            Expanded(
              child: _summaryValue(
                JexText.phrase('Average', 'Rata-rata', language),
                _formatTemperature(summary.average),
              ),
            ),
            Expanded(
              child: _summaryValue(
                JexText.phrase('Max', 'Maks', language),
                _formatTemperature(summary.maximum),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          JexText.phrase('Observed: ', 'Terpantau: ', language) +
              _formatDuration(summary.observedMs),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _profileSection(
    UsageStatsSummary summary,
    AppLanguage language,
    ColorScheme scheme,
  ) {
    final voltageLabels = <String>[
      for (final rail in ['5V', '9V', '12V'])
        rail + '  ' + _formatDuration(summary.voltageDurationMs[rail] ?? 0),
    ];
    final adaptiveLabel =
        JexText.phrase('Adaptive ON: ', 'Adaptive AKTIF: ', language) +
            _formatDuration(summary.adaptiveOnDurationMs);
    final fanAverage = summary.fanSpeedAverage;
    final fanMaximum = summary.fanSpeedMaximum;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          JexText.phrase('Operating Profile', 'Riwayat Operasi', language),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 9),
        _timelineLane(
          JexText.phrase('Voltage', 'Tegangan', language),
          summary.voltageSegments,
          scheme,
          lane: 'voltage',
        ),
        _timelineLane(
          JexText.phrase('Adaptive', 'Adaptif', language),
          summary.adaptiveSegments,
          scheme,
          lane: 'adaptive',
        ),
        _timelineLane(
          JexText.phrase('Fan Speed', 'Kecepatan Kipas', language),
          summary.fanSpeedSegments,
          scheme,
          lane: 'fan_speed',
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _axisTime(_snapshot!.fromMs, _period.duration.inMilliseconds),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            Text(
              _axisTime(_snapshot!.toMs, _period.duration.inMilliseconds),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            for (final label in voltageLabels)
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(adaptiveLabel, style: Theme.of(context).textTheme.bodySmall),
            Text(
              JexText.phrase('Fan average: ', 'Rata-rata kipas: ', language) +
                  (fanAverage == null
                      ? '--'
                      : fanAverage.toStringAsFixed(0) + '%'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              JexText.phrase('Fan max: ', 'Kipas maks: ', language) +
                  (fanMaximum == null
                      ? '--'
                      : fanMaximum.toStringAsFixed(0) + '%'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _timelineLane(
    String label,
    List<UsageStateSegment> segments,
    ColorScheme scheme, {
    required String lane,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 5),
          SizedBox(
            height: 28,
            width: double.infinity,
            child: CustomPaint(
              painter: _UsageTimelinePainter(
                segments: segments,
                fromMs: _snapshot!.fromMs,
                toMs: _snapshot!.toMs,
                lane: lane,
                scheme: scheme,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
        ),
      ],
    );
  }

  String _formatLastSample(
    UsageStatsSummary summary,
    AppLanguage language,
  ) {
    final points = [
      ...summary.battery.points,
      ...summary.hotside.points,
    ].where((point) => point.value != null).toList();
    if (points.isEmpty) {
      return JexText.phrase('No valid sample', 'Belum ada sampel valid', language);
    }
    points.sort((a, b) => a.timestampMs.compareTo(b.timestampMs));
    return _axisTime(points.last.timestampMs, _period.duration.inMilliseconds);
  }
}

class _UsageLinePainter extends CustomPainter {
  final List<UsageChartPoint> points;
  final int fromMs;
  final int toMs;
  final Color color;
  final Color gridColor;
  final Color labelColor;
  final double? referenceValue;

  const _UsageLinePainter({
    required this.points,
    required this.fromMs,
    required this.toMs,
    required this.color,
    required this.gridColor,
    required this.labelColor,
    required this.referenceValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const left = 34.0;
    const right = 8.0;
    const top = 8.0;
    const bottom = 22.0;
    final plot = Rect.fromLTRB(
      left,
      top,
      math.max(left + 1, size.width - right).toDouble(),
      math.max(top + 1, size.height - bottom).toDouble(),
    );
    final valid = points.where((point) => point.value != null).toList();
    if (valid.isEmpty || toMs <= fromMs) return;

    var minValue = valid
        .map((point) => point.value!)
        .reduce((a, b) => math.min(a, b).toDouble());
    var maxValue = valid
        .map((point) => point.value!)
        .reduce((a, b) => math.max(a, b).toDouble());
    if (referenceValue != null) {
      minValue = math.min(minValue, referenceValue!).toDouble();
      maxValue = math.max(maxValue, referenceValue!).toDouble();
    }
    if ((maxValue - minValue).abs() < 0.5) {
      minValue -= 1;
      maxValue += 1;
    } else {
      final padding = (maxValue - minValue) * 0.12;
      minValue -= padding;
      maxValue += padding;
    }

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.7;
    final textStyle = TextStyle(color: labelColor, fontSize: 9);
    for (var index = 0; index <= 3; index++) {
      final fraction = index / 3;
      final y = plot.top + plot.height * fraction;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      final value = maxValue - (maxValue - minValue) * fraction;
      final text = TextPainter(
        text: TextSpan(text: value.toStringAsFixed(0), style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: left - 5);
      text.paint(canvas, Offset(0, y - text.height / 2));
    }

    double xFor(int timestamp) {
      return plot.left +
          ((timestamp - fromMs) / (toMs - fromMs))
                  .clamp(0.0, 1.0)
                  .toDouble() *
              plot.width;
    }

    double yFor(double value) {
      return plot.bottom -
          ((value - minValue) / (maxValue - minValue))
                  .clamp(0.0, 1.0)
                  .toDouble() *
              plot.height;
    }

    if (referenceValue != null) {
      final referencePaint = Paint()
        ..color = Colors.deepOrange.withValues(alpha: 0.75)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      final y = yFor(referenceValue!);
      for (var x = plot.left; x < plot.right; x += 7) {
        canvas.drawLine(
          Offset(x, y),
          Offset(math.min(x + 3.5, plot.right).toDouble(), y),
          referencePaint,
        );
      }
    }

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    Path? path;
    int? pathSession;
    double? previousY;
    var drawn = false;

    for (final point in points) {
      final value = point.value;
      if (value == null) {
        if (path != null && drawn) canvas.drawPath(path, linePaint);
        path = null;
        pathSession = null;
        previousY = null;
        drawn = false;
        continue;
      }

      final x = xFor(point.timestampMs);
      final y = yFor(value);
      final startNew = path == null ||
          point.breakBefore ||
          (pathSession != null && pathSession != point.sessionId);
      if (startNew) {
        if (path != null && drawn) canvas.drawPath(path, linePaint);
        path = Path()..moveTo(x, y);
        pathSession = point.sessionId;
        previousY = y;
        drawn = false;
      } else {
        path!
          ..lineTo(x, previousY ?? y)
          ..lineTo(x, y);
        previousY = y;
        drawn = true;
      }
    }
    if (path != null && drawn) canvas.drawPath(path, linePaint);

    final range = toMs - fromMs;
    final startText = TextPainter(
      text: TextSpan(
        text: _axisTime(fromMs, range),
        style: TextStyle(color: labelColor, fontSize: 9),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final endText = TextPainter(
      text: TextSpan(
        text: _axisTime(toMs, range),
        style: TextStyle(color: labelColor, fontSize: 9),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    startText.paint(canvas, Offset(plot.left, size.height - bottom + 4));
    endText.paint(
      canvas,
      Offset(plot.right - endText.width, size.height - bottom + 4),
    );
  }

  @override
  bool shouldRepaint(covariant _UsageLinePainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.fromMs != fromMs ||
      oldDelegate.toMs != toMs ||
      oldDelegate.color != color ||
      oldDelegate.gridColor != gridColor ||
      oldDelegate.referenceValue != referenceValue;
}

class _UsageTimelinePainter extends CustomPainter {
  final List<UsageStateSegment> segments;
  final int fromMs;
  final int toMs;
  final String lane;
  final ColorScheme scheme;

  const _UsageTimelinePainter({
    required this.segments,
    required this.fromMs,
    required this.toMs,
    required this.lane,
    required this.scheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (toMs <= fromMs) return;

    final baseline = Paint()
      ..color = scheme.outlineVariant.withValues(alpha: 0.65)
      ..strokeWidth = 0.8;
    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      baseline,
    );

    double xFor(int time) =>
        ((time - fromMs) / (toMs - fromMs))
            .clamp(0.0, 1.0)
            .toDouble() *
        size.width;

    for (final segment in segments) {
      final start = xFor(segment.startMs);
      final end = xFor(segment.endMs);
      if (end <= start) continue;

      Color color;
      double top;
      double bottom;

      switch (lane) {
        case 'voltage':
          switch (segment.textValue?.toUpperCase()) {
            case '5V':
              color = const Color(0xFFD94B55);
              break;
            case '9V':
              color = const Color(0xFF26966D);
              break;
            case '12V':
              color = const Color(0xFF397FCA);
              break;
            default:
              color = scheme.outline;
          }
          top = 3;
          bottom = size.height - 3;
          break;
        case 'adaptive':
          color = segment.textValue?.toUpperCase() == 'ON'
              ? const Color(0xFF26966D)
              : scheme.outlineVariant;
          top = 3;
          bottom = size.height - 3;
          break;
        default:
          color = scheme.primary;
          final speed = (segment.numberValue ?? 0).clamp(0, 100).toDouble();
          final height = math.max(2.0, (size.height - 5) * speed / 100).toDouble();
          top = size.height - 2 - height;
          bottom = size.height - 2;
      }

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(start, top, math.max(start + 1, end).toDouble(), bottom),
          const Radius.circular(2),
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _UsageTimelinePainter oldDelegate) =>
      oldDelegate.segments != segments ||
      oldDelegate.fromMs != fromMs ||
      oldDelegate.toMs != toMs ||
      oldDelegate.lane != lane ||
      oldDelegate.scheme != scheme;
}

String _formatTemperature(double? value) =>
    value == null ? '--' : value.toStringAsFixed(1) + '°C';

String _formatDuration(int milliseconds) {
  if (milliseconds <= 0) return '0m';
  final minutes = milliseconds ~/ 60000;
  final hours = minutes ~/ 60;
  final days = hours ~/ 24;
  final remainingHours = hours % 24;
  final remainingMinutes = minutes % 60;
  if (days > 0) {
    return days.toString() + 'd ' + remainingHours.toString() + 'h';
  }
  if (hours > 0) {
    return hours.toString() + 'h ' + remainingMinutes.toString() + 'm';
  }
  return minutes.toString() + 'm';
}

String _axisTime(int timestampMs, int rangeMs) {
  final value = DateTime.fromMillisecondsSinceEpoch(timestampMs).toLocal();
  String two(int part) => part.toString().padLeft(2, '0');
  if (rangeMs <= const Duration(hours: 24).inMilliseconds) {
    return two(value.hour) + ':' + two(value.minute);
  }
  return two(value.day) + '/' + two(value.month);
}

