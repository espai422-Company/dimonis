import 'package:app_dimonis/models/gimcama.dart';
import 'package:flutter/material.dart';

class PlayinGimcamaProvider extends ChangeNotifier {
  Gimcama? _currentGimcama;

  set currentGimcama(Gimcama? gimcama) {
    _currentGimcama = gimcama;
    notifyListeners();
  }

  Gimcama? get currentGimcama => _currentGimcama;
}
