import 'package:beakpeek/Model/UserProfile/user_model.dart';

String userApiUrl = 'https://beakpeekuserapi.azurewebsites.net';
String loginUrl = '$userApiUrl/Identity/Account/Login';
String accessToken = '';
bool loggedIN = false;
UserModel user = UserModel();
