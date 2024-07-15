import 'package:property_change_notifier/property_change_notifier.dart';

class LoginModel with PropertyChangeNotifier<String> {
  bool loggedIN = false;

  set loggedIn(bool value) {
    loggedIN = value;
    notifyListeners('logged');
  }

  bool get loginVal => loggedIN;
}
