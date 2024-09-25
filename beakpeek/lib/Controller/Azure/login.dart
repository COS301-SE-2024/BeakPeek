// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:go_router/go_router.dart';
import 'package:beakpeek/config_azure.dart' as config;
import 'package:localstorage/localstorage.dart';

void loginFunction(BuildContext context) async {
  final result = await FlutterWebAuth2.authenticate(
      url: config.loginUrl, callbackUrlScheme: 'beakpeek');

  final uri = Uri.parse(result);
  final token = uri.queryParameters['token'];

  if (token != null) {
    config.accessToken = token;
    config.loggedIN = true;
    // print('Testing: user logged in');
    context.go('/home');
  } else {
    context.go('/');
    // print('Testing: user not logged in');
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
  if (accessToken.isEmpty) {
    context.go('/');
  } else {
    config.accessToken = accessToken;
    localStorage.setItem('accessToken', accessToken);
    config.loggedIN = true;
    context.go('/home');
  }
}
