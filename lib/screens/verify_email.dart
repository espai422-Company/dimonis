import 'dart:async';

import 'package:app_dimonis/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late Timer _timer;
  final Duration _interval = const Duration(seconds: 3);

  @override
  void initState() {
    // TODO: implement initState
    // Change the interval duration as needed

    _timer = Timer.periodic(_interval, (Timer timer) async {
      var user = FirebaseAuth.instance.currentUser;

      await user?.reload();
      if (user!.emailVerified) {
        timer.cancel();
        Navigator.of(context).pushReplacementNamed('/');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inici'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Text('Verifica la teva adreça de correu'),
              ElevatedButton(
                  onPressed: () {
                    auth.signOut();
                  },
                  child: Text('Cancel·la'))
            ],
          ),
        ),
      ),
    );
  }
}
