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
        Navigator.of(context).pushReplacementNamed('accountConfirmed');
        timer.cancel();
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
              },
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/verifyEmail.png",
              height: 250,
            ),
            const Text(
              'Verifica la teva adreça de correu',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(FirebaseAuth.instance.currentUser?.email ?? 'CORREU'),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Enhorabona, el teu compte espera: verifica el teu correu per començar a jugar i crear les teves gimcanes.",
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
                    auth.signOut();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Cancel·la'),
                    ],
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.send_outlined),
                onPressed: () {
                  auth.resendEmailVerification();
                },
                label: const Text("Resend Email"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
