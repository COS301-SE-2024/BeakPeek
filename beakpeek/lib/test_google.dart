import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the Create Account widget.
      '/': (context) => const MyApp(),
      '/demo': (context) => const Demo(),
    },
  ));
}

void onRedirect(BuildContext context) {
  Navigator.of(context).pushNamedAndRemoveUntil('/demo', (route) => false);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

const client = '560ea41c-e579-4a11-90c9-e3c825b5a88c';
const rediret = 'https://beakpeak.b2clogin.com/oauth2/nativeclient';
const flow = 'B2C_1_SignUpAndSignInUserFlow';
const scope = ['openid'];
const tenant = 'BeakPeeak';
const discovery = 'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/';

class _MyAppState extends State<MyApp> {
  bool _isBusy = false;
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  String? _codeVerifier;
  String? _nonce;
  String? _authorizationCode;
  String? _refreshToken;
  String? _accessToken;
  String? _idToken;

  final TextEditingController _authorizationCodeTextController =
      TextEditingController();
  final TextEditingController _accessTokenTextController =
      TextEditingController();
  final TextEditingController _accessTokenExpirationTextController =
      TextEditingController();

  final TextEditingController _idTokenTextController = TextEditingController();
  final TextEditingController _refreshTokenTextController =
      TextEditingController();
  String? _userInfo;

  // For a list of client IDs, go to https://demo.duendesoftware.com
  final String _clientId = client;
  final String _redirectUrl = rediret;
  //final String _issuer = 'https://demo.duendesoftware.com';
  final String _discoveryUrl =
      'https://beakpeak.b2clogin.com/beakpeak.onmicrosoft.com/';
  final String _postLogoutRedirectUrl =
      'https://beakpeak.b2clogin.com/oauth2/nativeclient';
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: _isBusy,
                  child: const LinearProgressIndicator(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('Sign in with no code exchange'),
                  onPressed: () => _signInWithNoCodeExchange(),
                ),
                ElevatedButton(
                  child: const Text(
                      'Sign in with no code exchange and generated nonce'),
                  onPressed: () => _signInWithNoCodeExchangeAndGeneratedNonce(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _authorizationCode != null ? _exchangeCode : null,
                  child: const Text('Exchange code'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('Sign in with auto code exchange'),
                  onPressed: () => _signInWithAutoCodeExchange(),
                ),
                if (Platform.isIOS || Platform.isMacOS)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: const Text(
                        'Sign in with auto code exchange using ephemeral '
                        'session',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => _signInWithAutoCodeExchange(
                          preferEphemeralSession: true),
                    ),
                  ),
                ElevatedButton(
                  onPressed: _refreshToken != null ? _refresh : null,
                  child: const Text('Refresh token'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _idToken != null
                      ? () async {
                          await _endSession();
                        }
                      : null,
                  child: const Text('End session'),
                ),
                const SizedBox(height: 8),
                const Text('authorization code'),
                TextField(
                  controller: _authorizationCodeTextController,
                ),
                const Text('access token'),
                TextField(
                  controller: _accessTokenTextController,
                ),
                const Text('access token expiration'),
                TextField(
                  controller: _accessTokenExpirationTextController,
                ),
                const Text('id token'),
                TextField(
                  controller: _idTokenTextController,
                ),
                const Text('refresh token'),
                TextField(
                  controller: _refreshTokenTextController,
                ),
                const Text('test api results'),
                Text(_userInfo ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _endSession() async {
    try {
      _setBusyState();
      await _appAuth.endSession(EndSessionRequest(
          idTokenHint: _idToken,
          postLogoutRedirectUrl: _postLogoutRedirectUrl,
          serviceConfiguration: _serviceConfiguration));
      _clearSessionInfo();
    } catch (_) {}
    _clearBusyState();
  }

  void _clearSessionInfo() {
    setState(() {
      _codeVerifier = null;
      _nonce = null;
      _authorizationCode = null;
      _authorizationCodeTextController.clear();
      _accessToken = null;
      _accessTokenTextController.clear();
      _idToken = null;
      _idTokenTextController.clear();
      _refreshToken = null;
      _refreshTokenTextController.clear();
      _accessTokenExpirationTextController.clear();
      _userInfo = null;
    });
  }

  Future<void> _refresh() async {
    try {
      _setBusyState();
      final TokenResponse? result = await _appAuth.token(TokenRequest(
          _clientId, _redirectUrl,
          refreshToken: _refreshToken, scopes: _scopes));
      _processTokenResponse(result);
      await _testApi(result);
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> _exchangeCode() async {
    try {
      _setBusyState();
      final TokenResponse? result = await _appAuth.token(TokenRequest(
          _clientId, _redirectUrl,
          authorizationCode: _authorizationCode,
          discoveryUrl: _discoveryUrl,
          codeVerifier: _codeVerifier,
          nonce: _nonce,
          scopes: _scopes));
      _processTokenResponse(result);
      await _testApi(result);
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> _signInWithNoCodeExchange() async {
    try {
      _setBusyState();
      /* 
        The discovery endpoint (_discoveryUrl) is used to find the
        configuration. The code challenge generation can be checked here 
        > https://github.com/MaikuB/flutter_appauth/search?q=challenge.
        The code challenge is generated from the code verifier and only the
        code verifier is included in the result. This because to get the token
        in the method _exchangeCode (see above) we need only the code verifier
        and the authorization code.
        Code challenge is not used according to the spec
        https://www.rfc-editor.org/rfc/rfc7636 page 9 section 4.5.
      */
      final AuthorizationResponse? result = await _appAuth.authorize(
        AuthorizationRequest(_clientId, _redirectUrl,
            discoveryUrl: _discoveryUrl, scopes: _scopes, loginHint: 'bob'),
      );

      /* 
        or just use the issuer
        var result = await _appAuth.authorize(
          AuthorizationRequest(
            _clientId,
            _redirectUrl,
            issuer: _issuer,
            scopes: _scopes,
          ),
        );
      */

      if (result != null) {
        _processAuthResponse(result);
        // ignore: use_build_context_synchronously
        onRedirect(context);
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> _signInWithNoCodeExchangeAndGeneratedNonce() async {
    try {
      _setBusyState();
      final Random random = Random.secure();
      final String nonce =
          base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
      // use the discovery endpoint to find the configuration
      final AuthorizationResponse? result = await _appAuth.authorize(
        AuthorizationRequest(_clientId, _redirectUrl,
            discoveryUrl: _discoveryUrl,
            scopes: _scopes,
            loginHint: 'bob',
            nonce: nonce),
      );

      if (result != null) {
        _processAuthResponse(result);
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> _signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {
      _setBusyState();

      /*
        This shows that we can also explicitly specify the endpoints rather than
        getting from the details from the discovery document.
      */
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

      /* 
        This code block demonstrates passing in values for the prompt
        parameter. In this case it prompts the user login even if they have
        already signed in. the list of supported values depends on the
        identity provider

        ```dart
        final AuthorizationTokenResponse result = await _appAuth
        .authorizeAndExchangeCode(
          AuthorizationTokenRequest(_clientId, _redirectUrl,
              serviceConfiguration: _serviceConfiguration,
              scopes: _scopes,
              promptValues: ['login']),
        );
        ```
      */

      if (result != null) {
        _processAuthTokenResponse(result);
        await _testApi(result);
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  void _clearBusyState() {
    setState(() {
      _isBusy = false;
    });
  }

  void _setBusyState() {
    setState(() {
      _isBusy = true;
    });
  }

  void _processAuthTokenResponse(AuthorizationTokenResponse response) {
    onRedirect(context);
  }

  void _processAuthResponse(AuthorizationResponse response) {
    setState(() {
      /*
        Save the code verifier and nonce as it must be used when exchanging the
        token.
      */
      _codeVerifier = response.codeVerifier;
      _nonce = response.nonce;
      _authorizationCode =
          _authorizationCodeTextController.text = response.authorizationCode!;
      _isBusy = false;
    });
  }

  void _processTokenResponse(TokenResponse? response) {
    setState(() {
      _accessToken = _accessTokenTextController.text = response!.accessToken!;
      _idToken = _idTokenTextController.text = response.idToken!;
      _refreshToken = _refreshTokenTextController.text = response.refreshToken!;
      _accessTokenExpirationTextController.text =
          response.accessTokenExpirationDateTime!.toIso8601String();
    });
  }

  Future<void> _testApi(TokenResponse? response) async {
    final http.Response httpResponse = await http.get(
        Uri.parse('https://demo.duendesoftware.com/api/test'),
        headers: <String, String>{'Authorization': 'Bearer $_accessToken'});
    setState(() {
      _userInfo = httpResponse.statusCode == 200 ? httpResponse.body : '';
      _isBusy = false;
    });
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