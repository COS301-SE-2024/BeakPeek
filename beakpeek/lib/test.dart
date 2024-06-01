// ignore_for_file: lines_longer_than_80_chars

import 'package:aad_b2c_webview/aad_b2c_webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv
      .load(); // mergeWith optional, you can include Platform.environment for Mobile/Desktop app

  runApp(const MyApp());
}

void onRedirect(BuildContext context) {
  Navigator.of(context).pushNamedAndRemoveUntil('/myappname', (route) => false);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF2F56D2),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            fontFamily: 'UberMove',
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF8A8A8A),
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: 'UberMoveText',
          ),
          displayMedium: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: 'UberMove',
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the Create Account widget.
        '/': (context) => const LoginPage(),
        '/myappname': (context) => const Demo(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? jwtToken;
  String? refreshToken;

  @override
  Widget build(BuildContext context) {
    const aadB2CClientID = '560ea41c-e579-4a11-90c9-e3c825b5a88c';
    const aadB2CRedirectURL =
        'https://beakpeak.b2clogin.com/oauth2/nativeclient';
    const aadB2CUserFlowName = 'B2C_1_SignUpAndSignInUserFlow';
    const aadB2CScopes = ['openid'];
    const aadB2TenantName = 'BeakPeeak';
    const aadB2CUserAuthFlow =
        'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/';

    return Scaffold(
      appBar: AppBar(
          title: const Text('AAD B2C Login'),
          backgroundColor: const Color(0xFF2F56D2)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Login flow
            AADLoginButton(
              userFlowUrl: aadB2CUserAuthFlow,
              clientId: aadB2CClientID,
              userFlowName: aadB2CUserFlowName,
              redirectUrl: aadB2CRedirectURL,
              context: context,
              scopes: aadB2CScopes,
              onAnyTokenRetrieved: (anyToken) {},
              onIDToken: (token) {
                jwtToken = token.value;
              },
              onAccessToken: (token) {},
              onRefreshToken: (token) {
                refreshToken = token.value;
              },
              onRedirect: (context) => onRedirect(context),
            ),

            /// Refresh token

            TextButton(
              onPressed: () async {
                if (refreshToken != null) {
                  final AzureTokenResponse? response =
                      await ClientAuthentication.refreshTokens(
                    refreshToken: refreshToken!,
                    tenant: aadB2TenantName,
                    policy: aadB2CUserAuthFlow,
                    clientId: aadB2CClientID,
                  );
                  if (response != null) {
                    refreshToken = response.refreshToken;
                    jwtToken = response.idToken;
                  }
                }
              },
              child: const Text('Refresh my token'),
            ),
          ],
        ),
      ),
    );
  }
}

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Text('Here bastard '),
    );
  }
}
