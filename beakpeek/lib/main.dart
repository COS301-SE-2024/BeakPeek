import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/Model/UserProfile/user_model.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Controller/Main/routing_data.dart';
import 'package:beakpeek/Controller/Main/theme_provider.dart';
import 'package:beakpeek/config_azure.dart' as config;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => MainState();
}

class MainState extends State<Main> {
  late final ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    if (localStorage.getItem('accessToken') != null) {
      accessToken = localStorage.getItem('accessToken')!;
    }

    // WARN: this code is genuinely one of the worst pieces of code
    // I have ever seen its too abstract and you can't tell what it is
    // doing. Also accessToken already has a default value that is an
    // empty string why bother setting it like this and why check if
    // terms and conditions is null and access token isn't
    // access token cannot be set in local storage unless terms and
    // conditons has already been sett
    /* localStorage.getItem('termsAndCondition') == null &&
            localStorage.getItem('accessToken') != null
        ? accessToken = localStorage.getItem('accessToken')!
        : accessToken = ''; */
    global.init();
    themeProvider = ThemeProvider();
    themeProvider.setInitialTheme(localStorage.getItem('theme') ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = RoutingData().router;
    if (accessToken.isNotEmpty) {
      config.loggedIN = true;
      user = getLocalUser();
      RoutingData().router.go('/home');
    }

    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            theme: ThemeData(
                useMaterial3: true, colorScheme: themeProvider.lightScheme),
            darkTheme: ThemeData(
                useMaterial3: true, colorScheme: themeProvider.darkScheme),
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
