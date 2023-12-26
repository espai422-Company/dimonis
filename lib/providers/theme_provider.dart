import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;

  ThemeData personalitzat = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    primarySwatch: Colors.blue,
  );

  ThemeProvider({required bool isDarkMode})
      : currentTheme = isDarkMode
            ? ThemeData.dark()
            : ThemeData(
                textTheme: GoogleFonts.poppinsTextTheme(),
                primarySwatch: Colors.blue,
              );

  setLightMode() {
    currentTheme = personalitzat;
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = ThemeData.dark();
    notifyListeners();
  }
}
