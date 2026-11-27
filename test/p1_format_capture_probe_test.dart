// TEMPORARY FORMAT CAPTURE — remove after this validation cycle.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'capture Dart formatter output for extracted P1 source-contract callers',
    () async {
      const paths = <String>[
        'test/firmware_qc_contract_test.dart',
        'test/widget_test.dart',
      ];

      for (final path in paths) {
        final result = await Process.run('dart', <String>[
          'format',
          '--output=show',
          path,
        ]);
        stdout.writeln('P1_MULTI_FORMAT_CAPTURE_BEGIN:$path');
        stdout.write(result.stdout);
        stdout.writeln('P1_MULTI_FORMAT_CAPTURE_STDERR:$path');
        stdout.write(result.stderr);
        stdout.writeln('P1_MULTI_FORMAT_CAPTURE_END:$path');
        expect(result.exitCode, 0, reason: path);
      }
    },
  );
}
