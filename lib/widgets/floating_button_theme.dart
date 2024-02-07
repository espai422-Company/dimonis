import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FloatingButtonTheme extends StatelessWidget {
  const FloatingButtonTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FloatingActionButton(
      onPressed: () {
        if (Preferences.isDarkMode) {
          themeProvider.setLightMode();
          Preferences.isDarkMode = false;
        } else {
          themeProvider.setDarkMode();
          Preferences.isDarkMode = true;
        }
      },
      child: Preferences.isDarkMode
          ? const Icon(Icons.light_mode_outlined)
          : const Icon(Icons.dark_mode_outlined),
    );
  }
}
