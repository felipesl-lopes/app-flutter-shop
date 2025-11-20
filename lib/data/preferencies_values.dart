import 'package:shared_preferences/shared_preferences.dart';

class PreferenciesValues {
  final _keyKeepLogged = "keepLogged";

  Future<void> setKeepLogged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyKeepLogged, value);
  }

  Future<bool> getKeepLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(_keyKeepLogged) ?? false;
  }
}
