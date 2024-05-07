import 'package:app_dimonis/preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Text(
              AppLocalizations.of(context)!.accountCreatedTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!.accountCreatedMessage,
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
                child: Text(AppLocalizations.of(context)!.continueButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
