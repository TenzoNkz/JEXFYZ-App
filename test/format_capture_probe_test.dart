import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'capture formatter output for Temperature accessibility test',
    () async {
      final result = await Process.run(
        'dart',
        <String>[
          'format',
          '--output=show',
          'test/temperature_accessibility_test.dart',
        ],
      );
      stdout.writeln('TEMPERATURE_FORMAT_CAPTURE_BEGIN');
      stdout.write(result.stdout);
      stdout.writeln('TEMPERATURE_FORMAT_CAPTURE_STDERR');
      stdout.write(result.stderr);
      stdout.writeln('TEMPERATURE_FORMAT_CAPTURE_END');
      expect(result.exitCode, 0);
    },
  );
}
