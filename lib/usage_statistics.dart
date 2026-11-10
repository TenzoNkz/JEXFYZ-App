// AI-MEMORY / FILE CONTRACT
// Owns App-local Usage Statistics persistence, telemetry recording, analytics and Settings page.
// P1 telemetry and Android battery readings are the only data sources; no inferred measurements.
// A session is bounded by a fully synchronized BLE/P1 session and cooler identity.
// Invalid readings, disconnects, process loss and sensor staleness remain explicit gaps.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'app_settings.dart';

/// Physical output telemetry, not a BLE connection or selected mode, defines operation.
bool usageCoolerIsActive({required bool fanOn, required bool peltierOn}) =>
    fanOn || peltierOn;

String formatUsageElapsed(int milliseconds) {
  final totalSeconds = math.max(0, milliseconds ~/ 1000).toInt();
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds ~/ 60) % 60;
  final seconds = totalSeconds % 60;
  String two(int value) => value.toString().padLeft(2, '0');
  if (hours > 0) return '$hours:${two(minutes)}:${two(seconds)}';
  return '${two(minutes)}:${two(seconds)}';
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

  bool get isActive => endedAtMs == null;

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

class UsageStatsLiveUpdate {
  final String coolerId;
  final UsageStatsSession session;
  final List<UsageStatsEvent> events;
  final int publishedAtMs;

  const UsageStatsLiveUpdate({
    required this.coolerId,
    required this.session,
    required this.events,
    required this.publishedAtMs,
  });
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
  final int peltierOnDurationMs;
  final double? fanSpeedAverage;
  final double? fanSpeedMaximum;
  final List<UsageStateSegment> voltageSegments;
  final List<UsageStateSegment> adaptiveSegments;
  final List<UsageStateSegment> peltierSegments;
  final List<UsageStateSegment> fanSpeedSegments;

  const UsageStatsSummary({
    required this.battery,
    required this.hotside,
    required this.voltageDurationMs,
    required this.adaptiveOnDurationMs,
    required this.peltierOnDurationMs,
    required this.fanSpeedAverage,
    required this.fanSpeedMaximum,
    required this.voltageSegments,
    required this.adaptiveSegments,
    required this.peltierSegments,
    required this.fanSpeedSegments,
  });

  bool get hasData =>
      battery.hasData ||
      hotside.hasData ||
      voltageSegments.isNotEmpty ||
      adaptiveSegments.isNotEmpty ||
      peltierSegments.isNotEmpty ||
      fanSpeedSegments.isNotEmpty;
}

abstract interface class UsageStatisticsRepository {
  Future<List<UsageStatsSession>> loadSessions({
    required String coolerId,
    int? nowMs,
  });

