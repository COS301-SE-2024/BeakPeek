import 'package:beakpeek/Model/Globals/globals.dart';
import 'package:beakpeek/config_azure.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Controller/Main/routing_data.dart';
import 'package:beakpeek/Controller/Main/theme_provider.dart';

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
  final Globals globel = global;
  @override
  void initState() {
    super.initState();
    localStorage.getItem('termsAndCondition') == null
        ? accessToken = ''
        // ignore: avoid_print
        : print(accessToken);
    localStorage.setItem('termsAndCondition', 'false');
    globel.init();
    final themeProvider = ThemeProvider();
    themeProvider.setInitialTheme(localStorage.getItem('theme') ?? '');
  }

  @override
  Widget build(BuildContext context) {
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
            routerConfig: RoutingData().router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
