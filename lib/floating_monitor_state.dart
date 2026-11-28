// AI-MEMORY / FILE CONTRACT
// Owns process-local value projections shared by App Settings, Dashboard and the overlay controller.
// This file has no persistence, native-channel or BLE/GATT side effects.

import 'package:flutter/foundation.dart';

import 'floating_monitor_models.dart';

final ValueNotifier<FloatingConfig> floatingConfigNotifier =
    ValueNotifier<FloatingConfig>(const FloatingConfig());
final ValueNotifier<FloatingTelemetry> floatingTelemetryNotifier =
    ValueNotifier<FloatingTelemetry>(const FloatingTelemetry());
