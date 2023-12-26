import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/providers/theme_provider.dart';
import 'package:app_dimonis/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
        backgroundColor: Colors.black,
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configuració',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.w300),
              ),
              const Divider(),
              SwitchListTile(
                value: Preferences.isDarkMode,
                title: const Text('Dark Mode'),
                onChanged: (value) {
                  Preferences.isDarkMode = value;
                  value
                      ? themeProvider.setDarkMode()
                      : themeProvider.setLightMode();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
