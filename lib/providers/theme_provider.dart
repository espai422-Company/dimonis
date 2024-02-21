import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;

  ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    textTheme: GoogleFonts.poppinsTextTheme(),
    primarySwatch: Colors.red,
  );

  ThemeData darkTheme = ThemeData(
      useMaterial3: false,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      primarySwatch: Colors.red,
      brightness: Brightness.dark);

  ThemeProvider({required bool isDarkMode})
      : currentTheme = isDarkMode
            ? ThemeData(
                useMaterial3: false,
                textTheme: GoogleFonts.poppinsTextTheme().apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
                primarySwatch: Colors.red,
                brightness: Brightness.dark)
            : ThemeData(
                useMaterial3: false,
                textTheme: GoogleFonts.poppinsTextTheme(),
                primarySwatch: Colors.red,
              );

  setLightMode() {
    currentTheme = lightTheme;
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = darkTheme;
    notifyListeners();
  }
}
