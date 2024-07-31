import 'package:beakpeek/Controller/Main/theme_provider.dart';
import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Login/landing_page.dart';
import 'package:beakpeek/View/Home/map_info.dart';
import 'package:beakpeek/View/UserProfile/user_profile.dart';
import 'package:beakpeek/View/Home/bird_page.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

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
  ThemeMode darkLight = ThemeMode.system;

  void changeTheme() {
    setState(
      () {
        darkLight = changeThemeMode(localStorage);
      },
    );
  }

  @override
  void initState() {
    darkLight = getThemeMode(localStorage.getItem('theme') ?? '');
    super.initState();
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
          );
        },
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: darkLight,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const LandingPage(),
        '/home': (context) => const Home(),
        '/map': (context) => const MapInfo(),
        '/profile': (context) => UserProfile(change: changeTheme),
        '/bird': (context) => const BirdPage(),
      },
    );
  }
}
