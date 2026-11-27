// AI-MEMORY / FILE CONTRACT
// Owns the ordered Flutter startup sequence: official-install gate, local preference restore,
// best-effort Firebase/App Check initialization, portrait orientation, and root launch.
// It does not own screen composition, BLE/GATT, P1 session state, or device telemetry.

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_security.dart';
import 'app_settings.dart' show AppSettingsStore, KnownCoolerStore;
import 'floating_monitor.dart' show FloatingStore;

typedef AppBootstrapStep = Future<void> Function();
typedef AppBootstrapVerifier = Future<bool> Function();
typedef AppBootstrapErrorLogger = void Function(String phase, Object error);

/// Runs the existing startup sequence while keeping its ordering independently testable.
///
/// Storage restoration is intentionally after official-build verification and before the
/// first production widget. Firebase/App Check remain best effort; a cloud-init failure
/// does not prevent the verified local UI from mounting.
class AppBootstrap {
  const AppBootstrap({
    required this.verifyOfficialBuild,
    required this.loadAppSettings,
    required this.loadKnownCooler,
    required this.loadFloatingMonitor,
    required this.initializeFirebase,
    required this.activateAppCheck,
    required this.setPortraitOrientation,
    required this.launchApp,
    required this.logError,
  });

  final AppBootstrapVerifier verifyOfficialBuild;
  final AppBootstrapStep loadAppSettings;
  final AppBootstrapStep loadKnownCooler;
  final AppBootstrapStep loadFloatingMonitor;
  final AppBootstrapStep initializeFirebase;
  final AppBootstrapStep activateAppCheck;
  final AppBootstrapStep setPortraitOrientation;
  final void Function(Widget app) launchApp;
  final AppBootstrapErrorLogger logError;

  /// Wires the production platform/store operations without changing their authorities.
  factory AppBootstrap.production() => AppBootstrap(
    verifyOfficialBuild: isOfficialBuild,
    loadAppSettings: AppSettingsStore.load,
    loadKnownCooler: KnownCoolerStore.load,
    loadFloatingMonitor: () async {
      await FloatingStore.load();
    },
    initializeFirebase: () async {
      await Firebase.initializeApp();
    },
    activateAppCheck: () async {
      await FirebaseAppCheck.instance.activate(
        providerAndroid: const AndroidPlayIntegrityProvider(),
      );
    },
    setPortraitOrientation: () => SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]),
    launchApp: runApp,
    logError: (phase, error) => debugPrint('$phase: $error'),
  );

  Future<void> start({
    required Widget Function() createOfficialApp,
    required Widget Function() createTamperApp,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Keep the verification gate ahead of all persisted App data and cloud setup.
    final officialBuild = await verifyOfficialBuild();
    if (!officialBuild) {
      await setPortraitOrientation();
      launchApp(createTamperApp());
      return;
    }

    await loadAppSettings();
    await loadKnownCooler();
    await loadFloatingMonitor();

    try {
      await initializeFirebase();
      try {
        await activateAppCheck();
      } catch (error) {
        // App Check rollout may be in monitoring mode; preserve the verified UI
        // when the backend is not yet enforcing the attestation result.
        logError('Firebase App Check init', error);
      }
    } catch (error) {
      logError('Firebase init', error);
    }

    await setPortraitOrientation();
    launchApp(createOfficialApp());
  }
}
