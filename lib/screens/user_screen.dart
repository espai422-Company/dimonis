import 'package:app_dimonis/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informació de l\'usuari'),
        backgroundColor: Colors.black,
      ),
      drawer: const SideMenu(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FadeInImage(
                placeholder: Image.asset('assets/user.png').image, 
                image: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Correu',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Divider(),
              Text(FirebaseAuth.instance.currentUser!.email!),
              const Divider(),
              const Text(
                'ID d\'usuari',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Divider(),
              Text(FirebaseAuth.instance.currentUser!.uid),
              const Divider(),
              const Text(
                'Nom d\'usuari',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Divider(),
              Text(FirebaseAuth.instance.currentUser!.displayName!),
              const Divider(),
              const Text(
                'Verificat',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const Divider(),
              Text(FirebaseAuth.instance.currentUser!.emailVerified
                  ? 'El compte està verificat.'
                  : 'El compte NO està verificat.'),
              const Divider()
            ],
          ),
        ),
      ),
    );
  }
}
