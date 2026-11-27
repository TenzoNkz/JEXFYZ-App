import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('temporary formatter probe for AppBootstrap regression test', () async {
    final result = await Process.run(
      Platform.resolvedExecutable,
      <String>[
        'format',
        '--output=show',
        'test/app_bootstrap_test.dart',
      ],
    );
    print('APP_BOOTSTRAP_FORMAT_PROBE_BEGIN');
    print(result.stdout);
    print('APP_BOOTSTRAP_FORMAT_PROBE_STDERR');
    print(result.stderr);
    print('APP_BOOTSTRAP_FORMAT_PROBE_END');
    expect(result.exitCode, 0);
  });
}
