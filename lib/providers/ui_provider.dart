import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt = 1;

  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  set selectMenuOpt(int index) {
    _selectedMenuOpt = index;
    notifyListeners();
  }
}
