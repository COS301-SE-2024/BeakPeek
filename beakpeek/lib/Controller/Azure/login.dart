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

  print(url);
}