  Future<UsageStatsSnapshot> loadSessionSnapshot({
    required String coolerId,
    required int sessionId,
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
    final peltier = _stateSegments(snapshot, 'peltier');
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

    var peltierOnMs = 0;
    for (final segment in peltier) {
      if (segment.textValue?.toUpperCase() == 'ON') {
        peltierOnMs += segment.durationMs;
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
      peltierOnDurationMs: peltierOnMs,
      fanSpeedAverage:
          fanObservedMs == 0 ? null : fanWeighted / fanObservedMs,
      fanSpeedMaximum: fanMaximum,
      voltageSegments: voltage,
      adaptiveSegments: adaptive,
      peltierSegments: peltier,
      fanSpeedSegments: fan,
    );
  }

  static int? lastTemperatureSampleAtMs(UsageStatsSnapshot snapshot) {
    final sessionsById = <int, UsageStatsSession>{
      for (final session in snapshot.sessions) session.id: session,
    };
    int? latestTimestampMs;

    for (final event in snapshot.events) {
      final value = event.numberValue;
      if ((event.metric != 'battery' && event.metric != 'hotside') ||
          value == null ||
          !value.isFinite) {
        continue;
      }

      final session = sessionsById[event.sessionId];
      if (session == null) continue;
      final sessionEndMs = session.endedAtMs ?? snapshot.toMs;
      if (event.timestampMs < session.startedAtMs ||
          event.timestampMs > sessionEndMs ||
          event.timestampMs > snapshot.toMs) {
        continue;
      }

      if (latestTimestampMs == null ||
          event.timestampMs > latestTimestampMs) {
        latestTimestampMs = event.timestampMs;
      }
    }

    return latestTimestampMs;
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
  static double? temperatureAt(
    List<UsageChartPoint> points,
    int timestampMs,
  ) {
    UsageChartPoint? previous;
    for (final point in points) {
      if (point.timestampMs > timestampMs) break;
      previous = point;
    }
    if (previous == null || previous.value == null) return null;
    return previous.value;
  }

  static UsageStateSegment? stateAt(
    List<UsageStateSegment> segments,
    int timestampMs,
  ) {
    for (final segment in segments) {
      if (timestampMs >= segment.startMs && timestampMs <= segment.endMs) {
        return segment;
      }
    }
    return null;
  }


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
  static const int retentionDays = 30;

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
    await database.rawDelete(
      'DELETE FROM usage_samples WHERE timestamp_ms < ? '
      'AND id NOT IN (SELECT MAX(id) FROM usage_samples '
      'WHERE timestamp_ms < ? GROUP BY session_id)',
      [cutoff, cutoff],
    );
    await database.delete(
      'usage_sessions',
      where: 'COALESCE(ended_at_ms, last_seen_at_ms) < ?',
      whereArgs: [cutoff],
    );
    _lastPrunedAtMs = timestampMs;
  }

  Future<void> _createUsageSamplesTable(DatabaseExecutor database) async {
    await database.execute('''
      CREATE TABLE usage_samples (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        timestamp_ms INTEGER NOT NULL,
        battery_seen INTEGER NOT NULL DEFAULT 0,
        battery_c REAL,
        hotside_seen INTEGER NOT NULL DEFAULT 0,
        hotside_c REAL,
        FOREIGN KEY(session_id) REFERENCES usage_sessions(id)
          ON DELETE CASCADE,
        UNIQUE(session_id, timestamp_ms)
      )
    ''');
    await database.execute(
      'CREATE INDEX usage_samples_session_time '
      'ON usage_samples(session_id, timestamp_ms)',
    );
    await database.execute(
      'CREATE INDEX usage_samples_timestamp ON usage_samples(timestamp_ms)',
    );
  }

  Future<Database> _openDatabase() async {
    final directory = await getDatabasesPath();
    final databasePath = p.join(directory, _databaseName);

    return openDatabase(
      databasePath,
      version: 2,
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
        await _createUsageSamplesTable(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createUsageSamplesTable(database);
          // Preserve v1 change-only temperature history as sparse samples.
          // The seen flags distinguish an absent metric from an explicit invalid gap.
          await database.execute('''
            INSERT INTO usage_samples (
              session_id, timestamp_ms, battery_seen, battery_c,
              hotside_seen, hotside_c
            )
            SELECT
              session_id,
              timestamp_ms,
              MAX(CASE WHEN metric = 'battery' THEN 1 ELSE 0 END),
              MAX(CASE WHEN metric = 'battery' THEN value_num ELSE NULL END),
              MAX(CASE WHEN metric = 'hotside' THEN 1 ELSE 0 END),
              MAX(CASE WHEN metric = 'hotside' THEN value_num ELSE NULL END)
            FROM usage_events
            WHERE metric IN ('battery', 'hotside')
            GROUP BY session_id, timestamp_ms
          ''');
          await database.delete(
            'usage_events',
            where: "metric IN ('battery', 'hotside')",
          );
        }
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
        await database.rawDelete(
          'DELETE FROM usage_samples WHERE timestamp_ms < ? '
          'AND id NOT IN (SELECT MAX(id) FROM usage_samples '
          'WHERE timestamp_ms < ? GROUP BY session_id)',
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
    String? peltier,
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
        'last_hotside_seen_at_ms': timestampMs,
        'last_battery_seen_at_ms': timestampMs,
      });

      // The start snapshot is the first sample of this confirmed active run.
      await transaction.insert('usage_samples', {
        'session_id': sessionId,
        'timestamp_ms': timestampMs,
        'battery_seen': 1,
        'battery_c': batteryC,
        'hotside_seen': 1,
        'hotside_c': hotsideC,
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

      await insertBaseline('voltage', textValue: voltage);
      await insertBaseline('adaptive', textValue: adaptive);
      await insertBaseline('peltier', textValue: peltier);
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

  Future<void> recordTemperatureSample({
    required int sessionId,
    required int timestampMs,
    required String metric,
    required double? value,
  }) async {
    final database = await _database;
    if (metric == 'battery') {
      await database.rawInsert(
        'INSERT INTO usage_samples '
        '(session_id, timestamp_ms, battery_seen, battery_c) '
        'VALUES (?, ?, 1, ?) '
        'ON CONFLICT(session_id, timestamp_ms) DO UPDATE SET '
        'battery_seen = 1, battery_c = excluded.battery_c',
        [sessionId, timestampMs, value],
      );
    } else if (metric == 'hotside') {
      await database.rawInsert(
        'INSERT INTO usage_samples '
        '(session_id, timestamp_ms, hotside_seen, hotside_c) '
        'VALUES (?, ?, 1, ?) '
        'ON CONFLICT(session_id, timestamp_ms) DO UPDATE SET '
        'hotside_seen = 1, hotside_c = excluded.hotside_c',
        [sessionId, timestampMs, value],
      );
    } else {
      throw ArgumentError.value(metric, 'metric', 'Unsupported temperature metric');
    }
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
  Future<List<UsageStatsSession>> loadSessions({
    required String coolerId,
    int? nowMs,
  }) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final cutoff = now - const Duration(days: retentionDays).inMilliseconds;
    final database = await _database;
    final rows = await database.query(
      'usage_sessions',
      where: 'cooler_id = ? AND COALESCE(ended_at_ms, last_seen_at_ms) >= ?',
      whereArgs: [coolerId, cutoff],
      orderBy: 'started_at_ms DESC',
    );
    return rows.map(UsageStatsSession.fromMap).toList(growable: false);
  }

  @override
  Future<UsageStatsSnapshot> loadSessionSnapshot({
    required String coolerId,
    required int sessionId,
    int? nowMs,
  }) async {
    final now = nowMs ?? DateTime.now().millisecondsSinceEpoch;
    final database = await _database;
    final sessionRows = await database.query(
      'usage_sessions',
      where: 'id = ? AND cooler_id = ?',
      whereArgs: [sessionId, coolerId],
      limit: 1,
    );
    if (sessionRows.isEmpty) {
      return UsageStatsSnapshot.empty(fromMs: now, toMs: now);
    }

    final session = UsageStatsSession.fromMap(sessionRows.first);
    final recordedEnd = session.endedAtMs ??
        math.min(now, session.lastSeenAtMs +
            const Duration(milliseconds: 1500).inMilliseconds);
    final end = math.max(session.startedAtMs, recordedEnd).toInt();

    final stateRows = await database.query(
      'usage_events',
      columns: [
        'session_id',
        'timestamp_ms',
        'metric',
        'value_num',
        'value_text',
      ],
      where: 'session_id = ? AND timestamp_ms <= ?',
      whereArgs: [sessionId, end],
      orderBy: 'timestamp_ms ASC',
    );
    final events = stateRows.map(UsageStatsEvent.fromMap).toList();

    final sampleRows = await database.query(
      'usage_samples',
      columns: [
        'session_id',
        'timestamp_ms',
        'battery_seen',
        'battery_c',
        'hotside_seen',
        'hotside_c',
      ],
      where: 'session_id = ? AND timestamp_ms <= ?',
      whereArgs: [sessionId, end],
      orderBy: 'timestamp_ms ASC',
    );
    for (final row in sampleRows) {
      final id = (row['session_id'] as num).toInt();
      final timestamp = (row['timestamp_ms'] as num).toInt();
      if ((row['battery_seen'] as num).toInt() == 1) {
        final raw = row['battery_c'];
        events.add(UsageStatsEvent(
          sessionId: id,
          timestampMs: timestamp,
          metric: 'battery',
          numberValue: raw is num ? raw.toDouble() : null,
          textValue: null,
        ));
      }
      if ((row['hotside_seen'] as num).toInt() == 1) {
        final raw = row['hotside_c'];
        events.add(UsageStatsEvent(
          sessionId: id,
          timestampMs: timestamp,
          metric: 'hotside',
          numberValue: raw is num ? raw.toDouble() : null,
          textValue: null,
        ));
      }
    }
    events.sort((a, b) {
      final timeOrder = a.timestampMs.compareTo(b.timestampMs);
      return timeOrder != 0 ? timeOrder : a.metric.compareTo(b.metric);
    });

    return UsageStatsSnapshot(
      fromMs: session.startedAtMs,
      toMs: end,
      sessions: [session],
      events: events,
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
  final StreamController<UsageStatsLiveUpdate> _liveUpdates =
      StreamController<UsageStatsLiveUpdate>.broadcast(sync: true);
  Stream<UsageStatsLiveUpdate> get liveUpdates => _liveUpdates.stream;
  int? _sessionStartedAtMs;
  int? _sessionEndedAtMs;
  Timer? _p1FreshnessTimer;
  int? _lastP1ReceiptAtMs;

  // Kept visible for the lifetime of this process because a later successful
  // write cannot prove that a previously dropped sample was recovered.
  String? lastWriteError;

  Future<void> _enqueue(Future<void> Function() operation) {
    _queue = _queue.then((_) async {
      try {
        await operation();
      } catch (error) {
        lastWriteError = error.toString();
        debugPrint('Usage statistics write: ' + error.toString());
        _notifyChanged();
      }
    });
    return _queue;
  }

  void _notifyChanged() {
    revisionNotifier.value++;
  }

  UsageStatsSession? _liveSession({int? endedAtMs}) {
    final id = _sessionId;
    final coolerId = _coolerId;
    final startedAt = _sessionStartedAtMs;
    if (id == null || coolerId == null || startedAt == null) return null;
    final lastHot = _lastSensorSeenMs['hotside'];
    final lastBattery = _lastSensorSeenMs['battery'];
    return UsageStatsSession(
      id: id,
      coolerId: coolerId,
      startedAtMs: startedAt,
      endedAtMs: endedAtMs ?? _sessionEndedAtMs,
      lastSeenAtMs: lastHot ?? startedAt,
      lastHotsideSeenAtMs: lastHot,
      lastBatterySeenAtMs: lastBattery,
    );
  }

  void _publishLiveUpdate({
    required int timestampMs,
    List<UsageStatsEvent> events = const [],
    int? endedAtMs,
  }) {
    final session = _liveSession(endedAtMs: endedAtMs);
    final coolerId = _coolerId;
    if (session == null || coolerId == null) return;
    _liveUpdates.add(UsageStatsLiveUpdate(
      coolerId: coolerId,
      session: session,
      events: List<UsageStatsEvent>.unmodifiable(events),
      publishedAtMs: timestampMs,
    ));
  }


  void _startP1FreshnessWatchdog() {
    _p1FreshnessTimer?.cancel();
    _p1FreshnessTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) {
        final sessionId = _sessionId;
        final lastReceipt = _lastP1ReceiptAtMs;
        if (sessionId == null || lastReceipt == null) return;
        final now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastReceipt >
            const Duration(milliseconds: 2500).inMilliseconds) {
          unawaited(endSession(
            reason: 'stale_p1',
            timestampMs: lastReceipt +
                const Duration(milliseconds: 1500).inMilliseconds,
          ));
        }
      },
    );
  }

  Future<void> startSession({
    required String coolerId,
    double? batteryC,
    double? hotsideC,
    String? voltage,
    String? adaptive,
    String? peltier,
    int? fanSpeed,
  }) {
    final safeId = coolerId.trim();
    if (safeId.isEmpty) return Future<void>.value();

    return _enqueue(() async {
      if (_sessionId != null && _coolerId == safeId) return;

      final now = DateTime.now().millisecondsSinceEpoch;
      _p1FreshnessTimer?.cancel();
      final previousSessionId = _sessionId;
      if (previousSessionId != null) {
        await _store.endSession(
          sessionId: previousSessionId,
          timestampMs: now,
          reason: 'superseded_session',
        );
      }
      _sessionId = await _store.startSession(
        coolerId: safeId,
        timestampMs: now,
        batteryC: batteryC,
        hotsideC: hotsideC,
        voltage: voltage,
        adaptive: adaptive,
        peltier: peltier,
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
        ..['peltier'] = peltier
        ..['fan_speed'] = fanSpeed;
      _lastSensorSeenMs
        ..clear()
        ..['battery'] = now
        ..['hotside'] = now;
      _sessionStartedAtMs = now;
      _sessionEndedAtMs = null;
      _lastP1ReceiptAtMs = now;
      _startP1FreshnessWatchdog();
      final sessionId = _sessionId!;
      _publishLiveUpdate(timestampMs: now, events: [
        UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'battery', numberValue: batteryC, textValue: null),
        UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'hotside', numberValue: hotsideC, textValue: null),
        if (voltage != null)
          UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'voltage', numberValue: null, textValue: voltage),
        if (adaptive != null)
          UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'adaptive', numberValue: null, textValue: adaptive),
        if (peltier != null)
          UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'peltier', numberValue: null, textValue: peltier),
        if (fanSpeed != null)
          UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'fan_speed', numberValue: fanSpeed.toDouble(), textValue: null),
      ]);
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
    final receivedAtMs = DateTime.now().millisecondsSinceEpoch;
    if (metric == 'hotside' && _sessionId != null) {
      // Advance the watchdog on receipt, before the serialized SQLite write.
      _lastP1ReceiptAtMs = receivedAtMs;
    }

    return _enqueue(() async {
      final sessionId = _sessionId;
      if (sessionId == null) return;

      final lastSeen = _lastSensorSeenMs[metric];
      if (lastSeen != null &&
          receivedAtMs - lastSeen >
              const Duration(milliseconds: 2500).inMilliseconds) {
        // Do not bridge a missing sensor interval with a stale value.
        await _store.recordTemperatureSample(
          sessionId: sessionId,
          timestampMs: lastSeen +
              const Duration(milliseconds: 1500).inMilliseconds,
          metric: metric,
          value: null,
        );
        if (metric == 'hotside') {
          final cutoff = lastSeen +
              const Duration(milliseconds: 1500).inMilliseconds;
          await _store.endSession(
            sessionId: sessionId,
            timestampMs: cutoff,
            reason: 'stale_p1',
          );
          _sessionEndedAtMs = cutoff;
          _publishLiveUpdate(
            timestampMs: cutoff,
            endedAtMs: cutoff,
            events: [
              UsageStatsEvent(
                sessionId: sessionId,
                timestampMs: cutoff,
                metric: 'hotside',
                numberValue: null,
                textValue: null,
              ),
            ],
          );
          _p1FreshnessTimer?.cancel();
          _p1FreshnessTimer = null;
          _sessionId = null;
          _coolerId = null;
          _temperatures.clear();
          _states.clear();
          _lastSensorSeenMs.clear();
          _lastP1ReceiptAtMs = null;
          _sessionStartedAtMs = null;
          _sessionEndedAtMs = null;
          _notifyChanged();
          return;
        }
      }

      // Persist every 1 Hz observation, even when its numeric value is unchanged.
      // Null samples are explicit gaps, not zero or a carried-forward reading.
      await _store.recordTemperatureSample(
        sessionId: sessionId,
        timestampMs: receivedAtMs,
        metric: metric,
        value: safeValue,
      );
      await _store.touchSensor(
        sessionId: sessionId,
        metric: metric,
        timestampMs: receivedAtMs,
      );
      _temperatures[metric] = safeValue;
      _lastSensorSeenMs[metric] = receivedAtMs;
      _publishLiveUpdate(timestampMs: receivedAtMs, events: [
        UsageStatsEvent(
          sessionId: sessionId,
          timestampMs: receivedAtMs,
          metric: metric,
          numberValue: safeValue,
          textValue: null,
        ),
      ]);
      _notifyChanged();
    });
  }

  Future<void> recordState({
    required String metric,
    required Object? value,
  }) {
    if (!const {'voltage', 'adaptive', 'peltier', 'fan_speed'}.contains(metric)) {
      return Future<void>.value();
    }

    Object? canonical;
    if (metric == 'voltage') {
      if (value is! String ||
          !const {'5V', '9V', '12V'}.contains(value.toUpperCase())) {
        return Future<void>.value();
      }
      canonical = value.toUpperCase();
    } else if (metric == 'adaptive' || metric == 'peltier') {
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
      _states[metric] = canonical;
      _publishLiveUpdate(timestampMs: now, events: [
        UsageStatsEvent(
          sessionId: sessionId,
          timestampMs: now,
          metric: metric,
          numberValue: numeric,
          textValue: text,
        ),
      ]);
      _notifyChanged();
    });
  }

