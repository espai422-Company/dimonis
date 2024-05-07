import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('ca');

  LanguageProvider({required String language}) {
    _locale = Locale(language);
  }

  Locale get locale {
    return _locale;
  }

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
