// TODO Implement this library.
import 'package:beakpeek/Model/UserProfile/user_model.dart';

String domain = 'com.example.beakpeek';
String clientID = '560ea41c-e579-4a11-90c9-e3c825b5a88c';
String issuer =
    'https://beakpeak.b2clogin.com/b57a5ea2-c1fd-411b-81dd-27b20a1b66f0/v2.0/';
String bundlerID = 'com.example.beakpeek';
String redirectURL = 'com.example.beakpeek://auth';
String discoveryURL =
    'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/v2.0/.well-known/openid-configuration';
String scope = 'https://beakpeak.onmicrosoft.com/com.example.beakpeek/callback';

String initialUrl = 'beakpeak.b2clogin.com';
String tokenUrl =
    '/beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/oauth2/v2.0/token';

String userApiUrl = 'https://beakpeekuserapi.azurewebsites.net';
String loginUrl = '$userApiUrl/Identity/Account/Login';
String accessToken = '';
bool loggedIN = false;
UserModel user = UserModel();
