import 'dart:collection';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/floating_monitor.dart';

class _FailureInjectingStorageMap extends MapBase<String, String> {
  _FailureInjectingStorageMap({
    this.failReads = false,
    this.failWrites = false,
    Map<String, String>? initialValues,
  }) : _values = Map<String, String>.of(initialValues ?? const {});

  final bool failReads;
  final bool failWrites;
  final Map<String, String> _values;

  int readAttempts = 0;
  int writeAttempts = 0;

  @override
  String? operator [](Object? key) {
    readAttempts++;
    if (failReads) {
      throw StateError('Injected Floating Monitor storage read failure');
    }
    return _values[key];
  }

  @override
  void operator []=(String key, String value) {
    writeAttempts++;
    if (failWrites) {
      throw StateError('Injected Floating Monitor storage write failure');
    }
    _values[key] = value;
  }

  @override
  Iterable<String> get keys => _values.keys;

  @override
  void clear() => _values.clear();

  @override
  String? remove(Object? key) => _values.remove(key);

  String? valueWithoutFailure(String key) => _values[key];
}

void main() {
  const storageKey = FloatingStore.key;

  setUp(() {
    floatingConfigNotifier.value = const FloatingConfig();
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  test(
    'FloatingStore.load returns persisted schema-v2 config without owning UI state',
    () async {
      const config = FloatingConfig(
        enabled: true,
        order: <String>['F', 'B', 'H', 'V', 'A', 'P'],
        selected: <String>{'F', 'B', 'P'},
        size: 0.75,
        opacity: 0.65,
        backgroundColor: FloatingBackgroundColor.white,
        horizontal: false,
      );
      const uiState = FloatingConfig(
        enabled: false,
        size: 0.45,
        backgroundColor: FloatingBackgroundColor.black,
      );
      floatingConfigNotifier.value = uiState;
      final storage = _FailureInjectingStorageMap(
        initialValues: <String, String>{storageKey: config.toJson()},
      );
      FlutterSecureStorage.setMockInitialValues(storage);

      final loaded = await FloatingStore.load();

      expect(loaded.toMap(), config.toMap());
      expect(floatingConfigNotifier.value.toMap(), uiState.toMap());
      expect(storage.readAttempts, 1);
    },
  );

  test(
    'FloatingStore.load returns defaults after read failure without publishing them',
    () async {
      const uiState = FloatingConfig(
        enabled: true,
        size: 1.0,
        backgroundColor: FloatingBackgroundColor.white,
      );
      floatingConfigNotifier.value = uiState;
      final storage = _FailureInjectingStorageMap(failReads: true);
      FlutterSecureStorage.setMockInitialValues(storage);

      final loaded = await FloatingStore.load();

      expect(loaded.toMap(), const FloatingConfig().toMap());
      expect(floatingConfigNotifier.value.toMap(), uiState.toMap());
      expect(storage.readAttempts, 1);
    },
  );

  test(
    'FloatingStore.save persists schema-v2 config without mutating UI state',
    () async {
      const config = FloatingConfig(
        enabled: true,
        order: <String>['H', 'B', 'V', 'A', 'P', 'F'],
        selected: <String>{'H', 'F'},
        size: 0.85,
        opacity: 0.4,
        horizontal: false,
      );
      const uiState = FloatingConfig(enabled: false, size: 0.4);
      floatingConfigNotifier.value = uiState;
      final storage = _FailureInjectingStorageMap();
      FlutterSecureStorage.setMockInitialValues(storage);

      await FloatingStore.save(config);

      expect(floatingConfigNotifier.value.toMap(), uiState.toMap());
      expect(storage.writeAttempts, 1);
      final stored =
          jsonDecode(storage.valueWithoutFailure(storageKey)!) as Map;
      expect(stored['metricSchemaVersion'], FloatingMetric.schemaVersion);
      expect(stored['order'], config.order);
      expect(stored['selected'], config.selected.toList());
      expect(stored['enabled'], isTrue);
    },
  );

  test(
    'FloatingStore.save contains storage failure and does not publish UI state',
    () async {
      const config = FloatingConfig(
        enabled: true,
        size: 0.9,
        opacity: 0.55,
        backgroundColor: FloatingBackgroundColor.white,
      );
      const uiState = FloatingConfig(enabled: false, size: 0.35);
      floatingConfigNotifier.value = uiState;
      final storage = _FailureInjectingStorageMap(failWrites: true);
      FlutterSecureStorage.setMockInitialValues(storage);

      await expectLater(FloatingStore.save(config), completes);

      expect(storage.writeAttempts, 1);
      expect(storage.valueWithoutFailure(storageKey), isNull);
      expect(floatingConfigNotifier.value.toMap(), uiState.toMap());
    },
  );
}
