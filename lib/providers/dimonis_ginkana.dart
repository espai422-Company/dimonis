import 'package:flutter/material.dart';

class TotalDimonisProvider extends ChangeNotifier {
  int totaldimonis = 0;

  setDimoni(int total) {
    totaldimonis = total;
  }
  notify(){
    notifyListeners();
  }
}
