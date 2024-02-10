import 'package:app_dimonis/widgets/widgets.dart';
import 'package:flutter/material.dart';

class UpgradeToPremium extends StatefulWidget {
  const UpgradeToPremium({super.key});

  @override
  State<UpgradeToPremium> createState() => _UpgradeToPremiumState();
}

class _UpgradeToPremiumState extends State<UpgradeToPremium> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Prime",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/pricing_plans.png",
              height: 250,
            ),
            const Text(
              'Vols ser PRIME?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Amb la subscripció PRIME podràs gaudir de totes les funcionalitats de l'aplicació i a més a més podras crear les teves pròpies gincanes per als teus amics o familiars.",
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
                  Navigator.of(context).pushNamed('/paypal');
                },
                child: const Text('Upgrade to premium'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
