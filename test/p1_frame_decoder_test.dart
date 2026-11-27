import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/p1_frame_decoder.dart';

void main() {
  group('P1FrameDecoder', () {
    test('emits complete newline lines and retains an unfinished suffix', () {
      final decoder = P1FrameDecoder();

      expect(
        decoder.addChunk('VOLTAGE:5V\nFAN:'),
        <P1FrameEvent>[const P1LineFrame('VOLTAGE:5V')],
      );
      expect(decoder.pendingCharacters, 'FAN:'.length);
      expect(
        decoder.addChunk('ON\n'),
        <P1FrameEvent>[const P1LineFrame('FAN:ON')],
      );
      expect(decoder.pendingCharacters, 0);
    });

    test(
      'holds leading lines until a split SYNC frame is complete',
      () {
        final decoder = P1FrameDecoder();

        expect(
          decoder.addChunk('VOLTAGE:5V\n<SYNC_START>PROTOCOL:P1'),
          isEmpty,
        );
        expect(decoder.pendingCharacters, greaterThan(0));

        expect(
          decoder.addChunk('\nBLE_SESSION:READY<SYNC_END>\nFAN:ON\n'),
          <P1FrameEvent>[
            const P1LineFrame('VOLTAGE:5V'),
            const P1SyncFrame('PROTOCOL:P1\nBLE_SESSION:READY'),
            const P1LineFrame('FAN:ON'),
          ],
        );
        expect(decoder.pendingCharacters, 0);
      },
    );

    test(
      'emits multiple atomic SYNC frames and surrounding lines in wire order',
      () {
        final decoder = P1FrameDecoder();

        expect(
          decoder.addChunk(
            'RESET:POWER_ON\n'
            '<SYNC_START>VOLTAGE:5V\nFAN:ON<SYNC_END>\n'
            '<SYNC_START>VOLTAGE:9V\nACK:SYNC_READY;REASON=READY<SYNC_END>\n'
            'HOT:30\n',
          ),
          <P1FrameEvent>[
            const P1LineFrame('RESET:POWER_ON'),
            const P1SyncFrame('VOLTAGE:5V\nFAN:ON'),
            const P1SyncFrame('VOLTAGE:9V\nACK:SYNC_READY;REASON=READY'),
            const P1LineFrame('HOT:30'),
          ],
        );
      },
    );

    test('does not leak newline records out of an incomplete SYNC frame', () {
      final decoder = P1FrameDecoder();

      expect(
        decoder.addChunk('VOLTAGE:5V\n<SYNC_START>FAN:ON\n'),
        isEmpty,
      );
      expect(decoder.pendingCharacters, greaterThan(0));
      expect(
        decoder.addChunk('PELTIER:OFF<SYNC_END>'),
        <P1FrameEvent>[
          const P1LineFrame('VOLTAGE:5V'),
          const P1SyncFrame('FAN:ON\nPELTIER:OFF'),
        ],
      );
    });

    test('discards oversized noise when no recoverable SYNC start exists', () {
      final decoder = P1FrameDecoder();
      final oversizedNoise = List<String>.filled(
        P1FrameDecoder.maxBufferLength + 1,
        'x',
      ).join();

      expect(decoder.addChunk(oversizedNoise), isEmpty);
      expect(decoder.pendingCharacters, 0);
      expect(decoder.addChunk('VOLTAGE:12V\n'), <P1FrameEvent>[
        const P1LineFrame('VOLTAGE:12V'),
      ]);
    });

    test(
      'retains the newest SYNC frame candidate after an oversized buffer',
      () {
        final decoder = P1FrameDecoder();
        final oversizedPrefix = List<String>.filled(
          P1FrameDecoder.maxBufferLength + 1,
          'x',
        ).join();

        expect(
          decoder.addChunk(
            '$oversizedPrefix<SYNC_START>PROTOCOL:P1<SYNC_END>',
          ),
          <P1FrameEvent>[const P1SyncFrame('PROTOCOL:P1')],
        );
        expect(decoder.pendingCharacters, 0);
      },
    );

    test('clear removes an incomplete frame before the next session', () {
      final decoder = P1FrameDecoder();

      expect(decoder.addChunk('<SYNC_START>OLD:1'), isEmpty);
      expect(decoder.pendingCharacters, greaterThan(0));
      decoder.clear();
      expect(decoder.pendingCharacters, 0);
      expect(decoder.addChunk('NEW:2\n'), <P1FrameEvent>[
        const P1LineFrame('NEW:2'),
      ]);
    });
  });
}
