// ignore_for_file: lines_longer_than_80_chars, avoid_print, avoid_redundant_argument_values
import 'dart:async';
import 'package:beakpeek/Model/login_config.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

Future<void> getResults(FlutterAppAuth appAuth) async {
  try {
    final AuthorizationTokenResponse? result =
        await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        client,
        rediret,
        serviceConfiguration: serviceConfiguration,
        scopes: scope,
        preferEphemeralSession: false,
      ),
    );
    print(result);
  } catch (_) {
    print('error');
  }
}
