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
        title: const Text('Settings'),
        backgroundColor: Colors.black,
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/settings.png',
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Configuració',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                color: Colors.red,
                thickness: 3,
              ),
              const SizedBox(
                height: 5,
              ),
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
