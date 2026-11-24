// AI-MEMORY / TEST CONTRACT
// Static source-contract checks for the guarded App release workflow.
// These checks protect authorization, credential scope and release gates; they do not execute GitHub Actions or prove a published build.

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

  setUpAll(() {
    workflow = File(
      '.github/workflows/jexfyz-app-build-trigger.yml',
    ).readAsStringSync();
  });

  test(
    'only the manually guarded issue event can enter the release workflow',
    () {
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
      RegExp(r'(?m)^  (?:push|pull_request|workflow_dispatch):').hasMatch(
        workflow,
      ),
      isFalse,
    );
    expect(workflow, contains('group: jexfyz-cooler-build'));
    expect(workflow, contains('cancel-in-progress: false'));
    expect(workflow, contains('queue: max'));
    },
  );

  test(
    'every direct third-party action is pinned to its verified full commit SHA',
    () {
    final uses = RegExp(
      r'(?m)^\s+uses:\s*([^\s#]+)',
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
    expect(workflow, isNot(contains('actions/cache@')));
    },
  );

  test(
    'write permission is denied by default and granted only to the guarded release job',
    () {
    expect(workflow, contains('\npermissions: {}\n'));
    expect(workflow, contains('\n    permissions:\n      contents: write\n'));
    expect(
      RegExp(r'(?m)^\s*permissions:').allMatches(workflow),
      hasLength(2),
    );
    expect(
      RegExp(r'(?m)^\s*contents:\s*write\s*$').allMatches(workflow),
      hasLength(1),
    );
    },
  );

  test(
    'keystore and signing credentials are scoped to steps that consume them',
    () {
    final prepare = _namedStep(workflow, 'Prepare production release signing');
    expect(
      prepare,
      contains(r'ANDROID_KEYSTORE_BASE64: ${{ secrets.ANDROID_KEYSTORE_BASE64 }}'),
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
    for (final secret in [
      'ANDROID_KEYSTORE_PASSWORD',
      'ANDROID_KEY_ALIAS',
      'ANDROID_KEY_PASSWORD',
    ]) {
      expect(build, contains('secrets.$secret'));
      expect(enforce, contains('secrets.$secret'));
    }

    final verify = _namedStep(workflow, 'Verify APK signature');
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

  test(
    'GitHub write token remains limited to release publication and verification',
    () {
    final publish = _namedStep(
      workflow,
      'Publish APK and corresponding source to GitHub Release',
    );
    final verify = _namedStep(workflow, 'Verify downloaded GitHub Release asset');

    expect(publish, contains(r'GH_TOKEN: ${{ github.token }}'));
    expect(verify, contains(r'GH_TOKEN: ${{ github.token }}'));
    expect(
      RegExp(r'(?m)^\s*GH_TOKEN:').allMatches(workflow),
      hasLength(2),
    );
    },
  );

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
      'test "$TAG_TARGET_SHA" = "$GITHUB_SHA"',
      'test "$APK_COUNT" = "1"',
      'test "$ASSET_COUNT" = "2"',
    ]) {
      expect(
        workflow,
        contains(gate),
        reason: 'Required release gate missing: $gate',
      );
    }
  });
}
