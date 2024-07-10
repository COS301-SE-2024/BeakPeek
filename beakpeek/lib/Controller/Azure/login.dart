// ignore_for_file: unused_import

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:beakpeek/Controller/Azure/config.dart' as config;

bool loggedIN = false;

void loginFunction() async {
  final url = Uri.https(
    'beakpeak.b2clogin.com',
    'beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/oauth2/v2.0/authorize',
    {
      'response_type': 'code',
      'client_id': config.clientID,
      'redirect_uri': config.redirectURL,
      'scope': config.scope,
    },
  );

  final result = await FlutterWebAuth2.authenticate(
      url: url.toString(), callbackUrlScheme: 'com.example.beakpeek');

  final code = Uri.parse(result).queryParameters['code'];

  final tokenUrl = Uri.https(config.initialUrl, config.tokenUrl);

  final response = await http.post(
    tokenUrl,
    body: {
      'client_id': config.clientID,
      'scope': 'openid',
      'redirect_uri': config.redirectURL,
      'grant_type': 'authorization_code',
      'code': code,
    },
  );

  final accessToken = jsonDecode(response.body)['id_token'] as String;
  print(accessToken);
}
