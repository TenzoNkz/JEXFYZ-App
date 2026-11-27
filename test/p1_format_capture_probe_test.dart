import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('capture exact formatted P1 command contract test output', () async {
    final result = await Process.run(
      'dart',
      <String>[
        'format',
        '--output=show',
        'test/p1_command_contract_test.dart',
      ],
    );
    stdout.writeln('P1_FORMAT_CAPTURE_BEGIN');
    stdout.write(result.stdout);
    stdout.writeln('P1_FORMAT_CAPTURE_STDERR');
    stdout.write(result.stderr);
    stdout.writeln('P1_FORMAT_CAPTURE_END');
    expect(result.exitCode, 0);
  });
}
