import 'package:shared_preferences/shared_preferences.dart';

class PreferenciesValues {
  final _keyKeepLogged = "keepLogged";

  Future<void> setKeepLogged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_keyKeepLogged, value);
  }

  Future<bool> getKeepLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyKeepLogged) ?? false;
  }

  Future<void> deleteKeepLogged() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyKeepLogged);
  }
}
