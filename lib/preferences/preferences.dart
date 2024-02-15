import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static bool _isDarkMode = false;
  static bool _guiaInicial = true;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isDarkMode {
    return _prefs.getBool('darkmode') ?? _isDarkMode;
  }

  static set isDarkMode(bool value) {
    _isDarkMode = value;
    _prefs.setBool('darkmode', value);
  }

  static bool get guiaInicial {
    return _prefs.getBool('guiaInicial') ?? _guiaInicial;
  }

  static set guiaInicial(bool value) {
    _guiaInicial = value;
    _prefs.setBool('guiaInicial', value);
  }
}
