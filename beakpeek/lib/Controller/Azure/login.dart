// ignore_for_file: use_build_context_synchronously

import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:go_router/go_router.dart';
import 'package:beakpeek/config_azure.dart' as config;
import 'package:localstorage/localstorage.dart';

void loginFunction(BuildContext context) async {
  if (localStorage.getItem('accessToken') != null) {
    loggedIN = true;
    context.go('/home');
    return;
  }

  final result = await FlutterWebAuth2.authenticate(
      url: config.loginUrl, callbackUrlScheme: 'beakpeek');

  final uri = Uri.parse(result);
  final token = uri.queryParameters['token'];

  if (token != null) {
    config.accessToken = token;
    config.loggedIN = true;
    localStorage.setItem('accessToken', token);
    user = await getOnlineUser();
    // print(
    //     '---------------------------------------------------- \n ${user.toJson()} \n ---------------------------------');
    storeUserLocally(user);
    context.go('/home');
    return;
  } else {
    context.go('/');
    return;
  }
}
