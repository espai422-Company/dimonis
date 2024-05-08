import 'package:app_dimonis/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                child: Text(
                  textAlign: TextAlign.center,
                  AppLocalizations.of(context)!.lema,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                '${AppLocalizations.of(context)!.madeByDimonisGoTeam}\n${AppLocalizations.of(context)!.version}\n${AppLocalizations.of(context)!.rightsReserved}',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