  Future<void> endSession({
    String reason = 'disconnected',
    int? timestampMs,
  }) {
    return _enqueue(() async {
      final id = _sessionId;
      if (id == null) return;

      final endedAt = timestampMs ?? DateTime.now().millisecondsSinceEpoch;
      await _store.endSession(
        sessionId: id,
        timestampMs: endedAt,
        reason: reason,
      );
      _sessionEndedAtMs = endedAt;
      _publishLiveUpdate(timestampMs: endedAt, endedAtMs: endedAt);
      _p1FreshnessTimer?.cancel();
      _p1FreshnessTimer = null;
      _sessionId = null;
      _coolerId = null;
      _temperatures.clear();
      _states.clear();
      _lastSensorSeenMs.clear();
      _lastP1ReceiptAtMs = null;
      _sessionStartedAtMs = null;
      _sessionEndedAtMs = null;
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
        peltier: _states['peltier'] as String?,
        fanSpeed: (_states['fan_speed'] as num?)?.toInt(),
      );
      _lastSensorSeenMs
        ..clear()
        ..['battery'] = now
        ..['hotside'] = now;
      _sessionStartedAtMs = now;
      _sessionEndedAtMs = null;
      _lastP1ReceiptAtMs = now;
      _startP1FreshnessWatchdog();
      final sessionId = _sessionId!;
      _publishLiveUpdate(timestampMs: now, events: [
        UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'battery', numberValue: _temperatures['battery'], textValue: null),
        UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'hotside', numberValue: _temperatures['hotside'], textValue: null),
        if (_states['voltage'] is String)
          UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'voltage', numberValue: null, textValue: _states['voltage'] as String),
        if (_states['adaptive'] is String)
          UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'adaptive', numberValue: null, textValue: _states['adaptive'] as String),
        if (_states['peltier'] is String)
          UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'peltier', numberValue: null, textValue: _states['peltier'] as String),
        if (_states['fan_speed'] is num)
          UsageStatsEvent(sessionId: sessionId, timestampMs: now, metric: 'fan_speed', numberValue: (_states['fan_speed'] as num).toDouble(), textValue: null),
      ]);
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
  List<UsageStatsSession> _sessions = const [];
  int? _selectedSessionId;
  bool _sessionSelectionPinned = false;
  UsageStatsSnapshot? _snapshot;
  UsageStatsSummary? _summary;
  bool _loading = true;
  bool _queryRunning = false;
  bool _reloadPending = false;
  StreamSubscription<UsageStatsLiveUpdate>? _liveSubscription;
  final List<UsageStatsLiveUpdate> _pendingLiveUpdates = [];
  Timer? _liveFlushTimer;
  int? _selectedTimestampMs;
  String? _error;

  UsageStatisticsRepository get _repository =>
      widget.repository ?? UsageStatisticsStore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _liveSubscription =
        UsageStatisticsRecorder.instance.liveUpdates.listen(_handleLiveUpdate);
    _load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _load(silent: true);
  }

  @override
  void dispose() {
    _liveFlushTimer?.cancel();
    _liveSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _handleLiveUpdate(UsageStatsLiveUpdate update) {
    final coolerId = widget.coolerId?.trim();
    if (coolerId == null || update.coolerId != coolerId) return;
    _pendingLiveUpdates.add(update);
    _liveFlushTimer ??= Timer(
      const Duration(milliseconds: 80),
      _flushLiveUpdates,
    );
  }

  void _flushLiveUpdates() {
    _liveFlushTimer?.cancel();
    _liveFlushTimer = null;
    if (!mounted || _pendingLiveUpdates.isEmpty) return;
    final updates = List<UsageStatsLiveUpdate>.of(_pendingLiveUpdates);
    _pendingLiveUpdates.clear();

    setState(() {
      for (final update in updates) {
        final isSelected = update.session.id == _selectedSessionId;
        final canFollowLatest = !_sessionSelectionPinned;
        if (!isSelected &&
            !(canFollowLatest &&
                (_selectedSessionId == null ||
                    update.session.startedAtMs >= (_snapshot?.fromMs ?? 0)))) {
          continue;
        }

        if (!isSelected) {
          _selectedSessionId = update.session.id;
          final otherSessions = _sessions
              .where((session) => session.id != update.session.id)
              .toList();
          _sessions = [update.session, ...otherSessions]
            ..sort((a, b) => b.startedAtMs.compareTo(a.startedAtMs));
          _sessionSelectionPinned = false;
        } else {
          _sessions = [
            for (final session in _sessions)
              if (session.id == update.session.id) update.session else session,
          ];
        }

        final previous = _snapshot;
        final sameSession = previous != null &&
            previous.sessions.any((session) => session.id == update.session.id);
        final mergedEvents = <UsageStatsEvent>[
          if (sameSession) ...previous.events,
        ];
        for (final event in update.events) {
          final exists = mergedEvents.any((existing) =>
              existing.sessionId == event.sessionId &&
              existing.metric == event.metric &&
              existing.timestampMs == event.timestampMs);
          if (!exists) mergedEvents.add(event);
        }
        mergedEvents.sort((a, b) {
          final byTime = a.timestampMs.compareTo(b.timestampMs);
          return byTime != 0 ? byTime : a.metric.compareTo(b.metric);
        });
        final toMs = math.max(
          sameSession ? previous.toMs : update.session.startedAtMs,
          math.max(update.publishedAtMs, update.session.endedAtMs ?? 0),
        ).toInt();
        _snapshot = UsageStatsSnapshot(
          fromMs: update.session.startedAtMs,
          toMs: toMs,
          sessions: [update.session],
          events: mergedEvents,
        );
        _summary = UsageStatsAnalytics.summarize(_snapshot!);
        _loading = false;
        _error = null;
      }
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
          _sessions = const [];
          _selectedSessionId = null;
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
        final sessions = await _repository.loadSessions(coolerId: coolerId);
        final requestedId = _sessionSelectionPinned ? _selectedSessionId : null;
        final selectedId = requestedId != null &&
                sessions.any((session) => session.id == requestedId)
            ? requestedId
            : (sessions.isEmpty ? null : sessions.first.id);
        final snapshot = selectedId == null
            ? null
            : await _repository.loadSessionSnapshot(
                coolerId: coolerId,
                sessionId: selectedId,
              );
        final summary =
            snapshot == null ? null : UsageStatsAnalytics.summarize(snapshot);
        if (!mounted) break;
        setState(() {
          _sessions = sessions;
          _selectedSessionId = selectedId;
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
    if (_pendingLiveUpdates.isNotEmpty) _flushLiveUpdates();
  }

  void _selectSession(int sessionId) {
    if (_selectedSessionId == sessionId) return;
    setState(() {
      _selectedSessionId = sessionId;
      _sessionSelectionPinned = true;
      _selectedTimestampMs = null;
    });
    _load();
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
      _sessionSelectionPinned = false;
      _selectedSessionId = null;
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
            if (_sessions.isNotEmpty) ...[
              _sessionSelector(language),
              const SizedBox(height: 8),
              _sessionHeader(language, scheme),
            ],
            if (UsageStatisticsRecorder.instance.lastWriteError != null) ...[
              const SizedBox(height: 10),
              _messageState(
                JexText.phrase(
                  'History recording may be incomplete.',
                  'Perekaman riwayat mungkin tidak lengkap.',
                  language,
                ),
                JexText.phrase(
                  'Local storage could not save one or more readings. Check available phone storage; some history may be missing.',
                  'Penyimpanan lokal gagal menyimpan satu atau beberapa pembacaan. Periksa ruang penyimpanan ponsel; sebagian riwayat mungkin hilang.',
                  language,
                ),
                scheme,
              ),
            ],
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
                  'No cooling history yet.',
                  'Belum ada riwayat pendinginan.',
                  language,
                ),
                JexText.phrase(
                  'A run is recorded only while the Firmware confirms FAN or PELTIER is ON.',
                  'Sesi direkam hanya saat Firmware mengonfirmasi FAN atau PELTIER AKTIF.',
                  language,
                ),
                scheme,
              )
            else ...[
              _sharedCursorReadout(summary, language, scheme),
              _temperatureSection(
                title: JexText.phrase(
                  'Phone Battery Temperature',
                  'Suhu Baterai HP',
                  language,
                ),
                summary: summary.battery,
                color: scheme.primary,
                language: language,
                metricKey: 'battery',
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
                metricKey: 'hotside',
                referenceValue: widget.hotLimit.toDouble(),
              ),
              const SizedBox(height: 22),
              _profileSection(summary, language, scheme),
              const SizedBox(height: 12),
              Text(
                JexText.phrase(
                  'Battery and Hotside are sampled every second during confirmed cooler operation. Missing or invalid sensor readings remain gaps.',
                  'Suhu Battery dan Hotside direkam setiap detik selama cooler benar-benar beroperasi. Pembacaan sensor yang hilang atau tidak valid tetap menjadi celah.',
                  language,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              Text(
                JexText.phrase(
                  'Stored locally on this phone. Last valid sample: ',
                  'Disimpan lokal di ponsel ini. Sampel valid terakhir: ',
                  language,
                ) +
                    _formatLastSample(_snapshot, language),
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

  Widget _sessionSelector(AppLanguage language) {
    if (_sessions.length < 2 || _selectedSessionId == null) {
      return const SizedBox.shrink();
    }
    return DropdownButton<int>(
      key: const ValueKey<String>('usage-session-selector'),
      isExpanded: true,
      value: _selectedSessionId,
      items: [
        for (final session in _sessions)
          DropdownMenuItem<int>(
            value: session.id,
            child: Text(
              _sessionOptionLabel(session, language),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (sessionId) {
        if (sessionId != null) _selectSession(sessionId);
      },
    );
  }

  Widget _sessionHeader(AppLanguage language, ColorScheme scheme) {
    final snapshot = _snapshot;
    UsageStatsSession? selected;
    for (final session in _sessions) {
      if (session.id == _selectedSessionId) {
        selected = session;
        break;
      }
    }
    if (snapshot == null || selected == null) {
      return const SizedBox.shrink();
    }
    final active = selected.isActive;
    final elapsed = formatUsageElapsed(snapshot.toMs - snapshot.fromMs);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.timelapse,
            color: active ? scheme.primary : scheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  JexText.phrase(
                    active ? 'Cooling active' : 'Completed cooling run',
                    active ? 'Pendinginan aktif' : 'Sesi pendinginan selesai',
                    language,
                  ),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  _sessionStartLabel(selected),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Text(
            elapsed,
            key: const ValueKey<String>('usage-session-elapsed'),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
          ),
        ],
      ),
    );
  }

  String _sessionOptionLabel(
    UsageStatsSession session,
    AppLanguage language,
  ) {
    final start = DateTime.fromMillisecondsSinceEpoch(
      session.startedAtMs,
    ).toLocal();
    final durationEnd = session.endedAtMs ?? session.lastSeenAtMs;
    final elapsed = formatUsageElapsed(durationEnd - session.startedAtMs);
    final prefix = session.isActive
        ? JexText.phrase('Active · ', 'Aktif · ', language)
        : '';
    return prefix +
        _twoDigits(start.day) +
        '/' +
        _twoDigits(start.month) +
        ' ' +
        _twoDigits(start.hour) +
        ':' +
        _twoDigits(start.minute) +
        ' · ' +
        elapsed;
  }

  String _sessionStartLabel(UsageStatsSession session) {
    final start = DateTime.fromMillisecondsSinceEpoch(
      session.startedAtMs,
    ).toLocal();
    return _twoDigits(start.day) +
        '/' +
        _twoDigits(start.month) +
        ' ' +
        _twoDigits(start.hour) +
        ':' +
        _twoDigits(start.minute);
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  Widget _messageState(
    String title,
    String message,
    ColorScheme scheme, {
  void _setChartCursor(double localX, double width) {
    final snapshot = _snapshot;
    if (snapshot == null || width <= 0 || snapshot.toMs <= snapshot.fromMs) {
      return;
    }
    final fraction = (localX / width).clamp(0.0, 1.0).toDouble();
    final timestamp = snapshot.fromMs +
        ((snapshot.toMs - snapshot.fromMs) * fraction).round();
    if (_selectedTimestampMs == timestamp) return;
    setState(() => _selectedTimestampMs = timestamp);
  }

  Widget _sharedCursorReadout(
    UsageStatsSummary summary,
    AppLanguage language,
    ColorScheme scheme,
  ) {
    final timestamp = _selectedTimestampMs;
    final snapshot = _snapshot;
    if (timestamp == null || snapshot == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          JexText.phrase(
            'Touch any chart to inspect all metrics at the same time.',
            'Sentuh grafik untuk melihat semua metrik pada waktu yang sama.',
            language,
          ),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      );
    }

    final voltage = UsageStatsAnalytics.stateAt(summary.voltageSegments, timestamp);
    final adaptive = UsageStatsAnalytics.stateAt(summary.adaptiveSegments, timestamp);
    final peltier = UsageStatsAnalytics.stateAt(summary.peltierSegments, timestamp);
    final fan = UsageStatsAnalytics.stateAt(summary.fanSpeedSegments, timestamp);
    final battery = UsageStatsAnalytics.temperatureAt(summary.battery.points, timestamp);
    final hotside = UsageStatsAnalytics.temperatureAt(summary.hotside.points, timestamp);

    Widget metric(String label, String value) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              )),
              Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                )),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(JexText.phrase('Selected time', 'Waktu dipilih', language),
              style: Theme.of(context).textTheme.labelMedium),
            Text(_axisTime(timestamp, snapshot.fromMs),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              )),
          ],
        ),
        const SizedBox(height: 8),
        Row(children: [
          metric('Battery', _formatTemperature(battery)),
          metric('Hotside', _formatTemperature(hotside)),
          metric('Voltage', voltage?.textValue ?? '--'),
        ]),
        const SizedBox(height: 7),
        Row(children: [
          metric('Adaptive', adaptive?.textValue ?? '--'),
          metric('Peltier', peltier?.textValue ?? '--'),
          metric('Fan', fan?.numberValue == null
              ? '--'
              : fan!.numberValue!.toStringAsFixed(0) + '%'),
        ]),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => setState(() => _selectedTimestampMs = null),
            child: Text(JexText.phrase('Clear cursor', 'Hapus kursor', language)),
          ),
        ),
      ],
    );
  }


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
    required String metricKey,
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
              ? LayoutBuilder(
                  builder: (context, constraints) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) => _setChartCursor(
                      details.localPosition.dx,
                      constraints.maxWidth,
                    ),
                    onHorizontalDragUpdate: (details) => _setChartCursor(
                      details.localPosition.dx,
                      constraints.maxWidth,
                    ),
                    child: _AnimatedUsageLineChart(
                      key: ValueKey<String>('usage-temperature-chart-$metricKey'),
                      points: UsageStatsAnalytics.decimatePoints(summary.points),
                      fromMs: _snapshot!.fromMs,
                      toMs: _snapshot!.toMs,
                      color: color,
                      gridColor: scheme.outlineVariant,
                      labelColor: scheme.onSurfaceVariant,
                      referenceValue: referenceValue,
                      cursorTimestampMs: _selectedTimestampMs,
                    ),
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
        JexText.phrase('Adaptive ON: ', 'Adaptif AKTIF: ', language) +
            _formatDuration(summary.adaptiveOnDurationMs);
    final peltierLabel =
        JexText.phrase('Peltier ON: ', 'Peltier AKTIF: ', language) +
            _formatDuration(summary.peltierOnDurationMs);
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
          JexText.phrase('Adaptive Mode', 'Mode Adaptif', language),
          summary.adaptiveSegments,
          scheme,
          lane: 'adaptive',
        ),
        _timelineLane(
          JexText.phrase('Peltier Switch', 'Sakelar Peltier', language),
          summary.peltierSegments,
          scheme,
          lane: 'peltier',
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
              _axisTime(_snapshot!.fromMs, _snapshot!.fromMs),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            Text(
              _axisTime(_snapshot!.toMs, _snapshot!.fromMs),
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
            Text(peltierLabel, style: Theme.of(context).textTheme.bodySmall),
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
            height: lane == 'fan_speed' ? 54 : 34,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => _setChartCursor(
                  details.localPosition.dx,
                  constraints.maxWidth,
                ),
                onHorizontalDragUpdate: (details) => _setChartCursor(
                  details.localPosition.dx,
                  constraints.maxWidth,
                ),
                child: CustomPaint(
                  key: ValueKey<String>('usage-profile-timeline-$lane'),
                  painter: _UsageTimelinePainter(
                    segments: segments,
                    fromMs: _snapshot!.fromMs,
                    toMs: _snapshot!.toMs,
                    lane: lane,
                    scheme: scheme,
                    cursorTimestampMs: _selectedTimestampMs,
                  ),
                ),
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
    UsageStatsSnapshot? snapshot,
    AppLanguage language,
  ) {
    if (snapshot == null) {
      return JexText.phrase('No valid sample', 'Belum ada sampel valid', language);
    }
    final timestampMs =
        UsageStatsAnalytics.lastTemperatureSampleAtMs(snapshot);
    if (timestampMs == null) {
      return JexText.phrase('No valid sample', 'Belum ada sampel valid', language);
    }
    return _axisTime(timestampMs, snapshot.fromMs);
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
        path
          ..lineTo(x, previousY ?? y)
          ..lineTo(x, y);
        previousY = y;
        drawn = true;
      }
    }
    if (path != null && drawn) canvas.drawPath(path, linePaint);

    final startText = TextPainter(
      text: TextSpan(
        text: _axisTime(fromMs, fromMs),
        style: TextStyle(color: labelColor, fontSize: 9),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final endText = TextPainter(
      text: TextSpan(
        text: _axisTime(toMs, fromMs),
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

String _axisTime(int timestampMs, int sessionStartMs) =>
    formatUsageElapsed(timestampMs - sessionStartMs);

