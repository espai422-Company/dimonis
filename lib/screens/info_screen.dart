import 'package:app_dimonis/preferences/preferences.dart';
import 'package:flutter/material.dart';

class InfoAppScreen extends StatelessWidget {
  const InfoAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            color: Preferences.isDarkMode ? Colors.white : Colors.black,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          backgroundColor: const Color.fromARGB(0, 255, 255, 255)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 20,
              child: FlutterLogo(size: 200),
            ),
            Positioned(
              bottom: 230,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                height: 100,
                child: const Text(
                  textAlign: TextAlign.center,
                  'Make it work, make it right, moke it fast.',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              child: Text(
                'Make with ❤️ by DimonisGoTeam\nVersió 1.0.0\n© 2024 DimonisGo | All rights reserved',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
