import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jexfyz_cooler/app_security.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(securityChannel, null);
  });

  test('non-Android platforms preserve the non-Android allowance', () async {
    var channelCalled = false;
    messenger.setMockMethodCallHandler(securityChannel, (call) async {
      channelCalled = true;
      return false;
    });

    expect(await isOfficialBuild(isAndroid: false), isTrue);
    expect(channelCalled, isFalse);
  });

  test('Android accepts only a true official-build result', () async {
    messenger.setMockMethodCallHandler(securityChannel, (call) async {
      expect(call.method, 'isOfficialBuild');
      return true;
    });

    expect(await isOfficialBuild(isAndroid: true), isTrue);
  });

  test(
    'Android fails closed when native verification is false or null',
    () async {
      for (final result in <bool?>[false, null]) {
        messenger.setMockMethodCallHandler(securityChannel, (call) async {
          expect(call.method, 'isOfficialBuild');
          return result;
        });

        expect(await isOfficialBuild(isAndroid: true), isFalse);
      }
    },
  );

  test('Android fails closed when the security channel throws', () async {
    messenger.setMockMethodCallHandler(securityChannel, (call) async {
      throw PlatformException(
        code: 'verification_unavailable',
        message: 'Native signing check unavailable',
      );
    });

    expect(await isOfficialBuild(isAndroid: true), isFalse);
  });
}
