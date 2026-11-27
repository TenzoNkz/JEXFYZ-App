import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_bootstrap.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppBootstrap', () {
    test(
      'unverified installation launches only the tamper surface',
      () async {
        final events = <String>[];
        Widget? launchedApp;
        final tamperApp = SizedBox(key: const ValueKey<String>('tamper'));
        final officialApp = SizedBox(key: const ValueKey<String>('official'));

        final bootstrap = AppBootstrap(
          verifyOfficialBuild: () async {
            events.add('verify');
            return false;
          },
          loadAppSettings: () async => events.add('settings'),
          loadKnownCooler: () async => events.add('known-cooler'),
          loadFloatingMonitor: () async => events.add('floating'),
          initializeFirebase: () async => events.add('firebase'),
          activateAppCheck: () async => events.add('app-check'),
          setPortraitOrientation: () async => events.add('portrait'),
          launchApp: (app) {
            events.add('launch');
            launchedApp = app;
          },
          logError: (phase, error) => events.add('error:$phase'),
        );

        await bootstrap.start(
          createOfficialApp: () {
            events.add('build-official');
            return officialApp;
          },
          createTamperApp: () {
            events.add('build-tamper');
            return tamperApp;
          },
        );

        expect(events, <String>[
          'verify',
          'portrait',
          'build-tamper',
          'launch',
        ]);
        expect(launchedApp, same(tamperApp));
        expect(launchedApp, isNot(same(officialApp)));
      },
    );

    test(
      'verified installation restores local state before cloud and launch',
      () async {
        final events = <String>[];
        Widget? launchedApp;
        final officialApp = SizedBox(key: const ValueKey<String>('official'));
        final tamperApp = SizedBox(key: const ValueKey<String>('tamper'));

        final bootstrap = AppBootstrap(
          verifyOfficialBuild: () async {
            events.add('verify');
            return true;
          },
          loadAppSettings: () async => events.add('settings'),
          loadKnownCooler: () async => events.add('known-cooler'),
          loadFloatingMonitor: () async => events.add('floating'),
          initializeFirebase: () async => events.add('firebase'),
          activateAppCheck: () async => events.add('app-check'),
          setPortraitOrientation: () async => events.add('portrait'),
          launchApp: (app) {
            events.add('launch');
            launchedApp = app;
          },
          logError: (phase, error) => events.add('error:$phase'),
        );

        await bootstrap.start(
          createOfficialApp: () {
            events.add('build-official');
            return officialApp;
          },
          createTamperApp: () {
            events.add('build-tamper');
            return tamperApp;
          },
        );

        expect(events, <String>[
          'verify',
          'settings',
          'known-cooler',
          'floating',
          'firebase',
          'app-check',
          'portrait',
          'build-official',
          'launch',
        ]);
        expect(launchedApp, same(officialApp));
        expect(launchedApp, isNot(same(tamperApp)));
      },
    );

    test(
      'Firebase initialization failure skips App Check but still launches',
      () async {
        final events = <String>[];
        Widget? launchedApp;
        final officialApp = SizedBox(key: const ValueKey<String>('official'));

        final bootstrap = AppBootstrap(
          verifyOfficialBuild: () async {
            events.add('verify');
            return true;
          },
          loadAppSettings: () async => events.add('settings'),
          loadKnownCooler: () async => events.add('known-cooler'),
          loadFloatingMonitor: () async => events.add('floating'),
          initializeFirebase: () async {
            events.add('firebase');
            throw StateError('firebase unavailable');
          },
          activateAppCheck: () async => events.add('app-check'),
          setPortraitOrientation: () async => events.add('portrait'),
          launchApp: (app) {
            events.add('launch');
            launchedApp = app;
          },
          logError: (phase, error) => events.add('error:$phase'),
        );

        await bootstrap.start(
          createOfficialApp: () {
            events.add('build-official');
            return officialApp;
          },
          createTamperApp: () => const SizedBox(),
        );

        expect(events, <String>[
          'verify',
          'settings',
          'known-cooler',
          'floating',
          'firebase',
          'error:Firebase init',
          'portrait',
          'build-official',
          'launch',
        ]);
        expect(launchedApp, same(officialApp));
      },
    );

    test(
      'App Check failure is reported without blocking the verified UI',
      () async {
        final events = <String>[];
        Widget? launchedApp;
        final officialApp = SizedBox(key: const ValueKey<String>('official'));

        final bootstrap = AppBootstrap(
          verifyOfficialBuild: () async {
            events.add('verify');
            return true;
          },
          loadAppSettings: () async => events.add('settings'),
          loadKnownCooler: () async => events.add('known-cooler'),
          loadFloatingMonitor: () async => events.add('floating'),
          initializeFirebase: () async => events.add('firebase'),
          activateAppCheck: () async {
            events.add('app-check');
            throw StateError('attestation provider unavailable');
          },
          setPortraitOrientation: () async => events.add('portrait'),
          launchApp: (app) {
            events.add('launch');
            launchedApp = app;
          },
          logError: (phase, error) => events.add('error:$phase'),
        );

        await bootstrap.start(
          createOfficialApp: () {
            events.add('build-official');
            return officialApp;
          },
          createTamperApp: () => const SizedBox(),
        );

        expect(events, <String>[
          'verify',
          'settings',
          'known-cooler',
          'floating',
          'firebase',
          'app-check',
          'error:Firebase App Check init',
          'portrait',
          'build-official',
          'launch',
        ]);
        expect(launchedApp, same(officialApp));
      },
    );

    test(
      'verification exceptions prevent preference restore and either launch',
      () async {
        final events = <String>[];
        final bootstrap = AppBootstrap(
          verifyOfficialBuild: () async {
            events.add('verify');
            throw StateError('verification unavailable');
          },
          loadAppSettings: () async => events.add('settings'),
          loadKnownCooler: () async => events.add('known-cooler'),
          loadFloatingMonitor: () async => events.add('floating'),
          initializeFirebase: () async => events.add('firebase'),
          activateAppCheck: () async => events.add('app-check'),
          setPortraitOrientation: () async => events.add('portrait'),
          launchApp: (_) => events.add('launch'),
          logError: (phase, error) => events.add('error:$phase'),
        );

        await expectLater(
          bootstrap.start(
            createOfficialApp: () => const SizedBox(),
            createTamperApp: () => const SizedBox(),
          ),
          throwsStateError,
        );
        expect(events, <String>['verify']);
      },
    );
  });
}
