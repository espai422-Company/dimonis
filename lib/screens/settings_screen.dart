import 'package:app_dimonis/preferences/preferences.dart';
import 'package:app_dimonis/providers/theme_provider.dart';
import 'package:app_dimonis/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    const Color color = Color.fromARGB(255, 190, 185, 185);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuració'),
        backgroundColor: Colors.black,
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Aparença',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
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
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: color),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: Preferences.isDarkMode,
                      title: const Text('Mode obscur'),
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
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Guia inicial',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
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
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: color),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: Preferences.guiaInicial,
                      title: const Text('Activar guia inicial'),
                      onChanged: (value) {
                        setState(() {
                          Preferences.guiaInicial = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
