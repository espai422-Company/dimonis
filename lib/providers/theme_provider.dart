import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;

  ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    textTheme: GoogleFonts.poppinsTextTheme(),
    primarySwatch: Colors.red,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    ),
  );

  ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    primarySwatch: Colors.red,
    brightness: Brightness.dark,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    ),
  );

  ThemeProvider({required bool isDarkMode})
      : currentTheme = isDarkMode
            ? ThemeData(
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                useMaterial3: false,
                textTheme: GoogleFonts.poppinsTextTheme().apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
                primarySwatch: Colors.red,
                brightness: Brightness.dark)
            : ThemeData(
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
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
