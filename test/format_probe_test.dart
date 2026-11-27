import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('temporary formatter probe for AppBootstrap regression test', () async {
    final result = await Process.run(
      'dart',
      <String>[
        'format',
        '--output=show',
        'test/app_bootstrap_test.dart',
      ],
    );
    stdout.writeln('APP_BOOTSTRAP_FORMAT_PROBE_BEGIN');
    stdout.write(result.stdout);
    stdout.writeln('APP_BOOTSTRAP_FORMAT_PROBE_STDERR');
    stdout.write(result.stderr);
    stdout.writeln('APP_BOOTSTRAP_FORMAT_PROBE_END');
    expect(result.exitCode, 0);
  });
}
