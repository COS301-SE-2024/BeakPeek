<<<<<<< HEAD
=======
import 'package:beakpeek/LandingText/signup_stack.dart';
>>>>>>> 05e77e4 (Resolved merge conflicts)
import 'package:beakpeek/LandingText/login_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

const client = '560ea41c-e579-4a11-90c9-e3c825b5a88c';
const rediret = 'https://beakpeak.b2clogin.com/oauth2/nativeclient';
const flow = 'B2C_1_SignUpAndSignInUserFlow';
const scope = ['openid'];
const tenant = 'BeakPeeak';
const discovery = 'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/';

void onRedirect(BuildContext context) {
  Navigator.pushNamed(context, '/home');
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  final String _clientId = client;
  final String _redirectUrl = rediret;
  final List<String> _scopes = <String>[
    'openid',
  ];

  final AuthorizationServiceConfiguration _serviceConfiguration =
      const AuthorizationServiceConfiguration(
    authorizationEndpoint:
        'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/oauth2/v2.0/authorize',
    tokenEndpoint:
        'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/B2C_1_SignUpAndSignInUserFlow/oauth2/v2.0/token',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LoginStack(),
            IconButton(
              icon: Image.asset('assets/icons/google.png'),
              onPressed: () => _signInWithAutoCodeExchange(),
              tooltip: 'Sign in with google',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration: _serviceConfiguration,
          scopes: _scopes,
          preferEphemeralSession: preferEphemeralSession,
        ),
      );
      if (result != null) {
        _setBusyState();
      }
    } catch (_) {}
  }

  void _setBusyState() {
    onRedirect(context);
  }
}
