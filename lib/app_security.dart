// AI-MEMORY / MODULE CONTRACT
// Owns the App-side bridge for official-install verification.
// Android must fail closed on a false/null result or a platform-channel error.
// Non-Android targets retain the existing non-Android allowance; this does not authenticate BLE peers.

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const MethodChannel securityChannel = MethodChannel('je_x_fyz/security');

/// Returns whether this installation passes the native production-signing gate.
///
/// [isAndroid] is an optional test seam. Production callers omit it so the actual
/// host platform determines whether the Android signing check is required.
Future<bool> isOfficialBuild({bool? isAndroid}) async {
  if (!(isAndroid ?? Platform.isAndroid)) return true;
  try {
    final result = await securityChannel.invokeMethod<bool>('isOfficialBuild');
    return result == true;
  } catch (error) {
    debugPrint('Security check: $error');
    return false;
  }
}
