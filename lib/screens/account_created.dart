import 'package:app_dimonis/preferences/preferences.dart';
import 'package:flutter/material.dart';

class AccountCreated extends StatelessWidget {
  const AccountCreated({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/confirmed.png",
              height: 250,
            ),
            const Text(
              'La conta s\'ha creat correctament!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Enhorabona, el teu compte s'ha verificat correctament. Benvingut a DimonisGo on podras jugar i crear les teves pròpies gimcanes.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (Preferences.guiaInicial) {
                    Navigator.of(context).pushReplacementNamed('guia_inicial');
                  } else {
                    Navigator.of(context).pushReplacementNamed('/');
                  }
                },
                child: const Text('Continua'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
