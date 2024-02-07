import 'package:app_dimonis/screens/paypal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';

class UpgradeToPremium extends StatefulWidget {
  const UpgradeToPremium({super.key});

  @override
  State<UpgradeToPremium> createState() => _UpgradeToPremiumState();
}

class _UpgradeToPremiumState extends State<UpgradeToPremium> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PayPal Checkout",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            Navigator.of(context).pushNamed('/paypal');
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(1),
              ),
            ),
          ),
          child: const Text('Upgrade to premium'),
        ),
      ),
    );
  }
}
