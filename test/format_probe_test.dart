import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('temporary formatter output capture', () async {
    final result = await Process.run(
      'dart',
      <String>[
        'format',
        '--output=show',
        'test/app_bootstrap_test.dart',
      ],
    );
    stdout.writeln('FORMAT_CAPTURE_BEGIN');
    stdout.write(result.stdout);
    stdout.writeln('FORMAT_CAPTURE_STDERR');
    stdout.write(result.stderr);
    stdout.writeln('FORMAT_CAPTURE_END');
    expect(result.exitCode, 0);
  });
}
