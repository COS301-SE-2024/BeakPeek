// ignore_for_file: unused_element

import 'package:flutter_appauth/flutter_appauth.dart';

const client = '560ea41c-e579-4a11-90c9-e3c825b5a88c';
const rediret =
    'https://beakpeak.b2clogin.com/oauth2/nativeclient'; //'com.example.beakpeek:/home';
const flow = 'B2C_1_SignUpAndSignInUserFlow';
const scope = ['openid'];
const tenant = 'BeakPeeak';
const discovery = 'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/';

const AuthorizationServiceConfiguration serviceConfiguration =
    AuthorizationServiceConfiguration(
  authorizationEndpoint:
      'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/oauth2/v2.0/authorize',
  tokenEndpoint:
      'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/oauth2/v2.0/token',
);
