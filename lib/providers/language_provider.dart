import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('ca');

  Locale get locale {
    return _locale;
  }

  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
