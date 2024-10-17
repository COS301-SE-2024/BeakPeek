import 'package:beakpeek/Model/UserProfile/achievment_list.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';

String userApiUrl = 'https://beakpeekuserapi.azurewebsites.net';
/* Below is used for local testing 
   also use the commmand: 
      `adb reverse tcp:5174 tcp:5174`
   to allow the connected android device to connect to the
   computers localhost
*/
// String userApiUrl = 'http://localhost:5174';
String loginUrl =
    '$userApiUrl/Identity/Account/Login?ReturnUrl=%2FHome%2FMobile';
String accessToken = '';
bool loggedIN = false;
UserModel user = UserModel();
AchievementList achievementList = AchievementList();
