import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

void main() {
  group(
    'Login Test',
    () {
      const channel = MethodChannel('flutter_web_auth_2');

      setUp(
        () {
          TestWidgetsFlutterBinding.ensureInitialized();

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
            channel,
            (methodCall) async {
              expect(methodCall.method, 'authenticate');

              expect(
                methodCall.arguments['url'] as String,
                'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/oauth2/v2.0/authorize',
              );
              expect(methodCall.arguments['callbackUrlScheme'] as String,
                  'com.example.beakpeek');

              return 'https://com.example.beakpeek://login-callback/?code=eyJraW';
            },
          );
        },
      );

      tearDown(
        () {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null);
        },
      );

      test(
        'authenticate',
        () async {
          expect(
            await FlutterWebAuth2.authenticate(
              url:
                  'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/oauth2/v2.0/authorize',
              callbackUrlScheme: 'com.example.beakpeek',
            ),
            'com.example.beakpeek://login-callback/?code=eyJraW',
          );
        },
      );

      test(
        'invalid scheme',
        () async {
          await expectLater(
            FlutterWebAuth2.authenticate(
              url:
                  'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/oauth2/v2.0/authorize',
              callbackUrlScheme: 'foobar://test',
            ),
            throwsA(isA<PlatformException>()),
          );
        },
      );
    },
  );
}
