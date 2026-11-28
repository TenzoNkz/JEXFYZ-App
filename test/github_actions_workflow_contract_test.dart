// AI-MEMORY / TEST CONTRACT
// Static source-contract checks for the guarded App release workflow.
// These checks protect authorization, credential scope and release gates;
// they do not execute GitHub Actions or prove a published build.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _namedStep(String workflow, String name) {
  final marker = '      - name: $name\n';
  final start = workflow.indexOf(marker);
  if (start < 0) {
    throw StateError('Missing workflow step: $name');
  }
  final next = workflow.indexOf('\n      - name: ', start + marker.length);
  return workflow.substring(start, next < 0 ? workflow.length : next);
}

void main() {
  late String workflow;
  late String validationOnlyWorkflow;

  setUpAll(() {
    workflow = File('.github/workflows/jexfyz-app-build-trigger.yml')
        .readAsStringSync();
    validationOnlyWorkflow = File('.github/workflows/jexfyz-app-validation.yml')
        .readAsStringSync();
  });

  test('only the manually guarded issue event can enter the release workflow', () {
    expect(
      workflow,
      contains('  issues:\n    types:\n      - opened\n      - reopened'),
    );
    expect(
      workflow,
      contains('github.event.issue.user.login == github.repository_owner'),
    );
    expect(
      workflow,
      contains(
        "github.event.issue.title == 'JE X FYZ — EKSEKUSI BUILD APP TRIGGER'",
      ),
    );
    expect(
      workflow,
      contains(
        "contains(github.event.issue.body, 'JEXFYZ_EKSEKUSI_BUILD_TRIGGER_V1')",
      ),
    );
    expect(
      RegExp(
        r'^  (?:push|pull_request|workflow_dispatch):',
        multiLine: true,
      ).hasMatch(workflow),
      isFalse,
    );
    expect(workflow, contains('group: jexfyz-cooler-build'));
    expect(workflow, contains('cancel-in-progress: false'));
    expect(workflow, contains('queue: max'));
  });

  test(
    'every direct third-party action is pinned to its verified full commit SHA',
    () {
      final uses = RegExp(
        r'^\s+uses:\s*([^\s#]+)',
        multiLine: true,
      ).allMatches(workflow).map((match) => match.group(1)!).toList();

      expect(uses, [
        'actions/checkout@d23441a48e516b6c34aea4fa41551a30e30af803',
        'actions/setup-java@d1374f8ac74474200d16ef8ecee22c7ae7a51880',
        'subosito/flutter-action@1a449444c387b1966244ae4d4f8c696479add0b2',
        'gradle/actions/setup-gradle@8da46b539cd8fe6ab27ca75128919a18d757604c',
      ]);
      for (final reference in uses) {
        expect(
          reference,
          matches(RegExp(r'^.+@[0-9a-f]{40}$')),
          reason: 'Action reference is not immutable: $reference',
        );
      }
    },
  );

  test(
    'checkout drops its token and nested Flutter cache action stays disabled',
    () {
      final checkout = _namedStep(workflow, 'Checkout repository');
      expect(checkout, contains('persist-credentials: false'));

      final flutter = _namedStep(workflow, 'Set up Flutter');
      expect(flutter, contains('cache: false'));
    },
  );

  test('main-only Validation Only disables the composite action cache', () {
    expect(
      _namedStep(validationOnlyWorkflow, 'Set up Flutter'),
      contains('cache: false'),
    );
  });

  test('Validation Only is direct-main, read-only and cannot mutate repository refs', () {
    expect(
      RegExp(
        r'^  push:\n    branches:\n      - main$',
        multiLine: true,
      ).hasMatch(validationOnlyWorkflow),
      isTrue,
    );
    expect(
      RegExp(
        r'^permissions:\n  contents: read$',
        multiLine: true,
      ).hasMatch(validationOnlyWorkflow),
      isTrue,
    );
    expect(validationOnlyWorkflow, contains('persist-credentials: false'));
    expect(
      validationOnlyWorkflow,
      contains('dart format --output=none --set-exit-if-changed lib test'),
    );
    expect(
      validationOnlyWorkflow,
      contains('flutter analyze --no-fatal-infos'),
    );
    expect(validationOnlyWorkflow, contains('flutter test'));
    expect(validationOnlyWorkflow, isNot(contains('pull_request:')));
    expect(validationOnlyWorkflow, isNot(contains('contents: write')));
    expect(validationOnlyWorkflow, isNot(contains('git push')));
    expect(validationOnlyWorkflow, isNot(contains('dart format lib test')));
    expect(
      File('.github/workflows/jexfyz-app-pr-validation.yml').existsSync(),
      isFalse,
    );
  });

  test('write permission is denied by default and granted only to the guarded release job', () {
    expect(workflow, contains('\npermissions: {}\n'));
    expect(workflow, contains('\n    permissions:\n      contents: write\n'));
    expect(
      RegExp(r'^\s*permissions:', multiLine: true).allMatches(workflow),
      hasLength(2),
    );
    expect(
      RegExp(r'^\s*contents:\s*write\s*', multiLine: true).allMatches(workflow),
      hasLength(1),
    );
  });

  test(
    'keystore and signing credentials are scoped to steps that consume them',
    () {
      final prepare = _namedStep(
        workflow,
        'Prepare production release signing',
      );
      expect(
        prepare,
        contains(
          r'ANDROID_KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}',
        ),
      );
      expect(
        RegExp(r'ANDROID_KEYSTORE_BASE64:').allMatches(prepare),
        hasLength(1),
      );
      for (final secret in [
        'ANDROID_KEYSTORE_PASSWORD',
        'ANDROID_KEY_ALIAS',
        'ANDROID_KEY_PASSWORD',
      ]) {
        expect(prepare, isNot(contains(secret)));
      }

      final build = _namedStep(workflow, 'Build latest release APK');
      final enforce = _namedStep(workflow, 'Enforce V1/V2/V3 APK signing');
      final verify = _namedStep(workflow, 'Verify APK signature');
      for (final secret in [
        'ANDROID_KEYSTORE_PASSWORD',
        'ANDROID_KEY_ALIAS',
        'ANDROID_KEY_PASSWORD',
      ]) {
        expect(build, contains('secrets.$secret'));
        expect(enforce, contains('secrets.$secret'));
        expect(
          RegExp(RegExp.escape('secrets.$secret')).allMatches(workflow),
          hasLength(2),
          reason: '$secret must be exposed only to the build and signing steps',
        );
      }
      expect(verify, isNot(contains('secrets.ANDROID_')));

      final environmentWrites = workflow
          .split('\n')
          .where((line) => line.contains('GITHUB_ENV'))
          .toList();
      expect(environmentWrites, hasLength(1));
      expect(environmentWrites.single, contains('ANDROID_KEYSTORE_FILE='));
      for (final secret in [
        'ANDROID_KEYSTORE_PASSWORD',
        'ANDROID_KEY_ALIAS',
        'ANDROID_KEY_PASSWORD',
        'ANDROID_KEYSTORE_BASE64',
      ]) {
        expect(environmentWrites.single, isNot(contains(secret)));
      }
    },
  );

  test('explicit GH_TOKEN env is only in Release steps; job token permission remains job-wide', () {
    final buildJobStart = workflow.indexOf('\n  build:\n');
    expect(buildJobStart, greaterThanOrEqualTo(0));

    // GH_TOKEN is explicit environment wiring, not a step-level permission boundary.
    // Actions can also read `github.token`; `contents: write` applies to this job.
    final jobPermissionStart = workflow.indexOf(
      '\n    permissions:\n      contents: write\n',
      buildJobStart,
    );
    final jobStepsStart = workflow.indexOf(
      '\n    steps:\n',
      jobPermissionStart,
    );
    expect(jobPermissionStart, greaterThan(buildJobStart));
    expect(jobStepsStart, greaterThan(jobPermissionStart));

    final publish = _namedStep(
      workflow,
      'Publish APK and corresponding source to GitHub Release',
    );
    final verify = _namedStep(
      workflow,
      'Verify downloaded GitHub Release asset',
    );

    expect(publish, contains(r'GH_TOKEN: ${{ github.token }}'));
    expect(verify, contains(r'GH_TOKEN: ${{ github.token }}'));
    expect(
      RegExp(r'^\s*GH_TOKEN:', multiLine: true).allMatches(workflow),
      hasLength(2),
    );
  });

  test(
    'release validation, signing and artifact integrity gates remain present',
    () {
      for (final gate in [
        'flutter analyze --no-fatal-infos',
        'flutter test',
        './gradlew --no-daemon :app:testDebugUnitTest',
        'flutter build apk --release --obfuscate --split-debug-info=build/symbols',
        'Verified using v1 scheme (JAR signing): true',
        'Verified using v2 scheme (APK Signature Scheme v2): true',
        'Verified using v3 scheme (APK Signature Scheme v3): true',
        r'test "$TAG_TARGET_SHA" = "$GITHUB_SHA"',
        r'test "$APK_COUNT" = "1"',
        r'test "$ASSET_COUNT" = "2"',
      ]) {
        expect(
          workflow,
          contains(gate),
          reason: 'Required release gate missing: $gate',
        );
      }
      expect(
        workflow,
        contains(
          'EXPECTED_SIGNING_CERT_SHA256: "dd6ca6bec4e8f4d594214730426048c06081c2e977dfd8f260606849c2c2e0e0"',
        ),
      );
    },
  );

  test('Floating Monitor audit follows the dedicated bridge module and native method contract', () {
    final audit = _namedStep(
      workflow,
      'JE X FYZ security and architecture audit',
    );

    expect(
      audit,
      contains(
        'floating_bridge = Path("lib/floating_monitor_bridge.dart").read_text(encoding="utf-8")',
      ),
    );
    expect(audit, contains("MethodChannel('je_x_fyz/floating')"));
    expect(audit, contains('missing_floating_methods'));
    expect(
      audit,
      isNot(
        contains("if \"MethodChannel('je_x_fyz/floating')\" not in floating:"),
      ),
    );

    for (final method in [
      'hasOverlayPermission',
      'openOverlaySettings',
      'startFloatingMonitor',
      'stopFloatingMonitor',
      'updateFloatingConfig',
      'updateFloatingData',
      'getFloatingRuntimeState',
    ]) {
      expect(audit, contains(method));
    }
  });

  test('debug-only Android Gradle tasks do not require production signing credentials', () {
    final androidBuild = File('android/app/build.gradle').readAsStringSync();

    expect(androidBuild, contains('gradle.taskGraph.whenReady'));
    expect(
      androidBuild,
      contains(
        "task.project.path == ':app' &&\n                task.name.toLowerCase().contains('release')",
      ),
    );
    expect(
      androidBuild,
      contains('if (releaseVariantRequested && !productionSigningReady)'),
    );
    expect(androidBuild, contains('if (productionSigningReady) {'));
    expect(androidBuild, contains('signingConfig signingConfigs.release'));
    expect(
      androidBuild,
      isNot(contains('if (!productionSigningReady)')),
      reason: 'Signing credentials must not block debug-only Gradle tasks.',
    );
    expect(androidBuild, contains('versionName "Telegram @horizontalzzz"'));
  });
}
Formatted 1 file (1 changed) in 0.01 seconds.
