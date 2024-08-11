import 'package:localstorage/localstorage.dart';

class LocalStorageWrapper {
  LocalStorageWrapper(this.localStorage);
  final LocalStorage localStorage;

  String? getItem(String key) {
    return localStorage.getItem(key);
  }

  void setItem(String key, String value) {
    localStorage.setItem(key, value);
  }

  Future<void> ready() async {
    await initLocalStorage();
  }
}
