import 'package:app_dimonis/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
        backgroundColor: Colors.black,
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/user.png',
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Correo',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Divider(),
              Text(FirebaseAuth.instance.currentUser!.email!),
              const Divider(),
              const Text(
                'ID User',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Divider(),
              Text(FirebaseAuth.instance.currentUser!.uid),
              const Divider(),
              const Text(
                'Verificación',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Divider(),
              Text(FirebaseAuth.instance.currentUser!.emailVerified
                  ? 'El correo ha sido verificado.'
                  : 'El correo NO ha sido verifcado.'),
              const Divider()
            ],
          ),
        ),
      ),
    );
  }
}
