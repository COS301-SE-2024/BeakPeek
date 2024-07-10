import 'package:beakpeek/Model/user_profile_function.dart';
import 'package:beakpeek/View/Home/home.dart';
import 'package:beakpeek/View/Login/landing_page.dart';
import 'package:beakpeek/View/Home/map_info.dart';
import 'package:beakpeek/View/UserProfile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:beakpeek/Controller/Azure/config.dart' as config;

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

  String route = '/';
  @override
  void initState() {
    darkLight = getThemeMode(localStorage.getItem('theme') ?? '');
    super.initState();
  }

  void changeRoute() {
    if (config.loggedIN) {
      setState(() {
        route = '/home';
      });
    }
  }

  void changeTheme() {
    setState(() {
      darkLight = changeThemeMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: darkLight,
      initialRoute: route,
      routes: <String, WidgetBuilder>{
        '/': (context) => LandingPage(routeChange: changeRoute),
        '/home': (context) => const Home(),
        '/map': (context) => const MapInfo(),
        '/profile': (context) => UserProfile(change: changeTheme),
      },
    );
  }
}
