import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('capture exact formatter output for Temperature semantics change', () async {
    for (final path in <String>[
      'lib/main.dart',
      'test/widget_test.dart',
      'test/temperature_accessibility_test.dart',
    ]) {
      final result = await Process.run(
        'dart',
        <String>['format', '--output=show', path],
      );
      stdout.writeln('FORMAT_CAPTURE_BEGIN:$path');
      stdout.write(result.stdout);
      stdout.writeln('FORMAT_CAPTURE_STDERR:$path');
      stdout.write(result.stderr);
      stdout.writeln('FORMAT_CAPTURE_END:$path');
      expect(result.exitCode, 0);
    }
  });
}
