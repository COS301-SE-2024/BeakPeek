// ignore_for_file: use_build_context_synchronously

import 'package:beakpeek/Model/UserProfile/achievment_list.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';

void loginFunction(BuildContext context) async {
  if (localStorage.getItem('accessToken') != null) {
    loggedIN = true;
    context.go('/home');
    return;
  }

  final result = await FlutterWebAuth2.authenticate(
      url: loginUrl, callbackUrlScheme: 'beakpeek');

  final uri = Uri.parse(result);
  final token = uri.queryParameters['token'];

  if (token != null) {
    accessToken = token;
    loggedIN = true;
    localStorage.setItem('accessToken', token);
    user = await getOnlineUser();
    achievementList = await getOnlineAchivementList();

    //     '---------------------------------------------------- \n ${user.toJson()} \n ---------------------------------');
    storeUserLocally(user);
    storeAchievementListLocally(achievementList);
    context.go('/home');
    return;
  } else {
    context.go('/');
    return;
  }
}
